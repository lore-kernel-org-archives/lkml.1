Return-Path: <linux-kernel-owner+w=401wt.eu-S933148AbYBTQRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933148AbYBTQRu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 11:17:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765048AbYBTQKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 11:10:04 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45424 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757450AbYBTQJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 11:09:35 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 28/37] NFS: Use local disk inode cache
To: Trond.Myklebust@netapp.com, chuck.lever@oracle.com, casey@schaufler-ca.com
Cc: nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
Date: Wed, 20 Feb 2008 16:08:28 +0000
Message-ID: <20080220160828.4715.7876.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080220160557.4715.66608.stgit@warthog.procyon.org.uk>
References: <20080220160557.4715.66608.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bind data storage objects in the local cache to NFS inodes.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/nfs/fscache.c       |  131 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nfs/fscache.h       |   19 +++++++
 fs/nfs/inode.c         |   39 ++++++++++++--
 include/linux/nfs_fs.h |   10 ++++
 4 files changed, 193 insertions(+), 6 deletions(-)


diff --git a/fs/nfs/fscache.c b/fs/nfs/fscache.c
index cbd09f0..c0e0320 100644
--- a/fs/nfs/fscache.c
+++ b/fs/nfs/fscache.c
@@ -166,3 +166,134 @@ void nfs_fscache_release_super_cookie(struct super_block *sb)
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
+void nfs_fscache_enable_inode_cookie(struct inode *inode)
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
+			&nfs_cache_inode_object_def,
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
+void nfs_fscache_disable_inode_cookie(struct inode *inode)
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
+ * Decide if we should enable or disable local caching for this inode.
+ * - For now, with NFS, only regular files that are open read-only will be able
+ *   to use the cache.
+ */
+void nfs_fscache_set_inode_cookie(struct inode *inode, struct file *filp)
+{
+	if (NFS_FSCACHE(inode)) {
+		if ((filp->f_flags & O_ACCMODE) != O_RDONLY)
+			nfs_fscache_disable_inode_cookie(inode);
+		else
+			nfs_fscache_enable_inode_cookie(inode);
+	}
+}
+
+/*
+ * Replace a per-inode cookie due to revalidation detecting a file having
+ * changed on the server.
+ */
+void nfs_fscache_renew_inode_cookie(struct inode *inode)
+{
+	struct nfs_inode *nfsi = NFS_I(inode);
+	struct nfs_server *nfss = NFS_SERVER(inode);
+	struct fscache_cookie *old = nfsi->fscache;
+
+	if (nfsi->fscache) {
+		/* retire the current fscache cache and get a new one */
+		fscache_relinquish_cookie(nfsi->fscache, 1);
+
+		nfsi->fscache = fscache_acquire_cookie(
+			nfss->nfs_client->fscache,
+			&nfs_cache_inode_object_def,
+			nfsi);
+
+		dfprintk(FSCACHE,
+			 "NFS: revalidation new cookie (0x%p/0x%p/0x%p/0x%p)\n",
+			 nfss, nfsi, old, nfsi->fscache);
+	}
+}
+
+/*
+ * Update the filesize associated with a per-inode cookie.
+ */
+void nfs_fscache_attr_changed(struct inode *inode)
+{
+	fscache_attr_changed(NFS_I(inode)->fscache);
+}
diff --git a/fs/nfs/fscache.h b/fs/nfs/fscache.h
index 7dcdf32..d730ec8 100644
--- a/fs/nfs/fscache.h
+++ b/fs/nfs/fscache.h
@@ -77,6 +77,15 @@ extern void nfs_fscache_get_super_cookie(struct super_block *,
 					 struct nfs_parsed_mount_data *);
 extern void nfs_fscache_release_super_cookie(struct super_block *);
 
+extern void nfs_fscache_init_inode_cookie(struct inode *);
+extern void nfs_fscache_enable_inode_cookie(struct inode *);
+extern void nfs_fscache_release_inode_cookie(struct inode *);
+extern void nfs_fscache_zap_inode_cookie(struct inode *);
+extern void nfs_fscache_disable_inode_cookie(struct inode *);
+extern void nfs_fscache_set_inode_cookie(struct inode *, struct file *);
+extern void nfs_fscache_renew_inode_cookie(struct inode *);
+extern void nfs_fscache_attr_changed(struct inode *);
+
 #else /* CONFIG_NFS_FSCACHE */
 static inline int nfs_fscache_register(void) { return 0; }
 static inline void nfs_fscache_unregister(void) {}
@@ -91,5 +100,15 @@ static inline void nfs_fscache_get_super_cookie(
 }
 static inline void nfs_fscache_release_super_cookie(struct super_block *sb) {}
 
