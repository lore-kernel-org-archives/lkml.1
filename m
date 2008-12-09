Return-Path: <linux-kernel-owner+w=401wt.eu-S1753426AbYLIDTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426AbYLIDTT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 22:19:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751357AbYLIDTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 22:19:10 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:58994 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbYLIDTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 22:19:09 -0500
Message-ID: <493DE3AB.4090409@ct.jp.nec.com>
Date: Mon, 08 Dec 2008 19:19:07 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: kill #ifdef for exit_idle()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Impact: cleanup

Introduce helper incline function in arch/x86/include/asm/idle.h
to remove #ifdefs around exit_idle().

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/include/asm/idle.h |    5 +++++
 arch/x86/kernel/apic.c      |    6 ------
 arch/x86/kernel/io_apic.c   |    3 +--
 3 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/idle.h b/arch/x86/include/asm/idle.h
index 44c89c3..38d8737 100644
--- a/arch/x86/include/asm/idle.h
+++ b/arch/x86/include/asm/idle.h
@@ -8,8 +8,13 @@ struct notifier_block;
 void idle_notifier_register(struct notifier_block *n);
 void idle_notifier_unregister(struct notifier_block *n);
 
+#ifdef CONFIG_X86_64
 void enter_idle(void);
 void exit_idle(void);
+#else /* !CONFIG_X86_64 */
+static inline void enter_idle(void) { }
+static inline void exit_idle(void) { }
+#endif /* CONFIG_X86_64 */
 
 void c1e_remove_cpu(int cpu);
 
diff --git a/arch/x86/kernel/apic.c b/arch/x86/kernel/apic.c
index 02d64c9..91c4257 100644
--- a/arch/x86/kernel/apic.c
+++ b/arch/x86/kernel/apic.c
@@ -809,9 +809,7 @@ void smp_apic_timer_interrupt(struct pt_regs *regs)
 	 * Besides, if we don't timer interrupts ignore the global
 	 * interrupt lock, which is the WrongThing (tm) to do.
 	 */
-#ifdef CONFIG_X86_64
 	exit_idle();
-#endif
 	irq_enter();
 	local_apic_timer_interrupt();
 	irq_exit();
@@ -1670,9 +1668,7 @@ void smp_spurious_interrupt(struct pt_regs *regs)
 {
 	u32 v;
 
-#ifdef CONFIG_X86_64
 	exit_idle();
-#endif
 	irq_enter();
 	/*
 	 * Check if this really is a spurious interrupt and ACK it
@@ -1701,9 +1697,7 @@ void smp_error_interrupt(struct pt_regs *regs)
 {
 	u32 v, v1;
 
-#ifdef CONFIG_X86_64
 	exit_idle();
-#endif
 	irq_enter();
 	/* First tickle the hardware, only then report what went on. -- REW */
 	v = apic_read(APIC_ESR);
diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
index a1a2e07..23f3141 100644
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -2303,10 +2303,9 @@ static void set_ir_ioapic_affinity_irq(unsigned int irq, cpumask_t mask)
 asmlinkage void smp_irq_move_cleanup_interrupt(void)
 {
 	unsigned vector, me;
+
 	ack_APIC_irq();
-#ifdef CONFIG_X86_64
 	exit_idle();
-#endif
 	irq_enter();
 
 	me = smp_processor_id();
-- 
1.6.0.4

