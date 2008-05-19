Return-Path: <linux-kernel-owner+w=401wt.eu-S1758772AbYESBMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758772AbYESBMp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 21:12:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757351AbYESBLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 21:11:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50292 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757157AbYESBKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 21:10:51 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 19 May 2008 11:10:44 +1000
Message-Id: <1080519011044.7712@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 006 of 10] md: Notify userspace on 'write-pending' changes to array_state
References: <20080519110910.7473.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When an array enters write pending, 'array_state' changes, so we
must be sure to sysfs_notify.

Also, when waiting for user-space to acknowledge 'write-pending' by
marking the metadata as dirty, we don't want to wait for
MD_CHANGE_DEVS to be cleared as that might not happen.  So explicity
test for the bits that we are really interested in.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2008-05-19 11:02:35.000000000 +1000
+++ ./drivers/md/md.c	2008-05-19 11:03:43.000000000 +1000
@@ -5435,8 +5435,11 @@ void md_write_start(mddev_t *mddev, stru
 			md_wakeup_thread(mddev->thread);
 		}
 		spin_unlock_irq(&mddev->write_lock);
+		sysfs_notify(&mddev->kobj, NULL, "array_state");
 	}
-	wait_event(mddev->sb_wait, mddev->flags==0);
+	wait_event(mddev->sb_wait,
+		   !test_bit(MD_CHANGE_CLEAN, &mddev->flags) &&
+		   !test_bit(MD_CHANGE_PENDING, &mddev->flags));
 }
 
 void md_write_end(mddev_t *mddev)
@@ -5471,6 +5474,12 @@ void md_allow_write(mddev_t *mddev)
 			mddev->safemode = 1;
 		spin_unlock_irq(&mddev->write_lock);
 		md_update_sb(mddev, 0);
+
+		sysfs_notify(&mddev->kobj, NULL, "array_state");
+		/* wait for the dirty state to be recorded in the metadata */
+		wait_event(mddev->sb_wait,
+			   !test_bit(MD_CHANGE_CLEAN, &mddev->flags) &&
+			   !test_bit(MD_CHANGE_PENDING, &mddev->flags));
 	} else
 		spin_unlock_irq(&mddev->write_lock);
 }
