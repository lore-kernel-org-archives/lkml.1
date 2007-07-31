Return-Path: <linux-kernel-owner+w=401wt.eu-S940845AbXGaCWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940845AbXGaCWI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 22:22:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938523AbXGaCRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 22:17:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:36036 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937713AbXGaCRH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 22:17:07 -0400
From: NeilBrown <neilb@suse.de>
To: linux-kernel@vger.kernel.org
Date: Tue, 31 Jul 2007 12:16:55 +1000
Message-Id: <1070731021655.25270@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Subject: [PATCH 013 of 35] Don't update bi_hw_*_size if we aren't going to merge.
References: <20070731112539.22428.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


ll_merge_requests_fn can update bi_hw_*_size in one case where we end
up not merging.  This is wrong.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./block/ll_rw_blk.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff .prev/block/ll_rw_blk.c ./block/ll_rw_blk.c
--- .prev/block/ll_rw_blk.c	2007-07-31 11:20:57.000000000 +1000
+++ ./block/ll_rw_blk.c	2007-07-31 11:20:58.000000000 +1000
@@ -1516,11 +1516,13 @@ static int ll_merge_requests_fn(struct r
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
