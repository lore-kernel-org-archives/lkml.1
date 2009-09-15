Return-Path: <linux-kernel-owner+w=401wt.eu-S1752593AbZIOJhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593AbZIOJhl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 05:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752430AbZIOJhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 05:37:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:57508 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752417AbZIOJhe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 05:37:34 -0400
Date: Tue, 15 Sep 2009 09:36:56 GMT
From: tip-bot for mingo <mingo@europe (none)>
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
Subject: [tip:perfcounters/core] perf sched: Add support for sched:sched_stat_runtime events
Message-ID: <tip-39aeb52f99f2380c1f16036deed2f7bb8b2e0559@git.kernel.org>
Git-Commit-ID: 39aeb52f99f2380c1f16036deed2f7bb8b2e0559
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 15 Sep 2009 09:37:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  39aeb52f99f2380c1f16036deed2f7bb8b2e0559
Gitweb:     http://git.kernel.org/tip/39aeb52f99f2380c1f16036deed2f7bb8b2e0559
Author:     mingo <mingo@europe.(none)>
AuthorDate: Mon, 14 Sep 2009 20:04:48 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 14 Sep 2009 20:08:23 +0200

perf sched: Add support for sched:sched_stat_runtime events

This allows more precise 'perf sched latency' output:

 ---------------------------------------------------------------------------------------
  Task                  |  Runtime ms | Switches | Average delay ms | Maximum delay ms |
 ---------------------------------------------------------------------------------------
  ksoftirqd/0-4         |    0.010 ms |        2 | avg:    2.476 ms | max:    2.977 ms |
  perf-12328            |   15.844 ms |       66 | avg:    1.118 ms | max:    9.979 ms |
  bdi-default-235       |    0.009 ms |        1 | avg:    0.998 ms | max:    0.998 ms |
  events/1-8            |    0.020 ms |        2 | avg:    0.998 ms | max:    0.998 ms |
  events/0-7            |    0.018 ms |        2 | avg:    0.992 ms | max:    0.996 ms |
  sleep-12329           |    0.742 ms |        3 | avg:    0.906 ms | max:    2.289 ms |
  sshd-12122            |    0.163 ms |        2 | avg:    0.283 ms | max:    0.562 ms |
  loop-getpid-lon-12322 | 1023.636 ms |       69 | avg:    0.208 ms | max:    5.996 ms |
  loop-getpid-lon-12321 | 1038.638 ms |        5 | avg:    0.073 ms | max:    0.171 ms |
  migration/1-5         |    0.000 ms |        1 | avg:    0.006 ms | max:    0.006 ms |
 ---------------------------------------------------------------------------------------
  TOTAL:                | 2079.078 ms |      153 |
 -------------------------------------------------

Also, streamline the code a bit more, add asserts for various state
machine failures (they should be debugged if they occur) and fix
a few odd ends.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-sched.c |  264 +++++++++++++++++++++++++++++---------------
 1 files changed, 173 insertions(+), 91 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 93ef7b2..adcb563 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -50,7 +50,7 @@ static u64			sleep_measurement_overhead;
 
 static unsigned long		nr_tasks;
 
