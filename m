Return-Path: <linux-kernel-owner+w=401wt.eu-S1758921AbZLGAfE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758921AbZLGAfE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:35:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758287AbZLGAMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:12:38 -0500
Received: from kroah.org ([198.145.64.141]:34179 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758210AbZLGAMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:12:30 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:42 2009
Message-Id: <20091207000641.956467260@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 15:59:45 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       NeilBrown <neilb@suse.de>
Subject: [009/119] md: dont clear endpoint for resync when resync is interrupted.
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=md-don-t-clear-endpoint-for-resync-when-resync-is-interrupted.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: NeilBrown <neilb@suse.de>

commit 24395a85d8efe6eee477ea35c73d045a8dd7a3a1 upstream.

If a 'sync_max' has been set (via sysfs), it is wrong to clear it
until a resync (or reshape or recovery ...) actually reached that
point.
So if a resync is interrupted (e.g. by device failure),
leave 'resync_max' unchanged.

This is particularly important for 'reshape' operations that do not
change the size of the array.  For such operations mdadm needs to
monitor the reshape taking rolling backups of the section being
reshaped.  If resync_max gets cleared, the reshape can get ahead of
mdadm and then the backups that mdadm creates are useless.

This is suitable for 2.6.31.y stable kernels.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/md.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6495,8 +6495,9 @@ void md_do_sync(mddev_t *mddev)
  skip:
 	mddev->curr_resync = 0;
 	mddev->curr_resync_completed = 0;
-	mddev->resync_min = 0;
-	mddev->resync_max = MaxSector;
+	if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery))
+		/* We completed so max setting can be forgotten. */
+		mddev->resync_max = MaxSector;
 	sysfs_notify(&mddev->kobj, NULL, "sync_completed");
 	wake_up(&resync_wait);
 	set_bit(MD_RECOVERY_DONE, &mddev->recovery);


