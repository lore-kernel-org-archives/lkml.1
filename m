Return-Path: <linux-kernel-owner+w=401wt.eu-S937345AbXGRXim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937345AbXGRXim (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 19:38:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936849AbXGRXba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 19:31:30 -0400
Received: from rex.snapgear.com ([203.143.235.140]:35240 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S936852AbXGRXb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 19:31:28 -0400
Date: Thu, 19 Jul 2007 09:30:14 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200707182330.l6INUENk014895@goober>
To: torvalds@linux-foundation.org
Subject: [PATCH][RESEND] m68knommu: remove is_in_rom() function
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove is_in_rom() function. It doesn't actually serve the purpose it was
intended to. If you look at the use of it _access_ok() (which is the only
use of it) then it is obvious that most of memory is marked as access_ok.
No point having is_in_rom() then, so remove it.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naur linux-2.6.22/arch/m68knommu/mm/memory.c linux-2.6.22-uc0/arch/m68knommu/mm/memory.c
--- linux-2.6.22/arch/m68knommu/mm/memory.c	2007-07-12 15:23:02.000000000 +1000
+++ linux-2.6.22-uc0/arch/m68knommu/mm/memory.c	2007-07-12 15:27:04.000000000 +1000
@@ -109,23 +33,3 @@
 	return paddr;
 }
 
-
-int is_in_rom(unsigned long addr)
-{
-	extern unsigned long _ramstart, _ramend;
-
-	/*
-	 *	What we are really trying to do is determine if addr is
-	 *	in an allocated kernel memory region. If not then assume
-	 *	we cannot free it or otherwise de-allocate it. Ideally
-	 *	we could restrict this to really being in a ROM or flash,
-	 *	but that would need to be done on a board by board basis,
-	 *	not globally.
-	 */
-	if ((addr < _ramstart) || (addr >= _ramend))
-		return(1);
-
-	/* Default case, not in ROM */
-	return(0);
-}
-
diff -Naur linux-2.6.22/arch/m68knommu/kernel/m68k_ksyms.c linux-2.6.22-uc0/arch/m68knommu/kernel/m68k_ksyms.c
--- linux-2.6.22/arch/m68knommu/kernel/m68k_ksyms.c	2007-07-12 15:23:02.000000000 +1000
+++ linux-2.6.22-uc0/arch/m68knommu/kernel/m68k_ksyms.c	2007-07-12 15:27:00.000000000 +1000
@@ -81,8 +81,6 @@
 EXPORT_SYMBOL(__udivsi3);
 EXPORT_SYMBOL(__umodsi3);
 
-EXPORT_SYMBOL(is_in_rom);
-
 #ifdef CONFIG_COLDFIRE
 extern unsigned int *dma_device_address;
 extern unsigned long dma_base_addr, _ramend;
diff -Naur linux-2.6.22/include/asm-m68knommu/pgtable.h linux-2.6.22-uc0/include/asm-m68knommu/pgtable.h
--- linux-2.6.22/include/asm-m68knommu/pgtable.h	2007-07-12 15:21:55.000000000 +1000
+++ linux-2.6.22-uc0/include/asm-m68knommu/pgtable.h	2007-07-12 15:23:58.000000000 +1000
@@ -49,7 +49,6 @@
  * These would be in other places but having them here reduces the diffs.
  */
 extern unsigned int kobjsize(const void *objp);
-extern int is_in_rom(unsigned long);
 
 /*
  * No page table caches to initialise.
diff -Naur linux-2.6.22/include/asm-m68knommu/uaccess.h linux-2.6.22-uc0/include/asm-m68knommu/uaccess.h
--- linux-2.6.22/include/asm-m68knommu/uaccess.h	2007-07-12 15:21:55.000000000 +1000
+++ linux-2.6.22-uc0/include/asm-m68knommu/uaccess.h	2007-07-12 15:23:59.000000000 +1000
@@ -15,12 +15,15 @@
 
 #define access_ok(type,addr,size)	_access_ok((unsigned long)(addr),(size))
 
+/*
+ * It is not enough to just have access_ok check for a real RAM address.
+ * This would disallow the case of code/ro-data running XIP in flash/rom.
+ * Ideally we would check the possible flash ranges too, but that is
+ * currently not so easy.
+ */
 static inline int _access_ok(unsigned long addr, unsigned long size)
 {
-	extern unsigned long memory_start, memory_end;
-
-	return (((addr >= memory_start) && (addr+size < memory_end)) ||
-		(is_in_rom(addr) && is_in_rom(addr+size)));
+	return 1;
 }
 
 /*
