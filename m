Return-Path: <linux-kernel-owner+w=401wt.eu-S1756782AbXKSWLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782AbXKSWLz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 17:11:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755361AbXKSWIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 17:08:10 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49403 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756066AbXKSWIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 17:08:07 -0500
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
Subject: [PATCH 16/18] x86 vDSO: ia32 vsyscall removal
In-Reply-To: Roland McGrath's message of  Monday, 19 November 2007 13:59:43 -0800 <20071119215944.01B7C26F8BE@magilla.localdomain>
References: <20071119215944.01B7C26F8BE@magilla.localdomain>
X-Shopping-List: (1) Condo-conscious collisions
   (2) Iniquitous rebellion roosters
   (3) Hemispherical malnutrition
Message-Id: <20071119220653.AF16D26F8C2@magilla.localdomain>
Date: Mon, 19 Nov 2007 14:06:53 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This removes all the old vsyscall code from arch/x86/ia32/ that is
no longer used because arch/x86/vdso/ code has replaced it.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/Makefile_64               |    3 -
 arch/x86/ia32/Makefile             |   37 ---------
 arch/x86/ia32/syscall32.c          |   87 ----------------------
 arch/x86/ia32/syscall32_syscall.S  |   17 ----
 arch/x86/ia32/vsyscall-sigreturn.S |  142 ------------------------------------
 arch/x86/ia32/vsyscall-syscall.S   |   69 -----------------
 arch/x86/ia32/vsyscall-sysenter.S  |   95 ------------------------
 arch/x86/ia32/vsyscall.lds         |   80 --------------------
 include/asm-x86/Kbuild             |    1 -
 include/asm-x86/vsyscall32.h       |   20 -----
 10 files changed, 0 insertions(+), 551 deletions(-)
 delete mode 100644 arch/x86/ia32/syscall32.c
 delete mode 100644 arch/x86/ia32/syscall32_syscall.S
 delete mode 100644 arch/x86/ia32/vsyscall-sigreturn.S
 delete mode 100644 arch/x86/ia32/vsyscall-syscall.S
 delete mode 100644 arch/x86/ia32/vsyscall-sysenter.S
 delete mode 100644 arch/x86/ia32/vsyscall.lds
 delete mode 100644 include/asm-x86/vsyscall32.h

diff --git a/arch/x86/Makefile_64 b/arch/x86/Makefile_64
index a804860..d12bb14 100644
--- a/arch/x86/Makefile_64
+++ b/arch/x86/Makefile_64
@@ -117,9 +117,6 @@ install: vdso_install
 	$(Q)$(MAKE) $(build)=$(boot) BOOTIMAGE=$(BOOTIMAGE) $@ 
 
 vdso_install:
-ifeq ($(CONFIG_IA32_EMULATION),y)
-	$(Q)$(MAKE) $(build)=arch/x86/ia32 $@
-endif
 	$(Q)$(MAKE) $(build)=arch/x86/vdso $@
 
 archclean:
diff --git a/arch/x86/ia32/Makefile b/arch/x86/ia32/Makefile
index 9abb0db..bf91690 100644
--- a/arch/x86/ia32/Makefile
+++ b/arch/x86/ia32/Makefile
@@ -13,40 +13,3 @@ obj-$(CONFIG_IA32_AOUT) += ia32_aout.o
 
 audit-class-$(CONFIG_AUDIT) := audit.o
 obj-$(CONFIG_IA32_EMULATION) += $(audit-class-y)
