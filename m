Return-Path: <linux-kernel-owner+w=401wt.eu-S1757370AbXFLBJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370AbXFLBJs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 21:09:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755773AbXFLBJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 21:09:36 -0400
Received: from mx1.suse.de ([195.135.220.2]:57598 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775AbXFLBJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 21:09:35 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 12 Jun 2007 11:09:29 +1000
Message-Id: <1070612010929.25355@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Neil Brown <neilb@suse.de>
Cc: stable@kernel.org
Subject: [PATCH 001 of 2] md: Fix two raid10 bugs.
References: <20070612110634.25171.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


1/ When resyncing a degraded raid10 which has more than 2 copies of each block,
  garbage can get synced on top of good data.

2/ We round the wrong way in part of the device size calculation, which
  can cause confusion.

Signed-off-by: Neil Brown <neilb@suse.de>
Cc: stable@kernel.org

### Diffstat output
 ./drivers/md/raid10.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff .prev/drivers/md/raid10.c ./drivers/md/raid10.c
--- .prev/drivers/md/raid10.c	2007-06-12 10:19:04.000000000 +1000
+++ ./drivers/md/raid10.c	2007-06-12 10:20:31.000000000 +1000
@@ -1866,6 +1866,7 @@ static sector_t sync_request(mddev_t *md
 			int d = r10_bio->devs[i].devnum;
 			bio = r10_bio->devs[i].bio;
 			bio->bi_end_io = NULL;
+			clear_bit(BIO_UPTODATE, &bio->bi_flags);
 			if (conf->mirrors[d].rdev == NULL ||
 			    test_bit(Faulty, &conf->mirrors[d].rdev->flags))
 				continue;
@@ -2036,6 +2037,11 @@ static int run(mddev_t *mddev)
 	/* 'size' is now the number of chunks in the array */
 	/* calculate "used chunks per device" in 'stride' */
 	stride = size * conf->copies;
+
+	/* We need to round up when dividing by raid_disks to
+	 * get the stride size.
+	 */
+	stride += conf->raid_disks - 1;
 	sector_div(stride, conf->raid_disks);
 	mddev->size = stride  << (conf->chunk_shift-1);
 
