Return-Path: <linux-kernel-owner+w=401wt.eu-S932333AbXAXUVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932333AbXAXUVH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 15:21:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932332AbXAXUUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 15:20:44 -0500
Received: from dsl081-065-125.sfo1.dsl.speakeasy.net ([64.81.65.125]:57419
	"EHLO lade.trondhjem.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932231AbXAXUUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 15:20:40 -0500
From: Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [PATCH 2/3] NFS: Fix races in nfs_revalidate_mapping()
Date: Wed, 24 Jan 2007 11:54:55 -0800
To: torvalds@osdl.org, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, nfs@lists.sourceforge.net, sds@tycho.nsa.gov
Message-Id: <20070124195455.21259.4066.stgit@lade.trondhjem.org>
In-Reply-To: <20070124195307.21259.64156.stgit@lade.trondhjem.org>
References: <20070124195307.21259.64156.stgit@lade.trondhjem.org>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
User-Agent: StGIT/0.9
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Trond Myklebust <Trond.Myklebust@netapp.com>

Prevent the call to invalidate_inode_pages2() from racing with file writes
by taking the inode->i_mutex across the page cache flush and invalidate.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---

 fs/nfs/dir.c           |    2 -
 fs/nfs/inode.c         |   97 +++++++++++++++++++++++++++++++++---------------
 fs/nfs/symlink.c       |    4 +-
 include/linux/nfs_fs.h |    1 
 4 files changed, 72 insertions(+), 32 deletions(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index dee3d6c..d9ba8cb 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -532,7 +532,7 @@ static int nfs_readdir(struct file *filp
 
 	lock_kernel();
 
-	res = nfs_revalidate_mapping(inode, filp->f_mapping);
+	res = nfs_revalidate_mapping_nolock(inode, filp->f_mapping);
 	if (res < 0) {
 		unlock_kernel();
 		return res;
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 63e4702..d834982 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -665,49 +665,86 @@ int nfs_revalidate_inode(struct nfs_serv
 	return __nfs_revalidate_inode(server, inode);
 }
 
+static int nfs_invalidate_mapping_nolock(struct inode *inode, struct address_space *mapping)
+{
+	struct nfs_inode *nfsi = NFS_I(inode);
+	
+	if (mapping->nrpages != 0) {
+		int ret = invalidate_inode_pages2(mapping);
+		if (ret < 0)
+			return ret;
+	}
+	spin_lock(&inode->i_lock);
+	nfsi->cache_validity &= ~NFS_INO_INVALID_DATA;
+	if (S_ISDIR(inode->i_mode)) {
+		memset(nfsi->cookieverf, 0, sizeof(nfsi->cookieverf));
+		/* This ensures we revalidate child dentries */
+		nfsi->cache_change_attribute = jiffies;
+	}
+	spin_unlock(&inode->i_lock);
+	nfs_inc_stats(inode, NFSIOS_DATAINVALIDATE);
+	dfprintk(PAGECACHE, "NFS: (%s/%Ld) data cache invalidated\n",
+			inode->i_sb->s_id, (long long)NFS_FILEID(inode));
+	return 0;
+}
+
+static int nfs_invalidate_mapping(struct inode *inode, struct address_space *mapping)
+{
+	int ret = 0;
+
+	mutex_lock(&inode->i_mutex);
+	if (NFS_I(inode)->cache_validity & NFS_INO_INVALID_DATA) {
+		ret = nfs_sync_mapping(mapping);
+		if (ret == 0)
+			ret = nfs_invalidate_mapping_nolock(inode, mapping);
+	}
+	mutex_unlock(&inode->i_mutex);
+	return ret;
+}
+
 /**
- * nfs_revalidate_mapping - Revalidate the pagecache
+ * nfs_revalidate_mapping_nolock - Revalidate the pagecache
  * @inode - pointer to host inode
  * @mapping - pointer to mapping
  */
-int nfs_revalidate_mapping(struct inode *inode, struct address_space *mapping)
+int nfs_revalidate_mapping_nolock(struct inode *inode, struct address_space *mapping)
 {
 	struct nfs_inode *nfsi = NFS_I(inode);
 	int ret = 0;
 
-	if (NFS_STALE(inode))
-		ret = -ESTALE;
 	if ((nfsi->cache_validity & NFS_INO_REVAL_PAGECACHE)
-			|| nfs_attribute_timeout(inode))
+			|| nfs_attribute_timeout(inode) || NFS_STALE(inode)) {
 		ret = __nfs_revalidate_inode(NFS_SERVER(inode), inode);
-	if (ret < 0)
-		goto out;
+		if (ret < 0)
+			goto out;
+	}
+	if (nfsi->cache_validity & NFS_INO_INVALID_DATA)
+		ret = nfs_invalidate_mapping_nolock(inode, mapping);
+out:
+	return ret;
+}
 
-	if (nfsi->cache_validity & NFS_INO_INVALID_DATA) {
-		if (mapping->nrpages != 0) {
-			if (S_ISREG(inode->i_mode)) {
-				ret = nfs_sync_mapping(mapping);
-				if (ret < 0)
-					goto out;
-			}
-			ret = invalidate_inode_pages2(mapping);
-			if (ret < 0)
-				goto out;
-		}
-		spin_lock(&inode->i_lock);
-		nfsi->cache_validity &= ~NFS_INO_INVALID_DATA;
-		if (S_ISDIR(inode->i_mode)) {
-			memset(nfsi->cookieverf, 0, sizeof(nfsi->cookieverf));
-			/* This ensures we revalidate child dentries */
-			nfsi->cache_change_attribute = jiffies;
-		}
-		spin_unlock(&inode->i_lock);
+/**
+ * nfs_revalidate_mapping - Revalidate the pagecache
+ * @inode - pointer to host inode
+ * @mapping - pointer to mapping
+ *
+ * This version of the function will take the inode->i_mutex and attempt to
+ * flush out all dirty data if it needs to invalidate the page cache.
+ */
+int nfs_revalidate_mapping(struct inode *inode, struct address_space *mapping)
+{
+	struct nfs_inode *nfsi = NFS_I(inode);
+	int ret = 0;
 
-		nfs_inc_stats(inode, NFSIOS_DATAINVALIDATE);
-		dfprintk(PAGECACHE, "NFS: (%s/%Ld) data cache invalidated\n",
-				inode->i_sb->s_id,
-				(long long)NFS_FILEID(inode));
+	if ((nfsi->cache_validity & NFS_INO_REVAL_PAGECACHE)
+			|| nfs_attribute_timeout(inode) || NFS_STALE(inode)) {
+		ret = __nfs_revalidate_inode(NFS_SERVER(inode), inode);
+		if (ret < 0)
+			goto out;
 	}
+	if (nfsi->cache_validity & NFS_INO_INVALID_DATA)
+		ret = nfs_invalidate_mapping(inode, mapping);
 out:
 	return ret;
 }
diff --git a/fs/nfs/symlink.c b/fs/nfs/symlink.c
index 6c68611..525c136 100644
--- a/fs/nfs/symlink.c
+++ b/fs/nfs/symlink.c
@@ -50,7 +50,9 @@ static void *nfs_follow_link(struct dent
 {
 	struct inode *inode = dentry->d_inode;
 	struct page *page;
-	void *err = ERR_PTR(nfs_revalidate_mapping(inode, inode->i_mapping));
+	void *err;
+
+	err = ERR_PTR(nfs_revalidate_mapping_nolock(inode, inode->i_mapping));
 	if (err)
 		goto read_failed;
 	page = read_cache_page(&inode->i_data, 0,
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index 0496306..c5d4084 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -308,6 +308,7 @@ extern int nfs_attribute_timeout(struct 
 extern int nfs_revalidate_inode(struct nfs_server *server, struct inode *inode);
 extern int __nfs_revalidate_inode(struct nfs_server *, struct inode *);
 extern int nfs_revalidate_mapping(struct inode *inode, struct address_space *mapping);
+extern int nfs_revalidate_mapping_nolock(struct inode *inode, struct address_space *mapping);
 extern int nfs_setattr(struct dentry *, struct iattr *);
 extern void nfs_setattr_update_inode(struct inode *inode, struct iattr *attr);
 extern void nfs_begin_attr_update(struct inode *);
