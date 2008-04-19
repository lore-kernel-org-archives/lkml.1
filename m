Return-Path: <linux-kernel-owner+w=401wt.eu-S1753408AbYDSAzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408AbYDSAzJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 20:55:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750869AbYDSAy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 20:54:56 -0400
Received: from wx-out-0506.google.com ([66.249.82.232]:4150 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbYDSAyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 20:54:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=RjiZvk2zC+hURXzK07ihwSKceTxT5gBHhR9DTCBcM6ku7EtusrtPWHqPQp3Gh6z8UArDWRI3nNajZ0hl1YzNyH+7K1lX00lcjVPHjncO01ux6gruyowCZV/eDGnRXlJe9zFy6ye++SvyFESN5PQELebdZnK0Tt9zJEwvggpFc9A=
From: Thiago Galesi <thiagogalesi@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Linux-fbdev-devel] [PATCH] fb: Remove use of lock_kernel / unlock_kernel in fbmem
Date: Fri, 18 Apr 2008 21:54:43 -0300
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       dilinger@queued.net
References: <200804131150.07601.thiagogalesi@gmail.com> <20080415221707.82da3d42.akpm@linux-foundation.org>
In-Reply-To: <20080415221707.82da3d42.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804182154.43834.thiagogalesi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello


>Just a minor nit; in general, I'd think you would want to completely
>initialize the structure (including calling mutex_init) before
>registering the structure with the rest of the system (in this case,
>with registered_fb and *_call_notifier_chain).  Initializing after
>registration is just asking for a race conditions.

This is better?? 


---
This patch removes lock_kernel(), unlock_kernel() usage in fbmem.c and replaces it with a mutex

Signed-off-by: Thiago Galesi <thiagogalesi@gmail.com>

---


Index: linux-2.6.23.1/drivers/video/fbmem.c
===================================================================
--- linux-2.6.23.1.orig/drivers/video/fbmem.c	2008-04-16 18:52:32.000000000 -0300
+++ linux-2.6.23.1/drivers/video/fbmem.c	2008-04-18 19:25:53.000000000 -0300
@@ -987,7 +987,7 @@
 }
 
 static int 
-fb_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
+__fb_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 	 unsigned long arg)
 {
 	int fbidx = iminor(inode);
@@ -1085,6 +1085,28 @@
 	}
 }
 
+static int
+fb_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
+	 unsigned long arg)
+{
+	int fbidx = iminor(inode);
+	struct fb_info *info = registered_fb[fbidx];
+	int ret;
+
+	mutex_lock(&info->hwlock);
+	ret = __fb_ioctl(inode, file, cmd, arg);
+	mutex_unlock(&info->hwlock);
+	return ret;
+}
+
+static long
+fb_unlocked_ioctl(struct file *file, unsigned int cmd,
+	 unsigned long arg)
+{
+	struct inode *inode = file->f_path.dentry->d_inode;
+	return fb_ioctl(inode, file, cmd, arg);
+}
+
 #ifdef CONFIG_COMPAT
 struct fb_fix_screeninfo32 {
 	char			id[16];
@@ -1136,7 +1158,7 @@
 	    put_user(compat_ptr(data), &cmap->transp))
 		return -EFAULT;
 