-
-$(obj)/syscall32_syscall.o: \
-	$(foreach F,sysenter syscall,$(obj)/vsyscall-$F.so)
-
-# Teach kbuild about targets
-targets := $(foreach F,$(addprefix vsyscall-,sysenter syscall),\
-		     $F.o $F.so $F.so.dbg)
-
-# The DSO images are built using a special linker script
-quiet_cmd_syscall = SYSCALL $@
-      cmd_syscall = $(CC) -m32 -nostdlib -shared \
-			  $(call ld-option, -Wl$(comma)--hash-style=sysv) \
-			   -Wl,-soname=linux-gate.so.1 -o $@ \
-			   -Wl,-T,$(filter-out FORCE,$^)
-
-$(obj)/%.so: OBJCOPYFLAGS := -S
-$(obj)/%.so: $(obj)/%.so.dbg FORCE
-	$(call if_changed,objcopy)
-
-$(obj)/vsyscall-sysenter.so.dbg $(obj)/vsyscall-syscall.so.dbg: \
-$(obj)/vsyscall-%.so.dbg: $(src)/vsyscall.lds $(obj)/vsyscall-%.o FORCE
-	$(call if_changed,syscall)
-
-AFLAGS_vsyscall-sysenter.o = -m32 -Wa,-32
-AFLAGS_vsyscall-syscall.o = -m32 -Wa,-32
-
-vdsos := vdso32-sysenter.so vdso32-syscall.so
-
-quiet_cmd_vdso_install = INSTALL $@
-      cmd_vdso_install = cp $(@:vdso32-%.so=$(obj)/vsyscall-%.so.dbg) \
-			    $(MODLIB)/vdso/$@
-
-$(vdsos):
-	@mkdir -p $(MODLIB)/vdso
-	$(call cmd,vdso_install)
-
-vdso_install: $(vdsos)
diff --git a/arch/x86/ia32/syscall32.c b/arch/x86/ia32/syscall32.c
deleted file mode 100644
index 2c9c145..0000000
--- a/arch/x86/ia32/syscall32.c
+++ /dev/null
@@ -1,87 +0,0 @@
-/* Copyright 2002,2003 Andi Kleen, SuSE Labs */
-
-/* vsyscall handling for 32bit processes. Map a stub page into it 
-   on demand because 32bit cannot reach the kernel's fixmaps */
-
-#include <linux/mm.h>
-#include <linux/string.h>
-#include <linux/kernel.h>
-#include <linux/gfp.h>
-#include <linux/init.h>
-#include <linux/stringify.h>
-#include <linux/security.h>
-#include <asm/proto.h>
-#include <asm/tlbflush.h>
-#include <asm/ia32_unistd.h>
-#include <asm/vsyscall32.h>
-
-extern unsigned char syscall32_syscall[], syscall32_syscall_end[];
-extern unsigned char syscall32_sysenter[], syscall32_sysenter_end[];
-extern int sysctl_vsyscall32;
-
-static struct page *syscall32_pages[1];
-static int use_sysenter = -1;
-
-struct linux_binprm;
-
-/* Setup a VMA at program startup for the vsyscall page */
-int syscall32_setup_pages(struct linux_binprm *bprm, int exstack)
-{
-	struct mm_struct *mm = current->mm;
-	int ret;
-
-	down_write(&mm->mmap_sem);
-	/*
-	 * MAYWRITE to allow gdb to COW and set breakpoints
-	 *
-	 * Make sure the vDSO gets into every core dump.
-	 * Dumping its contents makes post-mortem fully interpretable later
-	 * without matching up the same kernel and hardware config to see
-	 * what PC values meant.
-	 */
-	/* Could randomize here */
-	ret = install_special_mapping(mm, VSYSCALL32_BASE, PAGE_SIZE,
-				      VM_READ|VM_EXEC|
-				      VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC|
-				      VM_ALWAYSDUMP,
-				      syscall32_pages);
-	if (ret == 0) {
-		current->mm->context.vdso = (void __user *)VSYSCALL32_BASE;
-		current_thread_info()->sysenter_return = VSYSCALL32_SYSEXIT;
-	}
-	up_write(&mm->mmap_sem);
-	return ret;
-}
-
-static int __init init_syscall32(void)
-{ 
-	char *syscall32_page = (void *)get_zeroed_page(GFP_KERNEL);
-	if (!syscall32_page) 
-		panic("Cannot allocate syscall32 page"); 
-	syscall32_pages[0] = virt_to_page(syscall32_page);
- 	if (use_sysenter > 0) {
- 		memcpy(syscall32_page, syscall32_sysenter,
- 		       syscall32_sysenter_end - syscall32_sysenter);
- 	} else {
-  		memcpy(syscall32_page, syscall32_syscall,
-  		       syscall32_syscall_end - syscall32_syscall);
-  	}	
-	return 0;
-} 
-	
-__initcall(init_syscall32); 
-
-/* May not be __init: called during resume */
-void syscall32_cpu_init(void)
-{
-	if (use_sysenter < 0)
- 		use_sysenter = (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL);
-
-	/* Load these always in case some future AMD CPU supports
-	   SYSENTER from compat mode too. */
-	checking_wrmsrl(MSR_IA32_SYSENTER_CS, (u64)__KERNEL_CS);
-	checking_wrmsrl(MSR_IA32_SYSENTER_ESP, 0ULL);
-	checking_wrmsrl(MSR_IA32_SYSENTER_EIP, (u64)ia32_sysenter_target);
-
-	wrmsrl(MSR_CSTAR, ia32_cstar_target);
-}
diff --git a/arch/x86/ia32/syscall32_syscall.S b/arch/x86/ia32/syscall32_syscall.S
deleted file mode 100644
index 933f0f0..0000000
--- a/arch/x86/ia32/syscall32_syscall.S
+++ /dev/null
@@ -1,17 +0,0 @@
-/* 32bit VDSOs mapped into user space. */
-
-	.section ".init.data","aw"
-
-	.globl syscall32_syscall
-	.globl syscall32_syscall_end
-
-syscall32_syscall:
-	.incbin "arch/x86/ia32/vsyscall-syscall.so"
-syscall32_syscall_end:
-
-	.globl syscall32_sysenter
-	.globl syscall32_sysenter_end
-
-syscall32_sysenter:
-	.incbin "arch/x86/ia32/vsyscall-sysenter.so"
-syscall32_sysenter_end:
diff --git a/arch/x86/ia32/vsyscall-sigreturn.S b/arch/x86/ia32/vsyscall-sigreturn.S
deleted file mode 100644
index 295eecf..0000000
--- a/arch/x86/ia32/vsyscall-sigreturn.S
+++ /dev/null
@@ -1,142 +0,0 @@
-/*
- * Common code for the sigreturn entry points on the vsyscall page.
- * This code uses SYSCALL_ENTER_KERNEL (either syscall or int $0x80)
- * to enter the kernel.
- * This file is #include'd by vsyscall-*.S to define them after the
- * vsyscall entry point.  The addresses we get for these entry points
- * by doing ".balign 32" must match in both versions of the page.
- */
-
-	.code32
-	.section .text.sigreturn,"ax"
-	.balign 32
-	.globl __kernel_sigreturn
-	.type __kernel_sigreturn,@function
-__kernel_sigreturn:
-.LSTART_sigreturn:
-	popl %eax
-	movl $__NR_ia32_sigreturn, %eax
-	SYSCALL_ENTER_KERNEL
-.LEND_sigreturn:
-	.size __kernel_sigreturn,.-.LSTART_sigreturn
-
-	.section .text.rtsigreturn,"ax"
-	.balign 32
-	.globl __kernel_rt_sigreturn
-	.type __kernel_rt_sigreturn,@function
-__kernel_rt_sigreturn:
-.LSTART_rt_sigreturn:
-	movl $__NR_ia32_rt_sigreturn, %eax
-	SYSCALL_ENTER_KERNEL
-.LEND_rt_sigreturn:
-	.size __kernel_rt_sigreturn,.-.LSTART_rt_sigreturn
-
-	.section .eh_frame,"a",@progbits
-.LSTARTFRAMES:
-        .long .LENDCIES-.LSTARTCIES
-.LSTARTCIES:
-	.long 0			/* CIE ID */
-	.byte 1			/* Version number */
-	.string "zRS"		/* NUL-terminated augmentation string */
-	.uleb128 1		/* Code alignment factor */
-	.sleb128 -4		/* Data alignment factor */
-	.byte 8			/* Return address register column */
-	.uleb128 1		/* Augmentation value length */
-	.byte 0x1b		/* DW_EH_PE_pcrel|DW_EH_PE_sdata4. */
-	.byte 0x0c		/* DW_CFA_def_cfa */
-	.uleb128 4
-	.uleb128 4
-	.byte 0x88		/* DW_CFA_offset, column 0x8 */
-	.uleb128 1
-	.align 4
-.LENDCIES:
-
-	.long .LENDFDE2-.LSTARTFDE2	/* Length FDE */
-.LSTARTFDE2:
-	.long .LSTARTFDE2-.LSTARTFRAMES	/* CIE pointer */
-	/* HACK: The dwarf2 unwind routines will subtract 1 from the
-	   return address to get an address in the middle of the
-	   presumed call instruction.  Since we didn't get here via
-	   a call, we need to include the nop before the real start
-	   to make up for it.  */
-	.long .LSTART_sigreturn-1-.	/* PC-relative start address */
-	.long .LEND_sigreturn-.LSTART_sigreturn+1
-	.uleb128 0			/* Augmentation length */
-	/* What follows are the instructions for the table generation.
-	   We record the locations of each register saved.  This is
-	   complicated by the fact that the "CFA" is always assumed to
-	   be the value of the stack pointer in the caller.  This means
-	   that we must define the CFA of this body of code to be the
-	   saved value of the stack pointer in the sigcontext.  Which
-	   also means that there is no fixed relation to the other 
-	   saved registers, which means that we must use DW_CFA_expression
-	   to compute their addresses.  It also means that when we 
-	   adjust the stack with the popl, we have to do it all over again.  */
-
-#define do_cfa_expr(offset)						\
-	.byte 0x0f;			/* DW_CFA_def_cfa_expression */	\
-	.uleb128 1f-0f;			/*   length */			\
-0:	.byte 0x74;			/*     DW_OP_breg4 */		\
-	.sleb128 offset;		/*      offset */		\
-	.byte 0x06;			/*     DW_OP_deref */		\
-1:
-
-#define do_expr(regno, offset)						\
-	.byte 0x10;			/* DW_CFA_expression */		\
-	.uleb128 regno;			/*   regno */			\
-	.uleb128 1f-0f;			/*   length */			\
-0:	.byte 0x74;			/*     DW_OP_breg4 */		\
-	.sleb128 offset;		/*       offset */		\
-1:
-
-	do_cfa_expr(IA32_SIGCONTEXT_esp+4)
-	do_expr(0, IA32_SIGCONTEXT_eax+4)
-	do_expr(1, IA32_SIGCONTEXT_ecx+4)
-	do_expr(2, IA32_SIGCONTEXT_edx+4)
-	do_expr(3, IA32_SIGCONTEXT_ebx+4)
-	do_expr(5, IA32_SIGCONTEXT_ebp+4)
-	do_expr(6, IA32_SIGCONTEXT_esi+4)
-	do_expr(7, IA32_SIGCONTEXT_edi+4)
-	do_expr(8, IA32_SIGCONTEXT_eip+4)
-
-	.byte 0x42	/* DW_CFA_advance_loc 2 -- nop; popl eax. */
-
-	do_cfa_expr(IA32_SIGCONTEXT_esp)
-	do_expr(0, IA32_SIGCONTEXT_eax)
-	do_expr(1, IA32_SIGCONTEXT_ecx)
-	do_expr(2, IA32_SIGCONTEXT_edx)
-	do_expr(3, IA32_SIGCONTEXT_ebx)
-	do_expr(5, IA32_SIGCONTEXT_ebp)
-	do_expr(6, IA32_SIGCONTEXT_esi)
-	do_expr(7, IA32_SIGCONTEXT_edi)
-	do_expr(8, IA32_SIGCONTEXT_eip)
-
-	.align 4
-.LENDFDE2:
-
-	.long .LENDFDE3-.LSTARTFDE3	/* Length FDE */
-.LSTARTFDE3:
-	.long .LSTARTFDE3-.LSTARTFRAMES	/* CIE pointer */
-	/* HACK: See above wrt unwind library assumptions.  */
-	.long .LSTART_rt_sigreturn-1-.	/* PC-relative start address */
-	.long .LEND_rt_sigreturn-.LSTART_rt_sigreturn+1
-	.uleb128 0			/* Augmentation */
-	/* What follows are the instructions for the table generation.
-	   We record the locations of each register saved.  This is
-	   slightly less complicated than the above, since we don't
-	   modify the stack pointer in the process.  */
-
-	do_cfa_expr(IA32_RT_SIGFRAME_sigcontext-4 + IA32_SIGCONTEXT_esp)
-	do_expr(0, IA32_RT_SIGFRAME_sigcontext-4 + IA32_SIGCONTEXT_eax)
-	do_expr(1, IA32_RT_SIGFRAME_sigcontext-4 + IA32_SIGCONTEXT_ecx)
-	do_expr(2, IA32_RT_SIGFRAME_sigcontext-4 + IA32_SIGCONTEXT_edx)
-	do_expr(3, IA32_RT_SIGFRAME_sigcontext-4 + IA32_SIGCONTEXT_ebx)
-	do_expr(5, IA32_RT_SIGFRAME_sigcontext-4 + IA32_SIGCONTEXT_ebp)
-	do_expr(6, IA32_RT_SIGFRAME_sigcontext-4 + IA32_SIGCONTEXT_esi)
-	do_expr(7, IA32_RT_SIGFRAME_sigcontext-4 + IA32_SIGCONTEXT_edi)
-	do_expr(8, IA32_RT_SIGFRAME_sigcontext-4 + IA32_SIGCONTEXT_eip)
-
-	.align 4
-.LENDFDE3:
-
-#include "../vdso/vdso32/note.S"
diff --git a/arch/x86/ia32/vsyscall-syscall.S b/arch/x86/ia32/vsyscall-syscall.S
deleted file mode 100644
index cf9ef67..0000000
--- a/arch/x86/ia32/vsyscall-syscall.S
+++ /dev/null
@@ -1,69 +0,0 @@
-/*
- * Code for the vsyscall page.  This version uses the syscall instruction.
- */
-
-#include <asm/ia32_unistd.h>
-#include <asm/asm-offsets.h>
-#include <asm/segment.h>
-
-	.code32
-	.text
-	.section .text.vsyscall,"ax"
-	.globl __kernel_vsyscall
-	.type __kernel_vsyscall,@function
-__kernel_vsyscall:
-.LSTART_vsyscall:
-	push	%ebp
-.Lpush_ebp:
-	movl	%ecx, %ebp
-	syscall
-	movl	$__USER32_DS, %ecx
-	movl	%ecx, %ss
-	movl	%ebp, %ecx
-	popl	%ebp
-.Lpop_ebp:
-	ret
-.LEND_vsyscall:
-	.size __kernel_vsyscall,.-.LSTART_vsyscall
-
-	.section .eh_frame,"a",@progbits
-.LSTARTFRAME:
-	.long .LENDCIE-.LSTARTCIE
-.LSTARTCIE:
-	.long 0			/* CIE ID */
-	.byte 1			/* Version number */
-	.string "zR"		/* NUL-terminated augmentation string */
-	.uleb128 1		/* Code alignment factor */
-	.sleb128 -4		/* Data alignment factor */
-	.byte 8			/* Return address register column */
-	.uleb128 1		/* Augmentation value length */
-	.byte 0x1b		/* DW_EH_PE_pcrel|DW_EH_PE_sdata4. */
-	.byte 0x0c		/* DW_CFA_def_cfa */
-	.uleb128 4
-	.uleb128 4
-	.byte 0x88		/* DW_CFA_offset, column 0x8 */
-	.uleb128 1
-	.align 4
-.LENDCIE:
-
-	.long .LENDFDE1-.LSTARTFDE1	/* Length FDE */
-.LSTARTFDE1:
-	.long .LSTARTFDE1-.LSTARTFRAME	/* CIE pointer */
-	.long .LSTART_vsyscall-.	/* PC-relative start address */
-	.long .LEND_vsyscall-.LSTART_vsyscall
-	.uleb128 0			/* Augmentation length */
-	/* What follows are the instructions for the table generation.
-	   We have to record all changes of the stack pointer.  */
-	.byte 0x40 + .Lpush_ebp-.LSTART_vsyscall /* DW_CFA_advance_loc */
-	.byte 0x0e		/* DW_CFA_def_cfa_offset */
-	.uleb128 8
-	.byte 0x85, 0x02	/* DW_CFA_offset %ebp -8 */
-	.byte 0x40 + .Lpop_ebp-.Lpush_ebp /* DW_CFA_advance_loc */
-	.byte 0xc5		/* DW_CFA_restore %ebp */
-	.byte 0x0e		/* DW_CFA_def_cfa_offset */
-	.uleb128 4
-	.align 4
-.LENDFDE1:
-
-#define SYSCALL_ENTER_KERNEL	syscall
-#include "vsyscall-sigreturn.S"
diff --git a/arch/x86/ia32/vsyscall-sysenter.S b/arch/x86/ia32/vsyscall-sysenter.S
deleted file mode 100644
index ae056e5..0000000
--- a/arch/x86/ia32/vsyscall-sysenter.S
+++ /dev/null
@@ -1,95 +0,0 @@
-/*
- * Code for the vsyscall page.  This version uses the sysenter instruction.
- */
-
-#include <asm/ia32_unistd.h>
-#include <asm/asm-offsets.h>
-
-	.code32
-	.text
-	.section .text.vsyscall,"ax"
-	.globl __kernel_vsyscall
-	.type __kernel_vsyscall,@function
-__kernel_vsyscall:
-.LSTART_vsyscall:
-	push	%ecx
-.Lpush_ecx:
-	push	%edx
-.Lpush_edx:
-	push	%ebp
-.Lenter_kernel:
-	movl	%esp,%ebp
-	sysenter
-	.space 7,0x90
-	jmp	.Lenter_kernel
-	/* 16: System call normal return point is here! */
-	pop	%ebp
-.Lpop_ebp:
-	pop	%edx
-.Lpop_edx:
-	pop	%ecx
-.Lpop_ecx:
-	ret
-.LEND_vsyscall:
-	.size __kernel_vsyscall,.-.LSTART_vsyscall
-
-	.section .eh_frame,"a",@progbits
-.LSTARTFRAME:
-	.long .LENDCIE-.LSTARTCIE
-.LSTARTCIE:
-	.long 0			/* CIE ID */
-	.byte 1			/* Version number */
-	.string "zR"		/* NUL-terminated augmentation string */
-	.uleb128 1		/* Code alignment factor */
-	.sleb128 -4		/* Data alignment factor */
-	.byte 8			/* Return address register column */
-	.uleb128 1		/* Augmentation value length */
-	.byte 0x1b		/* DW_EH_PE_pcrel|DW_EH_PE_sdata4. */
-	.byte 0x0c		/* DW_CFA_def_cfa */
-	.uleb128 4
-	.uleb128 4
-	.byte 0x88		/* DW_CFA_offset, column 0x8 */
-	.uleb128 1
-	.align 4
-.LENDCIE:
-
-	.long .LENDFDE1-.LSTARTFDE1	/* Length FDE */
-.LSTARTFDE1:
-	.long .LSTARTFDE1-.LSTARTFRAME	/* CIE pointer */
-	.long .LSTART_vsyscall-.	/* PC-relative start address */
-	.long .LEND_vsyscall-.LSTART_vsyscall
-	.uleb128 0			/* Augmentation length */
-	/* What follows are the instructions for the table generation.
-	   We have to record all changes of the stack pointer.  */
-	.byte 0x04		/* DW_CFA_advance_loc4 */
-	.long .Lpush_ecx-.LSTART_vsyscall
-	.byte 0x0e		/* DW_CFA_def_cfa_offset */
-	.byte 0x08		/* RA at offset 8 now */
-	.byte 0x04		/* DW_CFA_advance_loc4 */
-	.long .Lpush_edx-.Lpush_ecx
-	.byte 0x0e		/* DW_CFA_def_cfa_offset */
-	.byte 0x0c		/* RA at offset 12 now */
-	.byte 0x04		/* DW_CFA_advance_loc4 */
-	.long .Lenter_kernel-.Lpush_edx
-	.byte 0x0e		/* DW_CFA_def_cfa_offset */
-	.byte 0x10		/* RA at offset 16 now */
-	.byte 0x85, 0x04	/* DW_CFA_offset %ebp -16 */
-	/* Finally the epilogue.  */
-	.byte 0x04		/* DW_CFA_advance_loc4 */
-	.long .Lpop_ebp-.Lenter_kernel
-	.byte 0x0e		/* DW_CFA_def_cfa_offset */
-	.byte 0x12		/* RA at offset 12 now */
-	.byte 0xc5		/* DW_CFA_restore %ebp */
-	.byte 0x04		/* DW_CFA_advance_loc4 */
-	.long .Lpop_edx-.Lpop_ebp
-	.byte 0x0e		/* DW_CFA_def_cfa_offset */
-	.byte 0x08		/* RA at offset 8 now */
-	.byte 0x04		/* DW_CFA_advance_loc4 */
-	.long .Lpop_ecx-.Lpop_edx
-	.byte 0x0e		/* DW_CFA_def_cfa_offset */
-	.byte 0x04		/* RA at offset 4 now */
-	.align 4
-.LENDFDE1:
-
-#define SYSCALL_ENTER_KERNEL	int $0x80
-#include "vsyscall-sigreturn.S"
diff --git a/arch/x86/ia32/vsyscall.lds b/arch/x86/ia32/vsyscall.lds
deleted file mode 100644
index 1dc86ff..0000000
--- a/arch/x86/ia32/vsyscall.lds
+++ /dev/null
@@ -1,80 +0,0 @@
-/*
- * Linker script for vsyscall DSO.  The vsyscall page is an ELF shared
- * object prelinked to its virtual address. This script controls its layout.
- */
-
-/* This must match <asm/fixmap.h>.  */
-VSYSCALL_BASE = 0xffffe000;
-
-SECTIONS
-{
-  . = VSYSCALL_BASE + SIZEOF_HEADERS;
-
-  .hash           : { *(.hash) }		:text
-  .gnu.hash       : { *(.gnu.hash) }
-  .dynsym         : { *(.dynsym) }
-  .dynstr         : { *(.dynstr) }
-  .gnu.version    : { *(.gnu.version) }
-  .gnu.version_d  : { *(.gnu.version_d) }
-  .gnu.version_r  : { *(.gnu.version_r) }
-
-  /* This linker script is used both with -r and with -shared.
-     For the layouts to match, we need to skip more than enough
-     space for the dynamic symbol table et al.  If this amount
-     is insufficient, ld -shared will barf.  Just increase it here.  */
-  . = VSYSCALL_BASE + 0x400;
-  
-  .text.vsyscall   : { *(.text.vsyscall) } 	:text =0x90909090
-
-  /* This is an 32bit object and we cannot easily get the offsets
-     into the 64bit kernel. Just hardcode them here. This assumes
-     that all the stubs don't need more than 0x100 bytes. */
-  . = VSYSCALL_BASE + 0x500;
-
-  .text.sigreturn  : { *(.text.sigreturn) }	:text =0x90909090
-
-  . = VSYSCALL_BASE + 0x600;
-
-  .text.rtsigreturn : { *(.text.rtsigreturn) }   :text =0x90909090
-	
-  .note		  : { *(.note.*) }		:text :note
-  .eh_frame_hdr   : { *(.eh_frame_hdr) }	:text :eh_frame_hdr
-  .eh_frame       : { KEEP (*(.eh_frame)) }	:text
-  .dynamic        : { *(.dynamic) }		:text :dynamic
-  .useless        : {
-  	*(.got.plt) *(.got)
-	*(.data .data.* .gnu.linkonce.d.*)
-	*(.dynbss)
-	*(.bss .bss.* .gnu.linkonce.b.*)
-  }						:text
-}
-
-/*
- * We must supply the ELF program headers explicitly to get just one
- * PT_LOAD segment, and set the flags explicitly to make segments read-only.
- */
-PHDRS
-{
-  text PT_LOAD FILEHDR PHDRS FLAGS(5); /* PF_R|PF_X */
-  dynamic PT_DYNAMIC FLAGS(4); /* PF_R */
-  note PT_NOTE FLAGS(4); /* PF_R */
-  eh_frame_hdr 0x6474e550; /* PT_GNU_EH_FRAME, but ld doesn't match the name */
-}
-
-/*
- * This controls what symbols we export from the DSO.
- */
-VERSION
-{
-  LINUX_2.5 {
-    global:
-    	__kernel_vsyscall;
-    	__kernel_sigreturn;
-    	__kernel_rt_sigreturn;
-
-    local: *;
-  };
-}
-
-/* The ELF entry point can be used to set the AT_SYSINFO value.  */
-ENTRY(__kernel_vsyscall);
diff --git a/include/asm-x86/Kbuild b/include/asm-x86/Kbuild
index 12db5a1..22e3a28 100644
--- a/include/asm-x86/Kbuild
+++ b/include/asm-x86/Kbuild
@@ -9,7 +9,6 @@ header-y += prctl.h
 header-y += ptrace-abi.h
 header-y += sigcontext32.h
 header-y += ucontext.h
