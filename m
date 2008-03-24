Return-Path: <linux-kernel-owner+w=401wt.eu-S1761176AbYCXRHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761176AbYCXRHi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 13:07:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755792AbYCXRHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 13:07:30 -0400
Received: from lazybastard.de ([212.112.238.170]:59598 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353AbYCXRH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 13:07:28 -0400
Date: Mon, 24 Mar 2008 18:07:07 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: Paul Mundt <lethal@linux-sh.org>, Greg KH <greg@kroah.com>,
       dwmw2 <dwmw2@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       MTD <linux-mtd@lists.infradead.org>,
       linux-sh <linux-sh@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] 3/3 maple: update bus driver to support Dreamcast VMU
Message-ID: <20080324170707.GH2899@logfs.org>
References: <1206207805.6324.13.camel@localhost.localdomain> <1206209786.6324.41.camel@localhost.localdomain> <20080324033344.GB15872@linux-sh.org> <20080324144647.GC2899@logfs.org> <1206371178.6283.37.camel@localhost.localdomain> <20080324152952.GF2899@logfs.org> <1206373900.6283.39.camel@localhost.localdomain> <20080324160429.GG2899@logfs.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="O5XBE6gyVG5Rl6Rj"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080324160429.GG2899@logfs.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--O5XBE6gyVG5Rl6Rj
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, 24 March 2008 17:04:29 +0100, JÃ¶rn Engel wrote:
> 
> Then we should be fine.  I'll try to beat the code into submission.

And here go two more interesting patches.  The first is removing all
locking from the mtd driver.  Since the existing locking code is nearly
impossibly to verify, I'd rather have something simple and wrong than
something complicated and wrong.

The second rearranges the list locking a bit.  Previously it was
possible to touch maple_waitq or maple_sentq without holding the lock.
With my limited understanding of the driver, the second patch may
already be enough to prevent the type of corruption you've been seeing.

JÃ¶rn

-- 
If a problem has a hardware solution, and a software solution,
do it in software.
-- Arnd Bergmann

--O5XBE6gyVG5Rl6Rj
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="cu6.patch"
Content-Transfer-Encoding: 8bit


Remove all locking with mq->mutex.

Signed-off-by: Jörn Engel <joern@logfs.org>
---

 drivers/mtd/maps/vmu_flash.c |   60 +++----------------------------------------
 drivers/sh/maple/maple.c     |   33 +----------------------
 2 files changed, 7 insertions(+), 86 deletions(-)


