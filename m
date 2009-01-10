Return-Path: <linux-kernel-owner+w=401wt.eu-S1756331AbZAJWj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756331AbZAJWj4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 17:39:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754239AbZAJWif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 17:38:35 -0500
Received: from relay1.sgi.com ([192.48.179.29]:51314 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754122AbZAJWie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 17:38:34 -0500
Message-Id: <20090110223818.767801000@polaris-admin.engr.sgi.com>
References: <20090110223818.459493000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Sat, 10 Jan 2009 14:38:20 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Yinghai Lu <yinghai@kernel.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] irq: allocate irq_desc_ptrs array based on nr_irqs
Content-Disposition: inline; filename=irq-alloc-irq_ptrs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: preparation for making irq_desc_ptrs variable-sized.

This addresses this memory usage bump when NR_CPUS bumped from 128 to 4096:

    34816   +229376    264192  +658%  irq_desc_ptrs(.data.read_mostly)

The patch is split into two part, the first simply allocates the
irq_desc_ptrs array.  Then next will deal with making it variable.
This is only when CONFIG_SPARSE_IRQS=y.

Signed-off-by: Mike Travis <travis@sgi.com>
---
 kernel/irq/handle.c    |   11 +++++++++--
 kernel/irq/internals.h |    4 ++++
 2 files changed, 13 insertions(+), 2 deletions(-)

--- linux-2.6-for-ingo.orig/kernel/irq/handle.c
+++ linux-2.6-for-ingo/kernel/irq/handle.c
@@ -17,6 +17,7 @@
 #include <linux/kernel_stat.h>
 #include <linux/rculist.h>
 #include <linux/hash.h>
+#include <linux/bootmem.h>
 
 #include "internals.h"
 
@@ -110,7 +111,7 @@ static void init_one_irq_desc(int irq, s
  */
 DEFINE_SPINLOCK(sparse_irq_lock);
 
-struct irq_desc *irq_desc_ptrs[NR_IRQS] __read_mostly;
+struct irq_desc **irq_desc_ptrs __read_mostly;
 
 static struct irq_desc irq_desc_legacy[NR_IRQS_LEGACY] __cacheline_aligned_in_smp = {
 	[0 ... NR_IRQS_LEGACY-1] = {
@@ -137,6 +138,9 @@ int __init early_irq_init(void)
 	desc = irq_desc_legacy;
 	legacy_count = ARRAY_SIZE(irq_desc_legacy);
 
+	/* allocate irq_desc_ptrs array based on nr_irqs */
+	irq_desc_ptrs = alloc_bootmem(nr_irqs * sizeof(void *));
+
 	for (i = 0; i < legacy_count; i++) {
 		desc[i].irq = i;
 		desc[i].kstat_irqs = kstat_irqs_legacy[i];
@@ -153,7 +157,10 @@ int __init early_irq_init(void)
 
 struct irq_desc *irq_to_desc(unsigned int irq)
 {
-	return (irq < nr_irqs) ? irq_desc_ptrs[irq] : NULL;
+	if (irq_desc_ptrs && irq < nr_irqs)
+		return irq_desc_ptrs[irq];
+
+	return NULL;
 }
 
 struct irq_desc *irq_to_desc_alloc_cpu(unsigned int irq, int cpu)
--- linux-2.6-for-ingo.orig/kernel/irq/internals.h
+++ linux-2.6-for-ingo/kernel/irq/internals.h
@@ -16,7 +16,11 @@ extern int __irq_set_trigger(struct irq_
 extern struct lock_class_key irq_desc_lock_class;
 extern void init_kstat_irqs(struct irq_desc *desc, int cpu, int nr);
 extern spinlock_t sparse_irq_lock;
+#ifdef CONFIG_SPARSE_IRQ
+extern struct irq_desc **irq_desc_ptrs;
+#else
 extern struct irq_desc *irq_desc_ptrs[NR_IRQS];
+#endif
 
 #ifdef CONFIG_PROC_FS
 extern void register_irq_proc(unsigned int irq, struct irq_desc *desc);

-- 
