Return-Path: <linux-kernel-owner+w=401wt.eu-S1756436AbYKWFXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756436AbYKWFXT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 00:23:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750819AbYKWFXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 00:23:06 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:43780 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbYKWFXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 00:23:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=m5mh3Y386nctKgHoCvxczlsdBArJPH6PJ8NKkE/tZ2GTAtWp8qnQdsvNOXc7CbiA1V
         HTmzTuaAYtkv92YSrKSKPh6Hqg9kbbqyJv4oUCZgo+PU7ac0Lz/uvs5ciRIAw5rW55ma
         lnlZOmgPJqzOCIsRWRZTsSEDH4zsk/B51ap+0=
Message-ID: <4928E8B0.1090103@gmail.com>
Date: Sun, 23 Nov 2008 06:22:56 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing/function-return-tracer: store return stack into task_struct
 and allocate it dynamically
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: use deeper tracing depth safely

Some tests showed that function return tracing needed a more deeper depth
of function calls. But it could be unsafe to store these return addresses
to the stack.
So these arrays will now be allocated dynamically into task_struct of current
only when the tracer is activated.

Typical scheme when tracer is activated:
_ allocate a return stack for each task in global list.
_ fork: allocate the return stack for the newly created task
_ exit: free return stack of current
_ idle init: same as fork

I chose a default depth of 50. I don't have anymore overruns (didn't tested for
a long time).

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/include/asm/ftrace.h      |    1 -
 arch/x86/include/asm/thread_info.h |   29 -----------
 arch/x86/kernel/ftrace.c           |   29 ++++++-----
 include/linux/ftrace.h             |    5 ++
 include/linux/sched.h              |   23 ++++-----
 kernel/exit.c                      |    5 ++-
 kernel/fork.c                      |    4 ++
 kernel/sched.c                     |    3 +
 kernel/trace/ftrace.c              |   96 +++++++++++++++++++++++++++++++++++-
 9 files changed, 137 insertions(+), 58 deletions(-)

diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
index 2bb43b4..754a3e0 100644
--- a/arch/x86/include/asm/ftrace.h
+++ b/arch/x86/include/asm/ftrace.h
@@ -29,7 +29,6 @@ struct dyn_arch_ftrace {
 #endif /* CONFIG_FUNCTION_TRACER */
 
 #ifdef CONFIG_FUNCTION_RET_TRACER
-#define FTRACE_RET_STACK_SIZE 20
 
 #ifndef __ASSEMBLY__
 
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index e90e81e..0921b40 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -40,36 +40,8 @@ struct thread_info {
 						*/
 	__u8			supervisor_stack[0];
 #endif
-
-#ifdef CONFIG_FUNCTION_RET_TRACER
-	/* Index of current stored adress in ret_stack */
-	int		curr_ret_stack;
-	/* Stack of return addresses for return function tracing */
-	struct ftrace_ret_stack	ret_stack[FTRACE_RET_STACK_SIZE];
-	/*
-	 * Number of functions that haven't been traced
-	 * because of depth overrun.
-	 */
-	atomic_t	trace_overrun;
-#endif
 };
 
-#ifdef CONFIG_FUNCTION_RET_TRACER
-#define INIT_THREAD_INFO(tsk)			\
-{						\
-	.task		= &tsk,			\
-	.exec_domain	= &default_exec_domain,	\
-	.flags		= 0,			\
-	.cpu		= 0,			\
-	.preempt_count	= 1,			\
-	.addr_limit	= KERNEL_DS,		\
-	.restart_block = {			\
-		.fn = do_no_restart_syscall,	\
-	},					\
-	.curr_ret_stack = -1,\
-	.trace_overrun	= ATOMIC_INIT(0)	\
-}
-#else
 #define INIT_THREAD_INFO(tsk)			\
 {						\
 	.task		= &tsk,			\
@@ -82,7 +54,6 @@ struct thread_info {
 		.fn = do_no_restart_syscall,	\
 	},					\
 }
-#endif
 
 #define init_thread_info	(init_thread_union.thread_info)
 #define init_stack		(init_thread_union.stack)
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 356bb1e..bb137f7 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -350,19 +350,21 @@ static int push_return_trace(unsigned long ret, unsigned long long time,
 				unsigned long func)
 {
 	int index;
-	struct thread_info *ti = current_thread_info();
+
+	if (!current->ret_stack)
+		return -EBUSY;
 
 	/* The return trace stack is full */
-	if (ti->curr_ret_stack == FTRACE_RET_STACK_SIZE - 1) {
-		atomic_inc(&ti->trace_overrun);
+	if (current->curr_ret_stack == FTRACE_RETFUNC_DEPTH - 1) {
+		atomic_inc(&current->trace_overrun);
 		return -EBUSY;
 	}
 
-	index = ++ti->curr_ret_stack;
+	index = ++current->curr_ret_stack;
 	barrier();
-	ti->ret_stack[index].ret = ret;
-	ti->ret_stack[index].func = func;
-	ti->ret_stack[index].calltime = time;
+	current->ret_stack[index].ret = ret;
+	current->ret_stack[index].func = func;
+	current->ret_stack[index].calltime = time;
 
 	return 0;
 }
@@ -373,13 +375,12 @@ static void pop_return_trace(unsigned long *ret, unsigned long long *time,
 {
 	int index;
 
-	struct thread_info *ti = current_thread_info();
-	index = ti->curr_ret_stack;
-	*ret = ti->ret_stack[index].ret;
-	*func = ti->ret_stack[index].func;
-	*time = ti->ret_stack[index].calltime;
-	*overrun = atomic_read(&ti->trace_overrun);
-	ti->curr_ret_stack--;
+	index = current->curr_ret_stack;
+	*ret = current->ret_stack[index].ret;
+	*func = current->ret_stack[index].func;
+	*time = current->ret_stack[index].calltime;
+	*overrun = atomic_read(&current->trace_overrun);
+	current->curr_ret_stack--;
 }
 
 /*
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index f7ba4ea..2ba259b 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -323,6 +323,8 @@ struct ftrace_retfunc {
 };
 
 #ifdef CONFIG_FUNCTION_RET_TRACER
+#define FTRACE_RETFUNC_DEPTH 50
+#define FTRACE_RETSTACK_ALLOC_SIZE 32
 /* Type of a callback handler of tracing return function */
 typedef void (*trace_function_return_t)(struct ftrace_retfunc *);
 
@@ -330,6 +332,9 @@ extern int register_ftrace_return(trace_function_return_t func);
 /* The current handler in use */
 extern trace_function_return_t ftrace_function_return;
 extern void unregister_ftrace_return(void);
+
+extern void ftrace_retfunc_init_task(struct task_struct *t);
+extern void ftrace_retfunc_exit_task(struct task_struct *t);
 #endif
 
 #endif /* _LINUX_FTRACE_H */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index deba0ed..e22cb72 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1349,6 +1349,17 @@ struct task_struct {
 	unsigned long default_timer_slack_ns;
 
 	struct list_head	*scm_work_list;
+#ifdef CONFIG_FUNCTION_RET_TRACER
+	/* Index of current stored adress in ret_stack */
+	int curr_ret_stack;
+	/* Stack of return addresses for return function tracing */
+	struct ftrace_ret_stack	*ret_stack;
+	/*
+	 * Number of functions that haven't been traced
+	 * because of depth overrun.
+	 */
+	atomic_t trace_overrun;
+#endif
 };
 
 /*
@@ -2003,18 +2014,6 @@ static inline void setup_thread_stack(struct task_struct *p, struct task_struct
 {
 	*task_thread_info(p) = *task_thread_info(org);
 	task_thread_info(p)->task = p;
-
-#ifdef CONFIG_FUNCTION_RET_TRACER
-	/*
-	 * When fork() creates a child process, this function is called.
-	 * But the child task may not inherit the return adresses traced
-	 * by the return function tracer because it will directly execute
-	 * in userspace and will not return to kernel functions its parent
-	 * used.
-	 */
-	task_thread_info(p)->curr_ret_stack = -1;
-	atomic_set(&task_thread_info(p)->trace_overrun, 0);
-#endif
 }
 
 static inline unsigned long *end_of_stack(struct task_struct *p)
diff --git a/kernel/exit.c b/kernel/exit.c
index 1eb455c..2c98e8c 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -47,6 +47,7 @@
 #include <linux/task_io_accounting_ops.h>
 #include <linux/tracehook.h>
 #include <trace/sched.h>
+#include <linux/ftrace.h>
 
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
@@ -1124,7 +1125,9 @@ NORET_TYPE void do_exit(long code)
 	preempt_disable();
 	/* causes final put_task_struct in finish_task_switch(). */
 	tsk->state = TASK_DEAD;
-
+#ifdef CONFIG_FUNCTION_RET_TRACER
+	ftrace_retfunc_exit_task(tsk);
+#endif
 	schedule();
 	BUG();
 	/* Avoid "noreturn function does return".  */
diff --git a/kernel/fork.c b/kernel/fork.c
index 775d62a..76afd0a 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -61,6 +61,7 @@
 #include <linux/blkdev.h>
 #include <trace/sched.h>
 #include <linux/magic.h>
+#include <linux/ftrace.h>
 
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
@@ -1274,6 +1275,9 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	total_forks++;
 	spin_unlock(&current->sighand->siglock);
 	write_unlock_irq(&tasklist_lock);
+#ifdef CONFIG_FUNCTION_RET_TRACER
+	ftrace_retfunc_init_task(p);
+#endif
 	proc_fork_connector(p);
 	cgroup_post_fork(p);
 	return p;
diff --git a/kernel/sched.c b/kernel/sched.c
index 2b33c28..510fedc 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5864,6 +5864,9 @@ void __cpuinit init_idle(struct task_struct *idle, int cpu)
 	 * The idle tasks have their own, simple scheduling class:
 	 */
 	idle->sched_class = &idle_sched_class;
+#ifdef CONFIG_FUNCTION_RET_TRACER
+	ftrace_retfunc_init_task(idle);
+#endif
 }
 
 /*
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index f212da4..90d99fb 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1498,10 +1498,77 @@ ftrace_enable_sysctl(struct ctl_table *table, int write,
 
 #ifdef CONFIG_FUNCTION_RET_TRACER
 
+static atomic_t ftrace_retfunc_active;
+
 /* The callback that hooks the return of a function */
 trace_function_return_t ftrace_function_return =
 			(trace_function_return_t)ftrace_stub;
 
