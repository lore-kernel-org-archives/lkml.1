Return-Path: <linux-kernel-owner+w=401wt.eu-S1758951AbYEVSTO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758951AbYEVSTO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 14:19:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757215AbYEVSSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 14:18:25 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:8479 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757054AbYEVSSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 14:18:24 -0400
Date: Thu, 22 May 2008 22:18:23 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Kumar Gala <galak@kernel.crashing.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: Jochen Friedrich <jochen@scram.de>, Timur Tabi <timur@freescale.com>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       spi-devel-general@lists.sourceforge.net
Subject: [PATCH 2/3] mmc_spi: add support for card-detection polling
Message-ID: <20080522181823.GB6104@polina.dev.rtsoft.ru>
References: <20080522181713.GA26918@polina.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20080522181713.GA26918@polina.dev.rtsoft.ru>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If platform_data lacks init() callback (solely used to request
card-detect interrupt), we mark the host as MMC_CAP_NEEDS_POLL.

get_cd() host operation provided to optimize polling.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/mmc/host/mmc_spi.c  |   18 ++++++++++++++++--
 include/linux/spi/mmc_spi.h |    6 ++++++
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/mmc_spi.c b/drivers/mmc/host/mmc_spi.c
index 3550858..f0f86b1 100644
--- a/drivers/mmc/host/mmc_spi.c
+++ b/drivers/mmc/host/mmc_spi.c
@@ -1131,11 +1131,20 @@ static int mmc_spi_get_ro(struct mmc_host *mmc)
 	return 0;
 }
 
+static int mmc_spi_get_cd(struct mmc_host *mmc)
+{
+	struct mmc_spi_host *host = mmc_priv(mmc);
+
+	if (host->pdata && host->pdata->get_cd)
+		return host->pdata->get_cd(mmc->parent);
+	return -ENOSYS;
+}
 
 static const struct mmc_host_ops mmc_spi_ops = {
 	.request	= mmc_spi_request,
 	.set_ios	= mmc_spi_set_ios,
 	.get_ro		= mmc_spi_get_ro,
+	.get_cd		= mmc_spi_get_cd,
 };
 
 
@@ -1323,13 +1332,18 @@ static int mmc_spi_probe(struct spi_device *spi)
 	if (status != 0)
 		goto fail_add_host;
 
-	dev_info(&spi->dev, "SD/MMC host %s%s%s%s\n",
+	if (host->pdata && !host->pdata->init)
+		mmc->caps |= MMC_CAP_NEEDS_POLL;
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
index d5ca78b..23c6923 100644
--- a/include/linux/spi/mmc_spi.h
+++ b/include/linux/spi/mmc_spi.h
@@ -23,6 +23,12 @@ struct mmc_spi_platform_data {
 	/* sense switch on sd cards */
 	int (*get_ro)(struct device *);
 
+	/*
+	 * If board does not use CD interrupts, driver can optimize polling
+	 * using this function.
+	 */
+	int (*get_cd)(struct device *);
+
 	/* how long to debounce card detect, in msecs */
 	u16 detect_delay;
 
-- 
1.5.5.1

