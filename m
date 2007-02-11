Return-Path: <linux-kernel-owner+w=401wt.eu-S1750773AbXBKSPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750773AbXBKSPo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 13:15:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750772AbXBKSPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 13:15:44 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:58364 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbXBKSPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 13:15:42 -0500
Date: Sun, 11 Feb 2007 18:15:29 +0000
From: Al Viro <viro@ftp.linux.org.uk>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Tejun Heo <htejun@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jgarzik@pobox.com>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org
Subject: Re: [PATCH] iomap: make PCI iomap stuff excluded when PCI isn't configured
Message-ID: <20070211181529.GY10050@ftp.linux.org.uk>
References: <20070210114314.GB12642@osiris.boeblingen.de.ibm.com> <45CE0434.30105@gmail.com> <20070210194630.GA13416@osiris.ibm.com> <45CE43B5.2020806@gmail.com> <Pine.LNX.4.64.0702101425230.8424@woody.linux-foundation.org> <20070210225033.GO10050@ftp.linux.org.uk> <20070210235553.GP10050@ftp.linux.org.uk> <1171212333.23147.10.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1171212333.23147.10.camel@localhost>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 11, 2007 at 05:45:33PM +0100, Martin Schwidefsky wrote:
> On Sat, 2007-02-10 at 23:55 +0000, Al Viro wrote: 
> > FWIW, the current picture wrt io-related stuff looks so:
> > 
> > s390: no ioport_map, no ioread*/iowrite*, no port IO except for (in|out)b(_p|)
> 
> s390 does not even need (in|out)b(_p|). I wondered what else from io.h
> do we not need. The answer is: almost nothing. With the devres patch
> from Al and the dma-mapping patch from Heiko we can get rid of iomem and
> all associated definitions.

Then we'll just need to replace NO_IOPORT with NO_IOMEM in Kconfig and
kill arch/s390/mm/ioremap.c.

BTW, there's an annoying bit of junk in there - IO_SPACE_LIMIT.  We
only need it for /proc/ioports, which AFAICS shouldn't even be there
on s390 (or uml).  OTOH, removing that thing would mean a user-visible
change - we go from "empty file in /proc" to "no such file in /proc"...

Anyway, switch to NO_IOMEM follows (on top of patches mentioned above).

>From cb57d59e45f97f1134c65f77e8dd6423e5ed9a47 Mon Sep 17 00:00:00 2001
From: Al Viro <viro@zeniv.linux.org.uk>
Date: Sun, 11 Feb 2007 13:10:19 -0500
Subject: [PATCH] s390 has no iomem

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/s390/Kconfig      |    2 +-
 arch/s390/mm/Makefile  |    2 +-
 arch/s390/mm/ioremap.c |   58 ------------------------------------------
 include/asm-s390/io.h  |   65 ------------------------------------------------
 4 files changed, 2 insertions(+), 125 deletions(-)
 delete mode 100644 arch/s390/mm/ioremap.c

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index c4366aa..1013808 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -37,7 +37,7 @@ config GENERIC_HWEIGHT
 config GENERIC_TIME
 	def_bool y
 
-config NO_IOPORT
+config NO_IOMEM
 	def_bool y
 
 mainmenu "Linux Kernel Configuration"
diff --git a/arch/s390/mm/Makefile b/arch/s390/mm/Makefile
index 8e09db1..f95449b 100644
--- a/arch/s390/mm/Makefile
+++ b/arch/s390/mm/Makefile
@@ -2,6 +2,6 @@
 # Makefile for the linux s390-specific parts of the memory manager.
 #
 
-obj-y	 := init.o fault.o ioremap.o extmem.o mmap.o vmem.o
+obj-y	 := init.o fault.o extmem.o mmap.o vmem.o
 obj-$(CONFIG_CMM) += cmm.o
 
diff --git a/arch/s390/mm/ioremap.c b/arch/s390/mm/ioremap.c
deleted file mode 100644
index 3d2100a..0000000
--- a/arch/s390/mm/ioremap.c
+++ /dev/null
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
diff --git a/include/asm-s390/io.h b/include/asm-s390/io.h
index a4c2d55..dca6a6c 100644
--- a/include/asm-s390/io.h
+++ b/include/asm-s390/io.h
@@ -13,7 +13,6 @@
 
 #ifdef __KERNEL__
 
-#include <linux/vmalloc.h>
 #include <asm/page.h>
 
 #define IO_SPACE_LIMIT 0xffffffff
@@ -41,70 +40,6 @@ static inline void * phys_to_virt(unsigned long address)
         return __io_virt(address);
 }
 
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
-}
-
-extern void iounmap(void *addr);
-
-/*
- * IO bus memory addresses are also 1:1 with the physical address
- */
-#define virt_to_bus virt_to_phys
-#define bus_to_virt phys_to_virt
-
-/*
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
 #define mmiowb()	do { } while (0)
 
 /*
-- 
1.5.0-rc2.GIT

