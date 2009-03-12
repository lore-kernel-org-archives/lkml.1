Return-Path: <linux-kernel-owner+w=401wt.eu-S1756118AbZCLKwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118AbZCLKwZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 06:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752713AbZCLKwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 06:52:15 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:32903 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019AbZCLKwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 06:52:13 -0400
Message-Id: <49B8F2DF.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Thu, 12 Mar 2009 10:32:47 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: fix unwind annotations in entry_64.S
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=__PartA28A5EDF.2__="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME message. If you are reading this text, you may want to 
consider changing to a mail reader or gateway that understands how to 
properly handle MIME multipart messages.

--=__PartA28A5EDF.2__=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Those were completely screwed up with the recent rework.

(This patch applies to plain 2.6.29-rc7, a version that applies to tip
is attached.)

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/kernel/entry_64.S |  193 +++++++++++++++++++++++-----------------=
-----
 1 file changed, 102 insertions(+), 91 deletions(-)

--- linux-2.6.29-rc7/arch/x86/kernel/entry_64.S	2009-03-11 17:52:10.0000000=
00 +0100
+++ 2.6.29-rc7-x86_64-unwind/arch/x86/kernel/entry_64.S	2009-03-10 =
16:41:53.000000000 +0100
@@ -38,6 +38,7 @@
  */
=20
 #include <linux/linkage.h>
+#include <linux/stringify.h>
 #include <asm/segment.h>
 #include <asm/cache.h>
 #include <asm/errno.h>
@@ -255,21 +256,21 @@ ENTRY(native_usergs_sysret64)
 /*
  * initial frame state for interrupts (and exceptions without error code)
  */
-	.macro EMPTY_FRAME start=3D1 offset=3D0
-	.if \start
+	.macro EMPTY_FRAME offset=3D0
 	CFI_STARTPROC simple
 	CFI_SIGNAL_FRAME
-	CFI_DEF_CFA rsp,8+\offset
-	.else
-	CFI_DEF_CFA_OFFSET 8+\offset
-	.endif
+	CFI_DEF_CFA rsp,\offset
 	.endm
=20
 /*
  * initial frame state for interrupts (and exceptions without error code)
  */
 	.macro INTR_FRAME start=3D1 offset=3D0
-	EMPTY_FRAME \start, SS+8+\offset-RIP
+	.if \start
+	EMPTY_FRAME __stringify(SS+8+\offset-RIP)
+	.else
+	CFI_DEF_CFA_OFFSET SS+8+\offset-RIP
+	.endif
 	/*CFI_REL_OFFSET ss, SS+\offset-RIP*/
 	CFI_REL_OFFSET rsp, RSP+\offset-RIP
 	/*CFI_REL_OFFSET rflags, EFLAGS+\offset-RIP*/
@@ -282,15 +283,16 @@ ENTRY(native_usergs_sysret64)
  * with vector already pushed)
  */
 	.macro XCPT_FRAME start=3D1 offset=3D0
-	INTR_FRAME \start, RIP+\offset-ORIG_RAX
-	/*CFI_REL_OFFSET orig_rax, ORIG_RAX-ORIG_RAX*/
+	INTR_FRAME \start, __stringify(RIP+\offset-ORIG_RAX)
 	.endm
=20
 /*
  * frame that enables calling into C.
  */
 	.macro PARTIAL_FRAME start=3D1 offset=3D0
-	XCPT_FRAME \start, ORIG_RAX+\offset-ARGOFFSET
+	.if \start >=3D 0
+	XCPT_FRAME \start, __stringify(ORIG_RAX+\offset-ARGOFFSET)
+	.endif
 	CFI_REL_OFFSET rdi, RDI+\offset-ARGOFFSET
 	CFI_REL_OFFSET rsi, RSI+\offset-ARGOFFSET
 	CFI_REL_OFFSET rdx, RDX+\offset-ARGOFFSET
@@ -306,7 +308,9 @@ ENTRY(native_usergs_sysret64)
  * frame that enables passing a complete pt_regs to a C function.
  */
 	.macro DEFAULT_FRAME start=3D1 offset=3D0
-	PARTIAL_FRAME \start, R11+\offset-R15
+	.if \start >=3D -1
+	PARTIAL_FRAME \start, __stringify(R11+\offset-R15)
+	.endif
 	CFI_REL_OFFSET rbx, RBX+\offset
 	CFI_REL_OFFSET rbp, RBP+\offset
 	CFI_REL_OFFSET r12, R12+\offset
@@ -317,21 +321,23 @@ ENTRY(native_usergs_sysret64)
=20
 /* save partial stack frame */
 ENTRY(save_args)
-	XCPT_FRAME
+	XCPT_FRAME offset=3D__stringify(ORIG_RAX-ARGOFFSET+16)
 	cld
