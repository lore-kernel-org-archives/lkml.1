Return-Path: <linux-kernel-owner+w=401wt.eu-S1757545AbYCVSE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545AbYCVSE0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 14:04:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755440AbYCVSET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 14:04:19 -0400
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:54436 "EHLO
	mk-filter-2-a-4.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751879AbYCVSER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 14:04:17 -0400
X-Trace: 690567378/mk-filter-2.mail.uk.tiscali.com/B2C/$THROTTLED-DYNAMIC/CUSTOMER-DYNAMIC-IP/81.1.89.66
X-SBRS: None
X-RemoteIP: 81.1.89.66
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApAFAPDm5EdRAVlC/2dsb2JhbACBW6ZG
Subject: Re: [PATCH] 2/3 mtd: add support for flash on the SEGA Dreamcast
	Visual Memory Unit
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: dwmw2 <dwmw2@infradead.org>
Cc: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
       MTD <linux-mtd@lists.infradead.org>,
       linux-sh <linux-sh@vger.kernel.org>,
       Paul Mundt <lethal@users.sourceforge.net>,
       Andrew Morton <akpm@osdl.org>
In-Reply-To: <1206207805.6324.13.camel@localhost.localdomain>
References: <1206207805.6324.13.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sat, 22 Mar 2008 18:03:55 +0000
Message-Id: <1206209035.6324.29.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SEGA Visual Memory Unit includes 128k of flash memory
which can be read in blocks.

The hardware specification is also capable of supporting
partitions (though it is doubtful such devices exist).

This driver supports block reads and writes, as well as
queries of hardware capabilities, through the maple
bus susbsystem.

(It also implements a caching system so that, for instance, a
read of 60 bytes will take 1/60th - or 1/50th in PAL regions -
of a second instead of a second or 1.2 seconds.)

Signed-off-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>


