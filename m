Return-Path: <linux-kernel-owner+w=401wt.eu-S1754474Ab0A0LPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474Ab0A0LPq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 06:15:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754459Ab0A0LPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 06:15:45 -0500
Received: from mga06.intel.com ([134.134.136.21]:54886 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754453Ab0A0LPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 06:15:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,352,1262592000"; 
   d="scan'208";a="487433209"
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Roman Jarosz <kedgedev@gmail.com>,
       A Rojas <nqn1976list@gmail.com>,
       "A. Boulan" <arnaud.boulan@libertysurf.fr>, michael@reinelt.co.at,
       jcnengel@googlemail.com, rientjes@google.com, earny@net4u.de,
       linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
       Chris Wilson <chris@chris-wilson.co.uk>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>,
       stable@kernel.org
Subject: [PATCH] drm/i915: Selectively enable self-reclaim
Date: Wed, 27 Jan 2010 11:14:04 +0000
Message-Id: <1264590844-22972-1-git-send-email-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <alpine.LFD.2.00.1001270252290.24253@localhost.localdomain>
References: <alpine.LFD.2.00.1001270252290.24253@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Having missed the ENOMEM return via i915_gem_fault(), there are probably
other paths that I also missed. By not enabling NORETRY by default these
paths can run the shrinker and take memory from the system (but not from
our own inactive lists because our shrinker can not run whilst we hold
the struct mutex) and this may allow the system to survive a little longer
whilst our drivers consume all available memory.

References:
  OOM killer unexpectedly called with kernel 2.6.32
  http://bugzilla.kernel.org/show_bug.cgi?id=14933

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Eric Anholt <eric@anholt.net>
Cc: stable@kernel.org
---
 drivers/gpu/drm/drm_gem.c       |   13 -------------
 drivers/gpu/drm/i915/i915_gem.c |   22 ++++++++++------------
 2 files changed, 10 insertions(+), 25 deletions(-)

diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
index e9dbb48..8bf3770 100644
--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -142,19 +142,6 @@ drm_gem_object_alloc(struct drm_device *dev, size_t size)
 	if (IS_ERR(obj->filp))
 		goto free;
 
-	/* Basically we want to disable the OOM killer and handle ENOMEM
-	 * ourselves by sacrificing pages from cached buffers.
-	 * XXX shmem_file_[gs]et_gfp_mask()
-	 */
-	mapping_set_gfp_mask(obj->filp->f_path.dentry->d_inode->i_mapping,
-			     GFP_HIGHUSER |
-			     __GFP_COLD |
-			     __GFP_FS |
-			     __GFP_RECLAIMABLE |
-			     __GFP_NORETRY |
-			     __GFP_NOWARN |
-			     __GFP_NOMEMALLOC);
-
 	kref_init(&obj->refcount);
 	kref_init(&obj->handlecount);
 	obj->size = size;
diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 28b8f03..1ef5b54 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -336,25 +336,25 @@ i915_gem_object_set_page_gfp_mask (struct drm_gem_object *obj, gfp_t gfp)
 static int
 i915_gem_object_get_pages_or_evict(struct drm_gem_object *obj)
 {
+	gfp_t gfp;
 	int ret;
 
+	gfp = i915_gem_object_get_page_gfp_mask(obj);
+	i915_gem_object_set_page_gfp_mask(obj, gfp | __GFP_NORETRY | __GFP_NOWARN);
 	ret = i915_gem_object_get_pages(obj);
+	i915_gem_object_set_page_gfp_mask (obj, gfp);
 
 	/* If we've insufficient memory to map in the pages, attempt
 	 * to make some space by throwing out some old buffers.
 	 */
 	if (ret == -ENOMEM) {
 		struct drm_device *dev = obj->dev;
-		gfp_t gfp;
 
 		ret = i915_gem_evict_something(dev, obj->size);
 		if (ret)
 			return ret;
 
-		gfp = i915_gem_object_get_page_gfp_mask(obj);
-		i915_gem_object_set_page_gfp_mask(obj, gfp & ~__GFP_NORETRY);
 		ret = i915_gem_object_get_pages(obj);
-		i915_gem_object_set_page_gfp_mask (obj, gfp);
 	}
 
 	return ret;
@@ -2580,6 +2580,7 @@ i915_gem_object_bind_to_gtt(struct drm_gem_object *obj, unsigned alignment)
 	struct drm_i915_gem_object *obj_priv = obj->driver_private;
 	struct drm_mm_node *free_space;
 	bool retry_alloc = false;
+	gfp_t gfp;
 	int ret;
 
 	if (obj_priv->madv != I915_MADV_WILLNEED) {
@@ -2623,15 +2624,12 @@ i915_gem_object_bind_to_gtt(struct drm_gem_object *obj, unsigned alignment)
 	DRM_INFO("Binding object of size %zd at 0x%08x\n",
 		 obj->size, obj_priv->gtt_offset);
 #endif
-	if (retry_alloc) {
-		i915_gem_object_set_page_gfp_mask (obj,
-						   i915_gem_object_get_page_gfp_mask (obj) & ~__GFP_NORETRY);
-	}
+	gfp = i915_gem_object_get_page_gfp_mask(obj);
+	if (! retry_alloc)
+		i915_gem_object_set_page_gfp_mask (obj, gfp | __GFP_NORETRY | __GFP_NOWARN);
 	ret = i915_gem_object_get_pages(obj);
-	if (retry_alloc) {
-		i915_gem_object_set_page_gfp_mask (obj,
-						   i915_gem_object_get_page_gfp_mask (obj) | __GFP_NORETRY);
-	}
+	i915_gem_object_set_page_gfp_mask (obj, gfp);
+
 	if (ret) {
 		drm_mm_put_block(obj_priv->gtt_space);
 		obj_priv->gtt_space = NULL;
-- 
1.6.6

