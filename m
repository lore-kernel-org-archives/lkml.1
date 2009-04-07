Return-Path: <linux-kernel-owner+w=401wt.eu-S1757777AbZDGPNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757777AbZDGPNs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 11:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758597AbZDGPH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 11:07:58 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48854 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758262AbZDGPH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 11:07:57 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20090407507.636692542@firstfloor.org>
In-Reply-To: <20090407507.636692542@firstfloor.org>
To: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Subject: [PATCH] [13/28] x86: MCE: Implement bootstrapping for machine check wakeups
Message-Id: <20090407150754.E02B81D046D@basil.firstfloor.org>
Date: Tue,  7 Apr 2009 17:07:54 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


machine checks support waking up the mcelog daemon quickly.

The original wake up code for this was pretty ugly, relying on 
a idle notifier and a special process flag. The reason it did
it this way is that the machine check handler is not subject
to normal interrupt locking rules so it's not safe
to call wake_up().  Instead it set a process flag 
and then either did the wakeup in the syscall return 
or in the idle notifier.

This patch adds a new "bootstraping" method as replacement.

The idea is that the handler checks if it's in a state where
it is unsafe to call wake_up(). If it's safe it calls it directly.
When it's not safe -- that is it interrupted in a critical
section with interrupts disables -- it uses a new "self IPI" to trigger 
an IPI to its own CPU. This can be done safely because IPI
triggers are atomic with some care. The IPI is raised
once the interrupts are reenabled and can then safely call
wake_up().

When APICs are disabled the event is just queued and will be picked up
eventually by the next polling timer. I think that's a reasonable
compromise, since it should only happen quite rarely.

Contains fixes from Ying Huang

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/include/asm/hw_irq.h       |    1 
 arch/x86/include/asm/irq_vectors.h  |    5 +++
 arch/x86/kernel/cpu/mcheck/mce_64.c |   52 ++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/entry_64.S          |    5 +++
 arch/x86/kernel/irqinit_64.c        |    4 ++
 5 files changed, 67 insertions(+)

Index: linux/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-04-07 16:09:59.000000000 +0200
+++ linux/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-04-07 16:43:12.000000000 +0200
@@ -7,6 +7,7 @@
  * Author: Andi Kleen
  */
 
+#include <linux/interrupt.h>
 #include <linux/init.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
@@ -35,6 +36,9 @@
 #include <asm/uaccess.h>
 #include <asm/smp.h>
 #include <asm/idle.h>
+#include <asm/ipi.h>
+#include <asm/hw_irq.h>
+#include <asm/apic.h>
 
 #define MISC_MCELOG_MINOR 227
 
@@ -188,6 +192,52 @@
 }
 
 /*
+ * Called after interrupts have been reenabled again
+ * when a MCE happened during an interrupts off region
+ * in the kernel.
+ */
+asmlinkage void smp_mce_self_interrupt(struct pt_regs *regs)
+{
+	ack_APIC_irq();
+	exit_idle();
+	irq_enter();
+	mce_notify_user();
+	irq_exit();
+}
+
+static void mce_report_event(struct pt_regs *regs)
+{
+	if (regs->flags & (X86_VM_MASK|X86_EFLAGS_IF)) {
+		mce_notify_user();
+		return;
+	}
+
+#ifdef CONFIG_X86_LOCAL_APIC
+	/*
+	 * Without APIC do not notify. The event will be picked
+	 * up eventually.
+	 */
+	if (!cpu_has_apic)
+		return;
+
+	/*
+	 * When interrupts are disabled we cannot use
+	 * kernel services safely. Trigger an self interrupt
+	 * through the APIC to instead do the notification
+	 * after interrupts are reenabled again.
+	 */
+	apic->send_IPI_self(MCE_SELF_VECTOR);
+
+	/*
+	 * Wait for idle afterwards again so that we don't leave the
+	 * APIC in a non idle state because the normal APIC writes
+	 * cannot exclude us.
+	 */
+	apic_wait_icr_idle();
+#endif
+}
+
+/*
  * Poll for corrected events or events that happened before reset.
  * Those are just logged through /dev/mcelog.
  *
@@ -412,6 +462,8 @@
 	/* notify userspace ASAP */
 	set_thread_flag(TIF_MCE_NOTIFY);
 
+	mce_report_event(regs);
+
 	/* the last thing we do is clear state */
 	for (i = 0; i < banks; i++) {
 		if (test_bit(i, toclear))
Index: linux/arch/x86/kernel/entry_64.S
===================================================================
--- linux.orig/arch/x86/kernel/entry_64.S	2009-04-07 16:09:58.000000000 +0200
+++ linux/arch/x86/kernel/entry_64.S	2009-04-07 16:09:59.000000000 +0200
@@ -1013,6 +1013,11 @@
 apicinterrupt THERMAL_APIC_VECTOR \
 	thermal_interrupt smp_thermal_interrupt
 
+#ifdef CONFIG_X86_MCE
+apicinterrupt MCE_SELF_VECTOR \
+	mce_self_interrupt smp_mce_self_interrupt
+#endif
+
 #ifdef CONFIG_SMP
 apicinterrupt CALL_FUNCTION_SINGLE_VECTOR \
 	call_function_single_interrupt smp_call_function_single_interrupt
Index: linux/arch/x86/include/asm/irq_vectors.h
===================================================================
--- linux.orig/arch/x86/include/asm/irq_vectors.h	2009-04-07 16:09:58.000000000 +0200
+++ linux/arch/x86/include/asm/irq_vectors.h	2009-04-07 16:43:04.000000000 +0200
@@ -121,6 +121,11 @@
 #define UV_BAU_MESSAGE			0xec
 
 /*
+ * Self IPI vector for machine checks
+ */
+#define MCE_SELF_VECTOR			0xeb
+
+/*
  * First APIC vector available to drivers: (vectors 0x30-0xee) we
  * start at 0x31(0x41) to spread out vectors evenly between priority
  * levels. (0x80 is the syscall vector)
Index: linux/arch/x86/include/asm/hw_irq.h
===================================================================
--- linux.orig/arch/x86/include/asm/hw_irq.h	2009-04-07 16:09:58.000000000 +0200
+++ linux/arch/x86/include/asm/hw_irq.h	2009-04-07 16:09:59.000000000 +0200
@@ -32,6 +32,7 @@
 extern void spurious_interrupt(void);
 extern void thermal_interrupt(void);
 extern void reschedule_interrupt(void);
+extern void mce_self_interrupt(void);
 
 extern void invalidate_interrupt(void);
 extern void invalidate_interrupt0(void);
Index: linux/arch/x86/kernel/irqinit_64.c
===================================================================
--- linux.orig/arch/x86/kernel/irqinit_64.c	2009-04-07 16:09:58.000000000 +0200
+++ linux/arch/x86/kernel/irqinit_64.c	2009-04-07 16:09:59.000000000 +0200
@@ -155,6 +155,10 @@
 	/* IPI vectors for APIC spurious and error interrupts */
 	alloc_intr_gate(SPURIOUS_APIC_VECTOR, spurious_interrupt);
 	alloc_intr_gate(ERROR_APIC_VECTOR, error_interrupt);
+
+#ifdef CONFIG_X86_MCE
+	alloc_intr_gate(MCE_SELF_VECTOR, mce_self_interrupt);
+#endif
 }
 
 void __init native_init_IRQ(void)
