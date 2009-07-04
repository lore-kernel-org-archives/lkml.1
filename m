Return-Path: <linux-kernel-owner+w=401wt.eu-S1758667AbZGDBoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758667AbZGDBoQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 21:44:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758173AbZGDBnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 21:43:45 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:1777 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758255AbZGDBnn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 21:43:43 -0400
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
Date: Fri, 3 Jul 2009 18:43:33 -0700
Subject: [PATCH v2 6/18] new ARM SoC support: BCMRing
Thread-Topic: [PATCH v2 6/18] new ARM SoC support: BCMRing
Thread-Index: Acn8SNdvx42cFDVXQWGYNuN9rUdIMw==
Message-ID: <8628FE4E7912BF47A96AE7DD7BAC0AADCB25BA6C13@SJEXCHCCR02.corp.ad.broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
X-WSS-ID: 66506C4D4CG20367270-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 22455371f1771769f747db9d735a9856e9d03431 Mon Sep 17 00:00:00 2001
From: Leo Chen <leochen@broadcom.com>
Date: Fri, 3 Jul 2009 16:23:10 -0700
Subject: [PATCH 06/18] add mach-bcmring/irq.c

init irq and handler for bcmring
add irq controller register file

Signed-off-by: Leo Chen <leochen@broadcom.com>
---
 arch/arm/mach-bcmring/include/csp/intcHw.h         |   45 ++++
 .../arm/mach-bcmring/include/mach/csp/intcHw_reg.h |  270 ++++++++++++++++++++
 arch/arm/mach-bcmring/irq.c                        |  127 +++++++++
 3 files changed, 442 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-bcmring/include/csp/intcHw.h
 create mode 100644 arch/arm/mach-bcmring/include/mach/csp/intcHw_reg.h
 create mode 100644 arch/arm/mach-bcmring/irq.c

