Return-Path: <linux-kernel-owner+w=401wt.eu-S1755084AbZFGRWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084AbZFGRWX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 13:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751680AbZFGRWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 13:22:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:34208 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753046AbZFGRWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 13:22:16 -0400
Date: Sun, 7 Jun 2009 17:21:32 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf stat: Print out instructins/cycle metric
Message-ID: <tip-e779898aa74cd2e97216368b3f3689ceffe8aeed@git.kernel.org>
Git-Commit-ID: e779898aa74cd2e97216368b3f3689ceffe8aeed
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 07 Jun 2009 17:21:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e779898aa74cd2e97216368b3f3689ceffe8aeed
Gitweb:     http://git.kernel.org/tip/e779898aa74cd2e97216368b3f3689ceffe8aeed
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Sun, 7 Jun 2009 18:14:46 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 7 Jun 2009 18:14:46 +0200

perf stat: Print out instructins/cycle metric

Before:

     7549326754  cycles               #    3201.811 M/sec
    10007594937  instructions         #    4244.408 M/sec

After:

     7542051194  cycles               #    3201.996 M/sec
    10007743852  instructions         #    4248.811 M/sec # 1.327 per cycle

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-stat.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 184ff95..8085509 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -83,6 +83,7 @@ static __u64			event_scaled[MAX_COUNTERS];
 
 static __u64			runtime_nsecs;
 static __u64			walltime_nsecs;
+static __u64			runtime_cycles;
 
 static void create_perf_stat_counter(int counter)
 {
@@ -177,6 +178,9 @@ static void read_counter(int counter)
 	if (attrs[counter].type == PERF_TYPE_SOFTWARE &&
 		attrs[counter].config == PERF_COUNT_TASK_CLOCK)
 		runtime_nsecs = count[0];
+	if (attrs[counter].type == PERF_TYPE_HARDWARE &&
+		attrs[counter].config == PERF_COUNT_CPU_CYCLES)
+		runtime_cycles = count[0];
 }
 
 /*
@@ -214,6 +218,13 @@ static void print_counter(int counter)
 		if (runtime_nsecs)
 			fprintf(stderr, " # %11.3f M/sec",
 				(double)count[0]/runtime_nsecs*1000.0);
+		if (runtime_cycles &&
+			attrs[counter].type == PERF_TYPE_HARDWARE &&
+				attrs[counter].config == PERF_COUNT_INSTRUCTIONS) {
+
+			fprintf(stderr, " # %1.3f per cycle",
+				(double)count[0] / (double)runtime_cycles);
+		}
 	}
 	if (scaled)
 		fprintf(stderr, "  (scaled from %.2f%%)",
