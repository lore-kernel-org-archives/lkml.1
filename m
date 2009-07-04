Return-Path: <linux-kernel-owner+w=401wt.eu-S1755372AbZGDBqH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372AbZGDBqH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 21:46:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758880AbZGDBok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 21:44:40 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:1657 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758802AbZGDBoa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 21:44:30 -0400
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
From: "Leo (Hao) Chen" <leochen@broadcom.com>
To: "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
       "Scott Branden" <sbranden@broadcom.com>,
       "Leo (Hao) Chen" <leochen@broadcom.com>
Date: Fri, 3 Jul 2009 18:44:13 -0700
Subject: [PATCH v2 9/18] new ARM SoC support: BCMRing
Thread-Topic: [PATCH v2 9/18] new ARM SoC support: BCMRing
Thread-Index: Acn8SO80JvQ+VKH2TDixZFMKrDbGKQ==
Message-ID: <8628FE4E7912BF47A96AE7DD7BAC0AADCB25BA6C17@SJEXCHCCR02.corp.ad.broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
X-WSS-ID: 66506C6560020617091-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From b26374d35d7ffc2fe6512c90fffae59890ed46cb Mon Sep 17 00:00:00 2001
From: Leo Chen <leochen@broadcom.com>
Date: Fri, 3 Jul 2009 17:04:06 -0700
Subject: [PATCH 09/18] add mach-bcmring timer.c

timer helper function, timer hardware register header file

Signed-off-by: Leo Chen <leochen@broadcom.com>
---
 arch/arm/mach-bcmring/include/mach/csp/tmrHw_reg.h |   82 ++++++++++++++++++++
 arch/arm/mach-bcmring/include/mach/timer.h         |   77 ++++++++++++++++++
 arch/arm/mach-bcmring/timer.c                      |   62 +++++++++++++++
 3 files changed, 221 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-bcmring/include/mach/csp/tmrHw_reg.h
 create mode 100644 arch/arm/mach-bcmring/include/mach/timer.h
 create mode 100644 arch/arm/mach-bcmring/timer.c

