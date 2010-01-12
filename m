Return-Path: <linux-kernel-owner+w=401wt.eu-S1753333Ab0ALG7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333Ab0ALG7m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 01:59:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751301Ab0ALG6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 01:58:49 -0500
Received: from ozlabs.org ([203.10.76.45]:45455 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752950Ab0ALG6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 01:58:46 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [RFC,PATCH 3/7 v2] arm/versatile: use generic struct clk
Message-Id: <1263279511.161193.484965724912.3.gpush@pororo>
In-Reply-To: <1263279511.160127.576969496193.0.gpush@pororo>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       linuxppc-dev@lists.ozlabs.org
From: Jeremy Kerr <jeremy.kerr@canonical.com>
Date: Tue, 12 Jan 2010 17:58:31 +1100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the common struct clk interface for the versatile clocks.

Signed-off-by: Jeremy Kerr <jeremy.kerr@canonical.com>

---
 arch/arm/Kconfig                |    1 
 arch/arm/common/clkdev.c        |    2 +
 arch/arm/mach-versatile/clock.c |   51 +++++++++++++-------------------
 arch/arm/mach-versatile/clock.h |   20 +++++++-----
 arch/arm/mach-versatile/core.c  |   50 +++++++++++++++----------------
 5 files changed, 62 insertions(+), 62 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 233a222..34497ce 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -245,6 +245,7 @@ config ARCH_VERSATILE
 	select ICST307
 	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
+	select USE_COMMON_STRUCT_CLK
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	help
 	  This enables support for ARM Ltd Versatile board.
diff --git a/arch/arm/common/clkdev.c b/arch/arm/common/clkdev.c
index aae5bc0..71e7596 100644
--- a/arch/arm/common/clkdev.c
+++ b/arch/arm/common/clkdev.c
@@ -85,11 +85,13 @@ struct clk *clk_get(struct device *dev, const char *con_id)
 }
 EXPORT_SYMBOL(clk_get);
 
+#ifndef CONFIG_USE_COMMON_STRUCT_CLK
 void clk_put(struct clk *clk)
 {
 	__clk_put(clk);
 }
 EXPORT_SYMBOL(clk_put);
