Return-Path: <linux-kernel-owner+w=401wt.eu-S1754117AbYIHM7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117AbYIHM7S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 08:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752847AbYIHM7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 08:59:07 -0400
Received: from 2-1-3-15a.ens.sth.bostream.se ([82.182.31.214]:39428 "EHLO
	zoo.weinigel.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749AbYIHM7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 08:59:06 -0400
X-Greylist: delayed 595 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Sep 2008 08:59:05 EDT
Message-Id: <20080908124910.107466441@zoo.weinigel.se>
References: <20080908124848.541807034@zoo.weinigel.se>
User-Agent: quilt/0.46-1
Date: Mon, 08 Sep 2008 14:48:51 +0200
From: Christer Weinigel <christer@weinigel.se>
To: ben-linux@fluff.org
Cc: linux-kernel@vger.kernel.org, christer@weinigel.se
Subject: [patch 3/3] s3cmci - add SDIO interrupt support
Content-Disposition: inline; filename=s3c_mci-sdio-irq.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support for the SDIO irq to the s3cmci driver.

The driver calls to enable_irq and disable_irq are not matched
properly when doing SDIO, so I've worked around this by counting the
number of enables and disables.  This is not the proper way to do it,
but makes things work for me the moment on a Samsung S3C24A0
processor.  There are supposed to be issues with spurious interrupts
on some S3C processors, so this needs more investigation and testing,
but I thought this patch may be useful anyway.

Signed-off-by: Christer Weinigel <christer@weinigel.se>

Index: linux-2.6.26.2/drivers/mmc/host/s3cmci.c
===================================================================
--- linux-2.6.26.2.orig/drivers/mmc/host/s3cmci.c
+++ linux-2.6.26.2/drivers/mmc/host/s3cmci.c
@@ -187,7 +187,11 @@ static inline u32 disable_imask(struct s
 
 static inline void clear_imask(struct s3cmci_host *host)
 {
-	writel(0, host->base + host->sdiimsk);
+	u32 newmask;
+
+	newmask = readl(host->base + host->sdiimsk);
+	newmask &= S3C2410_SDIIMSK_SDIOIRQ;
+	writel(newmask, host->base + host->sdiimsk);
 }
 
 static inline int get_data_buffer(struct s3cmci_host *host,
@@ -364,6 +368,7 @@ static void do_pio_write(struct s3cmci_h
 static void pio_tasklet(struct s3cmci_host *host)
 {
 	disable_irq(host->irq);
+	host->irq_disabled++;
 
 	if (host->pio_active == XFER_WRITE)
 		do_pio_write(host);
@@ -384,8 +389,12 @@ static void pio_tasklet(struct s3cmci_ho
 		}
 
 		finalize_request(host);
-	} else
+	}
+
+	if (host->irq_disabled) {
 		enable_irq(host->irq);
+		host->irq_disabled--;
+	}
 }
 
 /*
@@ -422,6 +431,7 @@ static irqreturn_t s3cmci_irq(int irq, v
 	u32 mci_csta, mci_dsta, mci_fsta, mci_dcnt, mci_imsk;
 	u32 mci_cclear, mci_dclear;
 	unsigned long iflags;
+	int cardint = 0;
 
 	spin_lock_irqsave(&host->complete_lock, iflags);
 
@@ -433,6 +443,13 @@ static irqreturn_t s3cmci_irq(int irq, v
 	mci_cclear = 0;
 	mci_dclear = 0;
 
+	if (mci_dsta & S3C2410_SDIDSTA_SDIOIRQDETECT &&
+	    mci_imsk & S3C2410_SDIIMSK_SDIOIRQ) {
+		cardint = 1;
+		mci_dclear = S3C2410_SDIDSTA_SDIOIRQDETECT;
+		goto clear_status_bits;
+	}
+
 	if ((host->complete_what == COMPLETION_NONE) ||
 	    (host->complete_what == COMPLETION_FINALIZE)) {
 		host->status = "nothing to complete";
@@ -603,8 +620,12 @@ irq_out:
 	    mci_csta, mci_dsta, mci_fsta, mci_dcnt, host->status);
 
 	spin_unlock_irqrestore(&host->complete_lock, iflags);
-	return IRQ_HANDLED;
 
+	/* We have to delay this as it calls back into the driver. */
+	if (cardint)
+		mmc_signal_sdio_irq(host->mmc);
+
+	return IRQ_HANDLED;
 }
 
 /*
@@ -671,7 +692,7 @@ out:
 fail_request:
 	host->mrq->data->error = -EINVAL;
 	host->complete_what = COMPLETION_FINALIZE;
-	writel(0, host->base + host->sdiimsk);
+	clear_imask(host);
 	goto out;
 
 }
@@ -716,7 +737,7 @@ static void finalize_request(struct s3cm
 	writel(0, host->base + S3C2410_SDICMDARG);
 	writel(S3C2410_SDIDCON_STOP, host->base + S3C2410_SDIDCON);
 	writel(0, host->base + S3C2410_SDICMDCON);
-	writel(0, host->base + host->sdiimsk);
+	clear_imask(host);
 
 	if (cmd->data && cmd->error)
 		cmd->data->error = cmd->error;
@@ -1026,7 +1047,10 @@ static void s3cmci_send_request(struct m
 	s3cmci_send_command(host, cmd);
 
 	/* Enable Interrupt */
-	enable_irq(host->irq);
+	if (host->irq_disabled) {
+		enable_irq(host->irq);
+		host->irq_disabled--;
+	}
 }
 
 static int s3cmci_card_present(struct s3cmci_host *host)