-header-y += vsyscall32.h
 
 unifdef-y += e820.h
 unifdef-y += ist.h
diff --git a/include/asm-x86/vsyscall32.h b/include/asm-x86/vsyscall32.h
deleted file mode 100644
index c631c08..0000000
--- a/include/asm-x86/vsyscall32.h
+++ /dev/null
@@ -1,20 +0,0 @@
-#ifndef _ASM_VSYSCALL32_H
-#define _ASM_VSYSCALL32_H 1
-
-/* Values need to match arch/x86_64/ia32/vsyscall.lds */
-
-#ifdef __ASSEMBLY__
-#define VSYSCALL32_BASE 0xffffe000
-#define VSYSCALL32_SYSEXIT (VSYSCALL32_BASE + 0x410)
-#else
-#define VSYSCALL32_BASE 0xffffe000UL
-#define VSYSCALL32_END (VSYSCALL32_BASE + PAGE_SIZE)
-#define VSYSCALL32_EHDR ((const struct elf32_hdr *) VSYSCALL32_BASE)
-
-#define VSYSCALL32_VSYSCALL ((void *)VSYSCALL32_BASE + 0x400) 
-#define VSYSCALL32_SYSEXIT ((void *)VSYSCALL32_BASE + 0x410)
-#define VSYSCALL32_SIGRETURN ((void __user *)VSYSCALL32_BASE + 0x500) 
-#define VSYSCALL32_RTSIGRETURN ((void __user *)VSYSCALL32_BASE + 0x600) 
-#endif
-
-#endif
