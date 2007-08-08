Return-Path: <linux-kernel-owner+w=401wt.eu-S937554AbXHHRXC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937554AbXHHRXC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 13:23:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937348AbXHHRTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 13:19:17 -0400
Received: from mail.suse.de ([195.135.220.2]:38771 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763318AbXHHRTF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 13:19:05 -0400
Message-Id: <20070808171644.525649633@suse.de>
References: <20070808171622.632749741@suse.de>
User-Agent: quilt/0.46-1
Date: Wed, 08 Aug 2007 19:16:31 +0200
From: Andreas Gruenbacher <agruen@suse.de>
To: linux-kernel@vger.kernel.org
Cc: John Johansen <jjohansen@suse.de>, Jan Blunck <jblunck@suse.de>,
       Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [RFC 09/10] Pass no unnecessary information to dop->d_revalidate
Content-Disposition: inline; filename=d_revalidate-args.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

dop->d_revalidate does not need a full nameidata. Pass a struct vfs_lookup
instead.

Signed-off-by: Andreas Gruenbacher <ag@bestbits.at>

---
 fs/afs/dir.c           |    4 ++--
 fs/autofs/root.c       |    4 ++--
 fs/autofs4/root.c      |   12 ++++++------
 fs/cifs/dir.c          |    2 +-
 fs/coda/dir.c          |    4 ++--
 fs/ecryptfs/dentry.c   |   20 +++++++++-----------
 fs/fuse/dir.c          |    3 ++-
 fs/gfs2/ops_dentry.c   |    4 ++--
 fs/hfs/sysdep.c        |    3 ++-
 fs/namei.c             |   13 +++++++------
 fs/ncpfs/dir.c         |    8 ++++----
 fs/nfs/dir.c           |   42 ++++++++++++++++++++++--------------------
 fs/nfs/nfs4_fs.h       |    2 +-
 fs/nfs/nfs4proc.c      |    8 ++++----
 fs/ocfs2/dcache.c      |    2 +-
 fs/proc/base.c         |    7 ++++---
 fs/proc/proc_sysctl.c  |    2 +-
 fs/smbfs/dir.c         |    4 ++--
 fs/vfat/namei.c        |    6 +++---
 include/linux/dcache.h |    3 ++-
 20 files changed, 79 insertions(+), 74 deletions(-)

--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -23,7 +23,7 @@ static struct dentry *afs_lookup(struct 
 				 struct nameidata *nd);
 static int afs_dir_open(struct inode *inode, struct file *file);
 static int afs_readdir(struct file *file, void *dirent, filldir_t filldir);
-static int afs_d_revalidate(struct dentry *dentry, struct nameidata *nd);
+static int afs_d_revalidate(struct dentry *dentry, struct vfs_lookup *lookup);
 static int afs_d_delete(struct dentry *dentry);
 static void afs_d_release(struct dentry *dentry);
 static int afs_lookup_filldir(void *_cookie, const char *name, int nlen,
@@ -560,7 +560,7 @@ static struct dentry *afs_lookup(struct 
  * - NOTE! the hit can be a negative hit too, so we can't assume we have an
  *   inode
  */
-static int afs_d_revalidate(struct dentry *dentry, struct nameidata *nd)
+static int afs_d_revalidate(struct dentry *dentry, struct vfs_lookup *lookup)
 {
 	struct afs_vnode *vnode, *dir;
 	struct afs_fid fid;
--- a/fs/autofs/root.c
+++ b/fs/autofs/root.c
@@ -145,7 +145,7 @@ static int try_to_fill_dentry(struct den
  * yet completely filled in, and revalidate has to delay such
  * lookups..
  */
-static int autofs_revalidate(struct dentry * dentry, struct nameidata *nd)
+static int autofs_revalidate(struct dentry * dentry, struct vfs_lookup *lookup)
 {
 	struct inode * dir;
 	struct autofs_sb_info *sbi;
@@ -233,7 +233,7 @@ static struct dentry *autofs_root_lookup
 	d_add(dentry, NULL);
 
 	mutex_unlock(&dir->i_mutex);
-	autofs_revalidate(dentry, nd);
+	autofs_revalidate(dentry, &nd->lookup);
 	mutex_lock(&dir->i_mutex);
 
 	/*
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -122,7 +122,7 @@ static int autofs4_dir_open(struct inode
 
 	status = -ENOENT;
 	if (!d_mountpoint(dentry) && dentry->d_op && dentry->d_op->d_revalidate) {
-		struct nameidata nd;
+		struct vfs_lookup lookup;
 		int empty, ret;
 
 		/* In case there are stale directory dentrys from a failed mount */
@@ -133,8 +133,8 @@ static int autofs4_dir_open(struct inode
 		if (!empty)
 			d_invalidate(dentry);
 
-		nd.lookup.flags = LOOKUP_DIRECTORY;
-		ret = (dentry->d_op->d_revalidate)(dentry, &nd);
+		lookup.flags = LOOKUP_DIRECTORY;
+		ret = (dentry->d_op->d_revalidate)(dentry, &lookup);
 
 		if (ret <= 0) {
 			if (ret < 0)
@@ -392,12 +392,12 @@ out_error:
  * yet completely filled in, and revalidate has to delay such
  * lookups..
  */
-static int autofs4_revalidate(struct dentry *dentry, struct nameidata *nd)
+static int autofs4_revalidate(struct dentry *dentry, struct vfs_lookup *lookup)
 {
 	struct inode *dir = dentry->d_parent->d_inode;
 	struct autofs_sb_info *sbi = autofs4_sbi(dir->i_sb);
 	int oz_mode = autofs4_oz_mode(sbi);
-	int flags = nd ? nd->lookup.flags : 0;
+	int flags = lookup ? lookup->flags : 0;
 	int status = 1;
 
 	/* Pending dentry */
@@ -627,7 +627,7 @@ static struct dentry *autofs4_lookup(str
 
 	if (dentry->d_op && dentry->d_op->d_revalidate) {
 		mutex_unlock(&dir->i_mutex);
-		(dentry->d_op->d_revalidate)(dentry, nd);
+		(dentry->d_op->d_revalidate)(dentry, &nd->lookup);
 		mutex_lock(&dir->i_mutex);
 	}
 
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -531,7 +531,7 @@ cifs_lookup(struct inode *parent_dir_ino
 }
 
 static int
-cifs_d_revalidate(struct dentry *direntry, struct nameidata *nd)
+cifs_d_revalidate(struct dentry *direntry, struct vfs_lookup *lookup)
 {
 	int isValid = 1;
 
--- a/fs/coda/dir.c
+++ b/fs/coda/dir.c
@@ -45,7 +45,7 @@ static int coda_rename(struct inode *old
 static int coda_readdir(struct file *file, void *buf, filldir_t filldir);
 
 /* dentry ops */
-static int coda_dentry_revalidate(struct dentry *de, struct nameidata *nd);
+static int coda_dentry_revalidate(struct dentry *de, struct vfs_lookup *lookup);
 static int coda_dentry_delete(struct dentry *);
 
 /* support routines */
@@ -583,7 +583,7 @@ out:
 }
 
 /* called when a cache lookup succeeds */
-static int coda_dentry_revalidate(struct dentry *de, struct nameidata *nd)
+static int coda_dentry_revalidate(struct dentry *de, struct vfs_lookup *lookup)
 {
 	struct inode *inode = de->d_inode;
 	struct coda_inode_info *cii;
--- a/fs/ecryptfs/dentry.c
+++ b/fs/ecryptfs/dentry.c
@@ -31,7 +31,7 @@
 /**
  * ecryptfs_d_revalidate - revalidate an ecryptfs dentry
  * @dentry: The ecryptfs dentry
- * @nd: The associated nameidata
+ * @lookup: The associated vfs_lookup
  *
  * Called when the VFS needs to revalidate a dentry. This
  * is called whenever a name lookup finds a dentry in the
@@ -41,23 +41,21 @@
  * Returns 1 if valid, 0 otherwise.
  *
  */
-static int ecryptfs_d_revalidate(struct dentry *dentry, struct nameidata *nd)
+static int ecryptfs_d_revalidate(struct dentry *dentry,
+				 struct vfs_lookup *lookup)
 {
 	struct dentry *lower_dentry = ecryptfs_dentry_to_lower(dentry);
 	struct vfsmount *lower_mnt = ecryptfs_dentry_to_lower_mnt(dentry);
-	struct dentry *dentry_save;
-	struct vfsmount *vfsmount_save;
+	struct path path_save;
 	int rc = 1;
 
 	if (!lower_dentry->d_op || !lower_dentry->d_op->d_revalidate)
 		goto out;
-	dentry_save = nd->lookup.path.dentry;
-	vfsmount_save = nd->lookup.path.mnt;
-	nd->lookup.path.dentry = lower_dentry;
-	nd->lookup.path.mnt = lower_mnt;
-	rc = lower_dentry->d_op->d_revalidate(lower_dentry, nd);
-	nd->lookup.path.dentry = dentry_save;
-	nd->lookup.path.mnt = vfsmount_save;
+	path_save = lookup->path;
+	lookup->path.dentry = lower_dentry;
+	lookup->path.mnt = lower_mnt;
+	rc = lower_dentry->d_op->d_revalidate(lower_dentry, lookup);
+	lookup->path = path_save;
 	if (dentry->d_inode) {
 		struct inode *lower_inode =
 			ecryptfs_inode_to_lower(dentry->d_inode);
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -127,7 +127,8 @@ static void fuse_lookup_init(struct fuse
  * the lookup once more.  If the lookup results in the same inode,
  * then refresh the attributes, timeouts and mark the dentry valid.
  */
-static int fuse_dentry_revalidate(struct dentry *entry, struct nameidata *nd)
+static int fuse_dentry_revalidate(struct dentry *entry,
+				  struct vfs_lookup *lookup)
 {
 	struct inode *inode = entry->d_inode;
 
--- a/fs/gfs2/ops_dentry.c
+++ b/fs/gfs2/ops_dentry.c
@@ -26,7 +26,7 @@
 /**
  * gfs2_drevalidate - Check directory lookup consistency
  * @dentry: the mapping to check
- * @nd:
+ * @lookup:
  *
  * Check to make sure the lookup necessary to arrive at this inode from its
  * parent is still good.
@@ -34,7 +34,7 @@
  * Returns: 1 if the dentry is ok, 0 if it isn't
  */
 
-static int gfs2_drevalidate(struct dentry *dentry, struct nameidata *nd)
+static int gfs2_drevalidate(struct dentry *dentry, struct vfs_lookup *lookup)
 {
 	struct dentry *parent = dget_parent(dentry);
 	struct gfs2_sbd *sdp = GFS2_SB(parent->d_inode);
--- a/fs/hfs/sysdep.c
+++ b/fs/hfs/sysdep.c
@@ -12,7 +12,8 @@
 
 /* dentry case-handling: just lowercase everything */
 
-static int hfs_revalidate_dentry(struct dentry *dentry, struct nameidata *nd)
+static int hfs_revalidate_dentry(struct dentry *dentry,
+				 struct vfs_lookup *lookup)
 {
 	struct inode *inode = dentry->d_inode;
 	int diff;
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -380,9 +380,9 @@ void release_open_intent(struct open_int
 }
 
 static inline struct dentry *
-do_revalidate(struct dentry *dentry, struct nameidata *nd)
+do_revalidate(struct dentry *dentry, struct vfs_lookup *lookup)
 {
-	int status = dentry->d_op->d_revalidate(dentry, nd);
+	int status = dentry->d_op->d_revalidate(dentry, lookup);
 	if (unlikely(status <= 0)) {
 		/*
 		 * The dentry failed validation.
@@ -418,7 +418,7 @@ static struct dentry * cached_lookup(str
 		dentry = d_lookup(parent, name);
 
 	if (dentry && dentry->d_op && dentry->d_op->d_revalidate)
-		dentry = do_revalidate(dentry, nd);
+		dentry = do_revalidate(dentry, &nd->lookup);
 
 	return dentry;
 }
@@ -511,7 +511,7 @@ static struct dentry * real_lookup(struc
 	 */
 	mutex_unlock(&dir->i_mutex);
 	if (result->d_op && result->d_op->d_revalidate) {
-		result = do_revalidate(result, nd);
+		result = do_revalidate(result, &nd->lookup);
 		if (!result)
 			result = ERR_PTR(-ENOENT);
 	}
@@ -792,7 +792,7 @@ need_lookup:
 	goto done;
 
 need_revalidate:
-	dentry = do_revalidate(dentry, nd);
+	dentry = do_revalidate(dentry, &nd->lookup);
 	if (!dentry)
 		goto need_lookup;
 	if (IS_ERR(dentry))
@@ -982,7 +982,8 @@ return_reval:
 		    (nd->lookup.path.dentry->d_sb->s_type->fs_flags & FS_REVAL_DOT)) {
 			err = -ESTALE;
 			/* Note: we do not d_invalidate() */
-			if (!nd->lookup.path.dentry->d_op->d_revalidate(nd->lookup.path.dentry, nd))
+			if (!nd->lookup.path.dentry->d_op->d_revalidate(
+					nd->lookup.path.dentry, &nd->lookup))
 				break;
 		}
 return_base:
--- a/fs/ncpfs/dir.c
+++ b/fs/ncpfs/dir.c
@@ -74,7 +74,7 @@ const struct inode_operations ncp_dir_in
 /*
  * Dentry operations routines
  */
-static int ncp_lookup_validate(struct dentry *, struct nameidata *);
+static int ncp_lookup_validate(struct dentry *, struct vfs_lookup *);
 static int ncp_hash_dentry(struct dentry *, struct qstr *);
 static int ncp_compare_dentry (struct dentry *, struct qstr *, struct qstr *);
 static int ncp_delete_dentry(struct dentry *);
@@ -266,7 +266,7 @@ leave_me:;
 
 
 static int
-__ncp_lookup_validate(struct dentry * dentry, struct nameidata *nd)
+__ncp_lookup_validate(struct dentry * dentry, struct vfs_lookup *lookup)
 {
 	struct ncp_server *server;
 	struct dentry *parent;
@@ -336,11 +336,11 @@ finished:
 }
 
 static int
-ncp_lookup_validate(struct dentry * dentry, struct nameidata *nd)
+ncp_lookup_validate(struct dentry * dentry, struct vfs_lookup *lookup)
 {
 	int res;
 	lock_kernel();
-	res = __ncp_lookup_validate(dentry, nd);
+	res = __ncp_lookup_validate(dentry, lookup);
 	unlock_kernel();
 	return res;
 }
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -703,16 +703,16 @@ static inline unsigned int nfs_lookup_ch
  *
  */
 static inline
-int nfs_lookup_verify_inode(struct inode *inode, struct nameidata *nd)
+int nfs_lookup_verify_inode(struct inode *inode, struct vfs_lookup *lookup)
 {
 	struct nfs_server *server = NFS_SERVER(inode);
 
-	if (nd != NULL) {
+	if (lookup) {
 		/* VFS wants an on-the-wire revalidation */
-		if (nd->lookup.flags & LOOKUP_REVAL)
+		if (lookup->flags & LOOKUP_REVAL)
 			goto out_force;
 		/* This is an open(2) */
-		if (nfs_lookup_check_intent(&nd->lookup, LOOKUP_OPEN) != 0 &&
+		if (nfs_lookup_check_intent(lookup, LOOKUP_OPEN) != 0 &&
 				!(server->flags & NFS_MOUNT_NOCTO) &&
 				(S_ISREG(inode->i_mode) ||
 				 S_ISDIR(inode->i_mode)))
@@ -732,10 +732,10 @@ out_force:
  */
 static inline
 int nfs_neg_need_reval(struct inode *dir, struct dentry *dentry,
-		       struct nameidata *nd)
+		       struct vfs_lookup *lookup)
 {
 	/* Don't revalidate a negative dentry if we're creating a new file */
-	if (nd != NULL && nfs_lookup_check_intent(&nd->lookup, LOOKUP_CREATE) != 0)
+	if (lookup && nfs_lookup_check_intent(lookup, LOOKUP_CREATE) != 0)
 		return 0;
 	return !nfs_check_verifier(dir, dentry);
 }
@@ -751,7 +751,8 @@ int nfs_neg_need_reval(struct inode *dir
  * If the parent directory is seen to have changed, we throw out the
  * cached dentry and do a new lookup.
  */
-static int nfs_lookup_revalidate(struct dentry * dentry, struct nameidata *nd)
+static int nfs_lookup_revalidate(struct dentry *dentry,
+				 struct vfs_lookup *lookup)
 {
 	struct inode *dir;
 	struct inode *inode;
@@ -772,7 +773,7 @@ static int nfs_lookup_revalidate(struct 
 		goto out_zap_parent;
 
 	if (!inode) {
-		if (nfs_neg_need_reval(dir, dentry, nd))
+		if (nfs_neg_need_reval(dir, dentry, lookup))
 			goto out_bad;
 		goto out_valid;
 	}
@@ -786,7 +787,7 @@ static int nfs_lookup_revalidate(struct 
 
 	/* Force a full look up iff the parent directory has changed */
 	if (nfs_check_verifier(dir, dentry)) {
-		if (nfs_lookup_verify_inode(inode, nd))
+		if (nfs_lookup_verify_inode(inode, lookup))
 			goto out_zap_parent;
 		goto out_valid;
 	}
@@ -977,7 +978,7 @@ out:
 }
 
 #ifdef CONFIG_NFS_V4
-static int nfs_open_revalidate(struct dentry *, struct nameidata *);
+static int nfs_open_revalidate(struct dentry *, struct vfs_lookup *);
 
 struct dentry_operations nfs4_dentry_operations = {
 	.d_revalidate	= nfs_open_revalidate,
@@ -989,15 +990,16 @@ struct dentry_operations nfs4_dentry_ope
  * Use intent information to determine whether we need to substitute
  * the NFSv4-style stateful OPEN for the LOOKUP call
  */
-static int is_atomic_open(struct inode *dir, struct nameidata *nd)
+static int is_atomic_open(struct inode *dir, struct vfs_lookup *lookup)
 {
-	if (nd == NULL || nfs_lookup_check_intent(&nd->lookup, LOOKUP_OPEN) == 0)
+	if (!lookup || nfs_lookup_check_intent(lookup, LOOKUP_OPEN) == 0)
 		return 0;
 	/* NFS does not (yet) have a stateful open for directories */
-	if (nd->lookup.flags & LOOKUP_DIRECTORY)
+	if (lookup->flags & LOOKUP_DIRECTORY)
 		return 0;
 	/* Are we trying to write to a read only partition? */
-	if (IS_RDONLY(dir) && (nd->lookup.intent.open.flags & (O_CREAT|O_TRUNC|FMODE_WRITE)))
+	if (IS_RDONLY(dir) && (lookup->intent.open.flags &
+			       (O_CREAT|O_TRUNC|FMODE_WRITE)))
 		return 0;
 	return 1;
 }
@@ -1011,7 +1013,7 @@ static struct dentry *nfs_atomic_lookup(
 			dir->i_sb->s_id, dir->i_ino, dentry->d_name.name);
 
 	/* Check that we are indeed trying to open this file */
-	if (!is_atomic_open(dir, nd))
+	if (!is_atomic_open(dir, &nd->lookup))
 		goto no_open;
 
 	if (dentry->d_name.len > NFS_SERVER(dir)->namelen) {
@@ -1071,7 +1073,7 @@ no_open:
 	return nfs_lookup(dir, dentry, nd);
 }
 
-static int nfs_open_revalidate(struct dentry *dentry, struct nameidata *nd)
+static int nfs_open_revalidate(struct dentry *dentry, struct vfs_lookup *lookup)
 {
 	struct dentry *parent = NULL;
 	struct inode *inode = dentry->d_inode;
@@ -1081,7 +1083,7 @@ static int nfs_open_revalidate(struct de
 
 	parent = dget_parent(dentry);
 	dir = parent->d_inode;
-	if (!is_atomic_open(dir, nd))
+	if (!is_atomic_open(dir, lookup))
 		goto no_open;
 	/* We can't create new files in nfs_open_revalidate(), so we
 	 * optimize away revalidation of negative dentries.
@@ -1091,7 +1093,7 @@ static int nfs_open_revalidate(struct de
 	/* NFS only supports OPEN on regular files */
 	if (!S_ISREG(inode->i_mode))
 		goto no_open;
-	openflags = nd->lookup.intent.open.flags;
+	openflags = lookup->intent.open.flags;
 	/* We cannot do exclusive creation on a positive dentry */
 	if ((openflags & (O_CREAT|O_EXCL)) == (O_CREAT|O_EXCL))
 		goto no_open;
@@ -1105,7 +1107,7 @@ static int nfs_open_revalidate(struct de
 	 */
 	lock_kernel();
 	verifier = nfs_save_change_attribute(dir);
-	ret = nfs4_open_revalidate(dir, dentry, openflags, nd);
+	ret = nfs4_open_revalidate(dir, dentry, openflags, lookup);
 	if (!ret)
 		nfs_refresh_verifier(dentry, verifier);
 	unlock_kernel();
@@ -1118,7 +1120,7 @@ no_open:
 	dput(parent);
 	if (inode != NULL && nfs_have_delegation(inode, FMODE_READ))
 		return 1;
-	return nfs_lookup_revalidate(dentry, nd);
+	return nfs_lookup_revalidate(dentry, lookup);
 }
 #endif /* CONFIG_NFSV4 */
 
--- a/fs/nfs/nfs4_fs.h
+++ b/fs/nfs/nfs4_fs.h
@@ -180,7 +180,7 @@ extern int nfs4_proc_async_renew(struct 
 extern int nfs4_proc_renew(struct nfs_client *, struct rpc_cred *);
 extern int nfs4_do_close(struct path *path, struct nfs4_state *state);
 extern struct dentry *nfs4_atomic_open(struct inode *, struct dentry *, struct nameidata *);
-extern int nfs4_open_revalidate(struct inode *, struct dentry *, int, struct nameidata *);
+extern int nfs4_open_revalidate(struct inode *, struct dentry *, int, struct vfs_lookup *);
 extern int nfs4_server_capabilities(struct nfs_server *server, struct nfs_fh *fhandle);
 extern int nfs4_proc_fs_locations(struct inode *dir, const struct qstr *name,
 		struct nfs4_fs_locations *fs_locations, struct page *page);
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1442,10 +1442,10 @@ nfs4_atomic_open(struct inode *dir, stru
 }
 
 int
-nfs4_open_revalidate(struct inode *dir, struct dentry *dentry, int openflags, struct nameidata *nd)
+nfs4_open_revalidate(struct inode *dir, struct dentry *dentry, int openflags, struct vfs_lookup *lookup)
 {
 	struct path path = {
-		.mnt = nd->lookup.path.mnt,
+		.mnt = lookup->path.mnt,
 		.dentry = dentry,
 	};
 	struct rpc_cred *cred;
@@ -1463,14 +1463,14 @@ nfs4_open_revalidate(struct inode *dir, 
 			case -EDQUOT:
 			case -ENOSPC:
 			case -EROFS:
-				lookup_instantiate_filp(&nd->lookup, (struct dentry *)state, NULL);
+				lookup_instantiate_filp(lookup, (struct dentry *)state, NULL);
 				return 1;
 			default:
 				goto out_drop;
 		}
 	}
 	if (state->inode == dentry->d_inode) {
-		nfs4_intent_set_file(&nd->lookup, &path, state);
+		nfs4_intent_set_file(lookup, &path, state);
 		return 1;
 	}
 	nfs4_close_state(&path, state, openflags);
--- a/fs/ocfs2/dcache.c
+++ b/fs/ocfs2/dcache.c
@@ -41,7 +41,7 @@
 
 
 static int ocfs2_dentry_revalidate(struct dentry *dentry,
-				   struct nameidata *nd)
+				   struct vfs_lookup *lookup)
 {
 	struct inode *inode = dentry->d_inode;
 	int ret = 0;    /* if all else fails, just return false */
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1100,7 +1100,7 @@ static int pid_getattr(struct vfsmount *
  * made this apply to all per process world readable and executable
  * directories.
  */
-static int pid_revalidate(struct dentry *dentry, struct nameidata *nd)
+static int pid_revalidate(struct dentry *dentry, struct vfs_lookup *lookup)
 {
 	struct inode *inode = dentry->d_inode;
 	struct task_struct *task = get_proc_task(inode);
@@ -1266,7 +1266,7 @@ static int proc_fd_link(struct inode *in
 	return proc_fd_info(inode, dentry, mnt, NULL);
 }
 
-static int tid_fd_revalidate(struct dentry *dentry, struct nameidata *nd)
+static int tid_fd_revalidate(struct dentry *dentry, struct vfs_lookup *lookup)
 {
 	struct inode *inode = dentry->d_inode;
 	struct task_struct *task = get_proc_task(inode);
@@ -1911,7 +1911,8 @@ static const struct pid_entry proc_base_
  * directory. In this case, however, we can do it - no aliasing problems
  * due to the way we treat inodes.
  */
-static int proc_base_revalidate(struct dentry *dentry, struct nameidata *nd)
+static int proc_base_revalidate(struct dentry *dentry,
+				struct vfs_lookup *lookup)
 {
 	struct inode *inode = dentry->d_inode;
 	struct task_struct *task = get_proc_task(inode);
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -451,7 +451,7 @@ static struct inode_operations proc_sys_
 	.setattr	= proc_sys_setattr,
 };
 
-static int proc_sys_revalidate(struct dentry *dentry, struct nameidata *nd)
+static int proc_sys_revalidate(struct dentry *dentry, struct vfs_lookup *lookup)
 {
 	struct ctl_table_header *head;
 	struct ctl_table *table;
--- a/fs/smbfs/dir.c
+++ b/fs/smbfs/dir.c
@@ -272,7 +272,7 @@ smb_dir_open(struct inode *dir, struct f
 /*
  * Dentry operations routines
  */
-static int smb_lookup_validate(struct dentry *, struct nameidata *);
+static int smb_lookup_validate(struct dentry *, struct vfs_lookup *);
 static int smb_hash_dentry(struct dentry *, struct qstr *);
 static int smb_compare_dentry(struct dentry *, struct qstr *, struct qstr *);
 static int smb_delete_dentry(struct dentry *);
@@ -296,7 +296,7 @@ static struct dentry_operations smbfs_de
  * This is the callback when the dcache has a lookup hit.
  */
 static int
-smb_lookup_validate(struct dentry * dentry, struct nameidata *nd)
+smb_lookup_validate(struct dentry * dentry, struct vfs_lookup *lookup)
 {
 	struct smb_sb_info *server = server_from_dentry(dentry);
 	struct inode * inode = dentry->d_inode;
--- a/fs/vfat/namei.c
+++ b/fs/vfat/namei.c
@@ -25,12 +25,12 @@
 #include <linux/buffer_head.h>
 #include <linux/namei.h>
 
-static int vfat_revalidate(struct dentry *dentry, struct nameidata *nd)
+static int vfat_revalidate(struct dentry *dentry, struct vfs_lookup *lookup)
 {
 	int ret = 1;
 
-	if (!dentry->d_inode &&
-	    nd && !(nd->lookup.flags & LOOKUP_CONTINUE) && (nd->lookup.flags & LOOKUP_CREATE))
+	if (!dentry->d_inode && lookup && !(lookup->flags & LOOKUP_CONTINUE) &&
+	    (lookup->flags & LOOKUP_CREATE))
 		/*
 		 * negative dentry is dropped, in order to make sure
 		 * to use the name which a user desires if this is
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -11,6 +11,7 @@
 
 struct nameidata;
 struct vfsmount;
+struct vfs_lookup;
 
 /*
  * linux/include/linux/dcache.h
@@ -127,7 +128,7 @@ enum dentry_d_lock_class
 };
 
 struct dentry_operations {
-	int (*d_revalidate)(struct dentry *, struct nameidata *);
+	int (*d_revalidate)(struct dentry *, struct vfs_lookup *);
 	int (*d_hash) (struct dentry *, struct qstr *);
 	int (*d_compare) (struct dentry *, struct qstr *, struct qstr *);
 	int (*d_delete)(struct dentry *);

