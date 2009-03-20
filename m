Return-Path: <linux-kernel-owner+w=401wt.eu-S1764501AbZCTXkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764501AbZCTXkv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 19:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763020AbZCTXZC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 19:25:02 -0400
Received: from kroah.org ([198.145.64.141]:48878 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762993AbZCTXY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 19:24:59 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 20 15:29:29 2009
Message-Id: <20090320222929.545390755@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 20 Mar 2009 15:28:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Eric Anholt <eric@anholt.net>,
       Dave Airlie <airlied@linux.ie>
Subject: [patch 42/43] drm/i915: Dont allow objects to get bound while VT switched.
References: <20090320222810.386844059@mini.kroah.org>
Content-Disposition: inline; filename=drm-i915-don-t-allow-objects-to-get-bound-while-vt-switched.patch
In-Reply-To: <20090320232116.GA3375@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Anholt <eric@anholt.net>

commit 9bb2d6f94aeb9a185d69aedbd19421b6da4e3309 upstream.

This avoids a BUG_ON in the enter_vt path due to objects being in the GTT
when we shouldn't have ever let them be (as we're not supposed to touch the
device during that time).

This was triggered by a change in the 2D driver to use the GTT mapping of
objects after pinning them to improve software fallback performance.

Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Dave Airlie <airlied@linux.ie>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_gem.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -1161,6 +1161,8 @@ i915_gem_object_bind_to_gtt(struct drm_g
 	struct drm_mm_node *free_space;
 	int page_count, ret;
 
+	if (dev_priv->mm.suspended)
+		return -EBUSY;
 	if (alignment == 0)
 		alignment = PAGE_SIZE;
 	if (alignment & (PAGE_SIZE - 1)) {
@@ -2180,7 +2182,7 @@ i915_gem_object_pin(struct drm_gem_objec
 	if (obj_priv->gtt_space == NULL) {
 		ret = i915_gem_object_bind_to_gtt(obj, alignment);
 		if (ret != 0) {
-			if (ret != -ERESTARTSYS)
+			if (ret != -EBUSY && ret != -ERESTARTSYS)
 				DRM_ERROR("Failure to bind: %d", ret);
 			return ret;
 		}
@@ -2703,20 +2705,21 @@ i915_gem_entervt_ioctl(struct drm_device
 		dev_priv->mm.wedged = 0;
 	}
 
-	ret = i915_gem_init_ringbuffer(dev);
-	if (ret != 0)
-		return ret;
-
 	dev_priv->mm.gtt_mapping = io_mapping_create_wc(dev->agp->base,
 							dev->agp->agp_info.aper_size
 							* 1024 * 1024);
 
 	mutex_lock(&dev->struct_mutex);
+	dev_priv->mm.suspended = 0;
+
+	ret = i915_gem_init_ringbuffer(dev);
+	if (ret != 0)
+		return ret;
+
 	BUG_ON(!list_empty(&dev_priv->mm.active_list));
 	BUG_ON(!list_empty(&dev_priv->mm.flushing_list));
 	BUG_ON(!list_empty(&dev_priv->mm.inactive_list));
 	BUG_ON(!list_empty(&dev_priv->mm.request_list));
-	dev_priv->mm.suspended = 0;
 	mutex_unlock(&dev->struct_mutex);
 
 	drm_irq_install(dev);


