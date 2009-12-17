Return-Path: <linux-kernel-owner+w=401wt.eu-S1763411AbZLQAEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763411AbZLQAEP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 19:04:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762567AbZLQAEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 19:04:12 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:60814 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758184AbZLQAEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 19:04:10 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: David Airlie <airlied@linux.ie>
Subject: [RFC] drm: allow unlocked ioctls in drivers
Date: Thu, 17 Dec 2009 00:04:04 +0000
User-Agent: KMail/1.12.2 (Linux/2.6.32-07503-g4027c0c-dirty; KDE/4.3.2; x86_64; ; )
Cc: dri-devel@lists.sourceforge.net, Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Eric Anholt <eric@anholt.net>, Jesse Barnes <jbarnes@virtuousgeek.org>
References: <200912162217.09577.arnd@arndb.de>
In-Reply-To: <200912162217.09577.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912170004.04173.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19kAfSN6OPB36WXuW/7JCm+MNtvRUpK6qGrlMj
 RQqwF6oVTo9EDic60zTtLw3OVaDnm7E9WlIXDZYlnU5bboAxvC
 quOH2xbRmaIblpnwTecSA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just tried to find out what it would take to get the BKL /mostly/
out of drm. The approach I tried was to add another flag to the
ioctl list for commands that do not need the big kernel lock.

I blindly applied this flag to all the most commonly used ioctl
commands without checking if they actually rely on the lock.
This cuts down the overall BKL usage on my system by about 90%.

Based on the previous patch to turn drm_ioctl itself into an
unlocked call.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---

The machine still crashes because of another problem I'm trying to nail
down (coincidentally in the same driver), so I don't even have a way of
testing if this otherwise works, but the crashes did not seem to get
more frequent either...

--- a/drivers/gpu/drm/drm_drv.c
+++ b/drivers/gpu/drm/drm_drv.c
@@ -502,9 +502,13 @@ long drm_ioctl(struct file *filp,
 				goto err_i1;
 			}
 		}
