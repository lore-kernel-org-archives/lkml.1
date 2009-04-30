Return-Path: <linux-kernel-owner+w=401wt.eu-S1765788AbZD3TF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765788AbZD3TF7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 15:05:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765098AbZD3TDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 15:03:12 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:49801 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764229AbZD3TC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 15:02:58 -0400
Message-Id: <20090430185717.674624337@arndb.de>
References: <20090430185628.866082445@arndb.de>
User-Agent: quilt/0.46-1
Date: Thu, 30 Apr 2009 20:56:36 +0200
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
       Remis Lima Baima <remis.developer@googlemail.com>
Subject: [PATCH v2 8/9] asm-generic: add generic atomic.h and io.h
Content-Disposition: inline; filename=0008-asm-generic-add-generic-atomic.h-and-io.h.patch
X-Provags-ID: V01U2FsdGVkX1+6ZMwnmOTFVnejiimXtZlAr2gM68XqNqvHTVb
 alcXaqQ/UAnyDdXQ5YYrLiBQXXggOv16vH6VT0NQYGJXfB5J6Y
 Jp88GkSK+T3emVN4yOlNg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

atomic.h and io.h are based on the mn10300 architecture,
which is already pretty generic and can be used by
other architectures that do not have hardware support
for atomic operations or out-of-order I/O access.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/asm-generic/atomic.h |  165 +++++++++++++++++++++++
 include/asm-generic/io.h     |  300 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 465 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-generic/atomic.h
 create mode 100644 include/asm-generic/io.h

