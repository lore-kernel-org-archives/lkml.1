Return-Path: <linux-kernel-owner+w=401wt.eu-S1754861AbXJVG7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861AbXJVG7W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 02:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751666AbXJVG7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 02:59:12 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:33378 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205AbXJVG7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 02:59:09 -0400
Date: Mon, 22 Oct 2007 12:29:04 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Blunck <jblunck@suse.de>, Andreas Gruenbacher <agruen@suse.de>,
       Christoph Hellwig <hch@lst.de>, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: [PATCH 06/13] Introduce path_put()
Message-ID: <20071022065904.GG6489@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20071022065352.GA6489@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071022065352.GA6489@in.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Blunck <jblunck@suse.de>

* Add path_put() functions for releasing a reference to the dentry and
  vfsmount of a struct path in the right order

* Switch from path_release(nd) to path_put(&nd->path)

* Rename dput_path() to path_put_conditional()

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
---
 arch/alpha/kernel/osf_sys.c                  |    2 
 arch/mips/kernel/sysirix.c                   |    6 +-
 arch/parisc/hpux/sys_hpux.c                  |    2 
 arch/powerpc/platforms/cell/spufs/syscalls.c |    2 
 arch/sparc64/solaris/fs.c                    |    4 -
 drivers/md/dm-table.c                        |    2 
 drivers/mtd/mtdsuper.c                       |    4 -
 fs/afs/mntpt.c                               |    2 
 fs/autofs4/root.c                            |    2 
 fs/block_dev.c                               |    2 
 fs/coda/pioctl.c                             |    4 -
 fs/compat.c                                  |    4 -
 fs/configfs/symlink.c                        |    4 -
 fs/dquot.c                                   |    2 
 fs/ecryptfs/main.c                           |    2 
 fs/exec.c                                    |    4 -
 fs/ext3/super.c                              |    4 -
 fs/ext4/super.c                              |    4 -
 fs/gfs2/ops_fstype.c                         |    2 
 fs/inotify_user.c                            |    4 -
 fs/namei.c                                   |   56 ++++++++++++++-------------
 fs/namespace.c                               |   20 ++++-----
 fs/nfs/namespace.c                           |    2 
 fs/nfsctl.c                                  |    2 
 fs/nfsd/export.c                             |   10 ++--
 fs/nfsd/nfs4recover.c                        |    2 
 fs/nfsd/nfs4state.c                          |    2 
 fs/open.c                                    |   22 +++++-----
 fs/proc/base.c                               |    2 
 fs/reiserfs/super.c                          |    8 +--
 fs/revoke.c                                  |    2 
 fs/stat.c                                    |    6 +-
 fs/unionfs/main.c                            |    2 
 fs/unionfs/super.c                           |   12 ++---
 fs/utimes.c                                  |    2 
 fs/xattr.c                                   |   16 +++----
 fs/xfs/linux-2.6/xfs_ioctl.c                 |    2 
 include/linux/namei.h                        |    7 ---
 include/linux/path.h                         |    2 
 kernel/audit_tree.c                          |   16 +++----
 kernel/auditfilter.c                         |    4 -
 net/sunrpc/rpc_pipe.c                        |    2 
 net/unix/af_unix.c                           |    6 +-
 43 files changed, 134 insertions(+), 133 deletions(-)

--- a/arch/alpha/kernel/osf_sys.c
+++ b/arch/alpha/kernel/osf_sys.c
@@ -261,7 +261,7 @@ osf_statfs(char __user *path, struct osf
 	retval = user_path_walk(path, &nd);
 	if (!retval) {
 		retval = do_osf_statfs(nd.path.dentry, buffer, bufsiz);
-		path_release(&nd);
+		path_put(&nd.path);
 	}
 	return retval;
 }
--- a/arch/mips/kernel/sysirix.c
+++ b/arch/mips/kernel/sysirix.c
@@ -711,7 +711,7 @@ asmlinkage int irix_statfs(const char __
 	}
 
 dput_and_out:
-	path_release(&nd);
+	path_put(&nd.path);
 out:
 	return error;
 }
@@ -1385,7 +1385,7 @@ asmlinkage int irix_statvfs(char __user 
 		error |= __put_user(0, &buf->f_fstr[i]);
 
 dput_and_out:
-	path_release(&nd);
+	path_put(&nd.path);
 out:
 	return error;
 }
@@ -1636,7 +1636,7 @@ asmlinkage int irix_statvfs64(char __use
 		error |= __put_user(0, &buf->f_fstr[i]);
 
 dput_and_out:
-	path_release(&nd);
+	path_put(&nd.path);
 out:
 	return error;
 }
--- a/arch/parisc/hpux/sys_hpux.c
+++ b/arch/parisc/hpux/sys_hpux.c
@@ -222,7 +222,7 @@ asmlinkage long hpux_statfs(const char _
 		error = vfs_statfs_hpux(nd.path.dentry, &tmp);
 		if (!error && copy_to_user(buf, &tmp, sizeof(tmp)))
 			error = -EFAULT;
-		path_release(&nd);
+		path_put(&nd.path);
 	}
 	return error;
 }
