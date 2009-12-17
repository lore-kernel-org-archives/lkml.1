Return-Path: <linux-kernel-owner+w=401wt.eu-S936408AbZLQER7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936408AbZLQER7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:17:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936393AbZLQERr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:17:47 -0500
Received: from kroah.org ([198.145.64.141]:55936 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936156AbZLQEFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:05:30 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:58 2009
Message-Id: <20091217035658.797276396@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:56:59 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Eric Anholt <eric@anholt.net>, Li Peng <peng.li@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Stefan Bader <stefan.bader@canonical.com>
Subject: [122/151] drm/i915: Fix sync to vblank when VGA output is turned off
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Li Peng <peng.li@linux.intel.com>

commit 778c902640530371a169ad1c03566e7c51b09874 upstream

In current vblank-wait implementation, if we turn off VGA output,
drm_wait_vblank will still wait on the disabled pipe until timeout,
because vblank on the pipe is assumed be enabled. This would cause
slow system response on some system such as moblin.

This patch resolve the issue by adding a drm helper function
drm_vblank_off which explicitly clear vblank_enabled[crtc], wake up
any waiting queue and save last vblank counter before turning off
crtc. It also slightly change drm_vblank_get to ensure that we will
will return immediately if trying to wait on a disabled pipe.

Signed-off-by: Li Peng <peng.li@intel.com>
Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>
[anholt: hand-applied for conflicts with overlay changes]
Signed-off-by: Eric Anholt <eric@anholt.net>
Cc: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/gpu/drm/drm_irq.c            |   34 ++++++++++++++++++++++++++--------
 drivers/gpu/drm/i915/intel_display.c |    1 +
 include/drm/drmP.h                   |    1 +
 3 files changed, 28 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/drm_irq.c
+++ b/drivers/gpu/drm/drm_irq.c
@@ -429,15 +429,21 @@ int drm_vblank_get(struct drm_device *de
 
 	spin_lock_irqsave(&dev->vbl_lock, irqflags);
 	/* Going from 0->1 means we have to enable interrupts again */
-	if (atomic_add_return(1, &dev->vblank_refcount[crtc]) == 1 &&
-	    !dev->vblank_enabled[crtc]) {
-		ret = dev->driver->enable_vblank(dev, crtc);
-		DRM_DEBUG("enabling vblank on crtc %d, ret: %d\n", crtc, ret);
-		if (ret)
+	if (atomic_add_return(1, &dev->vblank_refcount[crtc]) == 1) {
+		if (!dev->vblank_enabled[crtc]) {
+			ret = dev->driver->enable_vblank(dev, crtc);
+			DRM_DEBUG("enabling vblank on crtc %d, ret: %d\n", crtc, ret);
+			if (ret)
+				atomic_dec(&dev->vblank_refcount[crtc]);
+			else {
+				dev->vblank_enabled[crtc] = 1;
+				drm_update_vblank_count(dev, crtc);
+			}
+		}
+	} else {
+		if (!dev->vblank_enabled[crtc]) {
 			atomic_dec(&dev->vblank_refcount[crtc]);
-		else {
-			dev->vblank_enabled[crtc] = 1;
-			drm_update_vblank_count(dev, crtc);
+			ret = -EINVAL;
 		}
 	}
 	spin_unlock_irqrestore(&dev->vbl_lock, irqflags);
@@ -464,6 +470,18 @@ void drm_vblank_put(struct drm_device *d
 }
 EXPORT_SYMBOL(drm_vblank_put);
 
+void drm_vblank_off(struct drm_device *dev, int crtc)
+{
+	unsigned long irqflags;
+
+	spin_lock_irqsave(&dev->vbl_lock, irqflags);
+	DRM_WAKEUP(&dev->vbl_queue[crtc]);
+	dev->vblank_enabled[crtc] = 0;
+	dev->last_vblank[crtc] = dev->driver->get_vblank_counter(dev, crtc);
+	spin_unlock_irqrestore(&dev->vbl_lock, irqflags);
+}
+EXPORT_SYMBOL(drm_vblank_off);
+
 /**
  * drm_vblank_pre_modeset - account for vblanks across mode sets
  * @dev: DRM device
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -1845,6 +1845,7 @@ static void i9xx_crtc_dpms(struct drm_cr
 		intel_update_watermarks(dev);
 		/* Give the overlay scaler a chance to disable if it's on this pipe */
 		//intel_crtc_dpms_video(crtc, FALSE); TODO
+		drm_vblank_off(dev, pipe);
 
 		if (dev_priv->cfb_plane == plane &&
 		    dev_priv->display.disable_fbc)
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -1295,6 +1295,7 @@ extern u32 drm_vblank_count(struct drm_d
 extern void drm_handle_vblank(struct drm_device *dev, int crtc);
 extern int drm_vblank_get(struct drm_device *dev, int crtc);
 extern void drm_vblank_put(struct drm_device *dev, int crtc);
+extern void drm_vblank_off(struct drm_device *dev, int crtc);
 extern void drm_vblank_cleanup(struct drm_device *dev);
 /* Modesetting support */
 extern void drm_vblank_pre_modeset(struct drm_device *dev, int crtc);


