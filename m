Return-Path: <linux-kernel-owner+w=401wt.eu-S1752111AbZIOJcI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111AbZIOJcI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 05:32:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750975AbZIOJcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 05:32:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:49227 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010AbZIOJbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 05:31:41 -0400
Date: Tue, 15 Sep 2009 09:30:53 GMT
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
Subject: [tip:perfcounters/core] perf sched: Import schedbench.c
Message-ID: <tip-ec156764d424dd67283c2cd5e9f6f1b8388364ac@git.kernel.org>
Git-Commit-ID: ec156764d424dd67283c2cd5e9f6f1b8388364ac
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 15 Sep 2009 09:30:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ec156764d424dd67283c2cd5e9f6f1b8388364ac
Gitweb:     http://git.kernel.org/tip/ec156764d424dd67283c2cd5e9f6f1b8388364ac
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Fri, 11 Sep 2009 12:12:54 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 13 Sep 2009 10:22:37 +0200

perf sched: Import schedbench.c

Import the schedbench.c tool that i wrote some time ago to
simulate scheduler behavior but never finished. It's a good
basis for perf sched nevertheless.

Most of its guts are not hooked up to the perf event loop
yet - that will be done in the patches to come.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-sched.c          |  842 +++++++++++++++++++++++++++++++++-
 tools/perf/util/trace-event-parse.c |   16 +-
 tools/perf/util/trace-event.h       |    2 +
 3 files changed, 827 insertions(+), 33 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 60228d9..c66e6a3 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -12,22 +12,770 @@
 #include "util/debug.h"
 
 #include "util/trace-event.h"
+#include <sys/types.h>
 
-static char		const *input_name = "perf.data";
-static int		input;
-static unsigned long	page_size;
-static unsigned long	mmap_window = 32;
+static char			const *input_name = "perf.data";
+static int			input;
+static unsigned long		page_size;
+static unsigned long		mmap_window = 32;
 
-static unsigned long	total = 0;
-static unsigned long	total_comm = 0;
+static unsigned long		total_comm = 0;
 
-static struct rb_root	threads;
-static struct thread	*last_match;
+static struct rb_root		threads;
+static struct thread		*last_match;
 