+
+/* Try to assign a return stack array on FTRACE_RETSTACK_ALLOC_SIZE tasks. */
+static int alloc_retstack_tasklist(struct ftrace_ret_stack **ret_stack_list)
+{
+	int i;
+	int ret = 0;
+	unsigned long flags;
+	int start = 0, end = FTRACE_RETSTACK_ALLOC_SIZE;
+	struct task_struct *g, *t;
+
+	for (i = 0; i < FTRACE_RETSTACK_ALLOC_SIZE; i++) {
+		ret_stack_list[i] = kmalloc(FTRACE_RETFUNC_DEPTH
+					* sizeof(struct ftrace_ret_stack),
+					GFP_KERNEL);
+		if (!ret_stack_list[i]) {
+			start = 0;
+			end = i;
+			ret = -ENOMEM;
+			goto free;
+		}
+	}
+
+	read_lock_irqsave(&tasklist_lock, flags);
+	do_each_thread(g, t) {
+		if (start == end) {
+			ret = -EAGAIN;
+			goto unlock;
+		}
+
+		if (t->ret_stack == NULL) {
+			t->ret_stack = ret_stack_list[start++];
+			t->curr_ret_stack = -1;
+			atomic_set(&t->trace_overrun, 0);
+		}
+	} while_each_thread(g, t);
+
+unlock:
+	read_unlock_irqrestore(&tasklist_lock, flags);
+free:
+	for (i = start; i < end; i++)
+		kfree(ret_stack_list[i]);
+	return ret;
+}
+
+/* Allocate a return stack for each task */
+static int start_return_tracing(void)
+{
+	struct ftrace_ret_stack **ret_stack_list;
+	int ret;
+
+	ret_stack_list = kmalloc(FTRACE_RETSTACK_ALLOC_SIZE *
+				sizeof(struct ftrace_ret_stack *),
+				GFP_KERNEL);
+
+	if (!ret_stack_list)
+		return -ENOMEM;
+
+	do {
+		ret = alloc_retstack_tasklist(ret_stack_list);
+	} while (ret == -EAGAIN);
+
+	kfree(ret_stack_list);
+	return ret;
+}
+
 int register_ftrace_return(trace_function_return_t func)
 {
 	int ret = 0;
@@ -1516,7 +1583,12 @@ int register_ftrace_return(trace_function_return_t func)
 		ret = -EBUSY;
 		goto out;
 	}
-
+	atomic_inc(&ftrace_retfunc_active);
+	ret = start_return_tracing();
+	if (ret) {
+		atomic_dec(&ftrace_retfunc_active);
+		goto out;
+	}
 	ftrace_tracing_type = FTRACE_TYPE_RETURN;
 	ftrace_function_return = func;
 	ftrace_startup();
@@ -1530,6 +1602,7 @@ void unregister_ftrace_return(void)
 {
 	mutex_lock(&ftrace_sysctl_lock);
 
+	atomic_dec(&ftrace_retfunc_active);
 	ftrace_function_return = (trace_function_return_t)ftrace_stub;
 	ftrace_shutdown();
 	/* Restore normal tracing type */
@@ -1537,6 +1610,27 @@ void unregister_ftrace_return(void)
 
 	mutex_unlock(&ftrace_sysctl_lock);
 }
+
+/* Allocate a return stack for newly created task */
+void ftrace_retfunc_init_task(struct task_struct *t)
+{
+	if (atomic_read(&ftrace_retfunc_active)) {
+		t->ret_stack = kmalloc(FTRACE_RETFUNC_DEPTH
+				* sizeof(struct ftrace_ret_stack),
+				GFP_KERNEL);
+		if (!t->ret_stack)
+			return;
+		t->curr_ret_stack = -1;
+		atomic_set(&t->trace_overrun, 0);
+	} else
+		t->ret_stack = NULL;
+}
+
+void ftrace_retfunc_exit_task(struct task_struct *t)
+{
+	kfree(t->ret_stack);
+	t->ret_stack = NULL;
+}
 #endif
 
 
-- 
1.5.2.5
