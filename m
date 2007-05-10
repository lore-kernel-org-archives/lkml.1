Return-Path: <linux-kernel-owner+w=401wt.eu-S1755965AbXEJGXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965AbXEJGXY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 02:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757413AbXEJGW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 02:22:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55677 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757184AbXEJGW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 02:22:56 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 10 May 2007 16:22:25 +1000
Message-Id: <1070510062225.20388@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Neil Brown <neilb@suse.de>
Cc: stable@kernel.org
Subject: [PATCH 001 of 2] md: Avoid a possibility that a read error can wrongly propagate through md/raid1 to a filesystem.
References: <20070510161940.20204.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


When a raid1 has only one working drive, we want read error to
propagate up to the filesystem as there is no point failing the last
drive in an array.

Currently the code perform this check is racy.  If a write and a read
a both submitted to a device on a 2-drive raid1, and the write fails
followed by the read failing, the read will see that there is only one
working drive and will pass the failure up, even though the one
working drive is actually the *other* one.

So, tighten up the locking.

Cc: stable@kernel.org
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid1.c |   33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff .prev/drivers/md/raid1.c ./drivers/md/raid1.c
--- .prev/drivers/md/raid1.c	2007-05-10 15:51:54.000000000 +1000
+++ ./drivers/md/raid1.c	2007-05-10 15:51:58.000000000 +1000
@@ -271,21 +271,25 @@ static int raid1_end_read_request(struct
 	 */
 	update_head_pos(mirror, r1_bio);
 
-	if (uptodate || (conf->raid_disks - conf->mddev->degraded) <= 1) {
-		/*
-		 * Set R1BIO_Uptodate in our master bio, so that
-		 * we will return a good error code for to the higher
-		 * levels even if IO on some other mirrored buffer fails.
-		 *
-		 * The 'master' represents the composite IO operation to
-		 * user-side. So if something waits for IO, then it will
-		 * wait for the 'master' bio.
+	if (uptodate)
+		set_bit(R1BIO_Uptodate, &r1_bio->state);
+	else {
+		/* If all other devices have failed, we want to return
+		 * the error upwards rather than fail the last device.
+		 * Here we redefine "uptodate" to mean "Don't want to retry"
 		 */
-		if (uptodate)
-			set_bit(R1BIO_Uptodate, &r1_bio->state);
+		unsigned long flags;
+		spin_lock_irqsave(&conf->device_lock, flags);
+		if (r1_bio->mddev->degraded == conf->raid_disks ||
+		    (r1_bio->mddev->degraded == conf->raid_disks-1 &&
+		     !test_bit(Faulty, &conf->mirrors[mirror].rdev->flags)))
+			uptodate = 1;
+		spin_unlock_irqrestore(&conf->device_lock, flags);
+	}
 
+	if (uptodate)
 		raid_end_bio_io(r1_bio);
-	} else {
+	else {
 		/*
 		 * oops, read error:
 		 */
@@ -992,13 +996,14 @@ static void error(mddev_t *mddev, mdk_rd
 		unsigned long flags;
 		spin_lock_irqsave(&conf->device_lock, flags);
 		mddev->degraded++;
+		set_bit(Faulty, &rdev->flags);
 		spin_unlock_irqrestore(&conf->device_lock, flags);
 		/*
 		 * if recovery is running, make sure it aborts.
 		 */
 		set_bit(MD_RECOVERY_ERR, &mddev->recovery);
-	}
-	set_bit(Faulty, &rdev->flags);
+	} else
+		set_bit(Faulty, &rdev->flags);
 	set_bit(MD_CHANGE_DEVS, &mddev->flags);
 	printk(KERN_ALERT "raid1: Disk failure on %s, disabling device. \n"
 		"	Operation continuing on %d devices\n",
