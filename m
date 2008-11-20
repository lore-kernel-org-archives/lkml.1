Return-Path: <linux-kernel-owner+w=401wt.eu-S1758539AbYKTO4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758539AbYKTO4w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 09:56:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756536AbYKTOo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 09:44:56 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41169 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756531AbYKTOoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 09:44:54 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 36/45] NFS: Use local disk inode cache [ver #41]
To: trond.myklebust@fys.uio.no, viro@ZenIV.linux.org.uk
Cc: dhowells@redhat.com, nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Date: Thu, 20 Nov 2008 14:44:45 +0000
Message-ID: <20081120144444.10667.96676.stgit@warthog.procyon.org.uk>
In-Reply-To: <20081120144139.10667.75519.stgit@warthog.procyon.org.uk>
References: <20081120144139.10667.75519.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bind data storage objects in the local cache to NFS inodes.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/nfs/fscache.c       |  162 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nfs/fscache.h       |   13 ++++
 fs/nfs/inode.c         |    9 ++-
 include/linux/nfs_fs.h |   10 +++
 4 files changed, 193 insertions(+), 1 deletions(-)


diff --git a/fs/nfs/fscache.c b/fs/nfs/fscache.c
index ab2de2c..e3816eb 100644
--- a/fs/nfs/fscache.c
+++ b/fs/nfs/fscache.c
@@ -166,3 +166,165 @@ void nfs_fscache_release_super_cookie(struct super_block *sb)
 		nfss->fscache_key = NULL;
 	}
 }
