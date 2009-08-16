Return-Path: <linux-kernel-owner+w=401wt.eu-S1755683AbZHPS4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683AbZHPS4l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 14:56:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754753AbZHPS4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 14:56:40 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:43425 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208AbZHPS4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 14:56:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=dKLMke73CfcxJB+uep6kL43T3PJoxPZr4DffizPTTuy5g/u2Y3GG7k/JKXWP5T07qk
         pS25G8+aOIomCej6+PNGmOI/Le9eTjYTeCUrNG45w02onmwWMSZ7ewglN6HyLiwkKHDZ
         FLKUqru4TnT6ersnlQ45gHShADlIw5tkggfas=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>
Subject: [PATCH] perf tools: Librarize sample type and attr finding from headers
Date: Sun, 16 Aug 2009 20:56:37 +0200
Message-Id: <1250448997-30715-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1250443461-28130-1-git-send-email-fweisbec@gmail.com>
References: <1250443461-28130-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Librarize the sample type and attr fetching from perf data file
headers so that we can also use it from perf trace.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
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
 
-- 
1.6.2.3