diff --git a/arch/arm/mach-bcmring/include/csp/intcHw.h b/arch/arm/mach-bcmring/include/csp/intcHw.h
new file mode 100644
index 0000000..1781209
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/csp/intcHw.h
@@ -0,0 +1,45 @@
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
+
+/****************************************************************************/
+/**
+*  @file    intcHw.h
+*
+*  @brief   generic interrupt controller API
+*
+*  @note
+*     None
+*/
+/****************************************************************************/
+
+#ifndef _INTCHW_H
+#define _INTCHW_H
+
+/* ---- Include Files ---------------------------------------------------- */
+#include <mach/csp/intcHw_reg.h>
+
+/* ---- Public Constants and Types --------------------------------------- */
+/* ---- Public Variable Externs ------------------------------------------ */
+/* ---- Public Function Prototypes --------------------------------------- */
+static inline void intcHw_irq_disable(void *basep, uint32_t mask);
+static inline void intcHw_irq_enable(void *basep, uint32_t mask);
+static inline void intcHw_irq_type(void *basep, uint32_t mask);
+static inline uint32_t intcHw_rawstatus(void *basep);
+static inline uint32_t intcHw_irq_status(void *basep);
+static inline uint32_t intcHw_fiq_status(void *basep);
+
+
+#endif /* _INTCHW_H */
+
diff --git a/arch/arm/mach-bcmring/include/mach/csp/intcHw_reg.h b/arch/arm/mach-bcmring/include/mach/csp/intcHw_reg.h
new file mode 100644
index 0000000..e9c6279
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/mach/csp/intcHw_reg.h
@@ -0,0 +1,270 @@
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
+*  @file    intcHw_reg.h
+*
+*  @brief   platform specific interrupt controller bit assignments
+*
+*  @note
+*     None
+*/
+/****************************************************************************/
+
+#ifndef _INTCHW_REG_H
+#define _INTCHW_REG_H
+
+/* ---- Include Files ---------------------------------------------------- */
+#include <csp/stdint.h>
+#include <csp/reg.h>
+#include <mach/csp/mm_io.h>
+
+/* ---- Public Constants and Types --------------------------------------- */
+
+#define INTCHW_NUM_IRQ_PER_INTC   32   /* Maximum number of interrupt controllers */
+#define INTCHW_NUM_INTC           3
+
+/* Defines for interrupt controllers. This simplifies and cleans up the function calls. */
+#define INTCHW_INTC0    ((void *)MM_IO_BASE_INTC0)
+#define INTCHW_INTC1    ((void *)MM_IO_BASE_INTC1)
+#define INTCHW_SINTC    ((void *)MM_IO_BASE_SINTC)
+
+/* INTC0 - interrupt controller 0 */
+#define INTCHW_INTC0_PIF_BITNUM           31   /* Peripheral interface interrupt */
+#define INTCHW_INTC0_CLCD_BITNUM          30   /* LCD Controller interrupt */
+#define INTCHW_INTC0_GE_BITNUM            29   /* Graphic engine interrupt */
+#define INTCHW_INTC0_APM_BITNUM           28   /* Audio process module interrupt */
+#define INTCHW_INTC0_ESW_BITNUM           27   /* Ethernet switch interrupt */
+#define INTCHW_INTC0_SPIH_BITNUM          26   /* SPI host interrupt */
+#define INTCHW_INTC0_TIMER3_BITNUM        25   /* Timer3 interrupt */
+#define INTCHW_INTC0_TIMER2_BITNUM        24   /* Timer2 interrupt */
+#define INTCHW_INTC0_TIMER1_BITNUM        23   /* Timer1 interrupt */
+#define INTCHW_INTC0_TIMER0_BITNUM        22   /* Timer0 interrupt */
+#define INTCHW_INTC0_SDIOH1_BITNUM        21   /* SDIO1 host interrupt */
+#define INTCHW_INTC0_SDIOH0_BITNUM        20   /* SDIO0 host interrupt */
+#define INTCHW_INTC0_USBD_BITNUM          19   /* USB device interrupt */
+#define INTCHW_INTC0_USBH1_BITNUM         18   /* USB1 host interrupt */
+#define INTCHW_INTC0_USBHD2_BITNUM        17   /* USB host2/device2 interrupt */
+#define INTCHW_INTC0_VPM_BITNUM           16   /* Voice process module interrupt */
+#define INTCHW_INTC0_DMA1C7_BITNUM        15   /* DMA1 channel 7 interrupt */
+#define INTCHW_INTC0_DMA1C6_BITNUM        14   /* DMA1 channel 6 interrupt */
+#define INTCHW_INTC0_DMA1C5_BITNUM        13   /* DMA1 channel 5 interrupt */
+#define INTCHW_INTC0_DMA1C4_BITNUM        12   /* DMA1 channel 4 interrupt */
+#define INTCHW_INTC0_DMA1C3_BITNUM        11   /* DMA1 channel 3 interrupt */
+#define INTCHW_INTC0_DMA1C2_BITNUM        10   /* DMA1 channel 2 interrupt */
+#define INTCHW_INTC0_DMA1C1_BITNUM         9   /* DMA1 channel 1 interrupt */
+#define INTCHW_INTC0_DMA1C0_BITNUM         8   /* DMA1 channel 0 interrupt */
+#define INTCHW_INTC0_DMA0C7_BITNUM         7   /* DMA0 channel 7 interrupt */
+#define INTCHW_INTC0_DMA0C6_BITNUM         6   /* DMA0 channel 6 interrupt */
+#define INTCHW_INTC0_DMA0C5_BITNUM         5   /* DMA0 channel 5 interrupt */
+#define INTCHW_INTC0_DMA0C4_BITNUM         4   /* DMA0 channel 4 interrupt */
+#define INTCHW_INTC0_DMA0C3_BITNUM         3   /* DMA0 channel 3 interrupt */
+#define INTCHW_INTC0_DMA0C2_BITNUM         2   /* DMA0 channel 2 interrupt */
+#define INTCHW_INTC0_DMA0C1_BITNUM         1   /* DMA0 channel 1 interrupt */
+#define INTCHW_INTC0_DMA0C0_BITNUM         0   /* DMA0 channel 0 interrupt */
+
+#define INTCHW_INTC0_PIF                  (1<<INTCHW_INTC0_PIF_BITNUM)
+#define INTCHW_INTC0_CLCD                 (1<<INTCHW_INTC0_CLCD_BITNUM)
+#define INTCHW_INTC0_GE                   (1<<INTCHW_INTC0_GE_BITNUM)
+#define INTCHW_INTC0_APM                  (1<<INTCHW_INTC0_APM_BITNUM)
+#define INTCHW_INTC0_ESW                  (1<<INTCHW_INTC0_ESW_BITNUM)
+#define INTCHW_INTC0_SPIH                 (1<<INTCHW_INTC0_SPIH_BITNUM)
+#define INTCHW_INTC0_TIMER3               (1<<INTCHW_INTC0_TIMER3_BITNUM)
+#define INTCHW_INTC0_TIMER2               (1<<INTCHW_INTC0_TIMER2_BITNUM)
+#define INTCHW_INTC0_TIMER1               (1<<INTCHW_INTC0_TIMER1_BITNUM)
+#define INTCHW_INTC0_TIMER0               (1<<INTCHW_INTC0_TIMER0_BITNUM)
+#define INTCHW_INTC0_SDIOH1               (1<<INTCHW_INTC0_SDIOH1_BITNUM)
+#define INTCHW_INTC0_SDIOH0               (1<<INTCHW_INTC0_SDIOH0_BITNUM)
+#define INTCHW_INTC0_USBD                 (1<<INTCHW_INTC0_USBD_BITNUM)
+#define INTCHW_INTC0_USBH1                (1<<INTCHW_INTC0_USBH1_BITNUM)
+#define INTCHW_INTC0_USBHD2               (1<<INTCHW_INTC0_USBHD2_BITNUM)
+#define INTCHW_INTC0_VPM                  (1<<INTCHW_INTC0_VPM_BITNUM)
+#define INTCHW_INTC0_DMA1C7               (1<<INTCHW_INTC0_DMA1C7_BITNUM)
+#define INTCHW_INTC0_DMA1C6               (1<<INTCHW_INTC0_DMA1C6_BITNUM)
+#define INTCHW_INTC0_DMA1C5               (1<<INTCHW_INTC0_DMA1C5_BITNUM)
+#define INTCHW_INTC0_DMA1C4               (1<<INTCHW_INTC0_DMA1C4_BITNUM)
+#define INTCHW_INTC0_DMA1C3               (1<<INTCHW_INTC0_DMA1C3_BITNUM)
+#define INTCHW_INTC0_DMA1C2               (1<<INTCHW_INTC0_DMA1C2_BITNUM)
+#define INTCHW_INTC0_DMA1C1               (1<<INTCHW_INTC0_DMA1C1_BITNUM)
+#define INTCHW_INTC0_DMA1C0               (1<<INTCHW_INTC0_DMA1C0_BITNUM)
+#define INTCHW_INTC0_DMA0C7               (1<<INTCHW_INTC0_DMA0C7_BITNUM)
+#define INTCHW_INTC0_DMA0C6               (1<<INTCHW_INTC0_DMA0C6_BITNUM)
+#define INTCHW_INTC0_DMA0C5               (1<<INTCHW_INTC0_DMA0C5_BITNUM)
+#define INTCHW_INTC0_DMA0C4               (1<<INTCHW_INTC0_DMA0C4_BITNUM)
+#define INTCHW_INTC0_DMA0C3               (1<<INTCHW_INTC0_DMA0C3_BITNUM)
+#define INTCHW_INTC0_DMA0C2               (1<<INTCHW_INTC0_DMA0C2_BITNUM)
+#define INTCHW_INTC0_DMA0C1               (1<<INTCHW_INTC0_DMA0C1_BITNUM)
+#define INTCHW_INTC0_DMA0C0               (1<<INTCHW_INTC0_DMA0C0_BITNUM)
+
+/* INTC1 - interrupt controller 1 */
+#define INTCHW_INTC1_DDRVPMP_BITNUM       27   /* DDR and VPM PLL clock phase relationship interupt (Not for A0) */
+#define INTCHW_INTC1_DDRVPMT_BITNUM       26   /* DDR and VPM HW phase align timeout interrupt (Not for A0) */
+#define INTCHW_INTC1_DDRP_BITNUM          26   /* DDR and PLL clock phase relationship interupt (For A0 only)) */
+#define INTCHW_INTC1_RTC2_BITNUM          25   /* Real time clock tamper interrupt */
+#define INTCHW_INTC1_VDEC_BITNUM          24   /* Hantro Video Decoder interrupt */
+/* Bits 13-23 are non-secure versions of the corresponding secure bits in SINTC bits 0-10. */
+#define INTCHW_INTC1_SPUM_BITNUM          23   /* Secure process module interrupt */
+#define INTCHW_INTC1_RTC1_BITNUM          22   /* Real time clock one-shot interrupt */
+#define INTCHW_INTC1_RTC0_BITNUM          21   /* Real time clock periodic interrupt */
+#define INTCHW_INTC1_RNG_BITNUM           20   /* Random number generator interrupt */
+#define INTCHW_INTC1_FMPU_BITNUM          19   /* Flash memory parition unit interrupt */
+#define INTCHW_INTC1_VMPU_BITNUM          18   /* VRAM memory partition interrupt */
+#define INTCHW_INTC1_DMPU_BITNUM          17   /* DDR2 memory partition interrupt */
+#define INTCHW_INTC1_KEYC_BITNUM          16   /* Key pad controller interrupt */
+#define INTCHW_INTC1_TSC_BITNUM           15   /* Touch screen controller interrupt */
+#define INTCHW_INTC1_UART0_BITNUM         14   /* UART 0 */
+#define INTCHW_INTC1_WDOG_BITNUM          13   /* Watchdog timer interrupt */
+
+#define INTCHW_INTC1_UART1_BITNUM         12   /* UART 1 */
+#define INTCHW_INTC1_PMUIRQ_BITNUM        11   /* ARM performance monitor interrupt */
+#define INTCHW_INTC1_COMMRX_BITNUM        10   /* ARM DDC receive interrupt */
+#define INTCHW_INTC1_COMMTX_BITNUM         9   /* ARM DDC transmit interrupt */
+#define INTCHW_INTC1_FLASHC_BITNUM         8   /* Flash controller interrupt */
+#define INTCHW_INTC1_GPHY_BITNUM           7   /* Gigabit Phy interrupt */
+#define INTCHW_INTC1_SPIS_BITNUM           6   /* SPI slave interrupt */
+#define INTCHW_INTC1_I2CS_BITNUM           5   /* I2C slave interrupt */
+#define INTCHW_INTC1_I2CH_BITNUM           4   /* I2C host interrupt */
+#define INTCHW_INTC1_I2S1_BITNUM           3   /* I2S1 interrupt */
+#define INTCHW_INTC1_I2S0_BITNUM           2   /* I2S0 interrupt */
+#define INTCHW_INTC1_GPIO1_BITNUM          1   /* GPIO bit 64//32 combined interrupt */
+#define INTCHW_INTC1_GPIO0_BITNUM          0   /* GPIO bit 31//0 combined interrupt */
+
+#define INTCHW_INTC1_DDRVPMT              (1<<INTCHW_INTC1_DDRVPMT_BITNUM)
+#define INTCHW_INTC1_DDRVPMP              (1<<INTCHW_INTC1_DDRVPMP_BITNUM)
+#define INTCHW_INTC1_DDRP                 (1<<INTCHW_INTC1_DDRP_BITNUM)
+#define INTCHW_INTC1_VDEC                 (1<<INTCHW_INTC1_VDEC_BITNUM)
+#define INTCHW_INTC1_SPUM                 (1<<INTCHW_INTC1_SPUM_BITNUM)
+#define INTCHW_INTC1_RTC2                 (1<<INTCHW_INTC1_RTC2_BITNUM)
+#define INTCHW_INTC1_RTC1                 (1<<INTCHW_INTC1_RTC1_BITNUM)
+#define INTCHW_INTC1_RTC0                 (1<<INTCHW_INTC1_RTC0_BITNUM)
+#define INTCHW_INTC1_RNG                  (1<<INTCHW_INTC1_RNG_BITNUM)
+#define INTCHW_INTC1_FMPU                 (1<<INTCHW_INTC1_FMPU_BITNUM)
+#define INTCHW_INTC1_IMPU                 (1<<INTCHW_INTC1_IMPU_BITNUM)
+#define INTCHW_INTC1_DMPU                 (1<<INTCHW_INTC1_DMPU_BITNUM)
+#define INTCHW_INTC1_KEYC                 (1<<INTCHW_INTC1_KEYC_BITNUM)
+#define INTCHW_INTC1_TSC                  (1<<INTCHW_INTC1_TSC_BITNUM)
+#define INTCHW_INTC1_UART0                (1<<INTCHW_INTC1_UART0_BITNUM)
+#define INTCHW_INTC1_WDOG                 (1<<INTCHW_INTC1_WDOG_BITNUM)
+#define INTCHW_INTC1_UART1                (1<<INTCHW_INTC1_UART1_BITNUM)
+#define INTCHW_INTC1_PMUIRQ               (1<<INTCHW_INTC1_PMUIRQ_BITNUM)
+#define INTCHW_INTC1_COMMRX               (1<<INTCHW_INTC1_COMMRX_BITNUM)
+#define INTCHW_INTC1_COMMTX               (1<<INTCHW_INTC1_COMMTX_BITNUM)
+#define INTCHW_INTC1_FLASHC               (1<<INTCHW_INTC1_FLASHC_BITNUM)
+#define INTCHW_INTC1_GPHY                 (1<<INTCHW_INTC1_GPHY_BITNUM)
+#define INTCHW_INTC1_SPIS                 (1<<INTCHW_INTC1_SPIS_BITNUM)
+#define INTCHW_INTC1_I2CS                 (1<<INTCHW_INTC1_I2CS_BITNUM)
+#define INTCHW_INTC1_I2CH                 (1<<INTCHW_INTC1_I2CH_BITNUM)
+#define INTCHW_INTC1_I2S1                 (1<<INTCHW_INTC1_I2S1_BITNUM)
+#define INTCHW_INTC1_I2S0                 (1<<INTCHW_INTC1_I2S0_BITNUM)
+#define INTCHW_INTC1_GPIO1                (1<<INTCHW_INTC1_GPIO1_BITNUM)
+#define INTCHW_INTC1_GPIO0                (1<<INTCHW_INTC1_GPIO0_BITNUM)
+
+/* SINTC secure int controller */
+#define INTCHW_SINTC_RTC2_BITNUM          15   /* Real time clock tamper interrupt */
+#define INTCHW_SINTC_TIMER3_BITNUM        14   /* Secure timer3 interrupt */
+#define INTCHW_SINTC_TIMER2_BITNUM        13   /* Secure timer2 interrupt */
+#define INTCHW_SINTC_TIMER1_BITNUM        12   /* Secure timer1 interrupt */
+#define INTCHW_SINTC_TIMER0_BITNUM        11   /* Secure timer0 interrupt */
+#define INTCHW_SINTC_SPUM_BITNUM          10   /* Secure process module interrupt */
+#define INTCHW_SINTC_RTC1_BITNUM           9   /* Real time clock one-shot interrupt */
+#define INTCHW_SINTC_RTC0_BITNUM           8   /* Real time clock periodic interrupt */
+#define INTCHW_SINTC_RNG_BITNUM            7   /* Random number generator interrupt */
+#define INTCHW_SINTC_FMPU_BITNUM           6   /* Flash memory parition unit interrupt */
+#define INTCHW_SINTC_VMPU_BITNUM           5   /* VRAM memory partition interrupt */
+#define INTCHW_SINTC_DMPU_BITNUM           4   /* DDR2 memory partition interrupt */
+#define INTCHW_SINTC_KEYC_BITNUM           3   /* Key pad controller interrupt */
+#define INTCHW_SINTC_TSC_BITNUM            2   /* Touch screen controller interrupt */
+#define INTCHW_SINTC_UART0_BITNUM          1   /* UART0 interrupt */
+#define INTCHW_SINTC_WDOG_BITNUM           0   /* Watchdog timer interrupt */
+
+#define INTCHW_SINTC_TIMER3               (1<<INTCHW_SINTC_TIMER3_BITNUM)
+#define INTCHW_SINTC_TIMER2               (1<<INTCHW_SINTC_TIMER2_BITNUM)
+#define INTCHW_SINTC_TIMER1               (1<<INTCHW_SINTC_TIMER1_BITNUM)
+#define INTCHW_SINTC_TIMER0               (1<<INTCHW_SINTC_TIMER0_BITNUM)
+#define INTCHW_SINTC_SPUM                 (1<<INTCHW_SINTC_SPUM_BITNUM)
+#define INTCHW_SINTC_RTC2                 (1<<INTCHW_SINTC_RTC2_BITNUM)
+#define INTCHW_SINTC_RTC1                 (1<<INTCHW_SINTC_RTC1_BITNUM)
+#define INTCHW_SINTC_RTC0                 (1<<INTCHW_SINTC_RTC0_BITNUM)
+#define INTCHW_SINTC_RNG                  (1<<INTCHW_SINTC_RNG_BITNUM)
+#define INTCHW_SINTC_FMPU                 (1<<INTCHW_SINTC_FMPU_BITNUM)
+#define INTCHW_SINTC_IMPU                 (1<<INTCHW_SINTC_IMPU_BITNUM)
+#define INTCHW_SINTC_DMPU                 (1<<INTCHW_SINTC_DMPU_BITNUM)
+#define INTCHW_SINTC_KEYC                 (1<<INTCHW_SINTC_KEYC_BITNUM)
+#define INTCHW_SINTC_TSC                  (1<<INTCHW_SINTC_TSC_BITNUM)
+#define INTCHW_SINTC_UART0                (1<<INTCHW_SINTC_UART0_BITNUM)
+#define INTCHW_SINTC_WDOG                 (1<<INTCHW_SINTC_WDOG_BITNUM)
+
+/* PL192 Vectored Interrupt Controller (VIC) layout */
+#define INTCHW_IRQSTATUS      0x00     /* IRQ status register */
+#define INTCHW_FIQSTATUS      0x04     /* FIQ status register */
+#define INTCHW_RAWINTR        0x08     /* Raw Interrupt Status register */
+#define INTCHW_INTSELECT      0x0c     /* Interrupt Select Register */
+#define INTCHW_INTENABLE      0x10     /* Interrupt Enable Register */
+#define INTCHW_INTENCLEAR     0x14     /* Interrupt Enable Clear Register */
+#define INTCHW_SOFTINT        0x18     /* Soft Interrupt Register */
+#define INTCHW_SOFTINTCLEAR   0x1c     /* Soft Interrupt Clear Register */
+#define INTCHW_PROTECTION     0x20     /* Protection Enable Register */
+#define INTCHW_SWPRIOMASK     0x24     /* Software Priority Mask Register */
+#define INTCHW_PRIODAISY      0x28     /* Priority Daisy Chain Register */
+#define INTCHW_VECTADDR0      0x100    /* Vector Address Registers */
+#define INTCHW_VECTPRIO0      0x200    /* Vector Priority Registers 0-31 */
+#define INTCHW_ADDRESS        0xf00    /* Vector Address Register 0-31 */
+#define INTCHW_PID            0xfe0    /* Peripheral ID Register 0-3 */
+#define INTCHW_PCELLID        0xff0    /* PrimeCell ID Register 0-3 */
+
+/* Example Usage: intcHw_irq_enable(INTCHW_INTC0, INTCHW_INTC0_TIMER0); */
+/*                intcHw_irq_clear(INTCHW_INTC0, INTCHW_INTC0_TIMER0); */
+/*                uint32_t bits = intcHw_irq_status(INTCHW_INTC0); */
+/*                uint32_t bits = intcHw_irq_raw_status(INTCHW_INTC0); */
+
+/* ---- Public Variable Externs ------------------------------------------ */
+/* ---- Public Function Prototypes --------------------------------------- */
+/* Clear one or more IRQ interrupts. */
+static inline void intcHw_irq_disable(void *basep, uint32_t mask)
+{
+       __REG32(basep + INTCHW_INTENCLEAR) = mask;
+}
+
+/* Enables one or more IRQ interrupts. */
+static inline void intcHw_irq_enable(void *basep, uint32_t mask)
+{
+       __REG32(basep + INTCHW_INTENABLE) = mask;
+}
+
+/* Select interrupt (IRQ/FIQ) type */
+static inline void intcHw_irq_type(void *basep, uint32_t mask)
+{
+       __REG32(basep + INTCHW_INTSELECT) = mask;
+}
+
+/* Get raw status bits. */
+static inline uint32_t intcHw_rawstatus(void *basep)
+{
+       return __REG32(basep + INTCHW_RAWINTR);
+}
+
+/* Get irq masked status bits. */
+static inline uint32_t intcHw_irq_status(void *basep)
+{
+       return __REG32(basep + INTCHW_IRQSTATUS);
+}
+
+/* Get fiq masked status bits. */
+static inline uint32_t intcHw_fiq_status(void *basep)
+{
+       return __REG32(basep + INTCHW_FIQSTATUS);
+}
+
+#endif /* _INTCHW_REG_H */
diff --git a/arch/arm/mach-bcmring/irq.c b/arch/arm/mach-bcmring/irq.c
new file mode 100644
index 0000000..826add0
--- /dev/null
+++ b/arch/arm/mach-bcmring/irq.c
@@ -0,0 +1,127 @@
+/*
+ *
+ *  Copyright (C) 1999 ARM Limited
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
+#include <linux/init.h>
+#include <linux/stddef.h>
+#include <linux/list.h>
+#include <linux/timer.h>
+#include <linux/version.h>
+
+#include <mach/hardware.h>
+#include <asm/io.h>
+#include <asm/irq.h>
+
+#include <asm/mach/irq.h>
+#include <mach/csp/intcHw_reg.h>
+#include <mach/csp/mm_io.h>
+
+static void bcmring_mask_irq0(unsigned int irq)
+{
+       writel(1 << (irq - IRQ_INTC0_START),
+              MM_IO_BASE_INTC0 + INTCHW_INTENCLEAR);
+}
+
+static void bcmring_unmask_irq0(unsigned int irq)
+{
+       writel(1 << (irq - IRQ_INTC0_START),
+              MM_IO_BASE_INTC0 + INTCHW_INTENABLE);
+}
+
+static void bcmring_mask_irq1(unsigned int irq)
+{
+       writel(1 << (irq - IRQ_INTC1_START),
+              MM_IO_BASE_INTC1 + INTCHW_INTENCLEAR);
+}
+
+static void bcmring_unmask_irq1(unsigned int irq)
+{
+       writel(1 << (irq - IRQ_INTC1_START),
+              MM_IO_BASE_INTC1 + INTCHW_INTENABLE);
+}
+
+static void bcmring_mask_irq2(unsigned int irq)
+{
+       writel(1 << (irq - IRQ_SINTC_START),
+              MM_IO_BASE_SINTC + INTCHW_INTENCLEAR);
+}
+
+static void bcmring_unmask_irq2(unsigned int irq)
+{
+       writel(1 << (irq - IRQ_SINTC_START),
+              MM_IO_BASE_SINTC + INTCHW_INTENABLE);
+}
+
+static struct irq_chip bcmring_irq0_chip = {
+       .typename = "ARM-INTC0",
+       .ack = bcmring_mask_irq0,
+       .mask = bcmring_mask_irq0,      /* mask a specific interrupt, blocking its delivery. */
+       .unmask = bcmring_unmask_irq0,  /* unmaks an interrupt */
+};
+
+static struct irq_chip bcmring_irq1_chip = {
+       .typename = "ARM-INTC1",
+       .ack = bcmring_mask_irq1,
+       .mask = bcmring_mask_irq1,
+       .unmask = bcmring_unmask_irq1,
+};
+
+static struct irq_chip bcmring_irq2_chip = {
+       .typename = "ARM-SINTC",
+       .ack = bcmring_mask_irq2,
+       .mask = bcmring_mask_irq2,
+       .unmask = bcmring_unmask_irq2,
+};
+
+static void vic_init(void __iomem *base, struct irq_chip *chip,
+                    unsigned int irq_start, unsigned int vic_sources)
+{
+       unsigned int i;
+       for (i = 0; i < 32; i++) {
+               unsigned int irq = irq_start + i;
+               set_irq_chip(irq, chip);
+               set_irq_chip_data(irq, base);
+
+               if (vic_sources & (1 << i)) {
+                       set_irq_handler(irq, handle_level_irq);
+                       set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
+               }
+       }
+       writel(0, base + INTCHW_INTSELECT);
+       writel(0, base + INTCHW_INTENABLE);
+       writel(~0, base + INTCHW_INTENCLEAR);
+       writel(0, base + INTCHW_IRQSTATUS);
+       writel(~0, base + INTCHW_SOFTINTCLEAR);
+}
+
+void __init bcmring_init_irq(void)
+{
+       vic_init((void __iomem *)MM_IO_BASE_INTC0, &bcmring_irq0_chip,
+                IRQ_INTC0_START, IRQ_INTC0_VALID_MASK);
+       vic_init((void __iomem *)MM_IO_BASE_INTC1, &bcmring_irq1_chip,
+                IRQ_INTC1_START, IRQ_INTC1_VALID_MASK);
+       vic_init((void __iomem *)MM_IO_BASE_SINTC, &bcmring_irq2_chip,
+                IRQ_SINTC_START, IRQ_SINTC_VALID_MASK);
+
+       /* special cases */
+       if (INTCHW_INTC1_GPIO0 & IRQ_INTC1_VALID_MASK) {
+               set_irq_handler(IRQ_GPIO0, handle_simple_irq);
+       }
+       if (INTCHW_INTC1_GPIO1 & IRQ_INTC1_VALID_MASK) {
+               set_irq_handler(IRQ_GPIO1, handle_simple_irq);
+       }
+}
--
1.6.0.6



Leo Hao Chen
Software Engineer
Broadcom Canada Inc.


