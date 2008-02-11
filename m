Return-Path: <linux-kernel-owner+w=401wt.eu-S1752158AbYBKJgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158AbYBKJgA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 04:36:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751271AbYBKJeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 04:34:37 -0500
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:27392 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbYBKJef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 04:34:35 -0500
From: Andi Kleen <ak@suse.de>
References: <200802111034.764275766@suse.de>
In-Reply-To: <200802111034.764275766@suse.de>
To: tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: [PATCH] [3/8] CPA: Test the correct mapping alias on x86-64
Message-Id: <20080211093431.D673D1B41CE@basil.firstfloor.org>
Date: Mon, 11 Feb 2008 10:34:31 +0100 (CET)
X-OriginalArrivalTime: 11 Feb 2008 09:28:11.0037 (UTC) FILETIME=[6B3DECD0:01C86C90]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


static_protections previously would test against the x86-64 kernel mapping 
twice. First against the unchanged symbol directly from the linker (which
always points into the kernel mapping) and then again it would manually
relocate the address into the kernel mapping and test again.

This patch reverses the second test instead to test against the direct mapping
(low) aliases virtual addresses which was probably intended in the first place.

Simply use __pa and __va for that.

This also allows to drop an ifdef because it will work both on 32bit and 64bit.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/mm/pageattr.c |   22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

Index: linux/arch/x86/mm/pageattr.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr.c
+++ linux/arch/x86/mm/pageattr.c
@@ -128,17 +128,9 @@ static void cpa_flush_range(unsigned lon
 #define HIGH_MAP_START	__START_KERNEL_map
 #define HIGH_MAP_END	(__START_KERNEL_map + KERNEL_TEXT_SIZE)
 
-
-/*
- * Converts a virtual address to a X86-64 highmap address
- */
-static unsigned long virt_to_highmap(void *address)
+static unsigned long virt_to_direct(void *address)
 {
-#ifdef CONFIG_X86_64
-	return __pa((unsigned long)address) + HIGH_MAP_START - phys_base;
-#else
-	return (unsigned long)address;
-#endif
+	return (unsigned long)__va(__pa(address));
 }
 
 /*
@@ -165,9 +157,9 @@ static inline pgprot_t static_protection
 	if (within(address, (unsigned long)_text, (unsigned long)_etext))
 		pgprot_val(forbidden) |= _PAGE_NX;
 	/*
-	 * Do the same for the x86-64 high kernel mapping
+	 * Do the same for the direct map alias of the x86-64 text mapping
 	 */
-	if (within(address, virt_to_highmap(_text), virt_to_highmap(_etext)))
+	if (within(address, virt_to_direct(_text), virt_to_direct(_etext)))
 		pgprot_val(forbidden) |= _PAGE_NX;
 
 	/* The .rodata section needs to be read-only */
@@ -175,10 +167,10 @@ static inline pgprot_t static_protection
 				(unsigned long)__end_rodata))
 		pgprot_val(forbidden) |= _PAGE_RW;
 	/*
-	 * Do the same for the x86-64 high kernel mapping
+	 * Do the same for the direct map alias of the x86-64 text mapping
 	 */
-	if (within(address, virt_to_highmap(__start_rodata),
-				virt_to_highmap(__end_rodata)))
+	if (within(address, virt_to_direct(__start_rodata),
+				virt_to_direct(__end_rodata)))
 		pgprot_val(forbidden) |= _PAGE_RW;
 
 	prot = __pgprot(pgprot_val(prot) & ~pgprot_val(forbidden));