--- a/arch/powerpc/platforms/cell/spufs/syscalls.c
+++ b/arch/powerpc/platforms/cell/spufs/syscalls.c
@@ -73,7 +73,7 @@ static long do_spu_create(const char __u
 				LOOKUP_OPEN|LOOKUP_CREATE, &nd);
 		if (!ret) {
 			ret = spufs_create(&nd, flags, mode, neighbor);
-			path_release(&nd);
+			path_put(&nd.path);
 		}
 		putname(tmp);
 	}
--- a/arch/sparc64/solaris/fs.c
+++ b/arch/sparc64/solaris/fs.c
@@ -436,7 +436,7 @@ asmlinkage int solaris_statvfs(u32 path,
 	if (!error) {
 		struct inode *inode = nd.path.dentry->d_inode;
 		error = report_statvfs(nd.path.mnt, inode, buf);
-		path_release(&nd);
+		path_put(&nd.path);
 	}
 	return error;
 }
@@ -466,7 +466,7 @@ asmlinkage int solaris_statvfs64(u32 pat
 	if (!error) {
 		struct inode *inode = nd.path.dentry->d_inode;
 		error = report_statvfs64(nd.path.mnt, inode, buf);
-		path_release(&nd);
+		path_put(&nd.path);
 	}
 	unlock_kernel();
 	return error;
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -369,7 +369,7 @@ static int lookup_device(const char *pat
 	*dev = inode->i_rdev;
 
  out:
-	path_release(&nd);
+	path_put(&nd.path);
 	return r;
 }
 
--- a/drivers/mtd/mtdsuper.c
+++ b/drivers/mtd/mtdsuper.c
@@ -203,7 +203,7 @@ int get_sb_mtd(struct file_system_type *
 		goto not_an_MTD_device;
 
 	mtdnr = iminor(nd.path.dentry->d_inode);
-	path_release(&nd);
+	path_put(&nd.path);
 
 	return get_sb_mtd_nr(fs_type, flags, dev_name, data, mtdnr, fill_super,
 			     mnt);
@@ -214,7 +214,7 @@ not_an_MTD_device:
 		       "MTD: Attempt to mount non-MTD device \"%s\"\n",
 		       dev_name);
 out:
-	path_release(&nd);
+	path_put(&nd.path);
 	return ret;
 
 }
--- a/fs/afs/mntpt.c
+++ b/fs/afs/mntpt.c
@@ -227,7 +227,7 @@ static void *afs_mntpt_follow_link(struc
 
 	newmnt = afs_mntpt_do_automount(nd->path.dentry);
 	if (IS_ERR(newmnt)) {
-		path_release(nd);
+		path_put(&nd->path);
 		return (void *)newmnt;
 	}
 
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -541,7 +541,7 @@ done:
 	return NULL;
 
 out_error:
-	path_release(nd);
+	path_put(&nd->path);
 	return ERR_PTR(status);
 }
 
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1415,7 +1415,7 @@ struct block_device *lookup_bdev(const c
 	if (!bdev)
 		goto fail;
 out:
-	path_release(&nd);
+	path_put(&nd.path);
 	return bdev;
 fail:
 	bdev = ERR_PTR(error);
--- a/fs/coda/pioctl.c
+++ b/fs/coda/pioctl.c
@@ -80,7 +80,7 @@ static int coda_pioctl(struct inode * in
 	
 	/* return if it is not a Coda inode */
 	if ( target_inode->i_sb != inode->i_sb ) {
-		path_release(&nd);
+		path_put(&nd.path);
 	        return  -EINVAL;
 	}
 
@@ -89,7 +89,7 @@ static int coda_pioctl(struct inode * in
 
 	error = venus_pioctl(inode->i_sb, &(cnp->c_fid), cmd, &data);
 
-	path_release(&nd);
+	path_put(&nd.path);
         return error;
 }
 
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -244,7 +244,7 @@ asmlinkage long compat_sys_statfs(const 
 		error = vfs_statfs(nd.path.dentry, &tmp);
 		if (!error)
 			error = put_compat_statfs(buf, &tmp);
-		path_release(&nd);
+		path_put(&nd.path);
 	}
 	return error;
 }
@@ -312,7 +312,7 @@ asmlinkage long compat_sys_statfs64(cons
 		error = vfs_statfs(nd.path.dentry, &tmp);
 		if (!error)
 			error = put_compat_statfs64(buf, &tmp);
-		path_release(&nd);
+		path_put(&nd.path);
 	}
 	return error;
 }
--- a/fs/configfs/symlink.c
+++ b/fs/configfs/symlink.c
@@ -103,7 +103,7 @@ static int get_target(const char *symnam
 			*target = configfs_get_config_item(nd->path.dentry);
 			if (!*target) {
 				ret = -ENOENT;
-				path_release(nd);
+				path_put(&nd->path);
 			}
 		} else
 			ret = -EPERM;
