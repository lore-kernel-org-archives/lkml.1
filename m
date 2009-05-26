Return-Path: <linux-kernel-owner+w=401wt.eu-S1757671AbZEZX53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757671AbZEZX53 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 19:57:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756193AbZEZXyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:54:50 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38595 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754721AbZEZXyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:54:44 -0400
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, hpa@zytor.com, x86@kernel.org
Cc: Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 11/31] x86: MCE: Implement bootstrapping for machine check wakeups
Date: Wed, 27 May 2009 01:54:13 +0200
Message-Id: <34082fc262bae2f910f1a940622173445aea72cd.1243381848.git.ak@linux.intel.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <3e29698799ad2c02429613323897a6e61a0a7d01.1243381848.git.ak@linux.intel.com>
References: <1243382073-29338-1-git-send-email-andi@firstfloor.org>
 <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
 <c1d7bf910168f07efb50d98f901f41e289a87f1f.1243381848.git.ak@linux.intel.com>
 <6c6d1f8bbbd2312884dca5a5c75aa5f5a87dae4b.1243381848.git.ak@linux.intel.com>
 <1623cd9a1c77d35fc2044d72c4bfa1246e67a1c0.1243381848.git.ak@linux.intel.com>
 <723b3fe4e35063b123cee9658c24267287eeac07.1243381848.git.ak@linux.intel.com>
 <0301db6d6dabb8bcfaffe76a907a5036646c207d.1243381848.git.ak@linux.intel.com>
 <abf61c300dec40b8e93bb5ae7154a0633c682799.1243381848.git.ak@linux.intel.com>
 <23417423c34ad949f53ebc947af8d18672a79a40.1243381848.git.ak@linux.intel.com>
 <347567c2ace55b336b1a43a67323ff8b86b80243.1243381848.git.ak@linux.intel.com>
 <3e29698799ad2c02429613323897a6e61a0a7d01.1243381848.git.ak@linux.intel.com>
In-Reply-To: <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
References: <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

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
 arch/x86/include/asm/hw_irq.h      |    1 +
 arch/x86/include/asm/irq_vectors.h |    5 +++
 arch/x86/kernel/cpu/mcheck/mce.c   |   52 ++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/entry_64.S         |    5 +++
 arch/x86/kernel/irqinit_64.c       |    4 +++
 5 files changed, 67 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index 5498db6..f07814a 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -32,6 +32,7 @@ extern void error_interrupt(void);
 extern void spurious_interrupt(void);
 extern void thermal_interrupt(void);
 extern void reschedule_interrupt(void);
+extern void mce_self_interrupt(void);
 
 extern void invalidate_interrupt(void);
 extern void invalidate_interrupt0(void);
diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index b83991d..61f1592 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -116,6 +116,11 @@
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
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 1ce7b55..6219a18 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -7,6 +7,7 @@
  * Author: Andi Kleen
  */
 
+#include <linux/interrupt.h>
 #include <linux/thread_info.h>
 #include <linux/capability.h>
 #include <linux/miscdevice.h>
@@ -36,6 +37,9 @@
 #include <asm/mce.h>
 #include <asm/msr.h>
 #include <asm/smp.h>
+#include <asm/ipi.h>
+#include <asm/hw_irq.h>
+#include <asm/apic.h>
 
 #include "mce.h"
 
@@ -266,6 +270,52 @@ static inline void mce_get_rip(struct mce *m, struct pt_regs *regs)
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
@@ -498,6 +548,8 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 	/* notify userspace ASAP */
 	set_thread_flag(TIF_MCE_NOTIFY);
 
+	mce_report_event(regs);
+
 	/* the last thing we do is clear state */
 	for (i = 0; i < banks; i++) {
 		if (test_bit(i, toclear))
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index bb835c9..4234b12 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1013,6 +1013,11 @@ apicinterrupt THRESHOLD_APIC_VECTOR \
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
diff --git a/arch/x86/kernel/irqinit_64.c b/arch/x86/kernel/irqinit_64.c
index f965749..265eeb4 100644
--- a/arch/x86/kernel/irqinit_64.c
+++ b/arch/x86/kernel/irqinit_64.c
@@ -155,6 +155,10 @@ static void __init apic_intr_init(void)
 	/* IPI vectors for APIC spurious and error interrupts */
 	alloc_intr_gate(SPURIOUS_APIC_VECTOR, spurious_interrupt);
 	alloc_intr_gate(ERROR_APIC_VECTOR, error_interrupt);
+
+#ifdef CONFIG_X86_MCE
+	alloc_intr_gate(MCE_SELF_VECTOR, mce_self_interrupt);
+#endif
 }
 
 void __init native_init_IRQ(void)
-- 
1.6.0.2

