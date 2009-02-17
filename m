Return-Path: <linux-kernel-owner+w=401wt.eu-S1751449AbZBQIMG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751449AbZBQIMG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 03:12:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752591AbZBQIKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 03:10:51 -0500
Received: from sh.osrg.net ([192.16.179.4]:55117 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752452AbZBQIKn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 03:10:43 -0500
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH mmotm 3/6] nilfs2: remove compat ioctl code
Date: Tue, 17 Feb 2009 16:42:03 +0900
Message-Id: <1234856526-1947-4-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1234856526-1947-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1234856526-1947-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Dispatcher: imput version 20050308(IM148)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 17 Feb 2009 17:10:36 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes compat code from the nilfs ioctls and applies the same
function for both .ioctl and .compat_ioctl file operations.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/dir.c           |    2 +-
 fs/nilfs2/file.c          |    2 +-
 fs/nilfs2/ioctl.c         |  228 ---------------------------------------------
 fs/nilfs2/nilfs.h         |    1 -
 include/linux/nilfs2_fs.h |   41 --------
 5 files changed, 2 insertions(+), 272 deletions(-)

diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
index 1b7e6dd..393316c 100644
--- a/fs/nilfs2/dir.c
+++ b/fs/nilfs2/dir.c
@@ -704,7 +704,7 @@ struct file_operations nilfs_dir_operations = {
 	.readdir	= nilfs_readdir,
 	.ioctl		= nilfs_ioctl,
 #ifdef CONFIG_COMPAT
-	.compat_ioctl	= nilfs_compat_ioctl,
+	.compat_ioctl	= nilfs_ioctl,
 #endif	/* CONFIG_COMPAT */
 	.fsync		= nilfs_sync_file,
 
diff --git a/fs/nilfs2/file.c b/fs/nilfs2/file.c
index 34c751b..1670038 100644
--- a/fs/nilfs2/file.c
+++ b/fs/nilfs2/file.c
@@ -140,7 +140,7 @@ struct file_operations nilfs_file_operations = {
 	.aio_write	= generic_file_aio_write,
 	.ioctl		= nilfs_ioctl,
 #ifdef CONFIG_COMPAT
-	.compat_ioctl	= nilfs_compat_ioctl,
+	.compat_ioctl	= nilfs_ioctl,
 #endif	/* CONFIG_COMPAT */
 	.mmap		= nilfs_file_mmap,
 	.open		= generic_file_open,
diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index 7fbd9fe..33aff88 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -631,231 +631,3 @@ int nilfs_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
 		return -ENOTTY;
 	}
 }
