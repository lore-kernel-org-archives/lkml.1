Return-Path: <linux-kernel-owner+w=401wt.eu-S1760990AbZJIOba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760990AbZJIOba (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 10:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760947AbZJIOba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 10:31:30 -0400
Received: from ns1.co-raid.com ([12.51.113.4]:59250 "EHLO coraid.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756503AbZJIOb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 10:31:28 -0400
Message-ID: <ba76320f57aaf97ed261398460178284@coraid.com>
Date: Fri, 9 Oct 2009 10:30:35 -0400
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>, Ed Cashin <ecashin@coraid.com>
From: Ed Cashin <ecashin@coraid.com>
Subject: [RFC] aoe: add barrier support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows the aoe driver to support barrier bios by draining
the current set of outstanding AoE commands and then issuing an ATA
flush command.  If the barrier contains I/O, that I/O is then
performed, followed by a final ATA flush command.

This aoe driver differs from most block device drivers in that it does
not handle I/O requests but handles bios, providing a make_request_fn
to the block layer.

The implementation makes the make_request_fn sleep to wait for any
in-progress barrier to finish, and it sleeps waiting for the ATA flush
to complete.  I expect the process using make_request_fn to be
something like "cp", in which case sleeping will not interfere with
the performance characteristics of any unrelated aoe devices in the
system.  That hasn't been tested yet, though, and I'm concerned that
putting pdflush to sleep could interfere with dirty data flushing on
other aoe devices.  Any comments about this issue would be
appreciated.

Some debugging code remains in this patch for testing purposes, marked
with "XXXdebug".  This code allows barrier handling to be turned off
and on and to be traced.  Turning barrier support on and off is only
supported on module load.  This testing feature will not be a part of
the final barrier support for aoe.

Jens Axboe suggests that code that we know can sleep should use
spin_lock_irq instead of spin_lock_irqsave.  Even though the latter is
harmless, it also adds no value.  This patch sneaks a few such lock
changes in.  Please comment if you think the change from
spin_lock_irqsave to spin_lock_irq should be split out of the final
version of this patch.
---
 drivers/block/aoe/aoe.h    |    8 ++-
 drivers/block/aoe/aoeblk.c |  122 ++++++++++++++++++++++++++++++++++++----
 drivers/block/aoe/aoecmd.c |  133 +++++++++++++++++++++++++++++++++++++++-----
 drivers/block/aoe/aoedev.c |    5 +-
 4 files changed, 240 insertions(+), 28 deletions(-)

diff --git a/drivers/block/aoe/aoe.h b/drivers/block/aoe/aoe.h
index db195ab..40058c0 100644
--- a/drivers/block/aoe/aoe.h
+++ b/drivers/block/aoe/aoe.h
@@ -79,6 +79,7 @@ enum {
 	DEVFL_GDALLOC = (1<<4),	/* need to alloc gendisk */
 	DEVFL_KICKME = (1<<5),	/* slow polling network card catch */
 	DEVFL_NEWSIZE = (1<<6),	/* need to update dev size in block layer */
+	DEVFL_BARFAIL = (1<<7), /* barrier failed */
 
 	BUFFL_FAIL = 1,
 };
@@ -107,8 +108,8 @@ struct buf {
 	ulong bv_resid;
 	ulong bv_off;
 	sector_t sector;
-	struct bio *bio;
-	struct bio_vec *bv;
+	struct bio *bio;	/* NULL for ATA flush */
+	struct bio_vec *bv;	/* points to completion when bio is NULL */
 };
 
 struct frame {
@@ -168,6 +169,7 @@ struct aoedev {
 	struct aoetgt *targets[NTARGETS];
 	struct aoetgt **tgt;	/* target in use when working */
 	struct aoetgt **htgt;	/* target needing rexmit assistance */
+	struct bio *barrier;
 };
 
 
@@ -175,6 +177,7 @@ int aoeblk_init(void);
 void aoeblk_exit(void);
 void aoeblk_gdalloc(void *);
 void aoedisk_rm_sysfs(struct aoedev *d);
+void aoeblk_drain_check(struct aoedev *d);
 
 int aoechr_init(void);
 void aoechr_exit(void);
@@ -187,6 +190,7 @@ void aoecmd_cfg_rsp(struct sk_buff *);
 void aoecmd_sleepwork(struct work_struct *);
 void aoecmd_cleanslate(struct aoedev *);
 struct sk_buff *aoecmd_ata_id(struct aoedev *);
+void aoecmd_ata_flush(struct aoedev *d, struct completion *work);
 
 int aoedev_init(void);
 void aoedev_exit(void);
diff --git a/drivers/block/aoe/aoeblk.c b/drivers/block/aoe/aoeblk.c
index 3af97d4..00639ae 100644
--- a/drivers/block/aoe/aoeblk.c
+++ b/drivers/block/aoe/aoeblk.c
@@ -13,7 +13,13 @@
 #include <linux/netdevice.h>
 #include "aoe.h"
 
+static int aoe_barrier = 1;	/* XXXdebug */
+module_param(aoe_barrier, int, 0644);
+MODULE_PARM_DESC(aoe_barrier, "Support barriers in aoe.");
+
 static struct kmem_cache *buf_pool_cache;
+static DECLARE_WAIT_QUEUE_HEAD(barrier_wq);
+static DECLARE_WAIT_QUEUE_HEAD(drain_wq);
 
 static ssize_t aoedisk_show_state(struct device *dev,
 				  struct device_attribute *attr, char *page)
@@ -151,13 +157,73 @@ aoeblk_release(struct gendisk *disk, fmode_t mode)
 	return 0;
 }
 
+void
+clear_old_barrier(struct aoedev *d, struct bio *bio)
+{
+	for (;;) {
+		wait_event(barrier_wq, !d->barrier);
+		spin_lock_irq(&d->lock);
+		if (!d->barrier) {
+			d->barrier = bio_barrier(bio) ? bio : NULL;
+			break;
+		}
+		spin_unlock_irq(&d->lock);
+	}
+	spin_unlock_irq(&d->lock);
+	return;
+}
+
+static int
+__is_drained(struct aoedev *d)
+{
+	int i;
+
+	if (d->inprocess || !list_empty(&d->bufq))
+		return 0;
+	for (i = 0; i < NTARGETS && d->targets[i]; ++i)
+		if (d->targets[i]->nout)
+			return 0;
+	return 1;
+}
+
+static int
+is_drained(struct aoedev *d)
+{
+	int ret;
+
+	spin_lock_irq(&d->lock);
+	ret = __is_drained(d);
+	spin_unlock_irq(&d->lock);
+	return ret;
+}
+
+/* caller holds d->lock */
+void
+aoeblk_drain_check(struct aoedev *d)
+{
+	if (__is_drained(d))
+		wake_up(&drain_wq);
+}
+
+static int
+flush_failed(struct aoedev *d, struct bio *bio)
+{
+	int fail;
+	spin_lock_irq(&d->lock);
+	fail = d->flags & DEVFL_BARFAIL;
+	d->flags &= ~DEVFL_BARFAIL;
+	spin_unlock_irq(&d->lock);
+	return fail;
+}
+
 static int
 aoeblk_make_request(struct request_queue *q, struct bio *bio)
 {
 	struct sk_buff_head queue;
 	struct aoedev *d;
 	struct buf *buf;
-	ulong flags;
+	int err = 0;
+	DECLARE_COMPLETION_ONSTACK(wait);
 
 	blk_queue_bounce(q, &bio);
 
@@ -175,17 +241,32 @@ aoeblk_make_request(struct request_queue *q, struct bio *bio)
 	} else if (bio_rw_flagged(bio, BIO_RW_BARRIER)) {
 		bio_endio(bio, -EOPNOTSUPP);
 		return 0;
+	}
+	if (!aoe_barrier && bio_barrier(bio)) {
+		bio_endio(bio, -EOPNOTSUPP);
+		return 0;
+	}
+	clear_old_barrier(d, bio);
+	if (bio_barrier(bio)) {
+		wait_event(drain_wq, is_drained(d));
+		aoecmd_ata_flush(d, &wait);
+		wait_for_completion(&wait);
+		if (flush_failed(d, bio)) {
+			err = -EIO;
+			goto endbio;
+		} else if (bio->bi_size == 0)
+			goto endbio;
 	} else if (bio->bi_io_vec == NULL) {
 		printk(KERN_ERR "aoe: bi_io_vec is NULL\n");
 		BUG();
-		bio_endio(bio, -ENXIO);
-		return 0;
+		err = -ENXIO;
+		goto endbio;
 	}
 	buf = mempool_alloc(d->bufpool, GFP_NOIO);
 	if (buf == NULL) {
 		printk(KERN_INFO "aoe: buf allocation failure\n");
-		bio_endio(bio, -ENOMEM);
-		return 0;
+		err = -ENOMEM;
+		goto endbio;
 	}
 	memset(buf, 0, sizeof(*buf));
 	INIT_LIST_HEAD(&buf->bufs);
@@ -198,15 +279,15 @@ aoeblk_make_request(struct request_queue *q, struct bio *bio)
 	WARN_ON(buf->bv_resid == 0);
 	buf->bv_off = buf->bv->bv_offset;
 
-	spin_lock_irqsave(&d->lock, flags);
+	spin_lock_irq(&d->lock);
 
 	if ((d->flags & DEVFL_UP) == 0) {
 		printk(KERN_INFO "aoe: device %ld.%d is not up\n",
 			d->aoemajor, d->aoeminor);
-		spin_unlock_irqrestore(&d->lock, flags);
+		spin_unlock_irq(&d->lock);
 		mempool_free(buf, d->bufpool);
-		bio_endio(bio, -ENXIO);
-		return 0;
+		err = -ENXIO;
+		goto endbio;
 	}
 
 	list_add_tail(&buf->bufs, &d->bufq);
@@ -215,10 +296,29 @@ aoeblk_make_request(struct request_queue *q, struct bio *bio)
 	__skb_queue_head_init(&queue);
 	skb_queue_splice_init(&d->sendq, &queue);
 
-	spin_unlock_irqrestore(&d->lock, flags);
-	aoenet_xmit(&queue);
+	spin_unlock_irq(&d->lock);
+	aoenet_xmit(&queue);	/* buf freed on response or downdev */
+	if (d->barrier == bio) {
+		wait_event(drain_wq, is_drained(d));
+		if (flush_failed(d, bio)) {
+			err = -EIO;
+			goto endbio;
+		}
+		aoecmd_ata_flush(d, &wait);
+		wait_for_completion(&wait);
+		if (flush_failed(d, bio))
+			err = -EIO;
+		goto endbio;
+	}
 
 	return 0;
+endbio:
+	bio_endio(bio, err);
+	if (d->barrier == bio) {
+		d->barrier = NULL;
+		wake_up_all(&barrier_wq);
+	}
+	return 0;
 }
 
 static int
diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index 965ece2..e0118bc 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -11,10 +11,15 @@
 #include <linux/netdevice.h>
 #include <linux/genhd.h>
 #include <linux/moduleparam.h>
+#include <linux/wait.h>
 #include <net/net_namespace.h>
 #include <asm/unaligned.h>
 #include "aoe.h"
 
+static int aoe_btrace;	/* XXXdebug */
+module_param(aoe_btrace, int, 0644);
+MODULE_PARM_DESC(aoe_btrace, "Trace barriers in aoe.");
+
 static int aoe_deadsecs = 60 * 3;
 module_param(aoe_deadsecs, int, 0644);
 MODULE_PARM_DESC(aoe_deadsecs, "After aoe_deadsecs seconds, give up and fail dev.");
@@ -200,13 +205,13 @@ gotone:				skb_shinfo(skb)->nr_frags = skb->data_len = 0;
 }
 
 static int