@@ -141,7 +141,7 @@ int configfs_symlink(struct inode *dir, 
 		ret = create_link(parent_item, target_item, dentry);
 
 	config_item_put(target_item);
-	path_release(&nd);
+	path_put(&nd.path);
 
 out_put:
 	config_item_put(parent_item);
--- a/fs/dquot.c
+++ b/fs/dquot.c
@@ -1630,7 +1630,7 @@ int vfs_quota_on(struct super_block *sb,
 		error = vfs_quota_on_inode(nd.path.dentry->d_inode, type,
 					   format_id);
 out_path:
-	path_release(&nd);
+	path_put(&nd.path);
 	return error;
 }
 
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -531,7 +531,7 @@ static int ecryptfs_read_super(struct su
 	rc = 0;
 	goto out;
 out_free:
-	path_release(&nd);
+	path_put(&nd.path);
 out:
 	return rc;
 }
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -148,7 +148,7 @@ out:
   	return error;
 exit:
 	release_open_intent(&nd);
-	path_release(&nd);
+	path_put(&nd.path);
 	goto out;
 }
 
@@ -672,7 +672,7 @@ out:
 			}
 		}
 		release_open_intent(&nd);
-		path_release(&nd);
+		path_put(&nd.path);
 	}
 	goto out;
 }
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -2736,7 +2736,7 @@ static int ext3_quota_on(struct super_bl
 		return err;
 	/* Quotafile not on the same filesystem? */
 	if (nd.path.mnt->mnt_sb != sb) {
-		path_release(&nd);
+		path_put(&nd.path);
 		return -EXDEV;
 	}
 	/* Quotafile not of fs root? */
@@ -2744,7 +2744,7 @@ static int ext3_quota_on(struct super_bl
 		printk(KERN_WARNING
 			"EXT3-fs: Quota file not on filesystem root. "
 			"Journalled quota will not work.\n");
-	path_release(&nd);
+	path_put(&nd.path);
 	return vfs_quota_on(sb, type, format_id, path);
 }
 
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2939,7 +2939,7 @@ static int ext4_quota_on(struct super_bl
 		return err;
 	/* Quotafile not on the same filesystem? */
 	if (nd.path.mnt->mnt_sb != sb) {
-		path_release(&nd);
+		path_put(&nd.path);
 		return -EXDEV;
 	}
 	/* Quotafile not of fs root? */
@@ -2947,7 +2947,7 @@ static int ext4_quota_on(struct super_bl
 		printk(KERN_WARNING
 			"EXT4-fs: Quota file not on filesystem root. "
 			"Journalled quota will not work.\n");
-	path_release(&nd);
+	path_put(&nd.path);
 	return vfs_quota_on(sb, type, format_id, path);
 }
 
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -837,7 +837,7 @@ static struct super_block* get_gfs2_sb(c
 	       "mount point %s\n", dev_name);
 
 free_nd:
-	path_release(&nd);
+	path_put(&nd.path);
 out:
 	return sb;
 }
--- a/fs/inotify_user.c
+++ b/fs/inotify_user.c
@@ -352,7 +352,7 @@ static int find_inode(const char __user 
 	/* you can only watch an inode if you have read permissions on it */
 	error = vfs_permission(nd, MAY_READ);
 	if (error)
-		path_release(nd);
+		path_put(&nd->path);
 	return error;
 }
 
@@ -649,7 +649,7 @@ asmlinkage long sys_inotify_add_watch(in
 		ret = create_watch(dev, inode, mask);
 	mutex_unlock(&dev->up_mutex);
 
-	path_release(&nd);
+	path_put(&nd.path);
 fput_and_out:
 	fput_light(filp, fput_needed);
 	return ret;
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -362,11 +362,18 @@ int deny_write_access(struct file * file
 	return 0;
 }
 
-void path_release(struct nameidata *nd)
+/**
+ * path_put - put a reference to a path
+ * @path: path to put the reference to
+ *
+ * Given a path decrement the reference count to the dentry and the vfsmount.
+ */
+void path_put(struct path *path)
 {
-	dput(nd->path.dentry);
-	mntput(nd->path.mnt);
+	dput(path->dentry);
+	mntput(path->mnt);
 }
+EXPORT_SYMBOL(path_put);
 
 /**
  * release_open_intent - free up open intent resources
@@ -552,7 +559,7 @@ static __always_inline int __vfs_follow_
 		goto fail;
 
 	if (*link == '/') {
-		path_release(nd);
+		path_put(&nd->path);
 		if (!walk_init_root(link, nd))
 			/* weird __emul_prefix() stuff did it */
 			goto out;
@@ -568,18 +575,18 @@ out:
 	 */
 	name = __getname();
 	if (unlikely(!name)) {
-		path_release(nd);
+		path_put(&nd->path);
 		return -ENOMEM;
 	}
 	strcpy(name, nd->last.name);
 	nd->last.name = name;
 	return 0;
 fail:
-	path_release(nd);
+	path_put(&nd->path);
 	return PTR_ERR(link);
 }
 
-static inline void dput_path(struct path *path, struct nameidata *nd)
+static void path_put_conditional(struct path *path, struct nameidata *nd)
 {
 	dput(path->dentry);
 	if (path->mnt != nd->path.mnt)
@@ -652,8 +659,8 @@ static inline int do_follow_link(struct 
 	nd->depth--;
 	return err;
 loop:
-	dput_path(path, nd);
-	path_release(nd);
+	path_put_conditional(path, nd);
+	path_put(&nd->path);
 	return err;
 }
 
@@ -994,10 +1001,10 @@ return_reval:
 return_base:
 		return 0;
 out_dput:
-		dput_path(&next, nd);
+		path_put_conditional(&next, nd);
 		break;
 	}
-	path_release(nd);
+	path_put(&nd->path);
 return_err:
 	return err;
 }
