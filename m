Return-Path: <linux-kernel-owner+w=401wt.eu-S1757647AbYCKBYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757647AbYCKBYU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 21:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752206AbYCKBXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 21:23:25 -0400
Received: from smtp-out02.alice-dsl.net ([88.44.60.12]:60248 "EHLO
	smtp-out02.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973AbYCKBXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 21:23:24 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20080311223.655043226@firstfloor.org>
In-Reply-To: <20080311223.655043226@firstfloor.org>
To: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: [PATCH REPOST] [3/3] Replace macro recursion with more conventional loop
Message-Id: <20080311012322.B1E221B41CE@basil.firstfloor.org>
Date: Tue, 11 Mar 2008 02:23:22 +0100 (CET)
X-OriginalArrivalTime: 11 Mar 2008 01:16:51.0065 (UTC) FILETIME=[95C9EE90:01C88315]
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
