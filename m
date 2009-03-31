Return-Path: <linux-kernel-owner+w=401wt.eu-S1760944AbZCaDla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760944AbZCaDla (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 23:41:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756374AbZCaDlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 23:41:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:55988 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755386AbZCaDlU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 23:41:20 -0400
Message-ID: <49D18FF0.50707@kernel.org>
Date: Mon, 30 Mar 2009 20:37:20 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Rusty Russell <rusty@rustcorp.com.au>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] irq: fix cpumask leaking
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: fix bug

need to free the old cpumask for affinit and pending_mask

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 include/linux/irq.h       |   14 ++++++++++++++
 kernel/irq/numa_migrate.c |    1 +
 2 files changed, 15 insertions(+)

Index: linux-2.6/kernel/irq/numa_migrate.c
===================================================================
--- linux-2.6.orig/kernel/irq/numa_migrate.c
+++ linux-2.6/kernel/irq/numa_migrate.c
@@ -54,6 +54,7 @@ static bool init_copy_one_irq_desc(int i
 static void free_one_irq_desc(struct irq_desc *old_desc, struct irq_desc *desc)
 {
 	free_kstat_irqs(old_desc, desc);
+	free_desc_masks(old_desc, desc);
 	arch_free_chip_data(old_desc, desc);
 }
 
Index: linux-2.6/include/linux/irq.h
===================================================================
--- linux-2.6.orig/include/linux/irq.h
+++ linux-2.6/include/linux/irq.h
@@ -489,6 +489,16 @@ static inline void init_copy_desc_masks(
 #endif
 }
 
+static inline void free_desc_masks(struct irq_desc *old_desc,
+				   struct irq_desc *new_desc)
+{
+	free_cpumask_var(old_desc->affinity);
+
+#ifdef CONFIG_GENERIC_PENDING_IRQ
+	free_cpumask_var(old_desc->pending_mask);
+#endif
+}
+
 #else /* !CONFIG_SMP */
 
 static inline bool alloc_desc_masks(struct irq_desc *desc, int cpu,
@@ -506,6 +516,10 @@ static inline void init_copy_desc_masks(
 {
 }
 
+static inline void free_desc_masks(struct irq_desc *old_desc,
+				   struct irq_desc *new_desc)
+{
+}
 #endif	/* CONFIG_SMP */
 
 #endif /* _LINUX_IRQ_H */