-
-/* compat_ioctl */
-#ifdef CONFIG_COMPAT
-#include <linux/compat.h>
-
-static int nilfs_compat_locked_ioctl(struct inode *inode, struct file *filp,
-				     unsigned int cmd, unsigned long arg)
-{
-	int ret;
-
-	lock_kernel();
-	ret = nilfs_ioctl(inode, filp, cmd, arg);
-	unlock_kernel();
-	return ret;
-}
-
-static int
-nilfs_compat_ioctl_uargv32_to_uargv(struct nilfs_argv32 __user *uargv32,
-				    struct nilfs_argv __user *uargv)
-{
-	compat_uptr_t base;
-	compat_size_t nmembs, size;
-	compat_int_t index, flags;
-
-	if (get_user(base, &uargv32->v_base) ||
-	    put_user(compat_ptr(base), &uargv->v_base) ||
-	    get_user(nmembs, &uargv32->v_nmembs) ||
-	    put_user(nmembs, &uargv->v_nmembs) ||
-	    get_user(size, &uargv32->v_size) ||
-	    put_user(size, &uargv->v_size) ||
-	    get_user(index, &uargv32->v_index) ||
-	    put_user(index, &uargv->v_index) ||
-	    get_user(flags, &uargv32->v_flags) ||
-	    put_user(flags, &uargv->v_flags))
-		return -EFAULT;
-	return 0;
-}
-
-static int
-nilfs_compat_ioctl_uargv_to_uargv32(struct nilfs_argv __user *uargv,
-				    struct nilfs_argv32 __user *uargv32)
-{
-	size_t nmembs;
-
-	if (get_user(nmembs, &uargv->v_nmembs) ||
-	    put_user(nmembs, &uargv32->v_nmembs))
-		return -EFAULT;
-	return 0;
-}
-
-static int
-nilfs_compat_ioctl_get_by_argv(struct inode *inode, struct file *filp,
-			       unsigned int cmd, unsigned long arg)
-{
-	struct nilfs_argv __user *uargv;
-	struct nilfs_argv32 __user *uargv32;
-	int ret;
-
-	uargv = compat_alloc_user_space(sizeof(struct nilfs_argv));
-	uargv32 = compat_ptr(arg);
-	ret = nilfs_compat_ioctl_uargv32_to_uargv(uargv32, uargv);
-	if (ret < 0)
-		return ret;
-
-	ret = nilfs_compat_locked_ioctl(inode, filp, cmd, (unsigned long)uargv);
-	if (ret < 0)
-		return ret;
-
-	return nilfs_compat_ioctl_uargv_to_uargv32(uargv, uargv32);
-}
-
-static int
-nilfs_compat_ioctl_change_cpmode(struct inode *inode, struct file *filp,
-				 unsigned int cmd, unsigned long arg)
-{
-	struct nilfs_cpmode __user *ucpmode;
-	struct nilfs_cpmode32 __user *ucpmode32;
-	int mode;
-
-	ucpmode = compat_alloc_user_space(sizeof(struct nilfs_cpmode));
-	ucpmode32 = compat_ptr(arg);
-	if (copy_in_user(&ucpmode->cm_cno, &ucpmode32->cm_cno,
-			 sizeof(__u64)) ||
-	    get_user(mode, &ucpmode32->cm_mode) ||
-	    put_user(mode, &ucpmode->cm_mode))
-		return -EFAULT;
-
-	return nilfs_compat_locked_ioctl(
-		inode, filp, cmd, (unsigned long)ucpmode);
-}
-
-
-static inline int
-nilfs_compat_ioctl_delete_checkpoint(struct inode *inode, struct file *filp,
-				     unsigned int cmd, unsigned long arg)
-{
-	return nilfs_compat_locked_ioctl(inode, filp, cmd, arg);
-}
-
-static inline int
-nilfs_compat_ioctl_get_cpinfo(struct inode *inode, struct file *filp,
-			      unsigned int cmd, unsigned long arg)
-{
-	return nilfs_compat_ioctl_get_by_argv(inode, filp, cmd, arg);
-}
-
-static inline int
-nilfs_compat_ioctl_get_cpstat(struct inode *inode, struct file *filp,
-			      unsigned int cmd, unsigned long arg)
-{
-	return nilfs_compat_locked_ioctl(inode, filp, cmd, arg);
-}
-
-static inline int
-nilfs_compat_ioctl_get_suinfo(struct inode *inode, struct file *filp,
-			      unsigned int cmd, unsigned long arg)
-{
-	return nilfs_compat_ioctl_get_by_argv(inode, filp, cmd, arg);
-}
-
-static int
-nilfs_compat_ioctl_get_sustat(struct inode *inode, struct file *filp,
-			      unsigned int cmd, unsigned long arg)
-{
-	struct nilfs_sustat __user *usustat;
-	struct nilfs_sustat32 __user *usustat32;
-	time_t ctime, nongc_ctime;
-	int ret;
-
-	usustat = compat_alloc_user_space(sizeof(struct nilfs_sustat));
-	ret = nilfs_compat_locked_ioctl(inode, filp, cmd,
-					(unsigned long)usustat);
-	if (ret < 0)
-		return ret;
-
-	usustat32 = compat_ptr(arg);
-	if (copy_in_user(&usustat32->ss_nsegs, &usustat->ss_nsegs,
-			 sizeof(__u64)) ||
-	    copy_in_user(&usustat32->ss_ncleansegs, &usustat->ss_ncleansegs,
-			 sizeof(__u64)) ||
-	    copy_in_user(&usustat32->ss_ndirtysegs, &usustat->ss_ndirtysegs,
-			 sizeof(__u64)) ||
-	    get_user(ctime, &usustat->ss_ctime) ||
-	    put_user(ctime, &usustat32->ss_ctime) ||
-	    get_user(nongc_ctime, &usustat->ss_nongc_ctime) ||
-	    put_user(nongc_ctime, &usustat32->ss_nongc_ctime))
-		return -EFAULT;
-	return 0;
-}
-
-static inline int
-nilfs_compat_ioctl_get_vinfo(struct inode *inode, struct file *filp,
-			      unsigned int cmd, unsigned long arg)
-{
-	return nilfs_compat_ioctl_get_by_argv(inode, filp, cmd, arg);
-}
-
-static inline int
-nilfs_compat_ioctl_get_bdescs(struct inode *inode, struct file *filp,
-			     unsigned int cmd, unsigned long arg)
-{
-	return nilfs_compat_ioctl_get_by_argv(inode, filp, cmd, arg);
-}
-
-static int
-nilfs_compat_ioctl_clean_segments(struct inode *inode, struct file *filp,
-				  unsigned int cmd, unsigned long arg)
-{
-	struct nilfs_argv __user *uargv;
-	struct nilfs_argv32 __user *uargv32;
-	int i, ret;
-
-	uargv = compat_alloc_user_space(sizeof(struct nilfs_argv) * 5);
-	uargv32 = compat_ptr(arg);
-	for (i = 0; i < 5; i++) {
-		ret = nilfs_compat_ioctl_uargv32_to_uargv(&uargv32[i],
-							  &uargv[i]);
-		if (ret < 0)
-			return ret;
-	}
-	return nilfs_compat_locked_ioctl(
-		inode, filp, cmd, (unsigned long)uargv);
-}
-
-static int nilfs_compat_ioctl_sync(struct inode *inode, struct file *filp,
-				   unsigned int cmd, unsigned long arg)
-{
-	return nilfs_compat_locked_ioctl(inode, filp, cmd, arg);
-}
-
-long nilfs_compat_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
-{
-	struct inode *inode = filp->f_dentry->d_inode;
-
-	switch (cmd) {
-	case NILFS_IOCTL32_CHANGE_CPMODE:
-		return nilfs_compat_ioctl_change_cpmode(
-			inode, filp, NILFS_IOCTL_CHANGE_CPMODE, arg);
-	case NILFS_IOCTL_DELETE_CHECKPOINT:
-		return nilfs_compat_ioctl_delete_checkpoint(
-			inode, filp, cmd, arg);
-	case NILFS_IOCTL32_GET_CPINFO:
-		return nilfs_compat_ioctl_get_cpinfo(
-			inode, filp, NILFS_IOCTL_GET_CPINFO, arg);
-	case NILFS_IOCTL_GET_CPSTAT:
-		return nilfs_compat_ioctl_get_cpstat(inode, filp, cmd, arg);
-	case NILFS_IOCTL32_GET_SUINFO:
-		return nilfs_compat_ioctl_get_suinfo(
-			inode, filp, NILFS_IOCTL_GET_SUINFO, arg);
-	case NILFS_IOCTL32_GET_SUSTAT:
-		return nilfs_compat_ioctl_get_sustat(
-			inode, filp, NILFS_IOCTL_GET_SUSTAT, arg);
-	case NILFS_IOCTL32_GET_VINFO:
-		return nilfs_compat_ioctl_get_vinfo(
-			inode, filp, NILFS_IOCTL_GET_VINFO, arg);
-	case NILFS_IOCTL32_GET_BDESCS:
-		return nilfs_compat_ioctl_get_bdescs(
-			inode, filp, NILFS_IOCTL_GET_BDESCS, arg);
-	case NILFS_IOCTL32_CLEAN_SEGMENTS:
-		return nilfs_compat_ioctl_clean_segments(
-			inode, filp, NILFS_IOCTL_CLEAN_SEGMENTS, arg);
-	case NILFS_IOCTL_SYNC:
-		return nilfs_compat_ioctl_sync(inode, filp, cmd, arg);
-	default:
-		return -ENOIOCTLCMD;
-	}
-}
-#endif
diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index 30c5341..ad17fa9 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -243,7 +243,6 @@ extern int nilfs_sync_file(struct file *, struct dentry *, int);
 
 /* ioctl.c */
 int nilfs_ioctl(struct inode *, struct file *, unsigned int, unsigned long);
