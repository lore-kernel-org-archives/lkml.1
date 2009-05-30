Return-Path: <linux-kernel-owner+w=401wt.eu-S1762953AbZE3Lqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762953AbZE3Lqm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 07:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761119AbZE3Lqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 07:46:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:47908 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760978AbZE3Lqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 07:46:32 -0400
Date: Sat, 30 May 2009 11:45:36 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, mtosatti@redhat.com,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, mtosatti@redhat.com, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter tools: Print 'CPU utilization factor' in builtin-stat
Message-ID: <tip-d7c29318c2daa96d64b7312afd8283488c1cb29f@git.kernel.org>
Git-Commit-ID: d7c29318c2daa96d64b7312afd8283488c1cb29f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 30 May 2009 11:45:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d7c29318c2daa96d64b7312afd8283488c1cb29f
Gitweb:     http://git.kernel.org/tip/d7c29318c2daa96d64b7312afd8283488c1cb29f
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Sat, 30 May 2009 12:38:51 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 30 May 2009 12:41:12 +0200

perf_counter tools: Print 'CPU utilization factor' in builtin-stat

Before:

 Performance counter stats for '/home/mingo/hackbench':

    5728.862689  task clock ticks     (msecs)
          34426  context switches     #        0.006 M/sec
           3835  CPU migrations       #        0.001 M/sec
          18158  pagefaults           #        0.003 M/sec
    16218109156  CPU cycles           #     2830.947 M/sec
    13519616840  instructions         #     2359.913 M/sec
       55941661  cache references     #        9.765 M/sec
       23554938  cache misses         #        4.112 M/sec

 Wall-clock time elapsed:   528.886980 msecs

After:

 Performance counter stats for '/home/mingo/hackbench':

    5845.443541  task clock ticks     #      11.886 CPU utilization factor
          38289  context switches     #       0.007 M/sec
           4208  CPU migrations       #       0.001 M/sec
          17755  pagefaults           #       0.003 M/sec
    16664668576  CPU cycles           #    2850.882 M/sec
    13468113991  instructions         #    2304.036 M/sec
       57445468  cache references     #       9.827 M/sec
       26896502  cache misses         #       4.601 M/sec

 Wall-clock time elapsed:   491.802357 msecs

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-stat.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/Documentation/perf_counter/builtin-stat.c b/Documentation/perf_counter/builtin-stat.c
index ef7e0e1..5886791 100644
--- a/Documentation/perf_counter/builtin-stat.c
+++ b/Documentation/perf_counter/builtin-stat.c
@@ -75,6 +75,7 @@ static __u64			event_res[MAX_COUNTERS][3];
 static __u64			event_scaled[MAX_COUNTERS];
 
 static __u64			runtime_nsecs;
+static __u64			walltime_nsecs;
 
 static void create_perfstat_counter(int counter)
 {
@@ -194,13 +195,19 @@ static void print_counter(int counter)
 	if (nsec_counter(counter)) {
 		double msecs = (double)count[0] / 1000000;
 
-		fprintf(stderr, " %14.6f  %-20s (msecs)",
+		fprintf(stderr, " %14.6f  %-20s",
 			msecs, event_name(counter));
+		if (event_id[counter] ==
+				EID(PERF_TYPE_SOFTWARE, PERF_COUNT_TASK_CLOCK)) {
+
+			fprintf(stderr, " # %11.3f CPU utilization factor",
+				(double)count[0] / (double)walltime_nsecs);
+		}
 	} else {
 		fprintf(stderr, " %14Ld  %-20s",
 			count[0], event_name(counter));
 		if (runtime_nsecs)
-			fprintf(stderr, " # %12.3f M/sec",
+			fprintf(stderr, " # %11.3f M/sec",
 				(double)count[0]/runtime_nsecs*1000.0);
 	}
 	if (scaled)
@@ -241,6 +248,8 @@ static int do_perfstat(int argc, const char **argv)
 	prctl(PR_TASK_PERF_COUNTERS_DISABLE);
 	t1 = rdclock();
 
+	walltime_nsecs = t1 - t0;
+
 	fflush(stdout);
 
 	fprintf(stderr, "\n");
