Return-Path: <linux-kernel-owner+w=401wt.eu-S1755705AbYC3Wlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755705AbYC3Wlg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 18:41:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755731AbYC3Wkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 18:40:39 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:53769 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755589AbYC3Wkb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 18:40:31 -0400
Date: Mon, 31 Mar 2008 01:40:17 +0300
From: Adrian Bunk <bunk@kernel.org>
To: lethal@linux-sh.org
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC: 2.6 patch] sh: remove the broken SH_MPC1211 support
Message-ID: <20080330224017.GE28445@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SH_MPC1211 has been marked as BROKEN for some time.

Unless someone is working on reviving it now, I'd therefore suggest this 
patch to remove it.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/sh/Kconfig                      |   13 -
 arch/sh/Makefile                     |    1 
 arch/sh/boards/mpc1211/Makefile      |    8 
 arch/sh/boards/mpc1211/pci.c         |  295 ----------------------
 arch/sh/boards/mpc1211/rtc.c         |  136 ----------
 arch/sh/boards/mpc1211/setup.c       |  347 ---------------------------
 arch/sh/tools/mach-types             |    1 
 drivers/ide/Kconfig                  |    2 
 drivers/mtd/maps/Kconfig             |    7 
 drivers/mtd/maps/Makefile            |    1 
 drivers/mtd/maps/mpc1211.c           |   80 ------
 include/asm-sh/keyboard.h            |   13 -
 include/asm-sh/mpc1211/dma.h         |  303 -----------------------
 include/asm-sh/mpc1211/io.h          |   22 -
 include/asm-sh/mpc1211/keyboard.h    |   60 ----
 include/asm-sh/mpc1211/m1543c.h      |  200 ---------------
 include/asm-sh/mpc1211/mc146818rtc.h |    6 
 include/asm-sh/mpc1211/mpc1211.h     |   18 -
 include/asm-sh/mpc1211/pci.h         |   40 ---
 19 files changed, 3 insertions(+), 1550 deletions(-)

e9d259fed328fe9198b20d4090b2e474ab790173 diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 1272048..1eeff2e 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -428,14 +428,6 @@ config SH_DREAMCAST
 	  Select Dreamcast if configuring for a SEGA Dreamcast.
 	  More information at <http://www.linux-sh.org>
 
-config SH_MPC1211
-	bool "Interface MPC1211"
-	depends on CPU_SUBTYPE_SH7751 && BROKEN
-	help
-	  CTP/PCI-SH02 is a CPU module computer that is produced
-	  by Interface Corporation.
-	  More information at <http://www.interface.co.jp>
-
 config SH_SH03
 	bool "Interface CTP/PCI-SH03"
 	depends on CPU_SUBTYPE_SH7751
@@ -636,8 +628,7 @@ source "arch/sh/drivers/Kconfig"
 endmenu
 
 config ISA_DMA_API
-	def_bool y
-	depends on SH_MPC1211
+	bool
 
 menu "Kernel features"
 
@@ -742,7 +733,7 @@ menu "Boot options"
 
 config ZERO_PAGE_OFFSET
 	hex "Zero page offset"
-	default "0x00004000" if SH_MPC1211 || SH_SH03
+	default "0x00004000" if SH_SH03
 	default "0x00010000" if PAGE_SIZE_64KB
 	default "0x00002000" if PAGE_SIZE_8KB
 	default "0x00001000"
diff --git a/arch/sh/Makefile b/arch/sh/Makefile
index cffc92b..312847a 100644
--- a/arch/sh/Makefile
+++ b/arch/sh/Makefile
@@ -109,7 +109,6 @@ machdir-$(CONFIG_SH_7780_SOLUTION_ENGINE)	+= se/7780
 machdir-$(CONFIG_SH_7343_SOLUTION_ENGINE)	+= se/7343
 machdir-$(CONFIG_SH_HP6XX)			+= hp6xx
 machdir-$(CONFIG_SH_DREAMCAST)			+= dreamcast
-machdir-$(CONFIG_SH_MPC1211)			+= mpc1211
 machdir-$(CONFIG_SH_SH03)			+= sh03
 machdir-$(CONFIG_SH_SECUREEDGE5410)		+= snapgear
 machdir-$(CONFIG_SH_RTS7751R2D)			+= renesas/rts7751r2d
