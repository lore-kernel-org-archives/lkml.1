Return-Path: <linux-kernel-owner+w=401wt.eu-S1759991AbYHAVVO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759991AbYHAVVO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 17:21:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761252AbYHAVLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 17:11:50 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:53016 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761248AbYHAVLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 17:11:48 -0400
Date: Fri, 1 Aug 2008 14:11:46 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-rt-users@vger.kernel.org
Cc: rostedt@goodmis.org, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       mingo@elte.hu
Subject: [PATCH -rt] apply rcu_process_callbacks() changes from mainline
Message-ID: <20080801211146.GG14851@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On its way to mainline, rcu_process_callbacks() became a static
function and the unused function rcu_advance_callbacks() was
removed.  The attached patch adjusts -rt to better match mainline.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 include/linux/rcuclassic.h |    3 ---
 include/linux/rcupreempt.h |    2 --
 kernel/rcuclassic.c        |   13 +------------
 kernel/rcupreempt.c        |    2 +-
 4 files changed, 2 insertions(+), 18 deletions(-)

diff -urpNa -X dontdiff linux-2.6.26-rt1/include/linux/rcuclassic.h linux-2.6.26-rt1-rhf/include/linux/rcuclassic.h
--- linux-2.6.26-rt1/include/linux/rcuclassic.h	2008-07-30 05:42:42.000000000 -0700
+++ linux-2.6.26-rt1-rhf/include/linux/rcuclassic.h	2008-07-30 10:30:31.000000000 -0700
@@ -162,7 +162,4 @@ extern long rcu_batches_completed_bh(voi
 #define rcu_exit_nohz()		do { } while (0)
 #define rcu_preempt_boost_init() do { } while (0)
 
-struct softirq_action;
-extern void rcu_process_callbacks(struct softirq_action *unused);
-
 #endif /* __LINUX_RCUCLASSIC_H */
diff -urpNa -X dontdiff linux-2.6.26-rt1/include/linux/rcupreempt.h linux-2.6.26-rt1-rhf/include/linux/rcupreempt.h
--- linux-2.6.26-rt1/include/linux/rcupreempt.h	2008-07-30 05:42:41.000000000 -0700
+++ linux-2.6.26-rt1-rhf/include/linux/rcupreempt.h	2008-07-30 10:31:44.000000000 -0700
@@ -146,6 +146,4 @@ static inline void rcu_exit_nohz(void)
 #define rcu_exit_nohz()		do { } while (0)
 #endif /* CONFIG_NO_HZ */
 
-extern void rcu_process_callbacks(struct softirq_action *unused);
-
 #endif /* __LINUX_RCUPREEMPT_H */
diff -urpNa -X dontdiff linux-2.6.26-rt1/kernel/rcuclassic.c linux-2.6.26-rt1-rhf/kernel/rcuclassic.c
--- linux-2.6.26-rt1/kernel/rcuclassic.c	2008-07-30 05:42:42.000000000 -0700
+++ linux-2.6.26-rt1-rhf/kernel/rcuclassic.c	2008-07-30 10:54:35.000000000 -0700
@@ -458,7 +458,7 @@ static void __rcu_process_callbacks(stru
 		rcu_do_batch(rdp);
 }
 
-void rcu_process_callbacks(struct softirq_action *unused)
+static void rcu_process_callbacks(struct softirq_action *unused)
 {
 	__rcu_process_callbacks(&rcu_ctrlblk, &__get_cpu_var(rcu_data));
 	__rcu_process_callbacks(&rcu_bh_ctrlblk, &__get_cpu_var(rcu_bh_data));
@@ -513,17 +513,6 @@ int rcu_needs_cpu(int cpu)
 	return (!!rdp->curlist || !!rdp_bh->curlist || rcu_pending(cpu));
 }
 
-void rcu_advance_callbacks(int cpu, int user)
-{
-	if (user ||
-	    (idle_cpu(cpu) && !in_softirq() &&
-				hardirq_count() <= (1 << HARDIRQ_SHIFT))) {
-		rcu_qsctr_inc(cpu);
-		rcu_bh_qsctr_inc(cpu);
-	} else if (!in_softirq())
-		rcu_bh_qsctr_inc(cpu);
-}
-
 void rcu_check_callbacks(int cpu, int user)
 {
 	if (user ||
diff -urpNa -X dontdiff linux-2.6.26-rt1/kernel/rcupreempt.c linux-2.6.26-rt1-rhf/kernel/rcupreempt.c
--- linux-2.6.26-rt1/kernel/rcupreempt.c	2008-07-30 05:42:42.000000000 -0700
+++ linux-2.6.26-rt1-rhf/kernel/rcupreempt.c	2008-07-30 11:02:30.000000000 -0700
@@ -944,7 +944,7 @@ void __cpuinit rcu_online_cpu(int cpu)
 	spin_unlock_irqrestore(&rcu_ctrlblk.fliplock, flags);
 }
 
-void rcu_process_callbacks(struct softirq_action *unused)
+static void rcu_process_callbacks(struct softirq_action *unused)
 {
 	unsigned long flags;
 	struct rcu_head *next, *list;