-aoecmd_ata_rw(struct aoedev *d)
+aoecmd_ata(struct aoedev *d)
 {
 	struct frame *f;
 	struct aoe_hdr *h;
 	struct aoe_atahdr *ah;
 	struct buf *buf;
-	struct bio_vec *bv;
+	struct bio_vec *bv = NULL;
 	struct aoetgt *t;
 	struct sk_buff *skb;
 	ulong bcnt;
@@ -220,7 +225,8 @@ aoecmd_ata_rw(struct aoedev *d)
 		return 0;
 	t = *d->tgt;
 	buf = d->inprocess;
-	bv = buf->bv;
+	if (buf->bio)
+		bv = buf->bv;
 	bcnt = t->ifp->maxbcnt;
 	if (bcnt == 0)
 		bcnt = DEFAULTBCNT;
@@ -236,7 +242,10 @@ aoecmd_ata_rw(struct aoedev *d)
 	t->nout++;
 	f->waited = 0;
 	f->buf = buf;
-	f->bufaddr = page_address(bv->bv_page) + buf->bv_off;
+	if (buf->bio)
+		f->bufaddr = page_address(bv->bv_page) + buf->bv_off;
+	else
+		f->bufaddr = NULL;
 	f->bcnt = bcnt;
 	f->lba = buf->sector;
 
@@ -250,7 +259,7 @@ aoecmd_ata_rw(struct aoedev *d)
 		ah->lba3 &= 0x0f;
 		ah->lba3 |= 0xe0;	/* LBA bit + obsolete 0xa0 */
 	}
