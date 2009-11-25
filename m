Return-Path: <linux-kernel-owner+w=401wt.eu-S935148AbZKYWFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935148AbZKYWFF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 17:05:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933739AbZKYWFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 17:05:04 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34825 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933587AbZKYWFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 17:05:01 -0500
Date: Wed, 25 Nov 2009 14:04:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: <cliffcai.sh@gmail.com>
Cc: <linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       <cliff.cai@analog.com>, Bryan Wu <cooloney@kernel.org>,
       Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH v4][mmc/host]:Blackfin SD Host Controller Driver
Message-Id: <20091125140422.cdee4a0d.akpm@linux-foundation.org>
In-Reply-To: <1259162390-378-1-git-send-email-cliffcai.sh@gmail.com>
References: <1259162390-378-1-git-send-email-cliffcai.sh@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Nov 2009 23:19:50 +0800
<cliffcai.sh@gmail.com> wrote:

> From: Cliff Cai <cliffcai.sh@gmail.com>
> 
> Add SD host driver for Blackfin BF54x and BF51x.
> 
> Signed-off-by: Cliff Cai <cliffcai.sh@gmail.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
>
> ...
>
>
> +config SDH_BFIN
> +    tristate "Blackfin Secure Digital Host support"
> +    depends on MMC && ((BF54x && !BF544) || (BF51x && !BF512))
> +    help
> +      If you say yes here you will get support for the Blackfin on-chip
> +      Secure Digital Host interface.  This includes support for MMC and
> +      SD cards.
> +
> +      To compile this driver as a module, choose M here: the
> +      module will be called bfin_sdh.
> +
> +      If unsure, say N.
> +
> +config SDH_BFIN_MISSING_CMD_PULLUP_WORKAROUND
> +    bool "Blackfin EZkit Missing SDH_CMD Pull Up Resistor Workaround"
> +    depends on SDH_BFIN
> +    help
> +      If you say yes here SD-Cards may work on the EZkit.

Indenting is all mangled.

>
> ...
>
> +struct dma_desc_array {
> +	unsigned long	start_addr;
> +	unsigned short	cfg;
> +	unsigned short	x_count;
> +	short		x_modify;
> +} __attribute__((packed));

__packed is preferred.

