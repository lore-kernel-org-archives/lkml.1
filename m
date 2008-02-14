Return-Path: <linux-kernel-owner+w=401wt.eu-S1763116AbYBNUBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763116AbYBNUBc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 15:01:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756128AbYBNUBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 15:01:24 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:37400 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755903AbYBNUBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 15:01:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=JVC2htx2MfamkYs68YZjg7tvmjPcFoARxIlOjWqYp0ifTsjYxj3keIbOpLaRxbl7aYN2Eok0VPO3C1QaY/5BCrMTBilhy2PzKMz+4oyUTC0+T+kR3SbNCvoSmGHKpL3cEc/W7ZvvCeccSzUFpycaEhE6UWNr8twlSmim70840K0=
Message-ID: <47B49E0C.5060606@gmail.com>
Date: Thu, 14 Feb 2008 21:01:16 +0100
From: Vegard Nossum <vegard.nossum@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Daniel Walker <dwalker@mvista.com>, Ingo Molnar <mingo@elte.hu>,
       Richard Knutsson <ricknu-0@student.ltu.se>,
       Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <clameter@sgi.com>
Subject: [PATCH 2/4] kmemcheck v4
References: <47B49DB2.2090402@gmail.com>
In-Reply-To: <47B49DB2.2090402@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 From 5cbf7d1cb81b4f8bb4d80c027b74cdf0f08aaaff Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Thu, 14 Feb 2008 19:20:51 +0100
Subject: [PATCH] kmemcheck: add the x86 hooks

The hooks that we modify are:
- Page fault handler (to handle kmemcheck faults)
- Debug exception handler (to hide pages after single-stepping
   the instruction that caused the page fault)

Also redefine memset() to use the optimized version if kmemcheck
is enabled.

Signed-off-by: Vegard Nossum <vegardno@ifi.uio.no>
---
  arch/x86/kernel/cpu/common.c |    7 +++++++
  arch/x86/kernel/entry_32.S   |    8 ++++----
  arch/x86/kernel/traps_32.c   |   22 +++++++++++++++++++++-
  arch/x86/mm/fault.c          |   21 +++++++++++++++++----
  include/asm-x86/string_32.h  |    8 ++++++++
  5 files changed, 57 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index f86a3c4..83cd359 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -634,6 +634,13 @@ void __init early_cpu_init(void)
  	nexgen_init_cpu();
  	umc_init_cpu();
  	early_cpu_detect();
+
+#ifdef CONFIG_KMEMCHECK
+	/*
+	 * We need 4K granular PTEs for kmemcheck:
+	 */
+	setup_clear_cpu_cap(X86_FEATURE_PSE);
+#endif
  }

  /* Make sure %fs is initialized properly in idle threads */
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 824e21b..30b94e7 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -289,7 +289,7 @@ ENTRY(ia32_sysenter_target)
  	CFI_DEF_CFA esp, 0
  	CFI_REGISTER esp, ebp
  	movl TSS_sysenter_sp0(%esp),%esp
-sysenter_past_esp:
+ENTRY(sysenter_past_esp)
  	/*
  	 * No need to follow this irqs on/off section: the syscall
  	 * disabled irqs and here we enable it straight after entry:
@@ -767,7 +767,7 @@ label:						\
  	CFI_ADJUST_CFA_OFFSET 4;		\
  	CFI_REL_OFFSET eip, 0

-KPROBE_ENTRY(debug)
+KPROBE_ENTRY(x86_debug)
  	RING0_INT_FRAME
  	cmpl $ia32_sysenter_target,(%esp)
  	jne debug_stack_correct
@@ -781,7 +781,7 @@ debug_stack_correct:
  	call do_debug
  	jmp ret_from_exception
  	CFI_ENDPROC
-KPROBE_END(debug)
+KPROBE_END(x86_debug)

  /*
   * NMI is doubly nasty. It can happen _while_ we're handling
@@ -835,7 +835,7 @@ nmi_debug_stack_check:
  	/* We have a RING0_INT_FRAME here */
  	cmpw $__KERNEL_CS,16(%esp)
  	jne nmi_stack_correct
-	cmpl $debug,(%esp)
+	cmpl $x86_debug,(%esp)
  	jb nmi_stack_correct
  	cmpl $debug_esp_fix_insn,(%esp)
  	ja nmi_stack_correct
diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index b22c01e..1299d38 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -56,6 +56,7 @@
  #include <asm/arch_hooks.h>
  #include <linux/kdebug.h>
  #include <asm/stacktrace.h>
+#include <asm/kmemcheck.h>

  #include <linux/module.h>

@@ -841,6 +842,10 @@ void __kprobes do_int3(struct pt_regs *regs, long error_code)
  }
  #endif

