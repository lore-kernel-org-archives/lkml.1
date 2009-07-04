Return-Path: <linux-kernel-owner+w=401wt.eu-S1759548AbZGDBrI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759548AbZGDBrI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 21:47:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759117AbZGDBpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 21:45:11 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:1207 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759214AbZGDBpB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 21:45:01 -0400
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
From: "Leo (Hao) Chen" <leochen@broadcom.com>
To: "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
       "Scott Branden" <sbranden@broadcom.com>,
       "Leo (Hao) Chen" <leochen@broadcom.com>
Date: Fri, 3 Jul 2009 18:44:44 -0700
Subject: [PATCH v2 14/18] new ARM SoC support: BCMRing
Thread-Topic: [PATCH v2 14/18] new ARM SoC support: BCMRing
Thread-Index: Acn8SQFHH8K8sroqSmWyplcoY+VPjw==
Message-ID: <8628FE4E7912BF47A96AE7DD7BAC0AADCB25BA6C1C@SJEXCHCCR02.corp.ad.broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
X-WSS-ID: 66506B870EG20718027-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From daede68e15a5580ae0d68bd7572144d04fec1d36 Mon Sep 17 00:00:00 2001
From: Leo Chen <leochen@broadcom.com>
Date: Fri, 3 Jul 2009 17:11:28 -0700
Subject: [PATCH 14/18] csp/chipc code

bcmring chipc block, csp functions including clock freq. setting, chipc
module init, PLL init, reset functions

Signed-off-by: Leo Chen <leochen@broadcom.com>
---
 arch/arm/mach-bcmring/csp/chipc/Makefile           |    1 +
 arch/arm/mach-bcmring/csp/chipc/chipcHw.c          |  782 ++++++++++++++++++++
 .../mach-bcmring/csp/chipc/chipcHw_clkreconfig.c   |  248 +++++++
 arch/arm/mach-bcmring/csp/chipc/chipcHw_init.c     |  293 ++++++++
 arch/arm/mach-bcmring/csp/chipc/chipcHw_reset.c    |  125 ++++
 arch/arm/mach-bcmring/csp/chipc/chipcHw_str.c      |   64 ++
 6 files changed, 1513 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-bcmring/csp/chipc/Makefile
 create mode 100644 arch/arm/mach-bcmring/csp/chipc/chipcHw.c
 create mode 100644 arch/arm/mach-bcmring/csp/chipc/chipcHw_clkreconfig.c
 create mode 100644 arch/arm/mach-bcmring/csp/chipc/chipcHw_init.c
 create mode 100644 arch/arm/mach-bcmring/csp/chipc/chipcHw_reset.c
 create mode 100644 arch/arm/mach-bcmring/csp/chipc/chipcHw_str.c

