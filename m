Return-Path: <linux-kernel-owner+w=401wt.eu-S933362AbZHDTSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933362AbZHDTSr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 15:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933322AbZHDTSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 15:18:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37772 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933317AbZHDTSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 15:18:46 -0400
Date: Tue, 4 Aug 2009 21:18:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] perfcounter fixes
Message-ID: <20090804191832.GA2020@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perfcounters-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perfcounters-fixes-for-linus

Note, i was unsure about this commit:

  f265426: perf_counter: Set the CONFIG_PERF_COUNTERS default to y if CONFIG_PROFILING=y

Is it proper to offer up a default-y if CONFIG_PROFILING is set to y 
already and default-off otherwise?

I kept this the last commit so we can zap it easily if it's not ok.

 Thanks,

	Ingo

------------------>
Arnaldo Carvalho de Melo (1):
      perf top: Add mwait_idle_with_hints to skip_symbols[]

Ingo Molnar (2):
      perf_counter tools: Fix link errors with older toolchains
      perf_counter: Set the CONFIG_PERF_COUNTERS default to y if CONFIG_PROFILING=y

Peter Zijlstra (4):
      tracing, perf_counter: Add help text to CONFIG_EVENT_PROFILE
      perf_counter: Collapse inherit on read()
      perf_counter: Full task tracing
      perf report: Update for the new FORK/EXIT events

Roel Kluin (1):
      perf: Fix read buffer overflow

