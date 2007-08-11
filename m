Return-Path: <linux-kernel-owner+w=401wt.eu-S1761458AbXHKTAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761458AbXHKTAG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 15:00:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762385AbXHKS6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 14:58:14 -0400
Received: from 1wt.eu ([62.212.114.60]:1498 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762288AbXHKS6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 14:58:10 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070811184841.%N@1wt.eu>
References: <20070811184752.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Sat, 11 Aug 2007 21:48:05 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Neil Brown <neilb@suse.de>, Chris Wright <chrisw@sous-sol.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [2.6.20.16 review 13/28] md: Fix two raid10 bugs.
Content-Disposition: inline; filename=0013-md-Fix-two-raid10-bugs.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

1/ When resyncing a degraded raid10 which has more than 2 copies of each block,
  garbage can get synced on top of good data.

2/ We round the wrong way in part of the device size calculation, which
  can cause confusion.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/md/raid10.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 82249a6..9eb66c1 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1867,6 +1867,7 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *skipped, i
 			int d = r10_bio->devs[i].devnum;
 			bio = r10_bio->devs[i].bio;
 			bio->bi_end_io = NULL;
+			clear_bit(BIO_UPTODATE, &bio->bi_flags);
 			if (conf->mirrors[d].rdev == NULL ||
 			    test_bit(Faulty, &conf->mirrors[d].rdev->flags))
 				continue;
@@ -2037,6 +2038,11 @@ static int run(mddev_t *mddev)
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
 
-- 
1.5.2.4

-- 
