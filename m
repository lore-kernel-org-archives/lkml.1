Return-Path: <linux-kernel-owner+w=401wt.eu-S1759599AbYFQSnK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759599AbYFQSnK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 14:43:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757676AbYFQSmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 14:42:36 -0400
Received: from gw.goop.org ([64.81.55.164]:51607 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757390AbYFQSmf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 14:42:35 -0400
Message-ID: <48580572.4050709@goop.org>
Date: Tue, 17 Jun 2008 11:41:54 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: the arch/x86 maintainers <x86@kernel.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/4] x86: unify __set_fixmap
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__set_fixmap() is functionally identical in 32 and 64-bit.  The
cosmetic differences are:
 1. 32-bit __set_fixmap keeps track of the number of times it has been called, so
    that reserve_top_address can BUG if it's called too late
 2. 64-bit prints a message if the index is bad, rather than bugging.

In both cases, I went with the 32-bit behaviour.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/mm/init_64.c    |   12 ------------
 arch/x86/mm/pgtable.c    |   14 ++++++++++++++
 arch/x86/mm/pgtable_32.c |   14 +-------------
 include/asm-x86/fixmap.h |    2 ++
 4 files changed, 17 insertions(+), 25 deletions(-)

===================================================================
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -212,18 +212,6 @@
 		if (vaddr < (unsigned long) _text || vaddr > end)
 			set_pmd(pmd, __pmd(0));
 	}
-}
-
-/* NOTE: this is meant to be run only at boot */
-void __set_fixmap(enum fixed_addresses idx, unsigned long phys, pgprot_t prot)
-{
-	unsigned long address = __fix_to_virt(idx);
-
-	if (idx >= __end_of_fixed_addresses) {
-		printk(KERN_ERR "Invalid __set_fixmap\n");
-		return;
-	}
-	set_pte_phys(address, phys, prot);
 }
 
 static unsigned long __initdata table_start;
===================================================================
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -274,3 +274,17 @@
 
 	return young;
 }
+
+int fixmaps_set;
+
+void __set_fixmap (enum fixed_addresses idx, unsigned long phys, pgprot_t flags)
+{
+	unsigned long address = __fix_to_virt(idx);
+
+	if (idx >= __end_of_fixed_addresses) {
+		BUG();
+		return;
+	}
+	set_pte_pfn(address, phys >> PAGE_SHIFT, flags);
+	fixmaps_set++;
+}
===================================================================
--- a/arch/x86/mm/pgtable_32.c
+++ b/arch/x86/mm/pgtable_32.c
@@ -145,18 +145,6 @@
 unsigned long __FIXADDR_TOP = 0xfffff000;
 EXPORT_SYMBOL(__FIXADDR_TOP);
 
-void __set_fixmap (enum fixed_addresses idx, unsigned long phys, pgprot_t flags)
-{
-	unsigned long address = __fix_to_virt(idx);
-
-	if (idx >= __end_of_fixed_addresses) {
-		BUG();
-		return;
-	}
-	set_pte_pfn(address, phys >> PAGE_SHIFT, flags);
-	fixmaps++;
-}
-
 /**
  * reserve_top_address - reserves a hole in the top of kernel address space
  * @reserve - size of hole to reserve
@@ -166,7 +154,7 @@
  */
 void reserve_top_address(unsigned long reserve)
 {
-	BUG_ON(fixmaps > 0);
+	BUG_ON(fixmaps_set > 0);
 	printk(KERN_INFO "Reserving virtual address space above 0x%08x\n",
 	       (int)-reserve);
 	__FIXADDR_TOP = -reserve - PAGE_SIZE;
===================================================================
--- a/include/asm-x86/fixmap.h
+++ b/include/asm-x86/fixmap.h
@@ -6,6 +6,8 @@
 #else
 # include "fixmap_64.h"
 #endif
+
+extern int fixmaps_set;
 
 extern void __set_fixmap(enum fixed_addresses idx,
 			 unsigned long phys, pgprot_t flags);


