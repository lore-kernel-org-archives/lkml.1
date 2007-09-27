Return-Path: <linux-kernel-owner+w=401wt.eu-S1758135AbXI0OM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758135AbXI0OM1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 10:12:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756595AbXI0OJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 10:09:52 -0400
Received: from ns2.suse.de ([195.135.220.15]:55087 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755966AbXI0OJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 10:09:45 -0400
Message-Id: <20070927141228.394339995@X40.localnet>
References: <20070927141200.820970144@X40.localnet>
User-Agent: quilt/0.46-62.1
Date: Thu, 27 Sep 2007 16:12:06 +0200
From: jblunck@suse.de
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, hch@lst.de, agruen@suse.de, tiwai@suse.de
Subject: [patch 06/10] Introduce path_put()
Content-Disposition: inline; filename=nameidata-path-3.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Add path_put() functions for releasing a reference to the dentry and
  vfsmount of a struct path in the right order

* Switch from path_release(nd) to path_put(&nd->path)

* Rename dput_path() to path_put_conditional()

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
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
 fs/stat.c                                    |    6 +-
 fs/utimes.c                                  |    2 
 fs/xattr.c                                   |   16 +++----
 fs/xfs/linux-2.6/xfs_ioctl.c                 |    2 
 include/linux/namei.h                        |    1 
 include/linux/path.h                         |    2 
 kernel/auditfilter.c                         |    4 -
 net/sunrpc/rpc_pipe.c                        |    2 
 net/unix/af_unix.c                           |    6 +-
 39 files changed, 118 insertions(+), 111 deletions(-)

Index: b/arch/alpha/kernel/osf_sys.c
===================================================================
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
Index: b/arch/mips/kernel/sysirix.c
===================================================================
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
Index: b/arch/parisc/hpux/sys_hpux.c
===================================================================
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
Index: b/arch/powerpc/platforms/cell/spufs/syscalls.c
===================================================================
--- a/arch/powerpc/platforms/cell/spufs/syscalls.c
+++ b/arch/powerpc/platforms/cell/spufs/syscalls.c
@@ -91,7 +91,7 @@ asmlinkage long do_spu_create(const char
 				LOOKUP_OPEN|LOOKUP_CREATE, &nd);
 		if (!ret) {
 			ret = spufs_create(&nd, flags, mode, neighbor);
-			path_release(&nd);
+			path_put(&nd.path);
 		}
 		putname(tmp);
 	}
Index: b/arch/sparc64/solaris/fs.c
===================================================================
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
Index: b/drivers/md/dm-table.c
===================================================================
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -370,7 +370,7 @@ static int lookup_device(const char *pat
 	*dev = inode->i_rdev;
 
  out:
-	path_release(&nd);
+	path_put(&nd.path);
 	return r;
 }
 
Index: b/drivers/mtd/mtdsuper.c
===================================================================
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
Index: b/fs/afs/mntpt.c
===================================================================
--- a/fs/afs/mntpt.c
+++ b/fs/afs/mntpt.c
@@ -227,7 +227,7 @@ static void *afs_mntpt_follow_link(struc
 
 	newmnt = afs_mntpt_do_automount(nd->path.dentry);
 	if (IS_ERR(newmnt)) {
-		path_release(nd);
+		path_put(&nd->path);
 		return (void *)newmnt;
 	}
 
Index: b/fs/autofs4/root.c
===================================================================
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -383,7 +383,7 @@ done:
 	return NULL;
 
 out_error:
-	path_release(nd);
+	path_put(&nd->path);
 	return ERR_PTR(status);
 }
 
