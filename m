Return-Path: <linux-kernel-owner+w=401wt.eu-S1757324AbZETXTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757324AbZETXTf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 19:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756906AbZETXS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 19:18:28 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:43043 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755747AbZETXS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 19:18:26 -0400
X-Sasl-enc: QYcu8NsL60LCoi74oaNbNE7Jcg1nTSXXJlDT0s941/K9 1242861506
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Cc: Jan Beulich <JBeulich@novell.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH] i386, entry_32: remove indirect calls to exception handlers
Date: Thu, 21 May 2009 01:18:05 +0200
Message-Id: <1242861486-7255-8-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1242861486-7255-1-git-send-email-heukelum@fastmail.fm>
References: <1242861486-7255-1-git-send-email-heukelum@fastmail.fm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch separates out register saving and setting up the C environment
to a function "save_entry". This largely replaces error_entry, which was
called with the address of the exception handler on the stack in the slot
that was reserved for %gs. Also separated out is setting the correct stack
if the current stack is the espfix stack, but for performance reasons the
check itself is now inlined in the handler stub.

No functional change intended.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
---
 arch/x86/kernel/entry_32.S |  131 ++++++++++++++++++++++++--------------------
 1 files changed, 72 insertions(+), 59 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 407443c..d089897 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -313,11 +313,22 @@
 .macro zeroentry sym do_sym errorcode=0
 ENTRY(\sym)
 	RING0_INT_FRAME
-	pushl $\errorcode
+	pushl $-1	/* no syscall to restart */
 	CFI_ADJUST_CFA_OFFSET 4
-	pushl $\do_sym
-	CFI_ADJUST_CFA_OFFSET 4
-	jmp error_code
+	sub $11*4, %esp
+	call save_entry
+
+	/* see if on espfix stack */
+	mov %ss, %eax
+	cmp $__ESPFIX_SS, %eax
+	jne 1f
+	call fixup_espfix_stack		/* switch to normal stack */
+1:	TRACE_IRQS_OFF
+
+	movl $\errorcode, %edx		/* made-up error code */
+	movl %esp,%eax			/* pt_regs pointer */
+	call \do_sym
+	jmp ret_from_exception
 	CFI_ENDPROC
 END(\sym)
 .endm
@@ -325,9 +336,21 @@ END(\sym)
 .macro errorentry sym do_sym
 ENTRY(\sym)
 	RING0_EC_FRAME
-	pushl $\do_sym
-	CFI_ADJUST_CFA_OFFSET 4
-	jmp error_code
+	sub $11*4, %esp
+	call save_entry
+
+	/* see if on espfix stack */
+	mov %ss, %eax
+	cmp $__ESPFIX_SS, %eax
+	jne 1f
+	call fixup_espfix_stack		/* switch to normal stack */
+1:	TRACE_IRQS_OFF
+
+	movl PT_ORIG_EAX(%esp), %edx	/* get the error code */
+	movl $-1, PT_ORIG_EAX(%esp)	/* no syscall to restart */
+	movl %esp, %eax			/* pt_regs pointer */
+	call \do_sym
+	jmp ret_from_exception
 	CFI_ENDPROC
 END(\sym)
 .endm
@@ -1082,59 +1105,49 @@ syscall_table_size=(.-sys_call_table)
 
 errorentry page_fault do_page_fault
 
-ENTRY(error_code)
-	RING0_EC_FRAME
-	CFI_ADJUST_CFA_OFFSET 4
-	/* the function address is in %gs's slot on the stack */
-	pushl %fs
-	CFI_ADJUST_CFA_OFFSET 4
-	/*CFI_REL_OFFSET fs, 0*/
-	pushl %es
-	CFI_ADJUST_CFA_OFFSET 4
-	/*CFI_REL_OFFSET es, 0*/
-	pushl %ds
-	CFI_ADJUST_CFA_OFFSET 4
-	/*CFI_REL_OFFSET ds, 0*/
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
+ENTRY(save_entry)
+	RING0_PTREGS_FRAME
+	CFI_ADJUST_CFA_OFFSET 4	/* return address */
+	/* save registers */
+	mov %ebx, PT_EBX+4(%esp)
+	mov %ecx, PT_ECX+4(%esp)
+	mov %edx, PT_EDX+4(%esp)
+	mov %esi, PT_ESI+4(%esp)
+	mov %edi, PT_EDI+4(%esp)
+	mov %ebp, PT_EBP+4(%esp)
+	mov %eax, PT_EAX+4(%esp)
+
+	/* save segment registers */
+	mov %ds, %edx
+	mov %edx, PT_DS+4(%esp)
+	mov %es, %edx
+	mov %edx, PT_ES+4(%esp)
+	mov %fs, %edx
+	mov %edx, PT_FS+4(%esp)
+#ifdef CONFIG_X86_32_LAZY_GS
+	movl $0, PT_GS+4(%esp)
+#else
+	mov %gs, %edx
+	mov %edx, PT_GS+4(%esp)
+#endif
+	/* set C environment */
 	cld
-	movl $(__KERNEL_PERCPU), %ecx
-	movl %ecx, %fs
-	UNWIND_ESPFIX_STACK
-	GS_TO_REG %ecx
-	movl PT_GS(%esp), %edi		# get the function address
-	movl PT_ORIG_EAX(%esp), %edx	# get the error code
-	movl $-1, PT_ORIG_EAX(%esp)	# no syscall to restart
-	REG_TO_PTGS %ecx
-	SET_KERNEL_GS %ecx
-	movl $(__USER_DS), %ecx
-	movl %ecx, %ds
-	movl %ecx, %es
-	TRACE_IRQS_OFF
-	movl %esp,%eax			# pt_regs pointer
-	call *%edi
-	jmp ret_from_exception
-	CFI_ENDPROC
-END(error_code)
+	movl $(__USER_DS), %edx
+	movl %edx, %ds
+	movl %edx, %es
+	movl $(__KERNEL_PERCPU), %edx
+	movl %edx, %fs
+#ifndef CONFIG_X86_32_LAZY_GS
+	movl $(__KERNEL_STACK_CANARY), %edx
+	movl %edx, %gs
+#endif
+	ret
+END(save_entry)
+
+ENTRY(fixup_espfix_stack)
+	FIXUP_ESPFIX_STACK
+	ret
+END(fixup_espfix_stack)
 
 /*
  * Debug traps and NMI can happen at the one SYSENTER instruction
-- 
1.6.0.4

