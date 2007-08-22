Return-Path: <linux-kernel-owner+w=401wt.eu-S1760769AbXHVI5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760769AbXHVI5a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 04:57:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756936AbXHVIwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 04:52:54 -0400
Received: from 1wt.eu ([62.212.114.60]:1954 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758038AbXHVIww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 04:52:52 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070822084001.%N@1wt.eu>
References: <20070822083844.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Wed, 22 Aug 2007 11:39:03 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Dave Airlie <airlied@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Willy Tarreau <w@1wt.eu>
Subject: [2.6.20.17 review 19/58] drm/i915: Fix i965 secured batchbuffer usage (CVE-2007-3851)
Content-Disposition: inline; filename=0019-drm-i915-Fix-i965-secured-batchbuffer-usage-CVE-20.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This 965G and above chipsets moved the batch buffer non-secure bits to
another place. This means that previous drm's allowed in-secure batchbuffers
to be submitted to the hardware from non-privileged users who are logged
into X and and have access to direct rendering.

Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/char/drm/i915_dma.c |   14 +++++++++++---
 drivers/char/drm/i915_drv.h |    1 +
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/char/drm/i915_dma.c b/drivers/char/drm/i915_dma.c
index 9354ce3..ab1a1d0 100644
--- a/drivers/char/drm/i915_dma.c
+++ b/drivers/char/drm/i915_dma.c
@@ -172,6 +172,8 @@ static int i915_initialize(drm_device_t * dev,
 	 * private backbuffer/depthbuffer usage.
 	 */
 	dev_priv->use_mi_batchbuffer_start = 0;
+	if (IS_I965G(dev)) /* 965 doesn't support older method */
+		dev_priv->use_mi_batchbuffer_start = 1;
 
 	/* Allow hardware batchbuffers unless told otherwise.
 	 */
@@ -504,8 +506,13 @@ static int i915_dispatch_batchbuffer(drm_device_t * dev,
 
 		if (dev_priv->use_mi_batchbuffer_start) {
 			BEGIN_LP_RING(2);
-			OUT_RING(MI_BATCH_BUFFER_START | (2 << 6));
-			OUT_RING(batch->start | MI_BATCH_NON_SECURE);
+			if (IS_I965G(dev)) {
+				OUT_RING(MI_BATCH_BUFFER_START | (2 << 6) | MI_BATCH_NON_SECURE_I965);
+				OUT_RING(batch->start);
+			} else {
+				OUT_RING(MI_BATCH_BUFFER_START | (2 << 6));
+				OUT_RING(batch->start | MI_BATCH_NON_SECURE);
+			}
 			ADVANCE_LP_RING();
 		} else {
 			BEGIN_LP_RING(4);
@@ -722,7 +729,8 @@ static int i915_setparam(DRM_IOCTL_ARGS)
 
 	switch (param.param) {
 	case I915_SETPARAM_USE_MI_BATCHBUFFER_START:
-		dev_priv->use_mi_batchbuffer_start = param.value;
+		if (!IS_I965G(dev))
+			dev_priv->use_mi_batchbuffer_start = param.value;
 		break;
 	case I915_SETPARAM_TEX_LRU_LOG_GRANULARITY:
 		dev_priv->tex_lru_log_granularity = param.value;
diff --git a/drivers/char/drm/i915_drv.h b/drivers/char/drm/i915_drv.h
index 93cdcfe..30022c8 100644
--- a/drivers/char/drm/i915_drv.h
+++ b/drivers/char/drm/i915_drv.h
@@ -280,6 +280,7 @@ extern int i915_wait_ring(drm_device_t * dev, int n, const char *caller);
 #define MI_BATCH_BUFFER_START 	(0x31<<23)
 #define MI_BATCH_BUFFER_END 	(0xA<<23)
 #define MI_BATCH_NON_SECURE	(1)
+#define MI_BATCH_NON_SECURE_I965 (1<<8)
 
 #define MI_WAIT_FOR_EVENT       ((0x3<<23))
 #define MI_WAIT_FOR_PLANE_A_FLIP      (1<<2)
-- 
1.5.2.5

-- 
