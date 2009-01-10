Return-Path: <linux-kernel-owner+w=401wt.eu-S1756558AbZAJWj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756558AbZAJWj0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 17:39:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754116AbZAJWie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 17:38:34 -0500
Received: from relay2.sgi.com ([192.48.179.30]:44410 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753418AbZAJWic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 17:38:32 -0500
Message-Id: <20090110223818.636427000@polaris-admin.engr.sgi.com>
References: <20090110223818.459493000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Sat, 10 Jan 2009 14:38:19 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Yinghai Lu <yinghai@kernel.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] irq: change references from NR_IRQS to nr_irqs
Content-Disposition: inline; filename=irq-prep
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: preparation, cleanup

Modify references from NR_IRQS to nr_irqs as the later will become
variable-sized based on nr_cpu_ids when CONFIG_SPARSE_IRQS=y.

Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/io_apic.c |    2 +-
 kernel/irq/handle.c       |   12 +++++++-----
 2 files changed, 8 insertions(+), 6 deletions(-)

--- linux-2.6-for-ingo.orig/arch/x86/kernel/io_apic.c
+++ linux-2.6-for-ingo/arch/x86/kernel/io_apic.c
@@ -3185,7 +3185,7 @@ unsigned int create_irq_nr(unsigned int 
 
 	irq = 0;
 	spin_lock_irqsave(&vector_lock, flags);
-	for (new = irq_want; new < NR_IRQS; new++) {
+	for (new = irq_want; new < nr_irqs; new++) {
 		if (platform_legacy_irq(new))
 			continue;
 
--- linux-2.6-for-ingo.orig/kernel/irq/handle.c
+++ linux-2.6-for-ingo/kernel/irq/handle.c
@@ -132,6 +132,8 @@ int __init early_irq_init(void)
 	int legacy_count;
 	int i;
 
+	printk(KERN_INFO "NR_IRQS:%d nr_irqs:%d\n", NR_IRQS, nr_irqs);
+
 	desc = irq_desc_legacy;
 	legacy_count = ARRAY_SIZE(irq_desc_legacy);
 
@@ -143,7 +145,7 @@ int __init early_irq_init(void)
 		irq_desc_ptrs[i] = desc + i;
 	}
 
-	for (i = legacy_count; i < NR_IRQS; i++)
+	for (i = legacy_count; i < nr_irqs; i++)
 		irq_desc_ptrs[i] = NULL;
 
 	return arch_early_irq_init();
@@ -151,7 +153,7 @@ int __init early_irq_init(void)
 
 struct irq_desc *irq_to_desc(unsigned int irq)
 {
-	return (irq < NR_IRQS) ? irq_desc_ptrs[irq] : NULL;
+	return (irq < nr_irqs) ? irq_desc_ptrs[irq] : NULL;
 }
 
 struct irq_desc *irq_to_desc_alloc_cpu(unsigned int irq, int cpu)
@@ -160,9 +162,9 @@ struct irq_desc *irq_to_desc_alloc_cpu(u
 	unsigned long flags;
 	int node;
 
-	if (irq >= NR_IRQS) {
-		printk(KERN_WARNING "irq >= NR_IRQS in irq_to_desc_alloc: %d %d\n",
-				irq, NR_IRQS);
+	if (irq >= nr_irqs) {
+		printk(KERN_WARNING "irq >= nr_irqs in irq_to_desc_alloc: %d %d\n",
+				irq, nr_irqs);
 		WARN_ON(1);
 		return NULL;
 	}

-- 
