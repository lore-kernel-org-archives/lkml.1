Return-Path: <linux-kernel-owner+w=401wt.eu-S1754439AbZLMVuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439AbZLMVuu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 16:50:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754414AbZLMVuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 16:50:46 -0500
Received: from casper.infradead.org ([85.118.1.10]:45632 "HELO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754402AbZLMVuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 16:50:44 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 2/6] perf session: Ditch register_perf_file_handler
Date: Sun, 13 Dec 2009 19:50:25 -0200
Message-Id: <1260741029-4430-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1260741029-4430-1-git-send-email-acme@infradead.org>
References: <1260741029-4430-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Pass the event_ops to perf_session__process_events instead.

Also move the event_ops definition to session.h, starting to move things
around to their right place, trimming the many unneeded headers we have.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile               |    1 -
 tools/perf/builtin-annotate.c     |   10 ++++----
 tools/perf/builtin-buildid-list.c |    1 -
 tools/perf/builtin-kmem.c         |    8 ++----
 tools/perf/builtin-report.c       |    7 +----
 tools/perf/builtin-sched.c        |    7 ++---
 tools/perf/builtin-timechart.c    |    9 +++----
 tools/perf/builtin-trace.c        |    8 ++----
 tools/perf/util/data_map.c        |   41 ++++++++++++++++--------------------
 tools/perf/util/data_map.h        |   32 ----------------------------
 tools/perf/util/header.c          |    2 +-
 tools/perf/util/session.c         |    3 +-
 tools/perf/util/session.h         |   26 ++++++++++++++++++++++-
 13 files changed, 66 insertions(+), 89 deletions(-)
 delete mode 100644 tools/perf/util/data_map.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 4069996..a4cb792 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -370,7 +370,6 @@ LIB_H += util/values.h
 LIB_H += util/sort.h
 LIB_H += util/hist.h
 LIB_H += util/thread.h
-LIB_H += util/data_map.h
 LIB_H += util/probe-finder.h
 LIB_H += util/probe-event.h
 
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 2e418b9..43e3bb3 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -26,7 +26,6 @@
 #include "util/sort.h"
 #include "util/hist.h"
 #include "util/session.h"
-#include "util/data_map.h"
 
 static char		const *input_name = "perf.data";
 
@@ -454,7 +453,7 @@ static void find_annotations(void)
 	}
 }
 
