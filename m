Return-Path: <linux-kernel-owner+w=401wt.eu-S1759483AbYEVSSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759483AbYEVSSr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 14:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756982AbYEVSSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 14:18:23 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:8468 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755598AbYEVSSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 14:18:22 -0400
Date: Thu, 22 May 2008 22:18:21 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Kumar Gala <galak@kernel.crashing.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: Jochen Friedrich <jochen@scram.de>, Timur Tabi <timur@freescale.com>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       spi-devel-general@lists.sourceforge.net
Subject: [PATCH 1/3] mmc: add support for card-detection polling
Message-ID: <20080522181821.GA6104@polina.dev.rtsoft.ru>
References: <20080522181713.GA26918@polina.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20080522181713.GA26918@polina.dev.rtsoft.ru>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some hosts (and boards that use mmc_spi) do not use interrupts on the CD
line, so they can't trigger mmc_detect_change. We want to poll the card
and see if there was a change. 1 second poll interval seems resonable.

This patch also implements .get_cd() host operation, that could be used
by the hosts that are able to report card-detect status without need to
talk MMC.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/mmc/core/core.c  |   12 +++++++++---
 include/linux/mmc/host.h |    8 ++++++++
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 01ced4c..ede5d1e 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -638,6 +638,9 @@ void mmc_rescan(struct work_struct *work)
 		 */
 		mmc_bus_put(host);
 
+		if (host->ops->get_cd && host->ops->get_cd(host) == 0)
+			goto out;
+
 		mmc_claim_host(host);
 
 		mmc_power_up(host);
@@ -652,7 +655,7 @@ void mmc_rescan(struct work_struct *work)
 		if (!err) {
 			if (mmc_attach_sdio(host, ocr))
 				mmc_power_off(host);
-			return;
+			goto out;
 		}
 
 		/*
@@ -662,7 +665,7 @@ void mmc_rescan(struct work_struct *work)
 		if (!err) {
 			if (mmc_attach_sd(host, ocr))
 				mmc_power_off(host);
-			return;
+			goto out;
 		}
 
 		/*
@@ -672,7 +675,7 @@ void mmc_rescan(struct work_struct *work)
 		if (!err) {
 			if (mmc_attach_mmc(host, ocr))
 				mmc_power_off(host);
-			return;
+			goto out;
 		}
 
 		mmc_release_host(host);
@@ -683,6 +686,9 @@ void mmc_rescan(struct work_struct *work)
 
 		mmc_bus_put(host);
 	}
+out:
+	if (host->caps & MMC_CAP_NEEDS_POLL)
+		mmc_schedule_delayed_work(&host->detect, HZ);
 }
 
 void mmc_start_host(struct mmc_host *host)
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 7ab962f..f2e9885 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -51,8 +51,15 @@ struct mmc_ios {
 
 struct mmc_host_ops {
 	void	(*request)(struct mmc_host *host, struct mmc_request *req);
+	/*
+	 * Avoid calling these three functions too often or in a "fast path",
+	 * since underlaying controller might implement them in an expensive
+	 * and/or slow way.
+	 */
 	void	(*set_ios)(struct mmc_host *host, struct mmc_ios *ios);
 	int	(*get_ro)(struct mmc_host *host);
+	int	(*get_cd)(struct mmc_host *host);
+
 	void	(*enable_sdio_irq)(struct mmc_host *host, int enable);
 };
 
@@ -94,6 +101,7 @@ struct mmc_host {
 #define MMC_CAP_SD_HIGHSPEED	(1 << 3)	/* Can do SD high-speed timing */
 #define MMC_CAP_SDIO_IRQ	(1 << 4)	/* Can signal pending SDIO IRQs */
 #define MMC_CAP_SPI		(1 << 5)	/* Talks only SPI protocols */
+#define MMC_CAP_NEEDS_POLL	(1 << 6)	/* Needs polling for card-detection */
 
 	/* host specific block data */
 	unsigned int		max_seg_size;	/* see blk_queue_max_segment_size */
-- 
1.5.5.1

