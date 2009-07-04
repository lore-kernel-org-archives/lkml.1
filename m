Return-Path: <linux-kernel-owner+w=401wt.eu-S1757196AbZGDBn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196AbZGDBn2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 21:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757034AbZGDBmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 21:42:51 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:4785 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757030AbZGDBms convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 21:42:48 -0400
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
From: "Leo (Hao) Chen" <leochen@broadcom.com>
To: "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
       "Scott Branden" <sbranden@broadcom.com>,
       "Leo (Hao) Chen" <leochen@broadcom.com>
Date: Fri, 3 Jul 2009 18:42:39 -0700
Subject: [PATCH v2 3/18] new ARM SoC support: BCMRing
Thread-Topic: [PATCH v2 3/18] new ARM SoC support: BCMRing
Thread-Index: Acn8SLa3oszDjO0TQVihqus8B+1UCg==
Message-ID: <8628FE4E7912BF47A96AE7DD7BAC0AADCB25BA6C10@SJEXCHCCR02.corp.ad.broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
X-WSS-ID: 66506C1A4CG20366355-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 8e210728566d73fbb25b48de611d786d9fb1ddf3 Mon Sep 17 00:00:00 2001
From: Leo Chen <leochen@broadcom.com>
Date: Fri, 3 Jul 2009 16:18:06 -0700
Subject: [PATCH 03/18] add arch/arm/mach-bcmring/arch.c

add arch.c with machine description,
init_machine function

add cfg_global header files

add include/mach/csp/mm_*.h header files for memory map and io address

add basic include/mach/system.h and include/mach/hardware.h

Signed-off-by: Leo Chen <leochen@broadcom.com>
---
 arch/arm/mach-bcmring/arch.c                       |  174 ++++++++++++++++++++
 arch/arm/mach-bcmring/include/cfg_global.h         |   16 ++
 arch/arm/mach-bcmring/include/cfg_global_defines.h |   51 ++++++
 arch/arm/mach-bcmring/include/mach/csp/mm_addr.h   |  101 +++++++++++
 arch/arm/mach-bcmring/include/mach/csp/mm_io.h     |  160 ++++++++++++++++++
 arch/arm/mach-bcmring/include/mach/hardware.h      |   62 +++++++
 arch/arm/mach-bcmring/include/mach/system.h        |   54 ++++++
 7 files changed, 618 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-bcmring/arch.c
 create mode 100644 arch/arm/mach-bcmring/include/cfg_global.h
 create mode 100644 arch/arm/mach-bcmring/include/cfg_global_defines.h
 create mode 100644 arch/arm/mach-bcmring/include/mach/csp/mm_addr.h
 create mode 100644 arch/arm/mach-bcmring/include/mach/csp/mm_io.h
 create mode 100644 arch/arm/mach-bcmring/include/mach/hardware.h
 create mode 100644 arch/arm/mach-bcmring/include/mach/system.h

