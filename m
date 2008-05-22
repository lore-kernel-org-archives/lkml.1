Return-Path: <linux-kernel-owner+w=401wt.eu-S1760383AbYEVUov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760383AbYEVUov (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 16:44:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755508AbYEVUon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 16:44:43 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43998 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755261AbYEVUol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 16:44:41 -0400
Date: Thu, 22 May 2008 21:32:03 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
Subject: [PATCH] drm: Push BKL down into drivers
Message-ID: <20080522213203.012039c3@core>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a fairly simple change but affects all the drivers. The actual
lock is pushed down rather than eliminated. Hopefully it will then get
pushed down further. More importantly it helps us get rid of the old BKL
locked ioctl

Signed-off-by: Alan Cox <alan@redhat.com>

diff --git a/drivers/char/drm/drmP.h b/drivers/char/drm/drmP.h
index 213b3ca..c545ccb 100644
--- a/drivers/char/drm/drmP.h
+++ b/drivers/char/drm/drmP.h
@@ -888,7 +888,7 @@ static inline int drm_mtrr_del(int handle, unsigned long offset,
 				/* Driver support (drm_drv.h) */
 extern int drm_init(struct drm_driver *driver);
 extern void drm_exit(struct drm_driver *driver);
-extern int drm_ioctl(struct inode *inode, struct file *filp,
+extern long drm_ioctl(struct file *filp,
 		     unsigned int cmd, unsigned long arg);
 extern long drm_compat_ioctl(struct file *filp,
 			     unsigned int cmd, unsigned long arg);
diff --git a/drivers/char/drm/drm_drv.c b/drivers/char/drm/drm_drv.c
index fc54140..a494869 100644
--- a/drivers/char/drm/drm_drv.c
+++ b/drivers/char/drm/drm_drv.c
@@ -435,7 +435,6 @@ static int drm_version(struct drm_device *dev, void *data,
 /**
  * Called whenever a process performs an ioctl on /dev/drm.
  *
- * \param inode device inode.
  * \param file_priv DRM file private.
  * \param cmd command.
  * \param arg user argument.
@@ -444,8 +443,7 @@ static int drm_version(struct drm_device *dev, void *data,
  * Looks up the ioctl function in the ::ioctls table, checking for root
  * previleges if so required, and dispatches to the respective function.
  */
-int drm_ioctl(struct inode *inode, struct file *filp,
-	      unsigned int cmd, unsigned long arg)
+long drm_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	struct drm_file *file_priv = filp->private_data;
 	struct drm_device *dev = file_priv->minor->dev;
@@ -457,6 +455,8 @@ int drm_ioctl(struct inode *inode, struct file *filp,
 
 	atomic_inc(&dev->ioctl_count);
 	atomic_inc(&dev->counts[_DRM_STAT_IOCTLS]);
+
+	lock_kernel();
 	++file_priv->ioctl_count;
 
 	DRM_DEBUG("pid=%d, cmd=0x%02x, nr=0x%02x, dev 0x%lx, auth=%d\n",
@@ -519,6 +519,7 @@ int drm_ioctl(struct inode *inode, struct file *filp,
 	atomic_dec(&dev->ioctl_count);
 	if (retcode)
 		DRM_DEBUG("ret = %x\n", retcode);
+	unlock_kernel();
 	return retcode;
 }
 
diff --git a/drivers/char/drm/i810_dma.c b/drivers/char/drm/i810_dma.c
index e5de8ea..b82e8ed 100644
--- a/drivers/char/drm/i810_dma.c
+++ b/drivers/char/drm/i810_dma.c
@@ -115,7 +115,7 @@ static int i810_mmap_buffers(struct file *filp, struct vm_area_struct *vma)
 static const struct file_operations i810_buffer_fops = {
 	.open = drm_open,
 	.release = drm_release,
-	.ioctl = drm_ioctl,
+	.unlocked_ioctl = drm_ioctl,
 	.mmap = i810_mmap_buffers,
 	.fasync = drm_fasync,
 };
diff --git a/drivers/char/drm/i810_drv.c b/drivers/char/drm/i810_drv.c
index fabb9a8..c1e0275 100644
--- a/drivers/char/drm/i810_drv.c
+++ b/drivers/char/drm/i810_drv.c
@@ -59,7 +59,7 @@ static struct drm_driver driver = {
 		 .owner = THIS_MODULE,
 		 .open = drm_open,
 		 .release = drm_release,
-		 .ioctl = drm_ioctl,
+		 .unlocked_ioctl = drm_ioctl,
 		 .mmap = drm_mmap,
 		 .poll = drm_poll,
 		 .fasync = drm_fasync,
diff --git a/drivers/char/drm/i830_dma.c b/drivers/char/drm/i830_dma.c
index a86ab30..8045e7a 100644
--- a/drivers/char/drm/i830_dma.c
+++ b/drivers/char/drm/i830_dma.c
@@ -117,7 +117,7 @@ static int i830_mmap_buffers(struct file *filp, struct vm_area_struct *vma)
 static const struct file_operations i830_buffer_fops = {
 	.open = drm_open,
 	.release = drm_release,
-	.ioctl = drm_ioctl,
+	.unlocked_ioctl = drm_ioctl,
 	.mmap = i830_mmap_buffers,
 	.fasync = drm_fasync,
 };
diff --git a/drivers/char/drm/i830_drv.c b/drivers/char/drm/i830_drv.c
index 389597e..44f990b 100644
--- a/drivers/char/drm/i830_drv.c
+++ b/drivers/char/drm/i830_drv.c
@@ -70,7 +70,7 @@ static struct drm_driver driver = {
 		 .owner = THIS_MODULE,
 		 .open = drm_open,
 		 .release = drm_release,
-		 .ioctl = drm_ioctl,
+		 .unlocked_ioctl = drm_ioctl,
 		 .mmap = drm_mmap,
 		 .poll = drm_poll,
 		 .fasync = drm_fasync,
diff --git a/drivers/char/drm/i915_drv.c b/drivers/char/drm/i915_drv.c
index bb8f1b2..a05f44b 100644
--- a/drivers/char/drm/i915_drv.c
+++ b/drivers/char/drm/i915_drv.c
@@ -556,7 +556,7 @@ static struct drm_driver driver = {
 		 .owner = THIS_MODULE,
 		 .open = drm_open,
 		 .release = drm_release,
-		 .ioctl = drm_ioctl,
+		 .unlocked_ioctl = drm_ioctl,
 		 .mmap = drm_mmap,
 		 .poll = drm_poll,
 		 .fasync = drm_fasync,
diff --git a/drivers/char/drm/mga_drv.c b/drivers/char/drm/mga_drv.c
index 6b37909..02738ec 100644
--- a/drivers/char/drm/mga_drv.c
+++ b/drivers/char/drm/mga_drv.c
@@ -68,7 +68,7 @@ static struct drm_driver driver = {
 		 .owner = THIS_MODULE,
 		 .open = drm_open,
 		 .release = drm_release,
-		 .ioctl = drm_ioctl,
+		 .unlocked_ioctl = drm_ioctl,
 		 .mmap = drm_mmap,
 		 .poll = drm_poll,
 		 .fasync = drm_fasync,
diff --git a/drivers/char/drm/r128_drv.c b/drivers/char/drm/r128_drv.c
index 2888aa0..7e0baff 100644
--- a/drivers/char/drm/r128_drv.c
+++ b/drivers/char/drm/r128_drv.c
@@ -63,7 +63,7 @@ static struct drm_driver driver = {
 		 .owner = THIS_MODULE,
 		 .open = drm_open,
 		 .release = drm_release,
-		 .ioctl = drm_ioctl,
+		 .unlocked_ioctl = drm_ioctl,
 		 .mmap = drm_mmap,
 		 .poll = drm_poll,
 		 .fasync = drm_fasync,
diff --git a/drivers/char/drm/radeon_drv.c b/drivers/char/drm/radeon_drv.c
index a261031..639e9fe 100644
--- a/drivers/char/drm/radeon_drv.c
+++ b/drivers/char/drm/radeon_drv.c
@@ -85,7 +85,7 @@ static struct drm_driver driver = {
 		 .owner = THIS_MODULE,
 		 .open = drm_open,
 		 .release = drm_release,
-		 .ioctl = drm_ioctl,
+		 .unlocked_ioctl = drm_ioctl,
 		 .mmap = drm_mmap,
 		 .poll = drm_poll,
 		 .fasync = drm_fasync,
diff --git a/drivers/char/drm/savage_drv.c b/drivers/char/drm/savage_drv.c
index eee52aa..021de44 100644
--- a/drivers/char/drm/savage_drv.c
+++ b/drivers/char/drm/savage_drv.c
@@ -50,7 +50,7 @@ static struct drm_driver driver = {
 		 .owner = THIS_MODULE,
 		 .open = drm_open,
 		 .release = drm_release,
-		 .ioctl = drm_ioctl,
+		 .unlocked_ioctl = drm_ioctl,
 		 .mmap = drm_mmap,
 		 .poll = drm_poll,
 		 .fasync = drm_fasync,
diff --git a/drivers/char/drm/sis_drv.c b/drivers/char/drm/sis_drv.c
index 7dacc64..1bbde29 100644
--- a/drivers/char/drm/sis_drv.c
+++ b/drivers/char/drm/sis_drv.c
@@ -80,7 +80,7 @@ static struct drm_driver driver = {
 		 .owner = THIS_MODULE,
 		 .open = drm_open,
 		 .release = drm_release,
-		 .ioctl = drm_ioctl,
+		 .unlocked_ioctl = drm_ioctl,
 		 .mmap = drm_mmap,
 		 .poll = drm_poll,
 		 .fasync = drm_fasync,
diff --git a/drivers/char/drm/tdfx_drv.c b/drivers/char/drm/tdfx_drv.c
index 012ff2e..ec5a43e 100644
--- a/drivers/char/drm/tdfx_drv.c
+++ b/drivers/char/drm/tdfx_drv.c
@@ -48,7 +48,7 @@ static struct drm_driver driver = {
 		 .owner = THIS_MODULE,
 		 .open = drm_open,
 		 .release = drm_release,
-		 .ioctl = drm_ioctl,
+		 .unlocked_ioctl = drm_ioctl,
 		 .mmap = drm_mmap,
 		 .poll = drm_poll,
 		 .fasync = drm_fasync,
diff --git a/drivers/char/drm/via_drv.c b/drivers/char/drm/via_drv.c
index 37870a4..2bb9cf2 100644
--- a/drivers/char/drm/via_drv.c
+++ b/drivers/char/drm/via_drv.c
@@ -64,7 +64,7 @@ static struct drm_driver driver = {
 		 .owner = THIS_MODULE,
 		 .open = drm_open,
 		 .release = drm_release,
-		 .ioctl = drm_ioctl,
+		 .unlocked_ioctl = drm_ioctl,
 		 .mmap = drm_mmap,
 		 .poll = drm_poll,
 		 .fasync = drm_fasync,