---
diff -ruN a/drivers/mtd/maps/vmu_flash.c b/drivers/mtd/maps/vmu_flash.c
--- a/drivers/mtd/maps/vmu_flash.c	1970-01-01 01:00:00.000000000 +0100
+++ b/drivers/mtd/maps/vmu_flash.c	2008-03-22 17:53:50.000000000 +0000
@@ -0,0 +1,763 @@
+/* vmu-flash.c
+ * Driver for SEGA Dreamcast Visual Memory Unit
+ *
+ * Copyright Adrian McMenamin 2008
+ *
+ * Substantial parts based on code:
+ * Copyright Paul Mundt 2001
+ * Copyright Adrian McMenamin 2002
+ *
+ *
+ * Licensed under version 2 of the
+ * GNU General Public Licence
+ */
+#include <linux/init.h>
+#include <linux/maple.h>
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/map.h>
+#include <asm/mach/maple.h>
+
+static DECLARE_WAIT_QUEUE_HEAD(vmu_read);
+static int block_read;
+
+struct vmu_cache {
+	char *buffer;			/* Cache */
+	unsigned int block;		/* Which block was cached */
+	unsigned long jiffies_atc;	/* When was it cached? */
+	int valid;
+};
+
+struct mdev_part {
+	struct maple_device *mdev;
+	int partition;
+};
+
+struct vmupart {
+	u16 user_blocks;
+	u16 root_block;
+	u16 numblocks;
+	char *name;
+	struct vmu_cache *pcache;
+};
+
+struct memcard {
+	u16 tempA;
+	u16 tempB;
+	u32 partitions;
+	u32 blocklen;
+	u32 writecnt;
+	u32 readcnt;
+	u32 removeable;
+	int partition;
+	void *sendbuf;
+	void *blockread;
+	struct vmupart *parts;
+	struct mtd_info *mtd;
+};
+
+struct vmu_block {
+	unsigned int num; /* block number */
+	unsigned int ofs; /* block offset */
+};
+
+static struct vmu_block *ofs_to_block(unsigned long src_ofs,
+	struct mtd_info *mtd, int partition)
+{
+	struct vmu_block *vblock;
+	struct maple_device *mdev;
+	struct memcard *card;
+	struct mdev_part *mpart;
+	int num;
+
+	mpart = mtd->priv;
+	mdev = mpart->mdev;
+	card = mdev->private_data;
+
+	if (src_ofs >= ((card->parts)[partition]).numblocks * card->blocklen)
+		goto failed;
+
+	num = src_ofs / card->blocklen;
+	if (num > ((card->parts)[partition]).numblocks)
+		goto failed;
+
+	vblock = kmalloc(sizeof(struct vmu_block), GFP_KERNEL);
+	if (!vblock)
+		goto failed;
+
+	vblock->num = num;
+	vblock->ofs = src_ofs % card->blocklen;
+	return vblock;
+
+failed:
+	return NULL;
+}
+
+
+/* Maple bus callback function for reads */
+static void vmu_blockread(struct mapleq *mq)
+{
+	struct maple_device *mdev;
+	struct memcard *card;
+	struct mtd_info *mtd;
+	struct vmu_cache *pcache;
+	struct mdev_part *mpart;
+	int partition;
+
+	mdev = mq->dev;
+	card = mdev->private_data;
+	/* copy the read in data */
+	memcpy(card->blockread, mq->recvbuf + 12, card->blocklen);
+	block_read = 1;
+	/* fill the cache for this block */
+	mtd = card->mtd;
+	mpart = mtd->priv;
+	partition = mpart->partition;
+	pcache = (card->parts[partition]).pcache;
+	if (!pcache->buffer)
+		pcache->buffer = kmalloc(card->blocklen, GFP_KERNEL);
+	/* If fail because of ENOMEM - wake up to cause failure */
+	if (!pcache->buffer)
+		goto wakeup;
+	memcpy(pcache->buffer, card->blockread, card->blocklen);
+	pcache->block = ((unsigned char *)mq->recvbuf)[11];
+	pcache->jiffies_atc = jiffies;
+	pcache->valid = 1;
+wakeup:
+	wake_up_interruptible(&vmu_read);
+}
+
+/* Interface with maple bus to read bytes */
+static int maple_vmu_read_block(unsigned int num, unsigned char *buf,
+	struct mtd_info *mtd)
+{
+	struct memcard *card;
+	struct mdev_part *mpart;
+	struct maple_device *mdev;
+	int partition, error = 0, locking;
+	void *sendbuf;
+
+	mpart = mtd->priv;
+	mdev = mpart->mdev;
+	partition = mpart->partition;
+	card = mdev->private_data;
+
+	/***
+	* Maple devices include a mutex to ensure packets injected into
+	* the wait queue are not corrupted via scans for hotplug events etc
+	*/
+	locking = mutex_lock_interruptible(&mdev->mq->mutex);
+	if (locking) {
+		printk(KERN_INFO "Maple: VMU at (%d, %d) is locked -"
+			" aborting read\n", mdev->unit, mdev->port);
+		goto fail_nosendbuf;
+	}
+	mdev->mq->command = MAPLE_COMMAND_BREAD;
+	mdev->mq->length = 2;
+
+	sendbuf = kzalloc(mdev->mq->length * 4, GFP_KERNEL);
+	if (!sendbuf) {
+		error = -ENOMEM;
+		goto fail_nosendbuf;
+	}
+
+	((unsigned long *)sendbuf)[0] = cpu_to_be32(MAPLE_FUNC_MEMCARD);
+	((unsigned long *)sendbuf)[1] = cpu_to_be32(partition << 24 | num);
+
+	mdev->mq->sendbuf = sendbuf;
+	block_read = 0;
+
+	card->blockread = kmalloc(card->blocklen, GFP_KERNEL);
+	if (!card->blockread) {
+		error = -ENOMEM;
+		goto fail_bralloc;
+	}
+
+	maple_getcond_callback(mdev, vmu_blockread, 0, MAPLE_FUNC_MEMCARD);
+	maple_add_packet(mdev->mq);
+	wait_event_interruptible_timeout(vmu_read, block_read, HZ * 4);
+	if (block_read == 0) {
+		printk(KERN_INFO "Maple: VMU read failed on block 0x%X\n", num);
+		error = -EIO;
+		goto fail_blockread;
+	}
+
+	memcpy(buf, card->blockread, card->blocklen);
+	kfree(card->blockread);
+	kfree(sendbuf);
+
+	return 0;
+
+fail_blockread:
+	kfree(card->blockread);
+fail_bralloc:
+	kfree(sendbuf);
+fail_nosendbuf:
+	if (mutex_is_locked(&mdev->mq->mutex))
+		mutex_unlock(&mdev->mq->mutex);
+	return error;
+}
+
+/* communicate with maple bus for phased writing */
+static int maple_vmu_write_block(unsigned int num, const unsigned char *buf,
+	struct mtd_info *mtd)
+{
+	struct memcard *card;
+	struct mdev_part *mpart;
+	struct maple_device *mdev;
+	int partition, error, locking, x, phaselen;
+	void *sendbuf;
+
+	mpart = mtd->priv;
+	mdev = mpart->mdev;
+	partition = mpart->partition;
+	card = mdev->private_data;
+
+	phaselen = card->blocklen/card->writecnt;
+	mdev->mq->command = MAPLE_COMMAND_BWRITE;
+	mdev->mq->length = phaselen / 4 + 2;
+
+	sendbuf = kmalloc(mdev->mq->length * 4, GFP_KERNEL);
+	if (!sendbuf) {
+		error = -ENOMEM;
+		goto fail_nosendbuf;
+	}
+
+	((unsigned long *)sendbuf)[0] = cpu_to_be32(MAPLE_FUNC_MEMCARD);
+
+	for (x = 0; x < card->writecnt; x++) {
+		/* take the lock to protect the contents of sendbuf */
+		locking = mutex_lock_interruptible(&mdev->mq->mutex);
+		if (locking) {
+			error = -EBUSY;
+			goto fail_nolock;
+		}
+		((unsigned long *)sendbuf)[1] =
+			cpu_to_be32(partition << 24 | x << 16 | num);
+		memcpy(sendbuf + 8, buf + phaselen * x, phaselen);
+		mdev->mq->sendbuf = sendbuf;
+		maple_add_packet(mdev->mq);
+	}
+	/***
+	* The Maple bus driver will unlock the mutex once the command
+	* has been processed, so we'll just sleep waiting for the unlock */
+	locking = mutex_lock_interruptible(&mdev->mq->mutex);
+	if (locking) {
+		error = -EBUSY;
+		goto fail_nolock;
+	}
+	mutex_unlock(&mdev->mq->mutex);
+
+	kfree(sendbuf);
+
+	return card->blocklen;
+
+fail_nolock:
+	printk(KERN_INFO "Maple: VMU at (%d, %d) is locked -"
+		" aborting write\n", mdev->unit, mdev->port);
+	kfree(sendbuf);
+fail_nosendbuf:
+	printk("Maple: VMU (%d, %d): write failed\n", mdev->port, mdev->unit);
+	if (mutex_is_locked(&mdev->mq->mutex))
+		mutex_unlock(&mdev->mq->mutex);
+	return error;
+}
+
+/* mtd function to simulate reading byte by byte */
+static unsigned char vmu_flash_read_char(unsigned long ofs, int *retval,
+	struct mtd_info *mtd)
+{
+	struct vmu_block *vblock;
+	struct memcard *card;
+	struct mdev_part *mpart;
+	struct maple_device *mdev;
+	unsigned char *buf, ret;
+	int partition, error;
+
+	mpart = mtd->priv;
+	mdev = mpart->mdev;
+	partition = mpart->partition;
+	card = mdev->private_data;
+	*retval =  0;
+	buf = kmalloc(card->blocklen, GFP_KERNEL);
+	if (!buf) {
+		*retval = 1;
+		error = -ENOMEM;
+		goto fail_buffer;
+	}
+
+	vblock = ofs_to_block(ofs, mtd, partition);
+	if (!vblock) {
+		*retval = 3;
+		error = -ENOMEM;
+		goto invalid_block;
+	}
+
+	error = maple_vmu_read_block(vblock->num, buf, mtd);
+	if (error) {
+		*retval = 2;
+		goto failed_block;
+	}
+	ret = buf[vblock->ofs];
+	kfree(buf);
+	kfree(vblock);
+	return ret;
+
+failed_block:
+	kfree(vblock);
+invalid_block:
+	kfree(buf);
+fail_buffer:
+	return error;
+}
+
+/* mtd higher order function to read flash */
+static int vmu_flash_read(struct mtd_info *mtd, loff_t from, size_t len,
+	size_t *retlen,  u_char *buf)
+{
+	struct maple_device *mdev;
+	struct memcard *card;
+	struct mdev_part *mpart;
+	struct vmu_cache *pcache;
+	struct vmu_block *vblock = NULL;
+	int index = 0, retval, partition, leftover, numblocks;
+	unsigned char cx;
+
+	mpart = mtd->priv;
+	mdev = mpart->mdev;
+	partition = mpart->partition;
+	card = mdev->private_data;
+
+	if (len < 1)
+		return -1;
+	numblocks = card->parts[partition].numblocks;
+	if (from + len > numblocks * card->blocklen)
+		len = numblocks * card->blocklen - from;
+	if (len == 0)
+		return -1;
+	/* Have we cached this bit already? */
+	pcache = (card->parts[partition]).pcache;
+	do {
+		vblock =  ofs_to_block(from + index, mtd, partition);
+		if (!vblock)
+			return -ENOMEM;
+
+		/* Have we cached this and is the cache valid and timely? */
+		if (pcache->valid &&
+			time_before(jiffies, pcache->jiffies_atc + HZ) &&
+			(pcache->block == vblock->num)) {
+			/* we have cached it, so do necessary copying */
+			leftover = card->blocklen - vblock->ofs;
+			if (leftover > len - index) {
+				/* only a bit of this block to copy */
+				memcpy(buf + index,
+					pcache->buffer + vblock->ofs,
+					len - index);
+				index = len;
+				kfree(vblock);
+				break;
+			}
+			/* otherwise copy remainder of whole block */
+			memcpy(buf + index, pcache->buffer +
+				vblock->ofs, leftover);
+			index += leftover;
+		} else {
+			/* Not cached so read from the device */
+			cx = vmu_flash_read_char(from + index, &retval, mtd);
+			if (retval) {
+				*retlen = index;
+				return -EIO;
+			}
+			memset(buf + index, cx, 1);
+			index++;
+		}
+		kfree(vblock);
+		vblock = NULL;
+	} while (len > index);
+	*retlen = index;
+
+	return 0;
+}
+
+static int vmu_flash_write(struct mtd_info *mtd, loff_t to, size_t len,
+	size_t *retlen, const u_char *buf)
+{
+	struct maple_device *mdev;
+	struct memcard *card;
+	struct mdev_part *mpart;
+	int index = 0, retval, partition, error = 0, numblocks;
+	struct vmu_cache *pcache;
+	struct vmu_block *vblock;
+	unsigned char *buffer;
+
+	mpart = mtd->priv;
+	mdev = mpart->mdev;
+	partition = mpart->partition;
+	card = mdev->private_data;
+
+	/* simple sanity checks */
+	if (len < 1) {
+		error = -1;
+		goto failed;
+	}
+	numblocks = card->parts[partition].numblocks;
+	if (to + len > numblocks * card->blocklen)
+		len = numblocks * card->blocklen - to;
+	if (len == 0) {
+		error = -1;
+		goto failed;
+	}
+
+	vblock = ofs_to_block(to, mtd, partition);
+	if (!vblock) {
+		error = -ENOMEM;
+		goto failed;
+	}
+
+	buffer = kmalloc(card->blocklen, GFP_KERNEL);
+	if (!buffer) {
+		error = -ENOMEM;
+		goto fail_buffer;
+	}
+
+	do {
+
+		/* Read in the block we are to write to */
+		if (maple_vmu_read_block(vblock->num, buffer, mtd)) {
+			error = -EIO;
+			goto fail_io;
+		}
+
+		do {
+			buffer[vblock->ofs] = buf[index];
+			vblock->ofs++;
+			index++;
+			if (index >= len)
+				break;
+		} while (vblock->ofs < card->blocklen);
+		/* write out new buffer */
+		retval = maple_vmu_write_block(vblock->num, buffer, mtd);
+		/* invalidare the cache */
+		pcache = (card->parts[partition]).pcache;
+		pcache->valid = 0;
+
+		if (retval != card->blocklen) {
+			error = -EIO;
+			goto fail_io;
+		}
+
+		vblock->num++;
+		vblock->ofs = 0;
+	} while (len > index);
+
+	kfree(buffer);
+	*retlen = index;
+	kfree(vblock);
+	return 0;
+
+fail_io:
+	kfree(buffer);
+fail_buffer:
+	kfree(vblock);
+failed:
+	printk(KERN_INFO "Maple: VMU write failing with error %d\n", error);
+	return error;
+}
+
+static int vmu_flash_erase(struct mtd_info *mtd, struct erase_info *erase)
+{
+	int z;
+	erase->state = MTD_ERASING;
+	vmu_flash_write(mtd, erase->addr, erase->len, &z, "\0");
+	erase->state = MTD_ERASE_DONE;
+	if (erase->callback)
+		(erase->callback) (erase);
+	return 0;
+}
+
+static void vmu_flash_sync(struct mtd_info *mtd)
+{
+	/* Do nothing */
+}
+
+/* Maple bus callback function to recursively query hardware details */
+static void vmu_queryblocks(struct mapleq *mq)
+{
+	struct maple_device *mdev;
+	unsigned short *res;
+	struct memcard *card;
+	void *sendbuf;
+	struct vmu_cache *pcache;
+	struct mdev_part *mpart;
+	struct mtd_info *mtd_cur;
+	struct vmupart *part_cur;
+	int error, locking;
+
+	mdev = mq->dev;
+	card = mdev->private_data;
+	res = mq->recvbuf;
+	card->tempA = res[12];
+	card->tempB = res[6];
+
+	printk(KERN_INFO "Maple: VMU device at partition %d has %d user "
+		"blocks with a root block at %d\n", card->partition,
+		card->tempA, card->tempB);
+
+	part_cur = &((card->parts)[card->partition]);
+	part_cur->user_blocks = card->tempA;
+	part_cur->root_block = card->tempB;
+	part_cur->numblocks = card->tempB + 1;
+	part_cur->name = kmalloc(12, GFP_KERNEL);
+	if (!part_cur->name)
+		goto fail_name;
+
+	sprintf(part_cur->name, "vmu%d.%d.%d",
+		mdev->port, mdev->unit, card->partition);
+	mtd_cur = &((card->mtd)[card->partition]);
+	mtd_cur->name = part_cur->name;
+	mtd_cur->type = MTD_NORFLASH;
+	mtd_cur->flags = MTD_CAP_NORFLASH;
+	mtd_cur->size = part_cur->numblocks * card->blocklen;
+	mtd_cur->erasesize = card->blocklen;
+	mtd_cur->write = vmu_flash_write;
+	mtd_cur->read = vmu_flash_read;
+	mtd_cur->erase = vmu_flash_erase;
+	mtd_cur->sync = vmu_flash_sync;
+	mtd_cur->writesize = card->blocklen;
+
+	mpart = kmalloc(sizeof(struct mdev_part), GFP_KERNEL);
+	if (!mpart)
+		goto fail_mpart;
+
+	mpart->mdev = mdev;
+	mpart->partition = card->partition;
+	mtd_cur->priv = mpart;
+	mtd_cur->owner = THIS_MODULE;
+
+	pcache = kmalloc(sizeof(struct vmu_cache), GFP_KERNEL);
+	if (!pcache)
+		goto fail_cache_create;
+	pcache->buffer = NULL;
+	pcache->valid = 0;
+	part_cur->pcache = pcache;
+
+	error = add_mtd_device(mtd_cur);
+	if (error)
+		goto fail_mtd_register;
+
+	kfree(card->sendbuf);
+	maple_getcond_callback(mdev, NULL, 0,
+		MAPLE_FUNC_MEMCARD);
+
+	if (++(card->partition) < card->partitions) {
+		mdev->mq->command = MAPLE_COMMAND_GETMINFO;
+		mdev->mq->length = 2;
+
+		sendbuf = kzalloc(mdev->mq->length * 4, GFP_KERNEL);
+		if (!sendbuf) {
+			error = -ENOMEM;
+			goto fail_nosendbuf;
+		}
+		card->sendbuf = sendbuf;
+		mdev->mq->sendbuf = sendbuf;
+		maple_getcond_callback(mdev, vmu_queryblocks, 0,
+			MAPLE_FUNC_MEMCARD);
+
+		locking = mutex_lock_interruptible(&(mdev->mq->mutex));
+		if (!locking)
+			maple_add_packet(mdev->mq);
+	}
+
+	return;
+
+fail_mtd_register:
+	printk("mtd: Could not register maple device at (%d, %d)\n",
+		mdev->port, mdev->unit);
+	for (error = 0; error <= card->partition; error++) {
+		kfree(((card->parts)[error]).pcache);
+		((card->parts)[error]).pcache = NULL;
+	}
+fail_cache_create:
+	kfree(card->sendbuf);
+fail_mpart:
+	for (error = 0; error <= card->partition; error++) {
+		kfree(((card->mtd)[error]).priv);
+		((card->mtd)[error]).priv = NULL;
+	}
+fail_nosendbuf:
+	maple_getcond_callback(mdev, NULL, 0,
+		MAPLE_FUNC_MEMCARD);
+	kfree(part_cur->name);
+fail_name:
+	return;
+}
+
+static int vmu_connect(struct maple_device *mdev)
+{
+	unsigned long test_flash_data, basic_flash_data;
+	int c, locking, error = 0;
+	struct memcard *card;
+	void *sendbuf;
+
+	test_flash_data = be32_to_cpu(mdev->devinfo.function);
+	/* Need to count how many bits are set - to find out which
+	* function_data element has details of the memory card:
+	* using Brian Kernighan's/Peter Wegner's method */
+	for (c = 0; test_flash_data; c++)
+		test_flash_data &= test_flash_data - 1;
+
+	basic_flash_data = be32_to_cpu(mdev->devinfo.function_data[c - 1]);
+
+	card = kmalloc(sizeof(struct memcard), GFP_KERNEL);
+	if (!card) {
+		error = ENOMEM;
+		goto fail_nomem;
+	}
+
+	card->partitions = ((basic_flash_data >> 24) & 0xFF) + 1;
+	card->blocklen = (((basic_flash_data >> 16) & 0xFF) + 1) << 5;
+	card->writecnt = (basic_flash_data >> 12) & 0xF;
+	card->readcnt = (basic_flash_data >> 8) & 0xF;
+	card->removeable = (basic_flash_data >> 7) & 1;
+
+	card->partition = 0;
+	/* Not sure there are actually any multi-partition devices in the
+	* real world, but the hardware supports them, so, so will we */
+	card->parts = kmalloc(sizeof(struct vmupart) * card->partitions,
+		GFP_KERNEL);
+	if (!card->parts) {
+		error = -ENOMEM;
+		goto fail_partitions;
+	}
+	/*kzalloc this to ensure safe kfree-ing of NULL mparts on error*/
+	card->mtd = kzalloc(sizeof(struct mtd_info) * card->partitions,
+		GFP_KERNEL);
+	if (!card->mtd) {
+		error = -ENOMEM;
+		goto fail_mtd_info;
+	}
+
+	mdev->private_data = card;
+
+	/* Now query the device to find out about blocks */
+	mdev->mq->command = MAPLE_COMMAND_GETMINFO;
+	mdev->mq->length = 2;
+
+	sendbuf = kzalloc(mdev->mq->length * 4, GFP_KERNEL);
+	if (!sendbuf) {
+		error = -ENOMEM;
+		goto fail_nosendbuf;
+	}
+	card->sendbuf = sendbuf;
+	mdev->mq->sendbuf = sendbuf;
+
+	((unsigned long *)(mdev->mq->sendbuf))[0] =
+		cpu_to_be32(MAPLE_FUNC_MEMCARD);
+
+	maple_getcond_callback(mdev, vmu_queryblocks, 0,
+		MAPLE_FUNC_MEMCARD);
+
+	locking = mutex_lock_interruptible(&(mdev->mq->mutex));
+	if (!locking)
+		maple_add_packet(mdev->mq);
+
+	return 0;
+
+fail_nosendbuf:
+	kfree(card->mtd);
+fail_mtd_info:
+	kfree(card->parts);
+fail_partitions:
+	kfree(card);
+fail_nomem:
+	return -error;
+}
+
+static void vmu_disconnect(struct maple_device *mdev)
+{
+	struct memcard *card;
+	int x, locking;
+
+	/* Seek lock to ensure smooth removal */
+	locking = mutex_lock_interruptible(&mdev->mq->mutex);
+	if (locking) {
+		printk(KERN_INFO "Maple: Could not disconnect VMU device at:"
+			"(%d, %d)\n", mdev->port, mdev->unit);
+		return;
+	}
+	mdev->callback = NULL;
+	card = mdev->private_data;
+	for (x = 0; x < card->partitions; x++) {
+		del_mtd_device(&((card->mtd)[x]));
+		kfree(((card->parts)[x]).name);
+	}
+	kfree(card->parts);
+	kfree(card->mtd);
+	kfree(card);
+	mutex_unlock(&mdev->mq->mutex);
+
+}
+
+static int probe_maple_vmu(struct device *dev)
+{
+	int error;
+	struct maple_device *mdev = to_maple_dev(dev);
+	struct maple_driver *mdrv = to_maple_driver(dev->driver);
+
+	error = vmu_connect(mdev);
+	if (error)
+		return error;
+
+	mdev->driver = mdrv;
+
+	return 0;
+}
+
+static int remove_maple_vmu(struct device *dev)
+{
+	struct maple_device *mdev = to_maple_dev(dev);
+
+	vmu_disconnect(mdev);
+	return 0;
+}
+
+static struct maple_driver vmu_flash_driver = {
+	.function =	MAPLE_FUNC_MEMCARD,
+	.connect =	vmu_connect,
+	.disconnect =	vmu_disconnect,
+	.drv = {
+		.name = "Dreamcast_visual_memory",
+		.probe = probe_maple_vmu,
+		.remove = remove_maple_vmu,
+	},
+};
+
+static int unplug_vmu_flash(struct device *dev, void *ignored)
+{
+	struct maple_device *mdev;
+
+	mdev = to_maple_dev(dev);
+	if ((mdev->function & MAPLE_FUNC_MEMCARD)
+		&& (mdev->driver == &vmu_flash_driver))
+		remove_maple_vmu(dev);
+
+	return 0;
+}
+
+static int __init vmu_flash_map_init(void)
+{
+	maple_driver_register(&vmu_flash_driver.drv);
+	return 0;
+}
+
+static void __exit vmu_flash_map_exit(void)
+{
+	bus_for_each_dev(&maple_bus_type, NULL, NULL, unplug_vmu_flash);
+	driver_unregister(&vmu_flash_driver.drv);
+}
+
+module_init(vmu_flash_map_init);
+module_exit(vmu_flash_map_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Adrian McMenamin");
+MODULE_DESCRIPTION("Flash mapping for Sega Dreamcast visual memory");


