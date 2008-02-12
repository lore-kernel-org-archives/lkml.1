Return-Path: <linux-kernel-owner+w=401wt.eu-S1762146AbYBLMyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762146AbYBLMyA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 07:54:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761344AbYBLMxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 07:53:36 -0500
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:34210 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761272AbYBLMxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 07:53:35 -0500
From: Andi Kleen <ak@suse.de>
References: <20080212153.888987414@suse.de>
In-Reply-To: <20080212153.888987414@suse.de>
To: tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: [PATCH] [2/2] Improve not NX check in i386 direct mapping setup
Message-Id: <20080212125325.E993B1B4174@basil.firstfloor.org>
Date: Tue, 12 Feb 2008 13:53:25 +0100 (CET)
X-OriginalArrivalTime: 12 Feb 2008 12:47:04.0349 (UTC) FILETIME=[5E7694D0:01C86D75]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[This is a replacement for the direct mapping protections patchkit from 
 last week.  It is simpler by implementing its own specialized duplicated logic
 instead of adapting the existing pageattr logic to be usable for this case]

The i386 direct mapping support needs to avoid setting NX on pages
that are used by the kernel text. This patch improves the checks
for that case.

- Check the correct range of kernel text not including data only
sections at the end.
- Check the beginning too because there could be quite some pages
before the kernel text on a high loaded kernel
(previously all pages) 
- Add a special check for the PCI-BIOS range in the first MB 
that needs to be executable.
- Drop the inline for that function because it is larger now.

Result will be less pages in the direct mapping without NX
in some cases (particular with relocatable kernel loaded high)
giving a very minor increase of security against buffer overflows
in the kernel.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/kernel/vmlinux_32.lds.S |    1 +
 arch/x86/mm/init_32.c            |   14 +++++++++-----
 2 files changed, 10 insertions(+), 5 deletions(-)

Index: linux/arch/x86/mm/init_32.c
===================================================================
--- linux.orig/arch/x86/mm/init_32.c
+++ linux/arch/x86/mm/init_32.c
@@ -143,9 +143,14 @@ page_table_range_init(unsigned long star
 	}
 }
 
-static inline int is_kernel_text(unsigned long addr)
+extern char __end_text[];
+
+static int __init is_kernel_text(unsigned long start, unsigned long end)
 {
-	if (addr >= PAGE_OFFSET && addr <= (unsigned long)__init_end)
+	if (end >= (unsigned long)_text && start < (unsigned long)__end_text)
+		return 1;
+	/* Allow execution of 32bit BIOS */
+	if (end >= BIOS_BEGIN && start < BIOS_END)
 		return 1;
 	return 0;
 }
@@ -188,8 +193,7 @@ static void __init kernel_physical_mappi
 				addr2 = (pfn + PTRS_PER_PTE-1) * PAGE_SIZE +
 					PAGE_OFFSET + PAGE_SIZE-1;
 
-				if (is_kernel_text(addr) ||
-				    is_kernel_text(addr2))
+				if (is_kernel_text(addr, addr2))
 					prot = PAGE_KERNEL_LARGE_EXEC;
 
 				set_pmd(pmd, pfn_pmd(pfn, prot));
@@ -205,7 +209,7 @@ static void __init kernel_physical_mappi
 			     pte++, pfn++, pte_ofs++, addr += PAGE_SIZE) {
 				pgprot_t prot = PAGE_KERNEL;
 
-				if (is_kernel_text(addr))
+				if (is_kernel_text(addr, addr + PAGE_SIZE - 1))
 					prot = PAGE_KERNEL_EXEC;
 
 				set_pte(pte, pfn_pte(pfn, prot));
Index: linux/arch/x86/kernel/vmlinux_32.lds.S
===================================================================
--- linux.orig/arch/x86/kernel/vmlinux_32.lds.S
+++ linux/arch/x86/kernel/vmlinux_32.lds.S
@@ -165,6 +165,7 @@ SECTIONS
 	*(.parainstructions)
   	__parainstructions_end = .;
   }
+  __end_text = .;
   /* .exit.text is discard at runtime, not link time, to deal with references
      from .altinstructions and .eh_frame */
   .exit.text : AT(ADDR(.exit.text) - LOAD_OFFSET) {
