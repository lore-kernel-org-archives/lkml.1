Return-Path: <linux-kernel-owner+w=401wt.eu-S1755964AbZG0KBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964AbZG0KBt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 06:01:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755929AbZG0KBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 06:01:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59051 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755812AbZG0KBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 06:01:47 -0400
Message-ID: <4A6D79F6.3050509@redhat.com>
Date: Sun, 26 Jul 2009 23:57:10 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090317)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       axboe@kernel.dk, hch@infradead.org, akpm@linux-foundation.org,
       Paul.Clements@steeleye.com, tytso@mit.edu
Subject: [PATCH] Allow userspace block device implementation
X-Enigmail-Version: 0.95.7
Content-Type: multipart/mixed;
 boundary="------------080308000504000201080500"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080308000504000201080500
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Well, it may be a good, bad, idiotic or brilliant idea depending on your
personal philosophy.  I went down this route out of pragmatism.
Hopefully I have not fully re-invented the wheel.

The patch included allows one to implement a kernel level block device
in userspace, using an ioctl() based interface to create a sized device
with given properties, and then receive and respond to bio requests
issued to the device.  One can poll on the associated control socket to
allow efficient servicing of device requests.  So far only strict copy
to/from user memory is supported, there is no fancy page flipping or
mapping operations.

Which there probably should not be.  This device is not about
performance, is it about extending the boundaries of the kernel to the
almost improbable.  Now one can literally create any kind of device
imaginable and use it as a block device in the kernel, mounting
partitions and such and using them as if they existed natively.  I have
attached a very simple dummy program showing how to do this.

The design requirements 'kernel block device in user space' to me
demanded that the interface be stateless.  Userspace can crash, be
killed, or interrupted.  Block devices cannot, they must answer all
requests, even if that answer is a failure.  Thus there exists no state
between the kernel and the userspace process(es) or threads serving the
device.  No establishment of connections, just a queue which can be read
and answered via get and put, the ioctl operators available.  This
allows a completely flexible userspace implementation, with multiple
processes, etc, and allows complete recovery via a simple reset command
if those programs fail.  I believe this also prevents any possibility of
accidental deadlock.  There may of course be some hidden deep deadlock
potential in such a device, especially if one decided to use it as a
swap device, but again, this is a philosophical issue.

Enough talking, let's have at it and see where this goes.  Obviously
this is experimental and open to feedback.  Considering it turns kernel
interfaces on their head, I have given it what I feel is an appropriate
name.

If there is any person or list you know that I forgot to copy this to,
please forward it on to them.

Thanks,

Zach

--------------080308000504000201080500
Content-Type: text/plain;
 name="abuse-module.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="abuse-module.patch"

Allow block devices to be implemented in userspace via IOCTLs
on a char device which is coupled to a virtual block device.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 Documentation/ioctl/ioctl-number.txt |    1 +
 drivers/block/Kconfig                |   15 +
 drivers/block/Makefile               |    1 +
 drivers/block/abuse.c                |  772 ++++++++++++++++++++++++++++++++++
 include/linux/abuse.h                |  115 +++++
 include/linux/major.h                |    3 +
 6 files changed, 907 insertions(+), 0 deletions(-)
 create mode 100644 drivers/block/abuse.c
 create mode 100644 include/linux/abuse.h

diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
index 7bb0d93..95960bd 100644
--- a/Documentation/ioctl/ioctl-number.txt
+++ b/Documentation/ioctl/ioctl-number.txt
@@ -81,6 +81,7 @@ Code	Seq#	Include File		Comments
 '8'	all				SNP8023 advanced NIC card
 					<mailto:mcr@solidum.com>
 'A'	00-1F	linux/apm_bios.h
+'A'     20-2F   linux/abuse.h
 'B'	C0-FF				advanced bbus
 					<mailto:maassen@uni-freiburg.de>
 'C'	all	linux/soundcard.h
diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index 1d886e0..2beeca3 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -213,6 +213,21 @@ config BLK_DEV_COW_COMMON
 	bool
 	default BLK_DEV_UBD
 
+config BLK_DEV_ABUSE
+	tristate "ABUSE user space block device driver"
+	---help---
+	  This driver allows block devices to be implemented in userspace.
+	  It is completely useless and is a massive abuse of the layering
+	  of the kernel.  Unless of course you write a userspace driver
+	  for it, in which case you can create arbitrary block devices.
+
+	  Just don't try to swap over it.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called abuse.
+
+	  Most users will answer N here.
+
 config BLK_DEV_LOOP
 	tristate "Loopback device support"
 	---help---
diff --git a/drivers/block/Makefile b/drivers/block/Makefile
index cdaa3f8..1f5f8df 100644
--- a/drivers/block/Makefile
+++ b/drivers/block/Makefile
@@ -14,6 +14,7 @@ obj-$(CONFIG_PS3_VRAM)		+= ps3vram.o
 obj-$(CONFIG_ATARI_FLOPPY)	+= ataflop.o
 obj-$(CONFIG_AMIGA_Z2RAM)	+= z2ram.o
 obj-$(CONFIG_BLK_DEV_RAM)	+= brd.o
+obj-$(CONFIG_BLK_DEV_ABUSE)	+= abuse.o
 obj-$(CONFIG_BLK_DEV_LOOP)	+= loop.o
 obj-$(CONFIG_BLK_DEV_XD)	+= xd.o
 obj-$(CONFIG_BLK_CPQ_DA)	+= cpqarray.o
