Return-Path: <linux-kernel-owner+w=401wt.eu-S1753341AbYKXOmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341AbYKXOmB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 09:42:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752563AbYKXOlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 09:41:53 -0500
Received: from triton.rz.uni-saarland.de ([134.96.7.25]:24374 "EHLO
	triton.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471AbYKXOlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 09:41:52 -0500
Date: Mon, 24 Nov 2008 15:38:45 +0100
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Jan Beulich <jbeulich@novell.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Glauber Costa <gcosta@redhat.com>,
       Matt Mackall <mpm@selenic.com>, LKML <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] i386: get rid of the use of KPROBE_ENTRY / KPROBE_END
Message-ID: <20081124143845.GA8902@mailshack.com>
References: <20081121154318.GA13014@mailshack.com> <20081121154428.GB13014@mailshack.com> <20081121160629.GA24839@elte.hu> <20081123090828.GA31490@mailshack.com> <20081123091532.GA31515@mailshack.com> <492A7F39.76E4.0078.0@novell.com> <20081124102600.GA8335@mailshack.com> <492A9199.76E4.0078.0@novell.com> <20081124122428.GA8497@mailshack.com> <492ABB4D.76E4.0078.0@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <492ABB4D.76E4.0078.0@novell.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (triton.rz.uni-saarland.de [134.96.7.25]); Mon, 24 Nov 2008 15:40:59 +0100 (CET)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.9.0.35; VDF: 7.1.0.129; host: AntiVir3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

entry_32.S is now the only user of KPROBE_ENTRY / KPROBE_END,
treewide. This patch reorders entry_64.S and explicitly generates
a separate section for functions that need the protection. The
generated code before and after the patch is equal.

The KPROBE_ENTRY and KPROBE_END macro's are removed too.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
---
 arch/x86/kernel/entry_32.S |  438 ++++++++++++++++++++++---------------------
 include/linux/linkage.h    |    8 -
 2 files changed, 224 insertions(+), 222 deletions(-)

On Mon, Nov 24, 2008 at 01:33:49PM +0000, Jan Beulich wrote:
> I like things being done this way (including the goal of doing away with
> KPROBE_{ENTRY,END} altogether). Thanks a lot! Jan

Thanks for the comment. Here is the i386-side of the patch, including
the removal of the KPROBE_ENTRY and KPROBE_END macro's.

Greetings,
	Alexander

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index bd02ec7..6e96028 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -688,65 +688,6 @@ ENDPROC(name)
 /* The include is where all of the SMP etc. interrupts come from */
 #include "entry_arch.h"
 
-KPROBE_ENTRY(page_fault)
-	RING0_EC_FRAME
-	pushl $do_page_fault
-	CFI_ADJUST_CFA_OFFSET 4
-	ALIGN
-error_code:
-	/* the function address is in %fs's slot on the stack */
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
-	cld
-	pushl %fs
-	CFI_ADJUST_CFA_OFFSET 4
-	/*CFI_REL_OFFSET fs, 0*/
-	movl $(__KERNEL_PERCPU), %ecx
-	movl %ecx, %fs
-	UNWIND_ESPFIX_STACK
-	popl %ecx
-	CFI_ADJUST_CFA_OFFSET -4
-	/*CFI_REGISTER es, ecx*/
-	movl PT_FS(%esp), %edi		# get the function address
-	movl PT_ORIG_EAX(%esp), %edx	# get the error code
-	movl $-1, PT_ORIG_EAX(%esp)	# no syscall to restart
-	mov  %ecx, PT_FS(%esp)
-	/*CFI_REL_OFFSET fs, ES*/
-	movl $(__USER_DS), %ecx
-	movl %ecx, %ds
-	movl %ecx, %es
-	TRACE_IRQS_OFF
-	movl %esp,%eax			# pt_regs pointer
-	call *%edi
-	jmp ret_from_exception
-	CFI_ENDPROC
-KPROBE_END(page_fault)
-
 ENTRY(coprocessor_error)
 	RING0_INT_FRAME
 	pushl $0
@@ -777,140 +718,6 @@ ENTRY(device_not_available)
 	CFI_ENDPROC
 END(device_not_available)
 
