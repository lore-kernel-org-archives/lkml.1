Return-Path: <linux-kernel-owner+w=401wt.eu-S1753499AbYJ1Wdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499AbYJ1Wdj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 18:33:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752655AbYJ1Wda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 18:33:30 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:10954 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbYJ1Wd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 18:33:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=P7Ln+JuPg+nky0VEvkbxd1sQ3kKmomYkcgyb9cC5pf8gftMId5ZvTh5Xt+rEgaV/oP
         QuriTdSGuNCz/TLDWNJUr7Lore+b+jH0TRhW9cIqVXrtMeg/DMRXfkxOjwmgMqA1sW/S
         MNx35j1+BB7qSP+v2Zdt+UuQ0/rRNMfcMq9t0=
Message-ID: <49079333.6030403@gmail.com>
Date: Tue, 28 Oct 2008 23:33:23 +0100
From: Andrea Righi <righi.andrea@gmail.com>
Reply-To: righi.andrea@gmail.com
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Johannes Weiner <hannes@saeurebad.de>
CC: Krzysztof Helt <krzysztof.h1@wp.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: lockdep splat from fbmem
References: <87ljwgj8p1.fsf@saeurebad.de>
In-Reply-To: <87ljwgj8p1.fsf@saeurebad.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner wrote:
> Hi,
> 
> fb_mmap() is called under mmap_sem and acquires fb_info->lock.
> 
> Since 3e680aae4e53ab "fb: convert lock/unlock_kernel() into local fb
> mutex", fb_ioctl() takes fb_info->lock and does copy_to/from_user()
> under it, which in turn might acquire mmap_sem.
> 
> Just noticed the trace and wanted to let you know.
> 
>         Hannes

Johannes,

could you check the following fix for fbmem? maybe some parts are still
deadlockable, but I'm not able to raise any lockdep trace with it using
the latest Linus' git.

Thanks,
-Andrea

---
fb: avoid to call copy_from/to_user() with fb_info mutex held in fbmem ioctl()

Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
---
 drivers/video/fbcmap.c |   24 ++++++--
 drivers/video/fbmem.c  |  150 ++++++++++++++++++++++++++++++------------------
 include/linux/fb.h     |    5 +-
 3 files changed, 114 insertions(+), 65 deletions(-)

diff --git a/drivers/video/fbcmap.c b/drivers/video/fbcmap.c
index 91b78e6..8f46589 100644
--- a/drivers/video/fbcmap.c
+++ b/drivers/video/fbcmap.c
@@ -245,14 +245,11 @@ int fb_set_cmap(struct fb_cmap *cmap, struct fb_info *info)
 	return rc;
 }
 
-int fb_set_user_cmap(struct fb_cmap_user *cmap, struct fb_info *info)
+int fb_set_user_cmap(struct fb_cmap_user *cmap, int fbidx)
 {
 	int rc, size = cmap->len * sizeof(u16);
 	struct fb_cmap umap;
-
-	if (cmap->start < 0 || (!info->fbops->fb_setcolreg &&
-			        !info->fbops->fb_setcmap))
-		return -EINVAL;
+	struct fb_info *info;
 
 	memset(&umap, 0, sizeof(struct fb_cmap));
 	rc = fb_alloc_cmap(&umap, cmap->len, cmap->transp != NULL);
@@ -262,11 +259,24 @@ int fb_set_user_cmap(struct fb_cmap_user *cmap, struct fb_info *info)
 	    copy_from_user(umap.green, cmap->green, size) ||
 	    copy_from_user(umap.blue, cmap->blue, size) ||
 	    (cmap->transp && copy_from_user(umap.transp, cmap->transp, size))) {
-		fb_dealloc_cmap(&umap);
-		return -EFAULT;
+		rc = -EFAULT;
+		goto out;
 	}
 	umap.start = cmap->start;
+	info = get_fb_info(fbidx);
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
index cd5f20d..b4de3f3 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -1002,6 +1002,24 @@ fb_blank(struct fb_info *info, int blank)
  	return ret;
 }
 
