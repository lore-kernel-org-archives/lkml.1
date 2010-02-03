Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab0BCFSx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 00:18:53 -0500
Received: from adelie.canonical.com ([91.189.90.139]:33939 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab0BCFQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 00:16:46 -0500
From: Amit Kucheria <amit.kucheria@canonical.com>
To: List Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
       linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
       valentin.longchamp@epfl.ch, daniel@caiaq.de, grant.likely@secretlab.ca,
       Dinh.Nguyen@freescale.com, r.herring@freescale.com,
       bryan.wu@canonical.com
Subject: [PATCHv2 02/11] mxc timer: refactor timer code to use timer versions
Date: Tue,  2 Feb 2010 21:16:24 -0800
Message-Id: <9fa7a3c70c46a1f776c6520051481cff6525ef02.1265173480.git.amit.kucheria@canonical.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <0511204199ab83aed2340e70a4639500c0528dab.1265173480.git.amit.kucheria@canonical.com>
References: <cover.1265173246.git.amit.kucheria@verdurent.com>
 <0511204199ab83aed2340e70a4639500c0528dab.1265173480.git.amit.kucheria@canonical.com>
In-Reply-To: <cover.1265173480.git.amit.kucheria@canonical.com>
References: <cover.1265173480.git.amit.kucheria@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sascha Hauer <s.hauer@pengutronix.de>

Refactor the timer code into version 1 and version 2.

Essentially there are 2 versions of the timer hardware. Version 1 is found on
MX1/MXL and MX21. Version 2 is found on MX25, MX27, MX31, MX35, MX37, MX51,
and future parts.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Acked-by: Amit Kucheria <amit.kucheria@canonical.com>
Signed-off-by: Amit Kucheria <amit.kucheria@canonical.com>
---
 arch/arm/plat-mxc/time.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/arm/plat-mxc/time.c b/arch/arm/plat-mxc/time.c
index 844567e..7d6499e 100644
--- a/arch/arm/plat-mxc/time.c
+++ b/arch/arm/plat-mxc/time.c
@@ -57,6 +57,9 @@
 #define MX3_TCN			0x24
 #define MX3_TCMP		0x10
 
+#define timer_is_v1()	(cpu_is_mx1() || cpu_is_mx27())
+#define timer_is_v2()	(cpu_is_mx3() || cpu_is_mx25())
+
 static struct clock_event_device clockevent_mxc;
 static enum clock_event_mode clockevent_mode = CLOCK_EVT_MODE_UNUSED;
 
@@ -66,7 +69,7 @@ static inline void gpt_irq_disable(void)
 {
 	unsigned int tmp;
 
-	if (cpu_is_mx3() || cpu_is_mx25())
+	if (timer_is_v2())
 		__raw_writel(0, timer_base + MX3_IR);
 	else {
 		tmp = __raw_readl(timer_base + MXC_TCTL);
@@ -76,7 +79,7 @@ static inline void gpt_irq_disable(void)
 
 static inline void gpt_irq_enable(void)
 {
-	if (cpu_is_mx3() || cpu_is_mx25())
+	if (timer_is_v2())
 		__raw_writel(1<<0, timer_base + MX3_IR);
 	else {
 		__raw_writel(__raw_readl(timer_base + MXC_TCTL) | MX1_2_TCTL_IRQEN,
@@ -90,7 +93,7 @@ static void gpt_irq_acknowledge(void)
 		__raw_writel(0, timer_base + MX1_2_TSTAT);
 	if (cpu_is_mx2())
 		__raw_writel(MX2_TSTAT_CAPT | MX2_TSTAT_COMP, timer_base + MX1_2_TSTAT);
-	if (cpu_is_mx3() || cpu_is_mx25())
+	if (timer_is_v2())
 		__raw_writel(MX3_TSTAT_OF1, timer_base + MX3_TSTAT);
 }
 
@@ -117,7 +120,7 @@ static int __init mxc_clocksource_init(struct clk *timer_clk)
 {
 	unsigned int c = clk_get_rate(timer_clk);
 
-	if (cpu_is_mx3() || cpu_is_mx25())
+	if (timer_is_v2())
 		clocksource_mxc.read = mx3_get_cycles;
 
 	clocksource_mxc.mult = clocksource_hz2mult(c,
@@ -180,7 +183,7 @@ static void mxc_set_mode(enum clock_event_mode mode,
 
 	if (mode != clockevent_mode) {
 		/* Set event time into far-far future */
-		if (cpu_is_mx3() || cpu_is_mx25())
+		if (timer_is_v2())
 			__raw_writel(__raw_readl(timer_base + MX3_TCN) - 3,
 					timer_base + MX3_TCMP);
 		else
@@ -233,7 +236,7 @@ static irqreturn_t mxc_timer_interrupt(int irq, void *dev_id)
 	struct clock_event_device *evt = &clockevent_mxc;
 	uint32_t tstat;
 
-	if (cpu_is_mx3() || cpu_is_mx25())
+	if (timer_is_v2())
 		tstat = __raw_readl(timer_base + MX3_TSTAT);
 	else
 		tstat = __raw_readl(timer_base + MX1_2_TSTAT);
@@ -264,7 +267,7 @@ static int __init mxc_clockevent_init(struct clk *timer_clk)
 {
 	unsigned int c = clk_get_rate(timer_clk);
 
-	if (cpu_is_mx3() || cpu_is_mx25())
+	if (timer_is_v2())
 		clockevent_mxc.set_next_event = mx3_set_next_event;
 
 	clockevent_mxc.mult = div_sc(c, NSEC_PER_SEC,
@@ -296,7 +299,7 @@ void __init mxc_timer_init(struct clk *timer_clk, void __iomem *base, int irq)
 	__raw_writel(0, timer_base + MXC_TCTL);
 	__raw_writel(0, timer_base + MXC_TPRER); /* see datasheet note */
 
-	if (cpu_is_mx3() || cpu_is_mx25())
+	if (timer_is_v2())
 		tctl_val = MX3_TCTL_CLK_IPG | MX3_TCTL_FRR | MX3_TCTL_WAITEN | MXC_TCTL_TEN;
 	else
 		tctl_val = MX1_2_TCTL_FRR | MX1_2_TCTL_CLK_PCLK1 | MXC_TCTL_TEN;
-- 
1.6.3.3

