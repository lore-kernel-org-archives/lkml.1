Return-Path: <linux-kernel-owner+w=401wt.eu-S1161532AbXD2XHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161532AbXD2XHh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 19:07:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161535AbXD2XHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 19:07:36 -0400
Received: from mail.parknet.jp ([210.171.160.80]:1973 "EHLO parknet.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161532AbXD2XHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 19:07:35 -0400
X-AuthUser: hirofumi@parknet.jp
To: Bart Oldeman <bartoldeman@users.sourceforge.net>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] [FAT] fix VFAT compat ioctls on 64-bit systems
References: <Pine.LNX.4.64.0704291730040.32422@localhost.localdomain>
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Mon, 30 Apr 2007 08:07:26 +0900
In-Reply-To: <Pine.LNX.4.64.0704291730040.32422@localhost.localdomain> (Bart Oldeman's message of "Sun\, 29 Apr 2007 17\:31\:40 -0400 \(EDT\)")
Message-ID: <87bqh63hld.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.98 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bart Oldeman <bartoldeman@users.sourceforge.net> writes:

> I found your reply on linux-kernel via an archive but am not subscribed.

Sorry. I CCed actually, but sf.net rejected my email configuration.

> Anyway, I like your approach but there was one small bug.

Thanks for fixing my stupid bug.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>


[PATCH] fat: fix VFAT compat ioctls on 64-bit systems

If you compile and run the below test case in an msdos or vfat directory 
on an x86-64 system with -m32 you'll get garbage in the kernel_dirent 
struct followed by a SIGSEGV.

The patch fixes this.

Reported and initial fix by Bart Oldeman

Signed-off-by: Bart Oldeman <bartoldeman@users.sourceforge.net>
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/fat/dir.c |  199 +++++++++++++++++++++++++++++------------------------------
 1 file changed, 100 insertions(+), 99 deletions(-)

diff -puN fs/fat/dir.c~fat-compait_ioctl-fix fs/fat/dir.c
--- linux-2.6/fs/fat/dir.c~fat-compait_ioctl-fix	2007-04-30 07:56:47.000000000 +0900
+++ linux-2.6-hirofumi/fs/fat/dir.c	2007-04-30 07:56:47.000000000 +0900
@@ -422,7 +422,7 @@ EODir:
 EXPORT_SYMBOL_GPL(fat_search_long);
 
 struct fat_ioctl_filldir_callback {
-	struct dirent __user *dirent;
+	void __user *dirent;
 	int result;
 	/* for dir ioctl */
 	const char *longname;
@@ -647,62 +647,85 @@ static int fat_readdir(struct file *filp
 	return __fat_readdir(inode, filp, dirent, filldir, 0, 0);
 }
 
-static int fat_ioctl_filldir(void *__buf, const char *name, int name_len,
-			     loff_t offset, u64 ino, unsigned int d_type)
+#define FAT_IOCTL_FILLDIR_FUNC(func, dirent_type)			   \
+static int func(void *__buf, const char *name, int name_len,		   \
+			     loff_t offset, u64 ino, unsigned int d_type)  \
+{									   \
+	struct fat_ioctl_filldir_callback *buf = __buf;			   \
+	struct dirent_type __user *d1 = buf->dirent;			   \
+	struct dirent_type __user *d2 = d1 + 1;				   \
+									   \
+	if (buf->result)						   \
+		return -EINVAL;						   \
+	buf->result++;							   \
+									   \
+	if (name != NULL) {						   \
+		/* dirent has only short name */			   \
+		if (name_len >= sizeof(d1->d_name))			   \
+			name_len = sizeof(d1->d_name) - 1;		   \
+									   \
+		if (put_user(0, d2->d_name)			||	   \
+		    put_user(0, &d2->d_reclen)			||	   \
+		    copy_to_user(d1->d_name, name, name_len)	||	   \
+		    put_user(0, d1->d_name + name_len)		||	   \
+		    put_user(name_len, &d1->d_reclen))			   \
+			goto efault;					   \
+	} else {							   \
+		/* dirent has short and long name */			   \
+		const char *longname = buf->longname;			   \
+		int long_len = buf->long_len;				   \
+		const char *shortname = buf->shortname;			   \
+		int short_len = buf->short_len;				   \
+									   \
+		if (long_len >= sizeof(d1->d_name))			   \
+			long_len = sizeof(d1->d_name) - 1;		   \
+		if (short_len >= sizeof(d1->d_name))			   \
+			short_len = sizeof(d1->d_name) - 1;		   \
+									   \
+		if (copy_to_user(d2->d_name, longname, long_len)	|| \
+		    put_user(0, d2->d_name + long_len)			|| \
+		    put_user(long_len, &d2->d_reclen)			|| \
+		    put_user(ino, &d2->d_ino)				|| \
+		    put_user(offset, &d2->d_off)			|| \
+		    copy_to_user(d1->d_name, shortname, short_len)	|| \
+		    put_user(0, d1->d_name + short_len)			|| \
+		    put_user(short_len, &d1->d_reclen))			   \
+			goto efault;					   \
+	}								   \
+	return 0;							   \
+efault:									   \
+	buf->result = -EFAULT;						   \
+	return -EFAULT;							   \
+}
+
+FAT_IOCTL_FILLDIR_FUNC(fat_ioctl_filldir, dirent)
+
+static int fat_ioctl_readdir(struct inode *inode, struct file *filp,
+			     void __user *dirent, filldir_t filldir,
+			     int short_only, int both)
 {
-	struct fat_ioctl_filldir_callback *buf = __buf;
-	struct dirent __user *d1 = buf->dirent;
-	struct dirent __user *d2 = d1 + 1;
-
-	if (buf->result)
-		return -EINVAL;
-	buf->result++;
-
-	if (name != NULL) {
-		/* dirent has only short name */
-		if (name_len >= sizeof(d1->d_name))
-			name_len = sizeof(d1->d_name) - 1;
-
-		if (put_user(0, d2->d_name)			||
-		    put_user(0, &d2->d_reclen)			||
-		    copy_to_user(d1->d_name, name, name_len)	||
-		    put_user(0, d1->d_name + name_len)		||
-		    put_user(name_len, &d1->d_reclen))
-			goto efault;
-	} else {
-		/* dirent has short and long name */
-		const char *longname = buf->longname;
-		int long_len = buf->long_len;
-		const char *shortname = buf->shortname;
-		int short_len = buf->short_len;
-
-		if (long_len >= sizeof(d1->d_name))
-			long_len = sizeof(d1->d_name) - 1;
-		if (short_len >= sizeof(d1->d_name))
-			short_len = sizeof(d1->d_name) - 1;
-
-		if (copy_to_user(d2->d_name, longname, long_len)	||
-		    put_user(0, d2->d_name + long_len)			||
-		    put_user(long_len, &d2->d_reclen)			||
-		    put_user(ino, &d2->d_ino)				||
-		    put_user(offset, &d2->d_off)			||
-		    copy_to_user(d1->d_name, shortname, short_len)	||
-		    put_user(0, d1->d_name + short_len)			||
-		    put_user(short_len, &d1->d_reclen))
-			goto efault;
+	struct fat_ioctl_filldir_callback buf;
+	int ret;
+
+	buf.dirent = dirent;
+	buf.result = 0;
+	mutex_lock(&inode->i_mutex);
+	ret = -ENOENT;
+	if (!IS_DEADDIR(inode)) {
+		ret = __fat_readdir(inode, filp, &buf, filldir,
+				    short_only, both);
 	}
-	return 0;
-efault:
-	buf->result = -EFAULT;
-	return -EFAULT;
+	mutex_unlock(&inode->i_mutex);
+	if (ret >= 0)
+		ret = buf.result;
+	return ret;
 }
 
-static int fat_dir_ioctl(struct inode * inode, struct file * filp,
-		  unsigned int cmd, unsigned long arg)
+static int fat_dir_ioctl(struct inode *inode, struct file *filp,
+			 unsigned int cmd, unsigned long arg)
 {
-	struct fat_ioctl_filldir_callback buf;
-	struct dirent __user *d1;
-	int ret, short_only, both;
+	struct dirent __user *d1 = (struct dirent __user *)arg;
+	int short_only, both;
 
 	switch (cmd) {
 	case VFAT_IOCTL_READDIR_SHORT:
@@ -717,7 +740,6 @@ static int fat_dir_ioctl(struct inode * 
 		return fat_generic_ioctl(inode, filp, cmd, arg);
 	}
 
-	d1 = (struct dirent __user *)arg;
 	if (!access_ok(VERIFY_WRITE, d1, sizeof(struct dirent[2])))
 		return -EFAULT;
 	/*
@@ -728,69 +750,48 @@ static int fat_dir_ioctl(struct inode * 
 	if (put_user(0, &d1->d_reclen))
 		return -EFAULT;
 
-	buf.dirent = d1;
-	buf.result = 0;
-	mutex_lock(&inode->i_mutex);
-	ret = -ENOENT;
-	if (!IS_DEADDIR(inode)) {
-		ret = __fat_readdir(inode, filp, &buf, fat_ioctl_filldir,
-				    short_only, both);
-	}
-	mutex_unlock(&inode->i_mutex);
-	if (ret >= 0)
-		ret = buf.result;
-	return ret;
+	return fat_ioctl_readdir(inode, filp, d1, fat_ioctl_filldir,
+				 short_only, both);
 }
 
 #ifdef CONFIG_COMPAT
 #define	VFAT_IOCTL_READDIR_BOTH32	_IOR('r', 1, struct compat_dirent[2])
 #define	VFAT_IOCTL_READDIR_SHORT32	_IOR('r', 2, struct compat_dirent[2])
 
-static long fat_compat_put_dirent32(struct dirent *d,
-				    struct compat_dirent __user *d32)
-{
-        if (!access_ok(VERIFY_WRITE, d32, sizeof(struct compat_dirent)))
-                return -EFAULT;
+FAT_IOCTL_FILLDIR_FUNC(fat_compat_ioctl_filldir, compat_dirent)
 
-        __put_user(d->d_ino, &d32->d_ino);
-        __put_user(d->d_off, &d32->d_off);
-        __put_user(d->d_reclen, &d32->d_reclen);
-        if (__copy_to_user(d32->d_name, d->d_name, d->d_reclen))
-		return -EFAULT;
-
-        return 0;
-}
-
-static long fat_compat_dir_ioctl(struct file *file, unsigned cmd,
+static long fat_compat_dir_ioctl(struct file *filp, unsigned cmd,
 				 unsigned long arg)
 {
-	struct compat_dirent __user *p = compat_ptr(arg);
-	int ret;
-	mm_segment_t oldfs = get_fs();
-	struct dirent d[2];
+	struct inode *inode = filp->f_path.dentry->d_inode;
+	struct compat_dirent __user *d1 = compat_ptr(arg);
+	int short_only, both;
 
 	switch (cmd) {
-	case VFAT_IOCTL_READDIR_BOTH32:
-		cmd = VFAT_IOCTL_READDIR_BOTH;
-		break;
 	case VFAT_IOCTL_READDIR_SHORT32:
-		cmd = VFAT_IOCTL_READDIR_SHORT;
+		short_only = 1;
+		both = 0;
+		break;
+	case VFAT_IOCTL_READDIR_BOTH32:
+		short_only = 0;
+		both = 1;
 		break;
 	default:
 		return -ENOIOCTLCMD;
 	}
 
-	set_fs(KERNEL_DS);
-	lock_kernel();
-	ret = fat_dir_ioctl(file->f_path.dentry->d_inode, file,
-			    cmd, (unsigned long) &d);
-	unlock_kernel();
-	set_fs(oldfs);
-	if (ret >= 0) {
-		ret |= fat_compat_put_dirent32(&d[0], p);
-		ret |= fat_compat_put_dirent32(&d[1], p + 1);
-	}
-	return ret;
+	if (!access_ok(VERIFY_WRITE, d1, sizeof(struct compat_dirent[2])))
+		return -EFAULT;
+	/*
+	 * Yes, we don't need this put_user() absolutely. However old
+	 * code didn't return the right value. So, app use this value,
+	 * in order to check whether it is EOF.
+	 */
+	if (put_user(0, &d1->d_reclen))
+		return -EFAULT;
+
+	return fat_ioctl_readdir(inode, filp, d1, fat_compat_ioctl_filldir,
+				 short_only, both);
 }
 #endif /* CONFIG_COMPAT */
 
_
