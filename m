Return-Path: <linux-kernel-owner+w=401wt.eu-S1752308AbXDUQAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308AbXDUQAu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 12:00:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbXDUQAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 12:00:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51438 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752264AbXDUQAt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 12:00:49 -0400
Date: Sat, 21 Apr 2007 18:00:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Con Kolivas <kernel@kolivas.org>
Cc: Willy Tarreau <w@1wt.eu>, William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
Message-ID: <20070421160008.GA28783@elte.hu>
References: <20070420140457.GA14017@elte.hu> <20070421121235.GA2044@1wt.eu> <200704220155.20856.kernel@kolivas.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704220155.20856.kernel@kolivas.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Con Kolivas <kernel@kolivas.org> wrote:

> >   Feels even better, mouse movements are very smooth even under high 
> >   load. I noticed that X gets reniced to -19 with this scheduler. 
> >   I've not looked at the code yet but this looked suspicious to me. 
> >   I've reniced it to 0 and it did not change any behaviour. Still 
> >   very good.
> 
> Looks like this code does it:
> 
> +int sysctl_sched_privileged_nice_level __read_mostly = -19;

correct. Note that Willy reniced X back to 0 so it had no relevance on 
his test. Also note that i pointed this change out in the -v4 CFS 
announcement:

|| Changes since -v3:
||
||  - usability fix: automatic renicing of kernel threads such as 
||    keventd, OOM tasks and tasks doing privileged hardware access
||    (such as Xorg).

i've attached it below in a standalone form, feel free to put it into 
SD! :)

	Ingo

---
 arch/i386/kernel/ioport.c   |   13 ++++++++++---
 arch/x86_64/kernel/ioport.c |    8 ++++++--
 drivers/block/loop.c        |    5 ++++-
 include/linux/sched.h       |    7 +++++++
 kernel/sched.c              |   40 ++++++++++++++++++++++++++++++++++++++++
 kernel/workqueue.c          |    2 +-
 mm/oom_kill.c               |    4 +++-
 7 files changed, 71 insertions(+), 8 deletions(-)

