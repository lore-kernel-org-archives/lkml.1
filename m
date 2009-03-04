Return-Path: <linux-kernel-owner+w=401wt.eu-S1757326AbZCDSSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326AbZCDSSV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 13:18:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754879AbZCDSRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 13:17:34 -0500
Received: from [213.79.90.228] ([213.79.90.228]:43921 "EHLO
	buildserver.ru.mvista.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753582AbZCDSRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 13:17:32 -0500
Date: Wed, 4 Mar 2009 20:49:17 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Pierre Ossman <drzeus@drzeus.cx>
Cc: Pierre Ossman <drzeus-sdhci@drzeus.cx>, Ben Dooks <ben-linux@fluff.org>,
       Arnd Bergmann <arnd@arndb.de>, Kumar Gala <galak@kernel.crashing.org>,
       Liu Dave <DaveLiu@freescale.com>, sdhci-devel@list.drzeus.cx,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 05/13] sdhci: Add support for card-detection polling
Message-ID: <20090304174917.GD7477@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090213144630.GA13436@oksana.dev.rtsoft.ru> <20090213144718.GE23889@oksana.dev.rtsoft.ru> <20090221165821.1239aa5a@mjolnir.ossman.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20090221165821.1239aa5a@mjolnir.ossman.eu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 21, 2009 at 04:58:21PM +0100, Pierre Ossman wrote:
> On Fri, 13 Feb 2009 17:47:18 +0300
> Anton Vorontsov <avorontsov@ru.mvista.com> wrote:
> 
> > @@ -1110,13 +1113,18 @@ static void sdhci_request(struct mmc_host *mmc, struct mmc_request *mrq)
> >  
> >  	host->mrq = mrq;
> >  
> > +	if (host->quirks & SDHCI_QUIRK_BROKEN_CARD_DETECTION)
> > +		goto send;
> > +
> >  	if (!(sdhci_readl(host, SDHCI_PRESENT_STATE) & SDHCI_CARD_PRESENT)
> >  		|| (host->flags & SDHCI_DEVICE_DEAD)) {
> >  		host->mrq->cmd->error = -ENOMEDIUM;
> >  		tasklet_schedule(&host->finish_tasklet);
> > -	} else
> > -		sdhci_send_command(host, mrq->cmd);
> > -
> > +		goto out;
> > +	}
> > +send:
> > +	sdhci_send_command(host, mrq->cmd);
> > +out:
> >  	mmiowb();
> >  	spin_unlock_irqrestore(&host->lock, flags);
> >  }
> 
> goto:s seem unnecessary here, and your patch is even incorrect as it
> ignores the SDHCI_DEVICE_DEAD flag.

Oops.

> Just modify the if-clause and
> things will work.

That would look horrid...

        if ((!(host->quirks & SDHCI_QUIRK_BROKEN_CARD_DETECTION) &&
                        !(sdhci_readl(host, SDHCI_PRESENT_STATE) &
                                SDHCI_CARD_PRESENT)) ||
                        (host->flags & SDHCI_DEVICE_DEAD)) {

> Might want to add a comment also to make it more obvious what the
> if-clause does.

Let's try to avoid the if-clause above? How about this:

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 0cbde8e..d71c877 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -167,6 +167,9 @@ static void sdhci_set_card_detection(struct sdhci_host *host, bool enable)
 {
 	u32 irqs = SDHCI_INT_CARD_REMOVE | SDHCI_INT_CARD_INSERT;
 
+	if (host->quirks & SDHCI_QUIRK_BROKEN_CARD_DETECTION)
+		return;
+
 	if (enable)
 		sdhci_unmask_irqs(host, irqs);
 	else
@@ -1096,6 +1099,7 @@ out:
 static void sdhci_request(struct mmc_host *mmc, struct mmc_request *mrq)
 {
 	struct sdhci_host *host;
+	bool present;
 	unsigned long flags;
 
 	host = mmc_priv(mmc);
@@ -1110,8 +1114,14 @@ static void sdhci_request(struct mmc_host *mmc, struct mmc_request *mrq)
 
 	host->mrq = mrq;
 
-	if (!(sdhci_readl(host, SDHCI_PRESENT_STATE) & SDHCI_CARD_PRESENT)
-		|| (host->flags & SDHCI_DEVICE_DEAD)) {
+	/* If polling, assume that the card is always present. */
+	if (host->quirks & SDHCI_QUIRK_BROKEN_CARD_DETECTION)
+		present = true;
+	else
+		present = sdhci_readl(host, SDHCI_PRESENT_STATE) &
+				SDHCI_CARD_PRESENT;
+
+	if (!present || host->flags & SDHCI_DEVICE_DEAD) {
 		host->mrq->cmd->error = -ENOMEDIUM;
 		tasklet_schedule(&host->finish_tasklet);
 	} else
@@ -1745,6 +1755,9 @@ int sdhci_add_host(struct sdhci_host *host)
 	if (caps & SDHCI_CAN_DO_HISPD)
 		mmc->caps |= MMC_CAP_SD_HIGHSPEED;
 
+	if (host->quirks & SDHCI_QUIRK_BROKEN_CARD_DETECTION)
+		mmc->caps |= MMC_CAP_NEEDS_POLL;
+
 	mmc->ocr_avail = 0;
 	if (caps & SDHCI_CAN_VDD_330)
 		mmc->ocr_avail |= MMC_VDD_32_33|MMC_VDD_33_34;
diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
index 1c29895..09a4363 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -212,6 +212,8 @@ struct sdhci_host {
 #define SDHCI_QUIRK_BROKEN_SMALL_PIO			(1<<13)
 /* Controller does not provide transfer-complete interrupt when not busy */
 #define SDHCI_QUIRK_NO_BUSY_IRQ				(1<<14)
+/* Controller has unreliable card detection */
+#define SDHCI_QUIRK_BROKEN_CARD_DETECTION		(1<<15)
 
 	int			irq;		/* Device IRQ */
 	void __iomem *		ioaddr;		/* Mapped address */
