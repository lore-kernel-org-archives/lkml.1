Return-Path: <linux-kernel-owner+w=401wt.eu-S1758291AbYEACRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758291AbYEACRR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 22:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753897AbYEACRD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 22:17:03 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:57492 "EHLO
	snapgear.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753345AbYEACRB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 22:17:01 -0400
Date: Thu, 1 May 2008 12:16:29 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200805010216.m412GT6t004096@goober>
To: torvalds@linux-foundation.org
Subject: [PATCH] m68knommu: ColdFire add support for kernel preemption
Cc: akpm@linux-foundation.org, gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Siewior <bigeasy@linutronix.de>

As the subject says this patch adds the support for kernel preemption
on m68knommu Coldfire. I thing the same changes could be applied to
68360 & 68328 but since I don't have the HW for testing, I don't touch it.

Signed-off-by: Sebastian Siewior <bigeasy@linutronix.de>
Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naurp linux-2.6.25/arch/m68knommu/kernel/asm-offsets.c linux-2.6.25-uc0/arch/m68knommu/kernel/asm-offsets.c
--- linux-2.6.25/arch/m68knommu/kernel/asm-offsets.c	2008-04-17 12:49:44.000000000 +1000
+++ linux-2.6.25-uc0/arch/m68knommu/kernel/asm-offsets.c	2008-03-28 15:29:06.000000000 +1000
@@ -91,6 +91,7 @@ int main(void)
 	DEFINE(TI_TASK, offsetof(struct thread_info, task));
 	DEFINE(TI_EXECDOMAIN, offsetof(struct thread_info, exec_domain));
 	DEFINE(TI_FLAGS, offsetof(struct thread_info, flags));
+	DEFINE(TI_PREEMPTCOUNT, offsetof(struct thread_info, preempt_count));
 	DEFINE(TI_CPU, offsetof(struct thread_info, cpu));
 
 	return 0;
diff -Naurp linux-2.6.25/arch/m68knommu/platform/coldfire/entry.S linux-2.6.25-uc0/arch/m68knommu/platform/coldfire/entry.S
--- linux-2.6.25/arch/m68knommu/platform/coldfire/entry.S	2008-04-17 12:49:44.000000000 +1000
+++ linux-2.6.25-uc0/arch/m68knommu/platform/coldfire/entry.S	2008-05-01 11:58:21.000000000 +1000
@@ -106,6 +106,22 @@ ret_from_exception:
 	btst	#5,%sp@(PT_SR)		/* check if returning to kernel */
 	jeq	Luser_return		/* if so, skip resched, signals */
 
+#ifdef CONFIG_PREEMPT
+	movel	%sp,%d1			/* get thread_info pointer */
+	andl	#-THREAD_SIZE,%d1	/* at base of kernel stack */
+	movel	%d1,%a0
+	movel	%a0@(TI_FLAGS),%d1	/* get thread_info->flags */
+	andl	#_TIF_NEED_RESCHED,%d1
+	jeq	Lkernel_return
+
+	movel	%a0@(TI_PREEMPTCOUNT),%d1
+	cmpl	#0,%d1
+	jne	Lkernel_return
+
+	pea	Lkernel_return
+	jmp	preempt_schedule_irq	/* preempt the kernel */
+#endif
+
 Lkernel_return:
 	moveml	%sp@,%d1-%d5/%a0-%a2
 	lea	%sp@(32),%sp		/* space for 8 regs */
