Return-Path: <linux-kernel-owner+w=401wt.eu-S1030857AbXDPQ3N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030857AbXDPQ3N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 12:29:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030860AbXDPQ3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 12:29:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39376 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030857AbXDPQ3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 12:29:11 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell
To: Christoph Hellwig <hch@infradead.org>
Subject: [nameidata 2/2] Pass no useless nameidata to the create, lookup, and permission IOPs
Date: Mon, 16 Apr 2007 18:29:20 +0200
User-Agent: KMail/1.9.5
Cc: jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chrisw@sous-sol.org, Tony Jones <tonyj@suse.de>
References: <20070412090809.917795000@suse.de> <20070412090836.207973000@suse.de> <20070412100628.GA25078@infradead.org>
In-Reply-To: <20070412100628.GA25078@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704161829.20669.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a patch with request for comment.

The create, lookup, and permission inode operations are all passed a full
nameidata.  This is unfortunate because in nfsd and the mqueue filesystem we
must instantiate a struct nameidata, but cannot provide all of the same
information of a regular lookup.  The unused fields take up space on the
stack, but more importantly, it is not obvious which fields have meaningful
values and which don't, and so things might easily break.

This patch introduces struct nameidata2 with only the fields that make sense
independent of an actual lookup, and uses that struct in those places where a
full nameidata is not needed.

The entire patch is a little big so I'm only including the key parts here. The
complete version is here:

 http://forgeftp.novell.com/apparmor/LKML_Submission-April_07/split-up-nameidata.diff

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>