-		lock_kernel();
-		retcode = func(dev, kdata, file_priv);
-		unlock_kernel();
+		if (ioctl->flags & DRM_UNLOCKED)
+			retcode = func(dev, kdata, file_priv);
+		else {
+			lock_kernel();
+			retcode = func(dev, kdata, file_priv);
+			unlock_kernel();
+		}
 
 		if (cmd & IOC_OUT) {
 			if (copy_to_user((void __user *)arg, kdata,
diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index 701bfea..67d78d6 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -1651,20 +1651,20 @@ struct drm_ioctl_desc i915_ioctls[] = {
 	DRM_IOCTL_DEF(DRM_I915_VBLANK_SWAP, i915_vblank_swap, DRM_AUTH),
 	DRM_IOCTL_DEF(DRM_I915_HWS_ADDR, i915_set_status_page, DRM_AUTH|DRM_MASTER|DRM_ROOT_ONLY),
 	DRM_IOCTL_DEF(DRM_I915_GEM_INIT, i915_gem_init_ioctl, DRM_AUTH|DRM_MASTER|DRM_ROOT_ONLY),
-	DRM_IOCTL_DEF(DRM_I915_GEM_EXECBUFFER, i915_gem_execbuffer, DRM_AUTH),
+	DRM_IOCTL_DEF(DRM_I915_GEM_EXECBUFFER, i915_gem_execbuffer, DRM_AUTH|DRM_UNLOCKED),
 	DRM_IOCTL_DEF(DRM_I915_GEM_PIN, i915_gem_pin_ioctl, DRM_AUTH|DRM_ROOT_ONLY),
 	DRM_IOCTL_DEF(DRM_I915_GEM_UNPIN, i915_gem_unpin_ioctl, DRM_AUTH|DRM_ROOT_ONLY),
-	DRM_IOCTL_DEF(DRM_I915_GEM_BUSY, i915_gem_busy_ioctl, DRM_AUTH),
-	DRM_IOCTL_DEF(DRM_I915_GEM_THROTTLE, i915_gem_throttle_ioctl, DRM_AUTH),
+	DRM_IOCTL_DEF(DRM_I915_GEM_BUSY, i915_gem_busy_ioctl, DRM_AUTH|DRM_UNLOCKED),
+	DRM_IOCTL_DEF(DRM_I915_GEM_THROTTLE, i915_gem_throttle_ioctl, DRM_AUTH|DRM_UNLOCKED),
 	DRM_IOCTL_DEF(DRM_I915_GEM_ENTERVT, i915_gem_entervt_ioctl, DRM_AUTH|DRM_MASTER|DRM_ROOT_ONLY),
 	DRM_IOCTL_DEF(DRM_I915_GEM_LEAVEVT, i915_gem_leavevt_ioctl, DRM_AUTH|DRM_MASTER|DRM_ROOT_ONLY),
-	DRM_IOCTL_DEF(DRM_I915_GEM_CREATE, i915_gem_create_ioctl, 0),
-	DRM_IOCTL_DEF(DRM_I915_GEM_PREAD, i915_gem_pread_ioctl, 0),
-	DRM_IOCTL_DEF(DRM_I915_GEM_PWRITE, i915_gem_pwrite_ioctl, 0),
-	DRM_IOCTL_DEF(DRM_I915_GEM_MMAP, i915_gem_mmap_ioctl, 0),
-	DRM_IOCTL_DEF(DRM_I915_GEM_MMAP_GTT, i915_gem_mmap_gtt_ioctl, 0),
-	DRM_IOCTL_DEF(DRM_I915_GEM_SET_DOMAIN, i915_gem_set_domain_ioctl, 0),
-	DRM_IOCTL_DEF(DRM_I915_GEM_SW_FINISH, i915_gem_sw_finish_ioctl, 0),
+	DRM_IOCTL_DEF(DRM_I915_GEM_CREATE, i915_gem_create_ioctl, DRM_UNLOCKED),
+	DRM_IOCTL_DEF(DRM_I915_GEM_PREAD, i915_gem_pread_ioctl, DRM_UNLOCKED),
+	DRM_IOCTL_DEF(DRM_I915_GEM_PWRITE, i915_gem_pwrite_ioctl, DRM_UNLOCKED),
+	DRM_IOCTL_DEF(DRM_I915_GEM_MMAP, i915_gem_mmap_ioctl, DRM_UNLOCKED),
+	DRM_IOCTL_DEF(DRM_I915_GEM_MMAP_GTT, i915_gem_mmap_gtt_ioctl, DRM_UNLOCKED),
+	DRM_IOCTL_DEF(DRM_I915_GEM_SET_DOMAIN, i915_gem_set_domain_ioctl, DRM_UNLOCKED),
+	DRM_IOCTL_DEF(DRM_I915_GEM_SW_FINISH, i915_gem_sw_finish_ioctl, DRM_UNLOCKED),
 	DRM_IOCTL_DEF(DRM_I915_GEM_SET_TILING, i915_gem_set_tiling, 0),
 	DRM_IOCTL_DEF(DRM_I915_GEM_GET_TILING, i915_gem_get_tiling, 0),
 	DRM_IOCTL_DEF(DRM_I915_GEM_GET_APERTURE, i915_gem_get_aperture_ioctl, 0),
diff --git a/include/drm/drmP.h b/include/drm/drmP.h
index 5b1bbe0..71dafb6 100644
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -296,6 +296,7 @@ typedef int drm_ioctl_compat_t(struct file *filp, unsigned int cmd,
 #define	DRM_MASTER	0x2
 #define DRM_ROOT_ONLY	0x4
 #define DRM_CONTROL_ALLOW 0x8
+#define DRM_UNLOCKED	0x10
 
 struct drm_ioctl_desc {
 	unsigned int cmd;
