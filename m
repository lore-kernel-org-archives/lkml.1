Return-Path: <linux-kernel-owner+w=401wt.eu-S1756227AbZBINnD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227AbZBINnD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 08:43:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756010AbZBINkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 08:40:55 -0500
Received: from hera.kernel.org ([140.211.167.34]:37860 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755954AbZBINkx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 08:40:53 -0500
From: Tejun Heo <tj@kernel.org>
To: hpa@zytor.com, jeremy@goop.org, tglx@linutronix.de, mingo@elte.hu,
       linux-kernel@vger.kernel.org, x86@kernel.org, rusty@rustcorp.com.au
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 08/11] x86: use asm .macro instead of cpp #define in entry_32.S
Date: Mon,  9 Feb 2009 22:39:55 +0900
Message-Id: <1234186798-16820-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1234186798-16820-1-git-send-email-tj@kernel.org>
References: <1234186798-16820-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 09 Feb 2009 13:40:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Use .macro instead of cpp #define where approriate.  This cleans up
code and will ease future changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/kernel/entry_32.S |  293 +++++++++++++++++++++++---------------------
 1 files changed, 151 insertions(+), 142 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 65efd42..224739c 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -101,121 +101,127 @@
 #define resume_userspace_sig	resume_userspace
 #endif
 
-#define SAVE_ALL \
-	cld; \
-	pushl %fs; \
-	CFI_ADJUST_CFA_OFFSET 4;\
-	/*CFI_REL_OFFSET fs, 0;*/\
-	pushl %es; \
-	CFI_ADJUST_CFA_OFFSET 4;\
-	/*CFI_REL_OFFSET es, 0;*/\
-	pushl %ds; \
-	CFI_ADJUST_CFA_OFFSET 4;\
-	/*CFI_REL_OFFSET ds, 0;*/\
-	pushl %eax; \
-	CFI_ADJUST_CFA_OFFSET 4;\
-	CFI_REL_OFFSET eax, 0;\
-	pushl %ebp; \
-	CFI_ADJUST_CFA_OFFSET 4;\
-	CFI_REL_OFFSET ebp, 0;\
-	pushl %edi; \
-	CFI_ADJUST_CFA_OFFSET 4;\
-	CFI_REL_OFFSET edi, 0;\
-	pushl %esi; \
-	CFI_ADJUST_CFA_OFFSET 4;\
-	CFI_REL_OFFSET esi, 0;\
-	pushl %edx; \
-	CFI_ADJUST_CFA_OFFSET 4;\
-	CFI_REL_OFFSET edx, 0;\
-	pushl %ecx; \
-	CFI_ADJUST_CFA_OFFSET 4;\
-	CFI_REL_OFFSET ecx, 0;\
-	pushl %ebx; \
-	CFI_ADJUST_CFA_OFFSET 4;\
-	CFI_REL_OFFSET ebx, 0;\
-	movl $(__USER_DS), %edx; \
-	movl %edx, %ds; \
-	movl %edx, %es; \
-	movl $(__KERNEL_PERCPU), %edx; \
+.macro SAVE_ALL
+	cld
+	pushl %fs
+	CFI_ADJUST_CFA_OFFSET 4
+	/*CFI_REL_OFFSET fs, 0;*/
+	pushl %es
+	CFI_ADJUST_CFA_OFFSET 4
+	/*CFI_REL_OFFSET es, 0;*/
+	pushl %ds
+	CFI_ADJUST_CFA_OFFSET 4
+	/*CFI_REL_OFFSET ds, 0;*/
+	pushl %eax
+	CFI_ADJUST_CFA_OFFSET 4
+	CFI_REL_OFFSET eax, 0
+	pushl %ebp
+	CFI_ADJUST_CFA_OFFSET 4
+	CFI_REL_OFFSET ebp, 0
+	pushl %edi
+	CFI_ADJUST_CFA_OFFSET 4
+	CFI_REL_OFFSET edi, 0
+	pushl %esi
+	CFI_ADJUST_CFA_OFFSET 4
+	CFI_REL_OFFSET esi, 0
+	pushl %edx
+	CFI_ADJUST_CFA_OFFSET 4
+	CFI_REL_OFFSET edx, 0
+	pushl %ecx
+	CFI_ADJUST_CFA_OFFSET 4
+	CFI_REL_OFFSET ecx, 0
+	pushl %ebx
+	CFI_ADJUST_CFA_OFFSET 4
+	CFI_REL_OFFSET ebx, 0
+	movl $(__USER_DS), %edx
+	movl %edx, %ds
+	movl %edx, %es
+	movl $(__KERNEL_PERCPU), %edx
 	movl %edx, %fs