diff --git a/arch/arm/mach-bcmring/csp/chipc/Makefile b/arch/arm/mach-bcmring/csp/chipc/Makefile
new file mode 100644
index 0000000..6739527
--- /dev/null
+++ b/arch/arm/mach-bcmring/csp/chipc/Makefile
@@ -0,0 +1 @@
+obj-y += chipcHw.o chipcHw_str.o chipcHw_reset.o chipcHw_init.o
diff --git a/arch/arm/mach-bcmring/csp/chipc/chipcHw.c b/arch/arm/mach-bcmring/csp/chipc/chipcHw.c
new file mode 100644
index 0000000..b71048c
--- /dev/null
+++ b/arch/arm/mach-bcmring/csp/chipc/chipcHw.c
@@ -0,0 +1,782 @@
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
+*  @file    chipcHw.c
+*
+*  @brief   Low level Various CHIP clock controlling routines
+*
+*  @note
+*
+*   These routines provide basic clock controlling functionality only.
+*/
+/****************************************************************************/
+
+/* ---- Include Files ---------------------------------------------------- */
+
+#include <csp/errno.h>
+#include <csp/stdint.h>
+#include <csp/module.h>
+
+#include <mach/csp/chipcHw_def.h>
+#include <mach/csp/chipcHw_inline.h>
+
+#include <csp/reg.h>
+#include <csp/delay.h>
+
+/* ---- Private Constants and Types --------------------------------------- */
+
+/* VPM alignment algorithm uses this */
+#define MAX_PHASE_ADJUST_COUNT         0xFFFF  /* Max number of times allowed to adjust the phase */
+#define MAX_PHASE_ALIGN_ATTEMPTS       10      /* Max number of attempt to align the phase */
+
+/* Local definition of clock type */
+#define PLL_CLOCK                      1       /* PLL Clock */
+#define NON_PLL_CLOCK                  2       /* Divider clock */
+
+#define WAIT()       do { \
+       asm("nop"); asm("nop"); asm("nop"); asm("nop"); asm("nop"); asm("nop"); asm("nop"); asm("nop"); asm("nop"); asm("nop"); asm("nop"); asm("nop"); \
+       asm("nop"); asm("nop"); asm("nop"); asm("nop"); asm("nop"); asm("nop"); asm("nop"); asm("nop"); asm("nop"); asm("nop"); asm("nop"); asm("nop"); \
+       asm("nop"); asm("nop"); asm("nop"); asm("nop"); asm("nop"); asm("nop"); asm("nop"); asm("nop"); asm("nop"); asm("nop"); asm("nop"); asm("nop"); \
+       } while (0);
+
+static int chipcHw_divide(int num, int denom)
+    __attribute__ ((section(".aramtext")));
+
+/****************************************************************************/
+/**
+*  @brief   Set clock fequency for miscellaneous configurable clocks
+*
+*  This function sets clock frequency
+*
+*  @return  Configured clock frequency in hertz
+*
+*/
+/****************************************************************************/
+chipcHw_freq chipcHw_getClockFrequency(chipcHw_CLOCK_e clock   /*  [ IN ] Configurable clock */
+    ) {
+       volatile uint32_t *pPLLReg = (uint32_t *) 0x0;
+       volatile uint32_t *pClockCtrl = (uint32_t *) 0x0;
+       volatile uint32_t *pDependentClock = (uint32_t *) 0x0;
+       uint32_t vcoFreqPll1Hz = 0;     /* Effective VCO frequency for PLL1 in Hz */
+       uint32_t vcoFreqPll2Hz = 0;     /* Effective VCO frequency for PLL2 in Hz */
+       uint32_t dependentClockType = 0;
+       uint32_t vcoHz = 0;
+
+       /* Get VCO frequencies */
+       if ((pChipcHw->PLLPreDivider & chipcHw_REG_PLL_PREDIVIDER_NDIV_MODE_MASK) != chipcHw_REG_PLL_PREDIVIDER_NDIV_MODE_INTEGER) {
+               uint64_t adjustFreq = 0;
+
+               vcoFreqPll1Hz = chipcHw_XTAL_FREQ_Hz *
+                   chipcHw_divide(chipcHw_REG_PLL_PREDIVIDER_P1, chipcHw_REG_PLL_PREDIVIDER_P2) *
+                   ((pChipcHw->PLLPreDivider & chipcHw_REG_PLL_PREDIVIDER_NDIV_MASK) >>
+                    chipcHw_REG_PLL_PREDIVIDER_NDIV_SHIFT);
+
+               /* Adjusted frequency due to chipcHw_REG_PLL_DIVIDER_NDIV_f_SS */
+               adjustFreq = (uint64_t) chipcHw_XTAL_FREQ_Hz *
+                       (uint64_t) chipcHw_REG_PLL_DIVIDER_NDIV_f_SS *
+                       chipcHw_divide(chipcHw_REG_PLL_PREDIVIDER_P1, (chipcHw_REG_PLL_PREDIVIDER_P2 * (uint64_t) chipcHw_REG_PLL_DIVIDER_FRAC));
+               vcoFreqPll1Hz += (uint32_t) adjustFreq;
+       } else {
+               vcoFreqPll1Hz = chipcHw_XTAL_FREQ_Hz *
+                   chipcHw_divide(chipcHw_REG_PLL_PREDIVIDER_P1, chipcHw_REG_PLL_PREDIVIDER_P2) *
+                   ((pChipcHw->PLLPreDivider & chipcHw_REG_PLL_PREDIVIDER_NDIV_MASK) >>
+                    chipcHw_REG_PLL_PREDIVIDER_NDIV_SHIFT);
+       }
+       vcoFreqPll2Hz =
+           chipcHw_XTAL_FREQ_Hz *
+                chipcHw_divide(chipcHw_REG_PLL_PREDIVIDER_P1, chipcHw_REG_PLL_PREDIVIDER_P2) *
+           ((pChipcHw->PLLPreDivider2 & chipcHw_REG_PLL_PREDIVIDER_NDIV_MASK) >>
+            chipcHw_REG_PLL_PREDIVIDER_NDIV_SHIFT);
+
+       switch (clock) {
+       case chipcHw_CLOCK_DDR:
+               pPLLReg = &pChipcHw->DDRClock;
+               vcoHz = vcoFreqPll1Hz;
+               break;
+       case chipcHw_CLOCK_ARM:
+               pPLLReg = &pChipcHw->ARMClock;
+               vcoHz = vcoFreqPll1Hz;
+               break;
+       case chipcHw_CLOCK_ESW:
+               pPLLReg = &pChipcHw->ESWClock;
+               vcoHz = vcoFreqPll1Hz;
+               break;
+       case chipcHw_CLOCK_VPM:
+               pPLLReg = &pChipcHw->VPMClock;
+               vcoHz = vcoFreqPll1Hz;
+               break;
+       case chipcHw_CLOCK_ESW125:
+               pPLLReg = &pChipcHw->ESW125Clock;
+               vcoHz = vcoFreqPll1Hz;
+               break;
+       case chipcHw_CLOCK_UART:
+               pPLLReg = &pChipcHw->UARTClock;
+               vcoHz = vcoFreqPll1Hz;
+               break;
+       case chipcHw_CLOCK_SDIO0:
+               pPLLReg = &pChipcHw->SDIO0Clock;
+               vcoHz = vcoFreqPll1Hz;
+               break;
+       case chipcHw_CLOCK_SDIO1:
+               pPLLReg = &pChipcHw->SDIO1Clock;
+               vcoHz = vcoFreqPll1Hz;
+               break;
+       case chipcHw_CLOCK_SPI:
+               pPLLReg = &pChipcHw->SPIClock;
+               vcoHz = vcoFreqPll1Hz;
+               break;
+       case chipcHw_CLOCK_ETM:
+               pPLLReg = &pChipcHw->ETMClock;
+               vcoHz = vcoFreqPll1Hz;
+               break;
+       case chipcHw_CLOCK_USB:
+               pPLLReg = &pChipcHw->USBClock;
+               vcoHz = vcoFreqPll2Hz;
+               break;
+       case chipcHw_CLOCK_LCD:
+               pPLLReg = &pChipcHw->LCDClock;
+               vcoHz = vcoFreqPll2Hz;
+               break;
+       case chipcHw_CLOCK_APM:
+               pPLLReg = &pChipcHw->APMClock;
+               vcoHz = vcoFreqPll2Hz;
+               break;
+       case chipcHw_CLOCK_BUS:
+               pClockCtrl = &pChipcHw->ACLKClock;
+               pDependentClock = &pChipcHw->ARMClock;
+               vcoHz = vcoFreqPll1Hz;
+               dependentClockType = PLL_CLOCK;
+               break;
+       case chipcHw_CLOCK_OTP:
+               pClockCtrl = &pChipcHw->OTPClock;
+               break;
+       case chipcHw_CLOCK_I2C:
+               pClockCtrl = &pChipcHw->I2CClock;
+               break;
+       case chipcHw_CLOCK_I2S0:
+               pClockCtrl = &pChipcHw->I2S0Clock;
+               break;
+       case chipcHw_CLOCK_RTBUS:
+               pClockCtrl = &pChipcHw->RTBUSClock;
+               pDependentClock = &pChipcHw->ACLKClock;
+               dependentClockType = NON_PLL_CLOCK;
+               break;
+       case chipcHw_CLOCK_APM100:
+               pClockCtrl = &pChipcHw->APM100Clock;
+               pDependentClock = &pChipcHw->APMClock;
+               vcoHz = vcoFreqPll2Hz;
+               dependentClockType = PLL_CLOCK;
+               break;
+       case chipcHw_CLOCK_TSC:
+               pClockCtrl = &pChipcHw->TSCClock;
+               break;
+       case chipcHw_CLOCK_LED:
+               pClockCtrl = &pChipcHw->LEDClock;
+               break;
+       case chipcHw_CLOCK_I2S1:
+               pClockCtrl = &pChipcHw->I2S1Clock;
+               break;
+       }
+
+       if (pPLLReg) {
+               /* Obtain PLL clock frequency */
+               if (*pPLLReg & chipcHw_REG_PLL_CLOCK_BYPASS_SELECT) {
+                       /* Return crystal clock frequency when bypassed */
+                       return chipcHw_XTAL_FREQ_Hz;
+               } else if (clock == chipcHw_CLOCK_DDR) {
+                       /* DDR frequency is configured in PLLDivider register */
+                       return chipcHw_divide (vcoHz, (((pChipcHw->PLLDivider & 0xFF000000) >> 24) ? ((pChipcHw->PLLDivider & 0xFF000000) >> 24) : 256));
+               } else {
+                       /* From chip revision number B0, LCD clock is internally divided by 2 */
+                       if ((pPLLReg == &pChipcHw->LCDClock) && (chipcHw_getChipRevisionNumber() != chipcHw_REV_NUMBER_A0)) {
+                               vcoHz >>= 1;
+                       }
+                       /* Obtain PLL clock frequency using VCO dividers */
+                       return chipcHw_divide(vcoHz, ((*pPLLReg & chipcHw_REG_PLL_CLOCK_MDIV_MASK) ? (*pPLLReg & chipcHw_REG_PLL_CLOCK_MDIV_MASK) : 256));
+               }
+       } else if (pClockCtrl) {
+               /* Obtain divider clock frequency */
+               uint32_t div;
+               uint32_t freq = 0;
+
+               if (*pClockCtrl & chipcHw_REG_DIV_CLOCK_BYPASS_SELECT) {
+                       /* Return crystal clock frequency when bypassed */
+                       return chipcHw_XTAL_FREQ_Hz;
+               } else if (pDependentClock) {
+                       /* Identify the dependent clock frequency */
+                       switch (dependentClockType) {
+                       case PLL_CLOCK:
+                               if (*pDependentClock & chipcHw_REG_PLL_CLOCK_BYPASS_SELECT) {
+                                       /* Use crystal clock frequency when dependent PLL clock is bypassed */
+                                       freq = chipcHw_XTAL_FREQ_Hz;
+                               } else {
+                                       /* Obtain PLL clock frequency using VCO dividers */
+                                       div = *pDependentClock & chipcHw_REG_PLL_CLOCK_MDIV_MASK;
+                                       freq = div ? chipcHw_divide(vcoHz, div) : 0;
+                               }
+                               break;
+                       case NON_PLL_CLOCK:
+                               if (pDependentClock == (uint32_t *) &pChipcHw->ACLKClock) {
+                                       freq = chipcHw_getClockFrequency (chipcHw_CLOCK_BUS);
+                               } else {
+                                       if (*pDependentClock & chipcHw_REG_DIV_CLOCK_BYPASS_SELECT) {
+                                               /* Use crystal clock frequency when dependent divider clock is bypassed */
+                                               freq = chipcHw_XTAL_FREQ_Hz;
+                                       } else {
+                                               /* Obtain divider clock frequency using XTAL dividers */
+                                               div = *pDependentClock & chipcHw_REG_DIV_CLOCK_DIV_MASK;
+                                               freq = chipcHw_divide (chipcHw_XTAL_FREQ_Hz, (div ? div : 256));
+                                       }
+                               }
+                               break;
+                       }
+               } else {
+                       /* Dependent on crystal clock */
+                       freq = chipcHw_XTAL_FREQ_Hz;
+               }
+
+               div = *pClockCtrl & chipcHw_REG_DIV_CLOCK_DIV_MASK;
+               return chipcHw_divide(freq, (div ? div : 256));
+       }
+       return 0;
+}
+
+/****************************************************************************/
+/**
+*  @brief   Set clock fequency for miscellaneous configurable clocks
+*
+*  This function sets clock frequency
+*
+*  @return  Configured clock frequency in Hz
+*
+*/
+/****************************************************************************/
+chipcHw_freq chipcHw_setClockFrequency(chipcHw_CLOCK_e clock,  /*  [ IN ] Configurable clock */
+                                      uint32_t freq    /*  [ IN ] Clock frequency in Hz */
+    ) {
+       volatile uint32_t *pPLLReg = (uint32_t *) 0x0;
+       volatile uint32_t *pClockCtrl = (uint32_t *) 0x0;
+       volatile uint32_t *pDependentClock = (uint32_t *) 0x0;
+       uint32_t vcoFreqPll1Hz = 0;     /* Effective VCO frequency for PLL1 in Hz */
+       uint32_t desVcoFreqPll1Hz = 0;  /* Desired VCO frequency for PLL1 in Hz */
+       uint32_t vcoFreqPll2Hz = 0;     /* Effective VCO frequency for PLL2 in Hz */
+       uint32_t dependentClockType = 0;
+       uint32_t vcoHz = 0;
+       uint32_t desVcoHz = 0;
+
+       /* Get VCO frequencies */
+       if ((pChipcHw->PLLPreDivider & chipcHw_REG_PLL_PREDIVIDER_NDIV_MODE_MASK) != chipcHw_REG_PLL_PREDIVIDER_NDIV_MODE_INTEGER) {
+               uint64_t adjustFreq = 0;
+
+               vcoFreqPll1Hz = chipcHw_XTAL_FREQ_Hz *
+                   chipcHw_divide(chipcHw_REG_PLL_PREDIVIDER_P1, chipcHw_REG_PLL_PREDIVIDER_P2) *
+                   ((pChipcHw->PLLPreDivider & chipcHw_REG_PLL_PREDIVIDER_NDIV_MASK) >>
+                    chipcHw_REG_PLL_PREDIVIDER_NDIV_SHIFT);
+
+               /* Adjusted frequency due to chipcHw_REG_PLL_DIVIDER_NDIV_f_SS */
+               adjustFreq = (uint64_t) chipcHw_XTAL_FREQ_Hz *
+                       (uint64_t) chipcHw_REG_PLL_DIVIDER_NDIV_f_SS *
+                       chipcHw_divide(chipcHw_REG_PLL_PREDIVIDER_P1, (chipcHw_REG_PLL_PREDIVIDER_P2 * (uint64_t) chipcHw_REG_PLL_DIVIDER_FRAC));
+               vcoFreqPll1Hz += (uint32_t) adjustFreq;
+
+               /* Desired VCO frequency */
+               desVcoFreqPll1Hz = chipcHw_XTAL_FREQ_Hz *
+                   chipcHw_divide(chipcHw_REG_PLL_PREDIVIDER_P1, chipcHw_REG_PLL_PREDIVIDER_P2) *
+                   (((pChipcHw->PLLPreDivider & chipcHw_REG_PLL_PREDIVIDER_NDIV_MASK) >>
+                     chipcHw_REG_PLL_PREDIVIDER_NDIV_SHIFT) + 1);
+       } else {
+               vcoFreqPll1Hz = desVcoFreqPll1Hz = chipcHw_XTAL_FREQ_Hz *
+                   chipcHw_divide(chipcHw_REG_PLL_PREDIVIDER_P1, chipcHw_REG_PLL_PREDIVIDER_P2) *
+                   ((pChipcHw->PLLPreDivider & chipcHw_REG_PLL_PREDIVIDER_NDIV_MASK) >>
+                    chipcHw_REG_PLL_PREDIVIDER_NDIV_SHIFT);
+       }
+       vcoFreqPll2Hz = chipcHw_XTAL_FREQ_Hz * chipcHw_divide(chipcHw_REG_PLL_PREDIVIDER_P1, chipcHw_REG_PLL_PREDIVIDER_P2) *
+           ((pChipcHw->PLLPreDivider2 & chipcHw_REG_PLL_PREDIVIDER_NDIV_MASK) >>
+            chipcHw_REG_PLL_PREDIVIDER_NDIV_SHIFT);
+
+       switch (clock) {
+       case chipcHw_CLOCK_DDR:
+               /* Configure the DDR_ctrl:BUS ratio settings */
+               {
+                       REG_LOCAL_IRQ_SAVE;
+                       /* Dvide DDR_phy by two to obtain DDR_ctrl clock */
+                       pChipcHw->DDRClock = (pChipcHw->DDRClock & ~chipcHw_REG_PLL_CLOCK_TO_BUS_RATIO_MASK) | ((((freq / 2) / chipcHw_getClockFrequency(chipcHw_CLOCK_BUS)) - 1)
+                               << chipcHw_REG_PLL_CLOCK_TO_BUS_RATIO_SHIFT);
+                       REG_LOCAL_IRQ_RESTORE;
+               }
+               pPLLReg = &pChipcHw->DDRClock;
+               vcoHz = vcoFreqPll1Hz;
+               desVcoHz = desVcoFreqPll1Hz;
+               break;
+       case chipcHw_CLOCK_ARM:
+               pPLLReg = &pChipcHw->ARMClock;
+               vcoHz = vcoFreqPll1Hz;
+               desVcoHz = desVcoFreqPll1Hz;
+               break;
+       case chipcHw_CLOCK_ESW:
+               pPLLReg = &pChipcHw->ESWClock;
+               vcoHz = vcoFreqPll1Hz;
+               desVcoHz = desVcoFreqPll1Hz;
+               break;
+       case chipcHw_CLOCK_VPM:
+               /* Configure the VPM:BUS ratio settings */
+               {
+                       REG_LOCAL_IRQ_SAVE;
+                       pChipcHw->VPMClock = (pChipcHw->VPMClock & ~chipcHw_REG_PLL_CLOCK_TO_BUS_RATIO_MASK) | ((chipcHw_divide (freq, chipcHw_getClockFrequency(chipcHw_CLOCK_BUS)) - 1)
+                               << chipcHw_REG_PLL_CLOCK_TO_BUS_RATIO_SHIFT);
+                       REG_LOCAL_IRQ_RESTORE;
+               }
+               pPLLReg = &pChipcHw->VPMClock;
+               vcoHz = vcoFreqPll1Hz;
+               desVcoHz = desVcoFreqPll1Hz;
+               break;
+       case chipcHw_CLOCK_ESW125:
+               pPLLReg = &pChipcHw->ESW125Clock;
+               vcoHz = vcoFreqPll1Hz;
+               desVcoHz = desVcoFreqPll1Hz;
+               break;
+       case chipcHw_CLOCK_UART:
+               pPLLReg = &pChipcHw->UARTClock;
+               vcoHz = vcoFreqPll1Hz;
+               desVcoHz = desVcoFreqPll1Hz;
+               break;
+       case chipcHw_CLOCK_SDIO0:
+               pPLLReg = &pChipcHw->SDIO0Clock;
+               vcoHz = vcoFreqPll1Hz;
+               desVcoHz = desVcoFreqPll1Hz;
+               break;
+       case chipcHw_CLOCK_SDIO1:
+               pPLLReg = &pChipcHw->SDIO1Clock;
+               vcoHz = vcoFreqPll1Hz;
+               desVcoHz = desVcoFreqPll1Hz;
+               break;
+       case chipcHw_CLOCK_SPI:
+               pPLLReg = &pChipcHw->SPIClock;
+               vcoHz = vcoFreqPll1Hz;
+               desVcoHz = desVcoFreqPll1Hz;
+               break;
+       case chipcHw_CLOCK_ETM:
+               pPLLReg = &pChipcHw->ETMClock;
+               vcoHz = vcoFreqPll1Hz;
+               desVcoHz = desVcoFreqPll1Hz;
+               break;
+       case chipcHw_CLOCK_USB:
+               pPLLReg = &pChipcHw->USBClock;
+               vcoHz = vcoFreqPll2Hz;
+               desVcoHz = vcoFreqPll2Hz;
+               break;
+       case chipcHw_CLOCK_LCD:
+               pPLLReg = &pChipcHw->LCDClock;
+               vcoHz = vcoFreqPll2Hz;
+               desVcoHz = vcoFreqPll2Hz;
+               break;
+       case chipcHw_CLOCK_APM:
+               pPLLReg = &pChipcHw->APMClock;
+               vcoHz = vcoFreqPll2Hz;
+               desVcoHz = vcoFreqPll2Hz;
+               break;
+       case chipcHw_CLOCK_BUS:
+               pClockCtrl = &pChipcHw->ACLKClock;
+               pDependentClock = &pChipcHw->ARMClock;
+               vcoHz = vcoFreqPll1Hz;
+               desVcoHz = desVcoFreqPll1Hz;
+               dependentClockType = PLL_CLOCK;
+               break;
+       case chipcHw_CLOCK_OTP:
+               pClockCtrl = &pChipcHw->OTPClock;
+               break;
+       case chipcHw_CLOCK_I2C:
+               pClockCtrl = &pChipcHw->I2CClock;
+               break;
+       case chipcHw_CLOCK_I2S0:
+               pClockCtrl = &pChipcHw->I2S0Clock;
+               break;
+       case chipcHw_CLOCK_RTBUS:
+               pClockCtrl = &pChipcHw->RTBUSClock;
+               pDependentClock = &pChipcHw->ACLKClock;
+               dependentClockType = NON_PLL_CLOCK;
+               break;
+       case chipcHw_CLOCK_APM100:
+               pClockCtrl = &pChipcHw->APM100Clock;
+               pDependentClock = &pChipcHw->APMClock;
+               vcoHz = vcoFreqPll2Hz;
+               desVcoHz = vcoFreqPll2Hz;
+               dependentClockType = PLL_CLOCK;
+               break;
+       case chipcHw_CLOCK_TSC:
+               pClockCtrl = &pChipcHw->TSCClock;
+               break;
+       case chipcHw_CLOCK_LED:
+               pClockCtrl = &pChipcHw->LEDClock;
+               break;
+       case chipcHw_CLOCK_I2S1:
+               pClockCtrl = &pChipcHw->I2S1Clock;
+               break;
+       }
+
+       if (pPLLReg) {
+               /* Select XTAL as bypass source */
+               reg32_modify_and(pPLLReg, ~chipcHw_REG_PLL_CLOCK_SOURCE_GPIO);
+               reg32_modify_or(pPLLReg, chipcHw_REG_PLL_CLOCK_BYPASS_SELECT);
+               /* For DDR settings use only the PLL divider clock */
+               if (pPLLReg == &pChipcHw->DDRClock) {
+                       /* Set M1DIV for PLL1, which controls the DDR clock */
+                       reg32_write(&pChipcHw->PLLDivider, (pChipcHw->PLLDivider & 0x00FFFFFF) | ((chipcHw_REG_PLL_DIVIDER_MDIV (desVcoHz, freq)) << 24));
+                       /* Calculate expected frequency */
+                       freq = chipcHw_divide(vcoHz, (((pChipcHw->PLLDivider & 0xFF000000) >> 24) ? ((pChipcHw->PLLDivider & 0xFF000000) >> 24) : 256));
+               } else {
+                       /* From chip revision number B0, LCD clock is internally divided by 2 */
+                       if ((pPLLReg == &pChipcHw->LCDClock) && (chipcHw_getChipRevisionNumber() != chipcHw_REV_NUMBER_A0)) {
+                               desVcoHz >>= 1;
+                               vcoHz >>= 1;
+                       }
+                       /* Set MDIV to change the frequency */
+                       reg32_modify_and(pPLLReg, ~(chipcHw_REG_PLL_CLOCK_MDIV_MASK));
+                       reg32_modify_or(pPLLReg, chipcHw_REG_PLL_DIVIDER_MDIV(desVcoHz, freq));
+                       /* Calculate expected frequency */
+                       freq = chipcHw_divide(vcoHz, ((*(pPLLReg) & chipcHw_REG_PLL_CLOCK_MDIV_MASK) ? (*(pPLLReg) & chipcHw_REG_PLL_CLOCK_MDIV_MASK) : 256));
+               }
+               /* Wait for for atleast 200ns as per the protocol to change frequency */
+               udelay(1);
+               /* Do not bypass */
+               reg32_modify_and(pPLLReg, ~chipcHw_REG_PLL_CLOCK_BYPASS_SELECT);
+               /* Return the configured frequency */
+               return freq;
+       } else if (pClockCtrl) {
+               uint32_t divider = 0;
+
+               /* Divider clock should not be bypassed  */
+               reg32_modify_and(pClockCtrl,
+                                ~chipcHw_REG_DIV_CLOCK_BYPASS_SELECT);
+
+               /* Identify the clock source */
+               if (pDependentClock) {
+                       switch (dependentClockType) {
+                       case PLL_CLOCK:
+                               divider = chipcHw_divide(chipcHw_divide (desVcoHz, (*pDependentClock & chipcHw_REG_PLL_CLOCK_MDIV_MASK)), freq);
+                               break;
+                       case NON_PLL_CLOCK:
+                               {
+                                       uint32_t sourceClock = 0;
+
+                                       if (pDependentClock == (uint32_t *) &pChipcHw->ACLKClock) {
+                                               sourceClock = chipcHw_getClockFrequency (chipcHw_CLOCK_BUS);
+                                       } else {
+                                               uint32_t div = *pDependentClock & chipcHw_REG_DIV_CLOCK_DIV_MASK;
+                                               sourceClock = chipcHw_divide (chipcHw_XTAL_FREQ_Hz, ((div) ? div : 256));
+                                       }
+                                       divider = chipcHw_divide(sourceClock, freq);
+                               }
+                               break;
+                       }
+               } else {
+                       divider = chipcHw_divide(chipcHw_XTAL_FREQ_Hz, freq);
+               }
+
+               if (divider) {
+                       REG_LOCAL_IRQ_SAVE;
+                       /* Set the divider to obtain the required frequency */
+                       *pClockCtrl = (*pClockCtrl & (~chipcHw_REG_DIV_CLOCK_DIV_MASK)) | (((divider > 256) ? chipcHw_REG_DIV_CLOCK_DIV_256 : divider) & chipcHw_REG_DIV_CLOCK_DIV_MASK);
+                       REG_LOCAL_IRQ_RESTORE;
+                       return freq;
+               }
+       }
+
+       return 0;
+}
+
+EXPORT_SYMBOL(chipcHw_setClockFrequency);
+
+/****************************************************************************/
+/**
+*  @brief   Set VPM clock in sync with BUS clock for Chip Rev #A0
+*
+*  This function does the phase adjustment between VPM and BUS clock
+*
+*  @return >= 0 : On success (# of adjustment required)
+*            -1 : On failure
+*
+*/
+/****************************************************************************/
+static int vpmPhaseAlignA0(void)
+{
+       uint32_t phaseControl;
+       uint32_t phaseValue;
+       uint32_t prevPhaseComp;
+       int iter = 0;
+       int adjustCount = 0;
+       int count = 0;
+
+       for (iter = 0; (iter < MAX_PHASE_ALIGN_ATTEMPTS) && (adjustCount < MAX_PHASE_ADJUST_COUNT); iter++) {
+               phaseControl = (pChipcHw->VPMClock & chipcHw_REG_PLL_CLOCK_PHASE_CONTROL_MASK) >> chipcHw_REG_PLL_CLOCK_PHASE_CONTROL_SHIFT;
+               phaseValue = 0;
+               prevPhaseComp = 0;
+
+               /* Step 1: Look for falling PH_COMP transition */
+
+               /* Read the contents of VPM Clock resgister */
+               phaseValue = pChipcHw->VPMClock;
+               do {
+                       /* Store previous value of phase comparator */
+                       prevPhaseComp = phaseValue & chipcHw_REG_PLL_CLOCK_PHASE_COMP;
+                       /* Change the value of PH_CTRL. */
+                       reg32_write(&pChipcHw->VPMClock, (pChipcHw->VPMClock & (~chipcHw_REG_PLL_CLOCK_PHASE_CONTROL_MASK)) | (phaseControl << chipcHw_REG_PLL_CLOCK_PHASE_CONTROL_SHIFT));
+                       /* Wait atleast 20 ns */
+                       WAIT();
+                       /* Toggle the LOAD_CH after phase control is written. */
+                       pChipcHw->VPMClock ^= chipcHw_REG_PLL_CLOCK_PHASE_UPDATE_ENABLE;
+                       /* Read the contents of  VPM Clock resgister. */
+                       phaseValue = pChipcHw->VPMClock;
+
+                       if ((phaseValue & chipcHw_REG_PLL_CLOCK_PHASE_COMP) == 0x0) {
+                               phaseControl = (0x3F & (phaseControl - 1));
+                       } else {
+                               /* Increment to the Phase count value for next write, if Phase is not stable. */
+                               phaseControl = (0x3F & (phaseControl + 1));
+                       }
+                       /* Count number of adjustment made */
+                       adjustCount++;
+               } while (((prevPhaseComp == (phaseValue & chipcHw_REG_PLL_CLOCK_PHASE_COMP)) || /* Look for a transition */
+                         ((phaseValue & chipcHw_REG_PLL_CLOCK_PHASE_COMP) != 0x0)) &&  /* Look for a falling edge */
+                        (adjustCount < MAX_PHASE_ADJUST_COUNT) /* Do not exceed the limit while trying */
+                   );
+
+               if (adjustCount >= MAX_PHASE_ADJUST_COUNT) {
+                       /* Failed to align VPM phase after MAX_PHASE_ADJUST_COUNT tries */
+                       return -1;
+               }
+
+               /* Step 2: Keep moving forward to make sure falling PH_COMP transition was valid */
+
+               for (count = 0; (count < 5) && ((phaseValue & chipcHw_REG_PLL_CLOCK_PHASE_COMP) == 0); count++) {
+                       phaseControl = (0x3F & (phaseControl + 1));
+                       reg32_write(&pChipcHw->VPMClock, (pChipcHw->VPMClock & (~chipcHw_REG_PLL_CLOCK_PHASE_CONTROL_MASK)) | (phaseControl << chipcHw_REG_PLL_CLOCK_PHASE_CONTROL_SHIFT));
+                       /* Wait atleast 20 ns */
+                       WAIT();
+                       /* Toggle the LOAD_CH after phase control is written. */
+                       pChipcHw->VPMClock ^= chipcHw_REG_PLL_CLOCK_PHASE_UPDATE_ENABLE;
+                       phaseValue = pChipcHw->VPMClock;
+                       /* Count number of adjustment made */
+                       adjustCount++;
+               }
+
+               if (adjustCount >= MAX_PHASE_ADJUST_COUNT) {
+                       /* Failed to align VPM phase after MAX_PHASE_ADJUST_COUNT tries */
+                       return -1;
+               }
+
+               if (count != 5) {
+                       /* Detected false transition */
+                       continue;
+               }
+
+               /* Step 3: Keep moving backward to make sure falling PH_COMP transition was stable */
+
+               for (count = 0; (count < 3) && ((phaseValue & chipcHw_REG_PLL_CLOCK_PHASE_COMP) == 0); count++) {
+                       phaseControl = (0x3F & (phaseControl - 1));
+                       reg32_write(&pChipcHw->VPMClock, (pChipcHw->VPMClock & (~chipcHw_REG_PLL_CLOCK_PHASE_CONTROL_MASK)) | (phaseControl << chipcHw_REG_PLL_CLOCK_PHASE_CONTROL_SHIFT));
+                       /* Wait atleast 20 ns */
+                       WAIT();
+                       /* Toggle the LOAD_CH after phase control is written. */
+                       pChipcHw->VPMClock ^= chipcHw_REG_PLL_CLOCK_PHASE_UPDATE_ENABLE;
+                       phaseValue = pChipcHw->VPMClock;
+                       /* Count number of adjustment made */
+                       adjustCount++;
+               }
+
+               if (adjustCount >= MAX_PHASE_ADJUST_COUNT) {
+                       /* Failed to align VPM phase after MAX_PHASE_ADJUST_COUNT tries */
+                       return -1;
+               }
+
+               if (count != 3) {
+                       /* Detected noisy transition */
+                       continue;
+               }
+
+               /* Step 4: Keep moving backward before the original transition took place. */
+
+               for (count = 0; (count < 5); count++) {
+                       phaseControl = (0x3F & (phaseControl - 1));
+                       reg32_write(&pChipcHw->VPMClock, (pChipcHw->VPMClock & (~chipcHw_REG_PLL_CLOCK_PHASE_CONTROL_MASK)) | (phaseControl << chipcHw_REG_PLL_CLOCK_PHASE_CONTROL_SHIFT));
+                       /* Wait atleast 20 ns */
+                       WAIT();
+                       /* Toggle the LOAD_CH after phase control is written. */
+                       pChipcHw->VPMClock ^= chipcHw_REG_PLL_CLOCK_PHASE_UPDATE_ENABLE;
+                       phaseValue = pChipcHw->VPMClock;
+                       /* Count number of adjustment made */
+                       adjustCount++;
+               }
+
+               if (adjustCount >= MAX_PHASE_ADJUST_COUNT) {
+                       /* Failed to align VPM phase after MAX_PHASE_ADJUST_COUNT tries */
+                       return -1;
+               }
+
+               if ((phaseValue & chipcHw_REG_PLL_CLOCK_PHASE_COMP) == 0) {
+                       /* Detected false transition */
+                       continue;
+               }
+
+               /* Step 5: Re discover the valid transition */
+
+               do {
+                       /* Store previous value of phase comparator */
+                       prevPhaseComp = phaseValue;
+                       /* Change the value of PH_CTRL. */
+                       reg32_write(&pChipcHw->VPMClock, (pChipcHw->VPMClock & (~chipcHw_REG_PLL_CLOCK_PHASE_CONTROL_MASK)) | (phaseControl << chipcHw_REG_PLL_CLOCK_PHASE_CONTROL_SHIFT));
+                       /* Wait atleast 20 ns */
+                       WAIT();
+                       /* Toggle the LOAD_CH after phase control is written. */
+                       pChipcHw->VPMClock ^=
+                           chipcHw_REG_PLL_CLOCK_PHASE_UPDATE_ENABLE;
+                       /* Read the contents of  VPM Clock resgister. */
+                       phaseValue = pChipcHw->VPMClock;
+
+                       if ((phaseValue & chipcHw_REG_PLL_CLOCK_PHASE_COMP) == 0x0) {
+                               phaseControl = (0x3F & (phaseControl - 1));
+                       } else {
+                               /* Increment to the Phase count value for next write, if Phase is not stable. */
+                               phaseControl = (0x3F & (phaseControl + 1));
+                       }
+
+                       /* Count number of adjustment made */
+                       adjustCount++;
+               } while (((prevPhaseComp == (phaseValue & chipcHw_REG_PLL_CLOCK_PHASE_COMP)) || ((phaseValue & chipcHw_REG_PLL_CLOCK_PHASE_COMP) != 0x0)) && (adjustCount < MAX_PHASE_ADJUST_COUNT));
+
+               if (adjustCount >= MAX_PHASE_ADJUST_COUNT) {
+                       /* Failed to align VPM phase after MAX_PHASE_ADJUST_COUNT tries  */
+                       return -1;
+               } else {
+                       /* Valid phase must have detected */
+                       break;
+               }
+       }
+
+       /* For VPM Phase should be perfectly aligned. */
+       phaseControl = (((pChipcHw->VPMClock >> chipcHw_REG_PLL_CLOCK_PHASE_CONTROL_SHIFT) - 1) & 0x3F);
+       {
+               REG_LOCAL_IRQ_SAVE;
+
+               pChipcHw->VPMClock = (pChipcHw->VPMClock & ~chipcHw_REG_PLL_CLOCK_PHASE_CONTROL_MASK) | (phaseControl << chipcHw_REG_PLL_CLOCK_PHASE_CONTROL_SHIFT);
+               /* Load new phase value */
+               pChipcHw->VPMClock ^= chipcHw_REG_PLL_CLOCK_PHASE_UPDATE_ENABLE;
+
+               REG_LOCAL_IRQ_RESTORE;
+       }
+       /* Return the status */
+       return (int)adjustCount;
+}
+
+/****************************************************************************/
+/**
+*  @brief   Set VPM clock in sync with BUS clock
+*
+*  This function does the phase adjustment between VPM and BUS clock
+*
+*  @return >= 0 : On success (# of adjustment required)
+*            -1 : On failure
+*
+*/
+/****************************************************************************/
+int chipcHw_vpmPhaseAlign(void)
+{
+
+       if (chipcHw_getChipRevisionNumber() == chipcHw_REV_NUMBER_A0) {
+               return vpmPhaseAlignA0();
+       } else {
+               uint32_t phaseControl = chipcHw_getVpmPhaseControl();
+               uint32_t phaseValue = 0;
+               int adjustCount = 0;
+
+               /* Disable VPM access */
+               pChipcHw->Spare1 &= ~chipcHw_REG_SPARE1_VPM_BUS_ACCESS_ENABLE;
+               /* Disable HW VPM phase alignment  */
+               chipcHw_vpmHwPhaseAlignDisable();
+               /* Enable SW VPM phase alignment  */
+               chipcHw_vpmSwPhaseAlignEnable();
+               /* Adjust VPM phase */
+               while (adjustCount < MAX_PHASE_ADJUST_COUNT) {
+                       phaseValue = chipcHw_getVpmHwPhaseAlignStatus();
+
+                       /* Adjust phase control value */
+                       if (phaseValue > 0xF) {
+                               /* Increment phase control value */
+                               phaseControl++;
+                       } else if (phaseValue < 0xF) {
+                               /* Decrement phase control value */
+                               phaseControl--;
+                       } else {
+                               /* Enable VPM access */
+                               pChipcHw->Spare1 |= chipcHw_REG_SPARE1_VPM_BUS_ACCESS_ENABLE;
+                               /* Return adjust count */
+                               return adjustCount;
+                       }
+                       /* Change the value of PH_CTRL. */
+                       reg32_write(&pChipcHw->VPMClock, (pChipcHw->VPMClock & (~chipcHw_REG_PLL_CLOCK_PHASE_CONTROL_MASK)) | (phaseControl << chipcHw_REG_PLL_CLOCK_PHASE_CONTROL_SHIFT));
+                       /* Wait atleast 20 ns */
+                       WAIT();
+                       /* Toggle the LOAD_CH after phase control is written. */
+                       pChipcHw->VPMClock ^= chipcHw_REG_PLL_CLOCK_PHASE_UPDATE_ENABLE;
+                       /* Count adjustment */
+                       adjustCount++;
+               }
+       }
+
+       /* Disable VPM access */
+       pChipcHw->Spare1 &= ~chipcHw_REG_SPARE1_VPM_BUS_ACCESS_ENABLE;
+       return -1;
+}
+
+/****************************************************************************/
+/**
+*  @brief   Local Divide function
+*
+*  This function does the divide
+*
+*  @return divide value
+*
+*/
+/****************************************************************************/
+static int chipcHw_divide(int num, int denom)
+{
+       int r;
+       int t = 1;
+
+       /* Shift denom and t up to the largest value to optimize algorithm */
+       /* t contains the units of each divide */
+       while ((denom & 0x40000000) == 0) {     /* fails if denom=0 */
+               denom = denom << 1;
+               t = t << 1;
+       }
+
+       /* Intialize the result */
+       r = 0;
+
+       do {
+               /* Determine if there exists a positive remainder */
+               if ((num - denom) >= 0) {
+                       /* Accumlate t to the result and calculate a new remainder */
+                       num = num - denom;
+                       r = r + t;
+               }
+               /* Continue to shift denom and shift t down to 0 */
+               denom = denom >> 1;
+               t = t >> 1;
+       } while (t != 0);
+
+       return r;
+}
diff --git a/arch/arm/mach-bcmring/csp/chipc/chipcHw_clkreconfig.c b/arch/arm/mach-bcmring/csp/chipc/chipcHw_clkreconfig.c
new file mode 100644
index 0000000..9ad1ae9
--- /dev/null
+++ b/arch/arm/mach-bcmring/csp/chipc/chipcHw_clkreconfig.c
@@ -0,0 +1,248 @@
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
+/* ---- Include Files ---------------------------------------------------- */
+#include <csp/stdint.h>
+
+#include <mach/csp/chipcHw_def.h>
+#include <mach/csp/chipcHw_inline.h>
+#include <mach/csp/sdramHw_phaseAlign.h>
+#include <csp/intcHw.h>
+#include <csp/vpmHw.h>
+#include <csp/cache.h>
+#include <csp/delay.h>
+
+/* ---- Private Constants and Types --------------------------------------- */
+/* The following varaibles are defined in the linker file which contain the
+ * start and end address of the aramtext section.  The aramtext section links to
+ * DDR and however is relocatable and can be executed completely within ARAM */
+char _aramtext_start, _aramtext_end;
+
+#define ARAM_STACKSIZE 0x400
+
+/* ---- Private Variables ------------------------------------------------- */
+void chipcHw_run_from_aram(uint32_t busHz, uint32_t armRatio, uint32_t vpmRatio,
+                          uint32_t ddrRatio)
+    __attribute__ ((section(".aramtext")));
+
+typedef void (*RUNFUNC) (uint32_t busHz, uint32_t armRatio, uint32_t vpmRatio,
+                        uint32_t ddrRatio);
+
+/*
+ * Get current state.
+ */
+static inline uint32_t get_flags(void)
+{
+       uint32_t flags;
+
+       __asm__ __volatile__("mrs    %0, cpsr " : "=r"(flags) : : "memory", "cc");
+       return flags;
+}
+
+/*
+ * restore saved state
+ */
+static inline void restore_flags(uint32_t flags)
+{
+       __asm__ __volatile__("msr    cpsr_c, %0 " : : "r"(flags) : "memory", "cc");
+}
+
+/*
+ * Enable IRQs
+ */
+static inline void enable_irq(void)
+{
+       uint32_t flags = get_flags();
+       /* clear IRQ disable bit (enable IRQ) */
+       flags &= ~0x00000080;
+       restore_flags(flags);
+}
+
+/*
+ * Disable IRQs
+ */
+static inline void disable_irq(void)
+{
+       uint32_t flags = get_flags();
+       /* set IRQ disable bit (disable IRQ) */
+       flags |= 0x00000080;
+       restore_flags(flags);
+}
+
+/*
+ * Enable FIQs
+ */
+static inline void enable_fiq(void)
+{
+       uint32_t flags = get_flags();
+       /* clear FIQ disable bit (enable FIQ) */
+       flags &= ~0x00000040;
+       restore_flags(flags);
+}
+
+/*
+ * Disable FIQs
+ */
+static inline void disable_fiq(void)
+{
+       uint32_t flags = get_flags();
+       /* set FIQ disable bit (disable FIQ) */
+       flags |= 0x00000040;
+       restore_flags(flags);
+}
+
+/****************************************************************************/
+/**
+*  @brief   chipcHw_clockReconfig
+*
+*  @note chipcHw_clockReconfig configures the clock.
+*   To do so it needs to copy the code into internal
+*   memory to change the ARM clock and not execute from DDR.
+*   ARAM is used for code and stack.  The contents of ARAM are not
+*   preserved.
+*/
+/****************************************************************************/
+void chipcHw_clockReconfig(uint32_t busHz, uint32_t armRatio, uint32_t vpmRatio,
+                          uint32_t ddrRatio)
+{
+       RUNFUNC runFunc;
+       char *src;
+       char *dst;
+       unsigned int *stackFill;
+       unsigned long flags;
+
+       /* Disable IRQ and FIQ */
+       flags = get_flags();
+       disable_irq();
+       disable_fiq();
+       {
+               REG_LOCAL_IRQ_SAVE;
+
+               /* Halt the VPM, prior to clock reconfiguration */
+               vpmHw_Halt();
+
+               src = &_aramtext_start;
+               dst = (char *)MM_IO_BASE_ARAM + ARAM_STACKSIZE;
+
+               /* Copy code currently in DDR to ARAM */
+               while (src < &_aramtext_end) {
+                       *dst++ = *src++;
+               }
+
+               /* Fill Stack with known pattern to allow measurement of usage if required */
+               stackFill = (unsigned int *)MM_IO_BASE_ARAM;
+               while (stackFill <
+                      (unsigned int *)(MM_IO_BASE_ARAM + ARAM_STACKSIZE)) {
+                       *stackFill++ = 0xdeaddead;
+               }
+
+               /* -----------
+                * |         |
+                * |         |
+                * |         |   <- start run here; ARAM BASE + ARAM_STACKSIZE + (chipcHw_run_from_aram - _aramtext_start)
+                * |         |
+                * | code    |
+                * |---------|   <- ARAM BASE + ARAM_STACKSIZE
+                * | stack   |  /\
+                * |   ||    |   | Top of stack
+                * |   ||    |   |
+                * |   ||    |   | ARAM_STACKSIZE
+                * |   \/    |   |
+                * |         |  \/
+                * -----------   <- ARAM BASE (0x30100000)
+                * */
+
+               /* Save stack pointer in DDR to known location in ARAM */
+               asm(" ldr r2, =0x30100400-4                                          ");
+               asm(" str sp, [r2]                                                   ");
+               /* Use new stack pointer now located in ARAM */
+               asm(" ldr sp, =0x30100400-8                                          ");
+
+               /* Calculate the offset into ARAM to ensure that chipcHw_run_from_aram() is called */
+               runFunc =
+                   (RUNFUNC) (unsigned long)MM_ADDR_IO_ARAM + ARAM_STACKSIZE +
+                   (unsigned long)&chipcHw_run_from_aram -
+                   (unsigned long)&_aramtext_start;
+
+               CSP_CACHE_FLUSH_ALL;
+
+               /* run the function from ARAM */
+               runFunc(busHz, armRatio, vpmRatio, ddrRatio);
+
+               /* Restore stack pointer in DDR */
+               asm(" ldr r2, =0x30100400-4                                          ");
+               asm(" ldr sp, [r2]                                                   ");
+
+               /* Re-enable the VPM */
+               vpmHw_Run();
+
+               REG_LOCAL_IRQ_RESTORE;
+       }
+       /* Re-enable IRQ and FIQ */
+       restore_flags(flags);
+}
+
+/****************************************************************************/
+/**
+*  @brief   chipcHw_run_from_aram
+*
+*  @note This function must run from internal memory ARAM because DDR access
+*        is restricted when the clocks are reconfigured.  All of the functions and subfunctions
+*        called in this routine, *must* be located in the .aramtext section
+*        to ensure that DDR access does not occur.
+*/
+/****************************************************************************/
+void chipcHw_run_from_aram(uint32_t busHz, uint32_t armRatio, uint32_t vpmRatio,
+                          uint32_t ddrRatio)
+{
+       chipcHw_INIT_PARAM_t param;
+       int uartHz = 0;
+
+       if (busHz == 166666666) {
+               param.pllVcoFreqHz = 2000000000;        /* VCO must be integer multiple of bus.  VCO = 12 * bus */
+               uartHz = 142857142;     /* UART must be < 150MHz and multiple divided by VCO.   UART = VCO / 14 */
+       } else if (busHz == 150000000) {
+               param.pllVcoFreqHz = 1800000000;        /* VCO must be integer multiple of bus.  VCO = 12 * bus */
+               uartHz = 138461538;     /* UART must be < 150MHz and multiple divided by VCO.   UART = VCO / 13 */
+       } else {
+               /* Bus speed not supported */
+               return;
+       }
+
+       param.pll2VcoFreqHz = 1800000000;       /* Always 1.8GHz */
+
+       param.ssSupport = 0;
+       param.busClockFreqHz = busHz;
+       param.armBusRatio = armRatio;   /* ARM Clock = Ratio * BUS Clock */
+       param.vpmBusRatio = vpmRatio;   /* VPM Clock = Ratio * BUS Clock */
+       param.ddrBusRatio = ddrRatio;   /* DDR Clock = Ratio * BUS Clock */
+
+       /* Disable branch prediction.  Workaround for GNATS 8270 */
+       asm(" mrc p15, 0, r5, c1, c0, 0       ");       /* read control reg */
+       asm(" and r5, r5, #0xFFFFF7FF         ");       /* branch prediction off for ARM11 */
+       asm(" mcr p15, 0, r5, c1, c0, 0       ");       /* write control reg */
+
+       /* Program the PLL and major clocks */
+       chipcHw_Init(&param);
+
+       /* Re-enable branch prediction.  Workaround for GNATS 8270 */
+       asm(" mrc p15, 0, r5, c1, c0, 0       ");       /* read control reg */
+       asm(" orr r5, r5, #0x800              ");       /* branch prediction on for ARM11 */
+       asm(" mcr p15, 0, r5, c1, c0, 0       ");       /* write control reg */
+
+       chipcHw_setClockFrequency(chipcHw_CLOCK_UART, uartHz);
+
+       /* Set DDR clock in sync with BUS clock */
+       sdramHw_phaseAlignLowLevel();
+}
diff --git a/arch/arm/mach-bcmring/csp/chipc/chipcHw_init.c b/arch/arm/mach-bcmring/csp/chipc/chipcHw_init.c
new file mode 100644
index 0000000..367df75
--- /dev/null
+++ b/arch/arm/mach-bcmring/csp/chipc/chipcHw_init.c
@@ -0,0 +1,293 @@
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
+*  @file    chipcHw_init.c
+*
+*  @brief   Low level CHIPC PLL configuration functions
+*
+*  @note
+*
+*   These routines provide basic PLL controlling functionality only.
+*/
+/****************************************************************************/
+
+/* ---- Include Files ---------------------------------------------------- */
+
+#include <csp/errno.h>
+#include <csp/stdint.h>
+#include <csp/module.h>
+
+#include <mach/csp/chipcHw_def.h>
+#include <mach/csp/chipcHw_inline.h>
+
+#include <csp/reg.h>
+#include <csp/delay.h>
+/* ---- Private Constants and Types --------------------------------------- */
+
+/*
+    Calculation for NDIV_i to obtain VCO frequency
+    -----------------------------------------------
+
+       Freq_vco = Freq_ref * (P2 / P1) * (PLL_NDIV_i + PLL_NDIV_f)
+       for Freq_vco = VCO_FREQ_MHz
+               Freq_ref = chipcHw_XTAL_FREQ_Hz
+               PLL_P1 = PLL_P2 = 1
+               and
+               PLL_NDIV_f = 0
+
+       We get:
+               PLL_NDIV_i = Freq_vco / Freq_ref = VCO_FREQ_MHz / chipcHw_XTAL_FREQ_Hz
+
+    Calculation for PLL MDIV to obtain frequency Freq_x for channel x
+    -----------------------------------------------------------------
+               Freq_x = chipcHw_XTAL_FREQ_Hz * PLL_NDIV_i / PLL_MDIV_x = VCO_FREQ_MHz / PLL_MDIV_x
+
+               PLL_MDIV_x = VCO_FREQ_MHz / Freq_x
+*/
+
+/* ---- Private Variables ------------------------------------------------- */
+/****************************************************************************/
+/**
+*  @brief  Initializes the PLL2
+*
+*  This function initializes the PLL2
+*
+*/
+/****************************************************************************/
+void chipcHw_pll2Enable(uint32_t vcoFreqHz)
+{
+       uint32_t pllPreDivider2 = 0;
+
+       {
+               REG_LOCAL_IRQ_SAVE;
+               pChipcHw->PLLConfig2 =
+                   chipcHw_REG_PLL_CONFIG_D_RESET |
+                   chipcHw_REG_PLL_CONFIG_A_RESET;
+
+               pllPreDivider2 = chipcHw_REG_PLL_PREDIVIDER_POWER_DOWN |
+                   chipcHw_REG_PLL_PREDIVIDER_NDIV_MODE_INTEGER |
+                   (chipcHw_REG_PLL_PREDIVIDER_NDIV_i(vcoFreqHz) <<
+                    chipcHw_REG_PLL_PREDIVIDER_NDIV_SHIFT) |
+                   (chipcHw_REG_PLL_PREDIVIDER_P1 <<
+                    chipcHw_REG_PLL_PREDIVIDER_P1_SHIFT) |
+                   (chipcHw_REG_PLL_PREDIVIDER_P2 <<
+                    chipcHw_REG_PLL_PREDIVIDER_P2_SHIFT);
+
+               /* Enable CHIPC registers to control the PLL */
+               pChipcHw->PLLStatus |= chipcHw_REG_PLL_STATUS_CONTROL_ENABLE;
+
+               /* Set pre divider to get desired VCO frequency */
+               pChipcHw->PLLPreDivider2 = pllPreDivider2;
+               /* Set NDIV Frac */
+               pChipcHw->PLLDivider2 = chipcHw_REG_PLL_DIVIDER_NDIV_f;
+
+               /* This has to be removed once the default values are fixed for PLL2. */
+               pChipcHw->PLLControl12 = 0x38000700;
+               pChipcHw->PLLControl22 = 0x00000015;
+
+               /* Reset PLL2 */
+               if (vcoFreqHz > chipcHw_REG_PLL_CONFIG_VCO_SPLIT_FREQ) {
+                       pChipcHw->PLLConfig2 = chipcHw_REG_PLL_CONFIG_D_RESET |
+                           chipcHw_REG_PLL_CONFIG_A_RESET |
+                           chipcHw_REG_PLL_CONFIG_VCO_1601_3200 |
+                           chipcHw_REG_PLL_CONFIG_POWER_DOWN;
+               } else {
+                       pChipcHw->PLLConfig2 = chipcHw_REG_PLL_CONFIG_D_RESET |
+                           chipcHw_REG_PLL_CONFIG_A_RESET |
+                           chipcHw_REG_PLL_CONFIG_VCO_800_1600 |
+                           chipcHw_REG_PLL_CONFIG_POWER_DOWN;
+               }
+               REG_LOCAL_IRQ_RESTORE;
+       }
+
+       /* Insert certain amount of delay before deasserting ARESET. */
+       udelay(1);
+
+       {
+               REG_LOCAL_IRQ_SAVE;
+               /* Remove analog reset and Power on the PLL */
+               pChipcHw->PLLConfig2 &=
+                   ~(chipcHw_REG_PLL_CONFIG_A_RESET |
+                     chipcHw_REG_PLL_CONFIG_POWER_DOWN);
+
+               REG_LOCAL_IRQ_RESTORE;
+
+       }
+
+       /* Wait until PLL is locked */
+       while (!(pChipcHw->PLLStatus2 & chipcHw_REG_PLL_STATUS_LOCKED))
+               ;
+
+       {
+               REG_LOCAL_IRQ_SAVE;
+               /* Remove digital reset */
+               pChipcHw->PLLConfig2 &= ~chipcHw_REG_PLL_CONFIG_D_RESET;
+
+               REG_LOCAL_IRQ_RESTORE;
+       }
+}
+
+EXPORT_SYMBOL(chipcHw_pll2Enable);
+
+/****************************************************************************/
+/**
+*  @brief  Initializes the PLL1
+*
+*  This function initializes the PLL1
+*
+*/
+/****************************************************************************/
+void chipcHw_pll1Enable(uint32_t vcoFreqHz, chipcHw_SPREAD_SPECTRUM_e ssSupport)
+{
+       uint32_t pllPreDivider = 0;
+
+       {
+               REG_LOCAL_IRQ_SAVE;
+
+               pChipcHw->PLLConfig =
+                   chipcHw_REG_PLL_CONFIG_D_RESET |
+                   chipcHw_REG_PLL_CONFIG_A_RESET;
+               /* Setting VCO frequency */
+               if (ssSupport == chipcHw_SPREAD_SPECTRUM_ALLOW) {
+                       pllPreDivider =
+                           chipcHw_REG_PLL_PREDIVIDER_NDIV_MODE_MASH_1_8 |
+                           ((chipcHw_REG_PLL_PREDIVIDER_NDIV_i(vcoFreqHz) -
+                             1) << chipcHw_REG_PLL_PREDIVIDER_NDIV_SHIFT) |
+                           (chipcHw_REG_PLL_PREDIVIDER_P1 <<
+                            chipcHw_REG_PLL_PREDIVIDER_P1_SHIFT) |
+                           (chipcHw_REG_PLL_PREDIVIDER_P2 <<
+                            chipcHw_REG_PLL_PREDIVIDER_P2_SHIFT);
+               } else {
+                       pllPreDivider = chipcHw_REG_PLL_PREDIVIDER_POWER_DOWN |
+                           chipcHw_REG_PLL_PREDIVIDER_NDIV_MODE_INTEGER |
+                           (chipcHw_REG_PLL_PREDIVIDER_NDIV_i(vcoFreqHz) <<
+                            chipcHw_REG_PLL_PREDIVIDER_NDIV_SHIFT) |
+                           (chipcHw_REG_PLL_PREDIVIDER_P1 <<
+                            chipcHw_REG_PLL_PREDIVIDER_P1_SHIFT) |
+                           (chipcHw_REG_PLL_PREDIVIDER_P2 <<
+                            chipcHw_REG_PLL_PREDIVIDER_P2_SHIFT);
+               }
+
+               /* Enable CHIPC registers to control the PLL */
+               pChipcHw->PLLStatus |= chipcHw_REG_PLL_STATUS_CONTROL_ENABLE;
+
+               /* Set pre divider to get desired VCO frequency */
+               pChipcHw->PLLPreDivider = pllPreDivider;
+               /* Set NDIV Frac */
+               if (ssSupport == chipcHw_SPREAD_SPECTRUM_ALLOW) {
+                       pChipcHw->PLLDivider = chipcHw_REG_PLL_DIVIDER_M1DIV |
+                           chipcHw_REG_PLL_DIVIDER_NDIV_f_SS;
+               } else {
+                       pChipcHw->PLLDivider = chipcHw_REG_PLL_DIVIDER_M1DIV |
+                           chipcHw_REG_PLL_DIVIDER_NDIV_f;
+               }
+
+               /* Reset PLL1 */
+               if (vcoFreqHz > chipcHw_REG_PLL_CONFIG_VCO_SPLIT_FREQ) {
+                       pChipcHw->PLLConfig = chipcHw_REG_PLL_CONFIG_D_RESET |
+                           chipcHw_REG_PLL_CONFIG_A_RESET |
+                           chipcHw_REG_PLL_CONFIG_VCO_1601_3200 |
+                           chipcHw_REG_PLL_CONFIG_POWER_DOWN;
+               } else {
+                       pChipcHw->PLLConfig = chipcHw_REG_PLL_CONFIG_D_RESET |
+                           chipcHw_REG_PLL_CONFIG_A_RESET |
+                           chipcHw_REG_PLL_CONFIG_VCO_800_1600 |
+                           chipcHw_REG_PLL_CONFIG_POWER_DOWN;
+               }
+
+               REG_LOCAL_IRQ_RESTORE;
+
+               /* Insert certain amount of delay before deasserting ARESET. */
+               udelay(1);
+
+               {
+                       REG_LOCAL_IRQ_SAVE;
+                       /* Remove analog reset and Power on the PLL */
+                       pChipcHw->PLLConfig &=
+                           ~(chipcHw_REG_PLL_CONFIG_A_RESET |
+                             chipcHw_REG_PLL_CONFIG_POWER_DOWN);
+                       REG_LOCAL_IRQ_RESTORE;
+               }
+
+               /* Wait until PLL is locked */
+               while (!(pChipcHw->PLLStatus & chipcHw_REG_PLL_STATUS_LOCKED)
+                      || !(pChipcHw->
+                           PLLStatus2 & chipcHw_REG_PLL_STATUS_LOCKED))
+                       ;
+
+               /* Remove digital reset */
+               {
+                       REG_LOCAL_IRQ_SAVE;
+                       pChipcHw->PLLConfig &= ~chipcHw_REG_PLL_CONFIG_D_RESET;
+                       REG_LOCAL_IRQ_RESTORE;
+               }
+       }
+}
+
+EXPORT_SYMBOL(chipcHw_pll1Enable);
+
+/****************************************************************************/
+/**
+*  @brief  Initializes the chipc module
+*
+*  This function initializes the PLLs and core system clocks
+*
+*/
+/****************************************************************************/
+
+void chipcHw_Init(chipcHw_INIT_PARAM_t *initParam      /*  [ IN ] Misc chip initialization parameter */
+    ) {
+#if !(defined(__KERNEL__) && !defined(STANDALONE))
+       delay_init();
+#endif
+
+       /* Do not program PLL, when warm reset */
+       if (!(chipcHw_getStickyBits() & chipcHw_REG_STICKY_CHIP_WARM_RESET)) {
+               chipcHw_pll1Enable(initParam->pllVcoFreqHz,
+                                  initParam->ssSupport);
+               chipcHw_pll2Enable(initParam->pll2VcoFreqHz);
+       } else {
+               /* Clear sticky bits */
+               chipcHw_clearStickyBits(chipcHw_REG_STICKY_CHIP_WARM_RESET);
+       }
+       /* Clear sticky bits */
+       chipcHw_clearStickyBits(chipcHw_REG_STICKY_CHIP_SOFT_RESET);
+
+       /* Before configuring the ARM clock, atleast we need to make sure BUS clock maintains the proper ratio with ARM clock */
+       pChipcHw->ACLKClock =
+           (pChipcHw->
+            ACLKClock & ~chipcHw_REG_ACLKClock_CLK_DIV_MASK) | (initParam->
+                                                                armBusRatio &
+                                                                chipcHw_REG_ACLKClock_CLK_DIV_MASK);
+
+       /* Set various core component frequencies. The order in which this is done is important for some. */
+       /* The RTBUS (DDR PHY) is derived from the BUS, and the BUS from the ARM, and VPM needs to know BUS */
+       /* frequency to find its ratio with the BUS.  Hence we must set the ARM first, followed by the BUS,  */
+       /* then VPM and RTBUS. */
+
+       chipcHw_setClockFrequency(chipcHw_CLOCK_ARM,
+                                 initParam->busClockFreqHz *
+                                 initParam->armBusRatio);
+       chipcHw_setClockFrequency(chipcHw_CLOCK_BUS, initParam->busClockFreqHz);
+       chipcHw_setClockFrequency(chipcHw_CLOCK_VPM,
+                                 initParam->busClockFreqHz *
+                                 initParam->vpmBusRatio);
+       chipcHw_setClockFrequency(chipcHw_CLOCK_DDR,
+                                 initParam->busClockFreqHz *
+                                 initParam->ddrBusRatio);
+       chipcHw_setClockFrequency(chipcHw_CLOCK_RTBUS,
+                                 initParam->busClockFreqHz / 2);
+}
diff --git a/arch/arm/mach-bcmring/csp/chipc/chipcHw_reset.c b/arch/arm/mach-bcmring/csp/chipc/chipcHw_reset.c
new file mode 100644
index 0000000..0692d5f
--- /dev/null
+++ b/arch/arm/mach-bcmring/csp/chipc/chipcHw_reset.c
@@ -0,0 +1,125 @@
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
+/* ---- Include Files ---------------------------------------------------- */
+#include <csp/stdint.h>
+#include <mach/csp/chipcHw_def.h>
+#include <mach/csp/chipcHw_inline.h>
+#include <csp/intcHw.h>
+#include <csp/cache.h>
+
+/* ---- Private Constants and Types --------------------------------------- */
+/* ---- Private Variables ------------------------------------------------- */
+void chipcHw_reset_run_from_aram(void);
+
+typedef void (*RUNFUNC) (void);
+
+/****************************************************************************/
+/**
+*  @brief   warmReset
+*
+*  @note warmReset configures the clocks which are not reset back to the state
+*   required to execute on reset.  To do so we need to copy the code into internal
+*   memory to change the ARM clock while we are not executing from DDR.
+*/
+/****************************************************************************/
+void chipcHw_reset(uint32_t mask)
+{
+       int i = 0;
+       RUNFUNC runFunc = (RUNFUNC) (unsigned long)MM_ADDR_IO_ARAM;
+
+       /* Disable all interrupts */
+       intcHw_irq_disable(INTCHW_INTC0, 0xffffffff);
+       intcHw_irq_disable(INTCHW_INTC1, 0xffffffff);
+       intcHw_irq_disable(INTCHW_SINTC, 0xffffffff);
+
+       {
+               REG_LOCAL_IRQ_SAVE;
+               if (mask & chipcHw_REG_SOFT_RESET_CHIP_SOFT) {
+                       chipcHw_softReset(chipcHw_REG_SOFT_RESET_CHIP_SOFT);
+               }
+               /* Bypass the PLL clocks before reboot */
+               pChipcHw->UARTClock |= chipcHw_REG_PLL_CLOCK_BYPASS_SELECT;
+               pChipcHw->SPIClock |= chipcHw_REG_PLL_CLOCK_BYPASS_SELECT;
+
+               /* Copy the chipcHw_warmReset_run_from_aram function into ARAM */
+               do {
+                       ((uint32_t *) MM_IO_BASE_ARAM)[i] =
+                           ((uint32_t *) &chipcHw_reset_run_from_aram)[i];
+                       i++;
+               } while (((uint32_t *) MM_IO_BASE_ARAM)[i - 1] != 0xe1a0f00f);  /* 0xe1a0f00f == asm ("mov r15, r15"); */
+
+               CSP_CACHE_FLUSH_ALL;
+
+               /* run the function from ARAM */
+               runFunc();
+
+               /* Code will never get here, but include it to balance REG_LOCAL_IRQ_SAVE above */
+               REG_LOCAL_IRQ_RESTORE;
+       }
+}
+
+/* This function must run from internal memory */
+void chipcHw_reset_run_from_aram(void)
+{
+/* Make sure, pipeline is filled with instructions coming from ARAM */
+       asm(" nop                                                            ");
+       asm(" nop                                                            ");
+#if defined(__KERNEL__) && !defined(STANDALONE)
+       asm(" MRC      p15,#0x0,r0,c1,c0,#0        ");
+       asm(" BIC      r0,r0,#0xd                                            ");
+       asm(" MCR      p15,#0x0,r0,c1,c0,#0       ");
+       asm(" nop                                                            ");
+       asm(" nop                                                            ");
+       asm(" nop                                                            ");
+       asm(" nop                                                            ");
+       asm(" nop                                                            ");
+       asm(" nop                                                            ");
+#endif
+       asm(" nop                                                            ");
+       asm(" nop                                                            ");
+       /* Bypass the ARM clock and switch to XTAL clock */
+       asm(" MOV      r2,#0x80000000                                        ");
+       asm(" LDR      r3,[r2,#8]                                            ");
+       asm(" ORR      r3,r3,#0x20000                                        ");
+       asm(" STR      r3,[r2,#8]                                            ");
+
+       asm(" nop                                                            ");
+       asm(" nop                                                            ");
+       asm(" nop                                                            ");
+       asm(" nop                                                            ");
+       asm(" nop                                                            ");
+       asm(" nop                                                            ");
+       asm(" nop                                                            ");
+       asm(" nop                                                            ");
+       asm(" nop                                                            ");
+       asm(" nop                                                            ");
+       asm(" nop                                                            ");
+       asm(" nop                                                            ");
+       asm(" nop                                                            ");
+       asm(" nop                                                            ");
+       asm(" nop                                                            ");
+       asm(" nop                                                            ");
+       asm(" nop                                                            ");
+       asm(" nop                                                            ");
+       asm(" nop                                                            ");
+       asm(" nop                                                            ");
+       /* Issue reset */
+       asm(" MOV      r3,#0x2                                                 ");
+       asm(" STR      r3,[r2,#0x80]                                         ");
+       /* End here */
+       asm(" MOV      pc,pc                                                 ");
+/* 0xe1a0f00f ==  asm ("mov r15, r15"); */
+       ;
+}
diff --git a/arch/arm/mach-bcmring/csp/chipc/chipcHw_str.c b/arch/arm/mach-bcmring/csp/chipc/chipcHw_str.c
new file mode 100644
index 0000000..54ad964
--- /dev/null
+++ b/arch/arm/mach-bcmring/csp/chipc/chipcHw_str.c
@@ -0,0 +1,64 @@
+/*****************************************************************************
+* Copyright 2008 Broadcom Corporation.  All rights reserved.
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
+/****************************************************************************/
+/**
+*  @file    chipcHw_str.c
+*
+*  @brief   Contains strings which are useful to linux and csp
+*
+*  @note
+*/
+/****************************************************************************/
+
+/* ---- Include Files ---------------------------------------------------- */
+
+#include <mach/csp/chipcHw_inline.h>
+
+/* ---- Private Constants and Types --------------------------------------- */
+
+static const char *gMuxStr[] = {
+       "GPIO",                 /* 0 */
+       "KeyPad",               /* 1 */
+       "I2C-Host",             /* 2 */
+       "SPI",                  /* 3 */
+       "Uart",                 /* 4 */
+       "LED-Mtx-P",            /* 5 */
+       "LED-Mtx-S",            /* 6 */
+       "SDIO-0",               /* 7 */
+       "SDIO-1",               /* 8 */
+       "PCM",                  /* 9 */
+       "I2S",                  /* 10 */
+       "ETM",                  /* 11 */
+       "Debug",                /* 12 */
+       "Misc",                 /* 13 */
+       "0xE",                  /* 14 */
+       "0xF",                  /* 15 */
+};
+
+/****************************************************************************/
+/**
+*  @brief   Retrieves a string representation of the mux setting for a pin.
+*
+*  @return  Pointer to a character string.
+*/
+/****************************************************************************/
+
+const char *chipcHw_getGpioPinFunctionStr(int pin)
+{
+       if ((pin < 0) || (pin >= chipcHw_GPIO_COUNT)) {
+               return "";
+       }
+
+       return gMuxStr[chipcHw_getGpioPinFunction(pin)];
+}
--
1.6.0.6


Leo Hao Chen
Software Engineer
Broadcom Canada Inc.


