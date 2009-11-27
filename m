Return-Path: <linux-kernel-owner+w=401wt.eu-S1753522AbZK0S3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522AbZK0S3z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 13:29:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753487AbZK0S3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 13:29:54 -0500
Received: from casper.infradead.org ([85.118.1.10]:43557 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354AbZK0S3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 13:29:46 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       John Kacur <jkacur@redhat.com>, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 11/12] perf tools: Reorganize event processing routines, lotsa dups killed
Date: Fri, 27 Nov 2009 16:29:22 -0200
Message-Id: <1259346563-12568-11-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1259346563-12568-10-git-send-email-acme@infradead.org>
References: <1259346563-12568-1-git-send-email-acme@infradead.org>
 <1259346563-12568-2-git-send-email-acme@infradead.org>
 <1259346563-12568-3-git-send-email-acme@infradead.org>
 <1259346563-12568-4-git-send-email-acme@infradead.org>
 <1259346563-12568-5-git-send-email-acme@infradead.org>
 <1259346563-12568-6-git-send-email-acme@infradead.org>
 <1259346563-12568-7-git-send-email-acme@infradead.org>
 <1259346563-12568-8-git-send-email-acme@infradead.org>
 <1259346563-12568-9-git-send-email-acme@infradead.org>
 <1259346563-12568-10-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

While implementing event__preprocess_sample, that will do all of the
symbol lookup in one convenient function, I noticed that
util/process_event.[ch] were not being used at all, then started looking
if there were other functions that could be shared and...

All those functions really don't need to receive offset + head, the only
thing they did was common to all of them, so do it at one place instead.

Stats about number of each type of event processed now is done in a
central place.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: John Kacur <jkacur@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile              |    2 -
 tools/perf/builtin-annotate.c    |   63 ++++++++------------------------
 tools/perf/builtin-kmem.c        |   33 ++---------------
 tools/perf/builtin-report.c      |   72 ++++++++++---------------------------
 tools/perf/builtin-sched.c       |   42 +++-------------------
 tools/perf/builtin-top.c         |   19 ----------
 tools/perf/builtin-trace.c       |   40 +++------------------
 tools/perf/util/data_map.c       |   56 ++++++++++++++++++++++-------
 tools/perf/util/data_map.h       |    2 +-
 tools/perf/util/event.c          |   74 ++++++++++++++++++++++++++++++++++++++
 tools/perf/util/event.h          |   17 +++++++++
 tools/perf/util/hist.c           |    7 ----
 tools/perf/util/process_event.c  |   53 ---------------------------
 tools/perf/util/process_event.h  |   29 ---------------
 tools/perf/util/process_events.c |   64 --------------------------------
 tools/perf/util/process_events.h |   35 ------------------
 16 files changed, 183 insertions(+), 425 deletions(-)
 delete mode 100644 tools/perf/util/process_event.c
 delete mode 100644 tools/perf/util/process_event.h
 delete mode 100644 tools/perf/util/process_events.c
 delete mode 100644 tools/perf/util/process_events.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index de37d49..f1537a9 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -369,7 +369,6 @@ LIB_H += util/sort.h
 LIB_H += util/hist.h
 LIB_H += util/thread.h
 LIB_H += util/data_map.h
-LIB_H += util/process_events.h
 
 LIB_OBJS += util/abspath.o
 LIB_OBJS += util/alias.o
@@ -412,7 +411,6 @@ LIB_OBJS += util/svghelper.o
 LIB_OBJS += util/sort.o
 LIB_OBJS += util/hist.o
 LIB_OBJS += util/data_map.o
-LIB_OBJS += util/process_events.o
 
 BUILTIN_OBJS += builtin-annotate.o
 
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 3ebd70b..7d39bd2 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -19,12 +19,12 @@
 #include "perf.h"
 #include "util/debug.h"
 
+#include "util/event.h"
 #include "util/parse-options.h"
 #include "util/parse-events.h"
 #include "util/thread.h"
 #include "util/sort.h"
 #include "util/hist.h"
-#include "util/process_events.h"
 
 static char		const *input_name = "perf.data";
 
@@ -136,8 +136,7 @@ static int hist_entry__add(struct thread *thread, struct map *map,
 	return 0;
 }
 
