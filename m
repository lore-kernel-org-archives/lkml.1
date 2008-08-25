Return-Path: <linux-kernel-owner+w=401wt.eu-S1754739AbYHYUoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739AbYHYUoa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 16:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752677AbYHYUoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 16:44:21 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:58010 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788AbYHYUoS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 16:44:18 -0400
Date: Mon, 25 Aug 2008 23:43:34 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Greg Ungerer <gerg@snapgear.com>
Cc: gerg@uclinux.org, jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: [RFC: 2.6 patch] m68knommu: remove the broken COMEMPCI code
Message-ID: <20080825204333.GA13027@cs181140183.pp.htv.fi>
References: <20080819134718.GH8852@cs181140183.pp.htv.fi> <48B24E2C.9060703@snapgear.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <48B24E2C.9060703@snapgear.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2008 at 04:16:12PM +1000, Greg Ungerer wrote:
>
> Hi Adrian,
>
> Adrian Bunk wrote:
>> There exists blackfin hardware with PCI support, but the support
>> currently in the kernel fails to build starting with:
>>
>> <--  snip  -->
>>
>> ...
>>   CC      init/main.o
>> In file included from dma-mapping.h:5,
>>                  from dma-mapping.h:52,
>>                  from dmaengine.h:29,
>>                  from skbuff.h:29,
>>                  from netlink.h:155,
>>                  from genetlink.h:4,
>>                  from genetlink.h:4,
>>                  from taskstats_kern.h:12,
>>                  from main.c:46:
>> dma-mapping.h: In function 'dma_supported': ma-mapping.h:24: error: 
>> implicit declaration of function 'pci_dma_supported'
>> ...
>> make[2]: *** [init/main.o] Error 1
>
> I think we should just remove the underlying comempci access
> code which is the only user of this (arch/m68knommu/kernel/comempci.c).
> Nobody has used it in a very long time. And the hardware itself is
> old, and completely brain-damaged by design.

A patch for removing the comempci code is below.

It's a bit suspicious that asm/elia.h is now removed since comempci.c 
was the only user. What's the sttus of the eLIA platform?

But COMEMPCI fails with a different error - this init/main.o build error 
is present for CONFIG_PCI=y, CONFIG_COMEMPCI=n, so the dependency of PCI 
on BROKEN is still required (unless it gets fixed).

> Regards
> Greg

cu
Adrian


<--  snip  -->


The COMEMPCI code didn't even compile.

Greg Ungerer said:
I think we should just remove the underlying comempci access
code which is the only user of this (arch/m68knommu/kernel/comempci.c).
Nobody has used it in a very long time. And the hardware itself is
old, and completely brain-damaged by design.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/m68knommu/Kconfig              |    4 
 arch/m68knommu/include/asm/anchor.h |  112 ---
 arch/m68knommu/include/asm/elia.h   |   41 -
 arch/m68knommu/include/asm/mcfpci.h |  119 ---
 arch/m68knommu/include/asm/pci.h    |   23 
 arch/m68knommu/kernel/Makefile      |    1 
 arch/m68knommu/kernel/comempci.c    |  980 ----------------------------
 7 files changed, 1280 deletions(-)

6c2fed7cd1aad31f7c1518cfcb0d7d8f438ba8a4 
diff --git a/arch/m68knommu/Kconfig b/arch/m68knommu/Kconfig
index 77a5bdf..15ffd55 100644
--- a/arch/m68knommu/Kconfig
+++ b/arch/m68knommu/Kconfig
@@ -706,10 +706,6 @@ config PCI
 	help
 	  Support for PCI bus.
 
-config COMEMPCI
-	bool "CO-MEM lite PCI controller support"
-	depends on (M5307 || M5407)
-
 source "drivers/pci/Kconfig"
 
 source "drivers/pcmcia/Kconfig"
