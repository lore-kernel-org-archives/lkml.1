Return-Path: <linux-kernel-owner+w=401wt.eu-S1754742AbZGSP05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742AbZGSP05 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 11:26:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754634AbZGSP0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 11:26:34 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:47114 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754673AbZGSP0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 11:26:20 -0400
Date: Sun, 19 Jul 2009 17:25:52 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: airlied@linux.ie, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 2/10] drivers/gpu/drm: Move a dereference below a NULL test
Message-ID: <Pine.LNX.4.64.0907191725290.16542@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

If the NULL test is necessary, then the dereference should be moved below
the NULL test.

In the case of drivers/gpu/drm/i915/i915_drv.c, the variable dev_priv
whose initialization causes the problem is never used in the function, so
it is dropped.

Dropped some extra braces in drivers/gpu/drm/radeon/radeon_device.c

A simplified version of the semantic patch that makes this change is as
follows: (http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
type T;
expression E,E1;
identifier i,fld;
statement S;
@@

- T i = E->fld;
+ T i;
  ... when != E=E1
      when != i
  if (E == NULL||...) S
+ i = E->fld;
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/gpu/drm/drm_stub.c             |    3 ++-
 drivers/gpu/drm/i915/i915_drv.c        |    7 +++----
 drivers/gpu/drm/radeon/radeon_device.c |   12 +++++-------
 3 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/drm_stub.c b/drivers/gpu/drm/drm_stub.c
index 155a5bb..55bb8a8 100644
--- a/drivers/gpu/drm/drm_stub.c
+++ b/drivers/gpu/drm/drm_stub.c
@@ -489,7 +489,7 @@ int drm_put_minor(struct drm_minor **minor_p)
  */
 void drm_put_dev(struct drm_device *dev)
 {
-	struct drm_driver *driver = dev->driver;
+	struct drm_driver *driver;
 	struct drm_map_list *r_list, *list_temp;
 
 	DRM_DEBUG("\n");
@@ -498,6 +498,7 @@ void drm_put_dev(struct drm_device *dev)
 		DRM_ERROR("cleanup called no dev\n");
 		return;
 	}
+	driver = dev->driver;
 
 	drm_vblank_cleanup(dev);
 
diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
index fc4b68a..726b241 100644
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -55,10 +55,9 @@ MODULE_DEVICE_TABLE(pci, pciidlist);
 
 static int i915_suspend(struct drm_device *dev, pm_message_t state)
 {
-	struct drm_i915_private *dev_priv = dev->dev_private;
-
-	if (!dev || !dev_priv) {
-		DRM_ERROR("dev: %p, dev_priv: %p\n", dev, dev_priv);
+	if (!dev || !dev->dev_private) {
+		DRM_ERROR("dev: %p, dev_priv: %p\n",
+				dev, dev ? dev->dev_private : NULL);
 		DRM_ERROR("DRM not initialized, aborting suspend.\n");
 		return -ENODEV;
 	}
diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index f97563d..a9571a4 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -671,23 +671,21 @@ void radeon_device_fini(struct radeon_device *rdev)
  */
 int radeon_suspend_kms(struct drm_device *dev, pm_message_t state)
 {
-	struct radeon_device *rdev = dev->dev_private;
+	struct radeon_device *rdev;
 	struct drm_crtc *crtc;
 
-	if (dev == NULL || rdev == NULL) {
+	if (dev == NULL || dev->dev_private == NULL)
 		return -ENODEV;
-	}
-	if (state.event == PM_EVENT_PRETHAW) {
+	rdev = dev->dev_private;
+	if (state.event == PM_EVENT_PRETHAW)
 		return 0;
-	}
 	/* unpin the front buffers */
 	list_for_each_entry(crtc, &dev->mode_config.crtc_list, head) {
 		struct radeon_framebuffer *rfb = to_radeon_framebuffer(crtc->fb);
 		struct radeon_object *robj;
 
-		if (rfb == NULL || rfb->obj == NULL) {
+		if (rfb == NULL || rfb->obj == NULL)
 			continue;
-		}
 		robj = rfb->obj->driver_private;
 		if (robj != rdev->fbdev_robj) {
 			radeon_object_unpin(robj);
