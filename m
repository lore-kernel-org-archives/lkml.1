Return-Path: <linux-kernel-owner+w=401wt.eu-S933052AbXBLHKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933052AbXBLHKV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 02:10:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933053AbXBLHKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 02:10:20 -0500
Received: from ozlabs.org ([203.10.76.45]:55425 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933054AbXBLHKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 02:10:17 -0500
Subject: Re: [PATCH 7/8] lguest: trivial guest block driver
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.osdl.org>
In-Reply-To: <20070212053204.GB3999@kernel.dk>
References: <1171251770.10409.23.camel@localhost.localdomain>
	 <1171251894.10409.26.camel@localhost.localdomain>
	 <1171251965.10409.28.camel@localhost.localdomain>
	 <1171252113.10409.30.camel@localhost.localdomain>
	 <1171252219.10409.33.camel@localhost.localdomain>
	 <1171252321.10409.36.camel@localhost.localdomain>
	 <1171252405.10409.39.camel@localhost.localdomain>
	 <1171252474.10409.42.camel@localhost.localdomain>
	 <20070212044339.GJ3685@kernel.dk>
	 <1171258034.10409.54.camel@localhost.localdomain>
	 <20070212053204.GB3999@kernel.dk>
Content-Type: text/plain
Date: Mon, 12 Feb 2007 18:09:27 +1100
Message-Id: <1171264167.10409.62.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-12 at 06:32 +0100, Jens Axboe wrote:
> On Mon, Feb 12 2007, Rusty Russell wrote:
> > On Mon, 2007-02-12 at 05:43 +0100, Jens Axboe wrote:
> > > Here you map the entire request (lets call that segment A..Z), but
> > > end_request() only completes the first chunk of the request. So
> > > elv_next_request() will retrieve the same request again, and you'll then
> > > map B..Z and repeat that transfer. So unless I'm missing some other part
> > > here (just read it over quickly), you are re-doing large parts of a
> > > merged request several times.

virtbench before:
	Time to read from disk (256 kB): 18654562 nsec
After:
	Time to read from disk (256 kB): 8018468 nsec

Thanks Jens!!
Rusty.
PS.  One day I'll buy you a beer and you can explain your nomenclature
theory for the block subsystem 8)

Name: lguest: trivial guest block driver

A simple block driver for lguest (/dev/lgbX).  Only does one request
at once.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r a155959c419f drivers/block/Makefile
--- a/drivers/block/Makefile	Mon Feb 12 14:26:47 2007 +1100
+++ b/drivers/block/Makefile	Mon Feb 12 14:26:47 2007 +1100
@@ -28,4 +28,5 @@ obj-$(CONFIG_VIODASD)		+= viodasd.o
 obj-$(CONFIG_VIODASD)		+= viodasd.o
 obj-$(CONFIG_BLK_DEV_SX8)	+= sx8.o
 obj-$(CONFIG_BLK_DEV_UB)	+= ub.o
+obj-$(CONFIG_LGUEST_GUEST)	+= lguest_blk.o
 
