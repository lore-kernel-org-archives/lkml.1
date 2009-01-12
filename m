Return-Path: <linux-kernel-owner+w=401wt.eu-S1758084AbZALWGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758084AbZALWGe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 17:06:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754303AbZALWF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 17:05:26 -0500
Received: from relay1.sgi.com ([192.48.179.29]:54660 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751661AbZALWFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 17:05:22 -0500
Message-Id: <20090112220520.175039000@polaris-admin.engr.sgi.com>
References: <20090112220519.566749000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 12 Jan 2009 14:05:23 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Tony Luck <tony.luck@intel.com>, <linux-ia64@vger.kernel.org>
Subject: [PATCH 4/8] ia64 irq: update ia64 for new irq_desc
Content-Disposition: inline; filename=irq:update-ia64-to-new-irq_desc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, update to new cpumask API

Irq_desc.affinity and irq_desc.pending_mask are now cpumask_var_t's
so access to them should be using the new cpumask API.

Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: <linux-ia64@vger.kernel.org>
---
 arch/ia64/kernel/iosapic.c   |    2 +-
 arch/ia64/kernel/irq.c       |    4 ++--
 arch/ia64/kernel/msi_ia64.c  |    4 ++--
 arch/ia64/sn/kernel/msi_sn.c |    2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

--- linux-2.6-for-ingo.orig/arch/ia64/kernel/iosapic.c
+++ linux-2.6-for-ingo/arch/ia64/kernel/iosapic.c
@@ -880,7 +880,7 @@ iosapic_unregister_intr (unsigned int gs
 	if (iosapic_intr_info[irq].count == 0) {
 #ifdef CONFIG_SMP
 		/* Clear affinity */
-		cpus_setall(idesc->affinity);
+		cpumask_setall(idesc->affinity);
 #endif
 		/* Clear the interrupt information */
 		iosapic_intr_info[irq].dest = 0;
--- linux-2.6-for-ingo.orig/arch/ia64/kernel/irq.c
+++ linux-2.6-for-ingo/arch/ia64/kernel/irq.c
@@ -103,7 +103,7 @@ static char irq_redir [NR_IRQS]; // = { 
 void set_irq_affinity_info (unsigned int irq, int hwid, int redir)
 {
 	if (irq < NR_IRQS) {
-		cpumask_copy(&irq_desc[irq].affinity,
+		cpumask_copy(irq_desc[irq].affinity,
 			     cpumask_of(cpu_logical_id(hwid)));
 		irq_redir[irq] = (char) (redir & 0xff);
 	}
@@ -148,7 +148,7 @@ static void migrate_irqs(void)
 		if (desc->status == IRQ_PER_CPU)
 			continue;
 
-		if (cpumask_any_and(&irq_desc[irq].affinity, cpu_online_mask)
+		if (cpumask_any_and(irq_desc[irq].affinity, cpu_online_mask)
 		    >= nr_cpu_ids) {
 			/*
 			 * Save it for phase 2 processing
--- linux-2.6-for-ingo.orig/arch/ia64/kernel/msi_ia64.c
+++ linux-2.6-for-ingo/arch/ia64/kernel/msi_ia64.c
@@ -75,7 +75,7 @@ static void ia64_set_msi_irq_affinity(un
 	msg.data = data;
 
 	write_msi_msg(irq, &msg);
-	irq_desc[irq].affinity = cpumask_of_cpu(cpu);
+	cpumask_copy(irq_desc[irq].affinity, cpumask_of(cpu));
 }
 #endif /* CONFIG_SMP */
 
@@ -187,7 +187,7 @@ static void dmar_msi_set_affinity(unsign
 	msg.address_lo |= MSI_ADDR_DESTID_CPU(cpu_physical_id(cpu));
 
 	dmar_msi_write(irq, &msg);
-	irq_desc[irq].affinity = *mask;
+	cpumask_copy(irq_desc[irq].affinity, mask);
 }
 #endif /* CONFIG_SMP */
 
--- linux-2.6-for-ingo.orig/arch/ia64/sn/kernel/msi_sn.c
+++ linux-2.6-for-ingo/arch/ia64/sn/kernel/msi_sn.c
@@ -205,7 +205,7 @@ static void sn_set_msi_irq_affinity(unsi
 	msg.address_lo = (u32)(bus_addr & 0x00000000ffffffff);
 
 	write_msi_msg(irq, &msg);
-	irq_desc[irq].affinity = *cpu_mask;
+	cpumask_copy(irq_desc[irq].affinity, cpu_mask);
 }
 #endif /* CONFIG_SMP */
 

-- 