-	if (bio_data_dir(buf->bio) == WRITE) {
+	if (buf->bio && bio_data_dir(buf->bio) == WRITE) {
 		skb_fill_page_desc(skb, 0, bv->bv_page, buf->bv_off, bcnt);
 		ah->aflags |= AOEAFL_WRITE;
 		skb->len += bcnt;
@@ -261,7 +270,14 @@ aoecmd_ata_rw(struct aoedev *d)
 		writebit = 0;
 	}
 
-	ah->cmdstat = ATA_CMD_PIO_READ | writebit | extbit;
+	if (buf->bio)
+		ah->cmdstat = ATA_CMD_PIO_READ | writebit | extbit;
+	else {
+		if (ah->aflags & AOEAFL_EXT)
+			ah->cmdstat = ATA_CMD_FLUSH_EXT;
+		else
+			ah->cmdstat = ATA_CMD_FLUSH;
+	}
 
 	/* mark all tracking fields and load out */
 	buf->nframesout += 1;
@@ -577,22 +593,52 @@ rexmit_timer(ulong vp)
 	aoenet_xmit(&queue);
 }
 
+static void			/* XXXdebug */
+barrier_trace(struct aoedev *d)
+{
+	struct bio *bio = d->barrier;
+	int i, nbuf, nout;
+	struct list_head *pos;
+
+	if (!bio)
+		return;
+	if (!aoe_btrace)
+		return;
+
+	nbuf = !!d->inprocess;
+	list_for_each(pos, &d->bufq)
+		nbuf += 1;
+
+	for (i = 0, nout = 0; i < NTARGETS && d->targets[i]; ++i)
+		nout += d->targets[i]->nout;
+
+	printk(KERN_CRIT "e%ld.%ld: nbufs(%d) nout(%d)\n  bio(%p) sector(%16llx) flags(%8lx)",
+	       (long) d->aoemajor, (long) d->aoeminor,
+	       nbuf, nout,
+	       (void *) bio,
+	       (unsigned long long) bio->bi_sector,
+	       bio->bi_flags);
+}
+
 /* enters with d->lock held */
 void
 aoecmd_work(struct aoedev *d)
 {
 	struct buf *buf;
 loop:
+	barrier_trace(d);
 	if (d->htgt && !sthtith(d))
 		return;
 	if (d->inprocess == NULL) {
-		if (list_empty(&d->bufq))
+		if (list_empty(&d->bufq)) {
+			aoeblk_drain_check(d);
 			return;
+		}
 		buf = container_of(d->bufq.next, struct buf, bufs);
 		list_del(d->bufq.next);
 		d->inprocess = buf;
 	}
-	if (aoecmd_ata_rw(d))
+	if (aoecmd_ata(d))
 		goto loop;
 }
 
