Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab0BSRAx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:00:53 -0500
Received: from kroah.org ([198.145.64.141]:57645 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754865Ab0BSRAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:00:48 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Feb 19 08:32:45 2010
Message-Id: <20100219163245.439502654@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 19 Feb 2010 08:29:46 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Zhenyu Wang <zhenyuw@linux.intel.com>, Eric Anholt <eric@anholt.net>
Subject: [53/93] drm/i915: Dont wait interruptible for possible plane buffer flush
In-Reply-To: <20100219165717.GA15002@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Zhenyu Wang <zhenyuw@linux.intel.com>

commit b9241ea31fae4887104e5d1b3b18f4009c25a0c4 upstream.

When we setup buffer for display plane, we'll check any pending
required GPU flush and possible make interruptible wait for flush
complete. But that wait would be most possibly to fail in case of
signals received for X process, which will then fail modeset process
and put display engine in unconsistent state. The result could be
blank screen or CPU hang, and DDX driver would always turn on outputs
DPMS after whatever modeset fails or not.

So this one creates new helper for setup display plane buffer, and
when needing flush using uninterruptible wait for that.

This one should fix bug like https://bugs.freedesktop.org/show_bug.cgi?id=24009.
Also fixing mode switch stress test on Ironlake.

Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_drv.h      |    1 
 drivers/gpu/drm/i915/i915_gem.c      |   51 +++++++++++++++++++++++++++++++++++
 drivers/gpu/drm/i915/intel_display.c |    2 -
 3 files changed, 53 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -829,6 +829,7 @@ int i915_lp_ring_sync(struct drm_device
 int i915_gem_fault(struct vm_area_struct *vma, struct vm_fault *vmf);
 int i915_gem_object_set_to_gtt_domain(struct drm_gem_object *obj,
 				      int write);
+int i915_gem_object_set_to_display_plane(struct drm_gem_object *obj);
 int i915_gem_attach_phys_object(struct drm_device *dev,
 				struct drm_gem_object *obj, int id);
 void i915_gem_detach_phys_object(struct drm_device *dev,
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -2825,6 +2825,57 @@ i915_gem_object_set_to_gtt_domain(struct
 	return 0;
 }
 
+/*
+ * Prepare buffer for display plane. Use uninterruptible for possible flush
+ * wait, as in modesetting process we're not supposed to be interrupted.
+ */
+int
+i915_gem_object_set_to_display_plane(struct drm_gem_object *obj)
+{
+	struct drm_device *dev = obj->dev;
+	struct drm_i915_gem_object *obj_priv = obj->driver_private;
+	uint32_t old_write_domain, old_read_domains;
+	int ret;
+
+	/* Not valid to be called on unbound objects. */
+	if (obj_priv->gtt_space == NULL)
+		return -EINVAL;
+
+	i915_gem_object_flush_gpu_write_domain(obj);
+
+	/* Wait on any GPU rendering and flushing to occur. */
+	if (obj_priv->active) {
+#if WATCH_BUF
+		DRM_INFO("%s: object %p wait for seqno %08x\n",
+			  __func__, obj, obj_priv->last_rendering_seqno);
+#endif
+		ret = i915_do_wait_request(dev, obj_priv->last_rendering_seqno, 0);
+		if (ret != 0)
+			return ret;
+	}
+
+	old_write_domain = obj->write_domain;
+	old_read_domains = obj->read_domains;
+
+	obj->read_domains &= I915_GEM_DOMAIN_GTT;
+
+	i915_gem_object_flush_cpu_write_domain(obj);
+
+	/* It should now be out of any other write domains, and we can update
+	 * the domain values for our changes.
+	 */
+	BUG_ON((obj->write_domain & ~I915_GEM_DOMAIN_GTT) != 0);
+	obj->read_domains |= I915_GEM_DOMAIN_GTT;
+	obj->write_domain = I915_GEM_DOMAIN_GTT;
+	obj_priv->dirty = 1;
+
+	trace_i915_gem_object_change_domain(obj,
+					    old_read_domains,
+					    old_write_domain);
+
+	return 0;
+}
+
 /**
  * Moves a single object to the CPU read, and possibly write domain.
  *
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -1253,7 +1253,7 @@ intel_pipe_set_base(struct drm_crtc *crt
 		return ret;
 	}
 
-	ret = i915_gem_object_set_to_gtt_domain(obj, 1);
+	ret = i915_gem_object_set_to_display_plane(obj);
 	if (ret != 0) {
 		i915_gem_object_unpin(obj);
 		mutex_unlock(&dev->struct_mutex);


