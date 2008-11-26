Return-Path: <linux-kernel-owner+w=401wt.eu-S1754210AbYLAQn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210AbYLAQn0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 11:43:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753205AbYLAQkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 11:40:17 -0500
Received: from zombie2.ncsc.mil ([144.51.88.133]:56939 "EHLO zombie2.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370AbYLAQju (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 11:39:50 -0500
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: hch@infradead.org, viro@zeniv.linux.org.uk, casey@schaufler-ca.com,
       sds@tycho.nsa.gov, matthew.dodd@sparta.com, trond.myklebust@fys.uio.no,
       bfields@fieldses.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov,
       labeled-nfs@linux-nfs.org, "David P. Quigley" <dpquigl@tycho.nsa.gov>,
       "Matthew N. Dodd" <Matthew.Dodd@sparta.com>
Subject: [PATCH 12/14] NFS: Client implementation of Labeled-NFS
Date: Wed, 26 Nov 2008 16:03:12 -0500
Message-Id: <1227733394-1114-13-git-send-email-dpquigl@tycho.nsa.gov>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1227733394-1114-1-git-send-email-dpquigl@tycho.nsa.gov>
References: <1227733394-1114-1-git-send-email-dpquigl@tycho.nsa.gov>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements the client transport and handling support for labeled
NFS. The patch adds two functions to encode and decode the security label
recommended attribute which makes use of the LSM hooks added earlier. It also
adds code to grab the label from the file attribute structures and encode the
label to be sent back to the server.

Signed-off-by: Matthew N. Dodd <Matthew.Dodd@sparta.com>
Signed-off-by: David P. Quigley <dpquigl@tycho.nsa.gov>
---
 fs/nfs/inode.c           |   49 +++++++-
 fs/nfs/nfs4proc.c        |  303 ++++++++++++++++++++++++++++++++++++++++++----
 fs/nfs/nfs4xdr.c         |   55 ++++++++-
 fs/nfs/super.c           |   33 +++++-
 include/linux/nfs_fs.h   |    2 +
 security/selinux/hooks.c |    5 +
 6 files changed, 412 insertions(+), 35 deletions(-)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 33ae87b..c025624 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -143,10 +143,13 @@ static void nfs_zap_caches_locked(struct inode *inode)
 	nfsi->attrtimeo_timestamp = jiffies;
 
 	memset(NFS_COOKIEVERF(inode), 0, sizeof(NFS_COOKIEVERF(inode)));
+	nfsi->cache_validity |= NFS_INO_INVALID_ATTR| \
+				NFS_INO_INVALID_LABEL| \
+				NFS_INO_INVALID_ACCESS| \
+				NFS_INO_INVALID_ACL| \
+				NFS_INO_REVAL_PAGECACHE;
 	if (S_ISREG(mode) || S_ISDIR(mode) || S_ISLNK(mode))
-		nfsi->cache_validity |= NFS_INO_INVALID_ATTR|NFS_INO_INVALID_DATA|NFS_INO_INVALID_ACCESS|NFS_INO_INVALID_ACL|NFS_INO_REVAL_PAGECACHE;
-	else
-		nfsi->cache_validity |= NFS_INO_INVALID_ATTR|NFS_INO_INVALID_ACCESS|NFS_INO_INVALID_ACL|NFS_INO_REVAL_PAGECACHE;
+		nfsi->cache_validity |= NFS_INO_INVALID_DATA;
 }
 
 void nfs_zap_caches(struct inode *inode)
