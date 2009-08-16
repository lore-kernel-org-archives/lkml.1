Return-Path: <linux-kernel-owner+w=401wt.eu-S932078AbZHPSBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078AbZHPSBR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 14:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755232AbZHPSBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 14:01:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:56173 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755162AbZHPSBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 14:01:15 -0400
Date: Sun, 16 Aug 2009 18:00:39 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, peterz@infradead.org,
       efault@gmx.de, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1250443461-28130-1-git-send-email-fweisbec@gmail.com>
References: <1250443461-28130-1-git-send-email-fweisbec@gmail.com>
Subject: [tip:perfcounters/core] perf tools: Factorize the dprintf definition
Message-ID: <tip-2cec19d9d0716f8d68f1c5a87667d0387d4d252d@git.kernel.org>
Git-Commit-ID: 2cec19d9d0716f8d68f1c5a87667d0387d4d252d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 16 Aug 2009 18:00:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2cec19d9d0716f8d68f1c5a87667d0387d4d252d
Gitweb:     http://git.kernel.org/tip/2cec19d9d0716f8d68f1c5a87667d0387d4d252d
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Sun, 16 Aug 2009 19:24:21 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 16 Aug 2009 19:42:31 +0200

perf tools: Factorize the dprintf definition

We have two users of dprintf: report and annotate. Another one
is coming with perf trace. Then factorize it into the debug
file.

While at it, rename dprintf() to dump_printf() so that it
doesn't conflicts with its libc homograph.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <1250443461-28130-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-annotate.c |   40 +++++++++++++----------------
 tools/perf/builtin-report.c   |   56 +++++++++++++++++++---------------------
 tools/perf/util/debug.c       |   15 +++++++++++
 tools/perf/util/debug.h       |    2 +
 4 files changed, 62 insertions(+), 51 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 32ff983..820e7cc 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -34,10 +34,6 @@ static char		*sort_order = default_sort_order;
 static int		input;
 static int		show_mask = SHOW_KERNEL | SHOW_USER | SHOW_HV;
 
-static int		dump_trace = 0;
-#define dprintf(x...)	do { if (dump_trace) printf(x); } while (0)
-
-
 static int		full_paths;
 
 static int		print_line;
@@ -507,14 +503,14 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 
 	thread = threads__findnew(event->ip.pid, &threads, &last_match);
 
