Return-Path: <linux-kernel-owner+w=401wt.eu-S1756893AbYLSWCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893AbYLSWCT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 17:02:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755208AbYLSVyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 16:54:51 -0500
Received: from mx1.suse.de ([195.135.220.2]:58016 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753263AbYLSVyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 16:54:50 -0500
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>,
       Tiger Yang <tiger.yang@oracle.com>, Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 23/45] ocfs2: add ocfs2_xattr_set_handle
Date: Fri, 19 Dec 2008 13:53:42 -0800
Message-Id: <1229723644-13630-24-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1229723644-13630-1-git-send-email-mfasheh@suse.com>
References: <1229723644-13630-1-git-send-email-mfasheh@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tiger Yang <tiger.yang@oracle.com>

This function is used to set xattr's in a started transaction. It is only
called during inode creation inode for initial security/acl xattrs of the
new inode. These xattrs could be put into ibody or extent block, so xattr
bucket would not be use in this case.

Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/xattr.c |   68 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/xattr.h |    4 +++
 2 files changed, 72 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 7a90892..6480254 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -2326,6 +2326,74 @@ out:
 }
 
 /*
+ * This function only called duing creating inode
+ * for init security/acl xattrs of the new inode.
+ * The xattrs could be put into ibody or extent block,
+ * xattr bucket would not be use in this case.
+ * transanction credits also be reserved in here.
+ */
+int ocfs2_xattr_set_handle(handle_t *handle,
+			   struct inode *inode,
+			   struct buffer_head *di_bh,
+			   int name_index,
+			   const char *name,
+			   const void *value,
+			   size_t value_len,
+			   int flags,
+			   struct ocfs2_alloc_context *meta_ac,
+			   struct ocfs2_alloc_context *data_ac)
+{
+	struct ocfs2_dinode *di;
+	int ret;
+
+	struct ocfs2_xattr_info xi = {
+		.name_index = name_index,
+		.name = name,
+		.value = value,
+		.value_len = value_len,
+	};
+
+	struct ocfs2_xattr_search xis = {
+		.not_found = -ENODATA,
+	};
+
+	struct ocfs2_xattr_search xbs = {
+		.not_found = -ENODATA,
+	};
+
+	struct ocfs2_xattr_set_ctxt ctxt = {
+		.handle = handle,
+		.meta_ac = meta_ac,
+		.data_ac = data_ac,
+	};
+
+	if (!ocfs2_supports_xattr(OCFS2_SB(inode->i_sb)))
+		return -EOPNOTSUPP;
+
+	xis.inode_bh = xbs.inode_bh = di_bh;
+	di = (struct ocfs2_dinode *)di_bh->b_data;
+
+	down_write(&OCFS2_I(inode)->ip_xattr_sem);
+
+	ret = ocfs2_xattr_ibody_find(inode, name_index, name, &xis);
+	if (ret)
+		goto cleanup;
+	if (xis.not_found) {
+		ret = ocfs2_xattr_block_find(inode, name_index, name, &xbs);
+		if (ret)
+			goto cleanup;
+	}
+
+	ret = __ocfs2_xattr_set_handle(inode, di, &xi, &xis, &xbs, &ctxt);
+
+cleanup:
+	up_write(&OCFS2_I(inode)->ip_xattr_sem);
+	brelse(xbs.xattr_bh);
+
+	return ret;
+}
+
+/*
  * ocfs2_xattr_set()
  *
  * Set, replace or remove an extended attribute for this inode.
diff --git a/fs/ocfs2/xattr.h b/fs/ocfs2/xattr.h
index 1d8314c..8fbdc16 100644
--- a/fs/ocfs2/xattr.h
+++ b/fs/ocfs2/xattr.h
@@ -37,6 +37,10 @@ extern struct xattr_handler *ocfs2_xattr_handlers[];
 ssize_t ocfs2_listxattr(struct dentry *, char *, size_t);
 int ocfs2_xattr_set(struct inode *, int, const char *, const void *,
 		    size_t, int);
+int ocfs2_xattr_set_handle(handle_t *, struct inode *, struct buffer_head *,
+			   int, const char *, const void *, size_t, int,
+			   struct ocfs2_alloc_context *,
+			   struct ocfs2_alloc_context *);
 int ocfs2_xattr_remove(struct inode *, struct buffer_head *);
 
 #endif /* OCFS2_XATTR_H */
-- 
1.5.6

