Return-Path: <linux-kernel-owner+w=401wt.eu-S1752073AbZIOJbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073AbZIOJbp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 05:31:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751955AbZIOJbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 05:31:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:49220 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993AbZIOJbi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 05:31:38 -0400
Date: Tue, 15 Sep 2009 09:31:07 GMT
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
Subject: [tip:perfcounters/core] perf sched: Implement the scheduling workload replay engine
Message-ID: <tip-fbf9482911825f965829567aea8acff3bbc5279c@git.kernel.org>
Git-Commit-ID: fbf9482911825f965829567aea8acff3bbc5279c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 15 Sep 2009 09:31:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fbf9482911825f965829567aea8acff3bbc5279c
Gitweb:     http://git.kernel.org/tip/fbf9482911825f965829567aea8acff3bbc5279c
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Fri, 11 Sep 2009 12:12:54 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 13 Sep 2009 10:22:38 +0200

perf sched: Implement the scheduling workload replay engine

Integrate the schedbench.c bits with the raw trace events
that we get from the perf machinery, and activate the
workload replayer/simulator.

Example of a captured 'make -j' workload:

$ perf sched

  run measurement overhead: 90 nsecs
  sleep measurement overhead: 2724743 nsecs
  the run test took 1000081 nsecs
  the sleep test took 2981111 nsecs
  version = 0.5
  ...
  nr_run_events:        70
  nr_sleep_events:      66
  nr_wakeup_events:     9
  target-less wakeups:  71
  multi-target wakeups: 47
  run events optimized: 139
  task      0 (                perf:      6607), nr_events: 2
  task      1 (                perf:      6608), nr_events: 6
  task      2 (                    :         0), nr_events: 1
  task      3 (                make:      6609), nr_events: 5
  task      4 (                  sh:      6610), nr_events: 4
  task      5 (                make:      6611), nr_events: 6
  task      6 (                  sh:      6612), nr_events: 4
  task      7 (                make:      6613), nr_events: 5
  task      8 (        migration/11:        25), nr_events: 1
  task      9 (        migration/13:        29), nr_events: 1
  task     10 (        migration/15:        33), nr_events: 1
  task     11 (         migration/9:        21), nr_events: 1
  task     12 (                  sh:      6614), nr_events: 4
  task     13 (                make:      6615), nr_events: 5
  task     14 (                  sh:      6616), nr_events: 4
  task     15 (                make:      6617), nr_events: 7
  task     16 (         migration/3:         9), nr_events: 1
  task     17 (         migration/5:        13), nr_events: 1
  task     18 (         migration/7:        17), nr_events: 1
  task     19 (         migration/1:         5), nr_events: 1
  task     20 (                  sh:      6618), nr_events: 4
  task     21 (                make:      6619), nr_events: 5
  task     22 (                  sh:      6620), nr_events: 4
  task     23 (                make:      6621), nr_events: 10
  task     24 (                  sh:      6623), nr_events: 3
  task     25 (                 gcc:      6624), nr_events: 4
  task     26 (                 gcc:      6625), nr_events: 4
  task     27 (                 gcc:      6626), nr_events: 5
  task     28 (            collect2:      6627), nr_events: 5
  task     29 (                  sh:      6622), nr_events: 1
  task     30 (                make:      6628), nr_events: 7
  task     31 (                  sh:      6630), nr_events: 4
  task     32 (                 gcc:      6631), nr_events: 4
  task     33 (                  sh:      6629), nr_events: 1
  task     34 (                 gcc:      6632), nr_events: 4
  task     35 (                 gcc:      6633), nr_events: 4
  task     36 (            collect2:      6634), nr_events: 4
  task     37 (                make:      6635), nr_events: 8
  task     38 (                  sh:      6637), nr_events: 4
  task     39 (                  sh:      6636), nr_events: 1
  task     40 (                 gcc:      6638), nr_events: 4
  task     41 (                 gcc:      6639), nr_events: 4
  task     42 (                 gcc:      6640), nr_events: 4
  task     43 (            collect2:      6641), nr_events: 4
  task     44 (                make:      6642), nr_events: 6
  task     45 (                  sh:      6643), nr_events: 5
  task     46 (                  sh:      6644), nr_events: 3
  task     47 (                  sh:      6645), nr_events: 4
  task     48 (                make:      6646), nr_events: 6
  task     49 (                  sh:      6647), nr_events: 3
  task     50 (                make:      6648), nr_events: 5
  task     51 (                  sh:      6649), nr_events: 5
  task     52 (                  sh:      6650), nr_events: 6
  task     53 (                make:      6651), nr_events: 4
  task     54 (                make:      6652), nr_events: 5
  task     55 (                make:      6653), nr_events: 4
  task     56 (                make:      6654), nr_events: 4
  task     57 (                make:      6655), nr_events: 5
  task     58 (                  sh:      6656), nr_events: 4
  task     59 (                 gcc:      6657), nr_events: 9
  task     60 (         ksoftirqd/3:        10), nr_events: 1
  task     61 (                 gcc:      6658), nr_events: 4
  task     62 (                make:      6659), nr_events: 5
  task     63 (                  sh:      6660), nr_events: 3
  task     64 (                 gcc:      6661), nr_events: 5
  task     65 (            collect2:      6662), nr_events: 4
  ------------------------------------------------------------
  #1  : 256.745, ravg: 256.74, cpu: 0.00 / 0.00
  #2  : 439.372, ravg: 275.01, cpu: 0.00 / 0.00
  #3  : 411.971, ravg: 288.70, cpu: 0.00 / 0.00
  #4  : 385.500, ravg: 298.38, cpu: 0.00 / 0.00
  #5  : 366.526, ravg: 305.20, cpu: 0.00 / 0.00
  #6  : 381.281, ravg: 312.81, cpu: 0.00 / 0.00
  #7  : 410.756, ravg: 322.60, cpu: 0.00 / 0.00
  #8  : 368.009, ravg: 327.14, cpu: 0.00 / 0.00
  #9  : 408.098, ravg: 335.24, cpu: 0.00 / 0.00
  #10 : 368.582, ravg: 338.57, cpu: 0.00 / 0.00

