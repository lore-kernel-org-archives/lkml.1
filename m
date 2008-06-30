Return-Path: <linux-kernel-owner+w=401wt.eu-S1761540AbYF3P3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761540AbYF3P3c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 11:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754083AbYF3P1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 11:27:54 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:60300 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751345AbYF3P1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 11:27:49 -0400
Message-Id: <20080630152747.132370982@fluff.org.uk>
References: <20080630152547.755285683@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Mon, 30 Jun 2008 16:25:49 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org, drzeus-mmc@drzeus.cx
Cc: tk@maintech.de, laforge@openmoko.org, Ben Dooks <ben-linux@fluff.org>
Subject: [patch v4 02/17] MMC: S3C24XX: Fix the checkpatch.pl errors in the s3cmci driver
Content-Disposition: inline; filename=simtec/simtec-fix-checkpatch-errors.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the checkpatch and other problems pointed out by
akpm.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.26-rc8-next20080627/drivers/mmc/host/s3cmci.c
===================================================================
--- linux-2.6.26-rc8-next20080627.orig/drivers/mmc/host/s3cmci.c	2008-06-30 12:18:49.000000000 +0100
+++ linux-2.6.26-rc8-next20080627/drivers/mmc/host/s3cmci.c	2008-06-30 15:31:29.000000000 +0100
@@ -11,15 +11,13 @@
 #include <linux/module.h>
 #include <linux/dma-mapping.h>
 #include <linux/clk.h>
-#include <linux/mmc/mmc.h>
 #include <linux/mmc/host.h>
 #include <linux/platform_device.h>
 #include <linux/irq.h>
+#include <linux/io.h>
 
 #include <asm/dma.h>
-#include <asm/dma-mapping.h>
 
-#include <asm/io.h>
 #include <asm/arch/regs-sdi.h>
 #include <asm/arch/regs-gpio.h>
 
@@ -43,13 +41,15 @@ static const int dbgmap_err   = dbg_err 
 static const int dbgmap_info  = dbg_info | dbg_conf;
 static const int dbgmap_debug = dbg_debug;
 
-#define dbg(host, channels, args...)		 \
-	if (dbgmap_err & channels) 		 \
-		dev_err(&host->pdev->dev, args); \
-	else if (dbgmap_info & channels)	 \
-		dev_info(&host->pdev->dev, args);\
-	else if (dbgmap_debug & channels)	 \
-		dev_dbg(&host->pdev->dev, args);
+#define dbg(host, channels, args...)		  \
+	do {					  \
+	if (dbgmap_err & channels) 		  \
+		dev_err(&host->pdev->dev, args);  \
+	else if (dbgmap_info & channels)	  \
+		dev_info(&host->pdev->dev, args); \
+	else if (dbgmap_debug & channels)	  \
+		dev_dbg(&host->pdev->dev, args);  \
+	} while (0)
 
 #define RESSIZE(ressource) (((ressource)->end - (ressource)->start)+1)
 
