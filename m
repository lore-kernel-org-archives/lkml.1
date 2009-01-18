Return-Path: <linux-kernel-owner+w=401wt.eu-S1755593AbZARUZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593AbZARUZA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 15:25:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753353AbZARUYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 15:24:50 -0500
Received: from mail-ew0-f20.google.com ([209.85.219.20]:48637 "EHLO
	mail-ew0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211AbZARUYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 15:24:49 -0500
X-Greylist: delayed 449 seconds by postgrey-1.27 at vger.kernel.org; Sun, 18 Jan 2009 15:24:48 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=mE17fD9zNSI03hRORW/nVrDSw6AHzG3we1rPVI504mVXrK0xv4kegMpB5aMF3qVlwA
         1sDuJ3QH+2GHCKUq/Y/8CTAvgV0XMFzdscOJcBNfeiqs9xR2F8PGA/fgBL9Hulfo6xbg
         TjjLQdS6QN75PXltyDfyWEIHl/iHF1Qo9tJg0=
Message-ID: <49738E4B.1030200@gmail.com>
Date: Sun, 18 Jan 2009 21:17:15 +0100
From: Andrea Righi <righi.andrea@gmail.com>
Reply-To: righi.andrea@gmail.com
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>, Dave Jones <davej@redhat.com>
CC: Johannes Weiner <hannes@saeurebad.de>, Krzysztof Helt <krzysztof.h1@wp.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] fbmem: fix copy_from/to_user() with mutex held
References: <20090117231925.GA28055@redhat.com> <20090118020038.GA17489@cmpxchg.org>
In-Reply-To: <20090118020038.GA17489@cmpxchg.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid to call copy_from/to_user() with fb_info->lock mutex held in fbmem
fb_ioctl().

NOTE: it doesn't push down the fb_info->lock in each driver's fb_ioctl().

Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
---
 drivers/video/fbcmap.c |   21 +++++--
 drivers/video/fbmem.c  |  158 ++++++++++++++++++++++++++++--------------------
 include/linux/fb.h     |    5 +-
 3 files changed, 112 insertions(+), 72 deletions(-)

diff --git a/drivers/video/fbcmap.c b/drivers/video/fbcmap.c
index 91b78e6..b19f12c 100644
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
@@ -262,11 +258,24 @@ int fb_set_user_cmap(struct fb_cmap_user *cmap, struct fb_info *info)
 	    copy_from_user(umap.green, cmap->green, size) ||
 	    copy_from_user(umap.blue, cmap->blue, size) ||
 	    (cmap->transp && copy_from_user(umap.transp, cmap->transp, size))) {
-		fb_dealloc_cmap(&umap);
-		return -EFAULT;
+		rc = -EFAULT;
+		goto out;
 	}
 	umap.start = cmap->start;
+	info = get_fb_info(info);
+	if (!info) {
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
+	put_fb_info(info);
+out:
 	fb_dealloc_cmap(&umap);
 	return rc;
 }
diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index 756efeb..e51e9ba 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -1006,6 +1006,23 @@ fb_blank(struct fb_info *info, int blank)
  	return ret;
 }
 
