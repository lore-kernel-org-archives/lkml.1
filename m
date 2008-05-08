Return-Path: <linux-kernel-owner+w=401wt.eu-S1761963AbYEHIGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761963AbYEHIGV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 04:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755897AbYEHIF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 04:05:56 -0400
Received: from fnoeppeil48.netpark.at ([217.175.205.176]:34779 "EHLO
	roarinelk.homelinux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521AbYEHIFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 04:05:53 -0400
Date: Thu, 8 May 2008 10:05:50 +0200
From: Manuel Lauss <mano@roarinelk.homelinux.net>
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] au1xmmc: codingstyle tidying
Message-ID: <20080508080550.GH24383@roarinelk.homelinux.net>
References: <20080508080040.GA24383@roarinelk.homelinux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080508080040.GA24383@roarinelk.homelinux.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 4e439a8b70c5ab0ca36e7a653fbb1c19605e0ea6 Mon Sep 17 00:00:00 2001
From: Manuel Lauss <mlau@msc-ge.com>
Date: Wed, 7 May 2008 15:30:14 +0200
Subject: [PATCH] au1xmmc: codingstyle tidying

Make the driver source a bit easier on the eyes;
no functional changes.

Signed-off-by: Manuel Lauss <mano@roarinelk.homelinux.net>
---
 drivers/mmc/host/au1xmmc.c |  139 ++++++++++++++++---------------------------
 1 files changed, 52 insertions(+), 87 deletions(-)

