Return-Path: <linux-kernel-owner+w=401wt.eu-S1757623Ab0ANWi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757623Ab0ANWi0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 17:38:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753863Ab0ANWiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 17:38:21 -0500
Received: from kroah.org ([198.145.64.141]:60537 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753065Ab0ANW21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 17:28:27 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Daniel Vetter <daniel.vetter@ffwll.ch>, Eric Anholt <eric@anholt.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 13/52] drm/i915: fix order of fence release wrt flushing
Date: Thu, 14 Jan 2010 14:26:52 -0800
Message-Id: <1263508051-7868-13-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1263508051-7868-12-git-send-email-gregkh@suse.de>
References: <20100114222551.GA7839@suse.de>
 <1263508051-7868-1-git-send-email-gregkh@suse.de>
 <1263508051-7868-2-git-send-email-gregkh@suse.de>
 <1263508051-7868-3-git-send-email-gregkh@suse.de>
 <1263508051-7868-4-git-send-email-gregkh@suse.de>
 <1263508051-7868-5-git-send-email-gregkh@suse.de>
 <1263508051-7868-6-git-send-email-gregkh@suse.de>
 <1263508051-7868-7-git-send-email-gregkh@suse.de>
 <1263508051-7868-8-git-send-email-gregkh@suse.de>
 <1263508051-7868-9-git-send-email-gregkh@suse.de>
 <1263508051-7868-10-git-send-email-gregkh@suse.de>
 <1263508051-7868-11-git-send-email-gregkh@suse.de>
 <1263508051-7868-12-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 96b47b65594fe2365f73aede060cb5203561fed3 upstream.

i915_gem_object_unbind had the ordering wrong. The other user,
i915_gem_object_put_fence_reg already has the correct ordering.

Results was usually corrupted pixmaps, especially garbled font glyphs
after a suspend/resume (because this evicts everything).

I'm still waiting for the feedback from the bug-reporters, but
because this obviously fixes a bug (at least for me) I'm already
submitting it.

Bugzilla: http://bugs.freedesktop.org/show_bug.cgi?id=25406
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/gpu/drm/i915/i915_gem.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 5ddbd38..2e10b9a 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -2010,9 +2010,6 @@ i915_gem_object_unbind(struct drm_gem_object *obj)
 	/* blow away mappings if mapped through GTT */
 	i915_gem_release_mmap(obj);
 
-	if (obj_priv->fence_reg != I915_FENCE_REG_NONE)
-		i915_gem_clear_fence_reg(obj);
-
 	/* Move the object to the CPU domain to ensure that
 	 * any possible CPU writes while it's not in the GTT
 	 * are flushed when we go to remap it. This will
@@ -2028,6 +2025,10 @@ i915_gem_object_unbind(struct drm_gem_object *obj)
 
 	BUG_ON(obj_priv->active);
 
+	/* release the fence reg _after_ flushing */
+	if (obj_priv->fence_reg != I915_FENCE_REG_NONE)
+		i915_gem_clear_fence_reg(obj);
+
 	if (obj_priv->agp_mem != NULL) {
 		drm_unbind_agp(obj_priv->agp_mem);
 		drm_free_agp(obj_priv->agp_mem, obj->size / PAGE_SIZE);
-- 
1.6.6