Index: linux/arch/i386/kernel/ioport.c
===================================================================
--- linux.orig/arch/i386/kernel/ioport.c
+++ linux/arch/i386/kernel/ioport.c
@@ -64,9 +64,15 @@ asmlinkage long sys_ioperm(unsigned long
 
 	if ((from + num <= from) || (from + num > IO_BITMAP_BITS))
 		return -EINVAL;
-	if (turn_on && !capable(CAP_SYS_RAWIO))
-		return -EPERM;
-
+	if (turn_on) {
+		if (!capable(CAP_SYS_RAWIO))
+			return -EPERM;
+		/*
+		 * Task will be accessing hardware IO ports,
+		 * mark it as special with the scheduler too:
+		 */
+		sched_privileged_task(current);
+	}
 	/*
 	 * If it's the first ioperm() call in this thread's lifetime, set the
 	 * IO bitmap up. ioperm() is much less timing critical than clone(),
@@ -145,6 +151,7 @@ asmlinkage long sys_iopl(unsigned long u
 	if (level > old) {
 		if (!capable(CAP_SYS_RAWIO))
 			return -EPERM;
+		sched_privileged_task(current);
 	}
 	t->iopl = level << 12;
 	regs->eflags = (regs->eflags & ~X86_EFLAGS_IOPL) | t->iopl;
Index: linux/arch/x86_64/kernel/ioport.c
===================================================================
--- linux.orig/arch/x86_64/kernel/ioport.c
+++ linux/arch/x86_64/kernel/ioport.c
@@ -41,8 +41,11 @@ asmlinkage long sys_ioperm(unsigned long
 
 	if ((from + num <= from) || (from + num > IO_BITMAP_BITS))
 		return -EINVAL;
-	if (turn_on && !capable(CAP_SYS_RAWIO))
-		return -EPERM;
+	if (turn_on) {
+		if (!capable(CAP_SYS_RAWIO))
+			return -EPERM;
+		sched_privileged_task(current);
+	}
 
 	/*
 	 * If it's the first ioperm() call in this thread's lifetime, set the
@@ -113,6 +116,7 @@ asmlinkage long sys_iopl(unsigned int le
 	if (level > old) {
 		if (!capable(CAP_SYS_RAWIO))
 			return -EPERM;
+		sched_privileged_task(current);
 	}
 	regs->eflags = (regs->eflags &~ X86_EFLAGS_IOPL) | (level << 12);
 	return 0;
Index: linux/drivers/block/loop.c
===================================================================
--- linux.orig/drivers/block/loop.c
+++ linux/drivers/block/loop.c
@@ -588,7 +588,10 @@ static int loop_thread(void *data)
 	 */
 	current->flags |= PF_NOFREEZE;
 
-	set_user_nice(current, -20);
+	/*
+	 * The loop thread is important enough to be given a boost:
+	 */
+	sched_privileged_task(current);
 
 	while (!kthread_should_stop() || lo->lo_bio) {
 
Index: linux/include/linux/sched.h
===================================================================
--- linux.orig/include/linux/sched.h
+++ linux/include/linux/sched.h
@@ -1256,6 +1256,13 @@ static inline int rt_mutex_getprio(struc
 #endif
 
 extern void set_user_nice(struct task_struct *p, long nice);
+/*
+ * Task has special privileges, give it more CPU power:
+ */
+extern void sched_privileged_task(struct task_struct *p);
+
+extern int sysctl_sched_privileged_nice_level;
+
 extern int task_prio(const struct task_struct *p);
 extern int task_nice(const struct task_struct *p);
 extern int can_nice(const struct task_struct *p, const int nice);
Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -3251,6 +3251,46 @@ out_unlock:
 EXPORT_SYMBOL(set_user_nice);
 
 /*
+ * Nice level for privileged tasks. (can be set to 0 for this
+ * to be turned off)
+ */
+int sysctl_sched_privileged_nice_level __read_mostly = -19;
+
+static int __init privileged_nice_level_setup(char *str)
+{
+	sysctl_sched_privileged_nice_level = simple_strtoul(str, NULL, 0);
+	return 1;
+}
+__setup("privileged_nice_level=", privileged_nice_level_setup);
+
+/*
+ * Tasks with special privileges call this and gain extra nice
+ * levels:
+ */
+void sched_privileged_task(struct task_struct *p)
+{
+	long new_nice = sysctl_sched_privileged_nice_level;
+	long old_nice = TASK_NICE(p);
+
+	if (new_nice >= old_nice)
+		return;
+	/*
+	 * Setting the sysctl to 0 turns off the boosting:
+	 */
+	if (unlikely(!new_nice))
+		return;
+
+	if (new_nice < -20)
+		new_nice = -20;
+	else if (new_nice > 19)
+		new_nice = 19;
+
+	set_user_nice(p, new_nice);
+}
+
+EXPORT_SYMBOL(sched_privileged_task);
+
+/*
  * can_nice - check if a task can reduce its nice value
  * @p: task
  * @nice: nice value
Index: linux/kernel/workqueue.c
===================================================================
--- linux.orig/kernel/workqueue.c
+++ linux/kernel/workqueue.c
@@ -355,7 +355,7 @@ static int worker_thread(void *__cwq)
 	if (!cwq->freezeable)
 		current->flags |= PF_NOFREEZE;
 
-	set_user_nice(current, -5);
+	sched_privileged_task(current);
 
 	/* Block and flush all signals */
 	sigfillset(&blocked);
Index: linux/mm/oom_kill.c
===================================================================
--- linux.orig/mm/oom_kill.c
+++ linux/mm/oom_kill.c
@@ -291,7 +291,9 @@ static void __oom_kill_task(struct task_
 	 * all the memory it needs. That way it should be able to
 	 * exit() and clear out its resources quickly...
 	 */
-	p->time_slice = HZ;
+	if (p->policy == SCHED_NORMAL || p->policy == SCHED_BATCH)
+		sched_privileged_task(p);
+
 	set_tsk_thread_flag(p, TIF_MEMDIE);
 
 	force_sig(SIGKILL, p);