@@ -1071,7 +1078,7 @@ static int __emul_lookup_dentry(const ch
 				mntput(old_mnt);
 				return 1;
 			}
-			path_release(nd);
+			path_put(&nd->path);
 		}
 		nd->path.dentry = old_dentry;
 		nd->path.mnt = old_mnt;
@@ -1231,7 +1238,7 @@ static int __path_lookup_intent_open(int
 	if (IS_ERR(nd->intent.open.file)) {
 		if (err == 0) {
 			err = PTR_ERR(nd->intent.open.file);
-			path_release(nd);
+			path_put(&nd->path);
 		}
 	} else if (err != 0)
 		release_open_intent(nd);
@@ -1819,11 +1826,11 @@ ok:
 exit_mutex_unlock:
 	mutex_unlock(&dir->d_inode->i_mutex);
 exit_dput:
-	dput_path(&path, nd);
+	path_put_conditional(&path, nd);
 exit:
 	if (!IS_ERR(nd->intent.open.file))
 		release_open_intent(nd);
-	path_release(nd);
+	path_put(&nd->path);
 	return error;
 
 do_link:
@@ -2004,7 +2011,7 @@ out_dput:
 	dput(dentry);
 out_unlock:
 	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
-	path_release(&nd);
+	path_put(&nd.path);
 out:
 	putname(tmp);
 
@@ -2069,7 +2076,7 @@ out_dput:
 	dput(dentry);
 out_unlock:
 	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
-	path_release(&nd);
+	path_put(&nd.path);
 out:
 	putname(tmp);
 out_err:
@@ -2182,7 +2189,7 @@ exit3:
 exit2:
 	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
 exit1:
-	path_release(&nd);
+	path_put(&nd.path);
 exit:
 	putname(name);
 	return error;
@@ -2269,7 +2276,7 @@ static long do_unlinkat(int dfd, const c
 	if (inode)
 		iput(inode);	/* truncate the inode here */
 exit1:
-	path_release(&nd);
+	path_put(&nd.path);
 exit:
 	putname(name);
 	return error;
@@ -2351,7 +2358,7 @@ out_dput:
 	dput(dentry);
 out_unlock:
 	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
-	path_release(&nd);
+	path_put(&nd.path);
 out:
 	putname(to);
 out_putname:
@@ -2452,9 +2459,9 @@ out_dput:
 out_unlock:
 	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
 out_release:
-	path_release(&nd);
+	path_put(&nd.path);
 out:
-	path_release(&old_nd);
+	path_put(&old_nd.path);
 exit:
 	putname(to);
 
@@ -2686,9 +2693,9 @@ exit4:
 exit3:
 	unlock_rename(new_dir, old_dir);
 exit2:
-	path_release(&newnd);
+	path_put(&newnd.path);
 exit1:
-	path_release(&oldnd);
+	path_put(&oldnd.path);
 exit:
 	return error;
 }
@@ -2862,7 +2869,6 @@ EXPORT_SYMBOL(page_symlink);
 EXPORT_SYMBOL(page_symlink_inode_operations);
 EXPORT_SYMBOL(path_lookup);
 EXPORT_SYMBOL(vfs_path_lookup);
-EXPORT_SYMBOL(path_release);
 EXPORT_SYMBOL(permission);
 EXPORT_SYMBOL(vfs_permission);
 EXPORT_SYMBOL(file_permission);
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1323,7 +1323,7 @@ static int do_loopback(struct nameidata 
 
 out:
 	up_write(&namespace_sem);
-	path_release(&old_nd);
+	path_put(&old_nd.path);
 	return err;
 }
 
@@ -1462,8 +1462,8 @@ out1:
 out:
 	up_write(&namespace_sem);
 	if (!err)
-		path_release(&parent_nd);
-	path_release(&old_nd);
+		path_put(&parent_nd.path);
+	path_put(&old_nd.path);
 	return err;
 }
 
@@ -1902,7 +1902,7 @@ long do_mount(char *dev_name, char *dir_
 		retval = do_new_mount(&nd, type_page, flags, mnt_flags,
 				      dev_name, data_page);
 dput_out:
-	path_release(&nd);
+	path_put(&nd.path);
 	return retval;
 }
 
