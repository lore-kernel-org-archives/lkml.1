Return-Path: <linux-kernel-owner+w=401wt.eu-S1752726AbZJLF4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726AbZJLF4y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 01:56:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751732AbZJLF4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 01:56:53 -0400
Received: from mail.gmx.net ([213.165.64.20]:38248 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751469AbZJLF4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 01:56:52 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/QxYRHY5jQgesG0F+2x/TIueAdG++mLdrCo8ztxd
	Rq2GOIxoLNkNAC
Subject: [patch] perf_counter tools: fix counter sample frequency breakage
From: Mike Galbraith <efault@gmx.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arjan van de Ven <arjan@infradead.org>
Content-Type: text/plain
Date: Mon, 12 Oct 2009 07:56:03 +0200
Message-Id: <1255326963.15107.2.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


perf_counter tools: fix counter sample frequency breakage

Commit 42e59d7d19dc4b4 switched to a default sample frequency of 1KHz, which
overrides any user supplied count, causing sched, top and timechart to miss
events due to their discrete event counters being flagged PERF_SAMPLE_PERIOD.

Override default sample frequency when the user profides a count, and make both
record and top honor that user supplied option.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arjan van de Ven <arjan@infradead.org>
LKML-Reference: <new-submission>

---
 tools/perf/builtin-record.c |   14 +++++++++++++-
 tools/perf/builtin-top.c    |   28 +++++++++++++++++++++-------
 2 files changed, 34 insertions(+), 8 deletions(-)

Index: linux-2.6/tools/perf/builtin-record.c
===================================================================
--- linux-2.6.orig/tools/perf/builtin-record.c
+++ linux-2.6/tools/perf/builtin-record.c
@@ -26,7 +26,7 @@
 
 static int			fd[MAX_NR_CPUS][MAX_COUNTERS];
 
-static long			default_interval		= 100000;
+static long			default_interval		=      0;
 
 static int			nr_cpus				=      0;
 static unsigned int		page_size;
@@ -730,6 +730,18 @@ int cmd_record(int argc, const char **ar
 		attrs[0].config = PERF_COUNT_HW_CPU_CYCLES;
 	}
 
+	/*
+	 * User specified count overrides default frequency.
+	 */
+	if (default_interval)
+		freq = 0;
+	else if (freq) {
+		default_interval = freq;
+	} else {
+		fprintf(stderr, "frequency and count are zero, aborting\n");
+		exit(EXIT_FAILURE);
+	}
+
 	for (counter = 0; counter < nr_counters; counter++) {
 		if (attrs[counter].sample_period)
 			continue;
Index: linux-2.6/tools/perf/builtin-top.c
===================================================================
--- linux-2.6.orig/tools/perf/builtin-top.c
+++ linux-2.6/tools/perf/builtin-top.c
@@ -57,7 +57,7 @@ static int			fd[MAX_NR_CPUS][MAX_COUNTER
 
 static int			system_wide			=      0;
 
-static int			default_interval		= 100000;
+static int			default_interval		=      0;
 
 static int			count_filter			=      5;
 static int			print_entries			=     15;
@@ -975,7 +975,13 @@ static void start_counter(int i, int cou
 	attr = attrs + counter;
 
 	attr->sample_type	= PERF_SAMPLE_IP | PERF_SAMPLE_TID;
-	attr->freq		= freq;
+
+	if (freq) {
+		attr->sample_type	|= PERF_SAMPLE_PERIOD;
+		attr->freq		= 1;
+		attr->sample_freq	= freq;
+	}
+
 	attr->inherit		= (cpu < 0) && inherit;
 
 try_again:
@@ -1130,11 +1136,6 @@ int cmd_top(int argc, const char **argv,
 	if (argc)
 		usage_with_options(top_usage, options);
 
-	if (freq) {
-		default_interval = freq;
-		freq = 1;
-	}
-
 	/* CPU and PID are mutually exclusive */
 	if (target_pid != -1 && profile_cpu != -1) {
 		printf("WARNING: PID switch overriding CPU\n");
@@ -1151,6 +1152,19 @@ int cmd_top(int argc, const char **argv,
 	parse_symbols();
 	parse_source(sym_filter_entry);
 
+
+	/*
+	 * User specified count overrides default frequency.
+	 */
+	if (default_interval)
+		freq = 0;
+	else if (freq) {
+		default_interval = freq;
+	} else {
+		fprintf(stderr, "frequency and count are zero, aborting\n");
+		exit(EXIT_FAILURE);
+	}
+
 	/*
 	 * Fill in the ones not specifically initialized via -c:
 	 */