diff --git a/arch/m68knommu/include/asm/anchor.h b/arch/m68knommu/include/asm/anchor.h
deleted file mode 100644
index 871c0d5..0000000
--- a/arch/m68knommu/include/asm/anchor.h
+++ /dev/null
@@ -1,112 +0,0 @@
-/****************************************************************************/
-
-/*
- *	anchor.h -- Anchor CO-MEM Lite PCI host bridge part.
- *
- *	(C) Copyright 2000, Moreton Bay (www.moreton.com.au)
- */
-
-/****************************************************************************/
-#ifndef	anchor_h
-#define	anchor_h
-/****************************************************************************/
-
-/*
- *	Define basic addressing info.
- */
-#if defined(CONFIG_M5407C3)
-#define	COMEM_BASE	0xFFFF0000	/* Base of CO-MEM address space */
-#define	COMEM_IRQ	25		/* IRQ of anchor part */
-#else
-#define	COMEM_BASE	0x80000000	/* Base of CO-MEM address space */
-#define	COMEM_IRQ	25		/* IRQ of anchor part */
-#endif
-
-/****************************************************************************/
-
-/*
- *	4-byte registers of CO-MEM, so adjust register addresses for
- *	easy access. Handy macro for word access too.
- */
-#define	LREG(a)		((a) >> 2)
-#define	WREG(a)		((a) >> 1)
-
-
-/*
- *	Define base addresses within CO-MEM Lite register address space.
- */
-#define	COMEM_I2O	0x0000		/* I2O registers */
-#define	COMEM_OPREGS	0x0400		/* Operation registers */
-#define	COMEM_PCIBUS	0x2000		/* Direct access to PCI bus */
-#define	COMEM_SHMEM	0x4000		/* Shared memory region */
-
-#define	COMEM_SHMEMSIZE	0x4000		/* Size of shared memory */
-
-
-/*
- *	Define CO-MEM Registers.
- */
-#define	COMEM_I2OHISR	0x0030		/* I2O host interrupt status */
-#define	COMEM_I2OHIMR	0x0034		/* I2O host interrupt mask */
-#define	COMEM_I2OLISR	0x0038		/* I2O local interrupt status */
-#define	COMEM_I2OLIMR	0x003c		/* I2O local interrupt mask */
-#define	COMEM_IBFPFIFO	0x0040		/* I2O inbound free/post FIFO */
-#define	COMEM_OBPFFIFO	0x0044		/* I2O outbound post/free FIFO */
-#define	COMEM_IBPFFIFO	0x0048		/* I2O inbound post/free FIFO */
-#define	COMEM_OBFPFIFO	0x004c		/* I2O outbound free/post FIFO */
-
-#define	COMEM_DAHBASE	0x0460		/* Direct access base address */
-
-#define	COMEM_NVCMD	0x04a0		/* I2C serial command */
-#define	COMEM_NVREAD	0x04a4		/* I2C serial read */
-#define	COMEM_NVSTAT	0x04a8		/* I2C status */
-
-#define	COMEM_DMALBASE	0x04b0		/* DMA local base address */
-#define	COMEM_DMAHBASE	0x04b4		/* DMA host base address */
-#define	COMEM_DMASIZE	0x04b8		/* DMA size */
-#define	COMEM_DMACTL	0x04bc		/* DMA control */
-
-#define	COMEM_HCTL	0x04e0		/* Host control */
-#define	COMEM_HINT	0x04e4		/* Host interrupt control/status */
-#define	COMEM_HLDATA	0x04e8		/* Host to local data mailbox */
-#define	COMEM_LINT	0x04f4		/* Local interrupt contole status */
-#define	COMEM_LHDATA	0x04f8		/* Local to host data mailbox */
-
-#define	COMEM_LBUSCFG	0x04fc		/* Local bus configuration */
-
-
-/*
- *	Commands and flags for use with Direct Access Register.
- */
-#define	COMEM_DA_IACK	0x00000000	/* Interrupt acknowledge (read) */
-#define	COMEM_DA_SPCL	0x00000010	/* Special cycle (write) */
-#define	COMEM_DA_MEMRD	0x00000004	/* Memory read cycle */
-#define	COMEM_DA_MEMWR	0x00000004	/* Memory write cycle */
-#define	COMEM_DA_IORD	0x00000002	/* I/O read cycle */
-#define	COMEM_DA_IOWR	0x00000002	/* I/O write cycle */
-#define	COMEM_DA_CFGRD	0x00000006	/* Configuration read cycle */
-#define	COMEM_DA_CFGWR	0x00000006	/* Configuration write cycle */
-
-#define	COMEM_DA_ADDR(a)	((a) & 0xffffe000)
-
-#define	COMEM_DA_OFFSET(a)	((a) & 0x00001fff)
-
-
-/*
- *	The PCI bus will be limited in what slots will actually be used.
- *	Define valid device numbers for different boards.
- */
-#if defined(CONFIG_M5407C3)
-#define	COMEM_MINDEV	14		/* Minimum valid DEVICE */
-#define	COMEM_MAXDEV	14		/* Maximum valid DEVICE */
-#define	COMEM_BRIDGEDEV	15		/* Slot bridge is in */
-#else
-#define	COMEM_MINDEV	0		/* Minimum valid DEVICE */
-#define	COMEM_MAXDEV	3		/* Maximum valid DEVICE */
-#endif
-
-#define	COMEM_MAXPCI	(COMEM_MAXDEV+1)	/* Maximum PCI devices */
-
-
-/****************************************************************************/
-#endif	/* anchor_h */
diff --git a/arch/m68knommu/include/asm/elia.h b/arch/m68knommu/include/asm/elia.h
deleted file mode 100644
index e037d4e..0000000
--- a/arch/m68knommu/include/asm/elia.h
+++ /dev/null
@@ -1,41 +0,0 @@
-/****************************************************************************/
-
-/*
- *	elia.h -- Lineo (formerly Moreton Bay) eLIA platform support.
- *
- *	(C) Copyright 1999-2000, Moreton Bay (www.moreton.com.au)
- *	(C) Copyright 1999-2000, Lineo (www.lineo.com)
- */
-
-/****************************************************************************/
-#ifndef	elia_h
-#define	elia_h
-/****************************************************************************/
-
-#include <asm/coldfire.h>
-
-#ifdef CONFIG_eLIA
-
-/*
- *	The serial port DTR and DCD lines are also on the Parallel I/O
- *	as well, so define those too.
- */
-
-#define	eLIA_DCD1		0x0001
-#define	eLIA_DCD0		0x0002
-#define	eLIA_DTR1		0x0004
-#define	eLIA_DTR0		0x0008
-
-#define	eLIA_PCIRESET		0x0020
-
-/*
- *	Kernel macros to set and unset the LEDs.
- */
-#ifndef __ASSEMBLY__
-extern unsigned short	ppdata;
-#endif /* __ASSEMBLY__ */
-
-#endif	/* CONFIG_eLIA */
-
-/****************************************************************************/
-#endif	/* elia_h */
diff --git a/arch/m68knommu/include/asm/mcfpci.h b/arch/m68knommu/include/asm/mcfpci.h
deleted file mode 100644
index f1507dd..0000000
--- a/arch/m68knommu/include/asm/mcfpci.h
+++ /dev/null
@@ -1,119 +0,0 @@
-/****************************************************************************/
-
-/*
- *	mcfpci.h -- PCI bridge on ColdFire eval boards.
- *
- *	(C) Copyright 2000, Greg Ungerer (gerg@snapgear.com)
- *	(C) Copyright 2000, Lineo Inc. (www.lineo.com)
- */
-
-/****************************************************************************/
-#ifndef	mcfpci_h
-#define	mcfpci_h
-/****************************************************************************/
-
-
-#ifdef CONFIG_PCI
-
-/*
- *	Address regions in the PCI address space are not mapped into the
- *	normal memory space of the ColdFire. They must be accessed via
- *	handler routines. This is easy for I/O space (inb/outb/etc) but
- *	needs some code changes to support ordinary memory. Interrupts
- *	also need to be vectored through the PCI handler first, then it
- *	will call the actual driver sub-handlers.
- */
-
-/*
- *	Un-define all the standard I/O access routines.
- */
-#undef	inb
-#undef	inw
-#undef	inl
-#undef	inb_p
-#undef	inw_p
-#undef	insb
-#undef	insw
-#undef	insl
-#undef	outb
-#undef	outw
-#undef	outl
-#undef	outb_p
-#undef	outw_p
-#undef	outsb
-#undef	outsw
-#undef	outsl
-
-#undef	request_irq
-#undef	free_irq
-
-#undef	bus_to_virt
-#undef	virt_to_bus
-
-
-/*
- *	Re-direct all I/O memory accesses functions to PCI specific ones.
- */
-#define	inb	pci_inb
-#define	inw	pci_inw
-#define	inl	pci_inl
-#define	inb_p	pci_inb
-#define	inw_p	pci_inw
-#define	insb	pci_insb
-#define	insw	pci_insw
-#define	insl	pci_insl
-
-#define	outb	pci_outb
-#define	outw	pci_outw
-#define	outl	pci_outl
-#define	outb_p	pci_outb
-#define	outw_p	pci_outw
-#define	outsb	pci_outsb
-#define	outsw	pci_outsw
-#define	outsl	pci_outsl
-
-#define	request_irq	pci_request_irq
-#define	free_irq	pci_free_irq
-
-#define	virt_to_bus	pci_virt_to_bus
-#define	bus_to_virt	pci_bus_to_virt
-
-#define	CONFIG_COMEMPCI	1
-
-
-/*
- *	Prototypes of the real PCI functions (defined in bios32.c).
- */
-unsigned char	pci_inb(unsigned int addr);
-unsigned short	pci_inw(unsigned int addr);
-unsigned int	pci_inl(unsigned int addr);
-void		pci_insb(void *addr, void *buf, int len);
-void		pci_insw(void *addr, void *buf, int len);
-void		pci_insl(void *addr, void *buf, int len);
-
-void		pci_outb(unsigned char val, unsigned int addr);
-void		pci_outw(unsigned short val, unsigned int addr);
-void		pci_outl(unsigned int val, unsigned int addr);
-void		pci_outsb(void *addr, void *buf, int len);
-void		pci_outsw(void *addr, void *buf, int len);
-void		pci_outsl(void *addr, void *buf, int len);
-
-int		pci_request_irq(unsigned int irq,
-			void (*handler)(int, void *, struct pt_regs *),
-			unsigned long flags,
-			const char *device,
-			void *dev_id);
-void		pci_free_irq(unsigned int irq, void *dev_id);
-
-void		*pci_bmalloc(int size);
-void		pci_bmfree(void *bmp, int len);
-void		pci_copytoshmem(unsigned long bmp, void *src, int size);
-void		pci_copyfromshmem(void *dst, unsigned long bmp, int size);
-unsigned long	pci_virt_to_bus(volatile void *address);
-void		*pci_bus_to_virt(unsigned long address);
-void		pci_bmcpyto(void *dst, void *src, int len);
-void		pci_bmcpyfrom(void *dst, void *src, int len);
-
-#endif /* CONFIG_PCI */
-/****************************************************************************/
-#endif	/* mcfpci_h */
diff --git a/arch/m68knommu/include/asm/pci.h b/arch/m68knommu/include/asm/pci.h
index a13f3cc..8031d1d 100644
--- a/arch/m68knommu/include/asm/pci.h
+++ b/arch/m68knommu/include/asm/pci.h
@@ -3,27 +3,4 @@
 
 #include <asm-m68k/pci.h>
 
