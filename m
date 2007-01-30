Return-Path: <linux-kernel-owner+w=401wt.eu-S1751733AbXA3VkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751733AbXA3VkY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 16:40:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751678AbXA3Vjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 16:39:53 -0500
Received: from tetsuo.zabbo.net ([207.173.201.20]:46909 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751728AbXA3Vjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 16:39:47 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 4 of 4] Introduce aio system call submission and completion
	system calls
X-Mercurial-Node: 5bdda0f7bef20427f7e1c7d06aae5b0d2a51840f
Message-Id: <5bdda0f7bef20427f7e1.1170193185@tetsuo.zabbo.net>
In-Reply-To: <patchbomb.1170193181@tetsuo.zabbo.net>
Date: Tue, 30 Jan 2007 13:39:45 -0700
From: Zach Brown <zach.brown@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This finally does something useful with the notion of being able to schedule
stacks as fibrils under a task_struct.  Again, i386-specific and in need of
proper layering with archs.

sys_asys_submit() is added to let userspace submit asynchronous system calls.
It specifies the system call number and arguments.  A fibril is constructed for
each call.  Each starts with a stack which executes the given system call
handler and then returns to a function which records the return code of the
system call handler.  sys_asys_await_completion() then lets userspace collect
these results.

sys_asys_submit() is careful to construct a fibril for the submission syscall
itself so that it can return to userspace if the calls it is dispatching block.
If none of them block, however, they will have all been run hot in this
submitting task on this processor.

It allocates and runs each system call in turn.  It could certainly work in
batches to decrease locking overhead at the cost of increased peak memory
overhead for calls which don't end up blocking.

The complexity of a fully-formed submission and completion interface hasn't
been addressed.  Details like targeting explicit completion contexts, batching,
timeouts, signal delivery, and syscall-free submission and completion (now with
more rings!) can all be hashed out in some giant thread, no doubt.  I didn't
want them to cloud the basic mechanics being presented here.

diff -r 4ea674e8825e -r 5bdda0f7bef2 arch/i386/kernel/syscall_table.S
--- a/arch/i386/kernel/syscall_table.S	Mon Jan 29 15:46:47 2007 -0800
+++ b/arch/i386/kernel/syscall_table.S	Mon Jan 29 15:50:10 2007 -0800
@@ -319,3 +319,5 @@ ENTRY(sys_call_table)
 	.long sys_move_pages
 	.long sys_getcpu
 	.long sys_epoll_pwait
+	.long sys_asys_submit		/* 320 */
+	.long sys_asys_await_completion
diff -r 4ea674e8825e -r 5bdda0f7bef2 include/asm-i386/unistd.h
--- a/include/asm-i386/unistd.h	Mon Jan 29 15:46:47 2007 -0800
+++ b/include/asm-i386/unistd.h	Mon Jan 29 15:50:10 2007 -0800
@@ -325,6 +325,8 @@
 #define __NR_move_pages		317
 #define __NR_getcpu		318
 #define __NR_epoll_pwait	319
+#define __NR_asys_submit	320
+#define __NR_asys_await_completion	321
 
 #ifdef __KERNEL__
 
diff -r 4ea674e8825e -r 5bdda0f7bef2 include/linux/init_task.h
--- a/include/linux/init_task.h	Mon Jan 29 15:46:47 2007 -0800
+++ b/include/linux/init_task.h	Mon Jan 29 15:50:10 2007 -0800
@@ -148,6 +148,8 @@ extern struct group_info init_groups;
 	.pi_lock	= SPIN_LOCK_UNLOCKED,				\
 	INIT_TRACE_IRQFLAGS						\
 	INIT_LOCKDEP							\
+	.asys_wait = __WAIT_QUEUE_HEAD_INITIALIZER(tsk.asys_wait),	\
+	.asys_completed = LIST_HEAD_INIT(tsk.asys_completed),		\
 }
 
 