+#endif /* CONFIG_USE_COMMON_STRUCT_CLK */
 
 void clkdev_add(struct clk_lookup *cl)
 {
diff --git a/arch/arm/mach-versatile/clock.c b/arch/arm/mach-versatile/clock.c
index c50a44e..16ab90b 100644
--- a/arch/arm/mach-versatile/clock.c
+++ b/arch/arm/mach-versatile/clock.c
@@ -17,49 +17,42 @@
 #include <linux/string.h>
 #include <linux/clk.h>
 #include <linux/mutex.h>
+#include <linux/clk.h>
 
-#include <asm/clkdev.h>
 #include <asm/hardware/icst307.h>
 
 #include "clock.h"
 
-int clk_enable(struct clk *clk)
-{
-	return 0;
-}
-EXPORT_SYMBOL(clk_enable);
+#define to_clk_versatile(clk) (container_of(clk, struct clk_versatile, clk))
 
-void clk_disable(struct clk *clk)
+static unsigned long clk_versatile_get_rate(struct clk *clk)
 {
+	return to_clk_versatile(clk)->rate;
 }
-EXPORT_SYMBOL(clk_disable);
 
-unsigned long clk_get_rate(struct clk *clk)
-{
-	return clk->rate;
-}
-EXPORT_SYMBOL(clk_get_rate);
-
-long clk_round_rate(struct clk *clk, unsigned long rate)
+static long clk_versatile_round_rate(struct clk *clk, unsigned long rate)
 {
+	const struct icst307_params *params = &to_clk_versatile(clk)->params;
 	struct icst307_vco vco;
-	vco = icst307_khz_to_vco(clk->params, rate / 1000);
-	return icst307_khz(clk->params, vco) * 1000;
+
+	vco = icst307_khz_to_vco(params, rate / 1000);
+	return icst307_khz(params, vco) * 1000;
 }
-EXPORT_SYMBOL(clk_round_rate);
 
-int clk_set_rate(struct clk *clk, unsigned long rate)
+static int clk_versatile_set_rate(struct clk *clk, unsigned long rate)
 {
-	int ret = -EIO;
+	struct clk_versatile *v_clk = to_clk_versatile(clk);
+	struct icst307_vco vco;
 
-	if (clk->setvco) {
-		struct icst307_vco vco;
+	vco = icst307_khz_to_vco(&v_clk->params, rate / 1000);
+	v_clk->rate = icst307_khz(&v_clk->params, vco) * 1000;
+	v_clk->setvco(v_clk, vco);
 
-		vco = icst307_khz_to_vco(clk->params, rate / 1000);
-		clk->rate = icst307_khz(clk->params, vco) * 1000;
-		clk->setvco(clk, vco);
-		ret = 0;
-	}
-	return ret;
+	return 0;
 }
-EXPORT_SYMBOL(clk_set_rate);
+
+struct clk_operations clk_versatile_operations = {
+	.get_rate = clk_versatile_get_rate,
+	.round_rate = clk_versatile_round_rate,
+	.set_rate = clk_versatile_set_rate,
+};
diff --git a/arch/arm/mach-versatile/clock.h b/arch/arm/mach-versatile/clock.h
index 03468fd..d1c8791 100644
--- a/arch/arm/mach-versatile/clock.h
+++ b/arch/arm/mach-versatile/clock.h
@@ -8,13 +8,17 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
-struct module;
-struct icst307_params;
 
-struct clk {
-	unsigned long		rate;
-	const struct icst307_params *params;
-	u32			oscoff;
-	void			*data;
-	void			(*setvco)(struct clk *, struct icst307_vco vco);
+#include <linux/clk.h>
+
+struct clk_versatile {
+	struct clk			clk;
+	unsigned long			rate;
+	const struct icst307_params	params;
+	u32				oscoff;
+	void				(*setvco)(struct clk_versatile *,
+						  struct icst307_vco);
 };
+
+extern struct clk_operations clk_versatile_operations;
+
diff --git a/arch/arm/mach-versatile/core.c b/arch/arm/mach-versatile/core.c
index e13be7c..b6964bc 100644
--- a/arch/arm/mach-versatile/core.c
+++ b/arch/arm/mach-versatile/core.c
@@ -379,16 +379,8 @@ static struct mmci_platform_data mmc0_plat_data = {
 /*
  * Clock handling
  */
-static const struct icst307_params versatile_oscvco_params = {
-	.ref		= 24000,
-	.vco_max	= 200000,
-	.vd_min		= 4 + 8,
-	.vd_max		= 511 + 8,
-	.rd_min		= 1 + 2,
-	.rd_max		= 127 + 2,
-};
 
-static void versatile_oscvco_set(struct clk *clk, struct icst307_vco vco)
+static void versatile_oscvco_set(struct clk_versatile *clk, struct icst307_vco vco)
 {
 	void __iomem *sys = __io_address(VERSATILE_SYS_BASE);
 	void __iomem *sys_lock = sys + VERSATILE_SYS_LOCK_OFFSET;
@@ -402,47 +394,55 @@ static void versatile_oscvco_set(struct clk *clk, struct icst307_vco vco)
 	writel(0, sys_lock);
 }
 
-static struct clk osc4_clk = {
-	.params	= &versatile_oscvco_params,
-	.oscoff	= VERSATILE_SYS_OSCCLCD_OFFSET,
-	.setvco	= versatile_oscvco_set,
+static struct clk_versatile osc4_clk = {
+	.clk = {
+		.ops = &clk_versatile_operations,
+	},
+	.params = {
+		.ref		= 24000,
+		.vco_max	= 200000,
+		.vd_min		= 4 + 8,
+		.vd_max		= 511 + 8,
+		.rd_min		= 1 + 2,
+		.rd_max		= 127 + 2,
+	},
+	.oscoff = VERSATILE_SYS_OSCCLCD_OFFSET,
+	.setvco = versatile_oscvco_set,
 };
 
 /*
  * These are fixed clocks.
  */
-static struct clk ref24_clk = {
-	.rate	= 24000000,
-};
+static struct clk_fixed ref24_clk = DEFINE_CLK_FIXED(24000000);
 
 static struct clk_lookup lookups[] = {
 	{	/* UART0 */
 		.dev_id		= "dev:f1",
-		.clk		= &ref24_clk,
+		.clk		= &ref24_clk.clk,
 	}, {	/* UART1 */
 		.dev_id		= "dev:f2",
-		.clk		= &ref24_clk,
+		.clk		= &ref24_clk.clk,
 	}, {	/* UART2 */
 		.dev_id		= "dev:f3",
-		.clk		= &ref24_clk,
+		.clk		= &ref24_clk.clk,
 	}, {	/* UART3 */
 		.dev_id		= "fpga:09",
-		.clk		= &ref24_clk,
+		.clk		= &ref24_clk.clk,
 	}, {	/* KMI0 */
 		.dev_id		= "fpga:06",
-		.clk		= &ref24_clk,
+		.clk		= &ref24_clk.clk,
 	}, {	/* KMI1 */
 		.dev_id		= "fpga:07",
-		.clk		= &ref24_clk,
+		.clk		= &ref24_clk.clk,
 	}, {	/* MMC0 */
 		.dev_id		= "fpga:05",
-		.clk		= &ref24_clk,
+		.clk		= &ref24_clk.clk,
 	}, {	/* MMC1 */
 		.dev_id		= "fpga:0b",
-		.clk		= &ref24_clk,
+		.clk		= &ref24_clk.clk,
 	}, {	/* CLCD */
 		.dev_id		= "dev:20",
-		.clk		= &osc4_clk,
+		.clk		= &osc4_clk.clk,
 	}
 };
 
