Return-Path: <linux-kernel-owner+w=401wt.eu-S1756369AbXLFXV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369AbXLFXV5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 18:21:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753727AbXLFXU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 18:20:27 -0500
Received: from tetsuo.zabbo.net ([207.173.201.20]:50769 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753022AbXLFXUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 18:20:22 -0500
From: Zach Brown <zach.brown@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Ulrich Drepper <drepper@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dan Williams <dan.j.williams@gmail.com>, Jeff Moyer <jmoyer@redhat.com>,
       Simon Holm Thogersen <odie@cs.aau.dk>, suresh.b.siddha@intel.com
Subject: [PATCH 5/6] syslets: add generic syslets infrastructure
Date: Thu,  6 Dec 2007 15:20:18 -0800
Message-Id: <11969832192130-git-send-email-zach.brown@oracle.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <1196983219370-git-send-email-zach.brown@oracle.com>
References: <1196983219534-git-send-email-zach.brown@oracle.com>
 <11969832193635-git-send-email-zach.brown@oracle.com>
 <1196983219225-git-send-email-zach.brown@oracle.com>
 <11969832192868-git-send-email-zach.brown@oracle.com>
 <1196983219370-git-send-email-zach.brown@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The indirect syslet arguments specify where to store the completion and what
function in userspcae to return to once the syslet has been executed.  The
details of how we pass the indirect syslet arguments needs help.

We parse the indirect syslet arguments in sys_indirect() before we call
the given system call.  If they're OK we mark the task as ready to become
a syslet.  We make sure that there is a child task waiting.

We call into kernel/syslet.c from the scheduler when we try to block a task
which has been marked as ready.   A child task is woken and returns to
userspace.

We store the result of the system call in the userspace ring back up in
sys_indrect() as the system call finally finishes.  At that point the original
task returns to the frame that userspace provided in the indirect syslet args.

This generic infrastructure relies on architecture specific routines to create
a new child task, move userspace state from one kernel task to another, and to
setup the userspace return frame in ptregs.  Code in asm-generic just returns
-EINVAL until an architecture provides the needed routines.

This is a simplification of Ingo's more involved syslet and threatlet
infrastructure which was built around 'uatoms'.  Enough code has changed that
it wasn't appropriate to bring the previous Signed-off-by lines forward.

Signed-off-by: Zach Brown <zach.brown@oracle.com>;

diff --git a/fs/exec.c b/fs/exec.c
index 282240a..942262f 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -51,6 +51,7 @@
 #include <linux/tsacct_kern.h>
 #include <linux/cn_proc.h>
 #include <linux/audit.h>
+#include <linux/syslet.h>
 
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
@@ -1614,6 +1615,8 @@ static int coredump_wait(int exit_code)
 		complete(vfork_done);
 	}
 
+	kill_syslet_tasks(tsk);
+
 	if (core_waiters)
 		wait_for_completion(&startup_done);
 fail:
diff --git a/include/asm-generic/errno.h b/include/asm-generic/errno.h
index e8852c0..26674c4 100644
--- a/include/asm-generic/errno.h
+++ b/include/asm-generic/errno.h
@@ -106,4 +106,7 @@
 #define	EOWNERDEAD	130	/* Owner died */
 #define	ENOTRECOVERABLE	131	/* State not recoverable */
 