-long nilfs_compat_ioctl(struct file *, unsigned int, unsigned long);
 int nilfs_ioctl_prepare_clean_segments(struct the_nilfs *, void __user *);
 
 /* inode.c */
diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
index 8fb64ce..306c446 100644
--- a/include/linux/nilfs2_fs.h
+++ b/include/linux/nilfs2_fs.h
@@ -793,45 +793,4 @@ struct nilfs_bdesc {
 #define NILFS_IOCTL_RESIZE  \
 	_IOW(NILFS_IOCTL_IDENT, 0x8B, __u64)
 
-/* compat_ioctl */
-#ifdef CONFIG_COMPAT
-#include <linux/compat.h>
-
-struct nilfs_cpmode32 {
-	__u64 cm_cno;
-	compat_int_t cm_mode;
-};
-
-struct nilfs_argv32 {
-	compat_caddr_t v_base;
-	compat_size_t v_nmembs;
-	compat_size_t v_size;
-	compat_int_t v_index;
-	compat_int_t v_flags;
-};
-
-struct nilfs_sustat32 {
-	__u64 ss_nsegs;
-	__u64 ss_ncleansegs;
-	__u64 ss_ndirtysegs;
-	compat_time_t ss_ctime;
-	compat_time_t ss_nongc_ctime;
-};
-
-#define NILFS_IOCTL32_CHANGE_CPMODE  \
-	_IOW(NILFS_IOCTL_IDENT, 0x80, struct nilfs_cpmode32)
-#define NILFS_IOCTL32_GET_CPINFO  \
-	_IOR(NILFS_IOCTL_IDENT, 0x82, struct nilfs_argv32)
-#define NILFS_IOCTL32_GET_SUINFO  \
-	_IOR(NILFS_IOCTL_IDENT, 0x84, struct nilfs_argv32)
-#define NILFS_IOCTL32_GET_SUSTAT  \
-	_IOR(NILFS_IOCTL_IDENT, 0x85, struct nilfs_sustat32)
-#define NILFS_IOCTL32_GET_VINFO  \
-	_IOWR(NILFS_IOCTL_IDENT, 0x86, struct nilfs_argv32)
-#define NILFS_IOCTL32_GET_BDESCS  \
-	_IOWR(NILFS_IOCTL_IDENT, 0x87, struct nilfs_argv32)
-#define NILFS_IOCTL32_CLEAN_SEGMENTS  \
-	_IOW(NILFS_IOCTL_IDENT, 0x88, struct nilfs_argv32[5])
-#endif	/* CONFIG_COMPAT */
-
 #endif	/* _LINUX_NILFS_FS_H */
-- 
1.5.6.5

