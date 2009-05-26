Return-Path: <linux-kernel-owner+w=401wt.eu-S1759286AbZEZX4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759286AbZEZX4x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 19:56:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756118AbZEZXys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:54:48 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38596 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755577AbZEZXyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:54:43 -0400
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, hpa@zytor.com, x86@kernel.org
Cc: Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 06/31] x86: Fix panic with interrupts off (needed for MCE)
Date: Wed, 27 May 2009 01:54:08 +0200
Message-Id: <0301db6d6dabb8bcfaffe76a907a5036646c207d.1243381848.git.ak@linux.intel.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <723b3fe4e35063b123cee9658c24267287eeac07.1243381848.git.ak@linux.intel.com>
References: <1243382073-29338-1-git-send-email-andi@firstfloor.org>
 <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
 <c1d7bf910168f07efb50d98f901f41e289a87f1f.1243381848.git.ak@linux.intel.com>
 <6c6d1f8bbbd2312884dca5a5c75aa5f5a87dae4b.1243381848.git.ak@linux.intel.com>
 <1623cd9a1c77d35fc2044d72c4bfa1246e67a1c0.1243381848.git.ak@linux.intel.com>
 <723b3fe4e35063b123cee9658c24267287eeac07.1243381848.git.ak@linux.intel.com>
In-Reply-To: <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
References: <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Impact: bug fix, fixes an old regression

For some time each panic() called with interrupts disabled triggered the
!irqs_disabled() WARN_ON in smp_call_function(), producing ugly
backtraces and confusing users.

This is a common situation with machine checks for example which tend
to call panic with interrupts disabled, but will also hit
in other situations e.g. panic during early boot. In fact
it means that panic cannot be called in many circumstances, which
would be bad.

This all started with the new fancy queued smp_call_function,
which is then used by the shutdown path to shut down the other CPUs.

On closer examination it turned out that the fancy RCU
smp_call_function() does lots of things not suitable in a panic
situation anyways, like allocating memory and relying on complex system
state.

I originally tried to patch this over by checking for panic
there, but it was quite complicated and the original patch
was also not very popular. This also didn't fix some
of the underlying complexity problems.

The new code in post 2.6.29 tries to patch around this by
checking for oops_in_progress, but that is not enough to make
this fully safe and I don't think that's a real solution
because panic has to be reliable.

So instead use an own vector to reboot. This makes the reboot code
extremly straight forward, which is definitely a big plus
in a panic situation where it is important to avoid relying
on too much kernel state. The new simple code is also
safe to be called from interupts off region because it is
very very simple.

There can be situations where it is important that panic
is reliable. For example on a fatal machine check the panic
is needed to get the system up again and running as quickly
as possible. So it's important that panic is reliable and
all function it calls simple.

This is why I came up with this simple vector scheme.
It's very hard to beat in simplicity.  Vectors are not
particularly precious anymore since all big systems
are using per CPU vectors.

Another possibility would have been to use an NMI similar
to kdump, but there is still the problem that NMIs don't
work reliably on some systems due to BIOS issues. NMIs
would have been able to stop CPUs running with interrupts
off too. In the sake of universal reliability I opted for
using a non NMI vector for now.

I put the reboot vector into the highest priority bucket
of the APIC vectors and moved the 64bit UV_BAU message
down instead into the next lower priority.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/entry_arch.h  |    1 +
 arch/x86/include/asm/hw_irq.h      |    1 +
 arch/x86/include/asm/irq_vectors.h |    8 +++-----
 arch/x86/kernel/entry_64.S         |    2 ++
 arch/x86/kernel/irqinit_32.c       |    3 +++
 arch/x86/kernel/irqinit_64.c       |    3 +++
 arch/x86/kernel/smp.c              |   28 +++++++++++++++++++++++++++-
 7 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/entry_arch.h b/arch/x86/include/asm/entry_arch.h
index b2eb9c0..b884dcd 100644
--- a/arch/x86/include/asm/entry_arch.h
+++ b/arch/x86/include/asm/entry_arch.h
@@ -14,6 +14,7 @@ BUILD_INTERRUPT(reschedule_interrupt,RESCHEDULE_VECTOR)
 BUILD_INTERRUPT(call_function_interrupt,CALL_FUNCTION_VECTOR)
 BUILD_INTERRUPT(call_function_single_interrupt,CALL_FUNCTION_SINGLE_VECTOR)
 BUILD_INTERRUPT(irq_move_cleanup_interrupt,IRQ_MOVE_CLEANUP_VECTOR)
+BUILD_INTERRUPT(reboot_interrupt,REBOOT_VECTOR)
 
 BUILD_INTERRUPT3(invalidate_interrupt0,INVALIDATE_TLB_VECTOR_START+0,
 		 smp_invalidate_interrupt)
diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index b762ea4..5498db6 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -44,6 +44,7 @@ extern void invalidate_interrupt6(void);
 extern void invalidate_interrupt7(void);
 
 extern void irq_move_cleanup_interrupt(void);
+extern void reboot_interrupt(void);
 extern void threshold_interrupt(void);
 
 extern void call_function_interrupt(void);
diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index 451e24d..b83991d 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -89,11 +89,7 @@
 
 #define THRESHOLD_APIC_VECTOR		0xf9
 
-#ifdef CONFIG_X86_32
-/* 0xf9 : free */
-#else
-# define UV_BAU_MESSAGE			0xf8
-#endif
+#define REBOOT_VECTOR			0xf8
 
 /* f0-f7 used for spreading out TLB flushes: */
 #define INVALIDATE_TLB_VECTOR_END	0xf7
@@ -117,6 +113,8 @@
  */
 #define GENERIC_INTERRUPT_VECTOR	0xed
 
+#define UV_BAU_MESSAGE			0xec
+
 /*
  * First APIC vector available to drivers: (vectors 0x30-0xee) we
  * start at 0x31(0x41) to spread out vectors evenly between priority
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index a31a7f2..bb835c9 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -976,6 +976,8 @@ END(\sym)
 #ifdef CONFIG_SMP
 apicinterrupt IRQ_MOVE_CLEANUP_VECTOR \
 	irq_move_cleanup_interrupt smp_irq_move_cleanup_interrupt
+apicinterrupt REBOOT_VECTOR \
+	reboot_interrupt smp_reboot_interrupt
 #endif
 
 #ifdef CONFIG_X86_UV
diff --git a/arch/x86/kernel/irqinit_32.c b/arch/x86/kernel/irqinit_32.c
index 2512ad9..d57f91a 100644
--- a/arch/x86/kernel/irqinit_32.c
+++ b/arch/x86/kernel/irqinit_32.c
@@ -167,6 +167,9 @@ void __init native_init_IRQ(void)
 	/* Low priority IPI to cleanup after moving an irq */
 	set_intr_gate(IRQ_MOVE_CLEANUP_VECTOR, irq_move_cleanup_interrupt);
 	set_bit(IRQ_MOVE_CLEANUP_VECTOR, used_vectors);
+
+	/* IPI used for rebooting/stopping */
+	alloc_intr_gate(REBOOT_VECTOR, reboot_interrupt);
 #endif
 
 #ifdef CONFIG_X86_LOCAL_APIC
diff --git a/arch/x86/kernel/irqinit_64.c b/arch/x86/kernel/irqinit_64.c
index 8cd1053..f965749 100644
--- a/arch/x86/kernel/irqinit_64.c
+++ b/arch/x86/kernel/irqinit_64.c
@@ -133,6 +133,9 @@ static void __init smp_intr_init(void)
 	/* Low priority IPI to cleanup after moving an irq */
 	set_intr_gate(IRQ_MOVE_CLEANUP_VECTOR, irq_move_cleanup_interrupt);
 	set_bit(IRQ_MOVE_CLEANUP_VECTOR, used_vectors);
+
+	/* IPI for rebooting/panicing */
+	alloc_intr_gate(REBOOT_VECTOR, reboot_interrupt);
 #endif
 }
 
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 13f33ea..8835783 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -150,14 +150,40 @@ void native_send_call_func_ipi(const struct cpumask *mask)
  * this function calls the 'stop' function on all other CPUs in the system.
  */
 
+asmlinkage void smp_reboot_interrupt(void)
+{
+	ack_APIC_irq();
+	irq_enter();
+	stop_this_cpu(NULL);
+	irq_exit();
+}
+
 static void native_smp_send_stop(void)
 {
 	unsigned long flags;
+	unsigned long wait;
 
 	if (reboot_force)
 		return;
 
-	smp_call_function(stop_this_cpu, NULL, 0);
+	/*
+	 * Use an own vector here because smp_call_function
+	 * does lots of things not suitable in a panic situation.
+	 * On most systems we could also use an NMI here,
+	 * but there are a few systems around where NMI
+	 * is problematic so stay with an non NMI for now
+	 * (this implies we cannot stop CPUs spinning with irq off
+	 * currently)
+	 */
+	if (num_online_cpus() > 1) {
+		apic->send_IPI_allbutself(REBOOT_VECTOR);
+
+		/* Don't wait longer than a second */
+		wait = USEC_PER_SEC;
+		while (num_online_cpus() > 1 && wait--)
+			udelay(1);
+	}
+
 	local_irq_save(flags);
 	disable_local_APIC();
 	local_irq_restore(flags);
-- 
1.6.0.2