Index: b/fs/block_dev.c
===================================================================
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1398,7 +1398,7 @@ struct block_device *lookup_bdev(const c
 	if (!bdev)
 		goto fail;
 out:
-	path_release(&nd);
+	path_put(&nd.path);
 	return bdev;
 fail:
 	bdev = ERR_PTR(error);
Index: b/fs/coda/pioctl.c
===================================================================
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
 
Index: b/fs/compat.c
===================================================================
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
Index: b/fs/configfs/symlink.c
===================================================================
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
Index: b/fs/dquot.c
===================================================================
--- a/fs/dquot.c
+++ b/fs/dquot.c
@@ -1553,7 +1553,7 @@ int vfs_quota_on(struct super_block *sb,
 		error = vfs_quota_on_inode(nd.path.dentry->d_inode, type,
 					   format_id);
 out_path:
-	path_release(&nd);
+	path_put(&nd.path);
 	return error;
 }
 
Index: b/fs/ecryptfs/main.c
===================================================================
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -500,7 +500,7 @@ static int ecryptfs_read_super(struct su
 	rc = 0;
 	goto out;
 out_free:
-	path_release(&nd);
+	path_put(&nd.path);
 out:
 	return rc;
 }
Index: b/fs/exec.c
===================================================================
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -174,7 +174,7 @@ out:
   	return error;
 exit:
 	release_open_intent(&nd);
-	path_release(&nd);
+	path_put(&nd.path);
 	goto out;
 }
 
@@ -698,7 +698,7 @@ out:
 			}
 		}
 		release_open_intent(&nd);
-		path_release(&nd);
+		path_put(&nd.path);
 	}
 	goto out;
 }
