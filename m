Return-Path: <linux-kernel-owner+w=401wt.eu-S1755445AbXKEBFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445AbXKEBFb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 20:05:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753139AbXKEBFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 20:05:23 -0500
Received: from gir.skynet.ie ([193.1.99.77]:41250 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751480AbXKEBFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 20:05:22 -0500
Date: Mon, 5 Nov 2007 01:05:19 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@osdl.org, Andrew Morton <akpm@osdl.org>
cc: linux-kernel@vger.kernel.org
Subject: [git pull] drm patches for 2.6.24-rc2
Message-ID: <Pine.LNX.4.64.0711050103070.30576@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull from 'drm-patches' branch of
master.kernel.org:/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-patches

to receive the following updates:

 drivers/char/drm/radeon_cp.c  |    5 +++--
 drivers/char/drm/radeon_drv.h |    1 +
 drivers/char/drm/sis_mm.c     |    1 +
 3 files changed, 5 insertions(+), 2 deletions(-)

Dave Airlie (1):
      radeon: set the address to access the GART table on the CPU side correctly

Roel Kluin (1):
      drm/sis: missing mutex unlock in error path.

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
 