diff --git a/arch/arm/mach-bcmring/include/mach/csp/tmrHw_reg.h b/arch/arm/mach-bcmring/include/mach/csp/tmrHw_reg.h
new file mode 100644
index 0000000..3080ac7
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/mach/csp/tmrHw_reg.h
@@ -0,0 +1,82 @@
+/*****************************************************************************
+* Copyright 2004 - 2008 Broadcom Corporation.  All rights reserved.
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
+*  @file    tmrHw_reg.h
+*
+*  @brief   Definitions for low level Timer registers
+*
+*/
+/****************************************************************************/
+#ifndef _TMRHW_REG_H
+#define _TMRHW_REG_H
+
+#include <mach/csp/mm_io.h>
+#include <mach/csp/hw_cfg.h>
+/* Base address */
+#define tmrHw_MODULE_BASE_ADDR          MM_IO_BASE_TMR
+
+/*
+This platform has four different timers running at different clock speed
+
+Timer one   (Timer ID 0) runs at  25 MHz
+Timer two   (Timer ID 1) runs at  25 MHz
+Timer three (Timer ID 2) runs at 150 MHz
+Timer four  (Timer ID 3) runs at 150 MHz
+*/
+#define tmrHw_LOW_FREQUENCY_MHZ         25     /* Always 25MHz from XTAL */
+#define tmrHw_LOW_FREQUENCY_HZ          25000000
+
+#if defined(CFG_GLOBAL_CHIP) && (CFG_GLOBAL_CHIP == FPGA11107)
+#define tmrHw_HIGH_FREQUENCY_MHZ        150    /* Always 150MHz for FPGA */
+#define tmrHw_HIGH_FREQUENCY_HZ         150000000
+#else
+#define tmrHw_HIGH_FREQUENCY_HZ         HW_CFG_BUS_CLK_HZ
+#define tmrHw_HIGH_FREQUENCY_MHZ        (HW_CFG_BUS_CLK_HZ / 1000000)
+#endif
+
+#define tmrHw_LOW_RESOLUTION_CLOCK      tmrHw_LOW_FREQUENCY_HZ
+#define tmrHw_HIGH_RESOLUTION_CLOCK     tmrHw_HIGH_FREQUENCY_HZ
+#define tmrHw_MAX_COUNT                 (0xFFFFFFFF)   /* maximum number of count a timer can count */
+#define tmrHw_TIMER_NUM_COUNT           (4)    /* Number of timer module supported */
+
+typedef struct {
+       uint32_t LoadValue;     /* Load value for timer */
+       uint32_t CurrentValue;  /* Current value for timer */
+       uint32_t Control;       /* Control register */
+       uint32_t InterruptClear;        /* Interrupt clear register */
+       uint32_t RawInterruptStatus;    /* Raw interrupt status */
+       uint32_t InterruptStatus;       /* Masked interrupt status */
+       uint32_t BackgroundLoad;        /* Background load value */
+       uint32_t padding;       /* Padding register */
+} tmrHw_REG_t;
+
+/* Control bot masks */
+#define tmrHw_CONTROL_TIMER_ENABLE            0x00000080
+#define tmrHw_CONTROL_PERIODIC                0x00000040
+#define tmrHw_CONTROL_INTERRUPT_ENABLE        0x00000020
+#define tmrHw_CONTROL_PRESCALE_MASK           0x0000000C
+#define tmrHw_CONTROL_PRESCALE_1              0x00000000
+#define tmrHw_CONTROL_PRESCALE_16             0x00000004
+#define tmrHw_CONTROL_PRESCALE_256            0x00000008
+#define tmrHw_CONTROL_32BIT                   0x00000002
+#define tmrHw_CONTROL_ONESHOT                 0x00000001
+#define tmrHw_CONTROL_FREE_RUNNING            0x00000000
+
+#define tmrHw_CONTROL_MODE_MASK               (tmrHw_CONTROL_PERIODIC | tmrHw_CONTROL_ONESHOT)
+
+#define pTmrHw ((volatile tmrHw_REG_t *)tmrHw_MODULE_BASE_ADDR)
+
+#endif /* _TMRHW_REG_H */
diff --git a/arch/arm/mach-bcmring/include/mach/timer.h b/arch/arm/mach-bcmring/include/mach/timer.h
new file mode 100644
index 0000000..5a94bbb
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/mach/timer.h
@@ -0,0 +1,77 @@
+/*****************************************************************************
+* Copyright 2004 - 2008 Broadcom Corporation.  All rights reserved.
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
+/*
+*
+*****************************************************************************
+*
+*  timer.h
+*
+*  PURPOSE:
+*
+*
+*
+*  NOTES:
+*
+*****************************************************************************/
+
+#if !defined(BCM_LINUX_TIMER_H)
+#define BCM_LINUX_TIMER_H
+
+#if defined(__KERNEL__)
+
+/* ---- Include Files ---------------------------------------------------- */
+/* ---- Constants and Types ---------------------------------------------- */
+
+typedef unsigned int timer_tick_count_t;
+typedef unsigned int timer_tick_rate_t;
+typedef unsigned int timer_msec_t;
+
+/* ---- Variable Externs ------------------------------------------------- */
+/* ---- Function Prototypes ---------------------------------------------- */
+
+/****************************************************************************
+*
+*  timer_get_tick_count
+*
+*
+***************************************************************************/
+timer_tick_count_t timer_get_tick_count(void);
+
+/****************************************************************************
+*
+*  timer_get_tick_rate
+*
+*
+***************************************************************************/
+timer_tick_rate_t timer_get_tick_rate(void);
+
+/****************************************************************************
+*
+*  timer_get_msec
+*
+*
+***************************************************************************/
+timer_msec_t timer_get_msec(void);
+
+/****************************************************************************
+*
+*  timer_ticks_to_msec
+*
+*
+***************************************************************************/
+timer_msec_t timer_ticks_to_msec(timer_tick_count_t ticks);
+
+#endif /* __KERNEL__ */
+#endif /* BCM_LINUX_TIMER_H */
diff --git a/arch/arm/mach-bcmring/timer.c b/arch/arm/mach-bcmring/timer.c
new file mode 100644
index 0000000..2d415d2
--- /dev/null
+++ b/arch/arm/mach-bcmring/timer.c
@@ -0,0 +1,62 @@
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
+#include <linux/version.h>
+#include <linux/types.h>
+#include <linux/module.h>
+#include <csp/tmrHw.h>
+
+#include <mach/timer.h>
+/* The core.c file initializes timers 1 and 3 as a linux clocksource. */
+/* The real time clock should probably be the real linux clocksource. */
+/* In the meantime, this file should agree with core.c as to the */
+/* profiling timer. If the clocksource is moved to rtc later, then */
+/* we can init the profiling timer here instead. */
+
+/* Timer 1 provides 25MHz resolution syncrhonized to scheduling and APM timing */
+/* Timer 3 provides bus freqeuncy sychronized to ACLK, but spread spectrum will */
+/* affect synchronization with scheduling and APM timing. */
+
+#define PROF_TIMER 1
+
+timer_tick_rate_t timer_get_tick_rate(void)
+{
+       return tmrHw_getCountRate(PROF_TIMER);
+}
+
+timer_tick_count_t timer_get_tick_count(void)
+{
+       return tmrHw_GetCurrentCount(PROF_TIMER);       /* change downcounter to upcounter */
+}
+
+timer_msec_t timer_ticks_to_msec(timer_tick_count_t ticks)
+{
+       static int tickRateMsec;
+
+       if (tickRateMsec == 0) {
+               tickRateMsec = timer_get_tick_rate() / 1000;
+       }
+
+       return ticks / tickRateMsec;
+}
+
+timer_msec_t timer_get_msec(void)
+{
+       return timer_ticks_to_msec(timer_get_tick_count());
+}
+
+EXPORT_SYMBOL(timer_get_tick_count);
+EXPORT_SYMBOL(timer_ticks_to_msec);
+EXPORT_SYMBOL(timer_get_tick_rate);
+EXPORT_SYMBOL(timer_get_msec);
--
1.6.0.6



Leo Hao Chen
Software Engineer
Broadcom Canada Inc.


