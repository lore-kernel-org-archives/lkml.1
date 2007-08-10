Return-Path: <linux-kernel-owner+w=401wt.eu-S937925AbXHJOpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937925AbXHJOpR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 10:45:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932188AbXHJOns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 10:43:48 -0400
Received: from mail.suse.de ([195.135.220.2]:33029 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760892AbXHJOnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 10:43:43 -0400
Message-Id: <20070810143846.804017666@suse.de>
User-Agent: quilt/0.46-1
Date: Fri, 10 Aug 2007 16:22:09 +0200
From: Andreas Gruenbacher <agruen@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, John Johansen <jjohansen@suse.de>,
       Jan Blunck <jblunck@suse.de>, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [patch 1/4] Introduce pathput
References: <20070808171622.632749741@suse.de> <20070808171643.542685765@suse.de>
 <20070808193209.GA31354@infradead.org>
 <20070810142208.827949199@suse.de>
Content-Disposition: inline; filename=pathput.diff
Replace-Subject: Introduce pathput
Recipient-Cc: Jan Blunck <jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Add pathput() for releasing a reference to the dentry and vfsmount of a
  struct path.

* Switch from path_release(nd) to pathget(&nd->path).

* Switch from path_release_on_umount(nd) to pathput_on_umount(&nd->path).

* Rename dput_path() to pathput_conditional().

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
 fs/namei.c                                   |   57 +++++++++++----------------
 fs/namespace.c                               |   22 +++++-----
 fs/nfs/namespace.c                           |    2 
 fs/nfsctl.c                                  |    2 
 fs/nfsd/export.c                             |   10 ++--
 fs/nfsd/nfs4recover.c                        |    2 
 fs/nfsd/nfs4state.c                          |    2 
 fs/open.c                                    |   26 ++++++------
 fs/proc/base.c                               |    2 
 fs/reiserfs/super.c                          |    8 +--
 fs/stat.c                                    |    6 +-
 fs/utimes.c                                  |    2 
 fs/xattr.c                                   |   16 +++----
 fs/xfs/linux-2.6/xfs_ioctl.c                 |    2 
 include/linux/namei.h                        |   12 +++--
 kernel/auditfilter.c                         |    4 -
 net/sunrpc/rpc_pipe.c                        |    2 
 net/unix/af_unix.c                           |    6 +-
 38 files changed, 121 insertions(+), 124 deletions(-)

--- a/arch/alpha/kernel/osf_sys.c
+++ b/arch/alpha/kernel/osf_sys.c
@@ -261,7 +261,7 @@ osf_statfs(char __user *path, struct osf
 	retval = user_path_walk(path, &nd);
 	if (!retval) {
 		retval = do_osf_statfs(nd.dentry, buffer, bufsiz);
-		path_release(&nd);
+		pathput(&nd.lookup.path);
 	}
 	return retval;
 }
--- a/arch/mips/kernel/sysirix.c
+++ b/arch/mips/kernel/sysirix.c
@@ -711,7 +711,7 @@ asmlinkage int irix_statfs(const char __
 	}
 
 dput_and_out:
-	path_release(&nd);
+	pathput(&nd.lookup.path);
 out:
 	return error;
 }
@@ -1385,7 +1385,7 @@ asmlinkage int irix_statvfs(char __user 
 		error |= __put_user(0, &buf->f_fstr[i]);
 
 dput_and_out:
-	path_release(&nd);
+	pathput(&nd.lookup.path);
 out:
 	return error;
 }
@@ -1636,7 +1636,7 @@ asmlinkage int irix_statvfs64(char __use
 		error |= __put_user(0, &buf->f_fstr[i]);
 
 dput_and_out:
-	path_release(&nd);
+	pathput(&nd.lookup.path);
 out:
 	return error;
 }
--- a/arch/parisc/hpux/sys_hpux.c
+++ b/arch/parisc/hpux/sys_hpux.c
@@ -222,7 +222,7 @@ asmlinkage long hpux_statfs(const char _
 		error = vfs_statfs_hpux(nd.dentry, &tmp);
 		if (!error && copy_to_user(buf, &tmp, sizeof(tmp)))
 			error = -EFAULT;
-		path_release(&nd);
+		pathput(&nd.lookup.path);
 	}
 	return error;
 }
--- a/arch/powerpc/platforms/cell/spufs/syscalls.c
+++ b/arch/powerpc/platforms/cell/spufs/syscalls.c
@@ -91,7 +91,7 @@ asmlinkage long do_spu_create(const char
 				LOOKUP_OPEN|LOOKUP_CREATE, &nd);
 		if (!ret) {
 			ret = spufs_create(&nd, flags, mode, neighbor);
-			path_release(&nd);
+			pathput(&nd.lookup.path);
 		}
 		putname(tmp);
 	}
