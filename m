Return-Path: <linux-kernel-owner+w=401wt.eu-S1751858AbZALWFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858AbZALWFt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 17:05:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753923AbZALWFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 17:05:23 -0500
Received: from relay2.sgi.com ([192.48.179.30]:48518 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751449AbZALWFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 17:05:22 -0500
Message-Id: <20090112220520.566552000@polaris-admin.engr.sgi.com>
References: <20090112220519.566749000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 12 Jan 2009 14:05:26 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, <linuxppc-dev@ozlabs.org>
Subject: [PATCH 7/8] powerpc irq: update powerpc for new irq_desc
Content-Disposition: inline; filename=irq:update-powerpc-to-new-irq_desc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, update to new cpumask API

Irq_desc.affinity and irq_desc.pending_mask are now cpumask_var_t's
so access to them should be using the new cpumask API.

Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: <linuxppc-dev@ozlabs.org>
---
 arch/powerpc/kernel/irq.c             |    2 +-
 arch/powerpc/platforms/pseries/xics.c |    5 +++--
 arch/powerpc/sysdev/mpic.c            |    3 ++-
 3 files changed, 6 insertions(+), 4 deletions(-)

--- linux-2.6-for-ingo.orig/arch/powerpc/kernel/irq.c
+++ linux-2.6-for-ingo/arch/powerpc/kernel/irq.c
@@ -231,7 +231,7 @@ void fixup_irqs(cpumask_t map)
 		if (irq_desc[irq].status & IRQ_PER_CPU)
 			continue;
 
-		cpus_and(mask, irq_desc[irq].affinity, map);
+		cpumask_and(&mask, irq_desc[irq].affinity, &map);
 		if (any_online_cpu(mask) == NR_CPUS) {
 			printk("Breaking affinity for irq %i\n", irq);
 			mask = map;
--- linux-2.6-for-ingo.orig/arch/powerpc/platforms/pseries/xics.c
+++ linux-2.6-for-ingo/arch/powerpc/platforms/pseries/xics.c
@@ -153,9 +153,10 @@ static int get_irq_server(unsigned int v
 {
 	int server;
 	/* For the moment only implement delivery to all cpus or one cpu */
-	cpumask_t cpumask = irq_desc[virq].affinity;
+	cpumask_t cpumask;
 	cpumask_t tmp = CPU_MASK_NONE;
 
+	cpumask_copy(&cpumask, irq_desc[virq].affinity);
 	if (!distribute_irqs)
 		return default_server;
 
@@ -869,7 +870,7 @@ void xics_migrate_irqs_away(void)
 		       virq, cpu);
 
 		/* Reset affinity to all cpus */
-		irq_desc[virq].affinity = CPU_MASK_ALL;
+		cpumask_setall(irq_desc[virq].affinity);
 		desc->chip->set_affinity(virq, cpu_all_mask);
 unlock:
 		spin_unlock_irqrestore(&desc->lock, flags);
--- linux-2.6-for-ingo.orig/arch/powerpc/sysdev/mpic.c
+++ linux-2.6-for-ingo/arch/powerpc/sysdev/mpic.c
@@ -566,9 +566,10 @@ static void __init mpic_scan_ht_pics(str
 #ifdef CONFIG_SMP
 static int irq_choose_cpu(unsigned int virt_irq)
 {
-	cpumask_t mask = irq_desc[virt_irq].affinity;
+	cpumask_t mask;
 	int cpuid;
 
+	cpumask_copy(&mask, irq_desc[virt_irq].affinity);
 	if (cpus_equal(mask, CPU_MASK_ALL)) {
 		static int irq_rover;
 		static DEFINE_SPINLOCK(irq_rover_lock);

-- 