+static inline void nfs_fscache_init_inode_cookie(struct inode *inode) {}
+static inline void nfs_fscache_enable_inode_cookie(struct inode *inode) {}
+static inline void nfs_fscache_release_inode_cookie(struct inode *inode) {}
+static inline void nfs_fscache_zap_inode_cookie(struct inode *inode) {}
+static inline void nfs_fscache_renew_inode_cookie(struct inode *inode) {}
+static inline void nfs_fscache_disable_inode_cookie(struct inode *inode) {}
+static inline void nfs_fscache_set_inode_cookie(struct inode *inode,
+					     struct file *filp) {}
+static inline void nfs_fscache_attr_changed(struct inode *inode) {}
+
 #endif /* CONFIG_NFS_FSCACHE */
 #endif /* _NFS_FSCACHE_H */
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 7254d5c..eafad13 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -112,6 +112,7 @@ void nfs_clear_inode(struct inode *inode)
 	BUG_ON(!list_empty(&NFS_I(inode)->open_files));
 	nfs_zap_acl_cache(inode);
 	nfs_access_zap_cache(inode);
+	nfs_fscache_release_inode_cookie(inode);
 }
 
 /**
@@ -331,6 +332,8 @@ nfs_fhget(struct super_block *sb, struct nfs_fh *fh, struct nfs_fattr *fattr)
 		memset(nfsi->cookieverf, 0, sizeof(nfsi->cookieverf));
 		nfsi->access_cache = RB_ROOT;
 
+		nfs_fscache_init_inode_cookie(inode);
+
 		unlock_new_inode(inode);
 	} else
 		nfs_refresh_inode(inode, fattr);
@@ -619,6 +622,7 @@ int nfs_open(struct inode *inode, struct file *filp)
 	ctx->mode = filp->f_mode;
 	nfs_file_set_open_context(filp, ctx);
 	put_nfs_open_context(ctx);
+	nfs_fscache_set_inode_cookie(inode, filp);
 	return 0;
 }
 
@@ -679,7 +683,13 @@ __nfs_revalidate_inode(struct nfs_server *server, struct inode *inode)
 			 (long long)NFS_FILEID(inode), status);
 		goto out;
 	}
-	spin_unlock(&inode->i_lock);
+	if (nfsi->cache_validity & NFS_INO_INVALID_FSCACHE_ATTR) {
+		nfsi->cache_validity &= ~NFS_INO_INVALID_FSCACHE_ATTR;
+		spin_unlock(&inode->i_lock);
+		nfs_fscache_attr_changed(inode);
+	} else {
+		spin_unlock(&inode->i_lock);
+	}
 
 	if (nfsi->cache_validity & NFS_INO_INVALID_ACL)
 		nfs_zap_acl_cache(inode);
@@ -735,6 +745,7 @@ static int nfs_invalidate_mapping_nolock(struct inode *inode, struct address_spa
 		memset(nfsi->cookieverf, 0, sizeof(nfsi->cookieverf));
 	spin_unlock(&inode->i_lock);
 	nfs_inc_stats(inode, NFSIOS_DATAINVALIDATE);
+	nfs_fscache_renew_inode_cookie(inode);
 	dfprintk(PAGECACHE, "NFS: (%s/%Ld) data cache invalidated\n",
 			inode->i_sb->s_id, (long long)NFS_FILEID(inode));
 	return 0;
@@ -911,7 +922,13 @@ int nfs_refresh_inode(struct inode *inode, struct nfs_fattr *fattr)
 	else
 		status = nfs_check_inode_attributes(inode, fattr);
 
-	spin_unlock(&inode->i_lock);
+	if (nfsi->cache_validity & NFS_INO_INVALID_FSCACHE_ATTR) {
+		nfsi->cache_validity &= ~NFS_INO_INVALID_FSCACHE_ATTR;
+		spin_unlock(&inode->i_lock);
+		nfs_fscache_attr_changed(inode);
+	} else {
+		spin_unlock(&inode->i_lock);
+	}
 	return status;
 }
 
@@ -932,12 +949,19 @@ int nfs_refresh_inode(struct inode *inode, struct nfs_fattr *fattr)
 int nfs_post_op_update_inode(struct inode *inode, struct nfs_fattr *fattr)
 {
 	struct nfs_inode *nfsi = NFS_I(inode);
+	bool update_fscache = false;
 
 	spin_lock(&inode->i_lock);
 	nfsi->cache_validity |= NFS_INO_INVALID_ATTR|NFS_INO_REVAL_PAGECACHE;
 	if (S_ISDIR(inode->i_mode))
 		nfsi->cache_validity |= NFS_INO_INVALID_DATA;
+	if (nfsi->cache_validity & NFS_INO_INVALID_FSCACHE_ATTR) {
+		nfsi->cache_validity &= ~NFS_INO_INVALID_FSCACHE_ATTR;
+		update_fscache = true;
+	}
 	spin_unlock(&inode->i_lock);
+	if (update_fscache)
+		nfs_fscache_attr_changed(inode);
 	return nfs_refresh_inode(inode, fattr);
 }
 
@@ -1025,7 +1049,8 @@ static int nfs_update_inode(struct inode *inode, struct nfs_fattr *fattr)
 		if (!timespec_equal(&inode->i_mtime, &fattr->mtime)) {
 			dprintk("NFS: mtime change on server for file %s/%ld\n",
 					inode->i_sb->s_id, inode->i_ino);
-			invalid |= NFS_INO_INVALID_ATTR|NFS_INO_INVALID_DATA;
+			invalid |= NFS_INO_INVALID_ATTR|NFS_INO_INVALID_DATA |
+				NFS_INO_INVALID_FSCACHE_ATTR;
 			if (S_ISDIR(inode->i_mode))
 				nfs_force_lookup_revalidate(inode);
 		}
@@ -1035,7 +1060,9 @@ static int nfs_update_inode(struct inode *inode, struct nfs_fattr *fattr)
 	} else if (nfsi->change_attr != fattr->change_attr) {
 		dprintk("NFS: change_attr change on server for file %s/%ld\n",
 				inode->i_sb->s_id, inode->i_ino);
-		invalid |= NFS_INO_INVALID_ATTR|NFS_INO_INVALID_DATA|NFS_INO_INVALID_ACCESS|NFS_INO_INVALID_ACL;
+		invalid |= NFS_INO_INVALID_ATTR|NFS_INO_INVALID_DATA |
+			NFS_INO_INVALID_ACCESS|NFS_INO_INVALID_ACL |
+			NFS_INO_INVALID_FSCACHE_ATTR;
 		if (S_ISDIR(inode->i_mode))
 			nfs_force_lookup_revalidate(inode);
 	}
@@ -1048,13 +1075,13 @@ static int nfs_update_inode(struct inode *inode, struct nfs_fattr *fattr)
 		 * the file grown beyond our last write? */
 		if (nfsi->npages == 0 || new_isize > cur_isize) {
 			inode->i_size = new_isize;
-			invalid |= NFS_INO_INVALID_ATTR|NFS_INO_INVALID_DATA;
+			invalid |= NFS_INO_INVALID_ATTR|NFS_INO_INVALID_DATA |
+				NFS_INO_INVALID_FSCACHE_ATTR;
 		}
 		dprintk("NFS: isize change on server for file %s/%ld\n",
 				inode->i_sb->s_id, inode->i_ino);
 	}
 
