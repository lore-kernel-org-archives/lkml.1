Return-Path: <linux-kernel-owner+w=401wt.eu-S1757084AbXKSWI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757084AbXKSWI4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 17:08:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756700AbXKSWGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 17:06:47 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49351 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756694AbXKSWGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 17:06:46 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 12/18] x86 vDSO: ia32_sysenter_target
In-Reply-To: Roland McGrath's message of  Monday, 19 November 2007 13:59:43 -0800 <20071119215944.01B7C26F8BE@magilla.localdomain>
References: <20071119215944.01B7C26F8BE@magilla.localdomain>
Emacs: Lovecraft was an optimist.
Message-Id: <20071119220614.A438926F8BE@magilla.localdomain>
Date: Mon, 19 Nov 2007 14:06:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This harmonizes the name for the entry point from the 32-bit sysenter
instruction across 32-bit and 64-bit kernels.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/kernel/entry_32.S   |   10 +++++-----
 arch/x86/vdso/vdso32-setup.c |    4 ++--
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index dc7f938..388786c 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -283,7 +283,7 @@ END(resume_kernel)
    the vsyscall page.  See vsyscall-sysentry.S, which defines the symbol.  */
 
 	# sysenter call handler stub
-ENTRY(sysenter_entry)
+ENTRY(ia32_sysenter_target)
 	CFI_STARTPROC simple
 	CFI_SIGNAL_FRAME
 	CFI_DEF_CFA esp, 0
@@ -360,7 +360,7 @@ sysenter_past_esp:
 	.align 4
 	.long 1b,2b
 .popsection
-ENDPROC(sysenter_entry)
+ENDPROC(ia32_sysenter_target)
 
 	# system call handler stub
 ENTRY(system_call)
@@ -768,7 +768,7 @@ label:						\
 
 KPROBE_ENTRY(debug)
 	RING0_INT_FRAME
-	cmpl $sysenter_entry,(%esp)
+	cmpl $ia32_sysenter_target,(%esp)
 	jne debug_stack_correct
 	FIX_STACK(12, debug_stack_correct, debug_esp_fix_insn)
 debug_stack_correct:
@@ -799,7 +799,7 @@ KPROBE_ENTRY(nmi)
 	popl %eax
 	CFI_ADJUST_CFA_OFFSET -4
 	je nmi_espfix_stack
-	cmpl $sysenter_entry,(%esp)
+	cmpl $ia32_sysenter_target,(%esp)
 	je nmi_stack_fixup
 	pushl %eax
 	CFI_ADJUST_CFA_OFFSET 4
@@ -812,7 +812,7 @@ KPROBE_ENTRY(nmi)
 	popl %eax
 	CFI_ADJUST_CFA_OFFSET -4
 	jae nmi_stack_correct
-	cmpl $sysenter_entry,12(%esp)
+	cmpl $ia32_sysenter_target,12(%esp)
 	je nmi_debug_stack_check
 nmi_stack_correct:
 	/* We have a RING0_INT_FRAME here */
diff --git a/arch/x86/vdso/vdso32-setup.c b/arch/x86/vdso/vdso32-setup.c
index 85c52d2..fb71a93 100644
--- a/arch/x86/vdso/vdso32-setup.c
+++ b/arch/x86/vdso/vdso32-setup.c
@@ -54,7 +54,7 @@ static int __init vdso_setup(char *s)
 
 __setup("vdso=", vdso_setup);
 
-extern asmlinkage void sysenter_entry(void);
+extern asmlinkage void ia32_sysenter_target(void);
 
 static __init void reloc_symtab(Elf32_Ehdr *ehdr,
 				unsigned offset, unsigned size)
@@ -187,7 +187,7 @@ void enable_sep_cpu(void)
 	tss->x86_tss.esp1 = sizeof(struct tss_struct) + (unsigned long) tss;
 	wrmsr(MSR_IA32_SYSENTER_CS, __KERNEL_CS, 0);
 	wrmsr(MSR_IA32_SYSENTER_ESP, tss->x86_tss.esp1, 0);
-	wrmsr(MSR_IA32_SYSENTER_EIP, (unsigned long) sysenter_entry, 0);
+	wrmsr(MSR_IA32_SYSENTER_EIP, (unsigned long) ia32_sysenter_target, 0);
 	put_cpu();	
 }
 