@@ -235,6 +238,33 @@ nfs_init_locked(struct inode *inode, void *opaque)
 /* Don't use READDIRPLUS on directories that we believe are too large */
 #define NFS_LIMIT_READDIRPLUS (8*PAGE_SIZE)
 
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+void nfs_setsecurity(struct inode *inode, struct nfs_fattr *fattr)
+{
+	int error;
+
+/*	BUG_ON(!mutex_is_locked(&inode->i_mutex)); */
+
+	if ((fattr->valid & NFS_ATTR_FATTR_V4) &&
+	    (fattr->bitmap[1] & FATTR4_WORD1_SECURITY_LABEL) &&
+	    (fattr->label != NULL) &&
+	    (inode->i_security != NULL)) {
+		error = security_inode_notifysecctx(inode, fattr->label,
+						   fattr->label_len);
+		/* XXX: debug output */
+		if (error)
+			printk(KERN_ERR "%s() %s %d "
+				"security_inode_notifysecctx() %d\n",
+				__func__,
+				(char *)fattr->label, fattr->label_len, error);
+	}
+}
+#else
+void nfs_setsecurity(struct inode *inode, struct nfs_fattr *fattr)
+{
+}
+#endif
+
 /*
  * This is our front-end to iget that looks up inodes by file handle
  * instead of inode number.
@@ -315,6 +345,11 @@ nfs_fhget(struct super_block *sb, struct nfs_fh *fh, struct nfs_fattr *fattr)
 		inode->i_nlink = fattr->nlink;
 		inode->i_uid = fattr->uid;
 		inode->i_gid = fattr->gid;
+
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+		nfs_setsecurity(inode, fattr);
+#endif
+
 		if (fattr->valid & (NFS_ATTR_FATTR_V3 | NFS_ATTR_FATTR_V4)) {
 			/*
 			 * report the blocks in 512byte units
@@ -749,7 +784,7 @@ int nfs_attribute_timeout(struct inode *inode)
  */
 int nfs_revalidate_inode(struct nfs_server *server, struct inode *inode)
 {
-	if (!(NFS_I(inode)->cache_validity & NFS_INO_INVALID_ATTR)
+	if (!(NFS_I(inode)->cache_validity & (NFS_INO_INVALID_ATTR|NFS_INO_INVALID_LABEL))
 			&& !nfs_attribute_timeout(inode))
 		return NFS_STALE(inode) ? -ESTALE : 0;
 	return __nfs_revalidate_inode(server, inode);
@@ -1183,6 +1218,9 @@ static int nfs_update_inode(struct inode *inode, struct nfs_fattr *fattr)
 	inode->i_nlink = fattr->nlink;
 	inode->i_uid = fattr->uid;
 	inode->i_gid = fattr->gid;
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	nfs_setsecurity(inode, fattr);
+#endif
 
 	if (fattr->valid & (NFS_ATTR_FATTR_V3 | NFS_ATTR_FATTR_V4)) {
 		/*
@@ -1194,7 +1232,7 @@ static int nfs_update_inode(struct inode *inode, struct nfs_fattr *fattr)
  	}
 
 	/* Update attrtimeo value if we're out of the unstable period */
-	if (invalid & NFS_INO_INVALID_ATTR) {
+	if (invalid & (NFS_INO_INVALID_ATTR|NFS_INO_INVALID_LABEL)) {
 		nfs_inc_stats(inode, NFSIOS_ATTRINVALIDATE);
 		nfsi->attrtimeo = NFS_MINATTRTIMEO(inode);
 		nfsi->attrtimeo_timestamp = now;
@@ -1207,6 +1245,7 @@ static int nfs_update_inode(struct inode *inode, struct nfs_fattr *fattr)
 		}
 	}
 	invalid &= ~NFS_INO_INVALID_ATTR;
+	invalid &= ~NFS_INO_INVALID_LABEL;
 	/* Don't invalidate the data if we were to blame */
 	if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode)
 				|| S_ISLNK(inode->i_mode)))
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 3a0d25f..9db51ea 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -48,6 +48,7 @@
 #include <linux/smp_lock.h>
 #include <linux/namei.h>
 #include <linux/mount.h>
+#include <linux/nfs4_mount.h>
 
 #include "nfs4_fs.h"
 #include "delegation.h"