-	movq_cfi rdi, RDI+16-ARGOFFSET
-	movq_cfi rsi, RSI+16-ARGOFFSET
-	movq_cfi rdx, RDX+16-ARGOFFSET
-	movq_cfi rcx, RCX+16-ARGOFFSET
-	movq_cfi rax, RAX+16-ARGOFFSET
-	movq_cfi  r8,  R8+16-ARGOFFSET
-	movq_cfi  r9,  R9+16-ARGOFFSET
-	movq_cfi r10, R10+16-ARGOFFSET
-	movq_cfi r11, R11+16-ARGOFFSET
+	movq %rdi, RDI+16-ARGOFFSET(%rsp)
+	movq %rsi, RSI+16-ARGOFFSET(%rsp)
+	movq %rdx, RDX+16-ARGOFFSET(%rsp)
+	movq %rcx, RCX+16-ARGOFFSET(%rsp)
+	movq_cfi rax, __stringify(RAX+16-ARGOFFSET)
+	movq  %r8,  R8+16-ARGOFFSET(%rsp)
+	movq  %r9,  R9+16-ARGOFFSET(%rsp)
+	movq %r10, R10+16-ARGOFFSET(%rsp)
+	movq_cfi r11, __stringify(R11+16-ARGOFFSET)
=20
 	leaq -ARGOFFSET+16(%rsp),%rdi	/* arg1 for handler */
 	movq_cfi rbp, 8		/* push %rbp */
 	leaq 8(%rsp), %rbp		/* mov %rsp, %ebp */
+	CFI_DEF_CFA_REGISTER rbp
+	CFI_ADJUST_CFA_OFFSET -8
 	testl $3, CS(%rdi)
 	je 1f
 	SWAPGS
@@ -343,11 +349,10 @@ ENTRY(save_args)
 	 */
 1:	incl %gs:pda_irqcount
 	jne 2f
-	popq_cfi %rax			/* move return address... */
+	popq %rax			/* move return address... */
 	mov %gs:pda_irqstackptr,%rsp
-	EMPTY_FRAME 0
-	pushq_cfi %rbp			/* backlink for unwinder */
-	pushq_cfi %rax			/* ... to the new stack */
+	pushq %rbp			/* backlink for unwinder */
+	pushq %rax			/* ... to the new stack */
 	/*
 	 * We entered an interrupt context - irqs are off:
 	 */
@@ -357,14 +362,14 @@ ENTRY(save_args)
 END(save_args)
=20
 ENTRY(save_rest)
-	PARTIAL_FRAME 1 REST_SKIP+8
+	CFI_STARTPROC
 	movq 5*8+16(%rsp), %r11	/* save return address */
-	movq_cfi rbx, RBX+16
-	movq_cfi rbp, RBP+16
-	movq_cfi r12, R12+16
-	movq_cfi r13, R13+16
-	movq_cfi r14, R14+16
-	movq_cfi r15, R15+16
+	movq %rbx, RBX+16(%rsp)
+	movq %rbp, RBP+16(%rsp)
+	movq %r12, R12+16(%rsp)
+	movq %r13, R13+16(%rsp)
+	movq %r14, R14+16(%rsp)
+	movq %r15, R15+16(%rsp)
 	movq %r11, 8(%rsp)	/* return address */
 	FIXUP_TOP_OF_STACK %r11, 16
 	ret
@@ -373,23 +378,23 @@ END(save_rest)
=20
 /* save complete stack frame */
 ENTRY(save_paranoid)
-	XCPT_FRAME 1 RDI+8
+	XCPT_FRAME offset=3D__stringify(ORIG_RAX-R15+8)
 	cld
-	movq_cfi rdi, RDI+8
-	movq_cfi rsi, RSI+8
-	movq_cfi rdx, RDX+8
-	movq_cfi rcx, RCX+8
-	movq_cfi rax, RAX+8
-	movq_cfi r8, R8+8
-	movq_cfi r9, R9+8
-	movq_cfi r10, R10+8
-	movq_cfi r11, R11+8
-	movq_cfi rbx, RBX+8
-	movq_cfi rbp, RBP+8
-	movq_cfi r12, R12+8
-	movq_cfi r13, R13+8
-	movq_cfi r14, R14+8
-	movq_cfi r15, R15+8
+	movq %rdi, RDI+8(%rsp)
+	movq %rsi, RSI+8(%rsp)
+	movq_cfi rdx, __stringify(RDX+8)
+	movq_cfi rcx, __stringify(RCX+8)
+	movq_cfi rax, __stringify(RAX+8)
+	movq %r8, R8+8(%rsp)
+	movq %r9, R9+8(%rsp)
+	movq %r10, R10+8(%rsp)
+	movq %r11, R11+8(%rsp)
+	movq_cfi rbx, __stringify(RBX+8)
+	movq %rbp, RBP+8(%rsp)
+	movq %r12, R12+8(%rsp)
+	movq %r13, R13+8(%rsp)
+	movq %r14, R14+8(%rsp)
+	movq %r15, R15+8(%rsp)
 	movl $1,%ebx
 	movl $MSR_GS_BASE,%ecx
 	rdmsr
@@ -706,7 +711,7 @@ ENTRY(\label)
 	subq $REST_SKIP, %rsp
 	CFI_ADJUST_CFA_OFFSET REST_SKIP
 	call save_rest
