Return-Path: <linux-kernel-owner+w=401wt.eu-S1762151AbZCaDOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762151AbZCaDOn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 23:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754241AbZCaDOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 23:14:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39517 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753191AbZCaDOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 23:14:32 -0400
Date: Mon, 30 Mar 2009 23:14:26 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: jens.axboe@oracle.com
cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] remove virtual merge accounting
In-Reply-To: <Pine.LNX.4.64.0903302311490.6158@hs20-bc2-1.build.redhat.com>
Message-ID: <Pine.LNX.4.64.0903302314030.6158@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0903302311490.6158@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove max_hw_segs from MMC stack.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/mmc/card/queue.c     |    5 ++---
 drivers/mmc/core/host.c      |    1 -
 drivers/mmc/host/atmel-mci.c |    1 -
 drivers/mmc/host/imxmmc.c    |    1 -
 drivers/mmc/host/mmci.c      |    1 -
 drivers/mmc/host/omap.c      |    1 -
 drivers/mmc/host/s3cmci.c    |    1 -
 drivers/mmc/host/sdhci.c     |    7 +++----
 drivers/mmc/host/tifm_sd.c   |    3 +--
 drivers/mmc/host/wbsd.c      |    1 -
 include/linux/mmc/host.h     |    1 -
 11 files changed, 6 insertions(+), 17 deletions(-)

diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
index 7a32cbe..2bdef90 100644
--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -135,7 +135,7 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card, spinlock_t *lock
 	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, mq->queue);
 
 #ifdef CONFIG_MMC_BLOCK_BOUNCE