-/*
- * Debug traps and NMI can happen at the one SYSENTER instruction
- * that sets up the real kernel stack. Check here, since we can't
- * allow the wrong stack to be used.
- *
- * "TSS_sysenter_sp0+12" is because the NMI/debug handler will have
- * already pushed 3 words if it hits on the sysenter instruction:
- * eflags, cs and eip.
- *
- * We just load the right stack, and push the three (known) values
- * by hand onto the new stack - while updating the return eip past
- * the instruction that would have done it for sysenter.
- */
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
-	CFI_REL_OFFSET eip, 0
-
-KPROBE_ENTRY(debug)
-	RING0_INT_FRAME
-	cmpl $ia32_sysenter_target,(%esp)
-	jne debug_stack_correct
-	FIX_STACK(12, debug_stack_correct, debug_esp_fix_insn)
-debug_stack_correct:
-	pushl $-1			# mark this as an int
-	CFI_ADJUST_CFA_OFFSET 4
-	SAVE_ALL
-	TRACE_IRQS_OFF
-	xorl %edx,%edx			# error code 0
-	movl %esp,%eax			# pt_regs pointer
-	call do_debug
-	jmp ret_from_exception
-	CFI_ENDPROC
-KPROBE_END(debug)
-
-/*
- * NMI is doubly nasty. It can happen _while_ we're handling
- * a debug fault, and the debug fault hasn't yet been able to
- * clear up the stack. So we first check whether we got  an
- * NMI on the sysenter entry path, but after that we need to
- * check whether we got an NMI on the debug path where the debug
- * fault happened on the sysenter path.
- */
-KPROBE_ENTRY(nmi)
-	RING0_INT_FRAME
-	pushl %eax
-	CFI_ADJUST_CFA_OFFSET 4
-	movl %ss, %eax
-	cmpw $__ESPFIX_SS, %ax
-	popl %eax
-	CFI_ADJUST_CFA_OFFSET -4
-	je nmi_espfix_stack
-	cmpl $ia32_sysenter_target,(%esp)
-	je nmi_stack_fixup
-	pushl %eax
-	CFI_ADJUST_CFA_OFFSET 4
-	movl %esp,%eax
-	/* Do not access memory above the end of our stack page,
-	 * it might not exist.
-	 */
-	andl $(THREAD_SIZE-1),%eax
-	cmpl $(THREAD_SIZE-20),%eax
-	popl %eax
-	CFI_ADJUST_CFA_OFFSET -4
-	jae nmi_stack_correct
-	cmpl $ia32_sysenter_target,12(%esp)
-	je nmi_debug_stack_check
-nmi_stack_correct:
-	/* We have a RING0_INT_FRAME here */
-	pushl %eax
-	CFI_ADJUST_CFA_OFFSET 4
-	SAVE_ALL
-	TRACE_IRQS_OFF
-	xorl %edx,%edx		# zero error code
-	movl %esp,%eax		# pt_regs pointer
-	call do_nmi
-	jmp restore_nocheck_notrace
-	CFI_ENDPROC
-
-nmi_stack_fixup:
-	RING0_INT_FRAME
-	FIX_STACK(12,nmi_stack_correct, 1)
-	jmp nmi_stack_correct
-
-nmi_debug_stack_check:
-	/* We have a RING0_INT_FRAME here */
-	cmpw $__KERNEL_CS,16(%esp)
-	jne nmi_stack_correct
-	cmpl $debug,(%esp)
-	jb nmi_stack_correct
-	cmpl $debug_esp_fix_insn,(%esp)
-	ja nmi_stack_correct
-	FIX_STACK(24,nmi_stack_correct, 1)
-	jmp nmi_stack_correct
-
-nmi_espfix_stack:
-	/* We have a RING0_INT_FRAME here.
-	 *
-	 * create the pointer to lss back
-	 */
-	pushl %ss
-	CFI_ADJUST_CFA_OFFSET 4
-	pushl %esp
-	CFI_ADJUST_CFA_OFFSET 4
-	addw $4, (%esp)
-	/* copy the iret frame of 12 bytes */
-	.rept 3
-	pushl 16(%esp)
-	CFI_ADJUST_CFA_OFFSET 4
-	.endr
-	pushl %eax
-	CFI_ADJUST_CFA_OFFSET 4
-	SAVE_ALL
-	TRACE_IRQS_OFF
-	FIXUP_ESPFIX_STACK		# %eax == %esp
-	xorl %edx,%edx			# zero error code
-	call do_nmi
-	RESTORE_REGS
-	lss 12+4(%esp), %esp		# back to espfix stack
-	CFI_ADJUST_CFA_OFFSET -24
-	jmp irq_return
-	CFI_ENDPROC
-KPROBE_END(nmi)
-
 #ifdef CONFIG_PARAVIRT
 ENTRY(native_iret)
 	iret
@@ -926,19 +733,6 @@ ENTRY(native_irq_enable_sysexit)
 END(native_irq_enable_sysexit)
 #endif
 