-	DEFAULT_FRAME 0 8		/* offset 8: return address */
+	DEFAULT_FRAME -2 8		/* offset 8: return address */
 	leaq 8(%rsp), \arg	/* pt_regs pointer */
 	call \func
 	jmp ptregscall_common
@@ -723,12 +728,12 @@ END(\label)
 ENTRY(ptregscall_common)
 	DEFAULT_FRAME 1 8	/* offset 8: return address */
 	RESTORE_TOP_OF_STACK %r11, 8
-	movq_cfi_restore R15+8, r15
-	movq_cfi_restore R14+8, r14
-	movq_cfi_restore R13+8, r13
-	movq_cfi_restore R12+8, r12
-	movq_cfi_restore RBP+8, rbp
-	movq_cfi_restore RBX+8, rbx
+	movq_cfi_restore __stringify(R15+8), r15
+	movq_cfi_restore __stringify(R14+8), r14
+	movq_cfi_restore __stringify(R13+8), r13
+	movq_cfi_restore __stringify(R12+8), r12
+	movq_cfi_restore __stringify(RBP+8), rbp
+	movq_cfi_restore __stringify(RBX+8), rbx
 	ret $REST_SKIP		/* pop extended registers */
 	CFI_ENDPROC
 END(ptregscall_common)
@@ -817,10 +822,12 @@ END(interrupt)
=20
 /* 0(%rsp): ~(interrupt number) */
 	.macro interrupt func
-	subq $10*8, %rsp
-	CFI_ADJUST_CFA_OFFSET 10*8
+	subq $ORIG_RAX-ARGOFFSET+8, %rsp
+	CFI_ADJUST_CFA_OFFSET ORIG_RAX-ARGOFFSET+8
 	call save_args
-	PARTIAL_FRAME 0
+	PARTIAL_FRAME -1 8
+	CFI_REL_OFFSET rbp, 0
+	CFI_DEF_CFA_REGISTER rbp
 	call \func
 	.endm
=20
@@ -1033,10 +1040,10 @@ ENTRY(\sym)
 	INTR_FRAME
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
 	pushq_cfi $-1		/* ORIG_RAX: no syscall to restart */
-	subq $15*8,%rsp
-	CFI_ADJUST_CFA_OFFSET 15*8
+	subq $ORIG_RAX-R15, %rsp
+	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
 	call error_entry
-	DEFAULT_FRAME 0
+	DEFAULT_FRAME -1
 	movq %rsp,%rdi		/* pt_regs pointer */
 	xorl %esi,%esi		/* no error code */
 	call \do_sym
@@ -1051,8 +1058,10 @@ ENTRY(\sym)
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
 	pushq $-1		/* ORIG_RAX: no syscall to restart */
 	CFI_ADJUST_CFA_OFFSET 8
-	subq $15*8, %rsp
+	subq $ORIG_RAX-R15, %rsp
+	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
 	call save_paranoid
+	DEFAULT_FRAME -1
 	TRACE_IRQS_OFF
 	movq %rsp,%rdi		/* pt_regs pointer */
 	xorl %esi,%esi		/* no error code */
@@ -1068,8 +1077,10 @@ ENTRY(\sym)
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
 	pushq $-1		/* ORIG_RAX: no syscall to restart */
 	CFI_ADJUST_CFA_OFFSET 8
-	subq $15*8, %rsp
+	subq $ORIG_RAX-R15, %rsp
+	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
 	call save_paranoid
+	DEFAULT_FRAME -1
 	TRACE_IRQS_OFF
 	movq %rsp,%rdi		/* pt_regs pointer */
 	xorl %esi,%esi		/* no error code */
@@ -1086,10 +1097,10 @@ END(\sym)
 ENTRY(\sym)
 	XCPT_FRAME
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
-	subq $15*8,%rsp
-	CFI_ADJUST_CFA_OFFSET 15*8
+	subq $ORIG_RAX-R15, %rsp
+	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
 	call error_entry
-	DEFAULT_FRAME 0
+	DEFAULT_FRAME -1
 	movq %rsp,%rdi			/* pt_regs pointer */
 	movq ORIG_RAX(%rsp),%rsi	/* get error code */
 	movq $-1,ORIG_RAX(%rsp)		/* no syscall to restart */
@@ -1104,10 +1115,10 @@ END(\sym)
 ENTRY(\sym)
 	XCPT_FRAME
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
-	subq $15*8,%rsp
-	CFI_ADJUST_CFA_OFFSET 15*8
+	subq $ORIG_RAX-R15, %rsp
+	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
 	call save_paranoid
-	DEFAULT_FRAME 0
+	DEFAULT_FRAME -1
 	TRACE_IRQS_OFF
 	movq %rsp,%rdi			/* pt_regs pointer */
 	movq ORIG_RAX(%rsp),%rsi	/* get error code */
@@ -1400,7 +1411,7 @@ paranoidzeroentry machine_check do_machi
=20
 	/* ebx:	no swapgs flag */
 ENTRY(paranoid_exit)