-	if (host->max_hw_segs == 1) {
+	if (host->max_phys_segs == 1) {
 		unsigned int bouncesz;
 
 		bouncesz = MMC_QUEUE_BOUNCESZ;
@@ -185,8 +185,7 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card, spinlock_t *lock
 		blk_queue_bounce_limit(mq->queue, limit);
 		blk_queue_max_sectors(mq->queue,
 			min(host->max_blk_count, host->max_req_size / 512));
-	/* TODO: drop host->max_hw_segs */
-		blk_queue_max_phys_segments(mq->queue, min(host->max_phys_segs, host->max_hw_segs));
+		blk_queue_max_phys_segments(mq->queue, host->max_phys_segs);
 		blk_queue_max_segment_size(mq->queue, host->max_seg_size);
 
 		mq->sg = kmalloc(sizeof(struct scatterlist) *
diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
index 5e945e6..ef7d270 100644
--- a/drivers/mmc/core/host.c
+++ b/drivers/mmc/core/host.c
@@ -88,7 +88,6 @@ struct mmc_host *mmc_alloc_host(int extra, struct device *dev)
 	 * By default, hosts do not support SGIO or large requests.
 	 * They have to set these according to their abilities.
 	 */
-	host->max_hw_segs = 1;
 	host->max_phys_segs = 1;
 	host->max_seg_size = PAGE_CACHE_SIZE;
 
diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index 2b1196e..89992ea 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -1465,7 +1465,6 @@ static int __init atmci_init_slot(struct atmel_mci *host,
 	if (slot_data->bus_width >= 4)
 		mmc->caps |= MMC_CAP_4_BIT_DATA;
 
-	mmc->max_hw_segs = 64;
 	mmc->max_phys_segs = 64;
 	mmc->max_req_size = 32768 * 512;
 	mmc->max_blk_size = 32768;
diff --git a/drivers/mmc/host/imxmmc.c b/drivers/mmc/host/imxmmc.c
index eb29b1d..adcfb57 100644
--- a/drivers/mmc/host/imxmmc.c
+++ b/drivers/mmc/host/imxmmc.c
@@ -970,7 +970,6 @@ static int imxmci_probe(struct platform_device *pdev)
 	mmc->caps = MMC_CAP_4_BIT_DATA;
 
 	/* MMC core transfer sizes tunable parameters */
-	mmc->max_hw_segs = 64;
 	mmc->max_phys_segs = 64;
 	mmc->max_seg_size = 64*512;	/* default PAGE_CACHE_SIZE */
 	mmc->max_req_size = 64*512;	/* default PAGE_CACHE_SIZE */
diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index 2909bbc..55e473d 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -560,7 +560,6 @@ static int mmci_probe(struct amba_device *dev, void *id)
 	/*
 	 * We can do SGIO
 	 */
-	mmc->max_hw_segs = 16;
 	mmc->max_phys_segs = NR_SG;
 
 	/*
diff --git a/drivers/mmc/host/omap.c b/drivers/mmc/host/omap.c
index 67d7b7f..0374711 100644
--- a/drivers/mmc/host/omap.c
+++ b/drivers/mmc/host/omap.c
@@ -1336,7 +1336,6 @@ static int __init mmc_omap_new_slot(struct mmc_omap_host *host, int id)
 	 * normally used (except e.g. for reading SD registers).
 	 */
 	mmc->max_phys_segs = 32;
-	mmc->max_hw_segs = 32;
 	mmc->max_blk_size = 2048;	/* BLEN is 11 bits (+1) */
 	mmc->max_blk_count = 2048;	/* NBLK is 11 bits (+1) */
 	mmc->max_req_size = mmc->max_blk_size * mmc->max_blk_count;
diff --git a/drivers/mmc/host/s3cmci.c b/drivers/mmc/host/s3cmci.c
index 2db166b..0918a73 100644
--- a/drivers/mmc/host/s3cmci.c
+++ b/drivers/mmc/host/s3cmci.c
@@ -1388,7 +1388,6 @@ static int __devinit s3cmci_probe(struct platform_device *pdev, int is2440)
 	mmc->max_seg_size	= mmc->max_req_size;
 
 	mmc->max_phys_segs	= 128;
-	mmc->max_hw_segs	= 128;
 
 	dbg(host, dbg_debug,
 	    "probe: mode:%s mapped mci_base:%p irq:%u irq_cd:%u dma:%u.\n",
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index accb592..8fed9d2 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1663,12 +1663,11 @@ int sdhci_add_host(struct sdhci_host *host)
 	 * can do scatter/gather or not.
 	 */
 	if (host->flags & SDHCI_USE_ADMA)
-		mmc->max_hw_segs = 128;
+		mmc->max_phys_segs = 128;
 	else if (host->flags & SDHCI_USE_DMA)
-		mmc->max_hw_segs = 1;
+		mmc->max_phys_segs = 1;
 	else /* PIO */
-		mmc->max_hw_segs = 128;
-	mmc->max_phys_segs = 128;
+		mmc->max_phys_segs = 128;
 
 	/*
 	 * Maximum number of sectors in one transfer. Limited by DMA boundary
diff --git a/drivers/mmc/host/tifm_sd.c b/drivers/mmc/host/tifm_sd.c
index 82554dd..6193bc9 100644
--- a/drivers/mmc/host/tifm_sd.c
+++ b/drivers/mmc/host/tifm_sd.c
@@ -978,11 +978,10 @@ static int tifm_sd_probe(struct tifm_dev *sock)
 	mmc->f_max = 24000000;
 
 	mmc->max_blk_count = 2048;
-	mmc->max_hw_segs = mmc->max_blk_count;
+	mmc->max_phys_segs = mmc->max_blk_count;
 	mmc->max_blk_size = min(TIFM_MMCSD_MAX_BLOCK_SIZE, PAGE_SIZE);
 	mmc->max_seg_size = mmc->max_blk_count * mmc->max_blk_size;
 	mmc->max_req_size = mmc->max_seg_size;
-	mmc->max_phys_segs = mmc->max_hw_segs;
 
 	sock->card_event = tifm_sd_card_event;
 	sock->data_event = tifm_sd_data_event;
diff --git a/drivers/mmc/host/wbsd.c b/drivers/mmc/host/wbsd.c
index adda379..034ccc4 100644
--- a/drivers/mmc/host/wbsd.c
+++ b/drivers/mmc/host/wbsd.c
@@ -1234,7 +1234,6 @@ static int __devinit wbsd_alloc_mmc(struct device *dev)
 	 * Maximum number of segments. Worst case is one sector per segment
 	 * so this will be 64kB/512.
 	 */
-	mmc->max_hw_segs = 128;
 	mmc->max_phys_segs = 128;
 
 	/*
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 4e45725..6c7e83b 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -121,7 +121,6 @@ struct mmc_host {
 
 	/* host specific block data */
 	unsigned int		max_seg_size;	/* see blk_queue_max_segment_size */
-	unsigned short		max_hw_segs;	/* see blk_queue_max_hw_segments */
 	unsigned short		max_phys_segs;	/* see blk_queue_max_phys_segments */
 	unsigned short		unused;
 	unsigned int		max_req_size;	/* maximum number of bytes in one req */
-- 
1.5.6.5