Stoyan Gaydarov (1):
      perf tools: Fix faulty check


 include/linux/perf_counter.h |   13 +++++-
 init/Kconfig                 |   11 ++++-
 kernel/fork.c                |    4 +-
 kernel/perf_counter.c        |  101 +++++++++++++++++++++++++++++------------
 tools/perf/Makefile          |    2 +-
 tools/perf/builtin-report.c  |   24 ++++++++--
 tools/perf/builtin-top.c     |    1 +
 tools/perf/util/quote.c      |    2 +-
 tools/perf/util/symbol.c     |    2 +-
 9 files changed, 117 insertions(+), 43 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index bd15d7a..e604e6e 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -181,8 +181,9 @@ struct perf_counter_attr {
 				freq           :  1, /* use freq, not period  */
 				inherit_stat   :  1, /* per task counts       */
 				enable_on_exec :  1, /* next exec enables     */
+				task           :  1, /* trace fork/exit       */
 
-				__reserved_1   : 51;
+				__reserved_1   : 50;
 
 	__u32			wakeup_events;	/* wakeup every n events */
 	__u32			__reserved_2;
@@ -311,6 +312,15 @@ enum perf_event_type {
 	/*
 	 * struct {
 	 *	struct perf_event_header	header;
+	 *	u32				pid, ppid;
+	 *	u32				tid, ptid;
+	 * };
+	 */
+	PERF_EVENT_EXIT			= 4,
+
+	/*
+	 * struct {
+	 *	struct perf_event_header	header;
 	 *	u64				time;
 	 *	u64				id;
 	 *	u64				stream_id;
@@ -323,6 +333,7 @@ enum perf_event_type {
 	 * struct {
 	 *	struct perf_event_header	header;
 	 *	u32				pid, ppid;
+	 *	u32				tid, ptid;
 	 * };
 	 */
 	PERF_EVENT_FORK			= 7,
diff --git a/init/Kconfig b/init/Kconfig
index cb2c092..3f7e609 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -940,6 +940,7 @@ menu "Performance Counters"
 
 config PERF_COUNTERS
 	bool "Kernel Performance Counters"
+	default y if PROFILING
 	depends on HAVE_PERF_COUNTERS
 	select ANON_INODES
 	help
@@ -961,9 +962,17 @@ config PERF_COUNTERS
 	  Say Y if unsure.
 
 config EVENT_PROFILE
-	bool "Tracepoint profile sources"
+	bool "Tracepoint profiling sources"
 	depends on PERF_COUNTERS && EVENT_TRACING
 	default y
+	help
+	 Allow the use of tracepoints as software performance counters.
+
+	 When this is enabled, you can create perf counters based on
+	 tracepoints using PERF_TYPE_TRACEPOINT and the tracepoint ID
+	 found in debugfs://tracing/events/*/*/id. (The -e/--events
+	 option to the perf tool can parse and interpret symbolic
+	 tracepoints, in the subsystem:tracepoint_name format.)
 
 endmenu
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 29b532e..466531e 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1269,6 +1269,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	write_unlock_irq(&tasklist_lock);
 	proc_fork_connector(p);
 	cgroup_post_fork(p);
+	perf_counter_fork(p);
 	return p;
 
 bad_fork_free_pid:
@@ -1410,9 +1411,6 @@ long do_fork(unsigned long clone_flags,
 			init_completion(&vfork);
 		}
 
-		if (!(clone_flags & CLONE_THREAD))
-			perf_counter_fork(p);
-
 		audit_finish_fork(p);
 		tracehook_report_clone(regs, clone_flags, nr, p);
 
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 9509310..199ed47 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -42,6 +42,7 @@ static int perf_overcommit __read_mostly = 1;
 static atomic_t nr_counters __read_mostly;
 static atomic_t nr_mmap_counters __read_mostly;
 static atomic_t nr_comm_counters __read_mostly;
+static atomic_t nr_task_counters __read_mostly;
 
 /*
  * perf counter paranoia level:
@@ -1654,6 +1655,8 @@ static void free_counter(struct perf_counter *counter)
 			atomic_dec(&nr_mmap_counters);
 		if (counter->attr.comm)
 			atomic_dec(&nr_comm_counters);
+		if (counter->attr.task)
+			atomic_dec(&nr_task_counters);
 	}
 
 	if (counter->destroy)
@@ -1688,6 +1691,18 @@ static int perf_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
+static u64 perf_counter_read_tree(struct perf_counter *counter)
+{
+	struct perf_counter *child;
+	u64 total = 0;
+
+	total += perf_counter_read(counter);
+	list_for_each_entry(child, &counter->child_list, child_list)
+		total += perf_counter_read(child);
+
+	return total;
+}
+
 /*
  * Read the performance counter - simple non blocking version for now
  */
@@ -1707,7 +1722,7 @@ perf_read_hw(struct perf_counter *counter, char __user *buf, size_t count)
 
 	WARN_ON_ONCE(counter->ctx->parent_ctx);
 	mutex_lock(&counter->child_mutex);
-	values[0] = perf_counter_read(counter);
+	values[0] = perf_counter_read_tree(counter);
 	n = 1;
 	if (counter->attr.read_format & PERF_FORMAT_TOTAL_TIME_ENABLED)
 		values[n++] = counter->total_time_enabled +
@@ -2819,10 +2834,12 @@ perf_counter_read_event(struct perf_counter *counter,
 }
 
 /*
- * fork tracking
+ * task tracking -- fork/exit
+ *
+ * enabled by: attr.comm | attr.mmap | attr.task
  */
 
-struct perf_fork_event {
+struct perf_task_event {
 	struct task_struct	*task;
 
 	struct {
@@ -2830,37 +2847,42 @@ struct perf_fork_event {
 
 		u32				pid;
 		u32				ppid;
+		u32				tid;
+		u32				ptid;
 	} event;
 };
 
-static void perf_counter_fork_output(struct perf_counter *counter,
-				     struct perf_fork_event *fork_event)
+static void perf_counter_task_output(struct perf_counter *counter,
+				     struct perf_task_event *task_event)
 {
 	struct perf_output_handle handle;
-	int size = fork_event->event.header.size;
-	struct task_struct *task = fork_event->task;
+	int size = task_event->event.header.size;
+	struct task_struct *task = task_event->task;
 	int ret = perf_output_begin(&handle, counter, size, 0, 0);
 
 	if (ret)
 		return;
 
-	fork_event->event.pid = perf_counter_pid(counter, task);
-	fork_event->event.ppid = perf_counter_pid(counter, task->real_parent);
+	task_event->event.pid = perf_counter_pid(counter, task);
+	task_event->event.ppid = perf_counter_pid(counter, task->real_parent);
 
-	perf_output_put(&handle, fork_event->event);
+	task_event->event.tid = perf_counter_tid(counter, task);
+	task_event->event.ptid = perf_counter_tid(counter, task->real_parent);
+
+	perf_output_put(&handle, task_event->event);
 	perf_output_end(&handle);
 }
 
-static int perf_counter_fork_match(struct perf_counter *counter)
+static int perf_counter_task_match(struct perf_counter *counter)
 {
-	if (counter->attr.comm || counter->attr.mmap)
+	if (counter->attr.comm || counter->attr.mmap || counter->attr.task)
 		return 1;
 
 	return 0;
 }
 
-static void perf_counter_fork_ctx(struct perf_counter_context *ctx,
-				  struct perf_fork_event *fork_event)
+static void perf_counter_task_ctx(struct perf_counter_context *ctx,
+				  struct perf_task_event *task_event)
 {
 	struct perf_counter *counter;
 
@@ -2869,19 +2891,19 @@ static void perf_counter_fork_ctx(struct perf_counter_context *ctx,
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(counter, &ctx->event_list, event_entry) {
-		if (perf_counter_fork_match(counter))
-			perf_counter_fork_output(counter, fork_event);
+		if (perf_counter_task_match(counter))
+			perf_counter_task_output(counter, task_event);
 	}
 	rcu_read_unlock();
 }
 
-static void perf_counter_fork_event(struct perf_fork_event *fork_event)
+static void perf_counter_task_event(struct perf_task_event *task_event)
 {
 	struct perf_cpu_context *cpuctx;
 	struct perf_counter_context *ctx;
 
 	cpuctx = &get_cpu_var(perf_cpu_context);
-	perf_counter_fork_ctx(&cpuctx->ctx, fork_event);
+	perf_counter_task_ctx(&cpuctx->ctx, task_event);
 	put_cpu_var(perf_cpu_context);
 
 	rcu_read_lock();
@@ -2891,32 +2913,40 @@ static void perf_counter_fork_event(struct perf_fork_event *fork_event)
 	 */
 	ctx = rcu_dereference(current->perf_counter_ctxp);
 	if (ctx)
-		perf_counter_fork_ctx(ctx, fork_event);
+		perf_counter_task_ctx(ctx, task_event);
 	rcu_read_unlock();
 }
 
-void perf_counter_fork(struct task_struct *task)
+static void perf_counter_task(struct task_struct *task, int new)
 {
-	struct perf_fork_event fork_event;
+	struct perf_task_event task_event;
 
 	if (!atomic_read(&nr_comm_counters) &&
-	    !atomic_read(&nr_mmap_counters))
+	    !atomic_read(&nr_mmap_counters) &&
+	    !atomic_read(&nr_task_counters))
 		return;
 
-	fork_event = (struct perf_fork_event){
+	task_event = (struct perf_task_event){
 		.task	= task,
 		.event  = {
 			.header = {
-				.type = PERF_EVENT_FORK,
+				.type = new ? PERF_EVENT_FORK : PERF_EVENT_EXIT,
 				.misc = 0,
-				.size = sizeof(fork_event.event),
+				.size = sizeof(task_event.event),
 			},
 			/* .pid  */
 			/* .ppid */
+			/* .tid  */
+			/* .ptid */
 		},
 	};
 
-	perf_counter_fork_event(&fork_event);
+	perf_counter_task_event(&task_event);
+}
+
+void perf_counter_fork(struct task_struct *task)
+{
+	perf_counter_task(task, 1);
 }
 
 /*
@@ -3875,6 +3905,8 @@ done:
 			atomic_inc(&nr_mmap_counters);
 		if (counter->attr.comm)
 			atomic_inc(&nr_comm_counters);
+		if (counter->attr.task)
+			atomic_inc(&nr_task_counters);
 	}
 
 	return counter;
@@ -4236,8 +4268,10 @@ void perf_counter_exit_task(struct task_struct *child)
 	struct perf_counter_context *child_ctx;
 	unsigned long flags;
 
-	if (likely(!child->perf_counter_ctxp))
+	if (likely(!child->perf_counter_ctxp)) {
+		perf_counter_task(child, 0);
 		return;
+	}
 
 	local_irq_save(flags);
 	/*
@@ -4255,15 +4289,22 @@ void perf_counter_exit_task(struct task_struct *child)
 	 * incremented the context's refcount before we do put_ctx below.
 	 */
 	spin_lock(&child_ctx->lock);
-	child->perf_counter_ctxp = NULL;
 	/*
 	 * If this context is a clone; unclone it so it can't get
 	 * swapped to another process while we're removing all
 	 * the counters from it.
 	 */
 	unclone_ctx(child_ctx);
-	spin_unlock(&child_ctx->lock);
-	local_irq_restore(flags);
+	spin_unlock_irqrestore(&child_ctx->lock, flags);
+
+	/*
+	 * Report the task dead after unscheduling the counters so that we
+	 * won't get any samples after PERF_EVENT_EXIT. We can however still
+	 * get a few PERF_EVENT_READ events.
+	 */
+	perf_counter_task(child, 0);
+
+	child->perf_counter_ctxp = NULL;
 
 	/*
 	 * We can recurse on the same lock type through:
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index a5e9b87..4b20fa4 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -345,7 +345,7 @@ BUILTIN_OBJS += builtin-stat.o
 BUILTIN_OBJS += builtin-top.o
 
 PERFLIBS = $(LIB_FILE)
-EXTLIBS = -lbfd
+EXTLIBS = -lbfd -liberty
 
 #
 # Platform specific tweaks
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index b20a4b6..ce4f286 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -99,6 +99,7 @@ struct comm_event {
 struct fork_event {
 	struct perf_event_header header;
 	u32 pid, ppid;
+	u32 tid, ptid;
 };
 
 struct lost_event {
@@ -252,7 +253,7 @@ static int strcommon(const char *pathname)
 {
 	int n = 0;
 
-	while (pathname[n] == cwd[n] && n < cwdlen)
+	while (n < cwdlen && pathname[n] == cwd[n])
 		++n;
 
 	return n;
@@ -1608,15 +1609,27 @@ process_comm_event(event_t *event, unsigned long offset, unsigned long head)
 }
 
 static int
-process_fork_event(event_t *event, unsigned long offset, unsigned long head)
+process_task_event(event_t *event, unsigned long offset, unsigned long head)
 {
 	struct thread *thread = threads__findnew(event->fork.pid);
 	struct thread *parent = threads__findnew(event->fork.ppid);
 
-	dprintf("%p [%p]: PERF_EVENT_FORK: %d:%d\n",
+	dprintf("%p [%p]: PERF_EVENT_%s: (%d:%d):(%d:%d)\n",
 		(void *)(offset + head),
 		(void *)(long)(event->header.size),
-		event->fork.pid, event->fork.ppid);
+		event->header.type == PERF_EVENT_FORK ? "FORK" : "EXIT",
+		event->fork.pid, event->fork.tid,
+		event->fork.ppid, event->fork.ptid);
+
+	/*
+	 * A thread clone will have the same PID for both
+	 * parent and child.
+	 */
+	if (thread == parent)
+		return 0;
+
+	if (event->header.type == PERF_EVENT_EXIT)
+		return 0;
 
 	if (!thread || !parent || thread__fork(thread, parent)) {
 		dprintf("problem processing PERF_EVENT_FORK, skipping event.\n");
@@ -1706,7 +1719,8 @@ process_event(event_t *event, unsigned long offset, unsigned long head)
 		return process_comm_event(event, offset, head);
 
 	case PERF_EVENT_FORK:
-		return process_fork_event(event, offset, head);
+	case PERF_EVENT_EXIT:
+		return process_task_event(event, offset, head);
 
 	case PERF_EVENT_LOST:
 		return process_lost_event(event, offset, head);
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index c0a4230..f139f1a 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -285,6 +285,7 @@ static const char *skip_symbols[] = {
 	"enter_idle",
 	"exit_idle",
 	"mwait_idle",
+	"mwait_idle_with_hints",
 	"ppc64_runlatch_off",
 	"pseries_dedicated_idle_sleep",
 	NULL
diff --git a/tools/perf/util/quote.c b/tools/perf/util/quote.c
index c6e5dc0..2726fe4 100644
--- a/tools/perf/util/quote.c
+++ b/tools/perf/util/quote.c
@@ -318,7 +318,7 @@ char *quote_path_relative(const char *in, int len,
 		strbuf_addch(out, '"');
 	if (prefix) {
 		int off = 0;
-		while (prefix[off] && off < len && prefix[off] == in[off])
+		while (off < len && prefix[off] && prefix[off] == in[off])
 			if (prefix[off] == '/') {
 				prefix += off + 1;
 				in += off + 1;
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 2810605..b4fe057 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -565,7 +565,7 @@ static int dso__load_sym(struct dso *self, int fd, const char *name,
 		goto out_elf_end;
 
 	secstrs = elf_getdata(sec_strndx, NULL);
-	if (symstrs == NULL)
+	if (secstrs == NULL)
 		goto out_elf_end;
 
 	nr_syms = shdr.sh_size / shdr.sh_entsize;

