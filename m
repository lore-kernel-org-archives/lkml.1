Return-Path: <linux-kernel-owner+w=401wt.eu-S1161205AbXCAXb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161205AbXCAXb6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 18:31:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161213AbXCAXb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 18:31:58 -0500
Received: from ns1.coraid.com ([65.14.39.133]:31124 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161205AbXCAXb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 18:31:56 -0500
X-Greylist: delayed 959 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Mar 2007 18:31:55 EST
Date: Thu, 1 Mar 2007 18:15:10 -0500
From: "Ed L. Cashin" <ecashin@coraid.com>
To: linux-kernel@vger.kernel.org
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@osdl.org>,
       ecashin@coraid.com
Subject: PATCH 2.6.21-rc1 aoe: handle zero _count pages in bios
Message-ID: <20070301231510.GC8524@coraid.com>
Reply-To: support@coraid.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch works around a problem discussed here and on the XFS
mailing list in January.

  http://lkml.org/lkml/2007/1/19/56

To summarize the issue: If XFS (or any other creator of bios) gives
the aoe driver a bio with pages that have a zero page _count, and then
the aoe driver hands the page to the network layer in an sk_buff's
frags, and if the network card does not support the scatter gather
feature, then the network layer will eventually try to put_page on the
page, and the kernel winds up panicing.

There is a disconnect between the assumptions of the bio creator (that
pages don't need to have a non-zero _count), and the assumptions of
the network layer (where it's assumed that pages will always have a
positive count).  There was no response, though, to a call in January
for ideas about resolving the disconnect.

So to work around the issue, the simple patch below increments the
page _count before handing it to the network layer and decrements it
after the network layer is done with the page.  This patch eliminates
panics for XFS on aoe users who lack scatter gather support in their
network cards.

It's regrettable that _count is manipulated directly, because Andrew
Morton changed the page "count" member to a _count to prevent exactly
this kind of direct manipulation of the data.  There does not appear
to be a "right" way to increment and decrement the count, however,
inside a driver without unwanted side effects.  The closest candidates
are in mm/internal.h and are presumably intended to be used
exclusively by mm/*.c.

Signed-off-by: "Ed L. Cashin" <ecashin@coraid.com>

diff -upr -X linux-2.6.21-rc1.dontdiff linux-2.6.21-rc1.orig/drivers/block/aoe/aoe.h linux-2.6.21-rc1/drivers/block/aoe/aoe.h
--- linux-2.6.21-rc1.orig/drivers/block/aoe/aoe.h	2007-02-27 14:11:06.249132000 -0500
+++ linux-2.6.21-rc1/drivers/block/aoe/aoe.h	2007-02-27 17:43:22.037069000 -0500
@@ -150,6 +150,7 @@ int aoeblk_init(void);
 void aoeblk_exit(void);
 void aoeblk_gdalloc(void *);
 void aoedisk_rm_sysfs(struct aoedev *d);
+void aoe_bio_done(struct bio *bio, unsigned int bytes_done, int error);
 
 int aoechr_init(void);
 void aoechr_exit(void);
diff -upr -X linux-2.6.21-rc1.dontdiff linux-2.6.21-rc1.orig/drivers/block/aoe/aoeblk.c linux-2.6.21-rc1/drivers/block/aoe/aoeblk.c
--- linux-2.6.21-rc1.orig/drivers/block/aoe/aoeblk.c	2007-02-27 14:11:06.253132000 -0500
+++ linux-2.6.21-rc1/drivers/block/aoe/aoeblk.c	2007-02-27 17:43:22.037069000 -0500
@@ -14,6 +14,29 @@
 
 static struct kmem_cache *buf_pool_cache;
 
+/* workaround for XFS and bios with zero pageref pages in general */
+void
+aoe_bio_done(struct bio *bio, unsigned int bytes_done, int error)
+{
+	struct bio_vec *bv;
+	int i;
+
+	bio_for_each_segment(bv, bio, i)
+		atomic_dec(&bv->bv_page->_count);
+
+	bio_endio(bio, bytes_done, error);
+}
+
+static void
+bio_refpages(struct bio *bio)
+{
+	struct bio_vec *bv;
+	int i;
+
+	bio_for_each_segment(bv, bio, i)
+		atomic_inc(&bv->bv_page->_count);
+}
+
 static ssize_t aoedisk_show_state(struct gendisk * disk, char *page)
 {
 	struct aoedev *d = disk->private_data;
@@ -147,6 +170,7 @@ aoeblk_make_request(request_queue_t *q, 
 	buf->bio = bio;
 	buf->resid = bio->bi_size;
 	buf->sector = bio->bi_sector;
+	bio_refpages(bio);
 	buf->bv = &bio->bi_io_vec[bio->bi_idx];
 	WARN_ON(buf->bv->bv_len == 0);
 	buf->bv_resid = buf->bv->bv_len;
@@ -159,7 +183,7 @@ aoeblk_make_request(request_queue_t *q, 
 			d->aoemajor, d->aoeminor);
 		spin_unlock_irqrestore(&d->lock, flags);
 		mempool_free(buf, d->bufpool);
-		bio_endio(bio, bio->bi_size, -ENXIO);
+		aoe_bio_done(bio, bio->bi_size, -ENXIO);
 		return 0;
 	}
 
diff -upr -X linux-2.6.21-rc1.dontdiff linux-2.6.21-rc1.orig/drivers/block/aoe/aoecmd.c linux-2.6.21-rc1/drivers/block/aoe/aoecmd.c
--- linux-2.6.21-rc1.orig/drivers/block/aoe/aoecmd.c	2007-02-27 14:11:06.253132000 -0500
+++ linux-2.6.21-rc1/drivers/block/aoe/aoecmd.c	2007-02-27 17:43:22.037069000 -0500
@@ -649,7 +649,7 @@ aoecmd_ata_rsp(struct sk_buff *skb)
 			disk_stat_add(disk, sectors[rw], n_sect);
 			disk_stat_add(disk, io_ticks, duration);
 			n = (buf->flags & BUFFL_FAIL) ? -EIO : 0;
-			bio_endio(buf->bio, buf->bio->bi_size, n);
+			aoe_bio_done(buf->bio, buf->bio->bi_size, n);
 			mempool_free(buf, d->bufpool);
 		}
 	}
diff -upr -X linux-2.6.21-rc1.dontdiff linux-2.6.21-rc1.orig/drivers/block/aoe/aoedev.c linux-2.6.21-rc1/drivers/block/aoe/aoedev.c
--- linux-2.6.21-rc1.orig/drivers/block/aoe/aoedev.c	2007-02-27 14:11:06.253132000 -0500
+++ linux-2.6.21-rc1/drivers/block/aoe/aoedev.c	2007-02-27 17:43:22.041069250 -0500
@@ -119,7 +119,7 @@ aoedev_downdev(struct aoedev *d)
 		bio = buf->bio;
 		if (--buf->nframesout == 0) {
 			mempool_free(buf, d->bufpool);
-			bio_endio(bio, bio->bi_size, -EIO);
+			aoe_bio_done(bio, bio->bi_size, -EIO);
 		}
 		skb_shinfo(f->skb)->nr_frags = f->skb->data_len = 0;
 	}
@@ -130,7 +130,7 @@ aoedev_downdev(struct aoedev *d)
 		list_del(d->bufq.next);
 		bio = buf->bio;
 		mempool_free(buf, d->bufpool);
-		bio_endio(bio, bio->bi_size, -EIO);
+		aoe_bio_done(bio, bio->bi_size, -EIO);
 	}
 
 	if (d->gd)


-- 
  Ed L Cashin <ecashin@coraid.com>