> +struct sdh_host {
> +	struct mmc_host		*mmc;
> +	spinlock_t		lock;
> +	struct resource		*res;
> +	void __iomem		*base;
> +	int			irq;
> +	int			stat_irq;
> +	int			dma_ch;
> +	int			dma_dir;
> +	struct dma_desc_array	*sg_cpu;
> +	dma_addr_t		sg_dma;
> +	int			dma_len;
> +
> +	unsigned int		imask;
> +	unsigned int		power_mode;
> +	unsigned int		clk_div;
> +
> +	struct mmc_request	*mrq;
> +	struct mmc_command	*cmd;
> +	struct mmc_data		*data;
> +};
>
> ...
>
> +static int sdh_setup_data(struct sdh_host *host, struct mmc_data *data)
> +{
> +	unsigned int length;
> +	unsigned int data_ctl;
> +	unsigned int dma_cfg;
> +	struct scatterlist *sg;
> +
> +	dev_dbg(mmc_dev(host->mmc), "%s enter flags: 0x%x\n", __func__, data->flags);
> +	host->data = data;
> +	data_ctl = 0;
> +	dma_cfg = 0;
> +
> +	length = data->blksz * data->blocks;
> +	bfin_write_SDH_DATA_LGTH(length);
> +
> +	if (data->flags & MMC_DATA_STREAM)
> +		data_ctl |= DTX_MODE;
> +
> +	if (data->flags & MMC_DATA_READ)
> +		data_ctl |= DTX_DIR;
> +	/* Only supports power-of-2 block size */
> +	if (data->blksz & (data->blksz - 1))
> +		return -EINVAL;
> +	data_ctl |= ((ffs(data->blksz) - 1) << 4);
> +
> +	bfin_write_SDH_DATA_CTL(data_ctl);
> +
> +	bfin_write_SDH_DATA_TIMER(0xFFFF);
> +	SSYNC();
> +
> +	if (data->flags & MMC_DATA_READ) {
> +		host->dma_dir = DMA_FROM_DEVICE;
> +		dma_cfg |= WNR;
> +	} else
> +		host->dma_dir = DMA_TO_DEVICE;
> +
> +	sdh_enable_stat_irq(host, (DAT_CRC_FAIL | DAT_TIME_OUT | DAT_END));
> +	host->dma_len = dma_map_sg(mmc_dev(host->mmc), data->sg, data->sg_len, host->dma_dir);
> +#if defined(CONFIG_BF54x)
> +	int i;

This is going to generate a compiler warning.  We don't use the c99
declaration form in kernel code.

> +	dma_cfg |= DMAFLOW_ARRAY | NDSIZE_5 | RESTART | WDSIZE_32 | DMAEN;
> +	for_each_sg(data->sg, sg, host->dma_len, i) {
> +		host->sg_cpu[i].start_addr = sg_dma_address(sg);
> +		host->sg_cpu[i].cfg = dma_cfg;
> +		host->sg_cpu[i].x_count = sg_dma_len(sg) / 4;
> +		host->sg_cpu[i].x_modify = 4;
> +		dev_dbg(mmc_dev(host->mmc), "%d: start_addr:0x%lx, cfg:0x%x, x_count:0x%x,\
> +				x_modify:0x%x\n", i, host->sg_cpu[i].start_addr,
> +				host->sg_cpu[i].cfg, host->sg_cpu[i].x_count,
> +				host->sg_cpu[i].x_modify);
> +	}
> +	flush_dcache_range((unsigned int)host->sg_cpu,
> +		(unsigned int)host->sg_cpu +
> +			host->dma_len * sizeof(struct dma_desc_array));
> +	/* Set the last descriptor to stop mode */
> +	host->sg_cpu[host->dma_len - 1].cfg &= ~(DMAFLOW | NDSIZE);
> +	host->sg_cpu[host->dma_len - 1].cfg |= DI_EN;
> +
> +	set_dma_curr_desc_addr(host->dma_ch, (unsigned long *)host->sg_dma);
> +	set_dma_x_count(host->dma_ch, 0);
> +	set_dma_x_modify(host->dma_ch, 0);
> +	set_dma_config(host->dma_ch, dma_cfg);
> +#elif defined(CONFIG_BF51x)
> +	/* RSI DMA doesn't work in array mode */
> +	dma_cfg |= WDSIZE_32 | DMAEN;
> +	set_dma_start_addr(host->dma_ch, sg_dma_address(&data->sg[0]));
> +	set_dma_x_count(host->dma_ch, length / 4);
> +	set_dma_x_modify(host->dma_ch, 4);
> +	set_dma_config(host->dma_ch, dma_cfg);
> +#endif
> +	bfin_write_SDH_DATA_CTL(bfin_read_SDH_DATA_CTL() | DTX_DMA_E | DTX_E);
> +
> +	SSYNC();
> +
> +	dev_dbg(mmc_dev(host->mmc), "%s exit\n", __func__);
> +	return 0;
> +}
> +
> +static void sdh_start_cmd(struct sdh_host *host, struct mmc_command *cmd)
> +{
> +	unsigned int sdh_cmd;
> +	unsigned int stat_mask;
> +
> +	dev_dbg(mmc_dev(host->mmc), "%s enter cmd: 0x%p\n", __func__, cmd);
> +	WARN_ON(host->cmd != NULL);
> +	host->cmd = cmd;
> +
> +	sdh_cmd = 0;
> +	stat_mask = 0;
> +
> +	sdh_cmd |= cmd->opcode;
> +
> +	if (cmd->flags & MMC_RSP_PRESENT) {
> +		sdh_cmd |= CMD_RSP;
> +		stat_mask |= CMD_RESP_END;
> +	} else
> +		stat_mask |= CMD_SENT;

Arguably wrong from a coding-style POV and looks weird IMO.  Adds a bit
of risk that subsequent coders will think they're writing in python adn
will add bugs.

> +	if (cmd->flags & MMC_RSP_136)
> +		sdh_cmd |= CMD_L_RSP;
> +
> +	stat_mask |= CMD_CRC_FAIL | CMD_TIME_OUT;
> +
> +	sdh_enable_stat_irq(host, stat_mask);
> +
> +	bfin_write_SDH_ARGUMENT(cmd->arg);
> +	bfin_write_SDH_COMMAND(sdh_cmd | CMD_E);
> +	bfin_write_SDH_CLK_CTL(bfin_read_SDH_CLK_CTL() | CLK_E);
> +	SSYNC();
> +}
> +
>
> ...
>
> +static irqreturn_t sdh_stat_irq(int irq, void *devid)
> +{
> +	struct sdh_host *host = devid;
> +	unsigned int status;
> +	int handled = 0;
> +
> +	dev_dbg(mmc_dev(host->mmc), "%s enter\n", __func__);
> +	status = bfin_read_SDH_E_STATUS();
> +	if (status & SD_CARD_DET) {
> +		mmc_detect_change(host->mmc, 0);
> +		bfin_write_SDH_E_STATUS(SD_CARD_DET);
> +	}
> +	status = bfin_read_SDH_STATUS();
> +	if (status & (CMD_SENT | CMD_RESP_END | CMD_TIME_OUT | CMD_CRC_FAIL)) {
> +		handled |= sdh_cmd_done(host, status);
> +		bfin_write_SDH_STATUS_CLR( CMD_SENT_STAT | CMD_RESP_END_STAT | \
> +				CMD_TIMEOUT_STAT | CMD_CRC_FAIL_STAT);

Please always use scripts/checkpatch.pl.

> +		SSYNC();
> +	}
> +
> +	status = bfin_read_SDH_STATUS();
> +	if (status & (DAT_END | DAT_TIME_OUT | DAT_CRC_FAIL | RX_OVERRUN | TX_UNDERRUN))
> +		handled |= sdh_data_done(host, status);
> +
> +	dev_dbg(mmc_dev(host->mmc), "%s exit\n\n", __func__);
> +
> +	return IRQ_RETVAL(handled);
> +}
> +
>
> ...
>


