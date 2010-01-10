Return-Path: <linux-kernel-owner+w=401wt.eu-S1752741Ab0AJIxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741Ab0AJIxQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 03:53:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752479Ab0AJIxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 03:53:15 -0500
Received: from smtp.mujha-vel.cz ([81.30.225.246]:55063 "EHLO
	smtp.mujha-vel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417Ab0AJIxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 03:53:15 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: airlied@linux.ie
Cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       jirislaby@gmail.com
Subject: [PATCH] GPU: drm/i915, fix potential null dereference
Date: Sun, 10 Jan 2010 09:53:13 +0100
Message-Id: <1263113593-6786-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.5.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanse found a potential null dereference in i915_suspend.
There is a check for dev and dev_priv being NULL, but dev is
dereferenced earlier. Move the dereference after the check.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/i915/i915_drv.c |   18 +++++++++++++-----
 1 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
index 2ffffd7..6fc4473 100644
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -173,12 +173,17 @@ MODULE_DEVICE_TABLE(pci, pciidlist);
 
 static int i915_suspend(struct drm_device *dev, pm_message_t state)
 {
-	struct drm_i915_private *dev_priv = dev->dev_private;
+	struct drm_i915_private *dev_priv;
 
-	if (!dev || !dev_priv) {
-		DRM_ERROR("dev: %p, dev_priv: %p\n", dev, dev_priv);
-		DRM_ERROR("DRM not initialized, aborting suspend.\n");
-		return -ENODEV;
+	if (!dev) {
+		DRM_ERROR("dev: %p\n", dev);
+		goto abort;
+	}
+
+	dev_priv = dev->dev_private;
+	if (!dev_priv) {
+		DRM_ERROR("dev_priv: %p\n", dev_priv);
+		goto abort;
 	}
 
 	if (state.event == PM_EVENT_PRETHAW)
@@ -208,6 +213,9 @@ static int i915_suspend(struct drm_device *dev, pm_message_t state)
 	dev_priv->modeset_on_lid = 0;
 
 	return 0;
+abort:
+	DRM_ERROR("DRM not initialized, aborting suspend.\n");
+	return -ENODEV;
 }
 
 static int i915_resume(struct drm_device *dev)
-- 
1.6.5.7

