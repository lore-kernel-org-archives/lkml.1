Return-Path: <linux-kernel-owner+w=401wt.eu-S1760652AbYBHN3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760652AbYBHN3b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 08:29:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759340AbYBHN2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 08:28:04 -0500
Received: from smtp-out02.alice-dsl.net ([88.44.60.12]:28749 "EHLO
	smtp-out02.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759253AbYBHN2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 08:28:03 -0500
From: Andi Kleen <ak@suse.de>
References: <20080208227.168531243@suse.de>
In-Reply-To: <20080208227.168531243@suse.de>
To: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: [PATCH] [2/5] Support range checking for required/advisory protections
Message-Id: <20080208132745.30F891B41BB@basil.firstfloor.org>
Date: Fri,  8 Feb 2008 14:27:45 +0100 (CET)
X-OriginalArrivalTime: 08 Feb 2008 13:21:24.0919 (UTC) FILETIME=[81019C70:01C86A55]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Previously these checks would only check a single address, which is ok
for 4k pages, but not for large pages

Needed for followup patches

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/mm/pageattr.c |   31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

Index: linux/arch/x86/mm/pageattr.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr.c
+++ linux/arch/x86/mm/pageattr.c
@@ -35,6 +35,13 @@ within(unsigned long addr, unsigned long
 	return addr >= start && addr < end;
 }
 
+static inline int
+within_range(unsigned long addr_start, unsigned long addr_end,
+		unsigned long start, unsigned long end)
+{
+	return addr_end >= start && addr_start < end;
+}
+
 /*
  * Flushing functions
  */
@@ -149,7 +156,8 @@ static unsigned long virt_to_highmap(voi
  * right (again, ioremap() on BIOS memory is not uncommon) so this function
  * checks and fixes these known static required protection bits.
  */
-static inline pgprot_t required_static_prot(pgprot_t prot, unsigned long address)
+static inline pgprot_t
+required_static_prot(pgprot_t prot, unsigned long start, unsigned long end)
 {
 	pgprot_t forbidden = __pgprot(0);
 
@@ -157,19 +165,21 @@ static inline pgprot_t required_static_p
 	 * The BIOS area between 640k and 1Mb needs to be executable for
 	 * PCI BIOS based config access (CONFIG_PCI_GOBIOS) support.
 	 */
-	if (within(__pa(address), BIOS_BEGIN, BIOS_END))
+	if (within_range(__pa(start), __pa(end), BIOS_BEGIN, BIOS_END))
 		pgprot_val(forbidden) |= _PAGE_NX;
 
 	/*
 	 * The kernel text needs to be executable for obvious reasons
 	 * Does not cover __inittext since that is gone later on
 	 */
-	if (within(address, (unsigned long)_text, (unsigned long)_etext))
+	if (within_range(start, end,
+		(unsigned long)_text, (unsigned long)_etext))
 		pgprot_val(forbidden) |= _PAGE_NX;
 	/*
 	 * Do the same for the x86-64 high kernel mapping
 	 */
-	if (within(address, virt_to_highmap(_text), virt_to_highmap(_etext)))
+	if (within_range(start, end,
+			virt_to_highmap(_text), virt_to_highmap(_etext)))
 		pgprot_val(forbidden) |= _PAGE_NX;
 
 
@@ -178,17 +188,18 @@ static inline pgprot_t required_static_p
 	return prot;
 }
 
-static inline pgprot_t advised_static_prot(pgprot_t prot, unsigned long address)
+static inline pgprot_t
+advised_static_prot(pgprot_t prot, unsigned long start, unsigned long end)
 {
 #ifdef CONFIG_DEBUG_RODATA
 	/* The .rodata section needs to be read-only */
-	if (within(address, (unsigned long)__start_rodata,
+	if (within_range(start, end, (unsigned long)__start_rodata,
 				(unsigned long)__end_rodata))
 		pgprot_val(prot) &= ~_PAGE_RW;
 	/*
 	 * Do the same for the x86-64 high kernel mapping
 	 */
-	if (within(address, virt_to_highmap(__start_rodata),
+	if (within_range(start, end, virt_to_highmap(__start_rodata),
 				virt_to_highmap(__end_rodata)))
 		pgprot_val(prot) &= ~_PAGE_RW;
 #endif
@@ -322,8 +333,8 @@ try_preserve_large_page(pte_t *kpte, uns
 
 	pgprot_val(new_prot) &= ~pgprot_val(cpa->mask_clr);
 	pgprot_val(new_prot) |= pgprot_val(cpa->mask_set);
-	new_prot = required_static_prot(new_prot, address);
-	new_prot = advised_static_prot(new_prot, address);
+	new_prot = required_static_prot(new_prot, address, address + psize - 1);
+	new_prot = advised_static_prot(new_prot, address, address + psize - 1);
 
 	/*
 	 * If there are no changes, return. maxpages has been updated
@@ -447,6 +458,7 @@ repeat:
 	BUG_ON(PageCompound(kpte_page));
 
 	if (level == PG_LEVEL_4K) {
+		unsigned long end = address + PAGE_SIZE - 1;
 		pte_t new_pte, old_pte = *kpte;
 		pgprot_t new_prot = pte_pgprot(old_pte);
 
@@ -461,8 +473,8 @@ repeat:
 		pgprot_val(new_prot) &= ~pgprot_val(cpa->mask_clr);
 		pgprot_val(new_prot) |= pgprot_val(cpa->mask_set);
 
-		new_prot = required_static_prot(new_prot, address);
-		new_prot = advised_static_prot(new_prot, address);
+		new_prot = required_static_prot(new_prot, address, end);
+		new_prot = advised_static_prot(new_prot, address, end);
 
 		/*
 		 * We need to keep the pfn from the existing PTE,
