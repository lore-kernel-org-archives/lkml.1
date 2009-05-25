Return-Path: <linux-kernel-owner+w=401wt.eu-S1754059AbZEYT2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059AbZEYT2V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 15:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752927AbZEYT1z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 15:27:55 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:9307 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549AbZEYT1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 15:27:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=GrBqJxTZRp2M2hgU8O44tJipzAtifxyVPHx3VFIVbHMahibcjcBMRW8APOUFmKaOTd
         fkQxMGL0Sx3NNy0gT1vQfNs/Cqh8ZHfNclzHvQIdoHZkhE86N5Z9ryyBl1CKVoQqtnM7
         1G73rTLdueR9T4kdHjlxWX/iCbhfbJ/r7f9LA=
From: Philipp Zabel <philipp.zabel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ian Molton <spyro@f2s.com>, Philipp Zabel <philipp.zabel@gmail.com>,
       Pierre Ossman <pierre@ossman.eu>
Subject: [PATCH 2/5] mmc: tmio_mmc: add bus_shift support
Date: Mon, 25 May 2009 21:27:58 +0200
Message-Id: <1243279681-4233-3-git-send-email-philipp.zabel@gmail.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1243279681-4233-1-git-send-email-philipp.zabel@gmail.com>
References: <1243279681-4233-1-git-send-email-philipp.zabel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some ASIC3 devices in the wild are connected with the address bus shifted
by one line, so that its 16-bit registers appear 32-bit aligned in host
memory space.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
Cc: Pierre Ossman <pierre@ossman.eu>
Cc: Ian Molton <spyro@f2s.com>
---
 drivers/mmc/host/tmio_mmc.c |  127 +++++++++++++++++++------------------------
 drivers/mmc/host/tmio_mmc.h |   72 +++++++++++++++++++++---
 2 files changed, 118 insertions(+), 81 deletions(-)

diff --git a/drivers/mmc/host/tmio_mmc.c b/drivers/mmc/host/tmio_mmc.c
index 9c488a8..245de05 100644
--- a/drivers/mmc/host/tmio_mmc.c
+++ b/drivers/mmc/host/tmio_mmc.c
@@ -37,8 +37,6 @@
 
 static void tmio_mmc_set_clock(struct tmio_mmc_host *host, int new_clock)
 {
-	void __iomem *cnf = host->cnf;
-	void __iomem *ctl = host->ctl;
 	u32 clk = 0, clock;
 
 	if (new_clock) {
@@ -50,45 +48,39 @@ static void tmio_mmc_set_clock(struct tmio_mmc_host *host, int new_clock)
 			clk = 0x20000;
 
 		clk >>= 2;
-		tmio_iowrite8((clk & 0x8000) ? 0 : 1, cnf + CNF_SD_CLK_MODE);
+		sd_config_write8(host, CNF_SD_CLK_MODE, (clk & 0x8000) ? 0 : 1);
 		clk |= 0x100;
 	}
 
-	tmio_iowrite16(clk, ctl + CTL_SD_CARD_CLK_CTL);
+	sd_ctrl_write16(host, CTL_SD_CARD_CLK_CTL, clk);
 }
 
 static void tmio_mmc_clk_stop(struct tmio_mmc_host *host)
 {
-	void __iomem *ctl = host->ctl;
-
-	tmio_iowrite16(0x0000, ctl + CTL_CLK_AND_WAIT_CTL);
+	sd_ctrl_write16(host, CTL_CLK_AND_WAIT_CTL, 0x0000);
 	msleep(10);
-	tmio_iowrite16(tmio_ioread16(ctl + CTL_SD_CARD_CLK_CTL) & ~0x0100,
-	       ctl + CTL_SD_CARD_CLK_CTL);
+	sd_ctrl_write16(host, CTL_SD_CARD_CLK_CTL, ~0x0100 &
+		sd_ctrl_read16(host, CTL_SD_CARD_CLK_CTL));
 	msleep(10);
 }
 
 static void tmio_mmc_clk_start(struct tmio_mmc_host *host)
 {
-	void __iomem *ctl = host->ctl;
-
-	tmio_iowrite16(tmio_ioread16(ctl + CTL_SD_CARD_CLK_CTL) | 0x0100,
-	       ctl + CTL_SD_CARD_CLK_CTL);
+	sd_ctrl_write16(host, CTL_SD_CARD_CLK_CTL, 0x0100 |
+		sd_ctrl_read16(host, CTL_SD_CARD_CLK_CTL));
 	msleep(10);
-	tmio_iowrite16(0x0100, ctl + CTL_CLK_AND_WAIT_CTL);
+	sd_ctrl_write16(host, CTL_CLK_AND_WAIT_CTL, 0x0100);
 	msleep(10);
 }
 
 static void reset(struct tmio_mmc_host *host)
 {
-	void __iomem *ctl = host->ctl;
-
 	/* FIXME - should we set stop clock reg here */
-	tmio_iowrite16(0x0000, ctl + CTL_RESET_SD);
-	tmio_iowrite16(0x0000, ctl + CTL_RESET_SDIO);
+	sd_ctrl_write16(host, CTL_RESET_SD, 0x0000);
+	sd_ctrl_write16(host, CTL_RESET_SDIO, 0x0000);
 	msleep(10);
-	tmio_iowrite16(0x0001, ctl + CTL_RESET_SD);
-	tmio_iowrite16(0x0001, ctl + CTL_RESET_SDIO);
+	sd_ctrl_write16(host, CTL_RESET_SD, 0x0001);
+	sd_ctrl_write16(host, CTL_RESET_SDIO, 0x0001);
 	msleep(10);
 }
 
