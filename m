Return-Path: <linux-kernel-owner+w=401wt.eu-S1761793AbYCCATs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761793AbYCCATs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 19:19:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760137AbYCCARi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 19:17:38 -0500
Received: from ns1.suse.de ([195.135.220.2]:44914 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760000AbYCCARh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 19:17:37 -0500
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 3 Mar 2008 11:17:47 +1100
Message-Id: <1080303001747.23669@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Keld Simonsen <keld@dkuug.dk>
Subject: [PATCH 007 of 9] md: Don't attempt read-balancing for raid10 'far' layouts.
References: <20080303111240.23302.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Keld Simonsen <keld@dkuug.dk>

This patch changes the disk to be read for layout "far > 1" to always be
the disk with the lowest block address.

Thus the chunks to be read will always be (for a fully functioning array)
from the first band of stripes, and the raid will then work as a raid0
consisting of the first band of stripes.

Some advantages:

The fastest part which is the outer sectors of the disks involved will be used.
The outer blocks of a disk may be as much as 100 % faster than the inner blocks.

Average seek time will be smaller, as seeks will always be confined to the
first part of the disks.

Mixed disks with different performance characteristics will work better,
as they will work as raid0, the sequential read rate will be number of
disks involved times the IO rate of the slowest disk.

If a disk is malfunctioning, the first disk which is working, and has the lowest
block address for the logical block will be used.

Signed-off-by: Keld Simonsen <keld@dkuug.dk>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid10.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff .prev/drivers/md/raid10.c ./drivers/md/raid10.c
--- .prev/drivers/md/raid10.c	2008-03-03 09:35:29.000000000 +1100
+++ ./drivers/md/raid10.c	2008-03-03 09:35:52.000000000 +1100
@@ -537,7 +537,8 @@ static int read_balance(conf_t *conf, r1
 	current_distance = abs(r10_bio->devs[slot].addr -
 			       conf->mirrors[disk].head_position);
 
-	/* Find the disk whose head is closest */
+	/* Find the disk whose head is closest,
+	 * or - for far > 1 - find the closest to partition beginning */
 
 	for (nslot = slot; nslot < conf->copies; nslot++) {
 		int ndisk = r10_bio->devs[nslot].devnum;
@@ -557,8 +558,13 @@ static int read_balance(conf_t *conf, r1
 			slot = nslot;
 			break;
 		}
-		new_distance = abs(r10_bio->devs[nslot].addr -
-				   conf->mirrors[ndisk].head_position);
+
+		/* for far > 1 always use the lowest address */
+		if (conf->far_copies > 1)
+			new_distance = r10_bio->devs[nslot].addr;
+		else
+			new_distance = abs(r10_bio->devs[nslot].addr -
+					   conf->mirrors[ndisk].head_position);
 		if (new_distance < current_distance) {
 			current_distance = new_distance;
 			disk = ndisk;