diff -r 4ea674e8825e -r 5bdda0f7bef2 include/linux/sched.h
--- a/include/linux/sched.h	Mon Jan 29 15:46:47 2007 -0800
+++ b/include/linux/sched.h	Mon Jan 29 15:50:10 2007 -0800
@@ -1019,6 +1019,14 @@ struct task_struct {
 
 	/* Protection of the PI data structures: */
 	spinlock_t pi_lock;
+
+	/*
+	 * XXX This is just a dummy that should be in a seperately managed
+	 * context.  An explicit contexts lets asys calls be nested (!) and
+	 * will let us provide the sys_io_*() API on top of asys.
+	 */
+	struct list_head asys_completed;
+	wait_queue_head_t	asys_wait;
 
 #ifdef CONFIG_RT_MUTEXES
 	/* PI waiters blocked on a rt_mutex held by this task */
diff -r 4ea674e8825e -r 5bdda0f7bef2 kernel/Makefile
--- a/kernel/Makefile	Mon Jan 29 15:46:47 2007 -0800
+++ b/kernel/Makefile	Mon Jan 29 15:50:10 2007 -0800
@@ -8,7 +8,7 @@ obj-y     = sched.o fork.o exec_domain.o
 	    signal.o sys.o kmod.o workqueue.o pid.o \
 	    rcupdate.o extable.o params.o posix-timers.o \
 	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
-	    hrtimer.o rwsem.o latency.o nsproxy.o srcu.o
+	    hrtimer.o rwsem.o latency.o nsproxy.o srcu.o asys.o
 
 obj-$(CONFIG_STACKTRACE) += stacktrace.o
 obj-y += time/
diff -r 4ea674e8825e -r 5bdda0f7bef2 kernel/exit.c
--- a/kernel/exit.c	Mon Jan 29 15:46:47 2007 -0800
+++ b/kernel/exit.c	Mon Jan 29 15:50:10 2007 -0800
@@ -42,6 +42,7 @@
 #include <linux/audit.h> /* for audit_free() */
 #include <linux/resource.h>
 #include <linux/blkdev.h>
+#include <linux/asys.h>
 
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
@@ -926,6 +927,8 @@ fastcall NORET_TYPE void do_exit(long co
 	taskstats_exit(tsk, group_dead);
 
 	exit_mm(tsk);
+
+	asys_task_exiting(tsk);
 
 	if (group_dead)
 		acct_process();
diff -r 4ea674e8825e -r 5bdda0f7bef2 kernel/fork.c
--- a/kernel/fork.c	Mon Jan 29 15:46:47 2007 -0800
+++ b/kernel/fork.c	Mon Jan 29 15:50:10 2007 -0800
@@ -49,6 +49,7 @@
 #include <linux/delayacct.h>
 #include <linux/taskstats_kern.h>
 #include <linux/random.h>
+#include <linux/asys.h>
 
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
@@ -987,6 +988,8 @@ static struct task_struct *copy_process(
 		goto fork_out;
 
 	rt_mutex_init_task(p);
+
+	asys_init_task(p);
 
 #ifdef CONFIG_TRACE_IRQFLAGS
 	DEBUG_LOCKS_WARN_ON(!p->hardirqs_enabled);
diff -r 4ea674e8825e -r 5bdda0f7bef2 include/linux/asys.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/include/linux/asys.h	Mon Jan 29 15:50:10 2007 -0800
@@ -0,0 +1,7 @@
+#ifndef _LINUX_ASYS_H 
+#define _LINUX_ASYS_H 
+
+void asys_task_exiting(struct task_struct *tsk);
+void asys_init_task(struct task_struct *tsk);
+
+#endif
diff -r 4ea674e8825e -r 5bdda0f7bef2 kernel/asys.c
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/kernel/asys.c	Mon Jan 29 15:50:10 2007 -0800
@@ -0,0 +1,252 @@
+#include <linux/sched.h>
+#include <linux/uaccess.h>
+#include <linux/err.h>
+#include <linux/asys.h>
+
+/* XXX */
+#include <asm/processor.h>
+
+/*
+ * system call and argument specification given to _submit from userspace
+ */
+struct asys_input {
+	int 		syscall_nr;
+	unsigned long	cookie;
+	unsigned long	nr_args;
+	unsigned long	*args;
+};
+
+/*
+ * system call completion event given to userspace
+ * XXX: compat
+ */
+struct asys_completion {
+	long 		return_code;
+	unsigned long	cookie;
+};
+
+/*
+ * This record of a completed async system call is kept around until it
+ * is collected by userspace.
+ */
+struct asys_result {
+	struct list_head	item;
+	struct asys_completion	comp;
+};
+
+/*
+ * This stack is built-up and handed to the scheduler to first process
+ * the system call.  It stores the progress of the call until the call returns
+ * and this structure is freed.
+ */
+struct asys_call {
+	struct asys_result	*result;
+	struct fibril		fibril;
+};
+
+void asys_init_task(struct task_struct *tsk)
+{
+	INIT_LIST_HEAD(&tsk->asys_completed);
+	init_waitqueue_head(&tsk->asys_wait);
+}
+
+void asys_task_exiting(struct task_struct *tsk)
+{
+	struct asys_result *res, *next;
+
+	list_for_each_entry_safe(res, next, &tsk->asys_completed, item)
+		kfree(res);
+
+	/* 
+	 * XXX this only works if tsk->fibril was allocated by
+	 * sys_asys_submit(), not if its embedded in an asys_call.  This
+	 * implies that we must forbid sys_exit in asys_submit.
+	 */
+	if (tsk->fibril) {
+		BUG_ON(!list_empty(&tsk->fibril->run_list));
+		kfree(tsk->fibril);
+		tsk->fibril = NULL;
+	}
+}
+
+/*
+ * Initial asys call stacks are constructed such that this is called when
+ * the system call handler returns.  It records the return code from
+ * the handler in a completion event and frees data associated with the
+ * completed asys call.
+ *
+ * XXX we know that the x86 syscall handlers put their return code in eax and
+ * that regparm(3) here will take our rc argument from eax.
+ */
+static void fastcall NORET_TYPE asys_teardown_stack(long rc)
+{
+	struct asys_result *res;
+	struct asys_call *call;
+	struct fibril *fibril;
+
+	fibril = current->fibril;
+	call = container_of(fibril, struct asys_call, fibril);
+	res = call->result;
+	call->result = NULL;
+
+	res->comp.return_code = rc;
+	list_add_tail(&res->item, &current->asys_completed);
+	wake_up(&current->asys_wait);
+
+	/*
+	 * We embedded the fibril in the call so that we could dereference it
+	 * here without adding some tracking to the fibril.  We then free the
+	 * call and fibril because we're done with them.
+	 *
+	 * The ti itself, though, is still in use.  It will only be freed once
+	 * the scheduler switches away from it to another fibril.  It does
+	 * that when it sees current->fibril assigned to NULL.
+	 */
+	current->fibril = NULL;
+	BUG_ON(!list_empty(&fibril->run_list));
+	kfree(call);
+
+	/* 
+	 * XXX This is sloppy.  We "know" this is likely for now as the task
+	 * with fibrils is only going to be in sys_asys_submit() or
+	 * sys_asys_complete()
+	 */
+	BUG_ON(list_empty(&current->runnable_fibrils));
+
+	schedule();
+	BUG();
+}
+
+asmlinkage long sys_asys_await_completion(struct asys_completion __user *comp)
+{
+	struct asys_result *res;
+	long ret;
+
+	ret = wait_event_interruptible(current->asys_wait,
+				       !list_empty(&current->asys_completed));
+	if (ret)
+		goto out;
+
+	res = list_entry(current->asys_completed.next, struct asys_result,
+			  item);
+
+	/* XXX compat */
+	ret = copy_to_user(comp, &res->comp, sizeof(struct asys_completion));
+	if (ret) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	list_del(&res->item);
+	kfree(res);
+	ret = 1;
+
+out:
+	return ret;
+}
+
+/*
+ * This initializes a newly allocated fibril so that it can be handed to the
+ * scheduler.  The fibril is private to this code path at this point.
+ *
+ * XXX
+ *  - this is arch specific
+ *  - should maybe have a sched helper that uses INIT_PER_CALL_CHAIN
+ */
+extern unsigned long sys_call_table[]; /* XXX */
+static int asys_init_fibril(struct fibril *fibril, struct thread_info *ti, 
+			    struct asys_input *inp)
+{
+	unsigned long *stack_bottom;
+
+	INIT_LIST_HEAD(&fibril->run_list);
+	fibril->ti = ti;
+
+	/* XXX sanity check syscall_nr */
+	fibril->eip = sys_call_table[inp->syscall_nr];
+	/* this mirrors copy_thread()'s use of task_pt_regs() */
+	fibril->esp = (unsigned long)thread_info_pt_regs(ti) -
+			((inp->nr_args + 1) * sizeof(long));
+
+	/* 
+	 * now setup the stack so that our syscall handler gets its arguments
+	 * and we return to asys_teardown_stack.
+	 */
+	stack_bottom = (unsigned long *)fibril->esp;
+	stack_bottom[0] = (unsigned long)asys_teardown_stack;
+	/* XXX compat */
+	if (copy_from_user(&stack_bottom[1], inp->args,
+			   inp->nr_args * sizeof(long)))
+		return -EFAULT;
+
+	return 0;
+}
+
+asmlinkage long sys_asys_submit(struct asys_input __user *user_inp,
+				unsigned long nr_inp)
+{
+	struct asys_input inp;
+	struct asys_result *res;
+	struct asys_call *call;
+	struct thread_info *ti;
+	unsigned long i;
+	long err = 0;
+
+	/* Allocate a fibril for the submitter's thread_info */
+	if (current->fibril == NULL) {
+		current->fibril = kzalloc(sizeof(struct fibril), GFP_KERNEL);
+		if (current->fibril == NULL)
+			return -ENOMEM;
+
+		INIT_LIST_HEAD(&current->fibril->run_list);
+		current->fibril->state = TASK_RUNNING;
+		current->fibril->ti = current_thread_info();
+	}
+
+	for (i = 0; i < nr_inp; i++) {
+
+		if (copy_from_user(&inp, &user_inp[i], sizeof(inp))) {
+			err = -EFAULT;
+			break;
+		}
+
+		res = kmalloc(sizeof(struct asys_result), GFP_KERNEL);
+		if (res == NULL) {
+			err = -ENOMEM;
+			break;
+		}
+
+		/* XXX kzalloc to init call.fibril.per_cpu, add helper */
+		call = kzalloc(sizeof(struct asys_call), GFP_KERNEL);
+		if (call == NULL) {
+			kfree(res);
+			err = -ENOMEM;
+			break;
+		}
+
+		ti = alloc_thread_info(tsk);
+		if (ti == NULL) {
+			kfree(res);
+			kfree(call);
+			err = -ENOMEM;
+			break;
+		}
+
+		err = asys_init_fibril(&call->fibril, ti, &inp);
+		if (err) {
+			kfree(res);
+			kfree(call);
+			free_thread_info(ti);
+			break;
+		}
+
+		res->comp.cookie = inp.cookie;
+		call->result = res;
+		ti->task = current;
+
+		sched_new_runnable_fibril(&call->fibril);
+		schedule();
+	}
+
+	return i ? i : err;
+}
