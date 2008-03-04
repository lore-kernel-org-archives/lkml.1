Return-Path: <linux-kernel-owner+w=401wt.eu-S1761411AbYCDVOG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761411AbYCDVOG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 16:14:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755824AbYCDVNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 16:13:42 -0500
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:55782 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755596AbYCDVNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 16:13:40 -0500
From: Andi Kleen <andi@firstfloor.org>
Message-Id: <200803041013.139953228@firstfloor.org>
To: tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: [PATCH REPOST] [1/3] Don't set up early exception handlers for external interrupts
Date: Tue,  4 Mar 2008 22:13:30 +0100 (CET)
X-OriginalArrivalTime: 04 Mar 2008 21:07:00.0752 (UTC) FILETIME=[B0633100:01C87E3B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


All of early setup runs with interrupts disabled, so there is no 
need to set up early exception handlers for vectors >= 32

That saves some text size

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/kernel/head64.c  |    2 +-
 arch/x86/kernel/head_64.S |    6 ++----
 include/asm-x86/segment.h |    3 ++-
 3 files changed, 5 insertions(+), 6 deletions(-)

Index: linux/arch/x86/kernel/head64.c
===================================================================
--- linux.orig/arch/x86/kernel/head64.c
+++ linux/arch/x86/kernel/head64.c
@@ -91,7 +91,7 @@ void __init x86_64_start_kernel(char * r
 	/* Cleanup the over mapped high alias */
 	cleanup_highmap();
 
-	for (i = 0; i < IDT_ENTRIES; i++) {
+	for (i = 0; i < NUM_EXCEPTION_VECTORS; i++) {
 #ifdef CONFIG_EARLY_PRINTK
 		set_intr_gate(i, &early_idt_handlers[i]);
 #else
Index: linux/include/asm-x86/segment.h
===================================================================
--- linux.orig/include/asm-x86/segment.h
+++ linux/include/asm-x86/segment.h
@@ -191,13 +191,14 @@
 #define SEGMENT_TI_MASK		0x4
 
 #define IDT_ENTRIES 256
+#define NUM_EXCEPTION_VECTORS 32
 #define GDT_SIZE (GDT_ENTRIES * 8)
 #define GDT_ENTRY_TLS_ENTRIES 3
 #define TLS_SIZE (GDT_ENTRY_TLS_ENTRIES * 8)
 
 #ifdef __KERNEL__
 #ifndef __ASSEMBLY__
-extern const char early_idt_handlers[IDT_ENTRIES][10];
+extern const char early_idt_handlers[NUM_EXCEPTION_VECTORS][10];
 #endif
 #endif
 
Index: linux/arch/x86/kernel/head_64.S
===================================================================
--- linux.orig/arch/x86/kernel/head_64.S
+++ linux/arch/x86/kernel/head_64.S
@@ -278,10 +278,8 @@ bad_address:
 
 	.globl early_idt_handlers
 early_idt_handlers:
-	early_idt_tramp 0, 63
-	early_idt_tramp 64, 127
-	early_idt_tramp 128, 191
-	early_idt_tramp 192, 255
+	.set maxe,NUM_EXCEPTION_VECTORS-1
+	early_idt_tramp 0,maxe
 #endif
 
 ENTRY(early_idt_handler)
