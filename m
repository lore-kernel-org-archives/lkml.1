Return-Path: <linux-kernel-owner+w=401wt.eu-S1946260AbXBCCjK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946260AbXBCCjK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 21:39:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946267AbXBCCi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 21:38:59 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:53048 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946266AbXBCCiy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 21:38:54 -0500
Message-Id: <20070203024342.489435000@sous-sol.org>
References: <20070203023504.435051000@sous-sol.org>
User-Agent: quilt/0.45-1
Date: Fri, 02 Feb 2007 18:35:42 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       NeilBrown <neilb@suse.de>
Subject: [patch 38/59] md: assorted md and raid1 one-liners
Content-Disposition: inline; filename=md-assorted-md-and-raid1-one-liners.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
------------------

From: NeilBrown <neilb@suse.de>

Fix few bugs that meant that:
  - superblocks weren't alway written at exactly the right time (this
    could show up if the array was not written to - writting to the array
    causes lots of superblock updates and so hides these errors).

  - restarting device recovery after a clean shutdown (version-1 metadata
    only) didn't work as intended (or at all).

1/ Ensure superblock is updated when a new device is added.
2/ Remove an inappropriate test on MD_RECOVERY_SYNC in md_do_sync.
   The body of this if takes one of two branches depending on whether
   MD_RECOVERY_SYNC is set, so testing it in the clause of the if
   is wrong.
3/ Flag superblock for updating after a resync/recovery finishes.
4/ If we find the neeed to restart a recovery in the middle (version-1
   metadata only) make sure a full recovery (not just as guided by
   bitmaps) does get done.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/md/md.c    |    3 ++-
 drivers/md/raid1.c |    1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

--- linux-2.6.19.2.orig/drivers/md/md.c
+++ linux-2.6.19.2/drivers/md/md.c
@@ -3722,6 +3722,7 @@ static int add_new_disk(mddev_t * mddev,
 		if (err)
 			export_rdev(rdev);
 
+		md_update_sb(mddev, 1);
 		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 		md_wakeup_thread(mddev->thread);
 		return err;
@@ -5273,7 +5274,6 @@ void md_do_sync(mddev_t *mddev)
 	mddev->pers->sync_request(mddev, max_sectors, &skipped, 1);
 
 	if (!test_bit(MD_RECOVERY_ERR, &mddev->recovery) &&
-	    test_bit(MD_RECOVERY_SYNC, &mddev->recovery) &&
 	    !test_bit(MD_RECOVERY_CHECK, &mddev->recovery) &&
 	    mddev->curr_resync > 2) {
 		if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery)) {
@@ -5297,6 +5297,7 @@ void md_do_sync(mddev_t *mddev)
 					rdev->recovery_offset = mddev->curr_resync;
 		}
 	}
+	set_bit(MD_CHANGE_DEVS, &mddev->flags);
 
  skip:
 	mddev->curr_resync = 0;
--- linux-2.6.19.2.orig/drivers/md/raid1.c
+++ linux-2.6.19.2/drivers/md/raid1.c
@@ -1956,6 +1956,7 @@ static int run(mddev_t *mddev)
 		    !test_bit(In_sync, &disk->rdev->flags)) {
 			disk->head_position = 0;
 			mddev->degraded++;
+			conf->fullsync = 1;
 		}
 	}
 	if (mddev->degraded == conf->raid_disks) {

--
