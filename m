Return-Path: <linux-kernel-owner+w=401wt.eu-S1752024AbXBDEXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024AbXBDEXA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 23:23:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752035AbXBDEXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 23:23:00 -0500
Received: from pool-71-111-65-226.ptldor.dsl-w.verizon.net ([71.111.65.226]:27680
	"EHLO IBM-8EC8B5596CA.beaverton.ibm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752024AbXBDEW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 23:22:59 -0500
Date: Sat, 3 Feb 2007 20:22:33 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: nigel@nigel.suspend2.net, mingo@elte.hu, tglx@linutronix.de,
       dipankar@in.ibm.com, tytso@us.ibm.com, dvhltc@us.ibm.com,
       oleg@tv-sign.ru, twoerner.k@gmail.com, josh@freedesktop.org,
       billh@gnuppy.monkey.org, nielsen.esben@googlemail.com, corbet@lwn.net
Subject: [PATCH -rt] Make RCU-boost and rcutorture threads freezable
Message-ID: <20070204042233.GA6645@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes PF_NOFREEZE from the rcutorture and RCU-boost threads,
adding try_to_freeze() calls as required.  Passes the usual tests, but
I don't have a good freeze test handy as yet.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 rcupreempt.c |    4 +++-
 rcutorture.c |    9 +++++----
 2 files changed, 8 insertions(+), 5 deletions(-)

diff -urpNa -X dontdiff linux-2.6.20-rc7-rt3/kernel/rcupreempt.c linux-2.6.20-rc7-rt3-freezefix/kernel/rcupreempt.c
--- linux-2.6.20-rc7-rt3/kernel/rcupreempt.c	2007-02-02 11:33:50.000000000 -0800
+++ linux-2.6.20-rc7-rt3-freezefix/kernel/rcupreempt.c	2007-02-02 13:48:09.000000000 -0800
@@ -50,6 +50,7 @@
 #include <linux/cpumask.h>
 #include <linux/rcupreempt_trace.h>
 #include <linux/kthread.h>
+#include <linux/freezer.h>
 
 /*
  * PREEMPT_RCU data structures.
@@ -385,6 +386,7 @@ static void rcu_boost_one_reader_list(st
 		 */
 
 		spin_unlock_irqrestore(&rbdp->rbs_mutex, oldirq);
+		try_to_freeze();
 		schedule_timeout_uninterruptible(1);
 		spin_lock_irqsave(&rbdp->rbs_mutex, oldirq);
 
@@ -432,7 +434,6 @@ static int rcu_booster(void *arg)
 
 	sp.sched_priority = PREEMPT_RCU_BOOSTER_PRIO;
 	sched_setscheduler(current, SCHED_RR, &sp);
-	current->flags |= PF_NOFREEZE;
 
 	do {
 
@@ -465,6 +466,7 @@ static int rcu_booster(void *arg)
 		 * adjust, or eliminate in case of OOM.
 		 */
 
+		try_to_freeze();
 		schedule_timeout_uninterruptible(HZ / 100);
 
 		/* Print stats if enough time has passed. */
diff -urpNa -X dontdiff linux-2.6.20-rc7-rt3/kernel/rcutorture.c linux-2.6.20-rc7-rt3-freezefix/kernel/rcutorture.c
--- linux-2.6.20-rc7-rt3/kernel/rcutorture.c	2007-02-02 11:33:50.000000000 -0800
+++ linux-2.6.20-rc7-rt3-freezefix/kernel/rcutorture.c	2007-02-03 17:30:43.000000000 -0800
@@ -46,6 +46,7 @@
 #include <linux/byteorder/swabb.h>
 #include <linux/stat.h>
 #include <linux/srcu.h>
+#include <linux/freezer.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Paul E. McKenney <paulmck@us.ibm.com> and "
@@ -278,7 +279,6 @@ static int rcu_torture_preempt(void *arg
 	if (err != 0)
 		printk(KERN_ALERT "rcu_torture_preempt() priority err: %d\n",
 		       err);
-	current->flags |= PF_NOFREEZE;
 
 	do {
 		completedstart = rcu_torture_completed();
@@ -288,6 +288,7 @@ static int rcu_torture_preempt(void *arg
 			cond_resched();
 		if (rcu_torture_completed() == completedstart)
 			rcu_torture_preempt_errors++;
+		try_to_freeze();
 		schedule_timeout_interruptible(HZ);
 	} while (!kthread_should_stop());
 	return 0;
@@ -580,7 +581,6 @@ rcu_torture_writer(void *arg)
 
 	VERBOSE_PRINTK_STRING("rcu_torture_writer task started");
 	set_user_nice(current, 19);
-	current->flags |= PF_NOFREEZE;
 
 	do {
 		schedule_timeout_uninterruptible(1);
@@ -602,6 +602,7 @@ rcu_torture_writer(void *arg)
 		}
 		rcu_torture_current_version++;
 		oldbatch = cur_ops->completed();
+		try_to_freeze();
 	} while (!kthread_should_stop() && !fullstop);
 	VERBOSE_PRINTK_STRING("rcu_torture_writer task stopping");
 	while (!kthread_should_stop())
@@ -620,12 +621,12 @@ rcu_torture_fakewriter(void *arg)
 
 	VERBOSE_PRINTK_STRING("rcu_torture_fakewriter task started");
 	set_user_nice(current, 19);
-	current->flags |= PF_NOFREEZE;
 
 	do {
 		schedule_timeout_uninterruptible(1 + rcu_random(&rand)%10);
 		udelay(rcu_random(&rand) & 0x3ff);
 		cur_ops->sync();
+		try_to_freeze();
 	} while (!kthread_should_stop() && !fullstop);
 
 	VERBOSE_PRINTK_STRING("rcu_torture_fakewriter task stopping");
@@ -651,7 +652,6 @@ rcu_torture_reader(void *arg)
 
 	VERBOSE_PRINTK_STRING("rcu_torture_reader task started");
 	set_user_nice(current, 19);
-	current->flags |= PF_NOFREEZE;
 
 	do {
 		idx = cur_ops->readlock();
@@ -681,6 +681,7 @@ rcu_torture_reader(void *arg)
 		++__get_cpu_var(rcu_torture_batch)[completed];
 		preempt_enable();
 		cur_ops->readunlock(idx);
+		try_to_freeze();
 		schedule();
 	} while (!kthread_should_stop() && !fullstop);
 	VERBOSE_PRINTK_STRING("rcu_torture_reader task stopping");