-	INTR_FRAME
+	DEFAULT_FRAME
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
 	testl %ebx,%ebx				/* swapgs needed? */
@@ -1447,25 +1458,24 @@ END(paranoid_exit)
  * returns in "no swapgs flag" in %ebx.
  */
 ENTRY(error_entry)
-	XCPT_FRAME
-	CFI_ADJUST_CFA_OFFSET 15*8
+	XCPT_FRAME offset=3D__stringify(ORIG_RAX-R15+8)
 	/* oldrax contains error code */
 	cld
-	movq_cfi rdi, RDI+8
-	movq_cfi rsi, RSI+8
-	movq_cfi rdx, RDX+8
-	movq_cfi rcx, RCX+8
-	movq_cfi rax, RAX+8
-	movq_cfi  r8,  R8+8
-	movq_cfi  r9,  R9+8
-	movq_cfi r10, R10+8
-	movq_cfi r11, R11+8
-	movq_cfi rbx, RBX+8
-	movq_cfi rbp, RBP+8
-	movq_cfi r12, R12+8
-	movq_cfi r13, R13+8
-	movq_cfi r14, R14+8
-	movq_cfi r15, R15+8
+	movq %rdi, RDI+8(%rsp)
+	movq %rsi, RSI+8(%rsp)
+	movq %rdx, RDX+8(%rsp)
+	movq %rcx, RCX+8(%rsp)
+	movq %rax, RAX+8(%rsp)
+	movq  %r8,  R8+8(%rsp)
+	movq  %r9,  R9+8(%rsp)
+	movq %r10, R10+8(%rsp)
+	movq %r11, R11+8(%rsp)
+	movq_cfi rbx, __stringify(RBX+8)
+	movq %rbp, RBP+8(%rsp)
+	movq %r12, R12+8(%rsp)
+	movq %r13, R13+8(%rsp)
+	movq %r14, R14+8(%rsp)
+	movq %r15, R15+8(%rsp)
 	xorl %ebx,%ebx
 	testl $3,CS+8(%rsp)
 	je error_kernelspace
@@ -1474,7 +1484,6 @@ error_swapgs:
 error_sti:
 	TRACE_IRQS_OFF
 	ret
-	CFI_ENDPROC
=20
 /*
  * There are two places in the kernel that can potentially fault with
@@ -1484,6 +1493,7 @@ error_sti:
  * compat mode. Check for these here too.
  */
 error_kernelspace:
+	CFI_REL_OFFSET rcx, RCX+8
 	incl %ebx
 	leaq irq_return(%rip),%rcx
 	cmpq %rcx,RIP+8(%rsp)
@@ -1494,6 +1504,7 @@ error_kernelspace:
 	cmpq $gs_change,RIP+8(%rsp)
 	je error_swapgs
 	jmp error_sti
+	CFI_ENDPROC
 END(error_entry)
=20
=20
@@ -1522,10 +1533,10 @@ ENTRY(nmi)
 	INTR_FRAME
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
 	pushq_cfi $-1
-	subq $15*8, %rsp
-	CFI_ADJUST_CFA_OFFSET 15*8
+	subq $ORIG_RAX-R15, %rsp
+	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
 	call save_paranoid
-	DEFAULT_FRAME 0
+	DEFAULT_FRAME -1
 	/* paranoidentry do_nmi, 0; without TRACE_IRQS_OFF */
 	movq %rsp,%rdi
 	movq $-1,%rsi



--=__PartA28A5EDF.2__=
Content-Type: text/plain; name="linux-2.6.29-rc7-x86_64-unwind.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename="linux-2.6.29-rc7-x86_64-unwind.patch"

Those were completely screwed up with the recent rework.=0A=0ASigned-off-by=
: Jan Beulich <jbeulich@novell.com>=0A=0A---=0A arch/x86/kernel/entry_64.S =
|  193 +++++++++++++++++++++++----------------------=0A 1 file changed, =
102 insertions(+), 91 deletions(-)=0A=0A--- linux-2.6.29-rc7/arch/x86/kerne=
l/entry_64.S	2009-03-11 17:52:10.000000000 +0100=0A+++ 2.6.29-rc7-x86_64=
-unwind/arch/x86/kernel/entry_64.S	2009-03-10 16:41:53.000000000 =
+0100=0A@@ -38,6 +38,7 @@=0A  */=0A =0A #include <linux/linkage.h>=0A+#incl=
ude <linux/stringify.h>=0A #include <asm/segment.h>=0A #include <asm/cache.=
h>=0A #include <asm/errno.h>=0A@@ -255,21 +256,21 @@ ENTRY(native_usergs_sy=
sret64)=0A /*=0A  * initial frame state for interrupts (and exceptions =
without error code)=0A  */=0A-	.macro EMPTY_FRAME start=3D1 offset=3D0=0A-=
	.if \start=0A+	.macro EMPTY_FRAME offset=3D0=0A 	CFI_STARTPR=
