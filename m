Return-Path: <linux-kernel-owner+w=401wt.eu-S1756946AbZFDH64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946AbZFDH64 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 03:58:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755348AbZFDH6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 03:58:46 -0400
Received: from mail.atmel.fr ([81.80.104.162]:63251 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754420AbZFDH6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 03:58:45 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: avictor.za@gmail.com, linux-arm-kernel@lists.arm.linux.org.uk
Cc: patrice.vilchez@atmel.com, linux-kernel@vger.kernel.org,
       Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 2/3] at91: Support for at91sam9g45: clocks management
Date: Thu,  4 Jun 2009 10:48:01 +0200
Message-Id: <1244105282-31456-2-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1244105282-31456-1-git-send-email-nicolas.ferre@atmel.com>
References: <1244105282-31456-1-git-send-email-nicolas.ferre@atmel.com>
Message-Id: <4a78a0b84331f1fb5ea111657992b3557f70a1b3.1244104625.git.nicolas.ferre@atmel.com>
In-Reply-To: <0c80319114935c723d3bac8992e6b4d8fc464b0b.1244104624.git.nicolas.ferre@atmel.com>
References: <0c80319114935c723d3bac8992e6b4d8fc464b0b.1244104624.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the at91sam9g45 series support to the AT91 generic clock file.
This takes care of the particularities of the PMC for this series.
It also takes advantage of the management by functionalities of
those PLLs and clocks.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/clock.c |   62 ++++++++++++++++++++++++++++++++++++-------
 1 files changed, 52 insertions(+), 10 deletions(-)

diff --git a/arch/arm/mach-at91/clock.c b/arch/arm/mach-at91/clock.c
index bac578f..6396680 100644
--- a/arch/arm/mach-at91/clock.c
+++ b/arch/arm/mach-at91/clock.c
@@ -47,20 +47,25 @@
  * Chips have some kind of clocks : group them by functionality
  */
 #define cpu_has_utmi()		(  cpu_is_at91cap9() \
-				|| cpu_is_at91sam9rl())
+				|| cpu_is_at91sam9rl() \
+				|| cpu_is_at91sam9g45())
 
-#define cpu_has_800M_plla()	(cpu_is_at91sam9g20())
+#define cpu_has_800M_plla()	(  cpu_is_at91sam9g20() \
+				|| cpu_is_at91sam9g45())
 
-#define cpu_has_pllb()		(!cpu_is_at91sam9rl())
+#define cpu_has_300M_plla()	(0)
 
-#define cpu_has_upll()		(0)
+#define cpu_has_pllb()		(!(cpu_is_at91sam9rl() \
+				|| cpu_is_at91sam9g45()))
+
+#define cpu_has_upll()		(cpu_is_at91sam9g45())
 
 /* USB host HS & FS */
 #define cpu_has_uhp()		(!cpu_is_at91sam9rl())
 
 /* USB device FS only */
-#define cpu_has_udpfs()		(!cpu_is_at91sam9rl())
-
+#define cpu_has_udpfs()		(!(cpu_is_at91sam9rl() \
+				|| cpu_is_at91sam9g45()))
 
 static LIST_HEAD(clocks);
 static DEFINE_SPINLOCK(clk_lock);