-struct sched_event;
+struct sched_atom;
 
 struct task_desc {
 	unsigned long		nr;
@@ -59,7 +59,7 @@ struct task_desc {
 
 	unsigned long		nr_events;
 	unsigned long		curr_event;
-	struct sched_event	**events;
+	struct sched_atom	**atoms;
 
 	pthread_t		thread;
 	sem_t			sleep_sem;
@@ -76,7 +76,7 @@ enum sched_event_type {
 	SCHED_EVENT_WAKEUP,
 };
 
-struct sched_event {
+struct sched_atom {
 	enum sched_event_type	type;
 	u64			timestamp;
 	u64			duration;
@@ -137,8 +137,8 @@ struct work_atom {
 	u64			runtime;
 };
 
-struct task_atoms {
-	struct list_head	atom_list;
+struct work_atoms {
+	struct list_head	work_list;
 	struct thread		*thread;
 	struct rb_node		node;
 	u64			max_lat;
@@ -147,7 +147,7 @@ struct task_atoms {
 	u64			total_runtime;
 };
 
-typedef int (*sort_fn_t)(struct task_atoms *, struct task_atoms *);
+typedef int (*sort_fn_t)(struct work_atoms *, struct work_atoms *);
 
 static struct rb_root		atom_root, sorted_atom_root;
 
@@ -220,10 +220,10 @@ static void calibrate_sleep_measurement_overhead(void)
 	printf("sleep measurement overhead: %Ld nsecs\n", min_delta);
 }
 
-static struct sched_event *
+static struct sched_atom *
 get_new_event(struct task_desc *task, u64 timestamp)
 {
-	struct sched_event *event = calloc(1, sizeof(*event));
+	struct sched_atom *event = calloc(1, sizeof(*event));
 	unsigned long idx = task->nr_events;
 	size_t size;
 
@@ -231,27 +231,27 @@ get_new_event(struct task_desc *task, u64 timestamp)
 	event->nr = idx;
 
 	task->nr_events++;
-	size = sizeof(struct sched_event *) * task->nr_events;
-	task->events = realloc(task->events, size);
-	BUG_ON(!task->events);
+	size = sizeof(struct sched_atom *) * task->nr_events;
+	task->atoms = realloc(task->atoms, size);
+	BUG_ON(!task->atoms);
 
-	task->events[idx] = event;
+	task->atoms[idx] = event;
 
 	return event;
 }
 
-static struct sched_event *last_event(struct task_desc *task)
+static struct sched_atom *last_event(struct task_desc *task)
 {
 	if (!task->nr_events)
 		return NULL;
 
-	return task->events[task->nr_events - 1];
+	return task->atoms[task->nr_events - 1];
 }
 
 static void
 add_sched_event_run(struct task_desc *task, u64 timestamp, u64 duration)
 {
-	struct sched_event *event, *curr_event = last_event(task);
+	struct sched_atom *event, *curr_event = last_event(task);
 
 	/*
 	 * optimize an existing RUN event by merging this one
@@ -275,7 +275,7 @@ static void
 add_sched_event_wakeup(struct task_desc *task, u64 timestamp,
 		       struct task_desc *wakee)
 {
-	struct sched_event *event, *wakee_event;
+	struct sched_atom *event, *wakee_event;
 
 	event = get_new_event(task, timestamp);
 	event->type = SCHED_EVENT_WAKEUP;
@@ -303,7 +303,7 @@ static void
 add_sched_event_sleep(struct task_desc *task, u64 timestamp,
 		      u64 task_state __used)
 {
-	struct sched_event *event = get_new_event(task, timestamp);
+	struct sched_atom *event = get_new_event(task, timestamp);
 
 	event->type = SCHED_EVENT_SLEEP;
 
@@ -372,27 +372,27 @@ static void add_cross_task_wakeups(void)
 }
 
 static void
-process_sched_event(struct task_desc *this_task __used, struct sched_event *event)
+process_sched_event(struct task_desc *this_task __used, struct sched_atom *atom)
 {
 	int ret = 0;
 	u64 now;
 	long long delta;
 
 	now = get_nsecs();
-	delta = start_time + event->timestamp - now;
+	delta = start_time + atom->timestamp - now;
 
-	switch (event->type) {
+	switch (atom->type) {
 		case SCHED_EVENT_RUN:
-			burn_nsecs(event->duration);
+			burn_nsecs(atom->duration);
 			break;
 		case SCHED_EVENT_SLEEP:
-			if (event->wait_sem)
-				ret = sem_wait(event->wait_sem);
+			if (atom->wait_sem)
+				ret = sem_wait(atom->wait_sem);
 			BUG_ON(ret);
 			break;
 		case SCHED_EVENT_WAKEUP:
-			if (event->wait_sem)
-				ret = sem_post(event->wait_sem);
+			if (atom->wait_sem)
+				ret = sem_post(atom->wait_sem);
 			BUG_ON(ret);
 			break;
 		default:
@@ -467,7 +467,7 @@ again:
 
 	for (i = 0; i < this_task->nr_events; i++) {
 		this_task->curr_event = i;
-		process_sched_event(this_task, this_task->events[i]);
+		process_sched_event(this_task, this_task->atoms[i]);
 	}
 
 	cpu_usage_1 = get_cpu_usage_nsec_self();
@@ -649,7 +649,7 @@ static void __cmd_replay(void)
 	if (multitarget_wakeups)
 		printf("multi-target wakeups: %ld\n", multitarget_wakeups);
 	if (nr_run_events_optimized)
-		printf("run events optimized: %ld\n",
+		printf("run atoms optimized: %ld\n",
 			nr_run_events_optimized);
 
 	print_task_traces();
@@ -727,6 +727,20 @@ struct trace_switch_event {
 	u32 next_prio;
 };
 
+struct trace_runtime_event {
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
+	u64 runtime;
+	u64 vruntime;
+};
 
 struct trace_wakeup_event {
 	u32 size;
@@ -767,6 +781,12 @@ struct trace_sched_handler {
 			     u64 timestamp,
 			     struct thread *thread);
 
+	void (*runtime_event)(struct trace_runtime_event *,
+			      struct event *,
+			      int cpu,
+			      u64 timestamp,
+			      struct thread *thread);
+
 	void (*wakeup_event)(struct trace_wakeup_event *,
 			     struct event *,
 			     int cpu,
@@ -881,7 +901,7 @@ struct sort_dimension {
 static LIST_HEAD(cmp_pid);
 
 static int
-thread_lat_cmp(struct list_head *list, struct task_atoms *l, struct task_atoms *r)
+thread_lat_cmp(struct list_head *list, struct work_atoms *l, struct work_atoms *r)
 {
 	struct sort_dimension *sort;
 	int ret = 0;
@@ -897,18 +917,18 @@ thread_lat_cmp(struct list_head *list, struct task_atoms *l, struct task_atoms *
 	return ret;
 }
 
-static struct task_atoms *
+static struct work_atoms *
 thread_atoms_search(struct rb_root *root, struct thread *thread,
 			 struct list_head *sort_list)
 {
 	struct rb_node *node = root->rb_node;
-	struct task_atoms key = { .thread = thread };
+	struct work_atoms key = { .thread = thread };
 
 	while (node) {
-		struct task_atoms *atoms;
+		struct work_atoms *atoms;
 		int cmp;
 
-		atoms = container_of(node, struct task_atoms, node);
+		atoms = container_of(node, struct work_atoms, node);
 
 		cmp = thread_lat_cmp(sort_list, &key, atoms);
 		if (cmp > 0)
@@ -924,16 +944,16 @@ thread_atoms_search(struct rb_root *root, struct thread *thread,
 }
 
 static void
-__thread_latency_insert(struct rb_root *root, struct task_atoms *data,
+__thread_latency_insert(struct rb_root *root, struct work_atoms *data,
 			 struct list_head *sort_list)
 {
 	struct rb_node **new = &(root->rb_node), *parent = NULL;
 
 	while (*new) {
-		struct task_atoms *this;
+		struct work_atoms *this;
 		int cmp;
 
-		this = container_of(*new, struct task_atoms, node);
+		this = container_of(*new, struct work_atoms, node);
 		parent = *new;
 
 		cmp = thread_lat_cmp(sort_list, data, this);
@@ -950,14 +970,14 @@ __thread_latency_insert(struct rb_root *root, struct task_atoms *data,
 
 static void thread_atoms_insert(struct thread *thread)
 {
-	struct task_atoms *atoms;
+	struct work_atoms *atoms;
 
 	atoms = calloc(sizeof(*atoms), 1);
 	if (!atoms)
 		die("No memory");
 
 	atoms->thread = thread;
-	INIT_LIST_HEAD(&atoms->atom_list);
+	INIT_LIST_HEAD(&atoms->work_list);
 	__thread_latency_insert(&atom_root, atoms, &cmp_pid);
 }
 
@@ -980,10 +1000,9 @@ static char sched_out_state(struct trace_switch_event *switch_event)
 }
 
 static void
-lat_sched_out(struct task_atoms *atoms,
-	      struct trace_switch_event *switch_event __used,
-	      u64 delta,
-	      u64 timestamp)
+add_sched_out_event(struct work_atoms *atoms,
+		    char run_state,
+		    u64 timestamp)
 {
 	struct work_atom *atom;
 
@@ -993,25 +1012,37 @@ lat_sched_out(struct task_atoms *atoms,
 
 	atom->sched_out_time = timestamp;
 
-	if (sched_out_state(switch_event) == 'R') {
+	if (run_state == 'R') {
 		atom->state = THREAD_WAIT_CPU;
 		atom->wake_up_time = atom->sched_out_time;
 	}
 
-	atom->runtime = delta;
-	list_add_tail(&atom->list, &atoms->atom_list);
+	list_add_tail(&atom->list, &atoms->work_list);
+}
+
+static void
+add_runtime_event(struct work_atoms *atoms, u64 delta, u64 timestamp __used)
+{
+	struct work_atom *atom;
+
+	BUG_ON(list_empty(&atoms->work_list));
+
+	atom = list_entry(atoms->work_list.prev, struct work_atom, list);
+
+	atom->runtime += delta;
+	atoms->total_runtime += delta;
 }
 
 static void
-lat_sched_in(struct task_atoms *atoms, u64 timestamp)
+add_sched_in_event(struct work_atoms *atoms, u64 timestamp)
 {
 	struct work_atom *atom;
 	u64 delta;
 
-	if (list_empty(&atoms->atom_list))
+	if (list_empty(&atoms->work_list))
 		return;
 
-	atom = list_entry(atoms->atom_list.prev, struct work_atom, list);
+	atom = list_entry(atoms->work_list.prev, struct work_atom, list);
 
 	if (atom->state != THREAD_WAIT_CPU)
 		return;
@@ -1029,7 +1060,6 @@ lat_sched_in(struct task_atoms *atoms, u64 timestamp)
 	if (delta > atoms->max_lat)
 		atoms->max_lat = delta;
 	atoms->nb_atoms++;
-	atoms->total_runtime += atom->runtime;
 }
 
 static void
@@ -1039,13 +1069,12 @@ latency_switch_event(struct trace_switch_event *switch_event,
 		     u64 timestamp,
 		     struct thread *thread __used)
 {
-	struct task_atoms *out_atoms, *in_atoms;
+	struct work_atoms *out_events, *in_events;
 	struct thread *sched_out, *sched_in;
 	u64 timestamp0;
 	s64 delta;
 
-	if (cpu >= MAX_CPUS || cpu < 0)
-		return;
+	BUG_ON(cpu >= MAX_CPUS || cpu < 0);
 
 	timestamp0 = cpu_last_switched[cpu];
 	cpu_last_switched[cpu] = timestamp;
@@ -1061,34 +1090,63 @@ latency_switch_event(struct trace_switch_event *switch_event,
 	sched_out = threads__findnew(switch_event->prev_pid, &threads, &last_match);
 	sched_in = threads__findnew(switch_event->next_pid, &threads, &last_match);
 
-	in_atoms = thread_atoms_search(&atom_root, sched_in, &cmp_pid);
-	if (!in_atoms) {
+	out_events = thread_atoms_search(&atom_root, sched_out, &cmp_pid);
+	if (!out_events) {
+		thread_atoms_insert(sched_out);
+		out_events = thread_atoms_search(&atom_root, sched_out, &cmp_pid);
+		if (!out_events)
+			die("out-event: Internal tree error");
+	}
+	add_sched_out_event(out_events, sched_out_state(switch_event), timestamp);
+
+	in_events = thread_atoms_search(&atom_root, sched_in, &cmp_pid);
+	if (!in_events) {
 		thread_atoms_insert(sched_in);
-		in_atoms = thread_atoms_search(&atom_root, sched_in, &cmp_pid);
-		if (!in_atoms)
-			die("in-atom: Internal tree error");
+		in_events = thread_atoms_search(&atom_root, sched_in, &cmp_pid);
+		if (!in_events)
+			die("in-event: Internal tree error");
+		/*
+		 * Take came in we have not heard about yet,
+		 * add in an initial atom in runnable state:
+		 */
+		add_sched_out_event(in_events, 'R', timestamp);
 	}
+	add_sched_in_event(in_events, timestamp);
+}
 
-	out_atoms = thread_atoms_search(&atom_root, sched_out, &cmp_pid);
-	if (!out_atoms) {
-		thread_atoms_insert(sched_out);
-		out_atoms = thread_atoms_search(&atom_root, sched_out, &cmp_pid);
-		if (!out_atoms)
-			die("out-atom: Internal tree error");
+static void
+latency_runtime_event(struct trace_runtime_event *runtime_event,
+		     struct event *event __used,
+		     int cpu,
+		     u64 timestamp,
+		     struct thread *this_thread __used)
+{
+	struct work_atoms *atoms;
+	struct thread *thread;
+
+	BUG_ON(cpu >= MAX_CPUS || cpu < 0);
+
+	thread = threads__findnew(runtime_event->pid, &threads, &last_match);
+	atoms = thread_atoms_search(&atom_root, thread, &cmp_pid);
+	if (!atoms) {
+		thread_atoms_insert(thread);
+		atoms = thread_atoms_search(&atom_root, thread, &cmp_pid);
+		if (!atoms)
+			die("in-event: Internal tree error");
+		add_sched_out_event(atoms, 'R', timestamp);
 	}
 
-	lat_sched_in(in_atoms, timestamp);
-	lat_sched_out(out_atoms, switch_event, delta, timestamp);
+	add_runtime_event(atoms, runtime_event->runtime, timestamp);
 }
 
 static void
 latency_wakeup_event(struct trace_wakeup_event *wakeup_event,
-		     struct event *event __used,
+		     struct event *__event __used,
 		     int cpu __used,
 		     u64 timestamp,
 		     struct thread *thread __used)
 {
-	struct task_atoms *atoms;
+	struct work_atoms *atoms;
 	struct work_atom *atom;
 	struct thread *wakee;
 
@@ -1100,16 +1158,20 @@ latency_wakeup_event(struct trace_wakeup_event *wakeup_event,
 	atoms = thread_atoms_search(&atom_root, wakee, &cmp_pid);
 	if (!atoms) {
 		thread_atoms_insert(wakee);
-		return;
+		atoms = thread_atoms_search(&atom_root, wakee, &cmp_pid);
+		if (!atoms)
+			die("wakeup-event: Internal tree error");
+		add_sched_out_event(atoms, 'S', timestamp);
 	}
 
-	if (list_empty(&atoms->atom_list))
-		return;
+	BUG_ON(list_empty(&atoms->work_list));
 
-	atom = list_entry(atoms->atom_list.prev, struct work_atom, list);
+	atom = list_entry(atoms->work_list.prev, struct work_atom, list);
 
-	if (atom->state != THREAD_SLEEPING)
+	if (atom->state != THREAD_SLEEPING) {
+		printf("boo2\n");
 		return;
+	}
 
 	nr_timestamps++;
 	if (atom->sched_out_time > timestamp) {
@@ -1124,40 +1186,41 @@ latency_wakeup_event(struct trace_wakeup_event *wakeup_event,
 static struct trace_sched_handler lat_ops  = {
 	.wakeup_event		= latency_wakeup_event,
 	.switch_event		= latency_switch_event,
+	.runtime_event		= latency_runtime_event,
 	.fork_event		= latency_fork_event,
 };
 
-static void output_lat_thread(struct task_atoms *atom_list)
+static void output_lat_thread(struct work_atoms *work_list)
 {
 	int i;
 	int ret;
 	u64 avg;
 
-	if (!atom_list->nb_atoms)
+	if (!work_list->nb_atoms)
 		return;
 	/*
 	 * Ignore idle threads:
 	 */
-	if (!atom_list->thread->pid)
+	if (!work_list->thread->pid)
 		return;
 
-	all_runtime += atom_list->total_runtime;
-	all_count += atom_list->nb_atoms;
+	all_runtime += work_list->total_runtime;
+	all_count += work_list->nb_atoms;
 
-	ret = printf("  %s-%d ", atom_list->thread->comm, atom_list->thread->pid);
+	ret = printf("  %s-%d ", work_list->thread->comm, work_list->thread->pid);
 
 	for (i = 0; i < 24 - ret; i++)
 		printf(" ");
 
-	avg = atom_list->total_lat / atom_list->nb_atoms;
+	avg = work_list->total_lat / work_list->nb_atoms;
 
 	printf("|%9.3f ms |%9llu | avg:%9.3f ms | max:%9.3f ms |\n",
-	      (double)atom_list->total_runtime / 1e6,
-		 atom_list->nb_atoms, (double)avg / 1e6,
-		 (double)atom_list->max_lat / 1e6);
+	      (double)work_list->total_runtime / 1e6,
+		 work_list->nb_atoms, (double)avg / 1e6,
+		 (double)work_list->max_lat / 1e6);
 }
 
-static int pid_cmp(struct task_atoms *l, struct task_atoms *r)
+static int pid_cmp(struct work_atoms *l, struct work_atoms *r)
 {
 	if (l->thread->pid < r->thread->pid)
 		return -1;
@@ -1172,7 +1235,7 @@ static struct sort_dimension pid_sort_dimension = {
 	.cmp			= pid_cmp,
 };
 
-static int avg_cmp(struct task_atoms *l, struct task_atoms *r)
+static int avg_cmp(struct work_atoms *l, struct work_atoms *r)
 {
 	u64 avgl, avgr;
 
@@ -1198,7 +1261,7 @@ static struct sort_dimension avg_sort_dimension = {
 	.cmp			= avg_cmp,
 };
 
-static int max_cmp(struct task_atoms *l, struct task_atoms *r)
+static int max_cmp(struct work_atoms *l, struct work_atoms *r)
 {
 	if (l->max_lat < r->max_lat)
 		return -1;
@@ -1213,7 +1276,7 @@ static struct sort_dimension max_sort_dimension = {
 	.cmp			= max_cmp,
 };
 
-static int switch_cmp(struct task_atoms *l, struct task_atoms *r)
+static int switch_cmp(struct work_atoms *l, struct work_atoms *r)
 {
 	if (l->nb_atoms < r->nb_atoms)
 		return -1;
@@ -1228,7 +1291,7 @@ static struct sort_dimension switch_sort_dimension = {
 	.cmp			= switch_cmp,
 };
 
-static int runtime_cmp(struct task_atoms *l, struct task_atoms *r)
+static int runtime_cmp(struct work_atoms *l, struct work_atoms *r)
 {
 	if (l->total_runtime < r->total_runtime)
 		return -1;
@@ -1277,13 +1340,13 @@ static void sort_lat(void)
 	struct rb_node *node;
 
 	for (;;) {
-		struct task_atoms *data;
+		struct work_atoms *data;
 		node = rb_first(&atom_root);
 		if (!node)
 			break;
 
 		rb_erase(node, &atom_root);
-		data = rb_entry(node, struct task_atoms, node);
+		data = rb_entry(node, struct work_atoms, node);
 		__thread_latency_insert(&sorted_atom_root, data, &sort_list);
 	}
 }
@@ -1303,10 +1366,10 @@ static void __cmd_lat(void)
 	next = rb_first(&sorted_atom_root);
 
 	while (next) {
-		struct task_atoms *atom_list;
+		struct work_atoms *work_list;
 
-		atom_list = rb_entry(next, struct task_atoms, node);
-		output_lat_thread(atom_list);
+		work_list = rb_entry(next, struct work_atoms, node);
+		output_lat_thread(work_list);
 		next = rb_next(next);
 	}
 
@@ -1369,6 +1432,23 @@ process_sched_switch_event(struct raw_event_sample *raw,
 }
 
 static void
+process_sched_runtime_event(struct raw_event_sample *raw,
+			   struct event *event,
+			   int cpu __used,
+			   u64 timestamp __used,
+			   struct thread *thread __used)
+{
+	struct trace_runtime_event runtime_event;
+
+	FILL_ARRAY(runtime_event, comm, event, raw->data);
+	FILL_FIELD(runtime_event, pid, event, raw->data);
+	FILL_FIELD(runtime_event, runtime, event, raw->data);
+	FILL_FIELD(runtime_event, vruntime, event, raw->data);
+
+	trace_handler->runtime_event(&runtime_event, event, cpu, timestamp, thread);
+}
+
+static void
 process_sched_fork_event(struct raw_event_sample *raw,
 			 struct event *event,
 			 int cpu __used,
@@ -1410,6 +1490,8 @@ process_raw_event(event_t *raw_event __used, void *more_data,
 
 	if (!strcmp(event->name, "sched_switch"))
 		process_sched_switch_event(raw, event, cpu, timestamp, thread);
+	if (!strcmp(event->name, "sched_stat_runtime"))
+		process_sched_runtime_event(raw, event, cpu, timestamp, thread);
 	if (!strcmp(event->name, "sched_wakeup"))
 		process_sched_wakeup_event(raw, event, cpu, timestamp, thread);
 	if (!strcmp(event->name, "sched_wakeup_new"))