+
+/*
+ * Initialise the per-inode cache cookie pointer for an NFS inode.
+ */
+void nfs_fscache_init_inode_cookie(struct inode *inode)
+{
+	NFS_I(inode)->fscache = NULL;
+	if (S_ISREG(inode->i_mode))
+		set_bit(NFS_INO_FSCACHE, &NFS_I(inode)->flags);
+}
+
+/*
+ * Get the per-inode cache cookie for an NFS inode.
+ */
+static void nfs_fscache_enable_inode_cookie(struct inode *inode)
+{
+	struct super_block *sb = inode->i_sb;
+	struct nfs_inode *nfsi = NFS_I(inode);
+
+	if (nfsi->fscache || !NFS_FSCACHE(inode))
+		return;
+
+	if ((NFS_SB(sb)->options & NFS_OPTION_FSCACHE)) {
+		nfsi->fscache = fscache_acquire_cookie(
+			NFS_SB(sb)->fscache,
+			&nfs_fscache_inode_object_def,
+			nfsi);
+
+		dfprintk(FSCACHE, "NFS: get FH cookie (0x%p/0x%p/0x%p)\n",
+			 sb, nfsi, nfsi->fscache);
+	}
+}
+
+/*
+ * Release a per-inode cookie.
+ */
+void nfs_fscache_release_inode_cookie(struct inode *inode)
+{
+	struct nfs_inode *nfsi = NFS_I(inode);
+
+	dfprintk(FSCACHE, "NFS: clear cookie (0x%p/0x%p)\n",
+		 nfsi, nfsi->fscache);
+
+	fscache_relinquish_cookie(nfsi->fscache, 0);
+	nfsi->fscache = NULL;
+}
+
+/*
+ * Retire a per-inode cookie, destroying the data attached to it.
+ */
+void nfs_fscache_zap_inode_cookie(struct inode *inode)
+{
+	struct nfs_inode *nfsi = NFS_I(inode);
+
+	dfprintk(FSCACHE, "NFS: zapping cookie (0x%p/0x%p)\n",
+		 nfsi, nfsi->fscache);
+
+	fscache_relinquish_cookie(nfsi->fscache, 1);
+	nfsi->fscache = NULL;
+}
+
+/*
+ * Turn off the cache with regard to a per-inode cookie if opened for writing,
+ * invalidating all the pages in the page cache relating to the associated
+ * inode to clear the per-page caching.
+ */
+static void nfs_fscache_disable_inode_cookie(struct inode *inode)
+{
+	clear_bit(NFS_INO_FSCACHE, &NFS_I(inode)->flags);
+
+	if (NFS_I(inode)->fscache) {
+		dfprintk(FSCACHE,
+			 "NFS: nfsi 0x%p turning cache off\n", NFS_I(inode));
+
+		/* Need to invalidate any mapped pages that were read in before
+		 * turning off the cache.
+		 */
+		if (inode->i_mapping && inode->i_mapping->nrpages)
+			invalidate_inode_pages2(inode->i_mapping);
+
+		nfs_fscache_zap_inode_cookie(inode);
+	}
+}
+
+/*
+ * wait_on_bit() sleep function for uninterruptible waiting
+ */
+static int nfs_fscache_wait_bit(void *flags)
+{
+	schedule();
+	return 0;
+}
+
+/*
+ * Lock against someone else trying to also acquire or relinquish a cookie
+ */
+static inline void nfs_fscache_inode_lock(struct inode *inode)
+{
+	struct nfs_inode *nfsi = NFS_I(inode);
+
+	while (test_and_set_bit(NFS_INO_FSCACHE_LOCK, &nfsi->flags))
+		wait_on_bit(&nfsi->flags, NFS_INO_FSCACHE_LOCK,
+			    nfs_fscache_wait_bit, TASK_UNINTERRUPTIBLE);
+}
+
+/*
+ * Unlock cookie management lock
+ */
+static inline void nfs_fscache_inode_unlock(struct inode *inode)
+{
+	struct nfs_inode *nfsi = NFS_I(inode);
+
+	smp_mb__before_clear_bit();
+	clear_bit(NFS_INO_FSCACHE_LOCK, &nfsi->flags);
+	smp_mb__after_clear_bit();
+	wake_up_bit(&nfsi->flags, NFS_INO_FSCACHE_LOCK);
+}
+
+/*
+ * Decide if we should enable or disable local caching for this inode.
+ * - For now, with NFS, only regular files that are open read-only will be able
+ *   to use the cache.
+ * - May be invoked multiple times in parallel by parallel nfs_open() functions.
+ */
+void nfs_fscache_set_inode_cookie(struct inode *inode, struct file *filp)
+{
+	if (NFS_FSCACHE(inode)) {
+		nfs_fscache_inode_lock(inode);
+		if ((filp->f_flags & O_ACCMODE) != O_RDONLY)
+			nfs_fscache_disable_inode_cookie(inode);
+		else
+			nfs_fscache_enable_inode_cookie(inode);
+		nfs_fscache_inode_unlock(inode);
+	}
+}
+
+/*
+ * Replace a per-inode cookie due to revalidation detecting a file having
+ * changed on the server.
+ */
+void nfs_fscache_reset_inode_cookie(struct inode *inode)
+{
+	struct nfs_inode *nfsi = NFS_I(inode);
+	struct nfs_server *nfss = NFS_SERVER(inode);
+	struct fscache_cookie *old = nfsi->fscache;
+
+	nfs_fscache_inode_lock(inode);
+	if (nfsi->fscache) {
+		/* retire the current fscache cache and get a new one */
+		fscache_relinquish_cookie(nfsi->fscache, 1);
+
+		nfsi->fscache = fscache_acquire_cookie(
+			nfss->nfs_client->fscache,
+			&nfs_fscache_inode_object_def,
+			nfsi);
+
+		dfprintk(FSCACHE,
+			 "NFS: revalidation new cookie (0x%p/0x%p/0x%p/0x%p)\n",
+			 nfss, nfsi, old, nfsi->fscache);
+	}
+	nfs_fscache_inode_unlock(inode);
+}
diff --git a/fs/nfs/fscache.h b/fs/nfs/fscache.h
index d21b590..8b4299a 100644
--- a/fs/nfs/fscache.h
+++ b/fs/nfs/fscache.h
@@ -77,6 +77,12 @@ extern void nfs_fscache_get_super_cookie(struct super_block *,
 					 struct nfs_parsed_mount_data *);
 extern void nfs_fscache_release_super_cookie(struct super_block *);
 
+extern void nfs_fscache_init_inode_cookie(struct inode *);
+extern void nfs_fscache_release_inode_cookie(struct inode *);
+extern void nfs_fscache_zap_inode_cookie(struct inode *);
+extern void nfs_fscache_set_inode_cookie(struct inode *, struct file *);
+extern void nfs_fscache_reset_inode_cookie(struct inode *);
+
 #else /* CONFIG_NFS_FSCACHE */
 static inline int nfs_fscache_register(void) { return 0; }
 static inline void nfs_fscache_unregister(void) {}
@@ -91,5 +97,12 @@ static inline void nfs_fscache_get_super_cookie(
 }
 static inline void nfs_fscache_release_super_cookie(struct super_block *sb) {}
 
