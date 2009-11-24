Return-Path: <linux-kernel-owner+w=401wt.eu-S933686AbZKXQ61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933686AbZKXQ61 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 11:58:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933579AbZKXQ60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 11:58:26 -0500
Received: from hera.kernel.org ([140.211.167.34]:60377 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933512AbZKXQ6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 11:58:20 -0500
Date: Tue, 24 Nov 2009 16:57:34 GMT
From: tip-bot for John Kacur <jkacur@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jkacur@redhat.com, fweisbec@gmail.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1259073301-11506-3-git-send-email-jkacur@redhat.com>
References: <1259073301-11506-3-git-send-email-jkacur@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Use common process_event functions for annotate and report
Message-ID: <tip-e74328d3a17ed75ffdf72b86f289965823a47240@git.kernel.org>
Git-Commit-ID: e74328d3a17ed75ffdf72b86f289965823a47240
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e74328d3a17ed75ffdf72b86f289965823a47240
Gitweb:     http://git.kernel.org/tip/e74328d3a17ed75ffdf72b86f289965823a47240
Author:     John Kacur <jkacur@redhat.com>
AuthorDate: Tue, 24 Nov 2009 15:35:01 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 24 Nov 2009 16:37:01 +0100

perf tools: Use common process_event functions for annotate and report

Prevent bit-rot in perf-annotate by using common functions where
possible. Here we create process_events.[ch] to hold the common
functions.

Signed-off-by: John Kacur <jkacur@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: acme@redhat.com
LKML-Reference: <1259073301-11506-3-git-send-email-jkacur@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/Makefile              |    2 +
 tools/perf/builtin-annotate.c    |   56 +--------------------------------
 tools/perf/builtin-report.c      |   63 +------------------------------------
 tools/perf/util/process_event.c  |   53 +++++++++++++++++++++++++++++++
 tools/perf/util/process_event.h  |   29 +++++++++++++++++
 tools/perf/util/process_events.c |   64 ++++++++++++++++++++++++++++++++++++++
 tools/perf/util/process_events.h |   35 ++++++++++++++++++++
 7 files changed, 186 insertions(+), 116 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index f1537a9..de37d49 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -369,6 +369,7 @@ LIB_H += util/sort.h
 LIB_H += util/hist.h
 LIB_H += util/thread.h
 LIB_H += util/data_map.h
+LIB_H += util/process_events.h
 
 LIB_OBJS += util/abspath.o
 LIB_OBJS += util/alias.o
@@ -411,6 +412,7 @@ LIB_OBJS += util/svghelper.o
 LIB_OBJS += util/sort.o
 LIB_OBJS += util/hist.o
 LIB_OBJS += util/data_map.o
+LIB_OBJS += util/process_events.o
 
 BUILTIN_OBJS += builtin-annotate.o
 
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 6b13a1e..59b6123 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -24,6 +24,7 @@
 #include "util/thread.h"
 #include "util/sort.h"
 #include "util/hist.h"
+#include "util/process_events.h"
 
 static char		const *input_name = "perf.data";
 
@@ -202,32 +203,6 @@ got_map:
 }
 
 static int
-process_mmap_event(event_t *event, unsigned long offset, unsigned long head)
-{
-	struct map *map = map__new(&event->mmap, NULL, 0);
-	struct thread *thread = threads__findnew(event->mmap.pid);
-
-	dump_printf("%p [%p]: PERF_RECORD_MMAP %d: [%p(%p) @ %p]: %s\n",
-		(void *)(offset + head),
-		(void *)(long)(event->header.size),
-		event->mmap.pid,
-		(void *)(long)event->mmap.start,
-		(void *)(long)event->mmap.len,
-		(void *)(long)event->mmap.pgoff,
-		event->mmap.filename);
-
-	if (thread == NULL || map == NULL) {
-		dump_printf("problem processing PERF_RECORD_MMAP, skipping event.\n");
-		return 0;
-	}
-
-	thread__insert_map(thread, map);
-	total_mmap++;
-
-	return 0;
-}
-
-static int
 process_comm_event(event_t *event, unsigned long offset, unsigned long head)
 {
 	struct thread *thread = threads__findnew(event->comm.pid);
@@ -248,33 +223,6 @@ process_comm_event(event_t *event, unsigned long offset, unsigned long head)
 }
 
 static int