@@ -97,6 +98,9 @@ const u32 nfs4_fattr_bitmap[2] = {
 	| FATTR4_WORD1_TIME_ACCESS
 	| FATTR4_WORD1_TIME_METADATA
 	| FATTR4_WORD1_TIME_MODIFY
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	| FATTR4_WORD1_SECURITY_LABEL
+#endif
 };
 
 const u32 nfs4_statfs_bitmap[2] = {
@@ -251,7 +255,7 @@ static void nfs4_init_opendata_res(struct nfs4_opendata *p)
 
 static struct nfs4_opendata *nfs4_opendata_alloc(struct path *path,
 		struct nfs4_state_owner *sp, int flags,
-		const struct iattr *attrs)
+		const struct iattr *attrs, struct nfs4_label *label)
 {
 	struct dentry *parent = dget_parent(path->dentry);
 	struct inode *dir = parent->d_inode;
@@ -277,6 +281,7 @@ static struct nfs4_opendata *nfs4_opendata_alloc(struct path *path,
 	p->o_arg.server = server;
 	p->o_arg.bitmask = server->attr_bitmask;
 	p->o_arg.claim = NFS4_OPEN_CLAIM_NULL;
+	p->o_arg.label = label;
 	if (flags & O_EXCL) {
 		u32 *s = (u32 *) p->o_arg.u.verifier.data;
 		s[0] = jiffies;
@@ -567,7 +572,7 @@ static struct nfs4_opendata *nfs4_open_recoverdata_alloc(struct nfs_open_context
 {
 	struct nfs4_opendata *opendata;
 
-	opendata = nfs4_opendata_alloc(&ctx->path, state->owner, 0, NULL);
+	opendata = nfs4_opendata_alloc(&ctx->path, state->owner, 0, NULL, NULL);
 	if (opendata == NULL)
 		return ERR_PTR(-ENOMEM);
 	opendata->state = state;
@@ -1046,7 +1051,7 @@ static inline void nfs4_exclusive_attrset(struct nfs4_opendata *opendata, struct
 /*
  * Returns a referenced nfs4_state
  */
-static int _nfs4_do_open(struct inode *dir, struct path *path, int flags, struct iattr *sattr, struct rpc_cred *cred, struct nfs4_state **res)
+static int _nfs4_do_open(struct inode *dir, struct path *path, int flags, struct iattr *sattr, struct nfs4_label *label, struct rpc_cred *cred, struct nfs4_state **res)
 {
 	struct nfs4_state_owner  *sp;
 	struct nfs4_state     *state = NULL;
@@ -1068,7 +1073,7 @@ static int _nfs4_do_open(struct inode *dir, struct path *path, int flags, struct
 		nfs4_return_incompatible_delegation(path->dentry->d_inode, flags & (FMODE_READ|FMODE_WRITE));
 	down_read(&clp->cl_sem);
 	status = -ENOMEM;
-	opendata = nfs4_opendata_alloc(path, sp, flags, sattr);
+	opendata = nfs4_opendata_alloc(path, sp, flags, sattr, label);
 	if (opendata == NULL)
 		goto err_release_rwsem;
 
@@ -1103,14 +1108,14 @@ out_err:
 }
 
 
-static struct nfs4_state *nfs4_do_open(struct inode *dir, struct path *path, int flags, struct iattr *sattr, struct rpc_cred *cred)
+static struct nfs4_state *nfs4_do_open(struct inode *dir, struct path *path, int flags, struct iattr *sattr, struct nfs4_label *label, struct rpc_cred *cred)
 {
 	struct nfs4_exception exception = { };
 	struct nfs4_state *res;
 	int status;
 
 	do {
-		status = _nfs4_do_open(dir, path, flags, sattr, cred, &res);
+		status = _nfs4_do_open(dir, path, flags, sattr, label, cred, &res);
 		if (status == 0)
 			break;
 		/* NOTE: BAD_SEQID means the server and client disagree about the
@@ -1154,14 +1159,15 @@ static struct nfs4_state *nfs4_do_open(struct inode *dir, struct path *path, int
 
 static int _nfs4_do_setattr(struct inode *inode, struct rpc_cred *cred,
 			    struct nfs_fattr *fattr, struct iattr *sattr,
-			    struct nfs4_state *state)
+			    struct nfs4_label *label, struct nfs4_state *state)
 {
 	struct nfs_server *server = NFS_SERVER(inode);
         struct nfs_setattrargs  arg = {
                 .fh             = NFS_FH(inode),
                 .iap            = sattr,
 		.server		= server,
-		.bitmask = server->attr_bitmask,
+		.bitmask 	= server->attr_bitmask,
+		.label		= label,
         };
         struct nfs_setattrres  res = {
 		.fattr		= fattr,
@@ -1193,14 +1199,14 @@ static int _nfs4_do_setattr(struct inode *inode, struct rpc_cred *cred,
 
 static int nfs4_do_setattr(struct inode *inode, struct rpc_cred *cred,
 			   struct nfs_fattr *fattr, struct iattr *sattr,
-			   struct nfs4_state *state)
+			   struct nfs4_label *label, struct nfs4_state *state)
 {
 	struct nfs_server *server = NFS_SERVER(inode);
 	struct nfs4_exception exception = { };
 	int err;
 	do {
 		err = nfs4_handle_exception(server,
-				_nfs4_do_setattr(inode, cred, fattr, sattr, state),
+				_nfs4_do_setattr(inode, cred, fattr, sattr, label, state),
 				&exception);
 	} while (exception.retry);
 	return err;
@@ -1406,6 +1412,7 @@ out_close:
 struct dentry *
 nfs4_atomic_open(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
 {
+	struct nfs4_label l, *label = NULL;
 	struct path path = {
 		.mnt = nd->path.mnt,
 		.dentry = dentry,
@@ -1416,11 +1423,21 @@ nfs4_atomic_open(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
 	struct nfs4_state *state;
 	struct dentry *res;
 
+	memset(&attr, 0, sizeof(struct iattr));
 	if (nd->flags & LOOKUP_CREATE) {
 		attr.ia_mode = nd->intent.open.create_mode;
 		attr.ia_valid = ATTR_MODE;
 		if (!IS_POSIXACL(dir))
 			attr.ia_mode &= ~current->fs->umask;
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+		if (nfs_server_capable(dir, NFS_CAP_SECURITY_LABEL)) {
+			int error;
+			error = security_dentry_init_security(dentry,
+					attr.ia_mode, &l.label, &l.len);
+			if (error == 0)
+				label = &l;
+		}
+#endif
 	} else {
 		attr.ia_valid = 0;
 		BUG_ON(nd->intent.open.flags & O_CREAT);
@@ -1432,8 +1449,12 @@ nfs4_atomic_open(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
 	parent = dentry->d_parent;
 	/* Protect against concurrent sillydeletes */
 	nfs_block_sillyrename(parent);
-	state = nfs4_do_open(dir, &path, nd->intent.open.flags, &attr, cred);
+	state = nfs4_do_open(dir, &path, nd->intent.open.flags, &attr, label, cred);
 	put_rpccred(cred);
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (label != NULL)
+		security_release_secctx(l.label, l.len);
+#endif
 	if (IS_ERR(state)) {
 		if (PTR_ERR(state) == -ENOENT) {
 			d_add(dentry, NULL);
@@ -1464,7 +1485,7 @@ nfs4_open_revalidate(struct inode *dir, struct dentry *dentry, int openflags, st
 	cred = rpc_lookup_cred();
 	if (IS_ERR(cred))
 		return PTR_ERR(cred);
-	state = nfs4_do_open(dir, &path, openflags, NULL, cred);
+	state = nfs4_do_open(dir, &path, openflags, NULL, NULL, cred);
 	put_rpccred(cred);
 	if (IS_ERR(state)) {
 		switch (PTR_ERR(state)) {
@@ -1506,6 +1527,13 @@ static int _nfs4_server_capabilities(struct nfs_server *server, struct nfs_fh *f
 		memcpy(server->attr_bitmask, res.attr_bitmask, sizeof(server->attr_bitmask));
 		if (res.attr_bitmask[0] & FATTR4_WORD0_ACL)
 			server->caps |= NFS_CAP_ACLS;
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+		if (server->flags & NFS4_MOUNT_SECURITY_LABEL &&
+		    res.attr_bitmask[1] & FATTR4_WORD1_SECURITY_LABEL) {
+			server->caps |= NFS_CAP_SECURITY_LABEL;
+		} else
+#endif
+		server->attr_bitmask[1] &= ~FATTR4_WORD1_SECURITY_LABEL;
 		if (res.has_links != 0)
 			server->caps |= NFS_CAP_HARDLINKS;
 		if (res.has_symlinks != 0)
@@ -1688,9 +1716,11 @@ nfs4_proc_setattr(struct dentry *dentry, struct nfs_fattr *fattr,
 		}
 	}
 
-	status = nfs4_do_setattr(inode, cred, fattr, sattr, state);
-	if (status == 0)
+	status = nfs4_do_setattr(inode, cred, fattr, sattr, NULL, state);
+	if (status == 0) {
 		nfs_setattr_update_inode(inode, sattr);
+		nfs_setsecurity(inode, fattr);
+	}
 	return status;
 }
 
@@ -1913,6 +1943,7 @@ static int
 nfs4_proc_create(struct inode *dir, struct dentry *dentry, struct iattr *sattr,
                  int flags, struct nameidata *nd)
 {
+	struct nfs4_label l, *label = NULL;
 	struct path path = {
 		.mnt = nd->path.mnt,
 		.dentry = dentry,
@@ -1926,7 +1957,18 @@ nfs4_proc_create(struct inode *dir, struct dentry *dentry, struct iattr *sattr,
 		status = PTR_ERR(cred);
 		goto out;
 	}
-	state = nfs4_do_open(dir, &path, flags, sattr, cred);
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (((nd->flags & LOOKUP_CREATE) != 0) &&
+	      nfs_server_capable(dir, NFS_CAP_SECURITY_LABEL)) {
+		status = security_dentry_init_security(dentry,
+				sattr->ia_mode, &l.label, &l.len);
+		/* XXX: should this be more fatal? */
+		if (status == 0)
+			label = &l;
+	}
+#endif
+
+	state = nfs4_do_open(dir, &path, flags, sattr, label, cred);
 	d_drop(dentry);
 	if (IS_ERR(state)) {
 		status = PTR_ERR(state);
@@ -1945,10 +1987,12 @@ nfs4_proc_create(struct inode *dir, struct dentry *dentry, struct iattr *sattr,
 		if (status < 0)
 			goto out;
 #endif
-		status = nfs4_do_setattr(state->inode, cred, &fattr, sattr, state);
-		if (status == 0)
+		status = nfs4_do_setattr(state->inode, cred, &fattr, sattr, label, state);
+		if (status == 0) {
 			nfs_setattr_update_inode(state->inode, sattr);
-		nfs_post_op_update_inode(state->inode, &fattr);
+			nfs_post_op_update_inode(state->inode, &fattr);
+			nfs_setsecurity(state->inode, &fattr);
+		}
 		nfs_fattr_fini(&fattr);
 	}
 	if (status == 0 && (nd->flags & LOOKUP_OPEN) != 0)
@@ -1958,6 +2002,10 @@ nfs4_proc_create(struct inode *dir, struct dentry *dentry, struct iattr *sattr,
 out_putcred:
 	put_rpccred(cred);
 out:
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (label != NULL)
+		security_release_secctx(label->label, label->len);
+#endif
 	return status;
 }
 
@@ -2241,7 +2289,8 @@ static void nfs4_free_createdata(struct nfs4_createdata *data)
 }
 
 static int _nfs4_proc_symlink(struct inode *dir, struct dentry *dentry,
-		struct page *page, unsigned int len, struct iattr *sattr)
+		struct page *page, unsigned int len, struct iattr *sattr,
+		struct nfs4_label *label)
 {
 	struct nfs4_createdata *data;
 	int status = -ENAMETOOLONG;
@@ -2257,6 +2306,7 @@ static int _nfs4_proc_symlink(struct inode *dir, struct dentry *dentry,
 	data->msg.rpc_proc = &nfs4_procedures[NFSPROC4_CLNT_SYMLINK];
 	data->arg.u.symlink.pages = &page;
 	data->arg.u.symlink.len = len;
+	data->arg.label = label;
 	
 	status = nfs4_do_create(dir, dentry, data);
 
@@ -2269,18 +2319,33 @@ static int nfs4_proc_symlink(struct inode *dir, struct dentry *dentry,
 		struct page *page, unsigned int len, struct iattr *sattr)
 {
 	struct nfs4_exception exception = { };
+	struct nfs4_label l, *label = NULL;
 	int err;
+
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (nfs_server_capable(dir, NFS_CAP_SECURITY_LABEL)) {
+		err = security_dentry_init_security(dentry,
+				sattr->ia_mode, &l.label, &l.len);
+		if (err == 0)
+			label = &l;
+	}
+#endif
+
 	do {
 		err = nfs4_handle_exception(NFS_SERVER(dir),
 				_nfs4_proc_symlink(dir, dentry, page,
-							len, sattr),
+							len, sattr, label),
 				&exception);
 	} while (exception.retry);
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (label != NULL)
+		security_release_secctx(l.label, l.len);
+#endif
 	return err;
 }
 
 static int _nfs4_proc_mkdir(struct inode *dir, struct dentry *dentry,
-		struct iattr *sattr)
+		struct iattr *sattr, struct nfs4_label *label)
 {
 	struct nfs4_createdata *data;
 	int status = -ENOMEM;
@@ -2289,6 +2354,7 @@ static int _nfs4_proc_mkdir(struct inode *dir, struct dentry *dentry,
 	if (data == NULL)
 		goto out;
 
+	data->arg.label = label;
 	status = nfs4_do_create(dir, dentry, data);
 
 	nfs4_free_createdata(data);
@@ -2300,12 +2366,27 @@ static int nfs4_proc_mkdir(struct inode *dir, struct dentry *dentry,
 		struct iattr *sattr)
 {
 	struct nfs4_exception exception = { };
+	struct nfs4_label l, *label = NULL;
 	int err;
+
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (nfs_server_capable(dir, NFS_CAP_SECURITY_LABEL)) {
+		err = security_dentry_init_security(dentry,
+				sattr->ia_mode, &l.label, &l.len);
+		if (err == 0)
+			label = &l;
+	}
+#endif
+
 	do {
 		err = nfs4_handle_exception(NFS_SERVER(dir),
-				_nfs4_proc_mkdir(dir, dentry, sattr),
+				_nfs4_proc_mkdir(dir, dentry, sattr, label),
 				&exception);
 	} while (exception.retry);
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (label != NULL)
+		security_release_secctx(l.label, l.len);
+#endif
 	return err;
 }
 
@@ -2360,7 +2441,7 @@ static int nfs4_proc_readdir(struct dentry *dentry, struct rpc_cred *cred,
 }
 
 static int _nfs4_proc_mknod(struct inode *dir, struct dentry *dentry,
-		struct iattr *sattr, dev_t rdev)
+		struct iattr *sattr, struct nfs4_label *label, dev_t rdev)
 {
 	struct nfs4_createdata *data;
 	int mode = sattr->ia_mode;
@@ -2385,7 +2466,7 @@ static int _nfs4_proc_mknod(struct inode *dir, struct dentry *dentry,
 		data->arg.u.device.specdata1 = MAJOR(rdev);
 		data->arg.u.device.specdata2 = MINOR(rdev);
 	}
-	
+	data->arg.label = label;
 	status = nfs4_do_create(dir, dentry, data);
 
 	nfs4_free_createdata(data);
@@ -2397,12 +2478,27 @@ static int nfs4_proc_mknod(struct inode *dir, struct dentry *dentry,
 		struct iattr *sattr, dev_t rdev)
 {
 	struct nfs4_exception exception = { };
+	struct nfs4_label l, *label = NULL;
 	int err;
+
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (nfs_server_capable(dir, NFS_CAP_SECURITY_LABEL)) {
+		err = security_dentry_init_security(dentry,
+				sattr->ia_mode, &l.label, &l.len);
+		if (err == 0)
+			label = &l;
+	}
+#endif
+
 	do {
 		err = nfs4_handle_exception(NFS_SERVER(dir),
-				_nfs4_proc_mknod(dir, dentry, sattr, rdev),
+				_nfs4_proc_mknod(dir, dentry, sattr, label, rdev),
 				&exception);
 	} while (exception.retry);
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (label != NULL)
+		security_release_secctx(l.label, l.len);
+#endif
 	return err;
 }
 
@@ -2850,6 +2946,163 @@ static int nfs4_proc_set_acl(struct inode *inode, const void *buf, size_t buflen
 	return err;
 }
 
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+static int _nfs4_get_security_label(struct inode *inode, void *buf, size_t buflen)
+{
+	struct nfs_server *server = NFS_SERVER(inode);
+	struct nfs_fattr fattr;
+	u32 bitmask[2] = { 0, FATTR4_WORD1_SECURITY_LABEL };
+	struct nfs4_getattr_arg args = {
+		.fh		= NFS_FH(inode),
+		.bitmask	= bitmask,
+	};
+	struct nfs4_getattr_res res = {
+		.fattr		= &fattr,
+		.server		= server,
+	};
+	struct rpc_message msg = {
+		.rpc_proc	= &nfs4_procedures[NFSPROC4_CLNT_GETATTR],
+		.rpc_argp	= &args,
+		.rpc_resp	= &res,
+	};
+	int ret;
+
+	memset(&fattr, 0, sizeof(struct nfs_fattr));
+	nfs_fattr_alloc(&fattr, GFP_KERNEL);
+	nfs_fattr_init(&fattr);
+
+	ret = rpc_call_sync(server->client, &msg, 0);
+	if (ret)
+		goto out;
+	if (!(fattr.bitmap[1] & FATTR4_WORD1_SECURITY_LABEL))
+		return -ENOENT;
+	if (buflen < fattr.label_len) {
+		ret = -ERANGE;
+		goto out;
+	}
+	memcpy(buf, fattr.label, fattr.label_len);
+out:
+	nfs_fattr_fini(&fattr);
+	return ret;
+}
+
+static int nfs4_get_security_label(struct inode *inode, void *buf, size_t buflen)
+{
+	struct nfs4_exception exception = { };
+	int err;
+
+	if (!nfs_server_capable(inode, NFS_CAP_SECURITY_LABEL))
+		return -EOPNOTSUPP;
+
+	do {
+		err = nfs4_handle_exception(NFS_SERVER(inode),
+				_nfs4_get_security_label(inode, buf, buflen),
+				&exception);
+	} while (exception.retry);
+	return err;
+}
+
+static int _nfs4_do_set_security_label(struct inode *inode,
+				      struct nfs4_label *label,
+				      struct nfs_fattr *fattr,
+				      struct nfs4_state *state)
+{
+
+	struct iattr sattr;
+	struct nfs_server *server = NFS_SERVER(inode);
+	const u32 bitmask[2] = { 0, FATTR4_WORD1_SECURITY_LABEL };
+	struct nfs_setattrargs args = {
+		.fh             = NFS_FH(inode),
+		.iap            = &sattr,
+		.server		= server,
+		.bitmask	= bitmask,
+		.label		= label,
+	};
+	struct nfs_setattrres res = {
+		.fattr		= fattr,
+		.server		= server,
+	};
+	struct rpc_message msg = {
+		.rpc_proc       = &nfs4_procedures[NFSPROC4_CLNT_SETATTR],
+		.rpc_argp       = &args,
+		.rpc_resp       = &res,
+	};
+	unsigned long timestamp = jiffies;
+	int status;
+
+	memset(&sattr, 0, sizeof(struct iattr));
+
+	if (nfs4_copy_delegation_stateid(&args.stateid, inode)) {
+		/* Use that stateid */
+	} else if (state != NULL) {
+		msg.rpc_cred = state->owner->so_cred;
+		nfs4_copy_stateid(&args.stateid, state, current->files);
+	} else
+		memcpy(&args.stateid, &zero_stateid, sizeof(args.stateid));
+
+	status = rpc_call_sync(server->client, &msg, 0);
+	if (status == 0 && state != NULL)
+		renew_lease(server, timestamp);
+	return status;
+}
+
+static int nfs4_do_set_security_label(struct inode *inode,
+				     struct nfs4_label *label,
+				     struct nfs_fattr *fattr,
+				     struct nfs4_state *state)
+{
+	struct nfs4_exception exception = { };
+	int err;
+
+	do {
+		err = nfs4_handle_exception(NFS_SERVER(inode),
+			_nfs4_do_set_security_label(inode, label, fattr, state),
+			&exception);
+	} while (exception.retry);
+	return err;
+}
+
+static int
+nfs4_set_security_label(struct dentry *dentry, const void *buf, size_t buflen)
+{
+	struct nfs4_label label;
+	struct nfs_fattr fattr;
+	struct rpc_cred *cred;
+	struct nfs_open_context *ctx;
+	struct nfs4_state *state = NULL;
+	struct inode *inode = dentry->d_inode;
+	int status;
+
+	if (!nfs_server_capable(inode, NFS_CAP_SECURITY_LABEL))
+		return -EOPNOTSUPP;
+
+	memset(&fattr, 0, sizeof(struct nfs_fattr));
+	nfs_fattr_alloc(&fattr, GFP_KERNEL);
+	nfs_fattr_init(&fattr);
+
+	label.label = (char *)buf;
+	label.len = buflen;
+
+	cred = rpc_lookup_cred();
+	if (IS_ERR(cred))
+		return PTR_ERR(cred);
+
+	/* Search for an existing open(O_WRITE) file */
+	ctx = nfs_find_open_context(inode, cred, FMODE_WRITE);
+	if (ctx != NULL)
+		state = ctx->state;
+
+	status = nfs4_do_set_security_label(inode, &label, &fattr, state);
+	if (status == 0)
+		nfs_setsecurity(inode, &fattr);
+	if (ctx != NULL)
+		put_nfs_open_context(ctx);
+	put_rpccred(cred);
+	nfs_fattr_fini(&fattr);
+	return status;
+}
+#endif	/* CONFIG_NFS_V4_SECURITY_LABEL */
+
 static int
 nfs4_async_handle_error(struct rpc_task *task, const struct nfs_server *server)
 {
diff --git a/fs/nfs/nfs4xdr.c b/fs/nfs/nfs4xdr.c
index b916297..104fd29 100644
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -601,7 +601,7 @@ static void encode_nfs4_verifier(struct xdr_stream *xdr, const nfs4_verifier *ve
 	xdr_encode_opaque_fixed(p, verf->data, NFS4_VERIFIER_SIZE);
 }
 
-static int encode_attrs(struct xdr_stream *xdr, const struct iattr *iap, const struct nfs_server *server)
+static int encode_attrs(struct xdr_stream *xdr, const struct iattr *iap, const struct nfs4_label *label, const struct nfs_server *server)
 {
 	char owner_name[IDMAP_NAMESZ];
 	char owner_group[IDMAP_NAMESZ];
@@ -651,6 +651,10 @@ static int encode_attrs(struct xdr_stream *xdr, const struct iattr *iap, const s
 		}
 		len += 4 + (XDR_QUADLEN(owner_grouplen) << 2);
 	}
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (label != NULL)
+		len += 4 + (XDR_QUADLEN(label->len) << 2);
+#endif
 	if (iap->ia_valid & ATTR_ATIME_SET)
 		len += 16;
 	else if (iap->ia_valid & ATTR_ATIME)
@@ -709,6 +713,13 @@ static int encode_attrs(struct xdr_stream *xdr, const struct iattr *iap, const s
 		bmval1 |= FATTR4_WORD1_TIME_MODIFY_SET;
 		WRITE32(NFS4_SET_TO_SERVER_TIME);
 	}
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (label != NULL) {
+		bmval1 |= FATTR4_WORD1_SECURITY_LABEL;
+		WRITE32(label->len);
+		WRITEMEM(label->label, label->len);
+	}
+#endif
 	
 	/*
 	 * Now we backfill the bitmap and the attribute buffer length.
@@ -792,7 +803,7 @@ static int encode_create(struct xdr_stream *xdr, const struct nfs4_create_arg *c
 	WRITE32(create->name->len);
 	WRITEMEM(create->name->name, create->name->len);
 
-	return encode_attrs(xdr, create->attrs, create->server);
+	return encode_attrs(xdr, create->attrs, create->label, create->server);
 }
 
 static int encode_getattr_one(struct xdr_stream *xdr, uint32_t bitmap)
@@ -1000,7 +1011,7 @@ static inline void encode_createmode(struct xdr_stream *xdr, const struct nfs_op
 	switch(arg->open_flags & O_EXCL) {
 		case 0:
 			WRITE32(NFS4_CREATE_UNCHECKED);
-			encode_attrs(xdr, arg->u.attrs, arg->server);
+			encode_attrs(xdr, arg->u.attrs, arg->label, arg->server);
 			break;
 		default:
 			WRITE32(NFS4_CREATE_EXCLUSIVE);
@@ -1301,7 +1312,7 @@ static int encode_setattr(struct xdr_stream *xdr, const struct nfs_setattrargs *
         WRITE32(OP_SETATTR);
 	WRITEMEM(arg->stateid.data, NFS4_STATEID_SIZE);
 
-        if ((status = encode_attrs(xdr, arg->iap, server)))
+        if ((status = encode_attrs(xdr, arg->iap, arg->label, server)))
 		return status;
 
         return 0;
@@ -2954,6 +2965,39 @@ static int decode_attr_time_modify(struct xdr_stream *xdr, uint32_t *bitmap, str
 	return status;
 }
 
+static int decode_attr_security_label(struct xdr_stream *xdr, uint32_t *bitmap, void **ctx, __u32 *ctxlen)
+{
+	__u32 len;
+	__be32 *p;
+	int rc = 0;
+
+	if (unlikely(bitmap[1] & (FATTR4_WORD1_SECURITY_LABEL - 1U)))
+		return -EIO;
+	if (likely(bitmap[1] & FATTR4_WORD1_SECURITY_LABEL)) {
+		READ_BUF(4);
+		READ32(len);
+		READ_BUF(len);
+		if (len < XDR_MAX_NETOBJ) {
+			if (*ctx != NULL) {
+				if (*ctxlen < len) {
+					printk(KERN_ERR
+						"%s(): ctxlen %d < len %d\n",
+						__func__, *ctxlen, len);
+					/* rc = -ENOMEM; */
+					*ctx = NULL;	/* leak */
+				} else {
+					memcpy(*ctx, p, len);
+				}
+			}
+			*ctxlen = len;
+		} else
+			printk(KERN_WARNING "%s: label too long (%u)!\n",
+					__FUNCTION__, len);
+		bitmap[1] &= ~FATTR4_WORD1_SECURITY_LABEL;
+	}
+	return rc;
+}
+
 static int verify_attr_len(struct xdr_stream *xdr, __be32 *savep, uint32_t attrlen)
 {
 	unsigned int attrwords = XDR_QUADLEN(attrlen);
@@ -3188,6 +3232,9 @@ static int decode_getfattr(struct xdr_stream *xdr, struct nfs_fattr *fattr, cons
 		goto xdr_error;
 	if ((status = decode_attr_mounted_on_fileid(xdr, bitmap, &fileid)) != 0)
 		goto xdr_error;
+	if ((status = decode_attr_security_label(xdr, bitmap,
+				&fattr->label, &fattr->label_len)) != 0)
+		goto xdr_error;
 	if (fattr->fileid == 0 && fileid != 0)
 		fattr->fileid = fileid;
 	if ((status = verify_attr_len(xdr, savep, attrlen)) == 0)
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index ab071e1..41c979a 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -565,8 +565,15 @@ static void nfs_show_mount_options(struct seq_file *m, struct nfs_server *nfss,
 		nfs_show_mountd_options(m, nfss, showdefaults);
 
 #ifdef CONFIG_NFS_V4
-	if (clp->rpc_ops->version == 4)
+	if (clp->rpc_ops->version == 4) {
 		seq_printf(m, ",clientaddr=%s", clp->cl_ipaddr);
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+		if (nfss->caps & NFS_CAP_SECURITY_LABEL)
+			seq_printf(m, ",security_label");
+		else
+			seq_printf(m, ",nosecurity_label");
+#endif
+	}
 #endif
 }
 
@@ -623,6 +630,12 @@ static int nfs_show_stats(struct seq_file *m, struct vfsmount *mnt)
 		seq_printf(m, "bm0=0x%x", nfss->attr_bitmask[0]);
 		seq_printf(m, ",bm1=0x%x", nfss->attr_bitmask[1]);
 		seq_printf(m, ",acl=0x%x", nfss->acl_bitmask);
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+		if (nfss->caps & NFS_CAP_SECURITY_LABEL)
+			seq_printf(m, ",security_label");
+		else
+			seq_printf(m, ",nosecurity_label");
+#endif
 	}
 #endif
 
@@ -2212,6 +2225,9 @@ static int nfs4_validate_mount_data(void *options,
 	if (data == NULL)
 		goto out_no_data;
 
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	args->flags		|= NFS4_MOUNT_SECURITY_LABEL; /* Default */
+#endif
 	args->rsize		= NFS_MAX_FILE_IO_SIZE;
 	args->wsize		= NFS_MAX_FILE_IO_SIZE;
 	args->acregmin		= NFS_DEF_ACREGMIN;
@@ -2399,6 +2415,21 @@ static int nfs4_get_sb(struct file_system_type *fs_type,
 		goto error_splat_super;
 	}
 
+#ifdef CONFIG_SECURITY_SELINUX
+	if (server->caps & NFS_CAP_SECURITY_LABEL)
+		security_sb_parse_opts_str("native_labels", &data->lsm_opts);
+	else
+		data->flags &= ~NFS4_MOUNT_SECURITY_LABEL;
+		/* XXX: we need a way to separate the default use of
+			security labels if supported from the userland
+			passing in the requirment that they be present.
+
+			default			- will
+			-o nosecurity_label 	- won't
+			-o security_label	- must
+		*/
+#endif
+
 	error = security_sb_set_mnt_opts(s, &data->lsm_opts);
 	if (error)
 		goto error_splat_root;
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index 6120a28..4dc2fc1 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -197,6 +197,7 @@ struct nfs_inode {
 #define NFS_INO_INVALID_ACL	0x0010		/* cached acls are invalid */
 #define NFS_INO_REVAL_PAGECACHE	0x0020		/* must revalidate pagecache */
 #define NFS_INO_REVAL_FORCED	0x0040		/* force revalidation ignoring a delegation */
+#define NFS_INO_INVALID_LABEL	0x0080		/* cached label is invalid */
 
 /*
  * Bit offsets in flags field
@@ -341,6 +342,7 @@ extern int nfs_revalidate_mapping(struct inode *inode, struct address_space *map
 extern int nfs_revalidate_mapping_nolock(struct inode *inode, struct address_space *mapping);
 extern int nfs_setattr(struct dentry *, struct iattr *);
 extern void nfs_setattr_update_inode(struct inode *inode, struct iattr *attr);
+extern void nfs_setsecurity(struct inode *inode, struct nfs_fattr *fattr);
 extern struct nfs_open_context *get_nfs_open_context(struct nfs_open_context *ctx);
 extern void put_nfs_open_context(struct nfs_open_context *ctx);
 extern struct nfs_open_context *nfs_find_open_context(struct inode *inode, struct rpc_cred *cred, int mode);
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 9e73750..4560f8f 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2844,7 +2844,10 @@ static void selinux_inode_post_setxattr(struct dentry *dentry, const char *name,
 		return;
 	}
 
+	isec->sclass = inode_mode_to_security_class(inode->i_mode);
 	isec->sid = newsid;
+	isec->initialized = 1;
+
 	return;
 }
 
@@ -2934,7 +2937,9 @@ static int selinux_inode_setsecurity(struct inode *inode, const char *name,
 	if (rc)
 		return rc;
 
+	isec->sclass = inode_mode_to_security_class(inode->i_mode);
 	isec->sid = newsid;
+	isec->initialized = 1;
 	return 0;
 }
 
-- 
1.5.5.1