OC simple=0A 	CFI_SIGNAL_FRAME=0A-	CFI_DEF_CFA rsp,8+\offset=0A-	=
.else=0A-	CFI_DEF_CFA_OFFSET 8+\offset=0A-	.endif=0A+	=
CFI_DEF_CFA rsp,\offset=0A 	.endm=0A =0A /*=0A  * initial frame state =
for interrupts (and exceptions without error code)=0A  */=0A 	.macro =
INTR_FRAME start=3D1 offset=3D0=0A-	EMPTY_FRAME \start, SS+8+\offset-RI=
P=0A+	.if \start=0A+	EMPTY_FRAME __stringify(SS+8+\offset-RIP)=0A+	=
.else=0A+	CFI_DEF_CFA_OFFSET SS+8+\offset-RIP=0A+	.endif=0A 	=
/*CFI_REL_OFFSET ss, SS+\offset-RIP*/=0A 	CFI_REL_OFFSET rsp, =
RSP+\offset-RIP=0A 	/*CFI_REL_OFFSET rflags, EFLAGS+\offset-RIP*/=0A@@ =
-282,15 +283,16 @@ ENTRY(native_usergs_sysret64)=0A  * with vector already =
pushed)=0A  */=0A 	.macro XCPT_FRAME start=3D1 offset=3D0=0A-	=
INTR_FRAME \start, RIP+\offset-ORIG_RAX=0A-	/*CFI_REL_OFFSET orig_rax, =
ORIG_RAX-ORIG_RAX*/=0A+	INTR_FRAME \start, __stringify(RIP+\offset-ORIG_RAX=
)=0A 	.endm=0A =0A /*=0A  * frame that enables calling into C.=0A  */=0A =
	.macro PARTIAL_FRAME start=3D1 offset=3D0=0A-	XCPT_FRAME \start, =
