Return-Path: <linux-kernel-owner+w=401wt.eu-S965995AbXHGV0G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965995AbXHGV0G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:26:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935729AbXHGU4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:56:47 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59927 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935554AbXHGU4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:56:45 -0400
Date: Tue, 7 Aug 2007 13:49:10 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Stefan Bader <shbader@de.ibm.com>,
       Alasdair G Kergon <agk@redhat.com>
Subject: [2.6.22.2 review 73/84] dm: disable barriers
Message-ID: <20070807204910.GW23028@kroah.com>
References: <20070807204034.882009319@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="dm-disable-barriers.patch"
In-Reply-To: <20070807204157.GA23028@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm-crypt.c |    3 ---
 drivers/md/dm-mpath.c |    3 ---
 drivers/md/dm-snap.c  |    6 ------
 drivers/md/dm.c       |    9 +++++++++
 4 files changed, 9 insertions(+), 12 deletions(-)

--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -943,9 +943,6 @@ static int crypt_map(struct dm_target *t
 	struct crypt_config *cc = ti->private;
 	struct crypt_io *io;
 
-	if (bio_barrier(bio))
-		return -EOPNOTSUPP;
-
 	io = mempool_alloc(cc->io_pool, GFP_NOIO);
 	io->target = ti;
 	io->base_bio = bio;
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -798,9 +798,6 @@ static int multipath_map(struct dm_targe
 	struct mpath_io *mpio;
 	struct multipath *m = (struct multipath *) ti->private;
 
-	if (bio_barrier(bio))
-		return -EOPNOTSUPP;
-
 	mpio = mempool_alloc(m->mpio_pool, GFP_NOIO);
 	dm_bio_record(&mpio->details, bio);
 
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -887,9 +887,6 @@ static int snapshot_map(struct dm_target
 	if (!s->valid)
 		return -EIO;
 
-	if (unlikely(bio_barrier(bio)))
-		return -EOPNOTSUPP;
-
 	/* FIXME: should only take write lock if we need
 	 * to copy an exception */
 	down_write(&s->lock);
@@ -1160,9 +1157,6 @@ static int origin_map(struct dm_target *
 	struct dm_dev *dev = (struct dm_dev *) ti->private;
 	bio->bi_bdev = dev->bdev;
 
-	if (unlikely(bio_barrier(bio)))
-		return -EOPNOTSUPP;
-
 	/* Only tell snapshots if this is a write */
 	return (bio_rw(bio) == WRITE) ? do_origin(dev, bio) : DM_MAPIO_REMAPPED;
 }
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -802,6 +802,15 @@ static int dm_request(request_queue_t *q
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

-- 
