Return-Path: <linux-kernel-owner+w=401wt.eu-S1759550AbZATJ2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759550AbZATJ2c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 04:28:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753726AbZATJ2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 04:28:17 -0500
Received: from mail-ew0-f20.google.com ([209.85.219.20]:38869 "EHLO
	mail-ew0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684AbZATJ2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 04:28:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=CuY/kxuACjlOIKwRJfE5M168mEDgH1SgH94YI1HUBTjvvqPBRlEUSE6FTJCb7u0RS9
         h2AYhqaikXW1m0BGEIktEEqz1EivNl4YPz+AGglKpDpAsUDbljQpqyEtH8+2zrxpMWl8
         9vIS5rbq5UC4Bm80DWz7jir3Fzgfurs99IvEQ=
From: Andrea Righi <righi.andrea@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>, Dave Jones <davej@redhat.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Johannes Weiner <hannes@saeurebad.de>,
       Krzysztof Helt <krzysztof.h1@wp.pl>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrea Righi <righi.andrea@gmail.com>
Subject: [PATCH] fbmem: copy_from/to_user() with mutex held (v3)
Date: Tue, 20 Jan 2009 10:27:56 +0100
Message-Id: <1232443676-7037-1-git-send-email-righi.andrea@gmail.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid to call copy_from/to_user() with fb_info->lock mutex held in fbmem
ioctl().

fb_mmap() is called under mm->mmap_sem (A) held, that also acquires
fb_info->lock (B); fb_ioctl() takes fb_info->lock (B) and does
copy_from/to_user() that might acquire mm->mmap_sem (A), causing a
deadlock.

NOTE: it doesn't push down the fb_info->lock in each own driver's
fb_ioctl(), so there're still potential deadlocks somewhere.

ChangeLog (v2 -> v3):
 * fix: added a missing unlock_fb_info() in FBIOPUT_VSCREENINFO
   (thanks to Krzysztof Helt)

Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
---
 drivers/video/fbcmap.c |   20 +++++--
 drivers/video/fbmem.c  |  135 ++++++++++++++++++++++++-----------------------
 include/linux/fb.h     |   15 +++++
 3 files changed, 98 insertions(+), 72 deletions(-)

diff --git a/drivers/video/fbcmap.c b/drivers/video/fbcmap.c
index 91b78e6..f53b9f1 100644
--- a/drivers/video/fbcmap.c
+++ b/drivers/video/fbcmap.c
@@ -250,10 +250,6 @@ int fb_set_user_cmap(struct fb_cmap_user *cmap, struct fb_info *info)
 	int rc, size = cmap->len * sizeof(u16);
 	struct fb_cmap umap;
 
-	if (cmap->start < 0 || (!info->fbops->fb_setcolreg &&
-			        !info->fbops->fb_setcmap))
-		return -EINVAL;
-
 	memset(&umap, 0, sizeof(struct fb_cmap));
 	rc = fb_alloc_cmap(&umap, cmap->len, cmap->transp != NULL);
 	if (rc)
@@ -262,11 +258,23 @@ int fb_set_user_cmap(struct fb_cmap_user *cmap, struct fb_info *info)
 	    copy_from_user(umap.green, cmap->green, size) ||
 	    copy_from_user(umap.blue, cmap->blue, size) ||
 	    (cmap->transp && copy_from_user(umap.transp, cmap->transp, size))) {
-		fb_dealloc_cmap(&umap);
-		return -EFAULT;
+		rc = -EFAULT;
+		goto out;
 	}
 	umap.start = cmap->start;
+	if (!lock_fb_info(info)) {
+		rc = -ENODEV;
+		goto out;
+	}
+	if (cmap->start < 0 || (!info->fbops->fb_setcolreg &&
+				!info->fbops->fb_setcmap)) {
+		rc = -EINVAL;
+		goto out1;
+	}
 	rc = fb_set_cmap(&umap, info);
+out1:
+	unlock_fb_info(info);
+out:
 	fb_dealloc_cmap(&umap);
 	return rc;
 }
diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index 756efeb..cfd9dce 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -1013,132 +1013,139 @@ static long do_fb_ioctl(struct fb_info *info, unsigned int cmd,
 	struct fb_var_screeninfo var;
 	struct fb_fix_screeninfo fix;
 	struct fb_con2fbmap con2fb;
+	struct fb_cmap cmap_from;
 	struct fb_cmap_user cmap;
 	struct fb_event event;
 	void __user *argp = (void __user *)arg;
 	long ret = 0;
 
-	fb = info->fbops;
-	if (!fb)
-		return -ENODEV;
-
 	switch (cmd) {
 	case FBIOGET_VSCREENINFO:
-		ret = copy_to_user(argp, &info->var,
-				    sizeof(var)) ? -EFAULT : 0;
+		if (!lock_fb_info(info))
+			return -ENODEV;
+		var = info->var;
+		unlock_fb_info(info);
+
+		ret = copy_to_user(argp, &var, sizeof(var)) ? -EFAULT : 0;
 		break;
 	case FBIOPUT_VSCREENINFO:
-		if (copy_from_user(&var, argp, sizeof(var))) {
-			ret =  -EFAULT;
-			break;
-		}
+		if (copy_from_user(&var, argp, sizeof(var)))
+			return -EFAULT;
+		if (!lock_fb_info(info))
+			return -ENODEV;
 		acquire_console_sem();
 		info->flags |= FBINFO_MISC_USEREVENT;
 		ret = fb_set_var(info, &var);
 		info->flags &= ~FBINFO_MISC_USEREVENT;
 		release_console_sem();
-		if (ret == 0 && copy_to_user(argp, &var, sizeof(var)))
+		unlock_fb_info(info);
+		if (!ret && copy_to_user(argp, &var, sizeof(var)))
 			ret = -EFAULT;
 		break;
 	case FBIOGET_FSCREENINFO:
-		ret = copy_to_user(argp, &info->fix,
-				    sizeof(fix)) ? -EFAULT : 0;
+		if (!lock_fb_info(info))
+			return -ENODEV;
+		fix = info->fix;
+		unlock_fb_info(info);
+
+		ret = copy_to_user(argp, &fix, sizeof(fix)) ? -EFAULT : 0;
 		break;
 	case FBIOPUTCMAP:
 		if (copy_from_user(&cmap, argp, sizeof(cmap)))
-			ret = -EFAULT;
-		else
-			ret = fb_set_user_cmap(&cmap, info);
+			return -EFAULT;
+		ret = fb_set_user_cmap(&cmap, info);
 		break;
 	case FBIOGETCMAP:
 		if (copy_from_user(&cmap, argp, sizeof(cmap)))
-			ret = -EFAULT;
-		else
-			ret = fb_cmap_to_user(&info->cmap, &cmap);
+			return -EFAULT;
+		if (!lock_fb_info(info))
+			return -ENODEV;
+		cmap_from = info->cmap;
+		unlock_fb_info(info);
+		ret = fb_cmap_to_user(&cmap_from, &cmap);
 		break;
 	case FBIOPAN_DISPLAY:
-		if (copy_from_user(&var, argp, sizeof(var))) {
-			ret = -EFAULT;
-			break;
-		}
+		if (copy_from_user(&var, argp, sizeof(var)))
+			return -EFAULT;
+		if (!lock_fb_info(info))
+			return -ENODEV;
 		acquire_console_sem();
 		ret = fb_pan_display(info, &var);
 		release_console_sem();
+		unlock_fb_info(info);
 		if (ret == 0 && copy_to_user(argp, &var, sizeof(var)))
-			ret = -EFAULT;
+			return -EFAULT;
 		break;
 	case FBIO_CURSOR:
 		ret = -EINVAL;
 		break;
 	case FBIOGET_CON2FBMAP:
 		if (copy_from_user(&con2fb, argp, sizeof(con2fb)))
-			ret = -EFAULT;
-		else if (con2fb.console < 1 || con2fb.console > MAX_NR_CONSOLES)
-			ret = -EINVAL;
-		else {
-			con2fb.framebuffer = -1;
-			event.info = info;
-			event.data = &con2fb;
-			fb_notifier_call_chain(FB_EVENT_GET_CONSOLE_MAP,
-								&event);
-			ret = copy_to_user(argp, &con2fb,
-				    sizeof(con2fb)) ? -EFAULT : 0;
-		}
+			return -EFAULT;
+		if (con2fb.console < 1 || con2fb.console > MAX_NR_CONSOLES)
+			return -EINVAL;
+		con2fb.framebuffer = -1;
+		event.data = &con2fb;
+
+		if (!lock_fb_info(info))
+			return -ENODEV;
+		event.info = info;
+		fb_notifier_call_chain(FB_EVENT_GET_CONSOLE_MAP, &event);
+		unlock_fb_info(info);
+
+		ret = copy_to_user(argp, &con2fb, sizeof(con2fb)) ? -EFAULT : 0;
 		break;
 	case FBIOPUT_CON2FBMAP:
-		if (copy_from_user(&con2fb, argp, sizeof(con2fb))) {
-			ret = -EFAULT;
-			break;
-		}
-		if (con2fb.console < 1 || con2fb.console > MAX_NR_CONSOLES) {
-			ret = -EINVAL;
-			break;
-		}
-		if (con2fb.framebuffer < 0 || con2fb.framebuffer >= FB_MAX) {
-			ret = -EINVAL;
-			break;
-		}
+		if (copy_from_user(&con2fb, argp, sizeof(con2fb)))
+			return -EFAULT;
+		if (con2fb.console < 1 || con2fb.console > MAX_NR_CONSOLES)
+			return -EINVAL;
+		if (con2fb.framebuffer < 0 || con2fb.framebuffer >= FB_MAX)
+			return -EINVAL;
 		if (!registered_fb[con2fb.framebuffer])
 			request_module("fb%d", con2fb.framebuffer);
 		if (!registered_fb[con2fb.framebuffer]) {
 			ret = -EINVAL;
 			break;
 		}
-		event.info = info;
 		event.data = &con2fb;
+		if (!lock_fb_info(info))
+			return -ENODEV;
+		event.info = info;
 		ret = fb_notifier_call_chain(FB_EVENT_SET_CONSOLE_MAP,
 					      &event);
+		unlock_fb_info(info);
 		break;
 	case FBIOBLANK:
+		if (!lock_fb_info(info))
+			return -ENODEV;
 		acquire_console_sem();
 		info->flags |= FBINFO_MISC_USEREVENT;
 		ret = fb_blank(info, arg);
 		info->flags &= ~FBINFO_MISC_USEREVENT;
 		release_console_sem();
-		break;;
+		unlock_fb_info(info);
+		break;
 	default:
-		if (fb->fb_ioctl == NULL)
-			ret = -ENOTTY;
-		else
+		if (!lock_fb_info(info))
+			return -ENODEV;
+		fb = info->fbops;
+		if (fb->fb_ioctl)
 			ret = fb->fb_ioctl(info, cmd, arg);
+		else
+			ret = -ENOTTY;
+		unlock_fb_info(info);
 	}
 	return ret;
 }
 
 static long fb_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
