Return-Path: <linux-kernel-owner+w=401wt.eu-S1752645AbZHITKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645AbZHITKt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 15:10:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751985AbZHITKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 15:10:48 -0400
Received: from mail.mnementh.co.uk ([173.45.232.4]:36155 "EHLO mnementh.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575AbZHITKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 15:10:47 -0400
Message-ID: <4A7F1F2C.3080809@mnementh.co.uk>
Date: Sun, 09 Aug 2009 20:10:36 +0100
From: Ian Molton <ian@mnementh.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=_mnementh-24901-1249845047-0001-2"
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Magnus Damm <magnus.damm@gmail.com>,
       pHilipp Zabel <philipp.zabel@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org, Pierre Ossman <drzeus@drzeus.cx>,
       Magnus Damm <damm@opensource.se>
Subject: MMC / MFD / Clocks
References: <Pine.LNX.4.64.0907170842050.4731@axis700.grange>  <aec7e5c30907290608i43a80fe1xe4ef0f3847855709@mail.gmail.com>  <4A7053E8.8050303@mnementh.co.uk>  <20090729201702.GA28202@linux-sh.org>  <74d0deb30907291355n39df7db0v1d7afc93917adc14@mail.gmail.com>  <4A716F1C.2050805@mnementh.co.uk>  <Pine.LNX.4.64.0907301246330.4462@axis700.grange>  <4A71F2A5.4060206@mnementh.co.uk>  <aec7e5c30908021952j7947b513w7d62f2c4d87bd3c5@mail.gmail.com>  <4A787C2C.5070000@mnementh.co.uk> <aec7e5c30908041908p568f413albef7dede3fd2cb83@mail.gmail.com> <4A798A4B.4000901@mnementh.co.uk> <Pine.LNX.4.64.0908051702180.5802@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0908051702180.5802@axis700.grange>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_mnementh-24901-1249845047-0001-2
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi guys,

I've done a bit more on the clocking code - it compiles now, but the mmc 
driver needs to pass some more data out than it does right now before 
the code will actually work.

Unless I hear any other comments, this is the direction the driver will 
take.

-Ian

--=_mnementh-24901-1249845047-0001-2
Content-Type: text/plain; name=diff; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="diff"

diff --git a/drivers/mfd/tc6393xb.c b/drivers/mfd/tc6393xb.c
index 1429a73..e5235d6 100644
--- a/drivers/mfd/tc6393xb.c
+++ b/drivers/mfd/tc6393xb.c
@@ -136,10 +136,6 @@ static int tc6393xb_nand_enable(struct platform_device *nand)
 	return 0;
 }
 
