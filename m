Return-Path: <linux-kernel-owner+w=401wt.eu-S1756949AbZDGTYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949AbZDGTYT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 15:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753552AbZDGTYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 15:24:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35383 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751621AbZDGTYE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 15:24:04 -0400
Date: Tue, 7 Apr 2009 21:23:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [GIT PULL] tracing fixes
Message-ID: <20090407192355.GA12987@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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

Please pull the latest tracing-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tracing-fixes-for-linus

 Thanks,

	Ingo

------------------>
Bart Van Assche (1):
      branch tracer: Fix for enabling branch profiling makes sparse unusable

Carl Henrik Lunde (1):
      blktrace: NUL-terminate user space messages

Frederic Weisbecker (2):
      tracing/ftrace: fix missing include string.h
      tracing/ftrace: alloc the started cpumask for the trace file

Huang Weiyi (1):
      tracing, x86: remove duplicated #include

Lai Jiangshan (2):
      tracing: move scripts/trace/power.pl to scripts/tracing/power.pl
      tracing: fix incorrect return type of ns2usecs()

Li Zefan (2):
      blktrace: small cleanup in blk_msg_write()
      blktrace: fix pdu_len when tracing packet command requests

Linus Torvalds (1):
      branch tracer, intel-iommu: fix build with CONFIG_BRANCH_TRACER=y

Nikanth Karthikesan (1):
      Update /debug/tracing/README

Steven Rostedt (2):
      tracing: remove CALLER_ADDR2 from wakeup tracer
      function-graph: add proper initialization for init task

Zhaolei (2):
      ftrace: Add check of sched_stopped for probe_sched_wakeup
      ftrace: Correct a text align for event format output


 arch/x86/kernel/ftrace.c            |    1 -
 block/blk-core.c                    |    1 +
 include/linux/compiler.h            |    7 +++++--
 include/linux/ftrace.h              |    8 ++++++--
 include/linux/init_task.h           |    2 ++
 kernel/trace/blktrace.c             |    7 ++++---
 kernel/trace/trace.c                |   21 ++++++++++++++++-----
 kernel/trace/trace.h                |    2 +-
 kernel/trace/trace_export.c         |    2 +-
 kernel/trace/trace_output.c         |    2 +-
 kernel/trace/trace_sched_switch.c   |    3 +++
 kernel/trace/trace_sched_wakeup.c   |    8 +++++++-
 scripts/{trace => tracing}/power.pl |    0
 13 files changed, 47 insertions(+), 17 deletions(-)
 rename scripts/{trace => tracing}/power.pl (100%)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 61df775..70a10ca 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -20,7 +20,6 @@
 
 #include <asm/cacheflush.h>
 #include <asm/ftrace.h>
-#include <linux/ftrace.h>
 #include <asm/nops.h>
 #include <asm/nmi.h>
 
diff --git a/block/blk-core.c b/block/blk-core.c
index 29bcfac..859879d 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -132,6 +132,7 @@ void blk_rq_init(struct request_queue *q, struct request *rq)
 	INIT_HLIST_NODE(&rq->hash);
 	RB_CLEAR_NODE(&rq->rb_node);
 	rq->cmd = rq->__cmd;
