Return-Path: <linux-kernel-owner+w=401wt.eu-S1758642AbZE2JCC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758642AbZE2JCC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 05:02:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758625AbZE2JBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 05:01:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:59609 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758616AbZE2JBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 05:01:49 -0400
Date: Fri, 29 May 2009 09:01:09 GMT
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
Subject: [tip:perfcounters/core] perf_counter tools: Also display time-normalized stat results
Message-ID: <tip-be1ac0d81d0e3ab655f8c8ade31fb860ef6aa186@git.kernel.org>
Git-Commit-ID: be1ac0d81d0e3ab655f8c8ade31fb860ef6aa186
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 29 May 2009 09:01:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  be1ac0d81d0e3ab655f8c8ade31fb860ef6aa186
Gitweb:     http://git.kernel.org/tip/be1ac0d81d0e3ab655f8c8ade31fb860ef6aa186
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Fri, 29 May 2009 09:10:54 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 29 May 2009 09:46:45 +0200

perf_counter tools: Also display time-normalized stat results

Add new column that normalizes counter results by
'nanoseconds spent running' unit.

Before:

 Performance counter stats for '/home/mingo/hackbench':

   10469.403605  task clock ticks     (msecs)
          75502  context switches     (events)
           9501  CPU migrations       (events)
          36158  pagefaults           (events)
    31975676185  CPU cycles           (events)
    26257738659  instructions         (events)
      108740581  cache references     (events)
       54606088  cache misses         (events)

 Wall-clock time elapsed:   810.514504 msecs

After:

 Performance counter stats for '/home/mingo/hackbench':

   10469.403605  task clock ticks     (msecs)
          75502  context switches     #        0.007 M/sec
           9501  CPU migrations       #        0.001 M/sec
          36158  pagefaults           #        0.003 M/sec
    31975676185  CPU cycles           #     3054.202 M/sec
    26257738659  instructions         #     2508.045 M/sec
      108740581  cache references     #       10.387 M/sec
       54606088  cache misses         #        5.216 M/sec

 Wall-clock time elapsed:   810.514504 msecs

The advantage of that column is that it is characteristic of the
execution workflow, regardless of runtime. Hence 'hackbench 10'
will look similar to 'hackbench 15' - while the absolute counter
values are very different.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-stat.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/Documentation/perf_counter/builtin-stat.c b/Documentation/perf_counter/builtin-stat.c
index 0c92eb7..ef7e0e1 100644
--- a/Documentation/perf_counter/builtin-stat.c
+++ b/Documentation/perf_counter/builtin-stat.c
@@ -74,6 +74,8 @@ static const unsigned int default_count[] = {
 static __u64			event_res[MAX_COUNTERS][3];
 static __u64			event_scaled[MAX_COUNTERS];
 
+static __u64			runtime_nsecs;
+
 static void create_perfstat_counter(int counter)
 {
 	struct perf_counter_hw_event hw_event;
@@ -165,6 +167,11 @@ static void read_counter(int counter)
 				((double)count[0] * count[1] / count[2] + 0.5);
 		}
 	}
+	/*
+	 * Save the full runtime - to allow normalization during printout:
+	 */
+	if (event_id[counter] == EID(PERF_TYPE_SOFTWARE, PERF_COUNT_TASK_CLOCK))
+		runtime_nsecs = count[0];
 }
 
 /*
@@ -190,8 +197,11 @@ static void print_counter(int counter)
 		fprintf(stderr, " %14.6f  %-20s (msecs)",
 			msecs, event_name(counter));
 	} else {
-		fprintf(stderr, " %14Ld  %-20s (events)",
+		fprintf(stderr, " %14Ld  %-20s",
 			count[0], event_name(counter));
+		if (runtime_nsecs)
+			fprintf(stderr, " # %12.3f M/sec",
+				(double)count[0]/runtime_nsecs*1000.0);
 	}
 	if (scaled)
 		fprintf(stderr, "  (scaled from %.2f%%)",
