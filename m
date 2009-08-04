Return-Path: <linux-kernel-owner+w=401wt.eu-S933474AbZHDWPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933474AbZHDWPW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 18:15:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932170AbZHDWPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 18:15:20 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:39477 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755410AbZHDWPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 18:15:17 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAP9PeEqrR7PE/2dsb2JhbAC8N4gpkBcFhBg
X-IronPort-AV: E=Sophos;i="4.43,324,1246838400"; 
   d="scan'208";a="192519245"
Date: Tue, 4 Aug 2009 15:15:18 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, linux-usb@vger.kernel.org, greg@kroah.com,
       linux-scsi@vger.kernel.org, netdev@vger.kernel.org, arjan@infradead.org
Subject: [PATCH 6/7 v1] initdev:kernel:SCSI asynchronous block init device
	notification
Message-ID: <20090804221518.GA9362@cuplxvomd02.corp.sa.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Authentication-Results: sj-dkim-4; header.From=dvomlehn@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In addition to the bus initdev synchronization, SCSI also starts asynchronous
threads with which we must synchronize.

Signed-off-by: David VomLehn <dvomlehn@cisco.com>
---
 drivers/scsi/sd.c     |    2 ++
 fs/partitions/check.c |    1 +
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 5616cd7..394235d 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2005,6 +2005,7 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
 
 	sd_printk(KERN_NOTICE, sdkp, "Attached SCSI %sdisk\n",
 		  sdp->removable ? "removable " : "");
+	initdev_probe_done(INITDEV_BLOCK_MASK);
 }
 
 /**
@@ -2090,6 +2091,7 @@ static int sd_probe(struct device *dev)
 
 	get_device(&sdp->sdev_gendev);
 
+	initdev_found(INITDEV_BLOCK_MASK);
 	async_schedule(sd_probe_async, sdkp);
 
 	return 0;
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index ea4e6cb..a0fa50c 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -512,6 +512,7 @@ exit:
 	while ((part = disk_part_iter_next(&piter)))
 		kobject_uevent(&part_to_dev(part)->kobj, KOBJ_ADD);
 	disk_part_iter_exit(&piter);
+	initdev_registered(INITDEV_BLOCK_TYPE);
 }
 
 int rescan_partitions(struct gendisk *disk, struct block_device *bdev)