diff --git a/drivers/block/abuse.c b/drivers/block/abuse.c
new file mode 100644
index 0000000..a3d004e
--- /dev/null
+++ b/drivers/block/abuse.c
@@ -0,0 +1,772 @@
+/*
+ *  linux/drivers/block/abuse.c
+ *
+ *  Written by Zachary Amsden, 7/23/2009
+ *
+ *  This was heavily stolen from pieces of the loopback, network block device,
+ *  and parts of FUSE.  Since then it has grown antlers and had several new
+ *  limbs grafted onto it, even some of the intenal organs have been replaced.
+ *  Please forgive the comments and the obvious uprooting of kernel interfaces.
+ *
+ *  I believe the module is named appropriately.
+ *
+ *  The point of this driver is to allow /user-space/ drivers for kernel block
+ *  devices.  Yes, it's a strange concept.  However, it's also incredibly
+ *  useful.  I would not recommend trying to swap on these devices, unless you
+ *  can prove that case deadlock free.
+ *
+ * Copyright (c) 2009 by Zachary Amsden.  Redistribution of this file is
+ * permitted under the GNU General Public License.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/sched.h>
+#include <linux/fs.h>
+#include <linux/file.h>
+#include <linux/stat.h>
+#include <linux/errno.h>
+#include <linux/major.h>
+#include <linux/blkdev.h>
+#include <linux/init.h>
+#include <linux/smp_lock.h>
+#include <linux/buffer_head.h>		/* for invalidate_bdev() */
+#include <linux/cdev.h>
+#include <linux/poll.h>
+#include <linux/abuse.h>
+
+#include <asm/uaccess.h>
+
+static LIST_HEAD(abuse_devices);
+static DEFINE_MUTEX(abuse_devices_mutex);
+static struct class *abuse_class;
+static int max_part;
+static int num_minors;
+static int dev_shift;
+
+struct abuse_device *abuse_get_dev(int dev)
+{
+	struct abuse_device *ab = NULL;
+
+	mutex_lock(&abuse_devices_mutex);
+	list_for_each_entry(ab, &abuse_devices, ab_list) 
+		if (ab->ab_number == dev)
+			break;
+	mutex_unlock(&abuse_devices_mutex);
+	return ab;
+}
+
+/*
+ * Add bio to back of pending list
+ */
+static void abuse_add_bio(struct abuse_device *ab, struct bio *bio)
+{
+	printk("abuse_add_bio %p\n", bio);
+	if (ab->ab_biotail) {
+		ab->ab_biotail->bi_next = bio;
+		ab->ab_biotail = bio;
+	} else
+		ab->ab_bio = ab->ab_biotail = bio;
+	ab->ab_queue_size++;
+}
+
+static inline void abuse_add_bio_unlocked(struct abuse_device *ab,
+	struct bio *bio)
+{
+	spin_lock_irq(&ab->ab_lock);
+	abuse_add_bio(ab, bio);
+	spin_unlock_irq(&ab->ab_lock);
+}
+
+static inline struct bio *abuse_find_bio(struct abuse_device *ab,
+	struct bio *match)
+{
+	struct bio *bio;
+	struct bio **pprev = &ab->ab_bio;
+
+	while ((bio = *pprev) != 0 && match && bio != match)
+		pprev = &bio->bi_next;
+
+	if (bio) {
+		if (bio == ab->ab_biotail) {
+			ab->ab_biotail = bio == ab->ab_bio ? NULL :
+			   (struct bio *) 
+			   ((caddr_t)pprev - offsetof(struct bio, bi_next));
+		}
+		*pprev = bio->bi_next;
+		bio->bi_next = NULL;
+		ab->ab_queue_size--;
+	}
+
+	printk("abuse_find_bio %p %p\n", bio, match);
+	return bio;
+}
+
+static int abuse_make_request(struct request_queue *q, struct bio *old_bio)
+{
+	struct abuse_device *ab = q->queuedata;
+	int rw = bio_rw(old_bio);
+
+	if (rw == READA)
+		rw = READ;
+
+	BUG_ON(!ab || (rw != READ && rw != WRITE));
+
+	spin_lock_irq(&ab->ab_lock);
+	if (unlikely(rw == WRITE && (ab->ab_flags & ABUSE_FLAGS_READ_ONLY)))
+		goto out;
+	if (unlikely(ab->ab_queue_size == ab->ab_max_queue))
+		goto out;
+	abuse_add_bio(ab, old_bio);
+	wake_up(&ab->ab_event);
+	spin_unlock_irq(&ab->ab_lock);
+	return 0;
+
+out:
+	ab->ab_errors++;
+	spin_unlock_irq(&ab->ab_lock);
+	bio_io_error(old_bio);
+	return 0;
+}
+
+static void abuse_flush_bio(struct abuse_device *ab)
+{
+	struct bio *bio, *next;
+
+	spin_lock_irq(&ab->ab_lock);
+	bio = ab->ab_bio;
+	ab->ab_biotail = ab->ab_bio = NULL;
+	ab->ab_queue_size = 0;
+	spin_unlock_irq(&ab->ab_lock);
+
+	while (bio) {
+		next = bio->bi_next;
+		bio->bi_next = NULL;
+		bio_io_error(bio);
+		bio = next;
+	}
+}
+
+/*
+ * kick off io on the underlying address space
+ */
+static void abuse_unplug(struct request_queue *q)
+{
+	queue_flag_clear_unlocked(QUEUE_FLAG_PLUGGED, q);
+}
+
+static inline int is_abuse_device(struct file *file)
+{
+	struct inode *i = file->f_mapping->host;
+
+	return i && S_ISBLK(i->i_mode) && MAJOR(i->i_rdev) == ABUSE_MAJOR;
+}
+
+static int abuse_reset(struct abuse_device *ab)
+{
+	if (!ab->ab_disk->queue)
+		return -EINVAL;
+
+	abuse_flush_bio(ab);
+	ab->ab_queue->unplug_fn = NULL;
+	ab->ab_flags = 0;
+	ab->ab_errors = 0;
+	ab->ab_blocksize = 0;
+	ab->ab_size = 0;
+	ab->ab_max_queue = 0;
+	set_capacity(ab->ab_disk, 0);
+	if (ab->ab_device) {
+		bd_set_size(ab->ab_device, 0);
+		invalidate_bdev(ab->ab_device);
+		if (max_part > 0)
+			ioctl_by_bdev(ab->ab_device, BLKRRPART, 0);
+		blkdev_put(ab->ab_device, FMODE_READ);
+		ab->ab_device = NULL;
+		module_put(THIS_MODULE);
+	}
+	return 0;
+}
+
+static int
+abuse_set_status_int(struct abuse_device *ab, struct block_device *bdev,
+	const struct abuse_info *info)
+{
+	sector_t size = (sector_t)(info->ab_size >> 9);
+	loff_t blocks;
+	int err;
+
+	if (unlikely((loff_t)size != size))
+		return -EFBIG;
+
+	blocks = info->ab_size / info->ab_blocksize;
+	if (unlikely(info->ab_blocksize * blocks != info->ab_size))
+		return -EINVAL;
+
+	if (unlikely(info->ab_max_queue) > 512)
+		return -EINVAL;
+
+	if (unlikely(bdev)) {
+		if (bdev != ab->ab_device)
+			return -EBUSY;
+		if (!(ab->ab_flags & ABUSE_FLAGS_RECONNECT))
+			return -EINVAL;
+
+		/*
+		 * Don't allow these to change on a reconnect.
+		 * We do allow changing the max queue size and
+		 * the RO flag.
+		 */
+		if (ab->ab_size != info->ab_size ||
+		    ab->ab_blocksize != info->ab_blocksize ||
+		    info->ab_max_queue > ab->ab_queue_size)
+		    	return -EINVAL;
+	} else {
+		bdev = bdget_disk(ab->ab_disk, 0);
+		if (IS_ERR(bdev)) {
+			err = PTR_ERR(bdev);
+			return err;
+		}
+		err = blkdev_get(bdev, FMODE_READ);
+		if (err) {
+			bdput(bdev);
+			return err;
+		}
+		__module_get(THIS_MODULE);
+	}
+
+	ab->ab_device = bdev;
+	blk_queue_make_request(ab->ab_queue, abuse_make_request);
+	ab->ab_queue->queuedata = ab;
+	ab->ab_queue->unplug_fn = abuse_unplug;
+	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, ab->ab_queue);
+
+	ab->ab_size = info->ab_size;
+	ab->ab_flags = (info->ab_flags & ABUSE_FLAGS_READ_ONLY);
+	ab->ab_blocksize = info->ab_blocksize;
+	ab->ab_max_queue = info->ab_max_queue;
+
+	set_capacity(ab->ab_disk, size);
+	set_device_ro(bdev, (ab->ab_flags & ABUSE_FLAGS_READ_ONLY) != 0);
+	set_capacity(ab->ab_disk, size);
+	bd_set_size(bdev, size << 9);
+	set_blocksize(bdev, ab->ab_blocksize);
+	if (max_part > 0)
+		ioctl_by_bdev(bdev, BLKRRPART, 0);
+
+	return 0;
+}
+
+static int
+abuse_get_status_int(struct abuse_device *ab, struct abuse_info *info)
+{
+	memset(info, 0, sizeof(*info));
+	info->ab_size = ab->ab_size;
+	info->ab_number = ab->ab_number;
+	info->ab_flags = ab->ab_flags;
+	info->ab_blocksize = ab->ab_blocksize;
+	info->ab_max_queue = ab->ab_max_queue;
+	info->ab_queue_size = ab->ab_queue_size;
+	info->ab_errors = ab->ab_errors;
+	info->ab_max_vecs = BIO_MAX_PAGES;
+	return 0;
+}
+
+static int
+abuse_set_status(struct abuse_device *ab, struct block_device *bdev,
+	const struct abuse_info __user *arg)
+{
+	struct abuse_info info;
+
+	if (copy_from_user(&info, arg, sizeof (struct abuse_info)))
+		return -EFAULT;
+	return abuse_set_status_int(ab, bdev, &info);
+}
+
+static int
+abuse_get_status(struct abuse_device *ab, struct block_device *bdev,
+	struct abuse_info __user *arg)
+{
+	struct abuse_info info;
+	int err = 0;
+
+	if (!arg)
+		err = -EINVAL;
+	if (!err)
+		err = abuse_get_status_int(ab, &info);
+	if (!err && copy_to_user(arg, &info, sizeof(info)))
+		err = -EFAULT;
+
+	return err;
+}
+
+static int
+abuse_get_bio(struct abuse_device *ab, struct abuse_xfr_hdr __user *arg)
+{
+	struct abuse_xfr_hdr xfr;
+	struct bio *bio;
+
+	if (!arg)
+		return -EINVAL;
+	if (!ab)
+		return -ENODEV;
+
+	if (copy_from_user(&xfr, arg, sizeof (struct abuse_xfr_hdr)))
+		return -EFAULT;
+
+	spin_lock_irq(&ab->ab_lock);
+	bio = abuse_find_bio(ab, NULL);
+	xfr.ab_id = (__u64)bio;
+	if (bio) {
+		int i;
+		xfr.ab_sector = bio->bi_sector;
+		xfr.ab_command = (bio->bi_rw & BIO_RW);
+		xfr.ab_vec_count = bio->bi_vcnt;
+		for (i = 0; i < bio->bi_vcnt; i++) {
+			ab->ab_xfer[i].ab_len = bio->bi_io_vec[i].bv_len;
+			ab->ab_xfer[i].ab_offset = bio->bi_io_vec[i].bv_offset;
+		}
+
+		/* Put it back to the end of the list */
+		abuse_add_bio(ab, bio);
+	} else {
+		xfr.ab_transfer_address = 0;
+		xfr.ab_vec_count = 0;
+	}
+	spin_unlock_irq(&ab->ab_lock);
+
+	if (copy_to_user(arg, &xfr, sizeof(xfr)))
+		return -EFAULT;
+	if (xfr.ab_transfer_address &&
+		copy_to_user((void *)xfr.ab_transfer_address, ab->ab_xfer,
+			     xfr.ab_vec_count * sizeof(ab->ab_xfer[0])))
+		return -EFAULT;
+	
+	return bio ? 0 : -ENOMSG;
+}
+
+static int
+abuse_put_bio(struct abuse_device *ab, struct abuse_xfr_hdr __user *arg)
+{
+	struct abuse_xfr_hdr xfr;
+	struct bio *bio;
+	struct bio_vec *bvec;
+	int i, read;
+
+	if (!arg)
+		return -EINVAL;
+	if (!ab)
+		return -ENODEV;
+
+	if (copy_from_user(&xfr, arg, sizeof (struct abuse_xfr_hdr)))
+		return -EFAULT;
+
+	/*
+	 * Handle catastrophes first.  Do this by giving them catnip.
+	 */
+	if (unlikely(xfr.ab_result == ABUSE_RESULT_DEVICE_FAILURE)) {
+		abuse_flush_bio(ab);
+		return 0;
+	}
+
+	/*
+	 * Look up the dang thing to make sure the user is telling us
+	 * they've actually completed some work.  It's very doubtful.
+	 */
+	spin_lock_irq(&ab->ab_lock);
+	bio = abuse_find_bio(ab, (struct bio *)xfr.ab_id);
+	spin_unlock_irq(&ab->ab_lock);
+	if (!bio)
+		return -ENOMSG;
+	
+	/*
+	 * This isn't just arbitrary anal-retentiveness.  Userspace will
+	 * obviously crash and burn, and so we check all fields as stringently
+	 * as possible to provide some protection against the case when we
+	 * re-use the same bio and some user-tarded program tries to complete
+	 * an historical event.  Better prophylactics are possible, but crazy.
+	 */
+	if (bio->bi_sector != xfr.ab_sector ||
+	    bio->bi_vcnt != xfr.ab_vec_count ||
+	    (bio->bi_rw & BIO_RW) != xfr.ab_command) {
+	    	abuse_add_bio_unlocked(ab, bio);
+		return -EINVAL;
+	}
+	read = !(bio->bi_rw & BIO_RW);
+	
+	/*
+	 * Now handle individual failures that don't affect other I/Os.
+	 */
+	if (unlikely(xfr.ab_result == ABUSE_RESULT_MEDIA_FAILURE)) {
+		bio_io_error(bio);
+		return 0;
+	}
+
+	/*
+	 * We've now stolen the bio off the queue.  This is stupid if we don't
+	 * complete it.  But we don't want to hold the spinlock while doing I/O
+	 * from the user component.  If userspace bugs out and crashes, as is
+	 * to be expected from a userspace program, so be it.  The bio can
+	 * always be cancelled by a sane actor when we put it back.
+	 */
+	if (copy_from_user(ab->ab_xfer, (void *)xfr.ab_transfer_address,
+			     bio->bi_vcnt * sizeof(ab->ab_xfer[0]))) {
+	    	abuse_add_bio_unlocked(ab, bio);
+		return -EFAULT;
+	}
+	
+	/*
+	 * You made it this far?  It's time for the third movement.
+	 */
+	bio_for_each_segment(bvec, bio, i)
+	{
+		int ret;
+		void *kaddr = kmap(bvec->bv_page);
+
+		if (read)
+			ret = copy_from_user(kaddr + bvec->bv_offset, 
+				(void *)ab->ab_xfer[i].ab_address,
+				bvec->bv_len);
+		else
+			ret = copy_to_user((void *)ab->ab_xfer[i].ab_address,
+				kaddr + bvec->bv_offset, bvec->bv_len);
+
+		kunmap(bvec->bv_page);
+		if (ret != 0) { 
+			/* Wise, up sucker! (PWEI RULEZ) */
+			abuse_add_bio_unlocked(ab, bio);
+			return -EFAULT;
+		}
+	}
+
+	/* Well, you did it.  Congraulations, you get a pony. */
+	bio_endio(bio, 0);
+
+	return 0;
+}
+
+static int abctl_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
+	unsigned long arg)
+{
+	struct abuse_device *ab = filp->private_data;
+	int err;
+
+	if (!ab || !ab->ab_disk)
+		return -ENODEV;
+
+	mutex_lock(&ab->ab_ctl_mutex);
+	switch (cmd) {
+	case ABUSE_GET_STATUS:
+		err = abuse_get_status(ab, ab->ab_device,
+				       (struct abuse_info __user *) arg);
+		break;
+	case ABUSE_SET_STATUS:
+		err = abuse_set_status(ab, ab->ab_device,
+				       (struct abuse_info __user *) arg);
+		break;
+	case ABUSE_RESET:
+		err = abuse_reset(ab);
+		break;
+	case ABUSE_GET_BIO:
+		err = abuse_get_bio(ab, (struct abuse_xfr_hdr __user *) arg);
+		break;
+	case ABUSE_PUT_BIO:
+		err = abuse_put_bio(ab, (struct abuse_xfr_hdr __user *) arg);
+		break;
+	default:
+		err = -EINVAL;
+	}
+	mutex_unlock(&ab->ab_ctl_mutex);
+	return err;
+}
+
+static unsigned int abctl_poll(struct file *filp, poll_table *wait)
+{
+	unsigned int mask;
+	struct abuse_device *ab = filp->private_data;
+
+	poll_wait(filp, &ab->ab_event, wait);
+
+	/*
+	 * The comment in asm-generic/poll.h says of these nonstandard values,
+	 * 'Check them!'.  Thus we use POLLMSG to force the user to check it.
+	 */
+	mask = (ab->ab_bio) ? POLLMSG : 0;
+
+	return mask;
+}
+
+static int abctl_open(struct inode *inode, struct file *filp)
+{
+	struct abuse_device *ab;
+	
+	ab = abuse_get_dev(iminor(inode));
+	if (!ab)
+		return -ENODEV;
+
+	filp->private_data = ab;
+	return 0;
+}
+
+static int abctl_release(struct inode *inode, struct file *filp)
+{
+	struct abuse_device *ab = filp->private_data;
+	if (!ab)
+		return -ENODEV;
+
+	return 0;
+}
+
+static int ab_open(struct block_device *bdev, fmode_t mode)
+{
+	return 0;
+}
+
+static int ab_release(struct gendisk *disk, fmode_t mode)
+{
+	return 0;
+}
+
+static struct block_device_operations ab_fops = {
+	.owner =	THIS_MODULE,
+	.open =		ab_open,
+	.release =	ab_release,
+};
+
+static struct file_operations abctl_fops = {
+	.owner =	THIS_MODULE,
+	.open =		abctl_open,
+	.release =	abctl_release,
+	.ioctl =	abctl_ioctl,
+	.poll =		abctl_poll,
+};
+
+/*
+ * And now the modules code and kernel interface.
+ */
+static int max_abuse;
+module_param(max_abuse, int, 0);
+MODULE_PARM_DESC(max_abuse, "Maximum number of abuse devices");
+module_param(max_part, int, 0);
+MODULE_PARM_DESC(max_part, "Maximum number of partitions per abuse device");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_BLOCKDEV_MAJOR(ABUSE_MAJOR);
+
+static struct abuse_device *abuse_alloc(int i)
+{
+	struct abuse_device *ab;
+	struct gendisk *disk;
+	struct cdev *cdev;
+	struct device *device;
+
+	ab = kzalloc(sizeof(*ab), GFP_KERNEL);
+	if (!ab)
+		goto out;
+
+	ab->ab_queue = blk_alloc_queue(GFP_KERNEL);
+	if (!ab->ab_queue)
+		goto out_free_dev;
+
+	disk = ab->ab_disk = alloc_disk(num_minors);
+	if (!disk)
+		goto out_free_queue;
+	
+	disk->major		= ABUSE_MAJOR;
+	disk->first_minor	= i << dev_shift;
+	disk->fops		= &ab_fops;
+	disk->private_data	= ab;
+	disk->queue		= ab->ab_queue;
+	sprintf(disk->disk_name, "abuse%d", i);
+
+	cdev = ab->ab_cdev = cdev_alloc();
+	if (!cdev)
+		goto out_free_disk;
+
+	cdev->owner = THIS_MODULE;
+	cdev->ops = &abctl_fops;
+
+	if (cdev_add(ab->ab_cdev, MKDEV(ABUSECTL_MAJOR, i), 1) != 0)
+		goto out_free_cdev;
+	
+	device = device_create(abuse_class, NULL, MKDEV(ABUSECTL_MAJOR, i), ab,
+				"abctl%d", i);
+	if (IS_ERR(device)) {
+		printk(KERN_ERR "abuse_alloc: device_create failed\n");
+		goto out_free_cdev;
+	}
+	
+	mutex_init(&ab->ab_ctl_mutex);
+	ab->ab_number		= i;
+	init_waitqueue_head(&ab->ab_event);
+	spin_lock_init(&ab->ab_lock);
+
+	return ab;
+
+out_free_cdev:
+	cdev_del(ab->ab_cdev);
+out_free_disk:
+	put_disk(ab->ab_disk);
+out_free_queue:
+	blk_cleanup_queue(ab->ab_queue);
+out_free_dev:
+	kfree(ab);
+out:
+	return NULL;
+}
+
+static void abuse_free(struct abuse_device *ab)
+{
+	blk_cleanup_queue(ab->ab_queue);
+	device_destroy(abuse_class, MKDEV(ABUSECTL_MAJOR, ab->ab_number));
+	cdev_del(ab->ab_cdev);
+	put_disk(ab->ab_disk);
+	list_del(&ab->ab_list);
+	kfree(ab);
+}
+
+static struct abuse_device *abuse_init_one(int i)
+{
+	struct abuse_device *ab;
+
+	list_for_each_entry(ab, &abuse_devices, ab_list) 
+		if (ab->ab_number == i)
+			return ab;
+
+	ab = abuse_alloc(i);
+	if (ab) {
+		add_disk(ab->ab_disk);
+		list_add_tail(&ab->ab_list, &abuse_devices);
+	}
+	return ab;
+}
+
+static void abuse_del_one(struct abuse_device *ab)
+{
+	del_gendisk(ab->ab_disk);
+	abuse_free(ab);
+}
+
+static struct kobject *abuse_probe(dev_t dev, int *part, void *data)
+{
+	struct abuse_device *ab;
+	struct kobject *kobj;
+
+	mutex_lock(&abuse_devices_mutex);
+	ab = abuse_init_one(dev & MINORMASK);
+	kobj = ab ? get_disk(ab->ab_disk) : ERR_PTR(-ENOMEM);
+	mutex_unlock(&abuse_devices_mutex);
+
+	*part = 0;
+	return kobj;
+}
+
+static int __init abuse_init(void)
+{
+	int i, nr, err;
+	unsigned long range;
+	struct abuse_device *ab, *next;
+
+	/*
+	 * abuse module has a feature to instantiate underlying device
+	 * structure on-demand, provided that there is an access dev node.
+	 *
+	 * (1) if max_abuse is specified, create that many upfront, and this
+	 *     also becomes a hard limit.  Cross it and divorce is likely.
+	 * (2) if max_abuse is not specified, create 8 abuse device on module
+	 *     load, user can further extend abuse device by create dev node
+	 *     themselves and have kernel automatically instantiate actual
+	 *     device on-demand.
+	 */
+
+	dev_shift = 0;
+	if (max_part > 0)
+		dev_shift = fls(max_part);
+	num_minors = 1 << dev_shift;
+
+	if (max_abuse > 1UL << (MINORBITS - dev_shift))
+		return -EINVAL;
+
+	if (max_abuse) {
+		nr = max_abuse;
+		range = max_abuse;
+	} else {
+		nr = 8;
+		range = 1UL << (MINORBITS - dev_shift);
+	}
+
+	err = -EIO;
+	if (register_blkdev(ABUSE_MAJOR, "abuse")) {
+		printk("abuse: register_blkdev failed!\n");
+		return err;
+	}
+	
+	err = register_chrdev_region(MKDEV(ABUSECTL_MAJOR, 0), range, "abuse");
+	if (err) {
+		printk("abuse: register_chrdev_region failed!\n");
+		goto unregister_blk;
+	}
+
+	abuse_class = class_create(THIS_MODULE, "abuse");
+	if (IS_ERR(abuse_class)) {
+		err = PTR_ERR(abuse_class);
+		goto unregister_chr;
+	}
+
+	err = -ENOMEM;
+	for (i = 0; i < nr; i++) {
+		ab = abuse_alloc(i);
+		if (!ab) {
+			printk(KERN_INFO "abuse: out of memory\n");
+			goto free_devices;
+		}
+		list_add_tail(&ab->ab_list, &abuse_devices);
+	}
+
+	/* point of no return */
+
+	list_for_each_entry(ab, &abuse_devices, ab_list)
+		add_disk(ab->ab_disk);
+
+	blk_register_region(MKDEV(ABUSE_MAJOR, 0), range,
+				  THIS_MODULE, abuse_probe, NULL, NULL);
+
+	printk(KERN_INFO "abuse: module loaded\n");
+	return 0;
+
+free_devices:
+	list_for_each_entry_safe(ab, next, &abuse_devices, ab_list)
+		abuse_free(ab);
+unregister_chr:
+	unregister_chrdev_region(MKDEV(ABUSECTL_MAJOR, 0), range);
+unregister_blk:
+	unregister_blkdev(ABUSE_MAJOR, "abuse");
+	return err;
+}
+
+static void __exit abuse_exit(void)
+{
+	unsigned long range;
+	struct abuse_device *ab, *next;
+
+	range = max_abuse ? max_abuse :  1UL << (MINORBITS - dev_shift);
+
+	list_for_each_entry_safe(ab, next, &abuse_devices, ab_list)
+		abuse_del_one(ab);
+	class_destroy(abuse_class);
+	blk_unregister_region(MKDEV(ABUSE_MAJOR, 0), range);
+	unregister_chrdev_region(MKDEV(ABUSECTL_MAJOR, 0), range);
+	unregister_blkdev(ABUSE_MAJOR, "abuse");
+}
+
+module_init(abuse_init);
+module_exit(abuse_exit);
+
+#ifndef MODULE
+static int __init max_abuse_setup(char *str)
+{
+	max_abuse = simple_strtol(str, NULL, 0);
+	return 1;
+}
+
+__setup("max_abuse=", max_abuse_setup);
+#endif
diff --git a/include/linux/abuse.h b/include/linux/abuse.h
new file mode 100644
index 0000000..b904d50
--- /dev/null
+++ b/include/linux/abuse.h
@@ -0,0 +1,115 @@
+#ifndef _LINUX_ABUSE_H
+#define _LINUX_ABUSE_H
+
+/*
+ * include/linux/abuse.h
+ *
+ * Copyright 2009 by Zachary Amsden.  Redistribution of this file is
+ * permitted under the GNU General Public License.
+ */
+
+/*
+ * Loop flags
+ */
+enum {
+	ABUSE_FLAGS_READ_ONLY	= 1,
+	ABUSE_FLAGS_RECONNECT	= 2,
+};
+
+#include <linux/types.h>	/* for __u64 */
+
+struct abuse_info {
+	__u64		   ab_device;			/* ioctl r/o */
+	__u64		   ab_size;			/* ioctl r/w */
+	__u32		   ab_number;			/* ioctl r/o */
+	__u32		   ab_flags;			/* ioctl r/w */
+	__u32		   ab_blocksize;		/* ioctl r/w */
+	__u32		   ab_max_queue;		/* ioctl r/w */
+	__u32		   ab_queue_size;		/* ioctl r/o */
+	__u32		   ab_errors;			/* ioctl r/o */
+	__u32		   ab_max_vecs;			/* ioctl r/o */
+};
+
+/*
+ * IOCTL commands 
+ */
+
+#define ABUSE_GET_STATUS	0x4120
+#define ABUSE_SET_STATUS	0x4121
+#define ABUSE_SET_POLL		0x4122
+#define ABUSE_RESET		0x4123
+#define ABUSE_GET_BIO		0x4124
+#define ABUSE_PUT_BIO		0x4125
+
+struct abuse_vec {
+	__u64			ab_address;
+	__u32			ab_len;
+	__u32			ab_offset;
+};
+
+struct abuse_xfr_hdr {
+	__u64			ab_id;
+	__u64			ab_sector;
+	__u32			ab_command;
+	__u32			ab_result;
+	__u32			ab_vec_count;
+	__u32			ab_vec_offset;
+	__u64			ab_transfer_address;
+};
+
+/*
+ * ab_commnd codes 
+ */
+enum {
+	ABUSE_READ			= 0,
+	ABUSE_WRITE			= 1,
+	ABUSE_SYNC_NOTIFICATION		= 2
+};
+
+/*
+ * ab_result codes 
+ */
+enum {
+	ABUSE_RESULT_OKAY		= 0,
+	ABUSE_RESULT_MEDIA_FAILURE	= 1,
+	ABUSE_RESULT_DEVICE_FAILURE	= 2
+};
+
+#ifdef __KERNEL__
+#include <linux/bio.h>
+#include <linux/blkdev.h>
+#include <linux/spinlock.h>
+#include <linux/mutex.h>
+
+struct abuse_device {
+	int		ab_number;
+	int		ab_refcnt;
+	loff_t		ab_size;
+	int		ab_flags;
+	int		ab_queue_size;
+	int		ab_max_queue;
+	int		ab_errors;
+
+	struct block_device *ab_device;
+	unsigned	ab_blocksize;
+
+	gfp_t		old_gfp_mask;
+
+	spinlock_t		ab_lock;
+	struct bio 		*ab_bio;
+	struct bio		*ab_biotail;
+	struct mutex		ab_ctl_mutex;
+	wait_queue_head_t	ab_event;
+
+	struct request_queue	*ab_queue;
+	struct gendisk		*ab_disk;
+	struct cdev		*ab_cdev;
+	struct list_head	ab_list;
+
+	/* user xfer area */
+	struct abuse_vec	ab_xfer[BIO_MAX_PAGES];
+};
+
+#endif /* __KERNEL__ */
+
+#endif
diff --git a/include/linux/major.h b/include/linux/major.h
index 6a8ca98..652086c 100644
--- a/include/linux/major.h
+++ b/include/linux/major.h
@@ -75,6 +75,9 @@
 #define IDE4_MAJOR		56
 #define IDE5_MAJOR		57
 
