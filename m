Return-Path: <linux-kernel-owner+w=401wt.eu-S1755475AbXI1LtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475AbXI1LtS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 07:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751603AbXI1LtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 07:49:08 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:37440 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbXI1LtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 07:49:06 -0400
Date: Fri, 28 Sep 2007 13:49:03 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
       Zach Brown <zach.brown@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 00/12] various lockdep patches
Message-ID: <20070928114903.GB25726@osiris.boeblingen.de.ibm.com>
References: <20070928074200.436463000@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070928074200.436463000@chello.nl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2007 at 09:42:00AM +0200, Peter Zijlstra wrote:
> The first 3 patches provide a new lockdep check, it verifies we don't hold any
> locks when returning to userspace.
> 
> 	lockdep-sys_exit.patch
> 	lockdep-i386-sys_exit.patch
> 	lockdep-x86_64-sys_exit.patch
> 
> Could the various arch maintainers that have support for lockdep help out
> with placing this hook?

Subject: [PATCH] lockdep: s390: connect the sysexit hook

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Run the lockdep_sys_exit hook before returning to user space.

Reviewed-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/s390/kernel/entry.S   |   12 ++++++++++++
 arch/s390/kernel/entry64.S |    9 +++++++++
 2 files changed, 21 insertions(+)

Index: linux-2.6/arch/s390/kernel/entry64.S
===================================================================
--- linux-2.6.orig/arch/s390/kernel/entry64.S
+++ linux-2.6/arch/s390/kernel/entry64.S
@@ -66,9 +66,14 @@ _TIF_WORK_INT = (_TIF_SIGPENDING | _TIF_
 	.macro	TRACE_IRQS_OFF
 	 brasl	%r14,trace_hardirqs_off
 	.endm
+
+	.macro	LOCKDEP_SYS_EXIT
+	 brasl	%r14,lockdep_sys_exit
+	.endm
 #else
 #define TRACE_IRQS_ON
 #define TRACE_IRQS_OFF
+#define LOCKDEP_SYS_EXIT
 #endif
 
 	.macro	STORE_TIMER lc_offset
@@ -255,6 +260,7 @@ sysc_return:
 	jno	sysc_leave
 	tm	__TI_flags+7(%r9),_TIF_WORK_SVC
 	jnz	sysc_work	# there is work to do (signals etc.)
+	LOCKDEP_SYS_EXIT
 sysc_leave:
 	RESTORE_ALL __LC_RETURN_PSW,1
 
@@ -278,6 +284,7 @@ sysc_work:
 	jo	sysc_restart
 	tm	__TI_flags+7(%r9),_TIF_SINGLE_STEP
 	jo	sysc_singlestep
+	LOCKDEP_SYS_EXIT
 	j	sysc_leave
 
 #
@@ -558,6 +565,7 @@ io_return:
 #endif
 	tm	__TI_flags+7(%r9),_TIF_WORK_INT
 	jnz	io_work 		# there is work to do (signals etc.)
+	LOCKDEP_SYS_EXIT
 io_leave:
 	RESTORE_ALL __LC_RETURN_PSW,0
 io_done:
@@ -605,6 +613,7 @@ io_work_loop:
 	jo	io_reschedule
 	tm	__TI_flags+7(%r9),(_TIF_SIGPENDING | _TIF_RESTORE_SIGMASK)
 	jnz	io_sigpending
+	LOCKDEP_SYS_EXIT
 	j	io_leave
 
 #
Index: linux-2.6/arch/s390/kernel/entry.S
===================================================================
--- linux-2.6.orig/arch/s390/kernel/entry.S
+++ linux-2.6/arch/s390/kernel/entry.S
@@ -68,9 +68,15 @@ STACK_SIZE  = 1 << STACK_SHIFT
 	l	%r1,BASED(.Ltrace_irq_off)
 	basr	%r14,%r1
 	.endm
+
+	.macro	LOCKDEP_SYS_EXIT
+	l	%r1,BASED(.Llockdep_sys_exit)
+	basr	%r14,%r1
+	.endm
 #else
 #define TRACE_IRQS_ON
 #define TRACE_IRQS_OFF
+#define LOCKDEP_SYS_EXIT
 #endif
 
 /*
@@ -260,6 +266,7 @@ sysc_return:
 	bno	BASED(sysc_leave)
 	tm	__TI_flags+3(%r9),_TIF_WORK_SVC
 	bnz	BASED(sysc_work)  # there is work to do (signals etc.)
+	LOCKDEP_SYS_EXIT
 sysc_leave:
 	RESTORE_ALL __LC_RETURN_PSW,1
 
@@ -283,6 +290,7 @@ sysc_work:
 	bo	BASED(sysc_restart)
 	tm	__TI_flags+3(%r9),_TIF_SINGLE_STEP
 	bo	BASED(sysc_singlestep)
+	LOCKDEP_SYS_EXIT
 	b	BASED(sysc_leave)
 
 #
@@ -572,6 +580,7 @@ io_return:
 #endif
 	tm	__TI_flags+3(%r9),_TIF_WORK_INT
 	bnz	BASED(io_work)		# there is work to do (signals etc.)
+	LOCKDEP_SYS_EXIT
 io_leave:
 	RESTORE_ALL __LC_RETURN_PSW,0
 io_done:
@@ -618,6 +627,7 @@ io_work_loop:
 	bo	BASED(io_reschedule)
 	tm	__TI_flags+3(%r9),(_TIF_SIGPENDING | _TIF_RESTORE_SIGMASK)
 	bnz	BASED(io_sigpending)
+	LOCKDEP_SYS_EXIT
 	b	BASED(io_leave)
 
 #
@@ -1040,6 +1050,8 @@ cleanup_io_leave_insn:
 .Ltrace_irq_on: .long	trace_hardirqs_on
 .Ltrace_irq_off:
 		.long	trace_hardirqs_off
+.Llockdep_sys_exit:
+		.long	lockdep_sys_exit
 #endif
 .Lcritical_start:
 		.long	__critical_start + 0x80000000
