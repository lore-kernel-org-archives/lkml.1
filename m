Return-Path: <linux-kernel-owner+w=401wt.eu-S1762983AbXHPAja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762983AbXHPAja (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 20:39:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765927AbXHPAis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 20:38:48 -0400
Received: from ns2.suse.de ([195.135.220.15]:37919 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764640AbXHPAiq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 20:38:46 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 16 Aug 2007 10:38:39 +1000
Message-Id: <1070816003839.32721@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 001 of 2] md: Make sure a re-add after a restart honours bitmap when resyncing.
References: <20070816103626.32539.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Commit 1757128438d41670ded8bc3bc735325cc07dc8f9 was slightly bad.  If
an array has a write-intent bitmap, and you remove a drive, then readd
it, only the changed parts should be resynced.  However after the
above commit, this only works if the array has not been shut down and
restarted.

This is because it sets 'fullsync' at little more often
than it should.  This patch is more careful.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid1.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff .prev/drivers/md/raid1.c ./drivers/md/raid1.c
--- .prev/drivers/md/raid1.c	2007-08-16 10:27:57.000000000 +1000
+++ ./drivers/md/raid1.c	2007-08-16 10:27:57.000000000 +1000
@@ -1972,7 +1972,8 @@ static int run(mddev_t *mddev)
 		    !test_bit(In_sync, &disk->rdev->flags)) {
 			disk->head_position = 0;
 			mddev->degraded++;
-			conf->fullsync = 1;
+			if (disk->rdev)
+				conf->fullsync = 1;
 		}
 	}
 	if (mddev->degraded == conf->raid_disks) {
