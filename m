Return-Path: <linux-kernel-owner+w=401wt.eu-S1753034AbZKJRyH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034AbZKJRyH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 12:54:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751559AbZKJRyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 12:54:06 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48524 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751839AbZKJRyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 12:54:04 -0500
Date: Tue, 10 Nov 2009 18:53:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] core kernel fixes
Message-ID: <20091110175356.GA7123@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus

 Thanks,

	Ingo

------------------>
Paul E. McKenney (1):
      rcu: Fix long-grace-period race between forcing and initialization

Soeren Sandmann (2):
      highmem: Fix race in debug_kmap_atomic() which could cause warn_count to underflow
      highmem: Fix debug_kmap_atomic() to also handle KM_IRQ_PTE, KM_NMI, and KM_NMI_PTE

Thomas Gleixner (1):
      uids: Prevent tear down race


 kernel/rcutree.c |   16 +++++++++++-----
 kernel/rcutree.h |    7 ++++---
 kernel/user.c    |    2 +-
 mm/highmem.c     |   17 ++++++++++++-----
 4 files changed, 28 insertions(+), 14 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 0536125..f3077c0 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -59,7 +59,7 @@
 		NUM_RCU_LVL_2, \
 		NUM_RCU_LVL_3, /* == MAX_RCU_LVLS */ \
 	}, \
-	.signaled = RCU_SIGNAL_INIT, \
+	.signaled = RCU_GP_IDLE, \
 	.gpnum = -300, \
 	.completed = -300, \
 	.onofflock = __SPIN_LOCK_UNLOCKED(&name.onofflock), \
@@ -657,14 +657,17 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 	 * irqs disabled.
 	 */
 	rcu_for_each_node_breadth_first(rsp, rnp) {
-		spin_lock(&rnp->lock);	/* irqs already disabled. */
+		spin_lock(&rnp->lock);		/* irqs already disabled. */
 		rcu_preempt_check_blocked_tasks(rnp);
 		rnp->qsmask = rnp->qsmaskinit;
 		rnp->gpnum = rsp->gpnum;
-		spin_unlock(&rnp->lock);	/* irqs already disabled. */
+		spin_unlock(&rnp->lock);	/* irqs remain disabled. */
 	}
 
+	rnp = rcu_get_root(rsp);
+	spin_lock(&rnp->lock);			/* irqs already disabled. */
 	rsp->signaled = RCU_SIGNAL_INIT; /* force_quiescent_state now OK. */
+	spin_unlock(&rnp->lock);		/* irqs remain disabled. */
 	spin_unlock_irqrestore(&rsp->onofflock, flags);
 }
 
@@ -706,6 +709,7 @@ static void cpu_quiet_msk_finish(struct rcu_state *rsp, unsigned long flags)
 {
 	WARN_ON_ONCE(!rcu_gp_in_progress(rsp));
 	rsp->completed = rsp->gpnum;
+	rsp->signaled = RCU_GP_IDLE;
 	rcu_process_gp_end(rsp, rsp->rda[smp_processor_id()]);
 	rcu_start_gp(rsp, flags);  /* releases root node's rnp->lock. */
 }
@@ -1162,9 +1166,10 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 	}
 	spin_unlock(&rnp->lock);
 	switch (signaled) {
+	case RCU_GP_IDLE:
 	case RCU_GP_INIT:
 
-		break; /* grace period still initializing, ignore. */
+		break; /* grace period idle or initializing, ignore. */
 
 	case RCU_SAVE_DYNTICK:
 
@@ -1178,7 +1183,8 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 
 		/* Update state, record completion counter. */
 		spin_lock(&rnp->lock);
-		if (lastcomp == rsp->completed) {
+		if (lastcomp == rsp->completed &&
+		    rsp->signaled == RCU_SAVE_DYNTICK) {
 			rsp->signaled = RCU_FORCE_QS;
 			dyntick_record_completed(rsp, lastcomp);
 		}
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 1823c6e..1899023 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -201,9 +201,10 @@ struct rcu_data {
 };
 
 /* Values for signaled field in struct rcu_state. */
-#define RCU_GP_INIT		0	/* Grace period being initialized. */
-#define RCU_SAVE_DYNTICK	1	/* Need to scan dyntick state. */
-#define RCU_FORCE_QS		2	/* Need to force quiescent state. */
+#define RCU_GP_IDLE		0	/* No grace period in progress. */
+#define RCU_GP_INIT		1	/* Grace period being initialized. */
+#define RCU_SAVE_DYNTICK	2	/* Need to scan dyntick state. */
+#define RCU_FORCE_QS		3	/* Need to force quiescent state. */
 #ifdef CONFIG_NO_HZ
 #define RCU_SIGNAL_INIT		RCU_SAVE_DYNTICK
 #else /* #ifdef CONFIG_NO_HZ */
diff --git a/kernel/user.c b/kernel/user.c
index 2c000e7..46d0165 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -330,9 +330,9 @@ done:
  */
 static void free_user(struct user_struct *up, unsigned long flags)
 {
-	spin_unlock_irqrestore(&uidhash_lock, flags);
 	INIT_DELAYED_WORK(&up->work, cleanup_user_struct);
 	schedule_delayed_work(&up->work, msecs_to_jiffies(1000));
+	spin_unlock_irqrestore(&uidhash_lock, flags);
 }
 
 #else	/* CONFIG_USER_SCHED && CONFIG_SYSFS */
diff --git a/mm/highmem.c b/mm/highmem.c
index 25878cc..9c1e627 100644
--- a/mm/highmem.c
+++ b/mm/highmem.c
@@ -426,16 +426,21 @@ void __init page_address_init(void)
 
 void debug_kmap_atomic(enum km_type type)
 {
-	static unsigned warn_count = 10;
+	static int warn_count = 10;
 
-	if (unlikely(warn_count == 0))
+	if (unlikely(warn_count < 0))
 		return;
 
 	if (unlikely(in_interrupt())) {
-		if (in_irq()) {
+		if (in_nmi()) {
+			if (type != KM_NMI && type != KM_NMI_PTE) {
+				WARN_ON(1);
+				warn_count--;
+			}
+		} else if (in_irq()) {
 			if (type != KM_IRQ0 && type != KM_IRQ1 &&
 			    type != KM_BIO_SRC_IRQ && type != KM_BIO_DST_IRQ &&
-			    type != KM_BOUNCE_READ) {
+			    type != KM_BOUNCE_READ && type != KM_IRQ_PTE) {
 				WARN_ON(1);
 				warn_count--;
 			}
@@ -452,7 +457,9 @@ void debug_kmap_atomic(enum km_type type)
 	}
 
 	if (type == KM_IRQ0 || type == KM_IRQ1 || type == KM_BOUNCE_READ ||
-			type == KM_BIO_SRC_IRQ || type == KM_BIO_DST_IRQ) {
+			type == KM_BIO_SRC_IRQ || type == KM_BIO_DST_IRQ ||
+			type == KM_IRQ_PTE || type == KM_NMI ||
+			type == KM_NMI_PTE ) {
 		if (!irqs_disabled()) {
 			WARN_ON(1);
 			warn_count--;
