Return-Path: <linux-kernel-owner+w=401wt.eu-S1759330AbZBFSHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759330AbZBFSHY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 13:07:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758125AbZBFSGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 13:06:49 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:3189 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755682AbZBFSGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 13:06:48 -0500
Date: Fri, 6 Feb 2009 21:06:45 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Pierre Ossman <drzeus-sdhci@drzeus.cx>
Cc: Ben Dooks <ben-linux@fluff.org>, Arnd Bergmann <arnd@arndb.de>,
       Kumar Gala <galak@kernel.crashing.org>,
       Liu Dave <DaveLiu@freescale.com>, sdhci-devel@list.drzeus.cx,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: [PATCH 02/11] sdhci: Add support for bus-specific IO memory
	accessors
Message-ID: <20090206180645.GB11548@oksana.dev.rtsoft.ru>
References: <20090206180520.GA16123@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20090206180520.GA16123@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the SDHCI driver works with PCI accessors (write{l,b,w} and
read{l,b,w}).

With this patch drivers may change memory accessors, so that we can
support hosts with "weird" IO memory access requirments.

For example, in "FSL eSDHC" SDHCI hardware all registers are 32 bit
width, with big-endian addressing. That is, readb(0x2f) should turn
into readb(0x2c), and readw(0x2c) should be translated to
le16_to_cpu(readw(0x2e)).

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/mmc/host/sdhci-pci.c |    4 +-
 drivers/mmc/host/sdhci.c     |  205 +++++++++++++++++++++++++-----------------
 drivers/mmc/host/sdhci.h     |   48 ++++++++++
 3 files changed, 174 insertions(+), 83 deletions(-)

diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
index f07255c..a3ced4d 100644
--- a/drivers/mmc/host/sdhci-pci.c
+++ b/drivers/mmc/host/sdhci-pci.c
@@ -212,7 +212,7 @@ static int jmicron_probe_slot(struct sdhci_pci_slot *slot)
 	if (slot->chip->pdev->revision == 0) {
 		u16 version;
 
-		version = readl(slot->host->ioaddr + SDHCI_HOST_VERSION);
+		version = sdhci_readl(slot->host, SDHCI_HOST_VERSION);
 		version = (version & SDHCI_VENDOR_VER_MASK) >>
 			SDHCI_VENDOR_VER_SHIFT;
 
@@ -583,7 +583,7 @@ static void sdhci_pci_remove_slot(struct sdhci_pci_slot *slot)
 	u32 scratch;
 
 	dead = 0;
-	scratch = readl(slot->host->ioaddr + SDHCI_INT_STATUS);
+	scratch = sdhci_readl(slot->host, SDHCI_INT_STATUS);
 	if (scratch == (u32)-1)
 		dead = 1;
 
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 0a1f5c5..8557521 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -48,35 +48,35 @@ static void sdhci_dumpregs(struct sdhci_host *host)
 	printk(KERN_DEBUG DRIVER_NAME ": ============== REGISTER DUMP ==============\n");
 
 	printk(KERN_DEBUG DRIVER_NAME ": Sys addr: 0x%08x | Version:  0x%08x\n",
-		readl(host->ioaddr + SDHCI_DMA_ADDRESS),
-		readw(host->ioaddr + SDHCI_HOST_VERSION));
+		sdhci_readl(host, SDHCI_DMA_ADDRESS),
+		sdhci_readw(host, SDHCI_HOST_VERSION));
 	printk(KERN_DEBUG DRIVER_NAME ": Blk size: 0x%08x | Blk cnt:  0x%08x\n",
-		readw(host->ioaddr + SDHCI_BLOCK_SIZE),
-		readw(host->ioaddr + SDHCI_BLOCK_COUNT));
+		sdhci_readw(host, SDHCI_BLOCK_SIZE),
+		sdhci_readw(host, SDHCI_BLOCK_COUNT));
 	printk(KERN_DEBUG DRIVER_NAME ": Argument: 0x%08x | Trn mode: 0x%08x\n",
-		readl(host->ioaddr + SDHCI_ARGUMENT),
-		readw(host->ioaddr + SDHCI_TRANSFER_MODE));
+		sdhci_readl(host, SDHCI_ARGUMENT),
+		sdhci_readw(host, SDHCI_TRANSFER_MODE));
 	printk(KERN_DEBUG DRIVER_NAME ": Present:  0x%08x | Host ctl: 0x%08x\n",
-		readl(host->ioaddr + SDHCI_PRESENT_STATE),
-		readb(host->ioaddr + SDHCI_HOST_CONTROL));
+		sdhci_readl(host, SDHCI_PRESENT_STATE),
+		sdhci_readb(host, SDHCI_HOST_CONTROL));
 	printk(KERN_DEBUG DRIVER_NAME ": Power:    0x%08x | Blk gap:  0x%08x\n",
-		readb(host->ioaddr + SDHCI_POWER_CONTROL),
-		readb(host->ioaddr + SDHCI_BLOCK_GAP_CONTROL));
+		sdhci_readb(host, SDHCI_POWER_CONTROL),
+		sdhci_readb(host, SDHCI_BLOCK_GAP_CONTROL));
 	printk(KERN_DEBUG DRIVER_NAME ": Wake-up:  0x%08x | Clock:    0x%08x\n",
-		readb(host->ioaddr + SDHCI_WAKE_UP_CONTROL),
-		readw(host->ioaddr + SDHCI_CLOCK_CONTROL));
+		sdhci_readb(host, SDHCI_WAKE_UP_CONTROL),
+		sdhci_readw(host, SDHCI_CLOCK_CONTROL));
 	printk(KERN_DEBUG DRIVER_NAME ": Timeout:  0x%08x | Int stat: 0x%08x\n",
-		readb(host->ioaddr + SDHCI_TIMEOUT_CONTROL),
-		readl(host->ioaddr + SDHCI_INT_STATUS));
+		sdhci_readb(host, SDHCI_TIMEOUT_CONTROL),
+		sdhci_readl(host, SDHCI_INT_STATUS));
 	printk(KERN_DEBUG DRIVER_NAME ": Int enab: 0x%08x | Sig enab: 0x%08x\n",
-		readl(host->ioaddr + SDHCI_INT_ENABLE),
-		readl(host->ioaddr + SDHCI_SIGNAL_ENABLE));
+		sdhci_readl(host, SDHCI_INT_ENABLE),
+		sdhci_readl(host, SDHCI_SIGNAL_ENABLE));
 	printk(KERN_DEBUG DRIVER_NAME ": AC12 err: 0x%08x | Slot int: 0x%08x\n",
-		readw(host->ioaddr + SDHCI_ACMD12_ERR),
-		readw(host->ioaddr + SDHCI_SLOT_INT_STATUS));
+		sdhci_readw(host, SDHCI_ACMD12_ERR),
+		sdhci_readw(host, SDHCI_SLOT_INT_STATUS));
 	printk(KERN_DEBUG DRIVER_NAME ": Caps:     0x%08x | Max curr: 0x%08x\n",
-		readl(host->ioaddr + SDHCI_CAPABILITIES),
-		readl(host->ioaddr + SDHCI_MAX_CURRENT));
+		sdhci_readl(host, SDHCI_CAPABILITIES),
+		sdhci_readl(host, SDHCI_MAX_CURRENT));
 
 	printk(KERN_DEBUG DRIVER_NAME ": ===========================================\n");
 }
@@ -87,17 +87,47 @@ static void sdhci_dumpregs(struct sdhci_host *host)
  *                                                                           *
 \*****************************************************************************/
 