-static int
-process_sample_event(event_t *event, unsigned long offset, unsigned long head)
+static int process_sample_event(event_t *event)
 {
 	char level;
 	u64 ip = event->ip.ip;
@@ -145,12 +144,8 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 	struct symbol *sym = NULL;
 	struct thread *thread = threads__findnew(event->ip.pid);
 
-	dump_printf("%p [%p]: PERF_EVENT (IP, %d): %d: %p\n",
-		(void *)(offset + head),
-		(void *)(long)(event->header.size),
-		event->header.misc,
-		event->ip.pid,
-		(void *)(long)ip);
+	dump_printf("(IP, %d): %d: %p\n", event->header.misc,
+		    event->ip.pid, (void *)(long)ip);
 
 	if (thread == NULL) {
 		fprintf(stderr, "problem processing %d event, skipping it.\n",
@@ -198,46 +193,24 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 				"skipping event\n");
 		return -1;
 	}
-	total++;
 
 	return 0;
 }
 
-static int
-process_comm_event(event_t *event, unsigned long offset, unsigned long head)
+static int event__process(event_t *self)
 {
-	struct thread *thread = threads__findnew(event->comm.pid);
-
-	dump_printf("%p [%p]: PERF_RECORD_COMM: %s:%d\n",
-		(void *)(offset + head),
-		(void *)(long)(event->header.size),
-		event->comm.comm, event->comm.pid);
-
-	if (thread == NULL ||
-	    thread__set_comm(thread, event->comm.comm)) {
-		dump_printf("problem processing PERF_RECORD_COMM, skipping event.\n");
-		return -1;
-	}
-	total_comm++;
-
-	return 0;
-}
-
-static int
-process_event(event_t *event, unsigned long offset, unsigned long head)
-{
-	switch (event->header.type) {
+	switch (self->header.type) {
 	case PERF_RECORD_SAMPLE:
-		return process_sample_event(event, offset, head);
+		return process_sample_event(self);
 
 	case PERF_RECORD_MMAP:
-		return process_mmap_event(event, offset, head);
+		return event__process_mmap(self);
 
 	case PERF_RECORD_COMM:
-		return process_comm_event(event, offset, head);
+		return event__process_comm(self);
 
 	case PERF_RECORD_FORK:
-		return process_task_event(event, offset, head);
+		return event__process_task(self);
 	/*
 	 * We dont process them right now but they are fine:
 	 */
@@ -621,15 +594,12 @@ more:
 			(void *)(long)event->header.size,
 			event->header.type);
 
-	if (!size || process_event(event, offset, head) < 0) {
+	if (!size || event__process(event) < 0) {
 
 		dump_printf("%p [%p]: skipping unknown header type: %d\n",
 			(void *)(offset + head),
 			(void *)(long)(event->header.size),
 			event->header.type);
-
-		total_unknown++;
-
 		/*
 		 * assume we lost track of the stream, check alignment, and
 		 * increment a single u64 in the hope to catch on again 'soon'.
@@ -649,14 +619,11 @@ more:
 	rc = EXIT_SUCCESS;
 	close(input);
 
-	dump_printf("      IP events: %10ld\n", total);
-	dump_printf("    mmap events: %10ld\n", total_mmap);
-	dump_printf("    comm events: %10ld\n", total_comm);
-	dump_printf("    fork events: %10ld\n", total_fork);
-	dump_printf(" unknown events: %10ld\n", total_unknown);
 
-	if (dump_trace)
+	if (dump_trace) {
+		event__print_totals();
 		return 0;
+	}
 
 	if (verbose > 3)
 		threads__fprintf(stdout);
@@ -665,7 +632,7 @@ more:
 		dsos__fprintf(stdout);
 
 	collapse__resort();
-	output__resort(total);
+	output__resort(event__total[0]);
 
 	find_annotations();
 
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 35722fa..e7294c8 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -33,9 +33,6 @@ static bool			raw_ip;
 
 static char			default_sort_order[] = "frag,hit,bytes";
 
-static char			*cwd;
-static int			cwdlen;
-
 static int			*cpunode_map;
 static int			max_cpu_num;
 
@@ -126,25 +123,6 @@ static void setup_cpunode_map(void)
 	}
 }
 
-static int
-process_comm_event(event_t *event, unsigned long offset, unsigned long head)
-{
-	struct thread *thread = threads__findnew(event->comm.pid);
-
-	dump_printf("%p [%p]: PERF_RECORD_COMM: %s:%d\n",
-		(void *)(offset + head),
-		(void *)(long)(event->header.size),
-		event->comm.comm, event->comm.pid);
-
-	if (thread == NULL ||
-	    thread__set_comm(thread, event->comm.comm)) {
-		dump_printf("problem processing PERF_RECORD_COMM, skipping event.\n");
-		return -1;
-	}
-
-	return 0;
-}
-
 static void insert_alloc_stat(unsigned long call_site, unsigned long ptr,
 			      int bytes_req, int bytes_alloc, int cpu)
 {
@@ -340,8 +318,7 @@ process_raw_event(event_t *raw_event __used, void *more_data,
 	}
 }
 
-static int
-process_sample_event(event_t *event, unsigned long offset, unsigned long head)
+static int process_sample_event(event_t *event)
 {
 	u64 ip = event->ip.ip;
 	u64 timestamp = -1;
@@ -366,9 +343,7 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 		more_data += sizeof(u64);
 	}
 
-	dump_printf("%p [%p]: PERF_RECORD_SAMPLE (IP, %d): %d/%d: %p period: %Ld\n",
-		(void *)(offset + head),
-		(void *)(long)(event->header.size),
+	dump_printf("(IP, %d): %d/%d: %p period: %Ld\n",
 		event->header.misc,
 		event->ip.pid, event->ip.tid,
 		(void *)(long)ip,
@@ -403,7 +378,7 @@ static int sample_type_check(u64 type)
 
 static struct perf_file_handler file_handler = {
 	.process_sample_event	= process_sample_event,
-	.process_comm_event	= process_comm_event,
+	.process_comm_event	= event__process_comm,
 	.sample_type_check	= sample_type_check,
 };
 
@@ -413,7 +388,7 @@ static int read_events(void)
 	register_perf_file_handler(&file_handler);
 
 	return mmap_dispatch_perf_file(&header, input_name, 0, 0,
-				       &cwdlen, &cwd);
+				       &event__cwdlen, &event__cwd);
 }
 
 static double fragmentation(unsigned long n_req, unsigned long n_alloc)
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 9bd20c2..01ef35c 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -30,7 +30,6 @@
 #include "util/thread.h"
 #include "util/sort.h"
 #include "util/hist.h"
-#include "util/process_events.h"
 
 static char		const *input_name = "perf.data";
 
@@ -655,8 +654,7 @@ static int validate_chain(struct ip_callchain *chain, event_t *event)
 	return 0;
 }
 
-static int
-process_sample_event(event_t *event, unsigned long offset, unsigned long head)
+static int process_sample_event(event_t *event)
 {
 	char level;
 	struct symbol *sym = NULL;
@@ -673,9 +671,7 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 		more_data += sizeof(u64);
 	}
 
-	dump_printf("%p [%p]: PERF_RECORD_SAMPLE (IP, %d): %d/%d: %p period: %Ld\n",
-		(void *)(offset + head),
-		(void *)(long)(event->header.size),
+	dump_printf("(IP, %d): %d/%d: %p period: %Ld\n",
 		event->header.misc,
 		event->ip.pid, event->ip.tid,
 		(void *)(long)ip,
@@ -743,47 +739,27 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 		return -1;
 	}
 
-	total += period;
+	event__stats.total += period;
 
 	return 0;
 }
 
-static int
-process_comm_event(event_t *event, unsigned long offset, unsigned long head)
+static int process_comm_event(event_t *event)
 {
 	struct thread *thread = threads__findnew(event->comm.pid);
 
-	dump_printf("%p [%p]: PERF_RECORD_COMM: %s:%d\n",
-		(void *)(offset + head),
-		(void *)(long)(event->header.size),
-		event->comm.comm, event->comm.pid);
+	dump_printf(": %s:%d\n", event->comm.comm, event->comm.pid);
 
 	if (thread == NULL ||
 	    thread__set_comm_adjust(thread, event->comm.comm)) {
 		dump_printf("problem processing PERF_RECORD_COMM, skipping event.\n");
 		return -1;
 	}
-	total_comm++;
-
-	return 0;
-}
-
-static int
-process_lost_event(event_t *event, unsigned long offset, unsigned long head)
-{
-	dump_printf("%p [%p]: PERF_RECORD_LOST: id:%Ld: lost:%Ld\n",
-		(void *)(offset + head),
-		(void *)(long)(event->header.size),
-		event->lost.id,
-		event->lost.lost);
-
-	total_lost += event->lost.lost;
 
 	return 0;
 }
 
-static int
-process_read_event(event_t *event, unsigned long offset, unsigned long head)
+static int process_read_event(event_t *event)
 {
 	struct perf_event_attr *attr;
 
@@ -799,14 +775,9 @@ process_read_event(event_t *event, unsigned long offset, unsigned long head)
 					   event->read.value);
 	}
 
-	dump_printf("%p [%p]: PERF_RECORD_READ: %d %d %s %Lu\n",
-			(void *)(offset + head),
-			(void *)(long)(event->header.size),
-			event->read.pid,
-			event->read.tid,
-			attr ? __event_name(attr->type, attr->config)
-			     : "FAIL",
-			event->read.value);
+	dump_printf(": %d %d %s %Lu\n", event->read.pid, event->read.tid,
+		    attr ? __event_name(attr->type, attr->config) : "FAIL",
+		    event->read.value);
 
 	return 0;
 }
@@ -842,11 +813,11 @@ static int sample_type_check(u64 type)
 
 static struct perf_file_handler file_handler = {
 	.process_sample_event	= process_sample_event,
-	.process_mmap_event	= process_mmap_event,
+	.process_mmap_event	= event__process_mmap,
 	.process_comm_event	= process_comm_event,
-	.process_exit_event	= process_task_event,
-	.process_fork_event	= process_task_event,
-	.process_lost_event	= process_lost_event,
+	.process_exit_event	= event__process_task,
+	.process_fork_event	= event__process_task,
+	.process_lost_event	= event__process_lost,
 	.process_read_event	= process_read_event,
 	.sample_type_check	= sample_type_check,
 };
@@ -866,19 +837,14 @@ static int __cmd_report(void)
 	register_perf_file_handler(&file_handler);
 
 	ret = mmap_dispatch_perf_file(&header, input_name, force,
-				      full_paths, &cwdlen, &cwd);
+				      full_paths, &event__cwdlen, &event__cwd);
 	if (ret)
 		return ret;
 
-	dump_printf("      IP events: %10ld\n", total);
-	dump_printf("    mmap events: %10ld\n", total_mmap);
-	dump_printf("    comm events: %10ld\n", total_comm);
-	dump_printf("    fork events: %10ld\n", total_fork);
-	dump_printf("    lost events: %10ld\n", total_lost);
-	dump_printf(" unknown events: %10ld\n", file_handler.total_unknown);
-
-	if (dump_trace)
+	if (dump_trace) {
+		event__print_totals();
 		return 0;
+	}
 
 	if (verbose > 3)
 		threads__fprintf(stdout);
@@ -887,8 +853,8 @@ static int __cmd_report(void)
 		dsos__fprintf(stdout);
 
 	collapse__resort();
-	output__resort(total);
-	output__fprintf(stdout, total);
+	output__resort(event__stats.total);
+	output__fprintf(stdout, event__stats.total);
 
 	if (show_threads)
 		perf_read_values_destroy(&show_threads_values);
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 19eb708..26b782f 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -22,8 +22,6 @@
 
 static char			const *input_name = "perf.data";
 
-static unsigned long		total_comm = 0;
-
 static struct perf_header	*header;
 static u64			sample_type;
 
@@ -32,9 +30,6 @@ static char			*sort_order = default_sort_order;
 
 static int			profile_cpu = -1;
 
-static char			*cwd;
-static int			cwdlen;
-
 #define PR_SET_NAME		15               /* Set process name */
 #define MAX_CPUS		4096
 
@@ -633,27 +628,6 @@ static void test_calibrations(void)
 	printf("the sleep test took %Ld nsecs\n", T1-T0);
 }
 
-static int
-process_comm_event(event_t *event, unsigned long offset, unsigned long head)
-{
-	struct thread *thread = threads__findnew(event->comm.tid);
-
-	dump_printf("%p [%p]: perf_event_comm: %s:%d\n",
-		(void *)(offset + head),
-		(void *)(long)(event->header.size),
-		event->comm.comm, event->comm.pid);
-
-	if (thread == NULL ||
-	    thread__set_comm(thread, event->comm.comm)) {
-		dump_printf("problem processing perf_event_comm, skipping event.\n");
-		return -1;
-	}
-	total_comm++;
-
-	return 0;
-}
-
-
 struct raw_event_sample {
 	u32 size;
 	char data[0];
@@ -1622,8 +1596,7 @@ process_raw_event(event_t *raw_event __used, void *more_data,
 		process_sched_migrate_task_event(raw, event, cpu, timestamp, thread);
 }
 
-static int
-process_sample_event(event_t *event, unsigned long offset, unsigned long head)
+static int process_sample_event(event_t *event)
 {
 	struct thread *thread;
 	u64 ip = event->ip.ip;
@@ -1653,9 +1626,7 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 		more_data += sizeof(u64);
 	}
 
-	dump_printf("%p [%p]: PERF_RECORD_SAMPLE (IP, %d): %d/%d: %p period: %Ld\n",
-		(void *)(offset + head),
-		(void *)(long)(event->header.size),
+	dump_printf("(IP, %d): %d/%d: %p period: %Ld\n",
 		event->header.misc,
 		event->ip.pid, event->ip.tid,
 		(void *)(long)ip,
@@ -1677,10 +1648,7 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 	return 0;
 }
 
-static int
-process_lost_event(event_t *event __used,
-		   unsigned long offset __used,
-		   unsigned long head __used)
+static int process_lost_event(event_t *event __used)
 {
 	nr_lost_chunks++;
 	nr_lost_events += event->lost.lost;
@@ -1704,7 +1672,7 @@ static int sample_type_check(u64 type)
 
 static struct perf_file_handler file_handler = {
 	.process_sample_event	= process_sample_event,
-	.process_comm_event	= process_comm_event,
+	.process_comm_event	= event__process_comm,
 	.process_lost_event	= process_lost_event,
 	.sample_type_check	= sample_type_check,
 };
@@ -1715,7 +1683,7 @@ static int read_events(void)
 	register_perf_file_handler(&file_handler);
 
 	return mmap_dispatch_perf_file(&header, input_name, 0, 0,
-				       &cwdlen, &cwd);
+				       &event__cwdlen, &event__cwd);
 }
 
 static void print_bad_events(void)
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index bf6730c..7a3c0c7 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -991,25 +991,6 @@ static void event__process_sample(const event_t *self, int counter)
 	}
 }
 
-static void event__process_mmap(event_t *self)
-{
-	struct thread *thread = threads__findnew(self->mmap.pid);
-
-	if (thread != NULL) {
-		struct map *map = map__new(&self->mmap, MAP__FUNCTION, NULL, 0);
-		if (map != NULL)
-			thread__insert_map(thread, map);
-	}
-}
-
-static void event__process_comm(event_t *self)
-{
-	struct thread *thread = threads__findnew(self->comm.pid);
-
-	if (thread != NULL)
-		thread__set_comm(thread, self->comm.comm);
-}
-
 static int event__process(event_t *event)
 {
 	switch (event->header.type) {
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 75972fd..a775025 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -16,38 +16,10 @@
 
 static char		const *input_name = "perf.data";
 
-static unsigned long	total = 0;
-static unsigned long	total_comm = 0;
-
 static struct perf_header *header;
 static u64		sample_type;
 
-static char		*cwd;
-static int		cwdlen;
-
-
-static int
-process_comm_event(event_t *event, unsigned long offset, unsigned long head)
-{
-	struct thread *thread = threads__findnew(event->comm.pid);
-
-	dump_printf("%p [%p]: PERF_RECORD_COMM: %s:%d\n",
-		(void *)(offset + head),
-		(void *)(long)(event->header.size),
-		event->comm.comm, event->comm.pid);
-
-	if (thread == NULL ||
-	    thread__set_comm(thread, event->comm.comm)) {
-		dump_printf("problem processing PERF_RECORD_COMM, skipping event.\n");
-		return -1;
-	}
-	total_comm++;
-
-	return 0;
-}
-
-static int
-process_sample_event(event_t *event, unsigned long offset, unsigned long head)
+static int process_sample_event(event_t *event)
 {
 	u64 ip = event->ip.ip;
 	u64 timestamp = -1;
@@ -72,9 +44,7 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 		more_data += sizeof(u64);
 	}
 
-	dump_printf("%p [%p]: PERF_RECORD_SAMPLE (IP, %d): %d/%d: %p period: %Ld\n",
-		(void *)(offset + head),
-		(void *)(long)(event->header.size),
+	dump_printf("(IP, %d): %d/%d: %p period: %Ld\n",
 		event->header.misc,
 		event->ip.pid, event->ip.tid,
 		(void *)(long)ip,
@@ -101,7 +71,7 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 		 */
 		print_event(cpu, raw->data, raw->size, timestamp, thread->comm);
 	}
-	total += period;
+	event__stats.total += period;
 
 	return 0;
 }
@@ -122,7 +92,7 @@ static int sample_type_check(u64 type)
 
 static struct perf_file_handler file_handler = {
 	.process_sample_event	= process_sample_event,
-	.process_comm_event	= process_comm_event,
+	.process_comm_event	= event__process_comm,
 	.sample_type_check	= sample_type_check,
 };
 
@@ -132,7 +102,7 @@ static int __cmd_trace(void)
 	register_perf_file_handler(&file_handler);
 
 	return mmap_dispatch_perf_file(&header, input_name,
-				       0, 0, &cwdlen, &cwd);
+				       0, 0, &event__cwdlen, &event__cwd);
 }
 
 static const char * const annotate_usage[] = {
diff --git a/tools/perf/util/data_map.c b/tools/perf/util/data_map.c
index b238462..ca0bedf 100644
--- a/tools/perf/util/data_map.c
+++ b/tools/perf/util/data_map.c
@@ -8,11 +8,9 @@ static struct perf_file_handler *curr_handler;
 static unsigned long	mmap_window = 32;
 static char		__cwd[PATH_MAX];
 
-static int
-process_event_stub(event_t *event __used,
-		   unsigned long offset __used,
-		   unsigned long head __used)
+static int process_event_stub(event_t *event __used)
 {
+	dump_printf(": unhandled!\n");
 	return 0;
 }
 
@@ -40,30 +38,62 @@ void register_perf_file_handler(struct perf_file_handler *handler)
 	curr_handler = handler;
 }
 
+static const char *event__name[] = {
+	[0]			 = "TOTAL",
+	[PERF_RECORD_MMAP]	 = "MMAP",
+	[PERF_RECORD_LOST]	 = "LOST",
+	[PERF_RECORD_COMM]	 = "COMM",
+	[PERF_RECORD_EXIT]	 = "EXIT",
+	[PERF_RECORD_THROTTLE]	 = "THROTTLE",
+	[PERF_RECORD_UNTHROTTLE] = "UNTHROTTLE",
+	[PERF_RECORD_FORK]	 = "FORK",
+	[PERF_RECORD_READ]	 = "READ",
+	[PERF_RECORD_SAMPLE]	 = "SAMPLE",
+};
+
+unsigned long event__total[PERF_RECORD_MAX];
+
+void event__print_totals(void)
+{
+	int i;
+	for (i = 0; i < PERF_RECORD_MAX; ++i)
+		pr_info("%10s events: %10ld\n",
+			event__name[i], event__total[i]);
+}
+
 static int
 process_event(event_t *event, unsigned long offset, unsigned long head)
 {
 	trace_event(event);
 
+	if (event->header.type < PERF_RECORD_MAX) {
+		dump_printf("%p [%p]: PERF_RECORD_%s",
+			    (void *)(offset + head),
+			    (void *)(long)(event->header.size),
+			    event__name[event->header.type]);
+		++event__total[0];
+		++event__total[event->header.type];
+	}
+
 	switch (event->header.type) {
 	case PERF_RECORD_SAMPLE:
-		return curr_handler->process_sample_event(event, offset, head);
+		return curr_handler->process_sample_event(event);
 	case PERF_RECORD_MMAP:
-		return curr_handler->process_mmap_event(event, offset, head);
+		return curr_handler->process_mmap_event(event);
 	case PERF_RECORD_COMM:
-		return curr_handler->process_comm_event(event, offset, head);
+		return curr_handler->process_comm_event(event);
 	case PERF_RECORD_FORK:
-		return curr_handler->process_fork_event(event, offset, head);
+		return curr_handler->process_fork_event(event);
 	case PERF_RECORD_EXIT:
-		return curr_handler->process_exit_event(event, offset, head);
+		return curr_handler->process_exit_event(event);
 	case PERF_RECORD_LOST:
-		return curr_handler->process_lost_event(event, offset, head);
+		return curr_handler->process_lost_event(event);
 	case PERF_RECORD_READ:
-		return curr_handler->process_read_event(event, offset, head);
+		return curr_handler->process_read_event(event);
 	case PERF_RECORD_THROTTLE:
-		return curr_handler->process_throttle_event(event, offset, head);
+		return curr_handler->process_throttle_event(event);
 	case PERF_RECORD_UNTHROTTLE:
-		return curr_handler->process_unthrottle_event(event, offset, head);
+		return curr_handler->process_unthrottle_event(event);
 	default:
 		curr_handler->total_unknown++;
 		return -1;
diff --git a/tools/perf/util/data_map.h b/tools/perf/util/data_map.h
index ae036ec..3180ff7 100644
--- a/tools/perf/util/data_map.h
+++ b/tools/perf/util/data_map.h
@@ -4,7 +4,7 @@
 #include "event.h"
 #include "header.h"
 
-typedef int (*event_type_handler_t)(event_t *, unsigned long, unsigned long);
+typedef int (*event_type_handler_t)(event_t *);
 
 struct perf_file_handler {
 	event_type_handler_t	process_sample_event;
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 1dae7e3..70b4aa0 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -2,6 +2,7 @@
 #include "event.h"
 #include "debug.h"
 #include "string.h"
+#include "thread.h"
 
 static pid_t event__synthesize_comm(pid_t pid, int full,
 				    int (*process)(event_t *event))
@@ -175,3 +176,76 @@ void event__synthesize_threads(int (*process)(event_t *event))
 
 	closedir(proc);
 }
+
+char *event__cwd;
+int  event__cwdlen;
+
+struct events_stats event__stats;
+
+int event__process_comm(event_t *self)
+{
+	struct thread *thread = threads__findnew(self->comm.pid);
+
+	dump_printf("PERF_RECORD_COMM: %s:%d\n",
+		    self->comm.comm, self->comm.pid);
+
+	if (thread == NULL || thread__set_comm(thread, self->comm.comm)) {
+		dump_printf("problem processing PERF_RECORD_COMM, skipping event.\n");
+		return -1;
+	}
+
+	return 0;
+}
+
+int event__process_lost(event_t *self)
+{
+	dump_printf(": id:%Ld: lost:%Ld\n", self->lost.id, self->lost.lost);
+	event__stats.lost += self->lost.lost;
+	return 0;
+}
+
+int event__process_mmap(event_t *self)
+{
+	struct thread *thread = threads__findnew(self->mmap.pid);
+	struct map *map = map__new(&self->mmap, MAP__FUNCTION,
+				   event__cwd, event__cwdlen);
+
+	dump_printf(" %d/%d: [%p(%p) @ %p]: %s\n",
+		    self->mmap.pid, self->mmap.tid,
+		    (void *)(long)self->mmap.start,
+		    (void *)(long)self->mmap.len,
+		    (void *)(long)self->mmap.pgoff,
+		    self->mmap.filename);
+
+	if (thread == NULL || map == NULL)
+		dump_printf("problem processing PERF_RECORD_MMAP, skipping event.\n");
+	else
+		thread__insert_map(thread, map);
+
+	return 0;
+}
+
+int event__process_task(event_t *self)
+{
+	struct thread *thread = threads__findnew(self->fork.pid);
+	struct thread *parent = threads__findnew(self->fork.ppid);
+
+	dump_printf("(%d:%d):(%d:%d)\n", self->fork.pid, self->fork.tid,
+		    self->fork.ppid, self->fork.ptid);
+	/*
+	 * A thread clone will have the same PID for both parent and child.
+	 */
+	if (thread == parent)
+		return 0;
+
+	if (self->header.type == PERF_RECORD_EXIT)
+		return 0;
+
+	if (thread == NULL || parent == NULL ||
+	    thread__fork(thread, parent) < 0) {
+		dump_printf("problem processing PERF_RECORD_FORK, skipping event.\n");
+		return -1;
+	}
+
+	return 0;
+}
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 3ae3c96..13c12c7 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -80,6 +80,13 @@ typedef union event_union {
 	struct sample_event		sample;
 } event_t;
 
+struct events_stats {
+	unsigned long total;
+	unsigned long lost;
+};
+
+void event__print_totals(void);
+
 enum map_type {
 	MAP__FUNCTION = 0,
 
@@ -135,4 +142,14 @@ void map__fixup_end(struct map *self);
 int event__synthesize_thread(pid_t pid, int (*process)(event_t *event));
 void event__synthesize_threads(int (*process)(event_t *event));
 
+extern char *event__cwd;
+extern int  event__cwdlen;
+extern struct events_stats event__stats;
+extern unsigned long event__total[PERF_RECORD_MAX];
+
+int event__process_comm(event_t *self);
+int event__process_lost(event_t *self);
+int event__process_mmap(event_t *self);
+int event__process_task(event_t *self);
+
 #endif /* __PERF_RECORD_H */
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 7393a02..f26cd9b 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -10,13 +10,6 @@ struct callchain_param	callchain_param = {
 	.min_percent = 0.5
 };
 
-unsigned long total;
-unsigned long total_mmap;
-unsigned long total_comm;
-unsigned long total_fork;
-unsigned long total_unknown;
-unsigned long total_lost;
-
 /*
  * histogram, sorted on item, collects counts
  */
diff --git a/tools/perf/util/process_event.c b/tools/perf/util/process_event.c
deleted file mode 100644
index a970789..0000000
--- a/tools/perf/util/process_event.c
+++ /dev/null
@@ -1,53 +0,0 @@
-#include "process_event.h"
-
-char	*cwd;
-int	cwdlen;
-
-int
-process_mmap_event(event_t *event, unsigned long offset, unsigned long head)
-{
-	struct map *map = map__new(&event->mmap, cwd, cwdlen);
-	struct thread *thread = threads__findnew(event->mmap.pid);
-
-	dump_printf("%p [%p]: PERF_RECORD_MMAP %d/%d: [%p(%p) @ %p]: %s\n",
-			(void *)(offset + head),
-			(void *)(long)(event->header.size),
-			event->mmap.pid,
-			event->mmap.tid,
-			(void *)(long)event->mmap.start,
-			(void *)(long)event->mmap.len,
-			(void *)(long)event->mmap.pgoff,
-			event->mmap.filename);
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
-
-}
-
-int
-process_comm_event(event_t *event, unsigned long offset, unsigned long head)
-{
-	struct thread *thread = threads__findnew(event->comm.pid);
-
-	dump_printf("%p [%p]: PERF_RECORD_COMM: %s:%d\n",
-		(void *)(offset + head),
-		(void *)(long)(event->header.size),
-		event->comm.comm, event->comm.pid);
-
-	if (thread == NULL ||
-	    thread__set_comm_adjust(thread, event->comm.comm)) {
-		dump_printf("problem processing PERF_RECORD_COMM, skipping event.\n");
-		return -1;
-	}
-	total_comm++;
-
-	return 0;
-}
-
diff --git a/tools/perf/util/process_event.h b/tools/perf/util/process_event.h
deleted file mode 100644
index 6f68c69..0000000
--- a/tools/perf/util/process_event.h
+++ /dev/null
@@ -1,29 +0,0 @@
-#ifndef __PROCESS_EVENT_H
-#define __PROCESS_EVENT_H
-
-#include "../builtin.h"
-#include "util.h"
-
-#include "color.h"
-#include <linux/list.h>
-#include "cache.h"
-#include <linux/rbtree.h>
-#include "symbol.h"
-#include "string.h"
-
-#include "../perf.h"
-#include "debug.h"
-
-#include "parse-options.h"
-#include "parse-events.h"
-
-#include "thread.h"
-#include "sort.h"
-#include "hist.h"
-
-extern char	*cwd;
-extern int	cwdlen;
-extern int process_mmap_event(event_t *, unsigned long, unsigned long);
-extern int process_comm_event(event_t *, unsigned long , unsigned long);
-
-#endif	/* __PROCESS_H */
diff --git a/tools/perf/util/process_events.c b/tools/perf/util/process_events.c
deleted file mode 100644
index 5377868..0000000
--- a/tools/perf/util/process_events.c
+++ /dev/null
@@ -1,64 +0,0 @@
-#include "process_events.h"
-
-char	*cwd;
-int	cwdlen;
-
-int
-process_mmap_event(event_t *event, unsigned long offset, unsigned long head)
-{
-	struct map *map = map__new(&event->mmap, MAP__FUNCTION, cwd, cwdlen);
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
-int
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
diff --git a/tools/perf/util/process_events.h b/tools/perf/util/process_events.h
deleted file mode 100644
index 73d092f..0000000
--- a/tools/perf/util/process_events.h
+++ /dev/null
@@ -1,35 +0,0 @@
-#ifndef __PROCESS_EVENTS_H
-#define __PROCESS_EVENTS_H
-
-#include "../builtin.h"
-
-#include "util.h"
-#include "color.h"
-#include <linux/list.h>
-#include "cache.h"
-#include <linux/rbtree.h>
-#include "symbol.h"
-#include "string.h"
-#include "callchain.h"
-#include "strlist.h"
-#include "values.h"
-
-#include "../perf.h"
-#include "debug.h"
-#include "header.h"
-
-#include "parse-options.h"
-#include "parse-events.h"
-
-#include "data_map.h"
-#include "thread.h"
-#include "sort.h"
-#include "hist.h"
-
-extern char	*cwd;
-extern int	cwdlen;
-
-extern int process_mmap_event(event_t *, unsigned long , unsigned long);
-extern int process_task_event(event_t *, unsigned long, unsigned long);
-
-#endif	/* __PROCESS_EVENTS_H */
-- 
1.6.2.5

