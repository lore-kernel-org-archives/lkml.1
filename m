Return-Path: <linux-kernel-owner+w=401wt.eu-S1755021AbZF3KJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021AbZF3KJd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 06:09:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303AbZF3KI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 06:08:58 -0400
Received: from smtp.fireflyuk.net ([78.156.72.235]:1648 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752953AbZF3KI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 06:08:57 -0400
X-Greylist: delayed 1119 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Jun 2009 06:08:56 EDT
Subject: Re: [git pull] drm: previous pull req + 1.
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Dave Airlie <airlied@linux.ie>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net,
       Eric Anholt <eric@anholt.net>
In-Reply-To: <1246262271.25462.32.camel@tiger>
References: <alpine.DEB.2.00.0906200619520.27130@skynet.skynet.ie>
	 <1245542690.6104.6.camel@localhost>
	 <alpine.LFD.2.01.0906201741290.3119@localhost.localdomain>
	 <1245595658.4805.17.camel@localhost> <1245619456.4937.35.camel@tiger>
	 <1245694171.6673.5.camel@localhost>  <1246262271.25462.32.camel@tiger>
Content-Type: text/plain
Date: Tue, 30 Jun 2009 10:49:43 +0100
Message-Id: <1246355383.25462.40.camel@tiger>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: 78.156.66.37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Revised patch, unmap_mapping_range() on unbind and clear register.

>From 8f13b6389ee0c8a39a2073279928a3a228bd27dc Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris@chris-wilson.co.uk>
Date: Mon, 29 Jun 2009 08:45:31 +0100
Subject: [PATCH] drm/i915: Remove mappings on clearing fence register

As the fence register is not locked whilst the user has mmaped the buffer
through the GTT, in order for the buffer to reacquire a fence register we
need to cause a fresh page-fault on the next user access. In order to
cause the page fault, we zap the current mapping on clearing the register.
We also ensure that all potential outstanding access via the fence
register is flushed before release as well.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
---
 drivers/gpu/drm/i915/i915_gem.c |   35 +++++++++++++++++++----------------
 1 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 685a876..7fb636b 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -1946,8 +1946,7 @@ i915_gem_object_unbind(struct drm_gem_object *obj)
 		obj_priv->agp_mem = NULL;
 	}
 
-
-	/* blow away mappings if mapped through GTT */
+	/* Force the next mmap access to trigger a fault and rebind */
 	if (obj_priv->mmap_offset && dev->dev_mapping)
 		unmap_mapping_range(dev->dev_mapping,
 				    obj_priv->mmap_offset, obj->size, 1);
@@ -2350,8 +2349,7 @@ try_again:
 			if (old_obj_priv->pin_count)
 				continue;
 
-			/* i915 uses fences for GPU access to tiled buffers */
-			if (IS_I965G(dev) || !old_obj_priv->active)
+			if (!old_obj_priv->active)
 				break;
 
 			/* find the seqno of the first available fence */
@@ -2440,6 +2438,8 @@ i915_gem_clear_fence_reg(struct drm_gem_object *obj)
 		 obj_priv->gtt_offset, obj->size);
 #endif
 
+	BUG_ON(obj_priv->active);
+
 	if (IS_I965G(dev))
 		I915_WRITE64(FENCE_REG_965_0 + (obj_priv->fence_reg * 8), 0);
 	else {
@@ -2471,25 +2471,28 @@ i915_gem_object_put_fence_reg(struct drm_gem_object *obj)
 {
 	struct drm_device *dev = obj->dev;
 	struct drm_i915_gem_object *obj_priv = obj->driver_private;
+	int ret;
 
 	if (obj_priv->fence_reg == I915_FENCE_REG_NONE)
 		return 0;
 
-	/* On the i915, GPU access to tiled buffers is via a fence,
-	 * therefore we must wait for any outstanding access to complete
-	 * before clearing the fence.
+	/* If there is outstanding activity on the buffer whilst it holds
+	 * a fence register we must assume that it requires that fence for
+	 * correct operation. Therefore we must wait for any outstanding
+	 * access to complete before clearing the fence.
 	 */
-	if (!IS_I965G(dev)) {
-		int ret;
+	i915_gem_object_flush_gpu_write_domain(obj);
+	i915_gem_object_flush_gtt_write_domain(obj);
+	ret = i915_gem_object_wait_rendering(obj);
+	if (ret != 0)
+		return ret;
 
-		i915_gem_object_flush_gpu_write_domain(obj);
-		i915_gem_object_flush_gtt_write_domain(obj);
-		ret = i915_gem_object_wait_rendering(obj);
-		if (ret != 0)
-			return ret;
-	}
+	i915_gem_clear_fence_reg(obj);
 
-	i915_gem_clear_fence_reg (obj);
+	/* Reacquire fence register on next mmap access (via page fault) */
+	if (obj_priv->mmap_offset)
+		unmap_mapping_range(dev->dev_mapping,
+				    obj_priv->mmap_offset, obj->size, 1);
 
 	return 0;
 }
-- 
1.6.3.3



