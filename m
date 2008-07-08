Return-Path: <linux-kernel-owner+w=401wt.eu-S1756529AbYGHADU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529AbYGHADU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 20:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754351AbYGHADM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 20:03:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59914 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754003AbYGHADK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 20:03:10 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexander Viro <aviro@redhat.com>, Eric Paris <eparis@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] x86_64 ia32 syscall audit fast-path
In-Reply-To: Linus Torvalds's message of  Monday, 7 July 2008 09:39:13 -0700 <alpine.LFD.1.10.0807070937520.11076@woody.linux-foundation.org>
X-Fcc: ~/Mail/linus
References: <20080707065615.77BD9154246@magilla.localdomain>
	<20080707065742.7C119154246@magilla.localdomain>
	<alpine.LFD.1.10.0807070927090.11076@woody.linux-foundation.org>
	<alpine.LFD.1.10.0807070937520.11076@woody.linux-foundation.org>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20080708000233.E8EF3154244@magilla.localdomain>
Date: Mon,  7 Jul 2008 17:02:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't know if there was some reason I did it that way rather than the
other.  I don't remember in which order I wrote and rewrote the patches.
I'll cop to laziness if you like.

It reminded me that I'd never tested the AMD (syscall/sysret) version of
this path.  That was clearly just plain lazy, and it was in fact broken.
It's a good thing you called me names and made me feel bad about myself,
so I cast about for more of my failings.

This version of the patch changes what you didn't like, and it works
right on both the AMD (syscall) and Intel (sysenter) paths.  (Yes, I
had already tested all the other paths.  This is the only one that
is not used on Intel hardware.)

Is bt slower than testl?  Or do you just mean having another load?
(I used bt there because I saw it used in entry_64.S for all cases
of testing for only one bit at a time.  I don't claim to really know
about these things, but I had figured a second load from the same
location just loaded (even the identical address calculation) would
be very fast.)


Thanks,
Roland

---
[PATCH 3/4] x86_64 ia32 syscall audit fast-path

This adds fast paths for 32-bit syscall entry and exit when
TIF_SYSCALL_AUDIT is set, but no other kind of syscall tracing.
These paths does not need to save and restore all registers as
the general case of tracing does.  Avoiding the iret return path
when syscall audit is enabled helps performance a lot.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/ia32/ia32entry.S  |   78 +++++++++++++++++++++++++++++++++++++++++--
 arch/x86/kernel/entry_64.S |    1 +
 2 files changed, 75 insertions(+), 4 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index b5e329d..b2b8cda 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -15,6 +15,11 @@
 #include <asm/irqflags.h>
 #include <linux/linkage.h>
 
+/* Avoid __ASSEMBLER__'ifying <linux/audit.h> just for this.  */
+#include <linux/elf-em.h>
+#define AUDIT_ARCH_I386		(EM_386|__AUDIT_ARCH_LE)
+#define __AUDIT_ARCH_LE	   0x40000000
+
 #define IA32_NR_syscalls ((ia32_syscall_end - ia32_sys_call_table)/8)
 
 	.macro IA32_ARG_FIXUP noebp=0
@@ -131,13 +136,15 @@ sysenter_do_call:
 	cmpl	$(IA32_NR_syscalls-1),%eax
 	ja	ia32_badsys
 	IA32_ARG_FIXUP 1
+sysenter_dispatch:
 	call	*ia32_sys_call_table(,%rax,8)
 	movq	%rax,RAX-ARGOFFSET(%rsp)
 	GET_THREAD_INFO(%r10)
 	cli
 	TRACE_IRQS_OFF
 	testl	$_TIF_ALLWORK_MASK,threadinfo_flags(%r10)
-	jnz	int_ret_from_sys_call
+	jnz	sysexit_audit
+sysexit_from_sys_call:
 	andl    $~TS_COMPAT,threadinfo_status(%r10)
 	/* clear IF, that popfq doesn't enable interrupts early */
 	andl  $~0x200,EFLAGS-R11(%rsp) 
@@ -156,9 +163,59 @@ sysenter_do_call:
 	/* sysexit */
 	.byte	0xf, 0x35
 
