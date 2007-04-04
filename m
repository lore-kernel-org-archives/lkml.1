Return-Path: <linux-kernel-owner+w=401wt.eu-S934098AbXDDSNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934098AbXDDSNk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 14:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934100AbXDDSNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 14:13:39 -0400
Received: from nlpi001.sbcis.sbc.com ([207.115.36.30]:39683 "EHLO
	nlpi001.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934098AbXDDSNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 14:13:34 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>,
       Tony Lindgren <tony@atomide.com>
Subject: [PATCH 73/90] ARM: OMAP: Add onennand board specific support for N800
Date: Wed,  4 Apr 2007 14:05:52 -0400
Message-Id: <11757101683521-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11757101661984-git-send-email-tony@atomide.com>
References: 11757088953851-git-send-email-tony@atomide.com <11757099691323-git-send-email-tony@atomide.com> <11757099743984-git-send-email-tony@atomide.com> <1175709977545-git-send-email-tony@atomide.com> <1175709988265-git-send-email-tony@atomide.com> <11757099942493-git-send-email-tony@atomide.com> <11757100011056-git-send-email-tony@atomide.com> <1175710003925-git-send-email-tony@atomide.com> <11757100063945-git-send-email-tony@atomide.com> <11757100092910-git-send-email-tony@atomide.com> <11757100112473-git-send-email-tony@atomide.com> <11757100143517-git-send-email-tony@atomide.com> <11757100163760-git-send-email-tony@atomide.com> <11757100181189-git-send-email-tony@atomide.com> <11757100214151-git-send-email-tony@atomide.com> <11757100242980-git-send-email-tony@atomide.com> <1175710026446-git-send-email-tony@atomide.com> <11757100281957-git-send-email-tony@atomide.com> <11757100302964-git-send-email-tony@atomide.com> <1175710033286-git-send-email-tony@atomide.com> <117!
 57100403021-git-send-email-tony@atomide.com> <11757100423982-git-send-email-tony@atomide.com> <117571004562-git-send-email-tony@atomide.com> <11757100491583-git-send-email-tony@atomide.com> <11757100511172-git-send-email-tony@atomide.com> <1175710059333-git-send-email-tony@atomide.com> <11757100623383-git-send-email-tony@atomide.com> <11757100641006-git-send-email-tony@atomide.com> <11757100661228-git-send-email-tony@atomide.com> <11757100691131-git-send-email-tony@atomide.com> <11757100713004-git-send-email-tony@atomide.com> <11757100752021-git-send-email-tony@atomide.com> <11757100781275-git-send-email-tony@atomide.com> <11757100811771-git-send-email-tony@atomide.com> <11757100821353-git-send-email-tony@atomide.com> <11757100853841-git-send-email-tony@atomide.com> <1175710087578-git-send-email-tony@atomide.com> <11757100911247-git-send-email-tony@atomide.com> <1175710093864-git-send-email-tony@atomide.com> <11757100952384-git-send-email-tony@atomide.com> <11757100982726-g!
 it-send-email-tony@atomide.com> <11757101012787-git-send-email-tony@atomide.com> <1175710103340-git-send-email-tony@atomide.com> <11757101072553-git-send-email-tony@atomide.com> <11757101101180-git-send-email-tony@atomide.com> <11757101123620-git-send-email-tony@atomide.com> <11757101141643-git-send-email-tony@atomide.com> <
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jarkko Lavinen <jarkko.lavinen@nokia.com>

Add onennand board specific support for N800

Signed-off-by: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/board-n800-flash.c |   97 +++++++++++++++++++++++++++++++-
 include/asm-arm/arch-omap/onenand.h    |    1 +
 2 files changed, 97 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/board-n800-flash.c b/arch/arm/mach-omap2/board-n800-flash.c
index cd302ab..4005cfb 100644
--- a/arch/arm/mach-omap2/board-n800-flash.c
+++ b/arch/arm/mach-omap2/board-n800-flash.c
@@ -12,16 +12,23 @@
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
 #include <asm/mach/flash.h>
+#include <linux/mtd/onenand_regs.h>
+
+#include <asm/io.h>
 #include <asm/arch/onenand.h>
 #include <asm/arch/board.h>
+#include <asm/arch/gpmc.h>
 
 static struct mtd_partition n800_partitions[8];
 
+static int n800_onenand_setup(void __iomem *);
+
 static struct omap_onenand_platform_data n800_onenand_data = {
 	.cs = 0,
 	.gpio_irq = 26,
 	.parts = n800_partitions,
-	.nr_parts = 0 /* filled later */
+	.nr_parts = 0, /* filled later */
+	.onenand_setup = n800_onenand_setup
 };
 
 static struct platform_device n800_onenand_device = {
@@ -32,6 +39,94 @@ static struct platform_device n800_onenand_device = {
 	},
 };
 
+static unsigned short omap2_onenand_readw(void __iomem *addr)
+{
+	return readw(addr);
+}
+
+static void omap2_onenand_writew(unsigned short value, void __iomem *addr)
+{
+	writew(value, addr);
+}
+
+static int omap2_onenand_set_sync_mode(int cs, void __iomem *onenand_base)
+{
+	const int min_gpmc_clk_period = 18;
+	struct gpmc_timings t;
+	int tick_ns, div, fclk_offset_ns, fclk_offset, gpmc_clk_ns, latency;
+	u32 reg;
+
+	tick_ns = gpmc_round_ns_to_ticks(1);
+	div = gpmc_cs_calc_divider(cs, min_gpmc_clk_period);
+	gpmc_clk_ns = div * tick_ns;
+	if (gpmc_clk_ns >= 24)
+		latency = 3;
+	else
+		latency = 4;
+
+	/* Configure OneNAND for sync read */
+	reg = omap2_onenand_readw(onenand_base + ONENAND_REG_SYS_CFG1);
+	reg &= ~((0x7 << ONENAND_SYS_CFG1_BRL_SHIFT) | (0x7 << 9));
+	reg |=	(latency << ONENAND_SYS_CFG1_BRL_SHIFT) |
+		ONENAND_SYS_CFG1_SYNC_READ |
+		ONENAND_SYS_CFG1_BL_16;
+	omap2_onenand_writew(reg, onenand_base + ONENAND_REG_SYS_CFG1);
+
+	/* FIXME: Get timings from platform data */
+	/* Set syncronous read timings */
+	memset(&t, 0, sizeof(t));
+	t.sync_clk = min_gpmc_clk_period;
+	t.cs_on = 0;
+	t.adv_on = gpmc_round_ns_to_ticks(7);
+	fclk_offset_ns = t.adv_on + gpmc_round_ns_to_ticks(7);
+	fclk_offset = fclk_offset_ns / gpmc_round_ns_to_ticks(1);
+	t.page_burst_access = gpmc_clk_ns;
+
+	/* Read */
+	t.adv_rd_off = fclk_offset_ns + gpmc_round_ns_to_ticks(7);
+	t.oe_on = t.adv_rd_off;
+	t.access = fclk_offset_ns + (latency + 1) * gpmc_clk_ns;
+	t.oe_off = t.access + gpmc_round_ns_to_ticks(1);
+	t.cs_rd_off = t.oe_off;
+	t.rd_cycle = t.cs_rd_off + gpmc_round_ns_to_ticks(17);
+
+	/* Write */
+	t.adv_wr_off = t.adv_on + gpmc_round_ns_to_ticks(12);
+	t.we_on = t.adv_wr_off + gpmc_round_ns_to_ticks(1);
+	t.we_off = t.we_on + gpmc_round_ns_to_ticks(40);
+	t.cs_wr_off = t.we_off + gpmc_round_ns_to_ticks(1);
+	t.wr_cycle = t.cs_wr_off + gpmc_round_ns_to_ticks(1);
+
+	/* Configure GPMC for synchronous read */
+	fclk_offset %= div;
+	gpmc_cs_write_reg(cs, GPMC_CS_CONFIG1,
+			  GPMC_CONFIG1_WRAPBURST_SUPP |
+			  GPMC_CONFIG1_READMULTIPLE_SUPP |
+			  GPMC_CONFIG1_READTYPE_SYNC |
+			  GPMC_CONFIG1_CLKACTIVATIONTIME(fclk_offset) |
+			  GPMC_CONFIG1_PAGE_LEN(2) |
+			  GPMC_CONFIG1_WAIT_READ_MON |
+			  GPMC_CONFIG1_WAIT_PIN_SEL(0) |
+			  GPMC_CONFIG1_DEVICESIZE_16 |
+			  GPMC_CONFIG1_DEVICETYPE_NOR |
+			  GPMC_CONFIG1_MUXADDDATA);
+
+	return gpmc_cs_set_timings(cs, &t);
+}
+
+static int n800_onenand_setup(void __iomem *onenand_base)
+{
+	struct omap_onenand_platform_data *datap = &n800_onenand_data;
+	struct device *dev = &n800_onenand_device.dev;
+
+	/* Set sync timings in GPMC */
+	if (omap2_onenand_set_sync_mode(datap->cs, onenand_base) < 0) {
+		dev_err(dev, "Unable to set synchronous mode\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
 
 void __init n800_flash_init(void)
 {
diff --git a/include/asm-arm/arch-omap/onenand.h b/include/asm-arm/arch-omap/onenand.h
index b8a19be..3e8ab2f 100644
--- a/include/asm-arm/arch-omap/onenand.h
+++ b/include/asm-arm/arch-omap/onenand.h
@@ -16,4 +16,5 @@ struct omap_onenand_platform_data {
 	int			gpio_irq;
 	struct mtd_partition	*parts;
 	int			nr_parts;
+	int                     (*onenand_setup)(void __iomem *);
 };
-- 
1.4.4.2

