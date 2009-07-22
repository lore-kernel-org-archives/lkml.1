Return-Path: <linux-kernel-owner+w=401wt.eu-S1756551AbZGVF7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551AbZGVF7Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 01:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756300AbZGVF7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 01:59:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:46862 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756254AbZGVF7Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 01:59:24 -0400
Message-ID: <4A66AAA5.4080600@kernel.org>
Date: Wed, 22 Jul 2009 14:59:01 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] block fixes for 2.6.31-rc4
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 22 Jul 2009 05:59:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Please consider pulling from the following temp block fixes tree.  It
can be merged into the current #master without any conflict.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git tj-block-for-linus

The tree contains five fixes I've collected since last week.

* Two patches deal with build problems (spurious section mismatch
  warning and unnecessary NULL check).

* Fix z2ram unregistering more minors than it registers.

* Fix incorrect merge test resulting from comparing flag bits directly
  when the boolean result should be compared.  This was introduced by
  recent block layer fix to avoid merging requests of different
  failfast settings and may prevent valid merges.

* /sys/block/*/queue/read_ahead_kb used unsigned long on store but
  used int on show and thus showed overflowed values if the value was
  large enough.  Fix it to use unsigned long.

I'll be unavailable from tomorrow but Jens will be back next week.

Thanks.
---
Julia Lawall (1):
      ataflop: adjust NULL test

Rakib Mullick (1):
      virtio_blk: mark virtio_blk with __refdata to kill spurious section mismat
ch

Tejun Heo (1):
      block: fix failfast merge testing in elv_rq_merge_ok()

Xiaotian Feng (1):
      block: sysfs fix mismatched queue_var_{store,show} in 64bit kernel

Zhaolei (1):
      z2ram: Small cleanup for z2ram.c

 block/blk-sysfs.c          |   11 ++++++-----
 block/elevator.c           |   13 +++++++++----
 drivers/block/ataflop.c    |    2 +-
 drivers/block/virtio_blk.c |    7 ++++++-
 drivers/block/z2ram.c      |    2 +-
 5 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index b1cd040..418d636 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -16,9 +16,9 @@ struct queue_sysfs_entry {
 };

 static ssize_t
-queue_var_show(unsigned int var, char *page)
+queue_var_show(unsigned long var, char *page)
 {
-	return sprintf(page, "%d\n", var);
+	return sprintf(page, "%lu\n", var);
 }

 static ssize_t
@@ -77,7 +77,8 @@ queue_requests_store(struct request_queue *q, const char *page, size_t count)

 static ssize_t queue_ra_show(struct request_queue *q, char *page)
 {
-	int ra_kb = q->backing_dev_info.ra_pages << (PAGE_CACHE_SHIFT - 10);
+	unsigned long ra_kb = q->backing_dev_info.ra_pages <<
+					(PAGE_CACHE_SHIFT - 10);

 	return queue_var_show(ra_kb, (page));
 }
@@ -189,9 +190,9 @@ static ssize_t queue_nomerges_store(struct request_queue *q, const char *page,

 static ssize_t queue_rq_affinity_show(struct request_queue *q, char *page)
 {
-	unsigned int set = test_bit(QUEUE_FLAG_SAME_COMP, &q->queue_flags);
+	bool set = test_bit(QUEUE_FLAG_SAME_COMP, &q->queue_flags);

-	return queue_var_show(set != 0, page);
+	return queue_var_show(set, page);
 }

 static ssize_t
diff --git a/block/elevator.c b/block/elevator.c
index 6f23753..2d511f9 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -101,11 +101,16 @@ int elv_rq_merge_ok(struct request *rq, struct bio *bio)
 		return 0;

 	/*
-	 * Don't merge if failfast settings don't match
+	 * Don't merge if failfast settings don't match.
+	 *
+	 * FIXME: The negation in front of each condition is necessary
+	 * because bio and request flags use different bit positions
+	 * and the accessors return those bits directly.  This
+	 * ugliness will soon go away.
 	 */
-	if (bio_failfast_dev(bio)	!= blk_failfast_dev(rq)		||
-	    bio_failfast_transport(bio)	!= blk_failfast_transport(rq)	||
-	    bio_failfast_driver(bio)	!= blk_failfast_driver(rq))
+	if (!bio_failfast_dev(bio)	 != !blk_failfast_dev(rq)	||
+	    !bio_failfast_transport(bio) != !blk_failfast_transport(rq)	||
+	    !bio_failfast_driver(bio)	 != !blk_failfast_driver(rq))
 		return 0;

 	if (!elv_iosched_allow_merge(rq, bio))
diff --git a/drivers/block/ataflop.c b/drivers/block/ataflop.c
index f5e7180..3ff0294 100644
--- a/drivers/block/ataflop.c
+++ b/drivers/block/ataflop.c
@@ -1627,7 +1627,7 @@ static int fd_ioctl(struct block_device *bdev, fmode_t mode,
 				drive, dtp->blocks, dtp->spt, dtp->stretch);

 		/* sanity check */
-		if (!dtp || setprm.track != dtp->blocks/dtp->spt/2 ||
+		if (setprm.track != dtp->blocks/dtp->spt/2 ||
 		    setprm.head != 2) {
 			redo_fd_request();
 			return -EINVAL;
diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 43db3ea..024f2d2 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -424,7 +424,12 @@ static unsigned int features[] = {
 	VIRTIO_BLK_F_SCSI, VIRTIO_BLK_F_IDENTIFY
 };

-static struct virtio_driver virtio_blk = {
+/*
+ * virtio_blk causes spurious section mismatch warning by
+ * simultaneously referring to a __devinit and a __devexit function.
+ * Use __refdata to avoid this warning.
+ */
+static struct virtio_driver __refdata virtio_blk = {
 	.feature_table = features,
 	.feature_table_size = ARRAY_SIZE(features),
 	.driver.name =	KBUILD_MODNAME,
diff --git a/drivers/block/z2ram.c b/drivers/block/z2ram.c
index 4575171..b259040 100644
--- a/drivers/block/z2ram.c
+++ b/drivers/block/z2ram.c
@@ -374,7 +374,7 @@ err:
 static void __exit z2_exit(void)
 {
     int i, j;
-    blk_unregister_region(MKDEV(Z2RAM_MAJOR, 0), 256);
+    blk_unregister_region(MKDEV(Z2RAM_MAJOR, 0), Z2MINOR_COUNT);
     unregister_blkdev(Z2RAM_MAJOR, DEVICE_NAME);
     del_gendisk(z2ram_gendisk);
     put_disk(z2ram_gendisk);