@@ -2158,7 +2158,7 @@ asmlinkage long sys_pivot_root(const cha
 
 	error = security_sb_pivotroot(&old_nd, &new_nd);
 	if (error) {
-		path_release(&old_nd);
+		path_put(&old_nd.path);
 		goto out1;
 	}
 
@@ -2221,15 +2221,15 @@ asmlinkage long sys_pivot_root(const cha
 	chroot_fs_refs(&user_nd, &new_nd);
 	security_sb_post_pivotroot(&user_nd, &new_nd);
 	error = 0;
-	path_release(&root_parent);
-	path_release(&parent_nd);
+	path_put(&root_parent.path);
+	path_put(&parent_nd.path);
 out2:
 	mutex_unlock(&old_nd.path.dentry->d_inode->i_mutex);
 	up_write(&namespace_sem);
-	path_release(&user_nd);
-	path_release(&old_nd);
+	path_put(&user_nd.path);
+	path_put(&old_nd.path);
 out1:
-	path_release(&new_nd);
+	path_put(&new_nd.path);
 out0:
 	unlock_kernel();
 	return error;
--- a/fs/nfs/namespace.c
+++ b/fs/nfs/namespace.c
@@ -148,7 +148,7 @@ out:
 	dprintk("<-- nfs_follow_mountpoint() = %d\n", err);
 	return ERR_PTR(err);
 out_err:
-	path_release(nd);
+	path_put(&nd->path);
 	goto out;
 out_follow:
 	while (d_mountpoint(nd->path.dentry) &&
--- a/fs/nfsctl.c
+++ b/fs/nfsctl.c
@@ -43,7 +43,7 @@ static struct file *do_open(char *name, 
 	if (!error)
 		return dentry_open(nd.path.dentry, nd.path.mnt, flags);
 
-	path_release(&nd);
+	path_put(&nd.path);
 	return ERR_PTR(error);
 }
 
--- a/fs/nfsd/export.c
+++ b/fs/nfsd/export.c
@@ -177,7 +177,7 @@ static int expkey_parse(struct cache_det
 			cache_put(&ek->h, &svc_expkey_cache);
 		else
 			err = -ENOMEM;
-		path_release(&nd);
+		path_put(&nd.path);
 	}
 	cache_flush();
  out:
@@ -630,7 +630,7 @@ static int svc_export_parse(struct cache
 	kfree(exp.ex_uuid);
  	kfree(exp.ex_path);
 	if (nd.path.dentry)
-		path_release(&nd);
+		path_put(&nd.path);
  out_no_path:
 	if (dom)
 		auth_domain_put(dom);
@@ -1098,7 +1098,7 @@ finish:
 		cache_put(&fsid_key->h, &svc_expkey_cache);
 	if (clp)
 		auth_domain_put(clp);
-	path_release(&nd);
+	path_put(&nd.path);
 out_unlock:
 	exp_writeunlock();
 out:
@@ -1150,7 +1150,7 @@ exp_unexport(struct nfsctl_export *nxp)
 
 	err = -EINVAL;
 	exp = exp_get_by_name(dom, nd.path.mnt, nd.path.dentry, NULL);
-	path_release(&nd);
+	path_put(&nd.path);
 	if (IS_ERR(exp))
 		goto out_domain;
 
@@ -1209,7 +1209,7 @@ exp_rootfh(svc_client *clp, char *path, 
 	fh_put(&fh);
 	exp_put(exp);
 out:
-	path_release(&nd);
+	path_put(&nd.path);
 	return err;
 }
 
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -421,5 +421,5 @@ nfsd4_shutdown_recdir(void)
 	if (!rec_dir_init)
 		return;
 	rec_dir_init = 0;
-	path_release(&rec_dir);
+	path_put(&rec_dir.path);
 }
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -3330,7 +3330,7 @@ nfs4_reset_recoverydir(char *recdir)
 		nfs4_set_recdir(recdir);
 		status = 0;
 	}
-	path_release(&nd);
+	path_put(&nd.path);
 	return status;
 }
 
--- a/fs/open.c
+++ b/fs/open.c
@@ -130,7 +130,7 @@ asmlinkage long sys_statfs(const char __
 		error = vfs_statfs_native(nd.path.dentry, &tmp);
 		if (!error && copy_to_user(buf, &tmp, sizeof(tmp)))
 			error = -EFAULT;
-		path_release(&nd);
+		path_put(&nd.path);
 	}
 	return error;
 }
@@ -149,7 +149,7 @@ asmlinkage long sys_statfs64(const char 
 		error = vfs_statfs64(nd.path.dentry, &tmp);
 		if (!error && copy_to_user(buf, &tmp, sizeof(tmp)))
 			error = -EFAULT;
-		path_release(&nd);
+		path_put(&nd.path);
 	}
 	return error;
 }
@@ -279,7 +279,7 @@ put_write_and_out:
 mnt_drop_write_and_out:
 	mnt_drop_write(nd.path.mnt);
 dput_and_out:
-	path_release(&nd);
+	path_put(&nd.path);
 out:
 	return error;
 }
