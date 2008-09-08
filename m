Return-Path: <linux-kernel-owner+w=401wt.eu-S1754503AbYIHM7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503AbYIHM7p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 08:59:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753010AbYIHM7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 08:59:09 -0400
Received: from 2-1-3-15a.ens.sth.bostream.se ([82.182.31.214]:39431 "EHLO
	zoo.weinigel.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838AbYIHM7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 08:59:06 -0400
Message-Id: <20080908124909.554600509@zoo.weinigel.se>
References: <20080908124848.541807034@zoo.weinigel.se>
User-Agent: quilt/0.46-1
Date: Mon, 08 Sep 2008 14:48:50 +0200
From: Christer Weinigel <christer@weinigel.se>
To: ben-linux@fluff.org
Cc: linux-kernel@vger.kernel.org, christer@weinigel.se
Subject: [patch 2/3] s3cmci - call pio_tasklet from IRQ
Content-Disposition: inline; filename=s3c_mci-no-tasklet.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scheduling a tasklet to perform the pio transfer introduces a bit of
extra processing, just call pio_tasklet directly from the interrupt
instead.  Writing up to 64 bytes to a FIFO is probably uses less CPU
than scheduling a tasklet anyway.

Signed-off-by: Christer Weinigel <christer@weinigel.se>

Index: linux-2.6.26.2/drivers/mmc/host/s3cmci.c
===================================================================
--- linux-2.6.26.2.orig/drivers/mmc/host/s3cmci.c
+++ linux-2.6.26.2/drivers/mmc/host/s3cmci.c
@@ -361,11 +361,8 @@ static void do_pio_write(struct s3cmci_h
 	enable_imask(host, S3C2410_SDIIMSK_TXFIFOHALF);
 }
 
-static void pio_tasklet(unsigned long data)
+static void pio_tasklet(struct s3cmci_host *host)
 {
-	struct s3cmci_host *host = (struct s3cmci_host *) data;
-
-
 	disable_irq(host->irq);
 
 	if (host->pio_active == XFER_WRITE)
@@ -460,10 +457,10 @@ static irqreturn_t s3cmci_irq(int irq, v
 	if (!host->dodma) {
 		if ((host->pio_active == XFER_WRITE) &&
 		    (mci_fsta & S3C2410_SDIFSTA_TFDET)) {
-
 			disable_imask(host, S3C2410_SDIIMSK_TXFIFOHALF);
-			tasklet_schedule(&host->pio_tasklet);
+			pio_tasklet(host);
 			host->status = "pio tx";
+			goto irq_out;
 		}
 
 		if ((host->pio_active == XFER_READ) &&
@@ -473,8 +470,9 @@ static irqreturn_t s3cmci_irq(int irq, v
 				      S3C2410_SDIIMSK_RXFIFOHALF |
 				      S3C2410_SDIIMSK_RXFIFOLAST);
 
-			tasklet_schedule(&host->pio_tasklet);
+			pio_tasklet(host);
 			host->status = "pio rx";
+			goto irq_out;
 		}
 	}
 
@@ -595,7 +593,7 @@ close_transfer:
 	host->complete_what = COMPLETION_FINALIZE;
 
 	clear_imask(host);
-	tasklet_schedule(&host->pio_tasklet);
+	pio_tasklet(host);
 
 	goto irq_out;
 
@@ -666,7 +664,7 @@ void s3cmci_dma_done_callback(struct s3c
 	host->complete_what = COMPLETION_FINALIZE;
 
 out:
-	tasklet_schedule(&host->pio_tasklet);
+	pio_tasklet(host);
 	spin_unlock_irqrestore(&host->complete_lock, iflags);
 	return;
 
@@ -1198,7 +1196,6 @@ static int __devinit s3cmci_probe(struct
 	}
 
 	spin_lock_init(&host->complete_lock);
-	tasklet_init(&host->pio_tasklet, pio_tasklet, (unsigned long) host);
 
 	if (is2440) {
 		host->sdiimsk	= S3C2440_SDIIMSK;
@@ -1381,7 +1378,6 @@ static int __devexit s3cmci_remove(struc
 
 	clk_put(host->clk);
 
-	tasklet_disable(&host->pio_tasklet);
 	s3c2410_dma_free(S3CMCI_DMA, &s3cmci_dma_client);
 
 	free_irq(host->irq, host);
Index: linux-2.6.26.2/drivers/mmc/host/s3cmci.h
===================================================================
--- linux-2.6.26.2.orig/drivers/mmc/host/s3cmci.h
+++ linux-2.6.26.2/drivers/mmc/host/s3cmci.h
@@ -66,5 +66,4 @@ struct s3cmci_host {
 	char			*status;
 
 	unsigned int		ccnt, dcnt;
-	struct tasklet_struct	pio_tasklet;
 };

-- 
"Just how much can I get away with and still go to heaven?"

Christer Weinigel <christer@weinigel.se>  http://www.weinigel.se
