Return-Path: <linux-kernel-owner+w=401wt.eu-S1751272AbZDCNHC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751272AbZDCNHC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 09:07:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761620AbZDCNFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 09:05:45 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:55672 "EHLO
	pophost.sonytel.be" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757551AbZDCNFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 09:05:44 -0400
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       cbe-oss-dev@ozlabs.org,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [PATCH] ps3vram: Replace mutex by spinlock + list
Date: Fri,  3 Apr 2009 15:05:38 +0200
Message-Id: <1238763938-7076-4-git-send-email-Geert.Uytterhoeven@sonycom.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1238763938-7076-3-git-send-email-Geert.Uytterhoeven@sonycom.com>
References: <1238763938-7076-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1238763938-7076-2-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1238763938-7076-3-git-send-email-Geert.Uytterhoeven@sonycom.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the mutex serializing access to the cache.
Instead, queue up new requests on a list if the driver is busy.

This improves sequential write performance by ca. 2%.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 drivers/block/ps3vram.c |   55 ++++++++++++++++++++++++++++++++++------------
 1 files changed, 40 insertions(+), 15 deletions(-)

diff --git a/drivers/block/ps3vram.c b/drivers/block/ps3vram.c
index 3c9ad19..1396038 100644
--- a/drivers/block/ps3vram.c
+++ b/drivers/block/ps3vram.c
@@ -81,8 +81,8 @@ struct ps3vram_priv {
 
 	struct ps3vram_cache cache;
 
-	/* Used to serialize cache/DMA operations */
-	struct mutex lock;
+	spinlock_t lock;	/* protecting list of bios */
+	struct bio *tail;
 };
 
 
@@ -449,8 +449,6 @@ static int ps3vram_read(struct ps3_system_bus_device *dev, loff_t from,
 		offset = (unsigned int) (from & (priv->cache.page_size - 1));
 		avail  = priv->cache.page_size - offset;
 
-		mutex_lock(&priv->lock);
-
 		entry = ps3vram_cache_match(dev, from);
 		cached = CACHE_OFFSET + entry * priv->cache.page_size + offset;
 
@@ -462,8 +460,6 @@ static int ps3vram_read(struct ps3_system_bus_device *dev, loff_t from,
 			avail = count;
 		memcpy(buf, priv->xdr_buf + cached, avail);
 
-		mutex_unlock(&priv->lock);
-
 		buf += avail;
 		count -= avail;
 		from += avail;
@@ -494,8 +490,6 @@ static int ps3vram_write(struct ps3_system_bus_device *dev, loff_t to,
 		offset = (unsigned int) (to & (priv->cache.page_size - 1));
 		avail  = priv->cache.page_size - offset;
 
-		mutex_lock(&priv->lock);
-
 		entry = ps3vram_cache_match(dev, to);
 		cached = CACHE_OFFSET + entry * priv->cache.page_size + offset;
 
@@ -509,8 +503,6 @@ static int ps3vram_write(struct ps3_system_bus_device *dev, loff_t to,
 
 		priv->cache.tags[entry].flags |= CACHE_PAGE_DIRTY;
 
-		mutex_unlock(&priv->lock);
-
 		buf += avail;
 		count -= avail;
 		to += avail;
@@ -552,17 +544,17 @@ static void __devinit ps3vram_proc_init(struct ps3_system_bus_device *dev)
 		dev_warn(&dev->core, "failed to create /proc entry\n");
 }
 
-static int ps3vram_make_request(struct request_queue *q, struct bio *bio)
+static struct bio *ps3vram_do_bio(struct ps3_system_bus_device *dev,
+				  struct bio *bio)
 {
-	struct ps3_system_bus_device *dev = q->queuedata;
+	struct ps3vram_priv *priv = dev->core.driver_data;
 	int write = bio_data_dir(bio) == WRITE;
 	const char *op = write ? "write" : "read";
 	loff_t offset = bio->bi_sector << 9;
 	int error = 0;
 	struct bio_vec *bvec;
 	unsigned int i;
-
-	dev_dbg(&dev->core, "%s\n", __func__);
+	struct bio *next;
 
 	bio_for_each_segment(bvec, bio, i) {
 		/* PS3 is ppc64, so we don't handle highmem */
@@ -593,7 +585,40 @@ static int ps3vram_make_request(struct request_queue *q, struct bio *bio)
 	dev_dbg(&dev->core, "%s completed\n", op);
 
 out:
+	spin_lock_irq(&priv->lock);
+	next = bio->bi_next;
+	if (!next)
+		priv->tail = NULL;
+	else
+		bio->bi_next = NULL;
+	spin_unlock_irq(&priv->lock);
+
 	bio_endio(bio, error);
+	return next;
+}
+
+static int ps3vram_make_request(struct request_queue *q, struct bio *bio)
+{
+	struct ps3_system_bus_device *dev = q->queuedata;
+	struct ps3vram_priv *priv = dev->core.driver_data;
+
+	dev_dbg(&dev->core, "%s\n", __func__);
+
+	spin_lock_irq(&priv->lock);
+	if (priv->tail) {
+		priv->tail->bi_next = bio;
+		priv->tail = bio;
+		spin_unlock_irq(&priv->lock);
+		return 0;
+	}
+
+	priv->tail = bio;
+	spin_unlock_irq(&priv->lock);
+
+	do {
+		bio = ps3vram_do_bio(dev, bio);
+	} while (bio);
+
 	return 0;
 }
 
@@ -613,7 +638,7 @@ static int __devinit ps3vram_probe(struct ps3_system_bus_device *dev)
 		goto fail;
 	}
 
-	mutex_init(&priv->lock);
+	spin_lock_init(&priv->lock);
 	dev->core.driver_data = priv;
 
 	priv = dev->core.driver_data;
-- 
1.6.0.4

