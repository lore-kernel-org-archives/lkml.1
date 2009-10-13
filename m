Return-Path: <linux-kernel-owner+w=401wt.eu-S1760221AbZJMPUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760221AbZJMPUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 11:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752973AbZJMPUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 11:20:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:35412 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750914AbZJMPUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 11:20:30 -0400
Date: Tue, 13 Oct 2009 15:19:13 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, peterz@infradead.org,
       efault@gmx.de, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091013141629.GD21809@ghostprotocols.net>
References: <20091013141629.GD21809@ghostprotocols.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Move threads & last_match to threads.c
Message-ID: <tip-d5b889f2ecec7849e851ddd31c34bdfb3482b5de@git.kernel.org>
Git-Commit-ID: d5b889f2ecec7849e851ddd31c34bdfb3482b5de
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 13 Oct 2009 15:19:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d5b889f2ecec7849e851ddd31c34bdfb3482b5de
Gitweb:     http://git.kernel.org/tip/d5b889f2ecec7849e851ddd31c34bdfb3482b5de
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 13 Oct 2009 11:16:29 -0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 13 Oct 2009 17:12:18 +0200

perf tools: Move threads & last_match to threads.c

This was just being copy'n'pasted all over.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <20091013141629.GD21809@ghostprotocols.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-annotate.c |   25 +++++++------------------
 tools/perf/builtin-report.c   |   26 +++++++-------------------
 tools/perf/builtin-sched.c    |   30 +++++++++++-------------------
 tools/perf/builtin-trace.c    |   13 +++----------
 tools/perf/util/thread.c      |   27 ++++++++++++++-------------
 tools/perf/util/thread.h      |    8 +++-----
 6 files changed, 45 insertions(+), 84 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 8c84320..3fe0de0 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -37,10 +37,6 @@ static int		print_line;
 static unsigned long	page_size;
 static unsigned long	mmap_window = 32;
 
