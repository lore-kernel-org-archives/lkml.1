Return-Path: <linux-kernel-owner+w=401wt.eu-S1754081AbYLZJN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081AbYLZJN5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 04:13:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753349AbYLZJNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 04:13:33 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57580 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752966AbYLZJNc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 04:13:32 -0500
Message-ID: <4954A02E.3030207@cn.fujitsu.com>
Date: Fri, 26 Dec 2008 17:13:18 +0800
From: Wang Chen <wangchen@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: [PATCH 2/2 -tip] irq: kstat_incr_irqs_this_cpu only needs one parameter
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

desc is useless for kstat_incr_irqs_this_cpu.

Signed-off-by: Wang Chen <wangchen@cn.fujitsu.com>
---
 arch/x86/kernel/visws_quirks.c |    2 +-
 arch/x86/xen/spinlock.c        |    2 +-
 include/linux/kernel_stat.h    |    3 +--
 kernel/irq/chip.c              |   10 +++++-----
 kernel/irq/handle.c            |    4 ++--
 5 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/visws_quirks.c b/arch/x86/kernel/visws_quirks.c
index 0c9667f..bd37460 100644
--- a/arch/x86/kernel/visws_quirks.c
+++ b/arch/x86/kernel/visws_quirks.c
@@ -633,7 +633,7 @@ static irqreturn_t piix4_master_intr(int irq, void *dev_id)
 	/*
 	 * handle this 'virtual interrupt' as a Cobalt one now.
 	 */
-	kstat_incr_irqs_this_cpu(realirq, desc);
+	kstat_incr_irqs_this_cpu(realirq);
 
 	if (likely(desc->action != NULL))
 		handle_IRQ_event(realirq, desc->action);
diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
index 5601506..79b4791 100644
--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -241,7 +241,7 @@ static noinline int xen_spin_lock_slow(struct raw_spinlock *lock, bool irq_enabl
 		ADD_STATS(taken_slow_spurious, !xen_test_irq_pending(irq));
 	} while (!xen_test_irq_pending(irq)); /* check for spurious wakeups */
 
-	kstat_incr_irqs_this_cpu(irq, irq_to_desc(irq));
+	kstat_incr_irqs_this_cpu(irq);
 
 out:
 	raw_local_irq_restore(flags);
diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index 546a9d9..8b2e5b7 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -47,8 +47,7 @@ extern unsigned long long nr_context_switches(void);
 
 struct irq_desc;
 
-static inline void kstat_incr_irqs_this_cpu(unsigned int irq,
-					    struct irq_desc *desc)
+static inline void kstat_incr_irqs_this_cpu(unsigned int irq)
 {
 	kstat_this_cpu.irqs[irq]++;
 }
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index b929803..e316635 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -317,7 +317,7 @@ handle_simple_irq(unsigned int irq, struct irq_desc *desc)
 	if (unlikely(desc->status & IRQ_INPROGRESS))
 		goto out_unlock;
 	desc->status &= ~(IRQ_REPLAY | IRQ_WAITING);
-	kstat_incr_irqs_this_cpu(irq, desc);
+	kstat_incr_irqs_this_cpu(irq);
 
 	action = desc->action;
 	if (unlikely(!action || (desc->status & IRQ_DISABLED)))
@@ -359,7 +359,7 @@ handle_level_irq(unsigned int irq, struct irq_desc *desc)
 	if (unlikely(desc->status & IRQ_INPROGRESS))
 		goto out_unlock;
 	desc->status &= ~(IRQ_REPLAY | IRQ_WAITING);
-	kstat_incr_irqs_this_cpu(irq, desc);
+	kstat_incr_irqs_this_cpu(irq);
 
 	/*
 	 * If its disabled or no action available
@@ -406,7 +406,7 @@ handle_fasteoi_irq(unsigned int irq, struct irq_desc *desc)
 		goto out;
 
 	desc->status &= ~(IRQ_REPLAY | IRQ_WAITING);
-	kstat_incr_irqs_this_cpu(irq, desc);
+	kstat_incr_irqs_this_cpu(irq);
 
 	/*
 	 * If its disabled or no action available
@@ -472,7 +472,7 @@ handle_edge_irq(unsigned int irq, struct irq_desc *desc)
 		desc = irq_remap_to_desc(irq, desc);
 		goto out_unlock;
 	}
-	kstat_incr_irqs_this_cpu(irq, desc);
+	kstat_incr_irqs_this_cpu(irq);
 
 	/* Start handling the irq */
 	desc->chip->ack(irq);
@@ -528,7 +528,7 @@ handle_percpu_irq(unsigned int irq, struct irq_desc *desc)
 {
 	irqreturn_t action_ret;
 
-	kstat_incr_irqs_this_cpu(irq, desc);
+	kstat_incr_irqs_this_cpu(irq);
 
 	desc->chip->ack(irq);
 
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 4408672..3323d02 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -35,7 +35,7 @@ struct lock_class_key irq_desc_lock_class;
 void handle_bad_irq(unsigned int irq, struct irq_desc *desc)
 {
 	print_irq_desc(irq, desc);
-	kstat_incr_irqs_this_cpu(irq, desc);
+	kstat_incr_irqs_this_cpu(irq);
 	ack_bad_irq(irq);
 }
 
@@ -329,7 +329,7 @@ unsigned int __do_IRQ(unsigned int irq)
 	struct irqaction *action;
 	unsigned int status;
 
-	kstat_incr_irqs_this_cpu(irq, desc);
+	kstat_incr_irqs_this_cpu(irq);
 
 	if (CHECK_IRQ_PER_CPU(desc->status)) {
 		irqreturn_t action_ret;
-- 
1.5.3.4