@@ -842,6 +888,9 @@ aoecmd_ata_rsp(struct sk_buff *skb)
 			}
 			ataid_complete(d, t, (char *) (ahin+1));
 			break;
+		case ATA_CMD_FLUSH:
+		case ATA_CMD_FLUSH_EXT:
+			break;
 		default:
 			printk(KERN_INFO
 				"aoe: unrecognized ata command %2.2Xh for %d.%d\n",
@@ -851,13 +900,22 @@ aoecmd_ata_rsp(struct sk_buff *skb)
 		}
 	}
 
-	if (buf && --buf->nframesout == 0 && buf->resid == 0) {
-		diskstats(d->gd, buf->bio, jiffies - buf->stime, buf->sector);
-		n = (buf->flags & BUFFL_FAIL) ? -EIO : 0;
-		bio_endio(buf->bio, n);
-		mempool_free(buf, d->bufpool);
+	if (buf) {
+		if (buf->flags & BUFFL_FAIL
+		&& (!buf->bio || buf->bio == d->barrier))
+			d->flags |= DEVFL_BARFAIL;
+		if (!buf->bio) {
+			complete((struct completion *) buf->bv);
+			mempool_free(buf, d->bufpool);
+		} else if (--buf->nframesout == 0 && buf->resid == 0) {
+			diskstats(d->gd,
+				buf->bio, jiffies - buf->stime, buf->sector);
+			n = (buf->flags & BUFFL_FAIL) ? -EIO : 0;
+			if (buf->bio != d->barrier)
+				bio_endio(buf->bio, n);
+			mempool_free(buf, d->bufpool);
+		}
 	}
-
 	f->buf = NULL;
 	f->tag = FREETAG;
 	t->nout--;
@@ -1076,3 +1134,50 @@ aoecmd_cleanslate(struct aoedev *d)
 		}
 	}
 }