+static inline void nfs_fscache_init_inode_cookie(struct inode *inode) {}
+static inline void nfs_fscache_release_inode_cookie(struct inode *inode) {}
+static inline void nfs_fscache_zap_inode_cookie(struct inode *inode) {}
+static inline void nfs_fscache_set_inode_cookie(struct inode *inode,
+						struct file *filp) {}
+static inline void nfs_fscache_reset_inode_cookie(struct inode *inode) {}
+
 #endif /* CONFIG_NFS_FSCACHE */
 #endif /* _NFS_FSCACHE_H */
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index e531341..1ef9f4b 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -110,6 +110,7 @@ void nfs_clear_inode(struct inode *inode)
 	BUG_ON(!list_empty(&NFS_I(inode)->open_files));
 	nfs_zap_acl_cache(inode);
 	nfs_access_zap_cache(inode);
+	nfs_fscache_release_inode_cookie(inode);
 }
 
 /**
@@ -329,6 +330,8 @@ nfs_fhget(struct super_block *sb, struct nfs_fh *fh, struct nfs_fattr *fattr)
 		memset(nfsi->cookieverf, 0, sizeof(nfsi->cookieverf));
 		nfsi->access_cache = RB_ROOT;
 
+		nfs_fscache_init_inode_cookie(inode);
+
 		unlock_new_inode(inode);
 	} else
 		nfs_refresh_inode(inode, fattr);
@@ -643,6 +646,7 @@ int nfs_open(struct inode *inode, struct file *filp)
 	ctx->mode = filp->f_mode;
 	nfs_file_set_open_context(filp, ctx);
 	put_nfs_open_context(ctx);
+	nfs_fscache_set_inode_cookie(inode, filp);
 	return 0;
 }
 
@@ -753,6 +757,7 @@ static int nfs_invalidate_mapping_nolock(struct inode *inode, struct address_spa
 		memset(nfsi->cookieverf, 0, sizeof(nfsi->cookieverf));
 	spin_unlock(&inode->i_lock);
 	nfs_inc_stats(inode, NFSIOS_DATAINVALIDATE);
+	nfs_fscache_reset_inode_cookie(inode);
 	dfprintk(PAGECACHE, "NFS: (%s/%Ld) data cache invalidated\n",
 			inode->i_sb->s_id, (long long)NFS_FILEID(inode));
 	return 0;
@@ -983,6 +988,7 @@ int nfs_refresh_inode(struct inode *inode, struct nfs_fattr *fattr)
 	spin_lock(&inode->i_lock);
 	status = nfs_refresh_inode_locked(inode, fattr);
 	spin_unlock(&inode->i_lock);
+
 	return status;
 }
 
@@ -1129,7 +1135,8 @@ static int nfs_update_inode(struct inode *inode, struct nfs_fattr *fattr)
 	} else if (nfsi->change_attr != fattr->change_attr) {
 		dprintk("NFS: change_attr change on server for file %s/%ld\n",
 				inode->i_sb->s_id, inode->i_ino);
-		invalid |= NFS_INO_INVALID_ATTR|NFS_INO_INVALID_DATA|NFS_INO_INVALID_ACCESS|NFS_INO_INVALID_ACL;
+		invalid |= NFS_INO_INVALID_ATTR|NFS_INO_INVALID_DATA |
+			NFS_INO_INVALID_ACCESS|NFS_INO_INVALID_ACL;
 		if (S_ISDIR(inode->i_mode))
 			nfs_force_lookup_revalidate(inode);
 	}
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index 9400333..07283c0 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -183,6 +183,9 @@ struct nfs_inode {
 	int			 delegation_state;
 	struct rw_semaphore	rwsem;
 #endif /* CONFIG_NFS_V4*/
+#ifdef CONFIG_NFS_FSCACHE
+	struct fscache_cookie	*fscache;
+#endif
 	struct inode		vfs_inode;
 };
 
@@ -204,6 +207,8 @@ struct nfs_inode {
 #define NFS_INO_STALE		(1)		/* possible stale inode */
 #define NFS_INO_ACL_LRU_SET	(2)		/* Inode is on the LRU list */
 #define NFS_INO_MOUNTPOINT	(3)		/* inode is remote mountpoint */
+#define NFS_INO_FSCACHE		(4)		/* inode can be cached by FS-Cache */
+#define NFS_INO_FSCACHE_LOCK	(5)		/* FS-Cache cookie management lock */
 
 static inline struct nfs_inode *NFS_I(const struct inode *inode)
 {
@@ -257,6 +262,11 @@ static inline int NFS_STALE(const struct inode *inode)
 	return test_bit(NFS_INO_STALE, &NFS_I(inode)->flags);
 }
 
+static inline int NFS_FSCACHE(const struct inode *inode)
+{
+	return test_bit(NFS_INO_FSCACHE, &NFS_I(inode)->flags);
+}
+
 static inline __u64 NFS_FILEID(const struct inode *inode)
 {
 	return NFS_I(inode)->fileid;

