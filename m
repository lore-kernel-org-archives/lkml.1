Return-Path: <linux-kernel-owner+w=401wt.eu-S1760696AbYEACV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760696AbYEACV6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 22:21:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760648AbYEACS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 22:18:59 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:45778 "EHLO
	snapgear.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760574AbYEACS6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 22:18:58 -0400
Date: Thu, 1 May 2008 12:17:49 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200805010217.m412HnlZ004149@goober>
To: torvalds@linux-foundation.org
Subject: [PATCH] m68knommu: fix compare race in sched related code
Cc: akpm@linux-foundation.org, gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Siewior <bigeasy@linutronix.de>

The interrupts must be disabled before considering the need resched
bit of the task struct and they have to be disabled before calling
schedule()

Signed-off-by: Sebastian Siewior <bigeasy@linutronix.de>
Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naurp linux-2.6.25/arch/m68knommu/platform/coldfire/entry.S linux-2.6.25-uc0/arch/m68knommu/platform/coldfire/entry.S
--- linux-2.6.25/arch/m68knommu/platform/coldfire/entry.S	2008-04-17 12:49:44.000000000 +1000
+++ linux-2.6.25-uc0/arch/m68knommu/platform/coldfire/entry.S	2008-04-29 14:26:11.000000000 +1000
@@ -103,6 +103,7 @@ ret_from_signal:
 	addql	#4,%sp
 
 ret_from_exception:
+	move	#0x2700,%sr		/* disable intrs */
 	btst	#5,%sp@(PT_SR)		/* check if returning to kernel */
 	jeq	Luser_return		/* if so, skip resched, signals */
 
@@ -140,6 +141,7 @@ Lreturn:
 
 Lwork_to_do:
 	movel	%a0@(TI_FLAGS),%d1	/* get thread_info->flags */
+	move	#0x2000,%sr		/* enable intrs again */
 	btst	#TIF_NEED_RESCHED,%d1
 	jne	reschedule
 
