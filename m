Return-Path: <linux-kernel-owner+w=401wt.eu-S1758446AbZGDBny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758446AbZGDBny (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 21:43:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757792AbZGDBna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 21:43:30 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:1777 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757997AbZGDBn2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 21:43:28 -0400
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
Date: Fri, 3 Jul 2009 18:43:26 -0700
Subject: [PATCH v2 5/18] new ARM SoC support: BCMRing
Thread-Topic: [PATCH v2 5/18] new ARM SoC support: BCMRing
Thread-Index: Acn8SNL53NBJHvtvTBOqqNyBzy8WhA==
Message-ID: <8628FE4E7912BF47A96AE7DD7BAC0AADCB25BA6C12@SJEXCHCCR02.corp.ad.broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
X-WSS-ID: 66506C354CG20367118-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 2ad360b903637f0ddb87bc7f75d2cf8a47b0ef55 Mon Sep 17 00:00:00 2001
From: Leo Chen <leochen@broadcom.com>
Date: Fri, 3 Jul 2009 16:21:55 -0700
Subject: [PATCH 05/18] add mach-bcmring/clock.c clock.h

implement clock set/get disable/enable API for bcmring

Signed-off-by: Leo Chen <leochen@broadcom.com>
---
 arch/arm/mach-bcmring/clock.c |  235 +++++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-bcmring/clock.h |   33 ++++++
 2 files changed, 268 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-bcmring/clock.c
 create mode 100644 arch/arm/mach-bcmring/clock.h

diff --git a/arch/arm/mach-bcmring/clock.c b/arch/arm/mach-bcmring/clock.c
new file mode 100644
index 0000000..d437de4
--- /dev/null
+++ b/arch/arm/mach-bcmring/clock.c
@@ -0,0 +1,235 @@
+/*****************************************************************************
+* Copyright 2001 - 2009 Broadcom Corporation.  All rights reserved.
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
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/list.h>
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/string.h>
+#include <linux/clk.h>
+#include <linux/spinlock.h>
+#include <mach/csp/hw_cfg.h>
+#include <mach/csp/chipcHw_def.h>
+#include <mach/csp/chipcHw_reg.h>
+#include <mach/csp/chipcHw_inline.h>
+
+#include <asm/clkdev.h>
+
+#include "clock.h"
+
+#define clk_is_primary(x)       ((x)->type & CLK_TYPE_PRIMARY)
+#define clk_is_pll1(x)          ((x)->type & CLK_TYPE_PLL1)
+#define clk_is_pll2(x)          ((x)->type & CLK_TYPE_PLL2)
+#define clk_is_programmable(x)  ((x)->type & CLK_TYPE_PROGRAMMABLE)
+#define clk_is_bypassable(x)    ((x)->type & CLK_TYPE_BYPASSABLE)
+
+#define clk_is_using_xtal(x)    ((x)->mode & CLK_MODE_XTAL)
+
+static DEFINE_SPINLOCK(clk_lock);
+
+static void __clk_enable(struct clk *clk)
+{
+       if (!clk)
+               return;
+
+       /* enable parent clock first */
+       if (clk->parent)
+               __clk_enable(clk->parent);
+
+       if (clk->use_cnt++ == 0) {
+               if (clk_is_pll1(clk)) { /* PLL1 */
+                       chipcHw_pll1Enable(clk->rate_hz, 0);
+               } else if (clk_is_pll2(clk)) {  /* PLL2 */
+                       chipcHw_pll2Enable(clk->rate_hz);
+               } else if (clk_is_using_xtal(clk)) {    /* source is crystal */
+                       if (!clk_is_primary(clk)) {
+                               chipcHw_bypassClockEnable(clk->csp_id);
+                       }
+               } else {        /* source is PLL */
+                       chipcHw_setClockEnable(clk->csp_id);
+               }
+       }
+}
+
+int clk_enable(struct clk *clk)
+{
+       unsigned long flags;
+
+       if (!clk)
+               return -EINVAL;
+
+       spin_lock_irqsave(&clk_lock, flags);
+       __clk_enable(clk);
+       spin_unlock_irqrestore(&clk_lock, flags);
+
+       return 0;
+}
+
+EXPORT_SYMBOL(clk_enable);
+
+static void __clk_disable(struct clk *clk)
+{
+       if (!clk)
+               return;
+
+       BUG_ON(clk->use_cnt == 0);
+
+       if (--clk->use_cnt == 0) {
+               if (clk_is_pll1(clk)) { /* PLL1 */
+                       chipcHw_pll1Disable();
+               } else if (clk_is_pll2(clk)) {  /* PLL2 */
+                       chipcHw_pll2Disable();
+               } else if (clk_is_using_xtal(clk)) {    /* source is crystal */
+                       if (!clk_is_primary(clk)) {
+                               chipcHw_bypassClockDisable(clk->csp_id);
+                       }
+               } else {        /* source is PLL */
+                       chipcHw_setClockDisable(clk->csp_id);
+               }
+       }
+
+       if (clk->parent)
+               __clk_disable(clk->parent);
+}
+
+void clk_disable(struct clk *clk)
+{
+       unsigned long flags;
+
+       if (!clk)
+               return;
+
+       spin_lock_irqsave(&clk_lock, flags);
+       __clk_disable(clk);
+       spin_unlock_irqrestore(&clk_lock, flags);
+}
+
+EXPORT_SYMBOL(clk_disable);
+
+unsigned long clk_get_rate(struct clk *clk)
+{
+       if (!clk)
+               return 0;
+
+       return clk->rate_hz;
+}
+
+EXPORT_SYMBOL(clk_get_rate);
+
+long clk_round_rate(struct clk *clk, unsigned long rate)
+{
+       unsigned long flags;
+       unsigned long actual;
+       unsigned long rate_hz;
+
+       if (!clk)
+               return -EINVAL;
+
+       if (!clk_is_programmable(clk))
+               return -EINVAL;
+
+       if (clk->use_cnt)
+               return -EBUSY;
+
+       spin_lock_irqsave(&clk_lock, flags);
+       actual = clk->parent->rate_hz;
+       rate_hz = min(actual, rate);
+       rate_hz = chipcHw_setClockFrequency(clk->csp_id, rate_hz);
+       clk->rate_hz = rate_hz;
+       spin_unlock_irqrestore(&clk_lock, flags);
+
+       return rate_hz;
+}
+
+EXPORT_SYMBOL(clk_round_rate);
+
+int clk_set_rate(struct clk *clk, unsigned long rate)
+{
+       unsigned long flags;
+       unsigned long actual;
+       unsigned long rate_hz;
+
+       if (!clk)
+               return -EINVAL;
+
+       if (!clk_is_programmable(clk))
+               return -EINVAL;
+
+       if (clk->use_cnt)
+               return -EBUSY;
+
+       spin_lock_irqsave(&clk_lock, flags);
+       actual = clk->parent->rate_hz;
+       rate_hz = min(actual, rate);
+       rate_hz = chipcHw_setClockFrequency(clk->csp_id, rate_hz);
+       clk->rate_hz = rate_hz;
+       spin_unlock_irqrestore(&clk_lock, flags);
+
+       return 0;
+}
+
+EXPORT_SYMBOL(clk_set_rate);
+
+struct clk *clk_get_parent(struct clk *clk)
+{
+       if (!clk)
+               return NULL;
+
+       return clk->parent;
+}
+
+EXPORT_SYMBOL(clk_get_parent);
+
+int clk_set_parent(struct clk *clk, struct clk *parent)
+{
+       unsigned long flags;
+       struct clk *old_parent;
+
+       if (!clk || !parent)
+               return -EINVAL;
+
+       if (!clk_is_primary(parent) || !clk_is_bypassable(clk))
+               return -EINVAL;
+
+       /* if more than one user, parent is not allowed */
+       if (clk->use_cnt > 1)
+               return -EBUSY;
+
+       if (clk->parent == parent)
+               return 0;
+
+       spin_lock_irqsave(&clk_lock, flags);
+       old_parent = clk->parent;
+       clk->parent = parent;
+       if (clk_is_using_xtal(parent))
+               clk->mode |= CLK_MODE_XTAL;
+       else
+               clk->mode &= (~CLK_MODE_XTAL);
+
+       /* if clock is active */
+       if (clk->use_cnt != 0) {
+               clk->use_cnt--;
+               /* enable clock with the new parent */
+               __clk_enable(clk);
+               /* disable the old parent */
+               __clk_disable(old_parent);
+       }
+       spin_unlock_irqrestore(&clk_lock, flags);
+
+       return 0;
+}
+
+EXPORT_SYMBOL(clk_set_parent);
diff --git a/arch/arm/mach-bcmring/clock.h b/arch/arm/mach-bcmring/clock.h
new file mode 100644
index 0000000..5e0b981
--- /dev/null
+++ b/arch/arm/mach-bcmring/clock.h
@@ -0,0 +1,33 @@
+/*****************************************************************************
+* Copyright 2001 - 2009 Broadcom Corporation.  All rights reserved.
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
+#include <mach/csp/chipcHw_def.h>
+
+#define CLK_TYPE_PRIMARY         1     /* primary clock must NOT have a parent */
+#define CLK_TYPE_PLL1            2     /* PPL1 */
+#define CLK_TYPE_PLL2            4     /* PPL2 */
+#define CLK_TYPE_PROGRAMMABLE    8     /* programmable clock rate */
+#define CLK_TYPE_BYPASSABLE      16    /* parent can be changed */
+
+#define CLK_MODE_XTAL            1     /* clock source is from crystal */
+
+struct clk {
+       const char *name;       /* clock name */
+       unsigned int type;      /* clock type */
+       unsigned int mode;      /* current mode */
+       volatile int use_bypass;        /* indicate if it's in bypass mode */
+       chipcHw_CLOCK_e csp_id; /* clock ID for CSP CHIPC */
+       unsigned long rate_hz;  /* clock rate in Hz */
+       unsigned int use_cnt;   /* usage count */
+       struct clk *parent;     /* parent clock */
+};
--
1.6.0.6


Leo Hao Chen
Software Engineer
Broadcom Canada Inc.