diff --git a/include/asm-generic/atomic.h b/include/asm-generic/atomic.h
new file mode 100644
index 0000000..f4bc212
--- /dev/null
+++ b/include/asm-generic/atomic.h
@@ -0,0 +1,165 @@
+/*
+ * Generic C implementation of atomic counter operations
+ * Originally implemented for MN10300.
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef __ASM_GENERIC_ATOMIC_H
+#define __ASM_GENERIC_ATOMIC_H
+
+#ifdef CONFIG_SMP
+#error not SMP safe
+#endif
+
+/*
+ * Atomic operations that C can't guarantee us.  Useful for
+ * resource counting etc..
+ */
+
+#define ATOMIC_INIT(i)	{ (i) }
+
+#ifdef __KERNEL__
+
+/**
+ * atomic_read - read atomic variable
+ * @v: pointer of type atomic_t
+ *
+ * Atomically reads the value of @v.  Note that the guaranteed
+ * useful range of an atomic_t is only 24 bits.
+ */
+#define atomic_read(v)	((v)->counter)
+
+/**
+ * atomic_set - set atomic variable
+ * @v: pointer of type atomic_t
+ * @i: required value
+ *
+ * Atomically sets the value of @v to @i.  Note that the guaranteed
+ * useful range of an atomic_t is only 24 bits.
+ */
+#define atomic_set(v, i) (((v)->counter) = (i))
+
+#include <asm/system.h>
+
+/**
+ * atomic_add_return - add integer to atomic variable
+ * @i: integer value to add
+ * @v: pointer of type atomic_t
+ *
+ * Atomically adds @i to @v and returns the result
+ * Note that the guaranteed useful range of an atomic_t is only 24 bits.
+ */
+static inline int atomic_add_return(int i, atomic_t *v)
+{
+	unsigned long flags;
+	int temp;
+
+	local_irq_save(flags);
+	temp = v->counter;
+	temp += i;
+	v->counter = temp;
+	local_irq_restore(flags);
+
+	return temp;
+}
+
+/**
+ * atomic_sub_return - subtract integer from atomic variable
+ * @i: integer value to subtract
+ * @v: pointer of type atomic_t
+ *
+ * Atomically subtracts @i from @v and returns the result
+ * Note that the guaranteed useful range of an atomic_t is only 24 bits.
+ */
+static inline int atomic_sub_return(int i, atomic_t *v)
+{
+	unsigned long flags;
+	int temp;
+
+	local_irq_save(flags);
+	temp = v->counter;
+	temp -= i;
+	v->counter = temp;
+	local_irq_restore(flags);
+
+	return temp;
+}
+
+static inline int atomic_add_negative(int i, atomic_t *v)
+{
+	return atomic_add_return(i, v) < 0;
+}
+
+static inline void atomic_add(int i, atomic_t *v)
+{
+	atomic_add_return(i, v);
+}
+
+static inline void atomic_sub(int i, atomic_t *v)
+{
+	atomic_sub_return(i, v);
+}
+
+static inline void atomic_inc(atomic_t *v)
+{
+	atomic_add_return(1, v);
+}
+
+static inline void atomic_dec(atomic_t *v)
+{
+	atomic_sub_return(1, v);
+}
+
+#define atomic_dec_return(v)		atomic_sub_return(1, (v))
+#define atomic_inc_return(v)		atomic_add_return(1, (v))
+
+#define atomic_sub_and_test(i, v)	(atomic_sub_return((i), (v)) == 0)
+#define atomic_dec_and_test(v)		(atomic_sub_return(1, (v)) == 0)
+#define atomic_inc_and_test(v)		(atomic_add_return(1, (v)) == 0)
+
+#define atomic_add_unless(v, a, u)				\
+({								\
+	int c, old;						\
+	c = atomic_read(v);					\
+	while (c != (u) && (old = atomic_cmpxchg((v), c, c + (a))) != c) \
+		c = old;					\
+	c != (u);						\
+})
+
+#define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
+
+static inline void atomic_clear_mask(unsigned long mask, unsigned long *addr)
+{
+	unsigned long flags;
+
+	mask = ~mask;
+	local_irq_save(flags);
+	*addr &= mask;
+	local_irq_restore(flags);
+}
+
+#define atomic_xchg(ptr, v)		(xchg(&(ptr)->counter, (v)))
+#define atomic_cmpxchg(v, old, new)	(cmpxchg(&((v)->counter), (old), (new)))
+
+#define cmpxchg_local(ptr, o, n)				  	       \
+	((__typeof__(*(ptr)))__cmpxchg_local_generic((ptr), (unsigned long)(o),\
+			(unsigned long)(n), sizeof(*(ptr))))
+
+#define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
+
+/* Atomic operations are already serializing on MN10300??? */
+#define smp_mb__before_atomic_dec()	barrier()
+#define smp_mb__after_atomic_dec()	barrier()
+#define smp_mb__before_atomic_inc()	barrier()
+#define smp_mb__after_atomic_inc()	barrier()
+
+#include <asm-generic/atomic-long.h>
+
+#endif /* __KERNEL__ */
+#endif /* __ASM_GENERIC_ATOMIC_H */
diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
new file mode 100644
index 0000000..5ae45e5
--- /dev/null
+++ b/include/asm-generic/io.h
@@ -0,0 +1,300 @@
+/* Generic I/O port emulation, based on MN10300 code
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef __ASM_GENERIC_IO_H
+#define __ASM_GENERIC_IO_H
+
+#include <asm/page.h> /* I/O is all done through memory accesses */
+#include <asm/cacheflush.h>
+#include <linux/types.h>
+
+#ifdef CONFIG_GENERIC_IOMAP
+#include <asm-generic/iomap.h>
+#endif
+
+#define mmiowb() do {} while (0)
+
+/*****************************************************************************/
+/*
+ * readX/writeX() are used to access memory mapped devices. On some
+ * architectures the memory mapped IO stuff needs to be accessed
+ * differently. On the simple architectures, we just read/write the
+ * memory location directly.
+ */
+static inline u8 __raw_readb(const volatile void __iomem *addr)
+{
+	return *(const volatile u8 __force *) addr;
+}
+
+static inline u16 __raw_readw(const volatile void __iomem *addr)
+{
+	return *(const volatile u16 __force *) addr;
+}
+
+static inline u32 __raw_readl(const volatile void __iomem *addr)
+{
+	return *(const volatile u32 __force *) addr;
+}
+
+#define readb __raw_readb
+#define readw(addr) __le16_to_cpu(__raw_readw(addr))
+#define readl(addr) __le32_to_cpu(__raw_readl(addr))
+
+static inline void __raw_writeb(u8 b, volatile void __iomem *addr)
+{
+	*(volatile u8 __force *) addr = b;
+}
+
+static inline void __raw_writew(u16 b, volatile void __iomem *addr)
+{
+	*(volatile u16 __force *) addr = b;
+}
+
+static inline void __raw_writel(u32 b, volatile void __iomem *addr)
+{
+	*(volatile u32 __force *) addr = b;
+}
+
+#define writeb __raw_writeb
+#define writew(b,addr) __raw_writew(__cpu_to_le16(b),addr)
+#define writel(b,addr) __raw_writel(__cpu_to_le32(b),addr)
+
+#ifdef CONFIG_64BIT
+static inline u64 __raw_readq(const volatile void __iomem *addr)
+{
+	return *(const volatile u64 __force *) addr;
+}
+#define readq(addr) __le64_to_cpu(__raw_readq(addr))
+
+static inline void __raw_writeq(u64 b, volatile void __iomem *addr)
+{
+	*(volatile u64 __force *) addr = b;
+}
+#define writeq(b,addr) __raw_writeq(__cpu_to_le64(b),addr)
+#endif
+
+/*****************************************************************************/
+/*
+ * traditional input/output functions
+ */
+
+static inline u8 inb(unsigned long addr)
+{
+	return readb((volatile void __iomem *) addr);
+}
+
+static inline u16 inw(unsigned long addr)
+{
+	return readw((volatile void __iomem *) addr);
+}
+
+static inline u32 inl(unsigned long addr)
+{
+	return readl((volatile void __iomem *) addr);
+}
+
+static inline void outb(u8 b, unsigned long addr)
+{
+	writeb(b, (volatile void __iomem *) addr);
+}
+
+static inline void outw(u16 b, unsigned long addr)
+{
+	writew(b, (volatile void __iomem *) addr);
+}
+
+static inline void outl(u32 b, unsigned long addr)
+{
+	writel(b, (volatile void __iomem *) addr);
+}
+
+#define inb_p(addr)	inb(addr)
+#define inw_p(addr)	inw(addr)
+#define inl_p(addr)	inl(addr)
+#define outb_p(x, addr)	outb((x), (addr))
+#define outw_p(x, addr)	outw((x), (addr))
+#define outl_p(x, addr)	outl((x), (addr))
+
+static inline void insb(unsigned long addr, void *buffer, int count)
+{
+	if (count) {
+		u8 *buf = buffer;
+		do {
+			u8 x = inb(addr);
+			*buf++ = x;
+		} while (--count);
+	}
+}
+
+static inline void insw(unsigned long addr, void *buffer, int count)
+{
+	if (count) {
+		u16 *buf = buffer;
+		do {
+			u16 x = inw(addr);
+			*buf++ = x;
+		} while (--count);
+	}
+}
+
+static inline void insl(unsigned long addr, void *buffer, int count)
+{
+	if (count) {
+		u32 *buf = buffer;
+		do {
+			u32 x = inl(addr);
+			*buf++ = x;
+		} while (--count);
+	}
+}
+
+static inline void outsb(unsigned long addr, const void *buffer, int count)
+{
+	if (count) {
+		const u8 *buf = buffer;
+		do {
+			outb(*buf++, addr);
+		} while (--count);
+	}
+}
+
+static inline void outsw(unsigned long addr, const void *buffer, int count)
+{
+	if (count) {
+		const u16 *buf = buffer;
+		do {
+			outw(*buf++, addr);
+		} while (--count);
+	}
+}
+
+static inline void outsl(unsigned long addr, const void *buffer, int count)
+{
+	if (count) {
+		const u32 *buf = buffer;
+		do {
+			outl(*buf++, addr);
+		} while (--count);
+	}
+}
+
+#ifndef CONFIG_GENERIC_IOMAP
+#define ioread8(addr)		readb(addr)
+#define ioread16(addr)		readw(addr)
+#define ioread32(addr)		readl(addr)
+
+#define iowrite8(v, addr)	writeb((v), (addr))
+#define iowrite16(v, addr)	writew((v), (addr))
+#define iowrite32(v, addr)	writel((v), (addr))
+
+#define ioread8_rep(p, dst, count) \
+	insb((unsigned long) (p), (dst), (count))
+#define ioread16_rep(p, dst, count) \
+	insw((unsigned long) (p), (dst), (count))
+#define ioread32_rep(p, dst, count) \
+	insl((unsigned long) (p), (dst), (count))
+
+#define iowrite8_rep(p, src, count) \
+	outsb((unsigned long) (p), (src), (count))
+#define iowrite16_rep(p, src, count) \
+	outsw((unsigned long) (p), (src), (count))
+#define iowrite32_rep(p, src, count) \
+	outsl((unsigned long) (p), (src), (count))
+#endif /* CONFIG_GENERIC_IOMAP */
+
+
+#define IO_SPACE_LIMIT 0xffffffff
+
+#ifdef __KERNEL__
+
+#include <linux/vmalloc.h>
+#define __io_virt(x) ((void *) (x))
+
+#ifndef CONFIG_GENERIC_IOMAP
+/* Create a virtual mapping cookie for a PCI BAR (memory or IO) */
+struct pci_dev;
+extern void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max);
+static inline void pci_iounmap(struct pci_dev *dev, void __iomem *p)
+{
+}
+#endif /* CONFIG_GENERIC_IOMAP */
+
+/*
+ * Change virtual addresses to physical addresses and vv.
+ * These are pretty trivial
+ */
+static inline unsigned long virt_to_phys(volatile void *address)
+{
+	return __pa((unsigned long)address);
+}
+
+static inline void *phys_to_virt(unsigned long address)
+{
+	return __va(address);
+}
+
+/*
+ * Change "struct page" to physical address.
+ */
+static inline void __iomem *ioremap(phys_addr_t offset, unsigned long size)
+{
+	return (void *) offset;
+}
+
+#define __ioremap(offset, size, flags)	ioremap(offset, size)
+
+#ifndef ioremap_nocache
+#define ioremap_nocache ioremap
+#endif
+
+#ifndef ioremap_wc
+#define ioremap_wc ioremap_nocache
+#endif
+
+static inline void iounmap(void *addr)
+{
+}
+
+#ifndef CONFIG_GENERIC_IOMAP
+static inline void __iomem *ioport_map(unsigned long port, unsigned int nr)
+{
+	return (void __iomem *) port;
+}
+
+static inline void ioport_unmap(void __iomem *p)
+{
+}
+#else /* CONFIG_GENERIC_IOMAP */
+extern void __iomem *ioport_map(unsigned long port, unsigned int nr);
+extern void ioport_unmap(void __iomem *p);
+#endif /* CONFIG_GENERIC_IOMAP */
+
+#define xlate_dev_kmem_ptr(p)	p
+#define xlate_dev_mem_ptr(p)	((void *) (p))
+
+#ifndef virt_to_bus
+static inline unsigned long virt_to_bus(volatile void *address)
+{
+	return ((unsigned long) address);
+}
+
+static inline void *bus_to_virt(unsigned long address)
+{
+	return (void *) address;
+}
+#endif
+
+#define memset_io(a, b, c)	memset(__io_virt(a), (b), (c))
+#define memcpy_fromio(a, b, c)	memcpy((a), __io_virt(b), (c))
+#define memcpy_toio(a, b, c)	memcpy(__io_virt(a), (b), (c))
+
+#endif /* __KERNEL__ */
+
+#endif /* __ASM_GENERIC_IO_H */
-- 
1.5.6.3

-- 

