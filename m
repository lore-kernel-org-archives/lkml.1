Return-Path: <linux-kernel-owner+w=401wt.eu-S1752335AbYJaOzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335AbYJaOzb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 10:55:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbYJaOzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 10:55:21 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:61376 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751196AbYJaOzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 10:55:19 -0400
Date: Fri, 31 Oct 2008 15:55:12 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Krzysztof Helt <krzysztof.h1@wp.pl>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Frame Buffer Device Development 
	<linux-fbdev-devel@lists.sourceforge.net>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] fbdev: Fix fb_compat_ioctl() deadlocks (was: Re:
 [Linux-fbdev-devel] framebuffer compat_ioctl deadlock)
In-Reply-To: <Pine.LNX.4.64.0810281059350.17438@hs20-bc2-1.build.redhat.com>
Message-ID: <Pine.LNX.4.64.0810311351200.15181@vixen.sonytel.be>
References: <Pine.LNX.4.64.0810281059350.17438@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-1128215830-1225460572=:15181"
Content-ID: <Pine.LNX.4.64.0810311553280.15181@vixen.sonytel.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-1128215830-1225460572=:15181
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <Pine.LNX.4.64.0810311553281.15181@vixen.sonytel.be>

On Tue, 28 Oct 2008, Mikulas Patocka wrote:
> lock_kernel was converted to mutexes in framebuffer driver, but it 
> deadlocks because fb_compat_ioctl takes the lock and calls fb_ioctl that 
> takes that lock too.

Indeed: while lock_kernel() handled recursive locking, mutex_lock() doesn't.

BTW, there are still a few other callpaths from fb_compat_ioctl() that cause
deadlocks. I tried to fix them (verified on PS3 (ppc64 with ppc32 userland)).

Subject: [PATCH] fbdev: Fix fb_compat_ioctl() deadlocks

