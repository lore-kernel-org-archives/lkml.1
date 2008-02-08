Return-Path: <linux-kernel-owner+w=401wt.eu-S932950AbYBHQiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932950AbYBHQiP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 11:38:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759099AbYBHQgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 11:36:21 -0500
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:8715 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758688AbYBHQgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 11:36:18 -0500
From: Andi Kleen <ak@suse.de>
References: <20080208536.837219990@suse.de>
In-Reply-To: <20080208536.837219990@suse.de>
To: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: [PATCH] [1/5] CPA: Split static_protections into required_static_prot and advised_static_prot
Message-Id: <20080208163612.D76421B41AA@basil.firstfloor.org>
Date: Fri,  8 Feb 2008 17:36:12 +0100 (CET)
X-OriginalArrivalTime: 08 Feb 2008 16:29:52.0792 (UTC) FILETIME=[D5061980:01C86A6F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There is a big difference between NX and RO. NX absolutely has to be cleared
or the kernel will fail while RO just can be set, but does not need to.
And for a large page area not setting NX if there is a area below 
it that needs it is essential, while making it ro is optional again.

This is needed for a followup patch who uses requred_static_prot() for large 
pages where it is inconvenient to check all pages. 

No behaviour change in this patch.

[Lines > 80 characters are changed in followup patch]

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/mm/pageattr.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

Index: linux/arch/x86/mm/pageattr.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr.c
+++ linux/arch/x86/mm/pageattr.c
@@ -149,7 +149,7 @@ static unsigned long virt_to_highmap(voi
  * right (again, ioremap() on BIOS memory is not uncommon) so this function
  * checks and fixes these known static required protection bits.
  */
-static inline pgprot_t static_protections(pgprot_t prot, unsigned long address)
+static inline pgprot_t required_static_prot(pgprot_t prot, unsigned long address)
 {
 	pgprot_t forbidden = __pgprot(0);
 
@@ -172,6 +172,15 @@ static inline pgprot_t static_protection
 	if (within(address, virt_to_highmap(_text), virt_to_highmap(_etext)))
 		pgprot_val(forbidden) |= _PAGE_NX;
 
+	prot = __pgprot(pgprot_val(prot) & ~pgprot_val(forbidden));
+
+	return prot;
+}
+
+static inline pgprot_t advised_static_prot(pgprot_t prot, unsigned long address)
+{
+	pgprot_t forbidden = __pgprot(0);
+
 	/* The .rodata section needs to be read-only */
 	if (within(address, (unsigned long)__start_rodata,
 				(unsigned long)__end_rodata))
@@ -304,7 +313,8 @@ try_preserve_large_page(pte_t *kpte, uns
 
 	pgprot_val(new_prot) &= ~pgprot_val(cpa->mask_clr);
 	pgprot_val(new_prot) |= pgprot_val(cpa->mask_set);
-	new_prot = static_protections(new_prot, address);
+	new_prot = required_static_prot(new_prot, address);
+	new_prot = advised_static_prot(new_prot, address);
 
 	/*
 	 * If there are no changes, return. maxpages has been updated
@@ -442,7 +452,8 @@ repeat:
 		pgprot_val(new_prot) &= ~pgprot_val(cpa->mask_clr);
 		pgprot_val(new_prot) |= pgprot_val(cpa->mask_set);
 
-		new_prot = static_protections(new_prot, address);
+		new_prot = required_static_prot(new_prot, address);
+		new_prot = advised_static_prot(new_prot, address);
 
 		/*
 		 * We need to keep the pfn from the existing PTE,
@@ -532,7 +543,7 @@ static int change_page_attr_addr(struct 
 		 * for the non obvious details.
 		 *
 		 * Note that NX and other required permissions are
-		 * checked in static_protections().
+		 * checked in required_static_prot().
 		 */
 		address = phys_addr + HIGH_MAP_START - phys_base;
 
