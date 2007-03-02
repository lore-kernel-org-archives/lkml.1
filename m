Return-Path: <linux-kernel-owner+w=401wt.eu-S932280AbXCBE6D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932280AbXCBE6D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 23:58:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932643AbXCBE6B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 23:58:01 -0500
Received: from mx2.suse.de ([195.135.220.15]:60639 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932280AbXCBE6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 23:58:00 -0500
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 2 Mar 2007 15:56:55 +1100
Message-Id: <1070302045655.19069@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] md: Fix for raid6 reshape.
References: <20070302155626.19014.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

### Comments for Changeset

Recent patch for raid6 reshape had a change missing that showed up in
subsequent review.

Many places in the raid5 code used "conf->raid_disks-1" to mean
"number of data disks".  With raid6 that had to be changed to
"conf->raid_disk - conf->max_degraded" or similar.  One place was missed.

This bug means that if a raid6 reshape were aborted in the middle the
recorded position would be wrong.  On restart it would either fail (as
the position wasn't on an appropriate boundary) or would leave a section
of the array unreshaped, causing data corruption.


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2007-03-02 15:47:51.000000000 +1100
+++ ./drivers/md/raid5.c	2007-03-02 15:48:35.000000000 +1100
@@ -3071,7 +3071,7 @@ static sector_t reshape_request(mddev_t 
 		release_stripe(sh);
 	}
 	spin_lock_irq(&conf->device_lock);
-	conf->expand_progress = (sector_nr + i)*(conf->raid_disks-1);
+	conf->expand_progress = (sector_nr + i) * new_data_disks);
 	spin_unlock_irq(&conf->device_lock);
 	/* Ok, those stripe are ready. We can start scheduling
 	 * reads on the source stripes.
