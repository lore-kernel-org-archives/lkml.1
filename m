Return-Path: <linux-kernel-owner+w=401wt.eu-S1756151AbZHPVKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151AbZHPVKn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 17:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756080AbZHPVKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 17:10:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:60507 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755743AbZHPVKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 17:10:41 -0400
Date: Sun, 16 Aug 2009 21:10:02 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, peterz@infradead.org,
       efault@gmx.de, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1250448997-30715-1-git-send-email-fweisbec@gmail.com>
References: <1250448997-30715-1-git-send-email-fweisbec@gmail.com>
Subject: [tip:perfcounters/core] perf tools: Librarize sample type and attr finding from headers
Message-ID: <tip-0d3a5c885971de1e3124d85bfadf818abac9ba12@git.kernel.org>
Git-Commit-ID: 0d3a5c885971de1e3124d85bfadf818abac9ba12
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 16 Aug 2009 21:10:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0d3a5c885971de1e3124d85bfadf818abac9ba12
Gitweb:     http://git.kernel.org/tip/0d3a5c885971de1e3124d85bfadf818abac9ba12
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Sun, 16 Aug 2009 20:56:37 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 16 Aug 2009 23:06:44 +0200

perf tools: Librarize sample type and attr finding from headers

Librarize the sample type and attr fetching from perf data file
headers so that we can also use it from perf trace.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <1250448997-30715-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-report.c |   44 +++++-------------------------------------
 tools/perf/util/header.c    |   35 ++++++++++++++++++++++++++++++++++
 tools/perf/util/header.h    |    4 +++
 3 files changed, 45 insertions(+), 38 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 05d52ff..c6326de 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -70,6 +70,8 @@ static int		cwdlen;
 static struct rb_root	threads;
 static struct thread	*last_match;
 
+static struct perf_header *header;
+
 static
 struct callchain_param	callchain_param = {
 	.mode	= CHAIN_GRAPH_REL,
@@ -1319,29 +1321,12 @@ static void trace_event(event_t *event)
 	dump_printf(".\n");
 }
 
-static struct perf_header	*header;
-
-static struct perf_counter_attr *perf_header__find_attr(u64 id)
-{
-	int i;
-
-	for (i = 0; i < header->attrs; i++) {
-		struct perf_header_attr *attr = header->attr[i];
-		int j;
-
-		for (j = 0; j < attr->ids; j++) {
-			if (attr->id[j] == id)
-				return &attr->attr;
-		}
-	}
-
-	return NULL;
-}
-
 static int
 process_read_event(event_t *event, unsigned long offset, unsigned long head)
 {
-	struct perf_counter_attr *attr = perf_header__find_attr(event->read.id);
+	struct perf_counter_attr *attr;
+
+	attr = perf_header__find_attr(event->read.id, header);
 
 	if (show_threads) {
 		const char *name = attr ? __event_name(attr->type, attr->config)
@@ -1405,23 +1390,6 @@ process_event(event_t *event, unsigned long offset, unsigned long head)
 	return 0;
 }
 
-static u64 perf_header__sample_type(void)
-{
-	u64 type = 0;
-	int i;
-
-	for (i = 0; i < header->attrs; i++) {
-		struct perf_header_attr *attr = header->attr[i];
-
-		if (!type)
-			type = attr->attr.sample_type;
-		else if (type != attr->attr.sample_type)
-			die("non matching sample_type");
-	}
-
-	return type;
-}
-
 static int __cmd_report(void)
 {
 	int ret, rc = EXIT_FAILURE;
@@ -1460,7 +1428,7 @@ static int __cmd_report(void)
 	header = perf_header__read(input);
 	head = header->data_offset;
 
-	sample_type = perf_header__sample_type();
+	sample_type = perf_header__sample_type(header);
 
 	if (!(sample_type & PERF_SAMPLE_CALLCHAIN)) {
 		if (sort__has_parent) {
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index b92a457..a37a222 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -243,3 +243,38 @@ struct perf_header *perf_header__read(int fd)
 
 	return self;
 }
+
+u64 perf_header__sample_type(struct perf_header *header)
+{
+	u64 type = 0;
+	int i;
+
+	for (i = 0; i < header->attrs; i++) {
+		struct perf_header_attr *attr = header->attr[i];
+
+		if (!type)
+			type = attr->attr.sample_type;
+		else if (type != attr->attr.sample_type)
+			die("non matching sample_type");
+	}
+
+	return type;
+}
+
+struct perf_counter_attr *
+perf_header__find_attr(u64 id, struct perf_header *header)
+{
+	int i;
+
+	for (i = 0; i < header->attrs; i++) {
+		struct perf_header_attr *attr = header->attr[i];
+		int j;
+
+		for (j = 0; j < attr->ids; j++) {
+			if (attr->id[j] == id)
+				return &attr->attr;
+		}
+	}
+
+	return NULL;
+}
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index bf28044..5d0a72e 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -31,6 +31,10 @@ struct perf_header_attr *
 perf_header_attr__new(struct perf_counter_attr *attr);
 void perf_header_attr__add_id(struct perf_header_attr *self, u64 id);
 
+u64 perf_header__sample_type(struct perf_header *header);
+struct perf_counter_attr *
+perf_header__find_attr(u64 id, struct perf_header *header);
+
 
 struct perf_header *perf_header__new(void);
 