+extern void ia32_sysenter_target(void);
+extern void sysenter_past_esp(void);
+extern void x86_debug(void);
+
  /*
   * Our handling of the processor debug registers is non-trivial.
   * We do not clear them on entry and exit from the kernel. Therefore
@@ -872,6 +877,20 @@ void __kprobes do_debug(struct pt_regs * regs, long error_code)

  	get_debugreg(condition, 6);

+#ifdef CONFIG_KMEMCHECK
+	/* Catch kmemcheck conditions first of all! */
+	if (condition & DR_STEP) {
+		if (!(regs->flags & VM_MASK) && !user_mode(regs) &&
+			((void *)regs->ip != system_call) &&
+			((void *)regs->ip != x86_debug) &&
+			((void *)regs->ip != ia32_sysenter_target) &&
+			((void *)regs->ip != sysenter_past_esp)) {
+			kmemcheck_hide(regs);
+			return;
+		}
+	}
+#endif
+
  	/*
  	 * The processor cleared BTF, so don't mark that we need it set.
  	 */
@@ -881,6 +900,7 @@ void __kprobes do_debug(struct pt_regs * regs, long error_code)
  	if (notify_die(DIE_DEBUG, "debug", regs, condition, error_code,
  					SIGTRAP) == NOTIFY_STOP)
  		return;
+
  	/* It's safe to allow irq's after DR6 has been saved */
  	if (regs->flags & X86_EFLAGS_IF)
  		local_irq_enable();
@@ -1154,7 +1174,7 @@ void __init trap_init(void)
  #endif

  	set_trap_gate(0,&divide_error);
-	set_intr_gate(1,&debug);
+	set_intr_gate(1,&x86_debug);
  	set_intr_gate(2,&nmi);
  	set_system_intr_gate(3, &int3); /* int3/4 can be called from all */
  	set_system_gate(4,&overflow);
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 621afb6..2886cf9 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -33,6 +33,7 @@
  #include <asm/smp.h>
  #include <asm/tlbflush.h>
  #include <asm/proto.h>
+#include <asm/kmemcheck.h>
  #include <asm-generic/sections.h>

  /*
@@ -493,7 +494,8 @@ static int spurious_fault(unsigned long address,
   *
   * This assumes no large pages in there.
   */
-static int vmalloc_fault(unsigned long address)
+static int vmalloc_fault(struct pt_regs *regs, unsigned long address,
+	unsigned long error_code)
  {
  #ifdef CONFIG_X86_32
  	unsigned long pgd_paddr;
@@ -511,8 +513,19 @@ static int vmalloc_fault(unsigned long address)
  	if (!pmd_k)
  		return -1;
  	pte_k = pte_offset_kernel(pmd_k, address);
-	if (!pte_present(*pte_k))
-		return -1;
+	if (!pte_present(*pte_k)) {
+		if (!pte_hidden(*pte_k))
+			return -1;
+
+#ifdef CONFIG_KMEMCHECK
+		kmemcheck_prepare(regs);
+		if (error_code & 2)
+			kmemcheck_access(regs, address, KMEMCHECK_WRITE);
+		else
+			kmemcheck_access(regs, address, KMEMCHECK_READ);
+		kmemcheck_show(regs);
+#endif
+	}
  	return 0;
  #else
  	pgd_t *pgd, *pgd_ref;
@@ -623,7 +636,7 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
  	if (unlikely(address >= TASK_SIZE64)) {
  #endif
  		if (!(error_code & (PF_RSVD|PF_USER|PF_PROT)) &&
-		    vmalloc_fault(address) >= 0)
+		    vmalloc_fault(regs, address, error_code) >= 0)
  			return;

  		/* Can handle a stale RO->RW TLB */
diff --git a/include/asm-x86/string_32.h b/include/asm-x86/string_32.h
index c5d13a8..546cea0 100644
--- a/include/asm-x86/string_32.h
+++ b/include/asm-x86/string_32.h
@@ -262,6 +262,14 @@ __asm__  __volatile__( \
   __constant_c_x_memset((s),(0x01010101UL*(unsigned char)(c)),(count)) : \
   __memset((s),(c),(count)))

+/* If kmemcheck is enabled, our best bet is a custom memset() that disables
+ * checking in order to save a whole lot of (unnecessary) page faults. */
+#ifdef CONFIG_KMEMCHECK
+void kmemcheck_memset(unsigned long s, int c, size_t n);
+#undef memset
+#define memset(s, c, n) kmemcheck_memset((unsigned long) (s), (c), (n))
+#endif
+
  /*
   * find the first occurrence of byte 'c', or 1 past the area if none
   */
-- 
1.5.3.8


