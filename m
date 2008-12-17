Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1757603AbYLQM36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757603AbYLQM36 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 07:29:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751920AbYLQM3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 07:29:09 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53728 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751810AbYLQM3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 07:29:07 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 03/24] GFS2: Fix up jdata writepage/delete_inode
Date: Wed, 17 Dec 2008 11:30:02 +0000
Message-Id: <1229513423-19105-4-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1229513423-19105-3-git-send-email-swhiteho@redhat.com>
References: <1229513423-19105-1-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-2-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-3-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

There is a bug in writepage and delete_inode which allows jdata files to
invalidate pages from the address space without being in a transaction at
the time. This causes problems in case the pages are in the journal. This
patch fixes that case and prevents the resulting oops.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/ops_address.c b/fs/gfs2/ops_address.c
index 2756381..44a373b 100644
--- a/fs/gfs2/ops_address.c
+++ b/fs/gfs2/ops_address.c
@@ -210,25 +210,23 @@ static int gfs2_jdata_writepage(struct page *page, struct writeback_control *wbc
 {
 	struct inode *inode = page->mapping->host;
 	struct gfs2_sbd *sdp = GFS2_SB(inode);
-	int error;
+	int ret;
 	int done_trans = 0;
 
-	error = gfs2_writepage_common(page, wbc);
-	if (error <= 0)
-		return error;
-
 	if (PageChecked(page)) {
 		if (wbc->sync_mode != WB_SYNC_ALL)
 			goto out_ignore;
-		error = gfs2_trans_begin(sdp, RES_DINODE + 1, 0);
-		if (error)
+		ret = gfs2_trans_begin(sdp, RES_DINODE + 1, 0);
+		if (ret)
 			goto out_ignore;
 		done_trans = 1;
 	}
-	error = __gfs2_jdata_writepage(page, wbc);
+	ret = gfs2_writepage_common(page, wbc);
+	if (ret > 0)
+		ret = __gfs2_jdata_writepage(page, wbc);
 	if (done_trans)
 		gfs2_trans_end(sdp);
-	return error;
+	return ret;
 
 out_ignore:
 	redirty_page_for_writepage(wbc, page);
diff --git a/fs/gfs2/ops_super.c b/fs/gfs2/ops_super.c
index 9c7678d..2cb744b 100644
--- a/fs/gfs2/ops_super.c
+++ b/fs/gfs2/ops_super.c
@@ -493,7 +493,7 @@ static void gfs2_delete_inode(struct inode *inode)
 	gfs2_holder_reinit(LM_ST_EXCLUSIVE, LM_FLAG_TRY_1CB | GL_NOCACHE, &ip->i_iopen_gh);
 	error = gfs2_glock_nq(&ip->i_iopen_gh);
 	if (error)
-		goto out_uninit;
+		goto out_truncate;
 
 	if (S_ISDIR(inode->i_mode) &&
 	    (ip->i_di.di_flags & GFS2_DIF_EXHASH)) {
@@ -518,6 +518,7 @@ static void gfs2_delete_inode(struct inode *inode)
 	if (error)
 		goto out_unlock;
 
+out_truncate:
 	error = gfs2_trans_begin(sdp, 0, sdp->sd_jdesc->jd_blocks);
 	if (error)
 		goto out_unlock;
@@ -526,8 +527,8 @@ static void gfs2_delete_inode(struct inode *inode)
 	gfs2_trans_end(sdp);
 
 out_unlock:
-	gfs2_glock_dq(&ip->i_iopen_gh);
-out_uninit:
+	if (test_bit(HIF_HOLDER, &ip->i_iopen_gh.gh_iflags))
+		gfs2_glock_dq(&ip->i_iopen_gh);
 	gfs2_holder_uninit(&ip->i_iopen_gh);
 	gfs2_glock_dq_uninit(&gh);
 	if (error && error != GLR_TRYFAILED)
-- 
1.6.0.3

