Return-Path: <linux-kernel-owner+w=401wt.eu-S1761075AbYAUKGB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761075AbYAUKGB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 05:06:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759466AbYAUKCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 05:02:14 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35756 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759281AbYAUKCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 05:02:07 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 10/58] [GFS2] Don't hold page lock when starting transaction
Date: Mon, 21 Jan 2008 09:21:28 +0000
Message-Id: <12009073591688-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12009073571991-git-send-email-swhiteho@redhat.com>
References: <1200907336293-git-send-email-swhiteho@redhat.com>
 <12009073443813-git-send-email-swhiteho@redhat.com>
 <12009073453549-git-send-email-swhiteho@redhat.com>
 <1200907348435-git-send-email-swhiteho@redhat.com>
 <12009073492811-git-send-email-swhiteho@redhat.com>
 <12009073512300-git-send-email-swhiteho@redhat.com>
 <12009073531216-git-send-email-swhiteho@redhat.com>
 <12009073542596-git-send-email-swhiteho@redhat.com>
 <1200907356883-git-send-email-swhiteho@redhat.com>
 <12009073571991-git-send-email-swhiteho@redhat.com>
Message-Id: <c43aab67fce17cfb5b5ce2df6364cd915ff9b743.1200905287.git.swhiteho@redhat.com>
In-Reply-To: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
References: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

This is an addendum to the new AOPs work which moves the point
at which we take the page lock so that we don't get it until
the last possible moment. This resolves a conflict between
starting transactions and the page lock.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/ops_address.c b/fs/gfs2/ops_address.c
index 48913e5..ae782d2 100644
--- a/fs/gfs2/ops_address.c
+++ b/fs/gfs2/ops_address.c
@@ -657,18 +657,10 @@ static int gfs2_write_begin(struct file *file, struct address_space *mapping,
 	if (unlikely(error))
 		goto out_uninit;
 
-	error = -ENOMEM;
-	page = __grab_cache_page(mapping, index);
-	*pagep = page;
-	if (!page)
-		goto out_unlock;
-
 	gfs2_write_calc_reserv(ip, len, &data_blocks, &ind_blocks);
-
 	error = gfs2_write_alloc_required(ip, pos, len, &alloc_required);
 	if (error)
-		goto out_putpage;
-
+		goto out_unlock;
 
 	ip->i_alloc.al_requested = 0;
 	if (alloc_required) {
@@ -699,40 +691,47 @@ static int gfs2_write_begin(struct file *file, struct address_space *mapping,
 	if (error)
 		goto out_trans_fail;
 
+	error = -ENOMEM;
+	page = __grab_cache_page(mapping, index);
+	*pagep = page;
+	if (unlikely(!page))
+		goto out_endtrans;
+
 	if (gfs2_is_stuffed(ip)) {
+		error = 0;
 		if (pos + len > sdp->sd_sb.sb_bsize - sizeof(struct gfs2_dinode)) {
 			error = gfs2_unstuff_dinode(ip, page);
 			if (error == 0)
 				goto prepare_write;
-		} else if (!PageUptodate(page))
+		} else if (!PageUptodate(page)) {
 			error = stuffed_readpage(ip, page);
+		}
 		goto out;
 	}
 
 prepare_write:
 	error = block_prepare_write(page, from, to, gfs2_get_block);
-
 out:
-	if (error) {
-		gfs2_trans_end(sdp);
+	if (error == 0)
+		return 0;
+
+	page_cache_release(page);
+	if (pos + len > ip->i_inode.i_size)
+		vmtruncate(&ip->i_inode, ip->i_inode.i_size);
+out_endtrans:
+	gfs2_trans_end(sdp);
 out_trans_fail:
-		if (alloc_required) {
-			gfs2_inplace_release(ip);
+	if (alloc_required) {
+		gfs2_inplace_release(ip);
 out_qunlock:
-			gfs2_quota_unlock(ip);
+		gfs2_quota_unlock(ip);
 out_alloc_put:
-			gfs2_alloc_put(ip);
-		}
-out_putpage:
-		page_cache_release(page);
-		if (pos + len > ip->i_inode.i_size)
-			vmtruncate(&ip->i_inode, ip->i_inode.i_size);
+		gfs2_alloc_put(ip);
+	}
 out_unlock:
-		gfs2_glock_dq_m(1, &ip->i_gh);
+	gfs2_glock_dq(&ip->i_gh);
 out_uninit:
-		gfs2_holder_uninit(&ip->i_gh);
-	}
-
+	gfs2_holder_uninit(&ip->i_gh);
 	return error;
 }
 
-- 
1.5.1.2

