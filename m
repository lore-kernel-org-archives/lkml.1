Return-Path: <linux-kernel-owner+w=401wt.eu-S1755004AbYA3DTH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004AbYA3DTH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 22:19:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753322AbYA3DSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 22:18:49 -0500
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:60202 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745AbYA3DSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 22:18:47 -0500
Message-Id: <20080130031840.178601437@goodmis.org>
References: <20080130031521.258552785@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 29 Jan 2008 22:15:22 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Jan Kiszka <jan.kiszka@siemens.com>, John Stultz <johnstul@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 01/22 -v7] printk - dont wakeup klogd with interrupts disabled
Content-Disposition: inline; filename=printk-no-klogd-on-rq-locked.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ This patch is added to the series since the wakeup timings trace
  may lockup without it. ]

I thought that one could place a printk anywhere without worrying.
But it seems that it is not wise to place a printk where the runqueue
lock is held.

I just spent two hours debugging why some of my code was locking up,
to find that the lockup was caused by some debugging printk's that
I had in the scheduler.  The printk's were only in rare paths so
they shouldn't be too much of a problem, but after I hit the printk
the system locked up.

Thinking that it was locking up on my code I went looking down the
wrong path. I finally found (after examining an NMI dump) that
the lockup happened because printk was trying to wakeup the klogd
daemon, which caused a deadlock when the try_to_wakeup code tries
to grab the runqueue lock.

This patch adds a runqueue_is_locked interface in sched.c for other
files to see if the current runqueue lock is held. This is used
in printk to determine whether it is safe or not to wakeup the klogd.

And with this patch, my code ran fine ;-)

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/sched.h |    2 ++
 kernel/printk.c       |   14 ++++++++++----
 kernel/sched.c        |   18 ++++++++++++++++++
 3 files changed, 30 insertions(+), 4 deletions(-)

Index: linux-mcount.git/kernel/printk.c
===================================================================
--- linux-mcount.git.orig/kernel/printk.c	2008-01-29 17:02:10.000000000 -0500
+++ linux-mcount.git/kernel/printk.c	2008-01-29 17:25:40.000000000 -0500
@@ -590,9 +590,11 @@ static int have_callable_console(void)
  * @fmt: format string
  *
  * This is printk().  It can be called from any context.  We want it to work.
- * Be aware of the fact that if oops_in_progress is not set, we might try to
- * wake klogd up which could deadlock on runqueue lock if printk() is called
- * from scheduler code.
+ *
+ * Note: if printk() is called with the runqueue lock held, it will not wake
+ * up the klogd. This is to avoid a deadlock from calling printk() in schedule
+ * with the runqueue lock held and having the wake_up grab the runqueue lock
+ * as well.
  *
  * We try to grab the console_sem.  If we succeed, it's easy - we log the output and
  * call the console drivers.  If we fail to get the semaphore we place the output
@@ -1001,7 +1003,11 @@ void release_console_sem(void)
 	console_locked = 0;
 	up(&console_sem);
 	spin_unlock_irqrestore(&logbuf_lock, flags);
-	if (wake_klogd)
+	/*
+	 * If we try to wake up klogd while printing with the runqueue lock
+	 * held, this will deadlock.
+	 */
+	if (wake_klogd && !runqueue_is_locked())
 		wake_up_klogd();
 }
 EXPORT_SYMBOL(release_console_sem);
Index: linux-mcount.git/include/linux/sched.h
===================================================================
--- linux-mcount.git.orig/include/linux/sched.h	2008-01-29 17:02:10.000000000 -0500
+++ linux-mcount.git/include/linux/sched.h	2008-01-29 17:25:40.000000000 -0500
@@ -222,6 +222,8 @@ extern void sched_init_smp(void);
 extern void init_idle(struct task_struct *idle, int cpu);
 extern void init_idle_bootup_task(struct task_struct *idle);
 
+extern int runqueue_is_locked(void);
+
 extern cpumask_t nohz_cpu_mask;
 #if defined(CONFIG_SMP) && defined(CONFIG_NO_HZ)
 extern int select_nohz_load_balancer(int cpu);
Index: linux-mcount.git/kernel/sched.c
===================================================================
--- linux-mcount.git.orig/kernel/sched.c	2008-01-29 16:59:15.000000000 -0500
+++ linux-mcount.git/kernel/sched.c	2008-01-29 17:25:40.000000000 -0500
@@ -621,6 +621,24 @@ unsigned long rt_needs_cpu(int cpu)
 # define const_debug static const
 #endif
 
+/**
+ * runqueue_is_locked
+ *
+ * Returns true if the current cpu runqueue is locked.
+ * This interface allows printk to be called with the runqueue lock
+ * held and know whether or not it is OK to wake up the klogd.
+ */
+int runqueue_is_locked(void)
+{
+	int cpu = get_cpu();
+	struct rq *rq = cpu_rq(cpu);
+	int ret;
+
+	ret = spin_is_locked(&rq->lock);
+	put_cpu();
+	return ret;
+}
+
 /*
  * Debugging: various feature bits
  */

-- 
