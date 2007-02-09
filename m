Return-Path: <linux-kernel-owner+w=401wt.eu-S1752465AbXBIWd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465AbXBIWd5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 17:33:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752466AbXBIWd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 17:33:57 -0500
Received: from smtp.osdl.org ([65.172.181.24]:51573 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752465AbXBIWd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 17:33:56 -0500
Date: Fri, 9 Feb 2007 14:33:01 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Zach Brown <zach.brown@oracle.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0 of 4] Generic AIO by scheduling stacks
In-Reply-To: <patchbomb.1170193181@tetsuo.zabbo.net>
Message-ID: <Pine.LNX.4.64.0702091419470.8424@woody.linux-foundation.org>
References: <patchbomb.1170193181@tetsuo.zabbo.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Ok, here's another entry in this discussion.

This is a *really* small patch. Yes, it adds 174 lines, and yes it's 
actually x86 (32-bit) only, but about half of it is totally generic, and 
*all* of it is almost ludicrously simple.

There's no new assembly language. The one-liner addition to 
"syscall_table.S" is just adding the system call entry stub. It's all in 
C, and none of it is even hard to understand.

It's architecture-specific, because different architectures do the whole 
"fork()" entrypath differently, and this is basically a "delayed fork()", 
not really an AIO thing at all.

So what this does, very simply is:

 - on system call entry just save away the pt_regs pointer needed to do a 
   fork (on some architectures, this means that you need to use a longer 
   system call entry that saves off all registers - on x86 even that isn't 
   an issue)

 - save that away as a magic cookie in the task structure

 - do the system call

 - IF the system call blocks, we call the architecture-specific 
   "schedule_async()" function before we even get any scheduler locks, and 
   it can just do a fork() at that time, and let the *child* return to the 
   original user space. The process that already started doing the system 
   call will just continue to do the system call.

 - when the system call is done, we check to see if it was done totally 
   synchronously or not. If we ended up doing the clone(), we just exit 
   the new thread.

Now, I agree that this is a bit ugly in some of the details: in 
particular, it means that if the system call blocks, we will literally 
return as a *different* thread to user space. If you care, you shouldn't 
use this interface, or come up with some way to make it work nicely (doing 
it this way meant that I could just re-use all the clone/fork code as-is).

Also, it actually does take the hit of creating a full new thread. We 
could optimize that a bit. But at least the cached case has basically 
*zero* overhead: we literally end up doing just a few extra CPU 
instructions to copy the arguments around etc, but no locked cycles, no 
memory allocations, no *nothing*.

So I actually like this, because it means that while we slow down real IO, 
we don't slow down the cached cases at all.

Final warning: I didn't do any cancel/wait crud. It doesn't even return 
the thread ID as it is now. And I only hooked up "stat64()" as an exmple. 
So this really is just a total toy. But it's kind of funny how simple it 
was, once I started thinking about how I could do this in some clever way.

I even added comments, so a lot of the few new added lines aren't even 
code!

		Linus

---

diff --git a/arch/i386/kernel/process.c b/arch/i386/kernel/process.c
index c641056..0909724 100644
--- a/arch/i386/kernel/process.c
+++ b/arch/i386/kernel/process.c
@@ -698,6 +698,71 @@ struct task_struct fastcall * __switch_to(struct task_struct *prev_p, struct tas
 	return prev_p;
 }
 
