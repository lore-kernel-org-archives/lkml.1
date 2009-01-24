Return-Path: <linux-kernel-owner+w=401wt.eu-S1754338AbZAXKmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338AbZAXKmu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 05:42:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751177AbZAXKmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 05:42:42 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:62281 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbZAXKml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 05:42:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=j0njGbxlgmwwEnkB/vHCEOJ11WYS1nLZT9eJwUA5exBaBzdFM0xDqV0uRwbLlQzUDW
         xehcKOFVVpWpQLGG2nUEn782dOmEzMSM2ju/CIX6hBdXqNbGXZirZT7rNB7pW4PhPQ2w
         +NyyuwiXF2eAvegHUCetTxYCC8GLm45zizrC8=
Message-ID: <497AEFFE.7020106@tuffmail.co.uk>
Date: Sat, 24 Jan 2009 10:39:58 +0000
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: linux-pm@lists.linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Hibernate: fix "swap breaks after hibernation failures"
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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


