Return-Path: <linux-kernel-owner+w=401wt.eu-S1752744AbZEYLE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744AbZEYLE1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 07:04:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751713AbZEYLET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 07:04:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:55561 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751313AbZEYLES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 07:04:18 -0400
Date: Mon, 25 May 2009 11:03:32 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf top: Reduce display overhead
Message-ID: <tip-d94b943054721c346b0881865d645f000cd19880@git.kernel.org>
Git-Commit-ID: d94b943054721c346b0881865d645f000cd19880
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 25 May 2009 11:03:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d94b943054721c346b0881865d645f000cd19880
Gitweb:     http://git.kernel.org/tip/d94b943054721c346b0881865d645f000cd19880
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Mon, 25 May 2009 09:57:56 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 25 May 2009 13:01:17 +0200

perf top: Reduce display overhead

Iterate over the symbol table once per display interval, and
copy/sort/tally/decay only those symbols which are active.

Before:

 top - 10:14:53 up  4:08, 17 users,  load average: 1.17, 1.53, 1.49
 Tasks: 273 total,   5 running, 268 sleeping,   0 stopped,   0 zombie
 Cpu(s):  6.9%us, 38.2%sy,  0.0%ni, 19.9%id,  0.0%wa,  0.0%hi, 35.0%si,  0.0%st

   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  P COMMAND
 28504 root      20   0  1044  260  164 S   58  0.0   0:04.19 2 netserver
 28499 root      20   0  1040  412  316 R   51  0.0   0:04.15 0 netperf
 28500 root      20   0  1040  408  316 R   50  0.0   0:04.14 1 netperf
 28503 root      20   0  1044  260  164 S   50  0.0   0:04.01 1 netserver
 28501 root      20   0  1044  260  164 S   49  0.0   0:03.99 0 netserver
 28502 root      20   0  1040  412  316 S   43  0.0   0:03.96 2 netperf
 28468 root      20   0 1892m 325m  972 S   16 10.8   0:10.50 3 perf
 28467 root      20   0 1892m 325m  972 R    2 10.8   0:00.72 3 perf

After:

 top - 10:16:30 up  4:10, 17 users,  load average: 2.27, 1.88, 1.62
 Tasks: 273 total,   6 running, 267 sleeping,   0 stopped,   0 zombie
 Cpu(s):  2.5%us, 39.7%sy,  0.0%ni, 24.6%id,  0.0%wa,  0.0%hi, 33.3%si,  0.0%st

   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  P COMMAND
 28590 root      20   0  1040  412  316 S   54  0.0   0:07.85 2 netperf
 28589 root      20   0  1044  260  164 R   54  0.0   0:07.84 0 netserver
 28588 root      20   0  1040  412  316 R   50  0.0   0:07.89 1 netperf
 28591 root      20   0  1044  256  164 S   50  0.0   0:07.82 1 netserver
 28587 root      20   0  1040  408  316 R   47  0.0   0:07.61 0 netperf
 28592 root      20   0  1044  260  164 R   47  0.0   0:07.85 2 netserver
 28378 root      20   0  8732 1300  860 R    2  0.0   0:01.81 3 top
 28577 root      20   0 1892m 165m  972 R    2  5.5   0:00.48 3 perf
 28578 root      20   0 1892m 165m  972 S    2  5.5   0:00.04 3 perf

[ Impact: optimization ]

Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-top.c |   56 +++++++++++++++--------------
 1 files changed, 29 insertions(+), 27 deletions(-)

diff --git a/Documentation/perf_counter/builtin-top.c b/Documentation/perf_counter/builtin-top.c
index 74021ac..4bed265 100644
--- a/Documentation/perf_counter/builtin-top.c
+++ b/Documentation/perf_counter/builtin-top.c
@@ -374,18 +374,26 @@ static struct sym_entry		tmp[MAX_SYMS];
 
 static void print_sym_table(void)
 {
-	int i, printed;
+	int i, j, active_count, printed;
 	int counter;
 	float events_per_sec = events/delay_secs;
 	float kevents_per_sec = (events-userspace_events)/delay_secs;
 	float sum_kevents = 0.0;
 
 	events = userspace_events = 0;
-	memcpy(tmp, sym_table, sizeof(sym_table[0])*sym_table_count);
-	qsort(tmp, sym_table_count, sizeof(tmp[0]), compare);
 
-	for (i = 0; i < sym_table_count && tmp[i].count[0]; i++)
-		sum_kevents += tmp[i].count[0];
+	/* Iterate over symbol table and copy/tally/decay active symbols. */
+	for (i = 0, active_count = 0; i < sym_table_count; i++) {
+		if (sym_table[i].count[0]) {
+			tmp[active_count++] = sym_table[i];
+			sum_kevents += sym_table[i].count[0];
+
+			for (j = 0; j < nr_counters; j++)
+				sym_table[i].count[j] = zero ? 0 : sym_table[i].count[j] * 7 / 8;
+		}
+	}
+
+	qsort(tmp, active_count + 1, sizeof(tmp[0]), compare);
 
 	write(1, CONSOLE_CLEAR, strlen(CONSOLE_CLEAR));
 
@@ -433,29 +441,23 @@ static void print_sym_table(void)
 	       	       "  ______     ______   _____   ________________   _______________\n\n"
 	);
 
-	for (i = 0, printed = 0; i < sym_table_count; i++) {
+	for (i = 0, printed = 0; i < active_count; i++) {
 		float pcnt;
-		int count;
 
-		if (printed <= 18 && tmp[i].count[0] >= count_filter) {
-			pcnt = 100.0 - (100.0*((sum_kevents-tmp[i].count[0])/sum_kevents));
-
-			if (nr_counters == 1)
-				printf("%19.2f - %4.1f%% - %016llx : %s\n",
-					sym_weight(tmp + i),
-					pcnt, tmp[i].addr, tmp[i].sym);
-			else
-				printf("%8.1f %10ld - %4.1f%% - %016llx : %s\n",
-					sym_weight(tmp + i),
-					tmp[i].count[0],
-					pcnt, tmp[i].addr, tmp[i].sym);
-			printed++;
-		}
-		/*
-		 * Add decay to the counts:
-		 */
-		for (count = 0; count < nr_counters; count++)
-			sym_table[i].count[count] = zero ? 0 : sym_table[i].count[count] * 7 / 8;
+		if (++printed > 18 || tmp[i].count[0] < count_filter)
+			break;
+
+		pcnt = 100.0 - (100.0*((sum_kevents-tmp[i].count[0])/sum_kevents));
+
+		if (nr_counters == 1)
+			printf("%19.2f - %4.1f%% - %016llx : %s\n",
+				sym_weight(tmp + i),
+				pcnt, tmp[i].addr, tmp[i].sym);
+		else
+			printf("%8.1f %10ld - %4.1f%% - %016llx : %s\n",
+				sym_weight(tmp + i),
+				tmp[i].count[0],
+				pcnt, tmp[i].addr, tmp[i].sym);
 	}
 
 	if (sym_filter_entry)
