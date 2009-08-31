Return-Path: <linux-kernel-owner+w=401wt.eu-S1752300AbZHaEpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300AbZHaEpY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 00:45:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751921AbZHaEpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 00:45:24 -0400
Received: from mail-ew0-f228.google.com ([209.85.219.228]:64608 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbZHaEpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 00:45:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=T1lccJCXOLM/bG2GByKQmlxii/69W0S4gRRBomLEFZQSk0O0+OvsT6JIToutDQw7bX
         pvYamoCgwHchHpMSu/EPTYifVCi/cNKbjfMaXc4ui5ZhhlB8kpK1UnyzE1rnjpAn4wy2
         PkHuR0e9uNPFjLEKDYJDheCk8N5/Cv48jt7pI=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/4] perf tools: Librarize idle thread registration
Date: Mon, 31 Aug 2009 06:45:18 +0200
Message-Id: <1251693921-6579-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1251682323-10395-1-git-send-email-fweisbec@gmail.com>
References: <1251682323-10395-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Librarize register_idle_thread() used by annotate and report.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c |   13 +------------
 tools/perf/builtin-report.c   |   32 +++++++++++++++-----------------
 tools/perf/util/thread.c      |   13 +++++++++++++
 tools/perf/util/thread.h      |    2 ++
 4 files changed, 31 insertions(+), 29 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 4c7bc44..043d85b 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -472,17 +472,6 @@ static void output__resort(void)
 	}
 }
 
-static void register_idle_thread(void)
-{
-	struct thread *thread = threads__findnew(0, &threads, &last_match);
-
-	if (thread == NULL ||
-			thread__set_comm(thread, "[idle]")) {
-		fprintf(stderr, "problem inserting idle task.\n");
-		exit(-1);
-	}
-}
-
 static unsigned long total = 0,
 		     total_mmap = 0,
 		     total_comm = 0,
@@ -970,7 +959,7 @@ static int __cmd_annotate(void)
 	uint32_t size;
 	char *buf;
 
-	register_idle_thread();
+	register_idle_thread(&threads, &last_match);
 
 	input = open(input_name, O_RDONLY);
 	if (input < 0) {
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index cdd46ab..cdf9a8d 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -666,12 +666,9 @@ static void dso__calc_col_width(struct dso *self)
 	self->slen_calculated = 1;
 }
 
-static int thread__set_comm_adjust(struct thread *self, const char *comm)
+static void thread__comm_adjust(struct thread *self)
 {
-	int ret = thread__set_comm(self, comm);
-
-	if (ret)
-		return ret;
+	char *comm = self->comm;
 
 	if (!col_width_list_str && !field_sep &&
 	    (!comm_list || strlist__has_entry(comm_list, comm))) {
@@ -682,6 +679,16 @@ static int thread__set_comm_adjust(struct thread *self, const char *comm)
 			threads__col_width = slen + 6;
 		}
 	}
+}
+
+static int thread__set_comm_adjust(struct thread *self, const char *comm)
+{
+	int ret = thread__set_comm(self, comm);
+
+	if (ret)
+		return ret;
+
+	thread__comm_adjust(self);
 
 	return 0;
 }
@@ -1073,17 +1080,6 @@ print_entries:
 	return ret;
 }
 
-static void register_idle_thread(void)
-{
-	struct thread *thread = threads__findnew(0, &threads, &last_match);
-
-	if (thread == NULL ||
-			thread__set_comm_adjust(thread, "[idle]")) {
-		fprintf(stderr, "problem inserting idle task.\n");
-		exit(-1);
-	}
-}
-
 static unsigned long total = 0,
 		     total_mmap = 0,
 		     total_comm = 0,
@@ -1381,11 +1377,13 @@ static int __cmd_report(void)
 	unsigned long offset = 0;
 	unsigned long head, shift;
 	struct stat input_stat;
+	struct thread *idle;
 	event_t *event;
 	uint32_t size;
 	char *buf;
 
-	register_idle_thread();
+	idle = register_idle_thread(&threads, &last_match);
+	thread__comm_adjust(idle);
 
 	if (show_threads)
 		perf_read_values_init(&show_threads_values);
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index f98032c..3acd37f 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -80,6 +80,19 @@ threads__findnew(pid_t pid, struct rb_root *threads, struct thread **last_match)
 	return th;
 }
 
+struct thread *
+register_idle_thread(struct rb_root *threads, struct thread **last_match)
+{
+	struct thread *thread = threads__findnew(0, threads, last_match);
+
+	if (!thread || thread__set_comm(thread, "[idle]")) {
+		fprintf(stderr, "problem inserting idle task.\n");
+		exit(-1);
+	}
+
+	return thread;
+}
+
 void thread__insert_map(struct thread *self, struct map *map)
 {
 	struct map *pos, *tmp;
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index b1c6671..634f280 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -13,6 +13,8 @@ struct thread {
 int thread__set_comm(struct thread *self, const char *comm);
 struct thread *
 threads__findnew(pid_t pid, struct rb_root *threads, struct thread **last_match);
+struct thread *
+register_idle_thread(struct rb_root *threads, struct thread **last_match);
 void thread__insert_map(struct thread *self, struct map *map);
 int thread__fork(struct thread *self, struct thread *parent);
 struct map *thread__find_map(struct thread *self, u64 ip);
-- 
1.6.2.3

