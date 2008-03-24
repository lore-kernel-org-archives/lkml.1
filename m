Return-Path: <linux-kernel-owner+w=401wt.eu-S1759373AbYCXRj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759373AbYCXRj0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 13:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753829AbYCXRjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 13:39:17 -0400
Received: from lazybastard.de ([212.112.238.170]:38984 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694AbYCXRjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 13:39:15 -0400
Date: Mon, 24 Mar 2008 18:38:56 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: Paul Mundt <lethal@linux-sh.org>, Greg KH <greg@kroah.com>,
       dwmw2 <dwmw2@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       MTD <linux-mtd@lists.infradead.org>,
       linux-sh <linux-sh@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] 3/3 maple: update bus driver to support Dreamcast VMU
Message-ID: <20080324173856.GI2899@logfs.org>
References: <1206207805.6324.13.camel@localhost.localdomain> <1206209786.6324.41.camel@localhost.localdomain> <20080324033344.GB15872@linux-sh.org> <20080324144647.GC2899@logfs.org> <1206371178.6283.37.camel@localhost.localdomain> <20080324152952.GF2899@logfs.org> <1206373900.6283.39.camel@localhost.localdomain> <20080324160429.GG2899@logfs.org> <20080324170707.GH2899@logfs.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="m51xatjYGsM+13rf"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080324170707.GH2899@logfs.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--m51xatjYGsM+13rf
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, 24 March 2008 18:07:07 +0100, JÃ¶rn Engel wrote:
> 
> The second rearranges the list locking a bit.  Previously it was
> possible to touch maple_waitq or maple_sentq without holding the lock.
> With my limited understanding of the driver, the second patch may
> already be enough to prevent the type of corruption you've been seeing.

Limited understanding indeed.  The problem in the mtd driver is that it
has no concept of ownership.  For example maple_vmu_read_block() does
the following:
	mdev->mq->sendbuf = sendbuf;
	...
	maple_add_packet(mdev->mq);

It accesses some field in mdev->mq, then sends the structure off to
maple_add_packet().  From this point on, mdev->mq belongs to the bus
driver - until it calls the callback, vmu_blockread() in this case.

But a second thread can call into maple_vmu_read_block() again and
access mdev->mq while it rightfully belongs to the bus driver.  Bad
things will happen.

So these two patches try to close the race windows.  Please note the
FIXME in the write patch - I didn't do all the work.  Real life calls
for attention, so these will be the last patches for a while.

JÃ¶rn

-- 
The only good bug is a dead bug.
-- Starship Troopers

--m51xatjYGsM+13rf
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="cu8.patch"
Content-Transfer-Encoding: 8bit


Add a mutex to protect any accesses to maple queue.

Signed-off-by: Jörn Engel <joern@logfs.org>
---

 drivers/mtd/maps/vmu_flash.c |   55 ++++++++++++++++++++-----------------------
 1 file changed, 26 insertions(+), 29 deletions(-)

--- maple/drivers/mtd/maps/vmu_flash.c~cu8	2008-03-24 17:49:59.000000000 +0100
+++ maple/drivers/mtd/maps/vmu_flash.c	2008-03-24 18:26:56.000000000 +0100
@@ -22,6 +22,8 @@
 static DECLARE_WAIT_QUEUE_HEAD(vmu_read);
 static int block_read;
 
