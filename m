Return-Path: <linux-kernel-owner+w=401wt.eu-S1760065AbYCXOLI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760065AbYCXOLI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 10:11:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753746AbYCXOKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 10:10:55 -0400
Received: from lazybastard.de ([212.112.238.170]:59021 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbYCXOKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 10:10:54 -0400
Date: Mon, 24 Mar 2008 15:10:44 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: Paul Mundt <lethal@linux-sh.org>, linux-sh <linux-sh@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       MTD <linux-mtd@lists.infradead.org>
Subject: Re: [PATCH] 2/3 mtd: add support for flash on the SEGA Dreamcast Visual Memory Unit
Message-ID: <20080324141043.GB2899@logfs.org>
References: <1206211147.6324.48.camel@localhost.localdomain> <20080322185600.GE19347@logfs.org> <1206207805.6324.13.camel@localhost.localdomain> <1206209035.6324.29.camel@localhost.localdomain> <20080322183200.GD19347@logfs.org> <1206211147.6324.48.camel@localhost.localdomain> <20080324020832.GA13935@linux-sh.org> <1206360384.6283.11.camel@localhost.localdomain> <20080324132101.GA2899@logfs.org> <1206367120.6283.15.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="YZ5djTAD1cGYuMQK"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1206367120.6283.15.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, 24 March 2008 13:58:40 +0000, Adrian McMenamin wrote:
> 
> Tempting as it is to continue the war, discretion will be the better
> part of valour here and I will give you the last word.
> 
> Of course I don't mind you sending patches. Indeed it would be very
> helpful and generous of you to do so.

Good.  The first four shouldn't change any behaviour.  Number five flips
positive error returns into negative ones.  I believe the old behaviour
is a bug.  Worth a second look to make sure.

All five patches are attached.  Hope that doesn't cause any problems.

JÃ¶rn

-- 
There are two ways of constructing a software design: one way is to make
it so simple that there are obviously no deficiencies, and the other is
to make it so complicated that there are no obvious deficiencies.
-- C. A. R. Hoare

--YZ5djTAD1cGYuMQK
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="cu1.patch"
Content-Transfer-Encoding: 8bit


Directly include two headers.  While unnecessary on sh, this allows the driver
to be compiled on i386 for those lacking a cross-compiler setup.

Signed-off-by: Jörn Engel <joern@logfs.org>
---

 drivers/mtd/maps/vmu_flash.c |    2 ++
 1 file changed, 2 insertions(+)

--- maple/drivers/mtd/maps/vmu_flash.c~cu1	2008-03-24 14:36:51.000000000 +0100
+++ maple/drivers/mtd/maps/vmu_flash.c	2008-03-24 14:39:05.000000000 +0100
@@ -12,6 +12,8 @@
  * GNU General Public Licence
  */
 #include <linux/init.h>
+#include <linux/sched.h>
+#include <linux/jiffies.h>
 #include <linux/maple.h>
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/map.h>

--YZ5djTAD1cGYuMQK
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="cu2.patch"
Content-Transfer-Encoding: 8bit


Minimal changes to make sparse happier.

Signed-off-by: Jörn Engel <joern@logfs.org>
---

 drivers/mtd/maps/vmu_flash.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- maple/drivers/mtd/maps/vmu_flash.c~cu2	2008-03-24 14:39:05.000000000 +0100
+++ maple/drivers/mtd/maps/vmu_flash.c	2008-03-24 14:44:24.000000000 +0100
@@ -136,7 +136,7 @@ static int maple_vmu_read_block(unsigned
 	struct mdev_part *mpart;
 	struct maple_device *mdev;
 	int partition, error = 0, locking;
-	void *sendbuf;
+	__be32 *sendbuf;
 
 	mpart = mtd->priv;
 	mdev = mpart->mdev;
@@ -162,8 +162,8 @@ static int maple_vmu_read_block(unsigned
 		goto fail_nosendbuf;
 	}
 
-	((unsigned long *)sendbuf)[0] = cpu_to_be32(MAPLE_FUNC_MEMCARD);
-	((unsigned long *)sendbuf)[1] = cpu_to_be32(partition << 24 | num);
+	sendbuf[0] = cpu_to_be32(MAPLE_FUNC_MEMCARD);
+	sendbuf[1] = cpu_to_be32(partition << 24 | num);
 
 	mdev->mq->sendbuf = sendbuf;
 	block_read = 0;
@@ -207,7 +207,7 @@ static int maple_vmu_write_block(unsigne
 	struct mdev_part *mpart;
 	struct maple_device *mdev;
 	int partition, error, locking, x, phaselen;
-	void *sendbuf;
+	__be32 *sendbuf;
 
 	mpart = mtd->priv;
 	mdev = mpart->mdev;
@@ -224,7 +224,7 @@ static int maple_vmu_write_block(unsigne
 		goto fail_nosendbuf;
 	}
 
-	((unsigned long *)sendbuf)[0] = cpu_to_be32(MAPLE_FUNC_MEMCARD);
+	sendbuf[0] = cpu_to_be32(MAPLE_FUNC_MEMCARD);
 
 	for (x = 0; x < card->writecnt; x++) {
 		/* take the lock to protect the contents of sendbuf */
@@ -233,8 +233,7 @@ static int maple_vmu_write_block(unsigne
 			error = -EBUSY;
 			goto fail_nolock;
 		}
-		((unsigned long *)sendbuf)[1] =
-			cpu_to_be32(partition << 24 | x << 16 | num);
+		sendbuf[1] = cpu_to_be32(partition << 24 | x << 16 | num);
 		memcpy(sendbuf + 8, buf + phaselen * x, phaselen);
 		mdev->mq->sendbuf = sendbuf;
 		maple_add_packet(mdev->mq);
@@ -467,7 +466,7 @@ failed:
 
 static int vmu_flash_erase(struct mtd_info *mtd, struct erase_info *erase)
 {
-	int z;
+	size_t z;
 	erase->state = MTD_ERASING;
 	vmu_flash_write(mtd, erase->addr, erase->len, &z, "\0");
 	erase->state = MTD_ERASE_DONE;

--YZ5djTAD1cGYuMQK
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="cu3.patch"
Content-Transfer-Encoding: 8bit


Shrink the goto logic where easily possible.  Changing the return type to int
allows vmu_flash_read_char() to follow normal Linux style.

Signed-off-by: Jörn Engel <joern@logfs.org>
---

 drivers/mtd/maps/vmu_flash.c |   37 ++++++++++++++-----------------------
 1 file changed, 14 insertions(+), 23 deletions(-)

--- maple/drivers/mtd/maps/vmu_flash.c~cu3	2008-03-24 14:44:50.000000000 +0100
+++ maple/drivers/mtd/maps/vmu_flash.c	2008-03-24 14:55:22.000000000 +0100
@@ -76,22 +76,19 @@ static struct vmu_block *ofs_to_block(un
 	card = mdev->private_data;
 
 	if (src_ofs >= ((card->parts)[partition]).numblocks * card->blocklen)
-		goto failed;
+		return NULL;
 
 	num = src_ofs / card->blocklen;
 	if (num > ((card->parts)[partition]).numblocks)
-		goto failed;
+		return NULL;
 
 	vblock = kmalloc(sizeof(struct vmu_block), GFP_KERNEL);
 	if (!vblock)
-		goto failed;
+		return NULL;
 
 	vblock->num = num;
 	vblock->ofs = src_ofs % card->blocklen;
 	return vblock;
-
-failed:
-	return NULL;
 }
 
 
@@ -264,15 +261,15 @@ fail_nosendbuf:
 }
 
 /* mtd function to simulate reading byte by byte */
-static unsigned char vmu_flash_read_char(unsigned long ofs, int *retval,
+static int vmu_flash_read_char(unsigned long ofs, int *retval,
 	struct mtd_info *mtd)
 {
 	struct vmu_block *vblock;
 	struct memcard *card;
 	struct mdev_part *mpart;
 	struct maple_device *mdev;
-	unsigned char *buf, ret;
-	int partition, error;
+	unsigned char *buf;
+	int partition, ret;
 
 	mpart = mtd->priv;
 	mdev = mpart->mdev;
@@ -282,33 +279,27 @@ static unsigned char vmu_flash_read_char
 	buf = kmalloc(card->blocklen, GFP_KERNEL);
 	if (!buf) {
 		*retval = 1;
-		error = -ENOMEM;
-		goto fail_buffer;
+		return -ENOMEM;
 	}
 
 	vblock = ofs_to_block(ofs, mtd, partition);
 	if (!vblock) {
 		*retval = 3;
-		error = -ENOMEM;
+		ret = -ENOMEM;
 		goto invalid_block;
 	}
 
-	error = maple_vmu_read_block(vblock->num, buf, mtd);
-	if (error) {
+	ret = maple_vmu_read_block(vblock->num, buf, mtd);
+	if (ret) {
 		*retval = 2;
 		goto failed_block;
 	}
 	ret = buf[vblock->ofs];
-	kfree(buf);
-	kfree(vblock);
-	return ret;
-
 failed_block:
 	kfree(vblock);
 invalid_block:
 	kfree(buf);
-fail_buffer:
-	return error;
+	return ret;
 }
 
 /* mtd higher order function to read flash */
@@ -321,7 +312,7 @@ static int vmu_flash_read(struct mtd_inf
 	struct vmu_cache *pcache;
 	struct vmu_block *vblock = NULL;
 	int index = 0, retval, partition, leftover, numblocks;
-	unsigned char cx;
+	int cx;
 
 	mpart = mtd->priv;
 	mdev = mpart->mdev;
@@ -364,9 +355,9 @@ static int vmu_flash_read(struct mtd_inf
 		} else {
 			/* Not cached so read from the device */
 			cx = vmu_flash_read_char(from + index, &retval, mtd);
-			if (retval) {
+			if (cx < 0) {
 				*retlen = index;
-				return -EIO;
+				return cx;
 			}
 			memset(buf + index, cx, 1);
 			index++;

--YZ5djTAD1cGYuMQK
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="cu4.patch"
Content-Transfer-Encoding: 8bit


Trivial comment reformatting.  Old style was uncommon for Linux.

Signed-off-by: Jörn Engel <joern@logfs.org>
---

 drivers/mtd/maps/vmu_flash.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- maple/drivers/mtd/maps/vmu_flash.c~cu4	2008-03-24 14:55:22.000000000 +0100
+++ maple/drivers/mtd/maps/vmu_flash.c	2008-03-24 14:57:38.000000000 +0100
@@ -140,10 +140,10 @@ static int maple_vmu_read_block(unsigned
 	partition = mpart->partition;
 	card = mdev->private_data;
 
-	/***
-	* Maple devices include a mutex to ensure packets injected into
-	* the wait queue are not corrupted via scans for hotplug events etc
-	*/
+	/*
+	 * Maple devices include a mutex to ensure packets injected into
+	 * the wait queue are not corrupted via scans for hotplug events etc
+	 */
 	locking = mutex_lock_interruptible(&mdev->mq->mutex);
 	if (locking) {
 		printk(KERN_INFO "Maple: VMU at (%d, %d) is locked -"
@@ -235,9 +235,9 @@ static int maple_vmu_write_block(unsigne
 		mdev->mq->sendbuf = sendbuf;
 		maple_add_packet(mdev->mq);
 	}
-	/***
-	* The Maple bus driver will unlock the mutex once the command
-	* has been processed, so we'll just sleep waiting for the unlock */
+	/*
+	 * The Maple bus driver will unlock the mutex once the command
+	 * has been processed, so we'll just sleep waiting for the unlock */
 	locking = mutex_lock_interruptible(&mdev->mq->mutex);
 	if (locking) {
 		error = -EBUSY;
@@ -592,8 +592,8 @@ static int vmu_connect(struct maple_devi
 
 	test_flash_data = be32_to_cpu(mdev->devinfo.function);
 	/* Need to count how many bits are set - to find out which
-	* function_data element has details of the memory card:
-	* using Brian Kernighan's/Peter Wegner's method */
+	 * function_data element has details of the memory card:
+	 * using Brian Kernighan's/Peter Wegner's method */
 	for (c = 0; test_flash_data; c++)
 		test_flash_data &= test_flash_data - 1;
 
@@ -613,14 +613,14 @@ static int vmu_connect(struct maple_devi
 
 	card->partition = 0;
 	/* Not sure there are actually any multi-partition devices in the
-	* real world, but the hardware supports them, so, so will we */
+	 * real world, but the hardware supports them, so, so will we */
 	card->parts = kmalloc(sizeof(struct vmupart) * card->partitions,
 		GFP_KERNEL);
 	if (!card->parts) {
 		error = -ENOMEM;
 		goto fail_partitions;
 	}
-	/*kzalloc this to ensure safe kfree-ing of NULL mparts on error*/
+	/* kzalloc this to ensure safe kfree-ing of NULL mparts on error */
 	card->mtd = kzalloc(sizeof(struct mtd_info) * card->partitions,
 		GFP_KERNEL);
 	if (!card->mtd) {

--YZ5djTAD1cGYuMQK
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="cu5.patch"
Content-Transfer-Encoding: 8bit


Change return values.
- Turn -1 into -EIO.  Possibly not the best value, but better than -EPERM.
- Change -error to error to return negative error values, as is standard.

Signed-off-by: Jörn Engel <joern@logfs.org>
---

 drivers/mtd/maps/vmu_flash.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)


--- maple/drivers/mtd/maps/vmu_flash.c~cu5	2008-03-24 14:57:38.000000000 +0100
+++ maple/drivers/mtd/maps/vmu_flash.c	2008-03-24 15:02:36.000000000 +0100
@@ -320,12 +320,12 @@ static int vmu_flash_read(struct mtd_inf
 	card = mdev->private_data;
 
 	if (len < 1)
-		return -1;
+		return -EIO;
 	numblocks = card->parts[partition].numblocks;
 	if (from + len > numblocks * card->blocklen)
 		len = numblocks * card->blocklen - from;
 	if (len == 0)
-		return -1;
+		return -EIO;
 	/* Have we cached this bit already? */
 	pcache = (card->parts[partition]).pcache;
 	do {
@@ -388,14 +388,14 @@ static int vmu_flash_write(struct mtd_in
 
 	/* simple sanity checks */
 	if (len < 1) {
-		error = -1;
+		error = -EIO;
 		goto failed;
 	}
 	numblocks = card->parts[partition].numblocks;
 	if (to + len > numblocks * card->blocklen)
 		len = numblocks * card->blocklen - to;
 	if (len == 0) {
-		error = -1;
+		error = -EIO;
 		goto failed;
 	}
 
@@ -661,7 +661,7 @@ fail_mtd_info:
 fail_partitions:
 	kfree(card);
 fail_nomem:
-	return -error;
+	return error;
 }
 
 static void vmu_disconnect(struct maple_device *mdev)

--YZ5djTAD1cGYuMQK--