@@ -1119,9 +1143,9 @@ static void s3cmci_set_ios(struct mmc_ho
 
 	/* Set CLOCK_ENABLE */
 	if (ios->clock)
-		mci_con |= S3C2410_SDICON_CLOCKTYPE;
+		mci_con |= S3C2410_SDICON_CLOCKTYPE | S3C2410_SDICON_SDIOIRQ;
 	else
-		mci_con &= ~S3C2410_SDICON_CLOCKTYPE;
+		mci_con &= ~(S3C2410_SDICON_CLOCKTYPE | S3C2410_SDICON_SDIOIRQ);
 
 	writel(mci_con, host->base + S3C2410_SDICON);
 
@@ -1161,10 +1185,26 @@ static int s3cmci_get_ro(struct mmc_host
 	return ret;
 }
 
+static void s3cmci_enable_sdio_irq(struct mmc_host *mmc, int enable)
+{
+	struct s3cmci_host *host = mmc_priv(mmc);
+	unsigned long flags;
+
+	spin_lock_irqsave(&host->complete_lock, flags);
+
+	if (enable)
+		enable_imask(host, S3C2410_SDIIMSK_SDIOIRQ);
+	else
+		disable_imask(host, S3C2410_SDIIMSK_SDIOIRQ);
+
+	spin_unlock_irqrestore(&host->complete_lock, flags);
+}
+
 static struct mmc_host_ops s3cmci_ops = {
 	.request	= s3cmci_request,
 	.set_ios	= s3cmci_set_ios,
 	.get_ro		= s3cmci_get_ro,
+	.enable_sdio_irq = s3cmci_enable_sdio_irq,
 };
 
 static struct s3c24xx_mci_pdata s3cmci_def_pdata = {
@@ -1256,6 +1296,7 @@ static int __devinit s3cmci_probe(struct
 	 * ensure we don't lock the system with un-serviceable requests. */
 
 	disable_irq(host->irq);
+	host->irq_disabled++;
 
 	host->irq_cd = s3c2410_gpio_getirq(host->pdata->gpio_detect);
 
@@ -1301,7 +1342,7 @@ static int __devinit s3cmci_probe(struct
 
 	mmc->ops 	= &s3cmci_ops;
 	mmc->ocr_avail	= MMC_VDD_32_33 | MMC_VDD_33_34;
-	mmc->caps	= MMC_CAP_4_BIT_DATA;
+	mmc->caps	= MMC_CAP_4_BIT_DATA | MMC_CAP_SDIO_IRQ;
 	mmc->f_min 	= host->clk_rate / (host->clk_div * 256);
 	mmc->f_max 	= host->clk_rate / host->clk_div;
 
Index: linux-2.6.26.2/drivers/mmc/host/s3cmci.h
===================================================================
--- linux-2.6.26.2.orig/drivers/mmc/host/s3cmci.h
+++ linux-2.6.26.2/drivers/mmc/host/s3cmci.h
@@ -41,6 +41,7 @@ struct s3cmci_host {
 	unsigned		sdidata;
 	int			dodma;
 	int			dmatogo;
+	int                     irq_disabled;
 
 	struct mmc_request	*mrq;
 	int			cmd_is_stop;

-- 
"Just how much can I get away with and still go to heaven?"

Christer Weinigel <christer@weinigel.se>  http://www.weinigel.se
