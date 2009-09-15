Return-Path: <linux-kernel-owner+w=401wt.eu-S1752106AbZIOJbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106AbZIOJbx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 05:31:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954AbZIOJbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 05:31:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:49233 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060AbZIOJbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 05:31:44 -0400
Date: Tue, 15 Sep 2009 09:31:20 GMT
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
Subject: [tip:perfcounters/core] perf sched: Tighten up the code
Message-ID: <tip-ad236fd23b6d6372dcacd549983cce051d2ccff6@git.kernel.org>
Git-Commit-ID: ad236fd23b6d6372dcacd549983cce051d2ccff6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 15 Sep 2009 09:31:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ad236fd23b6d6372dcacd549983cce051d2ccff6
Gitweb:     http://git.kernel.org/tip/ad236fd23b6d6372dcacd549983cce051d2ccff6
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Fri, 11 Sep 2009 12:12:54 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 13 Sep 2009 10:22:39 +0200

perf sched: Tighten up the code

Various small cleanups - removal of debug printks and dead
functions, etc.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-sched.c |  236 +++++++++-----------------------------------
 1 files changed, 47 insertions(+), 189 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 6ec4f51..de93a26 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -61,29 +61,6 @@ static u64			sample_type;
 
 typedef unsigned long long nsec_t;
 
-#define printk(x...)		do { printf(x); fflush(stdout); } while (0)
-
-nsec_t prev_printk;
-
-#define __dprintk(x,y...) do {						 \
-	nsec_t __now = get_nsecs(), __delta = __now - prev_printk;	 \
-									 \
-	prev_printk = __now;						 \
-									 \
-	printf("%.3f [%Ld] [%.3f]: " x, (double)__now/1e6, __now, (double)__delta/1e6, y);\
-} while (0)
-
-#if !DEBUG
-# define dprintk(x...)	do { } while (0)
-#else
-# define dprintk(x...)	__dprintk(x)
-#endif
-
-#define __DP()		__dprintk("parent: line %d\n", __LINE__)
-#define DP()		dprintk("parent: line %d\n", __LINE__)
-#define D()		dprintk("task %ld: line %d\n", this_task->nr, __LINE__)
-
-
 static nsec_t run_measurement_overhead;
 static nsec_t sleep_measurement_overhead;
 
@@ -129,7 +106,7 @@ static void calibrate_run_measurement_overhead(void)
 	}
 	run_measurement_overhead = min_delta;
 
-	printk("run measurement overhead: %Ld nsecs\n", min_delta);
+	printf("run measurement overhead: %Ld nsecs\n", min_delta);
 }
 
 static void calibrate_sleep_measurement_overhead(void)
@@ -147,7 +124,7 @@ static void calibrate_sleep_measurement_overhead(void)
 	min_delta -= 10000;
 	sleep_measurement_overhead = min_delta;
 
-	printk("sleep measurement overhead: %Ld nsecs\n", min_delta);
+	printf("sleep measurement overhead: %Ld nsecs\n", min_delta);
 }
 
 #define COMM_LEN	20
@@ -293,7 +270,7 @@ add_sched_event_wakeup(struct task_desc *task, nsec_t timestamp,
 
 static void
 add_sched_event_sleep(struct task_desc *task, nsec_t timestamp,
-		      unsigned long uninterruptible __used)
+		      u64 task_state __used)
 {
 	struct sched_event *event = get_new_event(task, timestamp);
 
@@ -329,77 +306,13 @@ static struct task_desc *register_pid(unsigned long pid, const char *comm)
 	BUG_ON(!tasks);
 	tasks[task->nr] = task;
 
-	printk("registered task #%ld, PID %ld (%s)\n", nr_tasks, pid, comm);
+	if (verbose)
+		printf("registered task #%ld, PID %ld (%s)\n", nr_tasks, pid, comm);
 
 	return task;
 }
 
 
