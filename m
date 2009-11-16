Return-Path: <linux-kernel-owner+w=401wt.eu-S1753212AbZKPA3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212AbZKPA3Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 19:29:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752997AbZKPA3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 19:29:14 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:52798 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920AbZKPA3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 19:29:11 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Ian Kent <raven@themaw.net>,
       autofs@linux.kernel.org
Subject: [PATCH 03/12] autofs/autofs4: move compat_ioctl handling into fs
Date: Mon, 16 Nov 2009 00:26:58 +0000
Message-Id: <1258331227-1694-4-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1258331227-1694-1-git-send-email-arnd@arndb.de>
References: <1258331227-1694-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+2cE6ce2/M5pCObQzi85Rqt2tGRKIc8r7Bx83
 1Ki3quR/Twtn3xWRpU3GD/iJr5VGlecOy7ypb5XDtrxJn5qt9v
 iwplCye8fI3sRGeiGmPiQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handling of autofs ioctl numbers does not need to be generic
and can easily be done directly in autofs itself.

This also pushes the BKL into autofs and autofs4 ioctl
methods.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Ian Kent <raven@themaw.net>
Cc: autofs@linux.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 fs/autofs/root.c        |   67 +++++++++++++++++++++++++++++++++++++++++++--
 fs/autofs4/root.c       |   69 ++++++++++++++++++++++++++++++++++++++++++++--
 fs/compat_ioctl.c       |   36 ------------------------
 include/linux/auto_fs.h |    1 +
 4 files changed, 131 insertions(+), 42 deletions(-)

diff --git a/fs/autofs/root.c b/fs/autofs/root.c
index 4a1401c..ad8d240 100644
--- a/fs/autofs/root.c
+++ b/fs/autofs/root.c
@@ -15,6 +15,7 @@
 #include <linux/stat.h>
 #include <linux/param.h>
 #include <linux/time.h>
+#include <linux/compat.h>
 #include <linux/smp_lock.h>
 #include "autofs_i.h"
 
@@ -24,12 +25,16 @@ static int autofs_root_symlink(struct inode *,struct dentry *,const char *);
 static int autofs_root_unlink(struct inode *,struct dentry *);
 static int autofs_root_rmdir(struct inode *,struct dentry *);
 static int autofs_root_mkdir(struct inode *,struct dentry *,int);
-static int autofs_root_ioctl(struct inode *, struct file *,unsigned int,unsigned long);
+static long autofs_root_ioctl(struct file *,unsigned int,unsigned long);
+static long autofs_root_compat_ioctl(struct file *,unsigned int,unsigned long);
 
 const struct file_operations autofs_root_operations = {
 	.read		= generic_read_dir,
 	.readdir	= autofs_root_readdir,
-	.ioctl		= autofs_root_ioctl,
+	.unlocked_ioctl	= autofs_root_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= autofs_root_compat_ioctl,
+#endif
 };
 
 const struct inode_operations autofs_root_inode_operations = {
@@ -490,6 +495,25 @@ static int autofs_root_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 }
 
 /* Get/set timeout ioctl() operation */
