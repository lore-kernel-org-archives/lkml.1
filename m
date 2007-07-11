Return-Path: <linux-kernel-owner+w=401wt.eu-S933891AbXGKVDL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933891AbXGKVDL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 17:03:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933171AbXGKVBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 17:01:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33381 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933873AbXGKVBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 17:01:43 -0400
Date: Wed, 11 Jul 2007 22:01:00 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Stefan Bader <shbader@de.ibm.com>
Subject: [2.6.23 PATCH 11/18] dm: disable barriers
Message-ID: <20070711210100.GC24114@agk.fab.redhat.com>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	Stefan Bader <shbader@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 04098903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Bader <shbader@de.ibm.com>

This patch causes device-mapper to reject any barrier requests.  This is done
since most of the targets won't handle this correctly anyway.  So until the
situation improves it is better to reject these requests at the first place.
Since barrier requests won't get to the targets, the checks there can be
removed.

Signed-off-by: Stefan Bader <shbader@de.ibm.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>

---

 drivers/md/dm-crypt.c |    3 ---
 drivers/md/dm-mpath.c |    3 ---
 drivers/md/dm-snap.c  |    6 ------
 drivers/md/dm.c       |    9 +++++++++
 4 files changed, 9 insertions(+), 12 deletions(-)

Index: linux/drivers/md/dm-crypt.c
===================================================================
--- linux.orig/drivers/md/dm-crypt.c	2007-07-11 21:37:38.000000000 +0100
+++ linux/drivers/md/dm-crypt.c	2007-07-11 21:37:47.000000000 +0100
@@ -941,9 +941,6 @@ static int crypt_map(struct dm_target *t
 	struct crypt_config *cc = ti->private;
 	struct dm_crypt_io *io;
 
-	if (bio_barrier(bio))
-		return -EOPNOTSUPP;
-
 	io = mempool_alloc(cc->io_pool, GFP_NOIO);
 	io->target = ti;
 	io->base_bio = bio;
Index: linux/drivers/md/dm-mpath.c
===================================================================
--- linux.orig/drivers/md/dm-mpath.c	2007-07-11 21:37:40.000000000 +0100
+++ linux/drivers/md/dm-mpath.c	2007-07-11 21:37:47.000000000 +0100
@@ -798,9 +798,6 @@ static int multipath_map(struct dm_targe
 	struct dm_mpath_io *mpio;
 	struct multipath *m = (struct multipath *) ti->private;
 
-	if (bio_barrier(bio))
-		return -EOPNOTSUPP;
-
 	mpio = mempool_alloc(m->mpio_pool, GFP_NOIO);
 	dm_bio_record(&mpio->details, bio);
 
Index: linux/drivers/md/dm-snap.c
===================================================================
--- linux.orig/drivers/md/dm-snap.c	2007-07-11 21:37:45.000000000 +0100
+++ linux/drivers/md/dm-snap.c	2007-07-11 21:37:47.000000000 +0100
@@ -889,9 +889,6 @@ static int snapshot_map(struct dm_target
 	if (!s->valid)
 		return -EIO;
 
-	if (unlikely(bio_barrier(bio)))
-		return -EOPNOTSUPP;
-
 	/* FIXME: should only take write lock if we need
 	 * to copy an exception */
 	down_write(&s->lock);
@@ -1162,9 +1159,6 @@ static int origin_map(struct dm_target *
 	struct dm_dev *dev = ti->private;
 	bio->bi_bdev = dev->bdev;
 
-	if (unlikely(bio_barrier(bio)))
-		return -EOPNOTSUPP;
-
 	/* Only tell snapshots if this is a write */
 	return (bio_rw(bio) == WRITE) ? do_origin(dev, bio) : DM_MAPIO_REMAPPED;
 }
Index: linux/drivers/md/dm.c
===================================================================
--- linux.orig/drivers/md/dm.c	2007-07-11 21:37:38.000000000 +0100
+++ linux/drivers/md/dm.c	2007-07-11 21:37:47.000000000 +0100
@@ -800,6 +800,15 @@ static int dm_request(request_queue_t *q
 	int rw = bio_data_dir(bio);
 	struct mapped_device *md = q->queuedata;
 
+	/*
+	 * There is no use in forwarding any barrier request since we can't
+	 * guarantee it is (or can be) handled by the targets correctly.
+	 */
+	if (unlikely(bio_barrier(bio))) {
+		bio_endio(bio, bio->bi_size, -EOPNOTSUPP);
+		return 0;
+	}
+
 	down_read(&md->io_lock);
 
 	disk_stat_inc(dm_disk(md), ios[rw]);
