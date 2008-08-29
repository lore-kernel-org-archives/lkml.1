Return-Path: <linux-kernel-owner+w=401wt.eu-S1757018AbYH2XOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757018AbYH2XOv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 19:14:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753136AbYH2XNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 19:13:13 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:35886 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140AbYH2XNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 19:13:11 -0400
From: Andrew Patterson <andrew.patterson@hp.com>
Subject: [PATCH 3/6] Check for device resize when rescanning partitions
To: linux-scsi@vger.kernel.org
Cc: andrew.patterson@hp.com, James.Bottomley@HansenPartnership.com,
       linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
       andmike@linux.vnet.ibm.com, mike.miller@hp.com, genanr@emsphone.com,
       jmoyer@redhat.com
Date: Fri, 29 Aug 2008 17:13:10 -0600
Message-ID: <20080829231310.25065.40311.stgit@bluto.andrew>
In-Reply-To: <20080829231254.25065.66052.stgit@bluto.andrew>
References: <20080829231254.25065.66052.stgit@bluto.andrew>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check for device resize when rescanning partitions

Check for device resize in the rescan_partitions() routine. If the device
has been resized, the bdev size is set to match. The rescan_partitions()
routine is called when opening the device and when calling the
BLKRRPART ioctl.

Signed-off-by: Andrew Patterson <andrew.patterson@hp.com>
---

 fs/partitions/check.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)


diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 7d6b34e..2e7b1fa 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -480,11 +480,12 @@ int rescan_partitions(struct gendisk *disk, struct block_device *bdev)
 	res = invalidate_partition(disk, 0);
 	if (res)
 		return res;
-	bdev->bd_invalidated = 0;
 	for (p = 1; p < disk->minors; p++)
 		delete_partition(disk, p);
 	if (disk->fops->revalidate_disk)
 		disk->fops->revalidate_disk(disk);
+	check_disk_size_change(disk, bdev);
+	bdev->bd_invalidated = 0;
 	if (!get_capacity(disk) || !(state = check_partition(disk, bdev)))
 		return 0;
 	if (IS_ERR(state))	/* I/O error reading the partition table */

