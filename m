Return-Path: <linux-kernel-owner+w=401wt.eu-S1754525AbXHPFN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525AbXHPFN5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 01:13:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757671AbXHPFNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 01:13:39 -0400
Received: from ns1.suse.de ([195.135.220.2]:46433 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756566AbXHPFNi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 01:13:38 -0400
From: NeilBrown <neilb@suse.de>
To: Jens Axboe <jens.axboe@oracle.com>
Date: Thu, 16 Aug 2007 15:13:32 +1000
Message-Id: <1070816051332.31325@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>
Subject: [PATCH 001 of 5] Don't update bi_hw_*_size if we aren't going to merge.
References: <20070816150445.30843.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


ll_merge_requests_fn can update bi_hw_*_size in one case where we end
up not merging.  This is wrong.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./block/ll_rw_blk.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff .prev/block/ll_rw_blk.c ./block/ll_rw_blk.c
--- .prev/block/ll_rw_blk.c	2007-08-16 14:57:39.000000000 +1000
+++ ./block/ll_rw_blk.c	2007-08-16 15:02:29.000000000 +1000
@@ -1518,11 +1518,13 @@ static int ll_merge_requests_fn(struct r
 		/*
 		 * propagate the combined length to the end of the requests
 		 */
+		total_hw_segments--;
+		if (total_hw_segments > q->max_hw_segments)
+			return 0;
 		if (req->nr_hw_segments == 1)
 			req->bio->bi_hw_front_size = len;
 		if (next->nr_hw_segments == 1)
 			next->biotail->bi_hw_back_size = len;
-		total_hw_segments--;
 	}
 
 	if (total_hw_segments > q->max_hw_segments)
