Return-Path: <linux-kernel-owner+w=401wt.eu-S1756175AbYEWPoJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175AbYEWPoJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 11:44:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755949AbYEWPnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 11:43:46 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:2524 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755331AbYEWPnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 11:43:45 -0400
Date: Fri, 23 May 2008 19:43:43 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Kumar Gala <galak@kernel.crashing.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: Jochen Friedrich <jochen@scram.de>, Timur Tabi <timur@freescale.com>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       spi-devel-general@lists.sourceforge.net
Subject: [PATCH 2/3] mmc_spi: add support for card-detection polling
Message-ID: <20080523154343.GB24862@polina.dev.rtsoft.ru>
References: <20080523154204.GA19803@polina.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20080523154204.GA19803@polina.dev.rtsoft.ru>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds new platform data variable "caps", so platforms
could pass theirs capabilities into MMC core (for example, platforms
without interrupt on the CD line will most probably want to pass
MMC_CAP_NEEDS_POLL).

New platform get_cd() callback provided to optimize polling.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/mmc/host/mmc_spi.c  |   19 +++++++++++++++++--
 include/linux/spi/mmc_spi.h |    9 +++++++++
 2 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/mmc_spi.c b/drivers/mmc/host/mmc_spi.c
index 3550858..724870c 100644
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
 
 
@@ -1319,17 +1328,23 @@ static int mmc_spi_probe(struct spi_device *spi)
 			goto fail_glue_init;
 	}
 
+	/* pass platform capabilities, if any */
+	if (host->pdata)
+		mmc->caps |= host->pdata->caps;
+
 	status = mmc_add_host(mmc);
 	if (status != 0)
 		goto fail_add_host;
 
-	dev_info(&spi->dev, "SD/MMC host %s%s%s%s\n",
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
index d5ca78b..a3626ae 100644
--- a/include/linux/spi/mmc_spi.h
+++ b/include/linux/spi/mmc_spi.h
@@ -23,6 +23,15 @@ struct mmc_spi_platform_data {
 	/* sense switch on sd cards */
 	int (*get_ro)(struct device *);
 
+	/*
+	 * If board does not use CD interrupts, driver can optimize polling
+	 * using this function.
+	 */
+	int (*get_cd)(struct device *);
+
+	/* Capabilities to pass into mmc core (e.g. MMC_CAP_NEEDS_POLL). */
+	unsigned long caps;
+
 	/* how long to debounce card detect, in msecs */
 	u16 detect_delay;
 
-- 
1.5.5.1