+/*
+ * This gets called when an async event causes a schedule.
+ * We should try to
+ *
+ *  (a) create a new thread
+ *  (b) within that new thread, return to the original
+ *      user mode call-site.
+ *  (c) clear the async event flag, since it is now no
+ *      longer relevant.
+ *
+ * If anything fails (a resource issue etc), we just do
+ * the async system call as a normal synchronous event!
+ */
+#define CLONE_ALL (CLONE_VM | CLONE_FS | CLONE_FILES | CLONE_SIGHAND | CLONE_PARENT | CLONE_THREAD)
+#define FAILED_CLONE ((struct pt_regs *)1)
+void schedule_async(void)
+{
+	struct pt_regs *regs = current->async_cookie;
+	int retval;
+
+	if (regs == FAILED_CLONE)
+		return;
+
+	current->async_cookie = NULL;
+	/*
+	 * This is magic. The child will return through "ret_from_fork()" to
+	 * where the original thread started it all. It's not the same thread
+	 * any more, and we don't much care. The "real thread" has now become
+	 * the async worker thread, and will exit once the async work is done.
+	 */
+	retval = do_fork(CLONE_ALL, regs->esp, regs, 0, NULL, NULL);
+
+	/*
+	 * If it failed, we could just restore the async_cookie and try again
+	 * on the next scheduling event. 
+	 *
+	 * But it's just better to set it to some magic value to indicate
+	 * "do not try this again". If it failed once, we shouldn't waste 
+	 * time trying it over and over again.
+	 *
+	 * Any non-NULL value will tell "do_async()" at the end that it was
+	 * done "synchronously".
+	 */
+	if (retval < 0)
+		current->async_cookie = FAILED_CLONE;
+}
+
+asmlinkage int sys_async(struct pt_regs regs)
+{
+	void *async_cookie;
+	unsigned long syscall, flags;
+	int __user *status;
+	unsigned long __user *user_args;
+
+	/* Pick out the do_async() arguments.. */
+	async_cookie = &regs;
+	syscall = regs.ebx;
+	flags = regs.ecx;
+	status = (int __user *) regs.edx;
+	user_args = (unsigned long __user *) regs.esi;
+
+	/* ..and call the generic helper routine */
+	return do_async(async_cookie, syscall, flags, status, user_args);
+}
+
 asmlinkage int sys_fork(struct pt_regs regs)
 {
 	return do_fork(SIGCHLD, regs.esp, &regs, 0, NULL, NULL);
diff --git a/arch/i386/kernel/syscall_table.S b/arch/i386/kernel/syscall_table.S
index 2697e92..647193c 100644
--- a/arch/i386/kernel/syscall_table.S
+++ b/arch/i386/kernel/syscall_table.S
@@ -319,3 +319,4 @@ ENTRY(sys_call_table)
 	.long sys_move_pages
 	.long sys_getcpu
 	.long sys_epoll_pwait
+	.long sys_async			/* 320 */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4463735..e14b11b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -844,6 +844,13 @@ struct task_struct {
 
 	struct mm_struct *mm, *active_mm;
 
+	/*
+	 * The scheduler uses this to determine if the current call is a
+	 * standalone thread or just an async system call that hasn't
+	 * had its real thread created yet.
+	 */
+	void *async_cookie;
+
 /* task state */
 	struct linux_binfmt *binfmt;
 	long exit_state;
@@ -1649,6 +1656,12 @@ extern int sched_create_sysfs_power_savings_entries(struct sysdev_class *cls);
 
 extern void normalize_rt_tasks(void);
 
+/* Async system call support */
+extern long do_async(void *async_cookie, unsigned int syscall, unsigned long flags,
+	 int __user *status, unsigned long __user *user_args);
+extern void schedule_async(void);
+                                        
+
 #endif /* __KERNEL__ */
 
 #endif
diff --git a/kernel/Makefile b/kernel/Makefile
index 14f4d45..13bda9f 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -8,7 +8,7 @@ obj-y     = sched.o fork.o exec_domain.o panic.o printk.o profile.o \
 	    signal.o sys.o kmod.o workqueue.o pid.o \
 	    rcupdate.o extable.o params.o posix-timers.o \
 	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
-	    hrtimer.o rwsem.o latency.o nsproxy.o srcu.o
+	    hrtimer.o rwsem.o latency.o nsproxy.o srcu.o async.o
 
 obj-$(CONFIG_STACKTRACE) += stacktrace.o
 obj-y += time/
diff --git a/kernel/async.c b/kernel/async.c
new file mode 100644
index 0000000..29b14f3
--- /dev/null
+++ b/kernel/async.c
@@ -0,0 +1,71 @@
+/*
+ * kernel/async.c
+ *
+ * Create a light-weight kernel-level thread.
+ */
+#include <linux/sched.h>
+#include <linux/syscalls.h>
+
+#include <asm/uaccess.h>
+
+/* Fake "generic" system call pointer type */
+typedef asmlinkage long (*master_syscall_t)(unsigned long arg, ...);
+
+#define ASYNC_SYSCALL(syscall, param) \
+	{ (master_syscall_t) (syscall), (param) }
+
+static struct async_call {
+	master_syscall_t fn;
+	int args;
+} call_descriptor[] = {
+	ASYNC_SYSCALL(sys_stat64, 2),
+};
+
+long do_async(
+	void *async_cookie,
+	unsigned int syscall,
+	unsigned long flags,
+	int __user *status,
+	unsigned long __user *user_args)
+{
+	int ret, size;
+	struct async_call *desc;
+	unsigned long args[6];
+
+	if (syscall >= ARRAY_SIZE(call_descriptor))
+		return -EINVAL;
+
+	desc = call_descriptor + syscall;
+	if (!desc->fn)
+		return -EINVAL;
+
+	if (desc->args > ARRAY_SIZE(args))
+		return -EINVAL;
+
+	size = sizeof(unsigned long)*desc->args;
+	if (copy_from_user(args, user_args, size))
+		return -EFAULT;
+
+	/* We don't nest async calls! */
+	if (current->async_cookie)
+		return -EINVAL;
+	current->async_cookie = async_cookie;
+
+	ret = desc->fn(args[0], args[1], args[2], args[3], args[4], args[5]);
+	put_user(ret, status);
+
+	/*
+	 * Did we end up doing part of the work in a separate thread?
+	 *
+	 * If so, the async thread-creation already returned in the
+	 * origial parent, and cleared out the async_cookie. We're
+	 * now just in the worker thread, and should just exit. Our
+	 * job here is done.
+	 */
+	if (!current->async_cookie)
+		do_exit(0);
+
+	/* We did it synchronously - return 0 */
+	current->async_cookie = 0;
+	return 0;
+}
diff --git a/kernel/fork.c b/kernel/fork.c
index d57118d..6f38c46 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1413,6 +1413,18 @@ long do_fork(unsigned long clone_flags,
 	return nr;
 }
 
+/*
+ * Architectures that don't have async support get this
+ * dummy async thread scheduler callback.
+ *
+ * They had better not set task->async_cookie in the
+ * first place, so this should never get called!
+ */
+void __attribute__ ((weak)) schedule_async(void)
+{
+	BUG();
+}
+
 #ifndef ARCH_MIN_MMSTRUCT_ALIGN
 #define ARCH_MIN_MMSTRUCT_ALIGN 0
 #endif
diff --git a/kernel/sched.c b/kernel/sched.c
index cca93cc..cc73dee 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3436,6 +3436,17 @@ asmlinkage void __sched schedule(void)
 	}
 	profile_hit(SCHED_PROFILING, __builtin_return_address(0));
 
+	/* Are we running within an async system call? */
+	if (unlikely(current->async_cookie)) {
+		/*
+		 * If so, we now try to start a new thread for it, but
+		 * not for a preemption event or a scheduler timeout
+		 * triggering!
+		 */
+		if (!(preempt_count() & PREEMPT_ACTIVE) && current->state != TASK_RUNNING)
+			schedule_async();
+	}
+
 need_resched:
 	preempt_disable();
 	prev = current;
