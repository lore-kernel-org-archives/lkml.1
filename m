Return-Path: <linux-kernel-owner+w=401wt.eu-S1753342Ab0ALG72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342Ab0ALG72 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 01:59:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753165Ab0ALG6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 01:58:50 -0500
Received: from ozlabs.org ([203.10.76.45]:45460 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180Ab0ALG6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 01:58:47 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [RFC,PATCH 5/7 v2] arm/realview: use generic struct clk
Message-Id: <1263279511.161921.543439288257.5.gpush@pororo>
In-Reply-To: <1263279511.160127.576969496193.0.gpush@pororo>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       linuxppc-dev@lists.ozlabs.org
From: Jeremy Kerr <jeremy.kerr@canonical.com>
Date: Tue, 12 Jan 2010 17:58:31 +1100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the common struct clk interface for the realview clocks.

Compile tested only.

Signed-off-by: Jeremy Kerr <jeremy.kerr@canonical.com>

---
 arch/arm/Kconfig               |    1 
 arch/arm/mach-realview/clock.c |   48 +++++++++++++--------------------
 arch/arm/mach-realview/clock.h |   17 ++++++-----
 arch/arm/mach-realview/core.c  |   46 +++++++++++++++----------------
 4 files changed, 54 insertions(+), 58 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 34497ce..2ecef6b 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -232,6 +232,7 @@ config ARCH_REALVIEW
 	select ICST307
 	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
+	select USE_COMMON_STRUCT_CLK
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	help
 	  This enables support for ARM Ltd RealView boards.
diff --git a/arch/arm/mach-realview/clock.c b/arch/arm/mach-realview/clock.c
index a704311..472721c 100644
--- a/arch/arm/mach-realview/clock.c
+++ b/arch/arm/mach-realview/clock.c
@@ -22,43 +22,35 @@
 
 #include "clock.h"
 
-int clk_enable(struct clk *clk)
-{
-	return 0;
-}
-EXPORT_SYMBOL(clk_enable);
+#define to_clk_realview(clk) (container_of(clk, struct clk_realview, clk))
 
-void clk_disable(struct clk *clk)
+static unsigned long clk_realview_get_rate(struct clk *clk)
 {
+	return to_clk_realview(clk)->rate;
 }
-EXPORT_SYMBOL(clk_disable);
 
-unsigned long clk_get_rate(struct clk *clk)
-{
-	return clk->rate;
-}
-EXPORT_SYMBOL(clk_get_rate);
-
-long clk_round_rate(struct clk *clk, unsigned long rate)
+static long clk_realview_round_rate(struct clk *clk, unsigned long rate)
 {
+	const struct icst307_params *params = &to_clk_realview(clk)->params;
 	struct icst307_vco vco;
-	vco = icst307_khz_to_vco(clk->params, rate / 1000);
-	return icst307_khz(clk->params, vco) * 1000;
+	vco = icst307_khz_to_vco(params, rate / 1000);
+	return icst307_khz(params, vco) * 1000;
 }
-EXPORT_SYMBOL(clk_round_rate);
 
-int clk_set_rate(struct clk *clk, unsigned long rate)
+static int clk_realview_set_rate(struct clk *clk, unsigned long rate)
 {
-	int ret = -EIO;
+	struct clk_realview *r_clk = to_clk_realview(clk);
+	struct icst307_vco vco;
 
-	if (clk->setvco) {
-		struct icst307_vco vco;
+	vco = icst307_khz_to_vco(&r_clk->params, rate / 1000);
+	r_clk->rate = icst307_khz(&r_clk->params, vco) * 1000;
+	r_clk->setvco(r_clk, vco);
 
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
+struct clk_operations clk_realview_operations = {
+	.get_rate = clk_realview_get_rate,
+	.round_rate = clk_realview_round_rate,
+	.set_rate = clk_realview_set_rate,
+};
diff --git a/arch/arm/mach-realview/clock.h b/arch/arm/mach-realview/clock.h
index ebbb0f0..639a381 100644
--- a/arch/arm/mach-realview/clock.h
+++ b/arch/arm/mach-realview/clock.h
@@ -8,12 +8,15 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
-struct module;
-struct icst307_params;
 
-struct clk {
-	unsigned long		rate;
-	const struct icst307_params *params;
-	void			*data;
-	void			(*setvco)(struct clk *, struct icst307_vco vco);
+#include <linux/clk.h>
+
+struct clk_realview {
+	struct clk			clk;
+	unsigned long			rate;
+	const struct icst307_params	params;
+	void				(*setvco)(struct clk_realview *,
+						  struct icst307_vco);
 };
+
+extern struct clk_operations clk_realview_operations;
diff --git a/arch/arm/mach-realview/core.c b/arch/arm/mach-realview/core.c
index 9f29343..8102c75 100644
--- a/arch/arm/mach-realview/core.c
+++ b/arch/arm/mach-realview/core.c
@@ -273,16 +273,8 @@ struct mmci_platform_data realview_mmc1_plat_data = {
 /*
  * Clock handling
  */
-static const struct icst307_params realview_oscvco_params = {
-	.ref		= 24000,
-	.vco_max	= 200000,
-	.vd_min		= 4 + 8,
-	.vd_max		= 511 + 8,
-	.rd_min		= 1 + 2,
-	.rd_max		= 127 + 2,
-};
 
-static void realview_oscvco_set(struct clk *clk, struct icst307_vco vco)
+static void realview_oscvco_set(struct clk_realview *clk, struct icst307_vco vco)
 {
 	void __iomem *sys_lock = __io_address(REALVIEW_SYS_BASE) + REALVIEW_SYS_LOCK_OFFSET;
 	void __iomem *sys_osc;
@@ -301,46 +293,54 @@ static void realview_oscvco_set(struct clk *clk, struct icst307_vco vco)
 	writel(0, sys_lock);
 }
 
-static struct clk oscvco_clk = {
-	.params	= &realview_oscvco_params,
+static struct clk_realview oscvco_clk = {
+	.clk = {
+		.ops = &clk_realview_operations,
+	},
+	.params	= {
+		.ref		= 24000,
+		.vco_max	= 200000,
+		.vd_min		= 4 + 8,
+		.vd_max		= 511 + 8,
+		.rd_min		= 1 + 2,
+		.rd_max		= 127 + 2,
+	},
 	.setvco = realview_oscvco_set,
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
 		.dev_id		= "dev:uart0",
-		.clk		= &ref24_clk,
+		.clk		= &ref24_clk.clk,
 	}, {	/* UART1 */
 		.dev_id		= "dev:uart1",
-		.clk		= &ref24_clk,
+		.clk		= &ref24_clk.clk,
 	}, {	/* UART2 */
 		.dev_id		= "dev:uart2",
-		.clk		= &ref24_clk,
+		.clk		= &ref24_clk.clk,
 	}, {	/* UART3 */
 		.dev_id		= "fpga:uart3",
-		.clk		= &ref24_clk,
+		.clk		= &ref24_clk.clk,
 	}, {	/* KMI0 */
 		.dev_id		= "fpga:kmi0",
-		.clk		= &ref24_clk,
+		.clk		= &ref24_clk.clk,
 	}, {	/* KMI1 */
 		.dev_id		= "fpga:kmi1",
-		.clk		= &ref24_clk,
+		.clk		= &ref24_clk.clk,
 	}, {	/* MMC0 */
 		.dev_id		= "fpga:mmc0",
-		.clk		= &ref24_clk,
+		.clk		= &ref24_clk.clk,
 	}, {	/* EB:CLCD */
 		.dev_id		= "dev:clcd",
-		.clk		= &oscvco_clk,
+		.clk		= &oscvco_clk.clk,
 	}, {	/* PB:CLCD */
 		.dev_id		= "issp:clcd",
-		.clk		= &oscvco_clk,
+		.clk		= &oscvco_clk.clk,
 	}
 };
 