-	err = fb_ioctl(inode, file, cmd, (unsigned long) cmap);
+	err = __fb_ioctl(inode, file, cmd, (unsigned long) cmap);
 
 	if (!err) {
 		if (copy_in_user(&cmap32->start,
@@ -1190,7 +1212,7 @@
 
 	old_fs = get_fs();
 	set_fs(KERNEL_DS);
-	err = fb_ioctl(inode, file, cmd, (unsigned long) &fix);
+	err = __fb_ioctl(inode, file, cmd, (unsigned long) &fix);
 	set_fs(old_fs);
 
 	if (!err)
@@ -1208,7 +1230,7 @@
 	struct fb_ops *fb = info->fbops;
 	long ret = -ENOIOCTLCMD;
 
-	lock_kernel();
+	mutex_lock(&info->hwlock);
 	switch(cmd) {
 	case FBIOGET_VSCREENINFO:
 	case FBIOPUT_VSCREENINFO:
@@ -1217,7 +1239,7 @@
 	case FBIOPUT_CON2FBMAP:
 		arg = (unsigned long) compat_ptr(arg);
 	case FBIOBLANK:
-		ret = fb_ioctl(inode, file, cmd, arg);
+		ret = __fb_ioctl(inode, file, cmd, arg);
 		break;
 
 	case FBIOGET_FSCREENINFO:
@@ -1234,7 +1256,7 @@
 			ret = fb->fb_compat_ioctl(info, cmd, arg);
 		break;
 	}
-	unlock_kernel();
+	mutex_unlock(&info->hwlock);
 	return ret;
 }
 #endif
@@ -1256,13 +1278,13 @@
 		return -ENODEV;
 	if (fb->fb_mmap) {
 		int res;
-		lock_kernel();
+		mutex_lock(&info->hwlock);
 		res = fb->fb_mmap(info, vma);
-		unlock_kernel();
+		mutex_unlock(&info->hwlock);
 		return res;
 	}
 
-	lock_kernel();
+	mutex_lock(&info->hwlock);
 
 	/* frame buffer memory */
 	start = info->fix.smem_start;
@@ -1271,13 +1293,13 @@
 		/* memory mapped io */
 		off -= len;
 		if (info->var.accel_flags) {
-			unlock_kernel();
+			mutex_unlock(&info->hwlock);
 			return -EINVAL;
 		}
 		start = info->fix.mmio_start;
 		len = PAGE_ALIGN((start & ~PAGE_MASK) + info->fix.mmio_len);
 	}
-	unlock_kernel();
+	mutex_unlock(&info->hwlock);
 	start &= PAGE_MASK;
 	if ((vma->vm_end - vma->vm_start + off) > len)
 		return -EINVAL;
@@ -1323,25 +1345,25 @@
 {
 	struct fb_info * const info = file->private_data;
 
-	lock_kernel();
+	mutex_lock(&info->hwlock);
 	if (info->fbops->fb_release)
 		info->fbops->fb_release(info,1);
 	module_put(info->fbops->owner);
-	unlock_kernel();
+	mutex_unlock(&info->hwlock);
 	return 0;
 }
 
 static const struct file_operations fb_fops = {
-	.owner =	THIS_MODULE,
-	.read =		fb_read,
-	.write =	fb_write,
-	.ioctl =	fb_ioctl,
+	.owner =		THIS_MODULE,
+	.read =			fb_read,
+	.write =		fb_write,
+	.unlocked_ioctl =	fb_unlocked_ioctl,
 #ifdef CONFIG_COMPAT
-	.compat_ioctl = fb_compat_ioctl,
+	.compat_ioctl = 	fb_compat_ioctl,
 #endif
-	.mmap =		fb_mmap,
-	.open =		fb_open,
-	.release =	fb_release,
+	.mmap =			fb_mmap,
+	.open =			fb_open,
+	.release =		fb_release,
 #ifdef HAVE_ARCH_FB_UNMAPPED_AREA
 	.get_unmapped_area = get_fb_unmapped_area,
 #endif
@@ -1377,6 +1399,7 @@
 			break;
 	fb_info->node = i;
 
+	mutex_init(&fb_info->hwlock);
 	fb_info->dev = device_create(fb_class, fb_info->device,
 				     MKDEV(FB_MAJOR, i), "fb%d", i);
 	if (IS_ERR(fb_info->dev)) {
@@ -1413,6 +1436,7 @@
 
 	event.info = fb_info;
 	fb_notifier_call_chain(FB_EVENT_FB_REGISTERED, &event);
+
 	return 0;
 }
 
@@ -1464,6 +1488,7 @@
 	device_destroy(fb_class, MKDEV(FB_MAJOR, i));
 	event.info = fb_info;
 	fb_notifier_call_chain(FB_EVENT_FB_UNREGISTERED, &event);
+	mutex_destroy(&fb_info.hwlock);
 done:
 	return ret;
 }
Index: linux-2.6.23.1/include/linux/fb.h
===================================================================
--- linux-2.6.23.1.orig/include/linux/fb.h	2008-04-16 18:52:32.000000000 -0300
+++ linux-2.6.23.1/include/linux/fb.h	2008-04-16 18:53:22.000000000 -0300
@@ -802,6 +802,7 @@
 	struct list_head modelist;      /* mode list */
 	struct fb_videomode *mode;	/* current mode */
 
+	struct mutex hwlock;		/* mutex for protecting hw ops */
 #ifdef CONFIG_FB_BACKLIGHT
 	/* assigned backlight device */
 	/* set before framebuffer registration, 



