Return-Path: <linux-kernel-owner+w=401wt.eu-S1754423Ab0AHXsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423Ab0AHXsT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 18:48:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754288Ab0AHXrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 18:47:48 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:44857 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754147Ab0AHXrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 18:47:46 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Fri, 08 Jan 2010 15:46:31 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 3/5] sparseirq: change irq_desc_ptrs to static
In-reply-to: <1262994393-17391-1-git-send-email-yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Message-id: <1262994393-17391-3-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1262994393-17391-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add replace_irq_desc()

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 kernel/irq/handle.c       |    8 +++++++-
 kernel/irq/internals.h    |    6 +-----
 kernel/irq/numa_migrate.c |    4 ++--
 3 files changed, 10 insertions(+), 8 deletions(-)

Index: linux-2.6/kernel/irq/handle.c
===================================================================
--- linux-2.6.orig/kernel/irq/handle.c
+++ linux-2.6/kernel/irq/handle.c
@@ -127,7 +127,7 @@ static void init_one_irq_desc(int irq, s
  */
 DEFINE_RAW_SPINLOCK(sparse_irq_lock);
 
-struct irq_desc **irq_desc_ptrs __read_mostly;
+static struct irq_desc **irq_desc_ptrs __read_mostly;
 
 static struct irq_desc irq_desc_legacy[NR_IRQS_LEGACY] __cacheline_aligned_in_smp = {
 	[0 ... NR_IRQS_LEGACY-1] = {
@@ -192,6 +192,12 @@ struct irq_desc *irq_to_desc(unsigned in
 	return NULL;
 }
 
+void replace_irq_desc(unsigned int irq, struct irq_desc *desc)
+{
+	if (irq_desc_ptrs && irq < nr_irqs)
+		irq_desc_ptrs[irq] = desc;
+}
+
 struct irq_desc * __ref irq_to_desc_alloc_node(unsigned int irq, int node)
 {
 	struct irq_desc *desc;
Index: linux-2.6/kernel/irq/internals.h
===================================================================
--- linux-2.6.orig/kernel/irq/internals.h
+++ linux-2.6/kernel/irq/internals.h
@@ -21,11 +21,7 @@ extern void clear_kstat_irqs(struct irq_
 extern raw_spinlock_t sparse_irq_lock;
 
 #ifdef CONFIG_SPARSE_IRQ
-/* irq_desc_ptrs allocated at boot time */
-extern struct irq_desc **irq_desc_ptrs;
-#else
-/* irq_desc_ptrs is a fixed size array */
-extern struct irq_desc *irq_desc_ptrs[NR_IRQS];
+void replace_irq_desc(unsigned int irq, struct irq_desc *desc);
 #endif
 
 #ifdef CONFIG_PROC_FS
Index: linux-2.6/kernel/irq/numa_migrate.c
===================================================================
--- linux-2.6.orig/kernel/irq/numa_migrate.c
+++ linux-2.6/kernel/irq/numa_migrate.c
@@ -70,7 +70,7 @@ static struct irq_desc *__real_move_irq_
 	raw_spin_lock_irqsave(&sparse_irq_lock, flags);
 
 	/* We have to check it to avoid races with another CPU */
-	desc = irq_desc_ptrs[irq];
+	desc = irq_to_desc(irq);
 
 	if (desc && old_desc != desc)
 		goto out_unlock;
@@ -90,7 +90,7 @@ static struct irq_desc *__real_move_irq_
 		goto out_unlock;
 	}
 
-	irq_desc_ptrs[irq] = desc;
+	replace_irq_desc(irq, desc);
 	raw_spin_unlock_irqrestore(&sparse_irq_lock, flags);
 
 	/* free the old one */
