Return-Path: <linux-kernel-owner+w=401wt.eu-S1754974AbYLGVue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974AbYLGVue (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 16:50:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751823AbYLGVuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 16:50:25 -0500
Received: from mho-01-bos.mailhop.org ([63.208.196.178]:60616 "EHLO
	mho-01-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbYLGVuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 16:50:24 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 69.181.40.92
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19+zIv/xjt5GXuRf3Y8fnd9
Subject: [PATCH 4/5] omap mmc: force MMC module reset on boot
To: drzeus-mmc@drzeus.cx, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
From: Tony Lindgren <tony@atomide.com>
Cc: Kevin Hilman <khilman@deeprootsystems.com>, linux-omap@vger.kernel.org
Date: Sun, 07 Dec 2008 13:50:22 -0800
Message-ID: <20081207215022.10456.9800.stgit@localhost>
In-Reply-To: <20081207213617.10456.43951.stgit@localhost>
References: <20081207213617.10456.43951.stgit@localhost>
User-Agent: Whatever/0.14.3.285.g62874
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kevin Hilman <khilman@deeprootsystems.com>

The bootloader may leave the MMC in a state which prevents hitting
retention.  Even when MMC is not compiled in, each MMC module needs to
be forced into reset.

Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
---
 arch/arm/mach-omap2/devices.c |   85 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 85 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
index 6e03272..9d7216f 100644
--- a/arch/arm/mach-omap2/devices.c
+++ b/arch/arm/mach-omap2/devices.c
@@ -14,6 +14,7 @@
 #include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
+#include <linux/clk.h>
 
 #include <mach/hardware.h>
 #include <asm/mach-types.h>
@@ -299,6 +300,89 @@ static inline void omap_init_sha1_md5(void) { }
 
 /*-------------------------------------------------------------------------*/
 
+#ifdef CONFIG_ARCH_OMAP3
+
+#define MMCHS_SYSCONFIG			0x0010
+#define MMCHS_SYSCONFIG_SWRESET		(1 << 1)
+#define MMCHS_SYSSTATUS			0x0014
+#define MMCHS_SYSSTATUS_RESETDONE	(1 << 0)
+
+static struct platform_device dummy_pdev = {
+	.dev = {
+		.bus = &platform_bus_type,
+	},
+};
+
+/**
+ * omap_hsmmc_reset() - Full reset of each HS-MMC controller
+ *
+ * Ensure that each MMC controller is fully reset.  Controllers
+ * left in an unknown state (by bootloader) may prevent retention
+ * or OFF-mode.  This is especially important in cases where the
+ * MMC driver is not enabled, _or_ built as a module.
+ *
+ * In order for reset to work, interface, functional and debounce
+ * clocks must be enabled.  The debounce clock comes from func_32k_clk
+ * and is not under SW control, so we only enable i- and f-clocks.
+ **/
+static void __init omap_hsmmc_reset(void)
+{
+	u32 i, nr_controllers = cpu_is_omap34xx() ? OMAP34XX_NR_MMC :
+		OMAP24XX_NR_MMC;
+
+	for (i = 0; i < nr_controllers; i++) {
+		u32 v, base = 0;
+		struct clk *iclk, *fclk;
+		struct device *dev = &dummy_pdev.dev;
+
+		switch (i) {
+		case 0:
+			base = OMAP2_MMC1_BASE;
+			break;
+		case 1:
+			base = OMAP2_MMC2_BASE;
+			break;
+		case 2:
+			base = OMAP3_MMC3_BASE;
+			break;
+		}
+
+		dummy_pdev.id = i;
+		iclk = clk_get(dev, "mmchs_ick");
+		if (iclk && clk_enable(iclk))
+			iclk = NULL;
+
+		fclk = clk_get(dev, "mmchs_fck");
+		if (fclk && clk_enable(fclk))
+			fclk = NULL;
+
+		if (!iclk || !fclk) {
+			printk(KERN_WARNING
+			       "%s: Unable to enable clocks for MMC%d, "
+			       "cannot reset.\n",  __func__, i);
+			break;
+		}
+
+		omap_writel(MMCHS_SYSCONFIG_SWRESET, base + MMCHS_SYSCONFIG);
+		v = omap_readl(base + MMCHS_SYSSTATUS);
+		while (!(omap_readl(base + MMCHS_SYSSTATUS) &
+			 MMCHS_SYSSTATUS_RESETDONE))
+			cpu_relax();
+
+		if (fclk) {
+			clk_disable(fclk);
+			clk_put(fclk);
+		}
+		if (iclk) {
+			clk_disable(iclk);
+			clk_put(iclk);
+		}
+	}
+}
+#else
+static inline void omap_hsmmc_reset(void) {}
+#endif
+
 #if defined(CONFIG_MMC_OMAP) || defined(CONFIG_MMC_OMAP_MODULE) || \
 	defined(CONFIG_MMC_OMAP_HS) || defined(CONFIG_MMC_OMAP_HS_MODULE)
 
@@ -418,6 +502,7 @@ static int __init omap2_init_devices(void)
 	/* please keep these calls, and their implementations above,
 	 * in alphabetical order so they're easier to sort through.
 	 */
+	omap_hsmmc_reset();
 	omap_init_mbox();
 	omap_init_mcspi();
 	omap_hdq_init();