I.e. we successfully analyzed the trace, replayed it
via real threads and measured the replayed workload's
scheduling properties.

This is how it looked like in 'top' output:

   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
  7164 mingo     20   0 1434m 8080  888 R 57.0  0.1   0:02.04 :perf
  7165 mingo     20   0 1434m 8080  888 R 41.8  0.1   0:01.52 :perf
  7228 mingo     20   0 1434m 8080  888 R 39.8  0.1   0:01.44 :gcc
  7225 mingo     20   0 1434m 8080  888 R 33.8  0.1   0:01.26 :gcc
  7202 mingo     20   0 1434m 8080  888 R 31.2  0.1   0:01.16 :sh
  7222 mingo     20   0 1434m 8080  888 R 25.2  0.1   0:00.96 :sh
  7211 mingo     20   0 1434m 8080  888 R 21.9  0.1   0:00.82 :sh
  7213 mingo     20   0 1434m 8080  888 D 19.2  0.1   0:00.74 :sh
  7194 mingo     20   0 1434m 8080  888 D 18.6  0.1   0:00.72 :make

There's still various kinks in it - more patches to come.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-sched.c |  152 ++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 134 insertions(+), 18 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index c66e6a3..6ec4f51 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -57,7 +57,7 @@ static u64			sample_type;
 
 #define BUG_ON(x)	assert(!(x))
 
-#define DEBUG		1
+#define DEBUG		0
 
 typedef unsigned long long nsec_t;
 
@@ -238,15 +238,14 @@ static struct sched_event *last_event(struct task_desc *task)
 }
 
 static void