Index: b/fs/ext3/super.c
===================================================================
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -2648,7 +2648,7 @@ static int ext3_quota_on(struct super_bl
 		return err;
 	/* Quotafile not on the same filesystem? */
 	if (nd.path.mnt->mnt_sb != sb) {
-		path_release(&nd);
+		path_put(&nd.path);
 		return -EXDEV;
 	}
 	/* Quotafile not of fs root? */
@@ -2656,7 +2656,7 @@ static int ext3_quota_on(struct super_bl
 		printk(KERN_WARNING
 			"EXT3-fs: Quota file not on filesystem root. "
 			"Journalled quota will not work.\n");
-	path_release(&nd);
+	path_put(&nd.path);
 	return vfs_quota_on(sb, type, format_id, path);
 }
 
Index: b/fs/ext4/super.c
===================================================================
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2768,7 +2768,7 @@ static int ext4_quota_on(struct super_bl
 		return err;
 	/* Quotafile not on the same filesystem? */
 	if (nd.path.mnt->mnt_sb != sb) {
-		path_release(&nd);
+		path_put(&nd.path);
 		return -EXDEV;
 	}
 	/* Quotafile not of fs root? */
@@ -2776,7 +2776,7 @@ static int ext4_quota_on(struct super_bl
 		printk(KERN_WARNING
 			"EXT4-fs: Quota file not on filesystem root. "
 			"Journalled quota will not work.\n");
-	path_release(&nd);
+	path_put(&nd.path);
 	return vfs_quota_on(sb, type, format_id, path);
 }
 
Index: b/fs/gfs2/ops_fstype.c
===================================================================
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -844,7 +844,7 @@ static struct super_block* get_gfs2_sb(c
 	       "mount point %s\n", dev_name);
 
 free_nd:
-	path_release(&nd);
+	path_put(&nd.path);
 out:
 	return sb;
 }
Index: b/fs/inotify_user.c
===================================================================
--- a/fs/inotify_user.c
+++ b/fs/inotify_user.c
@@ -351,7 +351,7 @@ static int find_inode(const char __user 
 	/* you can only watch an inode if you have read permissions on it */
 	error = vfs_permission(nd, MAY_READ);
 	if (error)
-		path_release(nd);
+		path_put(&nd->path);
 	return error;
 }
 
@@ -648,7 +648,7 @@ asmlinkage long sys_inotify_add_watch(in
 		ret = create_watch(dev, inode, mask);
 	mutex_unlock(&dev->up_mutex);
 
-	path_release(&nd);
+	path_put(&nd.path);
 fput_and_out:
 	fput_light(filp, fput_needed);
 	return ret;
Index: b/fs/namei.c
===================================================================
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -347,11 +347,18 @@ int deny_write_access(struct file * file
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
@@ -536,7 +543,7 @@ static __always_inline int __vfs_follow_
 		goto fail;
 
 	if (*link == '/') {
-		path_release(nd);
+		path_put(&nd->path);
 		if (!walk_init_root(link, nd))
 			/* weird __emul_prefix() stuff did it */
 			goto out;
@@ -552,18 +559,18 @@ out:
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
@@ -636,8 +643,8 @@ static inline int do_follow_link(struct 
 	nd->depth--;
 	return err;
 loop:
-	dput_path(path, nd);
-	path_release(nd);
+	path_put_conditional(path, nd);
+	path_put(&nd->path);
 	return err;
 }
 
@@ -978,10 +985,10 @@ return_reval:
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
@@ -1055,7 +1062,7 @@ static int __emul_lookup_dentry(const ch
 				mntput(old_mnt);
 				return 1;
 			}
-			path_release(nd);
+			path_put(&nd->path);
 		}
 		nd->path.dentry = old_dentry;
 		nd->path.mnt = old_mnt;
@@ -1215,7 +1222,7 @@ static int __path_lookup_intent_open(int
 	if (IS_ERR(nd->intent.open.file)) {
 		if (err == 0) {
 			err = PTR_ERR(nd->intent.open.file);
-			path_release(nd);
+			path_put(&nd->path);
 		}
 	} else if (err != 0)
 		release_open_intent(nd);
@@ -1775,11 +1782,11 @@ ok:
 	return 0;
 
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
@@ -1950,7 +1957,7 @@ asmlinkage long sys_mknodat(int dfd, con
 		dput(dentry);
 	}
 	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
-	path_release(&nd);
+	path_put(&nd.path);
 out:
 	putname(tmp);
 
@@ -2010,7 +2017,7 @@ asmlinkage long sys_mkdirat(int dfd, con
 	dput(dentry);
 out_unlock:
 	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
-	path_release(&nd);
+	path_put(&nd.path);
 out:
 	putname(tmp);
 out_err:
@@ -2118,7 +2125,7 @@ static long do_rmdir(int dfd, const char
 exit2:
 	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
 exit1:
-	path_release(&nd);
+	path_put(&nd.path);
 exit:
 	putname(name);
 	return error;
@@ -2201,7 +2208,7 @@ static long do_unlinkat(int dfd, const c
 	if (inode)
 		iput(inode);	/* truncate the inode here */
 exit1:
-	path_release(&nd);
+	path_put(&nd.path);
 exit:
 	putname(name);
 	return error;
@@ -2278,7 +2285,7 @@ asmlinkage long sys_symlinkat(const char
 	dput(dentry);
 out_unlock:
 	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
-	path_release(&nd);
+	path_put(&nd.path);
 out:
 	putname(to);
 out_putname:
@@ -2375,9 +2382,9 @@ asmlinkage long sys_linkat(int olddfd, c
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
 
@@ -2605,9 +2612,9 @@ exit4:
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
@@ -2805,7 +2812,6 @@ EXPORT_SYMBOL(page_symlink);
 EXPORT_SYMBOL(page_symlink_inode_operations);
 EXPORT_SYMBOL(path_lookup);
 EXPORT_SYMBOL(vfs_path_lookup);
-EXPORT_SYMBOL(path_release);
 EXPORT_SYMBOL(permission);
 EXPORT_SYMBOL(vfs_permission);
 EXPORT_SYMBOL(file_permission);
Index: b/fs/namespace.c
===================================================================
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -942,7 +942,7 @@ static int do_loopback(struct nameidata 
 
 out:
 	up_write(&namespace_sem);
-	path_release(&old_nd);
+	path_put(&old_nd.path);
 	return err;
 }
 
@@ -1057,8 +1057,8 @@ out1:
 out:
 	up_write(&namespace_sem);
 	if (!err)
-		path_release(&parent_nd);
-	path_release(&old_nd);
+		path_put(&parent_nd.path);
+	path_put(&old_nd.path);
 	return err;
 }
 
@@ -1442,7 +1442,7 @@ long do_mount(char *dev_name, char *dir_
 		retval = do_new_mount(&nd, type_page, flags, mnt_flags,
 				      dev_name, data_page);
 dput_out:
-	path_release(&nd);
+	path_put(&nd.path);
 	return retval;
 }
 
@@ -1698,7 +1698,7 @@ asmlinkage long sys_pivot_root(const cha
 
 	error = security_sb_pivotroot(&old_nd, &new_nd);
 	if (error) {
-		path_release(&old_nd);
+		path_put(&old_nd.path);
 		goto out1;
 	}
 
@@ -1761,15 +1761,15 @@ asmlinkage long sys_pivot_root(const cha
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
Index: b/fs/nfs/namespace.c
===================================================================
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
Index: b/fs/nfsctl.c
===================================================================
--- a/fs/nfsctl.c
+++ b/fs/nfsctl.c
@@ -43,7 +43,7 @@ static struct file *do_open(char *name, 
 	if (!error)
 		return dentry_open(nd.path.dentry, nd.path.mnt, flags);
 
-	path_release(&nd);
+	path_put(&nd.path);
 	return ERR_PTR(error);
 }
 
Index: b/fs/nfsd/export.c
===================================================================
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
@@ -632,7 +632,7 @@ static int svc_export_parse(struct cache
 	kfree(exp.ex_uuid);
  	kfree(exp.ex_path);
 	if (nd.path.dentry)
-		path_release(&nd);
+		path_put(&nd.path);
  out_no_path:
 	if (dom)
 		auth_domain_put(dom);
@@ -1100,7 +1100,7 @@ finish:
 		cache_put(&fsid_key->h, &svc_expkey_cache);
 	if (clp)
 		auth_domain_put(clp);
-	path_release(&nd);
+	path_put(&nd.path);
 out_unlock:
 	exp_writeunlock();
 out:
@@ -1152,7 +1152,7 @@ exp_unexport(struct nfsctl_export *nxp)
 
 	err = -EINVAL;
 	exp = exp_get_by_name(dom, nd.path.mnt, nd.path.dentry, NULL);
-	path_release(&nd);
+	path_put(&nd.path);
 	if (IS_ERR(exp))
 		goto out_domain;
 
@@ -1211,7 +1211,7 @@ exp_rootfh(svc_client *clp, char *path, 
 	fh_put(&fh);
 	exp_put(exp);
 out:
-	path_release(&nd);
+	path_put(&nd.path);
 	return err;
 }
 
Index: b/fs/nfsd/nfs4recover.c
===================================================================
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -417,5 +417,5 @@ nfsd4_shutdown_recdir(void)
 	if (!rec_dir_init)
 		return;
 	rec_dir_init = 0;
-	path_release(&rec_dir);
+	path_put(&rec_dir.path);
 }
Index: b/fs/nfsd/nfs4state.c
===================================================================
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -3342,7 +3342,7 @@ nfs4_reset_recoverydir(char *recdir)
 		nfs4_set_recdir(recdir);
 		status = 0;
 	}
-	path_release(&nd);
+	path_put(&nd.path);
 	return status;
 }
 
Index: b/fs/open.c
===================================================================
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
@@ -277,7 +277,7 @@ static long do_sys_truncate(const char _
 put_write_and_out:
 	put_write_access(inode);
 dput_and_out:
-	path_release(&nd);
+	path_put(&nd.path);
 out:
 	return error;
 }
@@ -462,7 +462,7 @@ asmlinkage long sys_faccessat(int dfd, c
 		res = -EROFS;
 
 out_path_release:
-	path_release(&nd);
+	path_put(&nd.path);
 out:
 	current->fsuid = old_fsuid;
 	current->fsgid = old_fsgid;
@@ -493,7 +493,7 @@ asmlinkage long sys_chdir(const char __u
 	set_fs_pwd(current->fs, nd.path.mnt, nd.path.dentry);
 
 dput_and_out:
-	path_release(&nd);
+	path_put(&nd.path);
 out:
 	return error;
 }
@@ -549,7 +549,7 @@ asmlinkage long sys_chroot(const char __
 	set_fs_altroot();
 	error = 0;
 dput_and_out:
-	path_release(&nd);
+	path_put(&nd.path);
 out:
 	return error;
 }
@@ -621,7 +621,7 @@ asmlinkage long sys_fchmodat(int dfd, co
 	mutex_unlock(&inode->i_mutex);
 
 dput_and_out:
-	path_release(&nd);
+	path_put(&nd.path);
 out:
 	return error;
 }
@@ -675,7 +675,7 @@ asmlinkage long sys_chown(const char __u
 	if (error)
 		goto out;
 	error = chown_common(nd.path.dentry, user, group);
-	path_release(&nd);
+	path_put(&nd.path);
 out:
 	return error;
 }
@@ -695,7 +695,7 @@ asmlinkage long sys_fchownat(int dfd, co
 	if (error)
 		goto out;
 	error = chown_common(nd.path.dentry, user, group);
-	path_release(&nd);
+	path_put(&nd.path);
 out:
 	return error;
 }
@@ -709,7 +709,7 @@ asmlinkage long sys_lchown(const char __
 	if (error)
 		goto out;
 	error = chown_common(nd.path.dentry, user, group);
-	path_release(&nd);
+	path_put(&nd.path);
 out:
 	return error;
 }
@@ -889,7 +889,7 @@ struct file *nameidata_to_filp(struct na
 		filp = __dentry_open(nd->path.dentry, nd->path.mnt, flags, filp,
 				     NULL);
 	else
-		path_release(nd);
+		path_put(&nd->path);
 	return filp;
 }
 
Index: b/fs/proc/base.c
===================================================================
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -938,7 +938,7 @@ static void *proc_pid_follow_link(struct
 	int error = -EACCES;
 
 	/* We don't need a base pointer in the /proc filesystem */
-	path_release(nd);
+	path_put(&nd->path);
 
 	/* Are we allowed to snoop on the tasks file descriptors? */
 	if (!proc_fd_access_allowed(inode))
Index: b/fs/reiserfs/super.c
===================================================================
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -1986,20 +1986,20 @@ static int reiserfs_quota_on(struct supe
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
@@ -2007,7 +2007,7 @@ static int reiserfs_quota_on(struct supe
 		reiserfs_warning(sb,
 				 "reiserfs: Quota file not on filesystem root. "
 				 "Journalled quota will not work.");
-	path_release(&nd);
+	path_put(&nd.path);
 	return vfs_quota_on(sb, type, format_id, path);
 }
 
Index: b/fs/stat.c
===================================================================
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
Index: b/fs/utimes.c
===================================================================
--- a/fs/utimes.c
+++ b/fs/utimes.c
@@ -124,7 +124,7 @@ dput_and_out:
 	if (f)
 		fput(f);
 	else
-		path_release(&nd);
+		path_put(&nd.path);
 out:
 	return error;
 }
Index: b/fs/xattr.c
===================================================================
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -236,7 +236,7 @@ sys_setxattr(char __user *path, char __u
 	if (error)
 		return error;
 	error = setxattr(nd.path.dentry, name, value, size, flags);
-	path_release(&nd);
+	path_put(&nd.path);
 	return error;
 }
 
@@ -251,7 +251,7 @@ sys_lsetxattr(char __user *path, char __
 	if (error)
 		return error;
 	error = setxattr(nd.path.dentry, name, value, size, flags);
-	path_release(&nd);
+	path_put(&nd.path);
 	return error;
 }
 
@@ -321,7 +321,7 @@ sys_getxattr(char __user *path, char __u
 	if (error)
 		return error;
 	error = getxattr(nd.path.dentry, name, value, size);
-	path_release(&nd);
+	path_put(&nd.path);
 	return error;
 }
 
@@ -336,7 +336,7 @@ sys_lgetxattr(char __user *path, char __
 	if (error)
 		return error;
 	error = getxattr(nd.path.dentry, name, value, size);
-	path_release(&nd);
+	path_put(&nd.path);
 	return error;
 }
 
@@ -395,7 +395,7 @@ sys_listxattr(char __user *path, char __
 	if (error)
 		return error;
 	error = listxattr(nd.path.dentry, list, size);
-	path_release(&nd);
+	path_put(&nd.path);
 	return error;
 }
 
@@ -409,7 +409,7 @@ sys_llistxattr(char __user *path, char _
 	if (error)
 		return error;
 	error = listxattr(nd.path.dentry, list, size);
-	path_release(&nd);
+	path_put(&nd.path);
 	return error;
 }
 
@@ -456,7 +456,7 @@ sys_removexattr(char __user *path, char 
 	if (error)
 		return error;
 	error = removexattr(nd.path.dentry, name);
-	path_release(&nd);
+	path_put(&nd.path);
 	return error;
 }
 
@@ -470,7 +470,7 @@ sys_lremovexattr(char __user *path, char
 	if (error)
 		return error;
 	error = removexattr(nd.path.dentry, name);
-	path_release(&nd);
+	path_put(&nd.path);
 	return error;
 }
 
Index: b/fs/xfs/linux-2.6/xfs_ioctl.c
===================================================================
--- a/fs/xfs/linux-2.6/xfs_ioctl.c
+++ b/fs/xfs/linux-2.6/xfs_ioctl.c
@@ -94,7 +94,7 @@ xfs_find_handle(
 		ASSERT(nd.path.dentry);
 		ASSERT(nd.path.dentry->d_inode);
 		inode = igrab(nd.path.dentry->d_inode);
-		path_release(&nd);
+		path_put(&nd.path);
 		break;
 	}
 
Index: b/include/linux/namei.h
===================================================================
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -66,7 +66,6 @@ extern int FASTCALL(__user_walk_fd(int d
 extern int FASTCALL(path_lookup(const char *, unsigned, struct nameidata *));
 extern int vfs_path_lookup(struct dentry *, struct vfsmount *,
 			   const char *, unsigned int, struct nameidata *);
-extern void path_release(struct nameidata *);
 
 extern int __user_path_lookup_open(const char __user *, unsigned lookup_flags, struct nameidata *nd, int open_flags);
 extern int path_lookup_open(int dfd, const char *name, unsigned lookup_flags, struct nameidata *, int open_flags);
Index: b/include/linux/path.h
===================================================================
--- a/include/linux/path.h
+++ b/include/linux/path.h
@@ -9,4 +9,6 @@ struct path {
 	struct dentry *dentry;
 };
 
+extern void path_put(struct path *);
+
 #endif  /* _LINUX_PATH_H */
Index: b/kernel/auditfilter.c
===================================================================
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -1123,11 +1123,11 @@ static int audit_get_nd(char *path, stru
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
Index: b/net/sunrpc/rpc_pipe.c
===================================================================
--- a/net/sunrpc/rpc_pipe.c
+++ b/net/sunrpc/rpc_pipe.c
@@ -483,7 +483,7 @@ rpc_lookup_parent(char *path, struct nam
 static void
 rpc_release_path(struct nameidata *nd)
 {
-	path_release(nd);
+	path_put(&nd->path);
 	rpc_put_mount();
 }
 
Index: b/net/unix/af_unix.c
===================================================================
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -743,7 +743,7 @@ static struct sock *unix_find_other(stru
 		if (u->sk_type == type)
 			touch_atime(nd.path.mnt, nd.path.dentry);
 
-		path_release(&nd);
+		path_put(&nd.path);
 
 		err=-EPROTOTYPE;
 		if (u->sk_type != type) {
@@ -764,7 +764,7 @@ static struct sock *unix_find_other(stru
 	return u;
 
 put_fail:
-	path_release(&nd);
+	path_put(&nd.path);
 fail:
 	*error=err;
 	return NULL;
@@ -877,7 +877,7 @@ out_mknod_dput:
 	dput(dentry);
 out_mknod_unlock:
 	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
-	path_release(&nd);
+	path_put(&nd.path);
 out_mknod_parent:
 	if (err==-EEXIST)
 		err=-EADDRINUSE;

-- 

