Return-Path: <linux-kernel-owner+w=401wt.eu-S1763676AbZLQBrJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763676AbZLQBrJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:47:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763270AbZLQBqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:46:19 -0500
Received: from kroah.org ([198.145.64.141]:47814 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763584AbZLQBT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:19:58 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 17:16:00 2009
Message-Id: <20091217011559.935025982@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 17:14:27 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       NeilBrown <neilb@suse.de>
Subject: [16/90] md/bitmap: protect against bitmap removal while being updated.
In-Reply-To: <20091217011835.GA20434@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: NeilBrown <neilb@suse.de>

commit aa5cbd103887011b4830355f88fb055f9ad2d556 upstream.

A write intent bitmap can be removed from an array while the
array is active.
When this happens, all IO is suspended and flushed before the
bitmap is removed.
However it is possible that bitmap_daemon_work is still running to
clear old bits from the bitmap.  If it is, it can dereference the
bitmap after it has been freed.

So introduce a new mutex to protect bitmap_daemon_work and get it
before destroying a bitmap.

This is suitable for any current -stable kernel.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/bitmap.c |   24 ++++++++++++++++++------
 drivers/md/bitmap.h |    2 +-
 drivers/md/md.c     |    3 ++-
 drivers/md/md.h     |    1 +
 4 files changed, 22 insertions(+), 8 deletions(-)

--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -1077,23 +1077,31 @@ static bitmap_counter_t *bitmap_get_coun
  *			out to disk
  */
 
-void bitmap_daemon_work(struct bitmap *bitmap)
+void bitmap_daemon_work(mddev_t *mddev)
 {
+	struct bitmap *bitmap;
 	unsigned long j;
 	unsigned long flags;
 	struct page *page = NULL, *lastpage = NULL;
 	int blocks;
 	void *paddr;
 
-	if (bitmap == NULL)
+	/* Use a mutex to guard daemon_work against
+	 * bitmap_destroy.
+	 */
+	mutex_lock(&mddev->bitmap_mutex);
+	bitmap = mddev->bitmap;
+	if (bitmap == NULL) {
+		mutex_unlock(&mddev->bitmap_mutex);
 		return;
+	}
 	if (time_before(jiffies, bitmap->daemon_lastrun + bitmap->daemon_sleep*HZ))
 		goto done;
 
 	bitmap->daemon_lastrun = jiffies;
 	if (bitmap->allclean) {
 		bitmap->mddev->thread->timeout = MAX_SCHEDULE_TIMEOUT;
-		return;
+		goto done;
 	}
 	bitmap->allclean = 1;
 
@@ -1202,6 +1210,7 @@ void bitmap_daemon_work(struct bitmap *b
  done:
 	if (bitmap->allclean == 0)
 		bitmap->mddev->thread->timeout = bitmap->daemon_sleep * HZ;
+	mutex_unlock(&mddev->bitmap_mutex);
 }
 
 static bitmap_counter_t *bitmap_get_counter(struct bitmap *bitmap,
@@ -1538,9 +1547,9 @@ void bitmap_flush(mddev_t *mddev)
 	 */
 	sleep = bitmap->daemon_sleep;
 	bitmap->daemon_sleep = 0;
-	bitmap_daemon_work(bitmap);
-	bitmap_daemon_work(bitmap);
-	bitmap_daemon_work(bitmap);
+	bitmap_daemon_work(mddev);
+	bitmap_daemon_work(mddev);
+	bitmap_daemon_work(mddev);
 	bitmap->daemon_sleep = sleep;
 	bitmap_update_sb(bitmap);
 }
@@ -1571,6 +1580,7 @@ static void bitmap_free(struct bitmap *b
 	kfree(bp);
 	kfree(bitmap);
 }
+
 void bitmap_destroy(mddev_t *mddev)
 {
 	struct bitmap *bitmap = mddev->bitmap;
@@ -1578,7 +1588,9 @@ void bitmap_destroy(mddev_t *mddev)
 	if (!bitmap) /* there was no bitmap */
 		return;
 
+	mutex_lock(&mddev->bitmap_mutex);
 	mddev->bitmap = NULL; /* disconnect from the md device */
+	mutex_unlock(&mddev->bitmap_mutex);
 	if (mddev->thread)
 		mddev->thread->timeout = MAX_SCHEDULE_TIMEOUT;
 
--- a/drivers/md/bitmap.h
+++ b/drivers/md/bitmap.h
@@ -282,7 +282,7 @@ void bitmap_close_sync(struct bitmap *bi
 void bitmap_cond_end_sync(struct bitmap *bitmap, sector_t sector);
 
 void bitmap_unplug(struct bitmap *bitmap);
-void bitmap_daemon_work(struct bitmap *bitmap);
+void bitmap_daemon_work(mddev_t *mddev);
 #endif
 
 #endif
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -361,6 +361,7 @@ static mddev_t * mddev_find(dev_t unit)
 
 	mutex_init(&new->open_mutex);
 	mutex_init(&new->reconfig_mutex);
+	mutex_init(&new->bitmap_mutex);
 	INIT_LIST_HEAD(&new->disks);
 	INIT_LIST_HEAD(&new->all_mddevs);
 	init_timer(&new->safemode_timer);
@@ -6595,7 +6596,7 @@ void md_check_recovery(mddev_t *mddev)
 
 
 	if (mddev->bitmap)
-		bitmap_daemon_work(mddev->bitmap);
+		bitmap_daemon_work(mddev);
 
 	if (mddev->ro)
 		return;
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -289,6 +289,7 @@ struct mddev_s
 								* hot-adding a bitmap.  It should
 								* eventually be settable by sysfs.
 								*/
+	struct mutex			bitmap_mutex;
 
 	struct list_head		all_mddevs;
 };


