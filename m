Return-Path: <linux-kernel-owner+w=401wt.eu-S1754401Ab0AMAqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401Ab0AMAqZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 19:46:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752356Ab0AMAqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 19:46:24 -0500
Received: from rex.securecomputing.com ([203.24.151.4]:36789 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751998Ab0AMAqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 19:46:23 -0500
Date: Wed, 13 Jan 2010 10:46:40 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <201001130046.o0D0kerS031219@goober.internal.moreton.com.au>
CC: <gerg@uclinux.org>, <linux-m68k@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: [PATCH] m68knommu: fix definitions of __pa() and __va()
To: <torvalds@linux-foundation.org>
X-Mailer: mail (GNU Mailutils 2.0)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From d88bced890fcc16807288e5c161737aabeb1407b Mon Sep 17 00:00:00 2001
From: Greg Ungerer <gerg@uclinux.org>
Date: Wed, 13 Jan 2010 10:42:05 +1000
Subject: [PATCH] m68knommu: fix definitions of __pa() and __va()

Fix compilation breakage of all m68knommu targets:

  CC      arch/m68knommu/kernel/asm-offsets.s
In file included from include/linux/sched.h:77,
                 from arch/m68knommu/kernel/asm-offsets.c:12:
include/linux/percpu.h: In function 'per_cpu_ptr_to_phys':
include/linux/percpu.h:161: error: implicit declaration of function 'virt_to_phy

This is broken in linux-2.6.33-rc3.

Change the definitions of __pa() and __va() to not use virt_to_phys()
and phys_to_virt(). Trivial 1:1 conversion required for the non-MMU case.

A side effect if this is that the m68knommu can now use asm/virtconvert.h
for the definition of virt_to_phys() and phys_to_virt().

Also cleaned up the definition of page_to_phys() when moving into
virtconvert.h.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---
 arch/m68k/include/asm/io_no.h       |   14 +-------------
 arch/m68k/include/asm/page_no.h     |    4 ++--
 arch/m68k/include/asm/virtconvert.h |    4 ++++
 3 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/arch/m68k/include/asm/io_no.h b/arch/m68k/include/asm/io_no.h
index 7f57436..359065d 100644
--- a/arch/m68k/include/asm/io_no.h
+++ b/arch/m68k/include/asm/io_no.h
@@ -3,6 +3,7 @@
 
 #ifdef __KERNEL__
 
+#include <asm/virtconvert.h>
 
 /*
  * These are for ISA/PCI shared memory _only_ and should never be used
@@ -165,19 +166,6 @@ static inline void *ioremap_fullcache(unsigned long physaddr, unsigned long size
 
 extern void iounmap(void *addr);
 
-/* Pages to physical address... */
-#define page_to_phys(page)      ((page - mem_map) << PAGE_SHIFT)
-#define page_to_bus(page)       ((page - mem_map) << PAGE_SHIFT)
-
-/*
- * Macros used for converting between virtual and physical mappings.
- */
-#define phys_to_virt(vaddr)	((void *) (vaddr))
-#define virt_to_phys(vaddr)	((unsigned long) (vaddr))
-
-#define virt_to_bus virt_to_phys
-#define bus_to_virt phys_to_virt
-
 /*
  * Convert a physical pointer to a virtual kernel pointer for /dev/mem
  * access
diff --git a/arch/m68k/include/asm/page_no.h b/arch/m68k/include/asm/page_no.h
index 1f31b06..8029a33 100644
--- a/arch/m68k/include/asm/page_no.h
+++ b/arch/m68k/include/asm/page_no.h
@@ -56,8 +56,8 @@ extern unsigned long memory_end;
 
 #ifndef __ASSEMBLY__
 
-#define __pa(vaddr)		virt_to_phys((void *)(vaddr))
-#define __va(paddr)		phys_to_virt((unsigned long)(paddr))
+#define __pa(vaddr)		((unsigned long)(vaddr))
+#define __va(paddr)		((void *)(paddr))
 
 #define virt_to_pfn(kaddr)	(__pa(kaddr) >> PAGE_SHIFT)
 #define pfn_to_virt(pfn)	__va((pfn) << PAGE_SHIFT)
diff --git a/arch/m68k/include/asm/virtconvert.h b/arch/m68k/include/asm/virtconvert.h
index 22ab05c..3f834b3 100644
--- a/arch/m68k/include/asm/virtconvert.h
+++ b/arch/m68k/include/asm/virtconvert.h
@@ -26,6 +26,7 @@ static inline void *phys_to_virt(unsigned long address)
 }
 
 /* Permanent address of a page. */
+#ifdef CONFIG_MMU
 #ifdef CONFIG_SINGLE_MEMORY_CHUNK
 #define page_to_phys(page) \
 	__pa(PAGE_OFFSET + (((page) - pg_data_map[0].node_mem_map) << PAGE_SHIFT))
@@ -37,6 +38,9 @@ static inline void *phys_to_virt(unsigned long address)
 	page_to_pfn(__page) << PAGE_SHIFT;				\
 })
 #endif
+#else
+#define page_to_phys(page)	(((page) - mem_map) << PAGE_SHIFT)
+#endif
 
 /*
  * IO bus memory addresses are 1:1 with the physical address,
-- 
1.6.3.3

