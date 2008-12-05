Return-Path: <linux-kernel-owner+w=401wt.eu-S1755502AbYLEQYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502AbYLEQYQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 11:24:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846AbYLEQYC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 11:24:02 -0500
Received: from mx2.redhat.com ([66.187.237.31]:32877 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242AbYLEQYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 11:24:00 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] EXPORTFS: Don't return NULL from
	fh_to_dentry()/fh_to_parent() [ver #4]
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: dhowells@redhat.com, bfields@fieldses.org, hugh@veritas.com,
       hch@infradead.org, linux-kernel@vger.kernel.org
Date: Fri, 05 Dec 2008 16:23:18 +0000
Message-ID: <20081205162318.20732.73054.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Returning NULL from fh_to_dentry() and fh_to_parent() is not permitted, so
return -ESTALE instead.  exportfs_decode_fh() does not check for NULL, but
will try to dereference it as IS_ERR() does not check for it.

The generic_fh_to_dentry() and generic_fh_to_parent() functions also no longer
return NULL, but return -ESTALE instead.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: J. Bruce Fields <bfields@citi.umich.edu>
---

 fs/fat/inode.c                |    2 +-
 fs/fuse/inode.c               |    4 ++--
 fs/gfs2/ops_export.c          |    4 ++--
 fs/isofs/export.c             |    4 ++--
 fs/libfs.c                    |    4 ++--
 fs/ocfs2/export.c             |    4 ++--
 fs/udf/namei.c                |    4 ++--
 fs/xfs/linux-2.6/xfs_export.c |    2 +-
 mm/shmem.c                    |   14 +++++++-------
 9 files changed, 21 insertions(+), 21 deletions(-)


diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index d937aaf..cac84f2 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -657,7 +657,7 @@ static struct dentry *fat_fh_to_dentry(struct super_block *sb,
 	u32 *fh = fid->raw;
 
 	if (fh_len < 5 || fh_type != 3)
-		return NULL;
+		return ERR_PTR(-ESTALE);
 
 	inode = ilookup(sb, fh[0]);
 	if (!inode || inode->i_generation != fh[1]) {
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 2e99f34..0eb8990 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -653,7 +653,7 @@ static struct dentry *fuse_fh_to_dentry(struct super_block *sb,
 	struct fuse_inode_handle handle;
 
 	if ((fh_type != 0x81 && fh_type != 0x82) || fh_len < 3)
-		return NULL;
+		return ERR_PTR(-ESTALE);
 
 	handle.nodeid = (u64) fid->raw[0] << 32;
 	handle.nodeid |= (u64) fid->raw[1];
@@ -667,7 +667,7 @@ static struct dentry *fuse_fh_to_parent(struct super_block *sb,
 	struct fuse_inode_handle parent;
 
 	if (fh_type != 0x82 || fh_len < 6)
-		return NULL;
+		return ERR_PTR(-ESTALE);
 
 	parent.nodeid = (u64) fid->raw[3] << 32;
 	parent.nodeid |= (u64) fid->raw[4];
diff --git a/fs/gfs2/ops_export.c b/fs/gfs2/ops_export.c
index bbb8c36..2864873 100644
--- a/fs/gfs2/ops_export.c
+++ b/fs/gfs2/ops_export.c
@@ -254,7 +254,7 @@ static struct dentry *gfs2_fh_to_dentry(struct super_block *sb, struct fid *fid,
 		this.no_addr |= be32_to_cpu(fh[3]);
 		return gfs2_get_dentry(sb, &this);
 	default:
-		return NULL;
+		return ERR_PTR(-ESTALE);
 	}
 }
 
@@ -273,7 +273,7 @@ static struct dentry *gfs2_fh_to_parent(struct super_block *sb, struct fid *fid,
 		parent.no_addr |= be32_to_cpu(fh[7]);
 		return gfs2_get_dentry(sb, &parent);
 	default:
-		return NULL;
+		return ERR_PTR(-ESTALE);
 	}
 }
 
diff --git a/fs/isofs/export.c b/fs/isofs/export.c
index e81a305..1b4ee23 100644
--- a/fs/isofs/export.c
+++ b/fs/isofs/export.c
@@ -164,7 +164,7 @@ static struct dentry *isofs_fh_to_dentry(struct super_block *sb,
 	struct isofs_fid *ifid = (struct isofs_fid *)fid;
 
 	if (fh_len < 3 || fh_type > 2)
-		return NULL;
+		return ERR_PTR(-ESTALE);
 
 	return isofs_export_iget(sb, ifid->block, ifid->offset,
 			ifid->generation);
@@ -176,7 +176,7 @@ static struct dentry *isofs_fh_to_parent(struct super_block *sb,
 	struct isofs_fid *ifid = (struct isofs_fid *)fid;
 
 	if (fh_type != 2)
-		return NULL;
+		return ERR_PTR(-ESTALE);
 
 	return isofs_export_iget(sb,
 			fh_len > 2 ? ifid->parent_block : 0,
diff --git a/fs/libfs.c b/fs/libfs.c
index e960a83..4fe5b5b 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -751,7 +751,7 @@ struct dentry *generic_fh_to_dentry(struct super_block *sb, struct fid *fid,
 	struct inode *inode = NULL;
 
 	if (fh_len < 2)
-		return NULL;
+		return ERR_PTR(-ESTALE);
 
 	switch (fh_type) {
 	case FILEID_INO32_GEN:
@@ -784,7 +784,7 @@ struct dentry *generic_fh_to_parent(struct super_block *sb, struct fid *fid,
 	struct inode *inode = NULL;
 
 	if (fh_len <= 2)
-		return NULL;
+		return ERR_PTR(-ESTALE);
 
 	switch (fh_type) {
 	case FILEID_INO32_GEN_PARENT:
diff --git a/fs/ocfs2/export.c b/fs/ocfs2/export.c
index 2f27b33..0f1c80f 100644
--- a/fs/ocfs2/export.c
+++ b/fs/ocfs2/export.c
@@ -182,7 +182,7 @@ static struct dentry *ocfs2_fh_to_dentry(struct super_block *sb,
 	struct ocfs2_inode_handle handle;
 
 	if (fh_len < 3 || fh_type > 2)
-		return NULL;
+		return ERR_PTR(-ESTALE);
 
 	handle.ih_blkno = (u64)le32_to_cpu(fid->raw[0]) << 32;
 	handle.ih_blkno |= (u64)le32_to_cpu(fid->raw[1]);
@@ -196,7 +196,7 @@ static struct dentry *ocfs2_fh_to_parent(struct super_block *sb,
 	struct ocfs2_inode_handle parent;
 
 	if (fh_type != 2 || fh_len < 6)
-		return NULL;
+		return ERR_PTR(-ESTALE);
 
 	parent.ih_blkno = (u64)le32_to_cpu(fid->raw[3]) << 32;
 	parent.ih_blkno |= (u64)le32_to_cpu(fid->raw[4]);
diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index f84bfaa..e1a1c16 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -1297,7 +1297,7 @@ static struct dentry *udf_fh_to_dentry(struct super_block *sb,
 	if ((fh_len != 3 && fh_len != 5) ||
 	    (fh_type != FILEID_UDF_WITH_PARENT &&
 	     fh_type != FILEID_UDF_WITHOUT_PARENT))
-		return NULL;
+		return ERR_PTR(-ESTALE);
 
 	return udf_nfs_get_inode(sb, fid->udf.block, fid->udf.partref,
 			fid->udf.generation);
@@ -1307,7 +1307,7 @@ static struct dentry *udf_fh_to_parent(struct super_block *sb,
 				       struct fid *fid, int fh_len, int fh_type)
 {
 	if (fh_len != 5 || fh_type != FILEID_UDF_WITH_PARENT)
-		return NULL;
+		return ERR_PTR(-ESTALE);
 
 	return udf_nfs_get_inode(sb, fid->udf.parent_block,
 				 fid->udf.parent_partref,
diff --git a/fs/xfs/linux-2.6/xfs_export.c b/fs/xfs/linux-2.6/xfs_export.c
index 7f7abec..f9a51c4 100644
--- a/fs/xfs/linux-2.6/xfs_export.c
+++ b/fs/xfs/linux-2.6/xfs_export.c
@@ -150,7 +150,7 @@ xfs_fs_fh_to_dentry(struct super_block *sb, struct fid *fid,
 	struct inode		*inode = NULL;
 
 	if (fh_len < xfs_fileid_length(fileid_type))
-		return NULL;
+		return ERR_PTR(-ESTALE);
 
 	switch (fileid_type) {
 	case FILEID_INO32_GEN_PARENT:
diff --git a/mm/shmem.c b/mm/shmem.c
index f1b0d48..c9bdbf7 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2050,21 +2050,21 @@ static struct dentry *shmem_fh_to_dentry(struct super_block *sb,
 		struct fid *fid, int fh_len, int fh_type)
 {
 	struct inode *inode;
-	struct dentry *dentry = NULL;
+	struct dentry *dentry;
 	u64 inum = fid->raw[2];
 	inum = (inum << 32) | fid->raw[1];
 
 	if (fh_len < 3)
-		return NULL;
+		return ERR_PTR(-ESTALE);
 
 	inode = ilookup5(sb, (unsigned long)(inum + fid->raw[0]),
 			shmem_match, fid->raw);
-	if (inode) {
-		dentry = d_find_alias(inode);
-		iput(inode);
-	}
+	if (!inode)
+		return ERR_PTR(-ESTALE);
 
-	return dentry;
+	dentry = d_find_alias(inode);
+	iput(inode);
+	return dentry ?: ERR_PTR(-ESTALE);
 }
 
 static int shmem_encode_fh(struct dentry *dentry, __u32 *fh, int *len,