+struct fb_info *get_fb_info(struct fb_info *info)
+__acquires(&info->lock)
+{
+	mutex_lock(&info->lock);
+	if (!info->fbops) {
+		mutex_unlock(&info->lock);
+		return NULL;
+	}
+	return info;
+}
+
+void put_fb_info(struct fb_info *info)
+__releases(&info->lock)
+{
+	mutex_unlock(&info->lock);
+}
+
 static long do_fb_ioctl(struct fb_info *info, unsigned int cmd,
 			unsigned long arg)
 {
@@ -1013,25 +1030,28 @@ static long do_fb_ioctl(struct fb_info *info, unsigned int cmd,
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
+		info = get_fb_info(info);
+		if (!info)
+			return -ENODEV;
+		memcpy(&var, &info->var, sizeof(var));
+		put_fb_info(info);
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
+		info = get_fb_info(info);
+		if (!info)
+			return -ENODEV;
 		acquire_console_sem();
 		info->flags |= FBINFO_MISC_USEREVENT;
 		ret = fb_set_var(info, &var);
@@ -1041,104 +1061,116 @@ static long do_fb_ioctl(struct fb_info *info, unsigned int cmd,
 			ret = -EFAULT;
 		break;
 	case FBIOGET_FSCREENINFO:
-		ret = copy_to_user(argp, &info->fix,
-				    sizeof(fix)) ? -EFAULT : 0;
+		info = get_fb_info(info);
+		if (!info)
+			return -ENODEV;
+		memcpy(&fix, &info->fix, sizeof(fix));
+		put_fb_info(info);
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
+		info = get_fb_info(info);
+		if (!info)
+			return -ENODEV;
+		memcpy(&cmap_from, &info->cmap, sizeof(cmap_from));
+		put_fb_info(info);
+		ret = fb_cmap_to_user(&cmap_from, &cmap);
 		break;
 	case FBIOPAN_DISPLAY:
-		if (copy_from_user(&var, argp, sizeof(var))) {
-			ret = -EFAULT;
-			break;
-		}
+		if (copy_from_user(&var, argp, sizeof(var)))
+			return -EFAULT;
+		info = get_fb_info(info);
+		if (!info)
+			return -ENODEV;
 		acquire_console_sem();
 		ret = fb_pan_display(info, &var);
 		release_console_sem();
+		put_fb_info(info);
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
+		info = get_fb_info(info);
+		if (!info)
+			return -ENODEV;
+		event.info = info;
+		fb_notifier_call_chain(FB_EVENT_GET_CONSOLE_MAP, &event);
+		put_fb_info(info);
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
+		info = get_fb_info(info);
+		if (!info)
+			return -ENODEV;
+		event.info = info;
 		ret = fb_notifier_call_chain(FB_EVENT_SET_CONSOLE_MAP,
 					      &event);
+		put_fb_info(info);
 		break;
 	case FBIOBLANK:
+		info = get_fb_info(info);
+		if (!info)
+			return -ENODEV;
 		acquire_console_sem();
 		info->flags |= FBINFO_MISC_USEREVENT;
 		ret = fb_blank(info, arg);
 		info->flags &= ~FBINFO_MISC_USEREVENT;
 		release_console_sem();
-		break;;
+		put_fb_info(info);
+		break;
 	default:
-		if (fb->fb_ioctl == NULL)
-			ret = -ENOTTY;
-		else
+		info = get_fb_info(info);
+		if (!info)
+			return -ENODEV;
+		fb = info->fbops;
+		if (fb->fb_ioctl)
 			ret = fb->fb_ioctl(info, cmd, arg);
+		else
+			ret = -ENOTTY;
+		put_fb_info(info);
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
@@ -1257,8 +1289,6 @@ static int fb_get_fscreeninfo(struct fb_info *info, unsigned int cmd,
 
 static long fb_compat_ioctl(struct file *file, unsigned int cmd,
 			    unsigned long arg)
-__acquires(&info->lock)
-__releases(&info->lock)
 {
 	struct inode *inode = file->f_path.dentry->d_inode;
 	int fbidx = iminor(inode);
@@ -1266,7 +1296,6 @@ __releases(&info->lock)
 	struct fb_ops *fb = info->fbops;
 	long ret = -ENOIOCTLCMD;
 
-	mutex_lock(&info->lock);
 	switch(cmd) {
 	case FBIOGET_VSCREENINFO:
 	case FBIOPUT_VSCREENINFO:
@@ -1292,7 +1321,6 @@ __releases(&info->lock)
 			ret = fb->fb_compat_ioctl(info, cmd, arg);
 		break;
 	}
-	mutex_unlock(&info->lock);
 	return ret;
 }
 #endif
diff --git a/include/linux/fb.h b/include/linux/fb.h
index 818fe21..4f02a63 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -960,6 +960,9 @@ extern struct fb_info *registered_fb[FB_MAX];
 extern int num_registered_fb;
 extern struct class *fb_class;
 
+struct fb_info *get_fb_info(struct fb_info *info);
+void put_fb_info(struct fb_info *info);
+
 static inline void __fb_pad_aligned_buffer(u8 *dst, u32 d_pitch,
 					   u8 *src, u32 s_pitch, u32 height)
 {
@@ -1068,7 +1071,7 @@ extern void fb_dealloc_cmap(struct fb_cmap *cmap);
 extern int fb_copy_cmap(const struct fb_cmap *from, struct fb_cmap *to);
 extern int fb_cmap_to_user(const struct fb_cmap *from, struct fb_cmap_user *to);
 extern int fb_set_cmap(struct fb_cmap *cmap, struct fb_info *fb_info);
-extern int fb_set_user_cmap(struct fb_cmap_user *cmap, struct fb_info *fb_info);
+extern int fb_set_user_cmap(struct fb_cmap_user *cmap, struct fb_info *info);
 extern const struct fb_cmap *fb_default_cmap(int len);
 extern void fb_invert_cmaps(void);
 
