Return-Path: <linux-kernel-owner+w=401wt.eu-S1751490AbYBYLHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490AbYBYLHw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 06:07:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754407AbYBYLHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 06:07:14 -0500
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:23530 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbYBYLHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 06:07:13 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <200802251207.906590508@firstfloor.org>
In-Reply-To: <200802251207.906590508@firstfloor.org>
To: mingo@elte.hu, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       roland@redhat.com
Subject: [PATCH] [3/3] Replace macro recursion with more conventional loop
Message-Id: <20080225110710.EBB2D1B4192@basil.firstfloor.org>
Date: Mon, 25 Feb 2008 12:07:10 +0100 (CET)
X-OriginalArrivalTime: 25 Feb 2008 11:00:44.0798 (UTC) FILETIME=[AB5319E0:01C8779D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The early exception handlers are currently set up using a macro
recursion. Replace that with a standard loop.

Noop patch, just a cleanup.

---
 arch/x86/kernel/head_64.S |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

Index: linux/arch/x86/kernel/head_64.S
===================================================================
--- linux.orig/arch/x86/kernel/head_64.S
+++ linux/arch/x86/kernel/head_64.S
@@ -269,18 +269,17 @@ bad_address:
 
 	.section ".init.text","ax"
 #ifdef CONFIG_EARLY_PRINTK
-.macro early_idt_tramp first, last
-	.ifgt \last-\first
-	early_idt_tramp \first, \last-1
-	.endif
-	movl $\last,%esi
+.macro early_idt_tramp i
+	movl $\i,%esi
 	jmp early_idt_handler
 .endm
-
 	.globl early_idt_handlers
 early_idt_handlers:
-	.set maxe,NUM_EXCEPTION_VECTORS-1
-	early_idt_tramp 0,maxe
+	i = 0
+	.rept NUM_EXCEPTION_VECTORS
+	early_idt_tramp i
+	i = i+1
+	.endr
 #endif
 
 ENTRY(early_idt_handler)