ORIG_RAX+\offset-ARGOFFSET=0A+	.if \start >=3D 0=0A+	XCPT_FRAME \start, =
__stringify(ORIG_RAX+\offset-ARGOFFSET)=0A+	.endif=0A 	CFI_REL_OFF=
SET rdi, RDI+\offset-ARGOFFSET=0A 	CFI_REL_OFFSET rsi, RSI+\offset-ARG=
OFFSET=0A 	CFI_REL_OFFSET rdx, RDX+\offset-ARGOFFSET=0A@@ -306,7 =
+308,9 @@ ENTRY(native_usergs_sysret64)=0A  * frame that enables passing a =
complete pt_regs to a C function.=0A  */=0A 	.macro DEFAULT_FRAME =
start=3D1 offset=3D0=0A-	PARTIAL_FRAME \start, R11+\offset-R15=0A+	=
.if \start >=3D -1=0A+	PARTIAL_FRAME \start, __stringify(R11+\offset-R15)=
=0A+	.endif=0A 	CFI_REL_OFFSET rbx, RBX+\offset=0A 	CFI_REL_OFF=
SET rbp, RBP+\offset=0A 	CFI_REL_OFFSET r12, R12+\offset=0A@@ =
-317,21 +321,23 @@ ENTRY(native_usergs_sysret64)=0A =0A /* save partial =
stack frame */=0A ENTRY(save_args)=0A-	XCPT_FRAME=0A+	XCPT_FRAME =
offset=3D__stringify(ORIG_RAX-ARGOFFSET+16)=0A 	cld=0A-	movq_cfi rdi, =
RDI+16-ARGOFFSET=0A-	movq_cfi rsi, RSI+16-ARGOFFSET=0A-	movq_cfi =
rdx, RDX+16-ARGOFFSET=0A-	movq_cfi rcx, RCX+16-ARGOFFSET=0A-	=
movq_cfi rax, RAX+16-ARGOFFSET=0A-	movq_cfi  r8,  R8+16-ARGOFFSET=0A-	=
movq_cfi  r9,  R9+16-ARGOFFSET=0A-	movq_cfi r10, R10+16-ARGOFFSET=0A-	=
movq_cfi r11, R11+16-ARGOFFSET=0A+	movq %rdi, RDI+16-ARGOFFSET(%rsp)=
=0A+	movq %rsi, RSI+16-ARGOFFSET(%rsp)=0A+	movq %rdx, RDX+16-ARGOFFSET=
(%rsp)=0A+	movq %rcx, RCX+16-ARGOFFSET(%rsp)=0A+	movq_cfi rax, =
__stringify(RAX+16-ARGOFFSET)=0A+	movq  %r8,  R8+16-ARGOFFSET(%rsp)=
=0A+	movq  %r9,  R9+16-ARGOFFSET(%rsp)=0A+	movq %r10, R10+16-ARGOFFSET=
(%rsp)=0A+	movq_cfi r11, __stringify(R11+16-ARGOFFSET)=0A =0A 	=
leaq -ARGOFFSET+16(%rsp),%rdi	/* arg1 for handler */=0A 	movq_cfi =
rbp, 8		/* push %rbp */=0A 	leaq 8(%rsp), %rbp		/* =
mov %rsp, %ebp */=0A+	CFI_DEF_CFA_REGISTER rbp=0A+	CFI_ADJUST_CFA_OFFS=
ET -8=0A 	testl $3, CS(%rdi)=0A 	je 1f=0A 	SWAPGS=0A@@ =
-343,11 +349,10 @@ ENTRY(save_args)=0A 	 */=0A 1:	incl PER_CPU_VAR(ir=
q_count)=0A 	jne 2f=0A-	popq_cfi %rax			/* move =
return address... */=0A+	popq %rax			/* move =
return address... */=0A 	mov PER_CPU_VAR(irq_stack_ptr),%rsp=0A-	=
EMPTY_FRAME 0=0A-	pushq_cfi %rbp			/* backlink for =
unwinder */=0A-	pushq_cfi %rax			/* ... to the new stack =
*/=0A+	pushq %rbp			/* backlink for unwinder */=0A+	=
pushq %rax			/* ... to the new stack */=0A 	/*=0A 	 * =
We entered an interrupt context - irqs are off:=0A 	 */=0A@@ -357,14 =
+362,14 @@ ENTRY(save_args)=0A END(save_args)=0A =0A ENTRY(save_rest)=0A-	=
PARTIAL_FRAME 1 REST_SKIP+8=0A+	CFI_STARTPROC=0A 	movq 5*8+16(%rsp), =
%r11	/* save return address */=0A-	movq_cfi rbx, RBX+16=0A-	=
movq_cfi rbp, RBP+16=0A-	movq_cfi r12, R12+16=0A-	movq_cfi =
r13, R13+16=0A-	movq_cfi r14, R14+16=0A-	movq_cfi r15, R15+16=0A+	=
movq %rbx, RBX+16(%rsp)=0A+	movq %rbp, RBP+16(%rsp)=0A+	movq %r12, =
R12+16(%rsp)=0A+	movq %r13, R13+16(%rsp)=0A+	movq %r14, =
R14+16(%rsp)=0A+	movq %r15, R15+16(%rsp)=0A 	movq %r11, 8(%rsp)	=
/* return address */=0A 	FIXUP_TOP_OF_STACK %r11, 16=0A 	ret=0A@@ =
-373,23 +378,23 @@ END(save_rest)=0A =0A /* save complete stack frame =
*/=0A ENTRY(save_paranoid)=0A-	XCPT_FRAME 1 RDI+8=0A+	XCPT_FRAME =
offset=3D__stringify(ORIG_RAX-R15+8)=0A 	cld=0A-	movq_cfi rdi, =
RDI+8=0A-	movq_cfi rsi, RSI+8=0A-	movq_cfi rdx, RDX+8=0A-	movq_cfi =
rcx, RCX+8=0A-	movq_cfi rax, RAX+8=0A-	movq_cfi r8, R8+8=0A-	movq_cfi =
r9, R9+8=0A-	movq_cfi r10, R10+8=0A-	movq_cfi r11, R11+8=0A-	movq_cfi =
rbx, RBX+8=0A-	movq_cfi rbp, RBP+8=0A-	movq_cfi r12, R12+8=0A-	movq_cfi =
r13, R13+8=0A-	movq_cfi r14, R14+8=0A-	movq_cfi r15, R15+8=0A+	movq %rdi, =
RDI+8(%rsp)=0A+	movq %rsi, RSI+8(%rsp)=0A+	movq_cfi rdx, __stringify(R=
DX+8)=0A+	movq_cfi rcx, __stringify(RCX+8)=0A+	movq_cfi rax, =
__stringify(RAX+8)=0A+	movq %r8, R8+8(%rsp)=0A+	movq %r9, =
R9+8(%rsp)=0A+	movq %r10, R10+8(%rsp)=0A+	movq %r11, R11+8(%rsp)=0A+	=
movq_cfi rbx, __stringify(RBX+8)=0A+	movq %rbp, RBP+8(%rsp)=0A+	=
movq %r12, R12+8(%rsp)=0A+	movq %r13, R13+8(%rsp)=0A+	movq %r14, =
R14+8(%rsp)=0A+	movq %r15, R15+8(%rsp)=0A 	movl $1,%ebx=0A 	=
movl $MSR_GS_BASE,%ecx=0A 	rdmsr=0A@@ -706,7 +711,7 @@ ENTRY(\label)=
=0A 	subq $REST_SKIP, %rsp=0A 	CFI_ADJUST_CFA_OFFSET REST_SKIP=0A =
	call save_rest=0A-	DEFAULT_FRAME 0 8		/* offset =
8: return address */=0A+	DEFAULT_FRAME -2 8		/* offset =
8: return address */=0A 	leaq 8(%rsp), \arg	/* pt_regs pointer =
*/=0A 	call \func=0A 	jmp ptregscall_common=0A@@ -723,12 +728,12 @@ =
END(\label)=0A ENTRY(ptregscall_common)=0A 	DEFAULT_FRAME 1 8	/* =
offset 8: return address */=0A 	RESTORE_TOP_OF_STACK %r11, 8=0A-	=
movq_cfi_restore R15+8, r15=0A-	movq_cfi_restore R14+8, r14=0A-	movq_cfi_re=
store R13+8, r13=0A-	movq_cfi_restore R12+8, r12=0A-	movq_cfi_restore =
RBP+8, rbp=0A-	movq_cfi_restore RBX+8, rbx=0A+	movq_cfi_restore __stringif=
y(R15+8), r15=0A+	movq_cfi_restore __stringify(R14+8), r14=0A+	=
movq_cfi_restore __stringify(R13+8), r13=0A+	movq_cfi_restore __stringif=
y(R12+8), r12=0A+	movq_cfi_restore __stringify(RBP+8), rbp=0A+	=
movq_cfi_restore __stringify(RBX+8), rbx=0A 	ret $REST_SKIP		/* =
pop extended registers */=0A 	CFI_ENDPROC=0A END(ptregscall_common)=0A@@ =
-817,10 +822,12 @@ END(interrupt)=0A =0A /* 0(%rsp): ~(interrupt number) =
*/=0A 	.macro interrupt func=0A-	subq $10*8, %rsp=0A-	CFI_ADJUST_=
CFA_OFFSET 10*8=0A+	subq $ORIG_RAX-ARGOFFSET+8, %rsp=0A+	CFI_ADJUST_=
CFA_OFFSET ORIG_RAX-ARGOFFSET+8=0A 	call save_args=0A-	PARTIAL_FRA=
ME 0=0A+	PARTIAL_FRAME -1 8=0A+	CFI_REL_OFFSET rbp, 0=0A+	=
CFI_DEF_CFA_REGISTER rbp=0A 	call \func=0A 	.endm=0A =0A@@ -1033,10 =
+1040,10 @@ ENTRY(\sym)=0A 	INTR_FRAME=0A 	PARAVIRT_ADJUST_EXCEPTION_F=
RAME=0A 	pushq_cfi $-1		/* ORIG_RAX: no syscall to restart =
*/=0A-	subq $15*8,%rsp=0A-	CFI_ADJUST_CFA_OFFSET 15*8=0A+	subq =
$ORIG_RAX-R15, %rsp=0A+	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15=0A 	call =
error_entry=0A-	DEFAULT_FRAME 0=0A+	DEFAULT_FRAME -1=0A 	movq =
%rsp,%rdi		/* pt_regs pointer */=0A 	xorl %esi,%esi		=
/* no error code */=0A 	call \do_sym=0A@@ -1051,8 +1058,10 @@ ENTRY(\sym)=
=0A 	PARAVIRT_ADJUST_EXCEPTION_FRAME=0A 	pushq $-1		/* =
ORIG_RAX: no syscall to restart */=0A 	CFI_ADJUST_CFA_OFFSET 8=0A-	=
subq $15*8, %rsp=0A+	subq $ORIG_RAX-R15, %rsp=0A+	CFI_ADJUST_CFA_OFFS=
ET ORIG_RAX-R15=0A 	call save_paranoid=0A+	DEFAULT_FRAME -1=0A 	=
TRACE_IRQS_OFF=0A 	movq %rsp,%rdi		/* pt_regs pointer */=0A 	=
xorl %esi,%esi		/* no error code */=0A@@ -1068,8 +1077,10 @@ =
ENTRY(\sym)=0A 	PARAVIRT_ADJUST_EXCEPTION_FRAME=0A 	pushq $-1		=
/* ORIG_RAX: no syscall to restart */=0A 	CFI_ADJUST_CFA_OFFSET =
8=0A-	subq $15*8, %rsp=0A+	subq $ORIG_RAX-R15, %rsp=0A+	CFI_ADJUST_=
CFA_OFFSET ORIG_RAX-R15=0A 	call save_paranoid=0A+	DEFAULT_FRAME =
-1=0A 	TRACE_IRQS_OFF=0A 	movq %rsp,%rdi		/* pt_regs pointer =
*/=0A 	xorl %esi,%esi		/* no error code */=0A@@ -1086,10 +1097,10 =
@@ END(\sym)=0A ENTRY(\sym)=0A 	XCPT_FRAME=0A 	PARAVIRT_ADJUST_EXCEPTION_F=
RAME=0A-	subq $15*8,%rsp=0A-	CFI_ADJUST_CFA_OFFSET 15*8=0A+	=
subq $ORIG_RAX-R15, %rsp=0A+	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15=0A 	=
call error_entry=0A-	DEFAULT_FRAME 0=0A+	DEFAULT_FRAME -1=0A 	=
movq %rsp,%rdi			/* pt_regs pointer */=0A 	movq =
ORIG_RAX(%rsp),%rsi	/* get error code */=0A 	movq $-1,ORIG_RAX(%=
rsp)		/* no syscall to restart */=0A@@ -1104,10 +1115,10 @@ =
END(\sym)=0A ENTRY(\sym)=0A 	XCPT_FRAME=0A 	PARAVIRT_ADJUST_EXCEPTION_F=
RAME=0A-	subq $15*8,%rsp=0A-	CFI_ADJUST_CFA_OFFSET 15*8=0A+	=
subq $ORIG_RAX-R15, %rsp=0A+	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15=0A 	=
call save_paranoid=0A-	DEFAULT_FRAME 0=0A+	DEFAULT_FRAME -1=0A 	=
TRACE_IRQS_OFF=0A 	movq %rsp,%rdi			/* pt_regs pointer =
*/=0A 	movq ORIG_RAX(%rsp),%rsi	/* get error code */=0A@@ -1400,7 =
+1411,7 @@ paranoidzeroentry machine_check do_machi=0A =0A 	/* ebx:	no =
swapgs flag */=0A ENTRY(paranoid_exit)=0A-	INTR_FRAME=0A+	DEFAULT_FRA=
ME=0A 	DISABLE_INTERRUPTS(CLBR_NONE)=0A 	TRACE_IRQS_OFF=0A 	=
testl %ebx,%ebx				/* swapgs needed? */=0A@@ -1447,25 =
+1458,24 @@ END(paranoid_exit)=0A  * returns in "no swapgs flag" in =
%ebx.=0A  */=0A ENTRY(error_entry)=0A-	XCPT_FRAME=0A-	CFI_ADJUST_CFA_OFFS=
ET 15*8=0A+	XCPT_FRAME offset=3D__stringify(ORIG_RAX-R15+8)=0A 	/* =
oldrax contains error code */=0A 	cld=0A-	movq_cfi rdi, RDI+8=0A-	=
movq_cfi rsi, RSI+8=0A-	movq_cfi rdx, RDX+8=0A-	movq_cfi rcx, RCX+8=0A-	=
movq_cfi rax, RAX+8=0A-	movq_cfi  r8,  R8+8=0A-	movq_cfi  r9,  R9+8=0A-	=
movq_cfi r10, R10+8=0A-	movq_cfi r11, R11+8=0A-	movq_cfi rbx, RBX+8=0A-	=
movq_cfi rbp, RBP+8=0A-	movq_cfi r12, R12+8=0A-	movq_cfi r13, R13+8=0A-	=
movq_cfi r14, R14+8=0A-	movq_cfi r15, R15+8=0A+	movq %rdi, RDI+8(%rsp)=0A+	=
movq %rsi, RSI+8(%rsp)=0A+	movq %rdx, RDX+8(%rsp)=0A+	movq %rcx, =
RCX+8(%rsp)=0A+	movq %rax, RAX+8(%rsp)=0A+	movq  %r8,  R8+8(%rsp)=0A+	=
movq  %r9,  R9+8(%rsp)=0A+	movq %r10, R10+8(%rsp)=0A+	movq %r11, =
R11+8(%rsp)=0A+	movq_cfi rbx, __stringify(RBX+8)=0A+	movq %rbp, =
RBP+8(%rsp)=0A+	movq %r12, R12+8(%rsp)=0A+	movq %r13, R13+8(%rsp)=0A+	=
movq %r14, R14+8(%rsp)=0A+	movq %r15, R15+8(%rsp)=0A 	xorl =
%ebx,%ebx=0A 	testl $3,CS+8(%rsp)=0A 	je error_kernelspace=0A@@ -1474,7 =
+1484,6 @@ error_swapgs:=0A error_sti:=0A 	TRACE_IRQS_OFF=0A 	=
ret=0A-	CFI_ENDPROC=0A =0A /*=0A  * There are two places in the kernel =
that can potentially fault with=0A@@ -1484,6 +1493,7 @@ error_sti:=0A  * =
compat mode. Check for these here too.=0A  */=0A error_kernelspace:=0A+	=
CFI_REL_OFFSET rcx, RCX+8=0A 	incl %ebx=0A 	leaq irq_return(%rip),%rcx=
=0A 	cmpq %rcx,RIP+8(%rsp)=0A@@ -1494,6 +1504,7 @@ error_kernelspace:=0A=
 	cmpq $gs_change,RIP+8(%rsp)=0A 	je error_swapgs=0A 	jmp =
error_sti=0A+	CFI_ENDPROC=0A END(error_entry)=0A =0A =0A@@ -1522,10 =
+1533,10 @@ ENTRY(nmi)=0A 	INTR_FRAME=0A 	PARAVIRT_ADJUST_EXCEPTION_F=
RAME=0A 	pushq_cfi $-1=0A-	subq $15*8, %rsp=0A-	CFI_ADJUST_=
CFA_OFFSET 15*8=0A+	subq $ORIG_RAX-R15, %rsp=0A+	CFI_ADJUST_CFA_OFFS=
ET ORIG_RAX-R15=0A 	call save_paranoid=0A-	DEFAULT_FRAME 0=0A+	=
DEFAULT_FRAME -1=0A 	/* paranoidentry do_nmi, 0; without TRACE_IRQS_OFF =
*/=0A 	movq %rsp,%rdi=0A 	movq $-1,%rsi=0A
--=__PartA28A5EDF.2__=--
