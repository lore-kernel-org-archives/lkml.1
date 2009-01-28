Return-Path: <linux-kernel-owner+w=401wt.eu-S1753025AbZA1Xmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025AbZA1Xmv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 18:42:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755374AbZA1Xma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:42:30 -0500
Received: from gw.goop.org ([64.81.55.164]:57246 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754879AbZA1Xm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:42:29 -0500
Message-ID: <4980ED63.6030604@goop.org>
Date: Wed, 28 Jan 2009 15:42:27 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] x86: asm/io.h: unify virt_to_phys/phys_to_virt
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/io.h    |   59 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/io_32.h |   57 ----------------------------------------
 arch/x86/include/asm/io_64.h |   37 --------------------------
 3 files changed, 59 insertions(+), 94 deletions(-)

===================================================================
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -5,6 +5,7 @@
 
 #include <linux/compiler.h>
 #include <asm-generic/int-ll64.h>
+#include <asm/page.h>
 
 #define build_mmio_read(name, size, type, reg, barrier) \
 static inline type name(const volatile void __iomem *addr) \
@@ -80,6 +81,64 @@
 #define readq			readq
 #define writeq			writeq
 
+/**
+ *	virt_to_phys	-	map virtual addresses to physical
+ *	@address: address to remap
+ *
+ *	The returned physical address is the physical (CPU) mapping for
+ *	the memory address given. It is only valid to use this function on
+ *	addresses directly mapped or allocated via kmalloc.
+ *
+ *	This function does not give bus mappings for DMA transfers. In
+ *	almost all conceivable cases a device driver should not be using
+ *	this function
+ */
+
+static inline phys_addr_t virt_to_phys(volatile void *address)
+{
+	return __pa(address);
+}
+
+/**
+ *	phys_to_virt	-	map physical address to virtual
+ *	@address: address to remap
+ *
+ *	The returned virtual address is a current CPU mapping for
+ *	the memory address given. It is only valid to use this function on
+ *	addresses that have a kernel mapping
+ *
+ *	This function does not handle bus mappings for DMA transfers. In
+ *	almost all conceivable cases a device driver should not be using
+ *	this function
+ */
+
+static inline void *phys_to_virt(phys_addr_t address)
+{
+	return __va(address);
+}
+
+/*
+ * Change "struct page" to physical address.
+ */
+#define page_to_phys(page)    ((dma_addr_t)page_to_pfn(page) << PAGE_SHIFT)
+
+/*
+ * ISA I/O bus memory addresses are 1:1 with the physical address.
+ */
+#define isa_virt_to_bus virt_to_phys
+#define isa_page_to_bus page_to_phys
+#define isa_bus_to_virt phys_to_virt
+
+/*
+ * However PCI ones are not necessarily 1:1 and therefore these interfaces
+ * are forbidden in portable PCI drivers.
+ *
+ * Allow them on x86 for legacy drivers, though.
+ */
+#define virt_to_bus virt_to_phys
+#define bus_to_virt phys_to_virt
+
+
 #ifdef CONFIG_X86_32
 # include "io_32.h"
 #else
===================================================================
--- a/arch/x86/include/asm/io_32.h
+++ b/arch/x86/include/asm/io_32.h
@@ -52,47 +52,6 @@
 #define xlate_dev_kmem_ptr(p)	p
 
 /**
- *	virt_to_phys	-	map virtual addresses to physical
- *	@address: address to remap
- *
- *	The returned physical address is the physical (CPU) mapping for
- *	the memory address given. It is only valid to use this function on
- *	addresses directly mapped or allocated via kmalloc.
- *
- *	This function does not give bus mappings for DMA transfers. In
- *	almost all conceivable cases a device driver should not be using
- *	this function
- */
-
-static inline unsigned long virt_to_phys(volatile void *address)
-{
-	return __pa(address);
-}
-
-/**
- *	phys_to_virt	-	map physical address to virtual
- *	@address: address to remap
- *
- *	The returned virtual address is a current CPU mapping for
- *	the memory address given. It is only valid to use this function on
- *	addresses that have a kernel mapping
- *
- *	This function does not handle bus mappings for DMA transfers. In
- *	almost all conceivable cases a device driver should not be using
- *	this function
- */
-
-static inline void *phys_to_virt(unsigned long address)
-{
-	return __va(address);
-}
-
-/*
- * Change "struct page" to physical address.
- */
-#define page_to_phys(page)    ((dma_addr_t)page_to_pfn(page) << PAGE_SHIFT)
-
-/**
  * ioremap     -   map bus memory into CPU space
  * @offset:    bus address of the memory
  * @size:      size of the resource to map
@@ -121,22 +80,6 @@
 
 extern void iounmap(volatile void __iomem *addr);
 
-/*
- * ISA I/O bus memory addresses are 1:1 with the physical address.
- */
-#define isa_virt_to_bus virt_to_phys
-#define isa_page_to_bus page_to_phys
-#define isa_bus_to_virt phys_to_virt
-
-/*
- * However PCI ones are not necessarily 1:1 and therefore these interfaces
- * are forbidden in portable PCI drivers.
- *
- * Allow them on x86 for legacy drivers, though.
- */
-#define virt_to_bus virt_to_phys
-#define bus_to_virt phys_to_virt
-
 static inline void
 memset_io(volatile void __iomem *addr, unsigned char val, int count)
 {
===================================================================
--- a/arch/x86/include/asm/io_64.h
+++ b/arch/x86/include/asm/io_64.h
@@ -140,27 +140,6 @@
 
 #include <linux/vmalloc.h>
 
-#ifndef __i386__
-/*
- * Change virtual addresses to physical addresses and vv.
- * These are pretty trivial
- */
-static inline unsigned long virt_to_phys(volatile void *address)
-{
-	return __pa(address);
-}
-
-static inline void *phys_to_virt(unsigned long address)
-{
-	return __va(address);
-}
-#endif
-
-/*
- * Change "struct page" to physical address.
- */
-#define page_to_phys(page)    ((dma_addr_t)page_to_pfn(page) << PAGE_SHIFT)
-
 #include <asm-generic/iomap.h>
 
 /*
@@ -185,22 +164,6 @@
 
 extern void __iomem *fix_ioremap(unsigned idx, unsigned long phys);
 
-/*
- * ISA I/O bus memory addresses are 1:1 with the physical address.
- */
-#define isa_virt_to_bus virt_to_phys
-#define isa_page_to_bus page_to_phys
-#define isa_bus_to_virt phys_to_virt
-
-/*
- * However PCI ones are not necessarily 1:1 and therefore these interfaces
- * are forbidden in portable PCI drivers.
- *
- * Allow them on x86 for legacy drivers, though.
- */
-#define virt_to_bus virt_to_phys
-#define bus_to_virt phys_to_virt
-
 void __memcpy_fromio(void *, unsigned long, unsigned);
 void __memcpy_toio(unsigned long, const void *, unsigned);
 


