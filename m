Return-Path: <linux-kernel-owner+w=401wt.eu-S1752385AbZIOJfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385AbZIOJfV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 05:35:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752309AbZIOJfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 05:35:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:57317 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752279AbZIOJfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 05:35:11 -0400
Date: Tue, 15 Sep 2009 09:34:34 GMT
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
Subject: [tip:perfcounters/core] perf sched: Finish latency => atom rename and misc cleanups
Message-ID: <tip-b1ffe8f3e0c96f5527a89e24410d6b0e59b3554a@git.kernel.org>
Git-Commit-ID: b1ffe8f3e0c96f5527a89e24410d6b0e59b3554a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 15 Sep 2009 09:34:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b1ffe8f3e0c96f5527a89e24410d6b0e59b3554a
Gitweb:     http://git.kernel.org/tip/b1ffe8f3e0c96f5527a89e24410d6b0e59b3554a
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Fri, 11 Sep 2009 12:12:54 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 13 Sep 2009 10:22:49 +0200

perf sched: Finish latency => atom rename and misc cleanups

- Rename 'latency' field/variable names to the better 'atom' ones

 - Reduce the number of #include lines and consolidate them

 - Gather file scope variables at the top of the file

 - Remove unused bits

No change in functionality.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-sched.c |  399 ++++++++++++++++++++------------------------
 1 files changed, 184 insertions(+), 215 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index e01cc63..cc2dbd5 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1,4 +1,5 @@
 #include "builtin.h"
+#include "perf.h"
 
 #include "util/util.h"
 #include "util/cache.h"
@@ -7,15 +8,16 @@
 #include "util/header.h"
 
 #include "util/parse-options.h"
+#include "util/trace-event.h"
 
-#include "perf.h"
 #include "util/debug.h"
 
-#include "util/trace-event.h"
 #include <sys/types.h>
+#include <sys/prctl.h>
 
-
-#define MAX_CPUS 4096
+#include <semaphore.h>
+#include <pthread.h>
+#include <math.h>
 
 static char			const *input_name = "perf.data";
 static int			input;
@@ -33,44 +35,126 @@ static u64			sample_type;
 static char			default_sort_order[] = "avg, max, switch, runtime";
 static char			*sort_order = default_sort_order;
 
+#define PR_SET_NAME		15               /* Set process name */
+#define MAX_CPUS		4096
 
-/*
- * Scheduler benchmarks
- */
-#include <sys/resource.h>
-#include <sys/types.h>
-#include <sys/stat.h>
-#include <sys/time.h>
-#include <sys/prctl.h>
+#define BUG_ON(x)		assert(!(x))
 
-#include <linux/unistd.h>
+static u64			run_measurement_overhead;
+static u64			sleep_measurement_overhead;
 
-#include <semaphore.h>
-#include <pthread.h>
-#include <signal.h>
-#include <values.h>
-#include <string.h>
-#include <unistd.h>
-#include <stdlib.h>
-#include <assert.h>
-#include <fcntl.h>
-#include <time.h>
-#include <math.h>
+#define COMM_LEN		20
+#define SYM_LEN			129
 
-#include <stdio.h>
+#define MAX_PID			65536
 
-#define PR_SET_NAME	15               /* Set process name */
+static unsigned long		nr_tasks;
 
-#define BUG_ON(x)	assert(!(x))
+struct sched_event;
 