-static struct tmio_mmc_data tc6393xb_mmc_data = {
-	.hclk = 24000000,
-};
-
 static struct resource __devinitdata tc6393xb_nand_resources[] = {
 	{
 		.start	= 0x1000,
@@ -164,11 +160,11 @@ static struct resource __devinitdata tc6393xb_mmc_resources[] = {
 		.end	= 0x9ff,
 		.flags	= IORESOURCE_MEM,
 	},
-	{
-		.start	= 0x200,
-		.end	= 0x2ff,
-		.flags	= IORESOURCE_MEM,
-	},
+//	{
+//		.start	= 0x200,
+//		.end	= 0x2ff,
+//		.flags	= IORESOURCE_MEM,
+//	},
 	{
 		.start	= IRQ_TC6393_MMC,
 		.end	= IRQ_TC6393_MMC,
@@ -346,6 +342,84 @@ int tc6393xb_lcd_mode(struct platform_device *fb,
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
+#define sd_config_write8(a, b)  tmio_iowrite8((b), (a) + 0x200)
+#define sd_config_write16(a, b)  tmio_iowrite16((b), (a) + 0x200)
+#define sd_config_write32(a, b)  tmio_iowrite32((b), (a) + 0x200)
+
+static int tmio_mmc_enable(struct platform_device *mmc) {
+	struct platform_device *dev = to_platform_device(mmc->dev.parent);
+        struct tc6393xb *tc6393xb = platform_get_drvdata(dev);
+
+	/* Enable the MMC/SD Control registers */
+	sd_config_write16(tc6393xb->scr + CNF_CMD, SDCREN);
+	sd_config_write32(tc6393xb->scr + CNF_CTL_BASE,
+		(tc6393xb_mmc_resources[0].start) & 0xfffe);
+
+	/* Disable SD power during suspend */
+	sd_config_write8(tc6393xb->scr + CNF_PWR_CTL_3, 0x01);
+
+	/* The below is required but why? FIXME */
+	sd_config_write8(tc6393xb->scr + CNF_STOP_CLK_CTL, 0x1f);
+
+	/* Power down SD bus*/
+	sd_config_write8(tc6393xb->scr + CNF_PWR_CTL_2, 0x00);
+
+	return 0;
+}
+
+static int tmio_mmc_resume(struct platform_device *mmc) {
+        struct platform_device *dev = to_platform_device(mmc->dev.parent);
+        struct tc6393xb *tc6393xb = platform_get_drvdata(dev);
+
+	/* Enable the MMC/SD Control registers */
+	sd_config_write16(tc6393xb->scr + CNF_CMD, SDCREN);
+	sd_config_write32(tc6393xb->scr + CNF_CTL_BASE,
+		(tc6393xb_mmc_resources[0].start) & 0xfffe);
+
+	return 0;
+}
+
+static void tmio_mmc_pwr(struct platform_device *mmc, int state) {
+        struct platform_device *dev = to_platform_device(mmc->dev.parent);
+        struct tc6393xb *tc6393xb = platform_get_drvdata(dev);
+
+        sd_config_write8(tc6393xb->scr + CNF_PWR_CTL_2, state?0x02:0x00);
+}
+
+static void tmio_mmc_clk_div(struct platform_device *mmc, int state) {
+        struct platform_device *dev = to_platform_device(mmc->dev.parent);
+        struct tc6393xb *tc6393xb = platform_get_drvdata(dev);
+
+	sd_config_write8(tc6393xb->scr + CNF_SD_CLK_MODE, state?1:0);
+}
+
+static struct tmio_mmc_data tc6393xb_mmc_data = {
+	.hclk = 24000000,
+	.set_pwr = tmio_mmc_pwr,
+	.set_no_clk_div = tmio_mmc_clk_div,
+};
+
 static struct mfd_cell __devinitdata tc6393xb_cells[] = {
 	[TC6393XB_CELL_NAND] = {
 		.name = "tmio-nand",
@@ -355,6 +429,8 @@ static struct mfd_cell __devinitdata tc6393xb_cells[] = {
 	},
 	[TC6393XB_CELL_MMC] = {
 		.name = "tmio-mmc",
+		.enable = tmio_mmc_enable,
+		.resume = tmio_mmc_resume,
 		.driver_data = &tc6393xb_mmc_data,
 		.num_resources = ARRAY_SIZE(tc6393xb_mmc_resources),
 		.resources = tc6393xb_mmc_resources,
diff --git a/drivers/mmc/host/tmio_mmc.c b/drivers/mmc/host/tmio_mmc.c
index 91991b4..2045ba5 100644
--- a/drivers/mmc/host/tmio_mmc.c
+++ b/drivers/mmc/host/tmio_mmc.c
@@ -46,7 +46,9 @@ static void tmio_mmc_set_clock(struct tmio_mmc_host *host, int new_clock)
 		clk |= 0x100;
 	}
 
-	sd_config_write8(host, CNF_SD_CLK_MODE, clk >> 22);
+	if(host->set_no_clk_div)
+		host->set_no_clk_div(NULL, (clk>>22) & 1);
+
 	sd_ctrl_write16(host, CTL_SD_CARD_CLK_CTL, clk & 0x1ff);
 }
 
@@ -427,12 +429,13 @@ static void tmio_mmc_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 	/* Power sequence - OFF -> ON -> UP */
 	switch (ios->power_mode) {
 	case MMC_POWER_OFF: /* power down SD bus */
-		sd_config_write8(host, CNF_PWR_CTL_2, 0x00);
+		if(host->set_pwr)
+			host->set_pwr(NULL, 0);
 		tmio_mmc_clk_stop(host);
 		break;
 	case MMC_POWER_ON: /* power up SD bus */
-
-		sd_config_write8(host, CNF_PWR_CTL_2, 0x02);
+		if(host->set_pwr)
+			host->set_pwr(NULL, 1);
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
@@ -485,21 +488,15 @@ static int tmio_mmc_resume(struct platform_device *dev)
 {
 	struct mfd_cell	*cell = (struct mfd_cell *)dev->dev.platform_data;
 	struct mmc_host *mmc = platform_get_drvdata(dev);
-	struct tmio_mmc_host *host = mmc_priv(mmc);
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
@@ -514,7 +511,7 @@ static int __devinit tmio_mmc_probe(struct platform_device *dev)
 {
 	struct mfd_cell	*cell = (struct mfd_cell *)dev->dev.platform_data;
 	struct tmio_mmc_data *pdata;
-	struct resource *res_ctl, *res_cnf;
+	struct resource *res_ctl;
 	struct tmio_mmc_host *host;
 	struct mmc_host *mmc;
 	int ret = -EINVAL;
@@ -523,8 +520,7 @@ static int __devinit tmio_mmc_probe(struct platform_device *dev)
 		goto out;
 
 	res_ctl = platform_get_resource(dev, IORESOURCE_MEM, 0);
-	res_cnf = platform_get_resource(dev, IORESOURCE_MEM, 1);
-	if (!res_ctl || !res_cnf)
+	if (!res_ctl)
 		goto out;
 
 	pdata = cell->driver_data;
@@ -541,6 +537,9 @@ static int __devinit tmio_mmc_probe(struct platform_device *dev)
 	host->mmc = mmc;
 	platform_set_drvdata(dev, mmc);
 
+	host->set_pwr = pdata->set_pwr;
+	host->set_no_clk_div = pdata->set_no_clk_div;
+
 	/* SD control register space size is 0x200, 0x400 for bus_shift=1 */
 	host->bus_shift = resource_size(res_ctl) >> 10;
 
@@ -548,10 +547,6 @@ static int __devinit tmio_mmc_probe(struct platform_device *dev)
 	if (!host->ctl)
 		goto host_free;
 
-	host->cnf = ioremap(res_cnf->start, resource_size(res_cnf));
-	if (!host->cnf)
-		goto unmap_ctl;
-
 	mmc->ops = &tmio_mmc_ops;
 	mmc->caps = MMC_CAP_4_BIT_DATA;
 	mmc->f_max = pdata->hclk;
@@ -562,23 +557,9 @@ static int __devinit tmio_mmc_probe(struct platform_device *dev)
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
 
@@ -586,14 +567,14 @@ static int __devinit tmio_mmc_probe(struct platform_device *dev)
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
 
@@ -605,8 +586,6 @@ static int __devinit tmio_mmc_probe(struct platform_device *dev)
 
 	return 0;
 
-unmap_cnf:
-	iounmap(host->cnf);
 unmap_ctl:
 	iounmap(host->ctl);
 host_free:
@@ -626,7 +605,6 @@ static int __devexit tmio_mmc_remove(struct platform_device *dev)
 		mmc_remove_host(mmc);
 		free_irq(host->irq, host);
 		iounmap(host->ctl);
-		iounmap(host->cnf);
 		mmc_free_host(mmc);
 	}
 
diff --git a/drivers/mmc/host/tmio_mmc.h b/drivers/mmc/host/tmio_mmc.h
index 9fa9985..d7bc12d 100644
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
@@ -110,7 +90,6 @@
 
 
 struct tmio_mmc_host {
-	void __iomem *cnf;
 	void __iomem *ctl;
 	unsigned long bus_shift;
 	struct mmc_command      *cmd;
@@ -119,6 +98,10 @@ struct tmio_mmc_host {
 	struct mmc_host         *mmc;
 	int                     irq;
 
+	/* Callbacks for clock / power control */
+	void (*set_pwr)(struct platform_device *host, int state);
+	void (*set_no_clk_div)(struct platform_device *host, int state);
+
 	/* pio related stuff */
 	struct scatterlist      *sg_ptr;
 	unsigned int            sg_len;
@@ -163,25 +146,6 @@ static inline void sd_ctrl_write32(struct tmio_mmc_host *host, int addr,
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
index 6b9c5d0..cb34c28 100644
--- a/include/linux/mfd/tmio.h
+++ b/include/linux/mfd/tmio.h
@@ -23,6 +23,8 @@
  */
 struct tmio_mmc_data {
 	const unsigned int		hclk;
+	void (*set_pwr)(struct platform_device *host, int state);
+	void (*set_no_clk_div)(struct platform_device *host, int state);
 };
 
 /*

--=_mnementh-24901-1249845047-0001-2--
