Return-Path: <linux-kernel-owner+w=401wt.eu-S1755873AbZKBQRo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873AbZKBQRo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 11:17:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755393AbZKBQRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 11:17:42 -0500
Received: from hera.kernel.org ([140.211.167.34]:53629 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755797AbZKBQRj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 11:17:39 -0500
Date: Mon, 2 Nov 2009 16:16:40 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       ebiederm@xmission.com, garyhade@us.ibm.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       ebiederm@xmission.com, garyhade@us.ibm.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091026230001.562512739@sbs-t61.sc.intel.com>
References: <20091026230001.562512739@sbs-t61.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86: Unify fixup_irqs() for 32-bit and 64-bit kernels
Message-ID: <tip-7a7732bc0f7c46f217dbec723f25366b6285cc42@git.kernel.org>
Git-Commit-ID: 7a7732bc0f7c46f217dbec723f25366b6285cc42
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7a7732bc0f7c46f217dbec723f25366b6285cc42
Gitweb:     http://git.kernel.org/tip/7a7732bc0f7c46f217dbec723f25366b6285cc42
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Mon, 26 Oct 2009 14:24:31 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 2 Nov 2009 15:56:34 +0100

x86: Unify fixup_irqs() for 32-bit and 64-bit kernels

There is no reason to have different fixup_irqs() for 32-bit and
64-bit kernels. Unify by using the superior 64-bit version for
both the kernels.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Gary Hade <garyhade@us.ibm.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
LKML-Reference: <20091026230001.562512739@sbs-t61.sc.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/irq.c    |   59 ++++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/irq_32.c |   45 -----------------------------------
 arch/x86/kernel/irq_64.c |   58 ---------------------------------------------
 3 files changed, 59 insertions(+), 103 deletions(-)

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 3912061..3ea6655 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -276,3 +276,62 @@ void smp_generic_interrupt(struct pt_regs *regs)
 }
 
 EXPORT_SYMBOL_GPL(vector_used_by_percpu_irq);
+
+#ifdef CONFIG_HOTPLUG_CPU
+/* A cpu has been removed from cpu_online_mask.  Reset irq affinities. */
+void fixup_irqs(void)
+{
+	unsigned int irq;
+	static int warned;
+	struct irq_desc *desc;
+
+	for_each_irq_desc(irq, desc) {
+		int break_affinity = 0;
+		int set_affinity = 1;
+		const struct cpumask *affinity;
+
+		if (!desc)
+			continue;
+		if (irq == 2)
+			continue;
+
+		/* interrupt's are disabled at this point */
+		spin_lock(&desc->lock);
+
+		affinity = desc->affinity;
+		if (!irq_has_action(irq) ||
+		    cpumask_equal(affinity, cpu_online_mask)) {
+			spin_unlock(&desc->lock);
+			continue;
+		}
+
+		if (cpumask_any_and(affinity, cpu_online_mask) >= nr_cpu_ids) {
+			break_affinity = 1;
+			affinity = cpu_all_mask;
+		}
+
+		if (desc->chip->mask)
+			desc->chip->mask(irq);
+
+		if (desc->chip->set_affinity)
+			desc->chip->set_affinity(irq, affinity);
+		else if (!(warned++))
+			set_affinity = 0;
+
+		if (desc->chip->unmask)
+			desc->chip->unmask(irq);
+
+		spin_unlock(&desc->lock);
+
+		if (break_affinity && set_affinity)
+			printk("Broke affinity for irq %i\n", irq);
+		else if (!set_affinity)
+			printk("Cannot set affinity for irq %i\n", irq);
+	}
+
+	/* That doesn't seem sufficient.  Give it 1ms. */
+	local_irq_enable();
+	mdelay(1);
+	local_irq_disable();
+}
+#endif
diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index 7d35d0f..10709f2 100644
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -211,48 +211,3 @@ bool handle_irq(unsigned irq, struct pt_regs *regs)
 
 	return true;
 }
-
-#ifdef CONFIG_HOTPLUG_CPU
-
-/* A cpu has been removed from cpu_online_mask.  Reset irq affinities. */
-void fixup_irqs(void)
-{
-	unsigned int irq;
-	struct irq_desc *desc;
-
-	for_each_irq_desc(irq, desc) {
-		const struct cpumask *affinity;
-
-		if (!desc)
-			continue;
-		if (irq == 2)
-			continue;
-
-		affinity = desc->affinity;
-		if (cpumask_any_and(affinity, cpu_online_mask) >= nr_cpu_ids) {
-			printk("Breaking affinity for irq %i\n", irq);
-			affinity = cpu_all_mask;
-		}
-		if (desc->chip->set_affinity)
-			desc->chip->set_affinity(irq, affinity);
-		else if (desc->action)
-			printk_once("Cannot set affinity for irq %i\n", irq);
-	}
-
-#if 0
-	barrier();
-	/* Ingo Molnar says: "after the IO-APIC masks have been redirected
-	   [note the nop - the interrupt-enable boundary on x86 is two
-	   instructions from sti] - to flush out pending hardirqs and
-	   IPIs. After this point nothing is supposed to reach this CPU." */
-	__asm__ __volatile__("sti; nop; cli");
-	barrier();
-#else
-	/* That doesn't seem sufficient.  Give it 1ms. */
-	local_irq_enable();
-	mdelay(1);
-	local_irq_disable();
-#endif
-}
-#endif
-
diff --git a/arch/x86/kernel/irq_64.c b/arch/x86/kernel/irq_64.c
index 977d8b4..acf8fbf 100644
--- a/arch/x86/kernel/irq_64.c
+++ b/arch/x86/kernel/irq_64.c
@@ -62,64 +62,6 @@ bool handle_irq(unsigned irq, struct pt_regs *regs)
 	return true;
 }
 
-#ifdef CONFIG_HOTPLUG_CPU
-/* A cpu has been removed from cpu_online_mask.  Reset irq affinities. */
-void fixup_irqs(void)
-{
-	unsigned int irq;
-	static int warned;
-	struct irq_desc *desc;
-
-	for_each_irq_desc(irq, desc) {
-		int break_affinity = 0;
-		int set_affinity = 1;
-		const struct cpumask *affinity;
-
-		if (!desc)
-			continue;
-		if (irq == 2)
-			continue;
-
-		/* interrupt's are disabled at this point */
-		spin_lock(&desc->lock);
-
-		affinity = desc->affinity;
-		if (!irq_has_action(irq) ||
-		    cpumask_equal(affinity, cpu_online_mask)) {
-			spin_unlock(&desc->lock);
-			continue;
-		}
-
-		if (cpumask_any_and(affinity, cpu_online_mask) >= nr_cpu_ids) {
-			break_affinity = 1;
-			affinity = cpu_all_mask;
-		}
-
-		if (desc->chip->mask)
-			desc->chip->mask(irq);
-
-		if (desc->chip->set_affinity)
-			desc->chip->set_affinity(irq, affinity);
-		else if (!(warned++))
-			set_affinity = 0;
-
-		if (desc->chip->unmask)
-			desc->chip->unmask(irq);
-
-		spin_unlock(&desc->lock);
-
-		if (break_affinity && set_affinity)
-			printk("Broke affinity for irq %i\n", irq);
-		else if (!set_affinity)
-			printk("Cannot set affinity for irq %i\n", irq);
-	}
-
-	/* That doesn't seem sufficient.  Give it 1ms. */
-	local_irq_enable();
-	mdelay(1);
-	local_irq_disable();
-}
-#endif
 
 extern void call_softirq(void);
 
