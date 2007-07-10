Return-Path: <linux-kernel-owner+w=401wt.eu-S1764707AbXGJJc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764707AbXGJJc3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 05:32:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763730AbXGJJ3D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 05:29:03 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:62728 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764146AbXGJJ2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 05:28:49 -0400
Message-Id: <20070710093121.020580356@de.ibm.com>
References: <20070710092935.896013926@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 10 Jul 2007 11:29:47 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 12/16] system call optimization.
Content-Disposition: inline; filename=012-svc-speedup.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

After the in-kernel system call has been remove the system call path
can be optimized. The problem state bit of the old psw is always set
between system_call and sysc_do_svc. SAVE_ALL_SVC uses this information
to avoid two instructions.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/kernel/entry.S   |    7 ++++++-
 arch/s390/kernel/entry64.S |    7 ++++++-
 2 files changed, 12 insertions(+), 2 deletions(-)

Index: quilt-2.6/arch/s390/kernel/entry64.S
===================================================================
--- quilt-2.6.orig/arch/s390/kernel/entry64.S
+++ quilt-2.6/arch/s390/kernel/entry64.S
@@ -99,6 +99,11 @@ _TIF_WORK_INT = (_TIF_SIGPENDING | _TIF_
 	larl	%r13,system_call
 	.endm
 
+	.macro	SAVE_ALL_SVC psworg,savearea
+	la	%r12,\psworg
+	lg	%r15,__LC_KERNEL_STACK	# problem state -> load ksp
+	.endm
+
 	.macro	SAVE_ALL_SYNC psworg,savearea
 	la	%r12,\psworg
 	tm	\psworg+1,0x01		# test problem state bit
@@ -207,7 +212,7 @@ system_call:
 	STORE_TIMER __LC_SYNC_ENTER_TIMER
 sysc_saveall:
 	SAVE_ALL_BASE __LC_SAVE_AREA
-	SAVE_ALL_SYNC __LC_SVC_OLD_PSW,__LC_SAVE_AREA
+	SAVE_ALL_SVC __LC_SVC_OLD_PSW,__LC_SAVE_AREA
 	CREATE_STACK_FRAME __LC_SVC_OLD_PSW,__LC_SAVE_AREA
 	llgh	%r7,__LC_SVC_INT_CODE	# get svc number from lowcore
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING
Index: quilt-2.6/arch/s390/kernel/entry.S
===================================================================
--- quilt-2.6.orig/arch/s390/kernel/entry.S
+++ quilt-2.6/arch/s390/kernel/entry.S
@@ -107,6 +107,11 @@ STACK_SIZE  = 1 << STACK_SHIFT
 	l	%r13,__LC_SVC_NEW_PSW+4	# load &system_call to %r13
 	.endm
 
+	.macro	SAVE_ALL_SVC psworg,savearea
+	la	%r12,\psworg
+	l	%r15,__LC_KERNEL_STACK	# problem state -> load ksp
+	.endm
+
 	.macro	SAVE_ALL_SYNC psworg,savearea
 	la	%r12,\psworg
 	tm	\psworg+1,0x01		# test problem state bit
@@ -218,7 +223,7 @@ system_call:
 	STORE_TIMER __LC_SYNC_ENTER_TIMER
 sysc_saveall:
 	SAVE_ALL_BASE __LC_SAVE_AREA
-	SAVE_ALL_SYNC __LC_SVC_OLD_PSW,__LC_SAVE_AREA
+	SAVE_ALL_SVC __LC_SVC_OLD_PSW,__LC_SAVE_AREA
 	CREATE_STACK_FRAME __LC_SVC_OLD_PSW,__LC_SAVE_AREA
 	lh	%r7,0x8a	  # get svc number from lowcore
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