+#define ABUSE_MAJOR		60
+#define ABUSECTL_MAJOR		61
+
 #define SCSI_DISK1_MAJOR	65
 #define SCSI_DISK2_MAJOR	66
 #define SCSI_DISK3_MAJOR	67
-- 
1.6.2.2.471.g6da14


--------------080308000504000201080500
Content-Type: text/x-csrc;
 name="abusectl.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="abusectl.c"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <poll.h>
#include "include/linux/abuse.h"

void usage(void)
{
	printf("abusectl <cmd>\n"
		"	reset <dev>	   - issue a reset on an abuse device\n"
		"	info <dev>	   - get info from an abuse device\n"
		"	get <dev>	   - get bio from an abuse device\n"
		"	put <dev>	   - put bio to an abuse device\n"
		"	poll <dev>	   - poll for a bio on device\n"
		"	server <dev>	   - act as a server putting bios\n"
		"	setup <dev> <args> - setup device parameters\n"
	 	"		<args> is a list of comma delimited keys\n"
		"		sz/size=<N>		set size (K,M.G ok)\n"
		"		bs/blocksize=<N>	set block size\n"
		"		qs/queusize=<N>		set queue size\n"
		"		ro			make device read-only\n"		
		"		rw			make device writeable\n"		
		"		reconnect		do not reset already setup device\n"		
		);
	exit(1);
}