@@ -473,7 +473,7 @@ asmlinkage long sys_faccessat(int dfd, c
 		res = -EROFS;
 
 out_path_release:
-	path_release(&nd);
+	path_put(&nd.path);
 out:
 	current->fsuid = old_fsuid;
 	current->fsgid = old_fsgid;
@@ -504,7 +504,7 @@ asmlinkage long sys_chdir(const char __u
 	set_fs_pwd(current->fs, nd.path.mnt, nd.path.dentry);
 
 dput_and_out:
-	path_release(&nd);
+	path_put(&nd.path);
 out:
 	return error;
 }
@@ -560,7 +560,7 @@ asmlinkage long sys_chroot(const char __
 	set_fs_altroot();
 	error = 0;
 dput_and_out:
-	path_release(&nd);
+	path_put(&nd.path);
 out:
 	return error;
 }
@@ -636,7 +636,7 @@ asmlinkage long sys_fchmodat(int dfd, co
 out_drop_write:
 	mnt_drop_write(nd.path.mnt);
 dput_and_out:
-	path_release(&nd);
+	path_put(&nd.path);
 out:
 	return error;
 }
@@ -693,7 +693,7 @@ asmlinkage long sys_chown(const char __u
 	error = chown_common(nd.path.dentry, user, group);
 	mnt_drop_write(nd.path.mnt);
 out_release:
-	path_release(&nd);
+	path_put(&nd.path);
 out:
 	return error;
 }
@@ -718,7 +718,7 @@ asmlinkage long sys_fchownat(int dfd, co
 	error = chown_common(nd.path.dentry, user, group);
 	mnt_drop_write(nd.path.mnt);
 out_release:
-	path_release(&nd);
+	path_put(&nd.path);
 out:
 	return error;
 }
@@ -737,7 +737,7 @@ asmlinkage long sys_lchown(const char __
 	error = chown_common(nd.path.dentry, user, group);
 	mnt_drop_write(nd.path.mnt);
 out_release:
-	path_release(&nd);
+	path_put(&nd.path);
 out:
 	return error;
 }
@@ -926,7 +926,7 @@ struct file *nameidata_to_filp(struct na
 		filp = __dentry_open(nd->path.dentry, nd->path.mnt, flags, filp,
 				     NULL);
 	else
-		path_release(nd);
+		path_put(&nd->path);
 	return filp;
 }
 
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1033,7 +1033,7 @@ static void *proc_pid_follow_link(struct
 	int error = -EACCES;
 
 	/* We don't need a base pointer in the /proc filesystem */
-	path_release(nd);
+	path_put(&nd->path);
 
 	/* Are we allowed to snoop on the tasks file descriptors? */
 	if (!proc_fd_access_allowed(inode))
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -1998,20 +1998,20 @@ static int reiserfs_quota_on(struct supe
 		return err;
 	/* Quotafile not on the same filesystem? */
 	if (nd.path.mnt->mnt_sb != sb) {
-		path_release(&nd);
+		path_put(&nd.path);
 		return -EXDEV;
 	}
 	/* We must not pack tails for quota files on reiserfs for quota IO to work */
 	if (!REISERFS_I(nd.path.dentry->d_inode)->i_flags & i_nopack_mask) {
 		reiserfs_warning(sb,
 				 "reiserfs: Quota file must have tail packing disabled.");
-		path_release(&nd);
+		path_put(&nd.path);
 		return -EINVAL;
 	}
 	/* Not journalling quota? No more tests needed... */
 	if (!REISERFS_SB(sb)->s_qf_names[USRQUOTA] &&
 	    !REISERFS_SB(sb)->s_qf_names[GRPQUOTA]) {
-		path_release(&nd);
+		path_put(&nd.path);
 		return vfs_quota_on(sb, type, format_id, path);
 	}
 	/* Quotafile not of fs root? */
@@ -2019,7 +2019,7 @@ static int reiserfs_quota_on(struct supe
 		reiserfs_warning(sb,
 				 "reiserfs: Quota file not on filesystem root. "
 				 "Journalled quota will not work.");
-	path_release(&nd);
+	path_put(&nd.path);
 	return vfs_quota_on(sb, type, format_id, path);
 }
 
--- a/fs/revoke.c
+++ b/fs/revoke.c
@@ -650,7 +650,7 @@ asmlinkage long sys_revokeat(int dfd, co
 	err = __user_walk_fd(dfd, filename, 0, &nd);
 	if (!err) {
 		err = do_revoke(nd.path.dentry->d_inode, NULL);
-		path_release(&nd);
+		path_put(&nd.path);
 	}
 	return err;
 }
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -63,7 +63,7 @@ int vfs_stat_fd(int dfd, char __user *na
 	error = __user_walk_fd(dfd, name, LOOKUP_FOLLOW, &nd);
 	if (!error) {
 		error = vfs_getattr(nd.path.mnt, nd.path.dentry, stat);
-		path_release(&nd);
+		path_put(&nd.path);
 	}
 	return error;
 }
@@ -83,7 +83,7 @@ int vfs_lstat_fd(int dfd, char __user *n
 	error = __user_walk_fd(dfd, name, 0, &nd);
 	if (!error) {
 		error = vfs_getattr(nd.path.mnt, nd.path.dentry, stat);
-		path_release(&nd);
+		path_put(&nd.path);
 	}
 	return error;
 }
@@ -313,7 +313,7 @@ asmlinkage long sys_readlinkat(int dfd, 
 							      buf, bufsiz);
 			}
 		}
-		path_release(&nd);
+		path_put(&nd.path);
 	}
 	return error;
 }