diff -r a155959c419f drivers/block/lguest_blk.c
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/drivers/block/lguest_blk.c	Mon Feb 12 18:07:05 2007 +1100
@@ -0,0 +1,270 @@
+/* A simple block driver for lguest.
+ *
+ * Copyright 2006 Rusty Russell <rusty@rustcorp.com.au> IBM Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+//#define DEBUG
+#include <linux/init.h>
+#include <linux/types.h>
+#include <linux/blkdev.h>
+#include <linux/interrupt.h>
+#include <asm/lguest_device.h>
+
+static char next_block_index = 'a';
+
+struct blockdev
+{
+	spinlock_t lock;
+
+	/* The disk structure for the kernel. */
+	struct gendisk *disk;
+
+	/* The major number for this disk. */
+	int major;
+	int irq;
+
+	unsigned long phys_addr;
+	/* The ioremap'ed block page. */
+	struct lguest_block_page *lb_page;
+
+	/* We only have a single request outstanding at a time. */
+	struct lguest_dma dma;
+	struct request *req;
+};
+
+/* Jens gave me this nice helper to end all chunks of a request. */
+static void end_entire_request(struct request *req, int uptodate)
+{
+	if (end_that_request_first(req, uptodate, req->hard_nr_sectors))
+		BUG();
+	add_disk_randomness(req->rq_disk);
+	blkdev_dequeue_request(req);
+	end_that_request_last(req, uptodate);
+}
+
+static irqreturn_t lgb_irq(int irq, void *_bd)
+{
+	struct blockdev *bd = _bd;
+	unsigned long flags;
+
+	if (!bd->req) {
+		pr_debug("No work!\n");
+		return IRQ_NONE;
+	}
+
+	if (!bd->lb_page->result) {
+		pr_debug("No result!\n");
+		return IRQ_NONE;
+	}
+
+	spin_lock_irqsave(&bd->lock, flags);
+	end_entire_request(bd->req, bd->lb_page->result == 1);
+	bd->req = NULL;
+	bd->dma.used_len = 0;
+	blk_start_queue(bd->disk->queue);
+	spin_unlock_irqrestore(&bd->lock, flags);
+	return IRQ_HANDLED;
+}
+
+static unsigned int req_to_dma(struct request *req, struct lguest_dma *dma)
+{
+	unsigned int i = 0, idx, len = 0;
+	struct bio *bio;
+
+	rq_for_each_bio(bio, req) {
+		struct bio_vec *bvec;
+		bio_for_each_segment(bvec, bio, idx) {
+			BUG_ON(i == LGUEST_MAX_DMA_SECTIONS);
+			BUG_ON(!bvec->bv_len);
+			dma->addr[i] = page_to_phys(bvec->bv_page)
+				+ bvec->bv_offset;
+			dma->len[i] = bvec->bv_len;
+			len += bvec->bv_len;
+			i++;
+		}
+	}
+	if (i < LGUEST_MAX_DMA_SECTIONS)
+		dma->len[i] = 0;
+	return len;
+}
+
+static void empty_dma(struct lguest_dma *dma)
+{
+	dma->len[0] = 0;
+}
+
+static void setup_req(struct blockdev *bd,
+		      int type, struct request *req, struct lguest_dma *dma)
+{
+	bd->lb_page->type = type;
+	bd->lb_page->sector = req->sector;
+	bd->lb_page->result = 0;
+	bd->req = req;
+	bd->lb_page->bytes = req_to_dma(req, dma);
+}
+
+static int do_write(struct blockdev *bd, struct request *req)
+{
+	struct lguest_dma send;
+
+	pr_debug("lgb: WRITE sector %li\n", (long)req->sector);
+	setup_req(bd, 1, req, &send);
+
+	hcall(LHCALL_SEND_DMA, bd->phys_addr, __pa(&send), 0);
+	return 1;
+}
+
+static int do_read(struct blockdev *bd, struct request *req)
+{
+	struct lguest_dma ping;
+
+	pr_debug("lgb: READ sector %li\n", (long)req->sector);
+	setup_req(bd, 0, req, &bd->dma);
+
+	empty_dma(&ping);
+	hcall(LHCALL_SEND_DMA,bd->phys_addr,__pa(&ping),0);
+	return 1;
+}
+
+static void do_lgb_request(request_queue_t *q)
+{
+	struct blockdev *bd;
+	struct request *req;
+	int ok;
+
+again:
+	req = elv_next_request(q);
+	if (!req)
+		return;
+
+	bd = req->rq_disk->private_data;
+	/* Sometimes we get repeated requests after blk_stop_queue. */
+	if (bd->req)
+		return;
+
+	if (!blk_fs_request(req)) {
+		pr_debug("Got non-command 0x%08x\n", req->cmd_type);
+	error:
+		req->errors++;
+		end_entire_request(req, 0);
+		goto again;
+	} else {
+		if (rq_data_dir(req) == WRITE)
+			ok = do_write(req->rq_disk->private_data, req);
+		else
+			ok = do_read(req->rq_disk->private_data, req);
+
+		if (!ok)
+			goto error;
+		/* Wait for interrupt to tell us it's done. */
+		blk_stop_queue(q);
+	}
+}
+
+static struct block_device_operations lguestblk_fops = {
+	.owner = THIS_MODULE,
+};
+
+static int lguestblk_probe(struct lguest_device *lhdev)
+{
+	struct blockdev *bd;
+	int err;
+	int irqflags = IRQF_SHARED;
+
+	bd = kmalloc(sizeof(*bd), GFP_KERNEL);
+	if (!bd)
+		return -ENOMEM;
+
+	spin_lock_init(&bd->lock);
+	bd->phys_addr = (lguest_devices[lhdev->index].pfn << PAGE_SHIFT);
+
+	bd->disk = alloc_disk(1);
+	if (!bd->disk) {
+		err = -ENOMEM;
+		goto out_free_bd;
+	}
+
+	bd->disk->queue = blk_init_queue(do_lgb_request, &bd->lock);
+	if (!bd->disk->queue) {
+		err = -ENOMEM;
+		goto out_put;
+	}
+
+	/* We can only handle a certain number of sg entries */
+	blk_queue_max_hw_segments(bd->disk->queue, LGUEST_MAX_DMA_SECTIONS);
+	/* Buffers must not cross page boundaries */
+	blk_queue_segment_boundary(bd->disk->queue, PAGE_SIZE-1);
+
+	bd->irq = lhdev->index+1;
+	bd->major = register_blkdev(0, "lguestblk");
+	if (bd->major < 0) {
+		err = bd->major;
+		goto out_cleanup_queue;
+	}
+	bd->lb_page = (void *)ioremap(bd->phys_addr, PAGE_SIZE);
+	bd->req = NULL;
+
+	sprintf(bd->disk->disk_name, "lgb%c", next_block_index++);
+	if (lguest_devices[lhdev->index].features & LGUEST_DEVICE_F_RANDOMNESS)
+		irqflags |= IRQF_SAMPLE_RANDOM;
+	err = request_irq(bd->irq, lgb_irq, irqflags, bd->disk->disk_name, bd);
+	if (err)
+		goto out_unmap;
+
+	bd->dma.used_len = 0;
+	bd->dma.len[0] = 0;
+	hcall(LHCALL_BIND_DMA, bd->phys_addr, __pa(&bd->dma), (1<<8)+bd->irq);
+
+	printk(KERN_INFO "%s: device %i at major %d\n",
+	       bd->disk->disk_name, lhdev->index, bd->major);
+
+	bd->disk->major = bd->major;
+	bd->disk->first_minor = 0;
+	bd->disk->private_data = bd;
+	bd->disk->fops = &lguestblk_fops;
+	/* This is initialized to the disk size by the other end. */
+	set_capacity(bd->disk, bd->lb_page->num_sectors);
+	add_disk(bd->disk);
+
+	lhdev->private = bd;
+	return 0;
+
+out_unmap:
+	iounmap(bd->lb_page);
+out_cleanup_queue:
+	blk_cleanup_queue(bd->disk->queue);
+out_put:
+	put_disk(bd->disk);
+out_free_bd:
+	kfree(bd);
+	return err;
+}
+
+static struct lguest_driver lguestblk_drv = {
+	.name = "lguestblk",
+	.owner = THIS_MODULE,
+	.device_type = LGUEST_DEVICE_T_BLOCK,
+	.probe = lguestblk_probe,
+};
+
+static __init int lguestblk_init(void)
+{
+	return register_lguest_driver(&lguestblk_drv);
+}
+module_init(lguestblk_init);
+
+MODULE_DESCRIPTION("Lguest block driver");
+MODULE_LICENSE("GPL");