-static struct perf_header *header;
-static u64		sample_type;
+static struct perf_header	*header;
+static u64			sample_type;
 
 
+/*
+ * Scheduler benchmarks
+ */
+#include <sys/resource.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/time.h>
+#include <sys/prctl.h>
+
+#include <linux/unistd.h>
+
+#include <semaphore.h>
+#include <pthread.h>
+#include <signal.h>
+#include <values.h>
+#include <string.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <assert.h>
+#include <fcntl.h>
+#include <time.h>
+#include <math.h>
+
+#include <stdio.h>
+
+#define PR_SET_NAME	15               /* Set process name */
+
+#define BUG_ON(x)	assert(!(x))
+
+#define DEBUG		1
+
+typedef unsigned long long nsec_t;
+
+#define printk(x...)		do { printf(x); fflush(stdout); } while (0)
+
+nsec_t prev_printk;
+
+#define __dprintk(x,y...) do {						 \
+	nsec_t __now = get_nsecs(), __delta = __now - prev_printk;	 \
+									 \
+	prev_printk = __now;						 \
+									 \
+	printf("%.3f [%Ld] [%.3f]: " x, (double)__now/1e6, __now, (double)__delta/1e6, y);\
+} while (0)
+
+#if !DEBUG
+# define dprintk(x...)	do { } while (0)
+#else
+# define dprintk(x...)	__dprintk(x)
+#endif
+
+#define __DP()		__dprintk("parent: line %d\n", __LINE__)
+#define DP()		dprintk("parent: line %d\n", __LINE__)
+#define D()		dprintk("task %ld: line %d\n", this_task->nr, __LINE__)
+
+
+static nsec_t run_measurement_overhead;
+static nsec_t sleep_measurement_overhead;
+
+static nsec_t get_nsecs(void)
+{
+	struct timespec ts;
+
+	clock_gettime(CLOCK_MONOTONIC, &ts);
+
+	return ts.tv_sec * 1000000000ULL + ts.tv_nsec;
+}
+
+static void burn_nsecs(nsec_t nsecs)
+{
+	nsec_t T0 = get_nsecs(), T1;
+
+	do {
+		T1 = get_nsecs();
+	} while (T1 + run_measurement_overhead < T0 + nsecs);
+}
+
+static void sleep_nsecs(nsec_t nsecs)
+{
+	struct timespec ts;
+
+	ts.tv_nsec = nsecs % 999999999;
+	ts.tv_sec = nsecs / 999999999;
+
+	nanosleep(&ts, NULL);
+}
+
+static void calibrate_run_measurement_overhead(void)
+{
+	nsec_t T0, T1, delta, min_delta = 1000000000ULL;
+	int i;
+
+	for (i = 0; i < 10; i++) {
+		T0 = get_nsecs();
+		burn_nsecs(0);
+		T1 = get_nsecs();
+		delta = T1-T0;
+		min_delta = min(min_delta, delta);
+	}
+	run_measurement_overhead = min_delta;
+
+	printk("run measurement overhead: %Ld nsecs\n", min_delta);
+}
+
+static void calibrate_sleep_measurement_overhead(void)
+{
+	nsec_t T0, T1, delta, min_delta = 1000000000ULL;
+	int i;
+
+	for (i = 0; i < 10; i++) {
+		T0 = get_nsecs();
+		sleep_nsecs(10000);
+		T1 = get_nsecs();
+		delta = T1-T0;
+		min_delta = min(min_delta, delta);
+	}
+	min_delta -= 10000;
+	sleep_measurement_overhead = min_delta;
+
+	printk("sleep measurement overhead: %Ld nsecs\n", min_delta);
+}
+
+#define COMM_LEN	20
+#define SYM_LEN		129
+
+#define MAX_PID		65536
+
+static unsigned long nr_tasks;
+
+struct sched_event;
+
+struct task_desc {
+	unsigned long		nr;
+	unsigned long		pid;
+	char			comm[COMM_LEN];
+
+	unsigned long		nr_events;
+	unsigned long		curr_event;
+	struct sched_event	**events;
+
+	pthread_t		thread;
+	sem_t			sleep_sem;
+
+	sem_t			ready_for_work;
+	sem_t			work_done_sem;
+
+	nsec_t			cpu_usage;
+};
+
+enum sched_event_type {
+	SCHED_EVENT_RUN,
+	SCHED_EVENT_SLEEP,
+	SCHED_EVENT_WAKEUP,
+};
+
+struct sched_event {
+	enum sched_event_type	type;
+	nsec_t			timestamp;
+	nsec_t			duration;
+	unsigned long		nr;
+	int			specific_wait;
+	sem_t			*wait_sem;
+	struct task_desc	*wakee;
+};
+
+static struct task_desc		*pid_to_task[MAX_PID];
+
+static struct task_desc		**tasks;
+
+static pthread_mutex_t		start_work_mutex = PTHREAD_MUTEX_INITIALIZER;
+static nsec_t			start_time;
+
+static pthread_mutex_t		work_done_wait_mutex = PTHREAD_MUTEX_INITIALIZER;
+
+static unsigned long		nr_run_events;
+static unsigned long		nr_sleep_events;
+static unsigned long		nr_wakeup_events;
+
+static unsigned long		nr_sleep_corrections;
+static unsigned long		nr_run_events_optimized;
+
+static struct sched_event *
+get_new_event(struct task_desc *task, nsec_t timestamp)
+{
+	struct sched_event *event = calloc(1, sizeof(*event));
+	unsigned long idx = task->nr_events;
+	size_t size;
+
+	event->timestamp = timestamp;
+	event->nr = idx;
+
+	task->nr_events++;
+	size = sizeof(struct sched_event *) * task->nr_events;
+	task->events = realloc(task->events, size);
+	BUG_ON(!task->events);
+
+	task->events[idx] = event;
+
+	return event;
+}
+
+static struct sched_event *last_event(struct task_desc *task)
+{
+	if (!task->nr_events)
+		return NULL;
+
+	return task->events[task->nr_events - 1];
+}
+
+static void
+add_sched_event_run(struct task_desc *task, nsec_t timestamp,
+		    unsigned long duration)
+{
+	struct sched_event *event, *curr_event = last_event(task);
+
+	/*
+ 	 * optimize an existing RUN event by merging this one
+ 	 * to it:
+ 	 */
+	if (curr_event && curr_event->type == SCHED_EVENT_RUN) {
+		nr_run_events_optimized++;
+		curr_event->duration += duration;
+		return;
+	}
+
+	event = get_new_event(task, timestamp);
+
+	event->type = SCHED_EVENT_RUN;
+	event->duration = duration;
+
+	nr_run_events++;
+}
+
+static unsigned long targetless_wakeups;
+static unsigned long multitarget_wakeups;
+
+static void
+add_sched_event_wakeup(struct task_desc *task, nsec_t timestamp,
+		       struct task_desc *wakee)
+{
+	struct sched_event *event, *wakee_event;
+
+	event = get_new_event(task, timestamp);
+	event->type = SCHED_EVENT_WAKEUP;
+	event->wakee = wakee;
+
+	wakee_event = last_event(wakee);
+	if (!wakee_event || wakee_event->type != SCHED_EVENT_SLEEP) {
+		targetless_wakeups++;
+		return;
+	}
+	if (wakee_event->wait_sem) {
+		multitarget_wakeups++;
+		return;
+	}
+
+	wakee_event->wait_sem = calloc(1, sizeof(*wakee_event->wait_sem));
+	sem_init(wakee_event->wait_sem, 0, 0);
+	wakee_event->specific_wait = 1;
+	event->wait_sem = wakee_event->wait_sem;
+
+	nr_wakeup_events++;
+}
+
+static void
+add_sched_event_sleep(struct task_desc *task, nsec_t timestamp,
+		      unsigned long uninterruptible __used)
+{
+	struct sched_event *event = get_new_event(task, timestamp);
+
+	event->type = SCHED_EVENT_SLEEP;
+
+	nr_sleep_events++;
+}
+
+static struct task_desc *register_pid(unsigned long pid, const char *comm)
+{
+	struct task_desc *task;
+
+	BUG_ON(pid >= MAX_PID);
+
+	task = pid_to_task[pid];
+
+	if (task)
+		return task;
+
+	task = calloc(1, sizeof(*task));
+	task->pid = pid;
+	task->nr = nr_tasks;
+	strcpy(task->comm, comm);
+	/*
+	 * every task starts in sleeping state - this gets ignored
+	 * if there's no wakeup pointing to this sleep state:
+	 */
+	add_sched_event_sleep(task, 0, 0);
+
+	pid_to_task[pid] = task;
+	nr_tasks++;
+	tasks = realloc(tasks, nr_tasks*sizeof(struct task_task *));
+	BUG_ON(!tasks);
+	tasks[task->nr] = task;
+
+	printk("registered task #%ld, PID %ld (%s)\n", nr_tasks, pid, comm);
+
+	return task;
+}
+
+
+static int first_trace_line = 1;
+
+static nsec_t first_timestamp;
+static nsec_t prev_timestamp;
+
+void parse_line(char *line);
+
+void parse_line(char *line)
+{
+	unsigned long param1 = 0, param2 = 0;
+	char comm[COMM_LEN], comm2[COMM_LEN];
+	unsigned long pid, pid2, timestamp0;
+	struct task_desc *task, *task2;
+	char func_str[SYM_LEN];
+	nsec_t timestamp;
+	int ret;
+
+	//"   <idle> 0     0D.s3    0us+: try_to_wake_up <events/0 9> (1 0)"
+	ret = sscanf(line, "%20s %5ld %*s %ldus%*c:"
+			   " %128s <%20s %ld> (%ld %ld)\n",
+		comm, &pid, &timestamp0,
+		func_str, comm2, &pid2, &param1, &param2);
+	dprintk("ret: %d\n", ret);
+	if (ret != 8)
+		return;
+
+	timestamp = timestamp0 * 1000LL;
+
+	if (first_trace_line) {
+		first_trace_line = 0;
+		first_timestamp = timestamp;
+	}
+
+	timestamp -= first_timestamp;
+	BUG_ON(timestamp < prev_timestamp);
+	prev_timestamp = timestamp;
+
+	dprintk("parsed: %s - %ld %Ld: %s - <%s %ld> (%ld %ld)\n",
+		comm,
+		pid,
+		timestamp, 
+		func_str,
+		comm2,
+		pid2,
+		param1,
+		param2);
+
+	task = register_pid(pid, comm);
+	task2 = register_pid(pid2, comm2);
+
+	if (!strcmp(func_str, "update_curr")) {
+		dprintk("%Ld: task %ld runs for %ld nsecs\n",
+			timestamp, task->nr, param1);
+		add_sched_event_run(task, timestamp, param1);
+	} else if (!strcmp(func_str, "try_to_wake_up")) {
+		dprintk("%Ld: task %ld wakes up task %ld\n",
+			timestamp, task->nr, task2->nr);
+		add_sched_event_wakeup(task, timestamp, task2);
+	} else if (!strcmp(func_str, "deactivate_task")) {
+		dprintk("%Ld: task %ld goes to sleep (uninterruptible: %ld)\n",
+			timestamp, task->nr, param1);
+		add_sched_event_sleep(task, timestamp, param1);
+	}
+}
+
+static void print_task_traces(void)
+{
+	struct task_desc *task;
+	unsigned long i;
+
+	for (i = 0; i < nr_tasks; i++) {
+		task = tasks[i];
+		printk("task %6ld (%20s:%10ld), nr_events: %ld\n",
+			task->nr, task->comm, task->pid, task->nr_events);
+	}
+}
+
+static void add_cross_task_wakeups(void)
+{
+	struct task_desc *task1, *task2;
+	unsigned long i, j;
+
+	for (i = 0; i < nr_tasks; i++) {
+		task1 = tasks[i];
+		j = i + 1;
+		if (j == nr_tasks)
+			j = 0;
+		task2 = tasks[j];
+		add_sched_event_wakeup(task1, 0, task2);
+	}
+}
+
+static void
+process_sched_event(struct task_desc *this_task, struct sched_event *event)
+{
+	int ret = 0;
+	nsec_t now;
+	long long delta;
+
+	now = get_nsecs();
+	delta = start_time + event->timestamp - now;
+
+	dprintk("task %ld, event #%ld, %Ld, delta: %.3f (%Ld)\n",
+		this_task->nr, event->nr, event->timestamp,
+		(double)delta/1e6, delta);
+
+	if (0 && delta > 0) {
+		dprintk("%.3f: task %ld FIX %.3f\n",
+			(double)event->timestamp/1e6,
+			this_task->nr,
+			(double)delta/1e6);
+		sleep_nsecs(start_time + event->timestamp - now);
+		nr_sleep_corrections++;
+	}
+
+	switch (event->type) {
+		case SCHED_EVENT_RUN:
+			dprintk("%.3f: task %ld RUN for %.3f\n",
+				(double)event->timestamp/1e6,
+				this_task->nr,
+				(double)event->duration/1e6);
+			burn_nsecs(event->duration);
+			break;
+		case SCHED_EVENT_SLEEP:
+			dprintk("%.3f: task %ld %s SLEEP\n",
+				(double)event->timestamp/1e6,
+				this_task->nr, event->wait_sem ? "" : "SKIP");
+			if (event->wait_sem)
+				ret = sem_wait(event->wait_sem);
+			BUG_ON(ret);
+			break;
+		case SCHED_EVENT_WAKEUP:
+			dprintk("%.3f: task %ld WAKEUP => task %ld\n",
+				(double)event->timestamp/1e6,
+				this_task->nr,
+				event->wakee->nr);
+			if (event->wait_sem)
+				ret = sem_post(event->wait_sem);
+			BUG_ON(ret);
+			break;
+		default:
+			BUG_ON(1);
+	}
+}
+
+static nsec_t get_cpu_usage_nsec_parent(void)
+{
+	struct rusage ru;
+	nsec_t sum;
+	int err;
+
+	err = getrusage(RUSAGE_SELF, &ru);
+	BUG_ON(err);
+
+	sum =  ru.ru_utime.tv_sec*1e9 + ru.ru_utime.tv_usec*1e3;
+	sum += ru.ru_stime.tv_sec*1e9 + ru.ru_stime.tv_usec*1e3;
+
+	return sum;
+}
+
+static nsec_t get_cpu_usage_nsec_self(void)
+{
+	char filename [] = "/proc/1234567890/sched";
+	unsigned long msecs, nsecs;
+	char *line = NULL;
+	nsec_t total = 0;
+	size_t len = 0;
+	ssize_t chars;
+	FILE *file;
+	int ret;
+
+	sprintf(filename, "/proc/%d/sched", getpid());
+	file = fopen(filename, "r");
+	BUG_ON(!file);
+
+	while ((chars = getline(&line, &len, file)) != -1) {
+		dprintk("got line with length %zu :\n", chars);
+		dprintk("%s", line);
+		ret = sscanf(line, "se.sum_exec_runtime : %ld.%06ld\n",
+			&msecs, &nsecs);
+		if (ret == 2) {
+			total = msecs*1e6 + nsecs;
+			dprintk("total: (%ld.%06ld) %Ld\n",
+				msecs, nsecs, total);
+			break;
+		}
+	}
+	if (line)
+		free(line);
+	fclose(file);
+
+	return total;
+}
+
+static void *thread_func(void *ctx)
+{
+	struct task_desc *this_task = ctx;
+	nsec_t cpu_usage_0, cpu_usage_1;
+	unsigned long i, ret;
+	char comm2[22];
+
+	dprintk("task %ld started up.\n", this_task->nr);
+	sprintf(comm2, ":%s", this_task->comm);
+	prctl(PR_SET_NAME, comm2);
+
+again:
+	ret = sem_post(&this_task->ready_for_work);
+	BUG_ON(ret);
+	D();
+	ret = pthread_mutex_lock(&start_work_mutex);
+	BUG_ON(ret);
+	ret = pthread_mutex_unlock(&start_work_mutex);
+	BUG_ON(ret);
+	D();
+
+	cpu_usage_0 = get_cpu_usage_nsec_self();
+
+	for (i = 0; i < this_task->nr_events; i++) {
+		this_task->curr_event = i;
+		process_sched_event(this_task, this_task->events[i]);
+	}
+
+	cpu_usage_1 = get_cpu_usage_nsec_self();
+	this_task->cpu_usage = cpu_usage_1 - cpu_usage_0;
+
+	dprintk("task %ld cpu usage: %0.3f msecs\n",
+		this_task->nr, (double)this_task->cpu_usage / 1e6);
+
+	D();
+	ret = sem_post(&this_task->work_done_sem);
+	BUG_ON(ret);
+	D();
+
+	ret = pthread_mutex_lock(&work_done_wait_mutex);
+	BUG_ON(ret);
+	ret = pthread_mutex_unlock(&work_done_wait_mutex);
+	BUG_ON(ret);
+	D();
+
+	goto again;
+}
+
+static void create_tasks(void)
+{
+	struct task_desc *task;
+	pthread_attr_t attr;
+	unsigned long i;
+	int err;
+
+	err = pthread_attr_init(&attr);
+	BUG_ON(err);
+	err = pthread_attr_setstacksize(&attr, (size_t)(16*1024));
+	BUG_ON(err);
+	err = pthread_mutex_lock(&start_work_mutex);
+	BUG_ON(err);
+	err = pthread_mutex_lock(&work_done_wait_mutex);
+	BUG_ON(err);
+	for (i = 0; i < nr_tasks; i++) {
+		task = tasks[i];
+		sem_init(&task->sleep_sem, 0, 0);
+		sem_init(&task->ready_for_work, 0, 0);
+		sem_init(&task->work_done_sem, 0, 0);
+		task->curr_event = 0;
+		err = pthread_create(&task->thread, &attr, thread_func, task);
+		BUG_ON(err);
+	}
+}
+
+static nsec_t cpu_usage;
+static nsec_t runavg_cpu_usage;
+static nsec_t parent_cpu_usage;
+static nsec_t runavg_parent_cpu_usage;
+
+static void wait_for_tasks(void)
+{
+	nsec_t cpu_usage_0, cpu_usage_1;
+	struct task_desc *task;
+	unsigned long i, ret;
+
+	DP();
+	start_time = get_nsecs();
+	DP();
+	cpu_usage = 0;
+	pthread_mutex_unlock(&work_done_wait_mutex);
+
+	for (i = 0; i < nr_tasks; i++) {
+		task = tasks[i];
+		ret = sem_wait(&task->ready_for_work);
+		BUG_ON(ret);
+		sem_init(&task->ready_for_work, 0, 0);
+	}
+	ret = pthread_mutex_lock(&work_done_wait_mutex);
+	BUG_ON(ret);
+
+	cpu_usage_0 = get_cpu_usage_nsec_parent();
+
+	pthread_mutex_unlock(&start_work_mutex);
+
+#if 0
+	for (i = 0; i < nr_tasks; i++) {
+		unsigned long missed;
+
+		task = tasks[i];
+		while (task->curr_event + 1 < task->nr_events) {
+			dprintk("parent waiting for %ld (%ld != %ld)\n",
+				i, task->curr_event, task->nr_events);
+			sleep_nsecs(100000000);
+		}
+		missed = task->nr_events - 1 - task->curr_event;
+		if (missed)
+			printk("task %ld missed events: %ld\n", i, missed);
+		ret = sem_post(&task->sleep_sem);
+		BUG_ON(ret);
+	}
+#endif
+	DP();
+	for (i = 0; i < nr_tasks; i++) {
+		task = tasks[i];
+		ret = sem_wait(&task->work_done_sem);
+		BUG_ON(ret);
+		sem_init(&task->work_done_sem, 0, 0);
+		cpu_usage += task->cpu_usage;
+		task->cpu_usage = 0;
+	}
+
+	cpu_usage_1 = get_cpu_usage_nsec_parent();
+	if (!runavg_cpu_usage)
+		runavg_cpu_usage = cpu_usage;
+	runavg_cpu_usage = (runavg_cpu_usage*9 + cpu_usage)/10;
+
+	parent_cpu_usage = cpu_usage_1 - cpu_usage_0;
+	if (!runavg_parent_cpu_usage)
+		runavg_parent_cpu_usage = parent_cpu_usage;
+	runavg_parent_cpu_usage = (runavg_parent_cpu_usage*9 +
+				   parent_cpu_usage)/10;
+
+	ret = pthread_mutex_lock(&start_work_mutex);
+	BUG_ON(ret);
+
+	for (i = 0; i < nr_tasks; i++) {
+		task = tasks[i];
+		sem_init(&task->sleep_sem, 0, 0);
+		task->curr_event = 0;
+	}
+}
+
+static int __cmd_sched(void);
+
+static void parse_trace(void)
+{
+	__cmd_sched();
+
+	printk("nr_run_events:        %ld\n", nr_run_events);
+	printk("nr_sleep_events:      %ld\n", nr_sleep_events);
+	printk("nr_wakeup_events:     %ld\n", nr_wakeup_events);
+
+	if (targetless_wakeups)
+		printk("target-less wakeups:  %ld\n", targetless_wakeups);
+	if (multitarget_wakeups)
+		printk("multi-target wakeups: %ld\n", multitarget_wakeups);
+	if (nr_run_events_optimized)
+		printk("run events optimized: %ld\n",
+			nr_run_events_optimized);
+}
+
+static unsigned long nr_runs;
+static nsec_t sum_runtime;
+static nsec_t sum_fluct;
+static nsec_t run_avg;
+
+static void run_one_test(void)
+{
+	nsec_t T0, T1, delta, avg_delta, fluct, std_dev;
+
+	T0 = get_nsecs();
+	wait_for_tasks();
+	T1 = get_nsecs();
+
+	delta = T1 - T0;
+	sum_runtime += delta;
+	nr_runs++;
+
+	avg_delta = sum_runtime / nr_runs;
+	if (delta < avg_delta)
+		fluct = avg_delta - delta;
+	else
+		fluct = delta - avg_delta;
+	sum_fluct += fluct;
+	std_dev = sum_fluct / nr_runs / sqrt(nr_runs);
+	if (!run_avg)
+		run_avg = delta;
+	run_avg = (run_avg*9 + delta)/10;
+
+	printk("#%-3ld: %0.3f, ",
+		nr_runs, (double)delta/1000000.0);
+
+#if 0
+	printk("%0.2f +- %0.2f, ",
+		(double)avg_delta/1e6, (double)std_dev/1e6);
+#endif
+	printk("ravg: %0.2f, ",
+		(double)run_avg/1e6);
+
+	printk("cpu: %0.2f / %0.2f",
+		(double)cpu_usage/1e6, (double)runavg_cpu_usage/1e6);
+
+#if 0
+	/*
+ 	 * rusage statistics done by the parent, these are less
+ 	 * accurate than the sum_exec_runtime based statistics:
+ 	 */
+	printk(" [%0.2f / %0.2f]",
+		(double)parent_cpu_usage/1e6,
+		(double)runavg_parent_cpu_usage/1e6);
+#endif
+
+	printk("\n");
+
+	if (nr_sleep_corrections)
+		printk(" (%ld sleep corrections)\n", nr_sleep_corrections);
+	nr_sleep_corrections = 0;
+}
+
+static void test_calibrations(void)
+{
+	nsec_t T0, T1;
+
+	T0 = get_nsecs();
+	burn_nsecs(1e6);
+	T1 = get_nsecs();
+
+	printk("the run test took %Ld nsecs\n", T1-T0);
+
+	T0 = get_nsecs();
+	sleep_nsecs(1e6);
+	T1 = get_nsecs();
+
+	printk("the sleep test took %Ld nsecs\n", T1-T0);
+}
+
 static int
 process_comm_event(event_t *event, unsigned long offset, unsigned long head)
 {
@@ -50,6 +798,46 @@ process_comm_event(event_t *event, unsigned long offset, unsigned long head)
 	return 0;
 }
 
