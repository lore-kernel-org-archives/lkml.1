Return-Path: <linux-kernel-owner+w=401wt.eu-S933887AbYDQJxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933887AbYDQJxe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:53:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933742AbYDQJ0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:26:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46248 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933747AbYDQJ0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:26:38 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Abhijith Das <adas@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 41/48] [GFS2] gfs2_adjust_quota has broken unstuffing code
Date: Thu, 17 Apr 2008 09:39:17 +0100
Message-Id: <12084216533319-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12084216511207-git-send-email-swhiteho@redhat.com>
References: 12084214272083-git-send-email-swhiteho@redhat.com
 <12084215642582-git-send-email-swhiteho@redhat.com>
 <1208421571478-git-send-email-swhiteho@redhat.com>
 <12084215742081-git-send-email-swhiteho@redhat.com>
 <12084215763647-git-send-email-swhiteho@redhat.com>
 <12084215781246-git-send-email-swhiteho@redhat.com>
 <12084215802470-git-send-email-swhiteho@redhat.com>
 <12084215833555-git-send-email-swhiteho@redhat.com>
 <12084215851158-git-send-email-swhiteho@redhat.com>
 <120842158797-git-send-email-swhiteho@redhat.com>
 <12084215891940-git-send-email-swhiteho@redhat.com>
 <12084215913125-git-send-email-swhiteho@redhat.com>
 <12084215931509-git-send-email-swhiteho@redhat.com>
 <12084215961690-git-send-email-swhiteho@redhat.com>
 <1208421597980-git-send-email-swhiteho@redhat.com>
 <12084216003676-git-send-email-swhiteho@redhat.com>
 <12084216023999-git-send-email-swhiteho@redhat.com>
 <12084216044123-git-send-email-swhiteho@redhat.com>
 <12084216061172-git-send-email-swhiteho@redhat.com>
 <12084216082638-git-send-email-swhiteho@redhat.com>
 <12084216101961-git-send-email-swhiteho@redhat.com>
 <12084216121811-git-send-email-swhiteho@redhat.com>
 <12084216153016-git-send-email-swhiteho@redhat.com>
 <1208421617421-git-send-email-swhiteho@redhat.com>
 <12084216182363-git-send-email-swhiteho@redhat.com>
 <12084216204027-git-send-email-swhiteho@redhat.com>
 <12084216222853-git-send-email-swhiteho@redhat.com>
 <12084216241802-git-send-email-swhiteho@redhat.com>
 <12084216262937-git-send-email-swhiteho@redhat.com>
 <12084216281152-git-send-email-swhiteho@redhat.com>
 <12084216301107-git-send-email-swhiteho@redhat.com>
 <12084216323165-git-send-email-swhiteho@redhat.com>
 <1208421634101-git-send-email-swhiteho@redhat.com>
 <12084216372363-git-send-email-swhiteho@redhat.com>
 <12084216391215-git-send-email-swhiteho@redhat.com>
 <12084216402644-git-send-email-swhiteho@redhat.com>
 <12084216431261-git-send-email-swhiteho@redhat.com>
 <1208421645785-git-send-email-swhiteho@redhat.com>
 <1208421647805-git-send-email-swhiteho@redhat.com>
 <12084216494161-git-send-email-swhiteho@redhat.com>
 <12084216511207-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abhijith Das <adas@redhat.com>

This patch combines the 2 patches in bug 434736 to correct the lock
ordering in the unstuffing of the quota inode in gfs2_adjust_quota and
adjusting the number of revokes in gfs2_write_jdata_pagevec

Signed-off-by: Abhijith Das <adas@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/ops_address.c b/fs/gfs2/ops_address.c
index 2483d87..e72fd47 100644
--- a/fs/gfs2/ops_address.c
+++ b/fs/gfs2/ops_address.c
@@ -21,7 +21,6 @@
 #include <linux/gfs2_ondisk.h>
 #include <linux/lm_interface.h>
 #include <linux/backing-dev.h>
-#include <linux/pagevec.h>
 
 #include "gfs2.h"
 #include "incore.h"