@@ -63,7 +63,7 @@ static void s3cmci_reset(struct s3cmci_h
 
 #ifdef CONFIG_MMC_DEBUG
 
-static inline void dbg_dumpregs(struct s3cmci_host *host, char *prefix)
+static void dbg_dumpregs(struct s3cmci_host *host, char *prefix)
 {
 	u32 con, pre, cmdarg, cmdcon, cmdsta, r0, r1, r2, r3, timer, bsize;
 	u32 datcon, datcnt, datsta, fsta, imask;
@@ -101,33 +101,33 @@ static inline void dbg_dumpregs(struct s
 }
 
 static void prepare_dbgmsg(struct s3cmci_host *host, struct mmc_command *cmd,
-								int stop)
+			   int stop)
 {
- 	snprintf(host->dbgmsg_cmd, 300,
-		"#%u%s op:%i arg:0x%08x flags:0x08%x retries:%u",
-		host->ccnt, (stop?" (STOP)":""),
-		cmd->opcode, cmd->arg, cmd->flags, cmd->retries);
+	snprintf(host->dbgmsg_cmd, 300,
+		 "#%u%s op:%i arg:0x%08x flags:0x08%x retries:%u",
+		 host->ccnt, (stop ? " (STOP)" : ""),
+		 cmd->opcode, cmd->arg, cmd->flags, cmd->retries);
 
 	if (cmd->data) {
 		snprintf(host->dbgmsg_dat, 300,
-			"#%u bsize:%u blocks:%u bytes:%u",
-			host->dcnt, cmd->data->blksz,
-			cmd->data->blocks,
-			cmd->data->blocks * cmd->data->blksz);
+			 "#%u bsize:%u blocks:%u bytes:%u",
+			 host->dcnt, cmd->data->blksz,
+			 cmd->data->blocks,
+			 cmd->data->blocks * cmd->data->blksz);
 	} else {
 		host->dbgmsg_dat[0] = '\0';
 	}
 }
 
 static void dbg_dumpcmd(struct s3cmci_host *host, struct mmc_command *cmd,
-								int fail)
+			int fail)
 {
-	unsigned int dbglvl = fail?dbg_fail:dbg_debug;
+	unsigned int dbglvl = fail ? dbg_fail : dbg_debug;
 
 	if (!cmd)
 		return;
 
-	if (cmd->error == MMC_ERR_NONE) {
+	if (cmd->error == 0) {
 		dbg(host, dbglvl, "CMD[OK] %s R0:0x%08x\n",
 			host->dbgmsg_cmd, cmd->resp[0]);
 	} else {
@@ -138,7 +138,7 @@ static void dbg_dumpcmd(struct s3cmci_ho
 	if (!cmd->data)
 		return;
 
-	if (cmd->data->error == MMC_ERR_NONE) {
+	if (cmd->data->error == 0) {
 		dbg(host, dbglvl, "DAT[OK] %s\n", host->dbgmsg_dat);
 	} else {
 		dbg(host, dbglvl, "DAT[ERR %i] %s DCNT:0x%08x\n",
@@ -146,14 +146,23 @@ static void dbg_dumpcmd(struct s3cmci_ho
 			readl(host->base + S3C2410_SDIDCNT));
 	}
 }
-#endif
+#else
+static void dbg_dumpcmd(struct s3cmci_host *host,
+			struct mmc_command *cmd, int fail) { }
+
+static void prepare_dbgmsg(struct s3cmci_host *host, struct mmc_command *cmd,
+			   int stop) { }
+
+static void dbg_dumpregs(struct s3cmci_host *host, char *prefix) { }
+
+#endif /* CONFIG_MMC_DEBUG */
 
 static inline u32 enable_imask(struct s3cmci_host *host, u32 imask)
 {
 	u32 newmask;
 
 	newmask = readl(host->base + host->sdiimsk);
-	newmask|= imask;
+	newmask |= imask;
 
 	writel(newmask, host->base + host->sdiimsk);
 
@@ -165,7 +174,7 @@ static inline u32 disable_imask(struct s
 	u32 newmask;
 
 	newmask = readl(host->base + host->sdiimsk);
-	newmask&= ~imask;
+	newmask &= ~imask;
 
 	writel(newmask, host->base + host->sdiimsk);
 
@@ -178,7 +187,7 @@ static inline void clear_imask(struct s3
 }
 
 static inline int get_data_buffer(struct s3cmci_host *host,
-			volatile u32 *words, volatile u32 **pointer)
+				  u32 *words, u32 **pointer)
 {
 	struct scatterlist *sg;
 
@@ -195,69 +204,82 @@ static inline int get_data_buffer(struct
 	}
 	sg = &host->mrq->data->sg[host->pio_sgptr];
 
-	*words	= sg->length >> 2;
-	*pointer= page_address(sg->page) + sg->offset;
+	*words = sg->length >> 2;
+	*pointer = sg_virt(sg);
 
 	host->pio_sgptr++;
 
 	dbg(host, dbg_sg, "new buffer (%i/%i)\n",
-	      host->pio_sgptr, host->mrq->data->sg_len);
+	    host->pio_sgptr, host->mrq->data->sg_len);
 
 	return 0;
 }
 
-#define FIFO_FILL(host) ((readl(host->base + S3C2410_SDIFSTA) & S3C2410_SDIFSTA_COUNTMASK) >> 2)
-#define FIFO_FREE(host) ((63 - (readl(host->base + S3C2410_SDIFSTA) & S3C2410_SDIFSTA_COUNTMASK)) >> 2)
+static inline u32 fifo_count(struct s3cmci_host *host)
+{
+	u32 fifostat = readl(host->base + S3C2410_SDIFSTA);
+
+	fifostat &= S3C2410_SDIFSTA_COUNTMASK;
+	return fifostat >> 2;
+}
+
+static inline u32 fifo_free(struct s3cmci_host *host)
+{
+	u32 fifostat = readl(host->base + S3C2410_SDIFSTA);
+
+	fifostat &= S3C2410_SDIFSTA_COUNTMASK;
+	return (63 - fifostat) >> 2;
+}
 
-static inline void do_pio_read(struct s3cmci_host *host)
+static void do_pio_read(struct s3cmci_host *host)
 {
 	int res;
 	u32 fifo;
 	void __iomem *from_ptr;
 
-	//write real prescaler to host, it might be set slow to fix
+	/* write real prescaler to host, it might be set slow to fix */
 	writel(host->prescaler, host->base + S3C2410_SDIPRE);
 
 	from_ptr = host->base + host->sdidata;
 
-	while ((fifo = FIFO_FILL(host))) {
+	while ((fifo = fifo_count(host))) {
 		if (!host->pio_words) {
 			res = get_data_buffer(host, &host->pio_words,
-							&host->pio_ptr);
+					      &host->pio_ptr);
 			if (res) {
 				host->pio_active = XFER_NONE;
 				host->complete_what = COMPLETION_FINALIZE;
 
 				dbg(host, dbg_pio, "pio_read(): "
-					"complete (no more data).\n");
+				    "complete (no more data).\n");
 				return;
 			}
 
-			dbg(host, dbg_pio, "pio_read(): new target: [%i]@[%p]\n",
-			       host->pio_words, host->pio_ptr);
+			dbg(host, dbg_pio,
+			    "pio_read(): new target: [%i]@[%p]\n",
+			    host->pio_words, host->pio_ptr);
 		}
 
-		dbg(host, dbg_pio, "pio_read(): fifo:[%02i] "
-				   "buffer:[%03i] dcnt:[%08X]\n",
-				   fifo, host->pio_words,
-				   readl(host->base + S3C2410_SDIDCNT));
+		dbg(host, dbg_pio,
+		    "pio_read(): fifo:[%02i] buffer:[%03i] dcnt:[%08X]\n",
+		    fifo, host->pio_words,
+		    readl(host->base + S3C2410_SDIDCNT));
 
 		if (fifo > host->pio_words)
 			fifo = host->pio_words;
 
-		host->pio_words-= fifo;
-		host->pio_count+= fifo;
+		host->pio_words -= fifo;
+		host->pio_count += fifo;
 
-		while(fifo--) {
+		while (fifo--)
 			*(host->pio_ptr++) = readl(from_ptr);
-		}
 	}
 
 	if (!host->pio_words) {
 		res = get_data_buffer(host, &host->pio_words, &host->pio_ptr);
 		if (res) {
-			dbg(host, dbg_pio, "pio_read(): "
-				"complete (no more buffers).\n");
+			dbg(host, dbg_pio,
+			    "pio_read(): complete (no more buffers).\n");
 			host->pio_active = XFER_NONE;
 			host->complete_what = COMPLETION_FINALIZE;
 
@@ -265,45 +287,44 @@ static inline void do_pio_read(struct s3
 		}
 	}
 
-	enable_imask(host, S3C2410_SDIIMSK_RXFIFOHALF | S3C2410_SDIIMSK_RXFIFOLAST);
+	enable_imask(host,
+		     S3C2410_SDIIMSK_RXFIFOHALF | S3C2410_SDIIMSK_RXFIFOLAST);
 }
 
-static inline void do_pio_write(struct s3cmci_host *host)
+static void do_pio_write(struct s3cmci_host *host)
 {
+	void __iomem *to_ptr;
 	int res;
 	u32 fifo;
 
-	void __iomem *to_ptr;
-
 	to_ptr = host->base + host->sdidata;
 
-	while ((fifo = FIFO_FREE(host))) {
+	while ((fifo = fifo_free(host))) {
 		if (!host->pio_words) {
 			res = get_data_buffer(host, &host->pio_words,
 							&host->pio_ptr);
 			if (res) {
-				dbg(host, dbg_pio, "pio_write(): "
-					"complete (no more data).\n");
+				dbg(host, dbg_pio,
+				    "pio_write(): complete (no more data).\n");
 				host->pio_active = XFER_NONE;
 
 				return;
 			}
 
-			dbg(host, dbg_pio, "pio_write(): "
-				"new source: [%i]@[%p]\n",
-				host->pio_words, host->pio_ptr);
+			dbg(host, dbg_pio,
+			    "pio_write(): new source: [%i]@[%p]\n",
+			    host->pio_words, host->pio_ptr);
 
 		}
 
 		if (fifo > host->pio_words)
 			fifo = host->pio_words;
 
-		host->pio_words-= fifo;
-		host->pio_count+= fifo;
+		host->pio_words -= fifo;
+		host->pio_count += fifo;
 
-		while(fifo--) {
+		while (fifo--)
 			writel(*(host->pio_ptr++), to_ptr);
-		}
 	}
 
 	enable_imask(host, S3C2410_SDIIMSK_TXFIFOHALF);
@@ -324,11 +345,11 @@ static void pio_tasklet(unsigned long da
 		clear_imask(host);
 		if (host->pio_active != XFER_NONE) {
 			dbg(host, dbg_err, "unfinished %s "
-				"- pio_count:[%u] pio_words:[%u]\n",
-				(host->pio_active == XFER_READ)?"read":"write",
-				host->pio_count, host->pio_words);
+			    "- pio_count:[%u] pio_words:[%u]\n",
+			    (host->pio_active == XFER_READ) ? "read" : "write",
+			    host->pio_count, host->pio_words);
 
-			host->mrq->data->error = MMC_ERR_DMA;
+			host->mrq->data->error = -EINVAL;
 		}
 
 		disable_irq(host->irq);
@@ -340,7 +361,7 @@ static void pio_tasklet(unsigned long da
  * ISR for SDI Interface IRQ
  * Communication between driver and ISR works as follows:
  *   host->mrq 			points to current request
- *   host->complete_what	tells the ISR when the request is considered done
+ *   host->complete_what	Indicates when the request is considered done
  *     COMPLETION_CMDSENT	  when the command was sent
  *     COMPLETION_RSPFIN          when a response was received
  *     COMPLETION_XFERFINISH	  when the data transfer is finished
@@ -365,26 +386,24 @@ static void pio_tasklet(unsigned long da
 
 static irqreturn_t s3cmci_irq(int irq, void *dev_id)
 {
-	struct s3cmci_host *host;
+	struct s3cmci_host *host = dev_id;
 	struct mmc_command *cmd;
 	u32 mci_csta, mci_dsta, mci_fsta, mci_dcnt, mci_imsk;
 	u32 mci_cclear, mci_dclear;
 	unsigned long iflags;
 
-	host = (struct s3cmci_host *)dev_id;
-
 	spin_lock_irqsave(&host->complete_lock, iflags);
 
-	mci_csta 	= readl(host->base + S3C2410_SDICMDSTAT);
-	mci_dsta 	= readl(host->base + S3C2410_SDIDSTA);
-	mci_dcnt 	= readl(host->base + S3C2410_SDIDCNT);
-	mci_fsta 	= readl(host->base + S3C2410_SDIFSTA);
-	mci_imsk	= readl(host->base + host->sdiimsk);
-	mci_cclear	= 0;
-	mci_dclear	= 0;
+	mci_csta = readl(host->base + S3C2410_SDICMDSTAT);
+	mci_dsta = readl(host->base + S3C2410_SDIDSTA);
+	mci_dcnt = readl(host->base + S3C2410_SDIDCNT);
+	mci_fsta = readl(host->base + S3C2410_SDIFSTA);
+	mci_imsk = readl(host->base + host->sdiimsk);
+	mci_cclear = 0;
+	mci_dclear = 0;
 
 	if ((host->complete_what == COMPLETION_NONE) ||
-			(host->complete_what == COMPLETION_FINALIZE)) {
+	    (host->complete_what == COMPLETION_FINALIZE)) {
 		host->status = "nothing to complete";
 		clear_imask(host);
 		goto irq_out;
@@ -396,7 +415,7 @@ static irqreturn_t s3cmci_irq(int irq, v
 		goto irq_out;
 	}
 
-	cmd = host->cmd_is_stop?host->mrq->stop:host->mrq->cmd;
+	cmd = host->cmd_is_stop ? host->mrq->stop : host->mrq->cmd;
 
 	if (!cmd) {
 		host->status = "no active cmd";
@@ -406,7 +425,7 @@ static irqreturn_t s3cmci_irq(int irq, v
 
 	if (!host->dodma) {
 		if ((host->pio_active == XFER_WRITE) &&
-				(mci_fsta & S3C2410_SDIFSTA_TFDET)) {
+		    (mci_fsta & S3C2410_SDIFSTA_TFDET)) {
 
 			disable_imask(host, S3C2410_SDIIMSK_TXFIFOHALF);
 			tasklet_schedule(&host->pio_tasklet);
@@ -414,10 +433,11 @@ static irqreturn_t s3cmci_irq(int irq, v
 		}
 
 		if ((host->pio_active == XFER_READ) &&
-				(mci_fsta & S3C2410_SDIFSTA_RFDET)) {
+		    (mci_fsta & S3C2410_SDIFSTA_RFDET)) {
 
 			disable_imask(host,
-				S3C2410_SDIIMSK_RXFIFOHALF | S3C2410_SDIIMSK_RXFIFOLAST);
+				      S3C2410_SDIIMSK_RXFIFOHALF |
+				      S3C2410_SDIIMSK_RXFIFOLAST);
 
 			tasklet_schedule(&host->pio_tasklet);
 			host->status = "pio rx";
@@ -425,7 +445,7 @@ static irqreturn_t s3cmci_irq(int irq, v
 	}
 
 	if (mci_csta & S3C2410_SDICMDSTAT_CMDTIMEOUT) {
-		cmd->error = MMC_ERR_TIMEOUT;
+		cmd->error = -ETIMEDOUT;
 		host->status = "error: command timeout";
 		goto fail_transfer;
 	}
@@ -441,7 +461,7 @@ static irqreturn_t s3cmci_irq(int irq, v
 
 	if (mci_csta & S3C2410_SDICMDSTAT_CRCFAIL) {
 		if (cmd->flags & MMC_RSP_CRC) {
-			cmd->error = MMC_ERR_BADCRC;
+			cmd->error = -EILSEQ;
 			host->status = "error: bad command crc";
 			goto fail_transfer;
 		}
@@ -470,32 +490,32 @@ static irqreturn_t s3cmci_irq(int irq, v
 	/* Check for FIFO failure */
 	if (host->is2440) {
 		if (mci_fsta & S3C2440_SDIFSTA_FIFOFAIL) {
-			host->mrq->data->error = MMC_ERR_FIFO;
+			host->mrq->data->error = -EILSEQ;
 			host->status = "error: 2440 fifo failure";
 			goto fail_transfer;
 		}
 	} else {
 		if (mci_dsta & S3C2410_SDIDSTA_FIFOFAIL) {
-			cmd->data->error = MMC_ERR_FIFO;
+			cmd->data->error = -EILSEQ;
 			host->status = "error:  fifo failure";
 			goto fail_transfer;
 		}
 	}
 
 	if (mci_dsta & S3C2410_SDIDSTA_RXCRCFAIL) {
-		cmd->data->error = MMC_ERR_BADCRC;
+		cmd->data->error = -EILSEQ;
 		host->status = "error: bad data crc (outgoing)";
 		goto fail_transfer;
 	}
 
 	if (mci_dsta & S3C2410_SDIDSTA_CRCFAIL) {
-		cmd->data->error = MMC_ERR_BADCRC;
+		cmd->data->error = -EILSEQ;
 		host->status = "error: bad data crc (incoming)";
 		goto fail_transfer;
 	}
 
 	if (mci_dsta & S3C2410_SDIDSTA_DATATIMEOUT) {
-		cmd->data->error = MMC_ERR_TIMEOUT;
+		cmd->data->error = -ETIMEDOUT;
 		host->status = "error: data timeout";
 		goto fail_transfer;
 	}
@@ -506,9 +526,8 @@ static irqreturn_t s3cmci_irq(int irq, v
 			goto close_transfer;
 		}
 
-		if (host->complete_what == COMPLETION_XFERFINISH_RSPFIN) {
+		if (host->complete_what == COMPLETION_XFERFINISH_RSPFIN)
 			host->complete_what = COMPLETION_RSPFIN;
-		}
 
 		mci_dclear |= S3C2410_SDIDSTA_XFERFINISH;
 	}
@@ -531,10 +550,9 @@ close_transfer:
 	goto irq_out;
 
 irq_out:
-	dbg(host, dbg_irq, "csta:0x%08x dsta:0x%08x "
-			   "fsta:0x%08x dcnt:0x%08x status:%s.\n",
-				mci_csta, mci_dsta, mci_fsta,
-				mci_dcnt, host->status);
+	dbg(host, dbg_irq,
+	    "csta:0x%08x dsta:0x%08x fsta:0x%08x dcnt:0x%08x status:%s.\n",
+	    mci_csta, mci_dsta, mci_fsta, mci_dcnt, host->status);
 
 	spin_unlock_irqrestore(&host->complete_lock, iflags);
 	return IRQ_HANDLED;
@@ -557,22 +575,20 @@ static irqreturn_t s3cmci_irq_cd(int irq
 }
 
 void s3cmci_dma_done_callback(struct s3c2410_dma_chan *dma_ch, void *buf_id,
-	int size, enum s3c2410_dma_buffresult result)
+			      int size, enum s3c2410_dma_buffresult result)
 {
+	struct s3cmci_host *host = buf_id;
 	unsigned long iflags;
 	u32 mci_csta, mci_dsta, mci_fsta, mci_dcnt;
-	struct s3cmci_host *host = (struct s3cmci_host *)buf_id;
 
-	mci_csta 	= readl(host->base + S3C2410_SDICMDSTAT);
-	mci_dsta 	= readl(host->base + S3C2410_SDIDSTA);
-	mci_fsta 	= readl(host->base + S3C2410_SDIFSTA);
-	mci_dcnt 	= readl(host->base + S3C2410_SDIDCNT);
-
-	if ((!host->mrq) || (!host->mrq) || (!host->mrq->data))
-		return;
-
-	if (!host->dmatogo)
-		return;
+	mci_csta = readl(host->base + S3C2410_SDICMDSTAT);
+	mci_dsta = readl(host->base + S3C2410_SDIDSTA);
+	mci_fsta = readl(host->base + S3C2410_SDIFSTA);
+	mci_dcnt = readl(host->base + S3C2410_SDIDCNT);
+
+	BUG_ON(!host->mrq);
+	BUG_ON(!host->mrq->data);
+	BUG_ON(!host->dmatogo);
 
 	spin_lock_irqsave(&host->complete_lock, iflags);
 
@@ -606,7 +622,7 @@ out:
 
 
 fail_request:
-	host->mrq->data->error = MMC_ERR_DMA;
+	host->mrq->data->error = -EINVAL;
 	host->complete_what = COMPLETION_FINALIZE;
 	writel(0, host->base + host->sdiimsk);
 	goto out;
@@ -616,7 +632,7 @@ fail_request:
 static void finalize_request(struct s3cmci_host *host)
 {
 	struct mmc_request *mrq = host->mrq;
-	struct mmc_command *cmd = host->cmd_is_stop?mrq->stop:mrq->cmd;
+	struct mmc_command *cmd = host->cmd_is_stop ? mrq->stop : mrq->cmd;
 	int debug_as_failure = 0;
 
 	if (host->complete_what != COMPLETION_FINALIZE)
@@ -625,22 +641,20 @@ static void finalize_request(struct s3cm
 	if (!mrq)
 		return;
 
-	if (cmd->data && (cmd->error == MMC_ERR_NONE) &&
-		  (cmd->data->error == MMC_ERR_NONE)) {
-
+	if (cmd->data && (cmd->error == 0) &&
+	    (cmd->data->error == 0)) {
 		if (host->dodma && (!host->dma_complete)) {
 			dbg(host, dbg_dma, "DMA Missing!\n");
 			return;
 		}
 	}
 
-	// Read response
+	/* Read response from controller. */
 	cmd->resp[0] = readl(host->base + S3C2410_SDIRSP0);
 	cmd->resp[1] = readl(host->base + S3C2410_SDIRSP1);
 	cmd->resp[2] = readl(host->base + S3C2410_SDIRSP2);
 	cmd->resp[3] = readl(host->base + S3C2410_SDIRSP3);
 
-	// reset clock speed, as it could still be set low for
 	writel(host->prescaler, host->base + S3C2410_SDIPRE);
 
 	if (cmd->error)
@@ -649,12 +663,9 @@ static void finalize_request(struct s3cm
 	if (cmd->data && cmd->data->error)
 		debug_as_failure = 1;
 
-	//if(cmd->flags & MMC_RSP_MAYFAIL) debug_as_failure = 0;
-
-#ifdef CONFIG_MMC_DEBUG
 	dbg_dumpcmd(host, cmd, debug_as_failure);
-#endif
-	//Cleanup controller
+
+	/* Cleanup controller */
 	writel(0, host->base + S3C2410_SDICMDARG);
 	writel(0, host->base + S3C2410_SDIDCON);
 	writel(0, host->base + S3C2410_SDICMDCON);
@@ -669,36 +680,35 @@ static void finalize_request(struct s3cm
 		return;
 	}
 
-	// If we have no data transfer we are finished here
+	/* If we have no data transfer we are finished here */
 	if (!mrq->data)
 		goto request_done;
 
-	// Calulate the amout of bytes transfer, but only if there was
-	// no error
-	if (mrq->data->error == MMC_ERR_NONE) {
+	/* Calulate the amout of bytes transfer if there was no error */
+	if (mrq->data->error == 0) {
 		mrq->data->bytes_xfered =
 			(mrq->data->blocks * mrq->data->blksz);
 	} else {
 		mrq->data->bytes_xfered = 0;
 	}
 
-	// If we had an error while transfering data we flush the
-	// DMA channel and the fifo to clear out any garbage
-	if (mrq->data->error != MMC_ERR_NONE) {
+	/* If we had an error while transfering data we flush the
+	 * DMA channel and the fifo to clear out any garbage. */
+	if (mrq->data->error != 0) {
 		if (host->dodma)
 			s3c2410_dma_ctrl(host->dma, S3C2410_DMAOP_FLUSH);
 
 		if (host->is2440) {
-			//Clear failure register and reset fifo
+			/* Clear failure register and reset fifo. */
 			writel(S3C2440_SDIFSTA_FIFORESET |
 			       S3C2440_SDIFSTA_FIFOFAIL,
 			       host->base + S3C2410_SDIFSTA);
 		} else {
 			u32 mci_con;
 
-			//reset fifo
+			/* reset fifo */
 			mci_con = readl(host->base + S3C2410_SDICON);
-			mci_con|= S3C2410_SDICON_FIFORESET;
+			mci_con |= S3C2410_SDICON_FIFORESET;
 
 			writel(mci_con, host->base + S3C2410_SDICON);
 		}
@@ -713,8 +723,8 @@ request_done:
 
 void s3cmci_dma_setup(struct s3cmci_host *host, enum s3c2410_dmasrc source)
 {
-	static int setup_ok = 0;
 	static enum s3c2410_dmasrc last_source = -1;
+	static int setup_ok;
 
 	if (last_source == source)
 		return;
@@ -722,12 +732,13 @@ void s3cmci_dma_setup(struct s3cmci_host
 	last_source = source;
 
 	s3c2410_dma_devconfig(host->dma, source, 3,
-		host->mem->start + host->sdidata);
+			      host->mem->start + host->sdidata);
 
 	if (!setup_ok) {
 		s3c2410_dma_config(host->dma, 4,
 			(S3C2410_DCON_HWTRIG | S3C2410_DCON_CH0_SDI));
-		s3c2410_dma_set_buffdone_fn(host->dma, s3cmci_dma_done_callback);
+		s3c2410_dma_set_buffdone_fn(host->dma,
+					    s3cmci_dma_done_callback);
 		s3c2410_dma_setflags(host->dma, S3C2410_DMAF_AUTOSTART);
 		setup_ok = 1;
 	}
@@ -744,31 +755,30 @@ static void s3cmci_send_command(struct s
 
 	enable_imask(host, imsk);
 
-	if (cmd->data) {
+	if (cmd->data)
 		host->complete_what = COMPLETION_XFERFINISH_RSPFIN;
-	} else if (cmd->flags & MMC_RSP_PRESENT) {
+	else if (cmd->flags & MMC_RSP_PRESENT)
 		host->complete_what = COMPLETION_RSPFIN;
-	} else {
+	else
 		host->complete_what = COMPLETION_CMDSENT;
-	}
 
 	writel(cmd->arg, host->base + S3C2410_SDICMDARG);
 
-	ccon = cmd->opcode & S3C2410_SDICMDCON_INDEX;
-	ccon|= S3C2410_SDICMDCON_SENDERHOST | S3C2410_SDICMDCON_CMDSTART;
+	ccon  = cmd->opcode & S3C2410_SDICMDCON_INDEX;
+	ccon |= S3C2410_SDICMDCON_SENDERHOST | S3C2410_SDICMDCON_CMDSTART;
 
 	if (cmd->flags & MMC_RSP_PRESENT)
 		ccon |= S3C2410_SDICMDCON_WAITRSP;
 
 	if (cmd->flags & MMC_RSP_136)
-		ccon|= S3C2410_SDICMDCON_LONGRSP;
+		ccon |= S3C2410_SDICMDCON_LONGRSP;
 
 	writel(ccon, host->base + S3C2410_SDICMDCON);
 }
 
 static int s3cmci_setup_data(struct s3cmci_host *host, struct mmc_data *data)
 {
-	u32 dcon, imsk, stoptries=3;
+	u32 dcon, imsk, stoptries = 3;
 
 	/* write DCON register */
 
@@ -777,37 +787,31 @@ static int s3cmci_setup_data(struct s3cm
 		return 0;
 	}
 
-	while(readl(host->base + S3C2410_SDIDSTA) &
-		(S3C2410_SDIDSTA_TXDATAON | S3C2410_SDIDSTA_RXDATAON)) {
+	while (readl(host->base + S3C2410_SDIDSTA) &
+	       (S3C2410_SDIDSTA_TXDATAON | S3C2410_SDIDSTA_RXDATAON)) {
 
 		dbg(host, dbg_err,
-			"mci_setup_data() transfer stillin progress.\n");
+		    "mci_setup_data() transfer stillin progress.\n");
 
 		writel(0, host->base + S3C2410_SDIDCON);
 		s3cmci_reset(host);
 
-		if (0 == (stoptries--)) {
-#ifdef CONFIG_MMC_DEBUG
+		if ((stoptries--) == 0) {
 			dbg_dumpregs(host, "DRF");
-#endif
-
 			return -EINVAL;
 		}
 	}
 
 	dcon  = data->blocks & S3C2410_SDIDCON_BLKNUM_MASK;
 
-	if (host->dodma) {
+	if (host->dodma)
 		dcon |= S3C2410_SDIDCON_DMAEN;
-	}
 
-	if (host->bus_width == MMC_BUS_WIDTH_4) {
+	if (host->bus_width == MMC_BUS_WIDTH_4)
 		dcon |= S3C2410_SDIDCON_WIDEBUS;
-	}
 
-	if (!(data->flags & MMC_DATA_STREAM)) {
+	if (!(data->flags & MMC_DATA_STREAM))
 		dcon |= S3C2410_SDIDCON_BLOCKMODE;
-	}
 
 	if (data->flags & MMC_DATA_WRITE) {
 		dcon |= S3C2410_SDIDCON_TXAFTERRESP;
@@ -831,8 +835,8 @@ static int s3cmci_setup_data(struct s3cm
 	writel(data->blksz, host->base + S3C2410_SDIBSIZE);
 
 	/* add to IMASK register */
-	imsk =	S3C2410_SDIIMSK_FIFOFAIL | S3C2410_SDIIMSK_DATACRC |
-		S3C2410_SDIIMSK_DATATIMEOUT | S3C2410_SDIIMSK_DATAFINISH;
+	imsk = S3C2410_SDIIMSK_FIFOFAIL | S3C2410_SDIIMSK_DATACRC |
+	       S3C2410_SDIIMSK_DATATIMEOUT | S3C2410_SDIIMSK_DATAFINISH;
 
 	enable_imask(host, imsk);
 
@@ -843,35 +847,33 @@ static int s3cmci_setup_data(struct s3cm
 	} else {
 		writel(0x0000FFFF, host->base + S3C2410_SDITIMER);
 
-		//FIX: set slow clock to prevent timeouts on read
-		if (data->flags & MMC_DATA_READ) {
+		/* FIX: set slow clock to prevent timeouts on read */
+		if (data->flags & MMC_DATA_READ)
 			writel(0xFF, host->base + S3C2410_SDIPRE);
-		}
 	}
 
-	//debug_dump_registers(host, "Data setup:");
-
 	return 0;
 }
 
+#define BOTH_DIR (MMC_DATA_WRITE | MMC_DATA_READ)
+
 static int s3cmci_prepare_pio(struct s3cmci_host *host, struct mmc_data *data)
 {
-	int rw = (data->flags & MMC_DATA_WRITE)?1:0;
+	int rw = (data->flags & MMC_DATA_WRITE) ? 1 : 0;
 
-	if (rw != ((data->flags & MMC_DATA_READ)?0:1))
-		return -EINVAL;
+	BUG_ON((data->flags & BOTH_DIR) == BOTH_DIR);
 
 	host->pio_sgptr = 0;
 	host->pio_words = 0;
 	host->pio_count = 0;
-	host->pio_active = rw?XFER_WRITE:XFER_READ;
+	host->pio_active = rw ? XFER_WRITE : XFER_READ;
 
 	if (rw) {
 		do_pio_write(host);
 		enable_imask(host, S3C2410_SDIIMSK_TXFIFOHALF);
 	} else {
 		enable_imask(host, S3C2410_SDIIMSK_RXFIFOHALF
-			| S3C2410_SDIIMSK_RXFIFOLAST);
+			     | S3C2410_SDIIMSK_RXFIFOLAST);
 	}
 
 	return 0;
@@ -880,18 +882,15 @@ static int s3cmci_prepare_pio(struct s3c
 static int s3cmci_prepare_dma(struct s3cmci_host *host, struct mmc_data *data)
 {
 	int dma_len, i;
+	int rw = (data->flags & MMC_DATA_WRITE) ? 1 : 0;
 
-	int rw = (data->flags & MMC_DATA_WRITE)?1:0;
-
-	if (rw != ((data->flags & MMC_DATA_READ)?0:1))
-		return -EINVAL;
+	BUG_ON((data->flags & BOTH_DIR) == BOTH_DIR);
 
-	s3cmci_dma_setup(host, rw?S3C2410_DMASRC_MEM:S3C2410_DMASRC_HW);
+	s3cmci_dma_setup(host, rw ? S3C2410_DMASRC_MEM : S3C2410_DMASRC_HW);
 	s3c2410_dma_ctrl(host->dma, S3C2410_DMAOP_FLUSH);
 
 	dma_len = dma_map_sg(mmc_dev(host->mmc), data->sg, data->sg_len,
-				(rw)?DMA_TO_DEVICE:DMA_FROM_DEVICE);
-
+			     (rw) ? DMA_TO_DEVICE : DMA_FROM_DEVICE);
 
 	if (dma_len == 0)
 		return -ENOMEM;
@@ -907,14 +906,14 @@ static int s3cmci_prepare_dma(struct s3c
 			sg_dma_len(&data->sg[i]));
 
 		res = s3c2410_dma_enqueue(host->dma, (void *) host,
-				sg_dma_address(&data->sg[i]),
-				sg_dma_len(&data->sg[i]));
+					  sg_dma_address(&data->sg[i]),
+					  sg_dma_len(&data->sg[i]));
 
 		if (res) {
 			s3c2410_dma_ctrl(host->dma, S3C2410_DMAOP_FLUSH);
 			return -EBUSY;
 		}
- 	}
+	}
 
 	s3c2410_dma_ctrl(host->dma, S3C2410_DMAOP_START);
 
@@ -925,60 +924,57 @@ static void s3cmci_send_request(struct m
 {
 	struct s3cmci_host *host = mmc_priv(mmc);
 	struct mmc_request *mrq = host->mrq;
-	struct mmc_command *cmd = host->cmd_is_stop?mrq->stop:mrq->cmd;
+	struct mmc_command *cmd = host->cmd_is_stop ? mrq->stop : mrq->cmd;
 
 	host->ccnt++;
-#ifdef CONFIG_MMC_DEBUG
 	prepare_dbgmsg(host, cmd, host->cmd_is_stop);
-#endif
-	//Clear command, data and fifo status registers
-	//Fifo clear only necessary on 2440, but doesn't hurt on 2410
+
+	/* Clear command, data and fifo status registers
+	   Fifo clear only necessary on 2440, but doesn't hurt on 2410
+	*/
 	writel(0xFFFFFFFF, host->base + S3C2410_SDICMDSTAT);
 	writel(0xFFFFFFFF, host->base + S3C2410_SDIDSTA);
 	writel(0xFFFFFFFF, host->base + S3C2410_SDIFSTA);
 
 	if (cmd->data) {
-		int res;
-		res = s3cmci_setup_data(host, cmd->data);
+		int res = s3cmci_setup_data(host, cmd->data);
 
 		host->dcnt++;
 
 		if (res) {
-			cmd->error = MMC_ERR_DMA;
-			cmd->data->error = MMC_ERR_DMA;
+			cmd->error = -EINVAL;
+			cmd->data->error = -EINVAL;
 
 			mmc_request_done(mmc, mrq);
 			return;
 		}
 
-
-		if (host->dodma) {
+		if (host->dodma)
 			res = s3cmci_prepare_dma(host, cmd->data);
-		} else {
+		else
 			res = s3cmci_prepare_pio(host, cmd->data);
-		}
 
 		if (res) {
-			cmd->error = MMC_ERR_DMA;
-			cmd->data->error = MMC_ERR_DMA;
+			cmd->error = res;
+			cmd->data->error = res;
 
 			mmc_request_done(mmc, mrq);
 			return;
 		}
-
 	}
 
-	// Send command
+	/* Send command */
 	s3cmci_send_command(host, cmd);
 
-	// Enable Interrupt
+	/* Enable Interrupt */
 	enable_irq(host->irq);
 }
 
 static void s3cmci_request(struct mmc_host *mmc, struct mmc_request *mrq)
 {
- 	struct s3cmci_host *host = mmc_priv(mmc);
+	struct s3cmci_host *host = mmc_priv(mmc);
 
+	host->status = "mmc request";
 	host->cmd_is_stop = 0;
 	host->mrq = mrq;
 
@@ -990,62 +986,64 @@ static void s3cmci_set_ios(struct mmc_ho
 	struct s3cmci_host *host = mmc_priv(mmc);
 	u32 mci_psc, mci_con;
 
-	//Set power
-	mci_con = readl(host->base + S3C2410_SDICON);
-	switch(ios->power_mode) {
-		case MMC_POWER_ON:
-		case MMC_POWER_UP:
-			s3c2410_gpio_cfgpin(S3C2410_GPE5, S3C2410_GPE5_SDCLK);
-			s3c2410_gpio_cfgpin(S3C2410_GPE6, S3C2410_GPE6_SDCMD);
-			s3c2410_gpio_cfgpin(S3C2410_GPE7, S3C2410_GPE7_SDDAT0);
-			s3c2410_gpio_cfgpin(S3C2410_GPE8, S3C2410_GPE8_SDDAT1);
-			s3c2410_gpio_cfgpin(S3C2410_GPE9, S3C2410_GPE9_SDDAT2);
-			s3c2410_gpio_cfgpin(S3C2410_GPE10, S3C2410_GPE10_SDDAT3);
-
-			if (!host->is2440)
-				mci_con|=S3C2410_SDICON_FIFORESET;
+	/* Set the power state */
 
-			break;
+	mci_con = readl(host->base + S3C2410_SDICON);
 
-		case MMC_POWER_OFF:
-		default:
-			s3c2410_gpio_setpin(S3C2410_GPE5, 0);
-			s3c2410_gpio_cfgpin(S3C2410_GPE5, S3C2410_GPE5_OUTP);
+	switch (ios->power_mode) {
+	case MMC_POWER_ON:
+	case MMC_POWER_UP:
+		s3c2410_gpio_cfgpin(S3C2410_GPE5, S3C2410_GPE5_SDCLK);
+		s3c2410_gpio_cfgpin(S3C2410_GPE6, S3C2410_GPE6_SDCMD);
+		s3c2410_gpio_cfgpin(S3C2410_GPE7, S3C2410_GPE7_SDDAT0);
+		s3c2410_gpio_cfgpin(S3C2410_GPE8, S3C2410_GPE8_SDDAT1);
+		s3c2410_gpio_cfgpin(S3C2410_GPE9, S3C2410_GPE9_SDDAT2);
+		s3c2410_gpio_cfgpin(S3C2410_GPE10, S3C2410_GPE10_SDDAT3);
+
+		if (!host->is2440)
+			mci_con |= S3C2410_SDICON_FIFORESET;
+
+		break;
+
+	case MMC_POWER_OFF:
+	default:
+		s3c2410_gpio_setpin(S3C2410_GPE5, 0);
+		s3c2410_gpio_cfgpin(S3C2410_GPE5, S3C2410_GPE5_OUTP);
 
-			if (host->is2440)
-				mci_con|=S3C2440_SDICON_SDRESET;
+		if (host->is2440)
+			mci_con |= S3C2440_SDICON_SDRESET;
 
-			break;
+		break;
 	}
 
-	//Set clock
-	for (mci_psc=0; mci_psc<255; mci_psc++) {
+	/* Set clock */
+	for (mci_psc = 0; mci_psc < 255; mci_psc++) {
 		host->real_rate = host->clk_rate / (host->clk_div*(mci_psc+1));
 
 		if (host->real_rate <= ios->clock)
 			break;
 	}
 
-	if(mci_psc > 255) mci_psc = 255;
-	host->prescaler = mci_psc;
+	if (mci_psc > 255)
+		mci_psc = 255;
 
+	host->prescaler = mci_psc;
 	writel(host->prescaler, host->base + S3C2410_SDIPRE);
 
-	//If requested clock is 0, real_rate will be 0, too
+	/* If requested clock is 0, real_rate will be 0, too */
 	if (ios->clock == 0)
 		host->real_rate = 0;
 
-	//Set CLOCK_ENABLE
+	/* Set CLOCK_ENABLE */
 	if (ios->clock)
 		mci_con |= S3C2410_SDICON_CLOCKTYPE;
 	else
-		mci_con &=~S3C2410_SDICON_CLOCKTYPE;
+		mci_con &= ~S3C2410_SDICON_CLOCKTYPE;
 
 	writel(mci_con, host->base + S3C2410_SDICON);
 
-	if ((ios->power_mode==MMC_POWER_ON)
-		|| (ios->power_mode==MMC_POWER_UP)) {
-
+	if ((ios->power_mode == MMC_POWER_ON) ||
+	    (ios->power_mode == MMC_POWER_UP)) {
 		dbg(host, dbg_conf, "running at %lukHz (requested: %ukHz).\n",
 			host->real_rate/1000, ios->clock/1000);
 	} else {
@@ -1053,7 +1051,6 @@ static void s3cmci_set_ios(struct mmc_ho
 	}
 
 	host->bus_width = ios->bus_width;
-
 }
 
 static void s3cmci_reset(struct s3cmci_host *host)
@@ -1061,7 +1058,6 @@ static void s3cmci_reset(struct s3cmci_h
 	u32 con = readl(host->base + S3C2410_SDICON);
 
 	con |= S3C2440_SDICON_SDRESET;
-
 	writel(con, host->base + S3C2410_SDICON);
 }
 
@@ -1070,11 +1066,10 @@ static struct mmc_host_ops s3cmci_ops = 
 	.set_ios	= s3cmci_set_ios,
 };
 
-static int s3cmci_probe(struct platform_device *pdev, int is2440)
+static int __devinit s3cmci_probe(struct platform_device *pdev, int is2440)
 {
-	struct mmc_host 	*mmc;
-	struct s3cmci_host 	*host;
-
+	struct s3cmci_host *host;
+	struct mmc_host	*mmc;
 	int ret;
 
 	mmc = mmc_alloc_host(sizeof(struct s3cmci_host), &pdev->dev);
@@ -1086,20 +1081,21 @@ static int s3cmci_probe(struct platform_
 	host = mmc_priv(mmc);
 	host->mmc 	= mmc;
 	host->pdev	= pdev;
+	host->is2440	= is2440;
 
 	spin_lock_init(&host->complete_lock);
 	tasklet_init(&host->pio_tasklet, pio_tasklet, (unsigned long) host);
+
 	if (is2440) {
-		host->is2440	= 1;
 		host->sdiimsk	= S3C2440_SDIIMSK;
 		host->sdidata	= S3C2440_SDIDATA;
 		host->clk_div	= 1;
 	} else {
-		host->is2440	= 0;
 		host->sdiimsk	= S3C2410_SDIIMSK;
 		host->sdidata	= S3C2410_SDIDATA;
 		host->clk_div	= 2;
 	}
+
 	host->dodma		= 0;
 	host->complete_what 	= COMPLETION_NONE;
 	host->pio_active 	= XFER_NONE;
@@ -1117,7 +1113,7 @@ static int s3cmci_probe(struct platform_
 	}
 
 	host->mem = request_mem_region(host->mem->start,
-		RESSIZE(host->mem), pdev->name);
+				       RESSIZE(host->mem), pdev->name);
 
 	if (!host->mem) {
 		dev_err(&pdev->dev, "failed to request io memory region.\n");
@@ -1145,6 +1141,10 @@ static int s3cmci_probe(struct platform_
 		goto probe_iounmap;
 	}
 
+	/* We get spurious interrupts even when we have set the IMSK
+	 * register to ignore everything, so use disable_irq() to make
+	 * ensure we don't lock the system with un-serviceable requests. */
+
 	disable_irq(host->irq);
 
 	s3c2410_gpio_cfgpin(S3C2410_GPF2, S3C2410_GPF2_EINT2);
@@ -1153,7 +1153,6 @@ static int s3cmci_probe(struct platform_
 	if (request_irq(host->irq_cd, s3cmci_irq_cd, 0, DRIVER_NAME, host)) {
 		dev_err(&pdev->dev,
 			"failed to request card detect interrupt.\n");
-
 		ret = -ENOENT;
 		goto probe_free_irq;
 	}
@@ -1172,7 +1171,8 @@ static int s3cmci_probe(struct platform_
 		goto probe_free_host;
 	}
 
-	if ((ret = clk_enable(host->clk))) {
+	ret = clk_enable(host->clk);
+	if (ret) {
 		dev_err(&pdev->dev, "failed to enable clock source.\n");
 		goto clk_free;
 	}
@@ -1193,18 +1193,20 @@ static int s3cmci_probe(struct platform_
 	mmc->max_phys_segs	= 128;
 	mmc->max_hw_segs	= 128;
 
-	dbg(host, dbg_debug, "probe: mode:%s mapped mci_base:%p irq:%u irq_cd:%u dma:%u.\n",
-		(host->is2440?"2440":""),
-		host->base, host->irq, host->irq_cd, host->dma);
+	dbg(host, dbg_debug,
+	    "probe: mode:%s mapped mci_base:%p irq:%u irq_cd:%u dma:%u.\n",
+	    (host->is2440?"2440":""),
+	    host->base, host->irq, host->irq_cd, host->dma);
 
-	if ((ret = mmc_add_host(mmc))) {
+	ret = mmc_add_host(mmc);
+	if (ret) {
 		dev_err(&pdev->dev, "failed to add mmc host.\n");
 		goto free_dmabuf;
 	}
 
 	platform_set_drvdata(pdev, mmc);
+	dev_info(&pdev->dev, "initialisation done.\n");
 
-	dev_info(&pdev->dev,"initialisation done.\n");
 	return 0;
 
  free_dmabuf:
@@ -1214,10 +1216,10 @@ static int s3cmci_probe(struct platform_
 	clk_put(host->clk);
 
  probe_free_irq_cd:
- 	free_irq(host->irq_cd, host);
+	free_irq(host->irq_cd, host);
 
  probe_free_irq:
- 	free_irq(host->irq, host);
+	free_irq(host->irq, host);
 
  probe_iounmap:
 	iounmap(host->base);
@@ -1231,34 +1233,39 @@ static int s3cmci_probe(struct platform_
 	return ret;
 }
 
-static int s3cmci_remove(struct platform_device *pdev)
+static int __devexit s3cmci_remove(struct platform_device *pdev)
 {
-	struct mmc_host 	*mmc  = platform_get_drvdata(pdev);
-	struct s3cmci_host 	*host = mmc_priv(mmc);
+	struct mmc_host		*mmc  = platform_get_drvdata(pdev);
+	struct s3cmci_host	*host = mmc_priv(mmc);
 
 	mmc_remove_host(mmc);
+
 	clk_disable(host->clk);
 	clk_put(host->clk);
- 	free_irq(host->irq_cd, host);
- 	free_irq(host->irq, host);
+
+	tasklet_disable(&host->pio_tasklet);
+
+	free_irq(host->irq_cd, host);
+	free_irq(host->irq, host);
+
 	iounmap(host->base);
 	release_mem_region(host->mem->start, RESSIZE(host->mem));
-	mmc_free_host(mmc);
 
+	mmc_free_host(mmc);
 	return 0;
 }
 
-static int s3cmci_probe_2410(struct platform_device *dev)
+static int __devinit s3cmci_probe_2410(struct platform_device *dev)
 {
 	return s3cmci_probe(dev, 0);
 }
 
-static int s3cmci_probe_2412(struct platform_device *dev)
+static int __devinit s3cmci_probe_2412(struct platform_device *dev)
 {
 	return s3cmci_probe(dev, 1);
 }
 
-static int s3cmci_probe_2440(struct platform_device *dev)
+static int __devinit s3cmci_probe_2440(struct platform_device *dev)
 {
 	return s3cmci_probe(dev, 1);
 }
@@ -1285,29 +1292,29 @@ static int s3cmci_resume(struct platform
 #endif /* CONFIG_PM */
 
 
-static struct platform_driver s3cmci_driver_2410 =
-{
+static struct platform_driver s3cmci_driver_2410 = {
 	.driver.name	= "s3c2410-sdi",
+	.driver.owner	= THIS_MODULE,
 	.probe		= s3cmci_probe_2410,
-	.remove		= s3cmci_remove,
+	.remove		= __devexit_p(s3cmci_remove),
 	.suspend	= s3cmci_suspend,
 	.resume		= s3cmci_resume,
 };
 
-static struct platform_driver s3cmci_driver_2412 =
-{
+static struct platform_driver s3cmci_driver_2412 = {
 	.driver.name	= "s3c2412-sdi",
+	.driver.owner	= THIS_MODULE,
 	.probe		= s3cmci_probe_2412,
-	.remove		= s3cmci_remove,
+	.remove		= __devexit_p(s3cmci_remove),
 	.suspend	= s3cmci_suspend,
 	.resume		= s3cmci_resume,
 };
 
-static struct platform_driver s3cmci_driver_2440 =
-{
+static struct platform_driver s3cmci_driver_2440 = {
 	.driver.name	= "s3c2440-sdi",
+	.driver.owner	= THIS_MODULE,
 	.probe		= s3cmci_probe_2440,
-	.remove		= s3cmci_remove,
+	.remove		= __devexit_p(s3cmci_remove),
 	.suspend	= s3cmci_suspend,
 	.resume		= s3cmci_resume,
 };
@@ -1332,6 +1339,5 @@ module_init(s3cmci_init);
 module_exit(s3cmci_exit);
 
 MODULE_DESCRIPTION("Samsung S3C MMC/SD Card Interface driver");
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Thomas Kleffel <tk@maintech.de>");
-
Index: linux-2.6.26-rc8-next20080627/drivers/mmc/host/s3cmci.h
===================================================================
--- linux-2.6.26-rc8-next20080627.orig/drivers/mmc/host/s3cmci.h	2008-06-30 12:18:49.000000000 +0100
+++ linux-2.6.26-rc8-next20080627/drivers/mmc/host/s3cmci.h	2008-06-30 15:30:30.000000000 +0100
@@ -8,7 +8,7 @@
  * published by the Free Software Foundation.
  */
 
-//FIXME: DMA Resource management ?!
+/* FIXME: DMA Resource management ?! */
 #define S3CMCI_DMA 0
 
 enum s3cmci_waitfor {
@@ -39,32 +39,30 @@ struct s3cmci_host {
 	unsigned		sdiimsk;
 	unsigned		sdidata;
 	int			dodma;
-
-	volatile int		dmatogo;
+	int			dmatogo;
 
 	struct mmc_request	*mrq;
 	int			cmd_is_stop;
 
 	spinlock_t		complete_lock;
-	volatile enum s3cmci_waitfor
-				complete_what;
+	enum s3cmci_waitfor	complete_what;
 
-	volatile int		dma_complete;
+	int			dma_complete;
 
-	volatile u32		pio_sgptr;
-	volatile u32		pio_words;
-	volatile u32		pio_count;
-	volatile u32		*pio_ptr;
+	u32			pio_sgptr;
+	u32			pio_words;
+	u32			pio_count;
+	u32			*pio_ptr;
 #define XFER_NONE 0
 #define XFER_READ 1
 #define XFER_WRITE 2
-	volatile u32		pio_active;
+	u32			pio_active;
 
 	int			bus_width;
 
 	char 			dbgmsg_cmd[301];
 	char 			dbgmsg_dat[301];
-	volatile char		*status;
+	char			*status;
 
 	unsigned int		ccnt, dcnt;
 	struct tasklet_struct	pio_tasklet;

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
