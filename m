Return-Path: <linux-kernel-owner+w=401wt.eu-S1754541AbYJCUAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541AbYJCUAi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 16:00:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753069AbYJCUAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 16:00:06 -0400
Received: from m-relay2.rz.uni-saarland.de ([134.96.7.8]:24638 "EHLO
	eris.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943AbYJCUAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 16:00:04 -0400
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH 1/9] traps: x86: converge trap_init functions
Date: Fri,  3 Oct 2008 22:00:32 +0200
Message-Id: <1223064040-23170-2-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1223064040-23170-1-git-send-email-heukelum@fastmail.fm>
References: <1223064040-23170-1-git-send-email-heukelum@fastmail.fm>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (eris.rz.uni-saarland.de [134.96.7.8]); Fri, 03 Oct 2008 21:59:43 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.8.1.34; VDF: 7.0.6.242; host: AntiVir2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 - set_system_gate on i386 is really set_system_trap_gate
 - set_system_gate on x86_64 is really set_system_intr_gate
 - ist=0 means no special stack switch is done:
	- introduce STACKFAULT_STACK, DOUBLEFAULT_STACK, NMI_STACK,
		DEBUG_STACK and MCE_STACK as on x86_64.
	- use the _ist variants with XXX_STACK set to zero
 - remove set_system_gate

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
---
 arch/x86/kernel/traps_32.c |   16 +++++++++-------
 arch/x86/kernel/traps_64.c |    6 +++---
 include/asm-x86/desc.h     |   14 +++++---------
 include/asm-x86/page_32.h  |    6 ++++++
 4 files changed, 23 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index da97cd2..c17fcc8 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -852,10 +852,12 @@ void __init trap_init(void)
 #endif
 
 	set_intr_gate(0, &divide_error);
-	set_intr_gate(1, &debug);
-	set_intr_gate(2, &nmi);
-	set_system_intr_gate(3, &int3); /* int3 can be called from all */
-	set_system_intr_gate(4, &overflow); /* int4 can be called from all */
+	set_intr_gate_ist(1, &debug, DEBUG_STACK);
+	set_intr_gate_ist(2, &nmi, NMI_STACK);
+	/* int3 can be called from all */
+	set_system_intr_gate_ist(3, &int3, DEBUG_STACK);
+	/* int4 can be called from all */
+	set_system_intr_gate(4, &overflow);
 	set_intr_gate(5, &bounds);
 	set_intr_gate(6, &invalid_op);
 	set_intr_gate(7, &device_not_available);
@@ -863,14 +865,14 @@ void __init trap_init(void)
 	set_intr_gate(9, &coprocessor_segment_overrun);
 	set_intr_gate(10, &invalid_TSS);
 	set_intr_gate(11, &segment_not_present);
-	set_intr_gate(12, &stack_segment);
+	set_intr_gate_ist(12, &stack_segment, STACKFAULT_STACK);
 	set_intr_gate(13, &general_protection);
 	set_intr_gate(14, &page_fault);
 	set_intr_gate(15, &spurious_interrupt_bug);
 	set_intr_gate(16, &coprocessor_error);
 	set_intr_gate(17, &alignment_check);
 #ifdef CONFIG_X86_MCE
-	set_intr_gate(18, &machine_check);
+	set_intr_gate_ist(18, &machine_check, MCE_STACK);
 #endif
 	set_intr_gate(19, &simd_coprocessor_error);
 
@@ -886,7 +888,7 @@ void __init trap_init(void)
 		printk("done.\n");
 	}
 
-	set_system_gate(SYSCALL_VECTOR, &system_call);
+	set_system_trap_gate(SYSCALL_VECTOR, &system_call);
 
 	/* Reserve all the builtin and the syscall vector: */
 	for (i = 0; i < FIRST_EXTERNAL_VECTOR; i++)
