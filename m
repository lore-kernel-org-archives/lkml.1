Return-Path: <linux-kernel-owner+w=401wt.eu-S1752645AbZLMVuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645AbZLMVuw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 16:50:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754412AbZLMVuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 16:50:51 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:47502 "HELO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751993AbZLMVur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 16:50:47 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 3/6] perf session: Register the idle thread in perf_session__process_events
Date: Sun, 13 Dec 2009 19:50:26 -0200
Message-Id: <1260741029-4430-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1260741029-4430-1-git-send-email-acme@infradead.org>
References: <1260741029-4430-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

No need for all tools to register it and then immediately call
perf_session__process_events.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c |    3 ---
 tools/perf/builtin-kmem.c     |    1 -
 tools/perf/builtin-report.c   |    4 ----
 tools/perf/builtin-sched.c    |    2 --
 tools/perf/builtin-trace.c    |    1 -
 tools/perf/util/data_map.c    |   16 ++++++++++++++++
 tools/perf/util/thread.c      |   12 ------------
 tools/perf/util/thread.h      |    1 -
 8 files changed, 16 insertions(+), 24 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 43e3bb3..93d765a 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -464,14 +464,11 @@ static int __cmd_annotate(void)
 {
 	struct perf_session *session = perf_session__new(input_name, O_RDONLY,
 							 force);
-	struct thread *idle;
 	int ret;
 
 	if (session == NULL)
 		return -ENOMEM;
 
-	idle = register_idle_thread();
-
 	ret = perf_session__process_events(session, &event_ops, 0,
 					   &event__cwdlen, &event__cwd);
 	if (ret)
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 6f74bd8..37a8499 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -372,7 +372,6 @@ static int read_events(void)
 	if (session == NULL)
 		return -ENOMEM;
 
-	register_idle_thread();
 	err = perf_session__process_events(session, &event_ops, 0,
 					   &event__cwdlen, &event__cwd);
 	perf_session__delete(session);
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index c203eaf..4b37ac4 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -761,7 +761,6 @@ static struct perf_event_ops event_ops = {
 
 static int __cmd_report(void)
 {
-	struct thread *idle;
 	int ret;
 	struct perf_session *session;
 
@@ -769,9 +768,6 @@ static int __cmd_report(void)
 	if (session == NULL)
 		return -ENOMEM;
 
-	idle = register_idle_thread();
-	thread__comm_adjust(idle);
-
 	if (show_threads)
 		perf_read_values_init(&show_threads_values);
 
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index b5b4472..847ed51 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1670,8 +1670,6 @@ static int read_events(void)
 	if (session == NULL)
 		return -ENOMEM;
 
-	register_idle_thread();
-
 	err = perf_session__process_events(session, &event_ops, 0,
 					   &event__cwdlen, &event__cwd);
 	perf_session__delete(session);
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index c404dec..40cb896 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -125,7 +125,6 @@ static struct perf_event_ops event_ops = {
 
 static int __cmd_trace(struct perf_session *session)
 {
-	register_idle_thread();
 	return perf_session__process_events(session, &event_ops, 0,
 					    &event__cwdlen, &event__cwd);
 }
diff --git a/tools/perf/util/data_map.c b/tools/perf/util/data_map.c
index ba5bcfa..36e3bfe 100644
--- a/tools/perf/util/data_map.c
+++ b/tools/perf/util/data_map.c
@@ -1,6 +1,7 @@
 #include "symbol.h"
 #include "util.h"
 #include "debug.h"
+#include "thread.h"
 #include "session.h"
 
 static unsigned long	mmap_window = 32;
@@ -127,6 +128,18 @@ out:
 	return err;
 }
 
+static struct thread *perf_session__register_idle_thread(struct perf_session *self __used)
+{
+	struct thread *thread = threads__findnew(0);
+
+	if (!thread || thread__set_comm(thread, "swapper")) {
+		pr_err("problem inserting idle task.\n");
+		thread = NULL;
+	}
+
+	return thread;
+}
+
 int perf_session__process_events(struct perf_session *self,
 				 struct perf_event_ops *ops,
 				 int full_paths, int *cwdlen, char **cwd)
@@ -140,6 +153,9 @@ int perf_session__process_events(struct perf_session *self,
 	uint32_t size;
 	char *buf;
 
+	if (perf_session__register_idle_thread(self) == NULL)
+		return -ENOMEM;
+
 	perf_event_ops__fill_defaults(ops);
 
 	page_size = getpagesize();
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index b68a00e..5c0ab14 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -161,18 +161,6 @@ struct thread *threads__findnew(pid_t pid)
 	return th;
 }
 
-struct thread *register_idle_thread(void)
-{
-	struct thread *thread = threads__findnew(0);
-
-	if (!thread || thread__set_comm(thread, "swapper")) {
-		fprintf(stderr, "problem inserting idle task.\n");
-		exit(-1);
-	}
-
-	return thread;
-}
-
 static void map_groups__remove_overlappings(struct map_groups *self,
 					    struct map *map)
 {
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index 1751802..2e35e1f 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -24,7 +24,6 @@ void map_groups__init(struct map_groups *self);
 int thread__set_comm(struct thread *self, const char *comm);
 int thread__comm_len(struct thread *self);
 struct thread *threads__findnew(pid_t pid);
-struct thread *register_idle_thread(void);
 void thread__insert_map(struct thread *self, struct map *map);
 int thread__fork(struct thread *self, struct thread *parent);
 size_t map_groups__fprintf_maps(struct map_groups *self, FILE *fp);
-- 
1.6.2.5

