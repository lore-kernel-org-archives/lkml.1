Return-Path: <linux-kernel-owner+w=401wt.eu-S1762642AbZFNSh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762642AbZFNSh3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 14:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757899AbZFNShU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 14:37:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:55089 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756368AbZFNShT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 14:37:19 -0400
Date: Sun, 14 Jun 2009 18:36:32 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       penberg@cs.helsinki.fi, efault@gmx.de, arjan@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, penberg@cs.helsinki.fi,
       a.p.zijlstra@chello.nl, efault@gmx.de, arjan@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf record/report: Add call graph / call chain profiling
Message-ID: <tip-3efa1cc99ec51bc7a7ae0011a16619fd20dbe6ea@git.kernel.org>
Git-Commit-ID: 3efa1cc99ec51bc7a7ae0011a16619fd20dbe6ea
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 14 Jun 2009 18:36:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3efa1cc99ec51bc7a7ae0011a16619fd20dbe6ea
Gitweb:     http://git.kernel.org/tip/3efa1cc99ec51bc7a7ae0011a16619fd20dbe6ea
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Sun, 14 Jun 2009 15:04:15 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 14 Jun 2009 20:34:06 +0200

perf record/report: Add call graph / call chain profiling

Add the first steps of call-graph profiling:

 - add the -c (--call-graph) option to perf record
 - parse the call-graph record and printout out under -D (--dump-trace)

The call-graph data is not put into the histogram yet, but it
can be seen that it's being processed correctly:

0x3ce0 [0x38]: event: 35
.
. ... raw event: size 56 bytes
.  0000:  23 00 00 00 05 00 38 00 d4 df 0e 81 ff ff ff ff  #.....8........
.  0010:  60 0b 00 00 60 0b 00 00 03 00 00 00 01 00 02 00  `...`..........
.  0020:  d4 df 0e 81 ff ff ff ff a0 61 ed 41 36 00 00 00  .........a.A6..
.  0030:  04 92 e6 41 36 00 00 00                          .a.A6..
.
0x3ce0 [0x38]: PERF_EVENT (IP, 5): 2912: 0xffffffff810edfd4 period: 1
... chain: u:2, k:1, nr:3
.....  0: 0xffffffff810edfd4
.....  1: 0x3641ed61a0
.....  2: 0x3641e69204
 ... thread: perf:2912
 ...... dso: [kernel]

This shows a 3-entry call-graph: with 1 kernel-space and two user-space
entries

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-record.c |    8 ++++++
 tools/perf/builtin-report.c |   57 ++++++++++++++++++++++++++++++++++---------
 2 files changed, 53 insertions(+), 12 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 0f5771f..a177a59 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -37,6 +37,7 @@ static pid_t			target_pid			= -1;
 static int			inherit				= 1;
 static int			force				= 0;
 static int			append_file			= 0;
+static int			call_graph			= 0;
 static int			verbose				= 0;
 
 static long			samples;
@@ -351,11 +352,16 @@ static void create_counter(int counter, int cpu, pid_t pid)
 	int track = 1;
 
 	attr->sample_type	= PERF_SAMPLE_IP | PERF_SAMPLE_TID;
+
 	if (freq) {
 		attr->sample_type	|= PERF_SAMPLE_PERIOD;
 		attr->freq		= 1;
 		attr->sample_freq	= freq;
 	}
+
+	if (call_graph)
+		attr->sample_type	|= PERF_SAMPLE_CALLCHAIN;
+
 	attr->mmap		= track;
 	attr->comm		= track;
 	attr->inherit		= (cpu < 0) && inherit;
@@ -555,6 +561,8 @@ static const struct option options[] = {
 		    "profile at this frequency"),
 	OPT_INTEGER('m', "mmap-pages", &mmap_pages,
 		    "number of mmap data pages"),
