Return-Path: <linux-kernel-owner+w=401wt.eu-S934718AbXJSEvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934718AbXJSEvf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 00:51:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752634AbXJSEv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 00:51:27 -0400
Received: from rex.snapgear.com ([203.143.235.140]:59758 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752181AbXJSEv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 00:51:27 -0400
Date: Fri, 19 Oct 2007 14:50:12 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200710190450.l9J4oC2S005057@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: fix syscall tracing
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Waddel <Matt.Waddel@freescale.com>

Fix the system call code for handling syscall tracing, so strace
and gdbserver work properly.

This fix originally developed by Philippe De Muyter and Stuart Hughes.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naurp linux-2.6.23/arch/m68knommu/platform/5307/entry.S linux-2.6.23-uc0/arch/m68knommu/platform/5307/entry.S
--- linux-2.6.23/arch/m68knommu/platform/5307/entry.S	2007-10-19 10:30:55.000000000 +1000
+++ linux-2.6.23-uc0/arch/m68knommu/platform/5307/entry.S	2007-10-19 10:35:40.000000000 +1000
@@ -74,7 +74,8 @@ ENTRY(system_call)
 	movel	%sp,%d2			/* get thread_info pointer */
 	andl	#-THREAD_SIZE,%d2	/* at start of kernel stack */
 	movel	%d2,%a0
-	movel	%sp,%a0@(THREAD_ESP0)	/* save top of frame */
+	movel	%a0@,%a1		/* save top of frame */
+	movel	%sp,%a1@(TASK_THREAD+THREAD_ESP0)
 	btst	#(TIF_SYSCALL_TRACE%8),%a0@(TI_FLAGS+(31-TIF_SYSCALL_TRACE)/8)
 	bnes	1f
 
@@ -83,6 +84,8 @@ ENTRY(system_call)
 	movel	%d0,%sp@(PT_D0)		/* save the return value */
 	jra	ret_from_exception
 1:
+	movel	#-ENOSYS,%d2		/* strace needs -ENOSYS in PT_D0 */
+	movel	%d2,PT_D0(%sp)		/* on syscall entry */
 	subql	#4,%sp
 	SAVE_SWITCH_STACK
 	jbsr	syscall_trace
