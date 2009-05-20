Return-Path: <linux-kernel-owner+w=401wt.eu-S1757062AbZETXTH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757062AbZETXTH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 19:19:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756817AbZETXSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 19:18:22 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:46580 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756207AbZETXSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 19:18:21 -0400
X-Sasl-enc: c7MMEAwN3gxKNB7yyDiDlfqfTj3nMUh1rTqbcd50W2Ik 1242861501
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Cc: Jan Beulich <JBeulich@novell.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH] i386, entry_32: introduce zeroentry and errorentry macros
Date: Thu, 21 May 2009 01:18:03 +0200
Message-Id: <1242861486-7255-6-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1242861486-7255-1-git-send-email-heukelum@fastmail.fm>
References: <1242861486-7255-1-git-send-email-heukelum@fastmail.fm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce zeroentry and errorentry macros en remove source
code duplication.

Object code unchanged

impact: introduction of zeroentry/errorentry macros

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
---
 arch/x86/kernel/entry_32.S |  185 ++++++++++----------------------------------
 1 files changed, 41 insertions(+), 144 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 3c04063..29dcd74 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -307,6 +307,31 @@
 	CFI_OFFSET ebx, PT_EBX-PT_OLDESP
 .endm
 
+/*
+ * Exception entry points.
+ */
+.macro zeroentry sym do_sym errorcode=0
+ENTRY(\sym)
+	RING0_INT_FRAME
+	pushl $\errorcode
+	CFI_ADJUST_CFA_OFFSET 4
+	pushl $\do_sym
+	CFI_ADJUST_CFA_OFFSET 4
+	jmp error_code
+	CFI_ENDPROC
+END(\sym)
+.endm
+
+.macro errorentry sym do_sym
+ENTRY(\sym)
+	RING0_EC_FRAME
+	pushl $\do_sym
+	CFI_ADJUST_CFA_OFFSET 4
+	jmp error_code
+	CFI_ENDPROC
+END(\sym)
+.endm
+
 ENTRY(ret_from_fork)
 	CFI_STARTPROC
 	pushl %eax
@@ -800,35 +825,9 @@ ENDPROC(name)
 /* The include is where all of the SMP etc. interrupts come from */
 #include <asm/entry_arch.h>
 
-ENTRY(coprocessor_error)
-	RING0_INT_FRAME
-	pushl $0
-	CFI_ADJUST_CFA_OFFSET 4
-	pushl $do_coprocessor_error
-	CFI_ADJUST_CFA_OFFSET 4
-	jmp error_code
-	CFI_ENDPROC
-END(coprocessor_error)
-
-ENTRY(simd_coprocessor_error)
-	RING0_INT_FRAME
-	pushl $0
-	CFI_ADJUST_CFA_OFFSET 4
-	pushl $do_simd_coprocessor_error
-	CFI_ADJUST_CFA_OFFSET 4
-	jmp error_code
-	CFI_ENDPROC
-END(simd_coprocessor_error)
-
-ENTRY(device_not_available)
-	RING0_INT_FRAME
-	pushl $-1			# mark this as an int
-	CFI_ADJUST_CFA_OFFSET 4
-	pushl $do_device_not_available
-	CFI_ADJUST_CFA_OFFSET 4
-	jmp error_code
-	CFI_ENDPROC
-END(device_not_available)
+zeroentry coprocessor_error do_coprocessor_error
+zeroentry simd_coprocessor_error do_simd_coprocessor_error
+zeroentry device_not_available do_device_not_available -1
 
 #ifdef CONFIG_PARAVIRT
 ENTRY(native_iret)
@@ -845,109 +844,19 @@ ENTRY(native_irq_enable_sysexit)
 END(native_irq_enable_sysexit)
 #endif
 