+#ifdef CONFIG_COMPAT
+static inline int autofs_compat_get_set_timeout(struct autofs_sb_info *sbi,
+					 unsigned int __user *p)
+{
+	unsigned long ntimeout;
+
+	if (get_user(ntimeout, p) ||
+	    put_user(sbi->exp_timeout / HZ, p))
+		return -EFAULT;
+
+	if (ntimeout > UINT_MAX/HZ)
+		sbi->exp_timeout = 0;
+	else
+		sbi->exp_timeout = ntimeout * HZ;
+
+	return 0;
+}
+#endif
+
 static inline int autofs_get_set_timeout(struct autofs_sb_info *sbi,
 					 unsigned long __user *p)
 {
@@ -544,7 +568,7 @@ static inline int autofs_expire_run(struct super_block *sb,
  * ioctl()'s on the root directory is the chief method for the daemon to
  * generate kernel reactions
  */
-static int autofs_root_ioctl(struct inode *inode, struct file *filp,
+static int autofs_do_root_ioctl(struct inode *inode, struct file *filp,
 			     unsigned int cmd, unsigned long arg)
 {
 	struct autofs_sb_info *sbi = autofs_sbi(inode->i_sb);
@@ -569,6 +593,10 @@ static int autofs_root_ioctl(struct inode *inode, struct file *filp,
 		return 0;
 	case AUTOFS_IOC_PROTOVER: /* Get protocol version */
 		return autofs_get_protover(argp);
+#ifdef CONFIG_COMPAT
+	case AUTOFS_IOC_SETTIMEOUT32:
+		return autofs_compat_get_set_timeout(sbi, argp);
+#endif
 	case AUTOFS_IOC_SETTIMEOUT:
 		return autofs_get_set_timeout(sbi, argp);
 	case AUTOFS_IOC_EXPIRE:
@@ -577,4 +605,37 @@ static int autofs_root_ioctl(struct inode *inode, struct file *filp,
 	default:
 		return -ENOSYS;
 	}
+
+}
+
+static long autofs_root_ioctl(struct file *filp,
+			     unsigned int cmd, unsigned long arg)
+{
+	int ret;
+
+	lock_kernel();
+	ret = autofs_do_root_ioctl(filp->f_path.dentry->d_inode,
+				   filp, cmd, arg);
+	unlock_kernel();
+
+	return ret;
+}
+
+#ifdef CONFIG_COMPAT
+static long autofs_root_compat_ioctl(struct file *filp,
+			     unsigned int cmd, unsigned long arg)
+{
+	struct inode *inode = filp->f_path.dentry->d_inode;
+	int ret;
+
+	lock_kernel();
+	if (cmd == AUTOFS_IOC_READY || cmd == AUTOFS_IOC_FAIL)
+		ret = autofs_do_root_ioctl(inode, filp, cmd, arg);
+	else
+		ret = autofs_do_root_ioctl(inode, filp, cmd,
+			(unsigned long)compat_ptr(arg));
+	unlock_kernel();
+
+	return ret;
 }
+#endif
diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index b96a3c5..ff00dfc 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -17,13 +17,17 @@
 #include <linux/stat.h>
 #include <linux/param.h>
 #include <linux/time.h>
+#include <linux/compat.h>
+#include <linux/smp_lock.h>
+
 #include "autofs_i.h"
 
 static int autofs4_dir_symlink(struct inode *,struct dentry *,const char *);
 static int autofs4_dir_unlink(struct inode *,struct dentry *);
 static int autofs4_dir_rmdir(struct inode *,struct dentry *);
 static int autofs4_dir_mkdir(struct inode *,struct dentry *,int);
-static int autofs4_root_ioctl(struct inode *, struct file *,unsigned int,unsigned long);
+static long autofs4_root_ioctl(struct file *,unsigned int,unsigned long);
+static long autofs4_root_compat_ioctl(struct file *,unsigned int,unsigned long);
 static int autofs4_dir_open(struct inode *inode, struct file *file);
 static struct dentry *autofs4_lookup(struct inode *,struct dentry *, struct nameidata *);
 static void *autofs4_follow_link(struct dentry *, struct nameidata *);
@@ -37,7 +41,10 @@ const struct file_operations autofs4_root_operations = {
 	.read		= generic_read_dir,
 	.readdir	= dcache_readdir,
 	.llseek		= dcache_dir_lseek,
-	.ioctl		= autofs4_root_ioctl,
+	.unlocked_ioctl	= autofs4_root_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= autofs4_root_compat_ioctl,
+#endif
 };
 
 const struct file_operations autofs4_dir_operations = {
@@ -807,6 +814,26 @@ static int autofs4_dir_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 }
 
 /* Get/set timeout ioctl() operation */
+#ifdef CONFIG_COMPAT
+static inline int autofs4_compat_get_set_timeout(struct autofs_sb_info *sbi,
+					 compat_ulong_t __user *p)
+{
+	int rv;
+	unsigned long ntimeout;
+
+	if ((rv = get_user(ntimeout, p)) ||
+	     (rv = put_user(sbi->exp_timeout/HZ, p)))
+		return rv;
+
+	if (ntimeout > UINT_MAX/HZ)
+		sbi->exp_timeout = 0;
+	else
+		sbi->exp_timeout = ntimeout * HZ;
+
+	return 0;
+}
+#endif
+
 static inline int autofs4_get_set_timeout(struct autofs_sb_info *sbi,
 					 unsigned long __user *p)
 {
@@ -870,7 +897,7 @@ int is_autofs4_dentry(struct dentry *dentry)
  * ioctl()'s on the root directory is the chief method for the daemon to
  * generate kernel reactions
  */
-static int autofs4_root_ioctl(struct inode *inode, struct file *filp,
+static int autofs4_do_root_ioctl(struct inode *inode, struct file *filp,
 			     unsigned int cmd, unsigned long arg)
 {
 	struct autofs_sb_info *sbi = autofs4_sbi(inode->i_sb);
@@ -900,6 +927,10 @@ static int autofs4_root_ioctl(struct inode *inode, struct file *filp,
 		return autofs4_get_protosubver(sbi, p);
 	case AUTOFS_IOC_SETTIMEOUT:
 		return autofs4_get_set_timeout(sbi, p);
+#ifdef CONFIG_COMPAT
+	case AUTOFS_IOC_SETTIMEOUT32:
+		return autofs4_compat_get_set_timeout(sbi, p);
+#endif
 
 	case AUTOFS_IOC_ASKUMOUNT:
 		return autofs4_ask_umount(filp->f_path.mnt, p);
@@ -915,3 +946,35 @@ static int autofs4_root_ioctl(struct inode *inode, struct file *filp,
 		return -ENOSYS;
 	}
 }
+
+static long autofs4_root_ioctl(struct file *filp,
+			       unsigned int cmd, unsigned long arg)
+{
+	int ret;
+
+	lock_kernel();
+	ret = autofs4_do_root_ioctl(filp->f_path.dentry->d_inode,
+				    filp, cmd, arg);
+	unlock_kernel();
+
+	return ret;
+}
+
+#ifdef CONFIG_COMPAT
+static long autofs4_root_compat_ioctl(struct file *filp,
+			     unsigned int cmd, unsigned long arg)
+{
+	struct inode *inode = filp->f_path.dentry->d_inode;
+	int ret;
+
+	lock_kernel();
+	if (cmd == AUTOFS_IOC_READY || cmd == AUTOFS_IOC_FAIL)
+		ret = autofs4_do_root_ioctl(inode, filp, cmd, arg);
+	else
+		ret = autofs4_do_root_ioctl(inode, filp, cmd,
+			(unsigned long)compat_ptr(arg));
+	unlock_kernel();
+
+	return ret;
+}
+#endif
diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 219a117..ed3f23c 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -132,23 +132,6 @@ static int w_long(unsigned int fd, unsigned int cmd,
 	return err;
 }
 
-static int rw_long(unsigned int fd, unsigned int cmd,
-		compat_ulong_t __user *argp)
-{
-	mm_segment_t old_fs = get_fs();
-	int err;
-	unsigned long val;
-
-	if(get_user(val, argp))
-		return -EFAULT;
-	set_fs (KERNEL_DS);
-	err = sys_ioctl(fd, cmd, (unsigned long)&val);
-	set_fs (old_fs);
-	if (!err && put_user(val, argp))
-		return -EFAULT;
-	return err;
-}
-
 struct compat_video_event {
 	int32_t		type;
 	compat_time_t	timestamp;
@@ -556,12 +539,6 @@ static int do_smb_getmountuid(unsigned int fd, unsigned int cmd,
 	return err;
 }
 
-static int ioc_settimeout(unsigned int fd, unsigned int cmd,
-		compat_ulong_t __user *argp)
-{
-	return rw_long(fd, AUTOFS_IOC_SETTIMEOUT, argp);
-}
-
 /* Bluetooth ioctls */
 #define HCIUARTSETPROTO	_IOW('U', 200, int)
 #define HCIUARTGETPROTO	_IOR('U', 201, int)
@@ -1348,13 +1325,6 @@ COMPATIBLE_IOCTL(SOUND_MIXER_PRIVATE5)
 COMPATIBLE_IOCTL(SOUND_MIXER_GETLEVELS)
 COMPATIBLE_IOCTL(SOUND_MIXER_SETLEVELS)
 COMPATIBLE_IOCTL(OSS_GETVERSION)
-/* AUTOFS */
-COMPATIBLE_IOCTL(AUTOFS_IOC_CATATONIC)
-COMPATIBLE_IOCTL(AUTOFS_IOC_PROTOVER)
-COMPATIBLE_IOCTL(AUTOFS_IOC_EXPIRE)
-COMPATIBLE_IOCTL(AUTOFS_IOC_EXPIRE_MULTI)
-COMPATIBLE_IOCTL(AUTOFS_IOC_PROTOSUBVER)
-COMPATIBLE_IOCTL(AUTOFS_IOC_ASKUMOUNT)
 /* Raw devices */
 COMPATIBLE_IOCTL(RAW_SETBIND)
 COMPATIBLE_IOCTL(RAW_GETBIND)
@@ -1647,9 +1617,6 @@ static long do_ioctl_trans(int fd, unsigned int cmd,
 	case RAW_GETBIND:
 		return raw_ioctl(fd, cmd, argp);
 #endif
-#define AUTOFS_IOC_SETTIMEOUT32 _IOWR(0x93,0x64,unsigned int)
-	case AUTOFS_IOC_SETTIMEOUT32:
-		return ioc_settimeout(fd, cmd, argp);
 	/* One SMB ioctl needs translations. */
 #define SMB_IOC_GETMOUNTUID_32 _IOR('u', 1, compat_uid_t)
 	case SMB_IOC_GETMOUNTUID_32:
@@ -1715,9 +1682,6 @@ static long do_ioctl_trans(int fd, unsigned int cmd,
 	case KDSKBMETA:
 	case KDSKBLED:
 	case KDSETLED:
-	/* AUTOFS */
-	case AUTOFS_IOC_READY:
-	case AUTOFS_IOC_FAIL:
 	/* NBD */
 	case NBD_SET_SOCK:
 	case NBD_SET_BLKSIZE:
diff --git a/include/linux/auto_fs.h b/include/linux/auto_fs.h
index 7b09c83..da64e15 100644
--- a/include/linux/auto_fs.h
+++ b/include/linux/auto_fs.h
@@ -79,6 +79,7 @@ struct autofs_packet_expire {
 #define AUTOFS_IOC_FAIL       _IO(0x93,0x61)
 #define AUTOFS_IOC_CATATONIC  _IO(0x93,0x62)
 #define AUTOFS_IOC_PROTOVER   _IOR(0x93,0x63,int)
+#define AUTOFS_IOC_SETTIMEOUT32 _IOWR(0x93,0x64,compat_ulong_t)
 #define AUTOFS_IOC_SETTIMEOUT _IOWR(0x93,0x64,unsigned long)
 #define AUTOFS_IOC_EXPIRE     _IOR(0x93,0x65,struct autofs_packet_expire)
 
-- 
1.6.3.3

