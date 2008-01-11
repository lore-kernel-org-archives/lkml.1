Return-Path: <linux-kernel-owner+w=401wt.eu-S1760269AbYAKDWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760269AbYAKDWu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 22:22:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759978AbYAKDWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 22:22:18 -0500
Received: from ns2.suse.de ([195.135.220.15]:53242 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759963AbYAKDWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 22:22:16 -0500
Subject: [PATCH 5/11 ] Change drm_ioctl as an unlocked_ioctl function : mga
From: Nikanth Karthikesan <knikanth@suse.de>
To: airlied@linux.ie, dri-devel@lists.sourceforge.net,
       benh@kernel.crashing.org, paulus@samba.org, thomas@winischhofer.net,
       adaplas@gmail.com, sylvain.meyer@worldonline.fr
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain
Date: Fri, 11 Jan 2008 08:55:54 +0530
Message-Id: <1200021954.3844.8.camel@nikanth-laptop.blr.novell.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register drm_ioctl as an unlocked_ioctl function.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

--- 
diff --git a/drivers/char/drm/mga_drv.c b/drivers/char/drm/mga_drv.c
index 5572939..be31707 100644
--- a/drivers/char/drm/mga_drv.c
+++ b/drivers/char/drm/mga_drv.c
@@ -67,7 +67,7 @@ static struct drm_driver driver = {
 		 .owner = THIS_MODULE,
 		 .open = drm_open,
 		 .release = drm_release,
-		 .ioctl = drm_ioctl,
+		 .unlocked_ioctl = drm_ioctl,
 		 .mmap = drm_mmap,
 		 .poll = drm_poll,
 		 .fasync = drm_fasync,
diff --git a/drivers/char/drm/mga_ioc32.c b/drivers/char/drm/mga_ioc32.c
index 30d0047..a4581d9 100644
--- a/drivers/char/drm/mga_ioc32.c
+++ b/drivers/char/drm/mga_ioc32.c
@@ -100,8 +100,7 @@ static int compat_mga_init(struct file *file, unsigned int cmd,
 	if (err)
 		return -EFAULT;
 
-	return drm_ioctl(file->f_path.dentry->d_inode, file,
-			 DRM_IOCTL_MGA_INIT, (unsigned long)init);
+	return drm_ioctl(file, DRM_IOCTL_MGA_INIT, (unsigned long)init);
 }
 
 typedef struct drm_mga_getparam32 {
@@ -125,8 +124,8 @@ static int compat_mga_getparam(struct file *file, unsigned int cmd,
 			  &getparam->value))
 		return -EFAULT;
 
-	return drm_ioctl(file->f_path.dentry->d_inode, file,
-			 DRM_IOCTL_MGA_GETPARAM, (unsigned long)getparam);
+	return drm_ioctl(file, DRM_IOCTL_MGA_GETPARAM,
+					 (unsigned long)getparam);
 }
 
 typedef struct drm_mga_drm_bootstrap32 {
@@ -166,9 +165,8 @@ static int compat_mga_dma_bootstrap(struct file *file, unsigned int cmd,
 	    || __put_user(dma_bootstrap32.agp_size, &dma_bootstrap->agp_size))
 		return -EFAULT;
 
-	err = drm_ioctl(file->f_path.dentry->d_inode, file,
-			DRM_IOCTL_MGA_DMA_BOOTSTRAP,
-			(unsigned long)dma_bootstrap);
+	err = drm_ioctl(file, DRM_IOCTL_MGA_DMA_BOOTSTRAP,
+					(unsigned long)dma_bootstrap);
 	if (err)
 		return err;
 
@@ -224,7 +222,7 @@ long mga_compat_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	if (fn != NULL)
 		ret = (*fn) (filp, cmd, arg);
 	else
-		ret = drm_ioctl(filp->f_path.dentry->d_inode, filp, cmd, arg);
+		ret = drm_ioctl(filp, cmd, arg);
 	unlock_kernel();
 
 	return ret;


