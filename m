Return-Path: <linux-kernel-owner+w=401wt.eu-S1753434AbYLYSRJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434AbYLYSRJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 13:17:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021AbYLYSFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 13:05:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33784 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752092AbYLYSFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 13:05:53 -0500
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>,
       Tiger Yang <tiger.yang@oracle.com>, Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 34/35] ocfs2: alloc xattr bucket in ocfs2_xattr_set_handle
Date: Thu, 25 Dec 2008 10:04:49 -0800
Message-Id: <1230228290-22803-35-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1230228290-22803-1-git-send-email-mfasheh@suse.com>
References: <1230228290-22803-1-git-send-email-mfasheh@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tiger Yang <tiger.yang@oracle.com>

In extreme situation, may need xattr bucket for setting
security entry and acl entries during mknod. This only
happens when block size is too small.

Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/xattr.c |   18 +++++++++++++++---
 1 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index e5be470..095b0bb 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -2611,9 +2611,7 @@ out:
 /*
  * This function only called duing creating inode
  * for init security/acl xattrs of the new inode.
- * The xattrs could be put into ibody or extent block,
- * xattr bucket would not be use in this case.
- * transanction credits also be reserved in here.
+ * All transanction credits have been reserved in mknod.
  */
 int ocfs2_xattr_set_handle(handle_t *handle,
 			   struct inode *inode,
@@ -2653,6 +2651,19 @@ int ocfs2_xattr_set_handle(handle_t *handle,
 	if (!ocfs2_supports_xattr(OCFS2_SB(inode->i_sb)))
 		return -EOPNOTSUPP;
 
+	/*
+	 * In extreme situation, may need xattr bucket when
+	 * block size is too small. And we have already reserved
+	 * the credits for bucket in mknod.
+	 */
+	if (inode->i_sb->s_blocksize == OCFS2_MIN_BLOCKSIZE) {
+		xbs.bucket = ocfs2_xattr_bucket_new(inode);
+		if (!xbs.bucket) {
+			mlog_errno(-ENOMEM);
+			return -ENOMEM;
+		}
+	}
+
 	xis.inode_bh = xbs.inode_bh = di_bh;
 	di = (struct ocfs2_dinode *)di_bh->b_data;
 
@@ -2672,6 +2683,7 @@ int ocfs2_xattr_set_handle(handle_t *handle,
 cleanup:
 	up_write(&OCFS2_I(inode)->ip_xattr_sem);
 	brelse(xbs.xattr_bh);
+	ocfs2_xattr_bucket_free(xbs.bucket);
 
 	return ret;
 }
-- 
1.5.6