@@ -278,7 +277,7 @@ static int gfs2_write_jdata_pagevec(struct address_space *mapping,
 	int i;
 	int ret;
 
-	ret = gfs2_trans_begin(sdp, nrblocks, 0);
+	ret = gfs2_trans_begin(sdp, nrblocks, nrblocks);
 	if (ret < 0)
 		return ret;
 
diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 636bccf..c71f781 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -616,17 +616,9 @@ static int gfs2_adjust_quota(struct gfs2_inode *ip, loff_t loc,
 	s64 value;
 	int err = -EIO;
 
-	if (gfs2_is_stuffed(ip)) {
-		struct gfs2_alloc *al = gfs2_alloc_get(ip);
-		if (!al)
-			return -ENOMEM;
-		/* just request 1 blk */
-		al->al_requested = 1;
-		gfs2_inplace_reserve(ip);
+	if (gfs2_is_stuffed(ip))
 		gfs2_unstuff_dinode(ip, NULL);
-		gfs2_inplace_release(ip);
-		gfs2_alloc_put(ip);
-	}
+	
 	page = grab_cache_page(mapping, index);
 	if (!page)
 		return -ENOMEM;
@@ -691,7 +683,7 @@ static int do_sync(unsigned int num_qd, struct gfs2_quota_data **qda)
 	unsigned int qx, x;
 	struct gfs2_quota_data *qd;
 	loff_t offset;
-	unsigned int nalloc = 0;
+	unsigned int nalloc = 0, blocks;
 	struct gfs2_alloc *al = NULL;
 	int error;
 
@@ -728,34 +720,33 @@ static int do_sync(unsigned int num_qd, struct gfs2_quota_data **qda)
 			nalloc++;
 	}
 
-	if (nalloc) {
-		al = gfs2_alloc_get(ip);
-		if (!al) {
-			error = -ENOMEM;
-			goto out_gunlock;
-		}
+	al = gfs2_alloc_get(ip);
+	if (!al) {
+		error = -ENOMEM;
+		goto out_gunlock;
+	}
+	/* 
+	 * 1 blk for unstuffing inode if stuffed. We add this extra
+	 * block to the reservation unconditionally. If the inode
+	 * doesn't need unstuffing, the block will be released to the 
+	 * rgrp since it won't be allocated during the transaction
+	 */
+	al->al_requested = 1;
+	/* +1 in the end for block requested above for unstuffing */
+	blocks = num_qd * data_blocks + RES_DINODE + num_qd + 1;
 
-		al->al_requested = nalloc * (data_blocks + ind_blocks);
+	if (nalloc)
+		al->al_requested += nalloc * (data_blocks + ind_blocks);		
+	error = gfs2_inplace_reserve(ip);
+	if (error)
+		goto out_alloc;
 
-		error = gfs2_inplace_reserve(ip);
-		if (error)
-			goto out_alloc;
-
-		error = gfs2_trans_begin(sdp,
-					 al->al_rgd->rd_length +
-					 num_qd * data_blocks +
-					 nalloc * ind_blocks +
-					 RES_DINODE + num_qd +
-					 RES_STATFS, 0);
-		if (error)
-			goto out_ipres;
-	} else {
-		error = gfs2_trans_begin(sdp,
-					 num_qd * data_blocks +
-					 RES_DINODE + num_qd, 0);
-		if (error)
-			goto out_gunlock;
-	}
+	if (nalloc)
+		blocks += al->al_rgd->rd_length + nalloc * ind_blocks + RES_STATFS;
+
+	error = gfs2_trans_begin(sdp, blocks, 0);
+	if (error)
+		goto out_ipres;
 
 	for (x = 0; x < num_qd; x++) {
 		qd = qda[x];
@@ -774,11 +765,9 @@ static int do_sync(unsigned int num_qd, struct gfs2_quota_data **qda)
 out_end_trans:
 	gfs2_trans_end(sdp);
 out_ipres:
-	if (nalloc)
-		gfs2_inplace_release(ip);
+	gfs2_inplace_release(ip);
 out_alloc:
-	if (nalloc)
-		gfs2_alloc_put(ip);
+	gfs2_alloc_put(ip);
 out_gunlock:
 	gfs2_glock_dq_uninit(&i_gh);
 out:
-- 
1.5.1.2

