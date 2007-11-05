Return-Path: <linux-kernel-owner+w=401wt.eu-S1753553AbXKECRE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553AbXKECRE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 21:17:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753933AbXKECQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 21:16:45 -0500
Received: from gir.skynet.ie ([193.1.99.77]:60788 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753632AbXKECQo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 21:16:44 -0500
Date: Mon, 5 Nov 2007 02:16:42 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@osdl.org, Andrew Morton <akpm@osdl.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: [git pull] drm patches for 2.6.24-rc2
In-Reply-To: <Pine.LNX.4.64.0711050103070.30576@skynet.skynet.ie>
Message-ID: <alpine.DEB.0.82.0711050215050.11125@skynet.skynet.ie>
References: <Pine.LNX.4.64.0711050103070.30576@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Typical of me, I found another issue so I've just repushed the tree..

If you have or haven't pulled, please re-pull..

Please pull from 'drm-patches' branch of
master.kernel.org:/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-patches

to receive the following updates:

 drivers/char/drm/drmP.h         |    2 --
 drivers/char/drm/drm_os_linux.h |    8 --------
 drivers/char/drm/radeon_cp.c    |    5 +++--
 drivers/char/drm/radeon_drv.h   |    1 +
 drivers/char/drm/savage_bci.c   |    3 ---
 drivers/char/drm/sis_mm.c       |    1 +
 6 files changed, 5 insertions(+), 15 deletions(-)

Dave Airlie (3):
      radeon: set the address to access the GART table on the CPU side correctly
      drm: remove second forward decleration of drm device struct.
      drm: remove remnants of DRM_COPY_FROM/TO_USER_IOCTL

Roel Kluin (1):
      drm/sis: missing mutex unlock in error path.

diff --git a/drivers/char/drm/drmP.h b/drivers/char/drm/drmP.h
index 9dd0760..dde02a1 100644
--- a/drivers/char/drm/drmP.h
+++ b/drivers/char/drm/drmP.h
@@ -559,8 +559,6 @@ struct drm_mm {
  * a family of cards. There will one drm_device for each card present
  * in this family
  */
-struct drm_device;
-
 struct drm_driver {
 	int (*load) (struct drm_device *, unsigned long flags);
 	int (*firstopen) (struct drm_device *);
diff --git a/drivers/char/drm/drm_os_linux.h b/drivers/char/drm/drm_os_linux.h
index 76e44ac..daa69c9 100644
--- a/drivers/char/drm/drm_os_linux.h
+++ b/drivers/char/drm/drm_os_linux.h
@@ -62,14 +62,6 @@ static __inline__ int mtrr_del(int reg, unsigned long base, unsigned long size)
 
 #endif
 
-/** For data going into the kernel through the ioctl argument */
-#define DRM_COPY_FROM_USER_IOCTL(arg1, arg2, arg3)	\
-	if ( copy_from_user(&arg1, arg2, arg3) )	\
-		return -EFAULT
-/** For data going from the kernel through the ioctl argument */
-#define DRM_COPY_TO_USER_IOCTL(arg1, arg2, arg3)	\
-	if ( copy_to_user(arg1, &arg2, arg3) )		\
-		return -EFAULT
 /** Other copying of data to kernel space */
 #define DRM_COPY_FROM_USER(arg1, arg2, arg3)		\
 	copy_from_user(arg1, arg2, arg3)
diff --git a/drivers/char/drm/radeon_cp.c b/drivers/char/drm/radeon_cp.c
index 335423c..24fca8e 100644
--- a/drivers/char/drm/radeon_cp.c
+++ b/drivers/char/drm/radeon_cp.c
@@ -1679,7 +1679,7 @@ static int radeon_do_init_cp(struct drm_device * dev, drm_radeon_init_t * init)
 			dev_priv->gart_info.bus_addr =
 			    dev_priv->pcigart_offset + dev_priv->fb_location;
 			dev_priv->gart_info.mapping.offset =
-			    dev_priv->gart_info.bus_addr;
+			    dev_priv->pcigart_offset + dev_priv->fb_aper_offset;
 			dev_priv->gart_info.mapping.size =
 			    dev_priv->gart_info.table_size;
 
@@ -2275,7 +2275,8 @@ int radeon_driver_firstopen(struct drm_device *dev)
 	if (ret != 0)
 		return ret;
 
-	ret = drm_addmap(dev, drm_get_resource_start(dev, 0),
+	dev_priv->fb_aper_offset = drm_get_resource_start(dev, 0);
+	ret = drm_addmap(dev, dev_priv->fb_aper_offset,
 			 drm_get_resource_len(dev, 0), _DRM_FRAME_BUFFER,
 			 _DRM_WRITE_COMBINING, &map);
 	if (ret != 0)
diff --git a/drivers/char/drm/radeon_drv.h b/drivers/char/drm/radeon_drv.h
index e4077bc..bfbb60a 100644
--- a/drivers/char/drm/radeon_drv.h
+++ b/drivers/char/drm/radeon_drv.h
@@ -293,6 +293,7 @@ typedef struct drm_radeon_private {
 
 	/* starting from here on, data is preserved accross an open */
 	uint32_t flags;		/* see radeon_chip_flags */
+	unsigned long fb_aper_offset;
 } drm_radeon_private_t;
 
 typedef struct drm_radeon_buf_priv {
diff --git a/drivers/char/drm/savage_bci.c b/drivers/char/drm/savage_bci.c
index 59484d5..d465b2f 100644
--- a/drivers/char/drm/savage_bci.c
+++ b/drivers/char/drm/savage_bci.c
@@ -968,9 +968,6 @@ static int savage_bci_event_wait(struct drm_device *dev, void *data, struct drm_
 
 	DRM_DEBUG("\n");
 
-	DRM_COPY_FROM_USER_IOCTL(event, (drm_savage_event_wait_t __user *) data,
-				 sizeof(event));
-
 	UPDATE_EVENT_COUNTER();
 	if (dev_priv->status_ptr)
 		hw_e = dev_priv->status_ptr[1] & 0xffff;
diff --git a/drivers/char/drm/sis_mm.c b/drivers/char/drm/sis_mm.c
index 6be1c57..a6b7ccd 100644
--- a/drivers/char/drm/sis_mm.c
+++ b/drivers/char/drm/sis_mm.c
@@ -134,6 +134,7 @@ static int sis_drm_alloc(struct drm_device *dev, struct drm_file *file_priv,
 		      dev_priv->agp_initialized)) {
 		DRM_ERROR
 		    ("Attempt to allocate from uninitialized memory manager.\n");
+		mutex_unlock(&dev->struct_mutex);
 		return -EINVAL;
 	}
 
