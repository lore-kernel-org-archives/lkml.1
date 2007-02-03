Return-Path: <linux-kernel-owner+w=401wt.eu-S1946272AbXBCCjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946272AbXBCCjq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 21:39:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946276AbXBCCjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 21:39:46 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:53266 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946272AbXBCCja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 21:39:30 -0500
Message-Id: <20070203024415.110184000@sous-sol.org>
References: <20070203023504.435051000@sous-sol.org>
User-Agent: quilt/0.45-1
Date: Fri, 02 Feb 2007 18:35:45 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       NeilBrown <neilb@suse.de>
Subject: [patch 41/59] md: fix potential memalloc deadlock in md
Content-Disposition: inline; filename=md-fix-potential-memalloc-deadlock-in-md.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
------------------

From: NeilBrown <neilb@suse.de>

If a GFP_KERNEL allocation is attempted in md while the mddev_lock is
held, it is possible for a deadlock to eventuate.
This happens if the array was marked 'clean', and the memalloc triggers 
a write-out to the md device.
For the writeout to succeed, the array must be marked 'dirty', and that 
requires getting the mddev_lock.

So, before attempting a GFP_KERNEL alloction while holding the lock,
make sure the array is marked 'dirty' (unless it is currently read-only).

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/md/md.c         |   29 +++++++++++++++++++++++++++++
 drivers/md/raid1.c      |    2 ++
 drivers/md/raid5.c      |    3 +++
 include/linux/raid/md.h |    2 +-
 4 files changed, 35 insertions(+), 1 deletion(-)

--- linux-2.6.19.2.orig/drivers/md/md.c
+++ linux-2.6.19.2/drivers/md/md.c
@@ -3561,6 +3561,8 @@ static int get_bitmap_file(mddev_t * mdd
 	char *ptr, *buf = NULL;
 	int err = -ENOMEM;
 
+	md_allow_write(mddev);
+
 	file = kmalloc(sizeof(*file), GFP_KERNEL);
 	if (!file)
 		goto out;
@@ -5029,6 +5031,33 @@ void md_write_end(mddev_t *mddev)
 	}
 }
 
+/* md_allow_write(mddev)
+ * Calling this ensures that the array is marked 'active' so that writes
+ * may proceed without blocking.  It is important to call this before
+ * attempting a GFP_KERNEL allocation while holding the mddev lock.
+ * Must be called with mddev_lock held.
+ */
+void md_allow_write(mddev_t *mddev)
+{
+	if (!mddev->pers)
+		return;
+	if (mddev->ro)
+		return;
+
+	spin_lock_irq(&mddev->write_lock);
+	if (mddev->in_sync) {
+		mddev->in_sync = 0;
+		set_bit(MD_CHANGE_CLEAN, &mddev->flags);
+		if (mddev->safemode_delay &&
+		    mddev->safemode == 0)
+			mddev->safemode = 1;
+		spin_unlock_irq(&mddev->write_lock);
+		md_update_sb(mddev, 0);
+	} else
+		spin_unlock_irq(&mddev->write_lock);
+}
+EXPORT_SYMBOL_GPL(md_allow_write);
+
 static DECLARE_WAIT_QUEUE_HEAD(resync_wait);
 
 #define SYNC_MARKS	10
--- linux-2.6.19.2.orig/drivers/md/raid1.c
+++ linux-2.6.19.2/drivers/md/raid1.c
@@ -2104,6 +2104,8 @@ static int raid1_reshape(mddev_t *mddev)
 		return -EINVAL;
 	}
 
+	md_allow_write(mddev);
+
 	raid_disks = mddev->raid_disks + mddev->delta_disks;
 
 	if (raid_disks < conf->raid_disks) {
--- linux-2.6.19.2.orig/drivers/md/raid5.c
+++ linux-2.6.19.2/drivers/md/raid5.c
@@ -403,6 +403,8 @@ static int resize_stripes(raid5_conf_t *
 	if (newsize <= conf->pool_size)
 		return 0; /* never bother to shrink */
 
+	md_allow_write(conf->mddev);
+
 	/* Step 1 */
 	sc = kmem_cache_create(conf->cache_name[1-conf->active_name],
 			       sizeof(struct stripe_head)+(newsize-1)*sizeof(struct r5dev),
@@ -3045,6 +3047,7 @@ raid5_store_stripe_cache_size(mddev_t *m
 		else
 			break;
 	}
+	md_allow_write(mddev);
 	while (new > conf->max_nr_stripes) {
 		if (grow_one_stripe(conf))
 			conf->max_nr_stripes++;
--- linux-2.6.19.2.orig/include/linux/raid/md.h
+++ linux-2.6.19.2/include/linux/raid/md.h
@@ -94,7 +94,7 @@ extern int sync_page_io(struct block_dev
 			struct page *page, int rw);
 extern void md_do_sync(mddev_t *mddev);
 extern void md_new_event(mddev_t *mddev);
-
+extern void md_allow_write(mddev_t *mddev);
 
 #endif /* CONFIG_MD */
 #endif 

--