-static int first_trace_line = 1;
-
-static nsec_t first_timestamp;
-static nsec_t prev_timestamp;
-
-void parse_line(char *line);
-
-void parse_line(char *line)
-{
-	unsigned long param1 = 0, param2 = 0;
-	char comm[COMM_LEN], comm2[COMM_LEN];
-	unsigned long pid, pid2, timestamp0;
-	struct task_desc *task, *task2;
-	char func_str[SYM_LEN];
-	nsec_t timestamp;
-	int ret;
-
-	//"   <idle> 0     0D.s3    0us+: try_to_wake_up <events/0 9> (1 0)"
-	ret = sscanf(line, "%20s %5ld %*s %ldus%*c:"
-			   " %128s <%20s %ld> (%ld %ld)\n",
-		comm, &pid, &timestamp0,
-		func_str, comm2, &pid2, &param1, &param2);
-	dprintk("ret: %d\n", ret);
-	if (ret != 8)
-		return;
-
-	timestamp = timestamp0 * 1000LL;
-
-	if (first_trace_line) {
-		first_trace_line = 0;
-		first_timestamp = timestamp;
-	}
-
-	timestamp -= first_timestamp;
-	BUG_ON(timestamp < prev_timestamp);
-	prev_timestamp = timestamp;
-
-	dprintk("parsed: %s - %ld %Ld: %s - <%s %ld> (%ld %ld)\n",
-		comm,
-		pid,
-		timestamp,
-		func_str,
-		comm2,
-		pid2,
-		param1,
-		param2);
-
-	task = register_pid(pid, comm);
-	task2 = register_pid(pid2, comm2);
-
-	if (!strcmp(func_str, "update_curr")) {
-		dprintk("%Ld: task %ld runs for %ld nsecs\n",
-			timestamp, task->nr, param1);
-		add_sched_event_run(task, timestamp, param1);
-	} else if (!strcmp(func_str, "try_to_wake_up")) {
-		dprintk("%Ld: task %ld wakes up task %ld\n",
-			timestamp, task->nr, task2->nr);
-		add_sched_event_wakeup(task, timestamp, task2);
-	} else if (!strcmp(func_str, "deactivate_task")) {
-		dprintk("%Ld: task %ld goes to sleep (uninterruptible: %ld)\n",
-			timestamp, task->nr, param1);
-		add_sched_event_sleep(task, timestamp, param1);
-	}
-}
-
 static void print_task_traces(void)
 {
 	struct task_desc *task;
@@ -407,7 +320,7 @@ static void print_task_traces(void)
 
 	for (i = 0; i < nr_tasks; i++) {
 		task = tasks[i];
-		printk("task %6ld (%20s:%10ld), nr_events: %ld\n",
+		printf("task %6ld (%20s:%10ld), nr_events: %ld\n",
 			task->nr, task->comm, task->pid, task->nr_events);
 	}
 }
@@ -437,40 +350,16 @@ process_sched_event(struct task_desc *this_task __used, struct sched_event *even
 	now = get_nsecs();
 	delta = start_time + event->timestamp - now;
 
-	dprintk("task %ld, event #%ld, %Ld, delta: %.3f (%Ld)\n",
-		this_task->nr, event->nr, event->timestamp,
-		(double)delta/1e6, delta);
-
-	if (0 && delta > 0) {
-		dprintk("%.3f: task %ld FIX %.3f\n",
-			(double)event->timestamp/1e6,
-			this_task->nr,
-			(double)delta/1e6);
-		sleep_nsecs(start_time + event->timestamp - now);
-		nr_sleep_corrections++;
-	}
-
 	switch (event->type) {
 		case SCHED_EVENT_RUN:
-			dprintk("%.3f: task %ld RUN for %.3f\n",
-				(double)event->timestamp/1e6,
-				this_task->nr,
-				(double)event->duration/1e6);
 			burn_nsecs(event->duration);
 			break;
 		case SCHED_EVENT_SLEEP:
-			dprintk("%.3f: task %ld %s SLEEP\n",
-				(double)event->timestamp/1e6,
-				this_task->nr, event->wait_sem ? "" : "SKIP");
 			if (event->wait_sem)
 				ret = sem_wait(event->wait_sem);
 			BUG_ON(ret);
 			break;
 		case SCHED_EVENT_WAKEUP:
-			dprintk("%.3f: task %ld WAKEUP => task %ld\n",
-				(double)event->timestamp/1e6,
-				this_task->nr,
-				event->wakee->nr);
 			if (event->wait_sem)
 				ret = sem_post(event->wait_sem);
 			BUG_ON(ret);
@@ -511,14 +400,10 @@ static nsec_t get_cpu_usage_nsec_self(void)
 	BUG_ON(!file);
 
 	while ((chars = getline(&line, &len, file)) != -1) {
-		dprintk("got line with length %zu :\n", chars);
-		dprintk("%s", line);
 		ret = sscanf(line, "se.sum_exec_runtime : %ld.%06ld\n",
 			&msecs, &nsecs);
 		if (ret == 2) {
 			total = msecs*1e6 + nsecs;
-			dprintk("total: (%ld.%06ld) %Ld\n",
-				msecs, nsecs, total);
 			break;
 		}
 	}
@@ -536,19 +421,16 @@ static void *thread_func(void *ctx)
 	unsigned long i, ret;
 	char comm2[22];
 
-	dprintk("task %ld started up.\n", this_task->nr);
 	sprintf(comm2, ":%s", this_task->comm);
 	prctl(PR_SET_NAME, comm2);
 
 again:
 	ret = sem_post(&this_task->ready_for_work);
 	BUG_ON(ret);
-	D();
 	ret = pthread_mutex_lock(&start_work_mutex);
 	BUG_ON(ret);
 	ret = pthread_mutex_unlock(&start_work_mutex);
 	BUG_ON(ret);
-	D();
 
 	cpu_usage_0 = get_cpu_usage_nsec_self();
 
@@ -560,19 +442,13 @@ again:
 	cpu_usage_1 = get_cpu_usage_nsec_self();
 	this_task->cpu_usage = cpu_usage_1 - cpu_usage_0;
 
-	dprintk("task %ld cpu usage: %0.3f msecs\n",
-		this_task->nr, (double)this_task->cpu_usage / 1e6);
-
-	D();
 	ret = sem_post(&this_task->work_done_sem);
 	BUG_ON(ret);
-	D();
 
 	ret = pthread_mutex_lock(&work_done_wait_mutex);
 	BUG_ON(ret);
 	ret = pthread_mutex_unlock(&work_done_wait_mutex);
 	BUG_ON(ret);
-	D();
 
 	goto again;
 }
@@ -614,9 +490,7 @@ static void wait_for_tasks(void)
 	struct task_desc *task;
 	unsigned long i, ret;
 
-	DP();
 	start_time = get_nsecs();
-	DP();
 	cpu_usage = 0;
 	pthread_mutex_unlock(&work_done_wait_mutex);
 
@@ -633,24 +507,6 @@ static void wait_for_tasks(void)
 
 	pthread_mutex_unlock(&start_work_mutex);
 
-#if 0
-	for (i = 0; i < nr_tasks; i++) {
-		unsigned long missed;
-
-		task = tasks[i];
-		while (task->curr_event + 1 < task->nr_events) {
-			dprintk("parent waiting for %ld (%ld != %ld)\n",
-				i, task->curr_event, task->nr_events);
-			sleep_nsecs(100000000);
-		}
-		missed = task->nr_events - 1 - task->curr_event;
-		if (missed)
-			printk("task %ld missed events: %ld\n", i, missed);
-		ret = sem_post(&task->sleep_sem);
-		BUG_ON(ret);
-	}
-#endif
-	DP();
 	for (i = 0; i < nr_tasks; i++) {
 		task = tasks[i];
 		ret = sem_wait(&task->work_done_sem);
@@ -687,16 +543,16 @@ static void parse_trace(void)
 {
 	__cmd_sched();
 
-	printk("nr_run_events:        %ld\n", nr_run_events);
-	printk("nr_sleep_events:      %ld\n", nr_sleep_events);
-	printk("nr_wakeup_events:     %ld\n", nr_wakeup_events);
+	printf("nr_run_events:        %ld\n", nr_run_events);
+	printf("nr_sleep_events:      %ld\n", nr_sleep_events);
+	printf("nr_wakeup_events:     %ld\n", nr_wakeup_events);
 
 	if (targetless_wakeups)
-		printk("target-less wakeups:  %ld\n", targetless_wakeups);
+		printf("target-less wakeups:  %ld\n", targetless_wakeups);
 	if (multitarget_wakeups)
-		printk("multi-target wakeups: %ld\n", multitarget_wakeups);
+		printf("multi-target wakeups: %ld\n", multitarget_wakeups);
 	if (nr_run_events_optimized)
-		printk("run events optimized: %ld\n",
+		printf("run events optimized: %ld\n",
 			nr_run_events_optimized);
 }
 
@@ -728,17 +584,17 @@ static void run_one_test(void)
 		run_avg = delta;
 	run_avg = (run_avg*9 + delta)/10;
 
-	printk("#%-3ld: %0.3f, ",
+	printf("#%-3ld: %0.3f, ",
 		nr_runs, (double)delta/1000000.0);
 
 #if 0
-	printk("%0.2f +- %0.2f, ",
+	printf("%0.2f +- %0.2f, ",
 		(double)avg_delta/1e6, (double)std_dev/1e6);
 #endif
-	printk("ravg: %0.2f, ",
+	printf("ravg: %0.2f, ",
 		(double)run_avg/1e6);
 
-	printk("cpu: %0.2f / %0.2f",
+	printf("cpu: %0.2f / %0.2f",
 		(double)cpu_usage/1e6, (double)runavg_cpu_usage/1e6);
 
 #if 0
@@ -746,15 +602,15 @@ static void run_one_test(void)
 	 * rusage statistics done by the parent, these are less
 	 * accurate than the sum_exec_runtime based statistics:
 	 */
-	printk(" [%0.2f / %0.2f]",
+	printf(" [%0.2f / %0.2f]",
 		(double)parent_cpu_usage/1e6,
 		(double)runavg_parent_cpu_usage/1e6);
 #endif
 
-	printk("\n");
+	printf("\n");
 
 	if (nr_sleep_corrections)
-		printk(" (%ld sleep corrections)\n", nr_sleep_corrections);
+		printf(" (%ld sleep corrections)\n", nr_sleep_corrections);
 	nr_sleep_corrections = 0;
 }
 
@@ -766,13 +622,13 @@ static void test_calibrations(void)
 	burn_nsecs(1e6);
 	T1 = get_nsecs();
 
-	printk("the run test took %Ld nsecs\n", T1-T0);
+	printf("the run test took %Ld nsecs\n", T1-T0);
 
 	T0 = get_nsecs();
 	sleep_nsecs(1e6);
 	T1 = get_nsecs();
 
-	printk("the sleep test took %Ld nsecs\n", T1-T0);
+	printf("the sleep test took %Ld nsecs\n", T1-T0);
 }
 
 static int
@@ -820,12 +676,14 @@ process_sched_wakeup_event(struct trace_wakeup_event *wakeup_event, struct event
 {
 	struct task_desc *waker, *wakee;
 
-	printf("sched_wakeup event %p\n", event);
+	if (verbose) {
+		printf("sched_wakeup event %p\n", event);
 
-	printf(" ... pid %d woke up %s/%d\n",
-		wakeup_event->common_pid,
-		wakeup_event->comm,
-		wakeup_event->pid);
+		printf(" ... pid %d woke up %s/%d\n",
+			wakeup_event->common_pid,
+			wakeup_event->comm,
+			wakeup_event->pid);
+	}
 
 	waker = register_pid(wakeup_event->common_pid, "<unknown>");
 	wakee = register_pid(wakeup_event->pid, wakeup_event->comm);
@@ -863,7 +721,9 @@ process_sched_switch_event(struct trace_switch_event *switch_event, struct event
 	u64 timestamp0;
 	s64 delta;
 
-	printf("sched_switch event %p\n", event);
+	if (verbose)
+		printf("sched_switch event %p\n", event);
+
 	if (cpu >= MAX_CPUS || cpu < 0)
 		return;
 
@@ -876,10 +736,12 @@ process_sched_switch_event(struct trace_switch_event *switch_event, struct event
 	if (delta < 0)
 		die("hm, delta: %Ld < 0 ?\n", delta);
 
-	printf(" ... switch from %s/%d to %s/%d [ran %Ld nsecs]\n",
-		switch_event->prev_comm, switch_event->prev_pid,
-		switch_event->next_comm, switch_event->next_pid,
-		delta);
+	if (verbose) {
+		printf(" ... switch from %s/%d to %s/%d [ran %Ld nsecs]\n",
+			switch_event->prev_comm, switch_event->prev_pid,
+			switch_event->next_comm, switch_event->next_pid,
+			delta);
+	}
 
 	prev = register_pid(switch_event->prev_pid, switch_event->prev_comm);
 	next = register_pid(switch_event->next_pid, switch_event->next_comm);
@@ -887,6 +749,7 @@ process_sched_switch_event(struct trace_switch_event *switch_event, struct event
 	cpu_last_switched[cpu] = timestamp;
 
 	add_sched_event_run(prev, timestamp, delta);
+	add_sched_event_sleep(prev, timestamp, switch_event->prev_state);
 }
 
 struct trace_fork_event {
@@ -908,9 +771,11 @@ static void
 process_sched_fork_event(struct trace_fork_event *fork_event, struct event *event,
 		  int cpu __used, u64 timestamp __used, struct thread *thread __used)
 {
-	printf("sched_fork event %p\n", event);
-	printf("... parent: %s/%d\n", fork_event->parent_comm, fork_event->parent_pid);
-	printf("...  child: %s/%d\n", fork_event->child_comm, fork_event->child_pid);
+	if (verbose) {
+		printf("sched_fork event %p\n", event);
+		printf("... parent: %s/%d\n", fork_event->parent_comm, fork_event->parent_pid);
+		printf("...  child: %s/%d\n", fork_event->child_comm, fork_event->child_pid);
+	}
 	register_pid(fork_event->parent_pid, fork_event->parent_comm);
 	register_pid(fork_event->child_pid, fork_event->child_comm);
 }
@@ -918,11 +783,12 @@ process_sched_fork_event(struct trace_fork_event *fork_event, struct event *even
 static void process_sched_exit_event(struct event *event,
 		  int cpu __used, u64 timestamp __used, struct thread *thread __used)
 {
-	printf("sched_exit event %p\n", event);
+	if (verbose)
+		printf("sched_exit event %p\n", event);
 }
 
 static void
-process_raw_event(event_t *raw_event, void *more_data,
+process_raw_event(event_t *raw_event __used, void *more_data,
 		  int cpu, u64 timestamp, struct thread *thread)
 {
 	struct {
@@ -935,14 +801,6 @@ process_raw_event(event_t *raw_event, void *more_data,
 	type = trace_parse_common_type(raw->data);
 	event = trace_find_event(type);
 
-	/*
-	 * FIXME: better resolve from pid from the struct trace_entry
-	 * field, although it should be the same than this perf
-	 * event pid
-	 */
-	printf("id %d, type: %d, event: %s\n",
-		raw_event->header.type, type, event->name);
-
 	if (!strcmp(event->name, "sched_switch"))
 		process_sched_switch_event(more_data, event, cpu, timestamp, thread);
 	if (!strcmp(event->name, "sched_wakeup"))
@@ -1197,7 +1055,7 @@ int cmd_sched(int argc, const char **argv, const char *prefix __used)
 	add_cross_task_wakeups();
 
 	create_tasks();
-	printk("------------------------------------------------------------\n");
+	printf("------------------------------------------------------------\n");
 	for (i = 0; i < nr_iterations; i++)
 		run_one_test();
 
