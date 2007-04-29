Return-Path: <linux-kernel-owner+w=401wt.eu-S1030878AbXD2SQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030878AbXD2SQz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 14:16:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030812AbXD2SQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 14:16:55 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58239 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030878AbXD2SQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 14:16:53 -0400
Date: Sun, 29 Apr 2007 19:16:46 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, lkml <linux-kernel@vger.kernel.org>,
       Chris Wright <chrisw@sous-sol.org>, Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       Arjan van de Ven <arjan@infradead.org>, Greg KH <greg@kroah.com>,
       Jens Axboe <axboe@kernel.dk>
Subject: Re: [patch 26/32] xen: Add Xen virtual block device driver.
Message-ID: <20070429181646.GB3551@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	virtualization@lists.osdl.org, lkml <linux-kernel@vger.kernel.org>,
	Chris Wright <chrisw@sous-sol.org>,
	Ian Pratt <ian.pratt@xensource.com>,
	Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
	Arjan van de Ven <arjan@infradead.org>, Greg KH <greg@kroah.com>,
	Jens Axboe <axboe@kernel.dk>
References: <20070429172835.284784000@goop.org> <20070429172915.805798000@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070429172915.805798000@goop.org>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>  source "drivers/s390/block/Kconfig"
> +source "drivers/block/xen/Kconfig"

Please don't add a new subdirectory for a tiny new driver that
really should be only a single .c file.

> +config XEN_BLKDEV_FRONTEND
> +	tristate "Block device frontend driver"
> +	depends on XEN
> +	default y

Please kill the default statement.  We really should have script that
autorejects every new driver that wants to be default y..

> +#include <linux/version.h>

not needed, as usual.

> +#define BLKIF_STATE_DISCONNECTED 0
> +#define BLKIF_STATE_CONNECTED    1
> +#define BLKIF_STATE_SUSPENDED    2

enum, please.

> +static void connect(struct blkfront_info *);
> +static void blkfront_closing(struct xenbus_device *);
> +static int blkfront_remove(struct xenbus_device *);
> +static int talk_to_backend(struct xenbus_device *, struct blkfront_info *);
> +static int setup_blkring(struct xenbus_device *, struct blkfront_info *);
> +
> +static void kick_pending_request_queues(struct blkfront_info *);
> +
> +static irqreturn_t blkif_int(int irq, void *dev_id);
> +static void blkif_restart_queue(struct work_struct *work);
> +static void blkif_recover(struct blkfront_info *);
> +static void blkif_completion(struct blk_shadow *);
> +static void blkif_free(struct blkfront_info *, int);

Please get rid of all the forward-declarations by putting the code
into proper order.

> +static inline int GET_ID_FROM_FREELIST(
> +	struct blkfront_info *info)
> +{
> +	unsigned long free = info->shadow_free;
> +	BUG_ON(free > BLK_RING_SIZE);
> +	info->shadow_free = info->shadow[free].req.id;
> +	info->shadow[free].req.id = 0x0fffffee; /* debug */
> +	return free;
> +}
> +
> +static inline void ADD_ID_TO_FREELIST(
> +	struct blkfront_info *info, unsigned long id)
> +{
> +	info->shadow[id].req.id  = info->shadow_free;
> +	info->shadow[id].request = 0;
> +	info->shadow_free = id;
> +}

Please give these proper lowercased names, and while you're at it
please kill all the inline statements you have and let the compiler
do it's work.


> +static irqreturn_t blkif_int(int irq, void *dev_id)

Please call interrupt handlers foo_interrupt, that makes peopl see what's
going on much more easily.