--- maple/drivers/mtd/maps/vmu_flash.c~cu6	2008-03-24 17:12:15.000000000 +0100
+++ maple/drivers/mtd/maps/vmu_flash.c	2008-03-24 17:37:22.000000000 +0100
@@ -132,7 +132,7 @@ static int maple_vmu_read_block(unsigned
 	struct memcard *card;
 	struct mdev_part *mpart;
 	struct maple_device *mdev;
-	int partition, error = 0, locking;
+	int partition, error = 0;
 	__be32 *sendbuf;
 
 	mpart = mtd->priv;
@@ -140,16 +140,6 @@ static int maple_vmu_read_block(unsigned
 	partition = mpart->partition;
 	card = mdev->private_data;
 
-	/*
-	 * Maple devices include a mutex to ensure packets injected into
-	 * the wait queue are not corrupted via scans for hotplug events etc
-	 */
-	locking = mutex_lock_interruptible(&mdev->mq->mutex);
-	if (locking) {
-		printk(KERN_INFO "Maple: VMU at (%d, %d) is locked -"
-			" aborting read\n", mdev->unit, mdev->port);
-		goto fail_nosendbuf;
-	}
 	mdev->mq->command = MAPLE_COMMAND_BREAD;
 	mdev->mq->length = 2;
 
@@ -191,8 +181,6 @@ fail_blockread:
 fail_bralloc:
 	kfree(sendbuf);
 fail_nosendbuf:
-	if (mutex_is_locked(&mdev->mq->mutex))
-		mutex_unlock(&mdev->mq->mutex);
 	return error;
 }
 
@@ -203,7 +191,7 @@ static int maple_vmu_write_block(unsigne
 	struct memcard *card;
 	struct mdev_part *mpart;
 	struct maple_device *mdev;
-	int partition, error, locking, x, phaselen;
+	int partition, error, x, phaselen;
 	__be32 *sendbuf;
 
 	mpart = mtd->priv;
@@ -224,39 +212,18 @@ static int maple_vmu_write_block(unsigne
 	sendbuf[0] = cpu_to_be32(MAPLE_FUNC_MEMCARD);
 
 	for (x = 0; x < card->writecnt; x++) {
-		/* take the lock to protect the contents of sendbuf */
-		locking = mutex_lock_interruptible(&mdev->mq->mutex);
-		if (locking) {
-			error = -EBUSY;
-			goto fail_nolock;
-		}
 		sendbuf[1] = cpu_to_be32(partition << 24 | x << 16 | num);
 		memcpy(sendbuf + 8, buf + phaselen * x, phaselen);
 		mdev->mq->sendbuf = sendbuf;
 		maple_add_packet(mdev->mq);
 	}
-	/*
-	 * The Maple bus driver will unlock the mutex once the command
-	 * has been processed, so we'll just sleep waiting for the unlock */
-	locking = mutex_lock_interruptible(&mdev->mq->mutex);
-	if (locking) {
-		error = -EBUSY;
-		goto fail_nolock;
-	}
-	mutex_unlock(&mdev->mq->mutex);
 
 	kfree(sendbuf);
 
 	return card->blocklen;
 
-fail_nolock:
-	printk(KERN_INFO "Maple: VMU at (%d, %d) is locked -"
-		" aborting write\n", mdev->unit, mdev->port);
-	kfree(sendbuf);
 fail_nosendbuf:
 	printk("Maple: VMU (%d, %d): write failed\n", mdev->port, mdev->unit);
-	if (mutex_is_locked(&mdev->mq->mutex))
-		mutex_unlock(&mdev->mq->mutex);
 	return error;
 }
 
@@ -482,7 +449,7 @@ static void vmu_queryblocks(struct maple
 	struct mdev_part *mpart;
 	struct mtd_info *mtd_cur;
 	struct vmupart *part_cur;
-	int error, locking;
+	int error;
 
 	mdev = mq->dev;
 	card = mdev->private_data;
@@ -553,10 +520,6 @@ static void vmu_queryblocks(struct maple
 		mdev->mq->sendbuf = sendbuf;
 		maple_getcond_callback(mdev, vmu_queryblocks, 0,
 			MAPLE_FUNC_MEMCARD);
-
-		locking = mutex_lock_interruptible(&(mdev->mq->mutex));
-		if (!locking)
-			maple_add_packet(mdev->mq);
 	}
 
 	return;
@@ -586,7 +549,7 @@ fail_name:
 static int vmu_connect(struct maple_device *mdev)
 {
 	unsigned long test_flash_data, basic_flash_data;
-	int c, locking, error = 0;
+	int c, error = 0;
 	struct memcard *card;
 	void *sendbuf;
 
@@ -648,10 +611,6 @@ static int vmu_connect(struct maple_devi
 	maple_getcond_callback(mdev, vmu_queryblocks, 0,
 		MAPLE_FUNC_MEMCARD);
 
-	locking = mutex_lock_interruptible(&(mdev->mq->mutex));
-	if (!locking)
-		maple_add_packet(mdev->mq);
-
 	return 0;
 
 fail_nosendbuf:
@@ -667,15 +626,8 @@ fail_nomem:
 static void vmu_disconnect(struct maple_device *mdev)
 {
 	struct memcard *card;
-	int x, locking;
+	int x;
 
-	/* Seek lock to ensure smooth removal */
-	locking = mutex_lock_interruptible(&mdev->mq->mutex);
-	if (locking) {
-		printk(KERN_INFO "Maple: Could not disconnect VMU device at:"
-			"(%d, %d)\n", mdev->port, mdev->unit);
-		return;
-	}
 	mdev->callback = NULL;
 	card = mdev->private_data;
 	for (x = 0; x < card->partitions; x++) {
@@ -685,8 +637,6 @@ static void vmu_disconnect(struct maple_
 	kfree(card->parts);
 	kfree(card->mtd);
 	kfree(card);
-	mutex_unlock(&mdev->mq->mutex);
-
 }
 
 static int probe_maple_vmu(struct device *dev)
--- maple/drivers/sh/maple/maple.c~cu6	2008-03-24 14:40:26.000000000 +0100
+++ maple/drivers/sh/maple/maple.c	2008-03-24 17:49:51.000000000 +0100
@@ -381,14 +381,7 @@ static int setup_maple_commands(struct d
 {
 	struct maple_device *maple_dev = to_maple_dev(device);
 
-	if ((maple_dev->interval > 0)
-	    && time_after(jiffies, maple_dev->when)) {
-		/***
-		* Can only queue one command per device at a time
-		* so if cannot aquire the mutex, just return
-		*/
-		if (!mutex_trylock(&maple_dev->mq->mutex))
-			goto setup_finished;
+	if ((maple_dev->interval > 0) && time_after(jiffies, maple_dev->when)) {
 		maple_dev->when = jiffies + maple_dev->interval;
 		maple_dev->mq->command = MAPLE_COMMAND_GETCOND;
 		maple_dev->mq->sendbuf = &maple_dev->function;
@@ -396,8 +389,6 @@ static int setup_maple_commands(struct d
 		maple_add_packet(maple_dev->mq);
 	} else {
 		if (time_after(jiffies, maple_pnp_time)) {
-			if (!mutex_trylock(&maple_dev->mq->mutex))
-				goto setup_finished;
 			maple_dev->mq->command = MAPLE_COMMAND_DEVINFO;
 			maple_dev->mq->length = 0;
 			maple_add_packet(maple_dev->mq);
@@ -452,11 +443,6 @@ static void maple_map_subunits(struct ma
 			mdev_add = maple_alloc_dev(mdev->port, k + 1);
 			if (!mdev_add)
 				return;
-			/* Use trylock again to avoid corrupting
-			* any already queued commands */
-			locking = mutex_trylock(&mdev_add->mq->mutex);
-			if (locking == 0)
-				return;
 			mdev_add->mq->command = MAPLE_COMMAND_DEVINFO;
 			mdev_add->mq->length = 0;
 			maple_add_packet(mdev_add->mq);
@@ -536,18 +522,6 @@ static void maple_port_rescan(void)
 		if (checked[i] == false) {
 			fullscan = 0;
 			mdev = baseunits[i];
-			/**
-			*  Use trylock in case scan has failed
-			*  but device is still locked
-			*/
-			locking = mutex_trylock(&mdev->mq->mutex);
-			if (locking == 0) {
-				mutex_unlock(&mdev->mq->mutex);
-				locking = mutex_lock_interruptible
-					(&mdev->mq->mutex);
-				if (locking)
-					continue;
-			}
 			mdev->mq->command = MAPLE_COMMAND_DEVINFO;
 			mdev->mq->length = 0;
 			maple_add_packet(mdev->mq);
@@ -570,8 +544,6 @@ static void maple_dma_handler(struct wor
 		list_for_each_entry_safe(mq, nmq, &maple_sentq, list) {
 			recvbuf = mq->recvbuf;
 			code = recvbuf[0];
-			if (mutex_is_locked(&mq->mutex))
-				mutex_unlock(&mq->mutex);
 			dev = mq->dev;
 			list_del_init(&mq->list);
 			switch (code) {
@@ -763,9 +735,8 @@ static int __init maple_bus_init(void)
 		checked[i] = false;
 		mdev[i] = maple_alloc_dev(i, 0);
 		baseunits[i] = mdev[i];
-		if (!mdev[i] || mutex_lock_interruptible(&mdev[i]->mq->mutex)) {
+		if (!mdev[i]) {
 			while (i-- > 0) {
-				mutex_unlock(&mdev[i]->mq->mutex);
 				maple_free_dev(mdev[i]);
 			}
 			goto cleanup_cache;

--O5XBE6gyVG5Rl6Rj
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="cu7.patch"
Content-Transfer-Encoding: 8bit


Properly protect all accesses to maple_waitq or maple_sentq with
maple_wlist_lock.  

Signed-off-by: Jörn Engel <joern@logfs.org>
---

 drivers/sh/maple/maple.c |   31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)


--- maple/drivers/sh/maple/maple.c~cu7	2008-03-24 17:49:59.000000000 +0100
+++ maple/drivers/sh/maple/maple.c	2008-03-24 18:02:03.000000000 +0100
@@ -236,17 +236,13 @@ static void maple_send(void)
 	int maple_packets;
 	struct mapleq *mq, *nmq;
 
-	if (!list_empty(&maple_sentq))
-		return;
 	mutex_lock(&maple_wlist_lock);
-	if (list_empty(&maple_waitq) || !maple_dma_done()) {
-		mutex_unlock(&maple_wlist_lock);
-		return;
-	}
-	mutex_unlock(&maple_wlist_lock);
+	if (!list_empty(&maple_sentq))
+		goto out;
+	if (list_empty(&maple_waitq) || !maple_dma_done())
+		goto out;
 	maple_packets = 0;
 	maple_sendptr = maple_lastptr = maple_sendbuf;
-	mutex_lock(&maple_wlist_lock);
 	list_for_each_entry_safe(mq, nmq, &maple_waitq, list) {
 		maple_build_block(mq);
 		list_move(&mq->list, &maple_sentq);
@@ -259,6 +255,9 @@ static void maple_send(void)
 			dma_cache_sync(0, maple_sendbuf + i * PAGE_SIZE,
 				       PAGE_SIZE, DMA_BIDIRECTIONAL);
 	}
+	return;
+out:
+	mutex_unlock(&maple_wlist_lock);
 }
 
 /* check if there is a driver registered likely to match this device */
@@ -401,24 +400,22 @@ setup_finished:
 /* VBLANK bottom half - implemented via workqueue */
 static void maple_vblank_handler(struct work_struct *work)
 {
+	mutex_lock(&maple_wlist_lock);
 	if (!list_empty(&maple_sentq))
-		return;
+		goto out;
 	if (!maple_dma_done())
-		return;
+		goto out;
 	ctrl_outl(0, MAPLE_ENABLE);
 	bus_for_each_dev(&maple_bus_type, NULL, NULL,
 			 setup_maple_commands);
 	if (time_after(jiffies, maple_pnp_time))
 		maple_pnp_time = jiffies + MAPLE_PNP_INTERVAL;
-	mutex_lock(&maple_wlist_lock);
-	if (!list_empty(&maple_waitq) && list_empty(&maple_sentq)) {
-		mutex_unlock(&maple_wlist_lock);
+	if (!list_empty(&maple_waitq) && list_empty(&maple_sentq))
 		maple_send();
-	} else {
-		mutex_unlock(&maple_wlist_lock);
-	}
 
 	maplebus_dma_reset();
+out:
+	mutex_unlock(&maple_wlist_lock);
 }
 
 /* handle devices added via hotplugs - placing them on queue for DEVINFO*/
@@ -540,6 +537,7 @@ static void maple_dma_handler(struct wor
 	if (!maple_dma_done())
 		return;
 	ctrl_outl(0, MAPLE_ENABLE);
+	mutex_lock(&maple_wlist_lock);
 	if (!list_empty(&maple_sentq)) {
 		list_for_each_entry_safe(mq, nmq, &maple_sentq, list) {
 			recvbuf = mq->recvbuf;
@@ -595,6 +593,7 @@ static void maple_dma_handler(struct wor
 		if (started == 0)
 			started = 1;
 	}
+	mutex_unlock(&maple_wlist_lock);
 	maplebus_dma_reset();
 }
 

--O5XBE6gyVG5Rl6Rj--
