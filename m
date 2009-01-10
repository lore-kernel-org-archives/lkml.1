Return-Path: <linux-kernel-owner+w=401wt.eu-S1754037AbZAJF5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037AbZAJF5Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 00:57:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751114AbZAJF5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 00:57:17 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:59830 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbZAJF5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 00:57:16 -0500
X-IronPort-AV: E=Sophos;i="4.37,243,1231113600"; 
   d="scan'208";a="227206478"
From: Roland Dreier <rdreier@cisco.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] block: Fix register_disk() when name has '/' in it
X-Message-Flag: Warning: May contain useful information
Date: Fri, 09 Jan 2009 21:57:15 -0800
Message-ID: <adaljtjog90.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 10 Jan 2009 05:57:15.0512 (UTC) FILETIME=[49EE8F80:01C972E8]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 3ada8b7e ("block: struct device - replace bus_id with dev_name(),
dev_set_name()") deleted the code in register_disk() that changed a '/'
to a '!' in the device name when registering a disk.  This leads to
amusing problems with disks that have '/' in their names -- for example
a failure to boot with the root partition on a cciss device, even though
the kernel says it knows about the root device:

    VFS: Cannot open root device "cciss/c0d0p6" or unknown-block(0,0)
    Please append a correct "root=" boot option; here are the available partitions:
    6800        71652960 cciss/c0d0 driver: cciss
      6802               1 cciss/c0d0p2
      6805         2931831 cciss/c0d0p5
      6806        34354908 cciss/c0d0p6
    6810        71652960 cciss/c0d1 driver: cciss

Fix this by bringing back the code to change '/' to '!' in disk names
when registering a disk.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
 fs/partitions/check.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 6d72024..474d73e 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -448,11 +448,19 @@ void register_disk(struct gendisk *disk)
 	struct block_device *bdev;
 	struct disk_part_iter piter;
 	struct hd_struct *part;
+	char dname[DISK_NAME_LEN];
+	char *s;
 	int err;
 
 	ddev->parent = disk->driverfs_dev;
 
-	dev_set_name(ddev, disk->disk_name);
+	/* ewww... some of these buggers have / in the name... */
+	strcpy(dname, disk->disk_name);
+	s = strchr(dname, '/');
+	if (s)
+		*s = '!';
+
+	dev_set_name(ddev, dname);
 
 	/* delay uevents, until we scanned partition table */
 	ddev->uevent_suppress = 1;
