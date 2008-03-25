Return-Path: <linux-kernel-owner+w=401wt.eu-S1759175AbYCYTRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759175AbYCYTRX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 15:17:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754686AbYCYTRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 15:17:12 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:58110 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbYCYTRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 15:17:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=Ygfo0QbYK/D/C0GiALQK/Isw4Xr96oXayOew7KDB5yoG6hRvNZ+ZzZan9Ydr7Lot96waqgX9/C3726VqRysvQdTW2U8LkxjkFUGP8v0YOU4rUzUP7eZudhIJquwo9584nNsvBkksSBNLPJLAACkjksrqxW9htMxUKa7YoZSdiQg=
Date: Tue, 25 Mar 2008 22:16:32 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: entry_32.S - use flags from processor-flags.h
Message-ID: <20080325191632.GB9237@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By including processor-flags.h we are allowed to use predefined
macroses instead of keeping own ones

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

I've tried to bring as minimum changes as possible during this
patch (even checkpatch was not being started 'cause I know
it will require reformat much more lines that are touched by
this patch. Anyway, if someone wants me to do so - no problem
just say ;)

Please review

 entry_32.S |   20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/entry_32.S
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/entry_32.S	2008-03-25 21:32:27.000000000 +0300
+++ linux-2.6.git/arch/x86/kernel/entry_32.S	2008-03-25 21:55:45.000000000 +0300
@@ -50,6 +50,7 @@
 #include <asm/desc.h>
 #include <asm/percpu.h>
 #include <asm/dwarf2.h>
+#include <asm/processor-flags.h>
 #include "irq_vectors.h"
 
 /*
@@ -67,13 +68,6 @@
 
 #define nr_syscalls ((syscall_table_size)/4)
 
-CF_MASK		= 0x00000001
-TF_MASK		= 0x00000100
-IF_MASK		= 0x00000200
-DF_MASK		= 0x00000400 
-NT_MASK		= 0x00004000
-VM_MASK		= 0x00020000
-
 #ifdef CONFIG_PREEMPT
 #define preempt_stop(clobbers)	DISABLE_INTERRUPTS(clobbers); TRACE_IRQS_OFF
 #else
@@ -83,7 +77,7 @@ VM_MASK		= 0x00020000
 
 .macro TRACE_IRQS_IRET
 #ifdef CONFIG_TRACE_IRQFLAGS
-	testl $IF_MASK,PT_EFLAGS(%esp)     # interrupts off?
+	testl $X86_EFLAGS_IF,PT_EFLAGS(%esp)     # interrupts off?
 	jz 1f
 	TRACE_IRQS_ON
 1:
@@ -245,7 +239,7 @@ ret_from_intr:
 check_userspace:
 	movl PT_EFLAGS(%esp), %eax	# mix EFLAGS and CS
 	movb PT_CS(%esp), %al
-	andl $(VM_MASK | SEGMENT_RPL_MASK), %eax
+	andl $(X86_EFLAGS_VM | SEGMENT_RPL_MASK), %eax
 	cmpl $USER_RPL, %eax
 	jb resume_kernel		# not returning to v8086 or userspace
 
@@ -270,7 +264,7 @@ need_resched:
 	movl TI_flags(%ebp), %ecx	# need_resched set ?
 	testb $_TIF_NEED_RESCHED, %cl
 	jz restore_all
-	testl $IF_MASK,PT_EFLAGS(%esp)	# interrupts off (exception path) ?
+	testl $X86_EFLAGS_IF,PT_EFLAGS(%esp)	# interrupts off (exception path) ?
 	jz restore_all
 	call preempt_schedule_irq
 	jmp need_resched
@@ -387,7 +381,7 @@ syscall_exit:
 					# setting need_resched or sigpending
 					# between sampling and the iret
 	TRACE_IRQS_OFF
-	testl $TF_MASK,PT_EFLAGS(%esp)	# If tracing set singlestep flag on exit
+	testl $X86_EFLAGS_TF,PT_EFLAGS(%esp)	# If tracing set singlestep flag on exit
 	jz no_singlestep
 	orl $_TIF_SINGLESTEP,TI_flags(%ebp)
 no_singlestep:
@@ -402,7 +396,7 @@ restore_all:
 	# See comments in process.c:copy_thread() for details.
 	movb PT_OLDSS(%esp), %ah
 	movb PT_CS(%esp), %al
-	andl $(VM_MASK | (SEGMENT_TI_MASK << 8) | SEGMENT_RPL_MASK), %eax
+	andl $(X86_EFLAGS_VM | (SEGMENT_TI_MASK << 8) | SEGMENT_RPL_MASK), %eax
 	cmpl $((SEGMENT_LDT << 8) | USER_RPL), %eax
 	CFI_REMEMBER_STATE
 	je ldt_ss			# returning to user-space with LDT SS
@@ -489,7 +483,7 @@ work_resched:
 work_notifysig:				# deal with pending signals and
 					# notify-resume requests
 #ifdef CONFIG_VM86
-	testl $VM_MASK, PT_EFLAGS(%esp)
+	testl $X86_EFLAGS_VM, PT_EFLAGS(%esp)
 	movl %esp, %eax
 	jne work_notifysig_v86		# returning to kernel-space or
 					# vm86-space