+.endm
 
-#define RESTORE_INT_REGS \
-	popl %ebx;	\
-	CFI_ADJUST_CFA_OFFSET -4;\
-	CFI_RESTORE ebx;\
-	popl %ecx;	\
-	CFI_ADJUST_CFA_OFFSET -4;\
-	CFI_RESTORE ecx;\
-	popl %edx;	\
-	CFI_ADJUST_CFA_OFFSET -4;\
-	CFI_RESTORE edx;\
-	popl %esi;	\
-	CFI_ADJUST_CFA_OFFSET -4;\
-	CFI_RESTORE esi;\
-	popl %edi;	\
-	CFI_ADJUST_CFA_OFFSET -4;\
-	CFI_RESTORE edi;\
-	popl %ebp;	\
-	CFI_ADJUST_CFA_OFFSET -4;\
-	CFI_RESTORE ebp;\
-	popl %eax;	\
-	CFI_ADJUST_CFA_OFFSET -4;\
+.macro RESTORE_INT_REGS
+	popl %ebx
+	CFI_ADJUST_CFA_OFFSET -4
+	CFI_RESTORE ebx
+	popl %ecx
+	CFI_ADJUST_CFA_OFFSET -4
+	CFI_RESTORE ecx
+	popl %edx
+	CFI_ADJUST_CFA_OFFSET -4
+	CFI_RESTORE edx
+	popl %esi
+	CFI_ADJUST_CFA_OFFSET -4
+	CFI_RESTORE esi
+	popl %edi
+	CFI_ADJUST_CFA_OFFSET -4
+	CFI_RESTORE edi
+	popl %ebp
+	CFI_ADJUST_CFA_OFFSET -4
+	CFI_RESTORE ebp
+	popl %eax
+	CFI_ADJUST_CFA_OFFSET -4
 	CFI_RESTORE eax
+.endm
 
-#define RESTORE_REGS	\
-	RESTORE_INT_REGS; \
-1:	popl %ds;	\
-	CFI_ADJUST_CFA_OFFSET -4;\
-	/*CFI_RESTORE ds;*/\
-2:	popl %es;	\
-	CFI_ADJUST_CFA_OFFSET -4;\
-	/*CFI_RESTORE es;*/\
-3:	popl %fs;	\
-	CFI_ADJUST_CFA_OFFSET -4;\
-	/*CFI_RESTORE fs;*/\
-.pushsection .fixup,"ax";	\
-4:	movl $0,(%esp);	\
-	jmp 1b;		\
-5:	movl $0,(%esp);	\
-	jmp 2b;		\
-6:	movl $0,(%esp);	\
-	jmp 3b;		\
-.section __ex_table,"a";\
-	.align 4;	\
-	.long 1b,4b;	\
-	.long 2b,5b;	\
-	.long 3b,6b;	\
+.macro RESTORE_REGS
+	RESTORE_INT_REGS
+1:	popl %ds
+	CFI_ADJUST_CFA_OFFSET -4
+	/*CFI_RESTORE ds;*/
+2:	popl %es
+	CFI_ADJUST_CFA_OFFSET -4
+	/*CFI_RESTORE es;*/
+3:	popl %fs
+	CFI_ADJUST_CFA_OFFSET -4
+	/*CFI_RESTORE fs;*/
+.pushsection .fixup, "ax"
+4:	movl $0, (%esp)
+	jmp 1b
+5:	movl $0, (%esp)
+	jmp 2b
+6:	movl $0, (%esp)
+	jmp 3b
+.section __ex_table, "a"
+	.align 4
+	.long 1b, 4b
+	.long 2b, 5b
+	.long 3b, 6b
 .popsection
+.endm
 