+	rq->cmd_len = BLK_MAX_CDB;
 	rq->tag = -1;
 	rq->ref_count = 1;
 }
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 6faa7e5..37bcb50 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -76,7 +76,8 @@ struct ftrace_branch_data {
  * Note: DISABLE_BRANCH_PROFILING can be used by special lowlevel code
  * to disable branch tracing on a per file basis.
  */
-#if defined(CONFIG_TRACE_BRANCH_PROFILING) && !defined(DISABLE_BRANCH_PROFILING)
+#if defined(CONFIG_TRACE_BRANCH_PROFILING) \
+    && !defined(DISABLE_BRANCH_PROFILING) && !defined(__CHECKER__)
 void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
 
 #define likely_notrace(x)	__builtin_expect(!!(x), 1)
@@ -114,7 +115,9 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
  * "Define 'is'", Bill Clinton
  * "Define 'if'", Steven Rostedt
  */
-#define if(cond) if (__builtin_constant_p((cond)) ? !!(cond) :		\
+#define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
+#define __trace_if(cond) \
+	if (__builtin_constant_p((cond)) ? !!(cond) :			\
 	({								\
 		int ______r;						\
 		static struct ftrace_branch_data			\
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 015a3d2..da5405d 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -356,6 +356,9 @@ struct ftrace_graph_ret {
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 
+/* for init task */
+#define INIT_FTRACE_GRAPH		.ret_stack = NULL
+
 /*
  * Stack of return addresses for functions
  * of a thread.
@@ -430,10 +433,11 @@ static inline void unpause_graph_tracing(void)
 {
 	atomic_dec(&current->tracing_graph_pause);
 }
-#else
+#else /* !CONFIG_FUNCTION_GRAPH_TRACER */
 
 #define __notrace_funcgraph
 #define __irq_entry
+#define INIT_FTRACE_GRAPH
 
 static inline void ftrace_graph_init_task(struct task_struct *t) { }
 static inline void ftrace_graph_exit_task(struct task_struct *t) { }
@@ -445,7 +449,7 @@ static inline int task_curr_ret_stack(struct task_struct *tsk)
 
 static inline void pause_graph_tracing(void) { }
 static inline void unpause_graph_tracing(void) { }
-#endif
+#endif /* CONFIG_FUNCTION_GRAPH_TRACER */
 
 #ifdef CONFIG_TRACING
 #include <linux/sched.h>
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index e752d97..cada054 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -5,6 +5,7 @@
 #include <linux/irqflags.h>
 #include <linux/utsname.h>
 #include <linux/lockdep.h>
+#include <linux/ftrace.h>
 #include <linux/ipc.h>
 #include <linux/pid_namespace.h>
 #include <linux/user_namespace.h>
@@ -184,6 +185,7 @@ extern struct cred init_cred;
 	INIT_IDS							\
 	INIT_TRACE_IRQFLAGS						\
 	INIT_LOCKDEP							\
+	INIT_FTRACE_GRAPH						\
 }
 
 
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 947c5b3..b32ff44 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -327,10 +327,10 @@ static ssize_t blk_msg_write(struct file *filp, const char __user *buffer,
 	char *msg;
 	struct blk_trace *bt;
 
-	if (count > BLK_TN_MAX_MSG)
+	if (count >= BLK_TN_MAX_MSG)
 		return -EINVAL;
 
-	msg = kmalloc(count, GFP_KERNEL);
+	msg = kmalloc(count + 1, GFP_KERNEL);
 	if (msg == NULL)
 		return -ENOMEM;
 
@@ -339,6 +339,7 @@ static ssize_t blk_msg_write(struct file *filp, const char __user *buffer,
 		return -EFAULT;
 	}
 
+	msg[count] = '\0';
 	bt = filp->private_data;
 	__trace_note_message(bt, "%s", msg);
 	kfree(msg);
@@ -642,7 +643,7 @@ static void blk_add_trace_rq(struct request_queue *q, struct request *rq,
 	if (blk_pc_request(rq)) {
 		what |= BLK_TC_ACT(BLK_TC_PC);
 		__blk_add_trace(bt, 0, rq->data_len, rw, what, rq->errors,
-				sizeof(rq->cmd), rq->cmd);
+				rq->cmd_len, rq->cmd);
 	} else  {
 		what |= BLK_TC_ACT(BLK_TC_FS);
 		__blk_add_trace(bt, rq->hard_sector, rq->hard_nr_sectors << 9,
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index a0174a4..9d28476 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -30,6 +30,7 @@
 #include <linux/percpu.h>
 #include <linux/splice.h>
 #include <linux/kdebug.h>
+#include <linux/string.h>
 #include <linux/ctype.h>
 #include <linux/init.h>
 #include <linux/poll.h>
@@ -147,8 +148,7 @@ static int __init set_ftrace_dump_on_oops(char *str)
 }
 __setup("ftrace_dump_on_oops", set_ftrace_dump_on_oops);
 
-long
-ns2usecs(cycle_t nsec)
+unsigned long long ns2usecs(cycle_t nsec)
 {
 	nsec += 500;
 	do_div(nsec, 1000);
@@ -1632,7 +1632,11 @@ static void test_cpu_buff_start(struct trace_iterator *iter)
 		return;
 
 	cpumask_set_cpu(iter->cpu, iter->started);
-	trace_seq_printf(s, "##### CPU %u buffer started ####\n", iter->cpu);
+
+	/* Don't print started cpu buffer for the first entry of the trace */
+	if (iter->idx > 1)
+		trace_seq_printf(s, "##### CPU %u buffer started ####\n",
+				iter->cpu);
 }
 
 static enum print_line_t print_trace_fmt(struct trace_iterator *iter)
@@ -1867,6 +1871,11 @@ __tracing_open(struct inode *inode, struct file *file)
 	if (current_trace)
 		*iter->trace = *current_trace;
 
+	if (!alloc_cpumask_var(&iter->started, GFP_KERNEL))
+		goto fail;
+
+	cpumask_clear(iter->started);
+
 	if (current_trace && current_trace->print_max)
 		iter->tr = &max_tr;
 	else
@@ -1917,6 +1926,7 @@ __tracing_open(struct inode *inode, struct file *file)
 		if (iter->buffer_iter[cpu])
 			ring_buffer_read_finish(iter->buffer_iter[cpu]);
 	}
+	free_cpumask_var(iter->started);
  fail:
 	mutex_unlock(&trace_types_lock);
 	kfree(iter->trace);
@@ -1960,6 +1970,7 @@ static int tracing_release(struct inode *inode, struct file *file)
 
 	seq_release(inode, file);
 	mutex_destroy(&iter->mutex);
+	free_cpumask_var(iter->started);
 	kfree(iter->trace);
 	kfree(iter);
 	return 0;
@@ -2358,9 +2369,9 @@ static const char readme_msg[] =
 	"# mkdir /debug\n"
 	"# mount -t debugfs nodev /debug\n\n"
 	"# cat /debug/tracing/available_tracers\n"
-	"wakeup preemptirqsoff preemptoff irqsoff ftrace sched_switch none\n\n"
+	"wakeup preemptirqsoff preemptoff irqsoff function sched_switch nop\n\n"
 	"# cat /debug/tracing/current_tracer\n"
-	"none\n"
+	"nop\n"
 	"# echo sched_switch > /debug/tracing/current_tracer\n"
 	"# cat /debug/tracing/current_tracer\n"
 	"sched_switch\n"
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index cb0ce3f..0d81a4a 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -596,7 +596,7 @@ extern int trace_selftest_startup_branch(struct tracer *trace,
 #endif /* CONFIG_FTRACE_STARTUP_TEST */
 
 extern void *head_page(struct trace_array_cpu *data);
-extern long ns2usecs(cycle_t nsec);
+extern unsigned long long ns2usecs(cycle_t nsec);
 extern int
 trace_vbprintk(unsigned long ip, const char *fmt, va_list args);
 extern int
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index 4d9952d..07a22c3 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -40,7 +40,7 @@
 
 #undef TRACE_FIELD_ZERO_CHAR
 #define TRACE_FIELD_ZERO_CHAR(item)					\
-	ret = trace_seq_printf(s, "\tfield: char " #item ";\t"		\
+	ret = trace_seq_printf(s, "\tfield:char " #item ";\t"		\
 			       "offset:%u;\tsize:0;\n",			\
 			       (unsigned int)offsetof(typeof(field), item)); \
 	if (!ret)							\
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index d72b9a6..64b54a5 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -423,7 +423,7 @@ int trace_print_lat_context(struct trace_iterator *iter)
 
 		trace_find_cmdline(entry->pid, comm);
 
-		ret = trace_seq_printf(s, "%16s %5d %3d %d %08x %08lx [%08lx]"
+		ret = trace_seq_printf(s, "%16s %5d %3d %d %08x %08lx [%08llx]"
 				       " %ld.%03ldms (+%ld.%03ldms): ", comm,
 				       entry->pid, iter->cpu, entry->flags,
 				       entry->preempt_count, iter->idx,
diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_switch.c
index de35f20..9117cea 100644
--- a/kernel/trace/trace_sched_switch.c
+++ b/kernel/trace/trace_sched_switch.c
@@ -62,6 +62,9 @@ probe_sched_wakeup(struct rq *__rq, struct task_struct *wakee, int success)
 	pc = preempt_count();
 	tracing_record_cmdline(current);
 
+	if (sched_stopped)
+		return;
+
 	local_irq_save(flags);
 	cpu = raw_smp_processor_id();
 	data = ctx_trace->data[cpu];
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index 3c5ad6b..5bc00e8 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -154,7 +154,7 @@ probe_wakeup_sched_switch(struct rq *rq, struct task_struct *prev,
 	if (unlikely(!tracer_enabled || next != wakeup_task))
 		goto out_unlock;
 
-	trace_function(wakeup_trace, CALLER_ADDR1, CALLER_ADDR2, flags, pc);
+	trace_function(wakeup_trace, CALLER_ADDR0, CALLER_ADDR1, flags, pc);
 	tracing_sched_switch_trace(wakeup_trace, prev, next, flags, pc);
 
 	/*
@@ -257,6 +257,12 @@ probe_wakeup(struct rq *rq, struct task_struct *p, int success)
 	data = wakeup_trace->data[wakeup_cpu];
 	data->preempt_timestamp = ftrace_now(cpu);
 	tracing_sched_wakeup_trace(wakeup_trace, p, current, flags, pc);
+
+	/*
+	 * We must be careful in using CALLER_ADDR2. But since wake_up
+	 * is not called by an assembly function  (where as schedule is)
+	 * it should be safe to use it here.
+	 */
 	trace_function(wakeup_trace, CALLER_ADDR1, CALLER_ADDR2, flags, pc);
 
 out_locked:
diff --git a/scripts/trace/power.pl b/scripts/tracing/power.pl
similarity index 100%
rename from scripts/trace/power.pl
rename to scripts/tracing/power.pl