-sysenter_tracesys:
+	.macro auditsys_entry_common
+	movl %esi,%r9d			/* 6th arg: 4th syscall arg */
+	movl %edx,%r8d			/* 5th arg: 3rd syscall arg */
+	/* (already in %ecx)		   4th arg: 2nd syscall arg */
+	movl %ebx,%edx			/* 3rd arg: 1st syscall arg */
+	movl %eax,%esi			/* 2nd arg: syscall number */
+	movl $AUDIT_ARCH_I386,%edi	/* 1st arg: audit arch */
+	call audit_syscall_entry
+	movl RAX-ARGOFFSET(%rsp),%eax	/* reload syscall number */
+	cmpl $(IA32_NR_syscalls-1),%eax
+	ja ia32_badsys
+	movl %ebx,%edi			/* reload 1st syscall arg */
+	movl RCX-ARGOFFSET(%rsp),%esi	/* reload 2nd syscall arg */
+	movl RDX-ARGOFFSET(%rsp),%edx	/* reload 3rd syscall arg */
+	movl RSI-ARGOFFSET(%rsp),%ecx	/* reload 4th syscall arg */
+	movl RDI-ARGOFFSET(%rsp),%r8d	/* reload 5th syscall arg */
+	.endm
+
+	.macro auditsys_exit exit
+	testl $(_TIF_ALLWORK_MASK & ~_TIF_SYSCALL_AUDIT),threadinfo_flags(%r10)
+	jnz int_ret_from_sys_call
+	TRACE_IRQS_ON
+	sti
+	movl %eax,%esi		/* second arg, syscall return value */
+	cmpl $0,%eax		/* is it < 0? */
+	setl %al		/* 1 if so, 0 if not */
+	movzbl %al,%edi		/* zero-extend that into %edi */
+	inc %edi /* first arg, 0->1(AUDITSC_SUCCESS), 1->2(AUDITSC_FAILURE) */
+	call audit_syscall_exit
+	GET_THREAD_INFO(%r10)
+	movl RAX-ARGOFFSET(%rsp),%eax	/* reload syscall return value */
+	movl RBP-ARGOFFSET(%rsp),%ebp	/* reload user register value */
+	movl $(_TIF_ALLWORK_MASK & ~_TIF_SYSCALL_AUDIT),%edi
+	cli
+	TRACE_IRQS_OFF
+	testl %edi,threadinfo_flags(%r10)
+	jnz int_with_check
+	jmp \exit
+	.endm
+
+sysenter_auditsys:
 	CFI_RESTORE_STATE
+	auditsys_entry_common
+	movl %ebp,%r9d			/* reload 6th syscall arg */
+	jmp sysenter_dispatch
+
+sysexit_audit:
+	auditsys_exit sysexit_from_sys_call
+
+sysenter_tracesys:
 	xchgl	%r9d,%ebp
+	testl	$(_TIF_SYSCALL_TRACE|_TIF_SECCOMP),threadinfo_flags(%r10)
+	jz	sysenter_auditsys
 	SAVE_REST
 	CLEAR_RREGS
 	movq	%r9,R9(%rsp)
@@ -238,13 +295,15 @@ cstar_do_call:
 	cmpl $IA32_NR_syscalls-1,%eax
 	ja  ia32_badsys
 	IA32_ARG_FIXUP 1
+cstar_dispatch:
 	call *ia32_sys_call_table(,%rax,8)
 	movq %rax,RAX-ARGOFFSET(%rsp)
 	GET_THREAD_INFO(%r10)
 	cli
 	TRACE_IRQS_OFF
 	testl $_TIF_ALLWORK_MASK,threadinfo_flags(%r10)
-	jnz  int_ret_from_sys_call
+	jnz sysretl_audit
+sysretl_from_sys_call:
 	andl $~TS_COMPAT,threadinfo_status(%r10)
 	RESTORE_ARGS 1,-ARG_SKIP,1,1,1
 	movl RIP-ARGOFFSET(%rsp),%ecx
@@ -257,8 +316,19 @@ cstar_do_call:
 	swapgs
 	sysretl
 	
-cstar_tracesys:	
+cstar_auditsys:
 	CFI_RESTORE_STATE
+	movl %r9d,R9-ARGOFFSET(%rsp)	/* register to be clobbered by call */
+	auditsys_entry_common
+	movl R9-ARGOFFSET(%rsp),%r9d	/* reload 6th syscall arg */
+	jmp cstar_dispatch
+
+sysretl_audit:
+	auditsys_exit sysretl_from_sys_call
+
+cstar_tracesys:
+	testl $(_TIF_SYSCALL_TRACE|_TIF_SECCOMP),threadinfo_flags(%r10)
+	jz cstar_auditsys
 	xchgl %r9d,%ebp
 	SAVE_REST
 	CLEAR_RREGS
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 9b152d5..01c3e6b 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -375,6 +375,7 @@ tracesys:
  * Has correct top of stack, but partial stack frame.
  */
 	.globl int_ret_from_sys_call
+	.globl int_with_check
 int_ret_from_sys_call:
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
