Return-Path: <linux-kernel-owner+w=401wt.eu-S1758521AbYDDNqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758521AbYDDNqv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 09:46:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755419AbYDDNqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 09:46:42 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:16864 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbYDDNqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 09:46:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=bqWnldPLe8GHwDs/SH4CAHo7JB/swr68VX2APHgob42qxDOI9hIp05MwZXDVKA4v17rrPTASzV3HB8n+/QedabFiPpE7zvSemqYVAYPBzBmROlYEh+xRnBk81UMhChJIVDTAK18wtcEZiStdC4YQhS9SbV3J6BcosdidieKXd+I=
Message-ID: <47F6313B.6030408@gmail.com>
Date: Fri, 04 Apr 2008 15:46:35 +0200
From: Vegard Nossum <vegard.nossum@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Christoph Lameter <clameter@sgi.com>,
       Daniel Walker <dwalker@mvista.com>, Andi Kleen <andi@firstfloor.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Josh Aune <luken@omner.org>,
       Pekka Paalanen <pq@iki.fi>
Subject: [PATCH 2/3] x86: add hooks for kmemcheck
References: <47F630AE.7050801@gmail.com>
In-Reply-To: <47F630AE.7050801@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 From caf2b1b7198bd4e0d690555be389a3444523162d Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Fri, 4 Apr 2008 00:53:23 +0200
Subject: [PATCH] x86: add hooks for kmemcheck

The hooks that we modify are:
- Page fault handler (to handle kmemcheck faults)
- Debug exception handler (to hide pages after single-stepping
   the instruction that caused the page fault)

Also redefine memset() to use the optimized version if kmemcheck
is enabled.

Signed-off-by: Vegard Nossum <vegardno@ifi.uio.no>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
  arch/x86/kernel/cpu/common.c |    7 +++++++
  arch/x86/kernel/entry_32.S   |    8 ++++----
  arch/x86/kernel/traps_32.c   |   16 +++++++++++++++-
  arch/x86/mm/fault.c          |   25 +++++++++++++++++++++----
  include/asm-x86/string_32.h  |    8 ++++++++
  5 files changed, 55 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index a38aafa..040c650 100644
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
index 4b87c32..54f477c 100644
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
index b22c01e..898796e 100644
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
@@ -872,6 +877,14 @@ void __kprobes do_debug(struct pt_regs * regs, long error_code)

  	get_debugreg(condition, 6);

+	/* Catch kmemcheck conditions first of all! */
+	if (condition & DR_STEP) {
+		if (kmemcheck_active(regs)) {
+			kmemcheck_hide(regs);
+			return;
+		}
+	}
+
  	/*
  	 * The processor cleared BTF, so don't mark that we need it set.
  	 */
@@ -881,6 +894,7 @@ void __kprobes do_debug(struct pt_regs * regs, long error_code)
  	if (notify_die(DIE_DEBUG, "debug", regs, condition, error_code,
  					SIGTRAP) == NOTIFY_STOP)
  		return;
+
  	/* It's safe to allow irq's after DR6 has been saved */
  	if (regs->flags & X86_EFLAGS_IF)
  		local_irq_enable();
@@ -1154,7 +1168,7 @@ void __init trap_init(void)
  #endif

  	set_trap_gate(0,&divide_error);
-	set_intr_gate(1,&debug);
+	set_intr_gate(1,&x86_debug);
  	set_intr_gate(2,&nmi);
  	set_system_intr_gate(3, &int3); /* int3/4 can be called from all */
  	set_system_gate(4,&overflow);
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index ec08d83..fe493b4 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -33,6 +33,7 @@
  #include <asm/smp.h>
  #include <asm/tlbflush.h>
  #include <asm/proto.h>
+#include <asm/kmemcheck.h>
  #include <asm-generic/sections.h>

  /*
@@ -491,7 +492,8 @@ static int spurious_fault(unsigned long address,
   *
   * This assumes no large pages in there.
   */
-static int vmalloc_fault(unsigned long address)
+static int vmalloc_fault(struct pt_regs *regs, unsigned long address,
+	unsigned long error_code)
  {
  #ifdef CONFIG_X86_32
  	unsigned long pgd_paddr;
@@ -509,8 +511,16 @@ static int vmalloc_fault(unsigned long address)
  	if (!pmd_k)
  		return -1;
  	pte_k = pte_offset_kernel(pmd_k, address);
-	if (!pte_present(*pte_k))
-		return -1;
+	if (!pte_present(*pte_k)) {
+		if (!pte_hidden(*pte_k))
+			return -1;
+
+		if (error_code & 2)
+			kmemcheck_access(regs, address, KMEMCHECK_WRITE);
+		else
+			kmemcheck_access(regs, address, KMEMCHECK_READ);
+		kmemcheck_show(regs);
+	}
  	return 0;
  #else
  	pgd_t *pgd, *pgd_ref;
@@ -599,6 +609,13 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)

  	si_code = SEGV_MAPERR;

+	/*
+	 * Detect and handle instructions that would cause a page fault for
+	 * both a tracked kernel page and a userspace page.
+	 */
+	if(kmemcheck_active(regs))
+		kmemcheck_hide(regs);
+
  	if (notify_page_fault(regs))
  		return;

@@ -621,7 +638,7 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
  	if (unlikely(address >= TASK_SIZE64)) {
  #endif
  		if (!(error_code & (PF_RSVD|PF_USER|PF_PROT)) &&
-		    vmalloc_fault(address) >= 0)
+		    vmalloc_fault(regs, address, error_code) >= 0)
  			return;

  		/* Can handle a stale RO->RW TLB */
diff --git a/include/asm-x86/string_32.h b/include/asm-x86/string_32.h
index c5d13a8..6138aa4 100644
--- a/include/asm-x86/string_32.h
+++ b/include/asm-x86/string_32.h
@@ -262,6 +262,14 @@ __asm__  __volatile__( \
   __constant_c_x_memset((s),(0x01010101UL*(unsigned char)(c)),(count)) : \
   __memset((s),(c),(count)))

+/* If kmemcheck is enabled, our best bet is a custom memset() that disables
+ * checking in order to save a whole lot of (unnecessary) page faults. */
+#ifdef CONFIG_KMEMCHECK
+void *kmemcheck_memset(void *s, int c, size_t n);
+#undef memset
+#define memset(s, c, n) kmemcheck_memset((s), (c), (n))
+#endif
+
  /*
   * find the first occurrence of byte 'c', or 1 past the area if none
   */
-- 
1.5.4.1


