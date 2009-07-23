Return-Path: <linux-kernel-owner+w=401wt.eu-S1751192AbZGWABN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751192AbZGWABN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 20:01:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750868AbZGWABM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 20:01:12 -0400
Received: from mail-yx0-f197.google.com ([209.85.210.197]:38223 "EHLO
	mail-yx0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbZGWABM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 20:01:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=q7BVa/sJxCHvoygtxoIOt2vUCfDrMFprJjpg1+f1MpEF7k3SyuuU834JT5U58OFqV+
         VJtt3dz5Pci88DVV04zvb+ZZWiO5q9nhpbgEMJNi9bCXZ2Oo5XVmbcx+4xb1oJA/v3vc
         AHHvg/COvV6pbwvUvGs2jXvWb9hwJlQObjZrA=
Message-ID: <4A67A83D.1030101@gmail.com>
Date: Wed, 22 Jul 2009 21:01:01 -0300
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090626)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] irq: Add compiling definition of irq_thread_check_affinity
 for !CONFIG_SMP
References: <alpine.LFD.2.00.0907221655130.2813@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0907221655130.2813@localhost.localdomain>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The addition and use of irq_thread_check_affinity neglected the fact
that struct irq_desc does not have an affinity member when CONFIG_SMP=n.

Fix this by adding an empty definition of the method for !SMP.

Signed-off-by: Kevin Winchester <kjwinchester@gmail.com>
---

I'll try not to be lazy and send a real patch.  Please let me know if
I've done it wrong.

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index f0de36f..82f01c8 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -190,11 +190,46 @@ int irq_select_affinity_usr(unsigned int irq)
 	return ret;
 }
 
+/*
+ * Check whether we need to change the affinity of the interrupt thread.
+ */
+static void
+irq_thread_check_affinity(struct irq_desc *desc, struct irqaction *action)
+{
+	cpumask_var_t mask;
+
+	if (!test_and_clear_bit(IRQTF_AFFINITY, &action->thread_flags))
+		return;
+
+	/*
+	 * In case we are out of memory we set IRQTF_AFFINITY again and
+	 * try again next time
+	 */
+	if (!alloc_cpumask_var(&mask, GFP_KERNEL)) {
+		set_bit(IRQTF_AFFINITY, &action->thread_flags);
+		return;
+	}
+
+	spin_lock_irq(&desc->lock);
+	cpumask_copy(mask, desc->affinity);
+	spin_unlock_irq(&desc->lock);
+
+	set_cpus_allowed_ptr(current, mask);
+	free_cpumask_var(mask);
+}
+
 #else
+
 static inline int setup_affinity(unsigned int irq, struct irq_desc *desc)
 {
 	return 0;
 }
+
+static void
+irq_thread_check_affinity(struct irq_desc *desc, struct irqaction *action)
+{
+}
+
 #endif
 
 void __disable_irq(struct irq_desc *desc, unsigned int irq, bool suspend)
@@ -452,34 +487,6 @@ static int irq_wait_for_interrupt(struct irqaction *action)
 }
 
 /*
- * Check whether we need to change the affinity of the interrupt thread.
- */
-static void
-irq_thread_check_affinity(struct irq_desc *desc, struct irqaction *action)
-{
-	cpumask_var_t mask;
-
-	if (!test_and_clear_bit(IRQTF_AFFINITY, &action->thread_flags))
-		return;
-
-	/*
-	 * In case we are out of memory we set IRQTF_AFFINITY again and
-	 * try again next time
-	 */
-	if (!alloc_cpumask_var(&mask, GFP_KERNEL)) {
-		set_bit(IRQTF_AFFINITY, &action->thread_flags);
-		return;
-	}
-
-	spin_lock_irq(&desc->lock);
-	cpumask_copy(mask, desc->affinity);
-	spin_unlock_irq(&desc->lock);
-
-	set_cpus_allowed_ptr(current, mask);
-	free_cpumask_var(mask);
-}
-
-/*
  * Interrupt handler thread
  */
 static int irq_thread(void *data)

