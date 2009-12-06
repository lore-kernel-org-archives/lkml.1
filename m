Return-Path: <linux-kernel-owner+w=401wt.eu-S1758438AbZLGAfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758438AbZLGAfv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:35:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758273AbZLGAMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:12:34 -0500
Received: from kroah.org ([198.145.64.141]:34183 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758251AbZLGAMb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:12:31 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:42 2009
Message-Id: <20091207000642.118166452@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 15:59:46 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       NeilBrown <neilb@suse.de>
Subject: [010/119] md/raid5: make sure curr_sync_completes is uptodate when reshape starts
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=md-raid5-make-sure-curr_sync_completes-is-uptodate-when-reshape-starts.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: NeilBrown <neilb@suse.de>

commit 8dee7211467a56b7eb4e4359efb0aa4a72e1b6f3 upstream.

This value is visible through sysfs and is used by mdadm
when it manages a reshape (backing up data that is about to be
rearranged).  So it is important that it is always correct.
Current it does not get updated properly when a reshape
starts which can cause problems when assembling an array
that is in the middle of being reshaped.

This is suitable for 2.6.31.y stable kernels.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/raid5.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3790,6 +3790,8 @@ static sector_t reshape_request(mddev_t 
 			sector_nr = conf->reshape_progress;
 		sector_div(sector_nr, new_data_disks);
 		if (sector_nr) {
+			mddev->curr_resync_completed = sector_nr;
+			sysfs_notify(&mddev->kobj, NULL, "sync_completed");
 			*skipped = 1;
 			return sector_nr;
 		}