+static DEFINE_MUTEX(dev_mutex);
+
 struct vmu_cache {
 	char *buffer;			/* Cache */
 	unsigned int block;		/* Which block was cached */
@@ -133,26 +135,21 @@ static int maple_vmu_read_block(unsigned
 	struct mdev_part *mpart;
 	struct maple_device *mdev;
 	int partition, error = 0;
-	__be32 *sendbuf;
+	__be32 sendbuf[2];
 
 	mpart = mtd->priv;
 	mdev = mpart->mdev;
 	partition = mpart->partition;
 	card = mdev->private_data;
 
+	mutex_lock(&dev_mutex);
 	mdev->mq->command = MAPLE_COMMAND_BREAD;
 	mdev->mq->length = 2;
 
-	sendbuf = kzalloc(mdev->mq->length * 4, GFP_KERNEL);
-	if (!sendbuf) {
-		error = -ENOMEM;
-		goto fail_nosendbuf;
-	}
-
 	sendbuf[0] = cpu_to_be32(MAPLE_FUNC_MEMCARD);
 	sendbuf[1] = cpu_to_be32(partition << 24 | num);
 
-	mdev->mq->sendbuf = sendbuf;
+	mdev->mq->sendbuf = &sendbuf;
 	block_read = 0;
 
 	card->blockread = kmalloc(card->blocklen, GFP_KERNEL);
@@ -171,16 +168,12 @@ static int maple_vmu_read_block(unsigned
 	}
 
 	memcpy(buf, card->blockread, card->blocklen);
-	kfree(card->blockread);
-	kfree(sendbuf);
-
-	return 0;
 
+	error = 0;
 fail_blockread:
 	kfree(card->blockread);
 fail_bralloc:
-	kfree(sendbuf);
-fail_nosendbuf:
+	mutex_unlock(&dev_mutex);
 	return error;
 }
 
@@ -191,7 +184,7 @@ static int maple_vmu_write_block(unsigne
 	struct memcard *card;
 	struct mdev_part *mpart;
 	struct maple_device *mdev;
-	int partition, error, x, phaselen;
+	int partition, x, phaselen;
 	__be32 *sendbuf;
 
 	mpart = mtd->priv;
@@ -199,16 +192,18 @@ static int maple_vmu_write_block(unsigne
 	partition = mpart->partition;
 	card = mdev->private_data;
 
-	phaselen = card->blocklen/card->writecnt;
-	mdev->mq->command = MAPLE_COMMAND_BWRITE;
-	mdev->mq->length = phaselen / 4 + 2;
-
 	sendbuf = kmalloc(mdev->mq->length * 4, GFP_KERNEL);
 	if (!sendbuf) {
-		error = -ENOMEM;
-		goto fail_nosendbuf;
+		printk("Maple: VMU (%d, %d): write failed\n", mdev->port,
+				mdev->unit);
+		return -ENOMEM;
 	}
 
+	phaselen = card->blocklen/card->writecnt;
+	mutex_lock(&dev_mutex);
+	mdev->mq->command = MAPLE_COMMAND_BWRITE;
+	mdev->mq->length = phaselen / 4 + 2;
+
 	sendbuf[0] = cpu_to_be32(MAPLE_FUNC_MEMCARD);
 
 	for (x = 0; x < card->writecnt; x++) {
@@ -217,14 +212,14 @@ static int maple_vmu_write_block(unsigne
 		mdev->mq->sendbuf = sendbuf;
 		maple_add_packet(mdev->mq);
 	}
+	/* FIXME: we have to wait for the write to finish before releasing
+	 * the mutex.  Requires another callback.
+	 */
+	mutex_unlock(&dev_mutex);
 
 	kfree(sendbuf);
 
 	return card->blocklen;
-
-fail_nosendbuf:
-	printk("Maple: VMU (%d, %d): write failed\n", mdev->port, mdev->unit);
-	return error;
 }
 
 /* mtd function to simulate reading byte by byte */
@@ -593,15 +588,16 @@ static int vmu_connect(struct maple_devi
 
 	mdev->private_data = card;
 
-	/* Now query the device to find out about blocks */
-	mdev->mq->command = MAPLE_COMMAND_GETMINFO;
-	mdev->mq->length = 2;
-
 	sendbuf = kzalloc(mdev->mq->length * 4, GFP_KERNEL);
 	if (!sendbuf) {
 		error = -ENOMEM;
 		goto fail_nosendbuf;
 	}
+	/* Now query the device to find out about blocks */
+	mutex_lock(&dev_mutex);
+	mdev->mq->command = MAPLE_COMMAND_GETMINFO;
+	mdev->mq->length = 2;
+
 	card->sendbuf = sendbuf;
 	mdev->mq->sendbuf = sendbuf;
 
@@ -611,6 +607,7 @@ static int vmu_connect(struct maple_devi
 	maple_getcond_callback(mdev, vmu_queryblocks, 0,
 		MAPLE_FUNC_MEMCARD);
 
+	mutex_unlock(&dev_mutex);
 	return 0;
 
 fail_nosendbuf:

--m51xatjYGsM+13rf
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="cu9.patch"
Content-Transfer-Encoding: 8bit


Replace the waitqueue with completion logic.

Signed-off-by: Jörn Engel <joern@logfs.org>
---

 drivers/mtd/maps/vmu_flash.c |   15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

--- maple/drivers/mtd/maps/vmu_flash.c~cu9	2008-03-24 18:26:56.000000000 +0100
+++ maple/drivers/mtd/maps/vmu_flash.c	2008-03-24 18:36:12.000000000 +0100
@@ -19,8 +19,7 @@
 #include <linux/mtd/map.h>
 #include <asm/mach/maple.h>
 
-static DECLARE_WAIT_QUEUE_HEAD(vmu_read);
-static int block_read;
+static DECLARE_COMPLETION(read_complete);
 
 static DEFINE_MUTEX(dev_mutex);
 
@@ -108,7 +107,6 @@ static void vmu_blockread(struct mapleq 
 	card = mdev->private_data;
 	/* copy the read in data */
 	memcpy(card->blockread, mq->recvbuf + 12, card->blocklen);
-	block_read = 1;
 	/* fill the cache for this block */
 	mtd = card->mtd;
 	mpart = mtd->priv;
@@ -124,7 +122,7 @@ static void vmu_blockread(struct mapleq 
 	pcache->jiffies_atc = jiffies;
 	pcache->valid = 1;
 wakeup:
-	wake_up_interruptible(&vmu_read);
+	complete(&read_complete);
 }
 
 /* Interface with maple bus to read bytes */
@@ -150,7 +148,6 @@ static int maple_vmu_read_block(unsigned
 	sendbuf[1] = cpu_to_be32(partition << 24 | num);
 
 	mdev->mq->sendbuf = &sendbuf;
-	block_read = 0;
 
 	card->blockread = kmalloc(card->blocklen, GFP_KERNEL);
 	if (!card->blockread) {
@@ -160,17 +157,11 @@ static int maple_vmu_read_block(unsigned
 
 	maple_getcond_callback(mdev, vmu_blockread, 0, MAPLE_FUNC_MEMCARD);
 	maple_add_packet(mdev->mq);
-	wait_event_interruptible_timeout(vmu_read, block_read, HZ * 4);
-	if (block_read == 0) {
-		printk(KERN_INFO "Maple: VMU read failed on block 0x%X\n", num);
-		error = -EIO;
-		goto fail_blockread;
-	}
+	wait_for_completion(&read_complete);
 
 	memcpy(buf, card->blockread, card->blocklen);
 
 	error = 0;
-fail_blockread:
 	kfree(card->blockread);
 fail_bralloc:
 	mutex_unlock(&dev_mutex);

--m51xatjYGsM+13rf--
