Return-Path: <linux-kernel-owner+w=401wt.eu-S1762093AbYB0Xf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762093AbYB0Xf2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 18:35:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758794AbYB0XfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 18:35:13 -0500
Received: from zombie.ncsc.mil ([144.51.88.131]:52299 "EHLO zombie.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511AbYB0XfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 18:35:10 -0500
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: hch@infradead.org, viro@ftp.linux.org.uk, trond.myklebust@fys.uio.no,
       bfields@fieldses.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       "David P. Quigley" <dpquigl@tycho.nsa.gov>
Subject: [PATCH 09/11] NFS: Client implementation of Labeled-NFS
Date: Wed, 27 Feb 2008 15:39:44 -0500
Message-Id: <1204144786-3502-10-git-send-email-dpquigl@tycho.nsa.gov>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <1204144786-3502-1-git-send-email-dpquigl@tycho.nsa.gov>
References: <1204144786-3502-1-git-send-email-dpquigl@tycho.nsa.gov>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are several places where recommended attributes are implemented in the
NFSv4 client code. This patch adds two functions to encode and decode the secid
recommended attribute which makes use of the LSM hooks added earlier. It also
adds code to grab the label from the file attribute structures and encode the
label to be sent back to the server. Even though the code is there to encode a
label to be sent back to the server there does not appear to be an interface to
use it yet.

Signed-off-by: David P. Quigley <dpquigl@tycho.nsa.gov>
---
 fs/nfs/dir.c             |   76 ++++++++++++++++++-
 fs/nfs/inode.c           |   42 ++++++++++-
 fs/nfs/nfs4proc.c        |  191 +++++++++++++++++++++++++++++++++++++++++++++-
 fs/nfs/nfs4xdr.c         |   49 ++++++++++++
 fs/nfs/super.c           |   11 +++
 security/security.c      |    1 +
 security/selinux/hooks.c |    8 ++-
 7 files changed, 372 insertions(+), 6 deletions(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 19808be..bcb9e52 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -40,6 +40,10 @@
 #include "iostat.h"
 #include "internal.h"
 
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+#include <linux/security.h>
+#endif
+
 /* #define NFS_DEBUG_VERBOSE 1 */
 
 static int nfs_opendir(struct inode *, struct file *);
@@ -1234,18 +1238,36 @@ static int nfs_create(struct inode *dir, struct dentry *dentry, int mode,
 	attr.ia_mode = mode;
 	attr.ia_valid = ATTR_MODE;
 
-	if ((nd->flags & LOOKUP_CREATE) != 0)
+	if ((nd->flags & LOOKUP_CREATE) != 0) {
 		open_flags = nd->intent.open.flags;
 
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+		if (nfs_server_capable(dir, NFS_CAP_SECURITY_LABEL)) {
+			error = security_dentry_init_security(dentry,
+					attr.ia_mode,
+					&attr.ia_label, &attr.ia_label_len);
+			if (error == 0)
+				attr.ia_valid |= ATTR_SECURITY_LABEL;
+		}
+#endif
+	}
 	lock_kernel();
 	error = NFS_PROTO(dir)->create(dir, dentry, &attr, open_flags, nd);
 	if (error != 0)
 		goto out_err;
 	unlock_kernel();
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (attr.ia_label != NULL)
+		security_release_secctx(attr.ia_label, attr.ia_label_len);
+#endif
 	return 0;
 out_err:
 	unlock_kernel();
 	d_drop(dentry);
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (attr.ia_label != NULL)
+		security_release_secctx(attr.ia_label, attr.ia_label_len);
+#endif
 	return error;
 }
 
@@ -1268,8 +1290,22 @@ nfs_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t rdev)
 	attr.ia_mode = mode;
 	attr.ia_valid = ATTR_MODE;
 
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (nfs_server_capable(dir, NFS_CAP_SECURITY_LABEL)) {
+		status = security_dentry_init_security(dentry,
+				attr.ia_mode,
+				&attr.ia_label, &attr.ia_label_len);
+		if (status == 0)
+			attr.ia_valid |= ATTR_SECURITY_LABEL;
+	}
+#endif
+
 	lock_kernel();
 	status = NFS_PROTO(dir)->mknod(dir, dentry, &attr, rdev);
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (attr.ia_label != NULL)
+		security_release_secctx(attr.ia_label, attr.ia_label_len);
+#endif
 	if (status != 0)
 		goto out_err;
 	unlock_kernel();
@@ -1277,6 +1313,10 @@ nfs_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t rdev)
 out_err:
 	unlock_kernel();
 	d_drop(dentry);
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (attr.ia_label != NULL)
+		security_release_secctx(attr.ia_label, attr.ia_label_len);
+#endif
 	return status;
 }
 
