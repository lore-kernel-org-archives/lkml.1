Return-Path: <linux-kernel-owner+w=401wt.eu-S1755579AbYBYLHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579AbYBYLHY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 06:07:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753576AbYBYLHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 06:07:12 -0500
Received: from smtp-out02.alice-dsl.net ([88.44.60.12]:19066 "EHLO
	smtp-out02.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbYBYLHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 06:07:11 -0500
From: Andi Kleen <andi@firstfloor.org>
Message-Id: <200802251207.906590508@firstfloor.org>
To: mingo@elte.hu, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       roland@redhat.com
Subject: [PATCH] [1/3] Don't set up early exception handlers for external interrupts
Date: Mon, 25 Feb 2008 12:07:08 +0100 (CET)
X-OriginalArrivalTime: 25 Feb 2008 11:00:42.0720 (UTC) FILETIME=[AA160600:01C8779D]
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
