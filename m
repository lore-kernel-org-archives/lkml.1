Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755677Ab0BRB6i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 20:58:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:37325 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753797Ab0BRB6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 20:58:36 -0500
Date: Thu, 18 Feb 2010 01:58:12 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, tglx@linutronix.de
In-Reply-To: <1265793639-15071-31-git-send-email-yinghai@kernel.org>
References: <1265793639-15071-31-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/irq] sparseirq: Change irq_desc_ptrs to static
Message-ID: <tip-99558f0bbe68cb09799ec38adbaa3f3b2dc7ba63@git.kernel.org>
Git-Commit-ID: 99558f0bbe68cb09799ec38adbaa3f3b2dc7ba63
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 18 Feb 2010 01:58:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  99558f0bbe68cb09799ec38adbaa3f3b2dc7ba63
Gitweb:     http://git.kernel.org/tip/99558f0bbe68cb09799ec38adbaa3f3b2dc7ba63
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Wed, 10 Feb 2010 01:20:34 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 17 Feb 2010 17:27:03 -0800

sparseirq: Change irq_desc_ptrs to static

Add replace_irq_desc() instead of poking at the array directly.

-v2: remove unneeded boundary check in replace_irq_desc

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <1265793639-15071-31-git-send-email-yinghai@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
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
