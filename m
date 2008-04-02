Return-Path: <linux-kernel-owner+w=401wt.eu-S1759390AbYDBSg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759390AbYDBSg3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 14:36:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756275AbYDBSfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 14:35:34 -0400
Received: from 21.sub-75-208-3.myvzw.com ([75.208.3.21]:38401 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754722AbYDBSfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 14:35:33 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 22 of 24] xen: fold xen_sysexit into xen_iret
X-Mercurial-Node: 2f18411ec7d823edca3beaf80359bc569c36c1b7
Message-Id: <2f18411ec7d823edca3b.1207158851@localhost>
In-Reply-To: <patchbomb.1207158829@localhost>
Date: Wed, 02 Apr 2008 10:54:11 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Isaku Yamahata <yamahata@valinux.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xen_sysexit and xen_iret were doing essentially the same thing.  Rather
than having a separate implementation for xen_sysexit, we can just strip
the stack back to an iret frame and jump into xen_iret.  This removes
a lot of code and complexity - specifically, another critical region.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/entry_32.S |    9 -----
 arch/x86/xen/xen-asm.S     |   70 ++++++++------------------------------------
 2 files changed, 15 insertions(+), 64 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1044,15 +1044,8 @@
 
 	jmp  xen_iret_crit_fixup
 
-1:	cmpl $xen_sysexit_start_crit,%eax
-	jb   2f
-	cmpl $xen_sysexit_end_crit,%eax
-	jae  2f
-
-	jmp xen_sysexit_crit_fixup
-
 ENTRY(xen_do_upcall)
-2:	mov %esp, %eax
+1:	mov %esp, %eax
 	call xen_evtchn_do_upcall
 	jmp  ret_from_intr
 	CFI_ENDPROC
diff --git a/arch/x86/xen/xen-asm.S b/arch/x86/xen/xen-asm.S
--- a/arch/x86/xen/xen-asm.S
+++ b/arch/x86/xen/xen-asm.S
@@ -106,6 +106,20 @@
 	ret
 	ENDPROC(xen_restore_fl_direct)
 	RELOC(xen_restore_fl_direct, 2b+1)
+
+/*
+	We can't use sysexit directly, because we're not running in ring0.
+	But we can easily fake it up using iret.  Assuming xen_sysexit
+	is jumped to with a standard stack frame, we can just strip it
+	back to a standard iret frame and use iret.
+ */
+ENTRY(xen_sysexit)
+	movl PT_EAX(%esp), %eax			/* Shouldn't be necessary? */
+	orl $X86_EFLAGS_IF, PT_EFLAGS(%esp)
+	lea PT_EIP(%esp), %esp
+
+	jmp xen_iret
+ENDPROC(xen_sysexit)
 
 /*
 	This is run where a normal iret would be run, with the same stack setup:
@@ -276,62 +290,6 @@
 2:	jmp xen_do_upcall
 
 
-ENTRY(xen_sysexit)
-	/* Store vcpu_info pointer for easy access.  Do it this
-	   way to avoid having to reload %fs */
-#ifdef CONFIG_SMP
-	GET_THREAD_INFO(%eax)
-	movl TI_cpu(%eax),%eax
-	movl __per_cpu_offset(,%eax,4),%eax
-	mov per_cpu__xen_vcpu(%eax),%eax
-#else
-	movl per_cpu__xen_vcpu, %eax
-#endif
-
-	/* We can't actually use sysexit in a pv guest,
-	   so fake it up with iret */
-	pushl $__USER_DS		/* user stack segment */
-	pushl %ecx			/* user esp */
-	pushl PT_EFLAGS+2*4(%esp)	/* user eflags */
-	pushl $__USER_CS		/* user code segment */
-	pushl %edx			/* user eip */
-
-xen_sysexit_start_crit:
-	/* Unmask events... */
-	movb $0, XEN_vcpu_info_mask(%eax)
-	/* ...and test for pending.
-	   There's a preempt window here, but it doesn't
-	   matter because we're within the critical section. */
-	testb $0xff, XEN_vcpu_info_pending(%eax)
-
-	/* If there's something pending, mask events again so we
-	   can directly inject it back into the kernel. */
-	jnz   1f
-
-	movl PT_EAX+5*4(%esp),%eax
-2:	iret
-1:	movb $1, XEN_vcpu_info_mask(%eax)
-xen_sysexit_end_crit:
-	addl $5*4, %esp		/* remove iret frame */
-	/* no need to re-save regs, but need to restore kernel %fs */
-	mov $__KERNEL_PERCPU, %eax
-	mov %eax, %fs
-	jmp xen_do_upcall
-.section __ex_table,"a"
-	.align 4
-	.long 2b,iret_exc
-.previous
-
-	.globl xen_sysexit_start_crit, xen_sysexit_end_crit
-/*
-	sysexit fixup is easy, since the old frame is still sitting there
-	on the stack.  We just need to remove the new recursive
-	interrupt and return.
- */
-ENTRY(xen_sysexit_crit_fixup)
-	addl $PT_OLDESP+5*4, %esp		/* remove frame+iret */
-	jmp xen_do_upcall
-
 /*
 	Force an event check by making a hypercall,
 	but preserve regs before making the call.