+struct fb_info *get_fb_info(int fbidx)
+{
+	struct fb_info *info;
+
+	info = registered_fb[fbidx];
+	mutex_lock(&info->lock);
+	if (!info->fbops) {
+		mutex_unlock(&info->lock);
+		return NULL;
+	}
+	return info;
+}
+
+void put_fb_info(struct fb_info *info)
+{
+	mutex_unlock(&info->lock);
+}
+
 static long
 fb_ioctl(struct file *file, unsigned int cmd,
 	 unsigned long arg)
@@ -1013,120 +1031,138 @@ fb_ioctl(struct file *file, unsigned int cmd,
 	struct fb_var_screeninfo var;
 	struct fb_fix_screeninfo fix;
 	struct fb_con2fbmap con2fb;
+	struct fb_cmap cmap_from;
 	struct fb_cmap_user cmap;
 	struct fb_event event;
 	void __user *argp = (void __user *)arg;
 	long ret = 0;
 
-	info = registered_fb[fbidx];
-	mutex_lock(&info->lock);
-	fb = info->fbops;
-
-	if (!fb) {
-		mutex_unlock(&info->lock);
-		return -ENODEV;
-	}
 	switch (cmd) {
 	case FBIOGET_VSCREENINFO:
-		ret = copy_to_user(argp, &info->var,
-				    sizeof(var)) ? -EFAULT : 0;
+		info = get_fb_info(fbidx);
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
+		info = get_fb_info(fbidx);
+		if (!info)
+			return -ENODEV;
 		acquire_console_sem();
 		info->flags |= FBINFO_MISC_USEREVENT;
 		ret = fb_set_var(info, &var);
 		info->flags &= ~FBINFO_MISC_USEREVENT;
 		release_console_sem();
+		put_fb_info(info);
 		if (ret == 0 && copy_to_user(argp, &var, sizeof(var)))
-			ret = -EFAULT;
+			return -EFAULT;
 		break;
 	case FBIOGET_FSCREENINFO:
-		ret = copy_to_user(argp, &info->fix,
-				    sizeof(fix)) ? -EFAULT : 0;
+		info = get_fb_info(fbidx);
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
+		ret = fb_set_user_cmap(&cmap, fbidx);
 		break;
 	case FBIOGETCMAP:
 		if (copy_from_user(&cmap, argp, sizeof(cmap)))
-			ret = -EFAULT;
-		else
-			ret = fb_cmap_to_user(&info->cmap, &cmap);
+			return -EFAULT;
+		info = get_fb_info(fbidx);
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
+		info = get_fb_info(fbidx);
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
+		info = get_fb_info(fbidx);
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
+		info = get_fb_info(fbidx);
+		if (!info)
+			return -ENODEV;
+		event.info = info;
 		ret = fb_notifier_call_chain(FB_EVENT_SET_CONSOLE_MAP,
 					      &event);
+		put_fb_info(info);
 		break;
 	case FBIOBLANK:
+		info = get_fb_info(fbidx);
+		if (!info)
+			return -ENODEV;
 		acquire_console_sem();
 		info->flags |= FBINFO_MISC_USEREVENT;
 		ret = fb_blank(info, arg);
 		info->flags &= ~FBINFO_MISC_USEREVENT;
 		release_console_sem();
+		put_fb_info(info);
 		break;;
 	default:
-		if (fb->fb_ioctl == NULL)
-			ret = -ENOTTY;
-		else
+		info = get_fb_info(fbidx);
+		if (!info)
+			return -ENODEV;
+		fb = info->fbops;
+		if (fb->fb_ioctl)
 			ret = fb->fb_ioctl(info, cmd, arg);
+		else
+			ret = -ENOTTY;
+		put_fb_info(info);
 	}
-	mutex_unlock(&info->lock);
 	return ret;
 }
 
diff --git a/include/linux/fb.h b/include/linux/fb.h
index 75a81ea..9f4e70f 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -960,6 +960,9 @@ extern struct fb_info *registered_fb[FB_MAX];
 extern int num_registered_fb;
 extern struct class *fb_class;
 
+struct fb_info *get_fb_info(int fbidx);
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
+extern int fb_set_user_cmap(struct fb_cmap_user *cmap, int fbidx);
 extern const struct fb_cmap *fb_default_cmap(int len);
 extern void fb_invert_cmaps(void);
 
