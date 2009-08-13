Return-Path: <linux-kernel-owner+w=401wt.eu-S932213AbZHMT7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213AbZHMT7u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 15:59:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932216AbZHMT7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 15:59:48 -0400
Received: from kroah.org ([198.145.64.141]:41829 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932211AbZHMT7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:59:47 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:51:30 2009
Message-Id: <20090813195130.818923467@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:50:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dan Williams <dan.j.williams@intel.com>, NeilBrown <neilb@suse.de>
Subject: [patch 42/74] md/raid6: release spare page at ->stop()
References: <20090813194935.985368088@mini.kroah.org>
Content-Disposition: inline; filename=md-raid6-release-spare-page-at-stop.patch
In-Reply-To: <20090813195705.GA22393@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Williams <dan.j.williams@intel.com>

commit 95fc17aac45300f45968aacd97a536ddd8db8101 upstream.

Add missing call to safe_put_page from stop() by unifying open coded
raid5_conf_t de-allocation under free_conf().

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/raid5.c |   26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4310,6 +4310,15 @@ raid5_size(mddev_t *mddev, sector_t sect
 	return sectors * (raid_disks - conf->max_degraded);
 }
 
+static void free_conf(raid5_conf_t *conf)
+{
+	shrink_stripes(conf);
+	safe_put_page(conf->spare_page);
+	kfree(conf->disks);
+	kfree(conf->stripe_hashtbl);
+	kfree(conf);
+}
+
 static raid5_conf_t *setup_conf(mddev_t *mddev)
 {
 	raid5_conf_t *conf;
@@ -4439,11 +4448,7 @@ static raid5_conf_t *setup_conf(mddev_t 
 
  abort:
 	if (conf) {
-		shrink_stripes(conf);
-		safe_put_page(conf->spare_page);
-		kfree(conf->disks);
-		kfree(conf->stripe_hashtbl);
-		kfree(conf);
+		free_conf(conf);
 		return ERR_PTR(-EIO);
 	} else
 		return ERR_PTR(-ENOMEM);
@@ -4609,12 +4614,8 @@ abort:
 	md_unregister_thread(mddev->thread);
 	mddev->thread = NULL;
 	if (conf) {
-		shrink_stripes(conf);
 		print_raid5_conf(conf);
-		safe_put_page(conf->spare_page);
-		kfree(conf->disks);
-		kfree(conf->stripe_hashtbl);
-		kfree(conf);
+		free_conf(conf);
 	}
 	mddev->private = NULL;
 	printk(KERN_ALERT "raid5: failed to run raid set %s\n", mdname(mddev));
@@ -4629,13 +4630,10 @@ static int stop(mddev_t *mddev)
 
 	md_unregister_thread(mddev->thread);
 	mddev->thread = NULL;
-	shrink_stripes(conf);
-	kfree(conf->stripe_hashtbl);
 	mddev->queue->backing_dev_info.congested_fn = NULL;
 	blk_sync_queue(mddev->queue); /* the unplug fn references 'conf'*/
 	sysfs_remove_group(&mddev->kobj, &raid5_attrs_group);
-	kfree(conf->disks);
-	kfree(conf);
+	free_conf(conf);
 	mddev->private = NULL;
 	return 0;
 }