--- a/arch/sparc64/solaris/fs.c
+++ b/arch/sparc64/solaris/fs.c
@@ -436,7 +436,7 @@ asmlinkage int solaris_statvfs(u32 path,
 	if (!error) {
 		struct inode * inode = nd.dentry->d_inode;
 		error = report_statvfs(nd.mnt, inode, buf);
-		path_release(&nd);
+		pathput(&nd.lookup.path);
 	}
 	return error;
 }
@@ -466,7 +466,7 @@ asmlinkage int solaris_statvfs64(u32 pat
 	if (!error) {
 		struct inode * inode = nd.dentry->d_inode;
 		error = report_statvfs64(nd.mnt, inode, buf);
-		path_release(&nd);
+		pathput(&nd.lookup.path);
 	}
 	unlock_kernel();
 	return error;
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -370,7 +370,7 @@ static int lookup_device(const char *pat
 	*dev = inode->i_rdev;
 
  out:
-	path_release(&nd);
+	pathput(&nd.lookup.path);
 	return r;
 }
 
--- a/drivers/mtd/mtdsuper.c
+++ b/drivers/mtd/mtdsuper.c
@@ -201,7 +201,7 @@ int get_sb_mtd(struct file_system_type *
 		goto not_an_MTD_device;
 
 	mtdnr = iminor(nd.lookup.path.dentry->d_inode);
-	path_release(&nd);
+	pathput(&nd.lookup.path);
 
 	return get_sb_mtd_nr(fs_type, flags, dev_name, data, mtdnr, fill_super,
 			     mnt);
@@ -212,7 +212,7 @@ not_an_MTD_device:
 		       "MTD: Attempt to mount non-MTD device \"%s\"\n",
 		       dev_name);
 out:
-	path_release(&nd);
+	pathput(&nd.lookup.path);
 	return ret;
 
 }
--- a/fs/afs/mntpt.c
+++ b/fs/afs/mntpt.c
@@ -227,7 +227,7 @@ static void *afs_mntpt_follow_link(struc
 
 	newmnt = afs_mntpt_do_automount(nd->lookup.path.dentry);
 	if (IS_ERR(newmnt)) {
-		path_release(nd);
+		pathput(&nd->lookup.path);
 		return (void *)newmnt;
 	}
 
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -382,7 +382,7 @@ done:
 	return NULL;
 
 out_error:
-	path_release(nd);
+	pathput(&nd->lookup.path);
 	return ERR_PTR(status);
 }
 
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1398,7 +1398,7 @@ struct block_device *lookup_bdev(const c
 	if (!bdev)
 		goto fail;
 out:
-	path_release(&nd);
+	pathput(&nd.lookup.path);
 	return bdev;
 fail:
 	bdev = ERR_PTR(error);
--- a/fs/coda/pioctl.c
+++ b/fs/coda/pioctl.c
@@ -80,7 +80,7 @@ static int coda_pioctl(struct inode * in
 	
 	/* return if it is not a Coda inode */
 	if ( target_inode->i_sb != inode->i_sb ) {
-		path_release(&nd);
+		pathput(&nd.lookup.path);
 	        return  -EINVAL;
 	}
 
@@ -89,7 +89,7 @@ static int coda_pioctl(struct inode * in
 
 	error = venus_pioctl(inode->i_sb, &(cnp->c_fid), cmd, &data);
 
-	path_release(&nd);
+	pathput(&nd.lookup.path);
         return error;
 }
 
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -244,7 +244,7 @@ asmlinkage long compat_sys_statfs(const 
 		error = vfs_statfs(nd.lookup.path.dentry, &tmp);
 		if (!error)
 			error = put_compat_statfs(buf, &tmp);
-		path_release(&nd);
+		pathput(&nd.lookup.path);
 	}
 	return error;
 }
@@ -312,7 +312,7 @@ asmlinkage long compat_sys_statfs64(cons
 		error = vfs_statfs(nd.lookup.path.dentry, &tmp);
 		if (!error)
 			error = put_compat_statfs64(buf, &tmp);
-		path_release(&nd);
+		pathput(&nd.lookup.path);
 	}
 	return error;
 }
--- a/fs/configfs/symlink.c
+++ b/fs/configfs/symlink.c
@@ -103,7 +103,7 @@ static int get_target(const char *symnam
 			*target = configfs_get_config_item(nd->lookup.path.dentry);
 			if (!*target) {
 				ret = -ENOENT;
-				path_release(nd);
+				pathput(&nd->lookup.path);
 			}
 		} else
 			ret = -EPERM;
