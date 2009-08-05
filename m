Return-Path: <linux-kernel-owner+w=401wt.eu-S1753124AbZHEWnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124AbZHEWnc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 18:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752986AbZHEWnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 18:43:31 -0400
Received: from mail.mnementh.co.uk ([173.45.232.4]:45784 "EHLO mnementh.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752840AbZHEWna (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 18:43:30 -0400
Message-ID: <4A7A0B07.3030503@mnementh.co.uk>
Date: Wed, 05 Aug 2009 23:43:19 +0100
From: Ian Molton <ian@mnementh.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=_mnementh-20439-1249512211-0001-2"
To: Ian Molton <ian@mnementh.co.uk>
CC: Magnus Damm <magnus.damm@gmail.com>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       pHilipp Zabel <philipp.zabel@gmail.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org, Pierre Ossman <drzeus@drzeus.cx>,
       Magnus Damm <damm@opensource.se>
Subject: Re: Example idea for how to solve the clock/cnf problem.
References: <Pine.LNX.4.64.0907170842050.4731@axis700.grange>	 <aec7e5c30907290608i43a80fe1xe4ef0f3847855709@mail.gmail.com>	 <4A7053E8.8050303@mnementh.co.uk>	 <20090729201702.GA28202@linux-sh.org>	 <74d0deb30907291355n39df7db0v1d7afc93917adc14@mail.gmail.com>	 <4A716F1C.2050805@mnementh.co.uk>	 <Pine.LNX.4.64.0907301246330.4462@axis700.grange>	 <4A71F2A5.4060206@mnementh.co.uk>	 <aec7e5c30908021952j7947b513w7d62f2c4d87bd3c5@mail.gmail.com>	 <4A787C2C.5070000@mnementh.co.uk> <aec7e5c30908041908p568f413albef7dede3fd2cb83@mail.gmail.com> <4A7990F6.7030701@mnementh.co.uk>
In-Reply-To: <4A7990F6.7030701@mnementh.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_mnementh-20439-1249512211-0001-2
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Ooops. Patch attached this time.

Please comment on this. (its a WIP remember, so trivial stuff is to be 
ignored - I wanna get the functionality right first.)

Note in particular the change in the suspend/resume paths - we no longer 
(ab)use the enable/disable hooks, which may break some users of the driver.

I havent decided how I'm going to map the conf area in the MFD drivers 
in a nice way yet. As there are no known devices with TWO of these chips 
in them yet, I may do a static one-off mapping for now. At least this 
will leave tmio-mmc.{c,h} pure and free from all CNF area code.

-Ian


--=_mnementh-20439-1249512211-0001-2
Content-Type: text/plain; name=diffout; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="diffout"

diff --git a/drivers/mfd/tc6393xb.c b/drivers/mfd/tc6393xb.c
index 1429a73..5db07d7 100644
--- a/drivers/mfd/tc6393xb.c
+++ b/drivers/mfd/tc6393xb.c
@@ -138,6 +138,8 @@ static int tc6393xb_nand_enable(struct platform_device *nand)
 
 static struct tmio_mmc_data tc6393xb_mmc_data = {
 	.hclk = 24000000,
+	.set_pwr = tmio_mmc_pwr,
+	.set_no_clk_div = tmio_mmc_clk_div,
 };
 
 static struct resource __devinitdata tc6393xb_nand_resources[] = {
@@ -346,6 +348,59 @@ int tc6393xb_lcd_mode(struct platform_device *fb,
 }
 EXPORT_SYMBOL(tc6393xb_lcd_mode);
 
+
+#define CNF_CMD     0x04
+#define CNF_CTL_BASE   0x10
+#define CNF_INT_PIN  0x3d
+#define CNF_STOP_CLK_CTL 0x40
+#define CNF_GCLK_CTL 0x41
+#define CNF_SD_CLK_MODE 0x42
+#define CNF_PIN_STATUS 0x44
+#define CNF_PWR_CTL_1 0x48
+#define CNF_PWR_CTL_2 0x49
+#define CNF_PWR_CTL_3 0x4a
+#define CNF_CARD_DETECT_MODE 0x4c
+#define CNF_SD_SLOT 0x50
+#define CNF_EXT_GCLK_CTL_1 0xf0
+#define CNF_EXT_GCLK_CTL_2 0xf1
+#define CNF_EXT_GCLK_CTL_3 0xf9
+#define CNF_SD_LED_EN_1 0xfa
+#define CNF_SD_LED_EN_2 0xfe
+
+#define   SDCREN 0x2   /* Enable access to MMC CTL regs. (flag in COMMAND_REG)*/
+
+
+static int tmio_mmc_enable(struct platform_device *dev) {
+	/* Enable the MMC/SD Control registers */
+	sd_config_write16(host, CNF_CMD, SDCREN);
+	sd_config_write32(host, CNF_CTL_BASE,
+		(tc6393xb_mmc_resources[0].start) & 0xfffe);
+
+	/* Disable SD power during suspend */
+	sd_config_write8(host, CNF_PWR_CTL_3, 0x01);
+
+	/* The below is required but why? FIXME */
+	sd_config_write8(host, CNF_STOP_CLK_CTL, 0x1f);
+
+	/* Power down SD bus*/
+	sd_config_write8(host, CNF_PWR_CTL_2, 0x00);
+}
+
+static int tmio_mmc_resume(struct platform_device *dev) {
+	/* Enable the MMC/SD Control registers */
+	sd_config_write16(host, CNF_CMD, SDCREN);
+	sd_config_write32(host, CNF_CTL_BASE,
+		(dev->resource[0].start >> host->bus_shift) & 0xfffe);
+}
+
+static void tmio_mmc_pwr(struct tmio_mmc_host *host, int state) {
+        sd_config_write8(host, CNF_PWR_CTL_2, state?0x02:0x00);
+}
+
+static void tmio_mmc_clk_div(struct tmio_mmc_host *host, int state) {
+	sd_config_write8(host, CNF_SD_CLK_MODE, state?1:0);
+}
+
 static struct mfd_cell __devinitdata tc6393xb_cells[] = {
 	[TC6393XB_CELL_NAND] = {
 		.name = "tmio-nand",
@@ -355,6 +410,8 @@ static struct mfd_cell __devinitdata tc6393xb_cells[] = {
 	},
 	[TC6393XB_CELL_MMC] = {
 		.name = "tmio-mmc",
+		.enable = tmio_mmc_enable,
+		.resume = tmio_mmc_resume,
 		.driver_data = &tc6393xb_mmc_data,
 		.num_resources = ARRAY_SIZE(tc6393xb_mmc_resources),
 		.resources = tc6393xb_mmc_resources,
diff --git a/drivers/mmc/host/tmio_mmc.c b/drivers/mmc/host/tmio_mmc.c
index 91991b4..0b6075f 100644
--- a/drivers/mmc/host/tmio_mmc.c
+++ b/drivers/mmc/host/tmio_mmc.c
@@ -46,7 +46,9 @@ static void tmio_mmc_set_clock(struct tmio_mmc_host *host, int new_clock)
 		clk |= 0x100;
 	}
 
-	sd_config_write8(host, CNF_SD_CLK_MODE, clk >> 22);
+	if(host->set_no_clk_div)
+		host->set_no_clk_div(host, (clk>>22) & 1);
+
 	sd_ctrl_write16(host, CTL_SD_CARD_CLK_CTL, clk & 0x1ff);
 }
 
@@ -427,12 +429,13 @@ static void tmio_mmc_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 	/* Power sequence - OFF -> ON -> UP */
 	switch (ios->power_mode) {
 	case MMC_POWER_OFF: /* power down SD bus */
-		sd_config_write8(host, CNF_PWR_CTL_2, 0x00);
+		if(host->set_pwr)
+			host->set_pwr(host, 0);
 		tmio_mmc_clk_stop(host);
 		break;
 	case MMC_POWER_ON: /* power up SD bus */
-
-		sd_config_write8(host, CNF_PWR_CTL_2, 0x02);
+		if(host->set_pwr)
+			host->set_pwr(host, 1);
 		break;
 	case MMC_POWER_UP: /* start bus clock */
 		tmio_mmc_clk_start(host);
@@ -475,8 +478,8 @@ static int tmio_mmc_suspend(struct platform_device *dev, pm_message_t state)
 	ret = mmc_suspend_host(mmc, state);
 
 	/* Tell MFD core it can disable us now.*/
-	if (!ret && cell->disable)
-		cell->disable(dev);
+	if (!ret && cell->suspend)
+		cell->suspend(dev);
 
 	return ret;
 }
@@ -489,17 +492,12 @@ static int tmio_mmc_resume(struct platform_device *dev)
 	int ret = 0;
 
 	/* Tell the MFD core we are ready to be enabled */
-	if (cell->enable) {
-		ret = cell->enable(dev);
+	if (cell->resume) {
+		ret = cell->resume(dev);
 		if (ret)
 			goto out;
 	}
 
-	/* Enable the MMC/SD Control registers */
-	sd_config_write16(host, CNF_CMD, SDCREN);
-	sd_config_write32(host, CNF_CTL_BASE,
-		(dev->resource[0].start >> host->bus_shift) & 0xfffe);
-
 	mmc_resume_host(mmc);
 
 out:
@@ -514,7 +512,7 @@ static int __devinit tmio_mmc_probe(struct platform_device *dev)
 {
 	struct mfd_cell	*cell = (struct mfd_cell *)dev->dev.platform_data;
 	struct tmio_mmc_data *pdata;
-	struct resource *res_ctl, *res_cnf;
+	struct resource *res_ctl;
 	struct tmio_mmc_host *host;
 	struct mmc_host *mmc;
 	int ret = -EINVAL;
@@ -523,8 +521,7 @@ static int __devinit tmio_mmc_probe(struct platform_device *dev)
 		goto out;
 
 	res_ctl = platform_get_resource(dev, IORESOURCE_MEM, 0);
-	res_cnf = platform_get_resource(dev, IORESOURCE_MEM, 1);
-	if (!res_ctl || !res_cnf)
+	if (!res_ctl)
 		goto out;
 
 	pdata = cell->driver_data;
@@ -541,6 +538,9 @@ static int __devinit tmio_mmc_probe(struct platform_device *dev)
 	host->mmc = mmc;
 	platform_set_drvdata(dev, mmc);
 
+	host->set_pwr = pdata->set_pwr;
+	host->set_no_clk_div = pdata->set_no_clk_div;
+
 	/* SD control register space size is 0x200, 0x400 for bus_shift=1 */
 	host->bus_shift = resource_size(res_ctl) >> 10;
 
@@ -548,10 +548,6 @@ static int __devinit tmio_mmc_probe(struct platform_device *dev)
 	if (!host->ctl)
 		goto host_free;
 
-	host->cnf = ioremap(res_cnf->start, resource_size(res_cnf));
-	if (!host->cnf)
-		goto unmap_ctl;
-
 	mmc->ops = &tmio_mmc_ops;
 	mmc->caps = MMC_CAP_4_BIT_DATA;
 	mmc->f_max = pdata->hclk;
@@ -562,23 +558,9 @@ static int __devinit tmio_mmc_probe(struct platform_device *dev)
 	if (cell->enable) {
 		ret = cell->enable(dev);
 		if (ret)
-			goto unmap_cnf;
+			goto unmap_ctl;
 	}
 
-	/* Enable the MMC/SD Control registers */
-	sd_config_write16(host, CNF_CMD, SDCREN);
-	sd_config_write32(host, CNF_CTL_BASE,
-		(dev->resource[0].start >> host->bus_shift) & 0xfffe);
-
-	/* Disable SD power during suspend */
-	sd_config_write8(host, CNF_PWR_CTL_3, 0x01);
-
-	/* The below is required but why? FIXME */
-	sd_config_write8(host, CNF_STOP_CLK_CTL, 0x1f);
-
-	/* Power down SD bus*/
-	sd_config_write8(host, CNF_PWR_CTL_2, 0x00);
-
 	tmio_mmc_clk_stop(host);
 	reset(host);
 
@@ -586,14 +568,14 @@ static int __devinit tmio_mmc_probe(struct platform_device *dev)
 	if (ret >= 0)
 		host->irq = ret;
 	else
-		goto unmap_cnf;
+		goto unmap_ctl;
 
 	disable_mmc_irqs(host, TMIO_MASK_ALL);
 
 	ret = request_irq(host->irq, tmio_mmc_irq, IRQF_DISABLED |
 		IRQF_TRIGGER_FALLING, "tmio-mmc", host);
 	if (ret)
-		goto unmap_cnf;
+		goto unmap_ctl;
 
 	mmc_add_host(mmc);
 
@@ -605,8 +587,6 @@ static int __devinit tmio_mmc_probe(struct platform_device *dev)
 
 	return 0;
 
-unmap_cnf:
-	iounmap(host->cnf);
 unmap_ctl:
 	iounmap(host->ctl);
 host_free:
@@ -626,7 +606,6 @@ static int __devexit tmio_mmc_remove(struct platform_device *dev)
 		mmc_remove_host(mmc);
 		free_irq(host->irq, host);
 		iounmap(host->ctl);
-		iounmap(host->cnf);
 		mmc_free_host(mmc);
 	}
 
diff --git a/drivers/mmc/host/tmio_mmc.h b/drivers/mmc/host/tmio_mmc.h
index 9fa9985..95d3fc4 100644
--- a/drivers/mmc/host/tmio_mmc.h
+++ b/drivers/mmc/host/tmio_mmc.h
@@ -11,26 +11,6 @@
 
 #include <linux/highmem.h>
 
-#define CNF_CMD     0x04
-#define CNF_CTL_BASE   0x10
-#define CNF_INT_PIN  0x3d
-#define CNF_STOP_CLK_CTL 0x40
-#define CNF_GCLK_CTL 0x41
-#define CNF_SD_CLK_MODE 0x42
-#define CNF_PIN_STATUS 0x44
-#define CNF_PWR_CTL_1 0x48
-#define CNF_PWR_CTL_2 0x49
-#define CNF_PWR_CTL_3 0x4a
-#define CNF_CARD_DETECT_MODE 0x4c
-#define CNF_SD_SLOT 0x50
-#define CNF_EXT_GCLK_CTL_1 0xf0
-#define CNF_EXT_GCLK_CTL_2 0xf1
-#define CNF_EXT_GCLK_CTL_3 0xf9
-#define CNF_SD_LED_EN_1 0xfa
-#define CNF_SD_LED_EN_2 0xfe
-
-#define   SDCREN 0x2   /* Enable access to MMC CTL regs. (flag in COMMAND_REG)*/
-
 #define CTL_SD_CMD 0x00
 #define CTL_ARG_REG 0x04
 #define CTL_STOP_INTERNAL_ACTION 0x08
@@ -163,25 +143,6 @@ static inline void sd_ctrl_write32(struct tmio_mmc_host *host, int addr,
 	writew(val >> 16, host->ctl + ((addr + 2) << host->bus_shift));
 }
 
-static inline void sd_config_write8(struct tmio_mmc_host *host, int addr,
-		u8 val)
-{
-	writeb(val, host->cnf + (addr << host->bus_shift));
-}
-
-static inline void sd_config_write16(struct tmio_mmc_host *host, int addr,
-		u16 val)
-{
-	writew(val, host->cnf + (addr << host->bus_shift));
-}
-
-static inline void sd_config_write32(struct tmio_mmc_host *host, int addr,
-		u32 val)
-{
-	writew(val, host->cnf + (addr << host->bus_shift));
-	writew(val >> 16, host->cnf + ((addr + 2) << host->bus_shift));
-}
-
 #include <linux/scatterlist.h>
 #include <linux/blkdev.h>
 
diff --git a/include/linux/mfd/tmio.h b/include/linux/mfd/tmio.h
index 6b9c5d0..c09f284 100644
--- a/include/linux/mfd/tmio.h
+++ b/include/linux/mfd/tmio.h
@@ -23,6 +23,8 @@
  */
 struct tmio_mmc_data {
 	const unsigned int		hclk;
+	void (*set_pwr)(struct tmio_mmc_host *host, int state);
+	void (*set_no_clk_div)(struct tmio_mmc_host *host, int state);
 };
 
 /*

--=_mnementh-20439-1249512211-0001-2--
