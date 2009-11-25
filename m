Return-Path: <linux-kernel-owner+w=401wt.eu-S964922AbZKYNgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964922AbZKYNgt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 08:36:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934635AbZKYNgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 08:36:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15897 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934745AbZKYNga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 08:36:30 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Wu Fengguang <fengguang.wu@intel.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 30/30] writeback: remove unused nonblocking and congestion checks (gfs2)
Date: Wed, 25 Nov 2009 14:31:02 +0000
Message-Id: <1259159462-28622-10-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1259159462-28622-9-git-send-email-swhiteho@redhat.com>
References: <1259158975-28499-20-git-send-email-swhiteho@redhat.com>
 <1259159462-28622-1-git-send-email-swhiteho@redhat.com>
 <1259159462-28622-2-git-send-email-swhiteho@redhat.com>
 <1259159462-28622-3-git-send-email-swhiteho@redhat.com>
 <1259159462-28622-4-git-send-email-swhiteho@redhat.com>
 <1259159462-28622-5-git-send-email-swhiteho@redhat.com>
 <1259159462-28622-6-git-send-email-swhiteho@redhat.com>
 <1259159462-28622-7-git-send-email-swhiteho@redhat.com>
 <1259159462-28622-8-git-send-email-swhiteho@redhat.com>
 <1259159462-28622-9-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Fengguang <fengguang.wu@intel.com>

No one is calling wb_writeback and write_cache_pages with
wbc.nonblocking=1 any more. And lumpy pageout will want to do
nonblocking writeback without the congestion wait.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/aops.c |   12 ------------
 1 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index dce062a..7b8da94 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -269,7 +269,6 @@ static int gfs2_write_jdata_pagevec(struct address_space *mapping,
 	pgoff_t end_index = i_size >> PAGE_CACHE_SHIFT;
 	unsigned offset = i_size & (PAGE_CACHE_SIZE-1);
 	unsigned nrblocks = nr_pages * (PAGE_CACHE_SIZE/inode->i_sb->s_blocksize);
-	struct backing_dev_info *bdi = mapping->backing_dev_info;
 	int i;
 	int ret;
 
@@ -313,11 +312,6 @@ static int gfs2_write_jdata_pagevec(struct address_space *mapping,
 
 		if (ret || (--(wbc->nr_to_write) <= 0))
 			ret = 1;
-		if (wbc->nonblocking && bdi_write_congested(bdi)) {
-			wbc->encountered_congestion = 1;
-			ret = 1;
-		}
-
 	}
 	gfs2_trans_end(sdp);
 	return ret;
@@ -338,7 +332,6 @@ static int gfs2_write_jdata_pagevec(struct address_space *mapping,
 static int gfs2_write_cache_jdata(struct address_space *mapping,
 				  struct writeback_control *wbc)
 {
-	struct backing_dev_info *bdi = mapping->backing_dev_info;
 	int ret = 0;
 	int done = 0;
 	struct pagevec pvec;
@@ -348,11 +341,6 @@ static int gfs2_write_cache_jdata(struct address_space *mapping,
 	int scanned = 0;
 	int range_whole = 0;
 
-	if (wbc->nonblocking && bdi_write_congested(bdi)) {
-		wbc->encountered_congestion = 1;
-		return 0;
-	}
-
 	pagevec_init(&pvec, 0);
 	if (wbc->range_cyclic) {
 		index = mapping->writeback_index; /* Start from prev offset */
-- 
1.6.2.5

