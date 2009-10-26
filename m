Return-Path: <linux-kernel-owner+w=401wt.eu-S1754224AbZJZWCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224AbZJZWCj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 18:02:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754137AbZJZWCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 18:02:37 -0400
Received: from mga14.intel.com ([143.182.124.37]:19890 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753961AbZJZWCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 18:02:34 -0400
X-ExtLoop1: 1
Message-Id: <20091026230001.752968906@sbs-t61.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Mon, 26 Oct 2009 14:24:33 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, ebiederm@xmission.com
Cc: garyhade@us.ibm.com, suresh.b.siddha@intel.com,
       linux-kernel@vger.kernel.org
Subject: [patch 3/6] x86: remove move_cleanup_count from irq_cfg
References: <20091026222430.313656103@sbs-t61.sc.intel.com>
Content-Disposition: inline; filename=remove_move_cleanup_count.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

move_cleanup_count for each irq in irq_cfg is keeping track of the total number
of cpus that need to free the corresponding vectors associated with the irq
which has now been migrated to new destination. As long as this
move_cleanup_count is non-zero (i.e., as long as we have n't freed the vector
allocations on the old destinations) we were preventing the irq's further
migration.

This cleanup count is unnecessary and it is enough to not allow the irq
migration till we send the cleanup vector to the previous irq destination,
for which we already have irq_cfg's move_in_progress.  All we need to make
sure is that we free the vector at the old desintation but we don't need
to wait till that gets freed.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Gary Hade <garyhade@us.ibm.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/x86/include/asm/hw_irq.h  |    1 -
 arch/x86/kernel/apic/io_apic.c |    9 +--------
 2 files changed, 1 insertion(+), 9 deletions(-)

Index: tip/arch/x86/kernel/apic/io_apic.c
===================================================================
--- tip.orig/arch/x86/kernel/apic/io_apic.c
+++ tip/arch/x86/kernel/apic/io_apic.c
@@ -1161,7 +1161,7 @@ __assign_irq_vector(int irq, struct irq_
 	int cpu, err;
 	cpumask_var_t tmp_mask;
 
-	if ((cfg->move_in_progress) || cfg->move_cleanup_count)
+	if (cfg->move_in_progress)
 		return -EBUSY;
 
 	if (!alloc_cpumask_var(&tmp_mask, GFP_ATOMIC))
@@ -2234,14 +2234,10 @@ void send_cleanup_vector(struct irq_cfg 
 
 	if (unlikely(!alloc_cpumask_var(&cleanup_mask, GFP_ATOMIC))) {
 		unsigned int i;
-		cfg->move_cleanup_count = 0;
-		for_each_cpu_and(i, cfg->old_domain, cpu_online_mask)
-			cfg->move_cleanup_count++;
 		for_each_cpu_and(i, cfg->old_domain, cpu_online_mask)
 			apic->send_IPI_mask(cpumask_of(i), IRQ_MOVE_CLEANUP_VECTOR);
 	} else {
 		cpumask_and(cleanup_mask, cfg->old_domain, cpu_online_mask);
-		cfg->move_cleanup_count = cpumask_weight(cleanup_mask);
 		apic->send_IPI_mask(cleanup_mask, IRQ_MOVE_CLEANUP_VECTOR);
 		free_cpumask_var(cleanup_mask);
 	}
@@ -2430,8 +2426,6 @@ asmlinkage void smp_irq_move_cleanup_int
 
 		cfg = irq_cfg(irq);
 		spin_lock(&desc->lock);
-		if (!cfg->move_cleanup_count)
-			goto unlock;
 
 		if (vector == cfg->vector && cpumask_test_cpu(me, cfg->domain))
 			goto unlock;
@@ -2449,7 +2443,6 @@ asmlinkage void smp_irq_move_cleanup_int
 			goto unlock;
 		}
 		__get_cpu_var(vector_irq)[vector] = -1;
-		cfg->move_cleanup_count--;
 unlock:
 		spin_unlock(&desc->lock);
 	}
Index: tip/arch/x86/include/asm/hw_irq.h
===================================================================
--- tip.orig/arch/x86/include/asm/hw_irq.h
+++ tip/arch/x86/include/asm/hw_irq.h
@@ -94,7 +94,6 @@ struct irq_cfg {
 	struct irq_pin_list	*irq_2_pin;
 	cpumask_var_t		domain;
 	cpumask_var_t		old_domain;
-	unsigned		move_cleanup_count;
 	u8			vector;
 	u8			move_in_progress : 1;
 };