diff --git a/arch/x86/kernel/traps_64.c b/arch/x86/kernel/traps_64.c
index 80dbbc7..8cf590b 100644
--- a/arch/x86/kernel/traps_64.c
+++ b/arch/x86/kernel/traps_64.c
@@ -652,9 +652,9 @@ void __init trap_init(void)
 	set_intr_gate_ist(1, &debug, DEBUG_STACK);
 	set_intr_gate_ist(2, &nmi, NMI_STACK);
 	/* int3 can be called from all */
-	set_system_gate_ist(3, &int3, DEBUG_STACK);
+	set_system_intr_gate_ist(3, &int3, DEBUG_STACK);
 	/* int4 can be called from all */
-	set_system_gate(4, &overflow);
+	set_system_intr_gate(4, &overflow);
 	set_intr_gate(5, &bounds);
 	set_intr_gate(6, &invalid_op);
 	set_intr_gate(7, &device_not_available);
@@ -674,7 +674,7 @@ void __init trap_init(void)
 	set_intr_gate(19, &simd_coprocessor_error);
 
 #ifdef CONFIG_IA32_EMULATION
-	set_system_gate(IA32_SYSCALL_VECTOR, ia32_syscall);
+	set_system_intr_gate(IA32_SYSCALL_VECTOR, ia32_syscall);
 #endif
 	/*
 	 * Should be a barrier for any external CPU state:
diff --git a/include/asm-x86/desc.h b/include/asm-x86/desc.h
index ebc3078..168c5cc 100644
--- a/include/asm-x86/desc.h
+++ b/include/asm-x86/desc.h
@@ -351,20 +351,16 @@ static inline void set_system_intr_gate(unsigned int n, void *addr)
 	_set_gate(n, GATE_INTERRUPT, addr, 0x3, 0, __KERNEL_CS);
 }
 
-static inline void set_trap_gate(unsigned int n, void *addr)
+static inline void set_system_trap_gate(unsigned int n, void *addr)
 {
 	BUG_ON((unsigned)n > 0xFF);
-	_set_gate(n, GATE_TRAP, addr, 0, 0, __KERNEL_CS);
+	_set_gate(n, GATE_INTERRUPT, addr, 0x3, 0, __KERNEL_CS);
 }
 
-static inline void set_system_gate(unsigned int n, void *addr)
+static inline void set_trap_gate(unsigned int n, void *addr)
 {
 	BUG_ON((unsigned)n > 0xFF);
-#ifdef CONFIG_X86_32
-	_set_gate(n, GATE_TRAP, addr, 0x3, 0, __KERNEL_CS);
-#else
-	_set_gate(n, GATE_INTERRUPT, addr, 0x3, 0, __KERNEL_CS);
-#endif
+	_set_gate(n, GATE_TRAP, addr, 0, 0, __KERNEL_CS);
 }
 
 static inline void set_task_gate(unsigned int n, unsigned int gdt_entry)
@@ -379,7 +375,7 @@ static inline void set_intr_gate_ist(int n, void *addr, unsigned ist)
 	_set_gate(n, GATE_INTERRUPT, addr, 0, ist, __KERNEL_CS);
 }
 
-static inline void set_system_gate_ist(int n, void *addr, unsigned ist)
+static inline void set_system_intr_gate_ist(int n, void *addr, unsigned ist)
 {
 	BUG_ON((unsigned)n > 0xFF);
 	_set_gate(n, GATE_INTERRUPT, addr, 0x3, ist, __KERNEL_CS);
diff --git a/include/asm-x86/page_32.h b/include/asm-x86/page_32.h
index 82b0109..fd33556 100644
--- a/include/asm-x86/page_32.h
+++ b/include/asm-x86/page_32.h
@@ -20,6 +20,12 @@
 #endif
 #define THREAD_SIZE 	(PAGE_SIZE << THREAD_ORDER)
 
+#define STACKFAULT_STACK 0
+#define DOUBLEFAULT_STACK 1
+#define NMI_STACK 0
+#define DEBUG_STACK 0
+#define MCE_STACK 0
+#define N_EXCEPTION_STACKS 1
 
 #ifdef CONFIG_X86_PAE
 /* 44=32+12, the limit we can fit into an unsigned long pfn */
-- 
1.5.4.3

