Return-Path: <linux-kernel-owner+w=401wt.eu-S1756829AbYHXJI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829AbYHXJI3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 05:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753171AbYHXJDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 05:03:24 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:51456 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903AbYHXJDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 05:03:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=EOtinQgygV0jxPNSgSsQAO9vPpitbr9zTeE+Nl/mPYYHaTCggKefSrWm1zHAGKZdII
         2AExzygmZaYpga7qIaRBB+AKSxGejq4kk+64TPAXNieMW10CS/WxDKs/WDCoy8oaEFsm
         SQqs/WsDANXeVYGaaqA5ibVetrba3sgIqe3Co=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 15/18] x86: apic unify smp_spurious/error_interrupt
Date: Sun, 24 Aug 2008 02:01:53 -0700
Message-Id: <1219568516-681-16-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1219568516-681-1-git-send-email-yhlu.kernel@gmail.com>
References: <1219568516-681-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/apic_32.c |   24 +++++++++++++++++++++---
 arch/x86/kernel/apic_64.c |   24 ++++++++++++++++++++++--
 2 files changed, 43 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index 749adb5..d357038 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -1474,10 +1474,17 @@ int __init APIC_init_uniprocessor(void)
 /*
  * This interrupt should _never_ happen with our APIC/SMP architecture
  */
+#ifdef CONFIG_X86_64
+asmlinkage void smp_spurious_interrupt(void)
+#else
 void smp_spurious_interrupt(struct pt_regs *regs)
+#endif
 {
-	unsigned long v;
+	u32 v;
 
+#ifdef CONFIG_X86_64
+	exit_idle();
+#endif
 	irq_enter();
 	/*
 	 * Check if this really is a spurious interrupt and ACK it
@@ -1488,20 +1495,31 @@ void smp_spurious_interrupt(struct pt_regs *regs)
 	if (v & (1 << (SPURIOUS_APIC_VECTOR & 0x1f)))
 		ack_APIC_irq();
 
+#ifdef CONFIG_X86_64
+	add_pda(irq_spurious_count, 1);
+#else
 	/* see sw-dev-man vol 3, chapter 7.4.13.5 */
 	printk(KERN_INFO "spurious APIC interrupt on CPU#%d, "
 	       "should never happen.\n", smp_processor_id());
 	__get_cpu_var(irq_stat).irq_spurious_count++;
+#endif
 	irq_exit();
 }
 
 /*
  * This interrupt should never happen with our APIC/SMP architecture
  */
+#ifdef CONFIG_X86_64
+asmlinkage void smp_error_interrupt(void)
+#else
 void smp_error_interrupt(struct pt_regs *regs)
+#endif
 {
-	unsigned long v, v1;
+	u32 v, v1;
 
+#ifdef CONFIG_X86_64
+	exit_idle();
+#endif
 	irq_enter();
 	/* First tickle the hardware, only then report what went on. -- REW */
 	v = apic_read(APIC_ESR);
@@ -1520,7 +1538,7 @@ void smp_error_interrupt(struct pt_regs *regs)
 	   6: Received illegal vector
 	   7: Illegal register address
 	*/
-	printk(KERN_DEBUG "APIC error on CPU%d: %02lx(%02lx)\n",
+	printk(KERN_DEBUG "APIC error on CPU%d: %02x(%02x)\n",
 		smp_processor_id(), v , v1);
 	irq_exit();
 }
diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index ebe417b..c728885 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -1528,10 +1528,17 @@ int __init APIC_init_uniprocessor(void)
 /*
  * This interrupt should _never_ happen with our APIC/SMP architecture
  */
+#ifdef CONFIG_X86_64
 asmlinkage void smp_spurious_interrupt(void)
+#else
+void smp_spurious_interrupt(struct pt_regs *regs)
+#endif
 {
-	unsigned int v;
+	u32 v;
+
+#ifdef CONFIG_X86_64
 	exit_idle();
+#endif
 	irq_enter();
 	/*
 	 * Check if this really is a spurious interrupt and ACK it
@@ -1542,18 +1549,31 @@ asmlinkage void smp_spurious_interrupt(void)
 	if (v & (1 << (SPURIOUS_APIC_VECTOR & 0x1f)))
 		ack_APIC_irq();
 
+#ifdef CONFIG_X86_64
 	add_pda(irq_spurious_count, 1);
+#else
+	/* see sw-dev-man vol 3, chapter 7.4.13.5 */
+	printk(KERN_INFO "spurious APIC interrupt on CPU#%d, "
+	       "should never happen.\n", smp_processor_id());
+	__get_cpu_var(irq_stat).irq_spurious_count++;
+#endif
 	irq_exit();
 }
 
 /*
  * This interrupt should never happen with our APIC/SMP architecture
  */
+#ifdef CONFIG_X86_64
 asmlinkage void smp_error_interrupt(void)
+#else
+void smp_error_interrupt(struct pt_regs *regs)
+#endif
 {
-	unsigned int v, v1;
+	u32 v, v1;
 
+#ifdef CONFIG_X86_64
 	exit_idle();
+#endif
 	irq_enter();
 	/* First tickle the hardware, only then report what went on. -- REW */
 	v = apic_read(APIC_ESR);
-- 
1.5.4.5