--- a/fs/unionfs/main.c
+++ b/fs/unionfs/main.c
@@ -368,7 +368,7 @@ static int parse_dirs_option(struct supe
 		if (err) {
 			printk(KERN_ERR "unionfs: lower directory "
 			       "'%s' is not a valid branch\n", name);
-			path_release(&nd);
+			path_put(&nd.path);
 			goto out;
 		}
 
--- a/fs/unionfs/super.c
+++ b/fs/unionfs/super.c
@@ -205,7 +205,7 @@ static noinline int do_remount_mode_opti
 		if (nd.path.mnt == new_lower_paths[idx].mnt &&
 		    nd.path.dentry == new_lower_paths[idx].dentry)
 			break;
-	path_release(&nd);	/* no longer needed */
+	path_put(&nd.path);	/* no longer needed */
 	if (idx == cur_branches) {
 		err = -ENOENT;	/* err may have been reset above */
 		printk(KERN_ERR "unionfs: branch \"%s\" "
@@ -248,7 +248,7 @@ static noinline int do_remount_del_optio
 		if (nd.path.mnt == new_lower_paths[idx].mnt &&
 		    nd.path.dentry == new_lower_paths[idx].dentry)
 			break;
-	path_release(&nd);	/* no longer needed */
+	path_put(&nd.path);	/* no longer needed */
 	if (idx == cur_branches) {
 		printk(KERN_ERR "unionfs: branch \"%s\" "
 		       "not found\n", optarg);
@@ -267,7 +267,7 @@ static noinline int do_remount_del_optio
 	 * new_data and new_lower_paths one to the left.  Finally, adjust
 	 * cur_branches.
 	 */
-	pathput(&new_lower_paths[idx]);
+	path_put(&new_lower_paths[idx]);
 
 	if (idx < cur_branches - 1) {
 		/* if idx==cur_branches-1, we delete last branch: easy */
@@ -332,7 +332,7 @@ static noinline int do_remount_add_optio
 		if (nd.path.mnt == new_lower_paths[idx].mnt &&
 		    nd.path.dentry == new_lower_paths[idx].dentry)
 			break;
-	path_release(&nd);	/* no longer needed */
+	path_put(&nd.path);	/* no longer needed */
 	if (idx == cur_branches) {
 		printk(KERN_ERR "unionfs: branch \"%s\" "
 		       "not found\n", optarg);
@@ -375,7 +375,7 @@ found_insertion_point:
 	if (err) {
 		printk(KERN_ERR "unionfs: lower directory "
 		       "\"%s\" is not a valid branch\n", optarg);
-		path_release(&nd);
+		path_put(&nd.path);
 		goto out;
 	}
 
@@ -789,7 +789,7 @@ out_release:
 	/* no need to cleanup/release anything in tmp_data */
 	if (tmp_lower_paths)
 		for (i = 0; i < new_branches; i++)
-			pathput(&tmp_lower_paths[i]);
+			path_put(&tmp_lower_paths[i]);
 out_free:
 	kfree(tmp_lower_paths);
 	kfree(tmp_data);
--- a/fs/utimes.c
+++ b/fs/utimes.c
@@ -143,7 +143,7 @@ dput_and_out:
 	if (f)
 		fput(f);
 	else
-		path_release(&nd);
+		path_put(&nd.path);
 out:
 	return error;
 }
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -239,7 +239,7 @@ sys_setxattr(char __user *path, char __u
 		return error;
 	error = setxattr(nd.path.dentry, name, value, size, flags);
 	mnt_drop_write(nd.path.mnt);
-	path_release(&nd);
+	path_put(&nd.path);
 	return error;
 }
 
@@ -258,7 +258,7 @@ sys_lsetxattr(char __user *path, char __
 		return error;
 	error = setxattr(nd.path.dentry, name, value, size, flags);
 	mnt_drop_write(nd.path.mnt);
-	path_release(&nd);
+	path_put(&nd.path);
 	return error;
 }
 
@@ -333,7 +333,7 @@ sys_getxattr(char __user *path, char __u
 	if (error)
 		return error;
 	error = getxattr(nd.path.dentry, name, value, size);
-	path_release(&nd);
+	path_put(&nd.path);
 	return error;
 }
 
@@ -348,7 +348,7 @@ sys_lgetxattr(char __user *path, char __
 	if (error)
 		return error;
 	error = getxattr(nd.path.dentry, name, value, size);
-	path_release(&nd);
+	path_put(&nd.path);
 	return error;
 }
 
@@ -407,7 +407,7 @@ sys_listxattr(char __user *path, char __
 	if (error)
 		return error;
 	error = listxattr(nd.path.dentry, list, size);
-	path_release(&nd);
+	path_put(&nd.path);
 	return error;
 }
 
@@ -421,7 +421,7 @@ sys_llistxattr(char __user *path, char _
 	if (error)
 		return error;
 	error = listxattr(nd.path.dentry, list, size);
-	path_release(&nd);
+	path_put(&nd.path);
 	return error;
 }
 
@@ -468,7 +468,7 @@ sys_removexattr(char __user *path, char 
 	if (error)
 		return error;
 	error = removexattr(nd.path.dentry, name);
-	path_release(&nd);
+	path_put(&nd.path);
 	return error;
 }
 
@@ -482,7 +482,7 @@ sys_lremovexattr(char __user *path, char
 	if (error)
 		return error;
 	error = removexattr(nd.path.dentry, name);
-	path_release(&nd);
+	path_put(&nd.path);
 	return error;
 }
 
--- a/fs/xfs/linux-2.6/xfs_ioctl.c
+++ b/fs/xfs/linux-2.6/xfs_ioctl.c
@@ -95,7 +95,7 @@ xfs_find_handle(
 		ASSERT(nd.path.dentry);
 		ASSERT(nd.path.dentry->d_inode);
 		inode = igrab(nd.path.dentry->d_inode);
-		path_release(&nd);
+		path_put(&nd.path);
 		break;
 	}
 
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -67,7 +67,6 @@ extern int FASTCALL(__user_walk_fd(int d
 extern int FASTCALL(path_lookup(const char *, unsigned, struct nameidata *));
 extern int vfs_path_lookup(struct dentry *, struct vfsmount *,
 			   const char *, unsigned int, struct nameidata *);
-extern void path_release(struct nameidata *);
 
 extern int __user_path_lookup_open(const char __user *, unsigned lookup_flags, struct nameidata *nd, int open_flags);
 extern int path_lookup_open(int dfd, const char *name, unsigned lookup_flags, struct nameidata *, int open_flags);
@@ -101,10 +100,4 @@ static inline void pathget(struct path *
 	dget(path->dentry);
 }
 
-static inline void pathput(struct path *path)
-{
-	dput(path->dentry);
-	mntput(path->mnt);
-}
-
 #endif /* _LINUX_NAMEI_H */
--- a/include/linux/path.h
+++ b/include/linux/path.h
@@ -9,4 +9,6 @@ struct path {
 	struct dentry *dentry;
 };
 
+extern void path_put(struct path *);
+
 #endif  /* _LINUX_PATH_H */
--- a/kernel/audit_tree.c
+++ b/kernel/audit_tree.c
@@ -550,7 +550,7 @@ void audit_trim_trees(void)
 			goto skip_it;
 
 		root_mnt = collect_mounts(nd.path.mnt, nd.path.dentry);
-		path_release(&nd);
+		path_put(&nd.path);
 		if (!root_mnt)
 			goto skip_it;
 
@@ -642,7 +642,7 @@ int audit_add_tree_rule(struct audit_kru
 	if (err)
 		goto Err;
 	mnt = collect_mounts(nd.path.mnt, nd.path.dentry);
-	path_release(&nd);
+	path_put(&nd.path);
 	if (!mnt) {
 		err = -ENOMEM;
 		goto Err;
@@ -702,7 +702,7 @@ int audit_tag_tree(char *old, char *new)
 	if (err)
 		return err;
 	tagged = collect_mounts(nd.path.mnt, nd.path.dentry);
-	path_release(&nd);
+	path_put(&nd.path);
 	if (!tagged)
 		return -ENOMEM;
 
@@ -711,9 +711,9 @@ int audit_tag_tree(char *old, char *new)
 		drop_collected_mounts(tagged);
 		return err;
 	}
-	mnt = mntget(nd.mnt);
-	dentry = dget(nd.dentry);
-	path_release(&nd);
+	mnt = mntget(nd.path.mnt);
+	dentry = dget(nd.path.dentry);
+	path_put(&nd.path);
 
 	if (dentry == tagged->mnt_root && dentry == mnt->mnt_root)
 		follow_up(&mnt, &dentry);
@@ -744,13 +744,13 @@ int audit_tag_tree(char *old, char *new)
 		spin_lock(&vfsmount_lock);
 		if (!is_under(mnt, dentry, &nd)) {
 			spin_unlock(&vfsmount_lock);
-			path_release(&nd);
+			path_put(&nd.path);
 			put_tree(tree);
 			mutex_lock(&audit_filter_mutex);
 			continue;
 		}
 		spin_unlock(&vfsmount_lock);
-		path_release(&nd);
+		path_put(&nd.path);
 
 		list_for_each_entry(p, &list, mnt_list) {
 			failed = tag_chunk(p->mnt_root->d_inode, tree);
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -1152,11 +1152,11 @@ static int audit_get_nd(char *path, stru
 static void audit_put_nd(struct nameidata *ndp, struct nameidata *ndw)
 {
 	if (ndp) {
-		path_release(ndp);
+		path_put(&ndp->path);
 		kfree(ndp);
 	}
 	if (ndw) {
-		path_release(ndw);
+		path_put(&ndw->path);
 		kfree(ndw);
 	}
 }
--- a/net/sunrpc/rpc_pipe.c
+++ b/net/sunrpc/rpc_pipe.c
@@ -484,7 +484,7 @@ rpc_lookup_parent(char *path, struct nam
 static void
 rpc_release_path(struct nameidata *nd)
 {
-	path_release(nd);
+	path_put(&nd->path);
 	rpc_put_mount();
 }
 
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -752,7 +752,7 @@ static struct sock *unix_find_other(stru
 		if (u->sk_type == type)
 			touch_atime(nd.path.mnt, nd.path.dentry);
 
-		path_release(&nd);
+		path_put(&nd.path);
 		mnt_drop_write(nd.path.mnt);
 
 		err=-EPROTOTYPE;
@@ -776,7 +776,7 @@ static struct sock *unix_find_other(stru
 mnt_drop_write_fail:
 	mnt_drop_write(nd.path.mnt);
 put_path_fail:
-	path_release(&nd);
+	path_put(&nd.path);
 fail:
 	*error=err;
 	return NULL;
@@ -893,7 +893,7 @@ out_mknod_dput:
 	dput(dentry);
 out_mknod_unlock:
 	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
-	path_release(&nd);
+	path_put(&nd.path);
 out_mknod_parent:
 	if (err==-EEXIST)
 		err=-EADDRINUSE;
