Return-Path: <linux-kernel-owner+w=401wt.eu-S1030657AbXD1T0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030657AbXD1T0U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 15:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031176AbXD1T0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 15:26:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36239 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030657AbXD1T0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 15:26:15 -0400
Date: Sat, 28 Apr 2007 21:24:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: =?utf-8?B?Uy7Dh2HEn2xhcg==?= Onur <caglar@pardus.org.tr>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, Willy Tarreau <w@1wt.eu>,
       Gene Heskett <gene.heskett@gmail.com>, Mark Lord <lkml@rtr.ca>,
       Zach Carter <linux@zachcarter.com>, Kasper Sandberg <lkml@metanurb.dk>,
       buddabrod <buddabrod@gmail.com>, Srivatsa Vaddagiri <vatsa@in.ibm.com>
Subject: Re: [patch] CFS scheduler, -v7
Message-ID: <20070428192446.GA18822@elte.hu>
References: <20070428152539.GA21601@elte.hu> <200704282220.17689.caglar@pardus.org.tr>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="PNTmBPCT7hxwcZjr"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200704282220.17689.caglar@pardus.org.tr>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit


* S.Çağlar Onur <caglar@pardus.org.tr> wrote:

> If you want some more output/info etc. please just say, i have both v6 
> and v7 available.

could you try the auto-renice patch ontop of -v7:

  http://people.redhat.com/mingo/cfs-scheduler/sched-cfs-auto-renice.patch

does this make it behave like -v6?

	Ingo

--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="sched-cfs-auto-renice.patch"

---
 arch/i386/kernel/ioport.c   |   17 ++++++++++++++---
 arch/x86_64/kernel/ioport.c |   12 ++++++++++--
 drivers/block/loop.c        |    5 ++++-
 include/linux/sched.h       |    7 +++++++
 kernel/Kconfig.preempt      |   17 +++++++++++++++++
 kernel/sched.c              |   40 ++++++++++++++++++++++++++++++++++++++++
 kernel/workqueue.c          |    2 +-
 mm/oom_kill.c               |    4 +++-
 8 files changed, 96 insertions(+), 8 deletions(-)

Index: linux/arch/i386/kernel/ioport.c
===================================================================
--- linux.orig/arch/i386/kernel/ioport.c
+++ linux/arch/i386/kernel/ioport.c
@@ -64,9 +64,17 @@ asmlinkage long sys_ioperm(unsigned long
 
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
+#ifdef CONFIG_BOOST_X
+		sched_privileged_task(current);
+#endif
+	}
 	/*
 	 * If it's the first ioperm() call in this thread's lifetime, set the
 	 * IO bitmap up. ioperm() is much less timing critical than clone(),
@@ -145,6 +153,9 @@ asmlinkage long sys_iopl(unsigned long u
 	if (level > old) {
 		if (!capable(CAP_SYS_RAWIO))
 			return -EPERM;
+#ifdef CONFIG_BOOST_X
+		sched_privileged_task(current);
+#endif
 	}
 	t->iopl = level << 12;
 	regs->eflags = (regs->eflags & ~X86_EFLAGS_IOPL) | t->iopl;
Index: linux/arch/x86_64/kernel/ioport.c
===================================================================
--- linux.orig/arch/x86_64/kernel/ioport.c
+++ linux/arch/x86_64/kernel/ioport.c
@@ -41,8 +41,13 @@ asmlinkage long sys_ioperm(unsigned long
 
 	if ((from + num <= from) || (from + num > IO_BITMAP_BITS))
 		return -EINVAL;
-	if (turn_on && !capable(CAP_SYS_RAWIO))
-		return -EPERM;
+	if (turn_on) {
+		if (!capable(CAP_SYS_RAWIO))
+			return -EPERM;
+#ifdef CONFIG_BOOST_X
+		sched_privileged_task(current);
+#endif
+	}
 
 	/*
 	 * If it's the first ioperm() call in this thread's lifetime, set the
@@ -113,6 +118,9 @@ asmlinkage long sys_iopl(unsigned int le
 	if (level > old) {
 		if (!capable(CAP_SYS_RAWIO))
 			return -EPERM;
+#ifdef CONFIG_BOOST_X
+		sched_privileged_task(current);
+#endif
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
@@ -1268,6 +1268,13 @@ static inline int rt_mutex_getprio(struc
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
Index: linux/kernel/Kconfig.preempt
===================================================================
--- linux.orig/kernel/Kconfig.preempt
+++ linux/kernel/Kconfig.preempt
@@ -63,3 +63,20 @@ config PREEMPT_BKL
 	  Say Y here if you are building a kernel for a desktop system.
 	  Say N if you are unsure.
 
+config BOOST_X
+	bool "Boost X"
+	default y
+	help
+	  This option instructs the kernel to guarantee more CPU time to
+	  X than to other tasks, which is useful if you want to have a
+	  faster desktop even under high system load.
+
+	  This option works by automatically boosting X's priority via
+	  renicing it to -10. NOTE: CFS does not suffer from
+	  "overscheduling" problems when X is reniced to -10, so if this
+	  is a predominantly desktop box it makes sense to select this
+	  option.
+
+	  Say Y here if you are building a kernel for a desktop system.
+	  Say N if you want X to be treated as a normal task.
+
Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -3323,6 +3323,46 @@ out_unlock:
 EXPORT_SYMBOL(set_user_nice);
 
 /*
+ * Nice level for privileged tasks. (can be set to 0 for this
+ * to be turned off)
+ */
+int sysctl_sched_privileged_nice_level __read_mostly = -10;
+
+static int __init privileged_nice_level_setup(char *str)
+{
+	sysctl_sched_privileged_nice_level = simple_strtol(str, NULL, 0);
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
@@ -293,7 +293,9 @@ static void __oom_kill_task(struct task_
 	 * all the memory it needs. That way it should be able to
 	 * exit() and clear out its resources quickly...
 	 */
-	p->time_slice = HZ;
+	if (p->policy == SCHED_NORMAL || p->policy == SCHED_BATCH)
+		sched_privileged_task(p);
+
 	set_tsk_thread_flag(p, TIF_MEMDIE);
 
 	force_sig(SIGKILL, p);

--PNTmBPCT7hxwcZjr--