-add_sched_event_run(struct task_desc *task, nsec_t timestamp,
-		    unsigned long duration)
+add_sched_event_run(struct task_desc *task, nsec_t timestamp, u64 duration)
 {
 	struct sched_event *event, *curr_event = last_event(task);
 
 	/*
- 	 * optimize an existing RUN event by merging this one
- 	 * to it:
- 	 */
+	 * optimize an existing RUN event by merging this one
+	 * to it:
+	 */
 	if (curr_event && curr_event->type == SCHED_EVENT_RUN) {
 		nr_run_events_optimized++;
 		curr_event->duration += duration;
@@ -376,7 +375,7 @@ void parse_line(char *line)
 	dprintk("parsed: %s - %ld %Ld: %s - <%s %ld> (%ld %ld)\n",
 		comm,
 		pid,
-		timestamp, 
+		timestamp,
 		func_str,
 		comm2,
 		pid2,
@@ -429,7 +428,7 @@ static void add_cross_task_wakeups(void)
 }
 
 static void
-process_sched_event(struct task_desc *this_task, struct sched_event *event)
+process_sched_event(struct task_desc *this_task __used, struct sched_event *event)
 {
 	int ret = 0;
 	nsec_t now;
@@ -744,9 +743,9 @@ static void run_one_test(void)
 
 #if 0
 	/*
- 	 * rusage statistics done by the parent, these are less
- 	 * accurate than the sum_exec_runtime based statistics:
- 	 */
+	 * rusage statistics done by the parent, these are less
+	 * accurate than the sum_exec_runtime based statistics:
+	 */
 	printk(" [%0.2f / %0.2f]",
 		(double)parent_cpu_usage/1e6,
 		(double)runavg_parent_cpu_usage/1e6);
@@ -798,16 +797,128 @@ process_comm_event(event_t *event, unsigned long offset, unsigned long head)
 	return 0;
 }
 
-static void process_sched_wakeup_event(struct event *event,
+struct trace_wakeup_event {
+	u32 size;
+
+	u16 common_type;
+	u8 common_flags;
+	u8 common_preempt_count;
+	u32 common_pid;
+	u32 common_tgid;
+
+	char comm[16];
+	u32 pid;
+
+	u32 prio;
+	u32 success;
+	u32 cpu;
+};
+
+static void
+process_sched_wakeup_event(struct trace_wakeup_event *wakeup_event, struct event *event,
 		  int cpu __used, u64 timestamp __used, struct thread *thread __used)
 {
+	struct task_desc *waker, *wakee;
+
 	printf("sched_wakeup event %p\n", event);
+
+	printf(" ... pid %d woke up %s/%d\n",
+		wakeup_event->common_pid,
+		wakeup_event->comm,
+		wakeup_event->pid);
+
+	waker = register_pid(wakeup_event->common_pid, "<unknown>");
+	wakee = register_pid(wakeup_event->pid, wakeup_event->comm);
+
+	add_sched_event_wakeup(waker, timestamp, wakee);
 }
 
-static void process_sched_switch_event(struct event *event,
+struct trace_switch_event {
+	u32 size;
+
+	u16 common_type;
+	u8 common_flags;
+	u8 common_preempt_count;
+	u32 common_pid;
+	u32 common_tgid;
+
+	char prev_comm[16];
+	u32 prev_pid;
+	u32 prev_prio;
+	u64 prev_state;
+	char next_comm[16];
+	u32 next_pid;
+	u32 next_prio;
+};
+
+#define MAX_CPUS 4096
+
+unsigned long cpu_last_switched[MAX_CPUS];
+
+static void
+process_sched_switch_event(struct trace_switch_event *switch_event, struct event *event,
 		  int cpu __used, u64 timestamp __used, struct thread *thread __used)
 {
+	struct task_desc *prev, *next;
+	u64 timestamp0;
+	s64 delta;
+
 	printf("sched_switch event %p\n", event);
+	if (cpu >= MAX_CPUS || cpu < 0)
+		return;
+
+	timestamp0 = cpu_last_switched[cpu];
+	if (timestamp0)
+		delta = timestamp - timestamp0;
+	else
+		delta = 0;
+
+	if (delta < 0)
+		die("hm, delta: %Ld < 0 ?\n", delta);
+
+	printf(" ... switch from %s/%d to %s/%d [ran %Ld nsecs]\n",
+		switch_event->prev_comm, switch_event->prev_pid,
+		switch_event->next_comm, switch_event->next_pid,
+		delta);
+
+	prev = register_pid(switch_event->prev_pid, switch_event->prev_comm);
+	next = register_pid(switch_event->next_pid, switch_event->next_comm);
+
+	cpu_last_switched[cpu] = timestamp;
+
+	add_sched_event_run(prev, timestamp, delta);
+}
+
+struct trace_fork_event {
+	u32 size;
+
+	u16 common_type;
+	u8 common_flags;
+	u8 common_preempt_count;
+	u32 common_pid;
+	u32 common_tgid;
+
+	char parent_comm[16];
+	u32 parent_pid;
+	char child_comm[16];
+	u32 child_pid;
+};
+
+static void
+process_sched_fork_event(struct trace_fork_event *fork_event, struct event *event,
+		  int cpu __used, u64 timestamp __used, struct thread *thread __used)
+{
+	printf("sched_fork event %p\n", event);
+	printf("... parent: %s/%d\n", fork_event->parent_comm, fork_event->parent_pid);
+	printf("...  child: %s/%d\n", fork_event->child_comm, fork_event->child_pid);
+	register_pid(fork_event->parent_pid, fork_event->parent_comm);
+	register_pid(fork_event->child_pid, fork_event->child_comm);
+}
+
+static void process_sched_exit_event(struct event *event,
+		  int cpu __used, u64 timestamp __used, struct thread *thread __used)
+{
+	printf("sched_exit event %p\n", event);
 }
 
 static void
@@ -833,9 +944,15 @@ process_raw_event(event_t *raw_event, void *more_data,
 		raw_event->header.type, type, event->name);
 
 	if (!strcmp(event->name, "sched_switch"))
-		process_sched_switch_event(event, cpu, timestamp, thread);
+		process_sched_switch_event(more_data, event, cpu, timestamp, thread);
 	if (!strcmp(event->name, "sched_wakeup"))
-		process_sched_wakeup_event(event, cpu, timestamp, thread);
+		process_sched_wakeup_event(more_data, event, cpu, timestamp, thread);
+	if (!strcmp(event->name, "sched_wakeup_new"))
+		process_sched_wakeup_event(more_data, event, cpu, timestamp, thread);
+	if (!strcmp(event->name, "sched_process_fork"))
+		process_sched_fork_event(more_data, event, cpu, timestamp, thread);
+	if (!strcmp(event->name, "sched_process_exit"))
+		process_sched_exit_event(event, cpu, timestamp, thread);
 }
 
 static int
@@ -1053,7 +1170,7 @@ static const struct option options[] = {
 
 int cmd_sched(int argc, const char **argv, const char *prefix __used)
 {
-	long nr_iterations = LONG_MAX, i;
+	long nr_iterations = 10, i;
 
 	symbol__init();
 	page_size = getpagesize();
@@ -1068,8 +1185,7 @@ int cmd_sched(int argc, const char **argv, const char *prefix __used)
 			usage_with_options(annotate_usage, options);
 	}
 
-
-	setup_pager();
+//	setup_pager();
 
 	calibrate_run_measurement_overhead();
 	calibrate_sleep_measurement_overhead();
