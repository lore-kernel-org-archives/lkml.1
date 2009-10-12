Return-Path: <linux-kernel-owner+w=401wt.eu-S1754496AbZJLHOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496AbZJLHOS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 03:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754471AbZJLHOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 03:14:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:36899 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754443AbZJLHOP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 03:14:15 -0400
Date: Mon, 12 Oct 2009 07:12:45 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, arjan@infradead.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, arjan@infradead.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1255326963.15107.2.camel@marge.simson.net>
References: <1255326963.15107.2.camel@marge.simson.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fix counter sample frequency breakage
Message-ID: <tip-7e4ff9e3e8f88de8a8536f43294cd32b4e7d9123@git.kernel.org>
Git-Commit-ID: 7e4ff9e3e8f88de8a8536f43294cd32b4e7d9123
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 12 Oct 2009 07:12:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7e4ff9e3e8f88de8a8536f43294cd32b4e7d9123
Gitweb:     http://git.kernel.org/tip/7e4ff9e3e8f88de8a8536f43294cd32b4e7d9123
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Mon, 12 Oct 2009 07:56:03 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 12 Oct 2009 09:10:55 +0200

perf tools: Fix counter sample frequency breakage

Commit 42e59d7d19dc4b4 switched to a default sample frequency of
1KHz, which overrides any user supplied count, causing sched, top
and timechart to miss events due to their discrete events
being flagged PERF_SAMPLE_PERIOD.

Override default sample frequency when the user profides a
period count, and make both record and top honor that user
supplied option.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arjan van de Ven <arjan@infradead.org>
LKML-Reference: <1255326963.15107.2.camel@marge.simson.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-record.c |   14 +++++++++++++-
 tools/perf/builtin-top.c    |   28 +++++++++++++++++++++-------
 2 files changed, 34 insertions(+), 8 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 59af03d..4e3a374 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -26,7 +26,7 @@
 
 static int			fd[MAX_NR_CPUS][MAX_COUNTERS];
 
-static long			default_interval		= 100000;
+static long			default_interval		=      0;
 
 static int			nr_cpus				=      0;
 static unsigned int		page_size;
@@ -730,6 +730,18 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
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
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index d978dc9..c0f69e8 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -57,7 +57,7 @@ static int			fd[MAX_NR_CPUS][MAX_COUNTERS];
 
 static int			system_wide			=      0;
 
-static int			default_interval		= 100000;
+static int			default_interval		=      0;
 
 static int			count_filter			=      5;
 static int			print_entries			=     15;
@@ -975,7 +975,13 @@ static void start_counter(int i, int counter)
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
@@ -1130,11 +1136,6 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
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
@@ -1151,6 +1152,19 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
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
