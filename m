Return-Path: <linux-kernel-owner+w=401wt.eu-S1756285AbZJKQln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285AbZJKQln (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 12:41:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755992AbZJKQlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 12:41:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:57457 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755988AbZJKQll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 12:41:41 -0400
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>
Subject: [PATCH 1/1] perf tools: Move threads & last_match to threads.c
Date: Sun, 11 Oct 2009 13:40:54 -0300
Message-Id: <1255279254-9956-1-git-send-email-acme@redhat.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <y>
References: <y>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was just being copy'n'pasted all over.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c |   18 +++++++-----------
 tools/perf/builtin-report.c   |   17 +++++++----------
 tools/perf/builtin-sched.c    |   15 ++++++---------
 tools/perf/builtin-trace.c    |    9 +++------
 tools/perf/util/thread.c      |   40 ++++++++++++++++++----------------------
 tools/perf/util/thread.h      |   12 ++++--------
 6 files changed, 45 insertions(+), 66 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 8c84320..b64029f 100644
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
@@ -101,7 +97,7 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 	struct map *map = NULL;
 	struct symbol *sym = NULL;
 
-	thread = threads__findnew(event->ip.pid, &threads, &last_match);
+	thread = threads__findnew(event->ip.pid);
 
 	dump_printf("%p [%p]: PERF_EVENT (IP, %d): %d: %p\n",
 		(void *)(offset + head),
@@ -169,7 +165,7 @@ process_mmap_event(event_t *event, unsigned long offset, unsigned long head)
 	struct thread *thread;
 	struct map *map = map__new(&event->mmap, NULL, 0);
 
-	thread = threads__findnew(event->mmap.pid, &threads, &last_match);
+	thread = threads__findnew(event->mmap.pid);
 
 	dump_printf("%p [%p]: PERF_RECORD_MMAP %d: [%p(%p) @ %p]: %s\n",
 		(void *)(offset + head),
@@ -196,7 +192,7 @@ process_comm_event(event_t *event, unsigned long offset, unsigned long head)
 {
 	struct thread *thread;
 
-	thread = threads__findnew(event->comm.pid, &threads, &last_match);
+	thread = threads__findnew(event->comm.pid);
 	dump_printf("%p [%p]: PERF_RECORD_COMM: %s:%d\n",
 		(void *)(offset + head),
 		(void *)(long)(event->header.size),
@@ -218,8 +214,8 @@ process_fork_event(event_t *event, unsigned long offset, unsigned long head)
 	struct thread *thread;
 	struct thread *parent;
 
-	thread = threads__findnew(event->fork.pid, &threads, &last_match);
-	parent = threads__findnew(event->fork.ppid, &threads, &last_match);
+	thread = threads__findnew(event->fork.pid);
+	parent = threads__findnew(event->fork.ppid);
 	dump_printf("%p [%p]: PERF_RECORD_FORK: %d:%d\n",
 		(void *)(offset + head),
 		(void *)(long)(event->header.size),
@@ -558,7 +554,7 @@ static int __cmd_annotate(void)
 	uint32_t size;
 	char *buf;
 
-	register_idle_thread(&threads, &last_match);
+	register_idle_thread();
 
 	input = open(input_name, O_RDONLY);
 	if (input < 0) {
@@ -659,7 +655,7 @@ more:
 		return 0;
 
 	if (verbose > 3)
-		threads__fprintf(stdout, &threads);
+		threads__fprintf(stdout);
 
 	if (verbose > 2)
 		dsos__fprintf(stdout);
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index f57a23b..0a3b014 100644
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
@@ -601,7 +598,7 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 	struct ip_callchain *chain = NULL;
 	int cpumode;
 
-	thread = threads__findnew(event->ip.pid, &threads, &last_match);
+	thread = threads__findnew(event->ip.pid);
 
 	if (sample_type & PERF_SAMPLE_PERIOD) {
 		period = *(u64 *)more_data;
@@ -688,7 +685,7 @@ process_mmap_event(event_t *event, unsigned long offset, unsigned long head)
 	struct thread *thread;
 	struct map *map = map__new(&event->mmap, cwd, cwdlen);
 
-	thread = threads__findnew(event->mmap.pid, &threads, &last_match);
+	thread = threads__findnew(event->mmap.pid);
 
 	dump_printf("%p [%p]: PERF_RECORD_MMAP %d/%d: [%p(%p) @ %p]: %s\n",
 		(void *)(offset + head),
@@ -716,7 +713,7 @@ process_comm_event(event_t *event, unsigned long offset, unsigned long head)
 {
 	struct thread *thread;
 
-	thread = threads__findnew(event->comm.pid, &threads, &last_match);
+	thread = threads__findnew(event->comm.pid);
 
 	dump_printf("%p [%p]: PERF_RECORD_COMM: %s:%d\n",
 		(void *)(offset + head),
@@ -739,8 +736,8 @@ process_task_event(event_t *event, unsigned long offset, unsigned long head)
 	struct thread *thread;
 	struct thread *parent;
 
-	thread = threads__findnew(event->fork.pid, &threads, &last_match);
-	parent = threads__findnew(event->fork.ppid, &threads, &last_match);
+	thread = threads__findnew(event->fork.pid);
+	parent = threads__findnew(event->fork.ppid);
 
 	dump_printf("%p [%p]: PERF_RECORD_%s: (%d:%d):(%d:%d)\n",
 		(void *)(offset + head),
@@ -857,7 +854,7 @@ static int __cmd_report(void)
 	struct thread *idle;
 	int ret;
 
-	idle = register_idle_thread(&threads, &last_match);
+	idle = register_idle_thread();
 	thread__comm_adjust(idle);
 
 	if (show_threads)
@@ -881,7 +878,7 @@ static int __cmd_report(void)
 		return 0;
 
 	if (verbose > 3)
-		threads__fprintf(stdout, &threads);
+		threads__fprintf(stdout);
 
 	if (verbose > 2)
 		dsos__fprintf(stdout);
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 25b91e7..d66b8e2 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -24,9 +24,6 @@ static char			const *input_name = "perf.data";
 
 static unsigned long		total_comm = 0;
 
-static struct rb_root		threads;
-static struct thread		*last_match;
-
 static struct perf_header	*header;
 static u64			sample_type;
 
@@ -638,7 +635,7 @@ process_comm_event(event_t *event, unsigned long offset, unsigned long head)
 {
 	struct thread *thread;
 
-	thread = threads__findnew(event->comm.pid, &threads, &last_match);
+	thread = threads__findnew(event->comm.pid);
 
 	dump_printf("%p [%p]: perf_event_comm: %s:%d\n",
 		(void *)(offset + head),
@@ -1039,7 +1036,7 @@ threads__findnew_from_ctx(u32 pid, struct trace_switch_event *switch_event)
 {
 	struct thread *th;
 
-	th = threads__findnew_nocomm(pid, &threads, &last_match);
+	th = threads__findnew_nocomm(pid);
 	if (th->comm)
 		return th;
 
@@ -1055,7 +1052,7 @@ threads__findnew_from_wakeup(struct trace_wakeup_event *wakeup_event)
 {
 	struct thread *th;
 
-	th =  threads__findnew_nocomm(wakeup_event->pid, &threads, &last_match);
+	th =  threads__findnew_nocomm(wakeup_event->pid);
 	if (th->comm)
 		return th;
 
@@ -1130,7 +1127,7 @@ latency_runtime_event(struct trace_runtime_event *runtime_event,
 
 	BUG_ON(cpu >= MAX_CPUS || cpu < 0);
 
-	thread = threads__findnew(runtime_event->pid, &threads, &last_match);
+	thread = threads__findnew(runtime_event->pid);
 	atoms = thread_atoms_search(&atom_root, thread, &cmp_pid);
 	if (!atoms) {
 		thread_atoms_insert(thread);
@@ -1589,7 +1586,7 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 	if (!(sample_type & PERF_SAMPLE_RAW))
 		return 0;
 
-	thread = threads__findnew(event->ip.pid, &threads, &last_match);
+	thread = threads__findnew(event->ip.pid);
 
 	if (sample_type & PERF_SAMPLE_TIME) {
 		timestamp = *(u64 *)more_data;
@@ -1662,7 +1659,7 @@ static struct perf_file_handler file_handler = {
 
 static int read_events(void)
 {
-	register_idle_thread(&threads, &last_match);
+	register_idle_thread();
 	register_perf_file_handler(&file_handler);
 
 	return mmap_dispatch_perf_file(&header, input_name, 0, 0, &cwdlen, &cwd);
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index fb3f3c2..7dcd8f9 100644
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
 
@@ -34,7 +31,7 @@ process_comm_event(event_t *event, unsigned long offset, unsigned long head)
 {
 	struct thread *thread;
 
-	thread = threads__findnew(event->comm.pid, &threads, &last_match);
+	thread = threads__findnew(event->comm.pid);
 
 	dump_printf("%p [%p]: PERF_RECORD_COMM: %s:%d\n",
 		(void *)(offset + head),
@@ -61,7 +58,7 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 	u64 period = 1;
 	void *more_data = event->ip.__more_data;
 
-	thread = threads__findnew(event->ip.pid, &threads, &last_match);
+	thread = threads__findnew(event->ip.pid);
 
 	if (sample_type & PERF_SAMPLE_TIME) {
 		timestamp = *(u64 *)more_data;
@@ -135,7 +132,7 @@ static struct perf_file_handler file_handler = {
 
 static int __cmd_trace(void)
 {
-	register_idle_thread(&threads, &last_match);
+	register_idle_thread();
 	register_perf_file_handler(&file_handler);
 
 	return mmap_dispatch_perf_file(&header, input_name, 0, 0, &cwdlen, &cwd);
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 8bd5ca2..0b0ea59 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -6,6 +6,9 @@
 #include "util.h"
 #include "debug.h"
 
+static struct rb_root threads;
+static struct thread  *last_match;
+
 static struct thread *thread__new(pid_t pid, int set_comm)
 {
 	struct thread *self = calloc(1, sizeof(*self));
@@ -52,12 +55,9 @@ static size_t thread__fprintf(struct thread *self, FILE *fp)
 	return ret;
 }
 
-static struct thread *
-__threads__findnew(pid_t pid, struct rb_root *threads,
-		   struct thread **last_match,
-		   int set_comm)
+static struct thread *__threads__findnew(pid_t pid, int set_comm)
 {
-	struct rb_node **p = &threads->rb_node;
+	struct rb_node **p = &threads.rb_node;
 	struct rb_node *parent = NULL;
 	struct thread *th;
 
@@ -66,15 +66,15 @@ __threads__findnew(pid_t pid, struct rb_root *threads,
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
 
@@ -88,30 +88,26 @@ __threads__findnew(pid_t pid, struct rb_root *threads,
 
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
-threads__findnew(pid_t pid, struct rb_root *threads, struct thread **last_match)
+struct thread *threads__findnew(pid_t pid)
 {
-	return __threads__findnew(pid, threads, last_match, 1);
+	return __threads__findnew(pid, 1);
 }
 
-struct thread *
-threads__findnew_nocomm(pid_t pid, struct rb_root *threads,
-			struct thread **last_match)
+struct thread *threads__findnew_nocomm(pid_t pid)
 {
-	return __threads__findnew(pid, threads, last_match, 0);
+	return __threads__findnew(pid, 0);
 }
 
-struct thread *
-register_idle_thread(struct rb_root *threads, struct thread **last_match)
+struct thread *register_idle_thread(void)
 {
-	struct thread *thread = threads__findnew(0, threads, last_match);
+	struct thread *thread = threads__findnew(0);
 
 	if (!thread || thread__set_comm(thread, "swapper")) {
 		fprintf(stderr, "problem inserting idle task.\n");
@@ -215,12 +211,12 @@ int thread__fork(struct thread *self, struct thread *parent)
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
index 75bc843..40ace42 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -15,16 +15,12 @@ struct thread {
 };
 
 int thread__set_comm(struct thread *self, const char *comm);
-struct thread *
-threads__findnew(pid_t pid, struct rb_root *threads, struct thread **last_match);
-struct thread *
-threads__findnew_nocomm(pid_t pid, struct rb_root *threads,
-			struct thread **last_match);
-struct thread *
-register_idle_thread(struct rb_root *threads, struct thread **last_match);
+struct thread *threads__findnew(pid_t pid);
+struct thread *threads__findnew_nocomm(pid_t pid);
+struct thread *register_idle_thread(void);
 void thread__insert_map(struct thread *self, struct map *map);
 int thread__fork(struct thread *self, struct thread *parent);
-size_t threads__fprintf(FILE *fp, struct rb_root *threads);
+size_t threads__fprintf(FILE *fp);
 
 void maps__insert(struct rb_root *maps, struct map *map);
 struct map *maps__find(struct rb_root *maps, u64 ip);
-- 
1.6.2.5

