Return-Path: <linux-kernel-owner+w=401wt.eu-S1752211AbZIOJda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211AbZIOJda (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 05:33:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752181AbZIOJd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 05:33:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:49356 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077AbZIOJdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 05:33:25 -0400
Date: Tue, 15 Sep 2009 09:32:50 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perfcounters/core] perf sched: Add runtime stats
Message-ID: <tip-ea92ed5a8f4e6c638efe7de2efe8a875d580ad3f@git.kernel.org>
Git-Commit-ID: ea92ed5a8f4e6c638efe7de2efe8a875d580ad3f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 15 Sep 2009 09:32:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ea92ed5a8f4e6c638efe7de2efe8a875d580ad3f
Gitweb:     http://git.kernel.org/tip/ea92ed5a8f4e6c638efe7de2efe8a875d580ad3f
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Sat, 12 Sep 2009 10:08:34 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 13 Sep 2009 10:22:45 +0200

perf sched: Add runtime stats

Extend the latency tracking structure with scheduling atom
runtime info - and sum it up during per task display.

(Also clean up a few details.)

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-sched.c |   58 ++++++++++++++++++++++++++++---------------
 1 files changed, 38 insertions(+), 20 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index a084c28..c382f53 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -243,8 +243,8 @@ add_sched_event_run(struct task_desc *task, nsec_t timestamp, u64 duration)
 	nr_run_events++;
 }
 
-static unsigned long targetless_wakeups;
-static unsigned long multitarget_wakeups;
+static unsigned long		targetless_wakeups;
+static unsigned long		multitarget_wakeups;
 
 static void
 add_sched_event_wakeup(struct task_desc *task, nsec_t timestamp,
@@ -485,10 +485,10 @@ static void create_tasks(void)
 	}
 }
 
-static nsec_t cpu_usage;
-static nsec_t runavg_cpu_usage;
-static nsec_t parent_cpu_usage;
-static nsec_t runavg_parent_cpu_usage;
+static nsec_t			cpu_usage;
+static nsec_t			runavg_cpu_usage;
+static nsec_t			parent_cpu_usage;
+static nsec_t			runavg_parent_cpu_usage;
 
 static void wait_for_tasks(void)
 {
@@ -858,9 +858,9 @@ replay_fork_event(struct trace_fork_event *fork_event,
 }
 
 static struct trace_sched_handler replay_ops  = {
-	.wakeup_event = replay_wakeup_event,
-	.switch_event = replay_switch_event,
-	.fork_event = replay_fork_event,
+	.wakeup_event		= replay_wakeup_event,
+	.switch_event		= replay_switch_event,
+	.fork_event		= replay_fork_event,
 };
 
 #define TASK_STATE_TO_CHAR_STR "RSDTtZX"
@@ -877,6 +877,7 @@ struct lat_snapshot {
 	enum thread_state	state;
 	u64			wake_up_time;
 	u64			sched_in_time;
+	u64			runtime;
 };
 
 struct thread_latency {
@@ -951,6 +952,7 @@ latency_fork_event(struct trace_fork_event *fork_event __used,
 	/* should insert the newcomer */
 }
 
+__used
 static char sched_out_state(struct trace_switch_event *switch_event)
 {
 	const char *str = TASK_STATE_TO_CHAR_STR;
@@ -960,17 +962,15 @@ static char sched_out_state(struct trace_switch_event *switch_event)
 
 static void
 lat_sched_out(struct thread_latency *lat,
-	     struct trace_switch_event *switch_event)
+	     struct trace_switch_event *switch_event __used, u64 delta)
 {
 	struct lat_snapshot *snapshot;
 
-	if (sched_out_state(switch_event) == 'R')
-		return;
-
 	snapshot = calloc(sizeof(*snapshot), 1);
 	if (!snapshot)
 		die("Non memory");
 
+	snapshot->runtime = delta;
 	list_add_tail(&snapshot->list, &lat->snapshot_list);
 }
 
@@ -997,16 +997,31 @@ lat_sched_in(struct thread_latency *lat, u64 timestamp)
 	snapshot->sched_in_time = timestamp;
 }
 
-
 static void
 latency_switch_event(struct trace_switch_event *switch_event,
 		     struct event *event __used,
-		     int cpu __used,
+		     int cpu,
 		     u64 timestamp,
 		     struct thread *thread __used)
 {
 	struct thread_latency *out_lat, *in_lat;
 	struct thread *sched_out, *sched_in;
+	u64 timestamp0;
+	s64 delta;
+
+	if (cpu >= MAX_CPUS || cpu < 0)
+		return;
+
+	timestamp0 = cpu_last_switched[cpu];
+	cpu_last_switched[cpu] = timestamp;
+	if (timestamp0)
+		delta = timestamp - timestamp0;
+	else
+		delta = 0;
+
+	if (delta < 0)
+		die("hm, delta: %Ld < 0 ?\n", delta);
+
 
 	sched_out = threads__findnew(switch_event->prev_pid, &threads, &last_match);
 	sched_in = threads__findnew(switch_event->next_pid, &threads, &last_match);
@@ -1028,7 +1043,7 @@ latency_switch_event(struct trace_switch_event *switch_event,
 	}
 
 	lat_sched_in(in_lat, timestamp);
-	lat_sched_out(out_lat, switch_event);
+	lat_sched_out(out_lat, switch_event, delta);
 }
 
 static void
@@ -1067,9 +1082,9 @@ latency_wakeup_event(struct trace_wakeup_event *wakeup_event,
 }
 
 static struct trace_sched_handler lat_ops  = {
-	.wakeup_event = latency_wakeup_event,
-	.switch_event = latency_switch_event,
-	.fork_event = latency_fork_event,
+	.wakeup_event		= latency_wakeup_event,
+	.switch_event		= latency_switch_event,
+	.fork_event		= latency_fork_event,
 };
 
 static void output_lat_thread(struct thread_latency *lat)
@@ -1080,8 +1095,11 @@ static void output_lat_thread(struct thread_latency *lat)
 	int ret;
 	u64 max = 0, avg;
 	u64 total = 0, delta;
+	u64 total_runtime = 0;
 
 	list_for_each_entry(shot, &lat->snapshot_list, list) {
+		total_runtime += shot->runtime;
+
 		if (shot->state != THREAD_SCHED_IN)
 			continue;
 
@@ -1104,7 +1122,7 @@ static void output_lat_thread(struct thread_latency *lat)
 	avg = total / count;
 
 	printf("|%9.3f ms |%9d | avg:%9.3f ms | max:%9.3f ms |\n",
-		0.0, count, (double)avg/1e9, (double)max/1e9);
+		(double)total_runtime/1e9, count, (double)avg/1e9, (double)max/1e9);
 }
 
 static void __cmd_lat(void)
