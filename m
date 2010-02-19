Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779Ab0BSRAl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:00:41 -0500
Received: from kroah.org ([198.145.64.141]:57536 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754600Ab0BSRAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:00:37 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Feb 19 08:32:41 2010
Message-Id: <20100219163241.559320398@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 19 Feb 2010 08:29:32 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       NeilBrown <neilb@suse.de>
Subject: [39/93] md: fix degraded calculation when starting a reshape.
In-Reply-To: <20100219165717.GA15002@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: NeilBrown <neilb@suse.de>

commit 9eb07c259207d048e3ee8be2a77b2a4680b1edd4 upstream.

This code was written long ago when it was not possible to
reshape a degraded array.  Now it is so the current level of
degraded-ness needs to be taken in to account.  Also newly addded
devices should only reduce degradedness if they are deemed to be
in-sync.

In particular, if you convert a RAID5 to a RAID6, and increase the
number of devices at the same time, then the 5->6 conversion will
make the array degraded so the current code will produce a wrong
value for 'degraded' - "-1" to be precise.

If the reshape runs to completion end_reshape will calculate a correct
new value for 'degraded', but if a device fails during the reshape an
incorrect decision might be made based on the incorrect value of
"degraded".

This patch is suitable for 2.6.32-stable and if they are still open,
2.6.31-stable and 2.6.30-stable as well.

Reported-by: Michael Evans <mjevans1983@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/raid5.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5432,11 +5432,11 @@ static int raid5_start_reshape(mddev_t *
 		    !test_bit(Faulty, &rdev->flags)) {
 			if (raid5_add_disk(mddev, rdev) == 0) {
 				char nm[20];
-				if (rdev->raid_disk >= conf->previous_raid_disks)
+				if (rdev->raid_disk >= conf->previous_raid_disks) {
 					set_bit(In_sync, &rdev->flags);
-				else
+					added_devices++;
+				} else
 					rdev->recovery_offset = 0;
-				added_devices++;
 				sprintf(nm, "rd%d", rdev->raid_disk);
 				if (sysfs_create_link(&mddev->kobj,
 						      &rdev->kobj, nm))
@@ -5448,9 +5448,12 @@ static int raid5_start_reshape(mddev_t *
 				break;
 		}
 
+	/* When a reshape changes the number of devices, ->degraded
+	 * is measured against the large of the pre and post number of
+	 * devices.*/
 	if (mddev->delta_disks > 0) {
 		spin_lock_irqsave(&conf->device_lock, flags);
-		mddev->degraded = (conf->raid_disks - conf->previous_raid_disks)
+		mddev->degraded += (conf->raid_disks - conf->previous_raid_disks)
 			- added_devices;
 		spin_unlock_irqrestore(&conf->device_lock, flags);
 	}