Fixes:


diff -puN drivers/mmc/host/Kconfig~blackfin-sd-host-controller-driver-fix drivers/mmc/host/Kconfig
--- a/drivers/mmc/host/Kconfig~blackfin-sd-host-controller-driver-fix
+++ a/drivers/mmc/host/Kconfig
@@ -367,20 +367,20 @@ config MMC_VIA_SDMMC
 	  If unsure, say N.
 
 config SDH_BFIN
-    tristate "Blackfin Secure Digital Host support"
-    depends on MMC && ((BF54x && !BF544) || (BF51x && !BF512))
-    help
-      If you say yes here you will get support for the Blackfin on-chip
-      Secure Digital Host interface.  This includes support for MMC and
-      SD cards.
+	tristate "Blackfin Secure Digital Host support"
+	depends on MMC && ((BF54x && !BF544) || (BF51x && !BF512))
+	help
+	  If you say yes here you will get support for the Blackfin on-chip
+	  Secure Digital Host interface.  This includes support for MMC and
+	  SD cards.
 
-      To compile this driver as a module, choose M here: the
-      module will be called bfin_sdh.
+	  To compile this driver as a module, choose M here: the
+	  module will be called bfin_sdh.
 
-      If unsure, say N.
+	  If unsure, say N.
 
 config SDH_BFIN_MISSING_CMD_PULLUP_WORKAROUND