+	OPT_BOOLEAN('g', "call-graph", &call_graph,
+		    "do call-graph (stack chain/backtrace) recording"),
 	OPT_BOOLEAN('v', "verbose", &verbose,
 		    "be more verbose (show counter open errors, etc)"),
 	OPT_END()
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 37515da..aebba56 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -36,6 +36,7 @@ static int		show_mask = SHOW_KERNEL | SHOW_USER | SHOW_HV;
 
 static int		dump_trace = 0;
 #define dprintf(x...)	do { if (dump_trace) printf(x); } while (0)
+#define cdprintf(x...)	do { if (dump_trace) color_fprintf(stdout, color, x); } while (0)
 
 static int		verbose;
 static int		full_paths;
@@ -43,11 +44,19 @@ static int		full_paths;
 static unsigned long	page_size;
 static unsigned long	mmap_window = 32;
 
+struct ip_chain_event {
+	__u16 nr;
+	__u16 hv;
+	__u16 kernel;
+	__u16 user;
+	__u64 ips[];
+};
+
 struct ip_event {
 	struct perf_event_header header;
 	__u64 ip;
 	__u32 pid, tid;
-	__u64 period;
+	unsigned char __more_data[];
 };
 
 struct mmap_event {
@@ -944,9 +953,13 @@ process_overflow_event(event_t *event, unsigned long offset, unsigned long head)
 	__u64 ip = event->ip.ip;
 	__u64 period = 1;
 	struct map *map = NULL;
+	void *more_data = event->ip.__more_data;
+	struct ip_chain_event *chain;
 
-	if (event->header.type & PERF_SAMPLE_PERIOD)
-		period = event->ip.period;
+	if (event->header.type & PERF_SAMPLE_PERIOD) {
+		period = *(__u64 *)more_data;
+		more_data += sizeof(__u64);
+	}
 
 	dprintf("%p [%p]: PERF_EVENT (IP, %d): %d: %p period: %Ld\n",
 		(void *)(offset + head),
@@ -956,6 +969,22 @@ process_overflow_event(event_t *event, unsigned long offset, unsigned long head)
 		(void *)(long)ip,
 		(long long)period);
 
+	if (event->header.type & PERF_SAMPLE_CALLCHAIN) {
+		int i;
+
+		chain = (void *)more_data;
+
+		if (dump_trace) {
+			dprintf("... chain: u:%d, k:%d, nr:%d\n",
+				chain->user,
+				chain->kernel,
+				chain->nr);
+
+			for (i = 0; i < chain->nr; i++)
+				dprintf("..... %2d: %p\n", i, (void *)chain->ips[i]);
+		}
+	}
+
 	dprintf(" ... thread: %s:%d\n", thread->comm, thread->pid);
 
 	if (thread == NULL) {
@@ -1098,30 +1127,34 @@ process_period_event(event_t *event, unsigned long offset, unsigned long head)
 static void trace_event(event_t *event)
 {
 	unsigned char *raw_event = (void *)event;
+	char *color = PERF_COLOR_BLUE;
 	int i, j;
 
 	if (!dump_trace)
 		return;
 
-	dprintf(".\n. ... raw event: size %d bytes\n", event->header.size);
+	dprintf(".");
+	cdprintf("\n. ... raw event: size %d bytes\n", event->header.size);
 
 	for (i = 0; i < event->header.size; i++) {
-		if ((i & 15) == 0)
-			dprintf(".  %04x: ", i);
+		if ((i & 15) == 0) {
+			dprintf(".");
+			cdprintf("  %04x: ", i);
+		}
 
-		dprintf(" %02x", raw_event[i]);
+		cdprintf(" %02x", raw_event[i]);
 
 		if (((i & 15) == 15) || i == event->header.size-1) {
-			dprintf("  ");
+			cdprintf("  ");
 			for (j = 0; j < 15-(i & 15); j++)
-				dprintf("   ");
+				cdprintf("   ");
 			for (j = 0; j < (i & 15); j++) {
 				if (isprint(raw_event[i-15+j]))
-					dprintf("%c", raw_event[i-15+j]);
+					cdprintf("%c", raw_event[i-15+j]);
 				else
-					dprintf(".");
+					cdprintf(".");
 			}
-			dprintf("\n");
+			cdprintf("\n");
 		}
 	}
 	dprintf(".\n");