-	dprintf("%p [%p]: PERF_EVENT (IP, %d): %d: %p\n",
+	dump_printf("%p [%p]: PERF_EVENT (IP, %d): %d: %p\n",
 		(void *)(offset + head),
 		(void *)(long)(event->header.size),
 		event->header.misc,
 		event->ip.pid,
 		(void *)(long)ip);
 
-	dprintf(" ... thread: %s:%d\n", thread->comm, thread->pid);
+	dump_printf(" ... thread: %s:%d\n", thread->comm, thread->pid);
 
 	if (thread == NULL) {
 		fprintf(stderr, "problem processing %d event, skipping it.\n",
@@ -528,7 +524,7 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 
 		dso = kernel_dso;
 
-		dprintf(" ...... dso: %s\n", dso->name);
+		dump_printf(" ...... dso: %s\n", dso->name);
 
 	} else if (event->header.misc & PERF_EVENT_MISC_USER) {
 
@@ -549,12 +545,12 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 			if ((long long)ip < 0)
 				dso = kernel_dso;
 		}
-		dprintf(" ...... dso: %s\n", dso ? dso->name : "<not found>");
+		dump_printf(" ...... dso: %s\n", dso ? dso->name : "<not found>");
 
 	} else {
 		show = SHOW_HV;
 		level = 'H';
-		dprintf(" ...... dso: [hypervisor]\n");
+		dump_printf(" ...... dso: [hypervisor]\n");
 	}
 
 	if (show & show_mask) {
@@ -582,7 +578,7 @@ process_mmap_event(event_t *event, unsigned long offset, unsigned long head)
 
 	thread = threads__findnew(event->mmap.pid, &threads, &last_match);
 
-	dprintf("%p [%p]: PERF_EVENT_MMAP %d: [%p(%p) @ %p]: %s\n",
+	dump_printf("%p [%p]: PERF_EVENT_MMAP %d: [%p(%p) @ %p]: %s\n",
 		(void *)(offset + head),
 		(void *)(long)(event->header.size),
 		event->mmap.pid,
@@ -592,7 +588,7 @@ process_mmap_event(event_t *event, unsigned long offset, unsigned long head)
 		event->mmap.filename);
 
 	if (thread == NULL || map == NULL) {
-		dprintf("problem processing PERF_EVENT_MMAP, skipping event.\n");
+		dump_printf("problem processing PERF_EVENT_MMAP, skipping event.\n");
 		return 0;
 	}
 
@@ -608,14 +604,14 @@ process_comm_event(event_t *event, unsigned long offset, unsigned long head)
 	struct thread *thread;
 
 	thread = threads__findnew(event->comm.pid, &threads, &last_match);
-	dprintf("%p [%p]: PERF_EVENT_COMM: %s:%d\n",
+	dump_printf("%p [%p]: PERF_EVENT_COMM: %s:%d\n",
 		(void *)(offset + head),
 		(void *)(long)(event->header.size),
 		event->comm.comm, event->comm.pid);
 
 	if (thread == NULL ||
 	    thread__set_comm(thread, event->comm.comm)) {
-		dprintf("problem processing PERF_EVENT_COMM, skipping event.\n");
+		dump_printf("problem processing PERF_EVENT_COMM, skipping event.\n");
 		return -1;
 	}
 	total_comm++;
@@ -631,13 +627,13 @@ process_fork_event(event_t *event, unsigned long offset, unsigned long head)
 
 	thread = threads__findnew(event->fork.pid, &threads, &last_match);
 	parent = threads__findnew(event->fork.ppid, &threads, &last_match);
-	dprintf("%p [%p]: PERF_EVENT_FORK: %d:%d\n",
+	dump_printf("%p [%p]: PERF_EVENT_FORK: %d:%d\n",
 		(void *)(offset + head),
 		(void *)(long)(event->header.size),
 		event->fork.pid, event->fork.ppid);
 
 	if (!thread || !parent || thread__fork(thread, parent)) {
-		dprintf("problem processing PERF_EVENT_FORK, skipping event.\n");
+		dump_printf("problem processing PERF_EVENT_FORK, skipping event.\n");
 		return -1;
 	}
 	total_fork++;
@@ -1022,14 +1018,14 @@ more:
 
 	size = event->header.size;
 
-	dprintf("%p [%p]: event: %d\n",
+	dump_printf("%p [%p]: event: %d\n",
 			(void *)(offset + head),
 			(void *)(long)event->header.size,
 			event->header.type);
 
 	if (!size || process_event(event, offset, head) < 0) {
 
-		dprintf("%p [%p]: skipping unknown header type: %d\n",
+		dump_printf("%p [%p]: skipping unknown header type: %d\n",
 			(void *)(offset + head),
 			(void *)(long)(event->header.size),
 			event->header.type);
@@ -1055,11 +1051,11 @@ more:
 	rc = EXIT_SUCCESS;
 	close(input);
 
-	dprintf("      IP events: %10ld\n", total);
-	dprintf("    mmap events: %10ld\n", total_mmap);
-	dprintf("    comm events: %10ld\n", total_comm);
-	dprintf("    fork events: %10ld\n", total_fork);
-	dprintf(" unknown events: %10ld\n", total_unknown);
+	dump_printf("      IP events: %10ld\n", total);
+	dump_printf("    mmap events: %10ld\n", total_mmap);
+	dump_printf("    comm events: %10ld\n", total_comm);
+	dump_printf("    fork events: %10ld\n", total_fork);
+	dump_printf(" unknown events: %10ld\n", total_unknown);
 
 	if (dump_trace)
 		return 0;
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 3b9d24d..e104ed3 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -43,8 +43,6 @@ static char		*field_sep;
 static int		input;
 static int		show_mask = SHOW_KERNEL | SHOW_USER | SHOW_HV;
 
-static int		dump_trace = 0;
-#define dprintf(x...)	do { if (dump_trace) printf(x); } while (0)
 #define cdprintf(x...)	do { if (dump_trace) color_fprintf(stdout, color, x); } while (0)
 
 static int		full_paths;
@@ -713,8 +711,8 @@ got_map:
 		if ((long long)ip < 0)
 		dso = kernel_dso;
 	}
-	dprintf(" ...... dso: %s\n", dso ? dso->name : "<not found>");
-	dprintf(" ...... map: %Lx -> %Lx\n", *ipp, ip);
+	dump_printf(" ...... dso: %s\n", dso ? dso->name : "<not found>");
+	dump_printf(" ...... map: %Lx -> %Lx\n", *ipp, ip);
 	*ipp  = ip;
 
 	if (dsop)
@@ -1108,7 +1106,7 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 		more_data += sizeof(u64);
 	}
 
-	dprintf("%p [%p]: PERF_EVENT_SAMPLE (IP, %d): %d/%d: %p period: %Ld\n",
+	dump_printf("%p [%p]: PERF_EVENT_SAMPLE (IP, %d): %d/%d: %p period: %Ld\n",
 		(void *)(offset + head),
 		(void *)(long)(event->header.size),
 		event->header.misc,
@@ -1121,7 +1119,7 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 
 		chain = (void *)more_data;
 
-		dprintf("... chain: nr:%Lu\n", chain->nr);
+		dump_printf("... chain: nr:%Lu\n", chain->nr);
 
 		if (validate_chain(chain, event) < 0) {
 			eprintf("call-chain problem with event, skipping it.\n");
@@ -1130,11 +1128,11 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 
 		if (dump_trace) {
 			for (i = 0; i < chain->nr; i++)
-				dprintf("..... %2d: %016Lx\n", i, chain->ips[i]);
+				dump_printf("..... %2d: %016Lx\n", i, chain->ips[i]);
 		}
 	}
 
-	dprintf(" ... thread: %s:%d\n", thread->comm, thread->pid);
+	dump_printf(" ... thread: %s:%d\n", thread->comm, thread->pid);
 
 	if (thread == NULL) {
 		eprintf("problem processing %d event, skipping it.\n",
@@ -1153,7 +1151,7 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 
 		dso = kernel_dso;
 
-		dprintf(" ...... dso: %s\n", dso->name);
+		dump_printf(" ...... dso: %s\n", dso->name);
 
 	} else if (cpumode == PERF_EVENT_MISC_USER) {
 
@@ -1166,7 +1164,7 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 
 		dso = hypervisor_dso;
 
-		dprintf(" ...... dso: [hypervisor]\n");
+		dump_printf(" ...... dso: [hypervisor]\n");
 	}
 
 	if (show & show_mask) {
@@ -1197,7 +1195,7 @@ process_mmap_event(event_t *event, unsigned long offset, unsigned long head)
 
 	thread = threads__findnew(event->mmap.pid, &threads, &last_match);
 
-	dprintf("%p [%p]: PERF_EVENT_MMAP %d/%d: [%p(%p) @ %p]: %s\n",
+	dump_printf("%p [%p]: PERF_EVENT_MMAP %d/%d: [%p(%p) @ %p]: %s\n",
 		(void *)(offset + head),
 		(void *)(long)(event->header.size),
 		event->mmap.pid,
@@ -1208,7 +1206,7 @@ process_mmap_event(event_t *event, unsigned long offset, unsigned long head)
 		event->mmap.filename);
 
 	if (thread == NULL || map == NULL) {
-		dprintf("problem processing PERF_EVENT_MMAP, skipping event.\n");
+		dump_printf("problem processing PERF_EVENT_MMAP, skipping event.\n");
 		return 0;
 	}
 
@@ -1225,14 +1223,14 @@ process_comm_event(event_t *event, unsigned long offset, unsigned long head)
 
 	thread = threads__findnew(event->comm.pid, &threads, &last_match);
 
-	dprintf("%p [%p]: PERF_EVENT_COMM: %s:%d\n",
+	dump_printf("%p [%p]: PERF_EVENT_COMM: %s:%d\n",
 		(void *)(offset + head),
 		(void *)(long)(event->header.size),
 		event->comm.comm, event->comm.pid);
 
 	if (thread == NULL ||
 	    thread__set_comm(thread, event->comm.comm)) {
-		dprintf("problem processing PERF_EVENT_COMM, skipping event.\n");
+		dump_printf("problem processing PERF_EVENT_COMM, skipping event.\n");
 		return -1;
 	}
 	total_comm++;
@@ -1249,7 +1247,7 @@ process_task_event(event_t *event, unsigned long offset, unsigned long head)
 	thread = threads__findnew(event->fork.pid, &threads, &last_match);
 	parent = threads__findnew(event->fork.ppid, &threads, &last_match);
 
-	dprintf("%p [%p]: PERF_EVENT_%s: (%d:%d):(%d:%d)\n",
+	dump_printf("%p [%p]: PERF_EVENT_%s: (%d:%d):(%d:%d)\n",
 		(void *)(offset + head),
 		(void *)(long)(event->header.size),
 		event->header.type == PERF_EVENT_FORK ? "FORK" : "EXIT",
@@ -1267,7 +1265,7 @@ process_task_event(event_t *event, unsigned long offset, unsigned long head)
 		return 0;
 
 	if (!thread || !parent || thread__fork(thread, parent)) {
-		dprintf("problem processing PERF_EVENT_FORK, skipping event.\n");
+		dump_printf("problem processing PERF_EVENT_FORK, skipping event.\n");
 		return -1;
 	}
 	total_fork++;
@@ -1278,7 +1276,7 @@ process_task_event(event_t *event, unsigned long offset, unsigned long head)
 static int
 process_lost_event(event_t *event, unsigned long offset, unsigned long head)
 {
-	dprintf("%p [%p]: PERF_EVENT_LOST: id:%Ld: lost:%Ld\n",
+	dump_printf("%p [%p]: PERF_EVENT_LOST: id:%Ld: lost:%Ld\n",
 		(void *)(offset + head),
 		(void *)(long)(event->header.size),
 		event->lost.id,
@@ -1298,12 +1296,12 @@ static void trace_event(event_t *event)
 	if (!dump_trace)
 		return;
 
-	dprintf(".");
+	dump_printf(".");
 	cdprintf("\n. ... raw event: size %d bytes\n", event->header.size);
 
 	for (i = 0; i < event->header.size; i++) {
 		if ((i & 15) == 0) {
-			dprintf(".");
+			dump_printf(".");
 			cdprintf("  %04x: ", i);
 		}
 
@@ -1322,7 +1320,7 @@ static void trace_event(event_t *event)
 			cdprintf("\n");
 		}
 	}
-	dprintf(".\n");
+	dump_printf(".\n");
 }
 
 static struct perf_header	*header;
@@ -1359,7 +1357,7 @@ process_read_event(event_t *event, unsigned long offset, unsigned long head)
 					   event->read.value);
 	}
 
-	dprintf("%p [%p]: PERF_EVENT_READ: %d %d %s %Lu\n",
+	dump_printf("%p [%p]: PERF_EVENT_READ: %d %d %s %Lu\n",
 			(void *)(offset + head),
 			(void *)(long)(event->header.size),
 			event->read.pid,
@@ -1540,14 +1538,14 @@ more:
 
 	size = event->header.size;
 
-	dprintf("\n%p [%p]: event: %d\n",
+	dump_printf("\n%p [%p]: event: %d\n",
 			(void *)(offset + head),
 			(void *)(long)event->header.size,
 			event->header.type);
 
 	if (!size || process_event(event, offset, head) < 0) {
 
-		dprintf("%p [%p]: skipping unknown header type: %d\n",
+		dump_printf("%p [%p]: skipping unknown header type: %d\n",
 			(void *)(offset + head),
 			(void *)(long)(event->header.size),
 			event->header.type);
@@ -1577,12 +1575,12 @@ done:
 	rc = EXIT_SUCCESS;
 	close(input);
 
-	dprintf("      IP events: %10ld\n", total);
-	dprintf("    mmap events: %10ld\n", total_mmap);
-	dprintf("    comm events: %10ld\n", total_comm);
-	dprintf("    fork events: %10ld\n", total_fork);
-	dprintf("    lost events: %10ld\n", total_lost);
-	dprintf(" unknown events: %10ld\n", total_unknown);
+	dump_printf("      IP events: %10ld\n", total);
+	dump_printf("    mmap events: %10ld\n", total_mmap);
+	dump_printf("    comm events: %10ld\n", total_comm);
+	dump_printf("    fork events: %10ld\n", total_fork);
+	dump_printf("    lost events: %10ld\n", total_lost);
+	dump_printf(" unknown events: %10ld\n", total_unknown);
 
 	if (dump_trace)
 		return 0;
diff --git a/tools/perf/util/debug.c b/tools/perf/util/debug.c
index 7cb8464..8318fde 100644
--- a/tools/perf/util/debug.c
+++ b/tools/perf/util/debug.c
@@ -6,6 +6,7 @@
 #include <stdio.h>
 
 int verbose = 0;
+int dump_trace = 0;
 
 int eprintf(const char *fmt, ...)
 {
@@ -20,3 +21,17 @@ int eprintf(const char *fmt, ...)
 
 	return ret;
 }
+
+int dump_printf(const char *fmt, ...)
+{
+	va_list args;
+	int ret = 0;
+
+	if (dump_trace) {
+		va_start(args, fmt);
+		ret = vprintf(fmt, args);
+		va_end(args);
+	}
+
+	return ret;
+}
diff --git a/tools/perf/util/debug.h b/tools/perf/util/debug.h
index 2ae9090..a683bd5 100644
--- a/tools/perf/util/debug.h
+++ b/tools/perf/util/debug.h
@@ -1,5 +1,7 @@
 /* For debugging general purposes */
 
 extern int verbose;
+extern int dump_trace;
 
 int eprintf(const char *fmt, ...) __attribute__((format(printf, 1, 2)));
+int dump_printf(const char *fmt, ...) __attribute__((format(printf, 1, 2)));