-
 	memcpy(&inode->i_mtime, &fattr->mtime, sizeof(inode->i_mtime));
 	memcpy(&inode->i_ctime, &fattr->ctime, sizeof(inode->i_ctime));
 	memcpy(&inode->i_atime, &fattr->atime, sizeof(inode->i_atime));
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index 14894c9..d9adb53 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -174,6 +174,9 @@ struct nfs_inode {
 	int			 delegation_state;
 	struct rw_semaphore	rwsem;
 #endif /* CONFIG_NFS_V4*/
+#ifdef CONFIG_NFS_FSCACHE
+	struct fscache_cookie	*fscache;
+#endif
 	struct inode		vfs_inode;
 };
 
@@ -187,6 +190,7 @@ struct nfs_inode {
 #define NFS_INO_INVALID_ACL	0x0010		/* cached acls are invalid */
 #define NFS_INO_REVAL_PAGECACHE	0x0020		/* must revalidate pagecache */
 #define NFS_INO_REVAL_FORCED	0x0040		/* force revalidation ignoring a delegation */
+#define NFS_INO_INVALID_FSCACHE_ATTR	0x0080	/* local cache attributes are invalid */
 
 /*
  * Bit offsets in flags field
@@ -195,6 +199,7 @@ struct nfs_inode {
 #define NFS_INO_ADVISE_RDPLUS	(1)		/* advise readdirplus */
 #define NFS_INO_STALE		(2)		/* possible stale inode */
 #define NFS_INO_ACL_LRU_SET	(3)		/* Inode is on the LRU list */
+#define NFS_INO_FSCACHE		(4)		/* inode can be cached by FS-Cache */
 
 static inline struct nfs_inode *NFS_I(const struct inode *inode)
 {
@@ -248,6 +253,11 @@ static inline int NFS_STALE(const struct inode *inode)
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

