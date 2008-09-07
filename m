Return-Path: <linux-kernel-owner+w=401wt.eu-S1757572AbYIGW0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757572AbYIGW0d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 18:26:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755979AbYIGWYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 18:24:19 -0400
Received: from gw.goop.org ([64.81.55.164]:39673 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755117AbYIGWYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 18:24:15 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 6 of 7] x86: use early_ioremap in __acpi_map_table
X-Mercurial-Node: 944fe7ea3da7707eb90f0c88587bccf3a9394a1f
Message-Id: <944fe7ea3da7707eb90f.1220826078@localhost>
In-Reply-To: <patchbomb.1220826072@localhost>
Date: Sun, 07 Sep 2008 15:21:18 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Xen Devel <xen-devel@lists.xensource.com>,
       Andi Kleen <andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__acpi_map_table() effectively reimplements early_ioremap().  Rather
than have that duplication, just implement it in terms of
early_ioremap().

However, unlike early_ioremap(), __acpi_map_table() just maintains a
single mapping which gets replaced each call, and has no corresponding
unmap function.  Implement this by just removing the previous mapping
each time its called.  Unfortunately, this will leave a stray mapping
at the end.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/acpi/boot.c |   27 +++++++--------------------
 include/asm-x86/acpi.h      |    3 ---
 include/asm-x86/fixmap_32.h |    4 ----
 include/asm-x86/fixmap_64.h |    4 ----
 4 files changed, 7 insertions(+), 31 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -121,8 +121,8 @@
  */
 char *__init __acpi_map_table(unsigned long phys, unsigned long size)
 {
-	unsigned long base, offset, mapped_size;
-	int idx;
+	static char *prev_map;
+	static unsigned long prev_size;
 
 	if (!phys || !size)
 		return NULL;
@@ -130,26 +130,13 @@
 	if (phys+size <= (max_low_pfn_mapped << PAGE_SHIFT))
 		return __va(phys);
 
-	offset = phys & (PAGE_SIZE - 1);
-	mapped_size = PAGE_SIZE - offset;
-	clear_fixmap(FIX_ACPI_END);
-	set_fixmap(FIX_ACPI_END, phys);
-	base = fix_to_virt(FIX_ACPI_END);
+	if (prev_map)
+		early_iounmap(prev_map, prev_size);
 
-	/*
-	 * Most cases can be covered by the below.
-	 */
-	idx = FIX_ACPI_END;
-	while (mapped_size < size) {
-		if (--idx < FIX_ACPI_BEGIN)
-			return NULL;	/* cannot handle this */
-		phys += PAGE_SIZE;
-		clear_fixmap(idx);
-		set_fixmap(idx, phys);
-		mapped_size += PAGE_SIZE;
-	}
+	prev_size = size;
+	prev_map = early_ioremap(phys, size);
 
-	return ((unsigned char *)base + offset);
+	return prev_map;
 }
 
 #ifdef CONFIG_PCI_MMCONFIG
diff --git a/include/asm-x86/acpi.h b/include/asm-x86/acpi.h
--- a/include/asm-x86/acpi.h
+++ b/include/asm-x86/acpi.h
@@ -102,9 +102,6 @@
 	acpi_noirq = 1;
 }
 
-/* Fixmap pages to reserve for ACPI boot-time tables (see fixmap.h) */
-#define FIX_ACPI_PAGES 4
-
 extern int acpi_gsi_to_irq(u32 gsi, unsigned int *irq);
 
 static inline void acpi_noirq_set(void) { acpi_noirq = 1; }
diff --git a/include/asm-x86/fixmap_32.h b/include/asm-x86/fixmap_32.h
--- a/include/asm-x86/fixmap_32.h
+++ b/include/asm-x86/fixmap_32.h
@@ -99,10 +99,6 @@
 			(__end_of_permanent_fixed_addresses & 255),
 	FIX_BTMAP_BEGIN = FIX_BTMAP_END + NR_FIX_BTMAPS*FIX_BTMAPS_NESTING - 1,
 	FIX_WP_TEST,
-#ifdef CONFIG_ACPI
-	FIX_ACPI_BEGIN,
-	FIX_ACPI_END = FIX_ACPI_BEGIN + FIX_ACPI_PAGES - 1,
-#endif
 #ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
 	FIX_OHCI1394_BASE,
 #endif
diff --git a/include/asm-x86/fixmap_64.h b/include/asm-x86/fixmap_64.h
--- a/include/asm-x86/fixmap_64.h
+++ b/include/asm-x86/fixmap_64.h
@@ -50,10 +50,6 @@
 	FIX_PARAVIRT_BOOTMAP,
 #endif
 	__end_of_permanent_fixed_addresses,
-#ifdef CONFIG_ACPI
-	FIX_ACPI_BEGIN,
-	FIX_ACPI_END = FIX_ACPI_BEGIN + FIX_ACPI_PAGES - 1,
-#endif
 #ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
 	FIX_OHCI1394_BASE,
 #endif


