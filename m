Return-Path: <linux-kernel-owner+w=401wt.eu-S932098AbZJSLsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098AbZJSLsR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 07:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754160AbZJSLsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 07:48:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:53463 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752598AbZJSLsL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 07:48:11 -0400
Date: Mon, 19 Oct 2009 11:47:33 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       tim@klingt.org, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, tim@klingt.org, mingo@elte.hu
In-Reply-To: <4ADC3975.8050109@klingt.org>
References: <4ADC3975.8050109@klingt.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf stat: Count branches first
Message-ID: <tip-dd86e72abdbc4b436471af5a97927c6145f5298c@git.kernel.org>
Git-Commit-ID: dd86e72abdbc4b436471af5a97927c6145f5298c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 19 Oct 2009 11:47:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dd86e72abdbc4b436471af5a97927c6145f5298c
Gitweb:     http://git.kernel.org/tip/dd86e72abdbc4b436471af5a97927c6145f5298c
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Mon, 19 Oct 2009 13:33:03 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 19 Oct 2009 13:36:32 +0200

perf stat: Count branches first

Count branches first, cache-misses second. The reason is that
on x86 branches are not counted by all counters on all CPUs.

Before:

 Performance counter stats for 'ls':

       0.756653  task-clock-msecs         #      0.802 CPUs
              0  context-switches         #      0.000 M/sec
              0  CPU-migrations           #      0.000 M/sec
            250  page-faults              #      0.330 M/sec
        2375725  cycles                   #   3139.781 M/sec
        1628129  instructions             #      0.685 IPC
          19643  cache-references         #     25.960 M/sec
           4608  cache-misses             #      6.090 M/sec
         342532  branches                 #    452.694 M/sec
  <not counted>  branch-misses

    0.000943356  seconds time elapsed

After:

 Performance counter stats for 'ls':

       1.056734  task-clock-msecs         #      0.859 CPUs
              0  context-switches         #      0.000 M/sec
              0  CPU-migrations           #      0.000 M/sec
            259  page-faults              #      0.245 M/sec
        3345932  cycles                   #   3166.295 M/sec
        3074090  instructions             #      0.919 IPC
         616928  branches                 #    583.806 M/sec
          39279  branch-misses            #      6.367 %
          21312  cache-references         #     20.168 M/sec
           3661  cache-misses             #      3.464 M/sec

    0.001230551  seconds time elapsed

(also prettify the printout of branch misses, in case it's
 getting scaled.)

Cc: Tim Blechmann <tim@klingt.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <4ADC3975.8050109@klingt.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-stat.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index c373683..95a55ea 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -59,6 +59,8 @@ static struct perf_event_attr default_attrs[] = {
   { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_INSTRUCTIONS	},
   { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_CACHE_REFERENCES},
   { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_CACHE_MISSES	},
+  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_BRANCH_INSTRUCTIONS},
+  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_BRANCH_MISSES	},

 };
---
 tools/perf/builtin-stat.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 95a55ea..90e0a26 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -50,17 +50,17 @@

 static struct perf_event_attr default_attrs[] = {

-  { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_TASK_CLOCK	},
-  { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_CONTEXT_SWITCHES},
-  { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_CPU_MIGRATIONS	},
-  { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_PAGE_FAULTS	},
-
-  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_CPU_CYCLES	},
-  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_INSTRUCTIONS	},
-  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_CACHE_REFERENCES},
-  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_CACHE_MISSES	},
-  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_BRANCH_INSTRUCTIONS},
-  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_BRANCH_MISSES	},
+  { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_TASK_CLOCK		},
+  { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_CONTEXT_SWITCHES	},
+  { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_CPU_MIGRATIONS		},
+  { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_PAGE_FAULTS		},
+
+  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_CPU_CYCLES		},
+  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_INSTRUCTIONS		},
+  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_CACHE_REFERENCES	},
+  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_CACHE_MISSES		},
+  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_BRANCH_INSTRUCTIONS	},
+  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_BRANCH_MISSES		},

 };
---
 tools/perf/builtin-stat.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 90e0a26..c6df377 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -57,10 +57,10 @@ static struct perf_event_attr default_attrs[] = {
 
   { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_CPU_CYCLES		},
   { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_INSTRUCTIONS		},
-  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_CACHE_REFERENCES	},
-  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_CACHE_MISSES		},
   { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_BRANCH_INSTRUCTIONS	},
   { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_BRANCH_MISSES		},
+  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_CACHE_REFERENCES	},
+  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_CACHE_MISSES		},
 
 };
 
@@ -363,7 +363,7 @@ static void abs_printout(int counter, double avg)
 		if (total)
 			ratio = avg * 100 / total;
 
-		fprintf(stderr, " # %10.3f %%  ", ratio);
+		fprintf(stderr, " # %10.3f %%    ", ratio);
 
 	} else {
 		total = avg_stats(&runtime_nsecs_stats);
