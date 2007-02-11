Return-Path: <linux-kernel-owner+w=401wt.eu-S1750730AbXBKQpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750730AbXBKQpd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 11:45:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750728AbXBKQpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 11:45:33 -0500
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:42888 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbXBKQpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 11:45:32 -0500
Subject: Re: [PATCH] iomap: make PCI iomap stuff excluded when PCI isn't
	configured
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Tejun Heo <htejun@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jgarzik@pobox.com>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org
In-Reply-To: <20070210235553.GP10050@ftp.linux.org.uk>
References: <20070210114314.GB12642@osiris.boeblingen.de.ibm.com>
	 <45CE0434.30105@gmail.com> <20070210194630.GA13416@osiris.ibm.com>
	 <45CE43B5.2020806@gmail.com>
	 <Pine.LNX.4.64.0702101425230.8424@woody.linux-foundation.org>
	 <20070210225033.GO10050@ftp.linux.org.uk>
	 <20070210235553.GP10050@ftp.linux.org.uk>
Content-Type: text/plain
Organization: IBM Corporation
Date: Sun, 11 Feb 2007 17:45:33 +0100
Message-Id: <1171212333.23147.10.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-02-10 at 23:55 +0000, Al Viro wrote: 
> FWIW, the current picture wrt io-related stuff looks so:
> 
> s390: no ioport_map, no ioread*/iowrite*, no port IO except for (in|out)b(_p|)

s390 does not even need (in|out)b(_p|). I wondered what else from io.h
do we not need. The answer is: almost nothing. With the devres patch
from Al and the dma-mapping patch from Heiko we can get rid of iomem and
all associated definitions.

-- 
blue skies,
  Martin.

Martin Schwidefsky
Linux for zSeries Development & Services
IBM Deutschland Entwicklung GmbH

"Reality continues to ruin my life." - Calvin.

--
From: Martin Schwidefsky <schwidefsky@de.ibm.com>

[S390] cleanup io.h

Remove code to access I/O memory. There is no such thing on s390.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 arch/s390/Kconfig      |    3 ++
 arch/s390/mm/Makefile  |    2 -
 arch/s390/mm/ioremap.c |   58 --------------------------------------------
 include/asm-s390/io.h  |   64 -------------------------------------------------
 4 files changed, 5 insertions(+), 122 deletions(-)

diff -urpN linux-2.6/arch/s390/Kconfig linux-2.6-patched/arch/s390/Kconfig
--- linux-2.6/arch/s390/Kconfig	2007-02-11 17:24:37.000000000 +0100
+++ linux-2.6-patched/arch/s390/Kconfig	2007-02-11 17:25:30.000000000 +0100
@@ -40,6 +40,9 @@ config GENERIC_TIME
 config NO_IOPORT
 	def_bool y
 
+config NO_IOMEM
+	def_bool y
+
 mainmenu "Linux Kernel Configuration"
 
 config S390
diff -urpN linux-2.6/arch/s390/mm/ioremap.c linux-2.6-patched/arch/s390/mm/ioremap.c
--- linux-2.6/arch/s390/mm/ioremap.c	2006-12-09 21:08:18.000000000 +0100
+++ linux-2.6-patched/arch/s390/mm/ioremap.c	1970-01-01 01:00:00.000000000 +0100
@@ -1,58 +0,0 @@
-/*
- *  arch/s390/mm/ioremap.c
- *
- *  S390 version
- *    Copyright (C) 1999 IBM Deutschland Entwicklung GmbH, IBM Corporation
- *    Author(s): Hartmut Penner (hp@de.ibm.com)
- *
- *  Derived from "arch/i386/mm/extable.c"
- *    (C) Copyright 1995 1996 Linus Torvalds
- *
- * Re-map IO memory to kernel address space so that we can access it.
- * This is needed for high PCI addresses that aren't mapped in the
- * 640k-1MB IO memory area on PC's
- */
-
-#include <linux/vmalloc.h>
-#include <linux/mm.h>
-#include <linux/io.h>
-#include <asm/pgalloc.h>
-
-/*
- * Generic mapping function (not visible outside):
- */
-
-/*
- * Remap an arbitrary physical address space into the kernel virtual
- * address space. Needed when the kernel wants to access high addresses
- * directly.
- */
-void * __ioremap(unsigned long phys_addr, unsigned long size, unsigned long flags)
-{
-	void * addr;
-	struct vm_struct * area;
-
-	if (phys_addr < virt_to_phys(high_memory))
-		return phys_to_virt(phys_addr);
-	if (phys_addr & ~PAGE_MASK)
-		return NULL;
-	size = PAGE_ALIGN(size);
-	if (!size || size > phys_addr + size)
-		return NULL;
-	area = get_vm_area(size, VM_IOREMAP);
-	if (!area)
-		return NULL;
-	addr = area->addr;
-	if (ioremap_page_range((unsigned long)addr, (unsigned long)addr + size,
-			       phys_addr, __pgprot(flags))) {
-		vfree(addr);
-		return NULL;
-	}
-	return addr;
-}
-
-void iounmap(void *addr)
-{
-	if (addr > high_memory)
-		vfree(addr);
-}
diff -urpN linux-2.6/arch/s390/mm/Makefile linux-2.6-patched/arch/s390/mm/Makefile
--- linux-2.6/arch/s390/mm/Makefile	2006-12-09 21:08:18.000000000 +0100
+++ linux-2.6-patched/arch/s390/mm/Makefile	2007-02-11 17:23:02.000000000 +0100
@@ -2,6 +2,6 @@
 # Makefile for the linux s390-specific parts of the memory manager.
 #
 