+static void process_sched_wakeup_event(struct event *event,
+		  int cpu __used, u64 timestamp __used, struct thread *thread __used)
+{
+	printf("sched_wakeup event %p\n", event);
+}
+
+static void process_sched_switch_event(struct event *event,
+		  int cpu __used, u64 timestamp __used, struct thread *thread __used)
+{
+	printf("sched_switch event %p\n", event);
+}
+
+static void
+process_raw_event(event_t *raw_event, void *more_data,
+		  int cpu, u64 timestamp, struct thread *thread)
+{
+	struct {
+		u32 size;
+		char data[0];
+	} *raw = more_data;
+	struct event *event;
+	int type;
+
+	type = trace_parse_common_type(raw->data);
+	event = trace_find_event(type);
+
+	/*
+	 * FIXME: better resolve from pid from the struct trace_entry
+	 * field, although it should be the same than this perf
+	 * event pid
+	 */
+	printf("id %d, type: %d, event: %s\n",
+		raw_event->header.type, type, event->name);
+
+	if (!strcmp(event->name, "sched_switch"))
+		process_sched_switch_event(event, cpu, timestamp, thread);
+	if (!strcmp(event->name, "sched_wakeup"))
+		process_sched_wakeup_event(event, cpu, timestamp, thread);
+}
+
 static int
 process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 {
@@ -122,20 +910,8 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 		dump_printf(" ...... dso: [hypervisor]\n");
 	}
 