-#define DEBUG		0
+struct task_desc {
+	unsigned long		nr;
+	unsigned long		pid;
+	char			comm[COMM_LEN];
 
-typedef unsigned long long nsec_t;
+	unsigned long		nr_events;
+	unsigned long		curr_event;
+	struct sched_event	**events;
+
+	pthread_t		thread;
+	sem_t			sleep_sem;
 
-static nsec_t run_measurement_overhead;
-static nsec_t sleep_measurement_overhead;
+	sem_t			ready_for_work;
+	sem_t			work_done_sem;
+
+	u64			cpu_usage;
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
+	u64			timestamp;
+	u64			duration;
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
+static u64			start_time;
+
+static pthread_mutex_t		work_done_wait_mutex = PTHREAD_MUTEX_INITIALIZER;
 
-static nsec_t get_nsecs(void)
+static unsigned long		nr_run_events;
+static unsigned long		nr_sleep_events;
+static unsigned long		nr_wakeup_events;
+
+static unsigned long		nr_sleep_corrections;
+static unsigned long		nr_run_events_optimized;
+
+static unsigned long		targetless_wakeups;
+static unsigned long		multitarget_wakeups;
+
+static u64			cpu_usage;
+static u64			runavg_cpu_usage;
+static u64			parent_cpu_usage;
+static u64			runavg_parent_cpu_usage;
+
+static unsigned long		nr_runs;
+static u64			sum_runtime;
+static u64			sum_fluct;
+static u64			run_avg;
+
+static unsigned long		replay_repeat = 10;
+
+#define TASK_STATE_TO_CHAR_STR "RSDTtZX"
+
+enum thread_state {
+	THREAD_SLEEPING = 0,
+	THREAD_WAIT_CPU,
+	THREAD_SCHED_IN,
+	THREAD_IGNORE
+};
+
+struct work_atom {
+	struct list_head	list;
+	enum thread_state	state;
+	u64			wake_up_time;
+	u64			sched_in_time;
+	u64			runtime;
+};
+
+struct task_atoms {
+	struct list_head	atom_list;
+	struct thread		*thread;
+	struct rb_node		node;
+	u64			max_lat;
+	u64			total_lat;
+	u64			nb_atoms;
+	u64			total_runtime;
+};
+
+typedef int (*sort_thread_lat)(struct task_atoms *, struct task_atoms *);
+
+static struct rb_root		atom_root, sorted_atom_root;
+
+static u64			all_runtime;
+static u64			all_count;
+
+static int read_events(void);
+
+
+static u64 get_nsecs(void)
 {
 	struct timespec ts;
 
@@ -79,16 +163,16 @@ static nsec_t get_nsecs(void)
 	return ts.tv_sec * 1000000000ULL + ts.tv_nsec;
 }
 
-static void burn_nsecs(nsec_t nsecs)
+static void burn_nsecs(u64 nsecs)
 {
-	nsec_t T0 = get_nsecs(), T1;
+	u64 T0 = get_nsecs(), T1;
 
 	do {
 		T1 = get_nsecs();
 	} while (T1 + run_measurement_overhead < T0 + nsecs);
 }
 
-static void sleep_nsecs(nsec_t nsecs)
+static void sleep_nsecs(u64 nsecs)
 {
 	struct timespec ts;
 
@@ -100,7 +184,7 @@ static void sleep_nsecs(nsec_t nsecs)
 
 static void calibrate_run_measurement_overhead(void)
 {
-	nsec_t T0, T1, delta, min_delta = 1000000000ULL;
+	u64 T0, T1, delta, min_delta = 1000000000ULL;
 	int i;
 
 	for (i = 0; i < 10; i++) {
@@ -117,7 +201,7 @@ static void calibrate_run_measurement_overhead(void)
 
 static void calibrate_sleep_measurement_overhead(void)
 {
-	nsec_t T0, T1, delta, min_delta = 1000000000ULL;
+	u64 T0, T1, delta, min_delta = 1000000000ULL;
 	int i;
 
 	for (i = 0; i < 10; i++) {
@@ -133,67 +217,8 @@ static void calibrate_sleep_measurement_overhead(void)
 	printf("sleep measurement overhead: %Ld nsecs\n", min_delta);
 }
 
-#define COMM_LEN	20
-#define SYM_LEN		129
-
-#define MAX_PID		65536
-
-static unsigned long nr_tasks;
-
-struct sched_event;
-
-struct task_desc {
-	unsigned long		nr;
-	unsigned long		pid;
-	char			comm[COMM_LEN];
-
-	unsigned long		nr_events;
-	unsigned long		curr_event;
-	struct sched_event	**events;
-
-	pthread_t		thread;
-	sem_t			sleep_sem;
-
-	sem_t			ready_for_work;
-	sem_t			work_done_sem;
-
-	nsec_t			cpu_usage;
-};
-
-enum sched_event_type {
-	SCHED_EVENT_RUN,
-	SCHED_EVENT_SLEEP,
-	SCHED_EVENT_WAKEUP,
-};
-
-struct sched_event {
-	enum sched_event_type	type;
-	nsec_t			timestamp;
-	nsec_t			duration;
-	unsigned long		nr;
-	int			specific_wait;
-	sem_t			*wait_sem;
-	struct task_desc	*wakee;
-};
-
-static struct task_desc		*pid_to_task[MAX_PID];
-
-static struct task_desc		**tasks;
-
-static pthread_mutex_t		start_work_mutex = PTHREAD_MUTEX_INITIALIZER;
-static nsec_t			start_time;
-
-static pthread_mutex_t		work_done_wait_mutex = PTHREAD_MUTEX_INITIALIZER;
-
-static unsigned long		nr_run_events;
-static unsigned long		nr_sleep_events;
-static unsigned long		nr_wakeup_events;
-
-static unsigned long		nr_sleep_corrections;
-static unsigned long		nr_run_events_optimized;
-
 static struct sched_event *
-get_new_event(struct task_desc *task, nsec_t timestamp)
+get_new_event(struct task_desc *task, u64 timestamp)
 {
 	struct sched_event *event = calloc(1, sizeof(*event));
 	unsigned long idx = task->nr_events;
@@ -221,7 +246,7 @@ static struct sched_event *last_event(struct task_desc *task)
 }
 
 static void
-add_sched_event_run(struct task_desc *task, nsec_t timestamp, u64 duration)
+add_sched_event_run(struct task_desc *task, u64 timestamp, u64 duration)
 {
 	struct sched_event *event, *curr_event = last_event(task);
 
@@ -243,11 +268,8 @@ add_sched_event_run(struct task_desc *task, nsec_t timestamp, u64 duration)
 	nr_run_events++;
 }
 
-static unsigned long		targetless_wakeups;
-static unsigned long		multitarget_wakeups;
-
 static void
-add_sched_event_wakeup(struct task_desc *task, nsec_t timestamp,
+add_sched_event_wakeup(struct task_desc *task, u64 timestamp,
 		       struct task_desc *wakee)
 {
 	struct sched_event *event, *wakee_event;
@@ -275,7 +297,7 @@ add_sched_event_wakeup(struct task_desc *task, nsec_t timestamp,
 }
 
 static void
-add_sched_event_sleep(struct task_desc *task, nsec_t timestamp,
+add_sched_event_sleep(struct task_desc *task, u64 timestamp,
 		      u64 task_state __used)
 {
 	struct sched_event *event = get_new_event(task, timestamp);
@@ -350,7 +372,7 @@ static void
 process_sched_event(struct task_desc *this_task __used, struct sched_event *event)
 {
 	int ret = 0;
-	nsec_t now;
+	u64 now;
 	long long delta;
 
 	now = get_nsecs();
@@ -375,10 +397,10 @@ process_sched_event(struct task_desc *this_task __used, struct sched_event *even
 	}
 }
 
-static nsec_t get_cpu_usage_nsec_parent(void)
+static u64 get_cpu_usage_nsec_parent(void)
 {
 	struct rusage ru;
-	nsec_t sum;
+	u64 sum;
 	int err;
 
 	err = getrusage(RUSAGE_SELF, &ru);
@@ -390,12 +412,12 @@ static nsec_t get_cpu_usage_nsec_parent(void)
 	return sum;
 }
 
-static nsec_t get_cpu_usage_nsec_self(void)
+static u64 get_cpu_usage_nsec_self(void)
 {
 	char filename [] = "/proc/1234567890/sched";
 	unsigned long msecs, nsecs;
 	char *line = NULL;
-	nsec_t total = 0;
+	u64 total = 0;
 	size_t len = 0;
 	ssize_t chars;
 	FILE *file;
@@ -423,7 +445,7 @@ static nsec_t get_cpu_usage_nsec_self(void)
 static void *thread_func(void *ctx)
 {
 	struct task_desc *this_task = ctx;
-	nsec_t cpu_usage_0, cpu_usage_1;
+	u64 cpu_usage_0, cpu_usage_1;
 	unsigned long i, ret;
 	char comm2[22];
 
@@ -485,14 +507,9 @@ static void create_tasks(void)
 	}
 }
 
-static nsec_t			cpu_usage;
-static nsec_t			runavg_cpu_usage;
-static nsec_t			parent_cpu_usage;
-static nsec_t			runavg_parent_cpu_usage;
-
 static void wait_for_tasks(void)
 {
-	nsec_t cpu_usage_0, cpu_usage_1;
+	u64 cpu_usage_0, cpu_usage_1;
 	struct task_desc *task;
 	unsigned long i, ret;
 
@@ -543,16 +560,9 @@ static void wait_for_tasks(void)
 	}
 }
 
-static int read_events(void);
-
-static unsigned long nr_runs;
-static nsec_t sum_runtime;
-static nsec_t sum_fluct;
-static nsec_t run_avg;
-
 static void run_one_test(void)
 {
-	nsec_t T0, T1, delta, avg_delta, fluct, std_dev;
+	u64 T0, T1, delta, avg_delta, fluct, std_dev;
 
 	T0 = get_nsecs();
 	wait_for_tasks();
@@ -576,10 +586,6 @@ static void run_one_test(void)
 	printf("#%-3ld: %0.3f, ",
 		nr_runs, (double)delta/1000000.0);
 
-#if 0
-	printf("%0.2f +- %0.2f, ",
-		(double)avg_delta/1e6, (double)std_dev/1e6);
-#endif
 	printf("ravg: %0.2f, ",
 		(double)run_avg/1e6);
 
@@ -605,7 +611,7 @@ static void run_one_test(void)
 
 static void test_calibrations(void)
 {
-	nsec_t T0, T1;
+	u64 T0, T1;
 
 	T0 = get_nsecs();
 	burn_nsecs(1e6);
@@ -620,8 +626,6 @@ static void test_calibrations(void)
 	printf("the sleep test took %Ld nsecs\n", T1-T0);
 }
 
-static unsigned long replay_repeat = 10;
-
 static void __cmd_replay(void)
 {
 	unsigned long i;
@@ -865,47 +869,8 @@ static struct trace_sched_handler replay_ops  = {
 	.fork_event		= replay_fork_event,
 };
 
-#define TASK_STATE_TO_CHAR_STR "RSDTtZX"
-
-enum thread_state {
-	THREAD_SLEEPING = 0,
-	THREAD_WAIT_CPU,
-	THREAD_SCHED_IN,
-	THREAD_IGNORE
-};
-
-struct work_atom {
-	struct list_head	list;
-	enum thread_state	state;
-	u64			wake_up_time;
-	u64			sched_in_time;
-	u64			runtime;
-};
-
-struct task_atoms {
-	struct list_head	snapshot_list;
-	struct thread		*thread;
-	struct rb_node		node;
-	u64			max_lat;
-	u64			total_lat;
-	u64			nb_atoms;
-	u64			total_runtime;
-};
-
-typedef int (*sort_thread_lat)(struct task_atoms *, struct task_atoms *);
-
-struct sort_dimension {
-	const char 		*name;
-	sort_thread_lat		cmp;
-	struct list_head 	list;
-};
-
-static LIST_HEAD(cmp_pid);
-
-static struct rb_root lat_snapshot_root, sorted_lat_snapshot_root;
-
 static struct task_atoms *
-thread_atom_list_search(struct rb_root *root, struct thread *thread)
+thread_atoms_search(struct rb_root *root, struct thread *thread)
 {
 	struct rb_node *node = root->rb_node;
 
@@ -924,6 +889,14 @@ thread_atom_list_search(struct rb_root *root, struct thread *thread)
 	return NULL;
 }
 
+struct sort_dimension {
+	const char		*name;
+	sort_thread_lat		cmp;
+	struct list_head	list;
+};
+
+static LIST_HEAD(cmp_pid);
+
 static int
 thread_lat_cmp(struct list_head *list, struct task_atoms *l,
 	       struct task_atoms *r)
@@ -965,16 +938,17 @@ __thread_latency_insert(struct rb_root *root, struct task_atoms *data,
 	rb_insert_color(&data->node, root);
 }
 
-static void thread_atom_list_insert(struct thread *thread)
+static void thread_atoms_insert(struct thread *thread)
 {
 	struct task_atoms *atoms;
+
 	atoms = calloc(sizeof(*atoms), 1);
 	if (!atoms)
 		die("No memory");
 
 	atoms->thread = thread;
-	INIT_LIST_HEAD(&atoms->snapshot_list);
-	__thread_latency_insert(&lat_snapshot_root, atoms, &cmp_pid);
+	INIT_LIST_HEAD(&atoms->atom_list);
+	__thread_latency_insert(&atom_root, atoms, &cmp_pid);
 }
 
 static void
@@ -1001,50 +975,49 @@ lat_sched_out(struct task_atoms *atoms,
 	      u64 delta,
 	      u64 timestamp)
 {
-	struct work_atom *snapshot;
+	struct work_atom *atom;
 
-	snapshot = calloc(sizeof(*snapshot), 1);
-	if (!snapshot)
+	atom = calloc(sizeof(*atom), 1);
+	if (!atom)
 		die("Non memory");
 
 	if (sched_out_state(switch_event) == 'R') {
-		snapshot->state = THREAD_WAIT_CPU;
-		snapshot->wake_up_time = timestamp;
+		atom->state = THREAD_WAIT_CPU;
+		atom->wake_up_time = timestamp;
 	}
 
-	snapshot->runtime = delta;
-	list_add_tail(&snapshot->list, &atoms->snapshot_list);
+	atom->runtime = delta;
+	list_add_tail(&atom->list, &atoms->atom_list);
 }
 
 static void
 lat_sched_in(struct task_atoms *atoms, u64 timestamp)
 {
-	struct work_atom *snapshot;
+	struct work_atom *atom;
 	u64 delta;
 
-	if (list_empty(&atoms->snapshot_list))
+	if (list_empty(&atoms->atom_list))
 		return;
 
-	snapshot = list_entry(atoms->snapshot_list.prev, struct work_atom,
-			      list);
+	atom = list_entry(atoms->atom_list.prev, struct work_atom, list);
 
-	if (snapshot->state != THREAD_WAIT_CPU)
+	if (atom->state != THREAD_WAIT_CPU)
 		return;
 
-	if (timestamp < snapshot->wake_up_time) {
-		snapshot->state = THREAD_IGNORE;
+	if (timestamp < atom->wake_up_time) {
+		atom->state = THREAD_IGNORE;
 		return;
 	}
 
-	snapshot->state = THREAD_SCHED_IN;
-	snapshot->sched_in_time = timestamp;
+	atom->state = THREAD_SCHED_IN;
+	atom->sched_in_time = timestamp;
 
-	delta = snapshot->sched_in_time - snapshot->wake_up_time;
+	delta = atom->sched_in_time - atom->wake_up_time;
 	atoms->total_lat += delta;
 	if (delta > atoms->max_lat)
 		atoms->max_lat = delta;
 	atoms->nb_atoms++;
-	atoms->total_runtime += snapshot->runtime;
+	atoms->total_runtime += atom->runtime;
 }
 
 static void
@@ -1076,20 +1049,20 @@ latency_switch_event(struct trace_switch_event *switch_event,
 	sched_out = threads__findnew(switch_event->prev_pid, &threads, &last_match);
 	sched_in = threads__findnew(switch_event->next_pid, &threads, &last_match);
 
-	in_atoms = thread_atom_list_search(&lat_snapshot_root, sched_in);
+	in_atoms = thread_atoms_search(&atom_root, sched_in);
 	if (!in_atoms) {
-		thread_atom_list_insert(sched_in);
-		in_atoms = thread_atom_list_search(&lat_snapshot_root, sched_in);
+		thread_atoms_insert(sched_in);
+		in_atoms = thread_atoms_search(&atom_root, sched_in);
 		if (!in_atoms)
-			die("Internal latency tree error");
+			die("in-atom: Internal tree error");
 	}
 
-	out_atoms = thread_atom_list_search(&lat_snapshot_root, sched_out);
+	out_atoms = thread_atoms_search(&atom_root, sched_out);
 	if (!out_atoms) {
-		thread_atom_list_insert(sched_out);
-		out_atoms = thread_atom_list_search(&lat_snapshot_root, sched_out);
+		thread_atoms_insert(sched_out);
+		out_atoms = thread_atoms_search(&atom_root, sched_out);
 		if (!out_atoms)
-			die("Internal latency tree error");
+			die("out-atom: Internal tree error");
 	}
 
 	lat_sched_in(in_atoms, timestamp);
@@ -1104,7 +1077,7 @@ latency_wakeup_event(struct trace_wakeup_event *wakeup_event,
 		     struct thread *thread __used)
 {
 	struct task_atoms *atoms;
-	struct work_atom *snapshot;
+	struct work_atom *atom;
 	struct thread *wakee;
 
 	/* Note for later, it may be interesting to observe the failing cases */
@@ -1112,23 +1085,22 @@ latency_wakeup_event(struct trace_wakeup_event *wakeup_event,
 		return;
 
 	wakee = threads__findnew(wakeup_event->pid, &threads, &last_match);
-	atoms = thread_atom_list_search(&lat_snapshot_root, wakee);
+	atoms = thread_atoms_search(&atom_root, wakee);
 	if (!atoms) {
-		thread_atom_list_insert(wakee);
+		thread_atoms_insert(wakee);
 		return;
 	}
 
-	if (list_empty(&atoms->snapshot_list))
+	if (list_empty(&atoms->atom_list))
 		return;
 
-	snapshot = list_entry(atoms->snapshot_list.prev, struct work_atom,
-			      list);
+	atom = list_entry(atoms->atom_list.prev, struct work_atom, list);
 
-	if (snapshot->state != THREAD_SLEEPING)
+	if (atom->state != THREAD_SLEEPING)
 		return;
 
-	snapshot->state = THREAD_WAIT_CPU;
-	snapshot->wake_up_time = timestamp;
+	atom->state = THREAD_WAIT_CPU;
+	atom->wake_up_time = timestamp;
 }
 
 static struct trace_sched_handler lat_ops  = {
@@ -1137,9 +1109,6 @@ static struct trace_sched_handler lat_ops  = {
 	.fork_event		= latency_fork_event,
 };
 
-static u64 all_runtime;
-static u64 all_count;
-
 static void output_lat_thread(struct task_atoms *atom_list)
 {
 	int i;
@@ -1287,13 +1256,13 @@ static void sort_lat(void)
 
 	for (;;) {
 		struct task_atoms *data;
-		node = rb_first(&lat_snapshot_root);
+		node = rb_first(&atom_root);
 		if (!node)
 			break;
 
-		rb_erase(node, &lat_snapshot_root);
+		rb_erase(node, &atom_root);
 		data = rb_entry(node, struct task_atoms, node);
-		__thread_latency_insert(&sorted_lat_snapshot_root, data, &sort_list);
+		__thread_latency_insert(&sorted_atom_root, data, &sort_list);
 	}
 }
 
@@ -1309,7 +1278,7 @@ static void __cmd_lat(void)
 	printf(" Task              |  Runtime ms | Switches | Average delay ms | Maximum delay ms |\n");
 	printf("-----------------------------------------------------------------------------------\n");
 
-	next = rb_first(&sorted_lat_snapshot_root);
+	next = rb_first(&sorted_atom_root);
 
 	while (next) {
 		struct task_atoms *atom_list;
