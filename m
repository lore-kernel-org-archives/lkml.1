Return-Path: <linux-kernel-owner+w=401wt.eu-S1756584AbYLSWAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584AbYLSWAo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 17:00:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755076AbYLSVyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 16:54:40 -0500
Received: from cantor.suse.de ([195.135.220.2]:58004 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755028AbYLSVyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 16:54:40 -0500
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>,
       Tao Ma <tao.ma@oracle.com>, Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 18/45] ocfs2/xattr: Move clusters free into dealloc.
Date: Fri, 19 Dec 2008 13:53:37 -0800
Message-Id: <1229723644-13630-19-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1229723644-13630-1-git-send-email-mfasheh@suse.com>
References: <1229723644-13630-1-git-send-email-mfasheh@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tao Ma <tao.ma@oracle.com>

Move clusters free process into dealloc context so that
they can be freed after the transaction.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/xattr.c |   14 +-------------
 1 files changed, 1 insertions(+), 13 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 4501c63..f1da381 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -457,7 +457,6 @@ static int __ocfs2_remove_xattr_range(struct inode *inode,
 	int ret;
 	u64 phys_blkno = ocfs2_clusters_to_blocks(inode->i_sb, phys_cpos);
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
-	struct inode *tl_inode = osb->osb_tl_inode;
 	handle_t *handle;
 	struct ocfs2_alloc_context *meta_ac = NULL;
 	struct ocfs2_extent_tree et;
@@ -470,16 +469,6 @@ static int __ocfs2_remove_xattr_range(struct inode *inode,
 		return ret;
 	}
 
-	mutex_lock(&tl_inode->i_mutex);
-
-	if (ocfs2_truncate_log_needs_flush(osb)) {
-		ret = __ocfs2_flush_truncate_log(osb);
-		if (ret < 0) {
-			mlog_errno(ret);
-			goto out;
-		}
-	}
-
 	handle = ocfs2_start_trans(osb, OCFS2_REMOVE_EXTENT_CREDITS);
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
@@ -509,14 +498,13 @@ static int __ocfs2_remove_xattr_range(struct inode *inode,
 		goto out_commit;
 	}
 
-	ret = ocfs2_truncate_log_append(osb, handle, phys_blkno, len);
+	ret = ocfs2_cache_cluster_dealloc(dealloc, phys_blkno, len);
 	if (ret)
 		mlog_errno(ret);
 
 out_commit:
 	ocfs2_commit_trans(osb, handle);
 out:
-	mutex_unlock(&tl_inode->i_mutex);
 
 	if (meta_ac)
 		ocfs2_free_alloc_context(meta_ac);
-- 
1.5.6

