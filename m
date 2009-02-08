Return-Path: <linux-kernel-owner+w=401wt.eu-S1753829AbZBHUAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829AbZBHUAy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 15:00:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753197AbZBHUAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 15:00:45 -0500
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:38239 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751409AbZBHUAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 15:00:42 -0500
X-Trace: 145589663/mk-filter-1.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.44.176.198/None/adrian@newgolddream.dyndns.info
X-SBRS: None
X-RemoteIP: 80.44.176.198
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-MUA: Evolution 2.24.3 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsoEABfIjklQLLDG/2dsb2JhbACBbcplhBoG
X-IronPort-AV: E=Sophos;i="4.37,400,1231113600"; 
   d="scan'208";a="145589663"
Subject: [PATCH] sh: maple: add support for Visual Memory Card devices, and
 make consequential changes to maple input drivers - 1/3 - v5
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: dwmw2 <dwmw2@infradead.org>
Cc: Greg KH <greg@kroah.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       dwmw2 <dwmw2@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       MTD <linux-mtd@lists.infradead.org>,
       linux-sh <linux-sh@vger.kernel.org>,
       linux-input <linux-input@vger.kernel.org>,
       Paul Mundt <lethal@linux-sh.org>
In-Reply-To: <1234122069.6736.8.camel@localhost.localdomain>
References: <1234122069.6736.8.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sun, 08 Feb 2009 20:00:22 +0000
Message-Id: <1234123222.6736.25.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support the the SEGA Dreamcast Visual Memory Unit as a flash
mapping.

The VMU is a proprietary 'smart' flash chip. It is packaged with an 8
bit processor and so things that erase-write appear as a seemless write
to the end user. But it has a good fit with the MTD subsystem on issues
such as response to hotplug events.

The device is attached to the Dreamcast via SEGA's proprietary 'Maple'
bus.

Signed-off-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
---
diff --git a/drivers/mtd/maps/Kconfig b/drivers/mtd/maps/Kconfig
index 0225cbb..9b3e564 100644
--- a/drivers/mtd/maps/Kconfig
+++ b/drivers/mtd/maps/Kconfig
@@ -551,5 +551,15 @@ config MTD_PLATRAM
 
 	  This selection automatically selects the map_ram driver.
 
-endmenu
+config MTD_VMU
+	tristate "Map driver for Dreamcast VMU"
+	depends on MAPLE
+	help
+	  This driver enables access to the Dreamcast Visual Memory Unit (VMU).
+
+	  Most Dreamcast users will want to say Y here.
 
+	  To build this as a module select M here, the module will be called
+	  vmu-flash.
+
+endmenu
diff --git a/drivers/mtd/maps/Makefile b/drivers/mtd/maps/Makefile
index 6d9ba35..26b28a7 100644
--- a/drivers/mtd/maps/Makefile
+++ b/drivers/mtd/maps/Makefile
@@ -61,3 +61,4 @@ obj-$(CONFIG_MTD_PLATRAM)	+= plat-ram.o
 obj-$(CONFIG_MTD_OMAP_NOR)	+= omap_nor.o
 obj-$(CONFIG_MTD_INTEL_VR_NOR)	+= intel_vr_nor.o
 obj-$(CONFIG_MTD_BFIN_ASYNC)	+= bfin-async-flash.o
