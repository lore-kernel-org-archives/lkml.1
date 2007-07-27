Return-Path: <linux-kernel-owner+w=401wt.eu-S933070AbXG0Ldd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933070AbXG0Ldd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 07:33:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932408AbXG0Lcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 07:32:51 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:24934 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936769AbXG0Lcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 07:32:48 -0400
Message-Id: <20070727113552.060734027@de.ibm.com>
References: <20070727113348.413110503@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jul 2007 13:33:50 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 2/6] Fix IRQ tracing.
Content-Disposition: inline; filename=011-irq-tracing.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

If a machine check is pending and the external or I/O interrupt handler
returns to userspace io_mcck_pending is going to call s390_handle_mcck.
Before this happens a call to TRACE_IRQS_ON was already made since we
know that we are going back to userspace and hence interrupts will be
enabled. So there was an indication that interrupts are enabled while
in reality they are still disabled.
s390_handle_mcck will do a local_irq_save/restore pair and confuse
lockdep which later complains about inconsistent irq tracing.
To solve this just call trace_hardirqs_off before calling
s390_handle_mcck and trace_hardirqs_on afterwards.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/kernel/entry.S   |    6 ++++--
 arch/s390/kernel/entry64.S |    6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

Index: quilt-2.6/arch/s390/kernel/entry64.S
===================================================================
--- quilt-2.6.orig/arch/s390/kernel/entry64.S
+++ quilt-2.6/arch/s390/kernel/entry64.S
@@ -611,8 +611,10 @@ io_work_loop:
 # _TIF_MCCK_PENDING is set, call handler
 #
 io_mcck_pending:
-	larl	%r14,io_work_loop
-	jg	s390_handle_mcck	# TIF bit will be cleared by handler
+	TRACE_IRQS_OFF
+	brasl	%r14,s390_handle_mcck	# TIF bit will be cleared by handler
+	TRACE_IRQS_ON
+	j	io_work_loop
 
 #
 # _TIF_NEED_RESCHED is set, call schedule
Index: quilt-2.6/arch/s390/kernel/entry.S
===================================================================
--- quilt-2.6.orig/arch/s390/kernel/entry.S
+++ quilt-2.6/arch/s390/kernel/entry.S
@@ -624,9 +624,11 @@ io_work_loop:
 # _TIF_MCCK_PENDING is set, call handler
 #
 io_mcck_pending:
+	TRACE_IRQS_OFF
 	l	%r1,BASED(.Ls390_handle_mcck)
-	la	%r14,BASED(io_work_loop)
-	br	%r1			# TIF bit will be cleared by handler
+	basr	%r14,%r1		# TIF bit will be cleared by handler
+	TRACE_IRQS_ON
+	b	BASED(io_work_loop)
 
 #
 # _TIF_NEED_RESCHED is set, call schedule

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