int get_device(char *fname)
{
	int fd;

	fd = open(fname, O_RDONLY);
	if (fd < 0) {
		perror("open");
		exit(1);
	}
	return fd;
}

int do_reset(int fd)
{
	int ret;
	ret = ioctl(fd, ABUSE_RESET);
	if (ret < 0) {
		perror("ioctl");
		exit(1);
	}
}

int do_info(int fd)
{
	int ret;
	struct abuse_info ab;

	ret = ioctl(fd, ABUSE_GET_STATUS, &ab);
	if (ret < 0) {
		perror("ioctl");
		exit(1);
	}
	printf("ab_size = %lld\n", ab.ab_size);
	printf("ab_number = %d\n", ab.ab_number);
	printf("ab_flags = %x\n", ab.ab_flags);
	printf("ab_blocksize = %d\n", ab.ab_blocksize);
	printf("ab_max_queue = %d\n", ab.ab_max_queue);
	printf("ab_queue_size = %d\n", ab.ab_queue_size);
	printf("ab_errors = %d\n", ab.ab_errors);
}

int do_setup(int fd)
{
	int ret;
	struct abuse_info ab;

	memset(&ab, '\0', sizeof(ab));
	ab.ab_size = 4096 * 4096;
	ab.ab_blocksize = 4096;
	ab.ab_max_queue = 128;
	ab.ab_flags = 0;
	ret = ioctl(fd, ABUSE_SET_STATUS, &ab);
	if (ret < 0) {
		perror("ioctl");
		exit(1);
	}
}

