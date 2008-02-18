Return-Path: <linux-kernel-owner+w=401wt.eu-S1758186AbYBRDgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758186AbYBRDgS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 22:36:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752111AbYBRDgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 22:36:05 -0500
Received: from ozlabs.org ([203.10.76.45]:46817 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551AbYBRDgC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 22:36:02 -0500
To: <linux-kernel@vger.kernel.org>
CC: Greg Kroah-Hartman <greg@kroah.com>, Al Viro <viro@ftp.linux.org.uk>,
       <jgarzik@pobox.com>, David Miller <davem@davemloft.net>,
       David Howells <dhowells@redhat.com>, <miles@gnu.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Mon, 18 Feb 2008 14:35:41 +1100
Subject: [RFC/PATCH] iomap: Add specific address space __iomap for iomap pointers
Message-Id: <20080218033600.A9761DDE35@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current iomap stuff (pci_iomap, ioport_map, pcim_iomap, ...) is
confusing as it returns pointers in the _miomem address space.

However, even if that would work on some architectures, the result
of those functions is -not- to be used as an __iomem, with accessors
such as readl/writel, but only with the new brand of specific accessors
(ioread32/iowrite32/...).

This causes confusion, there have been bugs in the past due to that,
and this is just wrong, so this is an attempt at fixing it by introducing
a new address space __iomap for the iomap stuff.

This patch adds the annotation and changes the generic and arch code
that returns these pointers. I have -not- yet started looking at drivers
and fixing them (that will be the hard part) and I may well have missed
or even borked things, as this stage, I'm looking for feedback on the
approach and for the affected arch maintainers to have a quick look in
case I missed something in their code.

_THIS_ _IS_ _UNTESTED_ (just so that you know !)

Note that incorrect address space annotations will not break build,
though they will spew warnings in sparse. So it is doable to get a
patch such as this one in, and -then- fix the drivers, though it would
be best to have as much conversion as possible done at once still.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

 arch/frv/mb93090-mb00/pci-iomap.c |    4 -
 arch/powerpc/kernel/iomap.c       |   69 ++++++++++++++++--------------
 arch/sparc/lib/iomap.c            |   14 +++---
 arch/sparc64/lib/iomap.c          |   12 ++---
 arch/v850/kernel/rte_mb_a_pci.c   |    4 -
 include/asm-arm/io.h              |    8 +--
 include/asm-frv/io.h              |   16 +++---
 include/asm-generic/iomap.h       |   44 +++++++++----------
 include/asm-mn10300/io.h          |   24 +++++-----
 include/asm-ppc/io.h              |   58 +++++++++++++------------
 include/asm-sparc/io.h            |   32 ++++++-------
 include/asm-sparc64/io.h          |   20 ++++----
 include/asm-v850/io.h             |   12 ++---
 include/asm-v850/pci.h            |    4 -
 include/linux/compiler.h          |    2 
 include/linux/pci.h               |    6 +-
 lib/devres.c                      |   26 +++++------
 lib/iomap.c                       |   87 +++++++++++++++++++-------------------
 18 files changed, 226 insertions(+), 216 deletions(-)

--- linux-work.orig/include/linux/compiler.h	2008-02-18 13:31:00.000000000 +1100
+++ linux-work/include/linux/compiler.h	2008-02-18 13:31:50.000000000 +1100
@@ -10,6 +10,7 @@
 # define __force	__attribute__((force))
 # define __nocast	__attribute__((nocast))
 # define __iomem	__attribute__((noderef, address_space(2)))
+# define __iomap	__attribute__((noderef, address_space(4)))
 # define __acquires(x)	__attribute__((context(x,0,1)))
 # define __releases(x)	__attribute__((context(x,1,0)))
 # define __acquire(x)	__context__(x,1)
@@ -24,6 +25,7 @@ extern void __chk_io_ptr(const volatile 
 # define __force
 # define __nocast
 # define __iomem
+# define __iomap
 # define __chk_user_ptr(x) (void)0
 # define __chk_io_ptr(x) (void)0
 # define __builtin_warning(x, y...) (1)
Index: linux-work/lib/iomap.c
===================================================================
--- linux-work.orig/lib/iomap.c	2008-02-18 13:33:23.000000000 +1100
+++ linux-work/lib/iomap.c	2008-02-18 13:46:43.000000000 +1100
@@ -50,6 +50,7 @@ static void bad_io_access(unsigned long 
  */
 #define IO_COND(addr, is_pio, is_mmio) do {			\
 	unsigned long port = (unsigned long __force)addr;	\
+	void __iomem *mem = (void __iomem __force *)addr;	\
 	if (port >= PIO_RESERVED) {				\
 		is_mmio;					\
 	} else if (port > PIO_OFFSET) {				\
@@ -69,29 +70,29 @@ static void bad_io_access(unsigned long 
 #define mmio_read32be(addr) be32_to_cpu(__raw_readl(addr))
 #endif
 
-unsigned int ioread8(void __iomem *addr)
+unsigned int ioread8(void __iomap *addr)
 {
-	IO_COND(addr, return inb(port), return readb(addr));
+	IO_COND(addr, return inb(port), return readb(mem));
 	return 0xff;
 }
-unsigned int ioread16(void __iomem *addr)
+unsigned int ioread16(void __iomap *addr)
 {
-	IO_COND(addr, return inw(port), return readw(addr));
+	IO_COND(addr, return inw(port), return readw(mem));
 	return 0xffff;
 }
-unsigned int ioread16be(void __iomem *addr)
+unsigned int ioread16be(void __iomap *addr)
 {
-	IO_COND(addr, return pio_read16be(port), return mmio_read16be(addr));
+	IO_COND(addr, return pio_read16be(port), return mmio_read16be(mem));
 	return 0xffff;
 }
-unsigned int ioread32(void __iomem *addr)
+unsigned int ioread32(void __iomap *addr)
 {
-	IO_COND(addr, return inl(port), return readl(addr));
+	IO_COND(addr, return inl(port), return readl(mem));
 	return 0xffffffff;
 }
-unsigned int ioread32be(void __iomem *addr)
+unsigned int ioread32be(void __iomap *addr)
 {
-	IO_COND(addr, return pio_read32be(port), return mmio_read32be(addr));
+	IO_COND(addr, return pio_read32be(port), return mmio_read32be(mem));
 	return 0xffffffff;
 }
 EXPORT_SYMBOL(ioread8);
@@ -106,29 +107,29 @@ EXPORT_SYMBOL(ioread32be);
 #endif
 
 #ifndef mmio_write16be
-#define mmio_write16be(val,port) __raw_writew(be16_to_cpu(val),port)
-#define mmio_write32be(val,port) __raw_writel(be32_to_cpu(val),port)
+#define mmio_write16be(val,mem) __raw_writew(be16_to_cpu(val),mem)
+#define mmio_write32be(val,mem) __raw_writel(be32_to_cpu(val),mem)
 #endif
 
-void iowrite8(u8 val, void __iomem *addr)
+void iowrite8(u8 val, void __iomap *addr)
 {
-	IO_COND(addr, outb(val,port), writeb(val, addr));
+	IO_COND(addr, outb(val,port), writeb(val, mem));
 }
-void iowrite16(u16 val, void __iomem *addr)
+void iowrite16(u16 val, void __iomap *addr)
 {
-	IO_COND(addr, outw(val,port), writew(val, addr));
+	IO_COND(addr, outw(val,port), writew(val, mem));
 }
-void iowrite16be(u16 val, void __iomem *addr)
+void iowrite16be(u16 val, void __iomap *addr)
 {
-	IO_COND(addr, pio_write16be(val,port), mmio_write16be(val, addr));
+	IO_COND(addr, pio_write16be(val,port), mmio_write16be(val, mem));
 }
-void iowrite32(u32 val, void __iomem *addr)
+void iowrite32(u32 val, void __iomap *addr)
 {
-	IO_COND(addr, outl(val,port), writel(val, addr));
+	IO_COND(addr, outl(val,port), writel(val, mem));
 }
-void iowrite32be(u32 val, void __iomem *addr)
+void iowrite32be(u32 val, void __iomap *addr)
 {
-	IO_COND(addr, pio_write32be(val,port), mmio_write32be(val, addr));
+	IO_COND(addr, pio_write32be(val,port), mmio_write32be(val, mem));
 }
 EXPORT_SYMBOL(iowrite8);
 EXPORT_SYMBOL(iowrite16);
@@ -193,47 +194,47 @@ static inline void mmio_outsl(void __iom
 }
 #endif
 
-void ioread8_rep(void __iomem *addr, void *dst, unsigned long count)
+void ioread8_rep(void __iomap *addr, void *dst, unsigned long count)
 {
-	IO_COND(addr, insb(port,dst,count), mmio_insb(addr, dst, count));
+	IO_COND(addr, insb(port,dst,count), mmio_insb(mem, dst, count));
 }
-void ioread16_rep(void __iomem *addr, void *dst, unsigned long count)
+void ioread16_rep(void __iomap *addr, void *dst, unsigned long count)
 {
-	IO_COND(addr, insw(port,dst,count), mmio_insw(addr, dst, count));
+	IO_COND(addr, insw(port,dst,count), mmio_insw(mem, dst, count));
 }
-void ioread32_rep(void __iomem *addr, void *dst, unsigned long count)
+void ioread32_rep(void __iomap *addr, void *dst, unsigned long count)
 {
-	IO_COND(addr, insl(port,dst,count), mmio_insl(addr, dst, count));
+	IO_COND(addr, insl(port,dst,count), mmio_insl(mem, dst, count));
 }
 EXPORT_SYMBOL(ioread8_rep);
 EXPORT_SYMBOL(ioread16_rep);
 EXPORT_SYMBOL(ioread32_rep);
 
-void iowrite8_rep(void __iomem *addr, const void *src, unsigned long count)
+void iowrite8_rep(void __iomap *addr, const void *src, unsigned long count)
 {
-	IO_COND(addr, outsb(port, src, count), mmio_outsb(addr, src, count));
+	IO_COND(addr, outsb(port, src, count), mmio_outsb(mem, src, count));
 }
-void iowrite16_rep(void __iomem *addr, const void *src, unsigned long count)
+void iowrite16_rep(void __iomap *addr, const void *src, unsigned long count)
 {
-	IO_COND(addr, outsw(port, src, count), mmio_outsw(addr, src, count));
+	IO_COND(addr, outsw(port, src, count), mmio_outsw(mem, src, count));
 }
-void iowrite32_rep(void __iomem *addr, const void *src, unsigned long count)
+void iowrite32_rep(void __iomap *addr, const void *src, unsigned long count)
 {
-	IO_COND(addr, outsl(port, src,count), mmio_outsl(addr, src, count));
+	IO_COND(addr, outsl(port, src,count), mmio_outsl(mem, src, count));
 }
 EXPORT_SYMBOL(iowrite8_rep);
 EXPORT_SYMBOL(iowrite16_rep);
 EXPORT_SYMBOL(iowrite32_rep);
 
 /* Create a virtual mapping cookie for an IO port range */
-void __iomem *ioport_map(unsigned long port, unsigned int nr)
+void __iomap *ioport_map(unsigned long port, unsigned int nr)
 {
 	if (port > PIO_MASK)
 		return NULL;
-	return (void __iomem *) (unsigned long) (port + PIO_OFFSET);
+	return (void __iomap *) (unsigned long) (port + PIO_OFFSET);
 }
 
-void ioport_unmap(void __iomem *addr)
+void ioport_unmap(void __iomap *addr)
 {
 	/* Nothing to do */
 }
@@ -246,7 +247,7 @@ EXPORT_SYMBOL(ioport_unmap);
  * @bar: BAR number
  * @maxlen: length of the memory to map
  *
- * Using this function you will get a __iomem address to your device BAR.
+ * Using this function you will get a __iomap address to your device BAR.
  * You can access it using ioread*() and iowrite*(). These functions hide
  * the details if this is a MMIO or PIO address space and will just do what
  * you expect from them in the correct way.
@@ -254,7 +255,7 @@ EXPORT_SYMBOL(ioport_unmap);
  * @maxlen specifies the maximum length to map. If you want to get access to
  * the complete BAR without checking for its length first, pass %0 here.
  * */
-void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
+void __iomap *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
 {
 	unsigned long start = pci_resource_start(dev, bar);
 	unsigned long len = pci_resource_len(dev, bar);
@@ -268,16 +269,16 @@ void __iomem *pci_iomap(struct pci_dev *
 		return ioport_map(start, len);
 	if (flags & IORESOURCE_MEM) {
 		if (flags & IORESOURCE_CACHEABLE)
-			return ioremap(start, len);
-		return ioremap_nocache(start, len);
+			return (void __iomap __force *)ioremap(start, len);
+		return (void __iomap __force *)ioremap_nocache(start, len);
 	}
 	/* What? */
 	return NULL;
 }
 
-void pci_iounmap(struct pci_dev *dev, void __iomem * addr)
+void pci_iounmap(struct pci_dev *dev, void __iomap * addr)
 {
-	IO_COND(addr, /* nothing */, iounmap(addr));
+	IO_COND(addr, /* nothing */, iounmap((void __iomem __force *)addr));
 }
 EXPORT_SYMBOL(pci_iomap);
 EXPORT_SYMBOL(pci_iounmap);
Index: linux-work/arch/powerpc/kernel/iomap.c
===================================================================
--- linux-work.orig/arch/powerpc/kernel/iomap.c	2008-02-18 13:40:52.000000000 +1100
+++ linux-work/arch/powerpc/kernel/iomap.c	2008-02-18 13:47:32.000000000 +1100
@@ -13,25 +13,28 @@
  * Here comes the ppc64 implementation of the IOMAP 
  * interfaces.
  */
-unsigned int ioread8(void __iomem *addr)
+
+#define IOMAP_TO_IOMEM(addr)	((void __iomem __force *)(addr))
+
+unsigned int ioread8(void __iomap *addr)
 {
-	return readb(addr);
+	return readb(IOMAP_TO_IOMEM(addr));
 }
-unsigned int ioread16(void __iomem *addr)
+unsigned int ioread16(void __iomap *addr)
 {
-	return readw(addr);
+	return readw(IOMAP_TO_IOMEM(addr));
 }
-unsigned int ioread16be(void __iomem *addr)
+unsigned int ioread16be(void __iomap *addr)
 {
-	return in_be16(addr);
+	return in_be16(IOMAP_TO_IOMEM(addr));
 }
-unsigned int ioread32(void __iomem *addr)
+unsigned int ioread32(void __iomap *addr)
 {
-	return readl(addr);
+	return readl(IOMAP_TO_IOMEM(addr));
 }
-unsigned int ioread32be(void __iomem *addr)
+unsigned int ioread32be(void __iomap *addr)
 {
-	return in_be32(addr);
+	return in_be32(IOMAP_TO_IOMEM(addr));
 }
 EXPORT_SYMBOL(ioread8);
 EXPORT_SYMBOL(ioread16);
@@ -41,23 +44,23 @@ EXPORT_SYMBOL(ioread32be);
 
 void iowrite8(u8 val, void __iomem *addr)
 {
-	writeb(val, addr);
+	writeb(val, IOMAP_TO_IOMEM(addr));
 }
 void iowrite16(u16 val, void __iomem *addr)
 {
-	writew(val, addr);
+	writew(val, IOMAP_TO_IOMEM(addr));
 }
 void iowrite16be(u16 val, void __iomem *addr)
 {
-	out_be16(addr, val);
+	out_be16(IOMAP_TO_IOMEM(addr), val);
 }
 void iowrite32(u32 val, void __iomem *addr)
 {
-	writel(val, addr);
+	writel(val, IOMAP_TO_IOMEM(addr));
 }
 void iowrite32be(u32 val, void __iomem *addr)
 {
-	out_be32(addr, val);
+	out_be32(IOMAP_TO_IOMEM(addr), val);
 }
 EXPORT_SYMBOL(iowrite8);
 EXPORT_SYMBOL(iowrite16);
@@ -73,33 +76,33 @@ EXPORT_SYMBOL(iowrite32be);
  * FIXME! We could make these do EEH handling if we really
  * wanted. Not clear if we do.
  */
-void ioread8_rep(void __iomem *addr, void *dst, unsigned long count)
+void ioread8_rep(void __iomap *addr, void *dst, unsigned long count)
 {
-	_insb((u8 __iomem *) addr, dst, count);
+	_insb((u8 __iomem __force *) addr, dst, count);
 }
-void ioread16_rep(void __iomem *addr, void *dst, unsigned long count)
+void ioread16_rep(void __iomap *addr, void *dst, unsigned long count)
 {
-	_insw_ns((u16 __iomem *) addr, dst, count);
+	_insw_ns((u16 __iomem __force *) addr, dst, count);
 }
-void ioread32_rep(void __iomem *addr, void *dst, unsigned long count)
+void ioread32_rep(void __iomap *addr, void *dst, unsigned long count)
 {
-	_insl_ns((u32 __iomem *) addr, dst, count);
+	_insl_ns((u32 __iomem __force *) addr, dst, count);
 }
 EXPORT_SYMBOL(ioread8_rep);
 EXPORT_SYMBOL(ioread16_rep);
 EXPORT_SYMBOL(ioread32_rep);
 
-void iowrite8_rep(void __iomem *addr, const void *src, unsigned long count)
+void iowrite8_rep(void __iomap *addr, const void *src, unsigned long count)
 {
-	_outsb((u8 __iomem *) addr, src, count);
+	_outsb((u8 __iomem __force *) addr, src, count);
 }
-void iowrite16_rep(void __iomem *addr, const void *src, unsigned long count)
+void iowrite16_rep(void __iomap *addr, const void *src, unsigned long count)
 {
-	_outsw_ns((u16 __iomem *) addr, src, count);
+	_outsw_ns((u16 __iomem __force *) addr, src, count);
 }
-void iowrite32_rep(void __iomem *addr, const void *src, unsigned long count)
+void iowrite32_rep(void __iomap *addr, const void *src, unsigned long count)
 {
-	_outsl_ns((u32 __iomem *) addr, src, count);
+	_outsl_ns((u32 __iomem __force *) addr, src, count);
 }
 EXPORT_SYMBOL(iowrite8_rep);
 EXPORT_SYMBOL(iowrite16_rep);
@@ -117,7 +120,7 @@ void ioport_unmap(void __iomem *addr)
 EXPORT_SYMBOL(ioport_map);
 EXPORT_SYMBOL(ioport_unmap);
 
-void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max)
+void __iomap *pci_iomap(struct pci_dev *dev, int bar, unsigned long max)
 {
 	resource_size_t start = pci_resource_start(dev, bar);
 	resource_size_t len = pci_resource_len(dev, bar);
@@ -130,18 +133,20 @@ void __iomem *pci_iomap(struct pci_dev *
 	if (flags & IORESOURCE_IO)
 		return ioport_map(start, len);
 	if (flags & IORESOURCE_MEM)
-		return ioremap(start, len);
+		return (void __iomap __force *)ioremap(start, len);
 	/* What? */
 	return NULL;
 }
 
 void pci_iounmap(struct pci_dev *dev, void __iomem *addr)
 {
-	if (isa_vaddr_is_ioport(addr))
+	void __iomem *vaddr = (void __iomem __force *)addr;
+
+	if (isa_vaddr_is_ioport(vaddr))
 		return;
-	if (pcibios_vaddr_is_ioport(addr))
+	if (pcibios_vaddr_is_ioport(vaddr))
 		return;
-	iounmap(addr);
+	iounmap(vaddr);
 }
 
 EXPORT_SYMBOL(pci_iomap);
Index: linux-work/arch/frv/mb93090-mb00/pci-iomap.c
===================================================================
--- linux-work.orig/arch/frv/mb93090-mb00/pci-iomap.c	2008-02-18 14:07:50.000000000 +1100
+++ linux-work/arch/frv/mb93090-mb00/pci-iomap.c	2008-02-18 14:07:58.000000000 +1100
@@ -11,7 +11,7 @@
 #include <linux/pci.h>
 #include <linux/module.h>
 
-void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
+void __iomap *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
 {
 	unsigned long start = pci_resource_start(dev, bar);
 	unsigned long len = pci_resource_len(dev, bar);
@@ -21,7 +21,7 @@ void __iomem *pci_iomap(struct pci_dev *
 		return NULL;
 
 	if ((flags & IORESOURCE_IO) || (flags & IORESOURCE_MEM))
-		return (void __iomem *) start;
+		return (void __iomap *) start;
 
 	return NULL;
 }
Index: linux-work/arch/sparc/lib/iomap.c
===================================================================
--- linux-work.orig/arch/sparc/lib/iomap.c	2008-02-18 14:15:54.000000000 +1100
+++ linux-work/arch/sparc/lib/iomap.c	2008-02-18 14:16:33.000000000 +1100
@@ -6,12 +6,12 @@
 #include <asm/io.h>
 
 /* Create a virtual mapping cookie for an IO port range */
-void __iomem *ioport_map(unsigned long port, unsigned int nr)
+void __iomap *ioport_map(unsigned long port, unsigned int nr)
 {
-	return (void __iomem *) (unsigned long) port;
+	return (void __iomap *) (unsigned long) port;
 }
 
-void ioport_unmap(void __iomem *addr)
+void ioport_unmap(void __iomap *addr)
 {
 	/* Nothing to do */
 }
@@ -19,7 +19,7 @@ EXPORT_SYMBOL(ioport_map);
 EXPORT_SYMBOL(ioport_unmap);
 
 /* Create a virtual mapping cookie for a PCI BAR (memory or IO) */
-void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
+void __iomap *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
 {
 	unsigned long start = pci_resource_start(dev, bar);
 	unsigned long len = pci_resource_len(dev, bar);
@@ -33,14 +33,14 @@ void __iomem *pci_iomap(struct pci_dev *
 		return ioport_map(start, len);
 	if (flags & IORESOURCE_MEM) {
 		if (flags & IORESOURCE_CACHEABLE)
-			return ioremap(start, len);
-		return ioremap_nocache(start, len);
+			return (void __iomap __force *)ioremap(start, len);
+		return (void __iomap __force *)ioremap_nocache(start, len);
 	}
 	/* What? */
 	return NULL;
 }
 
-void pci_iounmap(struct pci_dev *dev, void __iomem * addr)
+void pci_iounmap(struct pci_dev *dev, void __iomap * addr)
 {
 	/* nothing to do */
 }
Index: linux-work/arch/sparc64/lib/iomap.c
===================================================================
--- linux-work.orig/arch/sparc64/lib/iomap.c	2008-02-18 14:16:50.000000000 +1100
+++ linux-work/arch/sparc64/lib/iomap.c	2008-02-18 14:17:13.000000000 +1100
@@ -6,12 +6,12 @@
 #include <asm/io.h>
 
 /* Create a virtual mapping cookie for an IO port range */
-void __iomem *ioport_map(unsigned long port, unsigned int nr)
+void __iomap *ioport_map(unsigned long port, unsigned int nr)
 {
 	return (void __iomem *) (unsigned long) port;
 }
 
-void ioport_unmap(void __iomem *addr)
+void ioport_unmap(void __iomap *addr)
 {
 	/* Nothing to do */
 }
@@ -19,7 +19,7 @@ EXPORT_SYMBOL(ioport_map);
 EXPORT_SYMBOL(ioport_unmap);
 
 /* Create a virtual mapping cookie for a PCI BAR (memory or IO) */
-void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
+void __iomap *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
 {
 	unsigned long start = pci_resource_start(dev, bar);
 	unsigned long len = pci_resource_len(dev, bar);
@@ -33,14 +33,14 @@ void __iomem *pci_iomap(struct pci_dev *
 		return ioport_map(start, len);
 	if (flags & IORESOURCE_MEM) {
 		if (flags & IORESOURCE_CACHEABLE)
-			return ioremap(start, len);
-		return ioremap_nocache(start, len);
+			return (void __iomap __force *)ioremap(start, len);
+		return (void __iomap __force *)ioremap_nocache(start, len);
 	}
 	/* What? */
 	return NULL;
 }
 
-void pci_iounmap(struct pci_dev *dev, void __iomem * addr)
+void pci_iounmap(struct pci_dev *dev, void __iomap * addr)
 {
 	/* nothing to do */
 }
Index: linux-work/arch/v850/kernel/rte_mb_a_pci.c
===================================================================
--- linux-work.orig/arch/v850/kernel/rte_mb_a_pci.c	2008-02-18 14:19:39.000000000 +1100
+++ linux-work/arch/v850/kernel/rte_mb_a_pci.c	2008-02-18 14:19:46.000000000 +1100
@@ -788,7 +788,7 @@ pci_free_consistent (struct pci_dev *pde
 
 /* iomap/iomap */
 
-void __iomem *pci_iomap (struct pci_dev *dev, int bar, unsigned long max)
+void __iomap *pci_iomap (struct pci_dev *dev, int bar, unsigned long max)
 {
 	unsigned long start = pci_resource_start (dev, bar);
 	unsigned long len = pci_resource_len (dev, bar);
@@ -801,7 +801,7 @@ void __iomem *pci_iomap (struct pci_dev 
 	return ioremap (start, len);
 }
 
-void pci_iounmap (struct pci_dev *dev, void __iomem *addr)
+void pci_iounmap (struct pci_dev *dev, void __iomap *addr)
 {
 	/* nothing */
 }
Index: linux-work/include/asm-arm/io.h
===================================================================
--- linux-work.orig/include/asm-arm/io.h	2008-02-18 13:48:26.000000000 +1100
+++ linux-work/include/asm-arm/io.h	2008-02-18 14:05:33.000000000 +1100
@@ -243,14 +243,14 @@ extern void _memset_io(volatile void __i
 #define iowrite16_rep(p,s,c)	__raw_writesw(p,s,c)
 #define iowrite32_rep(p,s,c)	__raw_writesl(p,s,c)
 
-extern void __iomem *ioport_map(unsigned long port, unsigned int nr);
-extern void ioport_unmap(void __iomem *addr);
+extern void __iomap *ioport_map(unsigned long port, unsigned int nr);
+extern void ioport_unmap(void __iomap *addr);
 #endif
 
 struct pci_dev;
 
-extern void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen);
-extern void pci_iounmap(struct pci_dev *dev, void __iomem *addr);
+extern void __iomao *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen);
+extern void pci_iounmap(struct pci_dev *dev, void __iomap *addr);
 
 /*
  * can the hardware map this into one segment or not, given no other
Index: linux-work/include/asm-frv/io.h
===================================================================
--- linux-work.orig/include/asm-frv/io.h	2008-02-18 14:06:49.000000000 +1100
+++ linux-work/include/asm-frv/io.h	2008-02-18 14:07:15.000000000 +1100
@@ -290,12 +290,12 @@ static inline void flush_write_buffers(v
 /*
  * do appropriate I/O accesses for token type
  */
-static inline unsigned int ioread8(void __iomem *p)
+static inline unsigned int ioread8(void __iomap *p)
 {
 	return __builtin_read8(p);
 }
 
-static inline unsigned int ioread16(void __iomem *p)
+static inline unsigned int ioread16(void __iomap *p)
 {
 	uint16_t ret = __builtin_read16(p);
 	if (__is_PCI_addr(p))
@@ -303,7 +303,7 @@ static inline unsigned int ioread16(void
 	return ret;
 }
 
-static inline unsigned int ioread32(void __iomem *p)
+static inline unsigned int ioread32(void __iomap *p)
 {
 	uint32_t ret = __builtin_read32(p);
 	if (__is_PCI_addr(p))
@@ -311,14 +311,14 @@ static inline unsigned int ioread32(void
 	return ret;
 }
 
-static inline void iowrite8(u8 val, void __iomem *p)
+static inline void iowrite8(u8 val, void __iomap *p)
 {
 	__builtin_write8(p, val);
 	if (__is_PCI_MEM(p))
 		__flush_PCI_writes();
 }
 
-static inline void iowrite16(u16 val, void __iomem *p)
+static inline void iowrite16(u16 val, void __iomap *p)
 {
 	if (__is_PCI_addr(p))
 		val = _swapw(val);
@@ -327,7 +327,7 @@ static inline void iowrite16(u16 val, vo
 		__flush_PCI_writes();
 }
 
-static inline void iowrite32(u32 val, void __iomem *p)
+static inline void iowrite32(u32 val, void __iomap *p)
 {
 	if (__is_PCI_addr(p))
 		val = _swapl(val);
@@ -368,8 +368,8 @@ static inline void iowrite32_rep(void __
 
 /* Create a virtual mapping cookie for a PCI BAR (memory or IO) */
 struct pci_dev;
-extern void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max);
-static inline void pci_iounmap(struct pci_dev *dev, void __iomem *p)
+extern void __iomap *pci_iomap(struct pci_dev *dev, int bar, unsigned long max);
+static inline void pci_iounmap(struct pci_dev *dev, void __iomap *p)
 {
 }
 
Index: linux-work/include/asm-generic/iomap.h
===================================================================
--- linux-work.orig/include/asm-generic/iomap.h	2008-02-18 14:08:39.000000000 +1100
+++ linux-work/include/asm-generic/iomap.h	2008-02-18 14:09:20.000000000 +1100
@@ -25,17 +25,17 @@
  * in the low address range. Architectures for which this is not
  * true can't use this generic implementation.
  */
-extern unsigned int ioread8(void __iomem *);
-extern unsigned int ioread16(void __iomem *);
-extern unsigned int ioread16be(void __iomem *);
-extern unsigned int ioread32(void __iomem *);
-extern unsigned int ioread32be(void __iomem *);
-
-extern void iowrite8(u8, void __iomem *);
-extern void iowrite16(u16, void __iomem *);
-extern void iowrite16be(u16, void __iomem *);
-extern void iowrite32(u32, void __iomem *);
-extern void iowrite32be(u32, void __iomem *);
+extern unsigned int ioread8(void __iomap *);
+extern unsigned int ioread16(void __iomap *);
+extern unsigned int ioread16be(void __iomap *);
+extern unsigned int ioread32(void __iomap *);
+extern unsigned int ioread32be(void __iomap *);
+
+extern void iowrite8(u8, void __iomap *);
+extern void iowrite16(u16, void __iomap *);
+extern void iowrite16be(u16, void __iomap *);
+extern void iowrite32(u32, void __iomap *);
+extern void iowrite32be(u32, void __iomap *);
 
 /*
  * "string" versions of the above. Note that they
@@ -48,21 +48,21 @@ extern void iowrite32be(u32, void __iome
  * memory across multiple ports, use "memcpy_toio()"
  * and friends.
  */
-extern void ioread8_rep(void __iomem *port, void *buf, unsigned long count);
-extern void ioread16_rep(void __iomem *port, void *buf, unsigned long count);
-extern void ioread32_rep(void __iomem *port, void *buf, unsigned long count);
-
-extern void iowrite8_rep(void __iomem *port, const void *buf, unsigned long count);
-extern void iowrite16_rep(void __iomem *port, const void *buf, unsigned long count);
-extern void iowrite32_rep(void __iomem *port, const void *buf, unsigned long count);
+extern void ioread8_rep(void __iomap *port, void *buf, unsigned long count);
+extern void ioread16_rep(void __iomap *port, void *buf, unsigned long count);
+extern void ioread32_rep(void __iomap *port, void *buf, unsigned long count);
+
+extern void iowrite8_rep(void __iomap *port, const void *buf, unsigned long count);
+extern void iowrite16_rep(void __iomap *port, const void *buf, unsigned long count);
+extern void iowrite32_rep(void __iomap *port, const void *buf, unsigned long count);
 
 /* Create a virtual mapping cookie for an IO port range */
-extern void __iomem *ioport_map(unsigned long port, unsigned int nr);
-extern void ioport_unmap(void __iomem *);
+extern void __iomap *ioport_map(unsigned long port, unsigned int nr);
+extern void ioport_unmap(void __iomap *);
 
 /* Create a virtual mapping cookie for a PCI BAR (memory or IO) */
 struct pci_dev;
-extern void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max);
-extern void pci_iounmap(struct pci_dev *dev, void __iomem *);
+extern void __iomap *pci_iomap(struct pci_dev *dev, int bar, unsigned long max);
+extern void pci_iounmap(struct pci_dev *dev, void __iomap *);
 
 #endif
Index: linux-work/include/asm-mn10300/io.h
===================================================================
--- linux-work.orig/include/asm-mn10300/io.h	2008-02-18 14:20:40.000000000 +1100
+++ linux-work/include/asm-mn10300/io.h	2008-02-18 14:21:39.000000000 +1100
@@ -184,13 +184,13 @@ static inline void outsl(unsigned long a
 	}
 }
 
-#define ioread8(addr)		readb(addr)
-#define ioread16(addr)		readw(addr)
-#define ioread32(addr)		readl(addr)
-
-#define iowrite8(v, addr)	writeb((v), (addr))
-#define iowrite16(v, addr)	writew((v), (addr))
-#define iowrite32(v, addr)	writel((v), (addr))
+#define ioread8(addr)		readb((void __iomem __force *)(addr))
+#define ioread16(addr)		readw((void __iomem __force *)(addr))
+#define ioread32(addr)		readl((void __iomem __force *)(addr))
+
+#define iowrite8(v, addr)	writeb((v), (void __iomem __force *)(addr))
+#define iowrite16(v, addr)	writew((v), (void __iomem __force *)(addr))
+#define iowrite32(v, addr)	writel((v), (void __iomem __force *)(addr))
 
 #define ioread8_rep(p, dst, count) \
 	insb((unsigned long) (p), (dst), (count))
@@ -216,8 +216,8 @@ static inline void outsl(unsigned long a
 
 /* Create a virtual mapping cookie for a PCI BAR (memory or IO) */
 struct pci_dev;
-extern void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max);
-static inline void pci_iounmap(struct pci_dev *dev, void __iomem *p)
+extern void __iomap *pci_iomap(struct pci_dev *dev, int bar, unsigned long max);
+static inline void pci_iounmap(struct pci_dev *dev, void __iomap *p)
 {
 }
 
@@ -263,12 +263,12 @@ static inline void iounmap(void *addr)
 {
 }
 
-static inline void __iomem *ioport_map(unsigned long port, unsigned int nr)
+static inline void __iomap *ioport_map(unsigned long port, unsigned int nr)
 {
-	return (void __iomem *) port;
+	return (void __iomap *) port;
 }
 
-static inline void ioport_unmap(void __iomem *p)
+static inline void ioport_unmap(void __iomap *p)
 {
 }
 
Index: linux-work/include/asm-ppc/io.h
===================================================================
--- linux-work.orig/include/asm-ppc/io.h	2008-02-18 14:09:46.000000000 +1100
+++ linux-work/include/asm-ppc/io.h	2008-02-18 14:11:51.000000000 +1100
@@ -403,74 +403,76 @@ extern inline void * phys_to_virt(unsign
  * Here comes the ppc implementation of the IOMAP 
  * interfaces.
  */
-static inline unsigned int ioread8(void __iomem *addr)
+#define IOMAP_TO_IOMEM(addr)	((void __iomem __force *)(addr))
+
+static inline unsigned int ioread8(void __iomap *addr)
 {
-	return readb(addr);
+	return readb(IOMAP_TO_IOMEM(addr));
 }
 
-static inline unsigned int ioread16(void __iomem *addr)
+static inline unsigned int ioread16(void __iomap *addr)
 {
-	return readw(addr);
+	return readw(IOMAP_TO_IOMEM(addr));
 }
 
-static inline unsigned int ioread32(void __iomem *addr)
+static inline unsigned int ioread32(void __iomap *addr)
 {
-	return readl(addr);
+	return readl(IOMAP_TO_IOMEM(addr));
 }
 
-static inline void iowrite8(u8 val, void __iomem *addr)
+static inline void iowrite8(u8 val, void __iomap *addr)
 {
-	writeb(val, addr);
+	writeb(val, IOMAP_TO_IOMEM(addr));
 }
 
-static inline void iowrite16(u16 val, void __iomem *addr)
+static inline void iowrite16(u16 val, void __iomap *addr)
 {
-	writew(val, addr);
+	writew(val, IOMAP_TO_IOMEM(addr));
 }
 
-static inline void iowrite32(u32 val, void __iomem *addr)
+static inline void iowrite32(u32 val, void __iomap *addr)
 {
-	writel(val, addr);
+	writel(val, IOMAP_TO_IOMEM(addr));
 }
 
-static inline void ioread8_rep(void __iomem *addr, void *dst, unsigned long count)
+static inline void ioread8_rep(void __iomap *addr, void *dst, unsigned long count)
 {
-	_insb(addr, dst, count);
+	_insb(IOMAP_TO_IOMEM(addr), dst, count);
 }
 
-static inline void ioread16_rep(void __iomem *addr, void *dst, unsigned long count)
+static inline void ioread16_rep(void __iomap *addr, void *dst, unsigned long count)
 {
-	_insw_ns(addr, dst, count);
+	_insw_ns(IOMAP_TO_IOMEM(addr), dst, count);
 }
 
-static inline void ioread32_rep(void __iomem *addr, void *dst, unsigned long count)
+static inline void ioread32_rep(void __iomap *addr, void *dst, unsigned long count)
 {
-	_insl_ns(addr, dst, count);
+	_insl_ns(IOMAP_TO_IOMEM(addr), dst, count);
 }
 
-static inline void iowrite8_rep(void __iomem *addr, const void *src, unsigned long count)
+static inline void iowrite8_rep(void __iomap *addr, const void *src, unsigned long count)
 {
-	_outsb(addr, src, count);
+	_outsb(IOMAP_TO_IOMEM(addr), src, count);
 }
 
-static inline void iowrite16_rep(void __iomem *addr, const void *src, unsigned long count)
+static inline void iowrite16_rep(void __iomap *addr, const void *src, unsigned long count)
 {
-	_outsw_ns(addr, src, count);
+	_outsw_ns(IOMAP_TO_IOMEM(addr), src, count);
 }
 
-static inline void iowrite32_rep(void __iomem *addr, const void *src, unsigned long count)
+static inline void iowrite32_rep(void __iomap *addr, const void *src, unsigned long count)
 {
-	_outsl_ns(addr, src, count);
+	_outsl_ns(IOMAP_TO_IOMEM(addr), src, count);
 }
 
 /* Create a virtual mapping cookie for an IO port range */
-extern void __iomem *ioport_map(unsigned long port, unsigned int nr);
-extern void ioport_unmap(void __iomem *);
+extern void __iomap *ioport_map(unsigned long port, unsigned int nr);
+extern void ioport_unmap(void __iomap *);
 
 /* Create a virtual mapping cookie for a PCI BAR (memory or IO) */
 struct pci_dev;
-extern void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max);
-extern void pci_iounmap(struct pci_dev *dev, void __iomem *);
+extern void __iomap *pci_iomap(struct pci_dev *dev, int bar, unsigned long max);
+extern void pci_iounmap(struct pci_dev *dev, void __iomap *);
 
 #endif /* _PPC_IO_H */
 
Index: linux-work/include/asm-sparc/io.h
===================================================================
--- linux-work.orig/include/asm-sparc/io.h	2008-02-18 14:13:13.000000000 +1100
+++ linux-work/include/asm-sparc/io.h	2008-02-18 14:14:15.000000000 +1100
@@ -249,50 +249,50 @@ extern void __iomem *ioremap(unsigned lo
 #define ioremap_nocache(X,Y)	ioremap((X),(Y))
 extern void iounmap(volatile void __iomem *addr);
 
-#define ioread8(X)			readb(X)
-#define ioread16(X)			readw(X)
-#define ioread32(X)			readl(X)
-#define iowrite8(val,X)			writeb(val,X)
-#define iowrite16(val,X)		writew(val,X)
-#define iowrite32(val,X)		writel(val,X)
+#define ioread8(X)			readb((void __iomem __force *)(X))
+#define ioread16(X)			readw((void __iomem __force *)(X))
+#define ioread32(X)			readl((void __iomem __force *)(X))
+#define iowrite8(val,X)			writeb(val,(void __iomem __force *)(X))
+#define iowrite16(val,X)		writew(val,(void __iomem __force *)(X))
+#define iowrite32(val,X)		writel(val,(void __iomem __force *)(X))
 
-static inline void ioread8_rep(void __iomem *port, void *buf, unsigned long count)
+static inline void ioread8_rep(void __iomap *port, void *buf, unsigned long count)
 {
 	insb((unsigned long __force)port, buf, count);
 }
-static inline void ioread16_rep(void __iomem *port, void *buf, unsigned long count)
+static inline void ioread16_rep(void __iomap *port, void *buf, unsigned long count)
 {
 	insw((unsigned long __force)port, buf, count);
 }
 
-static inline void ioread32_rep(void __iomem *port, void *buf, unsigned long count)
+static inline void ioread32_rep(void __iomap *port, void *buf, unsigned long count)
 {
 	insl((unsigned long __force)port, buf, count);
 }
 
-static inline void iowrite8_rep(void __iomem *port, const void *buf, unsigned long count)
+static inline void iowrite8_rep(void __iomap *port, const void *buf, unsigned long count)
 {
 	outsb((unsigned long __force)port, buf, count);
 }
 
-static inline void iowrite16_rep(void __iomem *port, const void *buf, unsigned long count)
+static inline void iowrite16_rep(void __iomap *port, const void *buf, unsigned long count)
 {
 	outsw((unsigned long __force)port, buf, count);
 }
 
-static inline void iowrite32_rep(void __iomem *port, const void *buf, unsigned long count)
+static inline void iowrite32_rep(void __iomap *port, const void *buf, unsigned long count)
 {
 	outsl((unsigned long __force)port, buf, count);
 }
 
 /* Create a virtual mapping cookie for an IO port range */
-extern void __iomem *ioport_map(unsigned long port, unsigned int nr);
-extern void ioport_unmap(void __iomem *);
+extern void __iomap *ioport_map(unsigned long port, unsigned int nr);
+extern void ioport_unmap(void __iomap *);
 
 /* Create a virtual mapping cookie for a PCI BAR (memory or IO) */
 struct pci_dev;
-extern void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max);
-extern void pci_iounmap(struct pci_dev *dev, void __iomem *);
+extern void __iomap *pci_iomap(struct pci_dev *dev, int bar, unsigned long max);
+extern void pci_iounmap(struct pci_dev *dev, void __iomap *);
 
 /*
  * Bus number may be in res->flags... somewhere.
Index: linux-work/include/asm-sparc64/io.h
===================================================================
--- linux-work.orig/include/asm-sparc64/io.h	2008-02-18 14:14:43.000000000 +1100
+++ linux-work/include/asm-sparc64/io.h	2008-02-18 14:15:01.000000000 +1100
@@ -444,21 +444,21 @@ static inline void iounmap(volatile void
 {
 }
 
-#define ioread8(X)			readb(X)
-#define ioread16(X)			readw(X)
-#define ioread32(X)			readl(X)
-#define iowrite8(val,X)			writeb(val,X)
-#define iowrite16(val,X)		writew(val,X)
-#define iowrite32(val,X)		writel(val,X)
+#define ioread8(X)			readb((void __iomem __force *)(X))
+#define ioread16(X)			readw((void __iomem __force *)(X))
+#define ioread32(X)			readl((void __iomem __force *)(X))
+#define iowrite8(val,X)			writeb(val,(void __iomem __force *)(X))
+#define iowrite16(val,X)		writew(val,(void __iomem __force *)(X))
+#define iowrite32(val,X)		writel(val,(void __iomem __force *)(X))
 
 /* Create a virtual mapping cookie for an IO port range */
-extern void __iomem *ioport_map(unsigned long port, unsigned int nr);
-extern void ioport_unmap(void __iomem *);
+extern void __iomap *ioport_map(unsigned long port, unsigned int nr);
+extern void ioport_unmap(void __iomap *);
 
 /* Create a virtual mapping cookie for a PCI BAR (memory or IO) */
 struct pci_dev;
-extern void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max);
-extern void pci_iounmap(struct pci_dev *dev, void __iomem *);
+extern void __iomap *pci_iomap(struct pci_dev *dev, int bar, unsigned long max);
+extern void pci_iounmap(struct pci_dev *dev, void __iomap *);
 
 /* Similarly for SBUS. */
 #define sbus_ioremap(__res, __offset, __size, __name) \
Index: linux-work/include/asm-v850/io.h
===================================================================
--- linux-work.orig/include/asm-v850/io.h	2008-02-18 14:17:47.000000000 +1100
+++ linux-work/include/asm-v850/io.h	2008-02-18 14:18:21.000000000 +1100
@@ -106,12 +106,12 @@ outsl (unsigned long port, const void *s
 #define ioremap_writethrough(physaddr, size)	ioremap (physaddr, size)
 #define ioremap_fullcache(physaddr, size)	ioremap (physaddr, size)
 
-#define ioread8(addr)		readb (addr)
-#define ioread16(addr)		readw (addr)
-#define ioread32(addr)		readl (addr)
-#define iowrite8(val, addr)	writeb (val, addr)
-#define iowrite16(val, addr)	writew (val, addr)
-#define iowrite32(val, addr)	writel (val, addr)
+#define ioread8(addr)		readb ((void __iomem __force *)(addr))
+#define ioread16(addr)		readw ((void __iomem __force *)(addr))
+#define ioread32(addr)		readl ((void __iomem __force *)(addr))
+#define iowrite8(val, addr)	writeb (val, (void __iomem __force *)(addr))
+#define iowrite16(val, addr)	writew (val, (void __iomem __force *)(addr))
+#define iowrite32(val, addr)	writel (val, (void __iomem __force *)(addr))
 
 #define mmiowb()
 
Index: linux-work/include/asm-v850/pci.h
===================================================================
--- linux-work.orig/include/asm-v850/pci.h	2008-02-18 14:18:57.000000000 +1100
+++ linux-work/include/asm-v850/pci.h	2008-02-18 14:19:02.000000000 +1100
@@ -113,7 +113,7 @@ static inline void pci_dma_burst_advice(
 }
 #endif
 
-extern void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max);
-extern void pci_iounmap (struct pci_dev *dev, void __iomem *addr);
+extern void __iomap *pci_iomap(struct pci_dev *dev, int bar, unsigned long max);
+extern void pci_iounmap (struct pci_dev *dev, void __iomap *addr);
 
 #endif /* __V850_PCI_H__ */
Index: linux-work/include/linux/pci.h
===================================================================
--- linux-work.orig/include/linux/pci.h	2008-02-18 14:24:13.000000000 +1100
+++ linux-work/include/linux/pci.h	2008-02-18 14:24:29.000000000 +1100
@@ -1030,9 +1030,9 @@ enum pci_fixup_pass {
 
 void pci_fixup_device(enum pci_fixup_pass pass, struct pci_dev *dev);
 
-void __iomem *pcim_iomap(struct pci_dev *pdev, int bar, unsigned long maxlen);
-void pcim_iounmap(struct pci_dev *pdev, void __iomem *addr);
-void __iomem * const *pcim_iomap_table(struct pci_dev *pdev);
+void __iomap *pcim_iomap(struct pci_dev *pdev, int bar, unsigned long maxlen);
+void pcim_iounmap(struct pci_dev *pdev, void __iomap *addr);
+void __iomap * const *pcim_iomap_table(struct pci_dev *pdev);
 int pcim_iomap_regions(struct pci_dev *pdev, u16 mask, const char *name);
 void pcim_iounmap_regions(struct pci_dev *pdev, u16 mask);
 
Index: linux-work/lib/devres.c
===================================================================
--- linux-work.orig/lib/devres.c	2008-02-18 14:22:13.000000000 +1100
+++ linux-work/lib/devres.c	2008-02-18 14:23:44.000000000 +1100
@@ -90,7 +90,7 @@ EXPORT_SYMBOL(devm_iounmap);
  */
 static void devm_ioport_map_release(struct device *dev, void *res)
 {
-	ioport_unmap(*(void __iomem **)res);
+	ioport_unmap(*(void __iomap **)res);
 }
 
 static int devm_ioport_map_match(struct device *dev, void *res,
@@ -111,7 +111,7 @@ static int devm_ioport_map_match(struct 
 void __iomem * devm_ioport_map(struct device *dev, unsigned long port,
 			       unsigned int nr)
 {
-	void __iomem **ptr, *addr;
+	void __iomap **ptr, *addr;
 
 	ptr = devres_alloc(devm_ioport_map_release, sizeof(*ptr), GFP_KERNEL);
 	if (!ptr)
@@ -136,7 +136,7 @@ EXPORT_SYMBOL(devm_ioport_map);
  * Managed ioport_unmap().  @addr must have been mapped using
  * devm_ioport_map().
  */
-void devm_ioport_unmap(struct device *dev, void __iomem *addr)
+void devm_ioport_unmap(struct device *dev, void __iomap *addr)
 {
 	ioport_unmap(addr);
 	WARN_ON(devres_destroy(dev, devm_ioport_map_release,
@@ -151,7 +151,7 @@ EXPORT_SYMBOL(devm_ioport_unmap);
 #define PCIM_IOMAP_MAX	PCI_ROM_RESOURCE
 
 struct pcim_iomap_devres {
-	void __iomem *table[PCIM_IOMAP_MAX];
+	void __iomap *table[PCIM_IOMAP_MAX];
 };
 
 static void pcim_iomap_release(struct device *gendev, void *res)
@@ -178,7 +178,7 @@ static void pcim_iomap_release(struct de
  * be safely called without context and guaranteed to succed once
  * allocated.
  */
-void __iomem * const * pcim_iomap_table(struct pci_dev *pdev)
+void __iomap * const * pcim_iomap_table(struct pci_dev *pdev)
 {
 	struct pcim_iomap_devres *dr, *new_dr;
 
@@ -203,13 +203,13 @@ EXPORT_SYMBOL(pcim_iomap_table);
  * Managed pci_iomap().  Map is automatically unmapped on driver
  * detach.
  */
-void __iomem * pcim_iomap(struct pci_dev *pdev, int bar, unsigned long maxlen)
+void __iomap * pcim_iomap(struct pci_dev *pdev, int bar, unsigned long maxlen)
 {
-	void __iomem **tbl;
+	void __iomap **tbl;
 
 	BUG_ON(bar >= PCIM_IOMAP_MAX);
 
-	tbl = (void __iomem **)pcim_iomap_table(pdev);
+	tbl = (void __iomap **)pcim_iomap_table(pdev);
 	if (!tbl || tbl[bar])	/* duplicate mappings not allowed */
 		return NULL;
 
@@ -225,14 +225,14 @@ EXPORT_SYMBOL(pcim_iomap);
  *
  * Managed pci_iounmap().  @addr must have been mapped using pcim_iomap().
  */
-void pcim_iounmap(struct pci_dev *pdev, void __iomem *addr)
+void pcim_iounmap(struct pci_dev *pdev, void __iomap *addr)
 {
-	void __iomem **tbl;
+	void __iomap **tbl;
 	int i;
 
 	pci_iounmap(pdev, addr);
 
-	tbl = (void __iomem **)pcim_iomap_table(pdev);
+	tbl = (void __iomap **)pcim_iomap_table(pdev);
 	BUG_ON(!tbl);
 
 	for (i = 0; i < PCIM_IOMAP_MAX; i++)
@@ -254,7 +254,7 @@ EXPORT_SYMBOL(pcim_iounmap);
  */
 int pcim_iomap_regions(struct pci_dev *pdev, u16 mask, const char *name)
 {
-	void __iomem * const *iomap;
+	void __iomap * const *iomap;
 	int i, rc;
 
 	iomap = pcim_iomap_table(pdev);
@@ -306,7 +306,7 @@ EXPORT_SYMBOL(pcim_iomap_regions);
  */
 void pcim_iounmap_regions(struct pci_dev *pdev, u16 mask)
 {
-	void __iomem * const *iomap;
+	void __iomap * const *iomap;
 	int i;
 
 	iomap = pcim_iomap_table(pdev);