+/* for syslets */
+#define	ESYSLETPENDING	132	/* syslet syscall now pending */
+
 #endif
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 61a4b83..a134966 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1182,6 +1182,13 @@ struct task_struct {
 
 	/* Additional system call parameters.  */
 	union indirect_params indirect_params;
+
+	/* task waiting to return to userspace if we block as a syslet */
+	spinlock_t		syslet_lock;
+	struct list_head	syslet_tasks;
+	unsigned		syslet_ready:1,
+				syslet_return:1,
+				syslet_exit:1;
 };
 
 /*
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index addb39f..1a44838 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -55,6 +55,7 @@ struct compat_timeval;
 struct robust_list_head;
 struct getcpu_cache;
 struct indirect_registers;
+struct syslet_ring;
 
 #include <linux/types.h>
 #include <linux/aio_abi.h>
@@ -615,6 +616,8 @@ asmlinkage long sys_fallocate(int fd, int mode, loff_t offset, loff_t len);
 asmlinkage long sys_indirect(struct indirect_registers __user *userregs,
 			     void __user *userparams, size_t paramslen,
 			     int flags);
+asmlinkage long sys_syslet_ring_wait(struct syslet_ring __user *ring,
+				     unsigned long user_idx);
 
 int kernel_execve(const char *filename, char *const argv[], char *const envp[]);
 
diff --git a/include/linux/syslet.h b/include/linux/syslet.h
new file mode 100644
index 0000000..734b98f
--- /dev/null
+++ b/include/linux/syslet.h
@@ -0,0 +1,18 @@
+#ifndef _LINUX_SYSLET_H
+#define _LINUX_SYSLET_H
+
+#include <linux/syslet-abi.h>
+#include <asm/syslet.h>
+
+void syslet_init(struct task_struct *tsk);
+void kill_syslet_tasks(struct task_struct *cur);
+void syslet_schedule(struct task_struct *cur);
+int syslet_pre_indirect(void);
+int syslet_post_indirect(int status);
+
+static inline int syslet_args_present(union indirect_params *params)
+{
+	return params->syslet.completion_ring_ptr;
+}
+
+#endif
diff --git a/kernel/Makefile b/kernel/Makefile
index bcad37d..7a7dfbe 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -9,7 +9,7 @@ obj-y     = sched.o fork.o exec_domain.o panic.o printk.o profile.o \
 	    rcupdate.o extable.o params.o posix-timers.o \
 	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
 	    hrtimer.o rwsem.o latency.o nsproxy.o srcu.o \
-	    utsname.o notifier.o
+	    utsname.o notifier.o syslet.o
 
 obj-$(CONFIG_SYSCTL) += sysctl_check.o
 obj-$(CONFIG_STACKTRACE) += stacktrace.o
diff --git a/kernel/exit.c b/kernel/exit.c
index 549c055..831b2f9 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -44,6 +44,7 @@
 #include <linux/resource.h>
 #include <linux/blkdev.h>
 #include <linux/task_io_accounting_ops.h>
+#include <linux/syslet.h>
 
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
@@ -949,6 +950,12 @@ fastcall NORET_TYPE void do_exit(long code)
 		schedule();
 	}
 
+	/*
+	 * syslet threads have to exit their context before the MM exit (due to
+	 * the coredumping wait).
+	 */
+	kill_syslet_tasks(tsk);
+
 	tsk->flags |= PF_EXITING;
 	/*
 	 * tsk->flags are checked in the futex code to protect against
diff --git a/kernel/fork.c b/kernel/fork.c
index 8ca1a14..4b1efb9 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -51,6 +51,7 @@
 #include <linux/random.h>
 #include <linux/tty.h>
 #include <linux/proc_fs.h>
+#include <linux/syslet.h>
 
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
@@ -1123,6 +1124,8 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	p->blocked_on = NULL; /* not blocked yet */
 #endif
 
+	syslet_init(p);
+
 	/* Perform scheduler related setup. Assign this task to a CPU. */
 	sched_fork(p, clone_flags);
 
diff --git a/kernel/indirect.c b/kernel/indirect.c
index bc60850..3bcfaff 100644
--- a/kernel/indirect.c
+++ b/kernel/indirect.c
@@ -3,6 +3,8 @@
 #include <linux/unistd.h>
 #include <asm/asm-offsets.h>
 