-obj-y	 := init.o fault.o ioremap.o extmem.o mmap.o vmem.o
+obj-y	 := init.o fault.o extmem.o mmap.o vmem.o
 obj-$(CONFIG_CMM) += cmm.o
 
diff -urpN linux-2.6/include/asm-s390/io.h linux-2.6-patched/include/asm-s390/io.h
--- linux-2.6/include/asm-s390/io.h	2007-02-07 15:42:46.000000000 +0100
+++ linux-2.6-patched/include/asm-s390/io.h	2007-02-11 17:19:32.000000000 +0100
@@ -18,8 +18,6 @@
 
 #define IO_SPACE_LIMIT 0xffffffff
 
-#define __io_virt(x)            ((void *)(PAGE_OFFSET | (unsigned long)(x)))
-
 /*
  * Change virtual addresses to physical addresses and vv.
  * These are pretty trivial
@@ -38,28 +36,9 @@ static inline unsigned long virt_to_phys
 
 static inline void * phys_to_virt(unsigned long address)
 {
-        return __io_virt(address);
-}
-
-extern void * __ioremap(unsigned long offset, unsigned long size, unsigned long flags);
-
-static inline void * ioremap (unsigned long offset, unsigned long size)
-{
-        return __ioremap(offset, size, 0);
-}
-
-/*
- * This one maps high address device memory and turns off caching for that area.
- * it's useful if some control registers are in such an area and write combining
- * or read caching is not desirable:
- */
-static inline void * ioremap_nocache (unsigned long offset, unsigned long size)
-{
-        return __ioremap(offset, size, 0);
+        return (void *) address;
 }
 
-extern void iounmap(void *addr);
-
 /*
  * IO bus memory addresses are also 1:1 with the physical address
  */
@@ -67,47 +46,6 @@ extern void iounmap(void *addr);
 #define bus_to_virt phys_to_virt
 
 /*
- * readX/writeX() are used to access memory mapped devices. On some
- * architectures the memory mapped IO stuff needs to be accessed
- * differently.
- */
-
-#define readb(addr) (*(volatile unsigned char *) __io_virt(addr))
-#define readw(addr) (*(volatile unsigned short *) __io_virt(addr))
-#define readl(addr) (*(volatile unsigned int *) __io_virt(addr))
-#define readq(addr) (*(volatile unsigned long long *) __io_virt(addr))
-
-#define readb_relaxed(addr) readb(addr)
-#define readw_relaxed(addr) readw(addr)
-#define readl_relaxed(addr) readl(addr)
-#define readq_relaxed(addr) readq(addr)
-#define __raw_readb readb
-#define __raw_readw readw
-#define __raw_readl readl
-#define __raw_readq readq
-
-#define writeb(b,addr) (*(volatile unsigned char *) __io_virt(addr) = (b))
-#define writew(b,addr) (*(volatile unsigned short *) __io_virt(addr) = (b))
-#define writel(b,addr) (*(volatile unsigned int *) __io_virt(addr) = (b))
-#define writeq(b,addr) (*(volatile unsigned long long *) __io_virt(addr) = (b))
-#define __raw_writeb writeb
-#define __raw_writew writew
-#define __raw_writel writel
-#define __raw_writeq writeq
-
-#define memset_io(a,b,c)        memset(__io_virt(a),(b),(c))
-#define memcpy_fromio(a,b,c)    memcpy((a),__io_virt(b),(c))
-#define memcpy_toio(a,b,c)      memcpy(__io_virt(a),(b),(c))
-
-#define inb_p(addr) readb(addr)
-#define inb(addr) readb(addr)
-
-#define outb(x,addr) ((void) writeb(x,addr))
-#define outb_p(x,addr) outb(x,addr)
-
-#define mmiowb()	do { } while (0)
-
-/*
  * Convert a physical pointer to a virtual kernel pointer for /dev/mem
  * access
  */