+static u32 sdhci_def_readl(struct sdhci_host *host, int reg)
+{
+	return readl(host->ioaddr + reg);
+}
+
+static u16 sdhci_def_readw(struct sdhci_host *host, int reg)
+{
+	return readw(host->ioaddr + reg);
+}
+
+static u8 sdhci_def_readb(struct sdhci_host *host, int reg)
+{
+	return readb(host->ioaddr + reg);
+}
+
+static void sdhci_def_writel(struct sdhci_host *host, u32 val, int reg)
+{
+	writel(val, host->ioaddr + reg);
+}
+
+static void sdhci_def_writew(struct sdhci_host *host, u16 val, int reg)
+{
+	writew(val, host->ioaddr + reg);
+}
+
+static void sdhci_def_writeb(struct sdhci_host *host, u8 val, int reg)
+{
+	writeb(val, host->ioaddr + reg);
+}
+
 static void sdhci_reset(struct sdhci_host *host, u8 mask)
 {
 	unsigned long timeout;
 
 	if (host->quirks & SDHCI_QUIRK_NO_CARD_NO_RESET) {
-		if (!(readl(host->ioaddr + SDHCI_PRESENT_STATE) &
+		if (!(sdhci_readl(host, SDHCI_PRESENT_STATE) &
 			SDHCI_CARD_PRESENT))
 			return;
 	}
 
-	writeb(mask, host->ioaddr + SDHCI_SOFTWARE_RESET);
+	sdhci_writeb(host, mask, SDHCI_SOFTWARE_RESET);
 
 	if (mask & SDHCI_RESET_ALL)
 		host->clock = 0;
@@ -106,7 +136,7 @@ static void sdhci_reset(struct sdhci_host *host, u8 mask)
 	timeout = 100;
 
 	/* hw clears the bit when it's done */
-	while (readb(host->ioaddr + SDHCI_SOFTWARE_RESET) & mask) {
+	while (sdhci_readb(host, SDHCI_SOFTWARE_RESET) & mask) {
 		if (timeout == 0) {
 			printk(KERN_ERR "%s: Reset 0x%x never completed.\n",
 				mmc_hostname(host->mmc), (int)mask);
@@ -132,26 +162,26 @@ static void sdhci_init(struct sdhci_host *host)
 		SDHCI_INT_DMA_END | SDHCI_INT_DATA_END | SDHCI_INT_RESPONSE |
 		SDHCI_INT_ADMA_ERROR;
 
-	writel(intmask, host->ioaddr + SDHCI_INT_ENABLE);
-	writel(intmask, host->ioaddr + SDHCI_SIGNAL_ENABLE);
+	sdhci_writel(host, intmask, SDHCI_INT_ENABLE);
+	sdhci_writel(host, intmask, SDHCI_SIGNAL_ENABLE);
 }
 
 static void sdhci_activate_led(struct sdhci_host *host)
 {
 	u8 ctrl;
 
-	ctrl = readb(host->ioaddr + SDHCI_HOST_CONTROL);
+	ctrl = sdhci_readb(host, SDHCI_HOST_CONTROL);
 	ctrl |= SDHCI_CTRL_LED;
-	writeb(ctrl, host->ioaddr + SDHCI_HOST_CONTROL);
+	sdhci_writeb(host, ctrl, SDHCI_HOST_CONTROL);
 }
 
 static void sdhci_deactivate_led(struct sdhci_host *host)
 {
 	u8 ctrl;
 
-	ctrl = readb(host->ioaddr + SDHCI_HOST_CONTROL);
+	ctrl = sdhci_readb(host, SDHCI_HOST_CONTROL);
 	ctrl &= ~SDHCI_CTRL_LED;
-	writeb(ctrl, host->ioaddr + SDHCI_HOST_CONTROL);
+	sdhci_writeb(host, ctrl, SDHCI_HOST_CONTROL);
 }
 
 #ifdef SDHCI_USE_LEDS_CLASS
@@ -205,7 +235,7 @@ static void sdhci_read_block_pio(struct sdhci_host *host)
 
 		while (len) {
 			if (chunk == 0) {
-				scratch = readl(host->ioaddr + SDHCI_BUFFER);
+				scratch = sdhci_readl(host, SDHCI_BUFFER);
 				chunk = 4;
 			}
 
@@ -257,7 +287,7 @@ static void sdhci_write_block_pio(struct sdhci_host *host)
 			len--;
 
 			if ((chunk == 4) || ((len == 0) && (blksize == 0))) {
-				writel(scratch, host->ioaddr + SDHCI_BUFFER);
+				sdhci_writel(host, scratch, SDHCI_BUFFER);
 				chunk = 0;
 				scratch = 0;
 			}
@@ -292,7 +322,7 @@ static void sdhci_transfer_pio(struct sdhci_host *host)
 		(host->data->blocks == 1))
 		mask = ~0;
 
-	while (readl(host->ioaddr + SDHCI_PRESENT_STATE) & mask) {
+	while (sdhci_readl(host, SDHCI_PRESENT_STATE) & mask) {
 		if (host->data->flags & MMC_DATA_READ)
 			sdhci_read_block_pio(host);
 		else
@@ -581,7 +611,7 @@ static void sdhci_prepare_data(struct sdhci_host *host, struct mmc_data *data)
 	host->data_early = 0;
 
 	count = sdhci_calc_timeout(host, data);
-	writeb(count, host->ioaddr + SDHCI_TIMEOUT_CONTROL);
+	sdhci_writeb(host, count, SDHCI_TIMEOUT_CONTROL);
 
 	if (host->flags & SDHCI_USE_DMA)
 		host->flags |= SDHCI_REQ_USE_DMA;
@@ -661,8 +691,8 @@ static void sdhci_prepare_data(struct sdhci_host *host, struct mmc_data *data)
 				WARN_ON(1);
 				host->flags &= ~SDHCI_REQ_USE_DMA;
 			} else {
-				writel(host->adma_addr,
-					host->ioaddr + SDHCI_ADMA_ADDRESS);
+				sdhci_writel(host, host->adma_addr,
+					SDHCI_ADMA_ADDRESS);
 			}
 		} else {
 			int sg_cnt;
@@ -681,8 +711,8 @@ static void sdhci_prepare_data(struct sdhci_host *host, struct mmc_data *data)
 				host->flags &= ~SDHCI_REQ_USE_DMA;
 			} else {
 				WARN_ON(sg_cnt != 1);
-				writel(sg_dma_address(data->sg),
-					host->ioaddr + SDHCI_DMA_ADDRESS);
+				sdhci_writel(host, sg_dma_address(data->sg),
+					SDHCI_DMA_ADDRESS);
 			}
 		}
 	}
@@ -693,14 +723,14 @@ static void sdhci_prepare_data(struct sdhci_host *host, struct mmc_data *data)
 	 * is ADMA.
 	 */
 	if (host->version >= SDHCI_SPEC_200) {
-		ctrl = readb(host->ioaddr + SDHCI_HOST_CONTROL);
+		ctrl = sdhci_readb(host, SDHCI_HOST_CONTROL);
 		ctrl &= ~SDHCI_CTRL_DMA_MASK;
 		if ((host->flags & SDHCI_REQ_USE_DMA) &&
 			(host->flags & SDHCI_USE_ADMA))
 			ctrl |= SDHCI_CTRL_ADMA32;
 		else
 			ctrl |= SDHCI_CTRL_SDMA;
-		writeb(ctrl, host->ioaddr + SDHCI_HOST_CONTROL);
+		sdhci_writeb(host, ctrl, SDHCI_HOST_CONTROL);
 	}
 
 	if (!(host->flags & SDHCI_REQ_USE_DMA)) {
@@ -710,9 +740,8 @@ static void sdhci_prepare_data(struct sdhci_host *host, struct mmc_data *data)
 	}
 
 	/* We do not handle DMA boundaries, so set it to max (512 KiB) */
-	writew(SDHCI_MAKE_BLKSZ(7, data->blksz),
-		host->ioaddr + SDHCI_BLOCK_SIZE);
-	writew(data->blocks, host->ioaddr + SDHCI_BLOCK_COUNT);
+	sdhci_writew(host, SDHCI_MAKE_BLKSZ(7, data->blksz), SDHCI_BLOCK_SIZE);
+	sdhci_writew(host, data->blocks, SDHCI_BLOCK_COUNT);
 }
 
 static void sdhci_set_transfer_mode(struct sdhci_host *host,
@@ -733,7 +762,7 @@ static void sdhci_set_transfer_mode(struct sdhci_host *host,
 	if (host->flags & SDHCI_REQ_USE_DMA)
 		mode |= SDHCI_TRNS_DMA;
 
-	writew(mode, host->ioaddr + SDHCI_TRANSFER_MODE);
+	sdhci_writew(host, mode, SDHCI_TRANSFER_MODE);
 }
 
 static void sdhci_finish_data(struct sdhci_host *host)
@@ -802,7 +831,7 @@ static void sdhci_send_command(struct sdhci_host *host, struct mmc_command *cmd)
 	if (host->mrq->data && (cmd == host->mrq->data->stop))
 		mask &= ~SDHCI_DATA_INHIBIT;
 
-	while (readl(host->ioaddr + SDHCI_PRESENT_STATE) & mask) {
+	while (sdhci_readl(host, SDHCI_PRESENT_STATE) & mask) {
 		if (timeout == 0) {
 			printk(KERN_ERR "%s: Controller never released "
 				"inhibit bit(s).\n", mmc_hostname(host->mmc));
@@ -821,7 +850,7 @@ static void sdhci_send_command(struct sdhci_host *host, struct mmc_command *cmd)
 
 	sdhci_prepare_data(host, cmd->data);
 
-	writel(cmd->arg, host->ioaddr + SDHCI_ARGUMENT);
+	sdhci_writel(host, cmd->arg, SDHCI_ARGUMENT);
 
 	sdhci_set_transfer_mode(host, cmd->data);
 
@@ -849,8 +878,7 @@ static void sdhci_send_command(struct sdhci_host *host, struct mmc_command *cmd)
 	if (cmd->data)
 		flags |= SDHCI_CMD_DATA;
 
-	writew(SDHCI_MAKE_CMD(cmd->opcode, flags),
-		host->ioaddr + SDHCI_COMMAND);
+	sdhci_writew(host, SDHCI_MAKE_CMD(cmd->opcode, flags), SDHCI_COMMAND);
 }
 
 static void sdhci_finish_command(struct sdhci_host *host)
@@ -863,15 +891,15 @@ static void sdhci_finish_command(struct sdhci_host *host)
 		if (host->cmd->flags & MMC_RSP_136) {
 			/* CRC is stripped so we need to do some shifting. */
 			for (i = 0;i < 4;i++) {
-				host->cmd->resp[i] = readl(host->ioaddr +
+				host->cmd->resp[i] = sdhci_readl(host,
 					SDHCI_RESPONSE + (3-i)*4) << 8;
 				if (i != 3)
 					host->cmd->resp[i] |=
-						readb(host->ioaddr +
+						sdhci_readb(host,
 						SDHCI_RESPONSE + (3-i)*4-1);
 			}
 		} else {
-			host->cmd->resp[0] = readl(host->ioaddr + SDHCI_RESPONSE);
+			host->cmd->resp[0] = sdhci_readl(host, SDHCI_RESPONSE);
 		}
 	}
 
@@ -895,7 +923,7 @@ static void sdhci_set_clock(struct sdhci_host *host, unsigned int clock)
 	if (clock == host->clock)
 		return;
 
-	writew(0, host->ioaddr + SDHCI_CLOCK_CONTROL);
+	sdhci_writew(host, 0, SDHCI_CLOCK_CONTROL);
 
 	if (clock == 0)
 		goto out;
@@ -908,11 +936,11 @@ static void sdhci_set_clock(struct sdhci_host *host, unsigned int clock)
 
 	clk = div << SDHCI_DIVIDER_SHIFT;
 	clk |= SDHCI_CLOCK_INT_EN;
-	writew(clk, host->ioaddr + SDHCI_CLOCK_CONTROL);
+	sdhci_writew(host, clk, SDHCI_CLOCK_CONTROL);
 
 	/* Wait max 10 ms */
 	timeout = 10;
-	while (!((clk = readw(host->ioaddr + SDHCI_CLOCK_CONTROL))
+	while (!((clk = sdhci_readw(host, SDHCI_CLOCK_CONTROL))
 		& SDHCI_CLOCK_INT_STABLE)) {
 		if (timeout == 0) {
 			printk(KERN_ERR "%s: Internal clock never "
@@ -925,7 +953,7 @@ static void sdhci_set_clock(struct sdhci_host *host, unsigned int clock)
 	}
 
 	clk |= SDHCI_CLOCK_CARD_EN;
-	writew(clk, host->ioaddr + SDHCI_CLOCK_CONTROL);
+	sdhci_writew(host, clk, SDHCI_CLOCK_CONTROL);
 
 out:
 	host->clock = clock;
@@ -939,7 +967,7 @@ static void sdhci_set_power(struct sdhci_host *host, unsigned short power)
 		return;
 
 	if (power == (unsigned short)-1) {
-		writeb(0, host->ioaddr + SDHCI_POWER_CONTROL);
+		sdhci_writeb(host, 0, SDHCI_POWER_CONTROL);
 		goto out;
 	}
 
@@ -948,7 +976,7 @@ static void sdhci_set_power(struct sdhci_host *host, unsigned short power)
 	 * a new value. Some controllers don't seem to like this though.
 	 */
 	if (!(host->quirks & SDHCI_QUIRK_SINGLE_POWER_WRITE))
-		writeb(0, host->ioaddr + SDHCI_POWER_CONTROL);
+		sdhci_writeb(host, 0, SDHCI_POWER_CONTROL);
 
 	pwr = SDHCI_POWER_ON;
 
@@ -973,10 +1001,9 @@ static void sdhci_set_power(struct sdhci_host *host, unsigned short power)
 	 * and set turn on power at the same time, so set the voltage first.
 	 */
 	if ((host->quirks & SDHCI_QUIRK_NO_SIMULT_VDD_AND_POWER))
-		writeb(pwr & ~SDHCI_POWER_ON,
-				host->ioaddr + SDHCI_POWER_CONTROL);
+		sdhci_writeb(host, pwr & ~SDHCI_POWER_ON, SDHCI_POWER_CONTROL);
 
-	writeb(pwr, host->ioaddr + SDHCI_POWER_CONTROL);
+	sdhci_writeb(host, pwr, SDHCI_POWER_CONTROL);
 
 out:
 	host->power = power;
@@ -1005,7 +1032,7 @@ static void sdhci_request(struct mmc_host *mmc, struct mmc_request *mrq)
 
 	host->mrq = mrq;
 
-	if (!(readl(host->ioaddr + SDHCI_PRESENT_STATE) & SDHCI_CARD_PRESENT)
+	if (!(sdhci_readl(host, SDHCI_PRESENT_STATE) & SDHCI_CARD_PRESENT)
 		|| (host->flags & SDHCI_DEVICE_DEAD)) {
 		host->mrq->cmd->error = -ENOMEDIUM;
 		tasklet_schedule(&host->finish_tasklet);
@@ -1034,7 +1061,7 @@ static void sdhci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 	 * Should clear out any weird states.
 	 */
 	if (ios->power_mode == MMC_POWER_OFF) {
-		writel(0, host->ioaddr + SDHCI_SIGNAL_ENABLE);
+		sdhci_writel(host, 0, SDHCI_SIGNAL_ENABLE);
 		sdhci_init(host);
 	}
 
@@ -1045,7 +1072,7 @@ static void sdhci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 	else
 		sdhci_set_power(host, ios->vdd);
 
-	ctrl = readb(host->ioaddr + SDHCI_HOST_CONTROL);
+	ctrl = sdhci_readb(host, SDHCI_HOST_CONTROL);
 
 	if (ios->bus_width == MMC_BUS_WIDTH_4)
 		ctrl |= SDHCI_CTRL_4BITBUS;
@@ -1057,7 +1084,7 @@ static void sdhci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 	else
 		ctrl &= ~SDHCI_CTRL_HISPD;
 
-	writeb(ctrl, host->ioaddr + SDHCI_HOST_CONTROL);
+	sdhci_writeb(host, ctrl, SDHCI_HOST_CONTROL);
 
 	/*
 	 * Some (ENE) controllers go apeshit on some ios operation,
@@ -1085,7 +1112,7 @@ static int sdhci_get_ro(struct mmc_host *mmc)
 	if (host->flags & SDHCI_DEVICE_DEAD)
 		present = 0;
 	else
-		present = readl(host->ioaddr + SDHCI_PRESENT_STATE);
+		present = sdhci_readl(host, SDHCI_PRESENT_STATE);
 
 	spin_unlock_irqrestore(&host->lock, flags);
 
@@ -1105,14 +1132,14 @@ static void sdhci_enable_sdio_irq(struct mmc_host *mmc, int enable)
 	if (host->flags & SDHCI_DEVICE_DEAD)
 		goto out;
 
-	ier = readl(host->ioaddr + SDHCI_INT_ENABLE);
+	ier = sdhci_readl(host, SDHCI_INT_ENABLE);
 
 	ier &= ~SDHCI_INT_CARD_INT;
 	if (enable)
 		ier |= SDHCI_INT_CARD_INT;
 
-	writel(ier, host->ioaddr + SDHCI_INT_ENABLE);
-	writel(ier, host->ioaddr + SDHCI_SIGNAL_ENABLE);
+	sdhci_writel(host, ier, SDHCI_INT_ENABLE);
+	sdhci_writel(host, ier, SDHCI_SIGNAL_ENABLE);
 
 out:
 	mmiowb();
@@ -1142,7 +1169,7 @@ static void sdhci_tasklet_card(unsigned long param)
 
 	spin_lock_irqsave(&host->lock, flags);
 
-	if (!(readl(host->ioaddr + SDHCI_PRESENT_STATE) & SDHCI_CARD_PRESENT)) {
+	if (!(sdhci_readl(host, SDHCI_PRESENT_STATE) & SDHCI_CARD_PRESENT)) {
 		if (host->mrq) {
 			printk(KERN_ERR "%s: Card removed during transfer!\n",
 				mmc_hostname(host->mmc));
@@ -1346,8 +1373,8 @@ static void sdhci_data_irq(struct sdhci_host *host, u32 intmask)
 		 * we need to at least restart the transfer.
 		 */
 		if (intmask & SDHCI_INT_DMA_END)
-			writel(readl(host->ioaddr + SDHCI_DMA_ADDRESS),
-				host->ioaddr + SDHCI_DMA_ADDRESS);
+			sdhci_writel(host, sdhci_readl(host, SDHCI_DMA_ADDRESS),
+				SDHCI_DMA_ADDRESS);
 
 		if (intmask & SDHCI_INT_DATA_END) {
 			if (host->cmd) {
@@ -1373,7 +1400,7 @@ static irqreturn_t sdhci_irq(int irq, void *dev_id)
 
 	spin_lock(&host->lock);
 
-	intmask = readl(host->ioaddr + SDHCI_INT_STATUS);
+	intmask = sdhci_readl(host, SDHCI_INT_STATUS);
 
 	if (!intmask || intmask == 0xffffffff) {
 		result = IRQ_NONE;
@@ -1384,22 +1411,22 @@ static irqreturn_t sdhci_irq(int irq, void *dev_id)
 		mmc_hostname(host->mmc), intmask);
 
 	if (intmask & (SDHCI_INT_CARD_INSERT | SDHCI_INT_CARD_REMOVE)) {
-		writel(intmask & (SDHCI_INT_CARD_INSERT | SDHCI_INT_CARD_REMOVE),
-			host->ioaddr + SDHCI_INT_STATUS);
+		sdhci_writel(host, intmask & (SDHCI_INT_CARD_INSERT |
+			SDHCI_INT_CARD_REMOVE), SDHCI_INT_STATUS);
 		tasklet_schedule(&host->card_tasklet);
 	}
 
 	intmask &= ~(SDHCI_INT_CARD_INSERT | SDHCI_INT_CARD_REMOVE);
 
 	if (intmask & SDHCI_INT_CMD_MASK) {
-		writel(intmask & SDHCI_INT_CMD_MASK,
-			host->ioaddr + SDHCI_INT_STATUS);
+		sdhci_writel(host, intmask & SDHCI_INT_CMD_MASK,
+			SDHCI_INT_STATUS);
 		sdhci_cmd_irq(host, intmask & SDHCI_INT_CMD_MASK);
 	}
 
 	if (intmask & SDHCI_INT_DATA_MASK) {
-		writel(intmask & SDHCI_INT_DATA_MASK,
-			host->ioaddr + SDHCI_INT_STATUS);
+		sdhci_writel(host, intmask & SDHCI_INT_DATA_MASK,
+			SDHCI_INT_STATUS);
 		sdhci_data_irq(host, intmask & SDHCI_INT_DATA_MASK);
 	}
 
@@ -1410,7 +1437,7 @@ static irqreturn_t sdhci_irq(int irq, void *dev_id)
 	if (intmask & SDHCI_INT_BUS_POWER) {
 		printk(KERN_ERR "%s: Card is consuming too much power!\n",
 			mmc_hostname(host->mmc));
-		writel(SDHCI_INT_BUS_POWER, host->ioaddr + SDHCI_INT_STATUS);
+		sdhci_writel(host, SDHCI_INT_BUS_POWER, SDHCI_INT_STATUS);
 	}
 
 	intmask &= ~SDHCI_INT_BUS_POWER;
@@ -1425,7 +1452,7 @@ static irqreturn_t sdhci_irq(int irq, void *dev_id)
 			mmc_hostname(host->mmc), intmask);
 		sdhci_dumpregs(host);
 
-		writel(intmask, host->ioaddr + SDHCI_INT_STATUS);
+		sdhci_writel(host, intmask, SDHCI_INT_STATUS);
 	}
 
 	result = IRQ_HANDLED;
@@ -1535,9 +1562,25 @@ int sdhci_add_host(struct sdhci_host *host)
 	if (debug_quirks)
 		host->quirks = debug_quirks;
 
+	if (host->ops->readl) {
+		host->readl = host->ops->readl;
+		host->readw = host->ops->readw;
+		host->readb = host->ops->readb;
+		host->writel = host->ops->writel;
+		host->writew = host->ops->writew;
+		host->writeb = host->ops->writeb;
+	} else {
+		host->readl = sdhci_def_readl;
+		host->readw = sdhci_def_readw;
+		host->readb = sdhci_def_readb;
+		host->writel = sdhci_def_writel;
+		host->writew = sdhci_def_writew;
+		host->writeb = sdhci_def_writeb;
+	}
+
 	sdhci_reset(host, SDHCI_RESET_ALL);
 
-	host->version = readw(host->ioaddr + SDHCI_HOST_VERSION);
+	host->version = sdhci_readw(host, SDHCI_HOST_VERSION);
 	host->version = (host->version & SDHCI_SPEC_VER_MASK)
 				>> SDHCI_SPEC_VER_SHIFT;
 	if (host->version > SDHCI_SPEC_200) {
@@ -1546,7 +1589,7 @@ int sdhci_add_host(struct sdhci_host *host)
 			host->version);
 	}
 
-	caps = readl(host->ioaddr + SDHCI_CAPABILITIES);
+	caps = sdhci_readl(host, SDHCI_CAPABILITIES);
 
 	if (host->quirks & SDHCI_QUIRK_FORCE_DMA)
 		host->flags |= SDHCI_USE_DMA;
diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
index 2d08dd4..8e4c4a6 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -9,6 +9,7 @@
  * your option) any later version.
  */
 
+#include <linux/types.h>
 #include <linux/scatterlist.h>
 
 /*
@@ -263,14 +264,61 @@ struct sdhci_host {
 
 	struct timer_list	timer;		/* Timer for timeouts */
 
+	/*
+	 * We have to duplicate a part of `struct sdhci_ops' since ->ops are
+	 * const, so the sdhci core won't able to assign default ops.
+	 */
+	u32		(*readl)(struct sdhci_host *host, int reg);
+	u16		(*readw)(struct sdhci_host *host, int reg);
+	u8		(*readb)(struct sdhci_host *host, int reg);
+	void		(*writel)(struct sdhci_host *host, u32 val, int reg);
+	void		(*writew)(struct sdhci_host *host, u16 val, int reg);
+	void		(*writeb)(struct sdhci_host *host, u8 val, int reg);
+
 	unsigned long		private[0] ____cacheline_aligned;
 };
 
 
 struct sdhci_ops {
+	u32		(*readl)(struct sdhci_host *host, int reg);
+	u16		(*readw)(struct sdhci_host *host, int reg);
+	u8		(*readb)(struct sdhci_host *host, int reg);
+	void		(*writel)(struct sdhci_host *host, u32 val, int reg);
+	void		(*writew)(struct sdhci_host *host, u16 val, int reg);
+	void		(*writeb)(struct sdhci_host *host, u8 val, int reg);
+
 	int		(*enable_dma)(struct sdhci_host *host);
 };
 
+static inline void sdhci_writel(struct sdhci_host *host, u32 val, int reg)
+{
+	host->writel(host, val, reg);
+}
+
+static inline void sdhci_writew(struct sdhci_host *host, u16 val, int reg)
+{
+	host->writew(host, val, reg);
+}
+
+static inline void sdhci_writeb(struct sdhci_host *host, u8 val, int reg)
+{
+	host->writeb(host, val, reg);
+}
+
+static inline u32 sdhci_readl(struct sdhci_host *host, int reg)
+{
+	return host->readl(host, reg);
+}
+
+static inline u16 sdhci_readw(struct sdhci_host *host, int reg)
+{
+	return host->readw(host, reg);
+}
+
+static inline u8 sdhci_readb(struct sdhci_host *host, int reg)
+{
+	return host->readb(host, reg);
+}
 
 extern struct sdhci_host *sdhci_alloc_host(struct device *dev,
 	size_t priv_size);
-- 
1.5.6.5