--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -14,21 +14,39 @@ struct open_intent {
 
 enum { MAX_NESTED_LINKS = 8 };
 
+/**
+ * Fields shared between nameidata and nameidata2 -- nameidata2 could
+ * be embedded in nameidata, but then the vfs code would become
+ * cluttered with dereferences.
+ */
+#define __NAMEIDATA2				\
+	struct dentry	*dentry;		\
+	struct vfsmount *mnt;			\
+	unsigned int	flags;			\
+						\
+	union {					\
+		struct open_intent open;	\
+	} intent;
+
 struct nameidata {
-	struct dentry	*dentry;
-	struct vfsmount *mnt;
+	__NAMEIDATA2
 	struct qstr	last;
-	unsigned int	flags;
 	int		last_type;
 	unsigned	depth;
 	char *saved_names[MAX_NESTED_LINKS + 1];
+};
 
-	/* Intent data */
-	union {
-		struct open_intent open;
-	} intent;
+struct nameidata2 {
+	__NAMEIDATA2
 };
 
+#undef __NAMEIDATA2
+
+static inline struct nameidata2 *ND2(struct nameidata *nd)
+{
+	return container_of(&nd->dentry, struct nameidata2, dentry);
+}
+
 struct path {
 	struct vfsmount *mnt;
 	struct dentry *dentry;
@@ -76,10 +94,9 @@ extern void path_release_on_umount(struc
 
 extern int __user_path_lookup_open(const char __user *, unsigned lookup_flags, struct nameidata *nd, int open_flags);
 extern int path_lookup_open(int dfd, const char *name, unsigned lookup_flags, struct nameidata *, int open_flags);
-extern struct file *lookup_instantiate_filp(struct nameidata *nd, struct dentry *dentry,
-		int (*open)(struct inode *, struct file *));
+extern struct file *lookup_instantiate_filp(struct nameidata2 *nd, struct dentry *dentry, int (*open)(struct inode *, struct file *));
 extern struct file *nameidata_to_filp(struct nameidata *nd, int flags);
-extern void release_open_intent(struct nameidata *);
+extern void release_open_intent(struct nameidata2 *);
 
 extern struct dentry * lookup_one_len(const char *, struct dentry *, int);
 
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -225,7 +225,7 @@ int generic_permission(struct inode *ino
 	return -EACCES;
 }
 
-int permission(struct inode *inode, int mask, struct nameidata *nd)
+int permission(struct inode *inode, int mask, struct nameidata2 *nd)
 {
 	umode_t mode = inode->i_mode;
 	int retval, submask;
@@ -278,7 +278,7 @@ int permission(struct inode *inode, int 
  * for filesystem access without changing the "normal" uids which
  * are used for other things.
  */
-int vfs_permission(struct nameidata *nd, int mask)
+int vfs_permission(struct nameidata2 *nd, int mask)
 {
 	return permission(nd->dentry->d_inode, mask, nd);
 }
@@ -366,7 +366,7 @@ void path_release_on_umount(struct namei
  * release_open_intent - free up open intent resources
  * @nd: pointer to nameidata
  */
-void release_open_intent(struct nameidata *nd)
+void release_open_intent(struct nameidata2 *nd)
 {
 	if (nd->intent.open.file->f_path.dentry == NULL)
 		put_filp(nd->intent.open.file);
@@ -377,7 +377,7 @@ void release_open_intent(struct nameidat
 static inline struct dentry *
 do_revalidate(struct dentry *dentry, struct nameidata *nd)
 {
-	int status = dentry->d_op->d_revalidate(dentry, nd);
+	int status = dentry->d_op->d_revalidate(dentry, ND2(nd));
 	if (unlikely(status <= 0)) {
 		/*
 		 * The dentry failed validation.
@@ -455,7 +455,7 @@ static int exec_permission_lite(struct i
 
 	return -EACCES;
 ok:
-	return security_inode_permission(inode, MAY_EXEC, nd);
+	return security_inode_permission(inode, MAY_EXEC, ND2(nd));
 }
 
 /*
@@ -491,7 +491,7 @@ static struct dentry * real_lookup(struc
 		struct dentry * dentry = d_alloc(parent, name);
 		result = ERR_PTR(-ENOMEM);
 		if (dentry) {
-			result = dir->i_op->lookup(dir, dentry, nd);
+			result = dir->i_op->lookup(dir, dentry, ND2(nd));
 			if (result)
 				dput(dentry);
 			else
@@ -832,7 +832,7 @@ static fastcall int __link_path_walk(con
 		nd->flags |= LOOKUP_CONTINUE;
 		err = exec_permission_lite(inode, nd);
 		if (err == -EAGAIN)
-			err = vfs_permission(nd, MAY_EXEC);
+			err = vfs_permission(ND2(nd), MAY_EXEC);
  		if (err)
 			break;
 
@@ -978,7 +978,8 @@ return_reval:
 		    (nd->dentry->d_sb->s_type->fs_flags & FS_REVAL_DOT)) {
 			err = -ESTALE;
 			/* Note: we do not d_invalidate() */
-			if (!nd->dentry->d_op->d_revalidate(nd->dentry, nd))
+			if (!nd->dentry->d_op->d_revalidate(nd->dentry,
+							    ND2(nd)))
 				break;
 		}
 return_base:
@@ -1194,7 +1195,7 @@ static int __path_lookup_intent_open(int
 			path_release(nd);
 		}
 	} else if (err != 0)
-		release_open_intent(nd);
+		release_open_intent(ND2(nd));
 	return err;
 }
 
@@ -1255,7 +1256,7 @@ static struct dentry * __lookup_hash(str
 	int err;
 
 	inode = base->d_inode;
-	err = permission(inode, MAY_EXEC, nd);
+	err = permission(inode, MAY_EXEC, ND2(nd));
 	dentry = ERR_PTR(err);
 	if (err)
 		goto out;
@@ -1277,7 +1278,7 @@ static struct dentry * __lookup_hash(str
 		dentry = ERR_PTR(-ENOMEM);
 		if (!new)
 			goto out;
-		dentry = inode->i_op->lookup(inode, new, nd);
+		dentry = inode->i_op->lookup(inode, new, ND2(nd));
 		if (!dentry)
 			dentry = new;
 		else
@@ -1422,7 +1423,7 @@ static int may_delete(struct inode *dir,
  *  4. We can't do it if dir is immutable (done in permission())
  */
 static inline int may_create(struct inode *dir, struct dentry *child,
-			     struct nameidata *nd)
+			     struct nameidata2 *nd)
 {
 	if (child->d_inode)
 		return -EEXIST;
@@ -1492,7 +1493,7 @@ void unlock_rename(struct dentry *p1, st
 }
 
 int vfs_create(struct inode *dir, struct dentry *dentry, int mode,
-		struct nameidata *nd)
+		struct nameidata2 *nd)
 {
 	int error = may_create(dir, dentry, nd);
 
@@ -1528,7 +1529,7 @@ int may_open(struct nameidata *nd, int a
 	if (S_ISDIR(inode->i_mode) && (flag & FMODE_WRITE))
 		return -EISDIR;
 
-	error = vfs_permission(nd, acc_mode);
+	error = vfs_permission(ND2(nd), acc_mode);
 	if (error)
 		return error;
 
@@ -1601,7 +1602,7 @@ static int open_namei_create(struct name
 
 	if (!IS_POSIXACL(dir->d_inode))
 		mode &= ~current->fs->umask;
-	error = vfs_create(dir->d_inode, path->dentry, mode, nd);
+	error = vfs_create(dir->d_inode, path->dentry, mode, ND2(nd));
 	mutex_unlock(&dir->d_inode->i_mutex);
 	dput(nd->dentry);
 	nd->dentry = path->dentry;
@@ -1734,7 +1735,7 @@ exit_dput:
 	dput_path(&path, nd);
 exit:
 	if (!IS_ERR(nd->intent.open.file))
-		release_open_intent(nd);
+		release_open_intent(ND2(nd));
 	path_release(nd);
 	return error;
 
@@ -1762,7 +1763,7 @@ do_link:
 		 * me so stupid? Anathema to whoever designed this non-sense
 		 * with "intent.open".
 		 */
-		release_open_intent(nd);
+		release_open_intent(ND2(nd));
 		return error;
 	}
 	nd->flags &= ~LOOKUP_PARENT;
@@ -1888,7 +1889,7 @@ asmlinkage long sys_mknodat(int dfd, con
 		switch (mode & S_IFMT) {
 		case 0: case S_IFREG:
 			error = vfs_create(nd.dentry->d_inode, dentry, mode,
-					   &nd);
+					   ND2(&nd));
 			break;
 		case S_IFCHR: case S_IFBLK:
 			error = vfs_mknod(nd.dentry->d_inode, dentry, nd.mnt,
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -289,6 +289,7 @@ extern int dir_notify_enable;
 struct hd_geometry;
 struct iovec;
 struct nameidata;
+struct nameidata2;
 struct kiocb;
 struct pipe_inode_info;
 struct poll_table_struct;
@@ -981,8 +982,8 @@ extern void unlock_super(struct super_bl
 /*
  * VFS helper functions..
  */
-extern int vfs_permission(struct nameidata *, int);
-extern int vfs_create(struct inode *, struct dentry *, int, struct nameidata *);
+extern int vfs_permission(struct nameidata2 *, int);
+extern int vfs_create(struct inode *, struct dentry *, int, struct nameidata2 *);
 extern int vfs_mkdir(struct inode *, struct dentry *, struct vfsmount *, int);
 extern int vfs_mknod(struct inode *, struct dentry *, struct vfsmount *, int, dev_t);
 extern int vfs_symlink(struct inode *, struct dentry *, struct vfsmount *, const char *, int);
@@ -1106,8 +1107,8 @@ struct file_operations {
 };
 
 struct inode_operations {
-	int (*create) (struct inode *,struct dentry *,int, struct nameidata *);
-	struct dentry * (*lookup) (struct inode *,struct dentry *, struct nameidata *);
+	int (*create) (struct inode *,struct dentry *,int, struct nameidata2 *);
+	struct dentry * (*lookup) (struct inode *,struct dentry *, struct nameidata2 *);
 	int (*link) (struct dentry *,struct inode *,struct dentry *);
 	int (*unlink) (struct inode *,struct dentry *);
 	int (*symlink) (struct inode *,struct dentry *,const char *);
@@ -1120,7 +1121,7 @@ struct inode_operations {
 	void * (*follow_link) (struct dentry *, struct nameidata *);
 	void (*put_link) (struct dentry *, struct nameidata *, void *);
 	void (*truncate) (struct inode *);
-	int (*permission) (struct inode *, int, struct nameidata *);
+	int (*permission) (struct inode *, int, struct nameidata2 *);
 	int (*setattr) (struct dentry *, struct iattr *);
 	int (*getattr) (struct vfsmount *mnt, struct dentry *, struct kstat *);
 	int (*setxattr) (struct dentry *, const char *,const void *,size_t,int);
@@ -1616,7 +1617,7 @@ extern int do_remount_sb(struct super_bl
 extern sector_t bmap(struct inode *, sector_t);
 #endif
 extern int notify_change(struct dentry *, struct vfsmount *, struct iattr *);
-extern int permission(struct inode *, int, struct nameidata *);
+extern int permission(struct inode *, int, struct nameidata2 *);
 extern int generic_permission(struct inode *, int,
 		int (*check_acl)(struct inode *, int));
 
@@ -1873,7 +1874,7 @@ extern int simple_prepare_write(struct f
 extern int simple_commit_write(struct file *file, struct page *page,
 				unsigned offset, unsigned to);
 
-extern struct dentry *simple_lookup(struct inode *, struct dentry *, struct nameidata *);
+extern struct dentry *simple_lookup(struct inode *, struct dentry *, struct nameidata2 *);
 extern ssize_t generic_read_dir(struct file *, char __user *, size_t, loff_t *);
 extern const struct file_operations simple_dir_operations;
 extern const struct inode_operations simple_dir_inode_operations;
