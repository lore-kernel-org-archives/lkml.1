Return-Path: <linux-kernel-owner+w=401wt.eu-S1755474AbZALWGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474AbZALWGP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 17:06:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754036AbZALWFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 17:05:24 -0500
Received: from relay2.sgi.com ([192.48.179.30]:48520 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751653AbZALWFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 17:05:22 -0500
Message-Id: <20090112220519.899197000@polaris-admin.engr.sgi.com>
References: <20090112220519.566749000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 12 Jan 2009 14:05:21 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       <kernel@wantstofly.org>
Subject: [PATCH 2/8] arm irq: update arm for new irq_desc
Content-Disposition: inline; filename=irq:update-arm-to-new-irq_desc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, update to new cpumask API

Irq_desc.affinity and irq_desc.pending_mask are now cpumask_var_t's
so access to them should be using the new cpumask API.

Since CONFIG_CPUMASK_OFFSTACK is not likely to be enabled for the arm
architecture, double check that it is indeed not set, as we do not
allocate any variable-sized cpumask_var_t's.

Signed-off-by: Mike Travis <travis@sgi.com>
Cc: <kernel@wantstofly.org>
---
 arch/arm/kernel/irq.c               |   18 ++++++++++++------
 arch/arm/oprofile/op_model_mpcore.c |    2 +-
 2 files changed, 13 insertions(+), 7 deletions(-)

--- linux-2.6-for-ingo.orig/arch/arm/kernel/irq.c
+++ linux-2.6-for-ingo/arch/arm/kernel/irq.c
@@ -104,6 +104,11 @@ static struct irq_desc bad_irq_desc = {
 	.lock = SPIN_LOCK_UNLOCKED
 };
 
+#ifdef CONFIG_CPUMASK_OFFSTACK
+/* We are not allocating bad_irq_desc.affinity or .pending_mask */
+#error "ARM architecture does not support CONFIG_CPUMASK_OFFSTACK."
+#endif
+
 /*
  * do_IRQ handles all hardware IRQ's.  Decoded IRQs should not
  * come via this function.  Instead, they should provide their
@@ -161,7 +166,7 @@ void __init init_IRQ(void)
 		irq_desc[irq].status |= IRQ_NOREQUEST | IRQ_NOPROBE;
 
 #ifdef CONFIG_SMP
-	bad_irq_desc.affinity = CPU_MASK_ALL;
+	cpumask_setall(bad_irq_desc.affinity);
 	bad_irq_desc.cpu = smp_processor_id();
 #endif
 	init_arch_irq();
@@ -191,15 +196,16 @@ void migrate_irqs(void)
 		struct irq_desc *desc = irq_desc + i;
 
 		if (desc->cpu == cpu) {
-			unsigned int newcpu = any_online_cpu(desc->affinity);
-
-			if (newcpu == NR_CPUS) {
+			unsigned int newcpu = cpumask_any_and(desc->affinity,
+							      cpu_online_mask);
+			if (newcpu >= nr_cpu_ids) {
 				if (printk_ratelimit())
 					printk(KERN_INFO "IRQ%u no longer affine to CPU%u\n",
 					       i, cpu);
 
-				cpus_setall(desc->affinity);
-				newcpu = any_online_cpu(desc->affinity);
+				cpumask_setall(desc->affinity);
+				newcpu = cpumask_any_and(desc->affinity,
+							 cpu_online_mask);
 			}
 
 			route_irq(desc, i, newcpu);
--- linux-2.6-for-ingo.orig/arch/arm/oprofile/op_model_mpcore.c
+++ linux-2.6-for-ingo/arch/arm/oprofile/op_model_mpcore.c
@@ -263,7 +263,7 @@ static void em_route_irq(int irq, unsign
 	const struct cpumask *mask = cpumask_of(cpu);
 
 	spin_lock_irq(&desc->lock);
-	desc->affinity = *mask;
+	cpumask_copy(desc->affinity, mask);
 	desc->chip->set_affinity(irq, mask);
 	spin_unlock_irq(&desc->lock);
 }

-- 