-#ifdef CONFIG_COMEMPCI
-/*
- *	These are pretty much arbitary with the CoMEM implementation.
- *	We have the whole address space to ourselves.
- */
-#define PCIBIOS_MIN_IO		0x100
-#define PCIBIOS_MIN_MEM		0x00010000
-
-#define pcibios_scan_all_fns(a, b)	0
-
-/*
- * Return whether the given PCI device DMA address mask can
- * be supported properly.  For example, if your device can
- * only drive the low 24-bits during PCI bus mastering, then
- * you would pass 0x00ffffff as the mask to this function.
- */
-static inline int pci_dma_supported(struct pci_dev *hwdev, u64 mask)
-{
-	return 1;
-}
-
-#endif /* CONFIG_COMEMPCI */
-
 #endif /* M68KNOMMU_PCI_H */
diff --git a/arch/m68knommu/kernel/Makefile b/arch/m68knommu/kernel/Makefile
index f0eab3d..37c3fc0 100644
--- a/arch/m68knommu/kernel/Makefile
+++ b/arch/m68knommu/kernel/Makefile
@@ -8,4 +8,3 @@ obj-y += dma.o entry.o init_task.o irq.o m68k_ksyms.o process.o ptrace.o \
 	 setup.o signal.o syscalltable.o sys_m68k.o time.o traps.o
 
 obj-$(CONFIG_MODULES)	+= module.o