diff --git a/arch/arm/mach-bcmring/arch.c b/arch/arm/mach-bcmring/arch.c
new file mode 100644
index 0000000..82f8ae7
--- /dev/null
+++ b/arch/arm/mach-bcmring/arch.c
@@ -0,0 +1,174 @@
+/*****************************************************************************
+* Copyright 2003 - 2008 Broadcom Corporation.  All rights reserved.
+*
+* Unless you and Broadcom execute a separate written software license
+* agreement governing use of this software, this software is licensed to you
+* under the terms of the GNU General Public License version 2, available at
+* http://www.broadcom.com/licenses/GPLv2.php (the "GPL").
+*
+* Notwithstanding the above, under no circumstances may you combine this
+* software in any way with any other Broadcom software provided under a
+* license other than the GPL, without Broadcom's express prior written
+* consent.
+*****************************************************************************/
+
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <linux/version.h>
+#include <linux/types.h>
+#include <linux/sched.h>
+#include <linux/interrupt.h>
+#include <linux/init.h>
+#include <linux/errno.h>
+#include <linux/spinlock.h>
+#include <linux/module.h>
+
+#include <linux/proc_fs.h>
+#include <linux/sysctl.h>
+
+#include <asm/irq.h>
+#include <asm/setup.h>
+#include <asm/mach-types.h>
+#include <asm/mach/time.h>
+
+#include <asm/mach/arch.h>
+#include <mach/dma.h>
+#include <mach/hardware.h>
+#include <mach/csp/mm_io.h>
+#include <mach/csp/chipcHw_def.h>
+#include <mach/csp/chipcHw_inline.h>
+
+#include <cfg_global.h>
+
+#include "core.h"
+
+HW_DECLARE_SPINLOCK(arch)
+HW_DECLARE_SPINLOCK(gpio)
+#if defined(CONFIG_DEBUG_SPINLOCK)
+    EXPORT_SYMBOL(bcmring_gpio_reg_lock);
+#endif
+
+/* FIXME: temporary solution */
+#define BCM_SYSCTL_REBOOT_WARM               1
+#define CTL_BCM_REBOOT                 112
+
+/* sysctl */
+int bcmring_arch_warm_reboot;  /* do a warm reboot on hard reset */
+
+static struct ctl_table_header *bcmring_sysctl_header;
+
+static struct ctl_table bcmring_sysctl_warm_reboot[] = {
+       {
+        .ctl_name = BCM_SYSCTL_REBOOT_WARM,
+        .procname = "warm",
+        .data = &bcmring_arch_warm_reboot,
+        .maxlen = sizeof(int),
+        .mode = 0644,
+        .proc_handler = &proc_dointvec},
+       {}
+};
+
+static struct ctl_table bcmring_sysctl_reboot[] = {
+       {
+        .ctl_name = CTL_BCM_REBOOT,
+        .procname = "reboot",
+        .mode = 0555,
+        .child = bcmring_sysctl_warm_reboot},
+       {}
+};
+
+extern void bcmring_map_io(void);
+extern void bcmring_init_irq(void);
+extern void bcmring_init_timer(void);
+
+static struct platform_device nand_device = {
+       .name = "bcm-nand",
+       .id = -1,
+};
+
+static struct platform_device *devices[] __initdata = {
+       &nand_device,
+};
+
+/****************************************************************************
+*
+*   Called from the customize_machine function in arch/arm/kernel/setup.c
+*
+*   The customize_machine function is tagged as an arch_initcall
+*   (see include/linux/init.h for the order that the various init sections
+*   are called in.
+*
+*****************************************************************************/
+static void __init bcmring_init_machine(void)
+{
+
+       bcmring_sysctl_header = register_sysctl_table(bcmring_sysctl_reboot);
+
+       /* Enable spread spectrum */
+       chipcHw_enableSpreadSpectrum();
+
+       platform_add_devices(devices, ARRAY_SIZE(devices));
+
+       bcmring_amba_init();
+
+       dma_init();
+}
+
+/****************************************************************************
+*
+*   Called from setup_arch (in arch/arm/kernel/setup.c) to fixup any tags
+*   passed in by the boot loader.
+*
+*****************************************************************************/
+
+static void __init bcmring_fixup
+    (struct machine_desc *desc,
+     struct tag *t, char **cmdline, struct meminfo *mi) {
+#ifdef CONFIG_BLK_DEV_INITRD
+       printk(KERN_NOTICE "bcmring_fixup\n");
+       t->hdr.tag = ATAG_CORE;
+       t->hdr.size = tag_size(tag_core);
+       t->u.core.flags = 0;
+       t->u.core.pagesize = PAGE_SIZE;
+       t->u.core.rootdev = 31 << 8 | 0;
+       t = tag_next(t);
+
+       t->hdr.tag = ATAG_MEM;
+       t->hdr.size = tag_size(tag_mem32);
+       t->u.mem.start = CFG_GLOBAL_RAM_BASE;
+       t->u.mem.size = CFG_GLOBAL_RAM_SIZE;
+
+       t = tag_next(t);
+
+       t->hdr.tag = ATAG_NONE;
+       t->hdr.size = 0;
+#endif
+}
+
+/****************************************************************************
+*
+*   Timer related information. bcmring_init_timer is called from
+*   time_init (in arch/arm/kernel/time.c).
+*
+*****************************************************************************/
+
+static struct sys_timer bcmring_timer = {
+       .init = bcmring_init_timer,
+};
+
+/****************************************************************************
+*
+*   Machine Description
+*
+*****************************************************************************/
+
+MACHINE_START(BCMRING, "BCMRING")
+    /* Maintainer: Broadcom Corporation */
+    .phys_io = IO_START,
+        .io_pg_offst = (IO_BASE >> 18) & 0xfffc,
+        .fixup = bcmring_fixup,
+        .map_io = bcmring_map_io,
+        .init_irq = bcmring_init_irq,
+        .timer = &bcmring_timer,
+        .init_machine = bcmring_init_machine
+ MACHINE_END
diff --git a/arch/arm/mach-bcmring/include/cfg_global.h b/arch/arm/mach-bcmring/include/cfg_global.h
new file mode 100644
index 0000000..c71ed0a
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/cfg_global.h
@@ -0,0 +1,16 @@
+#ifndef _CFG_GLOBAL_H_
+#define _CFG_GLOBAL_H_
+
+#include <cfg_global_defines.h>
+
+#define CFG_GLOBAL_CHIP                         BCM11107
+#define CFG_GLOBAL_CHIP_FAMILY                  CFG_GLOBAL_CHIP_FAMILY_BCMRING
+#define CFG_GLOBAL_CHIP_REV                     0xA0
+#define CFG_GLOBAL_CPU                          ARM11
+#define CFG_GLOBAL_CPU_ENDIAN                   le
+#define CFG_GLOBAL_RAM_SIZE                     0x10000000
+#define CFG_GLOBAL_RAM_BASE                     0x00000000
+#define CFG_GLOBAL_RAM_RESERVED_SIZE            0x000000
+#define CFG_GLOBAL_RTLSIM_SUPPORT               1
+
+#endif /* _CFG_GLOBAL_H_ */
diff --git a/arch/arm/mach-bcmring/include/cfg_global_defines.h b/arch/arm/mach-bcmring/include/cfg_global_defines.h
new file mode 100644
index 0000000..be573c9
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/cfg_global_defines.h
@@ -0,0 +1,51 @@
+/*****************************************************************************
+* Copyright 2006 - 2008 Broadcom Corporation.  All rights reserved.
+*
+* Unless you and Broadcom execute a separate written software license
+* agreement governing use of this software, this software is licensed to you
+* under the terms of the GNU General Public License version 2, available at
+* http://www.broadcom.com/licenses/GPLv2.php (the "GPL").
+*
+* Notwithstanding the above, under no circumstances may you combine this
+* software in any way with any other Broadcom software provided under a
+* license other than the GPL, without Broadcom's express prior written
+* consent.
+*****************************************************************************/
+
+#ifndef CFG_GLOBAL_DEFINES_H
+#define CFG_GLOBAL_DEFINES_H
+
+/* CPU */
+#define   ARMEB  1
+#define   MIPS32 2
+#define   ARM9   3
+#define   ARM11  4
+
+/* CHIP */
+#define BCM1103 1
+
+#define BCM1191 4
+#define BCM2153 5
+#define BCM2820 6
+
+#define BCM2826 8
+#define FPGA11107 9
+#define BCM11107   10
+#define BCM11109   11
+#define BCM11170   12
+#define BCM11110   13
+#define BCM11211   14
+
+/* CFG_GLOBAL_CHIP_FAMILY types */
+#define CFG_GLOBAL_CHIP_FAMILY_NONE        0
+#define CFG_GLOBAL_CHIP_FAMILY_BCM116X     2
+#define CFG_GLOBAL_CHIP_FAMILY_BCMRING     4
+#define CFG_GLOBAL_CHIP_FAMILY_BCM1103     8
+
+/* CFG_GLOBAL_ROOT_FILE_SYSTEM */
+#define JFFS2_RFS      1
+#define CRAMFS_RFS     2
+#define INITRAMFS      3
+
+#define IMAGE_HEADER_SIZE_CHECKSUM    4
+#endif
diff --git a/arch/arm/mach-bcmring/include/mach/csp/mm_addr.h b/arch/arm/mach-bcmring/include/mach/csp/mm_addr.h
new file mode 100644
index 0000000..86bb58d
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/mach/csp/mm_addr.h
@@ -0,0 +1,101 @@
+/*****************************************************************************
+* Copyright 2003 - 2008 Broadcom Corporation.  All rights reserved.
+*
+* Unless you and Broadcom execute a separate written software license
+* agreement governing use of this software, this software is licensed to you
+* under the terms of the GNU General Public License version 2, available at
+* http://www.broadcom.com/licenses/GPLv2.php (the "GPL").
+*
+* Notwithstanding the above, under no circumstances may you combine this
+* software in any way with any other Broadcom software provided under a
+* license other than the GPL, without Broadcom's express prior written
+* consent.
+*****************************************************************************/
+
+/****************************************************************************/
+/**
+*  @file    mm_addr.h
+*
+*  @brief   Memory Map address defintions
+*
+*  @note
+*     None
+*/
+/****************************************************************************/
+
+#ifndef _MM_ADDR_H
+#define _MM_ADDR_H
+
+/* ---- Include Files ---------------------------------------------------- */
+
+#if !defined(CSP_SIMULATION)
+#include <cfg_global.h>
+#endif
+
+/* ---- Public Constants and Types --------------------------------------- */
+
+/*  Memory Map address definitions */
+
+#define MM_ADDR_DDR                0x00000000
+
+#define MM_ADDR_IO_VPM_EXTMEM_RSVD 0x0F000000  /* 16 MB - Reserved external memory for VPM use */
+
+#define MM_ADDR_IO_FLASHC          0x20000000
+#define MM_ADDR_IO_BROM            0x30000000
+#define MM_ADDR_IO_ARAM            0x30100000  /* 64 KB - extra cycle latency - WS switch */
+#define MM_ADDR_IO_DMA0            0x30200000
+#define MM_ADDR_IO_DMA1            0x30300000
+#define MM_ADDR_IO_ESW             0x30400000
+#define MM_ADDR_IO_CLCD            0x30500000
+#define MM_ADDR_IO_PIF             0x30580000
+#define MM_ADDR_IO_APM             0x30600000
+#define MM_ADDR_IO_SPUM            0x30700000
+#define MM_ADDR_IO_VPM_PROG        0x30800000
+#define MM_ADDR_IO_VPM_DATA        0x30A00000
+#define MM_ADDR_IO_VRAM            0x40000000  /* 64 KB  - security block in front of it */
+#define MM_ADDR_IO_CHIPC           0x80000000
+#define MM_ADDR_IO_UMI             0x80001000
+#define MM_ADDR_IO_NAND            0x80001800
+#define MM_ADDR_IO_LEDM            0x80002000
+#define MM_ADDR_IO_PWM             0x80002040
+#define MM_ADDR_IO_VINTC           0x80003000
+#define MM_ADDR_IO_GPIO0           0x80004000
+#define MM_ADDR_IO_GPIO1           0x80004800
+#define MM_ADDR_IO_I2CS            0x80005000
+#define MM_ADDR_IO_SPIS            0x80006000
+#define MM_ADDR_IO_HPM             0x80007400
+#define MM_ADDR_IO_HPM_REMAP       0x80007800
+#define MM_ADDR_IO_TZPC            0x80008000
+#define MM_ADDR_IO_MPU             0x80009000
+#define MM_ADDR_IO_SPUMP           0x8000a000
+#define MM_ADDR_IO_PKA             0x8000b000
+#define MM_ADDR_IO_RNG             0x8000c000
+#define MM_ADDR_IO_KEYC            0x8000d000
+#define MM_ADDR_IO_BBL             0x8000e000
+#define MM_ADDR_IO_OTP             0x8000f000
+#define MM_ADDR_IO_I2S0            0x80010000
+#define MM_ADDR_IO_I2S1            0x80011000
+#define MM_ADDR_IO_UARTA           0x80012000
+#define MM_ADDR_IO_UARTB           0x80013000
+#define MM_ADDR_IO_I2CH            0x80014020
+#define MM_ADDR_IO_SPIH            0x80015000
+#define MM_ADDR_IO_TSC             0x80016000
+#define MM_ADDR_IO_TMR             0x80017000
+#define MM_ADDR_IO_WATCHDOG        0x80017800
+#define MM_ADDR_IO_ETM             0x80018000
+#define MM_ADDR_IO_DDRC            0x80019000
+#define MM_ADDR_IO_SINTC           0x80100000
+#define MM_ADDR_IO_INTC0           0x80200000
+#define MM_ADDR_IO_INTC1           0x80201000
+#define MM_ADDR_IO_GE              0x80300000
+#define MM_ADDR_IO_USB_CTLR0       0x80400000
+#define MM_ADDR_IO_USB_CTLR1       0x80410000
+#define MM_ADDR_IO_USB_PHY         0x80420000
+#define MM_ADDR_IO_SDIOH0          0x80500000
+#define MM_ADDR_IO_SDIOH1          0x80600000
+#define MM_ADDR_IO_VDEC            0x80700000
+
+/* ---- Public Variable Externs ------------------------------------------ */
+/* ---- Public Function Prototypes --------------------------------------- */
+
+#endif /* _MM_ADDR_H */
diff --git a/arch/arm/mach-bcmring/include/mach/csp/mm_io.h b/arch/arm/mach-bcmring/include/mach/csp/mm_io.h
new file mode 100644
index 0000000..887311d
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/mach/csp/mm_io.h
@@ -0,0 +1,160 @@
+/*****************************************************************************
+* Copyright 2003 - 2008 Broadcom Corporation.  All rights reserved.
+*
+* Unless you and Broadcom execute a separate written software license
+* agreement governing use of this software, this software is licensed to you
+* under the terms of the GNU General Public License version 2, available at
+* http://www.broadcom.com/licenses/GPLv2.php (the "GPL").
+*
+* Notwithstanding the above, under no circumstances may you combine this
+* software in any way with any other Broadcom software provided under a
+* license other than the GPL, without Broadcom's express prior written
+* consent.
+*****************************************************************************/
+
+/****************************************************************************/
+/**
+*  @file    mm_io.h
+*
+*  @brief   Memory Map I/O definitions
+*
+*  @note
+*     None
+*/
+/****************************************************************************/
+
+#ifndef _MM_IO_H
+#define _MM_IO_H
+
+/* ---- Include Files ---------------------------------------------------- */
+#include <mach/csp/mm_addr.h>
+
+#if !defined(CSP_SIMULATION)
+#include <cfg_global.h>
+#endif
+
+/* ---- Public Constants and Types --------------------------------------- */
+
+#if defined(CONFIG_MMU)
+
+/* This macro is referenced in <mach/io.h> */
+
+#ifndef MM_IO_PHYS_TO_VIRT
+
+#ifdef __ASSEMBLY__
+
+#define MM_IO_PHYS_TO_VIRT(phys) (0xF0000000 | (((phys) >> 4) & 0x0F000000) | ((phys) & 0xFFFFFF))
+
+#else
+
+#define MM_IO_PHYS_TO_VIRT(phys)                                           \
+((((phys) >= 0x20000000) && ((phys) < 0x30000000)) ?                      \
+/* Phys to Virtual 0x2xxxxxxx => 0xExxxxxxx */                             \
+((phys) | 0xC0000000) :                                                    \
+/* Explicitly map phys addr MM_ADDR_IO_VPM_EXTMEM_RSVD to virt addr 0xF0000000. This */   \
+/* address range is reserved for VPM external prog and data memories. */   \
+(((phys) == MM_ADDR_IO_VPM_EXTMEM_RSVD) ? 0xF0000000 :                                    \
+/* Phys to Virtual 0xNyxxxxxx => 0xFNxxxxxx where N != 2 */                \
+(0xF0000000 | (((phys) >> 4) & 0x0F000000) | ((phys) & 0xFFFFFF))))
+
+#endif
+
+#endif
+
+#ifndef MM_IO_VIRT_TO_PHYS
+
+#ifdef __ASSEMBLY__
+#define MM_IO_VIRT_TO_PHYS(virt) ((((virt) & 0x0F000000) << 4) | ((virt) & 0xFFFFFF))
+#else
+#define MM_IO_VIRT_TO_PHYS(virt) ((((virt) & 0xF0000000) == 0xE0000000) ?  \
+/* Virtual to Physical 0xExxxxxxx => 0x2xxxxxxx */                         \
+(((virt) & ~0xF0000000) | 0x20000000)  :                                   \
+/* Explicitly map phys addr MM_ADDR_IO_VPM_EXTMEM_RSVD to virt addr 0xF0000000. This */   \
+/* address range is reserved for VPM external prog and data memories. */   \
+(((virt) == 0xF0000000) ? MM_ADDR_IO_VPM_EXTMEM_RSVD : \
+/* Virtual to Physical 0xFNxxxxxx => 0xN0xxxxxx */                         \
+((((virt) & 0x0F000000) << 4) | ((virt) & 0xFFFFFF))))
+
+#endif
+#endif
+
+#else
+
+#ifndef MM_IO_PHYS_TO_VIRT
+#define MM_IO_PHYS_TO_VIRT(phys)       (phys)
+#endif
+
+#ifndef MM_IO_VIRT_TO_PHYS
+#define MM_IO_VIRT_TO_PHYS(virt)       (virt)
+#endif
+
+#endif
+
+/* Registers in 0xExxxxxxx that should be moved to 0xFxxxxxxx */
+#define MM_IO_BASE_FLASHC              MM_IO_PHYS_TO_VIRT(MM_ADDR_IO_FLASHC)
+#define MM_IO_BASE_NAND                MM_IO_PHYS_TO_VIRT(MM_ADDR_IO_NAND)
+#define MM_IO_BASE_UMI                 MM_IO_PHYS_TO_VIRT(MM_ADDR_IO_UMI)
+
+#define MM_IO_START MM_ADDR_IO_FLASHC  /* Physical beginning of IO mapped memory */
+#define MM_IO_BASE  MM_IO_BASE_FLASHC  /* Virtual beginning of IO mapped memory */
+
+#define MM_IO_BASE_BROM                MM_IO_PHYS_TO_VIRT(MM_ADDR_IO_BROM)
+#define MM_IO_BASE_ARAM                MM_IO_PHYS_TO_VIRT(MM_ADDR_IO_ARAM)
+#define MM_IO_BASE_DMA0                MM_IO_PHYS_TO_VIRT(MM_ADDR_IO_DMA0)
+#define MM_IO_BASE_DMA1                MM_IO_PHYS_TO_VIRT(MM_ADDR_IO_DMA1)
+#define MM_IO_BASE_ESW                 MM_IO_PHYS_TO_VIRT(MM_ADDR_IO_ESW)
+#define MM_IO_BASE_CLCD                MM_IO_PHYS_TO_VIRT(MM_ADDR_IO_CLCD)
+#define MM_IO_BASE_PIF                 MM_IO_PHYS_TO_VIRT(MM_ADDR_IO_PIF)
+#define MM_IO_BASE_APM                 MM_IO_PHYS_TO_VIRT(MM_ADDR_IO_APM)
+#define MM_IO_BASE_SPUM                MM_IO_PHYS_TO_VIRT(MM_ADDR_IO_SPUM)
+#define MM_IO_BASE_VPM_PROG            MM_IO_PHYS_TO_VIRT(MM_ADDR_IO_VPM_PROG)
+#define MM_IO_BASE_VPM_DATA            MM_IO_PHYS_TO_VIRT(MM_ADDR_IO_VPM_DATA)
+
+#define MM_IO_BASE_VRAM                MM_IO_PHYS_TO_VIRT(MM_ADDR_IO_VRAM)
+
+#define MM_IO_BASE_CHIPC               MM_IO_PHYS_TO_VIRT(MM_ADDR_IO_CHIPC)
+#define MM_IO_BASE_DDRC                MM_IO_PHYS_TO_VIRT(MM_ADDR_IO_DDRC)
+#define MM_IO_BASE_LEDM                MM_IO_PHYS_TO_VIRT(MM_ADDR_IO_LEDM)
+#define MM_IO_BASE_PWM                 MM_IO_PHYS_TO_VIRT(MM_ADDR_IO_PWM)
+#define MM_IO_BASE_VINTC               MM_IO_PHYS_TO_VIRT(MM_ADDR_IO_VINTC)
+#define MM_IO_BASE_GPIO0               MM_IO_PHYS_TO_VIRT(MM_ADDR_IO_GPIO0)
+#define MM_IO_BASE_GPIO1               MM_IO_PHYS_TO_VIRT(MM_ADDR_IO_GPIO1)
+#define MM_IO_BASE_TMR                 MM_IO_PHYS_TO_VIRT(MM_ADDR_IO_TMR)
+#define MM_IO_BASE_WATCHDOG            MM_IO_PHYS_TO_VIRT(MM_ADDR_IO_WATCHDOG)
+#define MM_IO_BASE_ETM                 MM_IO_PHYS_TO_VIRT(MM_ADDR_IO_ETM)
+#define MM_IO_BASE_HPM                 MM_IO_PHYS_TO_VIRT(MM_ADDR_IO_HPM)
+#define MM_IO_BASE_HPM_REMAP           MM_IO_PHYS_TO_VIRT(MM_ADDR_IO_HPM_REMAP)
+#define MM_IO_BASE_TZPC                MM_IO_PHYS_TO_VIRT(MM_ADDR_IO_TZPC)
+#define MM_IO_BASE_MPU                 MM_IO_PHYS_TO_VIRT(MM_ADDR_IO_MPU)
+#define MM_IO_BASE_SPUMP               MM_IO_PHYS_TO_VIRT(MM_ADDR_IO_SPUMP)
+#define MM_IO_BASE_PKA                 MM_IO_PHYS_TO_VIRT(MM_ADDR_IO_PKA)
+#define MM_IO_BASE_RNG                 MM_IO_PHYS_TO_VIRT(MM_ADDR_IO_RNG)
+#define MM_IO_BASE_KEYC                MM_IO_PHYS_TO_VIRT(MM_ADDR_IO_KEYC)
+#define MM_IO_BASE_BBL                 MM_IO_PHYS_TO_VIRT(MM_ADDR_IO_BBL)
+#define MM_IO_BASE_OTP                 MM_IO_PHYS_TO_VIRT(MM_ADDR_IO_OTP)
+#define MM_IO_BASE_I2S0                MM_IO_PHYS_TO_VIRT(MM_ADDR_IO_I2S0)
+#define MM_IO_BASE_I2S1                MM_IO_PHYS_TO_VIRT(MM_ADDR_IO_I2S1)
+#define MM_IO_BASE_UARTA               MM_IO_PHYS_TO_VIRT(MM_ADDR_IO_UARTA)
+#define MM_IO_BASE_UARTB               MM_IO_PHYS_TO_VIRT(MM_ADDR_IO_UARTB)
+#define MM_IO_BASE_I2CH                MM_IO_PHYS_TO_VIRT(MM_ADDR_IO_I2CH)
+#define MM_IO_BASE_SPIH                MM_IO_PHYS_TO_VIRT(MM_ADDR_IO_SPIH)
+#define MM_IO_BASE_TSC                 MM_IO_PHYS_TO_VIRT(MM_ADDR_IO_TSC)
+#define MM_IO_BASE_I2CS                MM_IO_PHYS_TO_VIRT(MM_ADDR_IO_I2CS)
+#define MM_IO_BASE_SPIS                MM_IO_PHYS_TO_VIRT(MM_ADDR_IO_SPIS)
+#define MM_IO_BASE_SINTC               MM_IO_PHYS_TO_VIRT(MM_ADDR_IO_SINTC)
+#define MM_IO_BASE_INTC0               MM_IO_PHYS_TO_VIRT(MM_ADDR_IO_INTC0)
+#define MM_IO_BASE_INTC1               MM_IO_PHYS_TO_VIRT(MM_ADDR_IO_INTC1)
+#define MM_IO_BASE_GE                  MM_IO_PHYS_TO_VIRT(MM_ADDR_IO_GE)
+#define MM_IO_BASE_USB_CTLR0           MM_IO_PHYS_TO_VIRT(MM_ADDR_IO_USB_CTLR0)
+#define MM_IO_BASE_USB_CTLR1           MM_IO_PHYS_TO_VIRT(MM_ADDR_IO_USB_CTLR1)
+#define MM_IO_BASE_USB_PHY             MM_IO_PHYS_TO_VIRT(MM_ADDR_IO_USB_PHY)
+#define MM_IO_BASE_SDIOH0              MM_IO_PHYS_TO_VIRT(MM_ADDR_IO_SDIOH0)
+#define MM_IO_BASE_SDIOH1              MM_IO_PHYS_TO_VIRT(MM_ADDR_IO_SDIOH1)
+#define MM_IO_BASE_VDEC                MM_IO_PHYS_TO_VIRT(MM_ADDR_IO_VDEC)
+
+#define MM_IO_BASE_VPM_EXTMEM_RSVD     MM_IO_PHYS_TO_VIRT(MM_ADDR_IO_VPM_EXTMEM_RSVD)
+
+/* ---- Public Variable Externs ------------------------------------------ */
+/* ---- Public Function Prototypes --------------------------------------- */
+
+#endif /* _MM_IO_H */
diff --git a/arch/arm/mach-bcmring/include/mach/hardware.h b/arch/arm/mach-bcmring/include/mach/hardware.h
new file mode 100644
index 0000000..74eb129
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/mach/hardware.h
@@ -0,0 +1,62 @@
+/*
+ *
+ *  This file contains the hardware definitions of the BCM116X.
+ *
+ *  Copyright (C) 1999 ARM Limited.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+#ifndef __ASM_ARCH_HARDWARE_H
+#define __ASM_ARCH_HARDWARE_H
+
+#include <asm/sizes.h>
+#include <mach/memory.h>
+#include <cfg_global.h>
+#include <mach/csp/mm_io.h>
+
+/* Hardware addresses of major areas.
+ *  *_START is the physical address
+ *  *_SIZE  is the size of the region
+ *  *_BASE  is the virtual address
+ */
+#define RAM_START               PHYS_OFFSET
+
+#define RAM_SIZE                (CFG_GLOBAL_RAM_SIZE-CFG_GLOBAL_RAM_SIZE_RESERVED)
+#define RAM_BASE                PAGE_OFFSET
+
+#define pcibios_assign_all_busses()    1
+
+/* Macros to make managing spinlocks a bit more controlled in terms of naming. */
+/* See reg_gpio.h, reg_irq.h, arch.c, gpio.c for example usage. */
+#if defined(__KERNEL__)
+#define HW_DECLARE_SPINLOCK(name)  spinlock_t bcmring_arch_##name##_reg_lock = __SPIN_LOCK_UNLOCKED();
+#define HW_EXTERN_SPINLOCK(name)   extern spinlock_t bcmring_##name##_reg_lock;
+#define HW_IRQ_SAVE(name, val)     spin_lock_irqsave(&bcmring_##name##_reg_lock, (val))
+#define HW_IRQ_RESTORE(name, val)  spin_unlock_irqrestore(&bcmring_##name##_reg_lock, (val))
+#else
+#define HW_DECLARE_SPINLOCK(name)
+#define HW_EXTERN_SPINLOCK(name)
+#define HW_IRQ_SAVE(name, val)     {(void)(name); (void)(val); }
+#define HW_IRQ_RESTORE(name, val)  {(void)(name); (void)(val); }
+#endif
+
+#define IO_START MM_IO_START
+#define IO_BASE  MM_IO_BASE
+#ifndef HW_IO_PHYS_TO_VIRT
+#define HW_IO_PHYS_TO_VIRT MM_IO_PHYS_TO_VIRT
+#endif
+#define HW_IO_VIRT_TO_PHYS MM_IO_VIRT_TO_PHYS
+
+#endif
diff --git a/arch/arm/mach-bcmring/include/mach/system.h b/arch/arm/mach-bcmring/include/mach/system.h
new file mode 100644
index 0000000..cdbf93c
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/mach/system.h
@@ -0,0 +1,54 @@
+/*
+ *
+ *  Copyright (C) 1999 ARM Limited
+ *  Copyright (C) 2000 Deep Blue Solutions Ltd
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+#ifndef __ASM_ARCH_SYSTEM_H
+#define __ASM_ARCH_SYSTEM_H
+
+#include <mach/csp/chipcHw_inline.h>
+
+extern int bcmring_arch_warm_reboot;
+
+static inline void arch_idle(void)
+{
+       cpu_do_idle();
+}
+
+static inline void arch_reset(char mode, char *cmd)
+{
+       printk("arch_reset:%c %x\n", mode, bcmring_arch_warm_reboot);
+
+       if (mode == 'h') {
+               /* Reboot configured in proc entry */
+               if (bcmring_arch_warm_reboot) {
+                       printk("warm reset\n");
+                       /* Issue Warm reset (do not reset ethernet switch, keep alive) */
+                       chipcHw_reset(chipcHw_REG_SOFT_RESET_CHIP_WARM);
+               } else {
+                       /* Force reset of everything */
+                       printk("force reset\n");
+                       chipcHw_reset(chipcHw_REG_SOFT_RESET_CHIP_SOFT);
+               }
+       } else {
+               /* Force reset of everything */
+               printk("force reset\n");
+               chipcHw_reset(chipcHw_REG_SOFT_RESET_CHIP_SOFT);
+       }
+}
+
+#endif
--
1.6.0.6


Leo Hao Chen
Software Engineer
Broadcom Canada Inc.