int do_getbio(int fd)
{
	int ret, i;
	struct abuse_xfr_hdr hdr;
	struct abuse_vec xfr[512];

	memset(&hdr, '\0', sizeof(hdr));
	hdr.ab_transfer_address = (__u64)xfr;
	ret = ioctl(fd, ABUSE_GET_BIO, &hdr);
	if (ret < 0) {
		perror("ioctl");
		exit(1);
	}
	if (hdr.ab_command == ABUSE_READ)
		printf("READ\n");
	else
		printf("WRITE\n");
	printf("sector = %lld\n", hdr.ab_sector);
	printf("vcnt = %d\n", hdr.ab_vec_count);
	for (i = 0; i < hdr.ab_vec_count; i++) {
		printf("len%d = %lld, offset = %llx\n", i, xfr[i].ab_len,
			xfr[i].ab_offset);
	}
}

int do_putbio(int fd)
{
	int ret, i;
	struct abuse_xfr_hdr hdr;
	struct abuse_vec xfr[512];

	memset(&hdr, '\0', sizeof(hdr));
	hdr.ab_transfer_address = (__u64)xfr;
	ret = ioctl(fd, ABUSE_GET_BIO, &hdr);
	if (ret < 0) {
		perror("ioctl");
		exit(1);
	}
	if (hdr.ab_command == ABUSE_READ)
		printf("READ\n");
	else
		printf("WRITE\n");
	printf("sector = %lld\n", hdr.ab_sector);
	printf("vcnt = %d\n", hdr.ab_vec_count);
	for (i = 0; i < hdr.ab_vec_count; i++) {
		printf("len%d = %lld, offset = %llx\n", i, xfr[i].ab_len,
			xfr[i].ab_offset);
		xfr[i].ab_address = (__u64)malloc(xfr[i].ab_len);
	}
	ret = ioctl(fd, ABUSE_PUT_BIO, &hdr);
	if (ret < 0) {
		perror("ioctl");
		exit(1);
	}
	for (i = 0; i < hdr.ab_vec_count; i++) {
		free((void *)xfr[i].ab_address);
	}
}

#ifndef POLLMSG
#define POLLMSG         0x0400
#endif

int do_poll(int fd)
{
	int ret;
	struct pollfd fds;

	fds.fd = fd;
	fds.events = POLLMSG;
	ret = poll(&fds, 1, -1);
	if (ret < 0) {
		perror("poll");
		exit(1);
	}
	printf("%d %lx\n", ret, fds.revents);
}

int main(int argc, char **argv)
{
	int fd;

	if (argc < 3) {
		usage();
	}
	fd = get_device(argv[2]);
	if (!strcmp(argv[1], "reset")) {
		do_reset(fd);
	} else if (!strcmp(argv[1], "info")) {
		do_info(fd);
	} else if (!strcmp(argv[1], "setup")) {
		do_setup(fd);
	} else if (!strcmp(argv[1], "get")) {
		do_getbio(fd);
	} else if (!strcmp(argv[1], "put")) {
		do_putbio(fd);
	} else if (!strcmp(argv[1], "poll")) {
		do_poll(fd);
	} else if (!strcmp(argv[1], "server")) {
		for (;;) {
			do_poll(fd);
			do_putbio(fd);
		}
	} else usage();
}

--------------080308000504000201080500--