@@ -133,6 +138,13 @@ static void pmc_uckr_mode(struct clk *clk, int is_on)
 {
 	unsigned int uckr = at91_sys_read(AT91_CKGR_UCKR);
 
+	if (cpu_is_at91sam9g45()) {
+		if (is_on)
+			uckr |= AT91_PMC_BIASEN;
+		else
+			uckr &= ~AT91_PMC_BIASEN;
+	}
+
 	if (is_on) {
 		is_on = AT91_PMC_LOCKU;
 		at91_sys_write(AT91_CKGR_UCKR, uckr | clk->pmc_mask);
@@ -310,6 +322,7 @@ long clk_round_rate(struct clk *clk, unsigned long rate)
 	unsigned long	flags;
 	unsigned	prescale;
 	unsigned long	actual;
+	unsigned long	prev = ULONG_MAX;
 
 	if (!clk_is_programmable(clk))
 		return -EINVAL;
@@ -317,8 +330,16 @@ long clk_round_rate(struct clk *clk, unsigned long rate)
 
 	actual = clk->parent->rate_hz;
 	for (prescale = 0; prescale < 7; prescale++) {
-		if (actual && actual <= rate)
+		if (actual > rate)
+			prev = actual;
+
+		if (actual && actual <= rate) {
+			if ((prev - rate) < (rate - actual)) {
+				actual = prev;
+				prescale--;
+			}
 			break;
+		}
 		actual >>= 1;
 	}
 
@@ -373,6 +394,10 @@ int clk_set_parent(struct clk *clk, struct clk *parent)
 		return -EBUSY;
 	if (!clk_is_primary(parent) || !clk_is_programmable(clk))
 		return -EINVAL;
+
+	if (cpu_is_at91sam9rl() && parent->id == AT91_PMC_CSS_PLLB)
+		return -EINVAL;
+
 	spin_lock_irqsave(&clk_lock, flags);
 
 	clk->rate_hz = parent->rate_hz;
@@ -637,6 +662,7 @@ int __init at91_clock_init(unsigned long main_clock)
 {
 	unsigned tmp, freq, mckr;
 	int i;
+	int pll_overclock = false;
 
 	/*
 	 * When the bootloader initialized the main oscillator correctly,
@@ -654,12 +680,25 @@ int __init at91_clock_init(unsigned long main_clock)
 
 	/* report if PLLA is more than mildly overclocked */
 	plla.rate_hz = at91_pll_rate(&plla, main_clock, at91_sys_read(AT91_CKGR_PLLAR));
-	if ((!cpu_has_800M_plla() && plla.rate_hz > 209000000)
-	   || (cpu_has_800M_plla() && plla.rate_hz > 800000000))
+	if (cpu_has_300M_plla()) {
+		if (plla.rate_hz > 300000000)
+			pll_overclock = true;
+	} else if (cpu_has_800M_plla()) {
+		if (plla.rate_hz > 800000000)
+			pll_overclock = true;
+	} else {
+		if (plla.rate_hz > 209000000)
+			pll_overclock = true;
+	}
+	if (pll_overclock)
 		pr_info("Clocks: PLLA overclocked, %ld MHz\n", plla.rate_hz / 1000000);
 
+	if (cpu_is_at91sam9g45()) {
+		mckr = at91_sys_read(AT91_PMC_MCKR);
+		plla.rate_hz /= (1 << ((mckr & AT91_PMC_PLLADIV2) >> 12));	/* plla divisor by 2 */
+	}
 
-	if (cpu_has_upll() && !cpu_has_pllb()) {
+	if (!cpu_has_pllb() && cpu_has_upll()) {
 		/* setup UTMI clock as the fourth primary clock
 		 * (instead of pllb) */
 		utmi_clk.type |= CLK_TYPE_PRIMARY;
@@ -701,6 +740,9 @@ int __init at91_clock_init(unsigned long main_clock)
 			freq / ((mckr & AT91_PMC_MDIV) >> 7) : freq;	/* mdiv ; (x >> 7) = ((x >> 8) * 2) */
 		if (mckr & AT91_PMC_PDIV)
 			freq /= 2;		/* processor clock division */
+	} else if (cpu_is_at91sam9g45()) {
+		mck.rate_hz = (mckr & AT91_PMC_MDIV) == AT91SAM9_PMC_MDIV_3 ?
+			freq / 3 : freq / (1 << ((mckr & AT91_PMC_MDIV) >> 8));	/* mdiv */
 	} else {
 		mck.rate_hz = freq / (1 << ((mckr & AT91_PMC_MDIV) >> 8));      /* mdiv */
 	}
-- 
1.5.3.7

