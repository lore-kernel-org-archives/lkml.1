Return-Path: <linux-kernel-owner+w=401wt.eu-S1755941AbZA0WUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941AbZA0WUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 17:20:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751799AbZA0WTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 17:19:49 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33968 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612AbZA0WTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 17:19:49 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH 1/1] PM/Hibernate: fix "swap breaks after hibernation failures"
Date: Tue, 27 Jan 2009 23:18:59 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc2-tst; KDE/4.1.3; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Pavel Machek <pavel@suse.cz>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>
References: <200901272317.43512.rjw@sisk.pl>
In-Reply-To: <200901272317.43512.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901272319.00102.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>

http://bugzilla.kernel.org/show_bug.cgi?id=12239

The image writing code dropped a reference to the current swap device.
This doesn't show up if the hibernation succeeds - because it doesn't
affect the image which gets resumed.  But it means multiple _failed_
hibernations end up freeing the swap device while it is still use!

swsusp_write() finds the block device for the swap file using swap_type_of().
It then uses blkdev_get() / blkdev_put() to open and close the block device.

Unfortunately, blkdev_get() assumes ownership of the inode of the block_device
passed to it.  So blkdev_put() calls iput() on the inode.  This is by design
and other callers expect this behaviour.  The fix is for swap_type_of() to take
a reference on the inode using bdget().

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

diff --git a/mm/swapfile.c b/mm/swapfile.c
index f48b831..7740478 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -635,7 +635,7 @@ int swap_type_of(dev_t device, sector_t offset, struct block_device **bdev_p)
 
 		if (!bdev) {
 			if (bdev_p)
-				*bdev_p = sis->bdev;
+				*bdev_p = bdget(sis->bdev->bd_dev);
 
 			spin_unlock(&swap_lock);
 			return i;
@@ -647,7 +647,7 @@ int swap_type_of(dev_t device, sector_t offset, struct block_device **bdev_p)
 					struct swap_extent, list);
 			if (se->start_block == offset) {
 				if (bdev_p)
-					*bdev_p = sis->bdev;
+					*bdev_p = bdget(sis->bdev->bd_dev);
 
 				spin_unlock(&swap_lock);
 				bdput(bdev);




