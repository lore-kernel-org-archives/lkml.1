Return-Path: <linux-kernel-owner+w=401wt.eu-S1757080AbZGPCIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757080AbZGPCIw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 22:08:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757068AbZGPCIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 22:08:52 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:55214 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757057AbZGPCIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 22:08:51 -0400
Date: Thu, 16 Jul 2009 11:08:34 +0900 (JST)
Message-Id: <20090716.110834.886429911292889318.mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>, Dominik Brodowski <linux@brodo.de>,
       linux-kernel@vger.kernel.org
Subject: [PATCH][RFC] Adding transition of CPU frequency counting support
 to perfcounters
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I'm trying to add transition of CPU frequency counting support to perfcounters.
If perf can count freq transition, this will be more useful
because frequencies of CPUs are dynamic things today.
And there's no way to count freq transitions per process level.

But I have a question.
I copied the way of sw-events already exist such as migration or page-fault.
But like this,

% perf stat emacs

 Performance counter stats for 'emacs':

    1324.294227  task-clock-msecs         #      0.704 CPUs
           1980  context-switches         #      0.001 M/sec
             30  CPU-migrations           #      0.000 M/sec
          42986  page-faults              #      0.032 M/sec
              0  cpufreq-up               #      0.000 M/sec
                 ^^^^^^^^^^
              0  cpufreq-down             #      0.000 M/sec
                 ^^^^^^^^^^^^      
     4057387374  cycles                   #   3063.811 M/sec
     4767004447  instructions             #      1.175 IPC
       20687483  cache-references         #     15.622 M/sec
        5103528  cache-misses             #      3.854 M/sec

    1.880587959  seconds time elapsed

perf said there's no freq transition.
But I checked there are some transitions with cpufreq-info.

Can you find something bad in this patch?
I'll continue to try implementing.
If you find some bad points, I'd like to hear..

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index b90eda8..805eee2 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -28,6 +28,7 @@
 #include <linux/cpu.h>
 #include <linux/completion.h>
 #include <linux/mutex.h>
+#include <linux/perf_counter.h>
 
 #define dprintk(msg...) cpufreq_debug_printk(CPUFREQ_DEBUG_CORE, \
 						"cpufreq-core", msg)
@@ -356,6 +357,12 @@ void cpufreq_notify_transition(struct cpufreq_freqs *freqs, unsigned int state)
 				CPUFREQ_POSTCHANGE, freqs);
 		if (likely(policy) && likely(policy->cpu == freqs->cpu))
 			policy->cur = freqs->new;
+		if (freqs->new > freqs->old)
+			perf_swcounter_event(PERF_COUNT_SW_CPUFREQ_UP,
+					     1, 0, NULL, 0);
+		else
+			perf_swcounter_event(PERF_COUNT_SW_CPUFREQ_DOWN,
+					     1, 0, NULL, 0);
 		break;
 	}
 }
diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 5e970c7..8f93277 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -102,6 +102,8 @@ enum perf_sw_ids {
 	PERF_COUNT_SW_CPU_MIGRATIONS		= 4,
 	PERF_COUNT_SW_PAGE_FAULTS_MIN		= 5,
 	PERF_COUNT_SW_PAGE_FAULTS_MAJ		= 6,
+	PERF_COUNT_SW_CPUFREQ_UP                = 7,
+	PERF_COUNT_SW_CPUFREQ_DOWN              = 8,
 
 	PERF_COUNT_SW_MAX,			/* non-ABI */
 };
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index a641eb7..d358509 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -3754,6 +3754,9 @@ static const struct pmu *sw_perf_counter_init(struct perf_counter *counter)
 	case PERF_COUNT_SW_PAGE_FAULTS_MAJ:
 	case PERF_COUNT_SW_CONTEXT_SWITCHES:
 	case PERF_COUNT_SW_CPU_MIGRATIONS:
+	case PERF_COUNT_SW_CPUFREQ_UP:
+	case PERF_COUNT_SW_CPUFREQ_DOWN:
+
 		if (!counter->parent) {
 			atomic_inc(&perf_swcounter_enabled[event]);
 			counter->destroy = sw_perf_counter_destroy;
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 27921a8..dbf7969 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -52,6 +52,8 @@ static struct perf_counter_attr default_attrs[] = {
   { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_CONTEXT_SWITCHES},
   { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_CPU_MIGRATIONS	},
   { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_PAGE_FAULTS	},
+  { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_CPUFREQ_UP      },
+  { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_CPUFREQ_DOWN	},
 
   { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_CPU_CYCLES	},
   { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_INSTRUCTIONS	},
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 5184959..d83fb36 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -38,6 +38,8 @@ static struct event_symbol event_symbols[] = {
   { CSW(PAGE_FAULTS_MAJ),	"major-faults",		""		},
   { CSW(CONTEXT_SWITCHES),	"context-switches",	"cs"		},
   { CSW(CPU_MIGRATIONS),	"cpu-migrations",	"migrations"	},
+  { CSW(CPUFREQ_UP),    	"cpufreq-up",   	""      	},
+  { CSW(CPUFREQ_DOWN),   	"cpufreq-down", 	""              },
 };
 
 #define __PERF_COUNTER_FIELD(config, name) \
@@ -66,6 +68,8 @@ static char *sw_event_names[] = {
 	"CPU-migrations",
 	"minor-faults",
 	"major-faults",
+	"cpufreq-up",
+	"cpufreq-down",
 };
 
 #define MAX_ALIASES 8
