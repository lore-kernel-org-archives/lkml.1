Return-Path: <linux-kernel-owner+w=401wt.eu-S1753375AbZGVUay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375AbZGVUay (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 16:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753235AbZGVUay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 16:30:54 -0400
Received: from ppp-152-89.adsl.restena.lu ([158.64.152.89]:56620 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbZGVUax convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 16:30:53 -0400
X-Greylist: delayed 486 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Jul 2009 16:30:52 EDT
Date: Wed, 22 Jul 2009 22:22:32 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [Patch] Fix compile failure after genirq: Delegate irq affinity
 setting to the irq thread
Message-ID: <20090722222232.2eb3e1c4@neptune.home>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since genirq: Delegate irq affinity setting to the irq thread
(591d2fb02ea80472d846c0b8507007806bdd69cc) compilation with
CONFIG_SMP=n fails with following error:

/usr/src/linux-2.6/kernel/irq/manage.c:
   In function 'irq_thread_check_affinity':
/usr/src/linux-2.6/kernel/irq/manage.c:475:
   error: 'struct irq_desc' has no member named 'affinity'
make[4]: *** [kernel/irq/manage.o] Error 1

That commit adds a new function irq_thread_check_affinity() which
uses struct irq_desc.affinity which is only available for CONFIG_SMP=y.
Move that function under #ifdef CONFIG_SMP.

Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
---
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index f0de36f..576638d 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -451,6 +451,7 @@ static int irq_wait_for_interrupt(struct irqaction *action)
 	return -1;
 }
 
+#ifdef CONFIG_SMP
 /*
  * Check whether we need to change the affinity of the interrupt thread.
  */
@@ -478,6 +479,12 @@ irq_thread_check_affinity(struct irq_desc *desc, struct irqaction *action)
 	set_cpus_allowed_ptr(current, mask);
 	free_cpumask_var(mask);
 }
+#else
+static inline void
+irq_thread_check_affinity(struct irq_desc *desc, struct irqaction
*action) +{
+}
+#endif
 
 /*
  * Interrupt handler thread


---
Alternative patch which moves the new function irq_thread_check_affinity()
around so it is covered by already existing #ifdef CONFIG_SMP.
---
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index f0de36f..acf7922 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -190,11 +190,44 @@ int irq_select_affinity_usr(unsigned int irq)
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
 static inline int setup_affinity(unsigned int irq, struct irq_desc *desc)
 {
 	return 0;
 }
+
+static inline void
+irq_thread_check_affinity(struct irq_desc *desc, struct irqaction *action)
+{
+}
 #endif
 
 void __disable_irq(struct irq_desc *desc, unsigned int irq, bool suspend)
@@ -452,34 +485,6 @@ static int irq_wait_for_interrupt(struct irqaction *action)
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