-obj-$(CONFIG_COMEMPCI)	+= comempci.o
diff --git a/arch/m68knommu/kernel/comempci.c b/arch/m68knommu/kernel/comempci.c
deleted file mode 100644
index 0a68b5a..0000000
--- a/arch/m68knommu/kernel/comempci.c
+++ /dev/null
@@ -1,980 +0,0 @@
-/*****************************************************************************/
-
-/*
- *	comemlite.c -- PCI access code for embedded CO-MEM Lite PCI controller.
- *
- *	(C) Copyright 1999-2003, Greg Ungerer (gerg@snapgear.com).
- *	(C) Copyright 2000, Lineo (www.lineo.com)
- */
-
-/*****************************************************************************/
-
-#include <linux/kernel.h>
-#include <linux/types.h>
-#include <linux/pci.h>
-#include <linux/ptrace.h>
-#include <linux/spinlock.h>
-#include <linux/interrupt.h>
-#include <linux/sched.h>
-#include <asm/coldfire.h>
-#include <asm/mcfsim.h>
-#include <asm/irq.h>
-#include <asm/anchor.h>
-
-#ifdef CONFIG_eLIA
-#include <asm/elia.h>
-#endif
-
-/*****************************************************************************/
-
-/*
- *	Debug configuration defines. DEBUGRES sets debugging output for
- *	the resource allocation phase. DEBUGPCI traces on pcibios_ function
- *	calls, and DEBUGIO traces all accesses to devices on the PCI bus.
- */
-/*#define	DEBUGRES	1*/
-/*#define	DEBUGPCI	1*/
-/*#define	DEBUGIO		1*/
-
-/*****************************************************************************/
-
-/*
- *	PCI markers for bus present and active slots.
- */
-int		pci_bus_is_present = 0;
-unsigned long	pci_slotmask = 0;
-
-/*
- *	We may or may not need to swap the bytes of PCI bus tranfers.
- *	The endianess is re-roder automatically by the CO-MEM, but it
- *	will get the wrong byte order for a pure data stream.
- */
-#define	pci_byteswap	0
-
-
-/*
- *	Resource tracking. The CO-MEM part creates a virtual address
- *	space that all the PCI devices live in - it is not in any way
- *	directly mapped into the ColdFire address space. So we can
- *	really assign any resources we like to devices, as long as
- *	they do not clash with other PCI devices.
- */
-unsigned int	pci_iobase = PCIBIOS_MIN_IO;	/* Arbitrary start address */
-unsigned int	pci_membase = PCIBIOS_MIN_MEM;	/* Arbitrary start address */
-
-#define	PCI_MINIO	0x100			/* 256 byte minimum I/O */
-#define	PCI_MINMEM	0x00010000		/* 64k minimum chunk */
-
-/*
- *	The CO-MEM's shared memory segment is visible inside the PCI
- *	memory address space. We need to keep track of the address that
- *	this is mapped at, to setup the bus masters pointers.
- */
-unsigned int	pci_shmemaddr;
-
-/*****************************************************************************/
-
-void	pci_interrupt(int irq, void *id, struct pt_regs *fp);
-
-/*****************************************************************************/
-
-/*
- *	Some platforms have custom ways of reseting the PCI bus.
- */
-
-void pci_resetbus(void)
-{
-#ifdef CONFIG_eLIA
-	int	i;
-
-#ifdef DEBUGPCI
-	printk(KERN_DEBUG "pci_resetbus()\n");
-#endif
-
-	*((volatile unsigned short *) (MCF_MBAR+MCFSIM_PADDR)) |= eLIA_PCIRESET;
-	for (i = 0; (i < 1000); i++) {
-		*((volatile unsigned short *) (MCF_MBAR + MCFSIM_PADAT)) = 
-			(ppdata | eLIA_PCIRESET);
-	}
-
-
-	*((volatile unsigned short *) (MCF_MBAR + MCFSIM_PADAT)) = ppdata;
-#endif
-}
-
-/*****************************************************************************/
-
-int pcibios_assign_resource_slot(int slot)
-{
-	volatile unsigned long	*rp;
-	volatile unsigned char	*ip;
-	unsigned int		idsel, addr, val, align, i;
-	int			bar;
-
-#ifdef DEBUGPCI
-	printk(KERN_INFO "pcibios_assign_resource_slot(slot=%x)\n", slot);
-#endif
-
-	rp = (volatile unsigned long *) COMEM_BASE;
-	idsel = COMEM_DA_ADDR(0x1 << (slot + 16));
-
-	/* Try to assign resource to each BAR */
-	for (bar = 0; (bar < 6); bar++) {
-		addr = COMEM_PCIBUS + PCI_BASE_ADDRESS_0 + (bar * 4);
-		rp[LREG(COMEM_DAHBASE)] = COMEM_DA_CFGRD | idsel;
-		val = rp[LREG(addr)];
-#ifdef DEBUGRES
-		printk(KERN_DEBUG "-----------------------------------"
-			"-------------------------------------\n");
-		printk(KERN_DEBUG "BAR[%d]: read=%08x ", bar, val);
-#endif
-
-		rp[LREG(COMEM_DAHBASE)] = COMEM_DA_CFGWR | idsel;
-		rp[LREG(addr)] = 0xffffffff;
-
-		rp[LREG(COMEM_DAHBASE)] = COMEM_DA_CFGRD | idsel;
-		val = rp[LREG(addr)];
-#ifdef DEBUGRES
-		printk(KERN_DEBUG "write=%08x ", val);
-#endif
-		if (val == 0) {
-#ifdef DEBUGRES
-			printk(KERN_DEBUG "\n");
-#endif
-			continue;
-		}
-
-		/* Determine space required by BAR */
-		/* FIXME: this should go backwords from 0x80000000... */
-		for (i = 0; (i < 32); i++) {
-			if ((0x1 << i) & (val & 0xfffffffc))
-				break;
-		}
-
-#ifdef DEBUGRES
-		printk(KERN_DEBUG "size=%08x(%d)\n", (0x1 << i), i);
-#endif
-		i = 0x1 << i;
-
-		/* Assign a resource */
-		if (val & PCI_BASE_ADDRESS_SPACE_IO) {
-			if (i < PCI_MINIO)
-				i = PCI_MINIO;
-#ifdef DEBUGRES
-			printk(KERN_DEBUG "BAR[%d]: IO size=%08x iobase=%08x\n",
-				bar, i, pci_iobase);
-#endif
-			if (i > 0xffff) {
-				/* Invalid size?? */
-				val = 0 | PCI_BASE_ADDRESS_SPACE_IO;
-#ifdef DEBUGRES
-				printk(KERN_DEBUG "BAR[%d]: too big for IO??\n", bar);
-#endif
-			} else {
-				/* Check for un-alignment */
-				if ((align = pci_iobase % i))
-					pci_iobase += (i - align);
-				val = pci_iobase | PCI_BASE_ADDRESS_SPACE_IO;
-				pci_iobase += i;
-			}
-		} else {
-			if (i < PCI_MINMEM)
-				i = PCI_MINMEM;
-#ifdef DEBUGRES
-			printk(KERN_DEBUG "BAR[%d]: MEMORY size=%08x membase=%08x\n",
-				bar, i, pci_membase);
-#endif
-			/* Check for un-alignment */
-			if ((align = pci_membase % i))
-				pci_membase += (i - align);
-			val = pci_membase | PCI_BASE_ADDRESS_SPACE_MEMORY;
-			pci_membase += i;
-		}
-
-		/* Write resource back into BAR register */
-		rp[LREG(COMEM_DAHBASE)] = COMEM_DA_CFGWR | idsel;
-		rp[LREG(addr)] = val;
-#ifdef DEBUGRES
-		printk(KERN_DEBUG "BAR[%d]: assigned bar=%08x\n", bar, val);
-#endif
-	}
-
-#ifdef DEBUGRES
-	printk(KERN_DEBUG "-----------------------------------"
-			"-------------------------------------\n");
-#endif
-
-	/* Assign IRQ if one is wanted... */
-	ip = (volatile unsigned char *) (COMEM_BASE + COMEM_PCIBUS);
-	rp[LREG(COMEM_DAHBASE)] = COMEM_DA_CFGRD | idsel;
-
-	addr = (PCI_INTERRUPT_PIN & 0xfc) + (~PCI_INTERRUPT_PIN & 0x03);
-	if (ip[addr]) {
-		rp[LREG(COMEM_DAHBASE)] = COMEM_DA_CFGWR | idsel;
-		addr = (PCI_INTERRUPT_LINE & 0xfc)+(~PCI_INTERRUPT_LINE & 0x03);
-		ip[addr] = 25;
-#ifdef DEBUGRES
-		printk(KERN_DEBUG "IRQ LINE=25\n");
-#endif
-	}
-
-	return(0);
-}
-
-/*****************************************************************************/
-
-int pcibios_enable_slot(int slot)
-{
-	volatile unsigned long	*rp;
-	volatile unsigned short	*wp;
-	unsigned int		idsel, addr;
-	unsigned short		cmd;
-
-#ifdef DEBUGPCI
-	printk(KERN_DEBUG "pcibios_enbale_slot(slot=%x)\n", slot);
-#endif
-
-	rp = (volatile unsigned long *) COMEM_BASE;
-	wp = (volatile unsigned short *) COMEM_BASE;
-	idsel = COMEM_DA_ADDR(0x1 << (slot + 16));
-
-	/* Get current command settings */
-	addr = COMEM_PCIBUS + PCI_COMMAND;
-	addr = (addr & ~0x3) + (~addr & 0x02);
-	rp[LREG(COMEM_DAHBASE)] = COMEM_DA_CFGRD | idsel;
-	cmd = wp[WREG(addr)];
-	/*val = ((val & 0xff) << 8) | ((val >> 8) & 0xff);*/
-
-	/* Enable I/O and memory accesses to this device */
-	rp[LREG(COMEM_DAHBASE)] = COMEM_DA_CFGWR | idsel;
-	cmd |= PCI_COMMAND_IO | PCI_COMMAND_MEMORY | PCI_COMMAND_MASTER;
-	wp[WREG(addr)] = cmd;
-
-	return(0);
-}
-
-/*****************************************************************************/
-
-void pcibios_assign_resources(void)
-{
-	volatile unsigned long	*rp;
-	unsigned long		sel, id;
-	int			slot;
-
-	rp = (volatile unsigned long *) COMEM_BASE;
-
-	/*
-	 *	Do a quick scan of the PCI bus and see what is here.
-	 */
-	for (slot = COMEM_MINDEV; (slot <= COMEM_MAXDEV); slot++) {
-		sel = COMEM_DA_CFGRD | COMEM_DA_ADDR(0x1 << (slot + 16));
-		rp[LREG(COMEM_DAHBASE)] = sel;
-		rp[LREG(COMEM_PCIBUS)] = 0; /* Clear bus */
-		id = rp[LREG(COMEM_PCIBUS)];
-		if ((id != 0) && ((id & 0xffff0000) != (sel & 0xffff0000))) {
-			printk(KERN_INFO "PCI: slot=%d id=%08x\n", slot, (int) id);
-			pci_slotmask |= 0x1 << slot;
-			pcibios_assign_resource_slot(slot);
-			pcibios_enable_slot(slot);
-		}
-	}
-}
-
-/*****************************************************************************/
-
-int pcibios_init(void)
-{
-	volatile unsigned long	*rp;
-	unsigned long		sel, id;
-	int			slot;
-
-#ifdef DEBUGPCI
-	printk(KERN_DEBUG "pcibios_init()\n");
-#endif
-
-	pci_resetbus();
-
-	/*
-	 *	Do some sort of basic check to see if the CO-MEM part
-	 *	is present... This works ok, but I think we really need
-	 *	something better...
-	 */
-	rp = (volatile unsigned long *) COMEM_BASE;
-	if ((rp[LREG(COMEM_LBUSCFG)] & 0xff) != 0x50) {
-		printk(KERN_INFO "PCI: no PCI bus present\n");
-		return(0);
-	}
-
-#ifdef COMEM_BRIDGEDEV
-	/*
-	 *	Setup the PCI bridge device first. It needs resources too,
-	 *	so that bus masters can get to its shared memory.
-	 */
-	slot = COMEM_BRIDGEDEV;
-	sel = COMEM_DA_CFGRD | COMEM_DA_ADDR(0x1 << (slot + 16));
-	rp[LREG(COMEM_DAHBASE)] = sel;
-	rp[LREG(COMEM_PCIBUS)] = 0; /* Clear bus */
-	id = rp[LREG(COMEM_PCIBUS)];
-	if ((id == 0) || ((id & 0xffff0000) == (sel & 0xffff0000))) {
-		printk(KERN_INFO "PCI: no PCI bus bridge present\n");
-		return(0);
-	}
-
-	printk(KERN_INFO "PCI: bridge device at slot=%d id=%08x\n", slot, (int) id);
-	pci_slotmask |= 0x1 << slot;
-	pci_shmemaddr = pci_membase;
-	pcibios_assign_resource_slot(slot);
-	pcibios_enable_slot(slot);
-#endif
-
-	pci_bus_is_present = 1;
-
-	/* Get PCI irq for local vectoring */
-	if (request_irq(COMEM_IRQ, pci_interrupt, 0, "PCI bridge", NULL)) {
-		printk(KERN_WARNING "PCI: failed to acquire interrupt %d\n", COMEM_IRQ);
-	} else {
-		mcf_autovector(COMEM_IRQ);
-	}
-
-	pcibios_assign_resources();
-
-	return(0);
-}
-
-/*****************************************************************************/
-
-char *pcibios_setup(char *option)
-{
-	/* Nothing for us to handle. */
-	return(option);
-}
-/*****************************************************************************/
-
-void pcibios_fixup_bus(struct pci_bus *b)
-{
-}
-
-/*****************************************************************************/
-
-void pcibios_align_resource(void *data, struct resource *res,
-				resource_size_t size, resource_size_t align)
-{
-}
-
-/*****************************************************************************/
-
-int pcibios_enable_device(struct pci_dev *dev, int mask)
-{
-	int slot;
-
-	slot = PCI_SLOT(dev->devfn);
-	if ((dev->bus == 0) && (pci_slotmask & (1 << slot)))
-		pcibios_enable_slot(slot);
-	return(0);
-}
-
-/*****************************************************************************/
-
-/*
- *	Local routines to interrcept the standard I/O and vector handling
- *	code. Don't include this 'till now - initialization code above needs
- *	access to the real code too.
- */
-#include <asm/mcfpci.h>
-
-/*****************************************************************************/
-
-void pci_outb(unsigned char val, unsigned int addr)
-{
-	volatile unsigned long	*rp;
-	volatile unsigned char	*bp;
-
-#ifdef DEBUGIO
-	printk(KERN_DEBUG "pci_outb(val=%02x,addr=%x)\n", val, addr);
-#endif
-
-	rp = (volatile unsigned long *) COMEM_BASE;
-	bp = (volatile unsigned char *) COMEM_BASE;
-	rp[LREG(COMEM_DAHBASE)] = COMEM_DA_IOWR | COMEM_DA_ADDR(addr);
-	addr = (addr & ~0x3) + (~addr & 0x03);
-	bp[(COMEM_PCIBUS + COMEM_DA_OFFSET(addr))] = val;
-}
-
-/*****************************************************************************/
-
-void pci_outw(unsigned short val, unsigned int addr)
-{
-	volatile unsigned long	*rp;
-	volatile unsigned short	*sp;
-
-#ifdef DEBUGIO
-	printk(KERN_DEBUG "pci_outw(val=%04x,addr=%x)\n", val, addr);
-#endif
-
-	rp = (volatile unsigned long *) COMEM_BASE;
-	sp = (volatile unsigned short *) COMEM_BASE;
-	rp[LREG(COMEM_DAHBASE)] = COMEM_DA_IOWR | COMEM_DA_ADDR(addr);
-	addr = (addr & ~0x3) + (~addr & 0x02);
-	if (pci_byteswap)
-		val = ((val & 0xff) << 8) | ((val >> 8) & 0xff);
-	sp[WREG(COMEM_PCIBUS + COMEM_DA_OFFSET(addr))] = val;
-}
-
-/*****************************************************************************/
-
-void pci_outl(unsigned int val, unsigned int addr)
-{
-	volatile unsigned long	*rp;
-	volatile unsigned int	*lp;
-
-#ifdef DEBUGIO
-	printk(KERN_DEBUG "pci_outl(val=%08x,addr=%x)\n", val, addr);
-#endif
-
-	rp = (volatile unsigned long *) COMEM_BASE;
-	lp = (volatile unsigned int *) COMEM_BASE;
-	rp[LREG(COMEM_DAHBASE)] = COMEM_DA_IOWR | COMEM_DA_ADDR(addr);
-
-	if (pci_byteswap)
-		val = (val << 24) | ((val & 0x0000ff00) << 8) |
-			((val & 0x00ff0000) >> 8) | (val >> 24);
-
-	lp[LREG(COMEM_PCIBUS + COMEM_DA_OFFSET(addr))] = val;
-}
-
-/*****************************************************************************/
-
-unsigned long	pci_blmask[] = {
-	0x000000e0,
-	0x000000d0,
-	0x000000b0,
-	0x00000070
-};
-
-unsigned char pci_inb(unsigned int addr)
-{
-	volatile unsigned long	*rp;
-	volatile unsigned char	*bp;
-	unsigned long		r;
-	unsigned char		val;
-
-#ifdef DEBUGIO
-	printk(KERN_DEBUG "pci_inb(addr=%x)\n", addr);
-#endif
-
-	rp = (volatile unsigned long *) COMEM_BASE;
-	bp = (volatile unsigned char *) COMEM_BASE;
-
-	r = COMEM_DA_IORD | COMEM_DA_ADDR(addr) | pci_blmask[(addr & 0x3)];
-	rp[LREG(COMEM_DAHBASE)] = r;
-
-	addr = (addr & ~0x3) + (~addr & 0x3);
-	val = bp[(COMEM_PCIBUS + COMEM_DA_OFFSET(addr))];
-	return(val);
-}
-
-/*****************************************************************************/
-
-unsigned long	pci_bwmask[] = {
-	0x000000c0,
-	0x000000c0,
-	0x00000030,
-	0x00000030
-};
-
-unsigned short pci_inw(unsigned int addr)
-{
-	volatile unsigned long	*rp;
-	volatile unsigned short	*sp;
-	unsigned long		r;
-	unsigned short		val;
-
-#ifdef DEBUGIO
-	printk(KERN_DEBUG "pci_inw(addr=%x)", addr);
-#endif
-
-	rp = (volatile unsigned long *) COMEM_BASE;
-	r = COMEM_DA_IORD | COMEM_DA_ADDR(addr) | pci_bwmask[(addr & 0x3)];
-	rp[LREG(COMEM_DAHBASE)] = r;
-
-	sp = (volatile unsigned short *) COMEM_BASE;
-	addr = (addr & ~0x3) + (~addr & 0x02);
-	val = sp[WREG(COMEM_PCIBUS + COMEM_DA_OFFSET(addr))];
-	if (pci_byteswap)
-		val = ((val & 0xff) << 8) | ((val >> 8) & 0xff);
-#ifdef DEBUGIO
-	printk(KERN_DEBUG "=%04x\n", val);
-#endif
-	return(val);
-}
-
-/*****************************************************************************/
-
-unsigned int pci_inl(unsigned int addr)
-{
-	volatile unsigned long	*rp;
-	volatile unsigned int	*lp;
-	unsigned int		val;
-
-#ifdef DEBUGIO
-	printk(KERN_DEBUG "pci_inl(addr=%x)", addr);
-#endif
-
-	rp = (volatile unsigned long *) COMEM_BASE;
-	lp = (volatile unsigned int *) COMEM_BASE;
-	rp[LREG(COMEM_DAHBASE)] = COMEM_DA_IORD | COMEM_DA_ADDR(addr);
-	val = lp[LREG(COMEM_PCIBUS + COMEM_DA_OFFSET(addr))];
-
-	if (pci_byteswap)
-		val = (val << 24) | ((val & 0x0000ff00) << 8) |
-			((val & 0x00ff0000) >> 8) | (val >> 24);
-
-#ifdef DEBUGIO
-	printk(KERN_DEBUG "=%08x\n", val);
-#endif
-	return(val);
-}
-
-/*****************************************************************************/
-
-void pci_outsb(void *addr, void *buf, int len)
-{
-	volatile unsigned long	*rp;
-	volatile unsigned char	*bp;
-	unsigned char		*dp = (unsigned char *) buf;
-	unsigned int		a = (unsigned int) addr;
-
-#ifdef DEBUGIO
-	printk(KERN_DEBUG "pci_outsb(addr=%x,buf=%x,len=%d)\n", (int)addr, (int)buf, len);
-#endif
-
-	rp = (volatile unsigned long *) COMEM_BASE;
-	rp[LREG(COMEM_DAHBASE)] = COMEM_DA_IOWR | COMEM_DA_ADDR(a);
-
-	a = (a & ~0x3) + (~a & 0x03);
-	bp = (volatile unsigned char *)
-		(COMEM_BASE + COMEM_PCIBUS + COMEM_DA_OFFSET(a));
-
-	while (len--)
-		*bp = *dp++;
-}
-
-/*****************************************************************************/
-
-void pci_outsw(void *addr, void *buf, int len)
-{
-	volatile unsigned long	*rp;
-	volatile unsigned short	*wp;
-	unsigned short		w, *dp = (unsigned short *) buf;
-	unsigned int		a = (unsigned int) addr;
-
-#ifdef DEBUGIO
-	printk(KERN_DEBUG "pci_outsw(addr=%x,buf=%x,len=%d)\n", (int)addr, (int)buf, len);
-#endif
-
-	rp = (volatile unsigned long *) COMEM_BASE;
-	rp[LREG(COMEM_DAHBASE)] = COMEM_DA_IOWR | COMEM_DA_ADDR(a);
-
-	a = (a & ~0x3) + (~a & 0x2);
-	wp = (volatile unsigned short *)
-		(COMEM_BASE + COMEM_PCIBUS + COMEM_DA_OFFSET(a));
-
-	while (len--) {
-		w = *dp++;
-		if (pci_byteswap)
-			w = ((w & 0xff) << 8) | ((w >> 8) & 0xff);
-		*wp = w;
-	}
-}
-
-/*****************************************************************************/
-
-void pci_outsl(void *addr, void *buf, int len)
-{
-	volatile unsigned long	*rp;
-	volatile unsigned long	*lp;
-	unsigned long		l, *dp = (unsigned long *) buf;
-	unsigned int		a = (unsigned int) addr;
-
-#ifdef DEBUGIO
-	printk(KERN_DEBUG "pci_outsl(addr=%x,buf=%x,len=%d)\n", (int)addr, (int)buf, len);
-#endif
-
-	rp = (volatile unsigned long *) COMEM_BASE;
-	rp[LREG(COMEM_DAHBASE)] = COMEM_DA_IOWR | COMEM_DA_ADDR(a);
-
-	lp = (volatile unsigned long *)
-		(COMEM_BASE + COMEM_PCIBUS + COMEM_DA_OFFSET(a));
-
-	while (len--) {
-		l = *dp++;
-		if (pci_byteswap)
-			l = (l << 24) | ((l & 0x0000ff00) << 8) |
-				((l & 0x00ff0000) >> 8) | (l >> 24);
-		*lp = l;
-	}
-}
-
-/*****************************************************************************/
-
-void pci_insb(void *addr, void *buf, int len)
-{
-	volatile unsigned long	*rp;
-	volatile unsigned char	*bp;
-	unsigned char		*dp = (unsigned char *) buf;
-	unsigned int		a = (unsigned int) addr;
-
-#ifdef DEBUGIO
-	printk(KERN_DEBUG "pci_insb(addr=%x,buf=%x,len=%d)\n", (int)addr, (int)buf, len);
-#endif
-
-	rp = (volatile unsigned long *) COMEM_BASE;
-	rp[LREG(COMEM_DAHBASE)] = COMEM_DA_IORD | COMEM_DA_ADDR(a);
-
-	a = (a & ~0x3) + (~a & 0x03);
-	bp = (volatile unsigned char *)
-		(COMEM_BASE + COMEM_PCIBUS + COMEM_DA_OFFSET(a));
-
-	while (len--)
-		*dp++ = *bp;
-}
-
-/*****************************************************************************/
-
-void pci_insw(void *addr, void *buf, int len)
-{
-	volatile unsigned long	*rp;
-	volatile unsigned short	*wp;
-	unsigned short		w, *dp = (unsigned short *) buf;
-	unsigned int		a = (unsigned int) addr;
-
-#ifdef DEBUGIO
-	printk(KERN_DEBUG "pci_insw(addr=%x,buf=%x,len=%d)\n", (int)addr, (int)buf, len);
-#endif
-
-	rp = (volatile unsigned long *) COMEM_BASE;
-	rp[LREG(COMEM_DAHBASE)] = COMEM_DA_IORD | COMEM_DA_ADDR(a);
-
-	a = (a & ~0x3) + (~a & 0x2);
-	wp = (volatile unsigned short *)
-		(COMEM_BASE + COMEM_PCIBUS + COMEM_DA_OFFSET(a));
-
-	while (len--) {
-		w = *wp;
-		if (pci_byteswap)
-			w = ((w & 0xff) << 8) | ((w >> 8) & 0xff);
-		*dp++ = w;
-	}
-}
-
-/*****************************************************************************/
-
-void pci_insl(void *addr, void *buf, int len)
-{
-	volatile unsigned long	*rp;
-	volatile unsigned long	*lp;
-	unsigned long		l, *dp = (unsigned long *) buf;
-	unsigned int		a = (unsigned int) addr;
-
-#ifdef DEBUGIO
-	printk(KERN_DEBUG "pci_insl(addr=%x,buf=%x,len=%d)\n", (int)addr, (int)buf, len);
-#endif
-
-	rp = (volatile unsigned long *) COMEM_BASE;
-	rp[LREG(COMEM_DAHBASE)] = COMEM_DA_IORD | COMEM_DA_ADDR(a);
-
-	lp = (volatile unsigned long *)
-		(COMEM_BASE + COMEM_PCIBUS + COMEM_DA_OFFSET(a));
-
-	while (len--) {
-		l = *lp;
-		if (pci_byteswap)
-			l = (l << 24) | ((l & 0x0000ff00) << 8) |
-				((l & 0x00ff0000) >> 8) | (l >> 24);
-		*dp++ = l;
-	}
-}
-
-/*****************************************************************************/
-
-struct pci_localirqlist {
-	void		(*handler)(int, void *, struct pt_regs *);
-	const char	*device;
-	void		*dev_id;
-};
-
-struct pci_localirqlist	pci_irqlist[COMEM_MAXPCI];
-
-/*****************************************************************************/
-
-int pci_request_irq(unsigned int irq,
-	void (*handler)(int, void *, struct pt_regs *),
-	unsigned long flags, const char *device, void *dev_id)
-{
-	int	i;
-
-#ifdef DEBUGIO
-	printk(KERN_DEBUG "pci_request_irq(irq=%d,handler=%x,flags=%x,device=%s,"
-		"dev_id=%x)\n", irq, (int) handler, (int) flags, device,
-		(int) dev_id);
-#endif
-
-	/* Check if this interrupt handler is already lodged */
-	for (i = 0; (i < COMEM_MAXPCI); i++) {
-		if (pci_irqlist[i].handler == handler)
-			return(0);
-	}
-
-	/* Find a free spot to put this handler */
-	for (i = 0; (i < COMEM_MAXPCI); i++) {
-		if (pci_irqlist[i].handler == 0) {
-			pci_irqlist[i].handler = handler;
-			pci_irqlist[i].device = device;
-			pci_irqlist[i].dev_id = dev_id;
-			return(0);
-		}
-	}
-
-	/* Couldn't fit?? */
-	return(1);
-}
-
-/*****************************************************************************/
-
-void pci_free_irq(unsigned int irq, void *dev_id)
-{
-	int	i;
-
-#ifdef DEBUGIO
-	printk(KERN_DEBUG "pci_free_irq(irq=%d,dev_id=%x)\n", irq, (int) dev_id);
-#endif
-
-	if (dev_id == (void *) NULL)
-		return;
-
-	/* Check if this interrupt handler is lodged */
-	for (i = 0; (i < COMEM_MAXPCI); i++) {
-		if (pci_irqlist[i].dev_id == dev_id) {
-			pci_irqlist[i].handler = NULL;
-			pci_irqlist[i].device = NULL;
-			pci_irqlist[i].dev_id = NULL;
-			break;
-		}
-	}
-}
-
-/*****************************************************************************/
-
-void pci_interrupt(int irq, void *id, struct pt_regs *fp)
-{
-	int	i;
-
-#ifdef DEBUGIO
-	printk(KERN_DEBUG "pci_interrupt(irq=%d,id=%x,fp=%x)\n", irq, (int) id, (int) fp);
-#endif
-
-	for (i = 0; (i < COMEM_MAXPCI); i++) {
-		if (pci_irqlist[i].handler)
-			(*pci_irqlist[i].handler)(irq,pci_irqlist[i].dev_id,fp);
-	}
-}
-
-/*****************************************************************************/
-
-/*
- *	The shared memory region is broken up into contiguous 512 byte
- *	regions for easy allocation... This is not an optimal solution
- *	but it makes allocation and freeing regions really easy.
- */
-
-#define	PCI_MEMSLOTSIZE		512
-#define	PCI_MEMSLOTS		(COMEM_SHMEMSIZE / PCI_MEMSLOTSIZE)
-
-char	pci_shmemmap[PCI_MEMSLOTS];
-
-
-void *pci_bmalloc(int size)
-{
-	int	i, j, nrslots;
-
-#ifdef DEBUGIO
-	printk(KERN_DEBUG "pci_bmalloc(size=%d)\n", size);
-#endif
-
-	if (size <= 0)
-		return((void *) NULL);
-
-	nrslots = (size - 1) / PCI_MEMSLOTSIZE;
-
-	for (i = 0; (i < (PCI_MEMSLOTS-nrslots)); i++) {
-		if (pci_shmemmap[i] == 0) {
-			for (j = i+1; (j < (i+nrslots)); j++) {
-				if (pci_shmemmap[j])
-					goto restart;
-			}
-
-			for (j = i; (j <= i+nrslots); j++)
-				pci_shmemmap[j] = 1;
-			break;
-		}
-restart:
-	}
-
-	return((void *) (COMEM_BASE + COMEM_SHMEM + (i * PCI_MEMSLOTSIZE)));
-}
-
-/*****************************************************************************/
-
-void pci_bmfree(void *mp, int size)
-{
-	int	i, j, nrslots;
-
-#ifdef DEBUGIO
-	printk(KERN_DEBUG "pci_bmfree(mp=%x,size=%d)\n", (int) mp, size);
-#endif
-
-	nrslots = size / PCI_MEMSLOTSIZE;
-	i = (((unsigned long) mp) - (COMEM_BASE + COMEM_SHMEM)) /
-		PCI_MEMSLOTSIZE;
-
-	for (j = i; (j < (i+nrslots)); j++)
-		pci_shmemmap[j] = 0;
-}
-
-/*****************************************************************************/
-
-unsigned long pci_virt_to_bus(volatile void *address)
-{
-	unsigned long	l;
-
-#ifdef DEBUGIO
-	printk(KERN_DEBUG "pci_virt_to_bus(address=%x)", (int) address);
-#endif
-
-	l = ((unsigned long) address) - COMEM_BASE;
-#ifdef DEBUGIO
-	printk(KERN_DEBUG "=%x\n", (int) (l+pci_shmemaddr));
-#endif
-	return(l + pci_shmemaddr);
-}
-
-/*****************************************************************************/
-
-void *pci_bus_to_virt(unsigned long address)
-{
-	unsigned long	l;
-
-#ifdef DEBUGIO
-	printk(KERN_DEBUG "pci_bus_to_virt(address=%x)", (int) address);
-#endif
-
-	l = address - pci_shmemaddr;
-#ifdef DEBUGIO
-	printk(KERN_DEBUG "=%x\n", (int) (address + COMEM_BASE));
-#endif
-	return((void *) (address + COMEM_BASE));
-}
-
-/*****************************************************************************/
-
-void pci_bmcpyto(void *dst, void *src, int len)
-{
-	unsigned long	*dp, *sp, val;
-	unsigned char	*dcp, *scp;
-	int		i, j;
-
-#ifdef DEBUGIO
-	printk(KERN_DEBUG "pci_bmcpyto(dst=%x,src=%x,len=%d)\n", (int)dst, (int)src, len);
-#endif
-
-	dp = (unsigned long *) dst;
-	sp = (unsigned long *) src;
-	i = len >> 2;
-
-#if 0
-	printk(KERN_INFO "DATA:");
-	scp = (unsigned char *) sp;
-	for (i = 0; (i < len); i++) {
-		if ((i % 16) == 0) printk(KERN_INFO "\n%04x: ", i);
-		printk(KERN_INFO "%02x ", *scp++);
-	}
-	printk(KERN_INFO "\n");
-#endif
-
-	for (j = 0; (i >= 0); i--, j++) {
-		val = *sp++;
-		val = (val << 24) | ((val & 0x0000ff00) << 8) |
-			((val & 0x00ff0000) >> 8) | (val >> 24);
-		*dp++ = val;
-	}
-
-	if (len & 0x3) {
-		dcp = (unsigned char *) dp;
-		scp = ((unsigned char *) sp) + 3;
-		for (i = 0; (i < (len & 0x3)); i++)
-			*dcp++ = *scp--;
-	}
-}
-
-/*****************************************************************************/
-
-void pci_bmcpyfrom(void *dst, void *src, int len)
-{
-	unsigned long	*dp, *sp, val;
-	unsigned char	*dcp, *scp;
-	int		i;
-
-#ifdef DEBUGIO
-	printk(KERN_DEBUG "pci_bmcpyfrom(dst=%x,src=%x,len=%d)\n",(int)dst,(int)src,len);
-#endif
-
-	dp = (unsigned long *) dst;
-	sp = (unsigned long *) src;
-	i = len >> 2;
-
-	for (; (i >= 0); i--) {
-		val = *sp++;
-		val = (val << 24) | ((val & 0x0000ff00) << 8) |
-			((val & 0x00ff0000) >> 8) | (val >> 24);
-		*dp++ = val;
-	}
-
-	if (len & 0x3) {
-		dcp = ((unsigned char *) dp) + 3;
-		scp = (unsigned char *) sp;
-		for (i = 0; (i < (len & 0x3)); i++)
-			*dcp++ = *scp--;
-	}
-
-#if 0
-	printk(KERN_INFO "DATA:");
-	dcp = (unsigned char *) dst;
-	for (i = 0; (i < len); i++) {
-		if ((i % 16) == 0) printk(KERN_INFO "\n%04x: ", i);
-		printk(KERN_INFO "%02x ", *dcp++);
-	}
-	printk(KERN_INFO "\n");
-#endif
-}
-
-/*****************************************************************************/
-
-void *pci_alloc_consistent(struct pci_dev *dev, size_t size, dma_addr_t *dma_addr)
-{
-	void *mp;
-	if ((mp = pci_bmalloc(size)) != NULL) {
-		dma_addr = mp - (COMEM_BASE + COMEM_SHMEM);
-		return(mp);
-	}
-	*dma_addr = (dma_addr_t) NULL;
-	return(NULL);
-}
-
-/*****************************************************************************/
-
-void pci_free_consistent(struct pci_dev *dev, size_t size, void *cpu_addr, dma_addr_t dma_addr)
-{
-	pci_bmfree(cpu_addr, size);
-}
-
-/*****************************************************************************/