@@ -1295,15 +1335,31 @@ static int nfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	attr.ia_valid = ATTR_MODE;
 	attr.ia_mode = mode | S_IFDIR;
 
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (nfs_server_capable(dir, NFS_CAP_SECURITY_LABEL)) {
+		error = security_dentry_init_security(dentry, attr.ia_mode,
+				&attr.ia_label, &attr.ia_label_len);
+		if (error == 0)
+			attr.ia_valid |= ATTR_SECURITY_LABEL;
+	}
+#endif
 	lock_kernel();
 	error = NFS_PROTO(dir)->mkdir(dir, dentry, &attr);
 	if (error != 0)
 		goto out_err;
 	unlock_kernel();
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (attr.ia_label != NULL)
+		security_release_secctx(attr.ia_label, attr.ia_label_len);
+#endif
 	return 0;
 out_err:
 	d_drop(dentry);
 	unlock_kernel();
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (attr.ia_label != NULL)
+		security_release_secctx(attr.ia_label, attr.ia_label_len);
+#endif
 	return error;
 }
 
@@ -1513,6 +1569,16 @@ static int nfs_symlink(struct inode *dir, struct dentry *dentry, const char *sym
 	attr.ia_mode = S_IFLNK | S_IRWXUGO;
 	attr.ia_valid = ATTR_MODE;
 
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (nfs_server_capable(dir, NFS_CAP_SECURITY_LABEL)) {
+		error = security_dentry_init_security(dentry,
+				attr.ia_mode,
+				&attr.ia_label, &attr.ia_label_len);
+		if (error == 0)
+			attr.ia_valid |= ATTR_SECURITY_LABEL;
+	}
+#endif
+
 	lock_kernel();
 
 	page = alloc_page(GFP_HIGHUSER);
@@ -1535,6 +1601,10 @@ static int nfs_symlink(struct inode *dir, struct dentry *dentry, const char *sym
 		d_drop(dentry);
 		__free_page(page);
 		unlock_kernel();
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+		if (attr.ia_label != NULL)
+			security_release_secctx(attr.ia_label, attr.ia_label_len);
+#endif
 		return error;
 	}
 
@@ -1553,6 +1623,10 @@ static int nfs_symlink(struct inode *dir, struct dentry *dentry, const char *sym
 		__free_page(page);
 
 	unlock_kernel();
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (attr.ia_label != NULL)
+		security_release_secctx(attr.ia_label, attr.ia_label_len);
+#endif
 	return 0;
 }
 
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index c34fb7c..229b0e8 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -37,6 +37,7 @@
 #include <linux/vfs.h>
 #include <linux/inet.h>
 #include <linux/nfs_xdr.h>
+#include <linux/xattr.h>
 
 #include <asm/system.h>
 #include <asm/uaccess.h>
@@ -47,6 +48,10 @@
 #include "iostat.h"
 #include "internal.h"
 
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+#include <linux/security.h>
+#endif
+
 #define NFSDBG_FACILITY		NFSDBG_VFS
 
 #define NFS_64_BIT_INODE_NUMBERS_ENABLED	1
@@ -237,6 +242,27 @@ nfs_init_locked(struct inode *inode, void *opaque)
 /* Don't use READDIRPLUS on directories that we believe are too large */
 #define NFS_LIMIT_READDIRPLUS (8*PAGE_SIZE)
 
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+static inline void nfs_setsecurity(struct inode *inode, struct nfs_fattr *fattr)
+{
+	int error;
+
+	if ((fattr->valid & NFS_ATTR_FATTR_V4) &&
+	    (fattr->bitmap[1] & FATTR4_WORD1_SECURITY_LABEL) &&
+	    (fattr->label != NULL) &&
+	    (inode->i_security != NULL)) {
+		const char *key = security_maclabel_getname() +
+					XATTR_SECURITY_PREFIX_LEN;
+		error = security_inode_setsecurity(inode, key, fattr->label,
+						   fattr->label_len, 0);
+		if (error)
+			printk(KERN_ERR
+				"%s() %s %d security_inode_setsecurity() %d\n",
+			       __func__, fattr->label, fattr->label_len,
+			       error);
+	}
+}
+#endif
 /*
  * This is our front-end to iget that looks up inodes by file handle
  * instead of inode number.
@@ -317,6 +343,11 @@ nfs_fhget(struct super_block *sb, struct nfs_fh *fh, struct nfs_fattr *fattr)
 		inode->i_nlink = fattr->nlink;
 		inode->i_uid = fattr->uid;
 		inode->i_gid = fattr->gid;
+
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+		nfs_setsecurity(inode, fattr);
+#endif /* CONFIG_NFS_V4_SECURITY_LABEL  */
+
 		if (fattr->valid & (NFS_ATTR_FATTR_V3 | NFS_ATTR_FATTR_V4)) {
 			/*
 			 * report the blocks in 512byte units
@@ -346,7 +377,7 @@ out_no_inode:
 	goto out;
 }
 
-#define NFS_VALID_ATTRS (ATTR_MODE|ATTR_UID|ATTR_GID|ATTR_SIZE|ATTR_ATIME|ATTR_ATIME_SET|ATTR_MTIME|ATTR_MTIME_SET)
+#define NFS_VALID_ATTRS (ATTR_MODE|ATTR_UID|ATTR_GID|ATTR_SIZE|ATTR_ATIME|ATTR_ATIME_SET|ATTR_MTIME|ATTR_MTIME_SET|ATTR_SECURITY_LABEL)
 
 int
 nfs_setattr(struct dentry *dentry, struct iattr *attr)
@@ -425,6 +456,11 @@ void nfs_setattr_update_inode(struct inode *inode, struct iattr *attr)
 		inode->i_size = attr->ia_size;
 		vmtruncate(inode, attr->ia_size);
 	}
+
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if ((attr->ia_valid & ATTR_SECURITY_LABEL) != 0)
+		inode_setsecurity(inode, attr);
+#endif
 }
 
 static int nfs_wait_schedule(void *word)
@@ -1085,6 +1121,10 @@ static int nfs_update_inode(struct inode *inode, struct nfs_fattr *fattr)
 	inode->i_uid = fattr->uid;
 	inode->i_gid = fattr->gid;
 
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	nfs_setsecurity(inode, fattr);
+#endif /* CONFIG_NFS_V4_SECURITY_LABEL */
+
 	if (fattr->valid & (NFS_ATTR_FATTR_V3 | NFS_ATTR_FATTR_V4)) {
 		/*
 		 * report the blocks in 512byte units
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index b278f7c..a1a4051 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -48,11 +48,18 @@
 #include <linux/smp_lock.h>
 #include <linux/namei.h>
 #include <linux/mount.h>
+#include <linux/xattr.h>
+#include <linux/nfs4_mount.h>
+#include <linux/fsnotify.h>
 
 #include "nfs4_fs.h"
 #include "delegation.h"
 #include "iostat.h"
 
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+#include <linux/security.h>
+#endif
+
 #define NFSDBG_FACILITY		NFSDBG_PROC
 
 #define NFS4_POLL_RETRY_MIN	(HZ/10)
@@ -1419,25 +1426,40 @@ nfs4_atomic_open(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
 	struct nfs4_state *state;
 	struct dentry *res;
 
+	cred = rpcauth_lookupcred(NFS_CLIENT(dir)->cl_auth, 0);
+	if (IS_ERR(cred))
+		return (struct dentry *)cred;
+
 	memset(&attr, 0, sizeof(struct iattr));
 	if (nd->flags & LOOKUP_CREATE) {
 		attr.ia_mode = nd->intent.open.create_mode;
 		attr.ia_valid = ATTR_MODE;
 		if (!IS_POSIXACL(dir))
 			attr.ia_mode &= ~current->fs->umask;
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+		if (nfs_server_capable(dir, NFS_CAP_SECURITY_LABEL)) {
+			int error;
+			error = security_dentry_init_security(dentry,
+					attr.ia_mode,
+					&attr.ia_label, &attr.ia_label_len);
+			if (error == 0)
+				attr.ia_valid |= ATTR_SECURITY_LABEL;
+		}
+#endif
 	} else {
 		attr.ia_valid = 0;
 		BUG_ON(nd->intent.open.flags & O_CREAT);
 	}
 
-	cred = rpcauth_lookupcred(NFS_CLIENT(dir)->cl_auth, 0);
-	if (IS_ERR(cred))
-		return (struct dentry *)cred;
 	parent = dentry->d_parent;
 	/* Protect against concurrent sillydeletes */
 	nfs_block_sillyrename(parent);
 	state = nfs4_do_open(dir, &path, nd->intent.open.flags, &attr, cred);
 	put_rpccred(cred);
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (attr.ia_label != NULL)
+		security_release_secctx(attr.ia_label, attr.ia_label_len);
+#endif
 	if (IS_ERR(state)) {
 		if (PTR_ERR(state) == -ENOENT) {
 			d_add(dentry, NULL);
@@ -1510,6 +1532,13 @@ static int _nfs4_server_capabilities(struct nfs_server *server, struct nfs_fh *f
 		memcpy(server->attr_bitmask, res.attr_bitmask, sizeof(server->attr_bitmask));
 		if (res.attr_bitmask[0] & FATTR4_WORD0_ACL)
 			server->caps |= NFS_CAP_ACLS;
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+		if (server->flags & NFS4_MOUNT_SECURITY_LABEL &&
+			res.attr_bitmask[1] & FATTR4_WORD1_SECURITY_LABEL) {
+			server->caps |= NFS_CAP_SECURITY_LABEL;
+		} else
+#endif
+		server->attr_bitmask[1] &= ~FATTR4_WORD1_SECURITY_LABEL;
 		if (res.has_links != 0)
 			server->caps |= NFS_CAP_HARDLINKS;
 		if (res.has_symlinks != 0)
@@ -2862,6 +2891,162 @@ static int nfs4_proc_set_acl(struct inode *inode, const void *buf, size_t buflen
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
+				      struct iattr *sattr,
+				      struct nfs_fattr *fattr,
+				      struct nfs4_state *state)
+{
+	struct nfs_server *server = NFS_SERVER(inode);
+	const u32 bitmask[2] = { 0, FATTR4_WORD1_SECURITY_LABEL };
+	struct nfs_setattrargs args = {
+		.fh             = NFS_FH(inode),
+		.iap            = sattr,
+		.server		= server,
+		.bitmask	= bitmask,
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
+				     struct iattr *sattr,
+				     struct nfs_fattr *fattr,
+				     struct nfs4_state *state)
+{
+	struct nfs4_exception exception = { };
+	int err;
+
+	do {
+		err = nfs4_handle_exception(NFS_SERVER(inode),
+			_nfs4_do_set_security_label(inode, sattr, fattr, state),
+			&exception);
+	} while (exception.retry);
+	return err;
+}
+
+static int
+nfs4_set_security_label(struct dentry *dentry, const void *buf, size_t buflen)
+{
+	struct nfs_fattr fattr;
+	struct iattr sattr;
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
+	memset(&sattr, 0, sizeof(struct iattr));
+	sattr.ia_valid = ATTR_SECURITY_LABEL;
+	sattr.ia_label = (char *)buf;
+	sattr.ia_label_len = buflen;
+
+	cred = rpcauth_lookupcred(NFS_CLIENT(inode)->cl_auth, 0);
+	if (IS_ERR(cred))
+		return PTR_ERR(cred);
+
+	/* Search for an existing open(O_WRITE) file */
+	ctx = nfs_find_open_context(inode, cred, FMODE_WRITE);
+	if (ctx != NULL)
+		state = ctx->state;
+
+	status = nfs4_do_set_security_label(inode, &sattr, &fattr, state);
+	if (status == 0) {
+		nfs_setattr_update_inode(inode, &sattr);
+		fsnotify_change(dentry, sattr.ia_valid);
+	}
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
index db1ed9c..ed7ec8b 100644
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -651,6 +651,10 @@ static int encode_attrs(struct xdr_stream *xdr, const struct iattr *iap, const s
 		}
 		len += 4 + (XDR_QUADLEN(owner_grouplen) << 2);
 	}
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (iap->ia_valid & ATTR_SECURITY_LABEL)
+		len += 4 + (XDR_QUADLEN(iap->ia_label_len) << 2);
+#endif
 	if (iap->ia_valid & ATTR_ATIME_SET)
 		len += 16;
 	else if (iap->ia_valid & ATTR_ATIME)
@@ -709,6 +713,13 @@ static int encode_attrs(struct xdr_stream *xdr, const struct iattr *iap, const s
 		bmval1 |= FATTR4_WORD1_TIME_MODIFY_SET;
 		WRITE32(NFS4_SET_TO_SERVER_TIME);
 	}
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (iap->ia_valid & ATTR_SECURITY_LABEL) {
+		bmval1 |= FATTR4_WORD1_SECURITY_LABEL;
+		WRITE32(iap->ia_label_len);
+		WRITEMEM(iap->ia_label, iap->ia_label_len);
+	}
+#endif /* CONFIG_NFS_V4_SECURITY_LABEL */
 	
 	/*
 	 * Now we backfill the bitmap and the attribute buffer length.
@@ -2954,6 +2965,40 @@ static int decode_attr_time_modify(struct xdr_stream *xdr, uint32_t *bitmap, str
 	return status;
 }
 
+static int decode_attr_security_label(struct xdr_stream *xdr, uint32_t *bitmap, char **ctx, u32 *ctxlen)
+{
+	uint32_t len;
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
+					    "%s(): ctxlen (%d) < len (%d)\n",
+						__func__, *ctxlen, len);
+					/* rc = -ENOMEM; */
+					*ctx = NULL;	/* leak */
+				} else {
+					memcpy(*ctx, (char *)p, len);
+					(*ctx)[len + 1] = '\0';
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
@@ -3186,6 +3231,10 @@ static int decode_getfattr(struct xdr_stream *xdr, struct nfs_fattr *fattr, cons
 		goto xdr_error;
 	if ((status = decode_attr_mounted_on_fileid(xdr, bitmap, &fileid)) != 0)
 		goto xdr_error;
+	if ((status = decode_attr_security_label(xdr, bitmap,
+						 &fattr->label,
+						 &fattr->label_len)) != 0)
+		goto xdr_error;
 	if (fattr->fileid == 0 && fileid != 0)
 		fattr->fileid = fileid;
 	if ((status = verify_attr_len(xdr, savep, attrlen)) == 0)
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index 95f2fad..815ca3c 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -492,6 +492,13 @@ static void nfs_show_mount_options(struct seq_file *m, struct nfs_server *nfss,
 	seq_printf(m, ",timeo=%lu", 10U * nfss->client->cl_timeout->to_initval / HZ);
 	seq_printf(m, ",retrans=%u", nfss->client->cl_timeout->to_retries);
 	seq_printf(m, ",sec=%s", nfs_pseudoflavour_to_name(nfss->client->cl_auth->au_flavor));
+
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if ((nfss->nfs_client->rpc_ops->version == 4) &&
+	    (nfss->attr_bitmask[1] & FATTR4_WORD1_SECURITY_LABEL))
+		seq_printf(m, ",security_label");
+#endif /* CONFIG_NFS_V4_SECURITY_LABEL */
+
 }
 
 /*
@@ -547,6 +554,10 @@ static int nfs_show_stats(struct seq_file *m, struct vfsmount *mnt)
 		seq_printf(m, "bm0=0x%x", nfss->attr_bitmask[0]);
 		seq_printf(m, ",bm1=0x%x", nfss->attr_bitmask[1]);
 		seq_printf(m, ",acl=0x%x", nfss->acl_bitmask);
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+		if (nfss->attr_bitmask[1] & FATTR4_WORD1_SECURITY_LABEL)
+			seq_printf(m, ",security_label");
+#endif /* CONFIG_NFS_V4_SECURITY_LABEL */
 	}
 #endif
 
diff --git a/security/security.c b/security/security.c
index b6e80bb..1276c98 100644
--- a/security/security.c
+++ b/security/security.c
@@ -517,6 +517,7 @@ int security_inode_setsecurity(struct inode *inode, const char *name, const void
 		return 0;
 	return security_ops->inode_setsecurity(inode, name, value, size, flags);
 }
+EXPORT_SYMBOL(security_inode_setsecurity);
 
 int security_inode_listsecurity(struct inode *inode, char *buffer, size_t buffer_size)
 {
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index e3ed7c3..1742aaa 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2683,7 +2683,11 @@ static void selinux_inode_post_setxattr(struct dentry *dentry, char *name,
 		return;
 	}
 
+	isec->sclass = inode_mode_to_security_class(inode->i_mode);
 	isec->sid = newsid;
+	isec->initialized = 1;
+
+	fsnotify_change(dentry, ATTR_SECURITY_LABEL);
 	return;
 }
 
@@ -2754,7 +2758,9 @@ static int selinux_inode_setsecurity(struct inode *inode, const char *name,
 	if (rc)
 		return rc;
 
-	isec->sid = newsid;
+	isec->sclass = inode_mode_to_security_class(inode->i_mode);
+ 	isec->sid = newsid;
+	isec->initialized = 1;
 	return 0;
 }
 
-- 
1.5.3.8

