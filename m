Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313Ab0BRB64 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 20:58:56 -0500
Received: from hera.kernel.org ([140.211.167.34]:37340 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932164Ab0BRB6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 20:58:52 -0500
Date: Thu, 18 Feb 2010 01:58:29 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, tglx@linutronix.de
In-Reply-To: <1265793639-15071-32-git-send-email-yinghai@kernel.org>
References: <1265793639-15071-32-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/irq] sparseirq: Use radix_tree instead of ptrs array
Message-ID: <tip-b5eb78f76ddfa7caf4340cf6893b032f45d8114a@git.kernel.org>
Git-Commit-ID: b5eb78f76ddfa7caf4340cf6893b032f45d8114a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 18 Feb 2010 01:58:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b5eb78f76ddfa7caf4340cf6893b032f45d8114a
Gitweb:     http://git.kernel.org/tip/b5eb78f76ddfa7caf4340cf6893b032f45d8114a
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Wed, 10 Feb 2010 01:20:35 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 17 Feb 2010 17:27:20 -0800

sparseirq: Use radix_tree instead of ptrs array

Use radix_tree irq_desc_tree instead of irq_desc_ptrs.

-v2: according to Eric and cyrill to use radix_tree_lookup_slot and
     radix_tree_replace_slot

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <1265793639-15071-32-git-send-email-yinghai@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 kernel/irq/handle.c |   49 +++++++++++++++++++++++++------------------------
 1 files changed, 25 insertions(+), 24 deletions(-)

diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 266f798..76d5a67 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -19,6 +19,7 @@
 #include <linux/kernel_stat.h>
 #include <linux/rculist.h>
 #include <linux/hash.h>
+#include <linux/radix-tree.h>
 #include <trace/events/irq.h>
 
 #include "internals.h"
@@ -127,7 +128,26 @@ static void init_one_irq_desc(int irq, struct irq_desc *desc, int node)
  */
 DEFINE_RAW_SPINLOCK(sparse_irq_lock);
 
-static struct irq_desc **irq_desc_ptrs __read_mostly;
+static RADIX_TREE(irq_desc_tree, GFP_ATOMIC);
+
+static void set_irq_desc(unsigned int irq, struct irq_desc *desc)
+{
+	radix_tree_insert(&irq_desc_tree, irq, desc);
+}
+
+struct irq_desc *irq_to_desc(unsigned int irq)
+{
+	return radix_tree_lookup(&irq_desc_tree, irq);
+}
+
+void replace_irq_desc(unsigned int irq, struct irq_desc *desc)
+{
+	void **ptr;
+
+	ptr = radix_tree_lookup_slot(&irq_desc_tree, irq);
+	if (ptr)
+		radix_tree_replace_slot(ptr, desc);
+}
 
 static struct irq_desc irq_desc_legacy[NR_IRQS_LEGACY] __cacheline_aligned_in_smp = {
 	[0 ... NR_IRQS_LEGACY-1] = {
@@ -159,9 +179,6 @@ int __init early_irq_init(void)
 	legacy_count = ARRAY_SIZE(irq_desc_legacy);
 	node = first_online_node;
 
-	/* allocate irq_desc_ptrs array based on nr_irqs */
-	irq_desc_ptrs = kcalloc(nr_irqs, sizeof(void *), GFP_NOWAIT);
-
 	/* allocate based on nr_cpu_ids */
 	kstat_irqs_legacy = kzalloc_node(NR_IRQS_LEGACY * nr_cpu_ids *
 					  sizeof(int), GFP_NOWAIT, node);
@@ -175,28 +192,12 @@ int __init early_irq_init(void)
 		lockdep_set_class(&desc[i].lock, &irq_desc_lock_class);
 		alloc_desc_masks(&desc[i], node, true);
 		init_desc_masks(&desc[i]);
-		irq_desc_ptrs[i] = desc + i;
+		set_irq_desc(i, &desc[i]);
 	}
 
-	for (i = legacy_count; i < nr_irqs; i++)
-		irq_desc_ptrs[i] = NULL;
-
 	return arch_early_irq_init();
 }
 
-struct irq_desc *irq_to_desc(unsigned int irq)
-{
-	if (irq_desc_ptrs && irq < nr_irqs)
-		return irq_desc_ptrs[irq];
-
-	return NULL;
-}
-
-void replace_irq_desc(unsigned int irq, struct irq_desc *desc)
-{
-	irq_desc_ptrs[irq] = desc;
-}
-
 struct irq_desc * __ref irq_to_desc_alloc_node(unsigned int irq, int node)
 {
 	struct irq_desc *desc;
@@ -208,14 +209,14 @@ struct irq_desc * __ref irq_to_desc_alloc_node(unsigned int irq, int node)
 		return NULL;
 	}
 
-	desc = irq_desc_ptrs[irq];
+	desc = irq_to_desc(irq);
 	if (desc)
 		return desc;
 
 	raw_spin_lock_irqsave(&sparse_irq_lock, flags);
 
 	/* We have to check it to avoid races with another CPU */
-	desc = irq_desc_ptrs[irq];
+	desc = irq_to_desc(irq);
 	if (desc)
 		goto out_unlock;
 
@@ -228,7 +229,7 @@ struct irq_desc * __ref irq_to_desc_alloc_node(unsigned int irq, int node)
 	}
 	init_one_irq_desc(irq, desc, node);
 
-	irq_desc_ptrs[irq] = desc;
+	set_irq_desc(irq, desc);
 
 out_unlock:
 	raw_spin_unlock_irqrestore(&sparse_irq_lock, flags);