+
+void
+aoecmd_ata_flush(struct aoedev *d, struct completion *work)
+{
+	struct buf *buf;
+	struct sk_buff_head queue;
+
+	if (aoe_btrace)
+		printk(KERN_CRIT "aoe: aoecmd_ata_flush\n");
+
+	buf = mempool_alloc(d->bufpool, GFP_NOIO);
+	if (buf == NULL) {
+		printk(KERN_INFO "aoe: buf allocation failure\n");
+		goto error;
+	}
+	memset(buf, 0, sizeof(*buf));
+	INIT_LIST_HEAD(&buf->bufs);
+	buf->stime = jiffies;
+	buf->bio = NULL;	/* ATA flush has NULL bio */
+	buf->bv = (struct bio_vec *) work;
+
+	spin_lock_irq(&d->lock);
+	if (!(d->flags & DEVFL_UP)) {
+		spin_unlock_irq(&d->lock);
+		printk(KERN_INFO "aoe: device e%ld.%d is not up\n",
+			d->aoemajor, d->aoeminor);
+		goto error;
+	}
+
+	WARN_ON(!list_empty(&d->bufq));
+	list_add_tail(&buf->bufs, &d->bufq);
+
+	aoecmd_work(d);
+	__skb_queue_head_init(&queue);
+	skb_queue_splice_init(&d->sendq, &queue);
+
+	spin_unlock_irq(&d->lock);
+	aoenet_xmit(&queue);
+	return;
+
+ error:
+	spin_lock_irq(&d->lock);
+	d->flags |= DEVFL_BARFAIL;
+	spin_unlock_irq(&d->lock);
+	mempool_free(buf, d->bufpool);
+	complete(work);
+}
diff --git a/drivers/block/aoe/aoedev.c b/drivers/block/aoe/aoedev.c
index fa67027..ea5d731 100644
--- a/drivers/block/aoe/aoedev.c
+++ b/drivers/block/aoe/aoedev.c
@@ -67,7 +67,10 @@ aoedev_downdev(struct aoedev *d)
 			if (--buf->nframesout == 0
 			&& buf != d->inprocess) {
 				mempool_free(buf, d->bufpool);
-				bio_endio(bio, -EIO);
+				if (bio == d->barrier)
+					d->flags |= DEVFL_BARFAIL;
+				else
+					bio_endio(bio, -EIO);
 			}
 		}
 		(*t)->maxout = (*t)->nframes;
-- 
1.5.6.5