@@ -120,13 +112,12 @@ tmio_mmc_finish_request(struct tmio_mmc_host *host)
 static int
 tmio_mmc_start_command(struct tmio_mmc_host *host, struct mmc_command *cmd)
 {
-	void __iomem *ctl = host->ctl;
 	struct mmc_data *data = host->data;
 	int c = cmd->opcode;
 
 	/* Command 12 is handled by hardware */
 	if (cmd->opcode == 12 && !cmd->arg) {
-		tmio_iowrite16(0x001, ctl + CTL_STOP_INTERNAL_ACTION);
+		sd_ctrl_write16(host, CTL_STOP_INTERNAL_ACTION, 0x001);
 		return 0;
 	}
 
@@ -151,18 +142,18 @@ tmio_mmc_start_command(struct tmio_mmc_host *host, struct mmc_command *cmd)
 	if (data) {
 		c |= DATA_PRESENT;
 		if (data->blocks > 1) {
-			tmio_iowrite16(0x100, ctl + CTL_STOP_INTERNAL_ACTION);
+			sd_ctrl_write16(host, CTL_STOP_INTERNAL_ACTION, 0x100);
 			c |= TRANSFER_MULTI;
 		}
 		if (data->flags & MMC_DATA_READ)
 			c |= TRANSFER_READ;
 	}
 
-	enable_mmc_irqs(ctl, TMIO_MASK_CMD);
+	enable_mmc_irqs(host, TMIO_MASK_CMD);
 
 	/* Fire off the command */
-	tmio_iowrite32(cmd->arg, ctl + CTL_ARG_REG);
-	tmio_iowrite16(c, ctl + CTL_SD_CMD);
+	sd_ctrl_write32(host, CTL_ARG_REG, cmd->arg);
+	sd_ctrl_write16(host, CTL_SD_CMD, c);
 
 	return 0;
 }
