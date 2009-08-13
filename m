Return-Path: <linux-kernel-owner+w=401wt.eu-S1756126AbZHMUGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126AbZHMUGq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 16:06:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932211AbZHMT7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 15:59:49 -0400
Received: from kroah.org ([198.145.64.141]:41834 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932214AbZHMT7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:59:48 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:51:31 2009
Message-Id: <20090813195130.963233083@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:50:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       NeilBrown <neilb@suse.de>
Subject: [patch 43/74] md: when a level change reduces the number of devices, remove the excess.
References: <20090813194935.985368088@mini.kroah.org>
Content-Disposition: inline; filename=md-when-a-level-change-reduces-the-number-of-devices-remove-the-excess.patch
In-Reply-To: <20090813195705.GA22393@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: NeilBrown <neilb@suse.de>

commit 3a981b03f38dc3b8a69b77cbc679e66c1318a44a upstream.

When an array is changed from RAID6 to RAID5, fewer drives are
needed.  So any device that is made superfluous by the level
conversion must be marked as not-active.
For the RAID6->RAID5 conversion, this will be a drive which only
has 'Q' blocks on it.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/md.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2680,6 +2680,7 @@ level_store(mddev_t *mddev, const char *
 	ssize_t rv = len;
 	struct mdk_personality *pers;
 	void *priv;
+	mdk_rdev_t *rdev;
 
 	if (mddev->pers == NULL) {
 		if (len == 0)
@@ -2759,6 +2760,12 @@ level_store(mddev_t *mddev, const char *
 	mddev_suspend(mddev);
 	mddev->pers->stop(mddev);
 	module_put(mddev->pers->owner);
+	/* Invalidate devices that are now superfluous */
+	list_for_each_entry(rdev, &mddev->disks, same_set)
+		if (rdev->raid_disk >= mddev->raid_disks) {
+			rdev->raid_disk = -1;
+			clear_bit(In_sync, &rdev->flags);
+		}
 	mddev->pers = pers;
 	mddev->private = priv;
 	strlcpy(mddev->clevel, pers->name, sizeof(mddev->clevel));