+obj-$(CONFIG_MTD_VMU)		+= vmu-flash.o
diff --git a/drivers/mtd/maps/vmu-flash.c b/drivers/mtd/maps/vmu-flash.c
new file mode 100644
index 0000000..f866918
--- /dev/null
+++ b/drivers/mtd/maps/vmu-flash.c
@@ -0,0 +1,827 @@
+/* vmu-flash.c
+ * Driver for SEGA Dreamcast Visual Memory Unit
+ *
+ * Copyright (c) Adrian McMenamin 2002 - 2009
+ * Copyright (c) Paul Mundt 2001
+ *
+ * Licensed under version 2 of the
+ * GNU General Public Licence
+ */
+#include <linux/init.h>
+#include <linux/sched.h>
+#include <linux/delay.h>
+#include <linux/maple.h>
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/map.h>
+
+struct vmu_cache {
+	unsigned char *buffer;		/* Cache */
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
+	int read;
+	unsigned char *blockread;
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
+	card = maple_get_drvdata(mdev);
+
+	if (src_ofs >= card->parts[partition].numblocks * card->blocklen)
+		goto failed;
+
+	num = src_ofs / card->blocklen;
+	if (num > card->parts[partition].numblocks)
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
+/* Maple bus callback function for reads */
+static void vmu_blockread(struct mapleq *mq)
+{
+	struct maple_device *mdev;
+	struct memcard *card;
+
+	mdev = mq->dev;
+	card = maple_get_drvdata(mdev);
+	/* copy the read in data */
+
+	if (unlikely(!card->blockread))
+		return;
+
+	memcpy(card->blockread, mq->recvbuf->buf + 12,
+		card->blocklen/card->readcnt);
+
+}
+
+/* Interface with maple bus to read blocks
+ * caching the results so that other parts
+ * of the driver can access block reads */
+static int maple_vmu_read_block(unsigned int num, unsigned char *buf,
+	struct mtd_info *mtd)
+{
+	struct memcard *card;
+	struct mdev_part *mpart;
+	struct maple_device *mdev;
+	int partition, error = 0, x, wait;
+	unsigned char *blockread = NULL;
+	struct vmu_cache *pcache;
+	__be32 sendbuf;
+
+	mpart = mtd->priv;
+	mdev = mpart->mdev;
+	partition = mpart->partition;
+	card = maple_get_drvdata(mdev);
+	pcache = card->parts[partition].pcache;
+	pcache->valid = 0;
+
+	/* prepare the cache for this block */
+	if (!pcache->buffer) {
+		pcache->buffer = kmalloc(card->blocklen, GFP_KERNEL);
+		if (!pcache->buffer) {
+			dev_err(&mdev->dev, "VMU at (%d, %d) - read fails due"
+				" to lack of memory\n", mdev->port,
+				mdev->unit);
+			error = -ENOMEM;
+			goto outB;
+		}
+	}
+
+	/*
+	* Reads may be phased - again the hardware spec
+	* supports this - though may not be any devices in
+	* the wild that implement it, but we will here
+	*/
+	for (x = 0; x < card->readcnt; x++) {
+		sendbuf = cpu_to_be32(partition << 24 | x << 16 | num);
+
+		if (mdev->busy == 1) {
+			wait_event_interruptible_timeout(mdev->maple_wait,
+				(mdev->busy == 0), HZ);
+			if (mdev->busy == 1) {
+				dev_notice(&mdev->dev, "VMU at (%d, %d)"
+					" is busy\n", mdev->port, mdev->unit);
+				error = -EAGAIN;
+				goto outB;
+			}
+		}
+
+		mdev->busy = 1;
+		blockread = kmalloc(card->blocklen/card->readcnt, GFP_KERNEL);
+		if (!blockread) {
+			error = -ENOMEM;
+			mdev->busy = 0;
+			goto outB;
+		}
+		card->blockread = blockread;
+
+		maple_getcond_callback(mdev, vmu_blockread, 0,
+			MAPLE_FUNC_MEMCARD);
+		error = maple_add_packet(mdev, MAPLE_FUNC_MEMCARD,
+				MAPLE_COMMAND_BREAD, 2, &sendbuf);
+		wait = wait_event_interruptible_timeout(mdev->maple_wait,
+			((mdev->busy == 0) || (mdev->busy == 2)), HZ/2);
+		/*
+		* MTD layer does not handle hotplugging well
+		* so have to return errors when VMU is unplugged
+		* in the middle of a read (busy == 2)
+		*/
+		if (error || (mdev->busy == 2)) {
+			if (mdev->busy == 2)
+				error = -ENXIO;
+			mdev->busy = 0;
+			goto outA;
+		}
+		if ((wait == 0) || (wait == -ERESTARTSYS)) {
+			mdev->busy = 0;
+			error = -EIO;
+			if (wait == -ERESTARTSYS) {
+				list_del_init(&(mdev->mq->list));
+				kfree(mdev->mq->sendbuf);
+				dev_warn(&mdev->dev, "VMU read on (%d, %d)"
+					" interrupted on block 0x%X\n",
+					mdev->port, mdev->unit, num);
+			} else
+				dev_notice(&mdev->dev, "VMU read on (%d, %d)"
+					" timed out on block 0x%X\n",
+					mdev->port, mdev->unit, num);
+			goto outA;
+		}
+
+		memcpy(buf + (card->blocklen/card->readcnt) * x, blockread,
+			card->blocklen/card->readcnt);
+
+		memcpy(pcache->buffer + (card->blocklen/card->readcnt) * x,
+			card->blockread, card->blocklen/card->readcnt);
+		pcache->block = num;
+		pcache->jiffies_atc = jiffies;
+		pcache->valid = 1;
+	}
+
+outA:
+	kfree(blockread);
+outB:
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
+	int partition, error, locking, x, phaselen, wait;
+	__be32 *sendbuf;
+
+	mpart = mtd->priv;
+	mdev = mpart->mdev;
+	partition = mpart->partition;
+	card = maple_get_drvdata(mdev);
+
+	phaselen = card->blocklen/card->writecnt;
+
+	sendbuf = kmalloc(phaselen + 4, GFP_KERNEL);
+	if (!sendbuf) {
+		error = -ENOMEM;
+		goto fail_nosendbuf;
+	}
+	for (x = 0; x < card->writecnt; x++) {
+		sendbuf[0] = cpu_to_be32(partition << 24 | x << 16 | num);
+		memcpy(&sendbuf[1], buf + phaselen * x, phaselen);
+		/* wait until the device is not busy doing something else
+		* or 1 second - which ever is longer */
+		if (mdev->busy == 1) {
+			wait_event_interruptible_timeout(mdev->maple_wait,
+				(mdev->busy == 0), HZ);
+			if (mdev->busy == 1) {
+				error = -EBUSY;
+				dev_notice(&mdev->dev, "VMU write at (%d, %d)"
+					"failed - device is busy\n",
+					mdev->port, mdev->unit);
+				goto fail_nolock;
+			}
+		}
+		mdev->busy = 1;
+
+		locking = maple_add_packet(mdev, MAPLE_FUNC_MEMCARD,
+			MAPLE_COMMAND_BWRITE, phaselen / 4 + 2, sendbuf);
+		wait = wait_event_interruptible_timeout(mdev->maple_wait,
+			(mdev->busy == 0), HZ/10);
+		if (locking) {
+			error = -EIO;
+			mdev->busy = 0;
+			goto fail_nolock;
+		}
+		if (mdev->busy == 2) {
+			mdev->busy = 0;
+		} else if ((wait == 0) || (wait == -ERESTARTSYS)) {
+			error = -EIO;
+			dev_warn(&mdev->dev, "Write at (%d, %d) of block"
+				" 0x%X at phase %d failed: could not"
+				" communicate with VMU", mdev->port,
+				mdev->unit, num, x);
+			mdev->busy = 0;
+			if (wait == -ERESTARTSYS) {
+				kfree(mdev->mq->sendbuf);
+				list_del_init(&(mdev->mq->list));
+			}
+			goto fail_nolock;
+		}
+	}
+	kfree(sendbuf);
+
+	return card->blocklen;
+
+fail_nolock:
+	kfree(sendbuf);
+fail_nosendbuf:
+	dev_err(&mdev->dev, "VMU (%d, %d): write failed\n", mdev->port,
+		mdev->unit);
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
+	card = maple_get_drvdata(mdev);
+	*retval =  0;
+
+	buf = kmalloc(card->blocklen, GFP_KERNEL);
+	if (!buf) {
+		*retval = 1;
+		ret = -ENOMEM;
+		goto finish;
+	}
+
+	vblock = ofs_to_block(ofs, mtd, partition);
+	if (!vblock) {
+		*retval = 3;
+		ret = -ENOMEM;
+		goto out_buf;
+	}
+
+	error = maple_vmu_read_block(vblock->num, buf, mtd);
+	if (error) {
+		ret = error;
+		*retval = 2;
+		goto out_vblock;
+	}
+
+	ret = buf[vblock->ofs];
+
+out_vblock:
+	kfree(vblock);
+out_buf:
+	kfree(buf);
+finish:
+	return ret;
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
+	struct vmu_block *vblock;
+	int index = 0, retval, partition, leftover, numblocks;
+	unsigned char cx;
+
+	if (len < 1)
+		return -EIO;
+
+	mpart = mtd->priv;
+	mdev = mpart->mdev;
+	partition = mpart->partition;
+	card = maple_get_drvdata(mdev);
+
+	numblocks = card->parts[partition].numblocks;
+	if (from + len > numblocks * card->blocklen)
+		len = numblocks * card->blocklen - from;
+	if (len == 0)
+		return -EIO;
+	/* Have we cached this bit already? */
+	pcache = card->parts[partition].pcache;
+	do {
+		vblock =  ofs_to_block(from + index, mtd, partition);
+		if (!vblock)
+			return -ENOMEM;
+		/* Have we cached this and is the cache valid and timely? */
+		if (pcache->valid &&
+			time_before(jiffies, pcache->jiffies_atc + HZ) &&
+			(pcache->block == vblock->num)) {
+			/* we have cached it, so do necessary copying */
+			leftover = card->blocklen - vblock->ofs;
+			if (vblock->ofs + len - index < card->blocklen) {
+				/* only a bit of this block to copy */
+				memcpy(buf + index,
+					pcache->buffer + vblock->ofs,
+					len - index);
+				index = len;
+			} else {
+				/* otherwise copy remainder of whole block */
+				memcpy(buf + index, pcache->buffer +
+					vblock->ofs, leftover);
+				index += leftover;
+			}
+		} else {
+			/*
+			* Not cached so read one byte -
+			* but cache the rest of the block
+			*/
+			cx = vmu_flash_read_char(from + index, &retval, mtd);
+			if (retval) {
+				*retlen = index;
+				kfree(vblock);
+				return cx;
+			}
+			memset(buf + index, cx, 1);
+			index++;
+		}
+		kfree(vblock);
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
+	card = maple_get_drvdata(mdev);
+
+	/* simple sanity checks */
+	if (len < 1) {
+		error = -EIO;
+		goto failed;
+	}
+	numblocks = card->parts[partition].numblocks;
+	if (to + len > numblocks * card->blocklen)
+		len = numblocks * card->blocklen - to;
+	if (len == 0) {
+		error = -EIO;
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
+
+		/* write out new buffer */
+		retval = maple_vmu_write_block(vblock->num, buffer, mtd);
+		/* invalidate the cache */
+		pcache = card->parts[partition].pcache;
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
+	dev_err(&mdev->dev, "VMU write failing with error %d\n", error);
+	return error;
+}
+
+static void vmu_flash_sync(struct mtd_info *mtd)
+{
+	/* Do nothing here */
+}
+
+/* Maple bus callback function to recursively query hardware details */
+static void vmu_queryblocks(struct mapleq *mq)
+{
+	struct maple_device *mdev;
+	unsigned short *res;
+	struct memcard *card;
+	__be32 partnum;
+	struct vmu_cache *pcache;
+	struct mdev_part *mpart;
+	struct mtd_info *mtd_cur;
+	struct vmupart *part_cur;
+	int error;
+
+	mdev = mq->dev;
+	card = maple_get_drvdata(mdev);
+	res = (unsigned short *) (mq->recvbuf->buf);
+	card->tempA = res[12];
+	card->tempB = res[6];
+
+	dev_info(&mdev->dev, "VMU device at partition %d has %d user "
+		"blocks with a root block at %d\n", card->partition,
+		card->tempA, card->tempB);
+
+	part_cur = &card->parts[card->partition];
+	part_cur->user_blocks = card->tempA;
+	part_cur->root_block = card->tempB;
+	part_cur->numblocks = card->tempB + 1;
+	part_cur->name = kmalloc(12, GFP_KERNEL);
+	if (!part_cur->name)
+		goto fail_name;
+
+	sprintf(part_cur->name, "vmu%d.%d.%d",
+		mdev->port, mdev->unit, card->partition);
+	mtd_cur = &card->mtd[card->partition];
+	mtd_cur->name = part_cur->name;
+	mtd_cur->type = 8;
+	mtd_cur->flags = MTD_WRITEABLE|MTD_NO_ERASE;
+	mtd_cur->size = part_cur->numblocks * card->blocklen;
+	mtd_cur->erasesize = card->blocklen;
+	mtd_cur->write = vmu_flash_write;
+	mtd_cur->read = vmu_flash_read;
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
+	pcache = kzalloc(sizeof(struct vmu_cache), GFP_KERNEL);
+	if (!pcache)
+		goto fail_cache_create;
+	part_cur->pcache = pcache;
+
+	error = add_mtd_device(mtd_cur);
+	if (error)
+		goto fail_mtd_register;
+
+	maple_getcond_callback(mdev, NULL, 0,
+		MAPLE_FUNC_MEMCARD);
+
+	/*
+	* Set up a recursive call to the (probably theoretical)
+	* second or more partition
+	*/
+	if (++card->partition < card->partitions) {
+		partnum = cpu_to_be32(card->partition << 24);
+		maple_getcond_callback(mdev, vmu_queryblocks, 0,
+			MAPLE_FUNC_MEMCARD);
+		maple_add_packet(mdev, MAPLE_FUNC_MEMCARD,
+			MAPLE_COMMAND_GETMINFO, 2, &partnum);
+	}
+	return;
+
+fail_mtd_register:
+	dev_err(&mdev->dev, "Could not register maple device at (%d, %d)"
+		"error is 0x%X\n", mdev->port, mdev->unit, error);
+	for (error = 0; error <= card->partition; error++) {
+		kfree(((card->parts)[error]).pcache);
+		((card->parts)[error]).pcache = NULL;
+	}
+fail_cache_create:
+fail_mpart:
+	for (error = 0; error <= card->partition; error++) {
+		kfree(((card->mtd)[error]).priv);
+		((card->mtd)[error]).priv = NULL;
+	}
+	maple_getcond_callback(mdev, NULL, 0,
+		MAPLE_FUNC_MEMCARD);
+	kfree(part_cur->name);
+fail_name:
+	return;
+}
+
+/* Handles very basic info about the flash, queries for details */
+static int __devinit vmu_connect(struct maple_device *mdev)
+{
+	unsigned long test_flash_data, basic_flash_data;
+	int c, error;
+	struct memcard *card;
+	u32 partnum = 0;
+
+	test_flash_data = be32_to_cpu(mdev->devinfo.function);
+	/* Need to count how many bits are set - to find out which
+	 * function_data element has details of the memory card:
+	 * using Brian Kernighan's/Peter Wegner's method */
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
+	card->partitions = (basic_flash_data >> 24 & 0xFF) + 1;
+	card->blocklen = ((basic_flash_data >> 16 & 0xFF) + 1) << 5;
+	card->writecnt = basic_flash_data >> 12 & 0xF;
+	card->readcnt = basic_flash_data >> 8 & 0xF;
+	card->removeable = basic_flash_data >> 7 & 1;
+
+	card->partition = 0;
+
+	/*
+	* Not sure there are actually any multi-partition devices in the
+	* real world, but the hardware supports them, so, so will we
+	*/
+	card->parts = kmalloc(sizeof(struct vmupart) * card->partitions,
+		GFP_KERNEL);
+	if (!card->parts) {
+		error = -ENOMEM;
+		goto fail_partitions;
+	}
+
+	card->mtd = kmalloc(sizeof(struct mtd_info) * card->partitions,
+		GFP_KERNEL);
+	if (!card->mtd) {
+		error = -ENOMEM;
+		goto fail_mtd_info;
+	}
+
+	maple_set_drvdata(mdev, card);
+
+	/*
+	* We want to trap meminfo not get cond
+	* so set interval to zero, but rely on maple bus
+	* driver to pass back the results of the meminfo
+	*/
+	maple_getcond_callback(mdev, vmu_queryblocks, 0,
+		MAPLE_FUNC_MEMCARD);
+
+	/* Make sure we are clear to go */
+	if (mdev->busy == 1) {
+		wait_event_interruptible_timeout(mdev->maple_wait,
+			(mdev->busy == 0), HZ);
+		if (mdev->busy == 1) {
+			dev_notice(&mdev->dev, "VMU at (%d, %d) is busy\n",
+				mdev->port, mdev->unit);
+			error = -EAGAIN;
+			goto fail_device_busy;
+		}
+	}
+
+	mdev->busy = 1;
+
+	/*
+	* Set up the minfo call: vmu_queryblocks will handle
+	* the information passed back
+	*/
+	error = maple_add_packet(mdev, MAPLE_FUNC_MEMCARD,
+		MAPLE_COMMAND_GETMINFO, 2, &partnum);
+	if (error) {
+		dev_err(&mdev->dev, "Could not lock VMU at (%d, %d)"
+			" error is 0x%X\n", mdev->port, mdev->unit, error);
+		goto fail_mtd_info;
+	}
+	return 0;
+
+fail_device_busy:
+	kfree(card->mtd);
+fail_mtd_info:
+	kfree(card->parts);
+fail_partitions:
+	kfree(card);
+fail_nomem:
+	return error;
+}
+
+static void __devexit vmu_disconnect(struct maple_device *mdev)
+{
+	struct memcard *card;
+	struct mdev_part *mpart;
+	int x;
+
+	mdev->callback = NULL;
+	card = maple_get_drvdata(mdev);
+	for (x = 0; x < card->partitions; x++) {
+		mpart = ((card->mtd)[x]).priv;
+		mpart->mdev = NULL;
+		del_mtd_device(&((card->mtd)[x]));
+		kfree(((card->parts)[x]).name);
+	}
+	kfree(card->parts);
+	kfree(card->mtd);
+	kfree(card);
+}
+
+/* Callback to handle eccentricities of both mtd subsystem
+ * and general flakyness of Dreamcast VMUs
+ */
+static int vmu_can_unload(struct maple_device *mdev)
+{
+	struct memcard *card;
+	int x;
+	struct mtd_info *mtd;
+
+	card = maple_get_drvdata(mdev);
+	for (x = 0; x < card->partitions; x++) {
+		mtd = &((card->mtd)[x]);
+		if (mtd->usecount > 0)
+			return 0;
+	}
+	return 1;
+}
+
+#define ERRSTR "VMU at (%d, %d) file error -"
+
+static void vmu_file_error(struct maple_device *mdev, void *recvbuf)
+{
+	enum maple_file_errors error = ((int *)recvbuf)[1];
+
+	switch (error) {
+
+	case MAPLE_FILEERR_INVALID_PARTITION:
+		dev_notice(&mdev->dev, ERRSTR " invalid partition number\n",
+			mdev->port, mdev->unit);
+		break;
+
+	case MAPLE_FILEERR_PHASE_ERROR:
+		dev_notice(&mdev->dev, ERRSTR " phase error\n",
+			mdev->port, mdev->unit);
+		break;
+
+	case MAPLE_FILEERR_INVALID_BLOCK:
+		dev_notice(&mdev->dev, ERRSTR " invalid block number\n",
+			mdev->port, mdev->unit);
+		break;
+
+	case MAPLE_FILEERR_WRITE_ERROR:
+		dev_notice(&mdev->dev, ERRSTR " write error\n",
+			mdev->port, mdev->unit);
+		break;
+
+	case MAPLE_FILEERR_INVALID_WRITE_LENGTH:
+		dev_notice(&mdev->dev, ERRSTR " invalid write length\n",
+			mdev->port, mdev->unit);
+		break;
+
+	case MAPLE_FILEERR_BAD_CRC:
+		dev_notice(&mdev->dev, ERRSTR " bad CRC\n",
+			mdev->port, mdev->unit);
+		break;
+
+	default:
+		dev_notice(&mdev->dev, ERRSTR " 0x%X\n",
+			mdev->port, mdev->unit, error);
+	}
+}
+
+
+static int __devinit probe_maple_vmu(struct device *dev)
+{
+	int error;
+	struct maple_device *mdev = to_maple_dev(dev);
+	struct maple_driver *mdrv = to_maple_driver(dev->driver);
+
+	mdev->can_unload = vmu_can_unload;
+	mdev->fileerr_handler = vmu_file_error;
+	mdev->driver = mdrv;
+
+	error = vmu_connect(mdev);
+	if (error)
+		return error;
+
+	return 0;
+}
+
+static int __devexit remove_maple_vmu(struct device *dev)
+{
+	struct maple_device *mdev = to_maple_dev(dev);
+
+	vmu_disconnect(mdev);
+	return 0;
+}
+
+static struct maple_driver vmu_flash_driver = {
+	.function =	MAPLE_FUNC_MEMCARD,
+	.drv = {
+		.name =		"Dreamcast_visual_memory",
+		.probe =	probe_maple_vmu,
+		.remove = 	__devexit_p(remove_maple_vmu),
+	},
+};
+
+static int __init vmu_flash_map_init(void)
+{
+	return maple_driver_register(&vmu_flash_driver);
+}
+
+static void __exit vmu_flash_map_exit(void)
+{
+	maple_driver_unregister(&vmu_flash_driver);
+}
+
+module_init(vmu_flash_map_init);
+module_exit(vmu_flash_map_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Adrian McMenamin");
+MODULE_DESCRIPTION("Flash mapping for Sega Dreamcast visual memory");