@@ -174,7 +165,6 @@ tmio_mmc_start_command(struct tmio_mmc_host *host, struct mmc_command *cmd)
  */
 static inline void tmio_mmc_pio_irq(struct tmio_mmc_host *host)
 {
-	void __iomem *ctl = host->ctl;
 	struct mmc_data *data = host->data;
 	unsigned short *buf;
 	unsigned int count;
@@ -197,9 +187,9 @@ static inline void tmio_mmc_pio_irq(struct tmio_mmc_host *host)
 
 	/* Transfer the data */
 	if (data->flags & MMC_DATA_READ)
-		tmio_ioread16_rep(ctl + CTL_SD_DATA_PORT, buf, count >> 1);
+		sd_ctrl_read16_rep(host, CTL_SD_DATA_PORT, buf, count >> 1);
 	else
-		tmio_iowrite16_rep(ctl + CTL_SD_DATA_PORT, buf, count >> 1);
+		sd_ctrl_write16_rep(host, CTL_SD_DATA_PORT, buf, count >> 1);
 
 	host->sg_off += count;
 
@@ -213,7 +203,6 @@ static inline void tmio_mmc_pio_irq(struct tmio_mmc_host *host)
 
 static inline void tmio_mmc_data_irq(struct tmio_mmc_host *host)
 {
-	void __iomem *ctl = host->ctl;
 	struct mmc_data *data = host->data;
 	struct mmc_command *stop;
 
@@ -242,13 +231,13 @@ static inline void tmio_mmc_data_irq(struct tmio_mmc_host *host)
 	 */
 
 	if (data->flags & MMC_DATA_READ)
-		disable_mmc_irqs(ctl, TMIO_MASK_READOP);
+		disable_mmc_irqs(host, TMIO_MASK_READOP);
 	else
-		disable_mmc_irqs(ctl, TMIO_MASK_WRITEOP);
+		disable_mmc_irqs(host, TMIO_MASK_WRITEOP);
 
 	if (stop) {
 		if (stop->opcode == 12 && !stop->arg)
-			tmio_iowrite16(0x000, ctl + CTL_STOP_INTERNAL_ACTION);
+			sd_ctrl_write16(host, CTL_STOP_INTERNAL_ACTION, 0x000);
 		else
 			BUG();
 	}
@@ -259,9 +248,8 @@ static inline void tmio_mmc_data_irq(struct tmio_mmc_host *host)
 static inline void tmio_mmc_cmd_irq(struct tmio_mmc_host *host,
 	unsigned int stat)
 {
-	void __iomem *ctl = host->ctl, *addr;
 	struct mmc_command *cmd = host->cmd;
-	int i;
+	int i, addr;
 
 	if (!host->cmd) {
 		pr_debug("Spurious CMD irq\n");
@@ -275,8 +263,8 @@ static inline void tmio_mmc_cmd_irq(struct tmio_mmc_host *host,
 	 * modify the order of the response for short response command types.
 	 */
 
-	for (i = 3, addr = ctl + CTL_RESPONSE ; i >= 0 ; i--, addr += 4)
-		cmd->resp[i] = tmio_ioread32(addr);
+	for (i = 3, addr = CTL_RESPONSE ; i >= 0 ; i--, addr += 4)
+		cmd->resp[i] = sd_ctrl_read32(host, addr);
 
 	if (cmd->flags &  MMC_RSP_136) {
 		cmd->resp[0] = (cmd->resp[0] << 8) | (cmd->resp[1] >> 24);
@@ -298,9 +286,9 @@ static inline void tmio_mmc_cmd_irq(struct tmio_mmc_host *host,
 	 */
 	if (host->data && !cmd->error) {
 		if (host->data->flags & MMC_DATA_READ)
-			enable_mmc_irqs(ctl, TMIO_MASK_READOP);
+			enable_mmc_irqs(host, TMIO_MASK_READOP);
 		else
-			enable_mmc_irqs(ctl, TMIO_MASK_WRITEOP);
+			enable_mmc_irqs(host, TMIO_MASK_WRITEOP);
 	} else {
 		tmio_mmc_finish_request(host);
 	}
@@ -312,20 +300,19 @@ static inline void tmio_mmc_cmd_irq(struct tmio_mmc_host *host,
 static irqreturn_t tmio_mmc_irq(int irq, void *devid)
 {
 	struct tmio_mmc_host *host = devid;
-	void __iomem *ctl = host->ctl;
 	unsigned int ireg, irq_mask, status;
 
 	pr_debug("MMC IRQ begin\n");
 
-	status = tmio_ioread32(ctl + CTL_STATUS);
-	irq_mask = tmio_ioread32(ctl + CTL_IRQ_MASK);
+	status = sd_ctrl_read32(host, CTL_STATUS);
+	irq_mask = sd_ctrl_read32(host, CTL_IRQ_MASK);
 	ireg = status & TMIO_MASK_IRQ & ~irq_mask;
 
 	pr_debug_status(status);
 	pr_debug_status(ireg);
 
 	if (!ireg) {
-		disable_mmc_irqs(ctl, status & ~irq_mask);
+		disable_mmc_irqs(host, status & ~irq_mask);
 
 		pr_debug("tmio_mmc: Spurious irq, disabling! "
 			"0x%08x 0x%08x 0x%08x\n", status, irq_mask, ireg);
@@ -337,7 +324,7 @@ static irqreturn_t tmio_mmc_irq(int irq, void *devid)
 	while (ireg) {
 		/* Card insert / remove attempts */
 		if (ireg & (TMIO_STAT_CARD_INSERT | TMIO_STAT_CARD_REMOVE)) {
-			ack_mmc_irqs(ctl, TMIO_STAT_CARD_INSERT |
+			ack_mmc_irqs(host, TMIO_STAT_CARD_INSERT |
 				TMIO_STAT_CARD_REMOVE);
 			mmc_detect_change(host->mmc, 0);
 		}
@@ -349,25 +336,25 @@ static irqreturn_t tmio_mmc_irq(int irq, void *devid)
 
 		/* Command completion */
 		if (ireg & TMIO_MASK_CMD) {
-			ack_mmc_irqs(ctl, TMIO_MASK_CMD);
+			ack_mmc_irqs(host, TMIO_MASK_CMD);
 			tmio_mmc_cmd_irq(host, status);
 		}
 
 		/* Data transfer */
 		if (ireg & (TMIO_STAT_RXRDY | TMIO_STAT_TXRQ)) {
-			ack_mmc_irqs(ctl, TMIO_STAT_RXRDY | TMIO_STAT_TXRQ);
+			ack_mmc_irqs(host, TMIO_STAT_RXRDY | TMIO_STAT_TXRQ);
 			tmio_mmc_pio_irq(host);
 		}
 
 		/* Data transfer completion */
 		if (ireg & TMIO_STAT_DATAEND) {
-			ack_mmc_irqs(ctl, TMIO_STAT_DATAEND);
+			ack_mmc_irqs(host, TMIO_STAT_DATAEND);
 			tmio_mmc_data_irq(host);
 		}
 
 		/* Check status - keep going until we've handled it all */
-		status = tmio_ioread32(ctl + CTL_STATUS);
-		irq_mask = tmio_ioread32(ctl + CTL_IRQ_MASK);
+		status = sd_ctrl_read32(host, CTL_STATUS);
+		irq_mask = sd_ctrl_read32(host, CTL_IRQ_MASK);
 		ireg = status & TMIO_MASK_IRQ & ~irq_mask;
 
 		pr_debug("Status at end of loop: %08x\n", status);
@@ -382,8 +369,6 @@ out:
 static int tmio_mmc_start_data(struct tmio_mmc_host *host,
 	struct mmc_data *data)
 {
-	void __iomem *ctl = host->ctl;
-
 	pr_debug("setup data transfer: blocksize %08x  nr_blocks %d\n",
 	    data->blksz, data->blocks);
 
@@ -398,8 +383,8 @@ static int tmio_mmc_start_data(struct tmio_mmc_host *host,
 	host->data = data;
 
 	/* Set transfer length / blocksize */
-	tmio_iowrite16(data->blksz,  ctl + CTL_SD_XFER_LEN);
-	tmio_iowrite16(data->blocks, ctl + CTL_XFER_BLK_COUNT);
+	sd_ctrl_write16(host, CTL_SD_XFER_LEN, data->blksz);
+	sd_ctrl_write16(host, CTL_XFER_BLK_COUNT, data->blocks);
 
 	return 0;
 }
@@ -440,8 +425,6 @@ fail:
 static void tmio_mmc_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 {
 	struct tmio_mmc_host *host = mmc_priv(mmc);
-	void __iomem *cnf = host->cnf;
-	void __iomem *ctl = host->ctl;
 
 	if (ios->clock)
 		tmio_mmc_set_clock(host, ios->clock);
@@ -449,12 +432,12 @@ static void tmio_mmc_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 	/* Power sequence - OFF -> ON -> UP */
 	switch (ios->power_mode) {
 	case MMC_POWER_OFF: /* power down SD bus */
-		tmio_iowrite8(0x00, cnf + CNF_PWR_CTL_2);
+		sd_config_write8(host, CNF_PWR_CTL_2, 0x00);
 		tmio_mmc_clk_stop(host);
 		break;
 	case MMC_POWER_ON: /* power up SD bus */
 
-		tmio_iowrite8(0x02, cnf + CNF_PWR_CTL_2);
+		sd_config_write8(host, CNF_PWR_CTL_2, 0x02);
 		break;
 	case MMC_POWER_UP: /* start bus clock */
 		tmio_mmc_clk_start(host);
@@ -463,10 +446,10 @@ static void tmio_mmc_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 
 	switch (ios->bus_width) {
 	case MMC_BUS_WIDTH_1:
-		tmio_iowrite16(0x80e0, ctl + CTL_SD_MEM_CARD_OPT);
+		sd_ctrl_write16(host, CTL_SD_MEM_CARD_OPT, 0x80e0);
 	break;
 	case MMC_BUS_WIDTH_4:
-		tmio_iowrite16(0x00e0, ctl + CTL_SD_MEM_CARD_OPT);
+		sd_ctrl_write16(host, CTL_SD_MEM_CARD_OPT, 0x00e0);
 	break;
 	}
 
@@ -477,9 +460,8 @@ static void tmio_mmc_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 static int tmio_mmc_get_ro(struct mmc_host *mmc)
 {
 	struct tmio_mmc_host *host = mmc_priv(mmc);
-	void __iomem *ctl = host->ctl;
 
-	return (tmio_ioread16(ctl + CTL_STATUS) & TMIO_STAT_WRPROTECT) ? 0 : 1;
+	return (sd_ctrl_read16(host, CTL_STATUS) & TMIO_STAT_WRPROTECT) ? 0 : 1;
 }
 
 static struct mmc_host_ops tmio_mmc_ops = {
@@ -509,12 +491,11 @@ static int tmio_mmc_resume(struct platform_device *dev)
 	struct mfd_cell	*cell = (struct mfd_cell *)dev->dev.platform_data;
 	struct mmc_host *mmc = platform_get_drvdata(dev);
 	struct tmio_mmc_host *host = mmc_priv(mmc);
-	void __iomem *cnf = host->cnf;
 	int ret = 0;
 
 	/* Enable the MMC/SD Control registers */
-	tmio_iowrite16(SDCREN, cnf + CNF_CMD);
-	tmio_iowrite32(dev->resource[0].start & 0xfffe, cnf + CNF_CTL_BASE);
+	sd_config_write16(host, CNF_CMD, SDCREN);
+	sd_config_write32(host, CNF_CTL_BASE, dev->resource[0].start & 0xfffe);
 
 	/* Tell the MFD core we are ready to be enabled */
 	if (cell->enable) {
@@ -566,6 +547,9 @@ static int __devinit tmio_mmc_probe(struct platform_device *dev)
 	host->mmc = mmc;
 	platform_set_drvdata(dev, mmc);
 
+	/* SD control register space size is 0x200, 0x400 for bus_shift=1 */
+	host->bus_shift = resource_size(res_ctl) >> 10;
+
 	host->ctl = ioremap(res_ctl->start, resource_size(res_ctl));
 	if (!host->ctl)
 		goto host_free;
@@ -581,9 +565,8 @@ static int __devinit tmio_mmc_probe(struct platform_device *dev)
 	mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34;
 
 	/* Enable the MMC/SD Control registers */
-	tmio_iowrite16(SDCREN, host->cnf + CNF_CMD);
-	tmio_iowrite32(dev->resource[0].start & 0xfffe,
-		host->cnf + CNF_CTL_BASE);
+	sd_config_write16(host, CNF_CMD, SDCREN);
+	sd_config_write32(host, CNF_CTL_BASE, dev->resource[0].start & 0xfffe);
 
 	/* Tell the MFD core we are ready to be enabled */
 	if (cell->enable) {
@@ -593,13 +576,13 @@ static int __devinit tmio_mmc_probe(struct platform_device *dev)
 	}
 
 	/* Disable SD power during suspend */
-	tmio_iowrite8(0x01, host->cnf + CNF_PWR_CTL_3);
+	sd_config_write8(host, CNF_PWR_CTL_3, 0x01);
 
 	/* The below is required but why? FIXME */
-	tmio_iowrite8(0x1f, host->cnf + CNF_STOP_CLK_CTL);
+	sd_config_write8(host, CNF_STOP_CLK_CTL, 0x1f);
 
 	/* Power down SD bus*/
-	tmio_iowrite8(0x0,  host->cnf + CNF_PWR_CTL_2);
+	sd_config_write8(host, CNF_PWR_CTL_2, 0x00);
 
 	tmio_mmc_clk_stop(host);
 	reset(host);
@@ -610,7 +593,7 @@ static int __devinit tmio_mmc_probe(struct platform_device *dev)
 	else
 		goto unmap_cnf;
 
-	disable_mmc_irqs(host->ctl, TMIO_MASK_ALL);
+	disable_mmc_irqs(host, TMIO_MASK_ALL);
 
 	ret = request_irq(host->irq, tmio_mmc_irq, IRQF_DISABLED, "tmio-mmc",
 		host);
@@ -625,7 +608,7 @@ static int __devinit tmio_mmc_probe(struct platform_device *dev)
 	       (unsigned long)host->ctl, host->irq);
 
 	/* Unmask the IRQs we want to know about */
-	enable_mmc_irqs(host->ctl,  TMIO_MASK_IRQ);
+	enable_mmc_irqs(host, TMIO_MASK_IRQ);
 
 	return 0;
 
diff --git a/drivers/mmc/host/tmio_mmc.h b/drivers/mmc/host/tmio_mmc.h
index 9c831ab..9b97afa 100644
--- a/drivers/mmc/host/tmio_mmc.h
+++ b/drivers/mmc/host/tmio_mmc.h
@@ -83,34 +83,36 @@
 		TMIO_STAT_CARD_REMOVE | TMIO_STAT_CARD_INSERT)
 #define TMIO_MASK_IRQ     (TMIO_MASK_READOP | TMIO_MASK_WRITEOP | TMIO_MASK_CMD)
 
-#define enable_mmc_irqs(ctl, i) \
+
+#define enable_mmc_irqs(host, i) \
 	do { \
 		u32 mask;\
-		mask  = tmio_ioread32((ctl) + CTL_IRQ_MASK); \
+		mask  = sd_ctrl_read32((host), CTL_IRQ_MASK); \
 		mask &= ~((i) & TMIO_MASK_IRQ); \
-		tmio_iowrite32(mask, (ctl) + CTL_IRQ_MASK); \
+		sd_ctrl_write32((host), CTL_IRQ_MASK, mask); \
 	} while (0)
 
-#define disable_mmc_irqs(ctl, i) \
+#define disable_mmc_irqs(host, i) \
 	do { \
 		u32 mask;\
-		mask  = tmio_ioread32((ctl) + CTL_IRQ_MASK); \
+		mask  = sd_ctrl_read32((host), CTL_IRQ_MASK); \
 		mask |= ((i) & TMIO_MASK_IRQ); \
-		tmio_iowrite32(mask, (ctl) + CTL_IRQ_MASK); \
+		sd_ctrl_write32((host), CTL_IRQ_MASK, mask); \
 	} while (0)
 
-#define ack_mmc_irqs(ctl, i) \
+#define ack_mmc_irqs(host, i) \
 	do { \
 		u32 mask;\
-		mask  = tmio_ioread32((ctl) + CTL_STATUS); \
+		mask  = sd_ctrl_read32((host), CTL_STATUS); \
 		mask &= ~((i) & TMIO_MASK_IRQ); \
-		tmio_iowrite32(mask, (ctl) + CTL_STATUS); \
+		sd_ctrl_write32((host), CTL_STATUS, mask); \
 	} while (0)
 
 
 struct tmio_mmc_host {
 	void __iomem *cnf;
 	void __iomem *ctl;
+	unsigned long bus_shift;
 	struct mmc_command      *cmd;
 	struct mmc_request      *mrq;
 	struct mmc_data         *data;
@@ -123,6 +125,58 @@ struct tmio_mmc_host {
 	unsigned int            sg_off;
 };
 
+#include <linux/io.h>
+
+static inline u16 sd_ctrl_read16(struct tmio_mmc_host *host, int addr)
+{
+	return readw(host->ctl + (addr << host->bus_shift));
+}
+
+static inline void sd_ctrl_read16_rep(struct tmio_mmc_host *host, int addr,
+		u16 *buf, int count)
+{
+	readsw(host->ctl + (addr << host->bus_shift), buf, count);
+}
+
+static inline u32 sd_ctrl_read32(struct tmio_mmc_host *host, int addr)
+{
+	return readw(host->ctl + (addr << host->bus_shift)) |
+	       readw(host->ctl + ((addr + 2) << host->bus_shift)) << 16;
+}
+
+static inline void sd_ctrl_write16(struct tmio_mmc_host *host, int addr, u16 val)
+{
+	writew(val, host->ctl + (addr << host->bus_shift));
+}
+
+static inline void sd_ctrl_write16_rep(struct tmio_mmc_host *host, int addr,
+		u16 *buf, int count)
+{
+	writesw(host->ctl + (addr << host->bus_shift), buf, count);
+}
+
+static inline void sd_ctrl_write32(struct tmio_mmc_host *host, int addr, u32 val)
+{
+	writew(val, host->ctl + (addr << host->bus_shift));
+	writew(val >> 16, host->ctl + ((addr + 2) << host->bus_shift));
+}
+
+static inline void sd_config_write8(struct tmio_mmc_host *host, int addr, u8 val)
+{
+	writeb(val, host->cnf + (addr << host->bus_shift));
+}
+
+static inline void sd_config_write16(struct tmio_mmc_host *host, int addr, u16 val)
+{
+	writew(val, host->cnf + (addr << host->bus_shift));
+}
+
+static inline void sd_config_write32(struct tmio_mmc_host *host, int addr, u32 val)
+{
+	writew(val, host->cnf + (addr << host->bus_shift));
+	writew(val >> 16, host->cnf + ((addr + 2) << host->bus_shift));
+}
+
 #include <linux/scatterlist.h>
 #include <linux/blkdev.h>
 
-- 
1.6.3.1

