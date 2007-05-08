Return-Path: <linux-kernel-owner+w=401wt.eu-S966361AbXEHJok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966361AbXEHJok (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 05:44:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966283AbXEHJoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 05:44:38 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:18217 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966350AbXEHJog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 05:44:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:content-type;
        b=KBXaLvokboAKeI1w9FyfylGqLg2UzsxOXa5nKQ8I4y/7Q3jjYDcBbLFho3zhNPV3a+wF9WHiyCjFM8QXFaW0AEJhu3MgNQfsuRYduS9o3o02EyKWIAxRWexZzS6moSlSebH93hemYzbWrguoRI11AGVq5OpKKZsOn4Zyq+1HefA=
Message-ID: <464045F0.3040906@gmail.com>
Date: Tue, 08 May 2007 11:42:08 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: New Mitsumi legacy CD-ROM driver
Content-Type: multipart/mixed;
 boundary="------------030403040705010408020102"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030403040705010408020102
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Good day.

This is (the start of) a new driver for the legacy Mitsumi CD-ROM (LU-00xS 
and FX-001x) drives that used to be supported by drivers/cdrom/mcd(x).c, a 
driver that hasn't worked for a long time.

It's being tested on my LU-005S and is being submitted to -mm in the hope of 
maybe finding a few more testers and also in the hope of provoking a review. 
I'm co-authoring this with Pekka Enberg but certainly for me it's the first 
ever contact with anything having anything to do with block.

A few specific points/questions:

* This driver's core transfer function is doing:

   rq_for_each_bio(bio, req)
       bio_for_each_segment(bvec, bio, segno) {
           buffer = bvec_kmap_irq(bvec, &flags);
           ioread8_rep(ioaddr, buffer, bvec->bv_len);
           bvec_kunmap_irq(buffer, &flags);
       }
			
I've been slightly worried about struct bio having a bi_sector field. If 
we're not guaranteed that bio[n].bi_sector == bio[n-1].bi_sector + 1 during 
the rq_for_each_bio() loop we can't read from I/O into bio's directly but 
will need to use a temporary buffer and transfer into the bio's later. Is 
this guaranteed?

* This driver purports to support highmem. Given the number of machines out 
there that have both a Mitsumi legacy CD-ROM drive and enough physical 
memory installed to want highmem support this may come across as being 
overly... optimistic but is there much point to not supporting it? I believe 
we do always need the full rq_for_each_bio/bio_for_each_segment loop meaning 
that only the bvec_k{,un}map_irq could go, right?

* Some controllers do not support an IRQ; ading polled operation will not be 
hard. Some other controllers support DMA and I'll try and get one going and 
add that later as well.

* The hardware communication (mitsumi_{read,write}_cmd) can be improved 
upon. It was mostly taken from the old mcdx driver but every user is calling 
mitsumi_read_cmd with a 1 byte command, noone cares for the returned status 
and using MITSUMI_CMD #defines instead of spraying literals around as this 
is doing would be a bit nicer. This is subject to a later patch when all 
user's have been introduced though.

* All timeouts are up for grabs as well. Currently everything is using 
whole-second resolution timeouts but I'll need to instrument this a bit 
(preferabbly on more hardware samples than just my own) to see what makes 
sense. The current timeouts are mostly from the old driver.

* The next thing will be adding audio support to the driver. In fact, some 
parts were present already but have been deleted for now again to not muddy 
up the driver for review purposes. Some choices in there such as keeping the 
toc around as an array of struct cdrom_tocentry have been made with adding 
back mitsumi_audio_ioctl() in mind though and audio should prove relatively 
painless.

The plan...

Ofcourse not many have these old drives around anymore and even people that 
do aren't guaranteed to run 2.6 on the machines that host them. All legacy 
CD-ROM drivers in drivers/cdrom that I've looked at are and have been for 
quite some time broken and most do not serve a purpose anymore.

Mitsumi (mcdx, this driver), panasonic (sbpcd) and sony (cdu31a) are 
somewhat of an exception in so far that controllers for those three are 
still around on a lot of old ISA soundcards though. Moreover, I have the 
drives to test that trio so after this mitsumi driver is complete and in 
good shape I'll do the other two as well.

A few Media Vision based ISA soundcards have Philips CM206 controllers 
sitting on them and I may want to try and locate a matching drive for that 
but the rest is probably not useful to anyone for any purpose anymore and 
I'll submit a patch removing them when the ones that I want to keep are done.

Comments welcome...

Rene.


--------------030403040705010408020102
Content-Type: text/plain;
 name="mitsumi.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mitsumi.diff"

diff --git a/drivers/cdrom/Kconfig b/drivers/cdrom/Kconfig
index 4b12e90..c244b36 100644
--- a/drivers/cdrom/Kconfig
+++ b/drivers/cdrom/Kconfig
@@ -119,6 +119,20 @@ config MCDX
 	  To compile this driver as a module, choose M here: the
 	  module will be called mcdx.
 
+config MITSUMI
+	tristate "New Mitsumi CDROM support (EXPERIMENTAL)"
+	depends on CD_NO_IDESCSI
+	---help---
+	  Use this driver if you want to be able to use your Mitsumi LU-002S,
+	  LU-005S, LU-006S, FX-001S or FX-001D CD-ROM drive.
+
+	  If you say Y here, you should also say Y or M to "ISO 9660 CD-ROM
+	  file system support" below, because that's the file system used on
+	  CD-ROMs.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called mitsumi.
+
 config OPTCD
 	tristate "Optics Storage DOLPHIN 8000AT CDROM support"
 	depends on CD_NO_IDESCSI
diff --git a/drivers/cdrom/Makefile b/drivers/cdrom/Makefile
index d1d1e5a..317d887 100644
--- a/drivers/cdrom/Makefile
+++ b/drivers/cdrom/Makefile
@@ -16,6 +16,7 @@ obj-$(CONFIG_CM206)		+= cm206.o      cdrom.o
 obj-$(CONFIG_GSCD)		+= gscd.o
 obj-$(CONFIG_ISP16_CDI)		+= isp16.o
 obj-$(CONFIG_MCDX)		+= mcdx.o       cdrom.o
+obj-$(CONFIG_MITSUMI)		+= mitsumi.o    cdrom.o
 obj-$(CONFIG_OPTCD)		+= optcd.o
 obj-$(CONFIG_SBPCD)		+= sbpcd.o      cdrom.o
 obj-$(CONFIG_SJCD)		+= sjcd.o
diff --git a/drivers/cdrom/mitsumi.c b/drivers/cdrom/mitsumi.c
new file mode 100644
index 0000000..eaa8523
--- /dev/null
+++ b/drivers/cdrom/mitsumi.c
@@ -0,0 +1,850 @@
+/*
+ * drivers/cdrom/mitsumi.c - Mitsumi CD-ROM Driver for Linux
+ *
+ * Copyright (C) 1995-1996  Heiko Schlittermann
+ * Copyright (C) 2007  Pekka Enberg
+ * Copyright (C) 2007  Rene Herman
+ *
+ * This file is released under the GPLv2.
+ */
+
+#include <linux/bcd.h>
+#include <linux/blkdev.h>
+#include <linux/cdrom.h>
+#include <linux/delay.h>
+#include <linux/fs.h>
+#include <linux/interrupt.h>
+#include <linux/isa.h>
+#include <linux/major.h>
+#include <linux/mutex.h>
+#include <linux/slab.h>
+#include <linux/wait.h>
+
+MODULE_DESCRIPTION("Mitsumi CD-ROM Driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_BLOCKDEV_MAJOR(MITSUMI_CDROM_MAJOR);
+
+#define NR_DRIVES 1
+
+static unsigned long port[NR_DRIVES];
+static unsigned int irq[NR_DRIVES];
+
+module_param_array(port, ulong, NULL, 0444);
+module_param_array(irq, uint, NULL, 0444);
+
+#define MAX_SECTORS (255 * (CD_FRAMESIZE >> 9))
+
+static inline sector_t sector_to_hardsect(sector_t sector)
+{
+	return (sector << 9) / CD_FRAMESIZE;
+}
+
+enum mitsumi_drive_mode { MODE_TOC, MODE_DATA, MODE_RAW, MODE_COOKED };
+
+/* Device registers */
+enum {
+	/* Read */
+	RREG_DATA = 0,
+	RREG_STATUS = 1,
+
+	/* Write */
+	WREG_DATA = 0,
+	WREG_RESET = 1,
+	WREG_HW_CONFIG = 2,
+	WREG_CHANNEL = 3,
+};
+
+/*
+ * The status byte, returned from every command, set if the description is true
+ */
+#define MITSUMI_RBIT_OPEN       0x80	/* door is open */
+#define MITSUMI_RBIT_DISKSET    0x40	/* disk set (recognized) */
+#define MITSUMI_RBIT_CHANGED    0x20	/* disk was changed */
+#define MITSUMI_RBIT_CHECK      0x10	/* disk rotates, servo is on */
+#define MITSUMI_RBIT_AUDIOTR    0x08	/* current track is audio */
+#define MITSUMI_RBIT_RDERR      0x04	/* read error, refer SENSE KEY */
+#define MITSUMI_RBIT_AUDIOBS    0x02	/* currently playing audio */
+#define MITSUMI_RBIT_CMDERR     0x01	/* command, param or format error */
+
+/*
+ * The I/O Register holding the hardware status of the drive; can be read
+ * at RREG_STATUS.
+ */
+#define MITSUMI_RBIT_DOOR       0x10	/* door is open */
+#define MITSUMI_RBIT_STEN       0x04	/* if 0, I/O base contains status */
+#define MITSUMI_RBIT_DTEN       0x02	/* if 0, I/O base contains data */
+
+struct mitsumi_cdrom {
+	void __iomem *ioaddr;
+	struct mutex mutex;
+
+	unsigned long port;
+	unsigned int irq;
+
+	char ver;
+	char rev;
+
+	struct completion *io_done;
+
+	int door_open;
+	int media_changed;
+	int toc_uptodate;
+
+	struct gendisk *disk;
+	struct cdrom_device_info info;
+
+	struct cdrom_tochdr header;
+	struct cdrom_tocentry *toc;
+	struct cdrom_tocentry leadout;
+};
+
+static void hardsect_to_msf(sector_t hardsect, struct cdrom_msf0 *msf)
+{
+	hardsect += CD_MSF_OFFSET;
+	msf->frame = hardsect % CD_FRAMES;
+	hardsect /= CD_FRAMES;
+	msf->second = hardsect % CD_SECS;
+	msf->minute = hardsect / CD_SECS;
+}
+
+static sector_t msf_to_hardsect(const struct cdrom_msf0 *msf)
+{
+	sector_t hardsect = CD_SECS * msf->minute + msf->second;
+	return CD_FRAMES * hardsect + msf->frame - CD_MSF_OFFSET;
+}
+
+/*
+ *	LOCKING: mutex_lock(&mcd->mutex)
+ */
+static int mitsumi_get_value(struct mitsumi_cdrom *mcd, unsigned char *value,
+			     unsigned long timeout_msec)
+{
+	unsigned long timeout;
+	int err = 0;
+
+	timeout = jiffies + msecs_to_jiffies(timeout_msec);
+	while (ioread8(mcd->ioaddr + RREG_STATUS) & MITSUMI_RBIT_STEN) {
+		if (time_after(jiffies, timeout)) {
+			err = -EBUSY;
+			goto out;
+		}
+		msleep_interruptible(100);
+		if (signal_pending(current)) {
+			err = -EINTR;
+			goto out;
+		}
+	}
+	*value = ioread8(mcd->ioaddr + RREG_DATA);
+  out:
+	return err;
+}
+
+static int __mitsumi_write_cmd(struct mitsumi_cdrom *mcd,
+			       const unsigned char *cmd, size_t cmdlen,
+			       unsigned long timeout_msec,
+			       unsigned char *status)
+{
+	int err;
+
+	iowrite8_rep(mcd->ioaddr + WREG_DATA, cmd, cmdlen);
+
+	err = mitsumi_get_value(mcd, status, timeout_msec);
+	if (err)
+		goto out;
+
+	if (*status & MITSUMI_RBIT_CMDERR) {
+		printk(KERN_WARNING "mitsumi: command error: cmd=%02x, "
+		       "cmdlen=%d, status=%02x\n", cmd[0], cmdlen, *status);
+		err = -EIO;
+	}
+  out:
+	return err;
+}
+
+static int mitsumi_write_cmd(struct mitsumi_cdrom *mcd,
+			     const unsigned char *cmd, size_t cmdlen,
+			     unsigned long timeout_msec)
+{
+	unsigned char status;
+
+	return __mitsumi_write_cmd(mcd, cmd, cmdlen, timeout_msec, &status);
+}
+
+static int mitsumi_read_cmd(struct mitsumi_cdrom *mcd,
+			    const unsigned char *cmd, size_t cmdlen,
+			    unsigned char *buffer, size_t size,
+			    unsigned long timeout_msec)
+{
+	int err;
+
+	err = __mitsumi_write_cmd(mcd, cmd, cmdlen, timeout_msec, buffer);
+	while (!err && --size)
+		err = mitsumi_get_value(mcd, ++buffer, timeout_msec);
+
+	return err;
+}
+
+static int mitsumi_read_subchnl(struct mitsumi_cdrom *mcd,
+				struct cdrom_subchnl *q)
+{
+	unsigned char buf[11];
+	int err;
+
+	err = mitsumi_read_cmd(mcd, "\x20", 1, buf, sizeof buf, 2000);
+	if (err)
+		goto out;
+
+	q->cdsc_adr  = buf[1];
+	q->cdsc_ctrl = buf[1] >> 4;
+	q->cdsc_trk  = BCD2BIN(buf[2]);
+	q->cdsc_ind  = BCD2BIN(buf[3]);
+
+	q->cdsc_reladdr.msf.minute = BCD2BIN(buf[4]);
+	q->cdsc_reladdr.msf.second = BCD2BIN(buf[5]);
+	q->cdsc_reladdr.msf.frame  = BCD2BIN(buf[6]);
+
+	q->cdsc_absaddr.msf.minute = BCD2BIN(buf[8]);
+	q->cdsc_absaddr.msf.second = BCD2BIN(buf[9]);
+	q->cdsc_absaddr.msf.frame  = BCD2BIN(buf[10]);
+  out:
+	return err;
+}
+
+static int __mitsumi_read_toc(struct mitsumi_cdrom *mcd)
+{
+	int tracks = mcd->header.cdth_trk1 - mcd->header.cdth_trk0 + 1;
+	int retries;
+	int err = 0;
+
+	kfree(mcd->toc);
+
+	mcd->toc = kzalloc(tracks * sizeof *mcd->toc, GFP_KERNEL);
+	if (!mcd->toc) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	retries = 300; /* why 300? */
+	do {
+		struct cdrom_subchnl q;
+		int i;
+
+		err = mitsumi_read_subchnl(mcd, &q);
+		if (err)
+			goto out_free_toc;
+
+		if (q.cdsc_trk != 0)
+			continue;
+
+		i = q.cdsc_ind;
+		if (i < mcd->header.cdth_trk0 || i > mcd->header.cdth_trk1)
+			continue;
+
+		i -= mcd->header.cdth_trk0;
+		if (mcd->toc[i].cdte_track != 0)
+			continue;
+
+		mcd->toc[i].cdte_track = q.cdsc_ind;
+		mcd->toc[i].cdte_adr   = q.cdsc_adr;
+		mcd->toc[i].cdte_ctrl  = q.cdsc_ctrl;
+		mcd->toc[i].cdte_addr  = q.cdsc_absaddr;
+
+		if (!--tracks)
+			goto out;
+
+	} while (--retries);
+
+	err = -EIO;
+
+  out_free_toc:
+	kfree(mcd->toc);
+	mcd->toc = NULL;
+  out:
+	return err;
+}
+
+static int mitsumi_set_drive_mode(struct mitsumi_cdrom *mcd,
+				  enum mitsumi_drive_mode mode)
+{
+	unsigned char cmd[2];
+	int err;
+
+	err = mitsumi_read_cmd(mcd, "\xc2", 1, cmd, sizeof cmd, 5000);
+	if (err)
+		goto out;
+
+	cmd[0] = 0x50;
+	switch (mode) {
+	case MODE_TOC:
+		cmd[1] |= 0x04;
+		break;
+	case MODE_DATA:
+		cmd[1] &= ~0x04;
+		break;
+	case MODE_RAW:
+		cmd[1] |= 0x40;
+		break;
+	case MODE_COOKED:
+		cmd[1] &= ~0x40;
+		break;
+	default:
+		break;
+	}
+	err = mitsumi_write_cmd(mcd, cmd, sizeof cmd, 5000);
+  out:
+	return err;
+}
+
+static int mitsumi_hold(struct mitsumi_cdrom *mcd)
+{
+	return mitsumi_write_cmd(mcd, "\x70", 1, 5000);
+}
+
+static int mitsumi_read_toc(struct mitsumi_cdrom *mcd)
+{
+	int err;
+
+	err = mitsumi_hold(mcd);
+	if (err)
+		goto out;
+
+	err = mitsumi_set_drive_mode(mcd, MODE_TOC);
+	if (err)
+		goto out;
+
+	err = __mitsumi_read_toc(mcd);
+	if (err)
+		goto out;
+
+	err = mitsumi_set_drive_mode(mcd, MODE_DATA);
+  out:
+	return err;
+}
+
+static int mitsumi_read_header(struct mitsumi_cdrom *mcd)
+{
+	struct cdrom_tochdr header;
+	unsigned char buf[9];
+	int err;
+
+	mcd->header.cdth_trk0 = 0;
+	mcd->header.cdth_trk1 = 0;
+
+	err = mitsumi_read_cmd(mcd, "\x10", 1, buf, sizeof buf, 2000);
+	if (err)
+		goto out;
+
+	header.cdth_trk0 = BCD2BIN(buf[1]);
+	header.cdth_trk1 = BCD2BIN(buf[2]);
+
+	if (header.cdth_trk1 < header.cdth_trk0) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	mcd->header = header;
+
+	mcd->leadout.cdte_addr.msf.minute = BCD2BIN(buf[3]);
+	mcd->leadout.cdte_addr.msf.second = BCD2BIN(buf[4]);
+	mcd->leadout.cdte_addr.msf.frame  = BCD2BIN(buf[5]);
+
+	/*
+	 * First sector MSF in 6-8
+	 */
+  out:
+	return err;
+}
+
+static int mitsumi_update_toc(struct mitsumi_cdrom *mcd)
+{
+	sector_t sectors = 0;
+	int err;
+
+	err = mitsumi_read_header(mcd);
+	if (err)
+		goto out;
+
+	err = mitsumi_read_toc(mcd);
+	if (err)
+		goto out;
+
+	sectors = msf_to_hardsect(&mcd->leadout.cdte_addr.msf) *
+		  (CD_FRAMESIZE >> 9);
+	mcd->toc_uptodate = 1;
+  out:
+	set_capacity(mcd->disk, sectors);
+	return err;
+}
+
+static int mitsumi_config(struct mitsumi_cdrom *mcd)
+{
+	unsigned char cmd[3];
+	int err;
+
+	cmd[0] = 0x90;
+
+	cmd[1] = 0x02;	/* DMA config	*/
+	cmd[2] = 0x00;	/* DMA off	*/
+
+	err = mitsumi_write_cmd(mcd, cmd, sizeof cmd, 1000);
+	if (err)
+		goto out;
+
+	cmd[1] = 0x10;	/* IRQ config	*/
+	cmd[2] = 0x01;	/* IRQ pre	*/
+
+	err = mitsumi_write_cmd(mcd, cmd, sizeof cmd, 1000);
+  out:
+	return err;
+}
+
+static int mitsumi_get_status(struct mitsumi_cdrom *mcd)
+{
+	unsigned char status;
+	int err;
+
+	err = __mitsumi_write_cmd(mcd, "\x40", 1, 5000, &status);
+	if (err)
+		goto out;
+
+	mcd->door_open = !!(status & MITSUMI_RBIT_OPEN);
+
+	if (status & MITSUMI_RBIT_CHANGED) {
+		mcd->media_changed = 1;
+		mcd->toc_uptodate = 0;
+	}
+  out:
+	return err;
+}
+
+static int mitsumi_open(struct cdrom_device_info *cdi, int purpose)
+{
+	struct mitsumi_cdrom *mcd = cdi->handle;
+	int retries;
+	int err;
+
+	mutex_lock(&mcd->mutex);
+
+	retries = 10;
+	do {
+		err = mitsumi_get_status(mcd);
+		if (err)
+			goto out;
+
+		if (!mcd->door_open)
+			break;
+
+		if (!--retries) {
+			err = -ENXIO;
+			goto out;
+		}
+
+		msleep_interruptible(500);
+		if (signal_pending(current)) {
+			err = -EINTR;
+			goto out;
+		}
+
+	} while (1);
+
+	if (!mcd->toc_uptodate) {
+		err = mitsumi_config(mcd);
+		if (err)
+			goto out;
+
+		err = mitsumi_update_toc(mcd);
+	}
+  out:
+	mutex_unlock(&mcd->mutex);
+	return err;
+}
+
+static void mitsumi_release(struct cdrom_device_info *cdi)
+{
+}
+
+static int mitsumi_media_changed(struct cdrom_device_info *cdi, int disc_nr)
+{
+	struct mitsumi_cdrom *mcd = cdi->handle;
+	int ret = 0;
+
+	mutex_lock(&mcd->mutex);
+	if (mitsumi_get_status(mcd))
+		goto out;
+
+	ret = mcd->media_changed;
+	mcd->media_changed = 0;
+  out:
+	mutex_unlock(&mcd->mutex);
+	return ret;
+}
+
+static struct cdrom_device_ops mitsumi_dops = {
+	.open		= mitsumi_open,
+	.release	= mitsumi_release,
+	.media_changed	= mitsumi_media_changed,
+	.capability	= CDC_MEDIA_CHANGED
+};
+
+static void mitsumi_request_data(struct mitsumi_cdrom *mcd, sector_t hardsect,
+				 unsigned long nr_hardsects)
+{
+	struct cdrom_msf0 msf;
+	unsigned char cmd[7];
+
+	hardsect_to_msf(hardsect, &msf);
+
+	cmd[0] = 0xc0;	/* read 1x */
+	cmd[1] = BIN2BCD(msf.minute);
+	cmd[2] = BIN2BCD(msf.second);
+	cmd[3] = BIN2BCD(msf.frame);
+	cmd[4] = 0x00;
+	cmd[5] = 0x00;
+	cmd[6] = nr_hardsects;
+
+	iowrite8_rep(mcd->ioaddr + WREG_DATA, cmd, sizeof cmd);
+}
+
+static void mitsumi_read_data(struct mitsumi_cdrom *mcd, struct bio *bio)
+{
+	struct bio_vec *bvec;
+	int segno;
+
+	bio_for_each_segment(bvec, bio, segno) {
+		unsigned long flags;
+		char *buffer = bvec_kmap_irq(bvec, &flags);
+		ioread8_rep(mcd->ioaddr, buffer, bvec->bv_len);
+		bvec_kunmap_irq(buffer, &flags);
+	}
+}
+
+static int mitsumi_transfer(struct request *req)
+{
+	struct mitsumi_cdrom *mcd = req->rq_disk->private_data;
+	struct completion io_wait;
+	struct bio *bio;
+	int err = 0;
+
+	init_completion(&io_wait);
+	mutex_lock(&mcd->mutex);
+
+	mcd->io_done = &io_wait;
+	mitsumi_request_data(mcd, sector_to_hardsect(req->sector),
+			     sector_to_hardsect(req->nr_sectors));
+	/*
+	 * Wait for the interrupt handler to notify us when the I/O completes
+	 */
+	if (!wait_for_completion_timeout(&io_wait, msecs_to_jiffies(5000))) {
+		printk(KERN_ERR "mitsumi: I/O wait timed out\n");
+		err = -EIO;
+		goto out;
+	}
+
+	/*
+	 * Now actually read the data
+	 */
+	rq_for_each_bio(bio, req)
+		mitsumi_read_data(mcd, bio);
+  out:
+	mutex_unlock(&mcd->mutex);
+	return err;
+}
+
+static void mitsumi_request(struct request_queue *q)
+{
+	struct request *req;
+	int err;
+
+	while ((req = elv_next_request(q))) {
+		if (!blk_fs_request(req)) {
+			end_request(req, 0);
+			continue;
+		}
+		if (rq_data_dir(req) != READ) {
+			printk(KERN_WARNING
+			       "mitsumi: non-read request to CD\n");
+			end_request(req, 0);
+			continue;
+		}
+
+		spin_unlock_irq(q->queue_lock);
+		err = mitsumi_transfer(req);
+		spin_lock_irq(q->queue_lock);
+
+		if (!end_that_request_first(req, !err, req->nr_sectors)) {
+			blkdev_dequeue_request(req);
+			end_that_request_last(req, !err);
+		}
+	}
+}
+
+static int mitsumi_block_open(struct inode *inode, struct file *file)
+{
+	struct mitsumi_cdrom *mcd = inode->i_bdev->bd_disk->private_data;
+
+	return cdrom_open(&mcd->info, inode, file);
+}
+
+static int mitsumi_block_release(struct inode *inode, struct file *file)
+{
+	struct mitsumi_cdrom *mcd = inode->i_bdev->bd_disk->private_data;
+
+	return cdrom_release(&mcd->info, file);
+}
+
+static int mitsumi_block_ioctl(struct inode *inode, struct file *file,
+			       unsigned cmd, unsigned long arg)
+{
+	struct mitsumi_cdrom *mcd = inode->i_bdev->bd_disk->private_data;
+
+	return cdrom_ioctl(file, &mcd->info, inode, cmd, arg);
+}
+
+static int mitsumi_block_media_changed(struct gendisk *disk)
+{
+	struct mitsumi_cdrom *mcd = disk->private_data;
+
+	return cdrom_media_changed(&mcd->info);
+}
+
+static struct block_device_operations mitsumi_bdops = {
+	.owner		= THIS_MODULE,
+	.open		= mitsumi_block_open,
+	.release	= mitsumi_block_release,
+	.ioctl		= mitsumi_block_ioctl,
+	.media_changed	= mitsumi_block_media_changed,
+};
+
+static int mitsumi_check_version(struct mitsumi_cdrom *mcd)
+{
+	int err;
+
+	switch (mcd->ver) {
+	case 'D':
+	case 'F':
+	case 'M':
+		err = 0;
+		break;
+	default:
+		err = -EINVAL;
+		break;
+	};
+
+	return err;
+}
+
+static int mitsumi_request_version(struct mitsumi_cdrom *mcd)
+{
+	unsigned char buf[3];
+	int err;
+
+	err = mitsumi_read_cmd(mcd, "\xdc", 1, buf, sizeof buf, 2000);
+	if (err)
+		goto out;
+
+	mcd->ver = buf[1];
+	mcd->rev = buf[2];
+  out:
+	return err;
+}
+
+static void mitsumi_reset(struct mitsumi_cdrom *mcd)
+{
+	iowrite8(0x00, mcd->ioaddr + WREG_CHANNEL);	/* no dma, no irq */
+	iowrite8(0x00, mcd->ioaddr + WREG_RESET);	/* hardware reset */
+}
+
+static irqreturn_t mitsumi_intr(int irq, void *dev_id)
+{
+	struct mitsumi_cdrom *mcd = dev_id;
+	unsigned char status;
+
+	/*
+	 * Interrupt is raised when I/O completes.  So don't take
+	 * mcd->mutex here because either someone is already holding
+	 * it or we're the only one accessing the hardware and there's
+	 * no need to serialize.
+	 */
+	status = ioread8(mcd->ioaddr + RREG_STATUS);
+	if (status & MITSUMI_RBIT_DTEN) {
+		/*
+		 * Requested data is not ready.
+		 */
+		if (!(status & MITSUMI_RBIT_STEN))
+			printk(KERN_INFO "mitsumi: irq %d, status %#x\n",
+			       irq, ioread8(mcd->ioaddr + RREG_DATA));
+		else
+			printk(KERN_INFO
+			       "mitsumi: irq %d, ambiguous status %#x\n",
+			       irq, status);
+	} else {
+	        struct completion *io_done = mcd->io_done;
+
+		if (io_done) {
+			mcd->io_done = NULL;
+			complete(io_done);
+		}
+	}
+	return IRQ_HANDLED;
+}
+
+static int __devinit mitsumi_match(struct device *dev, unsigned int id)
+{
+	int match = port[id] != 0 && irq[id] != 0;
+
+	if (!match)
+		printk(KERN_ERR "mitsumi: please specify port and irq\n");
+
+	return match;
+}
+
+static int __devinit mitsumi_probe(struct device *dev, unsigned int id)
+{
+	struct mitsumi_cdrom *mcd;
+	struct gendisk *disk;
+	int err;
+
+	mcd = kzalloc(sizeof *mcd, GFP_KERNEL);
+	if (!mcd) {
+		err = -ENOMEM;
+		goto out_free_dev;
+	}
+	mcd->port = port[id];
+	mcd->irq = irq[id];
+	mutex_init(&mcd->mutex);
+
+	if (!request_region(mcd->port, 4, "mitsumi")) {
+		err = -EIO;
+		goto out_free_dev;
+	}
+	mcd->ioaddr = ioport_map(mcd->port, 4);
+
+	mitsumi_reset(mcd);
+	msleep(500);
+
+	err = mitsumi_request_version(mcd);
+	if (err)
+		goto out_release_region;
+
+	err = mitsumi_check_version(mcd);
+	if (err) {
+		printk(KERN_WARNING "mitsumi: unknown firmware version %c%d, "
+		       "driver not initialized\n", mcd->ver, mcd->rev);
+		goto out_release_region;
+	}
+
+	err = request_irq(mcd->irq, mitsumi_intr, IRQF_DISABLED, "mitsumi",
+			  mcd);
+	if (err)
+		goto out_release_region;
+
+	err = mitsumi_config(mcd);
+	if (err)
+		goto out_free_irq;
+
+	printk(KERN_INFO "mitsumi: mitsumi CD-ROM installed at %#lx, irq %d "
+	       "(firmware version %c%d)\n", mcd->port, mcd->irq, mcd->ver,
+	       mcd->rev);
+
+	disk = alloc_disk(1);
+	if (!disk) {
+		err = -ENOMEM;
+		goto out_free_irq;
+	}
+	mcd->disk = disk;
+	disk->private_data = mcd;
+
+	disk->major = MITSUMI_CDROM_MAJOR;
+	disk->first_minor = id;
+	disk->fops = &mitsumi_bdops;
+	disk->flags = GENHD_FL_CD;
+	sprintf(disk->disk_name, "mitsumi%u", id);
+
+	disk->queue = blk_init_queue(mitsumi_request, NULL);
+	if (!disk->queue) {
+		err = -ENOMEM;
+		goto out_put_disk;
+	}
+	blk_queue_hardsect_size(disk->queue, CD_FRAMESIZE);
+	blk_queue_max_sectors(disk->queue, MAX_SECTORS);
+	blk_queue_bounce_limit(disk->queue, BLK_BOUNCE_ANY);
+
+	mcd->info.ops = &mitsumi_dops;
+	mcd->info.speed = 1;
+	mcd->info.capacity = 1;
+	mcd->info.handle = mcd;
+	strcpy(mcd->info.name, disk->disk_name);
+
+	err = register_cdrom(&mcd->info);
+	if (err)
+		goto out_cleanup_queue;
+
+	add_disk(disk);
+
+	dev_set_drvdata(dev, mcd);
+	return 0;
+
+  out_cleanup_queue:
+	blk_cleanup_queue(disk->queue);
+  out_put_disk:
+	put_disk(disk);
+  out_free_irq:
+	free_irq(mcd->irq, mcd);
+  out_release_region:
+	ioport_unmap(mcd->ioaddr);
+	release_region(mcd->port, 4);
+  out_free_dev:
+	kfree(mcd);
+	return err;
+}
+
+static int __devexit mitsumi_remove(struct device *dev, unsigned int id)
+{
+	struct mitsumi_cdrom *mcd = dev_get_drvdata(dev);
+
+	dev_set_drvdata(dev, NULL);
+	del_gendisk(mcd->disk);
+	unregister_cdrom(&mcd->info);
+	blk_cleanup_queue(mcd->disk->queue);
+	put_disk(mcd->disk);
+	free_irq(mcd->irq, mcd);
+	ioport_unmap(mcd->ioaddr);
+	release_region(mcd->port, 4);
+	kfree(mcd->toc);
+	kfree(mcd);
+	return 0;
+}
+
+static struct isa_driver mitsumi_driver = {
+	.match		= mitsumi_match,
+	.probe		= mitsumi_probe,
+	.remove		= __devexit_p(mitsumi_remove),
+
+	.driver		= {
+		.name	= "mitsumi"
+	}
+};
+
+static int __init mitsumi_init(void)
+{
+	int err;
+
+	err = register_blkdev(MITSUMI_CDROM_MAJOR, "mitsumi");
+	if (err)
+		goto out;
+
+	err = isa_register_driver(&mitsumi_driver, NR_DRIVES);
+	if (err)
+		unregister_blkdev(MITSUMI_CDROM_MAJOR, "mitsumi");
+  out:
+	return err;
+}
+
+static void __exit mitsumi_exit(void)
+{
+	isa_unregister_driver(&mitsumi_driver);
+	unregister_blkdev(MITSUMI_CDROM_MAJOR, "mitsumi");
+}
+
+module_init(mitsumi_init);
+module_exit(mitsumi_exit);

--------------030403040705010408020102--