-	if (sample_type & PERF_SAMPLE_RAW) {
-		struct {
-			u32 size;
-			char data[0];
-		} *raw = more_data;
-
-		/*
-		 * FIXME: better resolve from pid from the struct trace_entry
-		 * field, although it should be the same than this perf
-		 * event pid
-		 */
-		print_event(cpu, raw->data, raw->size, timestamp, thread->comm);
-	}
-	total += period;
+	if (sample_type & PERF_SAMPLE_RAW)
+		process_raw_event(event, more_data, cpu, timestamp, thread);
 
 	return 0;
 }
@@ -277,6 +1053,8 @@ static const struct option options[] = {
 
 int cmd_sched(int argc, const char **argv, const char *prefix __used)
 {
+	long nr_iterations = LONG_MAX, i;
+
 	symbol__init();
 	page_size = getpagesize();
 
@@ -293,5 +1071,19 @@ int cmd_sched(int argc, const char **argv, const char *prefix __used)
 
 	setup_pager();
 
-	return __cmd_sched();
+	calibrate_run_measurement_overhead();
+	calibrate_sleep_measurement_overhead();
+
+	test_calibrations();
+
+	parse_trace();
+	print_task_traces();
+	add_cross_task_wakeups();
+
+	create_tasks();
+	printk("------------------------------------------------------------\n");
+	for (i = 0; i < nr_iterations; i++)
+		run_one_test();
+
+	return 0;
 }
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 629e602..16cf2d5 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -1799,7 +1799,7 @@ static int get_common_info(const char *type, int *offset, int *size)
 	return 0;
 }
 
