Return-Path: <linux-kernel-owner+w=401wt.eu-S1756265AbZETXUO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756265AbZETXUO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 19:20:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756865AbZETXSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 19:18:31 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:44415 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756619AbZETXS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 19:18:29 -0400
X-Sasl-enc: 6p0BSkZkMbkGS9KBiFe0uUPs0Zv4JdhUxnbxS/mNf+5K 1242861509
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Cc: Jan Beulich <JBeulich@novell.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH] i386, entry_32: cleanup macro usage
Date: Thu, 21 May 2009 01:18:06 +0200
Message-Id: <1242861486-7255-9-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1242861486-7255-1-git-send-email-heukelum@fastmail.fm>
References: <1242861486-7255-1-git-send-email-heukelum@fastmail.fm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup macro usage

The function fixup_espfix_stack is now called from nmi_espfix_stack
instead of having the code duplicated inline.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
---
 arch/x86/kernel/entry_32.S |  113 ++++++--------------------------------------
 1 files changed, 15 insertions(+), 98 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index d089897..1b6bbd5 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -103,10 +103,6 @@
 #ifdef CONFIG_X86_32_LAZY_GS
 
  /* unfortunately push/pop can't be no-op */
-.macro PUSH_GS
-	pushl $0
-	CFI_ADJUST_CFA_OFFSET 4
-.endm
 .macro POP_GS pop=0
 	addl $(4 + \pop), %esp
 	CFI_ADJUST_CFA_OFFSET -(4 + \pop)
@@ -119,21 +115,9 @@
 .endm
 .macro PTGS_TO_GS_EX
 .endm
-.macro GS_TO_REG reg
-.endm
-.macro REG_TO_PTGS reg
-.endm
-.macro SET_KERNEL_GS reg
-.endm
 
 #else	/* CONFIG_X86_32_LAZY_GS */
 
-.macro PUSH_GS
-	pushl %gs
-	CFI_ADJUST_CFA_OFFSET 4
-	/*CFI_REL_OFFSET gs, 0*/
-.endm
-
 .macro POP_GS pop=0
 98:	popl %gs
 	CFI_ADJUST_CFA_OFFSET -4
@@ -166,60 +150,11 @@
 .popsection
 .endm
 
-.macro GS_TO_REG reg
-	movl %gs, \reg
-	/*CFI_REGISTER gs, \reg*/
-.endm
-.macro REG_TO_PTGS reg
-	movl \reg, PT_GS(%esp)
-	/*CFI_REL_OFFSET gs, PT_GS*/
-.endm
-.macro SET_KERNEL_GS reg
-	movl $(__KERNEL_STACK_CANARY), \reg
-	movl \reg, %gs
-.endm
-
 #endif	/* CONFIG_X86_32_LAZY_GS */
 
 .macro SAVE_ALL
-	cld
-	PUSH_GS
-	pushl %fs
-	CFI_ADJUST_CFA_OFFSET 4
-	/*CFI_REL_OFFSET fs, 0;*/
-	pushl %es
-	CFI_ADJUST_CFA_OFFSET 4
-	/*CFI_REL_OFFSET es, 0;*/
-	pushl %ds
-	CFI_ADJUST_CFA_OFFSET 4
-	/*CFI_REL_OFFSET ds, 0;*/
-	pushl %eax
-	CFI_ADJUST_CFA_OFFSET 4
-	CFI_REL_OFFSET eax, 0
-	pushl %ebp
-	CFI_ADJUST_CFA_OFFSET 4
-	CFI_REL_OFFSET ebp, 0
-	pushl %edi
-	CFI_ADJUST_CFA_OFFSET 4
-	CFI_REL_OFFSET edi, 0
-	pushl %esi
-	CFI_ADJUST_CFA_OFFSET 4
-	CFI_REL_OFFSET esi, 0
-	pushl %edx
-	CFI_ADJUST_CFA_OFFSET 4
-	CFI_REL_OFFSET edx, 0
-	pushl %ecx
-	CFI_ADJUST_CFA_OFFSET 4
-	CFI_REL_OFFSET ecx, 0
-	pushl %ebx
-	CFI_ADJUST_CFA_OFFSET 4
-	CFI_REL_OFFSET ebx, 0
-	movl $(__USER_DS), %edx
-	movl %edx, %ds
-	movl %edx, %es
-	movl $(__KERNEL_PERCPU), %edx
-	movl %edx, %fs
-	SET_KERNEL_GS %edx
+	sub $11*4, %esp
+	call save_entry
 .endm
 
 .macro RESTORE_INT_REGS
@@ -315,8 +250,7 @@ ENTRY(\sym)
 	RING0_INT_FRAME
 	pushl $-1	/* no syscall to restart */
 	CFI_ADJUST_CFA_OFFSET 4
-	sub $11*4, %esp
-	call save_entry
+	SAVE_ALL
 
 	/* see if on espfix stack */
 	mov %ss, %eax
@@ -336,8 +270,7 @@ END(\sym)
 .macro errorentry sym do_sym
 ENTRY(\sym)
 	RING0_EC_FRAME
-	sub $11*4, %esp
-	call save_entry
+	SAVE_ALL
 
 	/* see if on espfix stack */
 	mov %ss, %eax
@@ -748,31 +681,6 @@ PTREGSCALL(rt_sigreturn)
 PTREGSCALL(vm86)
 PTREGSCALL(vm86old)
 
-.macro FIXUP_ESPFIX_STACK
-	/* since we are on a wrong stack, we cant make it a C code :( */
-	PER_CPU(gdt_page, %ebx)
-	GET_DESC_BASE(GDT_ENTRY_ESPFIX_SS, %ebx, %eax, %ax, %al, %ah)
-	addl %esp, %eax
-	pushl $__KERNEL_DS
-	CFI_ADJUST_CFA_OFFSET 4
-	pushl %eax
-	CFI_ADJUST_CFA_OFFSET 4
-	lss (%esp), %esp
-	CFI_ADJUST_CFA_OFFSET -8
-.endm
-.macro UNWIND_ESPFIX_STACK
-	movl %ss, %eax
-	/* see if on espfix stack */
-	cmpw $__ESPFIX_SS, %ax
-	jne 27f
-	movl $__KERNEL_DS, %eax
-	movl %eax, %ds
-	movl %eax, %es
-	/* switch to normal stack */
-	FIXUP_ESPFIX_STACK
-27:
-.endm
-
 /*
  * Build the entry stubs and pointer table with some assembler magic.
  * We pack 7 stubs into a single 32-byte chunk, which will fit in a
@@ -1145,7 +1053,16 @@ ENTRY(save_entry)
 END(save_entry)
 
 ENTRY(fixup_espfix_stack)
-	FIXUP_ESPFIX_STACK
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
 	ret
 END(fixup_espfix_stack)
 
@@ -1272,7 +1189,7 @@ nmi_espfix_stack:
 	pushl %eax
 	CFI_ADJUST_CFA_OFFSET 4
 	SAVE_ALL
-	FIXUP_ESPFIX_STACK		# %eax == %esp
+	call fixup_espfix_stack		# %eax == %esp
 	xorl %edx,%edx			# zero error code
 	call do_nmi
 	RESTORE_REGS
-- 
1.6.0.4