-__acquires(&info->lock)
-__releases(&info->lock)
 {
 	struct inode *inode = file->f_path.dentry->d_inode;
 	int fbidx = iminor(inode);
-	struct fb_info *info;
-	long ret;
+	struct fb_info *info = registered_fb[fbidx];
 
-	info = registered_fb[fbidx];
-	mutex_lock(&info->lock);
-	ret = do_fb_ioctl(info, cmd, arg);
-	mutex_unlock(&info->lock);
-	return ret;
+	return do_fb_ioctl(info, cmd, arg);
 }
 
 #ifdef CONFIG_COMPAT
@@ -1257,8 +1264,6 @@ static int fb_get_fscreeninfo(struct fb_info *info, unsigned int cmd,
 
 static long fb_compat_ioctl(struct file *file, unsigned int cmd,
 			    unsigned long arg)
-__acquires(&info->lock)
-__releases(&info->lock)
 {
 	struct inode *inode = file->f_path.dentry->d_inode;
 	int fbidx = iminor(inode);
@@ -1266,7 +1271,6 @@ __releases(&info->lock)
 	struct fb_ops *fb = info->fbops;
 	long ret = -ENOIOCTLCMD;
 
-	mutex_lock(&info->lock);
 	switch(cmd) {
 	case FBIOGET_VSCREENINFO:
 	case FBIOPUT_VSCREENINFO:
@@ -1292,7 +1296,6 @@ __releases(&info->lock)
 			ret = fb->fb_compat_ioctl(info, cmd, arg);
 		break;
 	}
-	mutex_unlock(&info->lock);
 	return ret;
 }
 #endif
diff --git a/include/linux/fb.h b/include/linux/fb.h
index 818fe21..31527e1 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -960,6 +960,21 @@ extern struct fb_info *registered_fb[FB_MAX];
 extern int num_registered_fb;
 extern struct class *fb_class;
 
+static inline int lock_fb_info(struct fb_info *info)
+{
+	mutex_lock(&info->lock);
+	if (!info->fbops) {
+		mutex_unlock(&info->lock);
+		return 0;
+	}
+	return 1;
+}
+
+static inline void unlock_fb_info(struct fb_info *info)
+{
+	mutex_unlock(&info->lock);
+}
+
 static inline void __fb_pad_aligned_buffer(u8 *dst, u32 d_pitch,
 					   u8 *src, u32 s_pitch, u32 height)
 {
-- 
1.5.6.3

