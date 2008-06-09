Return-Path: <linux-kernel-owner+w=401wt.eu-S1759193AbYFIGis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759193AbYFIGis (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 02:38:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757059AbYFIGij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 02:38:39 -0400
Received: from fnoeppeil48.netpark.at ([217.175.205.176]:33862 "EHLO
	roarinelk.homelinux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756070AbYFIGih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 02:38:37 -0400
Date: Mon, 9 Jun 2008 08:38:35 +0200
From: Manuel Lauss <mano@roarinelk.homelinux.net>
To: linux-mips@linux-mips.org, sshtylyov@ru.mvista.com, drzeus@drzeus.cx,
       linux-kernel@vger.kernel.org
Subject: [PATCH 5/8] au1xmmc: codingstyle tidying.
Message-ID: <20080609063835.GF8724@roarinelk.homelinux.net>
References: <20080609063521.GA8724@roarinelk.homelinux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080609063521.GA8724@roarinelk.homelinux.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 629e26106e6fc0b653012e7229e3abd0bce554b2 Mon Sep 17 00:00:00 2001
From: Manuel Lauss <mlau@msc-ge.com>
Date: Sat, 17 May 2008 18:30:00 +0200
Subject: [PATCH] au1xmmc: codingstyle tidying

Clean up the codebase, no functional changes.
- merge the au1xmmc.h header contents into the driver file,
- indentation, spelling and style fixes.

Signed-off-by: Manuel Lauss <mano@roarinelk.homelinux.net>
---
 drivers/mmc/host/au1xmmc.c |  233 ++++++++++++++++++++++++++-----------------
 drivers/mmc/host/au1xmmc.h |   97 ------------------
 2 files changed, 141 insertions(+), 189 deletions(-)
 delete mode 100644 drivers/mmc/host/au1xmmc.h

diff --git a/drivers/mmc/host/au1xmmc.c b/drivers/mmc/host/au1xmmc.c
index 16b5640..fcbaf40 100644
--- a/drivers/mmc/host/au1xmmc.c
+++ b/drivers/mmc/host/au1xmmc.c
@@ -49,20 +49,104 @@
 #include <asm/mach-au1x00/au1xxx_dbdma.h>
 #include <asm/mach-au1x00/au1100_mmc.h>
 
-#include <au1xxx.h>
-#include "au1xmmc.h"
-
 #define DRIVER_NAME "au1xxx-mmc"
 
 /* Set this to enable special debugging macros */
 /* #define DEBUG */
 
 #ifdef DEBUG
-#define DBG(fmt, idx, args...) printk("au1xx(%d): DEBUG: " fmt, idx, ##args)
+#define DBG(fmt, idx, args...)	\
+	printk(KERN_DEBUG "au1xmmc(%d): DEBUG: " fmt, idx, ##args)
 #else
-#define DBG(fmt, idx, args...)
+#define DBG(fmt, idx, args...) do {} while (0)
 #endif
 
+/* Hardware definitions */
+#define AU1XMMC_DESCRIPTOR_COUNT 1
+#define AU1XMMC_DESCRIPTOR_SIZE  2048
+
+#define AU1XMMC_OCR (MMC_VDD_27_28 | MMC_VDD_28_29 | MMC_VDD_29_30 | \
+		     MMC_VDD_30_31 | MMC_VDD_31_32 | MMC_VDD_32_33 | \
+		     MMC_VDD_33_34 | MMC_VDD_34_35 | MMC_VDD_35_36)
+
+/* This gives us a hard value for the stop command that we can write directly
+ * to the command register.
+ */
+#define STOP_CMD	\
+	(SD_CMD_RT_1B | SD_CMD_CT_7 | (0xC << SD_CMD_CI_SHIFT) | SD_CMD_GO)
+
+/* This is the set of interrupts that we configure by default. */
+#define AU1XMMC_INTERRUPTS 				\
+	(SD_CONFIG_SC | SD_CONFIG_DT | SD_CONFIG_RAT |	\
+	 SD_CONFIG_CR | SD_CONFIG_I)
+
+/* The poll event (looking for insert/remove events runs twice a second. */
+#define AU1XMMC_DETECT_TIMEOUT (HZ/2)
+
+struct au1xmmc_host {
+	struct mmc_host *mmc;
+	struct mmc_request *mrq;
+
+	u32 flags;
+	u32 iobase;
+	u32 clock;
+	u32 bus_width;
+	u32 power_mode;
+
+	int status;
+
+	struct {
+		int len;
+		int dir;
+	} dma;
+
+	struct {
+		int index;
+		int offset;
+		int len;
+	} pio;
+
+	u32 tx_chan;
+	u32 rx_chan;
+
+	int irq;
+
+	struct timer_list timer;
+	struct tasklet_struct finish_task;
+	struct tasklet_struct data_task;
+	struct au1xmmc_platform_data *platdata;
+	struct platform_device *pdev;
+	struct resource *ioarea;
+};
+
+/* Status flags used by the host structure */
+#define HOST_F_XMIT	0x0001
+#define HOST_F_RECV	0x0002
+#define HOST_F_DMA	0x0010
+#define HOST_F_ACTIVE	0x0100
+#define HOST_F_STOP	0x1000
+
+#define HOST_S_IDLE	0x0001
+#define HOST_S_CMD	0x0002
+#define HOST_S_DATA	0x0003
+#define HOST_S_STOP	0x0004
+
+/* Easy access macros */
+#define HOST_STATUS(h)	((h)->iobase + SD_STATUS)
+#define HOST_CONFIG(h)	((h)->iobase + SD_CONFIG)
+#define HOST_ENABLE(h)	((h)->iobase + SD_ENABLE)
+#define HOST_TXPORT(h)	((h)->iobase + SD_TXPORT)
+#define HOST_RXPORT(h)	((h)->iobase + SD_RXPORT)
+#define HOST_CMDARG(h)	((h)->iobase + SD_CMDARG)
+#define HOST_BLKSIZE(h)	((h)->iobase + SD_BLKSIZE)
+#define HOST_CMD(h)	((h)->iobase + SD_CMD)
+#define HOST_CONFIG2(h)	((h)->iobase + SD_CONFIG2)
+#define HOST_TIMEOUT(h)	((h)->iobase + SD_TIMEOUT)
+#define HOST_DEBUG(h)	((h)->iobase + SD_DEBUG)
+
+#define DMA_CHANNEL(h)	\
+	(((h)->flags & HOST_F_XMIT) ? (h)->tx_chan : (h)->rx_chan)
+
 static inline void IRQ_ON(struct au1xmmc_host *host, u32 mask)
 {
 	u32 val = au_readl(HOST_CONFIG(host));
@@ -141,7 +225,6 @@ static int au1xmmc_card_readonly(struct mmc_host *mmc)
 
 static void au1xmmc_finish_request(struct au1xmmc_host *host)
 {
-
 	struct mmc_request *mrq = host->mrq;
 
 	host->mrq = NULL;
@@ -215,18 +298,14 @@ static int au1xmmc_send_command(struct au1xmmc_host *host, int wait,
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
@@ -240,12 +319,11 @@ static int au1xmmc_send_command(struct au1xmmc_host *host, int wait,
 
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
@@ -256,15 +334,13 @@ static void au1xmmc_data_complete(struct au1xmmc_host *host, u32 status)
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
@@ -282,15 +358,13 @@ static void au1xmmc_data_complete(struct au1xmmc_host *host, u32 status)
 #ifdef CONFIG_SOC_AU1200	/* DBDMA */
 			u32 chan = DMA_CHANNEL(host);
 
-			chan_tab_t *c = *((chan_tab_t **) chan);
+			chan_tab_t *c = *((chan_tab_t **)chan);
 			au1x_dma_chan_t *cp = c->chan_ptr;
 			data->bytes_xfered = cp->ddma_bytecnt;
 #endif
-		}
-		else
+		} else
 			data->bytes_xfered =
-				(data->blocks * data->blksz) -
-				host->pio.len;
+				(data->blocks * data->blksz) - host->pio.len;
 	}
 
 	au1xmmc_finish_request(host);
@@ -298,7 +372,7 @@ static void au1xmmc_data_complete(struct au1xmmc_host *host, u32 status)
 
 static void au1xmmc_tasklet_data(unsigned long param)
 {
-	struct au1xmmc_host *host = (struct au1xmmc_host *) param;
+	struct au1xmmc_host *host = (struct au1xmmc_host *)param;
 
 	u32 status = au_readl(HOST_STATUS(host));
 	au1xmmc_data_complete(host, status);
@@ -308,11 +382,10 @@ static void au1xmmc_tasklet_data(unsigned long param)
 
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
@@ -327,14 +400,12 @@ static void au1xmmc_send_pio(struct au1xmmc_host *host)
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
 
 		if (!(status & SD_STATUS_TH))
@@ -342,7 +413,7 @@ static void au1xmmc_send_pio(struct au1xmmc_host *host)
 
 		val = *sg_ptr++;
 
-		au_writel((unsigned long) val, HOST_TXPORT(host));
+		au_writel((unsigned long)val, HOST_TXPORT(host));
 		au_sync();
 	}
 
@@ -366,11 +437,10 @@ static void au1xmmc_send_pio(struct au1xmmc_host *host)
 
 static void au1xmmc_receive_pio(struct au1xmmc_host *host)
 {
-
-	struct mmc_data *data = 0;
-	int sg_len = 0, max = 0, count = 0;
-	unsigned char *sg_ptr = 0;
-	u32 status = 0;
+	struct mmc_data *data;
+	int max, count, sg_len = 0;
+	unsigned char *sg_ptr = NULL;
+	u32 status, val;
 	struct scatterlist *sg;
 
 	data = host->mrq->data;
@@ -387,15 +457,15 @@ static void au1xmmc_receive_pio(struct au1xmmc_host *host)
 		/* This is the space left inside the buffer */
 		sg_len = sg_dma_len(&data->sg[host->pio.index]) - host->pio.offset;
 
-		/* Check to if we need less then the size of the sg_buffer */
-		if (sg_len < max) max = sg_len;
+		/* Check if we need less than the size of the sg_buffer */
+		if (sg_len < max)
+			max = sg_len;
 	}
 
 	if (max > AU1XMMC_MAX_TRANSFER)
 		max = AU1XMMC_MAX_TRANSFER;
 
-	for(count = 0; count < max; count++ ) {
-		u32 val;
+	for (count = 0; count < max; count++) {
 		status = au_readl(HOST_STATUS(host));
 
 		if (!(status & SD_STATUS_NE))
@@ -421,7 +491,7 @@ static void au1xmmc_receive_pio(struct au1xmmc_host *host)
 		val = au_readl(HOST_RXPORT(host));
 
 		if (sg_ptr)
-			*sg_ptr++ = (unsigned char) (val & 0xFF);
+			*sg_ptr++ = (unsigned char)(val & 0xFF);
 	}
 
 	host->pio.len -= count;
@@ -433,7 +503,7 @@ static void au1xmmc_receive_pio(struct au1xmmc_host *host)
 	}
 
 	if (host->pio.len == 0) {
-		//IRQ_OFF(host, SD_CONFIG_RA | SD_CONFIG_RF);
+		/* IRQ_OFF(host, SD_CONFIG_RA | SD_CONFIG_RF); */
 		IRQ_OFF(host, SD_CONFIG_NE);
 
 		if (host->flags & HOST_F_STOP)
@@ -443,17 +513,15 @@ static void au1xmmc_receive_pio(struct au1xmmc_host *host)
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
-	int trans;
+	u32 r[4];
+	int i, trans;
 
 	if (!host->mrq)
 		return;
@@ -463,9 +531,6 @@ static void au1xmmc_cmd_complete(struct au1xmmc_host *host, u32 status)
 
 	if (cmd->flags & MMC_RSP_PRESENT) {
 		if (cmd->flags & MMC_RSP_136) {
-			u32 r[4];
-			int i;
-
 			r[0] = au_readl(host->iobase + SD_RESP3);
 			r[1] = au_readl(host->iobase + SD_RESP2);
 			r[2] = au_readl(host->iobase + SD_RESP1);
@@ -473,10 +538,9 @@ static void au1xmmc_cmd_complete(struct au1xmmc_host *host, u32 status)
 
 			/* The CRC is omitted from the response, so really
 			 * we only got 120 bytes, but the engine expects
-			 * 128 bits, so we have to shift things up
+			 * 128 bits, so we have to shift things up.
 			 */
-
-			for(i = 0; i < 4; i++) {
+			for (i = 0; i < 4; i++) {
 				cmd->resp[i] = (r[i] & 0x00FFFFFF) << 8;
 				if (i != 3)
 					cmd->resp[i] |= (r[i + 1] & 0xFF000000) >> 24;
@@ -487,22 +551,20 @@ static void au1xmmc_cmd_complete(struct au1xmmc_host *host, u32 status)
 			 * our response omits the CRC, our data ends up
 			 * being shifted 8 bits to the right.  In this case,
 			 * that means that the OSR data starts at bit 31,
-			 * so we can just read RESP0 and return that
+			 * so we can just read RESP0 and return that.
 			 */
 			cmd->resp[0] = au_readl(host->iobase + SD_RESP0);
 		}
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
@@ -529,18 +591,15 @@ static void au1xmmc_cmd_complete(struct au1xmmc_host *host, u32 status)
 
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
-
 	divisor = ((pbus / rate) / 2) - 1;
 
 	config = au_readl(HOST_CONFIG(host));
@@ -552,8 +611,8 @@ static void au1xmmc_set_clock(struct au1xmmc_host *host, int rate)
 	au_sync();
 }
 
-static int
-au1xmmc_prepare_data(struct au1xmmc_host *host, struct mmc_data *data)
+static int au1xmmc_prepare_data(struct au1xmmc_host *host,
+				struct mmc_data *data)
 {
 	int datalen = data->blocks * data->blksz;
 
@@ -582,7 +641,7 @@ au1xmmc_prepare_data(struct au1xmmc_host *host, struct mmc_data *data)
 
 		au1xxx_dbdma_stop(channel);
 
-		for(i = 0; i < host->dma.len; i++) {
+		for (i = 0; i < host->dma.len; i++) {
 			u32 ret = 0, flags = DDMA_FLAGS_NOIE;
 			struct scatterlist *sg = &data->sg[i];
 			int sg_len = sg->length;
@@ -592,14 +651,12 @@ au1xmmc_prepare_data(struct au1xmmc_host *host, struct mmc_data *data)
 			if (i == host->dma.len - 1)
 				flags = DDMA_FLAGS_IE;
 
-    			if (host->flags & HOST_F_XMIT){
-      				ret = au1xxx_dbdma_put_source_flags(channel,
-					(void *) sg_virt(sg), len, flags);
-			}
-    			else {
-      				ret = au1xxx_dbdma_put_dest_flags(channel,
-					(void *) sg_virt(sg),
-					len, flags);
+			if (host->flags & HOST_F_XMIT) {
+				ret = au1xxx_dbdma_put_source_flags(channel,
+					(void *)sg_virt(sg), len, flags);
+			} else {
+				ret = au1xxx_dbdma_put_dest_flags(channel,
+					(void *)sg_virt(sg), len, flags);
 			}
 
 			if (!ret)
@@ -608,8 +665,7 @@ au1xmmc_prepare_data(struct au1xmmc_host *host, struct mmc_data *data)
 			datalen -= len;
 		}
 #endif
-	}
-	else {
+	} else {
 		host->pio.index = 0;
 		host->pio.offset = 0;
 		host->pio.len = datalen;
@@ -618,7 +674,7 @@ au1xmmc_prepare_data(struct au1xmmc_host *host, struct mmc_data *data)
 			IRQ_ON(host, SD_CONFIG_TH);
 		else
 			IRQ_ON(host, SD_CONFIG_NE);
-			//IRQ_ON(host, SD_CONFIG_RA|SD_CONFIG_RF);
+			/* IRQ_ON(host, SD_CONFIG_RA | SD_CONFIG_RF); */
 	}
 
 	return 0;
@@ -629,15 +685,10 @@ dataerr:
 	return -ETIMEDOUT;
 }
 
-/* static void au1xmmc_request
-   This actually starts a command or data transaction
-*/
-
+/* This actually starts a command or data transaction */
 static void au1xmmc_request(struct mmc_host* mmc, struct mmc_request* mrq)
 {
-
 	struct au1xmmc_host *host = mmc_priv(mmc);
-	unsigned int flags = 0;
 	int ret = 0;
 
 	WARN_ON(irqs_disabled());
@@ -648,7 +699,6 @@ static void au1xmmc_request(struct mmc_host* mmc, struct mmc_request* mrq)
 
 	if (mrq->data) {
 		FLUSH_FIFO(host);
-		flags = mrq->data->flags;
 		ret = au1xmmc_prepare_data(host, mrq->data);
 	}
 
@@ -663,7 +713,6 @@ static void au1xmmc_request(struct mmc_host* mmc, struct mmc_request* mrq)
 
 static void au1xmmc_reset_controller(struct au1xmmc_host *host)
 {
-
 	/* Apply the clock */
 	au_writel(SD_ENABLE_CE, HOST_ENABLE(host));
         au_sync_delay(1);
@@ -693,7 +742,7 @@ static void au1xmmc_reset_controller(struct au1xmmc_host *host)
 }
 
 
-static void au1xmmc_set_ios(struct mmc_host* mmc, struct mmc_ios* ios)
+static void au1xmmc_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 {
 	struct au1xmmc_host *host = mmc_priv(mmc);
 	u32 config2;
diff --git a/drivers/mmc/host/au1xmmc.h b/drivers/mmc/host/au1xmmc.h
deleted file mode 100644
index 3b40065..0000000
--- a/drivers/mmc/host/au1xmmc.h
+++ /dev/null
@@ -1,97 +0,0 @@
-#ifndef _AU1XMMC_H_
-#define _AU1XMMC_H_
-
-/* Hardware definitions */
-
-#define AU1XMMC_DESCRIPTOR_COUNT 1
-#define AU1XMMC_DESCRIPTOR_SIZE  2048
-
-#define AU1XMMC_OCR ( MMC_VDD_27_28 | MMC_VDD_28_29 | MMC_VDD_29_30  | \
-		      MMC_VDD_30_31 | MMC_VDD_31_32 | MMC_VDD_32_33  | \
-		      MMC_VDD_33_34 | MMC_VDD_34_35 | MMC_VDD_35_36)
-
-/* Easy access macros */
-
-#define HOST_STATUS(h)	((h)->iobase + SD_STATUS)
-#define HOST_CONFIG(h)	((h)->iobase + SD_CONFIG)
-#define HOST_ENABLE(h)	((h)->iobase + SD_ENABLE)
-#define HOST_TXPORT(h)	((h)->iobase + SD_TXPORT)
-#define HOST_RXPORT(h)	((h)->iobase + SD_RXPORT)
-#define HOST_CMDARG(h)	((h)->iobase + SD_CMDARG)
-#define HOST_BLKSIZE(h)	((h)->iobase + SD_BLKSIZE)
-#define HOST_CMD(h)	((h)->iobase + SD_CMD)
-#define HOST_CONFIG2(h)	((h)->iobase + SD_CONFIG2)
-#define HOST_TIMEOUT(h)	((h)->iobase + SD_TIMEOUT)
-#define HOST_DEBUG(h)	((h)->iobase + SD_DEBUG)
-
-#define DMA_CHANNEL(h) \
-	( ((h)->flags & HOST_F_XMIT) ? (h)->tx_chan : (h)->rx_chan)
-
-/* This gives us a hard value for the stop command that we can write directly
- * to the command register
- */
-
-#define STOP_CMD (SD_CMD_RT_1B|SD_CMD_CT_7|(0xC << SD_CMD_CI_SHIFT)|SD_CMD_GO)
-
-/* This is the set of interrupts that we configure by default */
-
-#if 0
-#define AU1XMMC_INTERRUPTS (SD_CONFIG_SC | SD_CONFIG_DT | SD_CONFIG_DD | \
-		SD_CONFIG_RAT | SD_CONFIG_CR | SD_CONFIG_I)
-#endif
-
-#define AU1XMMC_INTERRUPTS (SD_CONFIG_SC | SD_CONFIG_DT | \
-		SD_CONFIG_RAT | SD_CONFIG_CR | SD_CONFIG_I)
-/* The poll event (looking for insert/remove events runs twice a second */
-#define AU1XMMC_DETECT_TIMEOUT (HZ/2)
-
-struct au1xmmc_host {
-  struct mmc_host *mmc;
-  struct mmc_request *mrq;
-
-  u32 flags;
-  u32 iobase;
-  u32 clock;
-  u32 bus_width;
-  u32 power_mode;
-
-  int status;
-
-   struct {
-	   int len;
-	   int dir;
-  } dma;
-
-   struct {
-	   int index;
-	   int offset;
-	   int len;
-  } pio;
-
-  u32 tx_chan;
-  u32 rx_chan;
-
-  int irq;
-
-  struct timer_list timer;
-  struct tasklet_struct finish_task;
-  struct tasklet_struct data_task;
-  struct au1xmmc_platform_data *platdata;
-  struct platform_device *pdev;
-  struct resource *ioarea;
-};
-
-/* Status flags used by the host structure */
-
-#define HOST_F_XMIT   0x0001
-#define HOST_F_RECV   0x0002
-#define HOST_F_DMA    0x0010
-#define HOST_F_ACTIVE 0x0100
-#define HOST_F_STOP   0x1000
-
-#define HOST_S_IDLE   0x0001
-#define HOST_S_CMD    0x0002
-#define HOST_S_DATA   0x0003
-#define HOST_S_STOP   0x0004
-
-#endif
-- 
1.5.5.3

