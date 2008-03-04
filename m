Return-Path: <linux-kernel-owner+w=401wt.eu-S1756561AbYCDVOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561AbYCDVOw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 16:14:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755787AbYCDVNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 16:13:45 -0500
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:55782 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755776AbYCDVNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 16:13:44 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <200803041013.139953228@firstfloor.org>
In-Reply-To: <200803041013.139953228@firstfloor.org>
To: tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: [PATCH REPOST] [3/3] Replace macro recursion with more conventional loop
Message-Id: <20080304211332.2F4C61B4199@basil.firstfloor.org>
Date: Tue,  4 Mar 2008 22:13:32 +0100 (CET)
X-OriginalArrivalTime: 04 Mar 2008 21:07:02.0736 (UTC) FILETIME=[B191ED00:01C87E3B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The early exception handlers are currently set up using a macro
recursion. Replace that with a standard loop.

Noop patch, just a cleanup.

Signed-off-by: Andi Kleen <ak@suse.de>

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
