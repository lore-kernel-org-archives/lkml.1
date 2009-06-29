Return-Path: <linux-kernel-owner+w=401wt.eu-S1756154AbZF2H6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154AbZF2H6S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 03:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753061AbZF2H6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 03:58:11 -0400
Received: from ev1s-66-98-244-53.theplanet.com ([66.98.244.53]:4286 "EHLO
	relay.fireflyinternet.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753006AbZF2H6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 03:58:10 -0400
Subject: Re: [git pull] drm: previous pull req + 1.
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net, Eric Anholt <eric@anholt.net>
In-Reply-To: <1245694171.6673.5.camel@localhost>
References: <alpine.DEB.2.00.0906200619520.27130@skynet.skynet.ie>
	 <1245542690.6104.6.camel@localhost>
	 <alpine.LFD.2.01.0906201741290.3119@localhost.localdomain>
	 <1245595658.4805.17.camel@localhost>  <1245619456.4937.35.camel@tiger>
	 <1245694171.6673.5.camel@localhost>
Content-Type: text/plain
Date: Mon, 29 Jun 2009 08:57:51 +0100
Message-Id: <1246262271.25462.32.camel@tiger>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: 78.156.66.37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-22 at 21:09 +0300, Maxim Levitsky wrote:
> Nope, same thing.
> 
> I use commit 87ef92092fd092936535ba057ee19b97bb6a709a + this patch
> Note that GE doesn't hang the system when maximizing it.
> 
> It is for sure tiled textures accessed incorrectly, same behavior
> observed in many games (they still run though)

Sorry for the delay, I was travelling last week and was sure I had
nailed the problem. Aside from the missing flush on i965 when a batch
buffer might be using fenced commands, the only other issue I found was
that we did not zap the mapping range on clear - which could also cause
tiling errors if textures were being written via a GTT mmap.

So please can you try this patch:

>From 20b7c9322914213bb589035afbbc03faf1ae3bf0 Mon Sep 17 00:00:00 2001
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
 drivers/gpu/drm/i915/i915_gem.c |   41 ++++++++++++++++++--------------------
 1 files changed, 19 insertions(+), 22 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 685a876..6dc74c8 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -1946,12 +1946,6 @@ i915_gem_object_unbind(struct drm_gem_object *obj)
 		obj_priv->agp_mem = NULL;
 	}
 
-
-	/* blow away mappings if mapped through GTT */
-	if (obj_priv->mmap_offset && dev->dev_mapping)
-		unmap_mapping_range(dev->dev_mapping,
-				    obj_priv->mmap_offset, obj->size, 1);
-
 	i915_gem_object_put_pages(obj);
 	BUG_ON(obj_priv->pages);
 
@@ -2350,8 +2344,7 @@ try_again:
 			if (old_obj_priv->pin_count)
 				continue;
 
-			/* i915 uses fences for GPU access to tiled buffers */
-			if (IS_I965G(dev) || !old_obj_priv->active)
+			if (!old_obj_priv->active)
 				break;
 
 			/* find the seqno of the first available fence */
@@ -2440,6 +2433,8 @@ i915_gem_clear_fence_reg(struct drm_gem_object *obj)
 		 obj_priv->gtt_offset, obj->size);
 #endif
 
+	BUG_ON(obj_priv->active);
+
 	if (IS_I965G(dev))
 		I915_WRITE64(FENCE_REG_965_0 + (obj_priv->fence_reg * 8), 0);
 	else {
@@ -2456,6 +2451,11 @@ i915_gem_clear_fence_reg(struct drm_gem_object *obj)
 
 	dev_priv->fence_regs[obj_priv->fence_reg].obj = NULL;
 	obj_priv->fence_reg = I915_FENCE_REG_NONE;
+
+	/* blow away mappings if mapped through GTT */
+	if (obj_priv->mmap_offset && dev->dev_mapping)
+		unmap_mapping_range(dev->dev_mapping,
+				    obj_priv->mmap_offset, obj->size, 1);
 }
 
 /**
@@ -2469,27 +2469,24 @@ i915_gem_clear_fence_reg(struct drm_gem_object *obj)
 int
 i915_gem_object_put_fence_reg(struct drm_gem_object *obj)
 {
-	struct drm_device *dev = obj->dev;
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
-
-		i915_gem_object_flush_gpu_write_domain(obj);
-		i915_gem_object_flush_gtt_write_domain(obj);
-		ret = i915_gem_object_wait_rendering(obj);
-		if (ret != 0)
-			return ret;
-	}
+	i915_gem_object_flush_gpu_write_domain(obj);
+	i915_gem_object_flush_gtt_write_domain(obj);
+	ret = i915_gem_object_wait_rendering(obj);
+	if (ret != 0)
+		return ret;
 
-	i915_gem_clear_fence_reg (obj);
+	i915_gem_clear_fence_reg(obj);
 
 	return 0;
 }
-- 
1.6.3.1



