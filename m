Return-Path: <linux-kernel-owner+w=401wt.eu-S1752000AbZL2Ass@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000AbZL2Ass (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 19:48:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751694AbZL2Asq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 19:48:46 -0500
Received: from casper.infradead.org ([85.118.1.10]:35588 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbZL2Asq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 19:48:46 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 2/5] perf header: perf_header__push_event shouldn't die
Date: Mon, 28 Dec 2009 22:48:33 -0200
Message-Id: <1262047716-23171-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1262047716-23171-1-git-send-email-acme@infradead.org>
References: <1262047716-23171-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Just propagate eventual errors.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c       |   16 ++++++++++------
 tools/perf/util/header.h       |    2 +-
 tools/perf/util/parse-events.c |   18 +++++++++++-------
 3 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 6b3cb94..709e325 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -105,24 +105,28 @@ struct perf_trace_event_type {
 static int event_count;
 static struct perf_trace_event_type *events;
 
-void perf_header__push_event(u64 id, const char *name)
+int perf_header__push_event(u64 id, const char *name)
 {
 	if (strlen(name) > MAX_EVENT_NAME)
 		pr_warning("Event %s will be truncated\n", name);
 
 	if (!events) {
 		events = malloc(sizeof(struct perf_trace_event_type));
-		if (!events)
-			die("nomem");
+		if (events == NULL)
+			return -ENOMEM;
 	} else {
-		events = realloc(events, (event_count + 1) * sizeof(struct perf_trace_event_type));
-		if (!events)
-			die("nomem");
+		struct perf_trace_event_type *nevents;
+
+		nevents = realloc(events, (event_count + 1) * sizeof(*events));
+		if (nevents == NULL)
+			return -ENOMEM;
+		events = nevents;
 	}
 	memset(&events[event_count], 0, sizeof(struct perf_trace_event_type));
 	events[event_count].event_id = id;
 	strncpy(events[event_count].name, name, MAX_EVENT_NAME - 1);
 	event_count++;
+	return 0;
 }
 
 char *perf_header__find_event(u64 id)
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index d118d05..2b69aab 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -64,7 +64,7 @@ int perf_header__write(struct perf_header *self, int fd, bool at_exit);
 int perf_header__add_attr(struct perf_header *self,
 			  struct perf_header_attr *attr);
 
-void perf_header__push_event(u64 id, const char *name);
+int perf_header__push_event(u64 id, const char *name);
 char *perf_header__find_event(u64 id);
 
 struct perf_header_attr *perf_header_attr__new(struct perf_event_attr *attr);
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index e5bc0fb..625ef5a 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -753,11 +753,11 @@ modifier:
 	return ret;
 }
 
-static void store_event_type(const char *orgname)
+static int store_event_type(const char *orgname)
 {
 	char filename[PATH_MAX], *c;
 	FILE *file;
-	int id;
+	int id, n;
 
 	sprintf(filename, "%s/", debugfs_path);
 	strncat(filename, orgname, strlen(orgname));
@@ -769,11 +769,14 @@ static void store_event_type(const char *orgname)
 
 	file = fopen(filename, "r");
 	if (!file)
-		return;
-	if (fscanf(file, "%i", &id) < 1)
-		die("cannot store event ID");
+		return 0;
+	n = fscanf(file, "%i", &id);
 	fclose(file);
-	perf_header__push_event(id, orgname);
+	if (n < 1) {
+		pr_err("cannot store event ID\n");
+		return -EINVAL;
+	}
+	return perf_header__push_event(id, orgname);
 }
 
 int parse_events(const struct option *opt __used, const char *str, int unset __used)
@@ -782,7 +785,8 @@ int parse_events(const struct option *opt __used, const char *str, int unset __u
 	enum event_result ret;
 
 	if (strchr(str, ':'))
-		store_event_type(str);
+		if (store_event_type(str) < 0)
+			return -1;
 
 	for (;;) {
 		if (nr_counters == MAX_COUNTERS)
-- 
1.5.5.1

