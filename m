Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750Ab0BMCvz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 21:51:55 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:64079 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413Ab0BMCuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 21:50:40 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Fri, 12 Feb 2010 18:49:45 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 3/8] sparseirq: change irq_desc_ptrs to static
In-reply-to: <1266029390-30907-1-git-send-email-yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       Eric Biederman <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Message-id: <1266029390-30907-4-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1266029390-30907-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add replace_irq_desc()

-v2: remove unneeded boundary check in replace_irq_desc

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 kernel/irq/handle.c       |    7 ++++++-
 kernel/irq/internals.h    |    6 +-----
 kernel/irq/numa_migrate.c |    4 ++--
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 0e823c0..266f798 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -127,7 +127,7 @@ static void init_one_irq_desc(int irq, struct irq_desc *desc, int node)
  */
 DEFINE_RAW_SPINLOCK(sparse_irq_lock);
 
-struct irq_desc **irq_desc_ptrs __read_mostly;
+static struct irq_desc **irq_desc_ptrs __read_mostly;
 
 static struct irq_desc irq_desc_legacy[NR_IRQS_LEGACY] __cacheline_aligned_in_smp = {
 	[0 ... NR_IRQS_LEGACY-1] = {
@@ -192,6 +192,11 @@ struct irq_desc *irq_to_desc(unsigned int irq)
 	return NULL;
 }
 
+void replace_irq_desc(unsigned int irq, struct irq_desc *desc)
+{
+	irq_desc_ptrs[irq] = desc;
+}
+
 struct irq_desc * __ref irq_to_desc_alloc_node(unsigned int irq, int node)
 {
 	struct irq_desc *desc;
diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index b2821f0..c63f3bc 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -21,11 +21,7 @@ extern void clear_kstat_irqs(struct irq_desc *desc);
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
diff --git a/kernel/irq/numa_migrate.c b/kernel/irq/numa_migrate.c
index 26bac9d..963559d 100644
--- a/kernel/irq/numa_migrate.c
+++ b/kernel/irq/numa_migrate.c
@@ -70,7 +70,7 @@ static struct irq_desc *__real_move_irq_desc(struct irq_desc *old_desc,
 	raw_spin_lock_irqsave(&sparse_irq_lock, flags);
 
 	/* We have to check it to avoid races with another CPU */
-	desc = irq_desc_ptrs[irq];
+	desc = irq_to_desc(irq);
 
 	if (desc && old_desc != desc)
 		goto out_unlock;
@@ -90,7 +90,7 @@ static struct irq_desc *__real_move_irq_desc(struct irq_desc *old_desc,
 		goto out_unlock;
 	}
 
-	irq_desc_ptrs[irq] = desc;
+	replace_irq_desc(irq, desc);
 	raw_spin_unlock_irqrestore(&sparse_irq_lock, flags);
 
 	/* free the old one */
-- 
1.6.4.2

