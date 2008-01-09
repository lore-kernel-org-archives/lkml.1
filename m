Return-Path: <linux-kernel-owner+w=401wt.eu-S1758770AbYAIBDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758770AbYAIBDl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 20:03:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755665AbYAIAzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 19:55:48 -0500
Received: from py-out-1112.google.com ([64.233.166.177]:51874 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755175AbYAIAyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 19:54:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject:content-disposition;
        b=ZX7BGj290iBefK8T3xrTnH4EP7euaGJTaMz73AMlEd+D9YQlz85GkBetfy+vQCSmhmPrlFHTdseMRHDcSvDfWzyBaVQwdEyW+XHKl2uT4TiBz+yKiYHi0N0n+SqxVZDI8q4lAq8lkyFhkuNcfLesQmRoq5540MZipBmpEIJ52MY=
Message-Id: <20080109005443.227306069@gmail.com>
References: <20080109005416.039551758@gmail.com>
User-Agent: quilt/0.46-1
Date: Tue, 08 Jan 2008 20:54:17 -0400
From: Kevin Winchester <kjwinchester@gmail.com>
To: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       Kevin Winchester <kjwinchester@gmail.com>
Subject: [patch 1/1] Convert drivers in drivers/char/drm to use .unlocked_ioctl
Content-Disposition: inline; filename=drm_ioctl-unlocked_ioctl.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.sourceforge.net
Cc: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org

The drm drivers in this patch all used drm_ioctl to perform their
ioctl calls.  The common function is converted to use lock_kernel()
and unlock_kernel() and the drivers are converted to use .unlocked_ioctl

Signed-off-by: Kevin Winchester <kjwinchester@gmail.com>

---

I also noted that in the failed kmalloc case in drm_ioctl(), the function
immediately returns -ENOMEM, rather than following the error path that
calls atomic_dec(&dev->ioctl_count);.  I'm not sure if the ioctl_count
is just not important in the -ENOMEM case, or if this is a bug.

 drivers/char/drm/drmP.h       |    3 +--
 drivers/char/drm/drm_drv.c    |   10 ++++++----
 drivers/char/drm/i810_dma.c   |    2 +-
 drivers/char/drm/i810_drv.c   |    2 +-
 drivers/char/drm/i830_dma.c   |    2 +-
 drivers/char/drm/i830_drv.c   |    2 +-
 drivers/char/drm/i915_drv.c   |    2 +-
 drivers/char/drm/mga_drv.c    |    2 +-
 drivers/char/drm/r128_drv.c   |    2 +-
 drivers/char/drm/radeon_drv.c |    2 +-
 drivers/char/drm/savage_drv.c |    2 +-
 drivers/char/drm/sis_drv.c    |    2 +-
 drivers/char/drm/tdfx_drv.c   |    2 +-
 drivers/char/drm/via_drv.c    |    2 +-
 14 files changed, 19 insertions(+), 18 deletions(-)

Index: v2.6.24-rc7/drivers/char/drm/drmP.h
===================================================================
--- v2.6.24-rc7.orig/drivers/char/drm/drmP.h
+++ v2.6.24-rc7/drivers/char/drm/drmP.h
@@ -833,8 +833,7 @@ static inline int drm_mtrr_del(int handl
 				/* Driver support (drm_drv.h) */
 extern int drm_init(struct drm_driver *driver);
 extern void drm_exit(struct drm_driver *driver);
-extern int drm_ioctl(struct inode *inode, struct file *filp,
-		     unsigned int cmd, unsigned long arg);
+extern long drm_ioctl(struct file *filp, unsigned int cmd, unsigned long arg);
 extern long drm_compat_ioctl(struct file *filp,
 			     unsigned int cmd, unsigned long arg);
 extern int drm_lastclose(struct drm_device *dev);
Index: v2.6.24-rc7/drivers/char/drm/drm_drv.c
===================================================================
--- v2.6.24-rc7.orig/drivers/char/drm/drm_drv.c
+++ v2.6.24-rc7/drivers/char/drm/drm_drv.c
@@ -438,7 +438,6 @@ static int drm_version(struct drm_device
 /**
  * Called whenever a process performs an ioctl on /dev/drm.
  *
- * \param inode device inode.
  * \param file_priv DRM file private.
  * \param cmd command.
  * \param arg user argument.
@@ -447,8 +446,7 @@ static int drm_version(struct drm_device
  * Looks up the ioctl function in the ::ioctls table, checking for root
  * previleges if so required, and dispatches to the respective function.
  */
-int drm_ioctl(struct inode *inode, struct file *filp,
-	      unsigned int cmd, unsigned long arg)
+long drm_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	struct drm_file *file_priv = filp->private_data;
 	struct drm_device *dev = file_priv->head->dev;
@@ -458,6 +456,7 @@ int drm_ioctl(struct inode *inode, struc
 	int retcode = -EINVAL;
 	char *kdata = NULL;
 
+	lock_kernel();
 	atomic_inc(&dev->ioctl_count);
 	atomic_inc(&dev->counts[_DRM_STAT_IOCTLS]);
 	++file_priv->ioctl_count;
@@ -494,8 +493,10 @@ int drm_ioctl(struct inode *inode, struc
 	} else {
 		if (cmd & (IOC_IN | IOC_OUT)) {
 			kdata = kmalloc(_IOC_SIZE(cmd), GFP_KERNEL);
-			if (!kdata)
+			if (!kdata) {
+				unlock_kernel();
 				return -ENOMEM;
+			}
 		}
 
 		if (cmd & IOC_IN) {
@@ -520,6 +521,7 @@ int drm_ioctl(struct inode *inode, struc
 	atomic_dec(&dev->ioctl_count);
 	if (retcode)
 		DRM_DEBUG("ret = %x\n", retcode);
+	unlock_kernel();
 	return retcode;
 }
 
Index: v2.6.24-rc7/drivers/char/drm/i810_dma.c
===================================================================
--- v2.6.24-rc7.orig/drivers/char/drm/i810_dma.c
+++ v2.6.24-rc7/drivers/char/drm/i810_dma.c
@@ -115,7 +115,7 @@ static int i810_mmap_buffers(struct file
 static const struct file_operations i810_buffer_fops = {
 	.open = drm_open,
 	.release = drm_release,
-	.ioctl = drm_ioctl,
+	.unlocked_ioctl = drm_ioctl,
 	.mmap = i810_mmap_buffers,
 	.fasync = drm_fasync,
 };
Index: v2.6.24-rc7/drivers/char/drm/i810_drv.c
===================================================================
--- v2.6.24-rc7.orig/drivers/char/drm/i810_drv.c
+++ v2.6.24-rc7/drivers/char/drm/i810_drv.c
@@ -59,7 +59,7 @@ static struct drm_driver driver = {
 		 .owner = THIS_MODULE,
 		 .open = drm_open,
 		 .release = drm_release,
-		 .ioctl = drm_ioctl,
+		 .unlocked_ioctl = drm_ioctl,
 		 .mmap = drm_mmap,
 		 .poll = drm_poll,
 		 .fasync = drm_fasync,
Index: v2.6.24-rc7/drivers/char/drm/i830_dma.c
===================================================================
--- v2.6.24-rc7.orig/drivers/char/drm/i830_dma.c
+++ v2.6.24-rc7/drivers/char/drm/i830_dma.c
@@ -117,7 +117,7 @@ static int i830_mmap_buffers(struct file
 static const struct file_operations i830_buffer_fops = {
 	.open = drm_open,
 	.release = drm_release,
-	.ioctl = drm_ioctl,
+	.unlocked_ioctl = drm_ioctl,
 	.mmap = i830_mmap_buffers,
 	.fasync = drm_fasync,
 };
Index: v2.6.24-rc7/drivers/char/drm/i830_drv.c
===================================================================
--- v2.6.24-rc7.orig/drivers/char/drm/i830_drv.c
+++ v2.6.24-rc7/drivers/char/drm/i830_drv.c
@@ -70,7 +70,7 @@ static struct drm_driver driver = {
 		 .owner = THIS_MODULE,
 		 .open = drm_open,
 		 .release = drm_release,
-		 .ioctl = drm_ioctl,
+		 .unlocked_ioctl = drm_ioctl,
 		 .mmap = drm_mmap,
 		 .poll = drm_poll,
 		 .fasync = drm_fasync,
Index: v2.6.24-rc7/drivers/char/drm/i915_drv.c
===================================================================
--- v2.6.24-rc7.orig/drivers/char/drm/i915_drv.c
+++ v2.6.24-rc7/drivers/char/drm/i915_drv.c
@@ -64,7 +64,7 @@ static struct drm_driver driver = {
 		 .owner = THIS_MODULE,
 		 .open = drm_open,
 		 .release = drm_release,
-		 .ioctl = drm_ioctl,
+		 .unlocked_ioctl = drm_ioctl,
 		 .mmap = drm_mmap,
 		 .poll = drm_poll,
 		 .fasync = drm_fasync,
Index: v2.6.24-rc7/drivers/char/drm/mga_drv.c
===================================================================
--- v2.6.24-rc7.orig/drivers/char/drm/mga_drv.c
+++ v2.6.24-rc7/drivers/char/drm/mga_drv.c
@@ -67,7 +67,7 @@ static struct drm_driver driver = {
 		 .owner = THIS_MODULE,
 		 .open = drm_open,
 		 .release = drm_release,
-		 .ioctl = drm_ioctl,
+		 .unlocked_ioctl = drm_ioctl,
 		 .mmap = drm_mmap,
 		 .poll = drm_poll,
 		 .fasync = drm_fasync,
Index: v2.6.24-rc7/drivers/char/drm/r128_drv.c
===================================================================
--- v2.6.24-rc7.orig/drivers/char/drm/r128_drv.c
+++ v2.6.24-rc7/drivers/char/drm/r128_drv.c
@@ -62,7 +62,7 @@ static struct drm_driver driver = {
 		 .owner = THIS_MODULE,
 		 .open = drm_open,
 		 .release = drm_release,
-		 .ioctl = drm_ioctl,
+		 .unlocked_ioctl = drm_ioctl,
 		 .mmap = drm_mmap,
 		 .poll = drm_poll,
 		 .fasync = drm_fasync,
Index: v2.6.24-rc7/drivers/char/drm/radeon_drv.c
===================================================================
--- v2.6.24-rc7.orig/drivers/char/drm/radeon_drv.c
+++ v2.6.24-rc7/drivers/char/drm/radeon_drv.c
@@ -85,7 +85,7 @@ static struct drm_driver driver = {
 		 .owner = THIS_MODULE,
 		 .open = drm_open,
 		 .release = drm_release,
-		 .ioctl = drm_ioctl,
+		 .unlocked_ioctl = drm_ioctl,
 		 .mmap = drm_mmap,
 		 .poll = drm_poll,
 		 .fasync = drm_fasync,
Index: v2.6.24-rc7/drivers/char/drm/savage_drv.c
===================================================================
--- v2.6.24-rc7.orig/drivers/char/drm/savage_drv.c
+++ v2.6.24-rc7/drivers/char/drm/savage_drv.c
@@ -50,7 +50,7 @@ static struct drm_driver driver = {
 		 .owner = THIS_MODULE,
 		 .open = drm_open,
 		 .release = drm_release,
-		 .ioctl = drm_ioctl,
+		 .unlocked_ioctl = drm_ioctl,
 		 .mmap = drm_mmap,
 		 .poll = drm_poll,
 		 .fasync = drm_fasync,
Index: v2.6.24-rc7/drivers/char/drm/sis_drv.c
===================================================================
--- v2.6.24-rc7.orig/drivers/char/drm/sis_drv.c
+++ v2.6.24-rc7/drivers/char/drm/sis_drv.c
@@ -80,7 +80,7 @@ static struct drm_driver driver = {
 		 .owner = THIS_MODULE,
 		 .open = drm_open,
 		 .release = drm_release,
-		 .ioctl = drm_ioctl,
+		 .unlocked_ioctl = drm_ioctl,
 		 .mmap = drm_mmap,
 		 .poll = drm_poll,
 		 .fasync = drm_fasync,
Index: v2.6.24-rc7/drivers/char/drm/tdfx_drv.c
===================================================================
--- v2.6.24-rc7.orig/drivers/char/drm/tdfx_drv.c
+++ v2.6.24-rc7/drivers/char/drm/tdfx_drv.c
@@ -48,7 +48,7 @@ static struct drm_driver driver = {
 		 .owner = THIS_MODULE,
 		 .open = drm_open,
 		 .release = drm_release,
-		 .ioctl = drm_ioctl,
+		 .unlocked_ioctl = drm_ioctl,
 		 .mmap = drm_mmap,
 		 .poll = drm_poll,
 		 .fasync = drm_fasync,
Index: v2.6.24-rc7/drivers/char/drm/via_drv.c
===================================================================
--- v2.6.24-rc7.orig/drivers/char/drm/via_drv.c
+++ v2.6.24-rc7/drivers/char/drm/via_drv.c
@@ -62,7 +62,7 @@ static struct drm_driver driver = {
 		 .owner = THIS_MODULE,
 		 .open = drm_open,
 		 .release = drm_release,
-		 .ioctl = drm_ioctl,
+		 .unlocked_ioctl = drm_ioctl,
 		 .mmap = drm_mmap,
 		 .poll = drm_poll,
 		 .fasync = drm_fasync,

-- 