> +static void blkif_recover(struct blkfront_info *info)
> +{
> +	int i;
> +	struct blkif_request *req;
> +	struct blk_shadow *copy;
> +	int j;
> +
> +	/* Stage 1: Make a safe copy of the shadow state. */
> +	copy = kmalloc(sizeof(info->shadow), GFP_KERNEL | __GFP_NOFAIL);

Please don't use __GFP_NOFAIL in any new code.

> +/* ** Driver Registration ** */

No one would have guesses without that comments..

> +extern int blkif_ioctl(struct inode *inode, struct file *filep,
> +		       unsigned command, unsigned long argument);

doesn't actually exist anywhere.

> +extern int blkif_check(dev_t dev);

ditto

> +extern int blkif_revalidate(dev_t dev);

ditto.

> +/******************************************************************************

Just kill these *, okay?

> + * vbd.c

Please don't put filenames in the top of file comments, they'll get out
of date far too soon while serving no purpose at all.

> +#define BLKIF_MAJOR(dev) ((dev)>>8)
> +#define BLKIF_MINOR(dev) ((dev) & 0xff)

Please make these proper xenblk-prefixed inlines in lower case.

> +
> +static struct xlbd_type_info xvd_type_info = {
> +	.partn_shift = 4,
> +	.disks_per_major = 16,
> +	.devname = "xvd",
> +	.diskname = "xvd"
> +};
> +
> +static struct xlbd_major_info xvd_major_info = {
> +	.major = XENVBD_MAJOR,
> +	.type = &xvd_type_info
> +};

The structures seem quite useless and the code would be much
cleaner without them.  What's the reason for their existance?

> +
> +/* Information about our VBDs. */
> +#define MAX_VBDS 64
> +static LIST_HEAD(vbds_list);
> +
> +static struct block_device_operations xlvbd_block_fops =
> +{
> +	.owner = THIS_MODULE,
> +	.open = blkif_open,
> +	.release = blkif_release,
> +	.getgeo = blkif_getgeo
> +};
> +
> +DEFINE_SPINLOCK(blkif_io_lock);
> +
> +int
> +xlvbd_alloc_major(void)
> +{
> +	if (register_blkdev(xvd_major_info.major,
> +			    xvd_major_info.type->devname)) {
> +		printk(KERN_WARNING "xen_blk: can't get major %d with name %s\n",
> +		       xvd_major_info.major, xvd_major_info.type->devname);
> +		return -1;
> +	}
> +	return 0;
> +}

Useless wrapper, please just kill it.

> +
> +static int
> +xlvbd_init_blk_queue(struct gendisk *gd, u16 sector_size)
> +{
> +	request_queue_t *rq;
> +
> +	rq = blk_init_queue(do_blkif_request, &blkif_io_lock);
> +	if (rq == NULL)
> +		return -1;
> +
> +	elevator_init(rq, "noop");
> +
> +	/* Hard sector size and max sectors impersonate the equiv. hardware. */
> +	blk_queue_hardsect_size(rq, sector_size);
> +	blk_queue_max_sectors(rq, 512);
> +
> +	/* Each segment in a request is up to an aligned page in size. */
> +	blk_queue_segment_boundary(rq, PAGE_SIZE - 1);
> +	blk_queue_max_segment_size(rq, PAGE_SIZE);
> +
> +	/* Ensure a merged request will fit in a single I/O ring slot. */
> +	blk_queue_max_phys_segments(rq, BLKIF_MAX_SEGMENTS_PER_REQUEST);
> +	blk_queue_max_hw_segments(rq, BLKIF_MAX_SEGMENTS_PER_REQUEST);
> +
> +	/* Make sure buffer addresses are sector-aligned. */
> +	blk_queue_dma_alignment(rq, 511);
> +
> +	gd->queue = rq;
> +
> +	return 0;

Useless wrapper, please just kill it.

> +static int
> +xlvbd_alloc_gendisk(int minor, blkif_sector_t capacity, int vdevice,
> +		    u16 vdisk_info, u16 sector_size,
> +		    struct blkfront_info *info)
> +{
> +	struct gendisk *gd;
> +	struct xlbd_major_info *mi;
> +	int nr_minors = 1;
> +	int err = -ENODEV;
> +
> +	BUG_ON(info->gd != NULL);
> +	BUG_ON(info->mi != NULL);
> +	BUG_ON(info->rq != NULL);
> +
> +	mi = &xvd_major_info;
> +	info->mi = mi;
> +
> +	if ((minor & ((1 << mi->type->partn_shift) - 1)) == 0)
> +		nr_minors = 1 << mi->type->partn_shift;
> +
> +	gd = alloc_disk(nr_minors);
> +	if (gd == NULL)
> +		goto out;
> +
> +	if (nr_minors > 1)
> +		sprintf(gd->disk_name, "%s%c", mi->type->diskname,
> +			'a' + mi->index * mi->type->disks_per_major +
> +			(minor >> mi->type->partn_shift));
> +	else
> +		sprintf(gd->disk_name, "%s%c%d", mi->type->diskname,
> +			'a' + mi->index * mi->type->disks_per_major +
> +			(minor >> mi->type->partn_shift),
> +			minor & ((1 << mi->type->partn_shift) - 1));
> +
> +	gd->major = mi->major;
> +	gd->first_minor = minor;
> +	gd->fops = &xlvbd_block_fops;
> +	gd->private_data = info;
> +	gd->driverfs_dev = &(info->xbdev->dev);
> +	set_capacity(gd, capacity);
> +
> +	if (xlvbd_init_blk_queue(gd, sector_size)) {
> +		del_gendisk(gd);
> +		goto out;
> +	}
> +
> +	info->rq = gd->queue;
> +	info->gd = gd;
> +
> +	if (info->feature_barrier)
> +		xlvbd_barrier(info);
> +
> +	if (vdisk_info & VDISK_READONLY)
> +		set_disk_ro(gd, 1);
> +
> +	if (vdisk_info & VDISK_REMOVABLE)
> +		gd->flags |= GENHD_FL_REMOVABLE;
> +
> +	if (vdisk_info & VDISK_CDROM)
> +		gd->flags |= GENHD_FL_CD;
> +
> +	return 0;
> +
> + out:
> +	info->mi = NULL;
> +	return err;
> +}
> +
> +int
> +xlvbd_add(blkif_sector_t capacity, int vdevice, u16 vdisk_info,
> +	  u16 sector_size, struct blkfront_info *info)
> +{
> +	struct block_device *bd;
> +	int err = 0;
> +
> +	info->dev = MKDEV(BLKIF_MAJOR(vdevice), BLKIF_MINOR(vdevice));
> +
> +	bd = bdget(info->dev);
> +	if (bd == NULL)
> +		return -ENODEV;
> +
> +	err = xlvbd_alloc_gendisk(BLKIF_MINOR(vdevice), capacity, vdevice,
> +				  vdisk_info, sector_size, info);
> +
> +	bdput(bd);
> +	return err;
> +}

Please just inline this in the caller, and get rid of the bdget mess.

> +void
> +xlvbd_del(struct blkfront_info *info)
> +{
> +	if (info->mi == NULL)
> +		return;
> +
> +	BUG_ON(info->gd == NULL);
> +	del_gendisk(info->gd);
> +	put_disk(info->gd);
> +	info->gd = NULL;
> +
> +	info->mi = NULL;
> +
> +	BUG_ON(info->rq == NULL);
> +	blk_cleanup_queue(info->rq);
> +	info->rq = NULL;
> +}

Note that the del_gendisk should happen before actual
cleanup happens on the device, so this function should
go away and the only caller should do things in the proper order.

> +int
> +xlvbd_barrier(struct blkfront_info *info)
> +{
> +	int err;
> +
> +	err = blk_queue_ordered(info->rq,
> +		info->feature_barrier ? QUEUE_ORDERED_DRAIN : QUEUE_ORDERED_NONE, NULL);
> +	if (err)
> +		return err;
> +	printk("blkfront: %s: barriers %s\n",
> +	       info->gd->disk_name, info->feature_barrier ? "enabled" : "disabled");
> +	return 0;
> +}
i
Please kill this rather useless wrapper.