-#define RING0_INT_FRAME \
-	CFI_STARTPROC simple;\
-	CFI_SIGNAL_FRAME;\
-	CFI_DEF_CFA esp, 3*4;\
-	/*CFI_OFFSET cs, -2*4;*/\
+.macro RING0_INT_FRAME
+	CFI_STARTPROC simple
+	CFI_SIGNAL_FRAME
+	CFI_DEF_CFA esp, 3*4
+	/*CFI_OFFSET cs, -2*4;*/
 	CFI_OFFSET eip, -3*4
+.endm
 
-#define RING0_EC_FRAME \
-	CFI_STARTPROC simple;\
-	CFI_SIGNAL_FRAME;\
-	CFI_DEF_CFA esp, 4*4;\
-	/*CFI_OFFSET cs, -2*4;*/\
+.macro RING0_EC_FRAME
+	CFI_STARTPROC simple
+	CFI_SIGNAL_FRAME
+	CFI_DEF_CFA esp, 4*4
+	/*CFI_OFFSET cs, -2*4;*/
 	CFI_OFFSET eip, -3*4
+.endm
 
-#define RING0_PTREGS_FRAME \
-	CFI_STARTPROC simple;\
-	CFI_SIGNAL_FRAME;\
-	CFI_DEF_CFA esp, PT_OLDESP-PT_EBX;\
-	/*CFI_OFFSET cs, PT_CS-PT_OLDESP;*/\
-	CFI_OFFSET eip, PT_EIP-PT_OLDESP;\
-	/*CFI_OFFSET es, PT_ES-PT_OLDESP;*/\
-	/*CFI_OFFSET ds, PT_DS-PT_OLDESP;*/\
-	CFI_OFFSET eax, PT_EAX-PT_OLDESP;\
-	CFI_OFFSET ebp, PT_EBP-PT_OLDESP;\
-	CFI_OFFSET edi, PT_EDI-PT_OLDESP;\
-	CFI_OFFSET esi, PT_ESI-PT_OLDESP;\
-	CFI_OFFSET edx, PT_EDX-PT_OLDESP;\
-	CFI_OFFSET ecx, PT_ECX-PT_OLDESP;\
+.macro RING0_PTREGS_FRAME
+	CFI_STARTPROC simple
+	CFI_SIGNAL_FRAME
+	CFI_DEF_CFA esp, PT_OLDESP-PT_EBX
+	/*CFI_OFFSET cs, PT_CS-PT_OLDESP;*/
+	CFI_OFFSET eip, PT_EIP-PT_OLDESP
+	/*CFI_OFFSET es, PT_ES-PT_OLDESP;*/
+	/*CFI_OFFSET ds, PT_DS-PT_OLDESP;*/
+	CFI_OFFSET eax, PT_EAX-PT_OLDESP
+	CFI_OFFSET ebp, PT_EBP-PT_OLDESP
+	CFI_OFFSET edi, PT_EDI-PT_OLDESP
+	CFI_OFFSET esi, PT_ESI-PT_OLDESP
+	CFI_OFFSET edx, PT_EDX-PT_OLDESP
+	CFI_OFFSET ecx, PT_ECX-PT_OLDESP
 	CFI_OFFSET ebx, PT_EBX-PT_OLDESP
+.endm
 
 ENTRY(ret_from_fork)
 	CFI_STARTPROC
@@ -595,28 +601,30 @@ syscall_badsys:
 END(syscall_badsys)
 	CFI_ENDPROC
 