+/* XXX would we prefer to generalize this somehow? */
+#include <linux/syslet.h>
 
 asmlinkage long sys_indirect(struct indirect_registers __user *userregs,
 			     void __user *userparams, size_t paramslen,
@@ -17,6 +19,24 @@ asmlinkage long sys_indirect(struct indirect_registers __user *userregs,
 	if (copy_from_user(&regs, userregs, sizeof(regs)))
 		return -EFAULT;
 
+	if (paramslen > sizeof(union indirect_params))
+		return -EINVAL;
+
+	if (copy_from_user(&current->indirect_params, userparams, paramslen)) {
+		result = -EFAULT;
+		goto out;
+	}
+
+	/* We need to come up with a better way to allow and forbid syscalls */
+	if (unlikely(syslet_args_present(&current->indirect_params))) {
+		result = syslet_pre_indirect();
+		if (result == 0) {
+			result = call_indirect(&regs);
+			result = syslet_post_indirect(result);
+		}
+		goto out;
+	}
+
 	switch (INDIRECT_SYSCALL (&regs))
 	{
 #define INDSYSCALL(name) __NR_##name
@@ -24,16 +44,12 @@ asmlinkage long sys_indirect(struct indirect_registers __user *userregs,
 		break;
 
 	default:
-		return -EINVAL;
+		result = -EINVAL;
+		goto out;
 	}
 
-	if (paramslen > sizeof(union indirect_params))
-		return -EINVAL;
-
-	result = -EFAULT;
-	if (!copy_from_user(&current->indirect_params, userparams, paramslen))
-		result = call_indirect(&regs);
-
+	result = call_indirect(&regs);
+out:
 	memset(&current->indirect_params, '\0', paramslen);
 
 	return result;
diff --git a/kernel/sched.c b/kernel/sched.c
index 59ff6b1..27e799d 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -63,6 +63,7 @@
 #include <linux/reciprocal_div.h>
 #include <linux/unistd.h>
 #include <linux/pagemap.h>
+#include <linux/syslet.h>
 
 #include <asm/tlb.h>
 #include <asm/irq_regs.h>
@@ -3612,6 +3613,14 @@ asmlinkage void __sched schedule(void)
 	struct rq *rq;
 	int cpu;
 
+	prev = current;
+	if (unlikely(prev->syslet_ready)) {
+		if (prev->state && !(preempt_count() & PREEMPT_ACTIVE) &&
+			(!(prev->state & TASK_INTERRUPTIBLE) ||
+				!signal_pending(prev)))
+			syslet_schedule(prev);
+	}
+
 need_resched:
 	preempt_disable();
 	cpu = smp_processor_id();
diff --git a/kernel/syslet.c b/kernel/syslet.c
new file mode 100644
index 0000000..6fb2eb9
--- /dev/null
+++ b/kernel/syslet.c
@@ -0,0 +1,462 @@
+#include <linux/sched.h>
+#include <linux/wait.h>
+#include <linux/mutex.h>
+#include <linux/completion.h>
+#include <linux/err.h>
+#include <linux/jhash.h>
+#include <linux/list.h>
+#include <linux/syslet.h>
+
+#include <asm/uaccess.h>
+
+/*
+ * XXX todo:
+ *  - do we need all this '*cur = current' nonsense?
+ *  - try to prevent userspace from submitting too much.. lazy user ptr read?
+ *  - explain how to deal with waiting threads with stale data in current
+ *  - how does userspace tell that a syslet completion was lost?
+ *  	provide an -errno argument to the userspace return function?
+ */
+
+/*
+ * These structs are stored on the kernel stack of tasks which are waiting to
+ * return to userspace.  They are linked into their parent's list of syslet
+ * children stored in 'syslet_tasks' in the parent's task_struct.
+ */
+struct syslet_task_entry {
+	struct task_struct *task;
+	struct list_head item;
+};
+
+/*
+ * syslet_ring doesn't have any kernel-side storage.  Userspace allocates them
+ * in their address space and initializes their fields and then passes them to
+ * the kernel.
+ *
+ * These hashes provide the kernel-side storage for the wait queues which
+ * sys_syslet_ring_wait() uses and the mutex which completion uses to serialize
+ * the (possible blocking) ordered writes of the completion and kernel head
+ * index into the ring.
+ *
+ * We chose the bucket that supports a given ring by hashing a u32 that
+ * userspace sets in the ring.
+ */
+#define SYSLET_HASH_BITS (CONFIG_BASE_SMALL ? 4 : 8)
+#define SYSLET_HASH_NR (1 << SYSLET_HASH_BITS)
+#define SYSLET_HASH_MASK (SYSLET_HASH_NR - 1)
+static wait_queue_head_t syslet_waitqs[SYSLET_HASH_NR];
+static struct mutex syslet_muts[SYSLET_HASH_NR];
+
+static wait_queue_head_t *ring_waitqueue(struct syslet_ring __user *ring)
+{
+	u32 group;
+
+	if (get_user(group, &ring->wait_group))
+		return ERR_PTR(-EFAULT);
+	else
+		return &syslet_waitqs[jhash_1word(group, 0) & SYSLET_HASH_MASK];
+}
+
+static struct mutex *ring_mutex(struct syslet_ring __user *ring)
+{
+	u32 group;
+
+	if (get_user(group, (u32 __user *)&ring->wait_group))
+		return ERR_PTR(-EFAULT);
+	else
+		return &syslet_muts[jhash_1word(group, 0) & SYSLET_HASH_MASK];
+}
+
+/*
+ * This is called for new tasks and for child tasks which might copy
+ * task_struct from their parent.  So we clear the syslet indirect args,
+ * too, just to be clear.
+ */
+void syslet_init(struct task_struct *tsk)
+{
+	memset(&tsk->indirect_params.syslet, 0, sizeof(struct syslet_args));
+	spin_lock_init(&tsk->syslet_lock);
+	INIT_LIST_HEAD(&tsk->syslet_tasks);
+	tsk->syslet_ready = 0;
+	tsk->syslet_return = 0;
+	tsk->syslet_exit = 0;
+}
+
+static struct task_struct *first_syslet_task(struct task_struct *parent)
+{
+	struct syslet_task_entry *entry;
+
+	assert_spin_locked(&parent->syslet_lock);
+
+	if (!list_empty(&parent->syslet_tasks)) {
+		entry = list_first_entry(&parent->syslet_tasks,
+					 struct syslet_task_entry, item);
+		return entry->task;
+	} else
+		return NULL;
+}
+
+/*
+ * XXX it's not great to wake up potentially lots of tasks under the lock
+ */
+/*
+ * We ask all the waiting syslet tasks to exit before we ourselves will
+ * exit.  The tasks remove themselves from the list and wake our process
+ * with the lock held to be sure that we're still around when they wake us.
+ */
+void kill_syslet_tasks(struct task_struct *cur)
+{
+	struct syslet_task_entry *entry;
+
+	spin_lock(&cur->syslet_lock);
+
+	list_for_each_entry(entry, &cur->syslet_tasks, item)  {
+		entry->task->syslet_exit = 1;
+		wake_up_process(entry->task);
+	}
+
+	while (!list_empty(&cur->syslet_tasks)) {
+		set_task_state(cur, TASK_INTERRUPTIBLE);
+		if (list_empty(&cur->syslet_tasks))
+			break;
+		spin_unlock(&cur->syslet_lock);
+		schedule();
+		spin_lock(&cur->syslet_lock);
+	}
+	spin_unlock(&cur->syslet_lock);
+
+	set_task_state(cur, TASK_RUNNING);
+}
+
+/*
+ * This task is cloned off of a syslet parent as the parent calls
+ * syslet_pre_indirect() from sys_indirect().  That parent waits for us to
+ * complete a completion struct on their stack.
+ *
+ * This task then waits until its parent tells it to return to user space on
+ * its behalf when the parent gets in to schedule().
+ *
+ * The parent in schedule will set this tasks's ptregs frame to return to the
+ * sys_indirect() call site in user space.  Our -ESYSLETPENDING return code is
+ * given to userspace to indicate that the status of their system call
+ * will be delivered to the ring.
+ */
+struct syslet_task_args {
+	struct completion *comp;
+	struct task_struct *parent;
+};
+static long syslet_thread(void *data)
+{
+	struct syslet_task_args args;
+	struct task_struct *cur = current;
+	struct syslet_task_entry entry = {
+		.task = cur,
+		.item = LIST_HEAD_INIT(entry.item),
+	};
+
+	args = *(struct syslet_task_args *)data;
+
+	spin_lock(&args.parent->syslet_lock);
+	list_add_tail(&entry.item, &args.parent->syslet_tasks);
+	spin_unlock(&args.parent->syslet_lock);
+
+	complete(args.comp);
+
+	/* wait until the scheduler tells us to return to user space */
+	for (;;) {
+		set_task_state(cur, TASK_INTERRUPTIBLE);
+		if (cur->syslet_return || cur->syslet_exit ||
+		    signal_pending(cur))
+			break;
+		schedule();
+	}
+	set_task_state(cur, TASK_RUNNING);
+
+	spin_lock(&args.parent->syslet_lock);
+	list_del(&entry.item);
+	/* our parent won't exit until it tests the list under the lock */
+	if (list_empty(&args.parent->syslet_tasks))
+		wake_up_process(args.parent);
+	spin_unlock(&args.parent->syslet_lock);
+
+	/* just exit if we weren't asked to return to userspace */
+	if (!cur->syslet_return)
+		do_exit(0);
+
+	/* inform userspace that their call will complete in the ring */
+	return -ESYSLETPENDING;
+}
+
+static int create_new_syslet_task(struct task_struct *cur)
+{
+	struct syslet_task_args args;
+	struct completion comp;
+	int ret;
+
+	init_completion(&comp);
+	args.comp = &comp;
+	args.parent = cur;
+
+	ret = create_syslet_thread(syslet_thread, &args,
+				   CLONE_VM | CLONE_FS | CLONE_FILES |
+				   CLONE_SIGHAND | CLONE_THREAD |
+				   CLONE_SYSVSEM);
+	if (ret >= 0) {
+		wait_for_completion(&comp);
+		ret = 0;
+	}
+
+	return ret;
+}
+
+/*
+ * This is called by sys_indirect() when it sees that syslet args have
+ * been provided.  We validate the arguments and make sure that there is
+ * a task waiting.  If everything works out we tell the scheduler that it
+ * can call syslet_schedule() by setting syslet_ready.
+ */
+int syslet_pre_indirect(void)
+{
+	struct task_struct *cur = current;
+	struct syslet_ring __user *ring;
+	u32 elements;
+	int ret;
+
+	/* Not sure if returning -EINVAL on unsupported archs is right */
+	if (!syslet_frame_valid(&cur->indirect_params.syslet.frame)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ring = (struct syslet_ring __user __force *)(unsigned long)
+		cur->indirect_params.syslet.completion_ring_ptr;
+	if (get_user(elements, &ring->elements)) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	if (!is_power_of_2(elements)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/*
+	 * Racing to test this list outside the lock as the final task removes
+	 * itself is OK.  It should be very rare, and all it results in is
+	 * syslet_schedule() finding the list empty and letting the task block.
+	 */
+	if (list_empty(&cur->syslet_tasks)) {
+		ret = create_new_syslet_task(cur);
+		if (ret)
+			goto out;
+	} else
+		ret = 0;
+
+	cur->syslet_ready = 1;
+out:
+	return ret;
+}
+
+/*
+ * This is called by sys_indirect() after it has called the given system
+ * call handler.  If we didn't block then we just return the status of the
+ * system call to userspace.
+ *
+ * If we did bock, however, then userspace got a -ESYSLETPENDING long ago.
+ * We need to deliver the status of the system call into the syslet ring
+ * and then return to the function in userspace which the caller specified
+ * in the frame in the syslet args.  schedule() already set that up
+ * when we blocked.  All we have to do is return to userspace.
+ *
+ * The return code from this function is lost.  It could become the
+ * argument to the userspace return function which would let us tell
+ * userspace when we fail to copy the status into the ring.
+ */
+int syslet_post_indirect(int status)
+{
+	struct syslet_ring __user *ring;
+	struct syslet_completion comp;
+	struct task_struct *cur = current;
+	struct syslet_args *args = &cur->indirect_params.syslet;
+	wait_queue_head_t *waitq;
+	struct mutex *mutex;
+	u32 kidx;
+	u32 mask;
+	int ret;
+
+	/* we didn't block, just return the status to userspace */
+	if (cur->syslet_ready) {
+		cur->syslet_ready = 0;
+		return status;
+	}
+
+	ring = (struct syslet_ring __force __user *)(unsigned long)
+		args->completion_ring_ptr;
+
+	comp.status = status;
+	comp.caller_data = args->caller_data;
+
+	mutex = ring_mutex(ring);
+	if (IS_ERR(mutex))
+		return PTR_ERR(mutex);
+
+	waitq = ring_waitqueue(ring);
+	if (IS_ERR(waitq))
+		return PTR_ERR(waitq);
+
+	if (get_user(mask, &ring->elements))
+		return -EFAULT;
+
+	if (!is_power_of_2(mask))
+		return -EINVAL;
+	mask--;
+
+	mutex_lock(mutex);
+
+	ret = -EFAULT;
+	if (get_user(kidx, (u32 __user *)&ring->kernel_head))
+		goto out;
+
+	if (copy_to_user(&ring->comp[kidx & mask], &comp, sizeof(comp)))
+		goto out;
+
+	/*
+	 * Make sure that the completion is stored before the index which
+	 * refers to it.  Notice that this means that userspace has to worry
+	 * about issuing a read memory barrier after it reads the index.
+	 */
+	smp_wmb();
+
+	kidx++;
+	if (put_user(kidx, &ring->kernel_head))
+		ret = -EFAULT;
+	else
+		ret = 0;
+out:
+	mutex_unlock(mutex);
+	if (ret == 0 && waitqueue_active(waitq))
+		wake_up(waitq);
+	return ret;
+}
+
+/*
+ * We're called by the scheduler when it sees that a task is about to block and
+ * has syslet_ready.  Our job is to hand userspace's state off to a waiting
+ * task and tell it to return to userspace.  That tells userspace that the
+ * system call that we're executing blocked and will complete in the future.
+ *
+ * The indirect syslet arguemnts specify the userspace instruction and stack
+ * that the child should return to.
+ */
+void syslet_schedule(struct task_struct *cur)
+{
+	struct task_struct *child = NULL;
+
+	spin_lock(&cur->syslet_lock);
+
+	child = first_syslet_task(cur);
+	if (child) {
+		move_user_context(child, cur);
+		set_user_frame(cur, &cur->indirect_params.syslet.frame);
+		cur->syslet_ready = 0;
+		child->syslet_return = 1;
+	}
+
+	spin_unlock(&cur->syslet_lock);
+
+	if (child)
+		wake_up_process(child);
+}
+
+/*
+ * Userspace calls this when the ring is empty.  We return to userspace
+ * when the kernel head and user tail indexes are no longer equal, meaning
+ * that the kernel has stored a new completion.
+ *
+ * The ring is stored entirely in user space.  We don't have a system call
+ * which initializes kernel state to go along with the ring.
+ *
+ * So we have to read the kernel head index from userspace.  In the common
+ * case this will not fault or block and will be a very fast simple
+ * pointer dereference.
+ *
+ * Howerver, we need a way for the kernel completion path to wake us when
+ * there is a new event.  We hash a field of the ring into buckets of
+ * wait queues for this.
+ *
+ * This relies on aligned u32 reads and writes being atomic with regard
+ * to other reads and writes, which I sure hope is true on linux's
+ * architectures.  I'm crossing my fingers.
+ */
+asmlinkage long sys_syslet_ring_wait(struct syslet_ring __user *ring,
+				     unsigned long user_idx)
+{
+	wait_queue_head_t *waitq;
+	struct task_struct *cur = current;
+	DEFINE_WAIT(wait);
+	u32 kidx;
+	int ret;
+
+	/* XXX disallow async waiting */
+
+	waitq = ring_waitqueue(ring);
+	if (IS_ERR(waitq)) {
+		ret = PTR_ERR(waitq);
+		goto out;
+	}
+
+	/*
+	 * We have to be careful not to miss wake-ups by setting our
+	 * state before testing the condition.  Testing our condition includes
+	 * copying the index from userspace, which can modify our state which
+	 * can mask a wake-up setting our state.
+	 *
+	 * So we very carefully copy the index.  We use the blocking copy
+	 * to fault the index in and detect bad pointers.  We only proceed
+	 * with the test and sleeping if the non-blocking copy succeeds.
+	 *
+	 * In the common case the non-blocking copy will succeed and this
+	 * will be very fast indeed.
+	 */
+	for (;;) {
+		prepare_to_wait(waitq, &wait, TASK_INTERRUPTIBLE);
+		ret = __copy_from_user_inatomic(&kidx, &ring->kernel_head,
+						sizeof(u32));
+		if (ret) {
+			set_task_state(cur, TASK_RUNNING);
+			ret = copy_from_user(&kidx, &ring->kernel_head,
+					     sizeof(u32));
+			if (ret) {
+				ret = -EFAULT;
+				break;
+			}
+			continue;
+		}
+
+		if (kidx != user_idx)
+			break;
+		if (signal_pending(cur)) {
+			ret = -ERESTARTSYS;
+			break;
+		}
+
+		schedule();
+	}
+
+	finish_wait(waitq, &wait);
+out:
+	return ret;
+}
+
+static int __init syslet_module_init(void)
+{
+	unsigned long i;
+
+	for (i = 0; i < SYSLET_HASH_NR; i++) {
+		init_waitqueue_head(&syslet_waitqs[i]);
+		mutex_init(&syslet_muts[i]);
+	}
+
+	return 0;
+}
+module_init(syslet_module_init);
-- 
1.5.2.2