-KPROBE_ENTRY(int3)
-	RING0_INT_FRAME
-	pushl $-1			# mark this as an int
-	CFI_ADJUST_CFA_OFFSET 4
-	SAVE_ALL
-	TRACE_IRQS_OFF
-	xorl %edx,%edx		# zero error code
-	movl %esp,%eax		# pt_regs pointer
-	call do_int3
-	jmp ret_from_exception
-	CFI_ENDPROC
-KPROBE_END(int3)
-
 ENTRY(overflow)
 	RING0_INT_FRAME
 	pushl $0
@@ -1003,14 +797,6 @@ ENTRY(stack_segment)
 	CFI_ENDPROC
 END(stack_segment)
 
-KPROBE_ENTRY(general_protection)
-	RING0_EC_FRAME
-	pushl $do_general_protection
-	CFI_ADJUST_CFA_OFFSET 4
-	jmp error_code
-	CFI_ENDPROC
-KPROBE_END(general_protection)
-
 ENTRY(alignment_check)
 	RING0_EC_FRAME
 	pushl $do_alignment_check
@@ -1220,3 +1006,227 @@ END(mcount)
 #include "syscall_table_32.S"
 
 syscall_table_size=(.-sys_call_table)
+
+/*
+ * Some functions should be protected against kprobes
+ */
+	.pushsection .kprobes.text, "ax"
+
+ENTRY(page_fault)
+	RING0_EC_FRAME
+	pushl $do_page_fault
+	CFI_ADJUST_CFA_OFFSET 4
+	ALIGN
+error_code:
+	/* the function address is in %fs's slot on the stack */
+	pushl %es
+	CFI_ADJUST_CFA_OFFSET 4
+	/*CFI_REL_OFFSET es, 0*/
+	pushl %ds
+	CFI_ADJUST_CFA_OFFSET 4
+	/*CFI_REL_OFFSET ds, 0*/
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
+	cld
+	pushl %fs
+	CFI_ADJUST_CFA_OFFSET 4
+	/*CFI_REL_OFFSET fs, 0*/
+	movl $(__KERNEL_PERCPU), %ecx
+	movl %ecx, %fs
+	UNWIND_ESPFIX_STACK
+	popl %ecx
+	CFI_ADJUST_CFA_OFFSET -4
+	/*CFI_REGISTER es, ecx*/
+	movl PT_FS(%esp), %edi		# get the function address
+	movl PT_ORIG_EAX(%esp), %edx	# get the error code
+	movl $-1, PT_ORIG_EAX(%esp)	# no syscall to restart
+	mov  %ecx, PT_FS(%esp)
+	/*CFI_REL_OFFSET fs, ES*/
+	movl $(__USER_DS), %ecx
+	movl %ecx, %ds
+	movl %ecx, %es
+	TRACE_IRQS_OFF
+	movl %esp,%eax			# pt_regs pointer
+	call *%edi
+	jmp ret_from_exception
+	CFI_ENDPROC
+END(page_fault)
+
+/*
+ * Debug traps and NMI can happen at the one SYSENTER instruction
+ * that sets up the real kernel stack. Check here, since we can't
+ * allow the wrong stack to be used.
+ *
+ * "TSS_sysenter_sp0+12" is because the NMI/debug handler will have
+ * already pushed 3 words if it hits on the sysenter instruction:
+ * eflags, cs and eip.
+ *
+ * We just load the right stack, and push the three (known) values
+ * by hand onto the new stack - while updating the return eip past
+ * the instruction that would have done it for sysenter.
+ */
+#define FIX_STACK(offset, ok, label)		\
+	cmpw $__KERNEL_CS,4(%esp);		\
+	jne ok;					\
+label:						\
+	movl TSS_sysenter_sp0+offset(%esp),%esp;	\
+	CFI_DEF_CFA esp, 0;			\
+	CFI_UNDEFINED eip;			\
+	pushfl;					\
+	CFI_ADJUST_CFA_OFFSET 4;		\
+	pushl $__KERNEL_CS;			\
+	CFI_ADJUST_CFA_OFFSET 4;		\
+	pushl $sysenter_past_esp;		\
+	CFI_ADJUST_CFA_OFFSET 4;		\
+	CFI_REL_OFFSET eip, 0
+
+ENTRY(debug)
+	RING0_INT_FRAME
+	cmpl $ia32_sysenter_target,(%esp)
+	jne debug_stack_correct
+	FIX_STACK(12, debug_stack_correct, debug_esp_fix_insn)
+debug_stack_correct:
+	pushl $-1			# mark this as an int
+	CFI_ADJUST_CFA_OFFSET 4
+	SAVE_ALL
+	TRACE_IRQS_OFF
+	xorl %edx,%edx			# error code 0
+	movl %esp,%eax			# pt_regs pointer
+	call do_debug
+	jmp ret_from_exception
+	CFI_ENDPROC
+END(debug)
+
+/*
+ * NMI is doubly nasty. It can happen _while_ we're handling
+ * a debug fault, and the debug fault hasn't yet been able to
+ * clear up the stack. So we first check whether we got  an
+ * NMI on the sysenter entry path, but after that we need to
+ * check whether we got an NMI on the debug path where the debug
+ * fault happened on the sysenter path.
+ */
+ENTRY(nmi)
+	RING0_INT_FRAME
+	pushl %eax
+	CFI_ADJUST_CFA_OFFSET 4
+	movl %ss, %eax
+	cmpw $__ESPFIX_SS, %ax
+	popl %eax
+	CFI_ADJUST_CFA_OFFSET -4
+	je nmi_espfix_stack
+	cmpl $ia32_sysenter_target,(%esp)
+	je nmi_stack_fixup
+	pushl %eax
+	CFI_ADJUST_CFA_OFFSET 4
+	movl %esp,%eax
+	/* Do not access memory above the end of our stack page,
+	 * it might not exist.
+	 */
+	andl $(THREAD_SIZE-1),%eax
+	cmpl $(THREAD_SIZE-20),%eax
+	popl %eax
+	CFI_ADJUST_CFA_OFFSET -4
+	jae nmi_stack_correct
+	cmpl $ia32_sysenter_target,12(%esp)
+	je nmi_debug_stack_check
+nmi_stack_correct:
+	/* We have a RING0_INT_FRAME here */
+	pushl %eax
+	CFI_ADJUST_CFA_OFFSET 4
+	SAVE_ALL
+	TRACE_IRQS_OFF
+	xorl %edx,%edx		# zero error code
+	movl %esp,%eax		# pt_regs pointer
+	call do_nmi
+	jmp restore_nocheck_notrace
+	CFI_ENDPROC
+
+nmi_stack_fixup:
+	RING0_INT_FRAME
+	FIX_STACK(12,nmi_stack_correct, 1)
+	jmp nmi_stack_correct
+
+nmi_debug_stack_check:
+	/* We have a RING0_INT_FRAME here */
+	cmpw $__KERNEL_CS,16(%esp)
+	jne nmi_stack_correct
+	cmpl $debug,(%esp)
+	jb nmi_stack_correct
+	cmpl $debug_esp_fix_insn,(%esp)
+	ja nmi_stack_correct
+	FIX_STACK(24,nmi_stack_correct, 1)
+	jmp nmi_stack_correct
+
+nmi_espfix_stack:
+	/* We have a RING0_INT_FRAME here.
+	 *
+	 * create the pointer to lss back
+	 */
+	pushl %ss
+	CFI_ADJUST_CFA_OFFSET 4
+	pushl %esp
+	CFI_ADJUST_CFA_OFFSET 4
+	addw $4, (%esp)
+	/* copy the iret frame of 12 bytes */
+	.rept 3
+	pushl 16(%esp)
+	CFI_ADJUST_CFA_OFFSET 4
+	.endr
+	pushl %eax
+	CFI_ADJUST_CFA_OFFSET 4
+	SAVE_ALL
+	TRACE_IRQS_OFF
+	FIXUP_ESPFIX_STACK		# %eax == %esp
+	xorl %edx,%edx			# zero error code
+	call do_nmi
+	RESTORE_REGS
+	lss 12+4(%esp), %esp		# back to espfix stack
+	CFI_ADJUST_CFA_OFFSET -24
+	jmp irq_return
+	CFI_ENDPROC
+END(nmi)
+
+ENTRY(int3)
+	RING0_INT_FRAME
+	pushl $-1			# mark this as an int
+	CFI_ADJUST_CFA_OFFSET 4
+	SAVE_ALL
+	TRACE_IRQS_OFF
+	xorl %edx,%edx		# zero error code
+	movl %esp,%eax		# pt_regs pointer
+	call do_int3
+	jmp ret_from_exception
+	CFI_ENDPROC
+END(int3)
+
+ENTRY(general_protection)
+	RING0_EC_FRAME
+	pushl $do_general_protection
+	CFI_ADJUST_CFA_OFFSET 4
+	jmp error_code
+	CFI_ENDPROC
+END(general_protection)
+
+/*
+ * End of kprobes section
+ */
+	.popsection
diff --git a/include/linux/linkage.h b/include/linux/linkage.h
index 9fd1f85..fee9e59 100644
--- a/include/linux/linkage.h
+++ b/include/linux/linkage.h
@@ -64,14 +64,6 @@
 	name:
 #endif
 
-#define KPROBE_ENTRY(name) \
-  .pushsection .kprobes.text, "ax"; \
-  ENTRY(name)
-
-#define KPROBE_END(name) \
-  END(name);		 \
-  .popsection
-
 #ifndef END
 #define END(name) \
   .size name, .-name
-- 
1.5.4.3

