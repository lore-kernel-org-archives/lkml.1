Return-Path: <linux-kernel-owner+w=401wt.eu-S935835AbYEUSs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935835AbYEUSs7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 14:48:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935721AbYEUSrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 14:47:55 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:5341 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760430AbYEUSry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 14:47:54 -0400
Date: Wed, 21 May 2008 22:47:52 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Kumar Gala <galak@kernel.crashing.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: Jochen Friedrich <jochen@scram.de>, Timur Tabi <timur@freescale.com>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       spi-devel-general@lists.sourceforge.net
Subject: [PATCH 2/2] mmc_spi: add support for card-detection polling
Message-ID: <20080521184752.GB32052@polina.dev.rtsoft.ru>
References: <20080521184713.GA30284@polina.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20080521184713.GA30284@polina.dev.rtsoft.ru>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If platform_data lacks init() callback (solely used to request
card-detect interrupt), we mark the host as MMC_CAP_NEEDS_POLL.

get_cd() host operation provided to optimize polling.

p.s. Since mmc_host_ops no longer the same for every instance of
mmc_spi, struct mmc_host_ops can't be const and should be allocated
dynamically.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/mmc/host/mmc_spi.c  |   31 +++++++++++++++++++++----------
 include/linux/spi/mmc_spi.h |    6 ++++++
 2 files changed, 27 insertions(+), 10 deletions(-)

diff --git a/drivers/mmc/host/mmc_spi.c b/drivers/mmc/host/mmc_spi.c
index 3550858..667855a 100644
--- a/drivers/mmc/host/mmc_spi.c
+++ b/drivers/mmc/host/mmc_spi.c
@@ -115,6 +115,7 @@ struct scratch {
 
 struct mmc_spi_host {
 	struct mmc_host		*mmc;
+	struct mmc_host_ops	mmc_spi_ops;
 	struct spi_device	*spi;
 
 	unsigned char		power_mode;
@@ -1131,13 +1132,12 @@ static int mmc_spi_get_ro(struct mmc_host *mmc)
 	return 0;
 }
 
+static int mmc_spi_get_cd(struct mmc_host *mmc)
+{
+	struct mmc_spi_host *host = mmc_priv(mmc);
 
-static const struct mmc_host_ops mmc_spi_ops = {
-	.request	= mmc_spi_request,
-	.set_ios	= mmc_spi_set_ios,
-	.get_ro		= mmc_spi_get_ro,
-};
-
+	return host->pdata->get_cd(mmc->parent);
+}
 
 /****************************************************************************/
 
@@ -1236,8 +1236,12 @@ static int mmc_spi_probe(struct spi_device *spi)
 	mmc = mmc_alloc_host(sizeof(*host), &spi->dev);
 	if (!mmc)
 		goto nomem;
+	host = mmc_priv(mmc);
 
-	mmc->ops = &mmc_spi_ops;
+	host->mmc_spi_ops.request = mmc_spi_request,
+	host->mmc_spi_ops.set_ios = mmc_spi_set_ios,
+	host->mmc_spi_ops.get_ro = mmc_spi_get_ro,
+	mmc->ops = &host->mmc_spi_ops;
 	mmc->max_blk_size = MMC_SPI_BLOCKSIZE;
 
 	/* As long as we keep track of the number of successfully
@@ -1256,7 +1260,6 @@ static int mmc_spi_probe(struct spi_device *spi)
 	mmc->f_min = 400000;
 	mmc->f_max = spi->max_speed_hz;
 
-	host = mmc_priv(mmc);
 	host->mmc = mmc;
 	host->spi = spi;
 
@@ -1323,13 +1326,21 @@ static int mmc_spi_probe(struct spi_device *spi)
 	if (status != 0)
 		goto fail_add_host;
 
-	dev_info(&spi->dev, "SD/MMC host %s%s%s%s\n",
+	if (host->pdata && !host->pdata->init)
+		mmc->caps |= MMC_CAP_NEEDS_POLL;
+
+	if (host->pdata && host->pdata->get_cd)
+		host->mmc_spi_ops.get_cd = mmc_spi_get_cd;
+
+	dev_info(&spi->dev, "SD/MMC host %s%s%s%s%s\n",
 			mmc->class_dev.bus_id,
 			host->dma_dev ? "" : ", no DMA",
 			(host->pdata && host->pdata->get_ro)
 				? "" : ", no WP",
 			(host->pdata && host->pdata->setpower)
-				? "" : ", no poweroff");
+				? "" : ", no poweroff",
+			(mmc->caps & MMC_CAP_NEEDS_POLL)
+				? ", cd polling" : "");
 	return 0;
 
 fail_add_host:
diff --git a/include/linux/spi/mmc_spi.h b/include/linux/spi/mmc_spi.h
index d5ca78b..915faf3 100644
--- a/include/linux/spi/mmc_spi.h
+++ b/include/linux/spi/mmc_spi.h
@@ -23,6 +23,12 @@ struct mmc_spi_platform_data {
 	/* sense switch on sd cards */
 	int (*get_ro)(struct device *);
 
+	/*
+	 * if board does not use CD interrupts, driver can poll the CD
+	 * line using this function.
+	 */
+	int (*get_cd)(struct device *);
+
 	/* how long to debounce card detect, in msecs */
 	u16 detect_delay;
 
-- 
1.5.5.1
