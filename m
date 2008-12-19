Return-Path: <linux-kernel-owner+w=401wt.eu-S1757092AbYLSWDL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757092AbYLSWDL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 17:03:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755266AbYLSVy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 16:54:57 -0500
Received: from mx2.suse.de ([195.135.220.15]:48977 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755258AbYLSVy4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 16:54:56 -0500
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>,
       Tiger Yang <tiger.yang@oracle.com>, Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 26/45] ocfs2: add ocfs2_xattr_get_nolock
Date: Fri, 19 Dec 2008 13:53:45 -0800
Message-Id: <1229723644-13630-27-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1229723644-13630-1-git-send-email-mfasheh@suse.com>
References: <1229723644-13630-1-git-send-email-mfasheh@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tiger Yang <tiger.yang@oracle.com>

This function does the work of ocfs2_xattr_get under an open lock.

Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/xattr.c |   40 ++++++++++++++++++++++++++++------------
 fs/ocfs2/xattr.h |    2 ++
 2 files changed, 30 insertions(+), 12 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 2cab0d6..ba9b870 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -925,12 +925,8 @@ cleanup:
 	return ret;
 }
 
-/* ocfs2_xattr_get()
- *
- * Copy an extended attribute into the buffer provided.
- * Buffer is NULL to compute the size of buffer required.
- */
-static int ocfs2_xattr_get(struct inode *inode,
+int ocfs2_xattr_get_nolock(struct inode *inode,
+			   struct buffer_head *di_bh,
 			   int name_index,
 			   const char *name,
 			   void *buffer,
@@ -938,7 +934,6 @@ static int ocfs2_xattr_get(struct inode *inode,
 {
 	int ret;
 	struct ocfs2_dinode *di = NULL;
-	struct buffer_head *di_bh = NULL;
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 	struct ocfs2_xattr_search xis = {
 		.not_found = -ENODATA,
@@ -953,11 +948,6 @@ static int ocfs2_xattr_get(struct inode *inode,
 	if (!(oi->ip_dyn_features & OCFS2_HAS_XATTR_FL))
 		ret = -ENODATA;
 
-	ret = ocfs2_inode_lock(inode, &di_bh, 0);
-	if (ret < 0) {
-		mlog_errno(ret);
-		return ret;
-	}
 	xis.inode_bh = xbs.inode_bh = di_bh;
 	di = (struct ocfs2_dinode *)di_bh->b_data;
 
@@ -968,6 +958,32 @@ static int ocfs2_xattr_get(struct inode *inode,
 		ret = ocfs2_xattr_block_get(inode, name_index, name, buffer,
 					    buffer_size, &xbs);
 	up_read(&oi->ip_xattr_sem);
+
+	return ret;
+}
+
+/* ocfs2_xattr_get()
+ *
+ * Copy an extended attribute into the buffer provided.
+ * Buffer is NULL to compute the size of buffer required.
+ */
+static int ocfs2_xattr_get(struct inode *inode,
+			   int name_index,
+			   const char *name,
+			   void *buffer,
+			   size_t buffer_size)
+{
+	int ret;
+	struct buffer_head *di_bh = NULL;
+
+	ret = ocfs2_inode_lock(inode, &di_bh, 0);
+	if (ret < 0) {
+		mlog_errno(ret);
+		return ret;
+	}
+	ret = ocfs2_xattr_get_nolock(inode, di_bh, name_index,
+				     name, buffer, buffer_size);
+
 	ocfs2_inode_unlock(inode, 0);
 
 	brelse(di_bh);
diff --git a/fs/ocfs2/xattr.h b/fs/ocfs2/xattr.h
index 188ef6b..86aa10f 100644
--- a/fs/ocfs2/xattr.h
+++ b/fs/ocfs2/xattr.h
@@ -43,6 +43,8 @@ extern struct xattr_handler ocfs2_xattr_security_handler;
 extern struct xattr_handler *ocfs2_xattr_handlers[];
 
 ssize_t ocfs2_listxattr(struct dentry *, char *, size_t);
+int ocfs2_xattr_get_nolock(struct inode *, struct buffer_head *, int,
+			   const char *, void *, size_t);
 int ocfs2_xattr_set(struct inode *, int, const char *, const void *,
 		    size_t, int);
 int ocfs2_xattr_set_handle(handle_t *, struct inode *, struct buffer_head *,
-- 
1.5.6