-#define FIXUP_ESPFIX_STACK \
-	/* since we are on a wrong stack, we cant make it a C code :( */ \
-	PER_CPU(gdt_page, %ebx); \
-	GET_DESC_BASE(GDT_ENTRY_ESPFIX_SS, %ebx, %eax, %ax, %al, %ah); \
-	addl %esp, %eax; \
-	pushl $__KERNEL_DS; \
-	CFI_ADJUST_CFA_OFFSET 4; \
-	pushl %eax; \
-	CFI_ADJUST_CFA_OFFSET 4; \
-	lss (%esp), %esp; \
-	CFI_ADJUST_CFA_OFFSET -8;
-#define UNWIND_ESPFIX_STACK \
-	movl %ss, %eax; \
-	/* see if on espfix stack */ \
-	cmpw $__ESPFIX_SS, %ax; \
-	jne 27f; \
-	movl $__KERNEL_DS, %eax; \
-	movl %eax, %ds; \
-	movl %eax, %es; \
-	/* switch to normal stack */ \
-	FIXUP_ESPFIX_STACK; \
-27:;
+.macro FIXUP_ESPFIX_STACK
+	/* since we are on a wrong stack, we cant make it a C code :( */
+	PER_CPU(gdt_page, %ebx)
+	GET_DESC_BASE(GDT_ENTRY_ESPFIX_SS, %ebx, %eax, %ax, %al, %ah)
+	addl %esp, %eax
+	pushl $__KERNEL_DS
+	CFI_ADJUST_CFA_OFFSET 4
+	pushl %eax
+	CFI_ADJUST_CFA_OFFSET 4
+	lss (%esp), %esp
+	CFI_ADJUST_CFA_OFFSET -8
+.endm
+.macro UNWIND_ESPFIX_STACK
+	movl %ss, %eax
+	/* see if on espfix stack */
+	cmpw $__ESPFIX_SS, %ax
+	jne 27f
+	movl $__KERNEL_DS, %eax
+	movl %eax, %ds
+	movl %eax, %es
+	/* switch to normal stack */
+	FIXUP_ESPFIX_STACK
+27:
+.endm
 
 /*
  * Build the entry stubs and pointer table with some assembler magic.
@@ -1136,26 +1144,27 @@ END(page_fault)
  * by hand onto the new stack - while updating the return eip past
  * the instruction that would have done it for sysenter.
  */
-#define FIX_STACK(offset, ok, label)		\
-	cmpw $__KERNEL_CS,4(%esp);		\
-	jne ok;					\
-label:						\
-	movl TSS_sysenter_sp0+offset(%esp),%esp;	\
-	CFI_DEF_CFA esp, 0;			\
-	CFI_UNDEFINED eip;			\
-	pushfl;					\
-	CFI_ADJUST_CFA_OFFSET 4;		\
-	pushl $__KERNEL_CS;			\
-	CFI_ADJUST_CFA_OFFSET 4;		\
-	pushl $sysenter_past_esp;		\
-	CFI_ADJUST_CFA_OFFSET 4;		\
+.macro FIX_STACK offset ok label
+	cmpw $__KERNEL_CS, 4(%esp)
+	jne \ok
+\label:
+	movl TSS_sysenter_sp0 + \offset(%esp), %esp
+	CFI_DEF_CFA esp, 0
+	CFI_UNDEFINED eip
+	pushfl
+	CFI_ADJUST_CFA_OFFSET 4
+	pushl $__KERNEL_CS
+	CFI_ADJUST_CFA_OFFSET 4
+	pushl $sysenter_past_esp
+	CFI_ADJUST_CFA_OFFSET 4
 	CFI_REL_OFFSET eip, 0
+.endm
 
 ENTRY(debug)
 	RING0_INT_FRAME
 	cmpl $ia32_sysenter_target,(%esp)
 	jne debug_stack_correct
-	FIX_STACK(12, debug_stack_correct, debug_esp_fix_insn)
+	FIX_STACK 12, debug_stack_correct, debug_esp_fix_insn
 debug_stack_correct:
 	pushl $-1			# mark this as an int
 	CFI_ADJUST_CFA_OFFSET 4
@@ -1213,7 +1222,7 @@ nmi_stack_correct:
 
 nmi_stack_fixup:
 	RING0_INT_FRAME
-	FIX_STACK(12,nmi_stack_correct, 1)
+	FIX_STACK 12, nmi_stack_correct, 1
 	jmp nmi_stack_correct
 
 nmi_debug_stack_check:
@@ -1224,7 +1233,7 @@ nmi_debug_stack_check:
 	jb nmi_stack_correct
 	cmpl $debug_esp_fix_insn,(%esp)
 	ja nmi_stack_correct
-	FIX_STACK(24,nmi_stack_correct, 1)
+	FIX_STACK 24, nmi_stack_correct, 1
 	jmp nmi_stack_correct
 
 nmi_espfix_stack:
-- 
1.6.0.2

