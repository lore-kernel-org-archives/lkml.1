Return-Path: <linux-kernel-owner+w=401wt.eu-S1758815AbZCRNdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758815AbZCRNdA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 09:33:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752929AbZCRN2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 09:28:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53205 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757707AbZCRN2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 09:28:30 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com, Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 16/18] GFS2: Pagecache usage optimization on GFS2
Date: Wed, 18 Mar 2009 12:23:51 +0000
Message-Id: <1237379033-28095-17-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1237379033-28095-16-git-send-email-swhiteho@redhat.com>
References: <1237379033-28095-1-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-2-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-3-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-4-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-5-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-6-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-7-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-8-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-9-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-10-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-11-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-12-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-13-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-14-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-15-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-16-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>

I introduced "is_partially_uptodate" aops for GFS2.

A page can have multiple buffers and even if a page is not uptodate, some buffers
can be uptodate on pagesize != blocksize environment.
This aops checks that all buffers which correspond to a part of a file
that we want to read are uptodate. If so, we do not have to issue actual
read IO to HDD even if a page is not uptodate because the portion we
want to read are uptodate.
"block_is_partially_uptodate" function is already used by ext2/3/4.
With the following patch random read/write mixed workloads or random read after
random write workloads can be optimized and we can get performance improvement.

I did a performance test using the sysbench.

#sysbench --num-threads=16 --max-requests=200000 --test=fileio --file-num=1
--file-block-size=8K --file-total-size=2G --file-test-mode=rndrw --file-fsync-freq=0
--file-rw-ratio=1 run

-2.6.29-rc6
Test execution summary:
    total time:                          202.6389s
    total number of events:              200000
    total time taken by event execution: 2580.0480
    per-request statistics:
         min:                            0.0000s
         avg:                            0.0129s
         max:                            49.5852s
         approx.  95 percentile:         0.0462s

-2.6.29-rc6-patched
Test execution summary:
    total time:                          177.8639s
    total number of events:              200000
    total time taken by event execution: 2419.0199
    per-request statistics:
         min:                            0.0000s
         avg:                            0.0121s
         max:                            52.4306s
         approx.  95 percentile:         0.0444s

arch: ia64
pagesize: 16k
blocksize: 4k

Signed-off-by: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/ops_address.c b/fs/gfs2/ops_address.c
index a6d00e8..a6dde17 100644
--- a/fs/gfs2/ops_address.c
+++ b/fs/gfs2/ops_address.c
@@ -1096,6 +1096,7 @@ static const struct address_space_operations gfs2_writeback_aops = {
 	.releasepage = gfs2_releasepage,
 	.direct_IO = gfs2_direct_IO,
 	.migratepage = buffer_migrate_page,
+	.is_partially_uptodate = block_is_partially_uptodate,
 };
 
 static const struct address_space_operations gfs2_ordered_aops = {
@@ -1111,6 +1112,7 @@ static const struct address_space_operations gfs2_ordered_aops = {
 	.releasepage = gfs2_releasepage,
 	.direct_IO = gfs2_direct_IO,
 	.migratepage = buffer_migrate_page,
+	.is_partially_uptodate = block_is_partially_uptodate,
 };
 
 static const struct address_space_operations gfs2_jdata_aops = {
@@ -1125,6 +1127,7 @@ static const struct address_space_operations gfs2_jdata_aops = {
 	.bmap = gfs2_bmap,
 	.invalidatepage = gfs2_invalidatepage,
 	.releasepage = gfs2_releasepage,
+	.is_partially_uptodate = block_is_partially_uptodate,
 };
 
 void gfs2_set_aops(struct inode *inode)
-- 
1.6.0.3