diff --git a/drivers/mmc/host/au1xmmc.c b/drivers/mmc/host/au1xmmc.c
index 8b60509..3b9833f 100644
--- a/drivers/mmc/host/au1xmmc.c
+++ b/drivers/mmc/host/au1xmmc.c
@@ -160,7 +160,6 @@ static inline void IRQ_OFF(struct au1xmmc_host *host, u32 mask)
 
 static inline void SEND_STOP(struct au1xmmc_host *host)
 {
-
 	u32 config2;
 
 	WARN_ON(host->status != HOST_S_DATA);
@@ -280,18 +279,14 @@ static int au1xmmc_send_command(struct au1xmmc_host *host, int wait,
 	au_sync();
 
 	/* Wait for the command to go on the line */
-
-	while(1) {
-		if (!(au_readl(HOST_CMD(host)) & SD_CMD_GO))
-			break;
-	}
+	while (au_readl(HOST_CMD(host)) & SD_CMD_GO)
+		/* nop */;
 
 	/* Wait for the command to come back */
-
 	if (wait) {
 		u32 status = au_readl(HOST_STATUS(host));
 
-		while(!(status & SD_STATUS_CR))
+		while (!(status & SD_STATUS_CR))
 			status = au_readl(HOST_STATUS(host));
 
 		/* Clear the CR status */
@@ -305,12 +300,11 @@ static int au1xmmc_send_command(struct au1xmmc_host *host, int wait,
 
 static void au1xmmc_data_complete(struct au1xmmc_host *host, u32 status)
 {
-
 	struct mmc_request *mrq = host->mrq;
 	struct mmc_data *data;
 	u32 crc;
 
-	WARN_ON(host->status != HOST_S_DATA && host->status != HOST_S_STOP);
+	WARN_ON((host->status != HOST_S_DATA) && (host->status != HOST_S_STOP));
 
 	if (host->mrq == NULL)
 		return;
@@ -321,15 +315,13 @@ static void au1xmmc_data_complete(struct au1xmmc_host *host, u32 status)
 		status = au_readl(HOST_STATUS(host));
 
 	/* The transaction is really over when the SD_STATUS_DB bit is clear */
-
-	while((host->flags & HOST_F_XMIT) && (status & SD_STATUS_DB))
+	while ((host->flags & HOST_F_XMIT) && (status & SD_STATUS_DB))
 		status = au_readl(HOST_STATUS(host));
 
 	data->error = 0;
 	dma_unmap_sg(mmc_dev(host->mmc), data->sg, data->sg_len, host->dma.dir);
 
         /* Process any errors */
-
 	crc = (status & (SD_STATUS_WC | SD_STATUS_RC));
 	if (host->flags & HOST_F_XMIT)
 		crc |= ((status & 0x07) == 0x02) ? 0 : 1;
@@ -346,11 +338,10 @@ static void au1xmmc_data_complete(struct au1xmmc_host *host, u32 status)
 		if (host->flags & HOST_F_DMA) {
 			u32 chan = DMA_CHANNEL(host);
 
-			chan_tab_t *c = *((chan_tab_t **) chan);
+			chan_tab_t *c = *((chan_tab_t **)chan);
 			au1x_dma_chan_t *cp = c->chan_ptr;
 			data->bytes_xfered = cp->ddma_bytecnt;
-		}
-		else
+		} else
 			data->bytes_xfered =
 				(data->blocks * data->blksz) -
 				host->pio.len;
@@ -361,7 +352,7 @@ static void au1xmmc_data_complete(struct au1xmmc_host *host, u32 status)
 
 static void au1xmmc_tasklet_data(unsigned long param)
 {
-	struct au1xmmc_host *host = (struct au1xmmc_host *) param;
+	struct au1xmmc_host *host = (struct au1xmmc_host *)param;
 
 	u32 status = au_readl(HOST_STATUS(host));
 	au1xmmc_data_complete(host, status);
@@ -371,11 +362,10 @@ static void au1xmmc_tasklet_data(unsigned long param)
 
 static void au1xmmc_send_pio(struct au1xmmc_host *host)
 {
-
-	struct mmc_data *data = 0;
-	int sg_len, max, count = 0;
-	unsigned char *sg_ptr;
-	u32 status = 0;
+	struct mmc_data *data;
+	int sg_len, max, count;
+	unsigned char *sg_ptr, val;
+	u32 status;
 	struct scatterlist *sg;
 
 	data = host->mrq->data;
@@ -390,22 +380,19 @@ static void au1xmmc_send_pio(struct au1xmmc_host *host)
 	/* This is the space left inside the buffer */
 	sg_len = data->sg[host->pio.index].length - host->pio.offset;
 
-	/* Check to if we need less then the size of the sg_buffer */
-
+	/* Check if we need less than the size of the sg_buffer */
 	max = (sg_len > host->pio.len) ? host->pio.len : sg_len;
-	if (max > AU1XMMC_MAX_TRANSFER) max = AU1XMMC_MAX_TRANSFER;
-
-	for(count = 0; count < max; count++ ) {
-		unsigned char val;
+	if (max > AU1XMMC_MAX_TRANSFER)
+		max = AU1XMMC_MAX_TRANSFER;
 
+	for (count = 0; count < max; count++) {
 		status = au_readl(HOST_STATUS(host));
-
 		if (!(status & SD_STATUS_TH))
 			break;
 
 		val = *sg_ptr++;
 
-		au_writel((unsigned long) val, HOST_TXPORT(host));
+		au_writel((unsigned long)val, HOST_TXPORT(host));
 		au_sync();
 	}
 
@@ -429,11 +416,10 @@ static void au1xmmc_send_pio(struct au1xmmc_host *host)
 
 static void au1xmmc_receive_pio(struct au1xmmc_host *host)
 {
-
-	struct mmc_data *data = 0;
-	int sg_len = 0, max = 0, count = 0;
-	unsigned char *sg_ptr = 0;
-	u32 status = 0;
+	struct mmc_data *data;
+	int sg_len = 0, max, count;
+	unsigned char *sg_ptr = NULL;
+	u32 status;
 	struct scatterlist *sg;
 
 	data = host->mrq->data;
@@ -451,13 +437,14 @@ static void au1xmmc_receive_pio(struct au1xmmc_host *host)
 		sg_len = sg_dma_len(&data->sg[host->pio.index]) - host->pio.offset;
 
 		/* Check to if we need less then the size of the sg_buffer */
-		if (sg_len < max) max = sg_len;
+		if (sg_len < max)
+			max = sg_len;
 	}
 
 	if (max > AU1XMMC_MAX_TRANSFER)
 		max = AU1XMMC_MAX_TRANSFER;
 
-	for(count = 0; count < max; count++ ) {
+	for (count = 0; count < max; count++) {
 		u32 val;
 		status = au_readl(HOST_STATUS(host));
 
@@ -474,8 +461,7 @@ static void au1xmmc_receive_pio(struct au1xmmc_host *host)
 			DBG("RX Overrun [%d + %d]\n", host->id,
 					host->pio.len, count);
 			break;
-		}
-		else if (status & SD_STATUS_RU) {
+		} else if (status & SD_STATUS_RU) {
 			DBG("RX Underrun [%d + %d]\n", host->id,
 					host->pio.len,	count);
 			break;
@@ -490,13 +476,13 @@ static void au1xmmc_receive_pio(struct au1xmmc_host *host)
 	host->pio.len -= count;
 	host->pio.offset += count;
 
-	if (sg_len && count == sg_len) {
+	if (sg_len && (count == sg_len)) {
 		host->pio.index++;
 		host->pio.offset = 0;
 	}
 
 	if (host->pio.len == 0) {
-		//IRQ_OFF(host, SD_CONFIG_RA | SD_CONFIG_RF);
+		/* IRQ_OFF(host, SD_CONFIG_RA | SD_CONFIG_RF); */
 		IRQ_OFF(host, SD_CONFIG_NE);
 
 		if (host->flags & HOST_F_STOP)
@@ -506,14 +492,11 @@ static void au1xmmc_receive_pio(struct au1xmmc_host *host)
 	}
 }
 
-/* static void au1xmmc_cmd_complete
-   This is called when a command has been completed - grab the response
-   and check for errors.  Then start the data transfer if it is indicated.
-*/
-
+/* This is called when a command has been completed - grab the response
+ * and check for errors.  Then start the data transfer if it is indicated.
+ */
 static void au1xmmc_cmd_complete(struct au1xmmc_host *host, u32 status)
 {
-
 	struct mmc_request *mrq = host->mrq;
 	struct mmc_command *cmd;
 	int trans;
@@ -538,7 +521,6 @@ static void au1xmmc_cmd_complete(struct au1xmmc_host *host, u32 status)
 			 * we only got 120 bytes, but the engine expects
 			 * 128 bits, so we have to shift things up
 			 */
-
 			for(i = 0; i < 4; i++) {
 				cmd->resp[i] = (r[i] & 0x00FFFFFF) << 8;
 				if (i != 3)
@@ -557,15 +539,13 @@ static void au1xmmc_cmd_complete(struct au1xmmc_host *host, u32 status)
 	}
 
         /* Figure out errors */
-
 	if (status & (SD_STATUS_SC | SD_STATUS_WC | SD_STATUS_RC))
 		cmd->error = -EILSEQ;
 
 	trans = host->flags & (HOST_F_XMIT | HOST_F_RECV);
 
 	if (!trans || cmd->error) {
-
-		IRQ_OFF(host, SD_CONFIG_TH | SD_CONFIG_RA|SD_CONFIG_RF);
+		IRQ_OFF(host, SD_CONFIG_TH | SD_CONFIG_RA | SD_CONFIG_RF);
 		tasklet_schedule(&host->finish_task);
 		return;
 	}
@@ -576,29 +556,25 @@ static void au1xmmc_cmd_complete(struct au1xmmc_host *host, u32 status)
 		u32 channel = DMA_CHANNEL(host);
 
 		/* Start the DMA as soon as the buffer gets something in it */
-
 		if (host->flags & HOST_F_RECV) {
 			u32 mask = SD_STATUS_DB | SD_STATUS_NE;
 
-			while((status & mask) != mask)
+			while ((status & mask) != mask)
 				status = au_readl(HOST_STATUS(host));
 		}
-
 		au1xxx_dbdma_start(channel);
 	}
 }
 
 static void au1xmmc_set_clock(struct au1xmmc_host *host, int rate)
 {
-
 	unsigned int pbus = get_au1x00_speed();
 	unsigned int divisor;
 	u32 config;
 
 	/* From databook:
-	   divisor = ((((cpuclock / sbus_divisor) / 2) / mmcclock) / 2) - 1
-	*/
-
+	 * divisor = ((((cpuclock / sbus_divisor) / 2) / mmcclock) / 2) - 1
+	 */
 	pbus /= ((au_readl(SYS_POWERCTRL) & 0x3) + 2);
 	pbus /= 2;
 
@@ -616,7 +592,6 @@ static void au1xmmc_set_clock(struct au1xmmc_host *host, int rate)
 static int
 au1xmmc_prepare_data(struct au1xmmc_host *host, struct mmc_data *data)
 {
-
 	int datalen = data->blocks * data->blksz;
 
 	if (dma != 0)
@@ -647,32 +622,31 @@ au1xmmc_prepare_data(struct au1xmmc_host *host, struct mmc_data *data)
 		au1xxx_dbdma_stop(channel);
 
 		for(i = 0; i < host->dma.len; i++) {
-			u32 ret = 0, flags = DDMA_FLAGS_NOIE;
+			u32 ret, flags;
 			struct scatterlist *sg = &data->sg[i];
 			int sg_len = sg->length;
 
 			int len = (datalen > sg_len) ? sg_len : datalen;
 
-			if (i == host->dma.len - 1)
+			if (i == (host->dma.len - 1))
 				flags = DDMA_FLAGS_IE;
-
-    			if (host->flags & HOST_F_XMIT){
-      				ret = au1xxx_dbdma_put_source_flags(channel,
-					(void *) sg_virt(sg), len, flags);
-			}
-    			else {
-      				ret = au1xxx_dbdma_put_dest_flags(channel,
-					(void *) sg_virt(sg),
-					len, flags);
+			else
+				flags = DDMA_FLAGS_NOIE;
+
+			if (host->flags & HOST_F_XMIT){
+				ret = au1xxx_dbdma_put_source_flags(channel,
+					(void *)sg_virt(sg), len, flags);
+			} else {
+				ret = au1xxx_dbdma_put_dest_flags(channel,
+					(void *)sg_virt(sg), len, flags);
 			}
 
-    			if (!ret)
+			if (!ret)
 				goto dataerr;
 
 			datalen -= len;
 		}
-	}
-	else {
+	} else {
 		host->pio.index = 0;
 		host->pio.offset = 0;
 		host->pio.len = datalen;
@@ -681,25 +655,19 @@ au1xmmc_prepare_data(struct au1xmmc_host *host, struct mmc_data *data)
 			IRQ_ON(host, SD_CONFIG_TH);
 		else
 			IRQ_ON(host, SD_CONFIG_NE);
-			//IRQ_ON(host, SD_CONFIG_RA|SD_CONFIG_RF);
+			/* IRQ_ON(host, SD_CONFIG_RA|SD_CONFIG_RF); */
 	}
 
 	return 0;
 
- dataerr:
+dataerr:
 	dma_unmap_sg(mmc_dev(host->mmc),data->sg,data->sg_len,host->dma.dir);
 	return -ETIMEDOUT;
 }
 
-/* static void au1xmmc_request
-   This actually starts a command or data transaction
-*/
-
 static void au1xmmc_request(struct mmc_host* mmc, struct mmc_request* mrq)
 {
-
 	struct au1xmmc_host *host = mmc_priv(mmc);
-	unsigned int flags = 0;
 	int ret = 0;
 
 	WARN_ON(irqs_disabled());
@@ -714,7 +682,6 @@ static void au1xmmc_request(struct mmc_host* mmc, struct mmc_request* mrq)
 
 	if (mrq->data) {
 		FLUSH_FIFO(host);
-		flags = mrq->data->flags;
 		ret = au1xmmc_prepare_data(host, mrq->data);
 	}
 
@@ -729,7 +696,6 @@ static void au1xmmc_request(struct mmc_host* mmc, struct mmc_request* mrq)
 
 static void au1xmmc_reset_controller(struct au1xmmc_host *host)
 {
-
 	/* Apply the clock */
 	au_writel(SD_ENABLE_CE, HOST_ENABLE(host));
         au_sync_delay(1);
@@ -759,7 +725,7 @@ static void au1xmmc_reset_controller(struct au1xmmc_host *host)
 }
 
 
-static void au1xmmc_set_ios(struct mmc_host* mmc, struct mmc_ios* ios)
+static void au1xmmc_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 {
 	struct au1xmmc_host *host = mmc_priv(mmc);
 	u32 config;
@@ -790,10 +756,9 @@ static void au1xmmc_set_ios(struct mmc_host* mmc, struct mmc_ios* ios)
 
 static void au1xmmc_dma_callback(int irq, void *dev_id)
 {
-	struct au1xmmc_host *host = (struct au1xmmc_host *) dev_id;
+	struct au1xmmc_host *host = (struct au1xmmc_host *)dev_id;
 
 	/* Avoid spurious interrupts */
-
 	if (!host->mrq)
 		return;
 
@@ -845,7 +810,7 @@ static irqreturn_t au1xmmc_irq(int irq, void *dev_id)
 #endif
 	else if (status & (SD_STATUS_CR)) {
 		if (host->status == HOST_S_CMD)
-			au1xmmc_cmd_complete(host,status);
+			au1xmmc_cmd_complete(host, status);
 
 	} else if (!(host->flags & HOST_F_DMA)) {
 		if ((host->flags & HOST_F_XMIT) && (status & STATUS_DATA_OUT))
-- 
1.5.5.1

