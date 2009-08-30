Return-Path: <linux-kernel-owner+w=401wt.eu-S1753297AbZH3CdD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297AbZH3CdD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 22:33:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752983AbZH3Cc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 22:32:59 -0400
Received: from mga11.intel.com ([192.55.52.93]:2616 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752336AbZH3CaY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 22:30:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,297,1249282800"; 
   d="scan'208";a="488600449"
Subject: [PATCH v3 05/14] md/raid6: release spare page at ->stop()
To: neilb@suse.de
From: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 29 Aug 2009 19:30:26 -0700
Message-ID: <20090830023026.5934.76997.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20090830022908.5934.72142.stgit@dwillia2-linux.ch.intel.com>
References: <20090830022908.5934.72142.stgit@dwillia2-linux.ch.intel.com>
User-Agent: StGit/0.14.3.289.g7daff
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing call to safe_put_page from stop() by unifying open coded
raid5_conf_t de-allocation under free_conf().

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/md/raid5.c |   26 ++++++++++++--------------
 1 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index e1920f2..9411466 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4309,6 +4309,15 @@ raid5_size(mddev_t *mddev, sector_t sectors, int raid_disks)
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
@@ -4438,11 +4447,7 @@ static raid5_conf_t *setup_conf(mddev_t *mddev)
 
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
@@ -4608,12 +4613,8 @@ abort:
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
@@ -4628,13 +4629,10 @@ static int stop(mddev_t *mddev)
 
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