-ENTRY(overflow)
-	RING0_INT_FRAME
-	pushl $0
-	CFI_ADJUST_CFA_OFFSET 4
-	pushl $do_overflow
-	CFI_ADJUST_CFA_OFFSET 4
-	jmp error_code
-	CFI_ENDPROC
-END(overflow)
-
-ENTRY(bounds)
-	RING0_INT_FRAME
-	pushl $0
-	CFI_ADJUST_CFA_OFFSET 4
-	pushl $do_bounds
-	CFI_ADJUST_CFA_OFFSET 4
-	jmp error_code
-	CFI_ENDPROC
-END(bounds)
-
-ENTRY(invalid_op)
-	RING0_INT_FRAME
-	pushl $0
-	CFI_ADJUST_CFA_OFFSET 4
-	pushl $do_invalid_op
-	CFI_ADJUST_CFA_OFFSET 4
-	jmp error_code
-	CFI_ENDPROC
-END(invalid_op)
-
-ENTRY(coprocessor_segment_overrun)
-	RING0_INT_FRAME
-	pushl $0
-	CFI_ADJUST_CFA_OFFSET 4
-	pushl $do_coprocessor_segment_overrun
-	CFI_ADJUST_CFA_OFFSET 4
-	jmp error_code
-	CFI_ENDPROC
-END(coprocessor_segment_overrun)
-
-ENTRY(invalid_TSS)
-	RING0_EC_FRAME
-	pushl $do_invalid_TSS
-	CFI_ADJUST_CFA_OFFSET 4
-	jmp error_code
-	CFI_ENDPROC
-END(invalid_TSS)
-
-ENTRY(segment_not_present)
-	RING0_EC_FRAME
-	pushl $do_segment_not_present
-	CFI_ADJUST_CFA_OFFSET 4
-	jmp error_code
-	CFI_ENDPROC
-END(segment_not_present)
-
-ENTRY(stack_segment)
-	RING0_EC_FRAME
-	pushl $do_stack_segment
-	CFI_ADJUST_CFA_OFFSET 4
-	jmp error_code
-	CFI_ENDPROC
-END(stack_segment)
-
-ENTRY(alignment_check)
-	RING0_EC_FRAME
-	pushl $do_alignment_check
-	CFI_ADJUST_CFA_OFFSET 4
-	jmp error_code
-	CFI_ENDPROC
-END(alignment_check)
-
-ENTRY(divide_error)
-	RING0_INT_FRAME
-	pushl $0			# no error code
-	CFI_ADJUST_CFA_OFFSET 4
-	pushl $do_divide_error
-	CFI_ADJUST_CFA_OFFSET 4
-	jmp error_code
-	CFI_ENDPROC
-END(divide_error)
-
+zeroentry overflow do_overflow
+zeroentry bounds do_bounds
+zeroentry invalid_op do_invalid_op
+zeroentry coprocessor_segment_overrun do_coprocessor_segment_overrun
+errorentry invalid_TSS do_invalid_TSS
+errorentry segment_not_present do_segment_not_present
+errorentry stack_segment do_stack_segment
+errorentry alignment_check do_alignment_check
+zeroentry divide_error do_divide_error
 #ifdef CONFIG_X86_MCE
-ENTRY(machine_check)
-	RING0_INT_FRAME
-	pushl $0
-	CFI_ADJUST_CFA_OFFSET 4
-	pushl $do_machine_check
-	CFI_ADJUST_CFA_OFFSET 4
-	jmp error_code
-	CFI_ENDPROC
-END(machine_check)
+zeroentry machine_check do_machine_check
 #endif
-
-ENTRY(spurious_interrupt_bug)
-	RING0_INT_FRAME
-	pushl $0
-	CFI_ADJUST_CFA_OFFSET 4
-	pushl $do_spurious_interrupt_bug
-	CFI_ADJUST_CFA_OFFSET 4
-	jmp error_code
-	CFI_ENDPROC
-END(spurious_interrupt_bug)
+zeroentry spurious_interrupt_bug do_spurious_interrupt_bug
 
 ENTRY(kernel_thread_helper)
 	pushl $0		# fake return address for unwinder
@@ -1174,13 +1083,7 @@ syscall_table_size=(.-sys_call_table)
  */
 	.pushsection .kprobes.text, "ax"
 
-ENTRY(page_fault)
-	RING0_EC_FRAME
-	pushl $do_page_fault
-	CFI_ADJUST_CFA_OFFSET 4
-	jmp error_code
-	CFI_ENDPROC
-END(page_fault)
+errorentry page_fault do_page_fault
 
 ENTRY(error_code)
 	RING0_EC_FRAME
@@ -1382,13 +1285,7 @@ ENTRY(int3)
 	CFI_ENDPROC
 END(int3)
 
-ENTRY(general_protection)
-	RING0_EC_FRAME
-	pushl $do_general_protection
-	CFI_ADJUST_CFA_OFFSET 4
-	jmp error_code
-	CFI_ENDPROC
-END(general_protection)
+errorentry general_protection do_general_protection
 
 /*
  * End of kprobes section
-- 
1.6.0.4