@@ -141,7 +141,7 @@ int configfs_symlink(struct inode *dir, 
 		ret = create_link(parent_item, target_item, dentry);
 
 	config_item_put(target_item);
-	path_release(&nd);
+	pathput(&nd.lookup.path);
 
 out_put:
 	config_item_put(parent_item);
--- a/fs/dquot.c
+++ b/fs/dquot.c
@@ -1552,7 +1552,7 @@ int vfs_quota_on(struct super_block *sb,
 	else
 		error = vfs_quota_on_inode(nd.lookup.path.dentry->d_inode, type, format_id);
 out_path:
-	path_release(&nd);
+	pathput(&nd.lookup.path);
 	return error;
 }
 
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -500,7 +500,7 @@ static int ecryptfs_read_super(struct su
 	rc = 0;
 	goto out;
 out_free:
-	path_release(&nd);
+	pathput(&nd.lookup.path);
 out:
 	return rc;
 }
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -175,7 +175,7 @@ out:
   	return error;
 exit:
 	release_open_intent(&nd.lookup.intent.open);
-	path_release(&nd);
+	pathput(&nd.lookup.path);
 	goto out;
 }
 
@@ -699,7 +699,7 @@ out:
 			}
 		}
 		release_open_intent(&nd.lookup.intent.open);
-		path_release(&nd);
+		pathput(&nd.lookup.path);
 	}
 	goto out;
 }
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -2645,7 +2645,7 @@ static int ext3_quota_on(struct super_bl
 		return err;
 	/* Quotafile not on the same filesystem? */
 	if (nd.lookup.path.mnt->mnt_sb != sb) {
-		path_release(&nd);
+		pathput(&nd.lookup.path);
 		return -EXDEV;
 	}
 	/* Quotafile not of fs root? */
@@ -2653,7 +2653,7 @@ static int ext3_quota_on(struct super_bl
 		printk(KERN_WARNING
 			"EXT3-fs: Quota file not on filesystem root. "
 			"Journalled quota will not work.\n");
-	path_release(&nd);
+	pathput(&nd.lookup.path);
 	return vfs_quota_on(sb, type, format_id, path);
 }
 
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2765,7 +2765,7 @@ static int ext4_quota_on(struct super_bl
 		return err;
 	/* Quotafile not on the same filesystem? */
 	if (nd.lookup.path.mnt->mnt_sb != sb) {
-		path_release(&nd);
+		pathput(&nd.lookup.path);
 		return -EXDEV;
 	}
 	/* Quotafile not of fs root? */
@@ -2773,7 +2773,7 @@ static int ext4_quota_on(struct super_bl
 		printk(KERN_WARNING
 			"EXT4-fs: Quota file not on filesystem root. "
 			"Journalled quota will not work.\n");
-	path_release(&nd);
+	pathput(&nd.lookup.path);
 	return vfs_quota_on(sb, type, format_id, path);
 }
 
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -843,7 +843,7 @@ static struct super_block* get_gfs2_sb(c
 	       "mount point %s\n", dev_name);
 
 free_nd:
-	path_release(&nd);
+	pathput(&nd.lookup.path);
 out:
 	return sb;
 }
--- a/fs/inotify_user.c
+++ b/fs/inotify_user.c
@@ -351,7 +351,7 @@ static int find_inode(const char __user 
 	/* you can only watch an inode if you have read permissions on it */
 	error = vfs_permission(&nd->lookup, MAY_READ);
 	if (error)
-		path_release(nd);
+		pathput(&nd->lookup.path);
 	return error;
 }
 
@@ -648,7 +648,7 @@ asmlinkage long sys_inotify_add_watch(in
 		ret = create_watch(dev, inode, mask);
 	mutex_unlock(&dev->up_mutex);
 
-	path_release(&nd);
+	pathput(&nd.lookup.path);
 fput_and_out:
 	fput_light(filp, fput_needed);
 	return ret;
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -349,20 +349,14 @@ int deny_write_access(struct file * file
 	return 0;
 }
 
-void path_release(struct nameidata *nd)
-{
-	dput(nd->lookup.path.dentry);
-	mntput(nd->lookup.path.mnt);
-}
-
 /*
- * umount() mustn't call path_release()/mntput() as that would clear
+ * umount() mustn't call pathput()/mntput() as that would clear
  * mnt_expiry_mark
  */
-void path_release_on_umount(struct nameidata *nd)
+void pathput_on_umount(struct path *path)
 {
-	dput(nd->lookup.path.dentry);
-	mntput_no_expire(nd->lookup.path.mnt);
+	dput(path->dentry);
+	mntput_no_expire(path->mnt);
 }
 
 /**
@@ -549,7 +543,7 @@ static __always_inline int __vfs_follow_
 		goto fail;
 
 	if (*link == '/') {
-		path_release(nd);
+		pathput(&nd->lookup.path);
 		if (!walk_init_root(link, nd))
 			/* weird __emul_prefix() stuff did it */
 			goto out;
@@ -565,18 +559,18 @@ out:
 	 */
 	name = __getname();
 	if (unlikely(!name)) {
-		path_release(nd);
+		pathput(&nd->lookup.path);
 		return -ENOMEM;
 	}
 	strcpy(name, nd->last.name);
 	nd->last.name = name;
 	return 0;
 fail:
-	path_release(nd);
+	pathput(&nd->lookup.path);
 	return PTR_ERR(link);
 }
 
-static inline void dput_path(struct path *path, struct nameidata *nd)
+static inline void pathput_conditional(struct path *path, struct nameidata *nd)
 {
 	dput(path->dentry);
 	if (path->mnt != nd->lookup.path.mnt)
@@ -649,8 +643,8 @@ static inline int do_follow_link(struct 
 	nd->depth--;
 	return err;
 loop:
-	dput_path(path, nd);
-	path_release(nd);
+	pathput_conditional(path, nd);
+	pathput(&nd->lookup.path);
 	return err;
 }
 
@@ -989,10 +983,10 @@ return_reval:
 return_base:
 		return 0;
 out_dput:
-		dput_path(&next, nd);
+		pathput_conditional(&next, nd);
 		break;
 	}
-	path_release(nd);
+	pathput(&nd->lookup.path);
 return_err:
 	return err;
 }