commit 3e680aae4e53ab54cdbb0c29257dae0cbb158e1c ("fb: convert
lock/unlock_kernel() into local fb mutex") introduced several deadlocks in the
fb_compat_ioctl() path, as mutex_lock() doesn't allow recursion, unlike
lock_kernel(). This broke frame buffer applications on 64-bit systems with a
32-bit userland.

commit 120a37470c2831fea49fdebaceb5a7039f700ce6 ("framebuffer compat_ioctl
deadlock") fixed one of the deadlocks.

This patch fixes the remaining deadlocks:
  - Revert commit 120a37470c2831fea49fdebaceb5a7039f700ce6,
  - Extract the core logic of fb_ioctl() into a new function do_fb_ioctl(),
  - Change all callsites of fb_ioctl() where info->lock is already held to
    call do_fb_ioctl() instead,
  - Add sparse annotations to all routines that take info->lock.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 drivers/video/fbmem.c |   63 ++++++++++++++++++++++++++++++--------------------
 1 file changed, 39 insertions(+), 24 deletions(-)

--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -1002,13 +1002,9 @@ fb_blank(struct fb_info *info, int blank
  	return ret;
 }
 
-static long
-fb_ioctl(struct file *file, unsigned int cmd,
-	 unsigned long arg)
+static long do_fb_ioctl(struct fb_info *info, unsigned int cmd,
+			unsigned long arg)
 {
-	struct inode *inode = file->f_path.dentry->d_inode;
-	int fbidx = iminor(inode);
-	struct fb_info *info;
 	struct fb_ops *fb;
 	struct fb_var_screeninfo var;
 	struct fb_fix_screeninfo fix;
@@ -1018,14 +1014,10 @@ fb_ioctl(struct file *file, unsigned int
 	void __user *argp = (void __user *)arg;
 	long ret = 0;
 
-	info = registered_fb[fbidx];
-	mutex_lock(&info->lock);
 	fb = info->fbops;
-
-	if (!fb) {
-		mutex_unlock(&info->lock);
+	if (!fb)
 		return -ENODEV;
-	}
+
 	switch (cmd) {
 	case FBIOGET_VSCREENINFO:
 		ret = copy_to_user(argp, &info->var,
@@ -1126,6 +1118,21 @@ fb_ioctl(struct file *file, unsigned int
 		else
 			ret = fb->fb_ioctl(info, cmd, arg);
 	}
+	return ret;
+}
+
+static long fb_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+__acquires(&info->lock)
+__releases(&info->lock)
+{
+	struct inode *inode = file->f_path.dentry->d_inode;
+	int fbidx = iminor(inode);
+	struct fb_info *info;
+	long ret;
+
+	info = registered_fb[fbidx];
+	mutex_lock(&info->lock);
+	ret = do_fb_ioctl(info, cmd, arg);
 	mutex_unlock(&info->lock);
 	return ret;
 }
@@ -1157,8 +1164,8 @@ struct fb_cmap32 {
 	compat_caddr_t	transp;
 };
 
-static int fb_getput_cmap(struct inode *inode, struct file *file,
-			unsigned int cmd, unsigned long arg)
+static int fb_getput_cmap(struct fb_info *info, unsigned int cmd,
+			  unsigned long arg)
 {
 	struct fb_cmap_user __user *cmap;
 	struct fb_cmap32 __user *cmap32;
@@ -1181,7 +1188,7 @@ static int fb_getput_cmap(struct inode *
 	    put_user(compat_ptr(data), &cmap->transp))
 		return -EFAULT;
 
-	err = fb_ioctl(file, cmd, (unsigned long) cmap);
+	err = do_fb_ioctl(info, cmd, (unsigned long) cmap);
 
 	if (!err) {
 		if (copy_in_user(&cmap32->start,
@@ -1223,8 +1230,8 @@ static int do_fscreeninfo_to_user(struct
 	return err;
 }
 
-static int fb_get_fscreeninfo(struct inode *inode, struct file *file,
-				unsigned int cmd, unsigned long arg)
+static int fb_get_fscreeninfo(struct fb_info *info, unsigned int cmd,
+			      unsigned long arg)
 {
 	mm_segment_t old_fs;
 	struct fb_fix_screeninfo fix;
@@ -1235,7 +1242,7 @@ static int fb_get_fscreeninfo(struct ino
 
 	old_fs = get_fs();
 	set_fs(KERNEL_DS);
-	err = fb_ioctl(file, cmd, (unsigned long) &fix);
+	err = do_fb_ioctl(info, cmd, (unsigned long) &fix);
 	set_fs(old_fs);
 
 	if (!err)
@@ -1244,8 +1251,10 @@ static int fb_get_fscreeninfo(struct ino
 	return err;
 }
 
-static long
-fb_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+static long fb_compat_ioctl(struct file *file, unsigned int cmd,
+			    unsigned long arg)
+__acquires(&info->lock)
+__releases(&info->lock)
 {
 	struct inode *inode = file->f_path.dentry->d_inode;
 	int fbidx = iminor(inode);
@@ -1262,16 +1271,16 @@ fb_compat_ioctl(struct file *file, unsig
 	case FBIOPUT_CON2FBMAP:
 		arg = (unsigned long) compat_ptr(arg);
 	case FBIOBLANK:
-		mutex_unlock(&info->lock);
-		return fb_ioctl(file, cmd, arg);
+		ret = do_fb_ioctl(info, cmd, arg);
+		break;
 
 	case FBIOGET_FSCREENINFO:
-		ret = fb_get_fscreeninfo(inode, file, cmd, arg);
+		ret = fb_get_fscreeninfo(info, cmd, arg);
 		break;
 
 	case FBIOGETCMAP:
 	case FBIOPUTCMAP:
-		ret = fb_getput_cmap(inode, file, cmd, arg);
+		ret = fb_getput_cmap(info, cmd, arg);
 		break;
 
 	default:
@@ -1286,6 +1295,8 @@ fb_compat_ioctl(struct file *file, unsig
 
 static int
 fb_mmap(struct file *file, struct vm_area_struct * vma)
+__acquires(&info->lock)
+__releases(&info->lock)
 {
 	int fbidx = iminor(file->f_path.dentry->d_inode);
 	struct fb_info *info = registered_fb[fbidx];
@@ -1339,6 +1350,8 @@ fb_mmap(struct file *file, struct vm_are
 
 static int
 fb_open(struct inode *inode, struct file *file)
+__acquires(&info->lock)
+__releases(&info->lock)
 {
 	int fbidx = iminor(inode);
 	struct fb_info *info;
@@ -1374,6 +1387,8 @@ out:
 
 static int 
 fb_release(struct inode *inode, struct file *file)
+__acquires(&info->lock)
+__releases(&info->lock)
 {
 	struct fb_info * const info = file->private_data;
 

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
---584349381-1128215830-1225460572=:15181--