-static struct perf_file_handler file_handler = {
+static struct perf_event_ops event_ops = {
 	.process_sample_event	= process_sample_event,
 	.process_mmap_event	= event__process_mmap,
 	.process_comm_event	= event__process_comm,
@@ -463,7 +462,8 @@ static struct perf_file_handler file_handler = {
 
 static int __cmd_annotate(void)
 {
-	struct perf_session *session = perf_session__new(input_name, O_RDONLY, force);
+	struct perf_session *session = perf_session__new(input_name, O_RDONLY,
+							 force);
 	struct thread *idle;
 	int ret;
 
@@ -471,9 +471,9 @@ static int __cmd_annotate(void)
 		return -ENOMEM;
 
 	idle = register_idle_thread();
-	register_perf_file_handler(&file_handler);
 
-	ret = perf_session__process_events(session, 0, &event__cwdlen, &event__cwd);
+	ret = perf_session__process_events(session, &event_ops, 0,
+					   &event__cwdlen, &event__cwd);
 	if (ret)
 		goto out_delete;
 
diff --git a/tools/perf/builtin-buildid-list.c b/tools/perf/builtin-buildid-list.c
index bfd16a1..2629f76 100644
--- a/tools/perf/builtin-buildid-list.c
+++ b/tools/perf/builtin-buildid-list.c
@@ -9,7 +9,6 @@
 #include "builtin.h"
 #include "perf.h"
 #include "util/cache.h"
-#include "util/data_map.h"
 #include "util/debug.h"
 #include "util/parse-options.h"
 #include "util/session.h"
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 101b268..6f74bd8 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -12,7 +12,6 @@
 #include "util/trace-event.h"
 
 #include "util/debug.h"
-#include "util/data_map.h"
 
 #include <linux/rbtree.h>
 
@@ -359,7 +358,7 @@ static int sample_type_check(u64 type)
 	return 0;
 }
 
-static struct perf_file_handler file_handler = {
+static struct perf_event_ops event_ops = {
 	.process_sample_event	= process_sample_event,
 	.process_comm_event	= event__process_comm,
 	.sample_type_check	= sample_type_check,
@@ -374,9 +373,8 @@ static int read_events(void)
 		return -ENOMEM;
 
 	register_idle_thread();
-	register_perf_file_handler(&file_handler);
-
-	err = perf_session__process_events(session, 0, &event__cwdlen, &event__cwd);
+	err = perf_session__process_events(session, &event_ops, 0,
+					   &event__cwdlen, &event__cwd);
 	perf_session__delete(session);
 	return err;
 }
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index dcd8fed..c203eaf 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -27,7 +27,6 @@
 #include "util/parse-options.h"
 #include "util/parse-events.h"
 
-#include "util/data_map.h"
 #include "util/thread.h"
 #include "util/sort.h"
 #include "util/hist.h"
@@ -748,7 +747,7 @@ static int sample_type_check(u64 type)
 	return 0;
 }
 
-static struct perf_file_handler file_handler = {
+static struct perf_event_ops event_ops = {
 	.process_sample_event	= process_sample_event,
 	.process_mmap_event	= event__process_mmap,
 	.process_comm_event	= process_comm_event,
@@ -776,9 +775,7 @@ static int __cmd_report(void)
 	if (show_threads)
 		perf_read_values_init(&show_threads_values);
 
-	register_perf_file_handler(&file_handler);
-
-	ret = perf_session__process_events(session, full_paths,
+	ret = perf_session__process_events(session, &event_ops, full_paths,
 					   &event__cwdlen, &event__cwd);
 	if (ret)
 		goto out_delete;
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 48ab283..b5b4472 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -12,7 +12,6 @@
 #include "util/trace-event.h"
 
 #include "util/debug.h"
-#include "util/data_map.h"
 
 #include <sys/prctl.h>
 
@@ -1656,7 +1655,7 @@ static int sample_type_check(u64 type)
 	return 0;
 }
 
-static struct perf_file_handler file_handler = {
+static struct perf_event_ops event_ops = {
 	.process_sample_event	= process_sample_event,
 	.process_comm_event	= event__process_comm,
 	.process_lost_event	= process_lost_event,
@@ -1672,9 +1671,9 @@ static int read_events(void)
 		return -ENOMEM;
 
 	register_idle_thread();
-	register_perf_file_handler(&file_handler);
 
-	err = perf_session__process_events(session, 0, &event__cwdlen, &event__cwd);
+	err = perf_session__process_events(session, &event_ops, 0,
+					   &event__cwdlen, &event__cwd);
 	perf_session__delete(session);
 	return err;
 }
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index db6caae..4b95cec 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -30,7 +30,7 @@
 #include "util/parse-options.h"
 #include "util/parse-events.h"
 #include "util/event.h"
-#include "util/data_map.h"
+#include "util/session.h"
 #include "util/svghelper.h"
 
 static char		const *input_name = "perf.data";
@@ -1046,7 +1046,7 @@ static int sample_type_check(u64 type)
 	return 0;
 }
 
-static struct perf_file_handler file_handler = {
+static struct perf_event_ops event_ops = {
 	.process_comm_event	= process_comm_event,
 	.process_fork_event	= process_fork_event,
 	.process_exit_event	= process_exit_event,
@@ -1062,9 +1062,8 @@ static int __cmd_timechart(void)
 	if (session == NULL)
 		return -ENOMEM;
 
-	register_perf_file_handler(&file_handler);
-
-	ret = perf_session__process_events(session, 0, &event__cwdlen, &event__cwd);
+	ret = perf_session__process_events(session, &event_ops, 0,
+					   &event__cwdlen, &event__cwd);
 	if (ret)
 		goto out_delete;
 
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 3057e1d..c404dec 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -57,7 +57,6 @@ static int cleanup_scripting(void)
 #include "util/debug.h"
 
 #include "util/trace-event.h"
-#include "util/data_map.h"
 #include "util/exec_cmd.h"
 
 static char const		*input_name = "perf.data";
@@ -118,7 +117,7 @@ static int sample_type_check(u64 type)
 	return 0;
 }
 
-static struct perf_file_handler file_handler = {
+static struct perf_event_ops event_ops = {
 	.process_sample_event	= process_sample_event,
 	.process_comm_event	= event__process_comm,
 	.sample_type_check	= sample_type_check,
@@ -127,9 +126,8 @@ static struct perf_file_handler file_handler = {
 static int __cmd_trace(struct perf_session *session)
 {
 	register_idle_thread();
-	register_perf_file_handler(&file_handler);
-
-	return perf_session__process_events(session, 0, &event__cwdlen, &event__cwd);
+	return perf_session__process_events(session, &event_ops, 0,
+					    &event__cwdlen, &event__cwd);
 }
 
 struct script_spec {
diff --git a/tools/perf/util/data_map.c b/tools/perf/util/data_map.c
index 22bcdfe..ba5bcfa 100644
--- a/tools/perf/util/data_map.c
+++ b/tools/perf/util/data_map.c
@@ -1,10 +1,8 @@
-#include "data_map.h"
 #include "symbol.h"
 #include "util.h"
 #include "debug.h"
+#include "session.h"
 
-
-static struct perf_file_handler *curr_handler;
 static unsigned long	mmap_window = 32;
 static char		__cwd[PATH_MAX];
 
@@ -15,7 +13,7 @@ static int process_event_stub(event_t *event __used,
 	return 0;
 }
 
-void register_perf_file_handler(struct perf_file_handler *handler)
+static void perf_event_ops__fill_defaults(struct perf_event_ops *handler)
 {
 	if (!handler->process_sample_event)
 		handler->process_sample_event = process_event_stub;
@@ -35,8 +33,6 @@ void register_perf_file_handler(struct perf_file_handler *handler)
 		handler->process_throttle_event = process_event_stub;
 	if (!handler->process_unthrottle_event)
 		handler->process_unthrottle_event = process_event_stub;
-
-	curr_handler = handler;
 }
 
 static const char *event__name[] = {
@@ -63,6 +59,7 @@ void event__print_totals(void)
 }
 
 static int process_event(event_t *event, struct perf_session *session,
+			 struct perf_event_ops *ops,
 			 unsigned long offset, unsigned long head)
 {
 	trace_event(event);
@@ -78,25 +75,25 @@ static int process_event(event_t *event, struct perf_session *session,
 
 	switch (event->header.type) {
 	case PERF_RECORD_SAMPLE:
-		return curr_handler->process_sample_event(event, session);
+		return ops->process_sample_event(event, session);
 	case PERF_RECORD_MMAP:
-		return curr_handler->process_mmap_event(event, session);
+		return ops->process_mmap_event(event, session);
 	case PERF_RECORD_COMM:
-		return curr_handler->process_comm_event(event, session);
+		return ops->process_comm_event(event, session);
 	case PERF_RECORD_FORK:
-		return curr_handler->process_fork_event(event, session);
+		return ops->process_fork_event(event, session);
 	case PERF_RECORD_EXIT:
-		return curr_handler->process_exit_event(event, session);
+		return ops->process_exit_event(event, session);
 	case PERF_RECORD_LOST:
-		return curr_handler->process_lost_event(event, session);
+		return ops->process_lost_event(event, session);
 	case PERF_RECORD_READ:
-		return curr_handler->process_read_event(event, session);
+		return ops->process_read_event(event, session);
 	case PERF_RECORD_THROTTLE:
-		return curr_handler->process_throttle_event(event, session);
+		return ops->process_throttle_event(event, session);
 	case PERF_RECORD_UNTHROTTLE:
-		return curr_handler->process_unthrottle_event(event, session);
+		return ops->process_unthrottle_event(event, session);
 	default:
-		curr_handler->total_unknown++;
+		ops->total_unknown++;
 		return -1;
 	}
 }
@@ -131,6 +128,7 @@ out:
 }
 
 int perf_session__process_events(struct perf_session *self,
+				 struct perf_event_ops *ops,
 				 int full_paths, int *cwdlen, char **cwd)
 {
 	int err;
@@ -142,10 +140,7 @@ int perf_session__process_events(struct perf_session *self,
 	uint32_t size;
 	char *buf;
 
-	if (curr_handler == NULL) {
-		pr_debug("Forgot to register perf file handler\n");
-		return -EINVAL;
-	}
+	perf_event_ops__fill_defaults(ops);
 
 	page_size = getpagesize();
 
@@ -153,8 +148,8 @@ int perf_session__process_events(struct perf_session *self,
 	sample_type = perf_header__sample_type(&self->header);
 
 	err = -EINVAL;
-	if (curr_handler->sample_type_check &&
-	    curr_handler->sample_type_check(sample_type) < 0)
+	if (ops->sample_type_check &&
+	    ops->sample_type_check(sample_type) < 0)
 		goto out_err;
 
 	if (!full_paths) {
@@ -210,7 +205,7 @@ more:
 			(void *)(long)event->header.size,
 			event->header.type);
 
-	if (!size || process_event(event, self, offset, head) < 0) {
+	if (!size || process_event(event, self, ops, offset, head) < 0) {
 
 		dump_printf("%p [%p]: skipping unknown header type: %d\n",
 			(void *)(offset + head),
diff --git a/tools/perf/util/data_map.h b/tools/perf/util/data_map.h
deleted file mode 100644
index 6d4ae52..0000000
--- a/tools/perf/util/data_map.h
+++ /dev/null
@@ -1,32 +0,0 @@
-#ifndef __PERF_DATAMAP_H
-#define __PERF_DATAMAP_H
-
-#include "event.h"
-#include "header.h"
-#include "session.h"
-
-struct perf_session;
-
-typedef int (*event_type_handler_t)(event_t *self,
-				    struct perf_session *session);
-
-struct perf_file_handler {
-	event_type_handler_t	process_sample_event;
-	event_type_handler_t	process_mmap_event;
-	event_type_handler_t	process_comm_event;
-	event_type_handler_t	process_fork_event;
-	event_type_handler_t	process_exit_event;
-	event_type_handler_t	process_lost_event;
-	event_type_handler_t	process_read_event;
-	event_type_handler_t	process_throttle_event;
-	event_type_handler_t	process_unthrottle_event;
-	int			(*sample_type_check)(u64 sample_type);
-	unsigned long		total_unknown;
-};
-
-void register_perf_file_handler(struct perf_file_handler *handler);
-int perf_session__process_events(struct perf_session *self,
-				 int full_paths, int *cwdlen, char **cwd);
-int perf_header__read_build_ids(int input, u64 offset, u64 file_size);
-
-#endif
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index f2e8d87..8a0bca5 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -8,8 +8,8 @@
 #include "header.h"
 #include "../perf.h"
 #include "trace-event.h"
+#include "session.h"
 #include "symbol.h"
-#include "data_map.h"
 #include "debug.h"
 
 /*
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 707ce1c..3976686 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -48,7 +48,8 @@ out_close:
 	return -1;
 }
 
-struct perf_session *perf_session__new(const char *filename, int mode, bool force)
+struct perf_session *perf_session__new(const char *filename, int mode,
+				       bool force)
 {
 	size_t len = strlen(filename) + 1;
 	struct perf_session *self = zalloc(sizeof(*self) + len);
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index f3699c8..7a4c32c 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -1,6 +1,7 @@
 #ifndef __PERF_SESSION_H
 #define __PERF_SESSION_H
 
+#include "event.h"
 #include "header.h"
 
 struct perf_session {
@@ -10,7 +11,30 @@ struct perf_session {
 	char filename[0];
 };
 
-struct perf_session *perf_session__new(const char *filename, int mode, bool force);
+typedef int (*event_op)(event_t *self, struct perf_session *session);
+
+struct perf_event_ops {
+	event_op	process_sample_event;
+	event_op	process_mmap_event;
+	event_op	process_comm_event;
+	event_op	process_fork_event;
+	event_op	process_exit_event;
+	event_op	process_lost_event;
+	event_op	process_read_event;
+	event_op	process_throttle_event;
+	event_op	process_unthrottle_event;
+	int		(*sample_type_check)(u64 sample_type);
+	unsigned long	total_unknown;
+};
+
+struct perf_session *perf_session__new(const char *filename, int mode,
+				       bool force);
 void perf_session__delete(struct perf_session *self);
 
+int perf_session__process_events(struct perf_session *self,
+				 struct perf_event_ops *event_ops,
+				 int full_paths, int *cwdlen, char **cwd);
+
+int perf_header__read_build_ids(int input, u64 offset, u64 file_size);
+
 #endif /* __PERF_SESSION_H */
-- 
1.6.2.5

