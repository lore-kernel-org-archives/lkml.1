Return-Path: <linux-kernel-owner+w=401wt.eu-S1753159AbYI2EFB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159AbYI2EFB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 00:05:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751136AbYI2EEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 00:04:51 -0400
Received: from ms0.nttdata.co.jp ([163.135.193.231]:60001 "EHLO
	ms0.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbYI2EEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 00:04:49 -0400
Message-ID: <48E053DB.3010201@nttdata.co.jp>
Date: Mon, 29 Sep 2008 13:04:43 +0900
From: Kentaro Takeda <takedakn@nttdata.co.jp>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.8.1.17) Gecko/20080914 Thunderbird/2.0.0.17 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       haradats@nttdata.co.jp,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [TOMOYO #9 (2.6.27-rc7-mm1) 1/6] LSM adapter functions.
References: <20080924090317.359685535@nttdata.co.jp> <20080924090338.407746083@nttdata.co.jp> <20080925165954.GA25587@us.ibm.com> <48DC7553.8040708@nttdata.co.jp> <20080926130409.GA14055@us.ibm.com>
In-Reply-To: <20080926130409.GA14055@us.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Sep 2008 04:04:45.0219 (UTC) FILETIME=[81E55730:01C921E8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn wrote:
> Unfortunately I think that is a shortcoming in the security_path_*
> patchset.  Unfortunate bc that is going to be a pain to work out.
Thanks for your constructive and tough suggestion. ;-)

> So for starters,
> both vfs_mknod and vfs_create do may_create, so just pull that
> into the callers.
Do you mean that we should move DAC code to all the caller of vfs_* ? 
If we move DAC code to the caller of vfs_*(), we need not to 
introduce seucrity_path_*() because we can move security_inode_*() 
together. Furthermore, each filesystem must perform DAC by itself. It 
will mess up the filesystem code...

> But I do think it needs to be worked out in the core code, not in
> Tomoyo (and each lsm using security_path_*).  So for starters,
> both vfs_mknod and vfs_create do may_create, so just pull that
> into the callers.  Now Al or Christoph may yell NO due to the
> intended layering (which i'm not clear on), in which case the
> solution will be tougher.
There are two approaches to perform DAC before MAC using 
security_path_*(). One is cloning DAC functions in 
security/security.c . The other is modifying fs/namei.c to make DAC 
functions visible to security/security.c . Which approach is 
preferable?

The attached patch is an implementation of the former approach. If 
CONFIG_SECURITY_PATH is not defined, cloned DAC functions will not be 
compiled.

Regards,

---
Subject: vfs: introduce new LSM hooks where vfsmount is available.

----- What is this patch for? -----

There are security_inode_*() LSM hooks for attribute-based MAC, but they are not
suitable for pathname-based MAC because they don't receive "struct vfsmount"
information.

----- How this patch was developed? -----

Two pathname-based MACs, AppArmor and TOMOYO Linux, are trying to merge
upstream. But because of "struct vfsmount" problem, they have been unable to
merge upstream.

Here are the list of approaches and the reasons of denial.

(1) Not using LSM
 http://lwn.net/Articles/277833/

 This approach was rejected because security modules should use LSM because the
 whole idea behind LSM was to have a single set of hooks for all security
 modules; if every module now adds its own set of hooks, that purpose will have
 been defeated and the kernel will turn into a big mess of security hooks.

(2) Retrieving "struct vfsmount" from "struct task_struct".
 http://lkml.org/lkml/2007/11/5/388

 Since "struct task_struct" contains list of "struct vfsmount",
 "struct vfsmount" which corresponds to "struct dentry" can be retrieved from
 the list unless "mount --bind" is used.

 This approach turned out to cause a critical problem that getting namespace_sem
 lock from security_inode_*() triggers AB-BA deadlock.

(3) Adding "struct vfsmount" parameter to VFS helper functions.
 http://lkml.org/lkml/2008/5/29/207

 This approach adds "struct vfsmount" to VFS helper functions (e.g. vfs_mkdir()
 and vfs_symlink()) and LSM hooks inside VFS helper functions. This approach is
 helpful for not only AppArmor and TOMOYO Linux 2.x but also SELinux and
 auditing purpose, for this approach allows existent LSM users to use pathnames
 in their access control and audit logs.

 This approach was rejected by Al Viro, the VFS maintainer, because he thinks
 individual filesystem should remain "struct vfsmount"-unaware and VFS helper
 functions should not receive "struct vfsmount".

 Al Viro also suggested to move existing security_inode_*() to out of VFS
 helper functions so that security_inode_*() can receive "struct vfsmount"
 without modifying VFS helper functions, but this suggestion was opposed by
 Stephen Smalley because changing the order of permission checks (i.e.
 MAC checks before DAC checks) is not acceptable.

(4) Passing "struct vfsmount" via "struct task_struct".
 http://lkml.org/lkml/2007/11/16/157

 Since we didn't understand the reason why accessing "struct vfsmount" from
 LSM hooks inside VFS helper functions is not acceptable, we thought the reason
 why VFS helper functions don't receive "struct vfsmount" is the amount of
 modifications needed to do so. Thus, we proposed to pass "struct vfsmount" via
 "struct task_struct" so that modifications remain minimal.

 This approach was rejected because this is an abuse of "struct task_struct".

(5) Remembering pathname of "struct vfsmount" via "struct task_struct".
 http://lkml.org/lkml/2008/8/19/16

 Since pathname of a "struct dentry" up to the mount point can be calculated
 without "struct vfsmount", absolute pathname of a "struct dentry" can be
 calculated if "struct task_struct" can remember absolute pathname of a
 "struct vfsmount" which corresponds to "struct dentry".
 As we now understand that Al Viro is opposing to access "struct vfsmount" from
 LSM hooks inside VFS helper functions, we gave up delivering "struct vfsmount"
 to LSM hooks inside VFS helper functions.
 Kernel 2.6.26 introduced read-only bind mount feature, and hooks for that
 feature (i.e. mnt_want_write() and mnt_drop_write()) were inserted around
 VFS helper functions call. Since mnt_want_write() receives "struct vfsmount"
 which corresponds to "struct dentry" that will be passed to subsequent VFS
 helper functions call, we associated pathname of "struct vfsmount" with
 "struct task_struct" instead of associating "struct vfsmount" itself.

 This approach was not explicitly rejected, but there seems to be performance
 problem.

(6) Introducing new LSM hooks.
 (this patch)

 We understand that adding new LSM hooks which receive "struct vfsmount" outside
 VFS helper functions is the most straightforward approach. This approach has
 less impact to existing LSM module and no impact to VFS helper functions.


Signed-off-by: Kentaro Takeda <takedakn@nttdata.co.jp>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Toshiharu Harada <haradats@nttdata.co.jp>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Crispin Cowan <crispin@crispincowan.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
-----

 fs/namei.c               |   37 +++++++
 fs/open.c                |    5 +
 include/linux/security.h |  139 ++++++++++++++++++++++++++++
 net/unix/af_unix.c       |    4 
 security/Kconfig         |    9 +
 security/capability.c    |   57 +++++++++++
 security/security.c      |  230 +++++++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 481 insertions(+)

--- linux-2.6.27-rc7-mm1.orig/fs/namei.c
+++ linux-2.6.27-rc7-mm1/fs/namei.c
@@ -1571,6 +1571,10 @@ int may_open(struct nameidata *nd, int a
 		 * Refuse to truncate files with mandatory locks held on them.
 		 */
 		error = locks_verify_locked(inode);
+		if (!error)
+			error = security_path_truncate(&nd->path, 0,
+					       ATTR_MTIME|ATTR_CTIME|ATTR_OPEN,
+						       NULL);
 		if (!error) {
 			DQUOT_INIT(inode);
 
@@ -1601,7 +1605,11 @@ static int __open_namei_create(struct na
 
 	if (!IS_POSIXACL(dir->d_inode))
 		mode &= ~current->fs->umask;
+	error = security_path_mknod(&nd->path, path->dentry, mode, 0);
+	if (error)
+		goto out_unlock;
 	error = vfs_create(dir->d_inode, path->dentry, mode, nd);
+out_unlock:
 	mutex_unlock(&dir->d_inode->i_mutex);
 	dput(nd->path.dentry);
 	nd->path.dentry = path->dentry;
@@ -2014,6 +2022,9 @@ asmlinkage long sys_mknodat(int dfd, con
 	error = mnt_want_write(nd.path.mnt);
 	if (error)
 		goto out_dput;
+	error = security_path_mknod(&nd.path, dentry, mode, dev);
+	if (error)
+		goto out_drop_write;
 	switch (mode & S_IFMT) {
 		case 0: case S_IFREG:
 			error = vfs_create(nd.path.dentry->d_inode,dentry,mode,&nd);
@@ -2026,6 +2037,7 @@ asmlinkage long sys_mknodat(int dfd, con
 			error = vfs_mknod(nd.path.dentry->d_inode,dentry,mode,0);
 			break;
 	}
+out_drop_write:
 	mnt_drop_write(nd.path.mnt);
 out_dput:
 	dput(dentry);
@@ -2085,7 +2097,11 @@ asmlinkage long sys_mkdirat(int dfd, con
 	error = mnt_want_write(nd.path.mnt);
 	if (error)
 		goto out_dput;
+	error = security_path_mkdir(&nd.path, dentry, mode);
+	if (error)
+		goto out_drop_write;
 	error = vfs_mkdir(nd.path.dentry->d_inode, dentry, mode);
+out_drop_write:
 	mnt_drop_write(nd.path.mnt);
 out_dput:
 	dput(dentry);
@@ -2192,7 +2208,11 @@ static long do_rmdir(int dfd, const char
 	error = mnt_want_write(nd.path.mnt);
 	if (error)
 		goto exit3;
+	error = security_path_rmdir(&nd.path, dentry);
+	if (error)
+		goto exit4;
 	error = vfs_rmdir(nd.path.dentry->d_inode, dentry);
+exit4:
 	mnt_drop_write(nd.path.mnt);
 exit3:
 	dput(dentry);
@@ -2274,7 +2294,11 @@ static long do_unlinkat(int dfd, const c
 		error = mnt_want_write(nd.path.mnt);
 		if (error)
 			goto exit2;
+		error = security_path_unlink(&nd.path, dentry);
+		if (error)
+			goto exit3;
 		error = vfs_unlink(nd.path.dentry->d_inode, dentry);
+exit3:
 		mnt_drop_write(nd.path.mnt);
 	exit2:
 		dput(dentry);
@@ -2355,7 +2379,11 @@ asmlinkage long sys_symlinkat(const char
 	error = mnt_want_write(nd.path.mnt);
 	if (error)
 		goto out_dput;
+	error = security_path_symlink(&nd.path, dentry, from);
+	if (error)
+		goto out_drop_write;
 	error = vfs_symlink(nd.path.dentry->d_inode, dentry, from);
+out_drop_write:
 	mnt_drop_write(nd.path.mnt);
 out_dput:
 	dput(dentry);
@@ -2452,7 +2480,11 @@ asmlinkage long sys_linkat(int olddfd, c
 	error = mnt_want_write(nd.path.mnt);
 	if (error)
 		goto out_dput;
+	error = security_path_link(old_path.dentry, &nd.path, new_dentry);
+	if (error)
+		goto out_drop_write;
 	error = vfs_link(old_path.dentry, nd.path.dentry->d_inode, new_dentry);
+out_drop_write:
 	mnt_drop_write(nd.path.mnt);
 out_dput:
 	dput(new_dentry);
@@ -2682,8 +2714,13 @@ asmlinkage long sys_renameat(int olddfd,
 	error = mnt_want_write(oldnd.path.mnt);
 	if (error)
 		goto exit5;
+	error = security_path_rename(&oldnd.path, old_dentry,
+				     &newnd.path, new_dentry);
+	if (error)
+		goto exit6;
 	error = vfs_rename(old_dir->d_inode, old_dentry,
 				   new_dir->d_inode, new_dentry);
+exit6:
 	mnt_drop_write(oldnd.path.mnt);
 exit5:
 	dput(new_dentry);
--- linux-2.6.27-rc7-mm1.orig/fs/open.c
+++ linux-2.6.27-rc7-mm1/fs/open.c
@@ -272,6 +272,8 @@ static long do_sys_truncate(const char _
 		goto put_write_and_out;
 
 	error = locks_verify_truncate(inode, NULL, length);
+	if (!error)
+		error = security_path_truncate(&path, length, 0, NULL);
 	if (!error) {
 		DQUOT_INIT(inode);
 		error = do_truncate(path.dentry, length, 0, NULL);
@@ -329,6 +331,9 @@ static long do_sys_ftruncate(unsigned in
 
 	error = locks_verify_truncate(inode, file, length);
 	if (!error)
+		error = security_path_truncate(&file->f_path, length,
+					       ATTR_MTIME|ATTR_CTIME, file);
+	if (!error)
 		error = do_truncate(dentry, length, ATTR_MTIME|ATTR_CTIME, file);
 out_putf:
 	fput(file);
--- linux-2.6.27-rc7-mm1.orig/include/linux/security.h
+++ linux-2.6.27-rc7-mm1/include/linux/security.h
@@ -331,17 +331,37 @@ static inline void security_free_mnt_opt
  *	@dir contains the inode structure of the parent directory of the new link.
  *	@new_dentry contains the dentry structure for the new link.
  *	Return 0 if permission is granted.
+ * @path_link:
+ *	Check permission before creating a new hard link to a file.
+ *	@old_dentry contains the dentry structure for an existing link
+ *	to the file.
+ *	@new_dir contains the path structure of the parent directory of
+ *	the new link.
+ *	@new_dentry contains the dentry structure for the new link.
+ *	Return 0 if permission is granted.
  * @inode_unlink:
  *	Check the permission to remove a hard link to a file.
  *	@dir contains the inode structure of parent directory of the file.
  *	@dentry contains the dentry structure for file to be unlinked.
  *	Return 0 if permission is granted.
+ * @path_unlink:
+ *	Check the permission to remove a hard link to a file.
+ *	@dir contains the path structure of parent directory of the file.
+ *	@dentry contains the dentry structure for file to be unlinked.
+ *	Return 0 if permission is granted.
  * @inode_symlink:
  *	Check the permission to create a symbolic link to a file.
  *	@dir contains the inode structure of parent directory of the symbolic link.
  *	@dentry contains the dentry structure of the symbolic link.
  *	@old_name contains the pathname of file.
  *	Return 0 if permission is granted.
+ * @path_symlink:
+ *	Check the permission to create a symbolic link to a file.
+ *	@dir contains the path structure of parent directory of
+ *	the symbolic link.
+ *	@dentry contains the dentry structure of the symbolic link.
+ *	@old_name contains the pathname of file.
+ *	Return 0 if permission is granted.
  * @inode_mkdir:
  *	Check permissions to create a new directory in the existing directory
  *	associated with inode strcture @dir.
@@ -349,11 +369,25 @@ static inline void security_free_mnt_opt
  *	@dentry contains the dentry structure of new directory.
  *	@mode contains the mode of new directory.
  *	Return 0 if permission is granted.
+ * @path_mkdir:
+ *	Check permissions to create a new directory in the existing directory
+ *	associated with path strcture @path.
+ *	@dir containst the path structure of parent of the directory
+ *	to be created.
+ *	@dentry contains the dentry structure of new directory.
+ *	@mode contains the mode of new directory.
+ *	Return 0 if permission is granted.
  * @inode_rmdir:
  *	Check the permission to remove a directory.
  *	@dir contains the inode structure of parent of the directory to be removed.
  *	@dentry contains the dentry structure of directory to be removed.
  *	Return 0 if permission is granted.
+ * @path_rmdir:
+ *	Check the permission to remove a directory.
+ *	@dir contains the path structure of parent of the directory to be
+ *	removed.
+ *	@dentry contains the dentry structure of directory to be removed.
+ *	Return 0 if permission is granted.
  * @inode_mknod:
  *	Check permissions when creating a special file (or a socket or a fifo
  *	file created via the mknod system call).  Note that if mknod operation
@@ -364,6 +398,15 @@ static inline void security_free_mnt_opt
  *	@mode contains the mode of the new file.
  *	@dev contains the device number.
  *	Return 0 if permission is granted.
+ * @path_mknod:
+ *	Check permissions when creating a file. Note that this hook is called
+ *	even if mknod operation is being done for a regular file.
+ *	@dir contains the path structure of parent of the new file.
+ *	@dentry contains the dentry structure of the new file.
+ *	@mode contains the mode of the new file.
+ *	@dev contains the undecoded device number. Use new_decode_dev() to get
+ *	the decoded device number.
+ *	Return 0 if permission is granted.
  * @inode_rename:
  *	Check for permission to rename a file or directory.
  *	@old_dir contains the inode structure for parent of the old link.
@@ -371,6 +414,13 @@ static inline void security_free_mnt_opt
  *	@new_dir contains the inode structure for parent of the new link.
  *	@new_dentry contains the dentry structure of the new link.
  *	Return 0 if permission is granted.
+ * @path_rename:
+ *	Check for permission to rename a file or directory.
+ *	@old_dir contains the path structure for parent of the old link.
+ *	@old_dentry contains the dentry structure of the old link.
+ *	@new_dir contains the path structure for parent of the new link.
+ *	@new_dentry contains the dentry structure of the new link.
+ *	Return 0 if permission is granted.
  * @inode_readlink:
  *	Check the permission to read the symbolic link.
  *	@dentry contains the dentry structure for the file link.
@@ -399,6 +449,13 @@ static inline void security_free_mnt_opt
  *	@dentry contains the dentry structure for the file.
  *	@attr is the iattr structure containing the new file attributes.
  *	Return 0 if permission is granted.
+ * @path_truncate:
+ *	Check permission before truncating a file.
+ *	@path contains the path structure for the file.
+ *	@length is the new length of the file.
+ *	@time_attrs is the flags passed to do_truncate().
+ *	@filp is the file structure (may be NULL).
+ *	Return 0 if permission is granted.
  * @inode_getattr:
  *	Check permission before obtaining file attributes.
  *	@mnt is the vfsmount where the dentry was looked up
@@ -1327,6 +1384,22 @@ struct security_operations {
 				   struct super_block *newsb);
 	int (*sb_parse_opts_str) (char *options, struct security_mnt_opts *opts);
 
+#ifdef CONFIG_SECURITY_PATH
+	int (*path_unlink) (struct path *dir, struct dentry *dentry);
+	int (*path_mkdir) (struct path *dir, struct dentry *dentry, int mode);
+	int (*path_rmdir) (struct path *dir, struct dentry *dentry);
+	int (*path_mknod) (struct path *dir, struct dentry *dentry, int mode,
+			   unsigned int dev);
+	int (*path_truncate) (struct path *path, loff_t length,
+			      unsigned int time_attrs, struct file *filp);
+	int (*path_symlink) (struct path *dir, struct dentry *dentry,
+			     const char *old_name);
+	int (*path_link) (struct dentry *old_dentry, struct path *new_dir,
+			  struct dentry *new_dentry);
+	int (*path_rename) (struct path *old_dir, struct dentry *old_dentry,
+			    struct path *new_dir, struct dentry *new_dentry);
+#endif
+
 	int (*inode_alloc_security) (struct inode *inode);
 	void (*inode_free_security) (struct inode *inode);
 	int (*inode_init_security) (struct inode *inode, struct inode *dir,
@@ -2685,6 +2758,72 @@ static inline void security_skb_classify
 
 #endif	/* CONFIG_SECURITY_NETWORK_XFRM */
 
+#ifdef CONFIG_SECURITY_PATH
+int security_path_unlink(struct path *dir, struct dentry *dentry);
+int security_path_mkdir(struct path *dir, struct dentry *dentry, int mode);
+int security_path_rmdir(struct path *dir, struct dentry *dentry);
+int security_path_mknod(struct path *dir, struct dentry *dentry, int mode,
+			unsigned int dev);
+int security_path_truncate(struct path *path, loff_t length,
+			   unsigned int time_attrs, struct file *filp);
+int security_path_symlink(struct path *dir, struct dentry *dentry,
+			  const char *old_name);
+int security_path_link(struct dentry *old_dentry, struct path *new_dir,
+		       struct dentry *new_dentry);
+int security_path_rename(struct path *old_dir, struct dentry *old_dentry,
+			 struct path *new_dir, struct dentry *new_dentry);
+#else	/* CONFIG_SECURITY_PATH */
+static inline int security_path_unlink(struct path *dir, struct dentry *dentry)
+{
+	return 0;
+}
+
+static inline int security_path_mkdir(struct path *dir, struct dentry *dentry,
+				      int mode)
+{
+	return 0;
+}
+
+static inline int security_path_rmdir(struct path *dir, struct dentry *dentry)
+{
+	return 0;
+}
+
+static inline int security_path_mknod(struct path *dir, struct dentry *dentry,
+				      int mode, unsigned int dev)
+{
+	return 0;
+}
+
+static inline int security_path_truncate(struct path *path, loff_t length,
+					 unsigned int time_attrs,
+					 struct file *filp)
+{
+	return 0;
+}
+
+static inline int security_path_symlink(struct path *dir, struct dentry *dentry,
+					const char *old_name)
+{
+	return 0;
+}
+
+static inline int security_path_link(struct dentry *old_dentry,
+				     struct path *new_dir,
+				     struct dentry *new_dentry)
+{
+	return 0;
+}
+
+static inline int security_path_rename(struct path *old_dir,
+				       struct dentry *old_dentry,
+				       struct path *new_dir,
+				       struct dentry *new_dentry)
+{
+	return 0;
+}
+#endif	/* CONFIG_SECURITY_PATH */
+
 #ifdef CONFIG_KEYS
 #ifdef CONFIG_SECURITY
 
--- linux-2.6.27-rc7-mm1.orig/net/unix/af_unix.c
+++ linux-2.6.27-rc7-mm1/net/unix/af_unix.c
@@ -828,7 +828,11 @@ static int unix_bind(struct socket *sock
 		err = mnt_want_write(nd.path.mnt);
 		if (err)
 			goto out_mknod_dput;
+		err = security_path_mknod(&nd.path, dentry, mode, 0);
+		if (err)
+			goto out_mknod_drop_write;
 		err = vfs_mknod(nd.path.dentry->d_inode, dentry, mode, 0);
+out_mknod_drop_write:
 		mnt_drop_write(nd.path.mnt);
 		if (err)
 			goto out_mknod_dput;
--- linux-2.6.27-rc7-mm1.orig/security/capability.c
+++ linux-2.6.27-rc7-mm1/security/capability.c
@@ -263,6 +263,53 @@ static void cap_inode_getsecid(const str
 	*secid = 0;
 }
 
+#ifdef CONFIG_SECURITY_PATH
+static int cap_path_mknod(struct path *dir, struct dentry *dentry, int mode,
+			  unsigned int dev)
+{
+	return 0;
+}
+
+static int cap_path_mkdir(struct path *dir, struct dentry *dentry, int mode)
+{
+	return 0;
+}
+
+static int cap_path_rmdir(struct path *dir, struct dentry *dentry)
+{
+	return 0;
+}
+
+static int cap_path_unlink(struct path *dir, struct dentry *dentry)
+{
+	return 0;
+}
+
+static int cap_path_symlink(struct path *dir, struct dentry *dentry,
+			    const char *old_name)
+{
+	return 0;
+}
+
+static int cap_path_link(struct dentry *old_dentry, struct path *new_dir,
+			 struct dentry *new_dentry)
+{
+	return 0;
+}
+
+static int cap_path_rename(struct path *old_path, struct dentry *old_dentry,
+			   struct path *new_path, struct dentry *new_dentry)
+{
+	return 0;
+}
+
+static int cap_path_truncate(struct path *path, loff_t length,
+			     unsigned int time_attrs, struct file *filp)
+{
+	return 0;
+}
+#endif
+
 static int cap_file_permission(struct file *file, int mask)
 {
 	return 0;
@@ -883,6 +930,16 @@ void security_fixup_ops(struct security_
 	set_to_cap_if_null(ops, inode_setsecurity);
 	set_to_cap_if_null(ops, inode_listsecurity);
 	set_to_cap_if_null(ops, inode_getsecid);
+#ifdef CONFIG_SECURITY_PATH
+	set_to_cap_if_null(ops, path_mknod);
+	set_to_cap_if_null(ops, path_mkdir);
+	set_to_cap_if_null(ops, path_rmdir);
+	set_to_cap_if_null(ops, path_unlink);
+	set_to_cap_if_null(ops, path_symlink);
+	set_to_cap_if_null(ops, path_link);
+	set_to_cap_if_null(ops, path_rename);
+	set_to_cap_if_null(ops, path_truncate);
+#endif
 	set_to_cap_if_null(ops, file_permission);
 	set_to_cap_if_null(ops, file_alloc_security);
 	set_to_cap_if_null(ops, file_free_security);
--- linux-2.6.27-rc7-mm1.orig/security/security.c
+++ linux-2.6.27-rc7-mm1/security/security.c
@@ -16,6 +16,8 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/security.h>
+#include <linux/audit.h>
+#include <linux/device_cgroup.h>
 
 /* Boot-time LSM user choice */
 static __initdata char chosen_lsm[SECURITY_NAME_MAX + 1];
@@ -341,6 +343,234 @@ int security_inode_init_security(struct 
 }
 EXPORT_SYMBOL(security_inode_init_security);
 
+#ifdef CONFIG_SECURITY_PATH
+
+/* Copied from fs/namei.c */
+static inline int may_create(struct inode *dir, struct dentry *child)
+{
+	if (child->d_inode)
+		return -EEXIST;
+	if (IS_DEADDIR(dir))
+		return -ENOENT;
+	return inode_permission(dir, MAY_WRITE | MAY_EXEC);
+}
+
+/* Copied from fs/namei.c */
+static inline int check_sticky(struct inode *dir, struct inode *inode)
+{
+	uid_t fsuid = current_fsuid();
+
+	if (!(dir->i_mode & S_ISVTX))
+		return 0;
+	if (inode->i_uid == fsuid)
+		return 0;
+	if (dir->i_uid == fsuid)
+		return 0;
+	return !capable(CAP_FOWNER);
+}
+
+/* Copied from fs/namei.c */
+static int may_delete(struct inode *dir, struct dentry *victim, int isdir)
+{
+	int error;
+
+	if (!victim->d_inode)
+		return -ENOENT;
+
+	BUG_ON(victim->d_parent->d_inode != dir);
+	audit_inode_child(victim->d_name.name, victim, dir);
+
+	error = inode_permission(dir, MAY_WRITE | MAY_EXEC);
+	if (error)
+		return error;
+	if (IS_APPEND(dir))
+		return -EPERM;
+	if (check_sticky(dir, victim->d_inode) || IS_APPEND(victim->d_inode) ||
+	    IS_IMMUTABLE(victim->d_inode))
+		return -EPERM;
+	if (isdir) {
+		if (!S_ISDIR(victim->d_inode->i_mode))
+			return -ENOTDIR;
+		if (IS_ROOT(victim))
+			return -EBUSY;
+	} else if (S_ISDIR(victim->d_inode->i_mode))
+		return -EISDIR;
+	if (IS_DEADDIR(dir))
+		return -ENOENT;
+	if (victim->d_flags & DCACHE_NFSFS_RENAMED)
+		return -EBUSY;
+	return 0;
+}
+
+int security_path_mknod(struct path *path, struct dentry *dentry, int mode,
+			unsigned int dev)
+{
+	/* may_mknod() checked mode is valid. */
+	struct inode *dir = path->dentry->d_inode;
+	int error = may_create(dir, dentry);
+	if (error)
+		return error;
+	switch (mode & S_IFMT) {
+	case S_IFREG:
+	case 0:
+		if (!dir->i_op || !dir->i_op->create)
+			return -EACCES; /* shouldn't it be ENOSYS? */
+		mode &= S_IALLUGO;
+		mode |= S_IFREG;
+		break;
+	case S_IFCHR:
+	case S_IFBLK:
+	case S_IFIFO:
+	case S_IFSOCK:
+		if ((S_ISCHR(mode) || S_ISBLK(mode)) && !capable(CAP_MKNOD))
+			return -EPERM;
+		if (!dir->i_op || !dir->i_op->mknod)
+			return -EPERM;
+		error = devcgroup_inode_mknod(mode, dev);
+		if (error)
+			return error;
+		break;
+	}
+	if (unlikely(IS_PRIVATE(dir)))
+		return 0;
+	return security_ops->path_mknod(path, dentry, mode, dev);
+}
+EXPORT_SYMBOL(security_path_mknod);
+
+int security_path_mkdir(struct path *path, struct dentry *dentry, int mode)
+{
+	struct inode *dir = path->dentry->d_inode;
+	int error = may_create(dir, dentry);
+	if (error)
+		return error;
+	if (!dir->i_op || !dir->i_op->mkdir)
+		return -EPERM;
+	if (unlikely(IS_PRIVATE(dir)))
+		return 0;
+	mode &= (S_IRWXUGO | S_ISVTX);
+	return security_ops->path_mkdir(path, dentry, mode);
+}
+
+int security_path_rmdir(struct path *path, struct dentry *dentry)
+{
+	struct inode *dir = path->dentry->d_inode;
+	int error = may_delete(dir, dentry, 1);
+	if (error)
+		return error;
+	if (!dir->i_op || !dir->i_op->rmdir)
+		return -EPERM;
+	mutex_lock(&dentry->d_inode->i_mutex);
+	/* I don't call dentry_unhash() here. */
+	if (likely(!IS_PRIVATE(dir)))
+		error = security_ops->path_rmdir(path, dentry);
+	mutex_unlock(&dentry->d_inode->i_mutex);
+	return error;
+}
+
+int security_path_unlink(struct path *path, struct dentry *dentry)
+{
+	struct inode *dir = path->dentry->d_inode;
+	int error = may_delete(dir, dentry, 0);
+	if (error)
+		return error;
+	if (!dir->i_op || !dir->i_op->unlink)
+		return -EPERM;
+	mutex_lock(&dentry->d_inode->i_mutex);
+	if (likely(!IS_PRIVATE(dir)))
+		error = security_ops->path_unlink(path, dentry);
+	mutex_unlock(&dentry->d_inode->i_mutex);
+	return error;
+}
+
+int security_path_symlink(struct path *path, struct dentry *dentry,
+			  const char *old_name)
+{
+	struct inode *dir = path->dentry->d_inode;
+	int error = may_create(dir, dentry);
+	if (error)
+		return error;
+	if (!dir->i_op || !dir->i_op->symlink)
+		return -EPERM;
+	if (unlikely(IS_PRIVATE(dir)))
+		return 0;
+	return security_ops->path_symlink(path, dentry, old_name);
+}
+
+int security_path_link(struct dentry *old_dentry, struct path *new_dir,
+		       struct dentry *new_dentry)
+{
+	struct inode *dir = new_dir->dentry->d_inode;
+	struct inode *inode = old_dentry->d_inode;
+	int error;
+	if (!inode)
+		return -ENOENT;
+	error = may_create(dir, new_dentry);
+	if (error)
+		return error;
+	if (dir->i_sb != inode->i_sb)
+		return -EXDEV;
+	if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
+		return -EPERM;
+	if (!dir->i_op || !dir->i_op->link)
+		return -EPERM;
+	if (S_ISDIR(inode->i_mode))
+		return -EPERM;
+	if (unlikely(IS_PRIVATE(inode)))
+		return 0;
+	return security_ops->path_link(old_dentry, new_dir, new_dentry);
+}
+
+int security_path_rename(struct path *old_path, struct dentry *old_dentry,
+			 struct path *new_path, struct dentry *new_dentry)
+{
+	struct inode *old_dir = old_path->dentry->d_inode;
+	struct inode *new_dir = new_path->dentry->d_inode;
+
+	int error;
+	int is_dir = S_ISDIR(old_dentry->d_inode->i_mode);
+	if (old_dentry->d_inode == new_dentry->d_inode)
+		return 0;
+	error = may_delete(old_dir, old_dentry, is_dir);
+	if (error)
+		return error;
+	if (!new_dentry->d_inode)
+		error = may_create(new_dir, new_dentry);
+	else
+		error = may_delete(new_dir, new_dentry, is_dir);
+	if (error)
+		return error;
+	if (!old_dir->i_op || !old_dir->i_op->rename)
+		return -EPERM;
+
+	/* I don't call fsnotify_oldname_init() here. */
+
+	if (is_dir && new_dir != old_dir) {
+		error = inode_permission(old_dentry->d_inode, MAY_WRITE);
+		if (error)
+			return error;
+	}
+	if (unlikely(IS_PRIVATE(old_dentry->d_inode) ||
+		     (new_dentry->d_inode && IS_PRIVATE(new_dentry->d_inode))))
+		return 0;
+	return security_ops->path_rename(old_path, old_dentry, new_path,
+					 new_dentry);
+}
+
+int security_path_truncate(struct path *path, loff_t length,
+			   unsigned int time_attrs, struct file *filp)
+{
+	struct dentry *dentry = path->dentry;
+	int error = 0;
+	mutex_lock(&dentry->d_inode->i_mutex);
+	if (likely(!IS_PRIVATE(dentry->d_inode)))
+		error = security_ops->path_truncate(path, length, time_attrs,
+						    filp);
+	mutex_unlock(&dentry->d_inode->i_mutex);
+	return error;
+}
+
+#endif
+
 int security_inode_create(struct inode *dir, struct dentry *dentry, int mode)
 {
 	if (unlikely(IS_PRIVATE(dir)))
--- linux-2.6.27-rc7-mm1.orig/security/Kconfig
+++ linux-2.6.27-rc7-mm1/security/Kconfig
@@ -81,6 +81,15 @@ config SECURITY_NETWORK_XFRM
 	  IPSec.
 	  If you are unsure how to answer this question, answer N.
 
+config SECURITY_PATH
+	bool "Security hooks for pathname based access control"
+	depends on SECURITY
+	help
+	  This enables the security hooks for pathname based access control.
+	  If enabled, a security module can use these hooks to
+	  implement pathname based access controls.
+	  If you are unsure how to answer this question, answer N.
+
 config SECURITY_FILE_CAPABILITIES
 	bool "File POSIX Capabilities"
 	default n