-static struct rb_root	threads;
-static struct thread	*last_match;
-
-
 struct sym_ext {
 	struct rb_node	node;
 	double		percent;
@@ -96,12 +92,10 @@ static int
 process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 {
 	char level;
-	struct thread *thread;
 	u64 ip = event->ip.ip;
 	struct map *map = NULL;
 	struct symbol *sym = NULL;
-
-	thread = threads__findnew(event->ip.pid, &threads, &last_match);
+	struct thread *thread = threads__findnew(event->ip.pid);
 
 	dump_printf("%p [%p]: PERF_EVENT (IP, %d): %d: %p\n",
 		(void *)(offset + head),
@@ -166,10 +160,8 @@ got_map:
 static int
 process_mmap_event(event_t *event, unsigned long offset, unsigned long head)
 {
-	struct thread *thread;
 	struct map *map = map__new(&event->mmap, NULL, 0);
-
-	thread = threads__findnew(event->mmap.pid, &threads, &last_match);
+	struct thread *thread = threads__findnew(event->mmap.pid);
 
 	dump_printf("%p [%p]: PERF_RECORD_MMAP %d: [%p(%p) @ %p]: %s\n",
 		(void *)(offset + head),
@@ -194,9 +186,8 @@ process_mmap_event(event_t *event, unsigned long offset, unsigned long head)
 static int
 process_comm_event(event_t *event, unsigned long offset, unsigned long head)
 {
-	struct thread *thread;
+	struct thread *thread = threads__findnew(event->comm.pid);
 
-	thread = threads__findnew(event->comm.pid, &threads, &last_match);
 	dump_printf("%p [%p]: PERF_RECORD_COMM: %s:%d\n",
 		(void *)(offset + head),
 		(void *)(long)(event->header.size),
@@ -215,11 +206,9 @@ process_comm_event(event_t *event, unsigned long offset, unsigned long head)
 static int
 process_fork_event(event_t *event, unsigned long offset, unsigned long head)
 {
-	struct thread *thread;
-	struct thread *parent;
+	struct thread *thread = threads__findnew(event->fork.pid);
+	struct thread *parent = threads__findnew(event->fork.ppid);
 
-	thread = threads__findnew(event->fork.pid, &threads, &last_match);
-	parent = threads__findnew(event->fork.ppid, &threads, &last_match);
 	dump_printf("%p [%p]: PERF_RECORD_FORK: %d:%d\n",
 		(void *)(offset + head),
 		(void *)(long)(event->header.size),
@@ -558,7 +547,7 @@ static int __cmd_annotate(void)
 	uint32_t size;
 	char *buf;
 
-	register_idle_thread(&threads, &last_match);
+	register_idle_thread();
 
 	input = open(input_name, O_RDONLY);
 	if (input < 0) {
@@ -659,7 +648,7 @@ more:
 		return 0;
 
 	if (verbose > 3)
-		threads__fprintf(stdout, &threads);
+		threads__fprintf(stdout);
 
 	if (verbose > 2)
 		dsos__fprintf(stdout);
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index f57a23b..015c797 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -55,9 +55,6 @@ static char		callchain_default_opt[] = "fractal,0.5";
 static char		*cwd;
 static int		cwdlen;
 
-static struct rb_root	threads;
-static struct thread	*last_match;
-
 static struct perf_header *header;
 
 static u64		sample_type;
@@ -593,15 +590,13 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 {
 	char level;
 	struct symbol *sym = NULL;
-	struct thread *thread;
 	u64 ip = event->ip.ip;
 	u64 period = 1;
 	struct map *map = NULL;
 	void *more_data = event->ip.__more_data;
 	struct ip_callchain *chain = NULL;
 	int cpumode;
-
-	thread = threads__findnew(event->ip.pid, &threads, &last_match);
+	struct thread *thread = threads__findnew(event->ip.pid);
 
 	if (sample_type & PERF_SAMPLE_PERIOD) {
 		period = *(u64 *)more_data;
@@ -685,10 +680,8 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 static int
 process_mmap_event(event_t *event, unsigned long offset, unsigned long head)
 {
-	struct thread *thread;
 	struct map *map = map__new(&event->mmap, cwd, cwdlen);
-
-	thread = threads__findnew(event->mmap.pid, &threads, &last_match);
+	struct thread *thread = threads__findnew(event->mmap.pid);
 
 	dump_printf("%p [%p]: PERF_RECORD_MMAP %d/%d: [%p(%p) @ %p]: %s\n",
 		(void *)(offset + head),
@@ -714,9 +707,7 @@ process_mmap_event(event_t *event, unsigned long offset, unsigned long head)
 static int
 process_comm_event(event_t *event, unsigned long offset, unsigned long head)
 {
-	struct thread *thread;
-
-	thread = threads__findnew(event->comm.pid, &threads, &last_match);
+	struct thread *thread = threads__findnew(event->comm.pid);
 
 	dump_printf("%p [%p]: PERF_RECORD_COMM: %s:%d\n",
 		(void *)(offset + head),
@@ -736,11 +727,8 @@ process_comm_event(event_t *event, unsigned long offset, unsigned long head)
 static int
 process_task_event(event_t *event, unsigned long offset, unsigned long head)
 {
-	struct thread *thread;
-	struct thread *parent;
-
-	thread = threads__findnew(event->fork.pid, &threads, &last_match);
-	parent = threads__findnew(event->fork.ppid, &threads, &last_match);
+	struct thread *thread = threads__findnew(event->fork.pid);
+	struct thread *parent = threads__findnew(event->fork.ppid);
 
 	dump_printf("%p [%p]: PERF_RECORD_%s: (%d:%d):(%d:%d)\n",
 		(void *)(offset + head),
@@ -857,7 +845,7 @@ static int __cmd_report(void)
 	struct thread *idle;
 	int ret;
 
-	idle = register_idle_thread(&threads, &last_match);
+	idle = register_idle_thread();
 	thread__comm_adjust(idle);
 
 	if (show_threads)
@@ -881,7 +869,7 @@ static int __cmd_report(void)
 		return 0;
 
 	if (verbose > 3)
-		threads__fprintf(stdout, &threads);
+		threads__fprintf(stdout);
 
 	if (verbose > 2)
 		dsos__fprintf(stdout);
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 387a442..73bdad0 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -24,9 +24,6 @@ static char			const *input_name = "perf.data";
 
 static unsigned long		total_comm = 0;
 
-static struct rb_root		threads;
-static struct thread		*last_match;
-
 static struct perf_header	*header;
 static u64			sample_type;
 
@@ -641,9 +638,7 @@ static void test_calibrations(void)
 static int
 process_comm_event(event_t *event, unsigned long offset, unsigned long head)
 {
-	struct thread *thread;
-
-	thread = threads__findnew(event->comm.tid, &threads, &last_match);
+	struct thread *thread = threads__findnew(event->comm.tid);
 
 	dump_printf("%p [%p]: perf_event_comm: %s:%d\n",
 		(void *)(offset + head),
@@ -1086,8 +1081,8 @@ latency_switch_event(struct trace_switch_event *switch_event,
 		die("hm, delta: %Ld < 0 ?\n", delta);
 
 
-	sched_out = threads__findnew(switch_event->prev_pid, &threads, &last_match);
-	sched_in = threads__findnew(switch_event->next_pid, &threads, &last_match);
+	sched_out = threads__findnew(switch_event->prev_pid);
+	sched_in = threads__findnew(switch_event->next_pid);
 
 	out_events = thread_atoms_search(&atom_root, sched_out, &cmp_pid);
 	if (!out_events) {
@@ -1120,13 +1115,10 @@ latency_runtime_event(struct trace_runtime_event *runtime_event,
 		     u64 timestamp,
 		     struct thread *this_thread __used)
 {
-	struct work_atoms *atoms;
-	struct thread *thread;
+	struct thread *thread = threads__findnew(runtime_event->pid);
+	struct work_atoms *atoms = thread_atoms_search(&atom_root, thread, &cmp_pid);
 
 	BUG_ON(cpu >= MAX_CPUS || cpu < 0);
-
-	thread = threads__findnew(runtime_event->pid, &threads, &last_match);
-	atoms = thread_atoms_search(&atom_root, thread, &cmp_pid);
 	if (!atoms) {
 		thread_atoms_insert(thread);
 		atoms = thread_atoms_search(&atom_root, thread, &cmp_pid);
@@ -1153,7 +1145,7 @@ latency_wakeup_event(struct trace_wakeup_event *wakeup_event,
 	if (!wakeup_event->success)
 		return;
 
-	wakee = threads__findnew(wakeup_event->pid, &threads, &last_match);
+	wakee = threads__findnew(wakeup_event->pid);
 	atoms = thread_atoms_search(&atom_root, wakee, &cmp_pid);
 	if (!atoms) {
 		thread_atoms_insert(wakee);
@@ -1202,7 +1194,7 @@ latency_migrate_task_event(struct trace_migrate_task_event *migrate_task_event,
 	if (profile_cpu == -1)
 		return;
 
-	migrant = threads__findnew(migrate_task_event->pid, &threads, &last_match);
+	migrant = threads__findnew(migrate_task_event->pid);
 	atoms = thread_atoms_search(&atom_root, migrant, &cmp_pid);
 	if (!atoms) {
 		thread_atoms_insert(migrant);
@@ -1458,8 +1450,8 @@ map_switch_event(struct trace_switch_event *switch_event,
 		die("hm, delta: %Ld < 0 ?\n", delta);
 
 
-	sched_out = threads__findnew(switch_event->prev_pid, &threads, &last_match);
-	sched_in = threads__findnew(switch_event->next_pid, &threads, &last_match);
+	sched_out = threads__findnew(switch_event->prev_pid);
+	sched_in = threads__findnew(switch_event->next_pid);
 
 	curr_thread[this_cpu] = sched_in;
 
@@ -1649,7 +1641,7 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 	if (!(sample_type & PERF_SAMPLE_RAW))
 		return 0;
 
-	thread = threads__findnew(event->ip.pid, &threads, &last_match);
+	thread = threads__findnew(event->ip.pid);
 
 	if (sample_type & PERF_SAMPLE_TIME) {
 		timestamp = *(u64 *)more_data;
@@ -1725,7 +1717,7 @@ static struct perf_file_handler file_handler = {
 
 static int read_events(void)
 {
-	register_idle_thread(&threads, &last_match);
+	register_idle_thread();
 	register_perf_file_handler(&file_handler);
 
 	return mmap_dispatch_perf_file(&header, input_name, 0, 0, &cwdlen, &cwd);
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index fb3f3c2..ccf867d 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -19,9 +19,6 @@ static char		const *input_name = "perf.data";
 static unsigned long	total = 0;
 static unsigned long	total_comm = 0;
 
-static struct rb_root	threads;
-static struct thread	*last_match;
-
 static struct perf_header *header;
 static u64		sample_type;
 
@@ -32,9 +29,7 @@ static int		cwdlen;
 static int
 process_comm_event(event_t *event, unsigned long offset, unsigned long head)
 {
-	struct thread *thread;
-
-	thread = threads__findnew(event->comm.pid, &threads, &last_match);
+	struct thread *thread = threads__findnew(event->comm.pid);
 
 	dump_printf("%p [%p]: PERF_RECORD_COMM: %s:%d\n",
 		(void *)(offset + head),
@@ -54,14 +49,12 @@ process_comm_event(event_t *event, unsigned long offset, unsigned long head)
 static int
 process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 {
-	struct thread *thread;
 	u64 ip = event->ip.ip;
 	u64 timestamp = -1;
 	u32 cpu = -1;
 	u64 period = 1;
 	void *more_data = event->ip.__more_data;
-
-	thread = threads__findnew(event->ip.pid, &threads, &last_match);
+	struct thread *thread = threads__findnew(event->ip.pid);
 
 	if (sample_type & PERF_SAMPLE_TIME) {
 		timestamp = *(u64 *)more_data;
@@ -135,7 +128,7 @@ static struct perf_file_handler file_handler = {
 
 static int __cmd_trace(void)
 {
-	register_idle_thread(&threads, &last_match);
+	register_idle_thread();
 	register_perf_file_handler(&file_handler);
 
 	return mmap_dispatch_perf_file(&header, input_name, 0, 0, &cwdlen, &cwd);
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 3b56aeb..f53fad7 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -6,6 +6,9 @@
 #include "util.h"
 #include "debug.h"
 
+static struct rb_root threads;
+static struct thread *last_match;
+
 static struct thread *thread__new(pid_t pid)
 {
 	struct thread *self = calloc(1, sizeof(*self));
@@ -50,10 +53,9 @@ static size_t thread__fprintf(struct thread *self, FILE *fp)
 	return ret;
 }
 
-struct thread *
-threads__findnew(pid_t pid, struct rb_root *threads, struct thread **last_match)
+struct thread *threads__findnew(pid_t pid)
 {
-	struct rb_node **p = &threads->rb_node;
+	struct rb_node **p = &threads.rb_node;
 	struct rb_node *parent = NULL;
 	struct thread *th;
 
@@ -62,15 +64,15 @@ threads__findnew(pid_t pid, struct rb_root *threads, struct thread **last_match)
 	 * so most of the time we dont have to look up
 	 * the full rbtree:
 	 */
-	if (*last_match && (*last_match)->pid == pid)
-		return *last_match;
+	if (last_match && last_match->pid == pid)
+		return last_match;
 
 	while (*p != NULL) {
 		parent = *p;
 		th = rb_entry(parent, struct thread, rb_node);
 
 		if (th->pid == pid) {
-			*last_match = th;
+			last_match = th;
 			return th;
 		}
 
@@ -83,17 +85,16 @@ threads__findnew(pid_t pid, struct rb_root *threads, struct thread **last_match)
 	th = thread__new(pid);
 	if (th != NULL) {
 		rb_link_node(&th->rb_node, parent, p);
-		rb_insert_color(&th->rb_node, threads);
-		*last_match = th;
+		rb_insert_color(&th->rb_node, &threads);
+		last_match = th;
 	}
 
 	return th;
 }
 
-struct thread *
-register_idle_thread(struct rb_root *threads, struct thread **last_match)
+struct thread *register_idle_thread(void)
 {
-	struct thread *thread = threads__findnew(0, threads, last_match);
+	struct thread *thread = threads__findnew(0);
 
 	if (!thread || thread__set_comm(thread, "swapper")) {
 		fprintf(stderr, "problem inserting idle task.\n");
@@ -197,12 +198,12 @@ int thread__fork(struct thread *self, struct thread *parent)
 	return 0;
 }
 
-size_t threads__fprintf(FILE *fp, struct rb_root *threads)
+size_t threads__fprintf(FILE *fp)
 {
 	size_t ret = 0;
 	struct rb_node *nd;
 
-	for (nd = rb_first(threads); nd; nd = rb_next(nd)) {
+	for (nd = rb_first(&threads); nd; nd = rb_next(nd)) {
 		struct thread *pos = rb_entry(nd, struct thread, rb_node);
 
 		ret += thread__fprintf(pos, fp);
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index 845d9b6..1abef3b 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -15,13 +15,11 @@ struct thread {
 };
 
 int thread__set_comm(struct thread *self, const char *comm);
-struct thread *
-threads__findnew(pid_t pid, struct rb_root *threads, struct thread **last_match);
-struct thread *
-register_idle_thread(struct rb_root *threads, struct thread **last_match);
+struct thread *threads__findnew(pid_t pid);
+struct thread *register_idle_thread(void);
 void thread__insert_map(struct thread *self, struct map *map);
 int thread__fork(struct thread *self, struct thread *parent);
-size_t threads__fprintf(FILE *fp, struct rb_root *threads);
+size_t threads__fprintf(FILE *fp);
 
 void maps__insert(struct rb_root *maps, struct map *map);
 struct map *maps__find(struct rb_root *maps, u64 ip);
