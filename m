Return-Path: <linux-kernel-owner+w=401wt.eu-S1759161AbYEPQvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759161AbYEPQvf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 12:51:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755028AbYEPQu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 12:50:59 -0400
Received: from rtsoft2.corbina.net ([85.21.88.2]:34098 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with SMTP id S1752849AbYEPQu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 12:50:57 -0400
Date: Fri, 16 May 2008 20:50:55 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Kumar Gala <galak@kernel.crashing.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: Jochen Friedrich <jochen@scram.de>, Timur Tabi <timur@freescale.com>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       spi-devel-general@lists.sourceforge.net
Subject: [PATCH 2/4] [POWERPC] 86xx: mpc8610_hpcd: add support for SPI and
	MMC-over-SPI
Message-ID: <20080516165055.GB24196@polina.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is mpc832x-like MMC setup, but with a quirk to work around PIXIS'
CS line weirdness.

Probably someday we'll want to convert spi_mpc83xx driver into OF driver
and place the MMC node into device tree. But this will need great efforts
for SPI (alike I2C work we've seen lately), plus converting some PIXIS
code into OF GPIO controller(s).

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 arch/powerpc/boot/dts/mpc8610_hpcd.dts     |    9 ++++
 arch/powerpc/platforms/86xx/mpc8610_hpcd.c |   63 +++++++++++++++++++++++++--
 2 files changed, 67 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/boot/dts/mpc8610_hpcd.dts b/arch/powerpc/boot/dts/mpc8610_hpcd.dts
index 44e9287..ed20ac4 100644
--- a/arch/powerpc/boot/dts/mpc8610_hpcd.dts
+++ b/arch/powerpc/boot/dts/mpc8610_hpcd.dts
@@ -193,6 +193,15 @@
 			reg = <0xe4000 0x100>;
 		};
 
+		spi@7000 {
+			compatible = "fsl,mpc8610-spi", "fsl,spi";
+			cell-index = <0>;
+			reg = <0x7000 0x40>;
+			interrupts = <59 2>;
+			interrupt-parent = <&mpic>;
+			mode = "cpu";
+		};
+
 		i2s@16000 {
 			compatible = "fsl,mpc8610-ssi";
 			cell-index = <0>;
diff --git a/arch/powerpc/platforms/86xx/mpc8610_hpcd.c b/arch/powerpc/platforms/86xx/mpc8610_hpcd.c
index fe163d4..be430bc 100644
--- a/arch/powerpc/platforms/86xx/mpc8610_hpcd.c
+++ b/arch/powerpc/platforms/86xx/mpc8610_hpcd.c
@@ -40,7 +40,63 @@
 #include <sysdev/fsl_pci.h>
 #include <sysdev/fsl_soc.h>
 
-static unsigned char *pixis_bdcfg0, *pixis_arch;
+#include <linux/spi/spi.h>
+#include <linux/spi/mmc_spi.h>
+#include <linux/mmc/host.h>
+
+#define PX_BRDCFG0_SERSEL	(1 << 1)
+#define PX_BRDCFG0_DVISEL	(1 << 3)
+#define PX_BRDCFG0_DLINK	(1 << 4)
+#define PX_BRDCFG0_DIU_MASK	(PX_BRDCFG0_DVISEL | PX_BRDCFG0_DLINK)
+
+#define PX_SDCSR_SD_nSEL	(1 << 0)
+/* despite documentation this is active-high */
+#define PX_SDCSR_SD_WP		(1 << 6)
+#define PX_SDCSR_SD_nCD		(1 << 7)
+
+static u8 __iomem *pixis_bdcfg0;
+static u8 __iomem *pixis_arch;
+static u8 __iomem *pixis_sdcsr;
+
+static int mmc_get_ro(struct device *dev)
+{
+	return in_8(pixis_sdcsr) & PX_SDCSR_SD_WP;
+}
+
+static struct mmc_spi_platform_data mmc_pdata = {
+	.ocr_mask = MMC_VDD_33_34,
+	.get_ro = mmc_get_ro,
+};
+
+static struct spi_board_info spi_boardinfo = {
+	.bus_num = 0x7000,
+	.chip_select = 0,
+	.max_speed_hz = 50000000,
+	.modalias = "mmc_spi",
+	.platform_data = &mmc_pdata,
+};
+
+static int __init spi_init(void)
+{
+	if (!pixis_sdcsr)
+		return -ENODEV;
+	if (!(in_8(pixis_bdcfg0) & PX_BRDCFG0_SERSEL)) {
+		pr_info("mpc8610_hpcd: SPI (and thus SD/MMC slot) was "
+			"disabled by the firmware.\n");
+		return -ENODEV;
+	}
+
+	/*
+	 * SD cards reacting quite badly on the PIXIS' SD CS line. That is,
+	 * I'm getting errors from the SD cards running at 25MHz. So here
+	 * is the trick: we assert the CS line and do not touch it afterwards.
+	 * This works for all cards I have, this also should be safe from the
+	 * SPI stand point, since SPI isn't shared.
+	 */
+	clrbits8(pixis_sdcsr, PX_SDCSR_SD_nSEL);
+	return fsl_spi_init(&spi_boardinfo, 1, NULL, NULL);
+}
+machine_device_initcall(mpc86xx_hpcd, spi_init);
 
 static struct of_device_id __initdata mpc8610_ids[] = {
 	{ .compatible = "fsl,mpc8610-immr", },
@@ -139,10 +195,6 @@ void mpc8610hpcd_set_gamma_table(int monitor_port, char *gamma_table_base)
 	}
 }
 
-#define PX_BRDCFG0_DVISEL	(1 << 3)
-#define PX_BRDCFG0_DLINK	(1 << 4)
-#define PX_BRDCFG0_DIU_MASK	(PX_BRDCFG0_DVISEL | PX_BRDCFG0_DLINK)
-
 void mpc8610hpcd_set_monitor_port(int monitor_port)
 {
 	static const u8 bdcfg[] = {
@@ -286,6 +338,7 @@ static void __init mpc86xx_hpcd_setup_arch(void)
 		}
 		pixis_bdcfg0 = pixis + 8;
 		pixis_arch = pixis + 1;
+		pixis_sdcsr = pixis + 10;
 	} else
 		printk(KERN_ERR "Err: "
 				"can't find device node 'fsl,fpga-pixis'\n");
-- 
1.5.5.1

