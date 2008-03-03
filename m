Return-Path: <linux-kernel-owner+w=401wt.eu-S1761884AbYCCAUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761884AbYCCAUj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 19:20:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760505AbYCCARw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 19:17:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45733 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756712AbYCCARu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 19:17:50 -0500
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 3 Mar 2008 11:18:00 +1100
Message-Id: <1080303001800.23698@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "K.Tanaka" <k-tanaka@ce.jp.nec.com>
Subject: [PATCH 009 of 9] md: The md RAID10 resync thread could cause a md RAID10 array deadlock
References: <20080303111240.23302.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: "K.Tanaka" <k-tanaka@ce.jp.nec.com>

This message describes another issue about md RAID10 found by
testing the 2.6.24 md RAID10 using new scsi fault injection framework.

Abstract:
When a scsi error results in disabling a disk during RAID10 recovery,
the resync threads of md RAID10 could stall.
This case, the raid array has already been broken and it may not matter.
But I think stall is not preferable. If it occurs, even shutdown or reboot
will fail because of resource busy.

The deadlock mechanism:
The r10bio_s structure has a "remaining" member to keep track of BIOs yet to be
handled when recovering. The "remaining" counter is incremented when building a BIO
in sync_request() and is decremented when finish a BIO in end_sync_write().

If building a BIO fails for some reasons in sync_request(), the "remaining" should be
decremented if it has already been incremented. I found a case where this decrement
is forgotten. This causes a md_do_sync() deadlock because md_do_sync() waits for
md_done_sync() called by end_sync_write(), but end_sync_write() never calls
md_done_sync() because of the "remaining" counter mismatch.

For example, this problem would be reproduced in the following case:

Personalities : [raid10]
md0 : active raid10 sdf1[4] sde1[5](F) sdd1[2] sdc1[1] sdb1[6](F)
      3919616 blocks 64K chunks 2 near-copies [4/2] [_UU_]
      [>....................]  recovery =  2.2% (45376/1959808) finish=0.7min speed=45376K/sec

This case, sdf1 is recovering, sdb1 and sde1 are disabled.
An additional error with detaching sdd will cause a deadlock.

md0 : active raid10 sdf1[4] sde1[5](F) sdd1[6](F) sdc1[1] sdb1[7](F)
      3919616 blocks 64K chunks 2 near-copies [4/1] [_U__]
      [=>...................]  recovery =  5.0% (99520/1959808) finish=5.9min speed=5237K/sec

 2739 ?        S<     0:17 [md0_raid10]
28608 ?        D<     0:00 [md0_resync]
28629 pts/1    Ss     0:00 bash
28830 pts/1    R+     0:00 ps ax
31819 ?        D<     0:00 [kjournald]

The resync thread keeps working, but actually it is deadlocked.

Patch:
By this patch, the remaining counter will be decremented if needed.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid10.c |    2 ++
 1 file changed, 2 insertions(+)

diff .prev/drivers/md/raid10.c ./drivers/md/raid10.c
--- .prev/drivers/md/raid10.c	2008-03-03 09:56:53.000000000 +1100
+++ ./drivers/md/raid10.c	2008-03-03 11:08:28.000000000 +1100
@@ -1818,6 +1818,8 @@ static sector_t sync_request(mddev_t *md
 				if (j == conf->copies) {
 					/* Cannot recover, so abort the recovery */
 					put_buf(r10_bio);
+					if (rb2)
+						atomic_dec(&rb2->remaining);
 					r10_bio = rb2;
 					if (!test_and_set_bit(MD_RECOVERY_ERR, &mddev->recovery))
 						printk(KERN_INFO "raid10: %s: insufficient working devices for recovery.\n",