-static int parse_common_type(void *data)
+int trace_parse_common_type(void *data)
 {
 	static int type_offset;
 	static int type_size;
@@ -1832,7 +1832,7 @@ static int parse_common_pid(void *data)
 	return read_size(data + pid_offset, pid_size);
 }
 
-static struct event *find_event(int id)
+struct event *trace_find_event(int id)
 {
 	struct event *event;
 
@@ -2420,8 +2420,8 @@ get_return_for_leaf(int cpu, int cur_pid, unsigned long long cur_func,
 	int type;
 	int pid;
 
-	type = parse_common_type(next->data);
-	event = find_event(type);
+	type = trace_parse_common_type(next->data);
+	event = trace_find_event(type);
 	if (!event)
 		return NULL;
 
@@ -2502,8 +2502,8 @@ print_graph_entry_leaf(struct event *event, void *data, struct record *ret_rec)
 	int type;
 	int i;
 
-	type = parse_common_type(ret_rec->data);
-	ret_event = find_event(type);
+	type = trace_parse_common_type(ret_rec->data);
+	ret_event = trace_find_event(type);
 
 	field = find_field(ret_event, "rettime");
 	if (!field)
@@ -2696,9 +2696,9 @@ void print_event(int cpu, void *data, int size, unsigned long long nsecs,
 	nsecs -= secs * NSECS_PER_SEC;
 	usecs = nsecs / NSECS_PER_USEC;
 
-	type = parse_common_type(data);
+	type = trace_parse_common_type(data);
 
-	event = find_event(type);
+	event = trace_find_event(type);
 	if (!event)
 		die("ug! no event found for type %d", type);
 
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index 420294a..bc81612 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -234,6 +234,8 @@ extern int header_page_data_offset;
 extern int header_page_data_size;
 
 int parse_header_page(char *buf, unsigned long size);
+int trace_parse_common_type(void *data);
+struct event *trace_find_event(int id);
 
 void read_tracing_data(struct perf_counter_attr *pattrs, int nb_counters);
 