-    bool "Blackfin EZkit Missing SDH_CMD Pull Up Resistor Workaround"
-    depends on SDH_BFIN
-    help
-      If you say yes here SD-Cards may work on the EZkit.
+	bool "Blackfin EZkit Missing SDH_CMD Pull Up Resistor Workaround"
+	depends on SDH_BFIN
+	help
+	  If you say yes here SD-Cards may work on the EZkit.
diff -puN drivers/mmc/host/Makefile~blackfin-sd-host-controller-driver-fix drivers/mmc/host/Makefile
diff -puN drivers/mmc/host/bfin_sdh.c~blackfin-sd-host-controller-driver-fix drivers/mmc/host/bfin_sdh.c
--- a/drivers/mmc/host/bfin_sdh.c~blackfin-sd-host-controller-driver-fix
+++ a/drivers/mmc/host/bfin_sdh.c
@@ -53,7 +53,7 @@ struct dma_desc_array {
 	unsigned short	cfg;
 	unsigned short	x_count;
 	short		x_modify;
-} __attribute__((packed));
+} __packed;
 
 struct sdh_host {
 	struct mmc_host		*mmc;
@@ -149,15 +149,17 @@ static int sdh_setup_data(struct sdh_hos
 	sdh_enable_stat_irq(host, (DAT_CRC_FAIL | DAT_TIME_OUT | DAT_END));
 	host->dma_len = dma_map_sg(mmc_dev(host->mmc), data->sg, data->sg_len, host->dma_dir);
 #if defined(CONFIG_BF54x)
-	int i;
 	dma_cfg |= DMAFLOW_ARRAY | NDSIZE_5 | RESTART | WDSIZE_32 | DMAEN;
-	for_each_sg(data->sg, sg, host->dma_len, i) {
-		host->sg_cpu[i].start_addr = sg_dma_address(sg);
-		host->sg_cpu[i].cfg = dma_cfg;
-		host->sg_cpu[i].x_count = sg_dma_len(sg) / 4;
-		host->sg_cpu[i].x_modify = 4;
-		dev_dbg(mmc_dev(host->mmc), "%d: start_addr:0x%lx, cfg:0x%x, x_count:0x%x,\
-				x_modify:0x%x\n", i, host->sg_cpu[i].start_addr,
+	{
+		int i;
+		for_each_sg(data->sg, sg, host->dma_len, i) {
+			host->sg_cpu[i].start_addr = sg_dma_address(sg);
+			host->sg_cpu[i].cfg = dma_cfg;
+			host->sg_cpu[i].x_count = sg_dma_len(sg) / 4;
+			host->sg_cpu[i].x_modify = 4;
+			dev_dbg(mmc_dev(host->mmc), "%d: start_addr:0x%lx, "
+				"cfg:0x%x, x_count:0x%x, x_modify:0x%x\n",
+				i, host->sg_cpu[i].start_addr,
 				host->sg_cpu[i].cfg, host->sg_cpu[i].x_count,
 				host->sg_cpu[i].x_modify);
 	}
@@ -205,8 +207,9 @@ static void sdh_start_cmd(struct sdh_hos
 	if (cmd->flags & MMC_RSP_PRESENT) {
 		sdh_cmd |= CMD_RSP;
 		stat_mask |= CMD_RESP_END;
-	} else
+	} else {
 		stat_mask |= CMD_SENT;
+	}
 
 	if (cmd->flags & MMC_RSP_136)
 		sdh_cmd |= CMD_L_RSP;
@@ -304,8 +307,9 @@ static int sdh_data_done(struct sdh_host
 	if (host->mrq->stop) {
 		sdh_stop_clock(host);
 		sdh_start_cmd(host, host->mrq->stop);
-	} else
+	} else }
 		sdh_finish_request(host, host->mrq);
+	}
 
 	return 1;
 }
@@ -425,7 +429,7 @@ static irqreturn_t sdh_stat_irq(int irq,
 	status = bfin_read_SDH_STATUS();
 	if (status & (CMD_SENT | CMD_RESP_END | CMD_TIME_OUT | CMD_CRC_FAIL)) {
 		handled |= sdh_cmd_done(host, status);
-		bfin_write_SDH_STATUS_CLR( CMD_SENT_STAT | CMD_RESP_END_STAT | \
+		bfin_write_SDH_STATUS_CLR(CMD_SENT_STAT | CMD_RESP_END_STAT | \
 				CMD_TIMEOUT_STAT | CMD_CRC_FAIL_STAT);
 		SSYNC();
 	}
_