diff --git a/arch/sh/boards/mpc1211/Makefile b/arch/sh/boards/mpc1211/Makefile
deleted file mode 100644
index 8cd31b5..0000000
--- a/arch/sh/boards/mpc1211/Makefile
+++ /dev/null
@@ -1,8 +0,0 @@
-#
-# Makefile for the Interface (CTP/PCI/MPC-SH02) specific parts of the kernel
-#
-
-obj-y	 := setup.o rtc.o
-
-obj-$(CONFIG_PCI) += pci.o
-
diff --git a/arch/sh/boards/mpc1211/pci.c b/arch/sh/boards/mpc1211/pci.c
deleted file mode 100644
index 23849f7..0000000
--- a/arch/sh/boards/mpc1211/pci.c
+++ /dev/null
@@ -1,295 +0,0 @@
-/*
- *	Low-Level PCI Support for the MPC-1211(CTP/PCI/MPC-SH02)
- *
- *  (c) 2002-2003 Saito.K & Jeanne
- *
- *  Dustin McIntire (dustin@sensoria.com)
- *	Derived from arch/i386/kernel/pci-*.c which bore the message:
- *	(c) 1999--2000 Martin Mares <mj@ucw.cz>
- *	
- *  May be copied or modified under the terms of the GNU General Public
- *  License.  See linux/COPYING for more information.
- *
- */
-#include <linux/types.h>
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/delay.h>
-#include <linux/pci.h>
-#include <linux/sched.h>
-#include <linux/ioport.h>
-#include <linux/errno.h>
-#include <linux/irq.h>
-#include <linux/interrupt.h>
-
-#include <asm/machvec.h>
-#include <asm/io.h>
-#include <asm/mpc1211/pci.h>
-
-static struct resource mpcpci_io_resource = {
-	"MPCPCI IO",
-	0x00000000,
-	0xffffffff,
-	IORESOURCE_IO
-};
-
-static struct resource mpcpci_mem_resource = {
-	"MPCPCI mem",
-	0x00000000,
-	0xffffffff,
-	IORESOURCE_MEM
-};
-
-static struct pci_ops pci_direct_conf1;
-struct pci_channel board_pci_channels[] = {
-	{&pci_direct_conf1, &mpcpci_io_resource, &mpcpci_mem_resource, 0, 256},
-	{NULL, NULL, NULL, 0, 0},
-};
-
-/*
- * Direct access to PCI hardware...
- */
-
-
-#define CONFIG_CMD(bus, devfn, where) (0x80000000 | (bus->number << 16) | (devfn << 8) | (where & ~3))
-
-/*
- * Functions for accessing PCI configuration space with type 1 accesses
- */
-static int pci_conf1_read(struct pci_bus *bus, unsigned int devfn, int where, int size, u32 *value)
-{
-	u32 word;
-	unsigned long flags;
-
-	/* 
-	 * PCIPDR may only be accessed as 32 bit words, 
-	 * so we must do byte alignment by hand 
-	 */
-	local_irq_save(flags);
-	writel(CONFIG_CMD(bus,devfn,where), PCIPAR);
-	word = readl(PCIPDR);
-	local_irq_restore(flags);
-
-	switch (size) {
-	case 1:
-		switch (where & 0x3) {
-		case 3:
-			*value = (u8)(word >> 24);
-			break;
-		case 2:
-			*value = (u8)(word >> 16);
-			break;
-		case 1:
-			*value = (u8)(word >> 8);
-			break;
-		default:
-			*value = (u8)word;
-			break;
-		}
-		break;
-	case 2:
-		switch (where & 0x3) {
-		case 3:
-			*value = (u16)(word >> 24);
-			local_irq_save(flags);
-			writel(CONFIG_CMD(bus,devfn,(where+1)), PCIPAR);
-			word = readl(PCIPDR);
-			local_irq_restore(flags);
-			*value |= ((word & 0xff) << 8);
-			break;
-		case 2:
-			*value = (u16)(word >> 16);
-			break;
-		case 1:
-			*value = (u16)(word >> 8);
-			break;
-		default:
-			*value = (u16)word;
-			break;
-		}
-		break;
-	case 4:
-		*value = word;
-		break;
-	}
-	PCIDBG(4,"pci_conf1_read@0x%08x=0x%x\n", CONFIG_CMD(bus,devfn,where),*value); 
-	return PCIBIOS_SUCCESSFUL;    
-}
-
-/* 
- * Since MPC-1211 only does 32bit access we'll have to do a read,mask,write operation.  
- * We'll allow an odd byte offset, though it should be illegal.
- */ 
-static int pci_conf1_write(struct pci_bus *bus, unsigned int devfn, int where, int size, u32 value)
-{
-	u32 word,mask = 0;
-	unsigned long flags;
-	u32 shift = (where & 3) * 8;
-
-	if(size == 1) {
-		mask = ((1 << 8) - 1) << shift;  // create the byte mask
-	} else if(size == 2){
-		if(shift == 24)
-			return PCIBIOS_BAD_REGISTER_NUMBER;           
-		mask = ((1 << 16) - 1) << shift;  // create the word mask
-	}
-	local_irq_save(flags);
-	writel(CONFIG_CMD(bus,devfn,where), PCIPAR);
-	if(size == 4){
-		writel(value, PCIPDR);
-		local_irq_restore(flags);
-		PCIDBG(4,"pci_conf1_write@0x%08x=0x%x\n", CONFIG_CMD(bus,devfn,where),value);
-		return PCIBIOS_SUCCESSFUL;
-	}
-	word = readl(PCIPDR);
-	word &= ~mask;
-	word |= ((value << shift) & mask);
-	writel(word, PCIPDR);
-	local_irq_restore(flags);
-	PCIDBG(4,"pci_conf1_write@0x%08x=0x%x\n", CONFIG_CMD(bus,devfn,where),word);
-	return PCIBIOS_SUCCESSFUL;
-}
-
-#undef CONFIG_CMD
-
-static struct pci_ops pci_direct_conf1 = {
-	.read =		pci_conf1_read,
-	.write = 	pci_conf1_write,
-};
-
-static void __devinit quirk_ali_ide_ports(struct pci_dev *dev)
-{
-        dev->resource[0].start = 0x1f0;
-	dev->resource[0].end   = 0x1f7;
-	dev->resource[0].flags = IORESOURCE_IO;
-        dev->resource[1].start = 0x3f6;
-	dev->resource[1].end   = 0x3f6;
-	dev->resource[1].flags = IORESOURCE_IO;
-        dev->resource[2].start = 0x170;
-	dev->resource[2].end   = 0x177;
-	dev->resource[2].flags = IORESOURCE_IO;
-        dev->resource[3].start = 0x376;
-	dev->resource[3].end   = 0x376;
-	dev->resource[3].flags = IORESOURCE_IO;
-        dev->resource[4].start = 0xf000;
-	dev->resource[4].end   = 0xf00f;
-	dev->resource[4].flags = IORESOURCE_IO;
-}
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M5229, quirk_ali_ide_ports);
-
-char * __devinit pcibios_setup(char *str)
-{
-	return str;
-}
-
-/*
- *  Called after each bus is probed, but before its children
- *  are examined.
- */
-
-void __devinit pcibios_fixup_bus(struct pci_bus *b)
-{
-	pci_read_bridge_bases(b);
-}
-
-/* 
- * 	IRQ functions 
- */
-static inline u8 bridge_swizzle(u8 pin, u8 slot)
-{
-        return (((pin-1) + slot) % 4) + 1;
-}
-
-static inline u8 bridge_swizzle_pci_1(u8 pin, u8 slot)
-{
-        return (((pin-1) - slot) & 3) + 1;
-}
-
-static u8 __init mpc1211_swizzle(struct pci_dev *dev, u8 *pinp)
-{
-	unsigned long flags;
-        u8 pin = *pinp;
-	u32 word;
-
-	for ( ; dev->bus->self; dev = dev->bus->self) {
-		if (!pin)
-			continue;
-
-		if (dev->bus->number == 1) {
-			local_irq_save(flags);
-			writel(0x80000000 | 0x2c, PCIPAR);
-			word = readl(PCIPDR);
-			local_irq_restore(flags);
-			word >>= 16;
-
-			if (word == 0x0001)
-				pin = bridge_swizzle_pci_1(pin, PCI_SLOT(dev->devfn));
-			else
-				pin = bridge_swizzle(pin, PCI_SLOT(dev->devfn));
-		} else
-			pin = bridge_swizzle(pin, PCI_SLOT(dev->devfn));
-	}
-
-	*pinp = pin;
-
-	return PCI_SLOT(dev->devfn);
-}
-
-static int __init map_mpc1211_irq(struct pci_dev *dev, u8 slot, u8 pin)
-{
-	int irq = -1;
-
-	/* now lookup the actual IRQ on a platform specific basis (pci-'platform'.c) */
-	if (dev->bus->number == 0) {
-		switch (slot) {
-		case 13:   irq =  9; break;   /* USB */
-		case 22:   irq = 10; break;   /* LAN */
-		default:   irq =  0; break;
-	  	}
-	} else {
-		switch (pin) {
-		case 0:   irq =  0; break;
-		case 1:   irq =  7; break;
-		case 2:   irq =  9; break;
-		case 3:   irq = 10; break;
-		case 4:   irq = 11; break;
-		}
-	}
-
-	if( irq < 0 ) {
-		PCIDBG(3, "PCI: Error mapping IRQ on device %s\n", pci_name(dev));
-		return irq;
-	}
-	
-	PCIDBG(2, "Setting IRQ for slot %s to %d\n", pci_name(dev), irq);
-
-	return irq;
-}
-
-void __init pcibios_fixup_irqs(void)
-{
-	pci_fixup_irqs(mpc1211_swizzle, map_mpc1211_irq);
-}
-
-void pcibios_align_resource(void *data, struct resource *res,
-			    resource_size_t size, resource_size_t align)
-{
-	resource_size_t start = res->start;
-
-	if (res->flags & IORESOURCE_IO) {
-		if (start >= 0x10000UL) {
-			if ((start & 0xffffUL) < 0x4000UL) {
-				start = (start & 0xffff0000UL) + 0x4000UL;
-			} else if ((start & 0xffffUL) >= 0xf000UL) {
-				start = (start & 0xffff0000UL) + 0x10000UL;
-			}
-			res->start = start;
-		} else {
-			if (start & 0x300) {
-				start = (start + 0x3ff) & ~0x3ff;
-				res->start = start;
-			}
-		}
-	}
-}
-
diff --git a/arch/sh/boards/mpc1211/rtc.c b/arch/sh/boards/mpc1211/rtc.c
deleted file mode 100644
index 03b123a..0000000
--- a/arch/sh/boards/mpc1211/rtc.c
+++ /dev/null
@@ -1,136 +0,0 @@
-/*
- * linux/arch/sh/kernel/rtc-mpc1211.c -- MPC-1211 on-chip RTC support
- *
- *  Copyright (C) 2002  Saito.K & Jeanne
- *
- */
-
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <linux/sched.h>
-#include <linux/time.h>
-#include <linux/bcd.h>
-#include <linux/mc146818rtc.h>
-
-unsigned long get_cmos_time(void)
-{
-	unsigned int year, mon, day, hour, min, sec;
-
-	spin_lock(&rtc_lock);
-
-	do {
-		sec = CMOS_READ(RTC_SECONDS);
-		min = CMOS_READ(RTC_MINUTES);
-		hour = CMOS_READ(RTC_HOURS);
-		day = CMOS_READ(RTC_DAY_OF_MONTH);
-		mon = CMOS_READ(RTC_MONTH);
-		year = CMOS_READ(RTC_YEAR);
-	} while (sec != CMOS_READ(RTC_SECONDS));
-
-	if (!(CMOS_READ(RTC_CONTROL) & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
-		BCD_TO_BIN(sec);
-		BCD_TO_BIN(min);
-		BCD_TO_BIN(hour);
-		BCD_TO_BIN(day);
-		BCD_TO_BIN(mon);
-		BCD_TO_BIN(year);
-	}
-
-	spin_unlock(&rtc_lock);
-
-	year += 1900;
-	if (year < 1970)
-		year += 100;
-
-	return mktime(year, mon, day, hour, min, sec);
-}
-
-void mpc1211_rtc_gettimeofday(struct timeval *tv)
-{
-
-	tv->tv_sec = get_cmos_time();
-	tv->tv_usec = 0;
-}
-
-/* arc/i386/kernel/time.c */
-/*
- * In order to set the CMOS clock precisely, set_rtc_mmss has to be
- * called 500 ms after the second nowtime has started, because when
- * nowtime is written into the registers of the CMOS clock, it will
- * jump to the next second precisely 500 ms later. Check the Motorola
- * MC146818A or Dallas DS12887 data sheet for details.
- *
- * BUG: This routine does not handle hour overflow properly; it just
- *      sets the minutes. Usually you'll only notice that after reboot!
- */
-static int set_rtc_mmss(unsigned long nowtime)
-{
-	int retval = 0;
-	int real_seconds, real_minutes, cmos_minutes;
-	unsigned char save_control, save_freq_select;
-
-	/* gets recalled with irq locally disabled */
-	spin_lock(&rtc_lock);
-	save_control = CMOS_READ(RTC_CONTROL); /* tell the clock it's being set */
-	CMOS_WRITE((save_control|RTC_SET), RTC_CONTROL);
-
-	save_freq_select = CMOS_READ(RTC_FREQ_SELECT); /* stop and reset prescaler */
-	CMOS_WRITE((save_freq_select|RTC_DIV_RESET2), RTC_FREQ_SELECT);
-
-	cmos_minutes = CMOS_READ(RTC_MINUTES);
-	if (!(save_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD)
-		BCD_TO_BIN(cmos_minutes);
-
-	/*
-	 * since we're only adjusting minutes and seconds,
-	 * don't interfere with hour overflow. This avoids
-	 * messing with unknown time zones but requires your
-	 * RTC not to be off by more than 15 minutes
-	 */
-	real_seconds = nowtime % 60;
-	real_minutes = nowtime / 60;
-	if (((abs(real_minutes - cmos_minutes) + 15)/30) & 1)
-		real_minutes += 30;		/* correct for half hour time zone */
-	real_minutes %= 60;
-
-	if (abs(real_minutes - cmos_minutes) < 30) {
-		if (!(save_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
-			BIN_TO_BCD(real_seconds);
-			BIN_TO_BCD(real_minutes);
-		}
-		CMOS_WRITE(real_seconds,RTC_SECONDS);
-		CMOS_WRITE(real_minutes,RTC_MINUTES);
-	} else {
-		printk(KERN_WARNING
-		       "set_rtc_mmss: can't update from %d to %d\n",
-		       cmos_minutes, real_minutes);
-		retval = -1;
-	}
-
-	/* The following flags have to be released exactly in this order,
-	 * otherwise the DS12887 (popular MC146818A clone with integrated
-	 * battery and quartz) will not reset the oscillator and will not
-	 * update precisely 500 ms later. You won't find this mentioned in
-	 * the Dallas Semiconductor data sheets, but who believes data
-	 * sheets anyway ...                           -- Markus Kuhn
-	 */
-	CMOS_WRITE(save_control, RTC_CONTROL);
-	CMOS_WRITE(save_freq_select, RTC_FREQ_SELECT);
-	spin_unlock(&rtc_lock);
-
-	return retval;
-}
-
-int mpc1211_rtc_settimeofday(const struct timeval *tv)
-{
-	unsigned long nowtime = tv->tv_sec;
-
-	return set_rtc_mmss(nowtime);
-}
-
-void mpc1211_time_init(void)
-{
-	rtc_sh_get_time = mpc1211_rtc_gettimeofday;
-	rtc_sh_set_time = mpc1211_rtc_settimeofday;
-}
-
diff --git a/arch/sh/boards/mpc1211/setup.c b/arch/sh/boards/mpc1211/setup.c
deleted file mode 100644
index fede363..0000000
--- a/arch/sh/boards/mpc1211/setup.c
+++ /dev/null
@@ -1,347 +0,0 @@
-/*
- * linux/arch/sh/boards/mpc1211/setup.c
- *
- * Copyright (C) 2002  Saito.K & Jeanne,  Fujii.Y
- *
- */
-
-#include <linux/init.h>
-#include <linux/irq.h>
-#include <linux/hdreg.h>
-#include <linux/ide.h>
-#include <linux/interrupt.h>
-#include <linux/platform_device.h>
-#include <asm/io.h>
-#include <asm/machvec.h>
-#include <asm/mpc1211/mpc1211.h>
-#include <asm/mpc1211/pci.h>
-#include <asm/mpc1211/m1543c.h>
-
-/* ALI15X3 SMBus address offsets */
-#define SMBHSTSTS   (0 + 0x3100)
-#define SMBHSTCNT   (1 + 0x3100)
-#define SMBHSTSTART (2 + 0x3100)
-#define SMBHSTCMD   (7 + 0x3100)
-#define SMBHSTADD   (3 + 0x3100)
-#define SMBHSTDAT0  (4 + 0x3100)
-#define SMBHSTDAT1  (5 + 0x3100)
-#define SMBBLKDAT   (6 + 0x3100)
-
-/* Other settings */
-#define MAX_TIMEOUT 500		/* times 1/100 sec */
-
-/* ALI15X3 command constants */
-#define ALI15X3_ABORT      0x04
-#define ALI15X3_T_OUT      0x08
-#define ALI15X3_QUICK      0x00
-#define ALI15X3_BYTE       0x10
-#define ALI15X3_BYTE_DATA  0x20
-#define ALI15X3_WORD_DATA  0x30
-#define ALI15X3_BLOCK_DATA 0x40
-#define ALI15X3_BLOCK_CLR  0x80
-
-/* ALI15X3 status register bits */
-#define ALI15X3_STS_IDLE	0x04
-#define ALI15X3_STS_BUSY	0x08
-#define ALI15X3_STS_DONE	0x10
-#define ALI15X3_STS_DEV		0x20	/* device error */
-#define ALI15X3_STS_COLL	0x40	/* collision or no response */
-#define ALI15X3_STS_TERM	0x80	/* terminated by abort */
-#define ALI15X3_STS_ERR		0xE0	/* all the bad error bits */
-
-static void __init pci_write_config(unsigned long busNo,
-				    unsigned long devNo,
-				    unsigned long fncNo,
-				    unsigned long cnfAdd,
-				    unsigned long cnfData)
-{
-	ctrl_outl((0x80000000 
-                + ((busNo & 0xff) << 16) 
-                + ((devNo & 0x1f) << 11) 
-                + ((fncNo & 0x07) <<  8) 
-		+ (cnfAdd & 0xfc)), PCIPAR);
-
-        ctrl_outl(cnfData, PCIPDR);
-}
-
-/*
-  Initialize IRQ setting
-*/
-
-static unsigned char m_irq_mask = 0xfb;
-static unsigned char s_irq_mask = 0xff;
-
-static void disable_mpc1211_irq(unsigned int irq)
-{
-	if( irq < 8) {
-		m_irq_mask |= (1 << irq);
-		outb(m_irq_mask,I8259_M_MR);
-	} else {
-		s_irq_mask |= (1 << (irq - 8));
-		outb(s_irq_mask,I8259_S_MR);
-	}
-
-}
-
-static void enable_mpc1211_irq(unsigned int irq)
-{
-	if( irq < 8) {
-		m_irq_mask &= ~(1 << irq);
-		outb(m_irq_mask,I8259_M_MR);
-	} else {
-		s_irq_mask &= ~(1 << (irq - 8));
-		outb(s_irq_mask,I8259_S_MR);
-	}
-}
-
-static inline int mpc1211_irq_real(unsigned int irq)
-{
-	int value;
-	int irqmask;
-
-	if ( irq < 8) {
-		irqmask = 1<<irq;
-		outb(0x0b,I8259_M_CR);		/* ISR register */
-		value = inb(I8259_M_CR) & irqmask;
-		outb(0x0a,I8259_M_CR);		/* back ro the IPR reg */
-		return value;
-	}
-	irqmask = 1<<(irq - 8);
-	outb(0x0b,I8259_S_CR);		/* ISR register */
-	value = inb(I8259_S_CR) & irqmask;
-	outb(0x0a,I8259_S_CR);		/* back ro the IPR reg */
-	return value;
-}
-
-static void mask_and_ack_mpc1211(unsigned int irq)
-{
-	if(irq < 8) {
-		if(m_irq_mask & (1<<irq)){
-		  if(!mpc1211_irq_real(irq)){
-		    atomic_inc(&irq_err_count)
-		    printk("spurious 8259A interrupt: IRQ %x\n",irq);
-		   }
-		} else {
-			m_irq_mask |= (1<<irq);
-		}
-		inb(I8259_M_MR);		/* DUMMY */
-		outb(m_irq_mask,I8259_M_MR);	/* disable */
-		outb(0x60+irq,I8259_M_CR);	/* EOI */
-		
-	} else {
-		if(s_irq_mask & (1<<(irq - 8))){
-		  if(!mpc1211_irq_real(irq)){
-		    atomic_inc(&irq_err_count);
-		    printk("spurious 8259A interrupt: IRQ %x\n",irq);
-		  }
-		} else {
-			s_irq_mask |= (1<<(irq - 8));
-		}
-		inb(I8259_S_MR);		/* DUMMY */
-		outb(s_irq_mask,I8259_S_MR);	/* disable */
-		outb(0x60+(irq-8),I8259_S_CR); 	/* EOI */
-		outb(0x60+2,I8259_M_CR);
-	}
-}
-
-static void end_mpc1211_irq(unsigned int irq)
-{
-	enable_mpc1211_irq(irq);
-}
-
-static unsigned int startup_mpc1211_irq(unsigned int irq)
-{
-	enable_mpc1211_irq(irq);
-	return 0;
-}
-
-static void shutdown_mpc1211_irq(unsigned int irq)
-{
-	disable_mpc1211_irq(irq);
-}
-
-static struct hw_interrupt_type mpc1211_irq_type = {
-	.typename	= "MPC1211-IRQ",
-	.startup	= startup_mpc1211_irq,
-	.shutdown	= shutdown_mpc1211_irq,
-	.enable		= enable_mpc1211_irq,
-	.disable	= disable_mpc1211_irq,
-	.ack		= mask_and_ack_mpc1211,
-	.end		= end_mpc1211_irq
-};
-
-static void make_mpc1211_irq(unsigned int irq)
-{
-	irq_desc[irq].chip = &mpc1211_irq_type;
-	irq_desc[irq].status  = IRQ_DISABLED;
-	irq_desc[irq].action  = 0;
-	irq_desc[irq].depth   = 1;
-	disable_mpc1211_irq(irq);
-}
-
-int mpc1211_irq_demux(int irq)
-{
-	unsigned int poll;
-
-	if( irq == 2 ) {
-		outb(0x0c,I8259_M_CR);
-		poll = inb(I8259_M_CR);
-		if(poll & 0x80) {
-			irq = (poll & 0x07);
-		}
-		if( irq == 2) {
-			outb(0x0c,I8259_S_CR);
-			poll = inb(I8259_S_CR);
-			irq = (poll & 0x07) + 8;
-		}
-	}
-	return irq;
-}
-
-static void __init init_mpc1211_IRQ(void)
-{
-	int i;
-	/*
-	 * Super I/O (Just mimic PC):
-	 *  1: keyboard
-	 *  3: serial 1
-	 *  4: serial 0
-	 *  5: printer
-	 *  6: floppy
-	 *  8: rtc
-	 * 10: lan
-	 * 12: mouse
-	 * 14: ide0
-	 * 15: ide1
-	 */
-
-	pci_write_config(0,0,0,0x54, 0xb0b0002d);
-	outb(0x11, I8259_M_CR); 	/* mater icw1 edge trigger  */
-	outb(0x11, I8259_S_CR);		/* slave icw1 edge trigger  */
-	outb(0x20, I8259_M_MR); 	/* m icw2 base vec 0x08	    */
-	outb(0x28, I8259_S_MR);		/* s icw2 base vec 0x70	    */
-	outb(0x04, I8259_M_MR);		/* m icw3 slave irq2	    */
-	outb(0x02, I8259_S_MR);		/* s icw3 slave id	    */
-	outb(0x01, I8259_M_MR);		/* m icw4 non buf normal eoi*/
-	outb(0x01, I8259_S_MR);		/* s icw4 non buf normal eo1*/
-	outb(0xfb, I8259_M_MR);		/* disable irq0--irq7  */
-	outb(0xff, I8259_S_MR);		/* disable irq8--irq15 */
-
-	for ( i=0; i < 16; i++) {
-		if(i != 2) {
-			make_mpc1211_irq(i);
-		}
-	}
-}
-
-static void delay1000(void)
-{
-	int i;
-
-	for (i=0; i<1000; i++)
-		ctrl_delay();
-}
-
-static int put_smb_blk(unsigned char *p, int address, int command, int no)
-{
-	int temp;
-	int timeout;
-	int i;
-
-	outb(0xff, SMBHSTSTS);
-	temp = inb(SMBHSTSTS);
-	for (timeout = 0; (timeout < MAX_TIMEOUT) && !(temp & ALI15X3_STS_IDLE); timeout++) {
-		delay1000();
-		temp = inb(SMBHSTSTS);
-	}
-	if (timeout >= MAX_TIMEOUT){
-		return -1;
-	}
-
-	outb(((address & 0x7f) << 1), SMBHSTADD);
-	outb(0xc0, SMBHSTCNT);
-	outb(command & 0xff, SMBHSTCMD);
-	outb(no & 0x1f, SMBHSTDAT0);
-
-	for(i = 1; i <= no; i++) {
-		outb(*p++, SMBBLKDAT);
-	}
-	outb(0xff, SMBHSTSTART);
-
-	temp = inb(SMBHSTSTS);
-	for (timeout = 0; (timeout < MAX_TIMEOUT) && !(temp & (ALI15X3_STS_ERR | ALI15X3_STS_DONE)); timeout++) {
-		delay1000();
-		temp = inb(SMBHSTSTS);
-	}
-	if (timeout >= MAX_TIMEOUT) {
-		return -2;
-	}
-	if ( temp & ALI15X3_STS_ERR ){
-		return -3;
-	}
-	return 0;
-}
-
-static struct resource heartbeat_resources[] = {
-	[0] = {
-		.start	= 0xa2000000,
-		.end	= 0xa2000000,
-		.flags	= IORESOURCE_MEM,
-	},
-};
-
-static struct platform_device heartbeat_device = {
-	.name		= "heartbeat",
-	.id		= -1,
-	.num_resources	= ARRAY_SIZE(heartbeat_resources),
-	.resource	= heartbeat_resources,
-};
-
-static struct platform_device *mpc1211_devices[] __initdata = {
-	&heartbeat_device,
-};
-
-static int __init mpc1211_devices_setup(void)
-{
-	return platform_add_devices(mpc1211_devices,
-				    ARRAY_SIZE(mpc1211_devices));
-}
-__initcall(mpc1211_devices_setup);
-
-/* arch/sh/boards/mpc1211/rtc.c */
-void mpc1211_time_init(void);
-
-static void __init mpc1211_setup(char **cmdline_p)
-{
-	unsigned char spd_buf[128];
-
-	__set_io_port_base(PA_PCI_IO);
-
-	pci_write_config(0,0,0,0x54, 0xb0b00000);
-
-	do {
-		outb(ALI15X3_ABORT, SMBHSTCNT);
-		spd_buf[0] = 0x0c;
-		spd_buf[1] = 0x43;
-		spd_buf[2] = 0x7f;
-		spd_buf[3] = 0x03;
-		spd_buf[4] = 0x00;
-		spd_buf[5] = 0x03;
-		spd_buf[6] = 0x00;
-	} while (put_smb_blk(spd_buf, 0x69, 0, 7) < 0);
-
-	board_time_init = mpc1211_time_init;
-
-	return 0;
-}
-
-/*
- * The Machine Vector
- */
-static struct sh_machine_vector mv_mpc1211 __initmv = {
-	.mv_name		= "Interface MPC-1211(CTP/PCI/MPC-SH02)",
-	.mv_setup		= mpc1211_setup,
-	.mv_nr_irqs		= 48,
-	.mv_irq_demux		= mpc1211_irq_demux,
-	.mv_init_irq		= init_mpc1211_IRQ,
-};
diff --git a/arch/sh/tools/mach-types b/arch/sh/tools/mach-types
index d63b93d..d473274 100644
--- a/arch/sh/tools/mach-types
+++ b/arch/sh/tools/mach-types
@@ -27,7 +27,6 @@ HD64465			HD64465
 7751SYSTEMH		SH_7751_SYSTEMH
 HP6XX			SH_HP6XX
 DREAMCAST		SH_DREAMCAST
-MPC1211			SH_MPC1211
 SNAPGEAR		SH_SECUREEDGE5410
 EDOSK7705		SH_EDOSK7705
 SH4202_MICRODEV		SH_SH4202_MICRODEV
diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index eed6d8e..833a0c6 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -124,7 +124,7 @@ config BLK_DEV_IDE_SATA
 
 config BLK_DEV_HD_IDE
 	bool "Use old disk-only driver on primary interface"
-	depends on (X86 || SH_MPC1211)
+	depends on X86
 	---help---
 	  There are two drivers for MFM/RLL/IDE disks.  Most people use just
 	  the new enhanced driver by itself.  This option however installs the
diff --git a/drivers/mtd/maps/Kconfig b/drivers/mtd/maps/Kconfig
index 12c2536..95f3478 100644
--- a/drivers/mtd/maps/Kconfig
+++ b/drivers/mtd/maps/Kconfig
@@ -477,13 +477,6 @@ config MTD_H720X
 	  This enables access to the flash chips on the Hynix evaluation boards.
 	  If you have such a board, say 'Y'.
 
-config MTD_MPC1211
-	tristate "CFI Flash device mapped on Interface MPC-1211"
-	depends on SH_MPC1211 && MTD_CFI
-	help
-	  This enables access to the flash chips on the Interface MPC-1211(CTP/PCI/MPC-SH02).
-	  If you have such a board, say 'Y'.
-
 config MTD_OMAP_NOR
 	tristate "TI OMAP board mappings"
 	depends on MTD_CFI && ARCH_OMAP
diff --git a/drivers/mtd/maps/Makefile b/drivers/mtd/maps/Makefile
index a9cbe80..957fb5f 100644
--- a/drivers/mtd/maps/Makefile
+++ b/drivers/mtd/maps/Makefile
@@ -58,7 +58,6 @@ obj-$(CONFIG_MTD_WALNUT)        += walnut.o
 obj-$(CONFIG_MTD_H720X)		+= h720x-flash.o
 obj-$(CONFIG_MTD_SBC8240)	+= sbc8240.o
 obj-$(CONFIG_MTD_NOR_TOTO)	+= omap-toto-flash.o
-obj-$(CONFIG_MTD_MPC1211)	+= mpc1211.o
 obj-$(CONFIG_MTD_IXP4XX)	+= ixp4xx.o
 obj-$(CONFIG_MTD_IXP2000)	+= ixp2000.o
 obj-$(CONFIG_MTD_WRSBC8260)	+= wr_sbc82xx_flash.o
diff --git a/drivers/mtd/maps/mpc1211.c b/drivers/mtd/maps/mpc1211.c
deleted file mode 100644
index 45a00fa..0000000
--- a/drivers/mtd/maps/mpc1211.c
+++ /dev/null
@@ -1,80 +0,0 @@
-/*
- * Flash on MPC-1211
- *
- * $Id: mpc1211.c,v 1.4 2004/09/16 23:27:13 gleixner Exp $
- *
- * (C) 2002 Interface, Saito.K & Jeanne
- *
- * GPL'd
- */
-
-#include <linux/module.h>
-#include <linux/types.h>
-#include <linux/kernel.h>
-#include <asm/io.h>
-#include <linux/mtd/mtd.h>
-#include <linux/mtd/map.h>
-#include <linux/mtd/partitions.h>
-
-static struct mtd_info *flash_mtd;
-static struct mtd_partition *parsed_parts;
-
-struct map_info mpc1211_flash_map = {
-	.name		= "MPC-1211 FLASH",
-	.size		= 0x80000,
-	.bankwidth	= 1,
-};
-
-static struct mtd_partition mpc1211_partitions[] = {
-	{
-		.name	= "IPL & ETH-BOOT",
-		.offset	= 0x00000000,
-		.size	= 0x10000,
-	},
-	{
-		.name	= "Flash FS",
-		.offset	= 0x00010000,
-		.size	= MTDPART_SIZ_FULL,
-	}
-};
-
-static int __init init_mpc1211_maps(void)
-{
-	int nr_parts;
-
-	mpc1211_flash_map.phys = 0;
-	mpc1211_flash_map.virt = (void __iomem *)P2SEGADDR(0);
-
-	simple_map_init(&mpc1211_flash_map);
-
-	printk(KERN_NOTICE "Probing for flash chips at 0x00000000:\n");
-	flash_mtd = do_map_probe("jedec_probe", &mpc1211_flash_map);
-	if (!flash_mtd) {
-		printk(KERN_NOTICE "Flash chips not detected at either possible location.\n");
-		return -ENXIO;
-	}
-	printk(KERN_NOTICE "MPC-1211: Flash at 0x%08lx\n", mpc1211_flash_map.virt & 0x1fffffff);
-	flash_mtd->module = THIS_MODULE;
-
-	parsed_parts = mpc1211_partitions;
-	nr_parts = ARRAY_SIZE(mpc1211_partitions);
-
-	add_mtd_partitions(flash_mtd, parsed_parts, nr_parts);
-	return 0;
-}
-
-static void __exit cleanup_mpc1211_maps(void)
-{
-	if (parsed_parts)
-		del_mtd_partitions(flash_mtd);
-	else
-		del_mtd_device(flash_mtd);
-	map_destroy(flash_mtd);
-}
-
-module_init(init_mpc1211_maps);
-module_exit(cleanup_mpc1211_maps);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Saito.K & Jeanne <ksaito@interface.co.jp>");
-MODULE_DESCRIPTION("MTD map driver for MPC-1211 boards. Interface");
diff --git a/include/asm-sh/keyboard.h b/include/asm-sh/keyboard.h
deleted file mode 100644
index 31dcc4f..0000000
--- a/include/asm-sh/keyboard.h
+++ /dev/null
@@ -1,13 +0,0 @@
-#ifndef	__ASM_SH_KEYBOARD_H
-#define	__ASM_SH_KEYBOARD_H
-/*
- *	$Id: keyboard.h,v 1.1.1.1 2001/10/15 20:45:09 mrbrown Exp $
- */
-
-#include <linux/kd.h>
-#include <asm/machvec.h>
-
-#ifdef CONFIG_SH_MPC1211
-#include <asm/mpc1211/keyboard-mpc1211.h>
-#endif
-#endif
diff --git a/include/asm-sh/mpc1211/dma.h b/include/asm-sh/mpc1211/dma.h
deleted file mode 100644
index e506d1a..0000000
--- a/include/asm-sh/mpc1211/dma.h
+++ /dev/null
@@ -1,303 +0,0 @@
-/* $Id: dma.h,v 1.7 1992/12/14 00:29:34 root Exp root $
- * linux/include/asm/dma.h: Defines for using and allocating dma channels.
- * Written by Hennus Bergman, 1992.
- * High DMA channel support & info by Hannu Savolainen
- * and John Boyd, Nov. 1992.
- */
-
-#ifndef _ASM_MPC1211_DMA_H
-#define _ASM_MPC1211_DMA_H
-
-#include <linux/spinlock.h>	/* And spinlocks */
-#include <asm/io.h>		/* need byte IO */
-#include <linux/delay.h>
-
-
-#ifdef HAVE_REALLY_SLOW_DMA_CONTROLLER
-#define dma_outb	outb_p
-#else
-#define dma_outb	outb
-#endif
-
-#define dma_inb		inb
-
-/*
- * NOTES about DMA transfers:
- *
- *  controller 1: channels 0-3, byte operations, ports 00-1F
- *  controller 2: channels 4-7, word operations, ports C0-DF
- *
- *  - ALL registers are 8 bits only, regardless of transfer size
- *  - channel 4 is not used - cascades 1 into 2.
- *  - channels 0-3 are byte - addresses/counts are for physical bytes
- *  - channels 5-7 are word - addresses/counts are for physical words
- *  - transfers must not cross physical 64K (0-3) or 128K (5-7) boundaries
- *  - transfer count loaded to registers is 1 less than actual count
- *  - controller 2 offsets are all even (2x offsets for controller 1)
- *  - page registers for 5-7 don't use data bit 0, represent 128K pages
- *  - page registers for 0-3 use bit 0, represent 64K pages
- *
- * DMA transfers are limited to the lower 16MB of _physical_ memory.  
- * Note that addresses loaded into registers must be _physical_ addresses,
- * not logical addresses (which may differ if paging is active).
- *
- *  Address mapping for channels 0-3:
- *
- *   A23 ... A16 A15 ... A8  A7 ... A0    (Physical addresses)
- *    |  ...  |   |  ... |   |  ... |
- *    |  ...  |   |  ... |   |  ... |
- *    |  ...  |   |  ... |   |  ... |
- *   P7  ...  P0  A7 ... A0  A7 ... A0   
- * |    Page    | Addr MSB | Addr LSB |   (DMA registers)
- *
- *  Address mapping for channels 5-7:
- *
- *   A23 ... A17 A16 A15 ... A9 A8 A7 ... A1 A0    (Physical addresses)
- *    |  ...  |   \   \   ... \  \  \  ... \  \
- *    |  ...  |    \   \   ... \  \  \  ... \  (not used)
- *    |  ...  |     \   \   ... \  \  \  ... \
- *   P7  ...  P1 (0) A7 A6  ... A0 A7 A6 ... A0   
- * |      Page      |  Addr MSB   |  Addr LSB  |   (DMA registers)
- *
- * Again, channels 5-7 transfer _physical_ words (16 bits), so addresses
- * and counts _must_ be word-aligned (the lowest address bit is _ignored_ at
- * the hardware level, so odd-byte transfers aren't possible).
- *
- * Transfer count (_not # bytes_) is limited to 64K, represented as actual
- * count - 1 : 64K => 0xFFFF, 1 => 0x0000.  Thus, count is always 1 or more,
- * and up to 128K bytes may be transferred on channels 5-7 in one operation. 
- *
- */
-
-#define MAX_DMA_CHANNELS	8
-
-/* The maximum address that we can perform a DMA transfer to on this platform */
-#define MAX_DMA_ADDRESS      (PAGE_OFFSET+0x10000000)
-
-/* 8237 DMA controllers */
-#define IO_DMA1_BASE	0x00	/* 8 bit slave DMA, channels 0..3 */
-#define IO_DMA2_BASE	0xC0	/* 16 bit master DMA, ch 4(=slave input)..7 */
-
-/* DMA controller registers */
-#define DMA1_CMD_REG		0x08	/* command register (w) */
-#define DMA1_STAT_REG		0x08	/* status register (r) */
-#define DMA1_REQ_REG            0x09    /* request register (w) */
-#define DMA1_MASK_REG		0x0A	/* single-channel mask (w) */
-#define DMA1_MODE_REG		0x0B	/* mode register (w) */
-#define DMA1_CLEAR_FF_REG	0x0C	/* clear pointer flip-flop (w) */
-#define DMA1_TEMP_REG           0x0D    /* Temporary Register (r) */
-#define DMA1_RESET_REG		0x0D	/* Master Clear (w) */
-#define DMA1_CLR_MASK_REG       0x0E    /* Clear Mask */
-#define DMA1_MASK_ALL_REG       0x0F    /* all-channels mask (w) */
-
-#define DMA2_CMD_REG		0xD0	/* command register (w) */
-#define DMA2_STAT_REG		0xD0	/* status register (r) */
-#define DMA2_REQ_REG            0xD2    /* request register (w) */
-#define DMA2_MASK_REG		0xD4	/* single-channel mask (w) */
-#define DMA2_MODE_REG		0xD6	/* mode register (w) */
-#define DMA2_CLEAR_FF_REG	0xD8	/* clear pointer flip-flop (w) */
-#define DMA2_TEMP_REG           0xDA    /* Temporary Register (r) */
-#define DMA2_RESET_REG		0xDA	/* Master Clear (w) */
-#define DMA2_CLR_MASK_REG       0xDC    /* Clear Mask */
-#define DMA2_MASK_ALL_REG       0xDE    /* all-channels mask (w) */
-
-#define DMA_ADDR_0              0x00    /* DMA address registers */
-#define DMA_ADDR_1              0x02
-#define DMA_ADDR_2              0x04
-#define DMA_ADDR_3              0x06
-#define DMA_ADDR_4              0xC0
-#define DMA_ADDR_5              0xC4
-#define DMA_ADDR_6              0xC8
-#define DMA_ADDR_7              0xCC
-
-#define DMA_CNT_0               0x01    /* DMA count registers */
-#define DMA_CNT_1               0x03
-#define DMA_CNT_2               0x05
-#define DMA_CNT_3               0x07
-#define DMA_CNT_4               0xC2
-#define DMA_CNT_5               0xC6
-#define DMA_CNT_6               0xCA
-#define DMA_CNT_7               0xCE
-
-#define DMA_PAGE_0              0x87    /* DMA page registers */
-#define DMA_PAGE_1              0x83
-#define DMA_PAGE_2              0x81
-#define DMA_PAGE_3              0x82
-#define DMA_PAGE_5              0x8B
-#define DMA_PAGE_6              0x89
-#define DMA_PAGE_7              0x8A
-
-#define DMA_MODE_READ	0x44	/* I/O to memory, no autoinit, increment, single mode */
-#define DMA_MODE_WRITE	0x48	/* memory to I/O, no autoinit, increment, single mode */
-#define DMA_MODE_CASCADE 0xC0   /* pass thru DREQ->HRQ, DACK<-HLDA only */
-
-#define DMA_AUTOINIT	0x10
-
-
-extern spinlock_t  dma_spin_lock;
-
-static __inline__ unsigned long claim_dma_lock(void)
-{
-	unsigned long flags;
-	spin_lock_irqsave(&dma_spin_lock, flags);
-	return flags;
-}
-
-static __inline__ void release_dma_lock(unsigned long flags)
-{
-	spin_unlock_irqrestore(&dma_spin_lock, flags);
-}
-
-/* enable/disable a specific DMA channel */
-static __inline__ void enable_dma(unsigned int dmanr)
-{
-	if (dmanr<=3)
-		dma_outb(dmanr,  DMA1_MASK_REG);
-	else
-		dma_outb(dmanr & 3,  DMA2_MASK_REG);
-}
-
-static __inline__ void disable_dma(unsigned int dmanr)
-{
-	if (dmanr<=3)
-		dma_outb(dmanr | 4,  DMA1_MASK_REG);
-	else
-		dma_outb((dmanr & 3) | 4,  DMA2_MASK_REG);
-}
-
-/* Clear the 'DMA Pointer Flip Flop'.
- * Write 0 for LSB/MSB, 1 for MSB/LSB access.
- * Use this once to initialize the FF to a known state.
- * After that, keep track of it. :-)
- * --- In order to do that, the DMA routines below should ---
- * --- only be used while holding the DMA lock ! ---
- */
-static __inline__ void clear_dma_ff(unsigned int dmanr)
-{
-	if (dmanr<=3)
-		dma_outb(0,  DMA1_CLEAR_FF_REG);
-	else
-		dma_outb(0,  DMA2_CLEAR_FF_REG);
-}
-
-/* set mode (above) for a specific DMA channel */
-static __inline__ void set_dma_mode(unsigned int dmanr, char mode)
-{
-	if (dmanr<=3)
-		dma_outb(mode | dmanr,  DMA1_MODE_REG);
-	else
-		dma_outb(mode | (dmanr&3),  DMA2_MODE_REG);
-}
-
-/* Set only the page register bits of the transfer address.
- * This is used for successive transfers when we know the contents of
- * the lower 16 bits of the DMA current address register, but a 64k boundary
- * may have been crossed.
- */
-static __inline__ void set_dma_page(unsigned int dmanr, unsigned int pagenr)
-{
-	switch(dmanr) {
-		case 0:
-			dma_outb( pagenr       & 0xff, DMA_PAGE_0);
-			dma_outb((pagenr >> 8) & 0xff, DMA_PAGE_0 + 0x400);
-			break;
-		case 1:
-			dma_outb( pagenr       & 0xff, DMA_PAGE_1);
-			dma_outb((pagenr >> 8) & 0xff, DMA_PAGE_1 + 0x400);
-			break;
-		case 2:
-			dma_outb( pagenr       & 0xff, DMA_PAGE_2);
-			dma_outb((pagenr >> 8) & 0xff, DMA_PAGE_2 + 0x400);
-			break;
-		case 3:
-			dma_outb( pagenr       & 0xff, DMA_PAGE_3);
-			dma_outb((pagenr >> 8) & 0xff, DMA_PAGE_3 + 0x400);
-			break;
-		case 5:
-			dma_outb( pagenr       & 0xfe, DMA_PAGE_5);
-			dma_outb((pagenr >> 8) & 0xff, DMA_PAGE_5 + 0x400);
-			break;
-		case 6:
-			dma_outb( pagenr       & 0xfe, DMA_PAGE_6);
-			dma_outb((pagenr >> 8) & 0xff, DMA_PAGE_6 + 0x400);
-			break;
-		case 7:
-			dma_outb( pagenr       & 0xfe, DMA_PAGE_7);
-			dma_outb((pagenr >> 8) & 0xff, DMA_PAGE_7 + 0x400);
-			break;
-       	}
-}
-
-
-/* Set transfer address & page bits for specific DMA channel.
- * Assumes dma flipflop is clear.
- */
-static __inline__ void set_dma_addr(unsigned int dmanr, unsigned int a)
-{
-	set_dma_page(dmanr, a>>16);
-	if (dmanr <= 3)  {
-	    dma_outb( a & 0xff, ((dmanr&3)<<1) + IO_DMA1_BASE );
-            dma_outb( (a>>8) & 0xff, ((dmanr&3)<<1) + IO_DMA1_BASE );
-	}  else  {
-	    dma_outb( (a>>1) & 0xff, ((dmanr&3)<<2) + IO_DMA2_BASE );
-	    dma_outb( (a>>9) & 0xff, ((dmanr&3)<<2) + IO_DMA2_BASE );
-	}
-}
-
-
-/* Set transfer size (max 64k for DMA1..3, 128k for DMA5..7) for
- * a specific DMA channel.
- * You must ensure the parameters are valid.
- * NOTE: from a manual: "the number of transfers is one more
- * than the initial word count"! This is taken into account.
- * Assumes dma flip-flop is clear.
- * NOTE 2: "count" represents _bytes_ and must be even for channels 5-7.
- */
-static __inline__ void set_dma_count(unsigned int dmanr, unsigned int count)
-{
-        count--;
-	if (dmanr <= 3)  {
-	    dma_outb( count & 0xff, ((dmanr&3)<<1) + 1 + IO_DMA1_BASE );
-	    dma_outb( (count>>8) & 0xff, ((dmanr&3)<<1) + 1 + IO_DMA1_BASE );
-        } else {
-	    dma_outb( (count>>1) & 0xff, ((dmanr&3)<<2) + 2 + IO_DMA2_BASE );
-	    dma_outb( (count>>9) & 0xff, ((dmanr&3)<<2) + 2 + IO_DMA2_BASE );
-        }
-}
-
-
-/* Get DMA residue count. After a DMA transfer, this
- * should return zero. Reading this while a DMA transfer is
- * still in progress will return unpredictable results.
- * If called before the channel has been used, it may return 1.
- * Otherwise, it returns the number of _bytes_ left to transfer.
- *
- * Assumes DMA flip-flop is clear.
- */
-static __inline__ int get_dma_residue(unsigned int dmanr)
-{
-	unsigned int io_port = (dmanr<=3)? ((dmanr&3)<<1) + 1 + IO_DMA1_BASE
-					 : ((dmanr&3)<<2) + 2 + IO_DMA2_BASE;
-
-	/* using short to get 16-bit wrap around */
-	unsigned short count;
-
-	count = 1 + dma_inb(io_port);
-	count += dma_inb(io_port) << 8;
-	return (dmanr<=3)? count : (count<<1);
-}
-
-
-/* These are in kernel/dma.c: */
-extern int request_dma(unsigned int dmanr, const char * device_id);	/* reserve a DMA channel */
-extern void free_dma(unsigned int dmanr);	/* release it again */
-
-/* From PCI */
-
-#ifdef CONFIG_PCI
-extern int isa_dma_bridge_buggy;
-#else
-#define isa_dma_bridge_buggy 	(0)
-#endif
-
-#endif /* _ASM_MPC1211_DMA_H */
diff --git a/include/asm-sh/mpc1211/io.h b/include/asm-sh/mpc1211/io.h
deleted file mode 100644
index 6298370..0000000
--- a/include/asm-sh/mpc1211/io.h
+++ /dev/null
@@ -1,22 +0,0 @@
-/*
- * include/asm-sh/mpc1211/io.h
- *
- * Copyright 2001 Saito.K & Jeanne
- *
- * IO functions for an Interface MPC-1211
- */
-
-#ifndef _ASM_SH_IO_MPC1211_H
-#define _ASM_SH_IO_MPC1211_H
-
-#include <linux/time.h>
-
-extern int mpc1211_irq_demux(int irq);
-
-extern void init_mpc1211_IRQ(void);
-extern void heartbeat_mpc1211(void);
-
-extern void mpc1211_rtc_gettimeofday(struct timeval *tv);
-extern int mpc1211_rtc_settimeofday(const struct timeval *tv);
-
-#endif /* _ASM_SH_IO_MPC1211_H */
diff --git a/include/asm-sh/mpc1211/keyboard.h b/include/asm-sh/mpc1211/keyboard.h
deleted file mode 100644
index 9020fee..0000000
--- a/include/asm-sh/mpc1211/keyboard.h
+++ /dev/null
@@ -1,60 +0,0 @@
-/*
- *  MPC1211 specific keybord definitions
- *  Taken from the old asm-i386/keybord.h for PC/AT-style definitions
- *  created 3 Nov 1996 by Geert Uytterhoeven.
- */
-
-#ifdef __KERNEL__
-
-#include <linux/kernel.h>
-#include <linux/ioport.h>
-#include <linux/kd.h>
-#include <linux/pm.h>
-#include <asm/io.h>
-
-#define KEYBOARD_IRQ			1
-#define DISABLE_KBD_DURING_INTERRUPTS	0
-
-extern int pckbd_setkeycode(unsigned int scancode, unsigned int keycode);
-extern int pckbd_getkeycode(unsigned int scancode);
-extern int pckbd_translate(unsigned char scancode, unsigned char *keycode,
-			   char raw_mode);
-extern char pckbd_unexpected_up(unsigned char keycode);
-extern void pckbd_leds(unsigned char leds);
-extern void pckbd_init_hw(void);
-extern int pckbd_pm_resume(struct pm_dev *, pm_request_t, void *);
-extern pm_callback pm_kbd_request_override;
-
-#define kbd_setkeycode		pckbd_setkeycode
-#define kbd_getkeycode		pckbd_getkeycode
-#define kbd_translate		pckbd_translate
-#define kbd_unexpected_up	pckbd_unexpected_up
-#define kbd_leds		pckbd_leds
-#define kbd_init_hw		pckbd_init_hw
-
-/* resource allocation */
-#define kbd_request_region()
-#define kbd_request_irq(handler) request_irq(KEYBOARD_IRQ, handler, 0, \
-                                             "keyboard", NULL)
-
-/* How to access the keyboard macros on this platform.  */
-#define kbd_read_input() inb(KBD_DATA_REG)
-#define kbd_read_status() inb(KBD_STATUS_REG)
-#define kbd_write_output(val) outb(val, KBD_DATA_REG)
-#define kbd_write_command(val) outb(val, KBD_CNTL_REG)
-
-/* Some stoneage hardware needs delays after some operations.  */
-#define kbd_pause() do { } while(0)
-
-/*
- * Machine specific bits for the PS/2 driver
- */
-
-#define AUX_IRQ 12
-
-#define aux_request_irq(hand, dev_id)					\
-	request_irq(AUX_IRQ, hand, IRQF_SHARED, "PS2 Mouse", dev_id)
-
-#define aux_free_irq(dev_id) free_irq(AUX_IRQ, dev_id)
-
-#endif /* __KERNEL__ */
diff --git a/include/asm-sh/mpc1211/m1543c.h b/include/asm-sh/mpc1211/m1543c.h
deleted file mode 100644
index c95d132..0000000
--- a/include/asm-sh/mpc1211/m1543c.h
+++ /dev/null
@@ -1,200 +0,0 @@
-#ifndef __ASM_SH_M1543C_H
-#define __ASM_SH_M1543C_H
-
-/*
- * linux/include/asm-sh/m1543c.h
- * Copyright (C) 2001  Nobuhiro Sakawa
- * M1543C:PCI-ISA Bus Bridge with Super IO Chip support
- *
- * from
- *
- * linux/include/asm-sh/smc37c93x.h
- *
- * Copyright (C) 2000  Kazumoto Kojima
- *
- * SMSC 37C93x Super IO Chip support
- */
-
-/* Default base I/O address */
-#define FDC_PRIMARY_BASE	0x3f0
-#define IDE1_PRIMARY_BASE	0x1f0
-#define IDE1_SECONDARY_BASE	0x170
-#define PARPORT_PRIMARY_BASE	0x378
-#define COM1_PRIMARY_BASE	0x2f8
-#define COM2_PRIMARY_BASE	0x3f8
-#define COM3_PRIMARY_BASE	0x3e8
-#define RTC_PRIMARY_BASE	0x070
-#define KBC_PRIMARY_BASE	0x060
-#define AUXIO_PRIMARY_BASE	0x000	/* XXX */
-#define I8259_M_CR		0x20
-#define I8259_M_MR		0x21
-#define I8259_S_CR		0xa0
-#define I8259_S_MR		0xa1
-
-/* Logical device number */
-#define LDN_FDC			0
-#define LDN_IDE1		1
-#define LDN_IDE2		2
-#define LDN_PARPORT		3
-#define LDN_COM1		4
-#define LDN_COM2		5
-#define LDN_COM3		11
-#define LDN_RTC			6
-#define LDN_KBC			7
-
-/* Configuration port and key */
-#define CONFIG_PORT		0x3f0
-#define INDEX_PORT		CONFIG_PORT
-#define DATA_PORT		0x3f1
-#define CONFIG_ENTER1		0x51
-#define CONFIG_ENTER2		0x23
-#define CONFIG_EXIT		0xbb
-
-/* Configuration index */
-#define CURRENT_LDN_INDEX	0x07
-#define POWER_CONTROL_INDEX	0x22
-#define ACTIVATE_INDEX		0x30
-#define IO_BASE_HI_INDEX	0x60
-#define IO_BASE_LO_INDEX	0x61
-#define IRQ_SELECT_INDEX	0x70
-#define PS2_IRQ_INDEX		0x72
-#define DMA_SELECT_INDEX	0x74
-
-/* UART stuff. Only for debugging.  */
-/* UART Register */
-
-#define UART_RBR	0x0	/* Receiver Buffer Register (Read Only) */
-#define UART_THR	0x0	/* Transmitter Holding Register (Write Only) */
-#define UART_IER	0x2	/* Interrupt Enable Register */
-#define UART_IIR	0x4	/* Interrupt Ident Register (Read Only) */
-#define UART_FCR	0x4	/* FIFO Control Register (Write Only) */
-#define UART_LCR	0x6	/* Line Control Register */
-#define UART_MCR	0x8	/* MODEM Control Register */
-#define UART_LSR	0xa	/* Line Status Register */
-#define UART_MSR	0xc	/* MODEM Status Register */
-#define UART_SCR	0xe	/* Scratch Register */
-#define UART_DLL	0x0	/* Divisor Latch (LS) */
-#define UART_DLM	0x2	/* Divisor Latch (MS) */
-
-#ifndef __ASSEMBLY__
-typedef struct uart_reg {
-	volatile __u16 rbr;
-	volatile __u16 ier;
-	volatile __u16 iir;
-	volatile __u16 lcr;
-	volatile __u16 mcr;
-	volatile __u16 lsr;
-	volatile __u16 msr;
-	volatile __u16 scr;
-} uart_reg;
-#endif /* ! __ASSEMBLY__ */
-
-/* Alias for Write Only Register */
-
-#define thr	rbr
-#define tcr	iir
-
-/* Alias for Divisor Latch Register */
-
-#define dll	rbr
-#define dlm	ier
-#define fcr	iir
-
-/* Interrupt Enable Register */
-
-#define IER_ERDAI	0x0100	/* Enable Received Data Available Interrupt */
-#define IER_ETHREI	0x0200	/* Enable Transmitter Holding Register Empty Interrupt */
-#define IER_ELSI	0x0400	/* Enable Receiver Line Status Interrupt */
-#define IER_EMSI	0x0800	/* Enable MODEM Status Interrupt */
-
-/* Interrupt Ident Register */
-
-#define IIR_IP		0x0100	/* "0" if Interrupt Pending */
-#define IIR_IIB0	0x0200	/* Interrupt ID Bit 0 */
-#define IIR_IIB1	0x0400	/* Interrupt ID Bit 1 */
-#define IIR_IIB2	0x0800	/* Interrupt ID Bit 2 */
-#define IIR_FIFO	0xc000	/* FIFOs enabled */
-
-/* FIFO Control Register */
-
-#define FCR_FEN		0x0100	/* FIFO enable */
-#define FCR_RFRES	0x0200	/* Receiver FIFO reset */
-#define FCR_TFRES	0x0400	/* Transmitter FIFO reset */
-#define FCR_DMA		0x0800	/* DMA mode select */
-#define FCR_RTL		0x4000	/* Receiver triger (LSB) */
-#define FCR_RTM		0x8000	/* Receiver triger (MSB) */
-
-/* Line Control Register */
-
-#define LCR_WLS0	0x0100	/* Word Length Select Bit 0 */
-#define LCR_WLS1	0x0200	/* Word Length Select Bit 1 */
-#define LCR_STB		0x0400	/* Number of Stop Bits */
-#define LCR_PEN		0x0800	/* Parity Enable */
-#define LCR_EPS		0x1000	/* Even Parity Select */
-#define LCR_SP		0x2000	/* Stick Parity */
-#define LCR_SB		0x4000	/* Set Break */
-#define LCR_DLAB	0x8000	/* Divisor Latch Access Bit */
-
-/* MODEM Control Register */
-
-#define MCR_DTR		0x0100	/* Data Terminal Ready */
-#define MCR_RTS		0x0200	/* Request to Send */
-#define MCR_OUT1	0x0400	/* Out 1 */
-#define MCR_IRQEN	0x0800	/* IRQ Enable */
-#define MCR_LOOP	0x1000	/* Loop */
-
-/* Line Status Register */
-
-#define LSR_DR		0x0100	/* Data Ready */
-#define LSR_OE		0x0200	/* Overrun Error */
-#define LSR_PE		0x0400	/* Parity Error */
-#define LSR_FE		0x0800	/* Framing Error */
-#define LSR_BI		0x1000	/* Break Interrupt */
-#define LSR_THRE	0x2000	/* Transmitter Holding Register Empty */
-#define LSR_TEMT	0x4000	/* Transmitter Empty */
-#define LSR_FIFOE	0x8000	/* Receiver FIFO error */
-
-/* MODEM Status Register */
-
-#define MSR_DCTS	0x0100	/* Delta Clear to Send */
-#define MSR_DDSR	0x0200	/* Delta Data Set Ready */
-#define MSR_TERI	0x0400	/* Trailing Edge Ring Indicator */
-#define MSR_DDCD	0x0800	/* Delta Data Carrier Detect */
-#define MSR_CTS		0x1000	/* Clear to Send */
-#define MSR_DSR		0x2000	/* Data Set Ready */
-#define MSR_RI		0x4000	/* Ring Indicator */
-#define MSR_DCD		0x8000	/* Data Carrier Detect */
-
-/* Baud Rate Divisor */
-
-#define UART_CLK	(1843200)	/* 1.8432 MHz */
-#define UART_BAUD(x)	(UART_CLK / (16 * (x)))
-
-/* RTC register definition */
-#define RTC_SECONDS             0
-#define RTC_SECONDS_ALARM       1
-#define RTC_MINUTES             2
-#define RTC_MINUTES_ALARM       3
-#define RTC_HOURS               4
-#define RTC_HOURS_ALARM         5
-#define RTC_DAY_OF_WEEK         6
-#define RTC_DAY_OF_MONTH        7
-#define RTC_MONTH               8
-#define RTC_YEAR                9
-#define RTC_FREQ_SELECT		10
-# define RTC_UIP 0x80
-# define RTC_DIV_CTL 0x70
-/* This RTC can work under 32.768KHz clock only.  */
-# define RTC_OSC_ENABLE 0x20
-# define RTC_OSC_DISABLE 0x00
-#define RTC_CONTROL     	11
-# define RTC_SET 0x80
-# define RTC_PIE 0x40
-# define RTC_AIE 0x20
-# define RTC_UIE 0x10
-# define RTC_SQWE 0x08
-# define RTC_DM_BINARY 0x04
-# define RTC_24H 0x02
-# define RTC_DST_EN 0x01
-
-#endif  /* __ASM_SH_M1543C_H */
diff --git a/include/asm-sh/mpc1211/mc146818rtc.h b/include/asm-sh/mpc1211/mc146818rtc.h
deleted file mode 100644
index e245f2a..0000000
--- a/include/asm-sh/mpc1211/mc146818rtc.h
+++ /dev/null
@@ -1,6 +0,0 @@
-/*
- * MPC1211 uses PC/AT style RTC definitions.
- */
-#include <asm-x86/mc146818rtc_32.h>
-
-
diff --git a/include/asm-sh/mpc1211/mpc1211.h b/include/asm-sh/mpc1211/mpc1211.h
deleted file mode 100644
index fa456c3..0000000
--- a/include/asm-sh/mpc1211/mpc1211.h
+++ /dev/null
@@ -1,18 +0,0 @@
-#ifndef __ASM_SH_MPC1211_H
-#define __ASM_SH_MPC1211_H
-
-/*
- * linux/include/asm-sh/mpc1211.h
- *
- * Copyright (C) 2001  Saito.K & Jeanne
- *
- * Interface MPC-1211 support
- */
-
-#define PA_PCI_IO       (0xa4000000)    /* PCI I/O space */
-#define PA_PCI_MEM      (0xb0000000)    /* PCI MEM space */
-
-#define PCIPAR          (0xa4000cf8)    /* PCI Config address */
-#define PCIPDR          (0xa4000cfc)    /* PCI Config data    */
-
-#endif  /* __ASM_SH_MPC1211_H */
diff --git a/include/asm-sh/mpc1211/pci.h b/include/asm-sh/mpc1211/pci.h
deleted file mode 100644
index 5d3712c..0000000
--- a/include/asm-sh/mpc1211/pci.h
+++ /dev/null
@@ -1,40 +0,0 @@
-/*
- *	Low-Level PCI Support for MPC-1211
- *
- *      (c) 2002 Saito.K & Jeanne
- *
- */
-
-#ifndef _PCI_MPC1211_H_
-#define _PCI_MPC1211_H_
-
-#include <linux/pci.h>
-
-/* set debug level 4=verbose...1=terse */
-//#define DEBUG_PCI 3
-#undef DEBUG_PCI
-
-#ifdef DEBUG_PCI
-#define PCIDBG(n, x...) { if(DEBUG_PCI>=n) printk(x); }
-#else
-#define PCIDBG(n, x...)
-#endif
-
-/* startup values */
-#define PCI_PROBE_BIOS    1
-#define PCI_PROBE_CONF1   2
-#define PCI_PROBE_CONF2   4
-#define PCI_NO_SORT       0x100
-#define PCI_BIOS_SORT     0x200
-#define PCI_NO_CHECKS     0x400
-#define PCI_ASSIGN_ROMS   0x1000
-#define PCI_BIOS_IRQ_SCAN 0x2000
-
-/* MPC-1211 Specific Values */
-#define PCIPAR            (0xa4000cf8)    /* PCI Config address */
-#define PCIPDR            (0xa4000cfc)    /* PCI Config data    */
-
-#define PA_PCI_IO         (0xa4000000)    /* PCI I/O space */
-#define PA_PCI_MEM        (0xb0000000)    /* PCI MEM space */
-
-#endif /* _PCI_MPC1211_H_ */