@@ -1065,7 +1059,7 @@ static int __emul_lookup_dentry(const ch
 				mntput(old_mnt);
 				return 1;
 			}
-			path_release(nd);
+			pathput(&nd->lookup.path);
 		}
 		nd->lookup.path.dentry = old_dentry;
 		nd->lookup.path.mnt = old_mnt;
@@ -1223,7 +1217,7 @@ static int __path_lookup_intent_open(int
 	if (IS_ERR(nd->lookup.intent.open.file)) {
 		if (err == 0) {
 			err = PTR_ERR(nd->lookup.intent.open.file);
-			path_release(nd);
+			pathput(&nd->lookup.path);
 		}
 	} else if (err != 0)
 		release_open_intent(&nd->lookup.intent.open);
@@ -1783,11 +1777,11 @@ ok:
 	return 0;
 
 exit_dput:
-	dput_path(&path, nd);
+	pathput_conditional(&path, nd);
 exit:
 	if (!IS_ERR(nd->lookup.intent.open.file))
 		release_open_intent(&nd->lookup.intent.open);
-	path_release(nd);
+	pathput(&nd->lookup.path);
 	return error;
 
 do_link:
@@ -1957,7 +1951,7 @@ asmlinkage long sys_mknodat(int dfd, con
 		dput(dentry);
 	}
 	mutex_unlock(&nd.lookup.path.dentry->d_inode->i_mutex);
-	path_release(&nd);
+	pathput(&nd.lookup.path);
 out:
 	putname(tmp);
 
@@ -2017,7 +2011,7 @@ asmlinkage long sys_mkdirat(int dfd, con
 	dput(dentry);
 out_unlock:
 	mutex_unlock(&nd.lookup.path.dentry->d_inode->i_mutex);
-	path_release(&nd);
+	pathput(&nd.lookup.path);
 out:
 	putname(tmp);
 out_err:
@@ -2125,7 +2119,7 @@ static long do_rmdir(int dfd, const char
 exit2:
 	mutex_unlock(&nd.lookup.path.dentry->d_inode->i_mutex);
 exit1:
-	path_release(&nd);
+	pathput(&nd.lookup.path);
 exit:
 	putname(name);
 	return error;
@@ -2208,7 +2202,7 @@ static long do_unlinkat(int dfd, const c
 	if (inode)
 		iput(inode);	/* truncate the inode here */
 exit1:
-	path_release(&nd);
+	pathput(&nd.lookup.path);
 exit:
 	putname(name);
 	return error;
@@ -2285,7 +2279,7 @@ asmlinkage long sys_symlinkat(const char
 	dput(dentry);
 out_unlock:
 	mutex_unlock(&nd.lookup.path.dentry->d_inode->i_mutex);
-	path_release(&nd);
+	pathput(&nd.lookup.path);
 out:
 	putname(to);
 out_putname:
@@ -2381,9 +2375,9 @@ asmlinkage long sys_linkat(int olddfd, c
 out_unlock:
 	mutex_unlock(&nd.lookup.path.dentry->d_inode->i_mutex);
 out_release:
-	path_release(&nd);
+	pathput(&nd.lookup.path);
 out:
-	path_release(&old_nd);
+	pathput(&old_nd.lookup.path);
 exit:
 	putname(to);
 
@@ -2611,9 +2605,9 @@ exit4:
 exit3:
 	unlock_rename(new_dir, old_dir);
 exit2:
-	path_release(&newnd);
+	pathput(&newnd.lookup.path);
 exit1:
-	path_release(&oldnd);
+	pathput(&oldnd.lookup.path);
 exit:
 	return error;
 }
@@ -2811,7 +2805,6 @@ EXPORT_SYMBOL(page_symlink);
 EXPORT_SYMBOL(page_symlink_inode_operations);
 EXPORT_SYMBOL(path_lookup);
 EXPORT_SYMBOL(vfs_path_lookup);
-EXPORT_SYMBOL(path_release);
 EXPORT_SYMBOL(permission);
 EXPORT_SYMBOL(vfs_permission);
 EXPORT_SYMBOL(file_permission);
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -648,7 +648,7 @@ asmlinkage long sys_umount(char __user *
 
 	retval = do_umount(nd.lookup.path.mnt, flags);
 dput_and_out:
-	path_release_on_umount(&nd);
+	pathput_on_umount(&nd.lookup.path);
 out:
 	return retval;
 }
@@ -940,7 +940,7 @@ static int do_loopback(struct nameidata 
 
 out:
 	up_write(&namespace_sem);
-	path_release(&old_nd);
+	pathput(&old_nd.lookup.path);
 	return err;
 }
 
@@ -1051,8 +1051,8 @@ out1:
 out:
 	up_write(&namespace_sem);
 	if (!err)
-		path_release(&parent_nd);
-	path_release(&old_nd);
+		pathput(&parent_nd.lookup.path);
+	pathput(&old_nd.lookup.path);
 	return err;
 }
 
@@ -1435,7 +1435,7 @@ long do_mount(char *dev_name, char *dir_
 		retval = do_new_mount(&nd, type_page, flags, mnt_flags,
 				      dev_name, data_page);
 dput_out:
-	path_release(&nd);
+	pathput(&nd.lookup.path);
 	return retval;
 }
 
@@ -1689,7 +1689,7 @@ asmlinkage long sys_pivot_root(const cha
 
 	error = security_sb_pivotroot(&old_nd, &new_nd);
 	if (error) {
-		path_release(&old_nd);
+		pathput(&old_nd.lookup.path);
 		goto out1;
 	}
 
@@ -1748,15 +1748,15 @@ asmlinkage long sys_pivot_root(const cha
 	chroot_fs_refs(&user_nd, &new_nd);
 	security_sb_post_pivotroot(&user_nd, &new_nd);
 	error = 0;
-	path_release(&root_parent);
-	path_release(&parent_nd);
+	pathput(&root_parent.lookup.path);
+	pathput(&parent_nd.lookup.path);
 out2:
 	mutex_unlock(&old_nd.lookup.path.dentry->d_inode->i_mutex);
 	up_write(&namespace_sem);
-	path_release(&user_nd);
-	path_release(&old_nd);
+	pathput(&user_nd.lookup.path);
+	pathput(&old_nd.lookup.path);
 out1:
-	path_release(&new_nd);
+	pathput(&new_nd.lookup.path);
 out0:
 	unlock_kernel();
 	return error;
--- a/fs/nfs/namespace.c
+++ b/fs/nfs/namespace.c
@@ -146,7 +146,7 @@ out:
 	dprintk("<-- nfs_follow_mountpoint() = %d\n", err);
 	return ERR_PTR(err);
 out_err:
-	path_release(nd);
+	pathput(&nd->lookup.path);
 	goto out;
 out_follow:
 	while(d_mountpoint(nd->lookup.path.dentry) && follow_down(&nd->lookup.path.mnt, &nd->lookup.path.dentry))
--- a/fs/nfsctl.c
+++ b/fs/nfsctl.c
@@ -43,7 +43,7 @@ static struct file *do_open(char *name, 
 	if (!error)
 		return dentry_open(nd.lookup.path.dentry, nd.lookup.path.mnt, flags);
 
-	path_release(&nd);
+	pathput(&nd.lookup.path);
 	return ERR_PTR(error);
 }
 
--- a/fs/nfsd/export.c
+++ b/fs/nfsd/export.c
@@ -177,7 +177,7 @@ static int expkey_parse(struct cache_det
 			cache_put(&ek->h, &svc_expkey_cache);
 		else
 			err = -ENOMEM;
-		path_release(&nd);
+		pathput(&nd.lookup.path);
 	}
 	cache_flush();
  out:
@@ -632,7 +632,7 @@ static int svc_export_parse(struct cache
 	kfree(exp.ex_uuid);
  	kfree(exp.ex_path);
 	if (nd.lookup.path.dentry)
-		path_release(&nd);
+		pathput(&nd.lookup.path);
  out_no_path:
 	if (dom)
 		auth_domain_put(dom);
@@ -1099,7 +1099,7 @@ finish:
 		cache_put(&fsid_key->h, &svc_expkey_cache);
 	if (clp)
 		auth_domain_put(clp);
-	path_release(&nd);
+	pathput(&nd.lookup.path);
 out_unlock:
 	exp_writeunlock();
 out:
@@ -1151,7 +1151,7 @@ exp_unexport(struct nfsctl_export *nxp)
 
 	err = -EINVAL;
 	exp = exp_get_by_name(dom, nd.lookup.path.mnt, nd.lookup.path.dentry, NULL);
-	path_release(&nd);
+	pathput(&nd.lookup.path);
 	if (IS_ERR(exp))
 		goto out_domain;
 
@@ -1210,7 +1210,7 @@ exp_rootfh(svc_client *clp, char *path, 
 	fh_put(&fh);
 	exp_put(exp);
 out:
-	path_release(&nd);
+	pathput(&nd.lookup.path);
 	return err;
 }
 
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -417,5 +417,5 @@ nfsd4_shutdown_recdir(void)
 	if (!rec_dir_init)
 		return;
 	rec_dir_init = 0;
-	path_release(&rec_dir);
+	pathput(&rec_dir.lookup.path);
 }
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -3342,7 +3342,7 @@ nfs4_reset_recoverydir(char *recdir)
 		nfs4_set_recdir(recdir);
 		status = 0;
 	}
-	path_release(&nd);
+	pathput(&nd.lookup.path);
 	return status;
 }
 
--- a/fs/open.c
+++ b/fs/open.c
@@ -130,7 +130,7 @@ asmlinkage long sys_statfs(const char __
 		error = vfs_statfs_native(nd.lookup.path.dentry, &tmp);
 		if (!error && copy_to_user(buf, &tmp, sizeof(tmp)))
 			error = -EFAULT;
-		path_release(&nd);
+		pathput(&nd.lookup.path);
 	}
 	return error;
 }
@@ -149,7 +149,7 @@ asmlinkage long sys_statfs64(const char 
 		error = vfs_statfs64(nd.lookup.path.dentry, &tmp);
 		if (!error && copy_to_user(buf, &tmp, sizeof(tmp)))
 			error = -EFAULT;
-		path_release(&nd);
+		pathput(&nd.lookup.path);
 	}
 	return error;
 }
@@ -277,7 +277,7 @@ static long do_sys_truncate(const char _
 put_write_and_out:
 	put_write_access(inode);
 dput_and_out:
-	path_release(&nd);
+	pathput(&nd.lookup.path);
 out:
 	return error;
 }
@@ -456,13 +456,13 @@ asmlinkage long sys_faccessat(int dfd, c
 	/* SuS v2 requires we report a read only fs too */
 	if(res || !(mode & S_IWOTH) ||
 	   special_file(nd.lookup.path.dentry->d_inode->i_mode))
-		goto out_path_release;
+		goto out_pathput;
 
 	if(IS_RDONLY(nd.lookup.path.dentry->d_inode))
 		res = -EROFS;
 
-out_path_release:
-	path_release(&nd);
+out_pathput:
+	pathput(&nd.lookup.path);
 out:
 	current->fsuid = old_fsuid;
 	current->fsgid = old_fsgid;
@@ -493,7 +493,7 @@ asmlinkage long sys_chdir(const char __u
 	set_fs_pwd(current->fs, nd.lookup.path.mnt, nd.lookup.path.dentry);
 
 dput_and_out:
-	path_release(&nd);
+	pathput(&nd.lookup.path);
 out:
 	return error;
 }
@@ -546,7 +546,7 @@ asmlinkage long sys_chroot(const char __
 	set_fs_altroot();
 	error = 0;
 dput_and_out:
-	path_release(&nd);
+	pathput(&nd.lookup.path);
 out:
 	return error;
 }
@@ -618,7 +618,7 @@ asmlinkage long sys_fchmodat(int dfd, co
 	mutex_unlock(&inode->i_mutex);
 
 dput_and_out:
-	path_release(&nd);
+	pathput(&nd.lookup.path);
 out:
 	return error;
 }
@@ -672,7 +672,7 @@ asmlinkage long sys_chown(const char __u
 	if (error)
 		goto out;
 	error = chown_common(nd.lookup.path.dentry, user, group);
-	path_release(&nd);
+	pathput(&nd.lookup.path);
 out:
 	return error;
 }
@@ -692,7 +692,7 @@ asmlinkage long sys_fchownat(int dfd, co
 	if (error)
 		goto out;
 	error = chown_common(nd.lookup.path.dentry, user, group);
-	path_release(&nd);
+	pathput(&nd.lookup.path);
 out:
 	return error;
 }
@@ -706,7 +706,7 @@ asmlinkage long sys_lchown(const char __
 	if (error)
 		goto out;
 	error = chown_common(nd.lookup.path.dentry, user, group);
-	path_release(&nd);
+	pathput(&nd.lookup.path);
 out:
 	return error;
 }
@@ -887,7 +887,7 @@ struct file *nameidata_to_filp(struct na
 	if (filp->f_path.dentry == NULL)
 		filp = __dentry_open(nd->lookup.path.dentry, nd->lookup.path.mnt, flags, filp, NULL);
 	else
-		path_release(nd);
+		pathput(&nd->lookup.path);
 	return filp;
 }
 
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -938,7 +938,7 @@ static void *proc_pid_follow_link(struct
 	int error = -EACCES;
 
 	/* We don't need a base pointer in the /proc filesystem */
-	path_release(nd);
+	pathput(&nd->lookup.path);
 
 	/* Are we allowed to snoop on the tasks file descriptors? */
 	if (!proc_fd_access_allowed(inode))
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -1983,20 +1983,20 @@ static int reiserfs_quota_on(struct supe
 		return err;
 	/* Quotafile not on the same filesystem? */
 	if (nd.lookup.path.mnt->mnt_sb != sb) {
-		path_release(&nd);
+		pathput(&nd.lookup.path);
 		return -EXDEV;
 	}
 	/* We must not pack tails for quota files on reiserfs for quota IO to work */
 	if (!REISERFS_I(nd.lookup.path.dentry->d_inode)->i_flags & i_nopack_mask) {
 		reiserfs_warning(sb,
 				 "reiserfs: Quota file must have tail packing disabled.");
-		path_release(&nd);
+		pathput(&nd.lookup.path);
 		return -EINVAL;
 	}
 	/* Not journalling quota? No more tests needed... */
 	if (!REISERFS_SB(sb)->s_qf_names[USRQUOTA] &&
 	    !REISERFS_SB(sb)->s_qf_names[GRPQUOTA]) {
-		path_release(&nd);
+		pathput(&nd.lookup.path);
 		return vfs_quota_on(sb, type, format_id, path);
 	}
 	/* Quotafile not of fs root? */
@@ -2004,7 +2004,7 @@ static int reiserfs_quota_on(struct supe
 		reiserfs_warning(sb,
 				 "reiserfs: Quota file not on filesystem root. "
 				 "Journalled quota will not work.");
-	path_release(&nd);
+	pathput(&nd.lookup.path);
 	return vfs_quota_on(sb, type, format_id, path);
 }
 
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -63,7 +63,7 @@ int vfs_stat_fd(int dfd, char __user *na
 	error = __user_walk_fd(dfd, name, LOOKUP_FOLLOW, &nd);
 	if (!error) {
 		error = vfs_getattr(nd.lookup.path.mnt, nd.lookup.path.dentry, stat);
-		path_release(&nd);
+		pathput(&nd.lookup.path);
 	}
 	return error;
 }
@@ -83,7 +83,7 @@ int vfs_lstat_fd(int dfd, char __user *n
 	error = __user_walk_fd(dfd, name, 0, &nd);
 	if (!error) {
 		error = vfs_getattr(nd.lookup.path.mnt, nd.lookup.path.dentry, stat);
-		path_release(&nd);
+		pathput(&nd.lookup.path);
 	}
 	return error;
 }
@@ -312,7 +312,7 @@ asmlinkage long sys_readlinkat(int dfd, 
 				error = inode->i_op->readlink(nd.lookup.path.dentry, buf, bufsiz);
 			}
 		}
-		path_release(&nd);
+		pathput(&nd.lookup.path);
 	}
 	return error;
 }
--- a/fs/utimes.c
+++ b/fs/utimes.c
@@ -124,7 +124,7 @@ dput_and_out:
 	if (f)
 		fput(f);
 	else
-		path_release(&nd);
+		pathput(&nd.lookup.path);
 out:
 	return error;
 }
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -236,7 +236,7 @@ sys_setxattr(char __user *path, char __u
 	if (error)
 		return error;
 	error = setxattr(nd.lookup.path.dentry, name, value, size, flags);
-	path_release(&nd);
+	pathput(&nd.lookup.path);
 	return error;
 }
 
@@ -251,7 +251,7 @@ sys_lsetxattr(char __user *path, char __
 	if (error)
 		return error;
 	error = setxattr(nd.lookup.path.dentry, name, value, size, flags);
-	path_release(&nd);
+	pathput(&nd.lookup.path);
 	return error;
 }
 
@@ -321,7 +321,7 @@ sys_getxattr(char __user *path, char __u
 	if (error)
 		return error;
 	error = getxattr(nd.lookup.path.dentry, name, value, size);
-	path_release(&nd);
+	pathput(&nd.lookup.path);
 	return error;
 }
 
@@ -336,7 +336,7 @@ sys_lgetxattr(char __user *path, char __
 	if (error)
 		return error;
 	error = getxattr(nd.lookup.path.dentry, name, value, size);
-	path_release(&nd);
+	pathput(&nd.lookup.path);
 	return error;
 }
 
@@ -395,7 +395,7 @@ sys_listxattr(char __user *path, char __
 	if (error)
 		return error;
 	error = listxattr(nd.lookup.path.dentry, list, size);
-	path_release(&nd);
+	pathput(&nd.lookup.path);
 	return error;
 }
 
@@ -409,7 +409,7 @@ sys_llistxattr(char __user *path, char _
 	if (error)
 		return error;
 	error = listxattr(nd.lookup.path.dentry, list, size);
-	path_release(&nd);
+	pathput(&nd.lookup.path);
 	return error;
 }
 
@@ -456,7 +456,7 @@ sys_removexattr(char __user *path, char 
 	if (error)
 		return error;
 	error = removexattr(nd.lookup.path.dentry, name);
-	path_release(&nd);
+	pathput(&nd.lookup.path);
 	return error;
 }
 
@@ -470,7 +470,7 @@ sys_lremovexattr(char __user *path, char
 	if (error)
 		return error;
 	error = removexattr(nd.lookup.path.dentry, name);
-	path_release(&nd);
+	pathput(&nd.lookup.path);
 	return error;
 }
 
--- a/fs/xfs/linux-2.6/xfs_ioctl.c
+++ b/fs/xfs/linux-2.6/xfs_ioctl.c
@@ -94,7 +94,7 @@ xfs_find_handle(
 		ASSERT(nd.lookup.path.dentry);
 		ASSERT(nd.lookup.path.dentry->d_inode);
 		inode = igrab(nd.lookup.path.dentry->d_inode);
-		path_release(&nd);
+		pathput(&nd.lookup.path);
 		break;
 	}
 
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -2,10 +2,9 @@
 #define _LINUX_NAMEI_H
 
 #include <linux/dcache.h>
+#include <linux/mount.h>
 #include <linux/linkage.h>
 
-struct vfsmount;
-
 struct open_intent {
 	int	flags;
 	int	create_mode;
@@ -74,8 +73,7 @@ extern int FASTCALL(__user_walk_fd(int d
 extern int FASTCALL(path_lookup(const char *, unsigned, struct nameidata *));
 extern int vfs_path_lookup(struct dentry *, struct vfsmount *,
 			   const char *, unsigned int, struct nameidata *);
-extern void path_release(struct nameidata *);
-extern void path_release_on_umount(struct nameidata *);
+extern void pathput_on_umount(struct path *);
 
 extern int __user_path_lookup_open(const char __user *, unsigned lookup_flags, struct nameidata *nd, int open_flags);
 extern int path_lookup_open(int dfd, const char *name, unsigned lookup_flags, struct nameidata *, int open_flags);
@@ -104,4 +102,10 @@ static inline char *nd_get_link(struct n
 	return nd->saved_names[nd->depth];
 }
 
+static inline void pathput(struct path *path)
+{
+	dput(path->dentry);
+	mntput(path->mnt);
+}
+
 #endif /* _LINUX_NAMEI_H */
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -1123,11 +1123,11 @@ static int audit_get_nd(char *path, stru
 static void audit_put_nd(struct nameidata *ndp, struct nameidata *ndw)
 {
 	if (ndp) {
-		path_release(ndp);
+		pathput(&ndp->lookup.path);
 		kfree(ndp);
 	}
 	if (ndw) {
-		path_release(ndw);
+		pathput(&ndw->lookup.path);
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
+	pathput(&nd->lookup.path);
 	rpc_put_mount();
 }
 
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -743,7 +743,7 @@ static struct sock *unix_find_other(stru
 		if (u->sk_type == type)
 			touch_atime(nd.lookup.path.mnt, nd.lookup.path.dentry);
 
-		path_release(&nd);
+		pathput(&nd.lookup.path);
 
 		err=-EPROTOTYPE;
 		if (u->sk_type != type) {
@@ -764,7 +764,7 @@ static struct sock *unix_find_other(stru
 	return u;
 
 put_fail:
-	path_release(&nd);
+	pathput(&nd.lookup.path);
 fail:
 	*error=err;
 	return NULL;
@@ -877,7 +877,7 @@ out_mknod_dput:
 	dput(dentry);
 out_mknod_unlock:
 	mutex_unlock(&nd.lookup.path.dentry->d_inode->i_mutex);
-	path_release(&nd);
+	pathput(&nd.lookup.path);
 out_mknod_parent:
 	if (err==-EEXIST)
 		err=-EADDRINUSE;