-process_fork_event(event_t *event, unsigned long offset, unsigned long head)
-{
-	struct thread *thread = threads__findnew(event->fork.pid);
-	struct thread *parent = threads__findnew(event->fork.ppid);
-
-	dump_printf("%p [%p]: PERF_RECORD_FORK: %d:%d\n",
-		(void *)(offset + head),
-		(void *)(long)(event->header.size),
-		event->fork.pid, event->fork.ppid);
-
-	/*
-	 * A thread clone will have the same PID for both
-	 * parent and child.
-	 */
-	if (thread == parent)
-		return 0;
-
-	if (!thread || !parent || thread__fork(thread, parent)) {
-		dump_printf("problem processing PERF_RECORD_FORK, skipping event.\n");
-		return -1;
-	}
-	total_fork++;
-
-	return 0;
-}
-
-static int
 process_event(event_t *event, unsigned long offset, unsigned long head)
 {
 	switch (event->header.type) {
@@ -288,7 +236,7 @@ process_event(event_t *event, unsigned long offset, unsigned long head)
 		return process_comm_event(event, offset, head);
 
 	case PERF_RECORD_FORK:
-		return process_fork_event(event, offset, head);
+		return process_task_event(event, offset, head);
 	/*
 	 * We dont process them right now but they are fine:
 	 */
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index fe474b7..1826be7 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -30,6 +30,7 @@
 #include "util/thread.h"
 #include "util/sort.h"
 #include "util/hist.h"
+#include "util/process_events.h"
 
 static char		const *input_name = "perf.data";
 
@@ -54,9 +55,6 @@ static int		exclude_other = 1;
 static char		callchain_default_opt[] = "fractal,0.5";
 const char		*vmlinux_name;
 
-static char		*cwd;
-static int		cwdlen;
-
 static struct perf_header *header;
 
 static u64		sample_type;
@@ -751,33 +749,6 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 }
 
 static int
-process_mmap_event(event_t *event, unsigned long offset, unsigned long head)
-{
-	struct map *map = map__new(&event->mmap, cwd, cwdlen);
-	struct thread *thread = threads__findnew(event->mmap.pid);
-
-	dump_printf("%p [%p]: PERF_RECORD_MMAP %d/%d: [%p(%p) @ %p]: %s\n",
-		(void *)(offset + head),
-		(void *)(long)(event->header.size),
-		event->mmap.pid,
-		event->mmap.tid,
-		(void *)(long)event->mmap.start,
-		(void *)(long)event->mmap.len,
-		(void *)(long)event->mmap.pgoff,
-		event->mmap.filename);
-
-	if (thread == NULL || map == NULL) {
-		dump_printf("problem processing PERF_RECORD_MMAP, skipping event.\n");
-		return 0;
-	}
-
-	thread__insert_map(thread, map);
-	total_mmap++;
-
-	return 0;
-}
-
-static int
 process_comm_event(event_t *event, unsigned long offset, unsigned long head)
 {
 	struct thread *thread = threads__findnew(event->comm.pid);
@@ -798,38 +769,6 @@ process_comm_event(event_t *event, unsigned long offset, unsigned long head)
 }
 
 static int
-process_task_event(event_t *event, unsigned long offset, unsigned long head)
-{
-	struct thread *thread = threads__findnew(event->fork.pid);
-	struct thread *parent = threads__findnew(event->fork.ppid);
-
-	dump_printf("%p [%p]: PERF_RECORD_%s: (%d:%d):(%d:%d)\n",
-		(void *)(offset + head),
-		(void *)(long)(event->header.size),
-		event->header.type == PERF_RECORD_FORK ? "FORK" : "EXIT",
-		event->fork.pid, event->fork.tid,
-		event->fork.ppid, event->fork.ptid);
-
-	/*
-	 * A thread clone will have the same PID for both
-	 * parent and child.
-	 */
-	if (thread == parent)
-		return 0;
-
-	if (event->header.type == PERF_RECORD_EXIT)
-		return 0;
-
-	if (!thread || !parent || thread__fork(thread, parent)) {
-		dump_printf("problem processing PERF_RECORD_FORK, skipping event.\n");
-		return -1;
-	}
-	total_fork++;
-
-	return 0;
-}
-
-static int
 process_lost_event(event_t *event, unsigned long offset, unsigned long head)
 {
 	dump_printf("%p [%p]: PERF_RECORD_LOST: id:%Ld: lost:%Ld\n",
diff --git a/tools/perf/util/process_event.c b/tools/perf/util/process_event.c
new file mode 100644
index 0000000..a970789
--- /dev/null
+++ b/tools/perf/util/process_event.c
@@ -0,0 +1,53 @@
+#include "process_event.h"
+
+char	*cwd;
+int	cwdlen;
+
+int
+process_mmap_event(event_t *event, unsigned long offset, unsigned long head)
+{
+	struct map *map = map__new(&event->mmap, cwd, cwdlen);
+	struct thread *thread = threads__findnew(event->mmap.pid);
+
+	dump_printf("%p [%p]: PERF_RECORD_MMAP %d/%d: [%p(%p) @ %p]: %s\n",
+			(void *)(offset + head),
+			(void *)(long)(event->header.size),
+			event->mmap.pid,
+			event->mmap.tid,
+			(void *)(long)event->mmap.start,
+			(void *)(long)event->mmap.len,
+			(void *)(long)event->mmap.pgoff,
+			event->mmap.filename);
+
+	if (thread == NULL || map == NULL) {
+		dump_printf("problem processing PERF_RECORD_MMAP, skipping event.\n");
+		return 0;
+	}
+
+	thread__insert_map(thread, map);
+	total_mmap++;
+
+	return 0;
+
+}
+
+int
+process_comm_event(event_t *event, unsigned long offset, unsigned long head)
+{
+	struct thread *thread = threads__findnew(event->comm.pid);
+
+	dump_printf("%p [%p]: PERF_RECORD_COMM: %s:%d\n",
+		(void *)(offset + head),
+		(void *)(long)(event->header.size),
+		event->comm.comm, event->comm.pid);
+
+	if (thread == NULL ||
+	    thread__set_comm_adjust(thread, event->comm.comm)) {
+		dump_printf("problem processing PERF_RECORD_COMM, skipping event.\n");
+		return -1;
+	}
+	total_comm++;
+
+	return 0;
+}
+
diff --git a/tools/perf/util/process_event.h b/tools/perf/util/process_event.h
new file mode 100644
index 0000000..6f68c69
--- /dev/null
+++ b/tools/perf/util/process_event.h
@@ -0,0 +1,29 @@
+#ifndef __PROCESS_EVENT_H
+#define __PROCESS_EVENT_H
+
+#include "../builtin.h"
+#include "util.h"
+
+#include "color.h"
+#include <linux/list.h>
+#include "cache.h"
+#include <linux/rbtree.h>
+#include "symbol.h"
+#include "string.h"
+
+#include "../perf.h"
+#include "debug.h"
+
+#include "parse-options.h"
+#include "parse-events.h"
+
+#include "thread.h"
+#include "sort.h"
+#include "hist.h"
+
+extern char	*cwd;
+extern int	cwdlen;
+extern int process_mmap_event(event_t *, unsigned long, unsigned long);
+extern int process_comm_event(event_t *, unsigned long , unsigned long);
+
+#endif	/* __PROCESS_H */
diff --git a/tools/perf/util/process_events.c b/tools/perf/util/process_events.c
new file mode 100644
index 0000000..a920436
--- /dev/null
+++ b/tools/perf/util/process_events.c
@@ -0,0 +1,64 @@
+#include "process_events.h"
+
+char	*cwd;
+int	cwdlen;
+
+int
+process_mmap_event(event_t *event, unsigned long offset, unsigned long head)
+{
+	struct map *map = map__new(&event->mmap, cwd, cwdlen);
+	struct thread *thread = threads__findnew(event->mmap.pid);
+
+	dump_printf("%p [%p]: PERF_RECORD_MMAP %d/%d: [%p(%p) @ %p]: %s\n",
+		(void *)(offset + head),
+		(void *)(long)(event->header.size),
+		event->mmap.pid,
+		event->mmap.tid,
+		(void *)(long)event->mmap.start,
+		(void *)(long)event->mmap.len,
+		(void *)(long)event->mmap.pgoff,
+		event->mmap.filename);
+
+	if (thread == NULL || map == NULL) {
+		dump_printf("problem processing PERF_RECORD_MMAP, skipping event.\n");
+		return 0;
+	}
+
+	thread__insert_map(thread, map);
+	total_mmap++;
+
+	return 0;
+}
+
+int
+process_task_event(event_t *event, unsigned long offset, unsigned long head)
+{
+	struct thread *thread = threads__findnew(event->fork.pid);
+	struct thread *parent = threads__findnew(event->fork.ppid);
+
+	dump_printf("%p [%p]: PERF_RECORD_%s: (%d:%d):(%d:%d)\n",
+		(void *)(offset + head),
+		(void *)(long)(event->header.size),
+		event->header.type == PERF_RECORD_FORK ? "FORK" : "EXIT",
+		event->fork.pid, event->fork.tid,
+		event->fork.ppid, event->fork.ptid);
+
+	/*
+	 * A thread clone will have the same PID for both
+	 * parent and child.
+	 */
+	if (thread == parent)
+		return 0;
+
+	if (event->header.type == PERF_RECORD_EXIT)
+		return 0;
+
+	if (!thread || !parent || thread__fork(thread, parent)) {
+		dump_printf("problem processing PERF_RECORD_FORK, skipping event.\n");
+		return -1;
+	}
+	total_fork++;
+
+	return 0;
+}
+
diff --git a/tools/perf/util/process_events.h b/tools/perf/util/process_events.h
new file mode 100644
index 0000000..73d092f
--- /dev/null
+++ b/tools/perf/util/process_events.h
@@ -0,0 +1,35 @@
+#ifndef __PROCESS_EVENTS_H
+#define __PROCESS_EVENTS_H
+
+#include "../builtin.h"
+
+#include "util.h"
+#include "color.h"
+#include <linux/list.h>
+#include "cache.h"
+#include <linux/rbtree.h>
+#include "symbol.h"
+#include "string.h"
+#include "callchain.h"
+#include "strlist.h"
+#include "values.h"
+
+#include "../perf.h"
+#include "debug.h"
+#include "header.h"
+
+#include "parse-options.h"
+#include "parse-events.h"
+
+#include "data_map.h"
+#include "thread.h"
+#include "sort.h"
+#include "hist.h"
+
+extern char	*cwd;
+extern int	cwdlen;
+
+extern int process_mmap_event(event_t *, unsigned long , unsigned long);
+extern int process_task_event(event_t *, unsigned long, unsigned long);
+
+#endif	/* __PROCESS_EVENTS_H */
