Return-Path: <linux-kernel-owner+w=401wt.eu-S1758473AbXEQWiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758473AbXEQWiQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 18:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755894AbXEQWiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 18:38:00 -0400
Received: from mga03.intel.com ([143.182.124.21]:24852 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754770AbXEQWh4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 18:37:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,550,1170662400"; 
   d="scan'208";a="229292574"
From: Jesse Barnes <jesse.barnes@intel.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] drm modesetting core
Date: Thu, 17 May 2007 15:37:45 -0700
User-Agent: KMail/1.9.6
Cc: "Antonino A. Daplas" <adaplas@gmail.com>,
       James Simmons <jsimmons@pentafluge.infradead.org>,
       Dave Airlie <airlied@gmail.com>,
       "Jakob Bornecrantz" <wallbraker@gmail.com>,
       dri-devel@lists.sourceforge.net
References: <200705171423.46748.jesse.barnes@intel.com>
In-Reply-To: <200705171423.46748.jesse.barnes@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200705171537.46639.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the core of the new DRM based modesetting system.  It
creates several new structures in the DRM, the primary ones being the
CRTC, which controls all aspects of your device's CRTC(s), output,
which describes and controls the various outputs on your gfx chip (e.g.
TMDS, LVDS, VGA, etc.), and mode, which describes graphics modes in
enough detail for the output and CRTC callbacks to program them to
hardware.

It also contains the user level IOCTL interfaces for doing graphics
programming (getting CRTC, output and mode lists, setting up new
frame buffer objects, etc.).

It relies on the new TTM patch Dave posted recently.

Jesse

diff --git a/linux-core/Makefile.kernel b/linux-core/Makefile.kernel
index 6f5b021..b9684d6 100644
--- a/linux-core/Makefile.kernel
+++ b/linux-core/Makefile.kernel
@@ -13,13 +13,15 @@ drm-objs    := drm_auth.o drm_bufs.o drm_context.o 
drm_dma.o drm_drawable.o \
 		drm_sysfs.o drm_pci.o drm_agpsupport.o drm_scatter.o \
 		drm_memory_debug.o ati_pcigart.o drm_sman.o \
 		drm_hashtab.o drm_mm.o drm_object.o drm_compat.o \
-	        drm_fence.o drm_ttm.o drm_bo.o drm_bo_move.o
+	        drm_fence.o drm_ttm.o drm_bo.o drm_bo_move.o drm_crtc.o \
+		drm_edid.o drm_modes.o drm_fb.o
 tdfx-objs   := tdfx_drv.o
 r128-objs   := r128_drv.o r128_cce.o r128_state.o r128_irq.o
 mga-objs    := mga_drv.o mga_dma.o mga_state.o mga_warp.o mga_irq.o
 i810-objs   := i810_drv.o i810_dma.o
 i915-objs   := i915_drv.o i915_dma.o i915_irq.o i915_mem.o i915_fence.o 
\
-		i915_buffer.o
+		i915_buffer.o intel_display.o intel_crt.o intel_lvds.o \
+		intel_sdvo.o intel_modes.o intel_i2c.o i915_init.o
 nouveau-objs := nouveau_drv.o nouveau_state.o nouveau_fifo.o 
nouveau_mem.o \
 		nouveau_object.o nouveau_irq.o \
 		nv04_timer.o \
diff --git a/linux-core/drmP.h b/linux-core/drmP.h
index a3f9ca8..377f447 100644
--- a/linux-core/drmP.h
+++ b/linux-core/drmP.h
@@ -164,6 +164,8 @@
 
 #include "drm_compat.h"
 
+#include "drm_crtc.h"
+
 /***********************************************************************/
 /** \name Macros to make printk easier */
 /*@{*/
@@ -429,6 +431,8 @@ typedef struct drm_file {
 
 	drm_open_hash_t refd_object_hash[_DRM_NO_REF_TYPES];
 	void *driver_priv;
+
+	struct list_head fbs;
 } drm_file_t;
 
 /** Wait queue */
@@ -831,6 +835,9 @@ typedef struct drm_device {
 	unsigned int drw_info_length;
 	drm_drawable_info_t **drw_info;
 	/*@} */
+
+	/* DRM mode setting */
+	struct drm_mode_config mode_config;
 } drm_device_t;
 
 #if __OS_HAS_AGP
@@ -1128,10 +1135,6 @@ extern drm_head_t **drm_heads;
 extern struct drm_sysfs_class *drm_class;
 extern struct proc_dir_entry *drm_proc_root;
 
-extern drm_local_map_t *drm_getsarea(struct drm_device *dev);
-extern int drm_wait_on(drm_device_t *dev, wait_queue_head_t *queue,
-		       int timeout, int (*fn)(drm_device_t *dev, void *priv),
-		       void *priv);
 				/* Proc support (drm_proc.h) */
 extern int drm_proc_init(drm_device_t * dev,
 			 int minor,
diff --git a/linux-core/drm_bo.c b/linux-core/drm_bo.c
index 1c7013b..27016d8 100644
--- a/linux-core/drm_bo.c
+++ b/linux-core/drm_bo.c
@@ -494,6 +494,7 @@ void drm_bo_usage_deref_locked(drm_buffer_object_t * 
bo)
 		drm_bo_destroy_locked(bo);
 	}
 }
+EXPORT_SYMBOL(drm_bo_usage_deref_locked);
 
 static void drm_bo_base_deref_locked(drm_file_t * priv, 
drm_user_object_t * uo)
 {
@@ -1624,6 +1625,7 @@ int drm_buffer_object_create(drm_device_t *dev,
 	drm_bo_usage_deref_unlocked(bo);
 	return ret;
 }
+EXPORT_SYMBOL(drm_buffer_object_create);
 
 static int drm_bo_add_user_object(drm_file_t * priv, 
drm_buffer_object_t * bo,
 				  int shareable)
@@ -1732,7 +1734,6 @@ int drm_bo_ioctl(DRM_IOCTL_ARGS)
 						      drm_buffer_type, &uo);
 			if (rep.ret)
 				break;
-
 			rep.ret = drm_bo_handle_info(priv, req->handle, &rep);
 			break;
 		case drm_bo_unreference:
@@ -1983,6 +1984,7 @@ int drm_bo_clean_mm(drm_device_t * dev, unsigned 
mem_type)
 
 	return ret;
 }
+EXPORT_SYMBOL(drm_bo_clean_mm);
 
 /**
  *Evict all buffers of a particular mem_type, but leave memory manager
@@ -2115,6 +2117,7 @@ int drm_bo_driver_finish(drm_device_t * dev)
 	mutex_unlock(&dev->bm.init_mutex);
 	return ret;
 }
+EXPORT_SYMBOL(drm_bo_driver_finish);
 
 int drm_bo_driver_init(drm_device_t * dev)
 {
@@ -2306,9 +2309,6 @@ void drm_bo_unmap_virtual(drm_buffer_object_t * 
bo)
 	loff_t offset = ((loff_t) bo->map_list.hash.key) << PAGE_SHIFT;
 	loff_t holelen = ((loff_t) bo->mem.num_pages) << PAGE_SHIFT;
 
-	if (!dev->dev_mapping)
-		return;
-
 	unmap_mapping_range(dev->dev_mapping, offset, holelen, 1);
 }
 
diff --git a/linux-core/drm_bo_move.c b/linux-core/drm_bo_move.c
index 4f75206..eaeef1b 100644
--- a/linux-core/drm_bo_move.c
+++ b/linux-core/drm_bo_move.c
@@ -128,6 +128,7 @@ int drm_mem_reg_ioremap(drm_device_t * dev, 
drm_bo_mem_reg_t * mem,
 	*virtual = addr;
 	return 0;
 }
+EXPORT_SYMBOL(drm_mem_reg_ioremap);
 
 /**
  * \c Unmap mapping obtained using drm_bo_ioremap
@@ -150,6 +151,7 @@ void drm_mem_reg_iounmap(drm_device_t * dev, 
drm_bo_mem_reg_t * mem,
 		iounmap(virtual);
 	}
 }
+EXPORT_SYMBOL(drm_mem_reg_iounmap);
 
 static int drm_copy_io_page(void *dst, void *src, unsigned long page)
 {
diff --git a/linux-core/drm_bufs.c b/linux-core/drm_bufs.c
index 8793ba0..1ba53c8 100644
--- a/linux-core/drm_bufs.c
+++ b/linux-core/drm_bufs.c
@@ -57,7 +57,7 @@ static drm_map_list_t 
*drm_find_matching_map(drm_device_t *dev,
 		drm_map_list_t *entry = list_entry(list, drm_map_list_t, head);
 		if (entry->map && map->type == entry->map->type &&
 		    ((entry->map->offset == map->offset) || 
-		     (map->type == _DRM_SHM && map->flags==_DRM_CONTAINS_LOCK))) {
+		     ((map->type == _DRM_SHM) && (map->flags&_DRM_CONTAINS_LOCK)))) {
 			return entry;
 		}
 	}
@@ -417,6 +417,7 @@ int drm_rmmap_locked(drm_device_t *dev, 
drm_local_map_t *map)
 		break;
 	case _DRM_SHM:
 		vfree(map->handle);
+		dev->sigdata.lock = dev->lock.hw_lock = NULL;   /* SHM removed */
 		break;
 	case _DRM_AGP:
 	case _DRM_SCATTER_GATHER:
diff --git a/linux-core/drm_compat.h b/linux-core/drm_compat.h
index bc5fadc..bada1fd 100644
--- a/linux-core/drm_compat.h
+++ b/linux-core/drm_compat.h
@@ -60,6 +60,13 @@
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,19))
 #undef DRM_IRQ_ARGS
 #define DRM_IRQ_ARGS		int irq, void *arg, struct pt_regs *regs
+
+typedef _Bool bool;
+enum {
+        false   = 0,
+        true    = 1
+};
+
 #endif
 
 #ifndef list_for_each_safe
diff --git a/linux-core/drm_crtc.c b/linux-core/drm_crtc.c
new file mode 100644
index 0000000..16cf62a
--- /dev/null
+++ b/linux-core/drm_crtc.c
@@ -0,0 +1,1652 @@
+/*
+ * Copyright (c) 2006-2007 Intel Corporation
+ * Copyright (c) 2007 Dave Airlie <airlied@linux.ie>
+ *
+ * DRM core CRTC related functions
+ *
+ * Permission to use, copy, modify, distribute, and sell this software 
and its
+ * documentation for any purpose is hereby granted without fee, 
provided that
+ * the above copyright notice appear in all copies and that both that 
copyright
+ * notice and this permission notice appear in supporting 
documentation, and
+ * that the name of the copyright holders not be used in advertising or
+ * publicity pertaining to distribution of the software without 
specific,
+ * written prior permission.  The copyright holders make no 
representations
+ * about the suitability of this software for any purpose.  It is 
provided "as
+ * is" without express or implied warranty.
+ *
+ * THE COPYRIGHT HOLDERS DISCLAIM ALL WARRANTIES WITH REGARD TO THIS 
SOFTWARE,
+ * INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS, IN 
NO
+ * EVENT SHALL THE COPYRIGHT HOLDERS BE LIABLE FOR ANY SPECIAL, 
INDIRECT OR
+ * CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS 
OF USE,
+ * DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR 
OTHER
+ * TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR 
PERFORMANCE
+ * OF THIS SOFTWARE.
+ *
+ * Authors:
+ *      Keith Packard
+ *	Eric Anholt <eric@anholt.net>
+ *      Dave Airlie <airlied@linux.ie>
+ *      Jesse Barnes <jesse.barnes@intel.com>
+ */
+#include <linux/list.h>
+#include "drm.h"
+#include "drmP.h"
+#include "drm_crtc.h"
+
+/**
+ * drm_idr_get - allocate a new identifier
+ * @dev: DRM device
+ * @ptr: object pointer, used to generate unique ID
+ *
+ * LOCKING:
+ * Process context (either init or calling process).  Must take DRM 
mode_config
+ * lock around IDR allocation.
+ *
+ * Create a unique identifier based on @ptr in @dev's identifier space.  
Used
+ * for tracking modes, CRTCs and outputs.
+ *
+ * RETURNS:
+ * New unique (relative to other objects in @dev) integer identifier 
for the
+ * object.
+ */
+int drm_idr_get(struct drm_device *dev, void *ptr)
+{
+	int new_id = 0;
+	int ret;
+again:
+	if (idr_pre_get(&dev->mode_config.crtc_idr, GFP_KERNEL) == 0) {
+		DRM_ERROR("Ran out memory getting a mode number\n");
+		return 0;
+	}
+
+	spin_lock(&dev->mode_config.config_lock);
+
+	ret = idr_get_new_above(&dev->mode_config.crtc_idr, ptr, 1, &new_id);
+	if (ret == -EAGAIN) {
+		spin_unlock(&dev->mode_config.config_lock);
+		goto again;
+	}	
+
+	spin_unlock(&dev->mode_config.config_lock);
+	return new_id;
+}
+
+/**
+ * drm_idr_put - free an identifer
+ * @dev: DRM device
+ * @id: ID to free
+ *
+ * LOCKING:
+ * Caller must hold DRM mode_config lock.
+ *
+ * Free @id from @dev's unique identifier pool.
+ */
+void drm_idr_put(struct drm_device *dev, int id)
+{
+	idr_remove(&dev->mode_config.crtc_idr, id);
+}
+
+/**
+ * drm_framebuffer_create - create a new framebuffer object
+ * @dev: DRM device
+ *
+ * LOCKING:
+ * Process context (either init or calling process).  Must take DRM 
mode_config
+ * lock around mode_config manipulation.
+ *
+ * Creates a new framebuffer objects and adds it to @dev's DRM 
mode_config.
+ *
+ * RETURNS:
+ * Pointer to new framebuffer or NULL on error.
+ */
+struct drm_framebuffer *drm_framebuffer_create(drm_device_t *dev)
+{
+	struct drm_framebuffer *fb;
+
+	spin_lock(&dev->mode_config.config_lock);
+	/* Limit to single framebuffer for now */
+	if (dev->mode_config.num_fb > 1) {
+		spin_unlock(&dev->mode_config.config_lock);
+		DRM_ERROR("Attempt to add multiple framebuffers failed\n");
+		return NULL;
+	}
+	spin_unlock(&dev->mode_config.config_lock);
+
+	fb = kzalloc(sizeof(struct drm_framebuffer), GFP_KERNEL);
+	if (!fb) {
+
+		return NULL;
+	}
+	
+	fb->id = drm_idr_get(dev, fb);
+	fb->dev = dev;
+	spin_lock(&dev->mode_config.config_lock);
+	dev->mode_config.num_fb++;
+	list_add(&fb->head, &dev->mode_config.fb_list);
+	spin_unlock(&dev->mode_config.config_lock);
+
+	return fb;
+}
+EXPORT_SYMBOL(drm_framebuffer_create);
+
+/**
+ * drm_framebuffer_destroy - remove a framebuffer object
+ * @fb: framebuffer to remove
+ *
+ * LOCKING:
+ * Process context (either init or calling process).  Must take DRM 
mode_config
+ * lock around mode_config manipulation.
+ *
+ * Scans all the CRTCs in @dev's mode_config.  If they're using @fb, 
removes
+ * it, setting it to NULL.
+ */
+void drm_framebuffer_destroy(struct drm_framebuffer *fb)
+{
+	drm_device_t *dev = fb->dev;
+	struct drm_crtc *crtc;
+
+	/* remove from any CRTC */
+	spin_lock(&dev->mode_config.config_lock);
+	list_for_each_entry(crtc, &dev->mode_config.crtc_list, head) {
+		if (crtc->fb == fb)
+			crtc->fb = NULL;
+	}
+
+	drm_idr_put(dev, fb->id);
+	list_del(&fb->head);
+	dev->mode_config.num_fb--;
+	spin_unlock(&dev->mode_config.config_lock);
+
+	kfree(fb);
+}
+
+/**
+ * drm_crtc_create - create a new CRTC object
+ * @dev: DRM device
+ * @funcs: callbacks for the new CRTC
+ *
+ * LOCKING:
+ * Process context (either init or calling process).  Must take DRM 
mode_config
+ * lock around mode_config manipulation.
+ *
+ * Creates a new CRTC object and adds it to @dev's mode_config 
structure.
+ *
+ * RETURNS:
+ * Pointer to new CRTC object or NULL on error.
+ */
+struct drm_crtc *drm_crtc_create(drm_device_t *dev,
+				 const struct drm_crtc_funcs *funcs)
+{
+	struct drm_crtc *crtc;
+
+	crtc = kzalloc(sizeof(struct drm_crtc), GFP_KERNEL);
+	if (!crtc)
+		return NULL;
+
+	crtc->dev = dev;
+	crtc->funcs = funcs;
+
+	crtc->id = drm_idr_get(dev, crtc);
+
+	spin_lock(&dev->mode_config.config_lock);
+	list_add_tail(&crtc->head, &dev->mode_config.crtc_list);
+	dev->mode_config.num_crtc++;
+	spin_unlock(&dev->mode_config.config_lock);
+
+	return crtc;
+}
+EXPORT_SYMBOL(drm_crtc_create);
+
+/**
+ * drm_crtc_destroy - remove a CRTC object
+ * @crtc: CRTC to remove
+ *
+ * LOCKING:
+ * Process context (either init or calling process).  Must take DRM 
mode_config
+ * lock around mode_config traversal.
+ *
+ * Cleanup @crtc.  Calls @crtc's cleanup function, then removes @crtc 
from
+ * its associated DRM device's mode_config.  Frees it afterwards.
+ */
+void drm_crtc_destroy(struct drm_crtc *crtc)
+{
+	drm_device_t *dev = crtc->dev;
+
+	if (crtc->funcs->cleanup)
+		(*crtc->funcs->cleanup)(crtc);
+
+	spin_lock(&dev->mode_config.config_lock);
+	drm_idr_put(dev, crtc->id);
+	list_del(&crtc->head);
+	dev->mode_config.num_crtc--;
+	spin_unlock(&dev->mode_config.config_lock);
+	kfree(crtc);
+}
+EXPORT_SYMBOL(drm_crtc_destroy);
+
+/**
+ * drm_crtc_in_use - check if a given CRTC is in a mode_config
+ * @crtc: CRTC to check
+ *
+ * LOCKING:
+ * Caller? (FIXME)
+ *
+ * Walk @crtc's DRM device's mode_config and see if it's in use.
+ *
+ * RETURNS:
+ * True if @crtc is part of the mode_config, false otherwise.
+ */
+bool drm_crtc_in_use(struct drm_crtc *crtc)
+{
+	struct drm_output *output;
+	drm_device_t *dev = crtc->dev;
+	/* FIXME: Locking around list access? */
+	list_for_each_entry(output, &dev->mode_config.output_list, head)
+		if (output->crtc == crtc)
+			return true;
+	return false;
+}
+EXPORT_SYMBOL(drm_crtc_in_use);
+
+/*
+ * Detailed mode info for a standard 640x480@60Hz monitor
+ */
+static struct drm_display_mode std_mode[] = {
+	{ DRM_MODE("640x480", DRM_MODE_TYPE_DRIVER, 25200, 640, 656,
+		   752, 800, 0, 480, 490, 492, 525, 0,
+		   V_NHSYNC | V_NVSYNC) }, /* 640x480@60Hz */
+};
+
+/**
+ * drm_crtc_probe_output_modes - get complete set of display modes
+ * @dev: DRM device
+ * @maxX: max width for modes
+ * @maxY: max height for modes
+ *
+ * LOCKING:
+ * Caller? (FIXME)
+ *
+ * Based on @dev's mode_config layout, scan all the outputs and try to 
detect
+ * modes on them.  Modes will first be added to the output's 
probed_modes
+ * list, then culled (based on validity and the @maxX, @maxY 
parameters) and
+ * put into the normal modes list.
+ *
+ * Intended to be used either at bootup time or when major 
configuration
+ * changes have occurred.
+ *
+ * FIXME: take into account monitor limits
+ */
+void drm_crtc_probe_output_modes(struct drm_device *dev, int maxX, int 
maxY)
+{
+	struct drm_output *output;
+	struct drm_display_mode *mode, *t;
+	int ret;
+	//if (maxX == 0 || maxY == 0) 
+	// TODO
+
+	list_for_each_entry(output, &dev->mode_config.output_list, head) {
+
+		/* set all modes to the unverified state */
+		list_for_each_entry_safe(mode, t, &output->modes, head)
+			mode->status = MODE_UNVERIFIED;
+		
+		output->status = (*output->funcs->detect)(output);
+
+		if (output->status == output_status_disconnected) {
+			DRM_DEBUG("%s is disconnected\n", output->name);
+			/* TODO set EDID to NULL */
+			continue;
+		}
+
+		ret = (*output->funcs->get_modes)(output);
+
+		if (ret) {
+			drm_mode_output_list_update(output);
+		}
+
+		if (maxX && maxY)
+			drm_mode_validate_size(dev, &output->modes, maxX,
+					       maxY, 0);
+		list_for_each_entry_safe(mode, t, &output->modes, head) {
+			if (mode->status == MODE_OK)
+				mode->status = (*output->funcs->mode_valid)(output,mode);
+		}
+		
+
+		drm_mode_prune_invalid(dev, &output->modes, TRUE);
+
+		if (list_empty(&output->modes)) {
+			struct drm_display_mode *stdmode;
+
+			DRM_DEBUG("No valid modes on %s\n", output->name);
+
+			/* Should we do this here ???
+			 * When no valid EDID modes are available we end up
+			 * here and bailed in the past, now we add a standard
+			 * 640x480@60Hz mode and carry on.
+			 */
+			stdmode = drm_mode_duplicate(dev, &std_mode[0]);
+			drm_mode_probed_add(output, stdmode);
+			drm_mode_list_concat(&output->probed_modes,
+					     &output->modes);
+
+			DRM_DEBUG("Adding standard 640x480 @ 60Hz to %s\n",
+								output->name);
+		}
+
+		drm_mode_sort(&output->modes);
+
+		DRM_DEBUG("Probed modes for %s\n", output->name);
+		list_for_each_entry_safe(mode, t, &output->modes, head) {
+			mode->vrefresh = drm_mode_vrefresh(mode);
+
+			drm_mode_set_crtcinfo(mode, CRTC_INTERLACE_HALVE_V);
+			drm_mode_debug_printmodeline(dev, mode);
+		}
+	}
+}
+
+/**
+ * drm_crtc_set_mode - set a mode
+ * @crtc: CRTC to program
+ * @mode: mode to use
+ * @x: width of mode
+ * @y: height of mode
+ *
+ * LOCKING:
+ * Caller? (FIXME)
+ *
+ * Try to set @mode on @crtc.  Give @crtc and its associated outputs a 
chance
+ * to fixup or reject the mode prior to trying to set it.
+ *
+ * RETURNS:
+ * True if the mode was set successfully, or false otherwise.
+ */
+bool drm_crtc_set_mode(struct drm_crtc *crtc, struct drm_display_mode 
*mode,
+		       int x, int y)
+{
+	drm_device_t *dev = crtc->dev;
+	struct drm_display_mode *adjusted_mode, saved_mode;
+	int saved_x, saved_y;
+	bool didLock = false;
+	bool ret = false;
+	struct drm_output *output;
+
+	adjusted_mode = drm_mode_duplicate(dev, mode);
+
+	crtc->enabled = drm_crtc_in_use(crtc);
+
+	if (!crtc->enabled) {
+		return true;
+	}
+
+	didLock = crtc->funcs->lock(crtc);
+
+	saved_mode = crtc->mode;
+	saved_x = crtc->x;
+	saved_y = crtc->y;
+	
+	/* Update crtc values up front so the driver can rely on them for mode
+	 * setting.
+	 */
+	crtc->mode = *mode;
+	crtc->x = x;
+	crtc->y = y;
+
+	/* XXX short-circuit changes to base location only */
+	
+	/* Pass our mode to the outputs and the CRTC to give them a chance to
+	 * adjust it according to limitations or output properties, and also
+	 * a chance to reject the mode entirely.
+	 */
+	list_for_each_entry(output, &dev->mode_config.output_list, head) {
+		
+		if (output->crtc != crtc)
+			continue;
+		
+		if (!output->funcs->mode_fixup(output, mode, adjusted_mode)) {
+			goto done;
+		}
+	}
+	
+	if (!crtc->funcs->mode_fixup(crtc, mode, adjusted_mode)) {
+		goto done;
+	}
+
+	/* Prepare the outputs and CRTCs before setting the mode. */
+	list_for_each_entry(output, &dev->mode_config.output_list, head) {
+
+		if (output->crtc != crtc)
+			continue;
+		
+		/* Disable the output as the first thing we do. */
+		output->funcs->prepare(output);
+	}
+	
+	crtc->funcs->prepare(crtc);
+	
+	/* Set up the DPLL and any output state that needs to adjust or depend
+	 * on the DPLL.
+	 */
+	crtc->funcs->mode_set(crtc, mode, adjusted_mode, x, y);
+	list_for_each_entry(output, &dev->mode_config.output_list, head) {
+		if (output->crtc == crtc)
+			output->funcs->mode_set(output, mode, adjusted_mode);
+	}
+	
+	/* Now, enable the clocks, plane, pipe, and outputs that we set up. */
+	crtc->funcs->commit(crtc);
+	list_for_each_entry(output, &dev->mode_config.output_list, head) {
+		if (output->crtc == crtc) {
+			output->funcs->commit(output);
+#if 0 // TODO def RANDR_12_INTERFACE
+			if (output->randr_output)
+				RRPostPendingProperties (output->randr_output);
+#endif
+		}
+	}
+	
+	/* XXX free adjustedmode */
+	drm_mode_destroy(dev, adjusted_mode);
+	ret = TRUE;
+	/* TODO */
+//	if (scrn->pScreen)
+//		drm_crtc_set_screen_sub_pixel_order(dev);
+
+done:
+	if (!ret) {
+		crtc->x = saved_x;
+		crtc->y = saved_y;
+		crtc->mode = saved_mode;
+	}
+	
+	if (didLock)
+		crtc->funcs->unlock (crtc);
+	
+	return ret;
+}
+
+/**
+ * drm_set_desired_modes - set a good mode on every CRTC & output
+ * @dev: DRM device
+ *
+ * LOCKING:
+ * Caller? (FIXME)
+ *
+ * Each CRTC may have a desired mode associated with it.  This routine 
simply
+ * walks @dev's mode_config and sets the desired mode on every CRTC.  
Intended
+ * for use at startup time.
+ *
+ * RETURNS:
+ * True if modes were set, false otherwise.
+ */
+bool drm_set_desired_modes(struct drm_device *dev)
+{
+	struct drm_crtc *crtc;
+	struct drm_output *output, *list_output;
+
+	list_for_each_entry(crtc, &dev->mode_config.crtc_list, head) {
+		output = NULL;
+
+		list_for_each_entry(list_output, &dev->mode_config.output_list,
+				    head) {
+			if (list_output->crtc == crtc) {
+				output = list_output;
+				break;
+			}
+		}
+		/* Skip disabled crtcs */
+		if (!output) {
+			DRM_DEBUG("skipping disabled crtc\n");
+			continue;
+		}
+
+		if (!drm_crtc_set_mode(crtc, crtc->desired_mode,
+				       crtc->desired_x, crtc->desired_y))
+			return false;
+	}
+
+	drm_disable_unused_functions(dev);
+	return true;
+}
+EXPORT_SYMBOL(drm_set_desired_modes);
+
+/**
+ * drm_disable_unused_functions - disable unused objects
+ * @dev: DRM device
+ *
+ * LOCKING:
+ * Caller? (FIXME)
+ *
+ * If an output or CRTC isn't part of @dev's mode_config, it can be 
disabled
+ * by calling its dpms function, which should power it off.
+ */
+void drm_disable_unused_functions(struct drm_device *dev)
+{
+	struct drm_output *output;
+	struct drm_crtc *crtc;
+
+	list_for_each_entry(output, &dev->mode_config.output_list, head) {
+		if (!output->crtc)
+			(*output->funcs->dpms)(output, DPMSModeOff);
+	}
+
+	list_for_each_entry(crtc, &dev->mode_config.crtc_list, head) {
+		if (!crtc->enabled)
+			crtc->funcs->dpms(crtc, DPMSModeOff);
+	}
+}
+	
+/**
+ * drm_mode_probed_add - add a mode to the specified output's probed 
mode list
+ * @output: output the new mode
+ * @mode: mode data
+ *
+ * LOCKING:
+ * Process context (either init or calling process).  Must take 
@output's
+ * mode_lock around mode list manipulation.
+ * 
+ * Add @mode to @output's mode list for later use.
+ */
+void drm_mode_probed_add(struct drm_output *output,
+			 struct drm_display_mode *mode)
+{
+	spin_lock(&output->modes_lock);
+	list_add(&mode->head, &output->probed_modes);
+	spin_unlock(&output->modes_lock);
+}
+EXPORT_SYMBOL(drm_mode_probed_add);
+
+/**
+ * drm_mode_remove - remove and free a mode
+ * @output: output list to modify
+ * @mode: mode to remove
+ *
+ * LOCKING:
+ * Process context (either init or calling process).  Must take 
@output's
+ * mode_lock around mode list manipulation.
+ * 
+ * Remove @mode from @output's mode list, then free it.
+ */
+void drm_mode_remove(struct drm_output *output, struct drm_display_mode 
*mode)
+{
+	spin_lock(&output->modes_lock);
+	list_del(&mode->head);
+	spin_unlock(&output->modes_lock);
+	kfree(mode);
+}
+EXPORT_SYMBOL(drm_mode_remove);
+
+/**
+ * drm_output_create - create a new output
+ * @dev: DRM device
+ * @funcs: callbacks for this output
+ * @name: user visible name of the output
+ *
+ * LOCKING:
+ * Process context (either init or calling process).  Must take @dev's
+ * mode_config lock around mode list manipulation.
+ *
+ * Creates a new drm_output structure and adds it to @dev's mode_config
+ * structure.
+ *
+ * RETURNS:
+ * Pointer to the new output or NULL on error.
+ */
+struct drm_output *drm_output_create(drm_device_t *dev,
+				     const struct drm_output_funcs *funcs,
+				     const char *name)
+{
+	struct drm_output *output = NULL;
+
+	output = kzalloc(sizeof(struct drm_output), GFP_KERNEL);
+	if (!output)
+		return NULL;
+		
+	output->dev = dev;
+	output->funcs = funcs;
+	output->id = drm_idr_get(dev, output);
+	if (name)
+		strncpy(output->name, name, DRM_OUTPUT_LEN);
+	output->name[DRM_OUTPUT_LEN - 1] = 0;
+	output->subpixel_order = SubPixelUnknown;
+	INIT_LIST_HEAD(&output->probed_modes);
+	INIT_LIST_HEAD(&output->modes);
+	spin_lock_init(&output->modes_lock);
+	/* randr_output? */
+	/* output_set_monitor(output)? */
+	/* check for output_ignored(output)? */
+
+	spin_lock(&dev->mode_config.config_lock);
+	list_add_tail(&output->head, &dev->mode_config.output_list);
+	dev->mode_config.num_output++;
+
+	spin_unlock(&dev->mode_config.config_lock);
+
+	return output;
+
+}
+EXPORT_SYMBOL(drm_output_create);
+
+/**
+ * drm_output_destroy - remove an output
+ * @output: output to remove
+ *
+ * LOCKING:
+ * Process context (either init or calling process).  Must take @dev's
+ * mode_config lock around mode list manipulation.  Caller must hold
+ * modes lock? (FIXME)
+ *
+ * Call @output's cleanup function, then remove the output from the DRM
+ * mode_config after freeing @output's modes.
+ */
+void drm_output_destroy(struct drm_output *output)
+{
+	struct drm_device *dev = output->dev;
+	struct drm_display_mode *mode, *t;
+
+	if (*output->funcs->cleanup)
+		(*output->funcs->cleanup)(output);
+
+	list_for_each_entry_safe(mode, t, &output->probed_modes, head)
+		drm_mode_remove(output, mode);
+
+	list_for_each_entry_safe(mode, t, &output->modes, head)
+		drm_mode_remove(output, mode);
+
+	spin_lock(&dev->mode_config.config_lock);
+	drm_idr_put(dev, output->id);
+	list_del(&output->head);
+	spin_unlock(&dev->mode_config.config_lock);
+	kfree(output);
+}
+EXPORT_SYMBOL(drm_output_destroy);
+
+/**
+ * drm_output_rename - rename an output
+ * @output: output to rename
+ * @name: new user visible name
+ *
+ * LOCKING:
+ * None.
+ *
+ * Simply stuff a new name into @output's name field, based on @name.
+ *
+ * RETURNS:
+ * True if the name was changed, false otherwise.
+ */
+bool drm_output_rename(struct drm_output *output, const char *name)
+{
+	if (!name)
+		return false;
+
+	strncpy(output->name, name, DRM_OUTPUT_LEN);
+	output->name[DRM_OUTPUT_LEN - 1] = 0;
+
+	DRM_DEBUG("Changed name to %s\n", output->name);
+//	drm_output_set_monitor(output);
+//	if (drm_output_ignored(output))
+//		return FALSE;
+
+	return TRUE;
+}
+EXPORT_SYMBOL(drm_output_rename);
+
+/**
+ * drm_mode_create - create a new display mode
+ * @dev: DRM device
+ *
+ * LOCKING:
+ * None.
+ *
+ * Create a new drm_display_mode, give it an ID, and return it.
+ *
+ * RETURNS:
+ * Pointer to new mode on success, NULL on error.
+ */
+struct drm_display_mode *drm_mode_create(struct drm_device *dev)
+{
+	struct drm_display_mode *nmode;
+
+	nmode = kzalloc(sizeof(struct drm_display_mode), GFP_KERNEL);
+	if (!nmode)
+		return NULL;
+
+	nmode->mode_id = drm_idr_get(dev, nmode);
+	return nmode;
+}
+
+/**
+ * drm_mode_destroy - remove a mode
+ * @dev: DRM device
+ * @mode: mode to remove
+ *
+ * LOCKING:
+ * None.
+ *
+ * Free @mode's unique identifier, then free it.
+ */
+void drm_mode_destroy(struct drm_device *dev, struct drm_display_mode 
*mode)
+{
+	drm_idr_put(dev, mode->mode_id);
+
+	kfree(mode);
+}
+
+/**
+ * drm_mode_config_init - initialize DRM mode_configuration structure
+ * @dev: DRM device
+ *
+ * LOCKING:
+ * None, should happen single threaded at init time.
+ *
+ * Initialize @dev's mode_config structure, used for tracking the 
graphics
+ * configuration of @dev.
+ */
+void drm_mode_config_init(drm_device_t *dev)
+{
+	spin_lock_init(&dev->mode_config.config_lock);
+	INIT_LIST_HEAD(&dev->mode_config.fb_list);
+	INIT_LIST_HEAD(&dev->mode_config.crtc_list);
+	INIT_LIST_HEAD(&dev->mode_config.output_list);
+	idr_init(&dev->mode_config.crtc_idr);
+}
+EXPORT_SYMBOL(drm_mode_config_init);
+
+/**
+ * drm_get_buffer_object - find the buffer object for a given handle
+ * @dev: DRM device
+ * @bo: pointer to caller's buffer_object pointer
+ * @handle: handle to lookup
+ *
+ * LOCKING:
+ * Must take @dev's struct_mutex to protect buffer object lookup.
+ *
+ * Given @handle, lookup the buffer object in @dev and put it in the 
caller's
+ * @bo pointer.
+ *
+ * RETURNS:
+ * Zero on success, -EINVAL if the handle couldn't be found.
+ */
+static int drm_get_buffer_object(drm_device_t *dev, struct 
drm_buffer_object **bo, unsigned long handle)
+{
+	drm_user_object_t *uo;
+	drm_hash_item_t *hash;
+	int ret;
+
+	*bo = NULL;
+
+	mutex_lock(&dev->struct_mutex);
+	ret = drm_ht_find_item(&dev->object_hash, handle, &hash);
+	if (ret) {
+		DRM_ERROR("Couldn't find handle.\n");
+		ret = -EINVAL;
+		goto out_err;
+	}
+
+	uo = drm_hash_entry(hash, drm_user_object_t, hash);
+	if (uo->type != drm_buffer_type) {
+		ret = -EINVAL;
+		goto out_err;
+	}
+	
+	*bo = drm_user_object_entry(uo, drm_buffer_object_t, base);
+	ret = 0;
+out_err:
+	mutex_unlock(&dev->struct_mutex);
+	return ret;
+}
+
+/**
+ * drm_setup_output - setup an output structure
+ * @output: output to setup
+ * @crtc: CRTC this output belongs to
+ * @mode: desired mode for this output
+ *
+ * LOCKING:
+ * None.
+ *
+ * Setup @output with the parameters given, with its initial 
coordinates set
+ * at the origin.
+ */
+static void drm_setup_output(struct drm_output *output, struct drm_crtc 
*crtc,
+			     struct drm_display_mode *mode)
+{
+	output->crtc = crtc;
+	output->crtc->desired_mode = mode;
+	output->initial_x = 0;
+	output->initial_y = 0;
+}
+
+/**
+ * drm_initial_config - setup a sane initial output configuration
+ * @dev: DRM device
+ * @can_grow: this configuration is growable
+ *
+ * LOCKING:
+ * Must take various locks. (FIXME)
+ *
+ * Scan the CRTCs and outputs and try to put together an initial setup.
+ * At the moment, this is a cloned configuration across all heads with
+ * a new framebuffer object as the backing store.
+ *
+ * FIXME: return value and better initial config.
+ *
+ * RETURNS:
+ * Zero if everything went ok, nonzero otherwise.
+ */
+bool drm_initial_config(drm_device_t *dev, bool can_grow)
+{
+	/* do a hardcoded initial configuration here */
+	struct drm_crtc *crtc, *vga_crtc = NULL, *tmds_crtc = NULL,
+		*lvds_crtc = NULL;
+	struct drm_output *output;
+	struct drm_framebuffer *fb;
+	drm_buffer_object_t *fbo;
+	unsigned long size, bytes_per_pixel;
+
+	fb = drm_framebuffer_create(dev);
+	if (!fb) {
+		DRM_ERROR("failed to allocate fb.\n");
+		return true;
+	}
+
+	/* bind both CRTCs to this fb */
+	/* only initialise one crtc to enabled state */
+	list_for_each_entry(crtc, &dev->mode_config.crtc_list, head) {
+		crtc->fb = fb;
+		if (!vga_crtc) {
+			vga_crtc = crtc;
+			crtc->enabled = 1;
+			crtc->desired_x = 0;
+			crtc->desired_y = 0;
+		} else {
+			if (!lvds_crtc) {
+				lvds_crtc = crtc;
+				crtc->enabled = 1;
+				crtc->desired_x = 0;
+				crtc->desired_y = 0;
+			}
+			if (!tmds_crtc) {
+				tmds_crtc = crtc;
+				crtc->enabled = 1;
+				crtc->desired_x = 0;
+				crtc->desired_y = 0;
+			}
+		}
+	}
+
+	drm_crtc_probe_output_modes(dev, 2048, 2048);
+
+	/* hard bind the CRTCS */
+
+	/* bind analog output to one crtc */
+	list_for_each_entry(output, &dev->mode_config.output_list, head) {
+		struct drm_display_mode *des_mode = NULL;
+
+		if (list_empty(&output->modes))
+			continue;
+
+		/* Get the first preferred moded */
+		list_for_each_entry(des_mode, &output->modes, head) {
+			if (des_mode->flags & DRM_MODE_TYPE_PREFERRED)
+				break;
+		}
+
+		if (!des_mode)
+			continue;
+
+		if (!strncmp(output->name, "VGA", 3)) {
+			DRM_DEBUG("VGA preferred mode: %s\n", des_mode->name);
+			drm_setup_output(output, vga_crtc, des_mode);
+		} else if (!strncmp(output->name, "TMDS", 4)) {
+			DRM_DEBUG("TMDS preferred mode: %s\n", des_mode->name);
+			drm_setup_output(output, tmds_crtc, des_mode);
+		} else 	if (!strncmp(output->name, "LVDS", 3)) {
+			DRM_DEBUG("LVDS preferred mode: %s\n", des_mode->name);
+			drm_setup_output(output, lvds_crtc, des_mode);
+		} else
+			output->crtc = NULL;
+
+		/* FB config is max of above desired resolutions */
+		/* FIXME: per-output FBs/CRTCs */
+		if (des_mode->hdisplay > fb->width) {
+			fb->width = des_mode->hdisplay;
+			fb->pitch = fb->width;
+		}
+		if (des_mode->vdisplay > fb->height)
+			fb->height = des_mode->vdisplay;
+	}
+
+	/* FIXME: multiple depths */
+	bytes_per_pixel = 4;
+	fb->bits_per_pixel = bytes_per_pixel * 8;
+	fb->depth = bytes_per_pixel * 8;
+	size = fb->width * fb->height * bytes_per_pixel;
+	drm_buffer_object_create(dev, size, drm_bo_type_kernel,
+				 DRM_BO_FLAG_READ | DRM_BO_FLAG_WRITE |
+				 DRM_BO_FLAG_MEM_PRIV0 | DRM_BO_FLAG_NO_MOVE,
+				 0, 0, 0,
+				 &fbo);
+	DRM_DEBUG("allocated %dx%d fb: 0x%08lx, bo %p\n", fb->width,
+		  fb->height, fbo->offset, fbo);
+	fb->offset = fbo->offset;
+	fb->bo = fbo;
+	drmfb_probe(dev, fb);
+
+	return false;
+}
+EXPORT_SYMBOL(drm_initial_config);
+
+/**
+ * drm_mode_config_cleanup - free up DRM mode_config info
+ * @dev: DRM device
+ *
+ * LOCKING:
+ * Caller? (FIXME)
+ *
+ * Free up all the outputs and CRTCs associated with this DRM device, 
then
+ * free up the framebuffers and associated buffer objects.
+ *
+ * FIXME: cleanup any dangling user buffer objects too
+ */
+void drm_mode_config_cleanup(drm_device_t *dev)
+{
+	struct drm_output *output, *ot;
+	struct drm_crtc *crtc, *ct;
+	struct drm_framebuffer *fb, *fbt;
+	list_for_each_entry_safe(output, ot, &dev->mode_config.output_list, 
head) {
+		drm_output_destroy(output);
+	}
+
+	list_for_each_entry_safe(crtc, ct, &dev->mode_config.crtc_list, head) 
{
+		drm_crtc_destroy(crtc);
+	}
+
+	list_for_each_entry_safe(fb, fbt, &dev->mode_config.fb_list, head) {
+		drmfb_remove(dev, fb);
+		/* If this FB was the kernel one, free it */
+		if (fb->bo->type == drm_bo_type_kernel) {
+			mutex_lock(&dev->struct_mutex);
+			drm_bo_usage_deref_locked(fb->bo);
+			mutex_unlock(&dev->struct_mutex);
+		}
+		drm_framebuffer_destroy(fb);
+	}
+}
+EXPORT_SYMBOL(drm_mode_config_cleanup);
+
+/**
+ * drm_crtc_set_config - set a new config from userspace
+ * @crtc: CRTC to setup
+ * @crtc_info: user provided configuration
+ * @new_mode: new mode to set
+ * @output_set: set of outputs for the new config
+ * @fb: new framebuffer
+ *
+ * LOCKING:
+ * Caller? (FIXME)
+ *
+ * Setup a new configuration, provided by the user in @crtc_info, and 
enable
+ * it.
+ *
+ * RETURNS:
+ * Zero. (FIXME)
+ */
+int drm_crtc_set_config(struct drm_crtc *crtc, struct drm_mode_crtc 
*crtc_info, struct drm_display_mode *new_mode, struct drm_output 
**output_set, struct drm_framebuffer *fb)
+{
+	drm_device_t *dev = crtc->dev;
+	struct drm_crtc **save_crtcs, *new_crtc;
+	bool save_enabled = crtc->enabled;
+	bool changed;
+	struct drm_output *output;
+	int count = 0, ro;
+
+	save_crtcs = kzalloc(dev->mode_config.num_crtc * sizeof(struct 
drm_crtc *), GFP_KERNEL);
+	if (!save_crtcs)
+		return -ENOMEM;
+
+	if (crtc->fb != fb)
+		changed = true;
+
+	if (crtc_info->x != crtc->x || crtc_info->y != crtc->y)
+		changed = true;
+
+	if (new_mode && (crtc->mode.mode_id != new_mode->mode_id))
+		changed = true;
+
+	list_for_each_entry(output, &dev->mode_config.output_list, head) {
+		save_crtcs[count++] = output->crtc;
+
+		if (output->crtc == crtc)
+			new_crtc = NULL;
+		else
+			new_crtc = output->crtc;
+
+		for (ro = 0; ro < crtc_info->count_outputs; ro++) {
+			if (output_set[ro] == output)
+				new_crtc = crtc;
+		}
+		if (new_crtc != output->crtc) {
+			changed = true;
+			output->crtc = new_crtc;
+		}
+	}
+
+	if (changed) {
+		crtc->fb = fb;
+		crtc->enabled = (new_mode != NULL);
+		if (new_mode != NULL) {
+			DRM_DEBUG("attempting to set mode from userspace\n");
+			drm_mode_debug_printmodeline(dev, new_mode);
+			if (!drm_crtc_set_mode(crtc, new_mode, crtc_info->x,
+					       crtc_info->y)) {
+				crtc->enabled = save_enabled;
+				count = 0;
+				list_for_each_entry(output, &dev->mode_config.output_list, head)
+					output->crtc = save_crtcs[count++];
+				kfree(save_crtcs);
+				return -EINVAL;
+			}
+			crtc->desired_x = crtc_info->x;
+			crtc->desired_y = crtc_info->y;
+			crtc->desired_mode = new_mode;
+		}
+		drm_disable_unused_functions(dev);
+	}
+	kfree(save_crtcs);
+	return 0;
+}
+
+/**
+ * drm_crtc_convert_to_umode - convert a drm_display_mode into a 
modeinfo
+ * @out: drm_mode_modeinfo struct to return to the user
+ * @in: drm_display_mode to use
+ *
+ * LOCKING:
+ * None.
+ *
+ * Convert a drm_display_mode into a drm_mode_modeinfo structure to 
return to
+ * the user.
+ */
+void drm_crtc_convert_to_umode(struct drm_mode_modeinfo *out, struct 
drm_display_mode *in)
+{
+
+	out->id = in->mode_id;
+	out->clock = in->clock;
+	out->hdisplay = in->hdisplay;
+	out->hsync_start = in->hsync_start;
+	out->hsync_end = in->hsync_end;
+	out->htotal = in->htotal;
+	out->hskew = in->hskew;
+	out->vdisplay = in->vdisplay;
+	out->vsync_start = in->vsync_start;
+	out->vsync_end = in->vsync_end;
+	out->vtotal = in->vtotal;
+	out->vscan = in->vscan;
+	out->vrefresh = in->vrefresh;
+	out->flags = in->flags;
+	strncpy(out->name, in->name, DRM_DISPLAY_MODE_LEN);
+	out->name[DRM_DISPLAY_MODE_LEN-1] = 0;
+}
+
+	
+/**
+ * drm_mode_getresources - get graphics configuration
+ * @inode: inode from the ioctl
+ * @filp: file * from the ioctl
+ * @cmd: cmd from ioctl
+ * @arg: arg from ioctl
+ *
+ * LOCKING:
+ * Caller? (FIXME)
+ *
+ * Construct a set of configuration description structures and return
+ * them to the user, including CRTC, output and framebuffer 
configuration.
+ *
+ * Called by the user via ioctl.
+ *
+ * RETURNS:
+ * Zero on success, errno on failure.
+ */
+int drm_mode_getresources(struct inode *inode, struct file *filp,
+			  unsigned int cmd, unsigned long arg)
+{
+	drm_file_t *priv = filp->private_data;
+	drm_device_t *dev = priv->head->dev;
+	struct drm_mode_card_res __user *argp = (void __user *)arg;
+	struct drm_mode_card_res card_res;
+	struct list_head *lh;
+	struct drm_framebuffer *fb;
+	struct drm_output *output;
+	struct drm_crtc *crtc;
+	struct drm_mode_modeinfo u_mode;
+	struct drm_display_mode *mode;
+	int retcode = 0;
+	int mode_count= 0;
+	int output_count = 0;
+	int crtc_count = 0;
+	int fb_count = 0;
+	int copied = 0;
+	
+	memset(&u_mode, 0, sizeof(struct drm_mode_modeinfo));
+
+	list_for_each(lh, &dev->mode_config.fb_list)
+		fb_count++;
+
+	list_for_each(lh, &dev->mode_config.crtc_list)
+		crtc_count++;
+
+	list_for_each_entry(output, &dev->mode_config.output_list,
+			    head) {
+		output_count++;
+		list_for_each(lh, &output->modes)
+			mode_count++;
+	}
+
+	if (copy_from_user(&card_res, argp, sizeof(card_res)))
+		return -EFAULT;
+
+	if (card_res.count_modes == 0) {
+		DRM_DEBUG("probing modes %dx%d\n", dev->mode_config.max_width, 
dev->mode_config.max_height);
+		drm_crtc_probe_output_modes(dev, dev->mode_config.max_width, 
dev->mode_config.max_height);
+		mode_count = 0;
+		list_for_each_entry(output, &dev->mode_config.output_list, head) {
+			list_for_each(lh, &output->modes)
+				mode_count++;
+		}
+	}
+
+	/* handle this in 4 parts */
+	/* FBs */
+	if (card_res.count_fbs >= fb_count) {
+		copied = 0;
+		list_for_each_entry(fb, &dev->mode_config.fb_list, head) {
+			if (put_user(fb->id, &card_res.fb_id[copied++])) {
+				retcode = -EFAULT;
+				goto done;
+			}
+		}
+	}
+	card_res.count_fbs = fb_count;
+
+	/* CRTCs */
+	if (card_res.count_crtcs >= crtc_count) {
+		copied = 0;
+		list_for_each_entry(crtc, &dev->mode_config.crtc_list, head){
+			DRM_DEBUG("CRTC ID is %d\n", crtc->id);
+			if (put_user(crtc->id, &card_res.crtc_id[copied++])) {
+				retcode = -EFAULT;
+				goto done;
+			}
+		}
+	}
+	card_res.count_crtcs = crtc_count;
+
+
+	/* Outputs */
+	if (card_res.count_outputs >= output_count) {
+		copied = 0;
+		list_for_each_entry(output, &dev->mode_config.output_list,
+				    head) {
+ 			DRM_DEBUG("OUTPUT ID is %d\n", output->id);
+			if (put_user(output->id, &card_res.output_id[copied++])) {
+				retcode = -EFAULT;
+				goto done;
+			}
+		}
+	}
+	card_res.count_outputs = output_count;
+	
+	/* Modes */
+	if (card_res.count_modes >= mode_count) {
+		copied = 0;
+		list_for_each_entry(output, &dev->mode_config.output_list,
+				    head) {
+			list_for_each_entry(mode, &output->modes, head) {
+				drm_crtc_convert_to_umode(&u_mode, mode);
+				if (copy_to_user(&card_res.modes[copied++], &u_mode, sizeof(struct 
drm_mode_modeinfo))) {
+					retcode = -EFAULT;
+					goto done;
+				}
+			}
+		}
+	}
+	card_res.count_modes = mode_count;
+
+done:
+	DRM_DEBUG("Counted %d %d %d\n", card_res.count_crtcs,
+		  card_res.count_outputs,
+		  card_res.count_modes);
+	
+	if (copy_to_user(argp, &card_res, sizeof(card_res)))
+		return -EFAULT;
+
+	return retcode;
+}
+
+/**
+ * drm_mode_getcrtc - get CRTC configuration
+ * @inode: inode from the ioctl
+ * @filp: file * from the ioctl
+ * @cmd: cmd from ioctl
+ * @arg: arg from ioctl
+ *
+ * LOCKING:
+ * Caller? (FIXME)
+ *
+ * Construct a CRTC configuration structure to return to the user.
+ *
+ * Called by the user via ioctl.
+ *
+ * RETURNS:
+ * Zero on success, errno on failure.
+ */
+int drm_mode_getcrtc(struct inode *inode, struct file *filp,
+		     unsigned int cmd, unsigned long arg)
+{
+	drm_file_t *priv = filp->private_data;
+	drm_device_t *dev = priv->head->dev;
+	struct drm_mode_crtc __user *argp = (void __user *)arg;
+	struct drm_mode_crtc crtc_resp;
+	struct drm_crtc *crtc;
+	struct drm_output *output;
+	int ocount;
+	int retcode = 0;
+
+	if (copy_from_user(&crtc_resp, argp, sizeof(crtc_resp)))
+		return -EFAULT;
+
+	crtc = idr_find(&dev->mode_config.crtc_idr, crtc_resp.crtc_id);
+	if (!crtc || (crtc->id != crtc_resp.crtc_id))
+		return -EINVAL;
+	crtc_resp.x = crtc->x;
+	crtc_resp.y = crtc->y;
+	crtc_resp.fb_id = 1;
+
+	crtc_resp.outputs = 0;
+	if (crtc->enabled) {
+
+		crtc_resp.mode = crtc->mode.mode_id;
+		ocount = 0;
+		list_for_each_entry(output, &dev->mode_config.output_list, head) {
+			if (output->crtc == crtc)
+				crtc_resp.outputs |= 1 << (ocount++);
+		}
+	} else {
+		crtc_resp.mode = 0;
+	}
+
+	if (copy_to_user(argp, &crtc_resp, sizeof(crtc_resp)))
+		return -EFAULT;
+
+	return retcode;
+}
+
+/**
+ * drm_mode_getoutput - get output configuration
+ * @inode: inode from the ioctl
+ * @filp: file * from the ioctl
+ * @cmd: cmd from ioctl
+ * @arg: arg from ioctl
+ *
+ * LOCKING:
+ * Caller? (FIXME)
+ *
+ * Construct a output configuration structure to return to the user.
+ *
+ * Called by the user via ioctl.
+ *
+ * RETURNS:
+ * Zero on success, errno on failure.
+ */
+int drm_mode_getoutput(struct inode *inode, struct file *filp,
+		       unsigned int cmd, unsigned long arg)
+{
+	drm_file_t *priv = filp->private_data;
+	drm_device_t *dev = priv->head->dev;
+	struct drm_mode_get_output __user *argp = (void __user *)arg;
+	struct drm_mode_get_output out_resp;
+	struct drm_output *output;
+	struct drm_display_mode *mode;
+	int mode_count = 0;
+	int retcode = 0;
+	int copied = 0;
+
+	if (copy_from_user(&out_resp, argp, sizeof(out_resp)))
+		return -EFAULT;	
+
+	DRM_DEBUG("output id %d:\n", out_resp.output);
+	output= idr_find(&dev->mode_config.crtc_idr, out_resp.output);
+	if (!output || (output->id != out_resp.output))
+		return -EINVAL;
+
+	list_for_each_entry(mode, &output->modes, head)
+		mode_count++;
+
+	strncpy(out_resp.name, output->name, DRM_OUTPUT_NAME_LEN);
+	out_resp.name[DRM_OUTPUT_NAME_LEN-1] = 0;
+
+	out_resp.mm_width = output->mm_width;
+	out_resp.mm_height = output->mm_height;
+	out_resp.subpixel = output->subpixel_order;
+	out_resp.connection = output->status;
+	if (output->crtc)
+		out_resp.crtc = output->crtc->id;
+	else
+		out_resp.crtc = 0;
+
+	if ((out_resp.count_modes >= mode_count) && mode_count) {
+		copied = 0;
+		list_for_each_entry(mode, &output->modes, head) {
+			if (put_user(mode->mode_id, &out_resp.modes[copied++])) {
+				retcode = -EFAULT;
+				goto done;
+			}
+		}
+	}
+	out_resp.count_modes = mode_count;
+
+done:
+	if (copy_to_user(argp, &out_resp, sizeof(out_resp)))
+		return -EFAULT;
+
+	return retcode;
+}
+
+/**
+ * drm_mode_setcrtc - set CRTC configuration
+ * @inode: inode from the ioctl
+ * @filp: file * from the ioctl
+ * @cmd: cmd from ioctl
+ * @arg: arg from ioctl
+ *
+ * LOCKING:
+ * Caller? (FIXME)
+ *
+ * Build a new CRTC configuration based on user request.
+ *
+ * Called by the user via ioctl.
+ *
+ * RETURNS:
+ * Zero on success, errno on failure.
+ */
+int drm_mode_setcrtc(struct inode *inode, struct file *filp,
+		     unsigned int cmd, unsigned long arg)
+{
+	drm_file_t *priv = filp->private_data;
+	drm_device_t *dev = priv->head->dev;
+	struct drm_mode_crtc __user *argp = (void __user *)arg;
+	struct drm_mode_crtc crtc_req;
+	struct drm_crtc *crtc;
+	struct drm_output **output_set = NULL, *output;
+	struct drm_display_mode *mode;
+	struct drm_framebuffer *fb = NULL;
+	int retcode = 0;
+	int i;
+
+	if (copy_from_user(&crtc_req, argp, sizeof(crtc_req)))
+		return -EFAULT;
+
+	crtc = idr_find(&dev->mode_config.crtc_idr, crtc_req.crtc_id);
+	if (!crtc || (crtc->id != crtc_req.crtc_id)) {
+		DRM_DEBUG("Unknown CRTC ID %d\n", crtc_req.crtc_id);
+		return -EINVAL;
+	}
+
+	if (crtc_req.mode) {
+
+		/* if we have a mode we need a framebuffer */
+		if (crtc_req.fb_id) {
+			fb = idr_find(&dev->mode_config.crtc_idr, crtc_req.fb_id);
+			if (!fb || (fb->id != crtc_req.fb_id)) {
+				DRM_DEBUG("Unknown FB ID%d\n", crtc_req.fb_id);
+				return -EINVAL;
+			}
+		}
+		mode = idr_find(&dev->mode_config.crtc_idr, crtc_req.mode);
+		if (!mode || (mode->mode_id != crtc_req.mode)) {
+			struct drm_output *output;
+			
+			list_for_each_entry(output, &dev->mode_config.output_list, head) {
+				list_for_each_entry(mode, &output->modes, head) {
+					drm_mode_debug_printmodeline(dev, mode);
+				}
+			}
+
+			DRM_DEBUG("Unknown mode id %d, %p\n", crtc_req.mode, mode);
+			return -EINVAL;
+		}
+	} else
+		mode = NULL;
+
+	if (crtc_req.count_outputs == 0 && mode) {
+		DRM_DEBUG("Count outputs is 0 but mode set\n");
+		return -EINVAL;
+	}
+
+	if (crtc_req.count_outputs > 0 && !mode && !fb) {
+		DRM_DEBUG("Count outputs is %d but no mode or fb set\n", 
crtc_req.count_outputs);
+		return -EINVAL;
+	}
+
+	if (crtc_req.count_outputs > 0) {
+		u32 out_id;
+		output_set = kmalloc(crtc_req.count_outputs * sizeof(struct 
drm_output *), GFP_KERNEL);
+		if (!output_set)
+			return -ENOMEM;
+
+		for (i = 0; i < crtc_req.count_outputs; i++) {
+			if (get_user(out_id, &crtc_req.set_outputs[i]))
+				return -EFAULT;
+
+			output = idr_find(&dev->mode_config.crtc_idr, out_id);
+			if (!output || (out_id != output->id)) {
+				DRM_DEBUG("Output id %d unknown\n", out_id);
+				return -EINVAL;
+			}
+
+			output_set[i] = output;
+		}
+	}
+		
+	retcode = drm_crtc_set_config(crtc, &crtc_req, mode, output_set, fb);
+	return retcode;
+}
+
+/**
+ * drm_mode_addfb - add an FB to the graphics configuration
+ * @inode: inode from the ioctl
+ * @filp: file * from the ioctl
+ * @cmd: cmd from ioctl
+ * @arg: arg from ioctl
+ *
+ * LOCKING:
+ * Caller? (FIXME)
+ *
+ * Add a new FB to the specified CRTC, given a user request.
+ *
+ * Called by the user via ioctl.
+ *
+ * RETURNS:
+ * Zero on success, errno on failure.
+ */
+int drm_mode_addfb(struct inode *inode, struct file *filp,
+		   unsigned int cmd, unsigned long arg)
+{
+	struct drm_file *priv = filp->private_data;
+	struct drm_device *dev = priv->head->dev;
+	struct drm_mode_fb_cmd __user *argp = (void __user *)arg;
+	struct drm_mode_fb_cmd r;
+	struct drm_mode_config *config = &dev->mode_config;
+	struct drm_framebuffer *fb;
+	struct drm_buffer_object *bo;
+	int ret;
+
+	if (copy_from_user(&r, argp, sizeof(r)))
+		return -EFAULT;
+
+	if ((config->min_width > r.width) || (r.width > config->max_width)) {
+		DRM_ERROR("mode new framebuffer width not within limits\n");
+		return -EINVAL;
+	}
+	if ((config->min_height > r.height) || (r.height > 
config->max_height)) {
+		DRM_ERROR("mode new framebuffer height not within limits\n");
+		return -EINVAL;
+	}
+
+	/* TODO check limits are okay */
+	ret = drm_get_buffer_object(dev, &bo, r.handle);
+	if (ret || !bo)
+		return -EINVAL;
+
+	/* TODO check buffer is sufficently large */
+	/* TODO setup destructor callback */
+
+	fb = drm_framebuffer_create(dev);
+	if(!fb)
+		return -EINVAL;;
+
+	fb->width = r.width;
+	fb->height = r.height;
+	fb->pitch = r.pitch;
+	fb->bits_per_pixel = r.bpp;
+	fb->depth = r.depth;
+	fb->offset = bo->offset;
+	fb->bo = bo;
+
+	r.buffer_id = fb->id;
+
+	list_add(&fb->filp_head, &priv->fbs);
+	/* bind the fb to the crtc for now */
+	{
+		struct drm_crtc *crtc;
+		list_for_each_entry(crtc, &dev->mode_config.crtc_list, head) {
+			crtc->fb = fb;
+		}
+	}
+	if (copy_to_user(argp, &r, sizeof(r)))
+		return -EFAULT;
+
+	drmfb_probe(dev, fb);
+	return 0;
+}
+
+/**
+ * drm_mode_rmfb - remove an FB from the configuration
+ * @inode: inode from the ioctl
+ * @filp: file * from the ioctl
+ * @cmd: cmd from ioctl
+ * @arg: arg from ioctl
+ *
+ * LOCKING:
+ * Caller? (FIXME)
+ *
+ * Remove the FB specified by the user.
+ *
+ * Called by the user via ioctl.
+ *
+ * RETURNS:
+ * Zero on success, errno on failure.
+ */
+int drm_mode_rmfb(struct inode *inode, struct file *filp,
+		   unsigned int cmd, unsigned long arg)
+{
+	drm_file_t *priv = filp->private_data;
+	drm_device_t *dev = priv->head->dev;
+	struct drm_framebuffer *fb = 0;
+	uint32_t id = arg;
+
+	fb = idr_find(&dev->mode_config.crtc_idr, id);
+	/* TODO check that we realy get a framebuffer back. */
+	if (!fb || (id != fb->id)) {
+		DRM_ERROR("mode invalid framebuffer id\n");
+		return -EINVAL;
+	}
+
+	drmfb_remove(dev, fb);
+	/* TODO check if we own the buffer */
+	/* TODO release all crtc connected to the framebuffer */
+	/* bind the fb to the crtc for now */
+	/* TODO unhock the destructor from the buffer object */
+
+	drm_framebuffer_destroy(fb);
+
+	return 0;
+}
+
+/**
+ * drm_mode_getfb - get FB info
+ * @inode: inode from the ioctl
+ * @filp: file * from the ioctl
+ * @cmd: cmd from ioctl
+ * @arg: arg from ioctl
+ *
+ * LOCKING:
+ * Caller? (FIXME)
+ *
+ * Lookup the FB given its ID and return info about it.
+ *
+ * Called by the user via ioctl.
+ *
+ * RETURNS:
+ * Zero on success, errno on failure.
+ */
+int drm_mode_getfb(struct inode *inode, struct file *filp,
+		   unsigned int cmd, unsigned long arg)
+{
+	drm_file_t *priv = filp->private_data;
+	drm_device_t *dev = priv->head->dev;	
+	struct drm_mode_fb_cmd __user *argp = (void __user *)arg;
+	struct drm_mode_fb_cmd r;
+	struct drm_framebuffer *fb;
+
+	if (copy_from_user(&r, argp, sizeof(r)))
+		return -EFAULT;
+
+	fb = idr_find(&dev->mode_config.crtc_idr, r.buffer_id);
+	if (!fb || (r.buffer_id != fb->id)) {
+		DRM_ERROR("invalid framebuffer id\n");
+		return -EINVAL;
+	}
+
+	r.height = fb->height;
+	r.width = fb->width;
+	r.depth = fb->depth;
+	r.bpp = fb->bits_per_pixel;
+	r.handle = fb->bo->base.hash.key;
+	r.pitch = fb->pitch;
+
+	if (copy_to_user(argp, &r, sizeof(r)))
+		return -EFAULT;
+
+	return 0;
+}
+
+/**
+ * drm_fb_release - remove and free the FBs on this file
+ * @filp: file * from the ioctl
+ *
+ * LOCKING:
+ * Caller? (FIXME)
+ *
+ * Destroy all the FBs associated with @filp.
+ *
+ * Called by the user via ioctl.
+ *
+ * RETURNS:
+ * Zero on success, errno on failure.
+ */
+void drm_fb_release(struct file *filp)
+{
+	drm_file_t *priv = filp->private_data;
+	drm_device_t *dev = priv->head->dev;
+	struct drm_framebuffer *fb, *tfb;
+
+	list_for_each_entry_safe(fb, tfb, &priv->fbs, filp_head) {
+		list_del(&fb->filp_head);
+		drmfb_remove(dev, fb);
+		drm_framebuffer_destroy(fb);
+		
+	}
+}
diff --git a/linux-core/drm_crtc.h b/linux-core/drm_crtc.h
new file mode 100644
index 0000000..a15ce0c
--- /dev/null
+++ b/linux-core/drm_crtc.h
@@ -0,0 +1,535 @@
+/*
+ * Copyright © 2006 Keith Packard
+ * Copyright © 2007 Intel Corporation
+ *   Jesse Barnes <jesse.barnes@intel.com>
+ */
+#ifndef __DRM_CRTC_H__
+#define __DRM_CRTC_H__
+
+#include <linux/i2c.h>
+#include <linux/spinlock.h>
+#include <linux/types.h>
+#include <linux/idr.h>
+
+#include <linux/fb.h>
+
+struct drm_device;
+
+/*
+ * Note on terminology:  here, for brevity and convenience, we refer to 
output
+ * control chips as 'CRTCs'.  They can control any type of output, VGA, 
LVDS,
+ * DVI, etc.  And 'screen' refers to the whole of the visible display, 
which
+ * may span multiple monitors (and therefore multiple CRTC and output
+ * structures).
+ */
+
+enum drm_mode_status {
+    MODE_OK	= 0,	/* Mode OK */
+    MODE_HSYNC,		/* hsync out of range */
+    MODE_VSYNC,		/* vsync out of range */
+    MODE_H_ILLEGAL,	/* mode has illegal horizontal timings */
+    MODE_V_ILLEGAL,	/* mode has illegal horizontal timings */
+    MODE_BAD_WIDTH,	/* requires an unsupported linepitch */
+    MODE_NOMODE,	/* no mode with a maching name */
+    MODE_NO_INTERLACE,	/* interlaced mode not supported */
+    MODE_NO_DBLESCAN,	/* doublescan mode not supported */
+    MODE_NO_VSCAN,	/* multiscan mode not supported */
+    MODE_MEM,		/* insufficient video memory */
+    MODE_VIRTUAL_X,	/* mode width too large for specified virtual size 
*/
+    MODE_VIRTUAL_Y,	/* mode height too large for specified virtual size 
*/
+    MODE_MEM_VIRT,	/* insufficient video memory given virtual size */
+    MODE_NOCLOCK,	/* no fixed clock available */
+    MODE_CLOCK_HIGH,	/* clock required is too high */
+    MODE_CLOCK_LOW,	/* clock required is too low */
+    MODE_CLOCK_RANGE,	/* clock/mode isn't in a ClockRange */
+    MODE_BAD_HVALUE,	/* horizontal timing was out of range */
+    MODE_BAD_VVALUE,	/* vertical timing was out of range */
+    MODE_BAD_VSCAN,	/* VScan value out of range */
+    MODE_HSYNC_NARROW,	/* horizontal sync too narrow */
+    MODE_HSYNC_WIDE,	/* horizontal sync too wide */
+    MODE_HBLANK_NARROW,	/* horizontal blanking too narrow */
+    MODE_HBLANK_WIDE,	/* horizontal blanking too wide */
+    MODE_VSYNC_NARROW,	/* vertical sync too narrow */
+    MODE_VSYNC_WIDE,	/* vertical sync too wide */
+    MODE_VBLANK_NARROW,	/* vertical blanking too narrow */
+    MODE_VBLANK_WIDE,	/* vertical blanking too wide */
+    MODE_PANEL,         /* exceeds panel dimensions */
+    MODE_INTERLACE_WIDTH, /* width too large for interlaced mode */
+    MODE_ONE_WIDTH,     /* only one width is supported */
+    MODE_ONE_HEIGHT,    /* only one height is supported */
+    MODE_ONE_SIZE,      /* only one resolution is supported */
+    MODE_NO_REDUCED,    /* monitor doesn't accept reduced blanking */
+    MODE_UNVERIFIED = -3, /* mode needs to reverified */
+    MODE_BAD = -2,	/* unspecified reason */
+    MODE_ERROR	= -1	/* error condition */
+};
+
+#define DRM_MODE_TYPE_BUILTIN	(1<<0)
+#define DRM_MODE_TYPE_CLOCK_C	((1<<1) | DRM_MODE_TYPE_BUILTIN)
+#define DRM_MODE_TYPE_CRTC_C	((1<<2) | DRM_MODE_TYPE_BUILTIN)
+#define DRM_MODE_TYPE_PREFERRED	(1<<3)
+#define DRM_MODE_TYPE_DEFAULT	(1<<4)
+#define DRM_MODE_TYPE_USERDEF	(1<<5)
+#define DRM_MODE_TYPE_DRIVER	(1<<6)
+
+#define DRM_MODE_TYPE_CLOCK_CRTC_C (DRM_MODE_TYPE_CLOCK_C | \
+				    DRM_MODE_TYPE_CRTC_C)
+
+#define DRM_MODE(nm, t, c, hd, hss, hse, ht, hsk, vd, vss, vse, vt, vs, 
f) \
+	.name = nm, .status = 0, .type = (t), .clock = (c), \
+	.hdisplay = (hd), .hsync_start = (hss), .hsync_end = (hse), \
+	.htotal = (ht), .hskew = (hsk), .vdisplay = (vd), \
+	.vsync_start = (vss), .vsync_end = (vse), .vtotal = (vt), \
+	.vscan = (vs), .flags = (f), .vrefresh = 0
+
+struct drm_display_mode {
+	/* Header */
+	struct list_head head;
+	char name[DRM_DISPLAY_MODE_LEN];
+	int mode_id;
+	enum drm_mode_status status;
+	int type;
+
+	/* Proposed mode values */
+	int clock;
+	int hdisplay;
+	int hsync_start;
+	int hsync_end;
+	int htotal;
+	int hskew;
+	int vdisplay;
+	int vsync_start;
+	int vsync_end;
+	int vtotal;
+	int vscan;
+	unsigned int flags;
+
+	/* Actual mode we give to hw */
+	int clock_index;
+	int synth_clock;
+	int crtc_hdisplay;
+	int crtc_hblank_start;
+	int crtc_hblank_end;
+	int crtc_hsync_start;
+	int crtc_hsync_end;
+	int crtc_htotal;
+	int crtc_hskew;
+	int crtc_vdisplay;
+	int crtc_vblank_start;
+	int crtc_vblank_end;
+	int crtc_vsync_start;
+	int crtc_vsync_end;
+	int crtc_vtotal;
+	int crtc_hadjusted;
+	int crtc_vadjusted;
+
+	/* Driver private mode info */
+	int private_size;
+	int *private;
+	int private_flags;
+
+	int vrefresh;
+	float hsync;
+};
+
+/* Video mode flags */
+#define V_PHSYNC	(1<<0)
+#define V_NHSYNC	(1<<1)
+#define V_PVSYNC	(1<<2)
+#define V_NVSYNC	(1<<3)
+#define V_INTERLACE	(1<<4)
+#define V_DBLSCAN	(1<<5)
+#define V_CSYNC		(1<<6)
+#define V_PCSYNC	(1<<7)
+#define V_NCSYNC	(1<<8)
+#define V_HSKEW		(1<<9) /* hskew provided */
+#define V_BCAST		(1<<10)
+#define V_PIXMUX	(1<<11)
+#define V_DBLCLK	(1<<12)
+#define V_CLKDIV2	(1<<13)
+
+#define CRTC_INTERLACE_HALVE_V 0x1 /* halve V values for interlacing */
+#define DPMSModeOn 0
+#define DPMSModeStandby 1
+#define DPMSModeSuspend 2
+#define DPMSModeOff 3
+
+enum drm_output_status {
+	output_status_connected,
+	output_status_disconnected,
+	output_status_unknown,
+};
+
+enum subpixel_order {
+	SubPixelUnknown = 0,
+	SubPixelHorizontalRGB,
+	SubPixelHorizontalBGR,
+	SubPixelVerticalRGB,
+	SubPixelVerticalBGR,
+	SubPixelNone,
+};
+
+/*
+ * Describes a given display (e.g. CRT or flat panel) and its 
limitations.
+ */
+struct drm_display_info {
+	char name[DRM_DISPLAY_INFO_LEN];
+	/* Input info */
+	bool serration_vsync;
+	bool sync_on_green;
+	bool composite_sync;
+	bool separate_syncs;
+	bool blank_to_black;
+	unsigned char video_level;
+	bool digital;
+	/* Physical size */
+        unsigned int width_mm;
+	unsigned int height_mm;
+
+	/* Display parameters */
+	unsigned char gamma; /* FIXME: storage format */
+	bool gtf_supported;
+	bool standard_color;
+	enum {
+		monochrome,
+		rgb,
+		other,
+		unknown,
+	} display_type;
+	bool active_off_supported;
+	bool suspend_supported;
+	bool standby_supported;
+
+	/* Color info FIXME: storage format */
+	unsigned short redx, redy;
+	unsigned short greenx, greeny;
+	unsigned short bluex, bluey;
+	unsigned short whitex, whitey;
+
+	/* Clock limits FIXME: storage format */
+	unsigned int min_vfreq, max_vfreq;
+	unsigned int min_hfreq, max_hfreq;
+	unsigned int pixel_clock;
+
+	/* White point indices FIXME: storage format */
+	unsigned int wpx1, wpy1;
+	unsigned int wpgamma1;
+	unsigned int wpx2, wpy2;
+	unsigned int wpgamma2;
+
+	/* Preferred mode (if any) */
+	struct drm_display_mode *preferred_mode;
+	char *raw_edid; /* if any */
+};
+
+struct drm_framebuffer {
+	struct drm_device *dev;
+	struct list_head head;
+	int id; /* idr assigned */
+	unsigned int pitch;
+	unsigned long offset;
+	unsigned int width;
+	unsigned int height;
+	/* depth can be 15 or 16 */
+	unsigned int depth;
+	int bits_per_pixel;
+	int flags;
+	struct drm_buffer_object *bo;
+	void *fbdev;
+	u32 pseudo_palette[17];
+	void *virtual_base;
+	struct list_head filp_head;
+};
+struct drm_crtc;
+struct drm_output;
+
+/**
+ * drm_crtc_funcs - control CRTCs for a given device
+ * @dpms: control display power levels
+ * @save: save CRTC state
+ * @resore: restore CRTC state
+ * @lock: lock the CRTC
+ * @unlock: unlock the CRTC
+ * @shadow_allocate: allocate shadow pixmap
+ * @shadow_create: create shadow pixmap for rotation support
+ * @shadow_destroy: free shadow pixmap
+ * @mode_fixup: fixup proposed mode
+ * @mode_set: set the desired mode on the CRTC
+ * @gamma_set: specify color ramp for CRTC
+ * @cleanup: cleanup driver private state prior to close
+ *
+ * The drm_crtc_funcs structure is the central CRTC management 
structure
+ * in the DRM.  Each CRTC controls one or more outputs (note that the 
name
+ * CRTC is simply historical, a CRTC may control LVDS, VGA, DVI, TV 
out, etc.
+ * outputs, not just CRTs).
+ *
+ * Each driver is responsible for filling out this structure at startup 
time,
+ * in addition to providing other modesetting features, like i2c and 
DDC
+ * bus accessors.
+ */
+struct drm_crtc_funcs {
+	/*
+	 * Control power levels on the CRTC.  If the mode passed in is
+	 * unsupported, the provider must use the next lowest power level.
+	 */
+	void (*dpms)(struct drm_crtc *crtc, int mode);
+
+	/* JJJ:  Are these needed? */
+	/* Save CRTC state */
+	void (*save)(struct drm_crtc *crtc); /* suspend? */
+	/* Restore CRTC state */
+	void (*restore)(struct drm_crtc *crtc); /* resume? */
+	bool (*lock)(struct drm_crtc *crtc);
+	void (*unlock)(struct drm_crtc *crtc);
+
+	void (*prepare)(struct drm_crtc *crtc);
+	void (*commit)(struct drm_crtc *crtc);
+
+	/* Provider can fixup or change mode timings before modeset occurs */
+	bool (*mode_fixup)(struct drm_crtc *crtc,
+			   struct drm_display_mode *mode,
+			   struct drm_display_mode *adjusted_mode);
+	/* Actually set the mode */
+	void (*mode_set)(struct drm_crtc *crtc, struct drm_display_mode *mode,
+			 struct drm_display_mode *adjusted_mode, int x, int y);
+	/* Set gamma on the CRTC */
+	void (*gamma_set)(struct drm_crtc *crtc, u16 *r, u16 *g, u16 *b,
+			  int size);
+	/* Driver cleanup routine */
+	void (*cleanup)(struct drm_crtc *crtc);
+};
+
+/**
+ * drm_crtc - central CRTC control structure
+ * @enabled: is this CRTC enabled?
+ * @x: x position on screen
+ * @y: y position on screen
+ * @desired_mode: new desired mode
+ * @desired_x: desired x for desired_mode
+ * @desired_y: desired y for desired_mode
+ * @funcs: CRTC control functions
+ * @driver_private: arbitrary driver data
+ *
+ * Each CRTC may have one or more outputs associated with it.  This 
structure
+ * allows the CRTC to be controlled.
+ */
+struct drm_crtc {
+	struct drm_device *dev;
+	struct list_head head;
+
+	int id; /* idr assigned */
+
+	/* framebuffer the CRTC is currently bound to */
+	struct drm_framebuffer *fb;
+
+	bool enabled;
+
+	/* JJJ: are these needed? */
+	bool cursor_in_range;
+	bool cursor_shown;
+
+	struct drm_display_mode mode;
+
+	int x, y;
+	struct drm_display_mode *desired_mode;
+	int desired_x, desired_y;
+	const struct drm_crtc_funcs *funcs;
+	void *driver_private;
+
+	/* RRCrtcPtr randr_crtc? */
+};
+
+extern struct drm_crtc *drm_crtc_create(struct drm_device *dev,
+					const struct drm_crtc_funcs *funcs);
+
+/**
+ * drm_output_funcs - control outputs on a given device
+ * @init: setup this output
+ * @dpms: set power state (see drm_crtc_funcs above)
+ * @save: save output state
+ * @restore: restore output state
+ * @mode_valid: is this mode valid on the given output?
+ * @mode_fixup: try to fixup proposed mode for this output
+ * @mode_set: set this mode
+ * @detect: is this output active?
+ * @get_modes: get mode list for this output
+ * @set_property: property for this output may need update
+ * @cleanup: output is going away, cleanup
+ *
+ * Each CRTC may have one or more outputs attached to it.  The 
functions
+ * below allow the core DRM code to control outputs, enumerate 
available modes,
+ * etc.
+ */
+struct drm_output_funcs {
+	void (*init)(struct drm_output *output);
+	void (*dpms)(struct drm_output *output, int mode);
+	void (*save)(struct drm_output *output);
+	void (*restore)(struct drm_output *output);
+	int (*mode_valid)(struct drm_output *output,
+			  struct drm_display_mode *mode);
+	bool (*mode_fixup)(struct drm_output *output,
+			   struct drm_display_mode *mode,
+			   struct drm_display_mode *adjusted_mode);
+	void (*prepare)(struct drm_output *output);
+	void (*commit)(struct drm_output *output);
+	void (*mode_set)(struct drm_output *output,
+			 struct drm_display_mode *mode,
+			 struct drm_display_mode *adjusted_mode);
+	enum drm_output_status (*detect)(struct drm_output *output);
+	int (*get_modes)(struct drm_output *output);
+	/* JJJ: type checking for properties via property value type */
+	bool (*set_property)(struct drm_output *output, int prop, void *val);
+	void (*cleanup)(struct drm_output *output);
+};
+
+#define DRM_OUTPUT_LEN 32
+/**
+ * drm_output - central DRM output control structure
+ * @crtc: CRTC this output is currently connected to, NULL if none
+ * @possible_crtcs: bitmap of CRTCS this output could be attached to
+ * @possible_clones: bitmap of possible outputs this output could clone
+ * @interlace_allowed: can this output handle interlaced modes?
+ * @doublescan_allowed: can this output handle doublescan?
+ * @available_modes: modes available on this output (from get_modes() + 
user)
+ * @initial_x: initial x position for this output
+ * @initial_y: initial y position for this output
+ * @status: output connected?
+ * @subpixel_order: for this output
+ * @mm_width: displayable width of output in mm
+ * @mm_height: displayable height of output in mm
+ * @name: name of output (should be one of a few standard names)
+ * @funcs: output control functions
+ * @driver_private: private driver data
+ *
+ * Each output may be connected to one or more CRTCs, or may be 
clonable by
+ * another output if they can share a CRTC.  Each output also has a 
specific
+ * position in the broader display (referred to as a 'screen' though it 
could
+ * span multiple monitors).
+ */
+struct drm_output {
+	struct drm_device *dev;
+	struct list_head head;
+	struct drm_crtc *crtc;
+	int id; /* idr assigned */
+	unsigned long possible_crtcs;
+	unsigned long possible_clones;
+	bool interlace_allowed;
+	bool doublescan_allowed;
+	spinlock_t modes_lock; /* protects modes and probed_modes lists */
+	struct list_head modes; /* list of modes on this output */
+	/*
+	  OptionInfoPtr options;
+	  XF86ConfMonitorPtr conf_monitor;
+	 */
+	int initial_x, initial_y;
+	enum drm_output_status status;
+
+	/* these are modes added by probing with DDC or the BIOS */
+	struct list_head probed_modes;
+	
+	/* xf86MonPtr MonInfo; */
+	enum subpixel_order subpixel_order;
+	int mm_width, mm_height;
+	struct drm_display_info *monitor_info; /* if any */
+	char name[DRM_OUTPUT_LEN];
+	const struct drm_output_funcs *funcs;
+	void *driver_private;
+	/* RROutputPtr randr_output? */
+};
+
+/**
+ * struct drm_mode_config_funcs - configure CRTCs for a given screen 
layout
+ * @resize: adjust CRTCs as necessary for the proposed layout
+ *
+ * Currently only a resize hook is available.  DRM will call back into 
the
+ * driver with a new screen width and height.  If the driver can't 
support
+ * the proposed size, it can return false.  Otherwise it should adjust
+ * the CRTC<->output mappings as needed and update its view of the 
screen.
+ */
+struct drm_mode_config_funcs {
+	bool (*resize)(struct drm_device *dev, int width, int height);
+};
+
+/**
+ * drm_mode_config - Mode configuration control structure
+ *
+ */
+struct drm_mode_config {
+	spinlock_t config_lock; /* protects configuration and IDR */
+	struct idr crtc_idr; /* use this idr for all IDs, fb, crtc, output, 
modes - just makes life easier */
+	/* this is limited to one for now */
+	int num_fb;
+	struct list_head fb_list;
+	int num_output;
+	struct list_head output_list;
+
+	/* int compat_output? */
+	int num_crtc;
+	struct list_head crtc_list;
+
+	int min_width, min_height;
+	int max_width, max_height;
+	/* DamagePtr rotationDamage? */
+	/* DGA stuff? */
+	struct drm_mode_config_funcs *funcs;
+	unsigned long fb_base;
+};
+
+struct drm_output *drm_output_create(struct drm_device *dev,
+				     const struct drm_output_funcs *funcs,
+				     const char *name);
+extern void drm_output_destroy(struct drm_output *output);
+extern bool drm_output_rename(struct drm_output *output, const char 
*name);
+
+extern int drm_add_edid_modes(struct drm_output *output,
+			struct i2c_adapter *adapter);
+extern void drm_mode_probed_add(struct drm_output *output, struct 
drm_display_mode *mode);
+extern void drm_mode_remove(struct drm_output *output, struct 
drm_display_mode *mode);
+extern struct drm_display_mode *drm_mode_duplicate(struct drm_device 
*dev,
+						   struct drm_display_mode *mode);
+extern void drm_mode_debug_printmodeline(struct drm_device *dev,
+					 struct drm_display_mode *mode);
+extern void drm_mode_config_init(struct drm_device *dev);
+extern void drm_mode_config_cleanup(struct drm_device *dev);
+extern void drm_mode_set_name(struct drm_display_mode *mode);
+extern void drm_disable_unused_functions(struct drm_device *dev);
+
+extern struct drm_display_mode *drm_mode_create(struct drm_device 
*dev);
+extern void drm_mode_destroy(struct drm_device *dev, struct 
drm_display_mode *mode);
+extern void drm_mode_list_concat(struct list_head *head,
+				 struct list_head *new);
+extern void drm_mode_validate_size(struct drm_device *dev,
+				   struct list_head *mode_list,
+				   int maxX, int maxY, int maxPitch);
+extern void drm_mode_prune_invalid(struct drm_device *dev,
+				   struct list_head *mode_list, bool verbose);
+extern void drm_mode_sort(struct list_head *mode_list);
+extern int drm_mode_vrefresh(struct drm_display_mode *mode);
+extern void drm_mode_set_crtcinfo(struct drm_display_mode *p,
+				  int adjust_flags);
+extern struct drm_display_mode *drm_crtc_mode_create(struct drm_device 
*dev);
+extern bool drm_initial_config(struct drm_device *dev, bool cangrow);
+extern void drm_framebuffer_set_object(struct drm_device *dev,
+				       unsigned long handle);
+extern bool drm_set_desired_modes(struct drm_device *dev);
+extern int drmfb_probe(struct drm_device *dev, struct drm_framebuffer 
*fb);
+extern int drmfb_remove(struct drm_device *dev, struct drm_framebuffer 
*fb);
+
+/* IOCTLs */
+extern int drm_mode_getresources(struct inode *inode, struct file 
*filp,
+				 unsigned int cmd, unsigned long arg);
+
+extern int drm_mode_getcrtc(struct inode *inode, struct file *filp,
+			    unsigned int cmd, unsigned long arg);
+extern int drm_mode_getoutput(struct inode *inode, struct file *filp,
+			      unsigned int cmd, unsigned long arg);
+extern int drm_mode_setcrtc(struct inode *inode, struct file *filp,
+			    unsigned int cmd, unsigned long arg);
+extern int drm_mode_addfb(struct inode *inode, struct file *filp,
+			  unsigned int cmd, unsigned long arg);
+extern int drm_mode_rmfb(struct inode *inode, struct file *filp,
+			 unsigned int cmd, unsigned long arg);
+extern int drm_mode_getfb(struct inode *inode, struct file *filp,
+			  unsigned int cmd, unsigned long arg);
+#endif /* __DRM_CRTC_H__ */
+
diff --git a/linux-core/drm_drv.c b/linux-core/drm_drv.c
index e5788d7..5aa7137 100644
--- a/linux-core/drm_drv.c
+++ b/linux-core/drm_drv.c
@@ -123,6 +123,13 @@ static drm_ioctl_desc_t drm_ioctls[] = {
 					     DRM_AUTH },
 
 	[DRM_IOCTL_NR(DRM_IOCTL_UPDATE_DRAW)] = {drm_update_drawable_info, 
DRM_AUTH|DRM_MASTER|DRM_ROOT_ONLY},
+	[DRM_IOCTL_NR(DRM_IOCTL_MODE_GETRESOURCES)] = {drm_mode_getresources, 
DRM_MASTER|DRM_ROOT_ONLY},
+	[DRM_IOCTL_NR(DRM_IOCTL_MODE_GETCRTC)] = {drm_mode_getcrtc, 
DRM_MASTER|DRM_ROOT_ONLY},
+	[DRM_IOCTL_NR(DRM_IOCTL_MODE_GETOUTPUT)] = {drm_mode_getoutput, 
DRM_MASTER|DRM_ROOT_ONLY},
+	[DRM_IOCTL_NR(DRM_IOCTL_MODE_SETCRTC)] = {drm_mode_setcrtc, 
DRM_MASTER|DRM_ROOT_ONLY},
+	[DRM_IOCTL_NR(DRM_IOCTL_MODE_ADDFB)] = {drm_mode_addfb, DRM_MASTER|
DRM_ROOT_ONLY},
+	[DRM_IOCTL_NR(DRM_IOCTL_MODE_RMFB)] = {drm_mode_rmfb, DRM_MASTER|
DRM_ROOT_ONLY},
+	[DRM_IOCTL_NR(DRM_IOCTL_MODE_GETFB)] = {drm_mode_getfb, DRM_MASTER|
DRM_ROOT_ONLY},
 };
 
 #define DRM_CORE_IOCTL_COUNT	ARRAY_SIZE( drm_ioctls )
@@ -140,7 +147,7 @@ static drm_ioctl_desc_t drm_ioctls[] = {
 int drm_lastclose(drm_device_t * dev)
 {
 	drm_magic_entry_t *pt, *next;
-	drm_map_list_t *r_list;
+	drm_map_list_t *r_list, *r_list_tmp;
 	drm_vma_entry_t *vma, *vma_next;
 	int i;
 
@@ -150,8 +157,6 @@ int drm_lastclose(drm_device_t * dev)
 	 * We can't do much about this function failing.
 	 */
 
-	drm_bo_driver_finish(dev);
-
 	if (dev->driver->lastclose)
 		dev->driver->lastclose(dev);
 	DRM_DEBUG("driver lastclose completed\n");
@@ -233,10 +238,9 @@ int drm_lastclose(drm_device_t * dev)
 	}
 
 	if (dev->maplist) {
-		while (!list_empty(&dev->maplist->head)) {
-			struct list_head *list = dev->maplist->head.next;
-			r_list = list_entry(list, drm_map_list_t, head);
-			drm_rmmap_locked(dev, r_list->map);
+                list_for_each_entry_safe(r_list, r_list_tmp, 
&dev->maplist->head, head) {
+                        if (!(r_list->map->flags & _DRM_DRIVER))
+                                drm_rmmap_locked(dev, r_list->map);
 		}
 	}
 
@@ -260,8 +264,7 @@ int drm_lastclose(drm_device_t * dev)
 	if (drm_core_check_feature(dev, DRIVER_HAVE_DMA))
 		drm_dma_takedown(dev);
 
-	if (dev->lock.hw_lock) {
-		dev->sigdata.lock = dev->lock.hw_lock = NULL;	/* SHM removed */
+	if (dev->lock.filp) {
 		dev->lock.filp = NULL;
 		wake_up_interruptible(&dev->lock.lock_queue);
 	}
@@ -372,17 +375,6 @@ static void drm_cleanup(drm_device_t * dev)
 	drm_lastclose(dev);
 	drm_fence_manager_takedown(dev);
 
-	if (dev->maplist) {
-		drm_free(dev->maplist, sizeof(*dev->maplist), DRM_MEM_MAPS);
-		dev->maplist = NULL;
-		drm_ht_remove(&dev->map_hash);
-		drm_mm_takedown(&dev->offset_manager);
-		drm_ht_remove(&dev->object_hash);
-	}
-
-	if (!drm_fb_loaded)
-		pci_disable_device(dev->pdev);
-
 	drm_ctxbitmap_cleanup(dev);
 
 	if (drm_core_has_MTRR(dev) && drm_core_has_AGP(dev) && dev->agp
@@ -394,12 +386,26 @@ static void drm_cleanup(drm_device_t * dev)
 		DRM_DEBUG("mtrr_del=%d\n", retval);
 	}
 
+	if (dev->driver->unload)
+		dev->driver->unload(dev);
+        
 	if (drm_core_has_AGP(dev) && dev->agp) {
 		drm_free(dev->agp, sizeof(*dev->agp), DRM_MEM_AGPLISTS);
 		dev->agp = NULL;
 	}
-	if (dev->driver->unload)
-		dev->driver->unload(dev);
+
+
+        //	drm_bo_driver_finish(dev);
+	if (dev->maplist) {
+		drm_free(dev->maplist, sizeof(*dev->maplist), DRM_MEM_MAPS);
+		dev->maplist = NULL;
+		drm_ht_remove(&dev->map_hash);
+		drm_mm_takedown(&dev->offset_manager);
+		drm_ht_remove(&dev->object_hash);
+	}
+
+	if (!drm_fb_loaded)
+		pci_disable_device(dev->pdev);
 
 	drm_put_head(&dev->primary);
 	if (drm_put_dev(dev))
@@ -622,45 +628,3 @@ err_i1:
 	return retcode;
 }
 EXPORT_SYMBOL(drm_ioctl);
-
-int drm_wait_on(drm_device_t *dev, wait_queue_head_t *queue, int 
timeout,
-		int (*fn)(drm_device_t *dev, void *priv), void *priv)
-{
-	DECLARE_WAITQUEUE(entry, current);
-	unsigned long end = jiffies + (timeout);
-	int ret = 0;
-	add_wait_queue(queue, &entry);
-
-	for (;;) {
-		__set_current_state(TASK_INTERRUPTIBLE);
-		if ((*fn)(dev, priv))
-			break;
-		if (time_after_eq(jiffies, end)) {
-			ret = -EBUSY;
-			break;
-		}
-		schedule_timeout((HZ/100 > 1) ? HZ/100 : 1);
-		if (signal_pending(current)) {
-			ret = -EINTR;
-			break;
-		}
-	}
-	__set_current_state(TASK_RUNNING);
-	remove_wait_queue(queue, &entry);
-	return ret;
-}
-EXPORT_SYMBOL(drm_wait_on);
-
-drm_local_map_t *drm_getsarea(struct drm_device *dev)
-{
-	drm_map_list_t *entry;
-
-	list_for_each_entry(entry, &dev->maplist->head, head) {
-		if (entry->map && entry->map->type == _DRM_SHM &&
-		    (entry->map->flags & _DRM_CONTAINS_LOCK)) {
-			return entry->map;
-		}
-	}
-	return NULL;
-}
-EXPORT_SYMBOL(drm_getsarea);
diff --git a/linux-core/drm_edid.c b/linux-core/drm_edid.c
new file mode 100644
index 0000000..0d06792
--- /dev/null
+++ b/linux-core/drm_edid.c
@@ -0,0 +1,467 @@
+/*
+ * Copyright (c) 2007 Intel Corporation
+ *   Jesse Barnes <jesse.barnes@intel.com>
+ *
+ * DDC probing routines (drm_ddc_read & drm_do_probe_ddc_edid) 
originally from
+ * FB layer.
+ *   Copyright (C) 2006 Dennis Munsie <dmunsie@cecropia.com>
+ */
+#include <linux/i2c.h>
+#include <linux/i2c-algo-bit.h>
+#include "drmP.h"
+#include "drm_edid.h"
+
+/* Valid EDID header has these bytes */
+static u8 edid_header[] = { 0x00, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 
0x00 };
+
+/**
+ * edid_valid - sanity check EDID data
+ * @edid: EDID data
+ *
+ * Sanity check the EDID block by looking at the header, the version 
number
+ * and the checksum.  Return 0 if the EDID doesn't check out, or 1 if 
it's
+ * valid.
+ */
+static bool edid_valid(struct edid *edid)
+{
+	int i;
+	u8 csum = 0;
+	u8 *raw_edid = (u8 *)edid;
+
+	if (memcmp(edid->header, edid_header, sizeof(edid_header)))
+		goto bad;
+	if (edid->version != 1)
+		goto bad;
+	if (edid->revision <= 0 || edid->revision > 3)
+		goto bad;
+
+	for (i = 0; i < EDID_LENGTH; i++)
+		csum += raw_edid[i];
+	if (csum)
+		goto bad;
+
+	return 1;
+
+bad:
+	return 0;
+}
+
+/**
+ * drm_mode_std - convert standard mode info (width, height, refresh) 
into mode
+ * @t: standard timing params
+ *
+ * Take the standard timing params (in this case width, aspect, and 
refresh)
+ * and convert them into a real mode using CVT.
+ *
+ * Punts for now, but should eventually use the FB layer's CVT based 
mode
+ * generation code.
+ */
+struct drm_display_mode *drm_mode_std(struct drm_device *dev,
+				      struct std_timing *t)
+{
+//	struct fb_videomode mode;
+
+//	fb_find_mode_cvt(&mode, 0, 0);
+	/* JJJ:  convert to drm_display_mode */
+	struct drm_display_mode *mode;
+	int hsize = t->hsize * 8 + 248, vsize;
+
+	mode = drm_mode_create(dev);
+	if (!mode)
+		return NULL;
+
+	if (t->aspect_ratio == 0)
+		vsize = (hsize * 10) / 16;
+	else if (t->aspect_ratio == 1)
+		vsize = (hsize * 3) / 4;
+	else if (t->aspect_ratio == 2)
+		vsize = (hsize * 4) / 5;
+	else
+		vsize = (hsize * 9) / 16;
+
+	drm_mode_set_name(mode);
+
+	return mode;
+}
+
+/**
+ * drm_mode_detailed - create a new mode from an EDID detailed timing 
section
+ * @timing: EDID detailed timing info
+ * @preferred: is this a preferred mode?
+ *
+ * An EDID detailed timing block contains enough info for us to create 
and
+ * return a new struct drm_display_mode.  The @preferred flag will be 
set
+ * if this is the display's preferred timing, and we'll use it to 
indicate
+ * to the other layers that this mode is desired.
+ */
+struct drm_display_mode *drm_mode_detailed(drm_device_t *dev,
+					   struct detailed_timing *timing)
+{
+	struct drm_display_mode *mode;
+	struct detailed_pixel_timing *pt = &timing->data.pixel_data;
+
+	if (pt->stereo) {
+		printk(KERN_WARNING "stereo mode not supported\n");
+		return NULL;
+	}
+	if (!pt->separate_sync) {
+		printk(KERN_WARNING "integrated sync not supported\n");
+		return NULL;
+	}
+
+	mode = drm_mode_create(dev);
+	if (!mode)
+		return NULL;
+
+	mode->type = DRM_MODE_TYPE_DRIVER;
+	mode->clock = timing->pixel_clock * 10;
+
+	mode->hdisplay = (pt->hactive_hi << 8) | pt->hactive_lo;
+	mode->hsync_start = mode->hdisplay + ((pt->hsync_offset_hi << 8) |
+					      pt->hsync_offset_lo);
+	mode->hsync_end = mode->hsync_start +
+		((pt->hsync_pulse_width_hi << 8) |
+		 pt->hsync_pulse_width_lo);
+	mode->htotal = mode->hdisplay + ((pt->hblank_hi << 8) | 
pt->hblank_lo);
+
+	mode->vdisplay = (pt->vactive_hi << 8) | pt->vactive_lo;
+	mode->vsync_start = mode->vdisplay + ((pt->vsync_offset_hi << 8) |
+					      pt->vsync_offset_lo);
+	mode->vsync_end = mode->vsync_start +
+		((pt->vsync_pulse_width_hi << 8) |
+		 pt->vsync_pulse_width_lo);
+	mode->vtotal = mode->vdisplay + ((pt->vblank_hi << 8) | 
pt->vblank_lo);
+
+	drm_mode_set_name(mode);
+
+	if (pt->interlaced)
+		mode->flags |= V_INTERLACE;
+
+	mode->flags |= pt->hsync_positive ? V_PHSYNC : V_NHSYNC;
+	mode->flags |= pt->vsync_positive ? V_PVSYNC : V_NVSYNC;
+
+	return mode;
+}
+
+/*
+ * Detailed mode info for the EDID "established modes" data to use.
+ */
+static struct drm_display_mode edid_est_modes[] = {
+	{ DRM_MODE("800x600", DRM_MODE_TYPE_DRIVER, 40000, 800, 840,
+		   968, 1056, 0, 600, 601, 605, 628, 0,
+		   V_PHSYNC | V_PVSYNC) }, /* 800x600@60Hz */
+	{ DRM_MODE("800x600", DRM_MODE_TYPE_DRIVER, 36000, 800, 824,
+		   896, 1024, 0, 600, 601, 603,  625, 0,
+		   V_PHSYNC | V_PVSYNC) }, /* 800x600@56Hz */
+	{ DRM_MODE("640x480", DRM_MODE_TYPE_DRIVER, 31500, 640, 656,
+		   720, 840, 0, 480, 481, 484, 500, 0,
+		   V_NHSYNC | V_NVSYNC) }, /* 640x480@75Hz */
+	{ DRM_MODE("640x480", DRM_MODE_TYPE_DRIVER, 31500, 640, 664,
+		   704,  832, 0, 480, 489, 491, 520, 0,
+		   V_NHSYNC | V_NVSYNC) }, /* 640x480@72Hz */
+	{ DRM_MODE("640x480", DRM_MODE_TYPE_DRIVER, 30240, 640, 704,
+		   768,  864, 0, 480, 483, 486, 525, 0,
+		   V_NHSYNC | V_NVSYNC) }, /* 640x480@67Hz */
+	{ DRM_MODE("640x480", DRM_MODE_TYPE_DRIVER, 25200, 640, 656,
+		   752, 800, 0, 480, 490, 492, 525, 0,
+		   V_NHSYNC | V_NVSYNC) }, /* 640x480@60Hz */
+	{ DRM_MODE("720x400", DRM_MODE_TYPE_DRIVER, 35500, 720, 738,
+		   846, 900, 0, 400, 421, 423,  449, 0,
+		   V_NHSYNC | V_NVSYNC) }, /* 720x400@88Hz */
+	{ DRM_MODE("720x400", DRM_MODE_TYPE_DRIVER, 28320, 720, 738,
+		   846,  900, 0, 400, 412, 414, 449, 0,
+		   V_NHSYNC | V_PVSYNC) }, /* 720x400@70Hz */
+	{ DRM_MODE("1280x1024", DRM_MODE_TYPE_DRIVER, 135000, 1280, 1296,
+		   1440, 1688, 0, 1024, 1025, 1028, 1066, 0,
+		   V_PHSYNC | V_PVSYNC) }, /* 1280x1024@75Hz */
+	{ DRM_MODE("1024x768", DRM_MODE_TYPE_DRIVER, 78800, 1024, 1040,
+		   1136, 1312, 0,  768, 769, 772, 800, 0,
+		   V_PHSYNC | V_PVSYNC) }, /* 1024x768@75Hz */
+	{ DRM_MODE("1024x768", DRM_MODE_TYPE_DRIVER, 75000, 1024, 1048,
+		   1184, 1328, 0,  768, 771, 777, 806, 0,
+		   V_NHSYNC | V_NVSYNC) }, /* 1024x768@70Hz */
+	{ DRM_MODE("1024x768", DRM_MODE_TYPE_DRIVER, 65000, 1024, 1048,
+		   1184, 1344, 0,  768, 771, 777, 806, 0,
+		   V_NHSYNC | V_NVSYNC) }, /* 1024x768@60Hz */
+	{ DRM_MODE("1024x768", DRM_MODE_TYPE_DRIVER,44900, 1024, 1032,
+		   1208, 1264, 0, 768, 768, 776, 817, 0,
+		   V_PHSYNC | V_PVSYNC | V_INTERLACE) }, /* 1024x768@43Hz */
+	{ DRM_MODE("832x624", DRM_MODE_TYPE_DRIVER, 57284, 832, 864,
+		   928, 1152, 0, 624, 625, 628, 667, 0,
+		   V_NHSYNC | V_NVSYNC) }, /* 832x624@75Hz */
+	{ DRM_MODE("800x600", DRM_MODE_TYPE_DRIVER, 49500, 800, 816,
+		   896, 1056, 0, 600, 601, 604,  625, 0,
+		   V_PHSYNC | V_PVSYNC) }, /* 800x600@75Hz */
+	{ DRM_MODE("800x600", DRM_MODE_TYPE_DRIVER, 50000, 800, 856,
+		   976, 1040, 0, 600, 637, 643, 666, 0,
+		   V_PHSYNC | V_PVSYNC) }, /* 800x600@72Hz */
+	{ DRM_MODE("1152x864", DRM_MODE_TYPE_DRIVER, 108000, 1152, 1216,
+		   1344, 1600, 0,  864, 865, 868, 900, 0,
+		   V_PHSYNC | V_PVSYNC) }, /* 1152x864@75Hz */
+};
+
+#define EDID_EST_TIMINGS 16
+#define EDID_STD_TIMINGS 8
+#define EDID_DETAILED_TIMINGS 4
+
+/**
+ * add_established_modes - get est. modes from EDID and add them
+ * @edid: EDID block to scan
+ *
+ * Each EDID block contains a bitmap of the supported "established 
modes" list
+ * (defined above).  Tease them out and add them to the global modes 
list.
+ */
+static int add_established_modes(struct drm_output *output, struct edid 
*edid)
+{
+	struct drm_device *dev = output->dev;
+	unsigned long est_bits = edid->established_timings.t1 |
+		(edid->established_timings.t2 << 8) |
+		((edid->established_timings.mfg_rsvd & 0x80) << 9);
+	int i, modes = 0;
+
+	for (i = 0; i <= EDID_EST_TIMINGS; i++)
+		if (est_bits & (1<<i)) {
+			struct drm_display_mode *newmode;
+			newmode = drm_mode_duplicate(dev, &edid_est_modes[i]);
+			drm_mode_probed_add(output, newmode);
+			modes++;
+		}
+
+	return modes;
+}
+
+/**
+ * add_standard_modes - get std. modes from EDID and add them
+ * @edid: EDID block to scan
+ *
+ * Standard modes can be calculated using the CVT standard.  Grab them 
from
+ * @edid, calculate them, and add them to the list.
+ */
+static int add_standard_modes(struct drm_output *output, struct edid 
*edid)
+{
+	struct drm_device *dev = output->dev;
+	int i, modes = 0;
+
+	for (i = 0; i < EDID_STD_TIMINGS; i++) {
+		struct std_timing *t = &edid->standard_timings[i];
+		struct drm_display_mode *newmode;
+
+		/* If std timings bytes are 1, 1 it's empty */
+		if (t->hsize == 1 && (t->aspect_ratio | t->vfreq) == 1)
+			continue;
+
+		newmode = drm_mode_std(dev, &edid->standard_timings[i]);
+		drm_mode_probed_add(output, newmode);
+		modes++;
+	}
+
+	return modes;
+}
+
+/**
+ * add_detailed_modes - get detailed mode info from EDID data
+ * @edid: EDID block to scan
+ *
+ * Some of the detailed timing sections may contain mode information.  
Grab
+ * it and add it to the list.
+ */
+static int add_detailed_info(struct drm_output *output, struct edid 
*edid)
+{
+	struct drm_device *dev = output->dev;
+	int i, j, modes = 0;
+
+	for (i = 0; i < EDID_DETAILED_TIMINGS; i++) {
+		struct detailed_timing *timing = &edid->detailed_timings[i];
+		struct detailed_non_pixel *data = &timing->data.other_data;
+		struct drm_display_mode *newmode;
+
+		/* EDID up to and including 1.2 may put monitor info here */
+		if (edid->version == 1 && edid->revision < 3)
+			continue;
+
+		/* Detailed mode timing */
+		if (timing->pixel_clock) {
+			newmode = drm_mode_detailed(dev, timing);
+			/* First detailed mode is preferred */
+			if (i == 0 && edid->preferred_timing)
+				newmode->type |= DRM_MODE_TYPE_PREFERRED;
+			drm_mode_probed_add(output, newmode);
+				     
+			modes++;
+			continue;
+		}
+
+		/* Other timing or info */
+		switch (data->type) {
+		case EDID_DETAIL_MONITOR_SERIAL:
+			break;
+		case EDID_DETAIL_MONITOR_STRING:
+			break;
+		case EDID_DETAIL_MONITOR_RANGE:
+			/* Get monitor range data */
+			break;
+		case EDID_DETAIL_MONITOR_NAME:
+			break;
+		case EDID_DETAIL_MONITOR_CPDATA:
+			break;
+		case EDID_DETAIL_STD_MODES:
+			/* Five modes per detailed section */
+			for (j = 0; j < 5; i++) {
+				struct std_timing *std;
+				struct drm_display_mode *newmode;
+
+				std = &data->data.timings[j];
+				newmode = drm_mode_std(dev, std);
+				drm_mode_probed_add(output, newmode);
+				modes++;
+			}
+			break;
+		default:
+			break;
+		}
+	}
+
+	return modes;
+}
+
+#define DDC_ADDR 0x50
+
+static unsigned char *drm_do_probe_ddc_edid(struct i2c_adapter 
*adapter)
+{
+	unsigned char start = 0x0;
+	unsigned char *buf = kmalloc(EDID_LENGTH, GFP_KERNEL);
+	struct i2c_msg msgs[] = {
+		{
+			.addr	= DDC_ADDR,
+			.flags	= 0,
+			.len	= 1,
+			.buf	= &start,
+		}, {
+			.addr	= DDC_ADDR,
+			.flags	= I2C_M_RD,
+			.len	= EDID_LENGTH,
+			.buf	= buf,
+		}
+	};
+
+	if (!buf) {
+		dev_warn(&adapter->dev, "unable to allocate memory for EDID "
+			 "block.\n");
+		return NULL;
+	}
+
+	if (i2c_transfer(adapter, msgs, 2) == 2)
+		return buf;
+
+	dev_info(&adapter->dev, "unable to read EDID block.\n");
+	kfree(buf);
+	return NULL;
+}
+
+static unsigned char *drm_ddc_read(struct i2c_adapter *adapter)
+{
+	struct i2c_algo_bit_data *algo_data = adapter->algo_data;
+	unsigned char *edid = NULL;
+	int i, j;
+
+	/*
+	 * Startup the bus:
+	 *   Set clock line high (but give it time to come up)
+	 *   Then set clock & data low
+	 */
+	algo_data->setscl(algo_data->data, 1);
+	udelay(550); /* startup delay */
+	algo_data->setscl(algo_data->data, 0);
+	algo_data->setsda(algo_data->data, 0);
+
+	for (i = 0; i < 3; i++) {
+		/* For some old monitors we need the
+		 * following process to initialize/stop DDC
+		 */
+		algo_data->setsda(algo_data->data, 0);
+		msleep(13);
+
+		algo_data->setscl(algo_data->data, 1);
+		for (j = 0; j < 5; j++) {
+			msleep(10);
+			if (algo_data->getscl(algo_data->data))
+				break;
+		}
+		if (j == 5)
+			continue;
+
+		algo_data->setsda(algo_data->data, 0);
+		msleep(15);
+		algo_data->setscl(algo_data->data, 0);
+		msleep(15);
+		algo_data->setsda(algo_data->data, 1);
+		msleep(15);
+
+		/* Do the real work */
+		edid = drm_do_probe_ddc_edid(adapter);
+		algo_data->setsda(algo_data->data, 0);
+		algo_data->setscl(algo_data->data, 0);
+		msleep(15);
+
+		algo_data->setscl(algo_data->data, 1);
+		for (j = 0; j < 10; j++) {
+			msleep(10);
+			if (algo_data->getscl(algo_data->data))
+				break;
+		}
+
+		algo_data->setsda(algo_data->data, 1);
+		msleep(15);
+		algo_data->setscl(algo_data->data, 0);
+		if (edid)
+			break;
+	}
+	/* Release the DDC lines when done or the Apple Cinema HD display
+	 * will switch off
+	 */
+	algo_data->setsda(algo_data->data, 0);
+	algo_data->setscl(algo_data->data, 0);
+	algo_data->setscl(algo_data->data, 1);
+
+	return edid;
+}
+
+/**
+ * drm_add_edid_modes - add modes from EDID data, if available
+ * @output: output we're probing
+ * @adapter: i2c adapter to use for DDC
+ *
+ * Poke the given output's i2c channel to grab EDID data if possible.  
If we
+ * get any, add the specified modes to the output's mode list.
+ *
+ * Return number of modes added or 0 if we couldn't find any.
+ */
+int drm_add_edid_modes(struct drm_output *output, struct i2c_adapter 
*adapter)
+{
+	struct edid *edid;
+	int num_modes = 0;
+
+	edid = (struct edid *)drm_ddc_read(adapter);
+	if (!edid) {
+		dev_warn(&output->dev->pdev->dev, "%s: no EDID data\n",
+			 output->name);
+		goto out_err;
+	}
+
+	if (!edid_valid(edid)) {
+		dev_warn(&output->dev->pdev->dev, "%s: EDID invalid.\n",
+			 output->name);
+		goto out_err;
+	}
+
+	num_modes += add_established_modes(output, edid);
+	num_modes += add_standard_modes(output, edid);
+	num_modes += add_detailed_info(output, edid);
+
+	return num_modes;
+
+out_err:
+	kfree(edid);
+	return 0;
+}
+EXPORT_SYMBOL(drm_add_edid_modes);
diff --git a/linux-core/drm_edid.h b/linux-core/drm_edid.h
new file mode 100644
index 0000000..0d2eeaa
--- /dev/null
+++ b/linux-core/drm_edid.h
@@ -0,0 +1,176 @@
+#ifndef __DRM_EDID_H__
+#define __DRM_EDID_H__
+
+#include <linux/types.h>
+
+#define EDID_LENGTH 128
+#define DDC_ADDR 0x50
+
+#ifdef BIG_ENDIAN
+#error "EDID structure is little endian, need big endian versions"
+#endif
+
+struct est_timings {
+	u8 t1;
+	u8 t2;
+	u8 mfg_rsvd;
+} __attribute__((packed));
+
+struct std_timing {
+	u8 hsize; /* need to multiply by 8 then add 248 */
+	u8 vfreq:6; /* need to add 60 */
+	u8 aspect_ratio:2; /* 00=16:10, 01=4:3, 10=5:4, 11=16:9 */
+} __attribute__((packed));
+
+/* If detailed data is pixel timing */
+struct detailed_pixel_timing {
+	u8 hactive_lo;
+	u8 hblank_lo;
+	u8 hblank_hi:4;
+	u8 hactive_hi:4;
+	u8 vactive_lo;
+	u8 vblank_lo;
+	u8 vblank_hi:4;
+	u8 vactive_hi:4;
+	u8 hsync_offset_lo;
+	u8 hsync_pulse_width_lo;
+	u8 vsync_pulse_width_lo:4;
+	u8 vsync_offset_lo:4;
+	u8 hsync_pulse_width_hi:2;
+	u8 hsync_offset_hi:2;
+	u8 vsync_pulse_width_hi:2;
+	u8 vsync_offset_hi:2;
+	u8 width_mm_lo;
+	u8 height_mm_lo;
+	u8 height_mm_hi:4;
+	u8 width_mm_hi:4;
+	u8 hborder;
+	u8 vborder;
+	u8 unknown0:1;
+	u8 vsync_positive:1;
+	u8 hsync_positive:1;
+	u8 separate_sync:2;
+	u8 stereo:1;
+	u8 unknown6:1;
+	u8 interlaced:1;
+} __attribute__((packed));
+
+/* If it's not pixel timing, it'll be one of the below */
+struct detailed_data_string {
+	u8 str[13];
+} __attribute__((packed));
+
+struct detailed_data_monitor_range {
+	u8 min_vfreq;
+	u8 max_vfreq;
+	u8 min_hfreq_khz;
+	u8 max_hfreq_khz;
+	u8 pixel_clock_mhz; /* need to multiply by 10 */
+	u16 sec_gtf_toggle; /* A000=use above, 20=use below */ /* FIXME: byte 
order */
+	u8 hfreq_start_khz; /* need to multiply by 2 */
+	u8 c; /* need to divide by 2 */
+	u16 m; /* FIXME: byte order */
+	u8 k;
+	u8 j; /* need to divide by 2 */
+} __attribute__((packed));
+
+struct detailed_data_wpindex {
+	u8 white_y_lo:2;
+	u8 white_x_lo:2;
+	u8 pad:4;
+	u8 white_x_hi;
+	u8 white_y_hi;
+	u8 gamma; /* need to divide by 100 then add 1 */
+} __attribute__((packed));
+
+struct detailed_data_color_point {
+	u8 windex1;
+	u8 wpindex1[3];
+	u8 windex2;
+	u8 wpindex2[3];
+} __attribute__((packed));
+
+struct detailed_non_pixel {
+	u8 pad1;
+	u8 type; /* ff=serial, fe=string, fd=monitor range, fc=monitor name
+		    fb=color point data, fa=standard timing data,
+		    f9=undefined, f8=mfg. reserved */
+	u8 pad2;
+	union {
+		struct detailed_data_string str;
+		struct detailed_data_monitor_range range;
+		struct detailed_data_wpindex color;
+		struct std_timing timings[5];
+	} data;
+} __attribute__((packed));
+
+#define EDID_DETAIL_STD_MODES 0xfa
+#define EDID_DETAIL_MONITOR_CPDATA 0xfb
+#define EDID_DETAIL_MONITOR_NAME 0xfc
+#define EDID_DETAIL_MONITOR_RANGE 0xfd
+#define EDID_DETAIL_MONITOR_STRING 0xfe
+#define EDID_DETAIL_MONITOR_SERIAL 0xff
+
+struct detailed_timing {
+	u16 pixel_clock; /* need to multiply by 10 KHz */ /* FIXME: byte order 
*/
+	union {
+		struct detailed_pixel_timing pixel_data;
+		struct detailed_non_pixel other_data;
+	} data;
+} __attribute__((packed));
+
+struct edid {
+	u8 header[8];
+	/* Vendor & product info */
+	u16 mfg_id; /* FIXME: byte order */
+	u16 prod_code; /* FIXME: byte order */
+	u32 serial; /* FIXME: byte order */
+	u8 mfg_week;
+	u8 mfg_year;
+	/* EDID version */
+	u8 version;
+	u8 revision;
+	/* Display info: */
+	/*   input definition */
+	u8 serration_vsync:1;
+	u8 sync_on_green:1;
+	u8 composite_sync:1;
+	u8 separate_syncs:1;
+	u8 blank_to_black:1;
+	u8 video_level:2;
+	u8 digital:1; /* bits below must be zero if set */
+	u8 width_cm;
+	u8 height_cm;
+	u8 gamma;
+	/*   feature support */
+	u8 default_gtf:1;
+	u8 preferred_timing:1;
+	u8 standard_color:1;
+	u8 display_type:2; /* 00=mono, 01=rgb, 10=non-rgb, 11=unknown */
+	u8 pm_active_off:1;
+	u8 pm_suspend:1;
+	u8 pm_standby:1;
+	/* Color characteristics */
+	u8 red_green_lo;
+	u8 black_white_lo;
+	u8 red_x;
+	u8 red_y;
+	u8 green_x;
+	u8 green_y;
+	u8 blue_x;
+	u8 blue_y;
+	u8 white_x;
+	u8 white_y;
+	/* Est. timings and mfg rsvd timings*/
+	struct est_timings established_timings;
+	/* Standard timings 1-8*/
+	struct std_timing standard_timings[8];
+	/* Detailing timings 1-4 */
+	struct detailed_timing detailed_timings[4];
+	/* Number of 128 byte ext. blocks */
+	u8 extensions;
+	/* Checksum */
+	u8 checksum;
+} __attribute__((packed));
+
+#endif /* __DRM_EDID_H__ */
diff --git a/linux-core/drm_fb.c b/linux-core/drm_fb.c
new file mode 100644
index 0000000..ef05341
--- /dev/null
+++ b/linux-core/drm_fb.c
@@ -0,0 +1,201 @@
+/*
+ * Copyright © 2007 David Airlie
+ *
+ * Permission is hereby granted, free of charge, to any person 
obtaining a
+ * copy of this software and associated documentation files 
(the "Software"),
+ * to deal in the Software without restriction, including without 
limitation
+ * the rights to use, copy, modify, merge, publish, distribute, 
sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom 
the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the 
next
+ * paragraph) shall be included in all copies or substantial portions 
of the
+ * Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT 
SHALL
+ * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR 
OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, 
ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
+ *
+ * Authors:
+ *     David Airlie
+ */
+    /*
+     *  Modularization
+     */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/string.h>
+#include <linux/mm.h>
+#include <linux/tty.h>
+#include <linux/slab.h>
+#include <linux/delay.h>
+#include <linux/fb.h>
+#include <linux/init.h>
+
+#include "drmP.h"
+struct drmfb_par {
+	struct drm_device *dev;
+	struct drm_framebuffer *fb;
+};
+
+static int drmfb_setcolreg(unsigned regno, unsigned red, unsigned 
green,
+			   unsigned blue, unsigned transp,
+			   struct fb_info *info)
+{
+	struct drmfb_par *par = info->par;
+	struct drm_framebuffer *fb = par->fb;
+	if (regno > 17)
+		return 1;
+
+	if (regno < 16) {
+		switch (fb->depth) {
+		case 15:
+			fb->pseudo_palette[regno] = ((red & 0xf800) >>  1) |
+				((green & 0xf800) >>  6) |
+				((blue & 0xf800) >> 11);
+			break;
+		case 16:
+			fb->pseudo_palette[regno] = (red & 0xf800) |
+				((green & 0xfc00) >>  5) |
+				((blue  & 0xf800) >> 11);
+			break;
+		case 24:
+		case 32:
+			fb->pseudo_palette[regno] = ((red & 0xff00) << 8) |
+				(green & 0xff00) |
+				((blue  & 0xff00) >> 8);
+			break;
+		}
+	}
+
+	return 0;
+}
+
+/* this will let fbcon do the mode init */
+static int drmfb_set_par(struct fb_info *info)
+{
+	struct drmfb_par *par = info->par;
+	struct drm_device *dev = par->dev;
+
+	drm_set_desired_modes(dev);
+	return 0;
+}
+
+static struct fb_ops drmfb_ops = {
+	.owner = THIS_MODULE,
+	//	.fb_open = drmfb_open,
+	//	.fb_read = drmfb_read,
+	//	.fb_write = drmfb_write,
+	//	.fb_release = drmfb_release,
+	//	.fb_ioctl = drmfb_ioctl,
+	.fb_set_par = drmfb_set_par,
+	.fb_setcolreg = drmfb_setcolreg,
+	.fb_fillrect = cfb_fillrect,
+	.fb_copyarea = cfb_copyarea,
+	.fb_imageblit = cfb_imageblit,
+};
+
+int drmfb_probe(struct drm_device *dev, struct drm_framebuffer *fb)
+{
+	struct fb_info *info;
+	struct drmfb_par *par;
+	struct device *device = &dev->pdev->dev; 
+	struct fb_var_screeninfo *var_info;
+	unsigned long base, size;
+	int ret;
+
+	info = framebuffer_alloc(sizeof(struct drmfb_par), device);
+	if (!info){
+		return -EINVAL;
+	}
+
+	fb->fbdev = info;
+		
+	par = info->par;
+
+	par->dev = dev;
+	par->fb = fb;
+
+	info->fbops = &drmfb_ops;
+
+	strcpy(info->fix.id, "drmfb");
+	info->fix.smem_start = fb->offset + dev->mode_config.fb_base;
+	info->fix.smem_len = (8*1024*1024);
+	info->fix.type = FB_TYPE_PACKED_PIXELS;
+	info->fix.visual = FB_VISUAL_DIRECTCOLOR;
+	info->fix.accel = FB_ACCEL_NONE;
+	info->fix.type_aux = 0;
+	info->fix.mmio_start = 0;
+	info->fix.mmio_len = 0;
+	info->fix.line_length = fb->pitch * ((fb->bits_per_pixel + 1) / 8);
+
+	info->flags = FBINFO_DEFAULT;
+
+	ret = drm_mem_reg_ioremap(dev, &fb->bo->mem, &fb->virtual_base);
+	if (ret)
+		DRM_ERROR("error mapping fb: %d\n", ret);
+
+	info->screen_base = fb->virtual_base;
+	info->screen_size = size;
+	info->pseudo_palette = fb->pseudo_palette;
+	info->var.xres = fb->width;
+	info->var.xres_virtual = fb->pitch;
+	info->var.yres = fb->height;
+	info->var.yres_virtual = fb->height;
+	info->var.bits_per_pixel = fb->bits_per_pixel;
+	info->var.xoffset = 0;
+	info->var.yoffset = 0;
+	info->var.activate = FB_ACTIVATE_NOW;
+	info->var.height = -1;
+	info->var.width = -1;
+	info->var.vmode = FB_VMODE_NONINTERLACED;
+
+	DRM_DEBUG("fb depth is %d\n", fb->depth);
+	switch(fb->depth) {
+	case 8:
+	case 15:
+	case 16:
+		break;
+	default:
+	case 24:
+	case 32:
+		info->var.red.offset = 16;
+		info->var.green.offset = 8;
+		info->var.blue.offset = 0;
+		info->var.red.length = info->var.green.length =
+			info->var.blue.length = 8;
+		if (fb->depth == 32) {
+			info->var.transp.offset = 24;
+			info->var.transp.length = 8;
+		}
+		break;
+	}
+
+	if (register_framebuffer(info) < 0)
+		return -EINVAL;
+
+	printk(KERN_INFO "fb%d: %s frame buffer device\n", info->node,
+	       info->fix.id);
+	return 0;
+}
+EXPORT_SYMBOL(drmfb_probe);
+
+int drmfb_remove(struct drm_device *dev, struct drm_framebuffer *fb)
+{
+	struct fb_info *info = fb->fbdev;
+	
+	if (info) {
+		drm_mem_reg_iounmap(dev, &fb->bo->mem, fb->virtual_base);
+		unregister_framebuffer(info);
+		framebuffer_release(info);
+	}
+	return 0;
+}
+EXPORT_SYMBOL(drmfb_remove);
+MODULE_LICENSE("GPL");
diff --git a/linux-core/drm_fops.c b/linux-core/drm_fops.c
index d400a4d..e474897 100644
--- a/linux-core/drm_fops.c
+++ b/linux-core/drm_fops.c
@@ -86,7 +86,7 @@ static int drm_setup(drm_device_t * dev)
 	INIT_LIST_HEAD(&dev->ctxlist->head);
 
 	dev->vmalist = NULL;
-	dev->sigdata.lock = NULL;
+	//	dev->sigdata.lock = NULL;
 	init_waitqueue_head(&dev->lock.lock_queue);
 	dev->queue_count = 0;
 	dev->queue_reserved = 0;
@@ -270,6 +270,7 @@ static int drm_open_helper(struct inode *inode, 
struct file *filp,
 
 	INIT_LIST_HEAD(&priv->user_objects);
 	INIT_LIST_HEAD(&priv->refd_objects);
+	INIT_LIST_HEAD(&priv->fbs);
 
 	for (i=0; i<_DRM_NO_REF_TYPES; ++i) {
 		ret = drm_ht_create(&priv->refd_object_hash[i], DRM_FILE_HASH_ORDER);
@@ -501,6 +502,7 @@ int drm_release(struct inode *inode, struct file 
*filp)
 	mutex_unlock(&dev->ctxlist_mutex);
 
 	mutex_lock(&dev->struct_mutex);
+	drm_fb_release(filp);
 	drm_object_release(filp);
 	if (priv->remove_auth_on_close == 1) {
 		drm_file_t *temp = dev->file_first;
diff --git a/linux-core/drm_modes.c b/linux-core/drm_modes.c
new file mode 100644
index 0000000..3293f91
--- /dev/null
+++ b/linux-core/drm_modes.c
@@ -0,0 +1,558 @@
+/*
+ * Copyright © 1997-2003 by The XFree86 Project, Inc.
+ *
+ * Permission is hereby granted, free of charge, to any person 
obtaining a
+ * copy of this software and associated documentation files 
(the "Software"),
+ * to deal in the Software without restriction, including without 
limitation
+ * the rights to use, copy, modify, merge, publish, distribute, 
sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom 
the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be 
included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT 
SHALL
+ * THE COPYRIGHT HOLDER(S) OR AUTHOR(S) BE LIABLE FOR ANY CLAIM, 
DAMAGES OR
+ * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
OTHERWISE,
+ * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE 
OR
+ * OTHER DEALINGS IN THE SOFTWARE.
+ *
+ * Except as contained in this notice, the name of the copyright 
holder(s)
+ * and author(s) shall not be used in advertising or otherwise to 
promote
+ * the sale, use or other dealings in this Software without prior 
written
+ * authorization from the copyright holder(s) and author(s).
+ */
+/*
+ * Copyright © 2007 Dave Airlie
+ */
+
+#include <linux/list.h>
+#include "drmP.h"
+#include "drm.h"
+#include "drm_crtc.h"
+
+/**
+ * drm_mode_debug_printmodeline - debug print a mode
+ * @dev: DRM device
+ * @mode: mode to print
+ *
+ * LOCKING:
+ * None.
+ *
+ * Describe @mode using DRM_DEBUG.
+ */
+void drm_mode_debug_printmodeline(struct drm_device *dev,
+				  struct drm_display_mode *mode)
+{
+	DRM_DEBUG("Modeline %d:\"%s\" %d %d %d %d %d %d %d %d %d %d\n",
+		  mode->mode_id, mode->name, mode->vrefresh, mode->clock,
+		  mode->hdisplay, mode->hsync_start,
+		  mode->hsync_end, mode->htotal,
+		  mode->vdisplay, mode->vsync_start,
+		  mode->vsync_end, mode->vtotal);
+}
+EXPORT_SYMBOL(drm_mode_debug_printmodeline);
+
+/**
+ * drm_mode_set_name - set the name on a mode
+ * @mode: name will be set in this mode
+ *
+ * LOCKING:
+ * None.
+ *
+ * Set the name of @mode to a standard format.
+ */
+void drm_mode_set_name(struct drm_display_mode *mode)
+{
+	snprintf(mode->name, DRM_DISPLAY_MODE_LEN, "%dx%d", mode->hdisplay,
+		 mode->vdisplay);
+}
+EXPORT_SYMBOL(drm_mode_set_name);
+
+/**
+ * drm_mode_list_concat - move modes from one list to another
+ * @head: source list
+ * @new: dst list
+ *
+ * LOCKING:
+ * Caller must ensure both lists are locked.
+ *
+ * Move all the modes from @head to @new.
+ */
+void drm_mode_list_concat(struct list_head *head, struct list_head 
*new)
+{
+
+	struct list_head *entry, *tmp;
+
+	list_for_each_safe(entry, tmp, head) {
+		list_move_tail(entry, new);
+	}
+}
+
+/**
+ * drm_mode_width - get the width of a mode
+ * @mode: mode
+ *
+ * LOCKING:
+ * None.
+ *
+ * Return @mode's width (hdisplay) value.
+ *
+ * FIXME: is this needed?
+ *
+ * RETURNS:
+ * @mode->hdisplay
+ */
+int drm_mode_width(struct drm_display_mode *mode)
+{
+	return mode->hdisplay;
+
+}
+EXPORT_SYMBOL(drm_mode_width);
+
+/**
+ * drm_mode_height - get the height of a mode
+ * @mode: mode
+ *
+ * LOCKING:
+ * None.
+ *
+ * Return @mode's height (vdisplay) value.
+ *
+ * FIXME: is this needed?
+ *
+ * RETURNS:
+ * @mode->vdisplay
+ */
+int drm_mode_height(struct drm_display_mode *mode)
+{
+	return mode->vdisplay;
+}
+EXPORT_SYMBOL(drm_mode_height);
+
+/**
+ * drm_mode_vrefresh - get the vrefresh of a mode
+ * @mode: mode
+ *
+ * LOCKING:
+ * None.
+ *
+ * Return @mode's vrefresh rate or calculate it if necessary.
+ *
+ * FIXME: why is this needed?
+ *
+ * RETURNS:
+ * Vertical refresh rate of @mode x 1000. For precision reasons.
+ */
+int drm_mode_vrefresh(struct drm_display_mode *mode)
+{
+	int refresh = 0;
+	unsigned int calc_val;
+
+	if (mode->vrefresh > 0)
+		refresh = mode->vrefresh;
+	else if (mode->htotal > 0 && mode->vtotal > 0) {
+		/* work out vrefresh the value will be x1000 */
+		calc_val = (mode->clock * 1000);
+
+		calc_val /= mode->htotal;
+		calc_val *= 1000;
+		calc_val /= mode->vtotal;
+
+		refresh = calc_val;
+		if (mode->flags & V_INTERLACE)
+			refresh *= 2;
+		if (mode->flags & V_DBLSCAN)
+			refresh /= 2;
+		if (mode->vscan > 1)
+			refresh /= mode->vscan;
+	}
+	return refresh;
+}
+EXPORT_SYMBOL(drm_mode_vrefresh);
+	
+/**
+ * drm_mode_set_crtcinfo - set CRTC modesetting parameters
+ * @p: mode
+ * @adjust_flags: unused? (FIXME)
+ *
+ * LOCKING:
+ * None.
+ *
+ * Setup the CRTC modesetting parameters for @p, adjusting if 
necessary.
+ */
+void drm_mode_set_crtcinfo(struct drm_display_mode *p, int 
adjust_flags)
+{
+	if ((p == NULL) || ((p->type & DRM_MODE_TYPE_CRTC_C) == 
DRM_MODE_TYPE_BUILTIN))
+		return;
+
+	p->crtc_hdisplay = p->hdisplay;
+	p->crtc_hsync_start = p->hsync_start;
+	p->crtc_hsync_end = p->hsync_end;
+	p->crtc_htotal = p->htotal;
+	p->crtc_hskew = p->hskew;
+	p->crtc_vdisplay = p->vdisplay;
+	p->crtc_vsync_start = p->vsync_start;
+	p->crtc_vsync_end = p->vsync_end;
+	p->crtc_vtotal = p->vtotal;
+
+	if (p->flags & V_INTERLACE) {
+		if (adjust_flags & CRTC_INTERLACE_HALVE_V) {
+			p->crtc_vdisplay /= 2;
+			p->crtc_vsync_start /= 2;
+			p->crtc_vsync_end /= 2;
+			p->crtc_vtotal /= 2;
+		}
+
+		p->crtc_vtotal |= 1;
+	}
+
+	if (p->flags & V_DBLSCAN) {
+		p->crtc_vdisplay *= 2;
+		p->crtc_vsync_start *= 2;
+		p->crtc_vsync_end *= 2;
+		p->crtc_vtotal *= 2;
+	}
+
+	if (p->vscan > 1) {
+		p->crtc_vdisplay *= p->vscan;
+		p->crtc_vsync_start *= p->vscan;
+		p->crtc_vsync_end *= p->vscan;
+		p->crtc_vtotal *= p->vscan;
+	}
+
+	p->crtc_vblank_start = min(p->crtc_vsync_start, p->crtc_vdisplay);
+	p->crtc_vblank_end = max(p->crtc_vsync_end, p->crtc_vtotal);
+	p->crtc_hblank_start = min(p->crtc_hsync_start, p->crtc_hdisplay);
+	p->crtc_hblank_end = max(p->crtc_hsync_end, p->crtc_htotal);
+
+	p->crtc_hadjusted = false;
+	p->crtc_vadjusted = false;
+}
+EXPORT_SYMBOL(drm_mode_set_crtcinfo);
+
+
+/**
+ * drm_mode_duplicate - allocate and duplicate an existing mode
+ * @m: mode to duplicate
+ *
+ * LOCKING:
+ * None.
+ *
+ * Just allocate a new mode, copy the existing mode into it, and return
+ * a pointer to it.  Used to create new instances of established modes.
+ */
+struct drm_display_mode *drm_mode_duplicate(struct drm_device *dev,
+					    struct drm_display_mode *mode)
+{
+	struct drm_display_mode *nmode;
+	int new_id;
+
+	nmode = drm_mode_create(dev);
+	if (!nmode)
+		return NULL;
+
+	new_id = nmode->mode_id;
+	*nmode = *mode;
+	nmode->mode_id = new_id;
+	INIT_LIST_HEAD(&nmode->head);
+	return nmode;
+}
+EXPORT_SYMBOL(drm_mode_duplicate);
+
+/**
+ * drm_mode_equal - test modes for equality
+ * @mode1: first mode
+ * @mode2: second mode
+ *
+ * LOCKING:
+ * None.
+ *
+ * Check to see if @mode1 and @mode2 are equivalent.
+ *
+ * RETURNS:
+ * True if the modes are equal, false otherwise.
+ */
+bool drm_mode_equal(struct drm_display_mode *mode1, struct 
drm_display_mode *mode2)
+{
+	if (mode1->clock == mode2->clock &&
+	    mode1->hdisplay == mode2->hdisplay &&
+	    mode1->hsync_start == mode2->hsync_start &&
+	    mode1->hsync_end == mode2->hsync_end &&
+	    mode1->htotal == mode2->htotal &&
+	    mode1->hskew == mode2->hskew &&
+	    mode1->vdisplay == mode2->vdisplay &&
+	    mode1->vsync_start == mode2->vsync_start &&
+	    mode1->vsync_end == mode2->vsync_end &&
+	    mode1->vtotal == mode2->vtotal &&
+	    mode1->vscan == mode2->vscan &&
+	    mode1->flags == mode2->flags)
+		return true;
+	
+	return false;
+}
+EXPORT_SYMBOL(drm_mode_equal);
+
+/**
+ * drm_mode_validate_size - make sure modes adhere to size constraints
+ * @dev: DRM device
+ * @mode_list: list of modes to check
+ * @maxX: maximum width
+ * @maxY: maximum height
+ * @maxPitch: max pitch
+ *
+ * LOCKING:
+ * Caller must hold a lock protecting @mode_list.
+ *
+ * The DRM device (@dev) has size and pitch limits.  Here we validate 
the
+ * modes we probed for @dev against those limits and set their status 
as
+ * necessary.
+ */
+void drm_mode_validate_size(struct drm_device *dev,
+			    struct list_head *mode_list,
+			    int maxX, int maxY, int maxPitch)
+{
+	struct drm_display_mode *mode;
+
+	list_for_each_entry(mode, mode_list, head) {
+		if (maxPitch > 0 && mode->hdisplay > maxPitch)
+			mode->status = MODE_BAD_WIDTH;
+		
+		if (maxX > 0 && mode->hdisplay > maxX)
+			mode->status = MODE_VIRTUAL_X;
+
+		if (maxY > 0 && mode->vdisplay > maxY)
+			mode->status = MODE_VIRTUAL_Y;
+	}
+}
+EXPORT_SYMBOL(drm_mode_validate_size);
+
+/**
+ * drm_mode_validate_clocks - validate modes against clock limits
+ * @dev: DRM device
+ * @mode_list: list of modes to check
+ * @min: minimum clock rate array
+ * @max: maximum clock rate array
+ * @n_ranges: number of clock ranges (size of arrays)
+ *
+ * LOCKING:
+ * Caller must hold a lock protecting @mode_list.
+ *
+ * Some code may need to check a mode list against the clock limits of 
the
+ * device in question.  This function walks the mode list, testing to 
make
+ * sure each mode falls within a given range (defined by @min and @max
+ * arrays) and sets @mode->status as needed.
+ */
+void drm_mode_validate_clocks(struct drm_device *dev,
+			      struct list_head *mode_list,
+			      int *min, int *max, int n_ranges)
+{
+	struct drm_display_mode *mode;
+	int i;
+
+	list_for_each_entry(mode, mode_list, head) {
+		bool good = false;
+		for (i = 0; i < n_ranges; i++) {
+			if (mode->clock >= min[i] && mode->clock <= max[i]) {
+				good = true;
+				break;
+			}
+		}
+		if (!good)
+			mode->status = MODE_CLOCK_RANGE;
+	}
+}
+EXPORT_SYMBOL(drm_mode_validate_clocks);
+
+/**
+ * drm_mode_prune_invalid - remove invalid modes from mode list
+ * @dev: DRM device
+ * @mode_list: list of modes to check
+ * @verbose: be verbose about it
+ *
+ * LOCKING:
+ * Caller must hold a lock protecting @mode_list.
+ *
+ * Once mode list generation is complete, a caller can use this routine 
to
+ * remove invalid modes from a mode list.  If any of the modes have a
+ * status other than %MODE_OK, they are removed from @mode_list and 
freed.
+ */
+void drm_mode_prune_invalid(struct drm_device *dev,
+			    struct list_head *mode_list, bool verbose)
+{
+	struct drm_display_mode *mode, *t;
+
+	list_for_each_entry_safe(mode, t, mode_list, head) {
+		if (mode->status != MODE_OK) {
+			list_del(&mode->head);
+			if (verbose)
+				DRM_DEBUG("Not using %s mode %d\n", mode->name, mode->status);
+			kfree(mode);
+		}
+	}
+}
+
+/**
+ * drm_mode_compare - compare modes for favorability
+ * @lh_a: list_head for first mode
+ * @lh_b: list_head for second mode
+ *
+ * LOCKING:
+ * None.
+ *
+ * Compare two modes, given by @lh_a and @lh_b, returning a value 
indicating
+ * which is better.
+ *
+ * RETURNS:
+ * Negative if @lh_a is better than @lh_b, zero if they're equivalent, 
or
+ * positive if @lh_b is better than @lh_a.
+ */
+static int drm_mode_compare(struct list_head *lh_a, struct list_head 
*lh_b)
+{
+	struct drm_display_mode *a = list_entry(lh_a, struct drm_display_mode, 
head);
+	struct drm_display_mode *b = list_entry(lh_b, struct drm_display_mode, 
head);
+	int diff;
+
+	diff = ((b->type & DRM_MODE_TYPE_PREFERRED) != 0) -
+		((a->type & DRM_MODE_TYPE_PREFERRED) != 0);
+	if (diff)
+		return diff;
+	diff = b->hdisplay * b->vdisplay - a->hdisplay * a->vdisplay;
+	if (diff)
+		return diff;
+	diff = b->clock - a->clock;
+	return diff;
+}
+
+/* FIXME: what we don't have a list sort function? */
+/* list sort from Mark J Roberts (mjr@znex.org) */
+void list_sort(struct list_head *head, int (*cmp)(struct list_head *a, 
struct list_head *b))
+{
+	struct list_head *p, *q, *e, *list, *tail, *oldhead;
+	int insize, nmerges, psize, qsize, i;
+	
+	list = head->next;
+	list_del(head);
+	insize = 1;
+	for (;;) {
+		p = oldhead = list;
+		list = tail = NULL;
+		nmerges = 0;
+		
+		while (p) {
+			nmerges++;
+			q = p;
+			psize = 0;
+			for (i = 0; i < insize; i++) {
+				psize++;
+				q = q->next == oldhead ? NULL : q->next;
+				if (!q)
+					break;
+			}
+			
+			qsize = insize;
+			while (psize > 0 || (qsize > 0 && q)) {
+				if (!psize) {
+					e = q;
+					q = q->next;
+					qsize--;
+					if (q == oldhead)
+						q = NULL;
+				} else if (!qsize || !q) {
+					e = p;
+					p = p->next;
+					psize--;
+					if (p == oldhead)
+						p = NULL;
+				} else if (cmp(p, q) <= 0) {
+					e = p;
+					p = p->next;
+					psize--;
+					if (p == oldhead)
+						p = NULL;
+				} else {
+					e = q;
+					q = q->next;
+					qsize--;
+					if (q == oldhead)
+						q = NULL;
+				}
+				if (tail)
+					tail->next = e;
+				else
+					list = e;
+				e->prev = tail;
+				tail = e;
+			}
+			p = q;
+		}
+		
+		tail->next = list;
+		list->prev = tail;
+		
+		if (nmerges <= 1)
+			break;
+		
+		insize *= 2;
+	}
+	
+	head->next = list;
+	head->prev = list->prev;
+	list->prev->next = head;
+	list->prev = head;
+}
+
+/**
+ * drm_mode_sort - sort mode list
+ * @mode_list: list to sort
+ *
+ * LOCKING:
+ * Caller must hold a lock protecting @mode_list.
+ *
+ * Sort @mode_list by favorability, putting good modes first.
+ */
+void drm_mode_sort(struct list_head *mode_list)
+{
+	list_sort(mode_list, drm_mode_compare);
+}
+
+
+/**
+ * drm_mode_output_list_update - update the mode list for the output
+ * @output: the output to update
+ *
+ * LOCKING:
+ * Caller must hold a lock protecting @mode_list.
+ *
+ * This moves the modes from the @output probed_modes list
+ * to the actual mode list. It compares the probed mode against the 
current
+ * list and only adds different modes. All modes unverified after this 
point
+ * will be removed by the prune invalid modes.
+ */
+void drm_mode_output_list_update(struct drm_output *output)
+{
+	struct drm_display_mode *mode, *t;
+	struct drm_display_mode *pmode, *pt;
+	int found_it;
+	list_for_each_entry_safe(pmode, pt, &output->probed_modes,
+				 head) {
+		found_it = 0;
+		/* go through current modes checking for the new probed mode */
+		list_for_each_entry(mode, &output->modes, head) {
+			if (drm_mode_equal(pmode, mode)) {
+				found_it = 1;
+				/* if equal delete the probed mode */
+				mode->status = pmode->status;
+				list_del(&pmode->head);
+				kfree(pmode);
+				break;
+			}
+		}
+
+		if (!found_it) {
+			list_move_tail(&pmode->head, &output->modes);
+		}
+	}
+}
diff --git a/linux-core/drm_objects.h b/linux-core/drm_objects.h
index 03ea927..8a70c73 100644
--- a/linux-core/drm_objects.h
+++ b/linux-core/drm_objects.h
@@ -29,7 +29,8 @@
  */
 
 #ifndef _DRM_OBJECTS_H
-#define _DRM_OBJECTS_H
+#define _DRM_OJBECTS_H
+#define DRM_HAS_TTM
 
 struct drm_device;
 
@@ -247,9 +248,9 @@ typedef struct drm_ttm_backend_func {
 
 
 typedef struct drm_ttm_backend {
-	uint32_t flags;
-	int mem_type;
-	drm_ttm_backend_func_t *func;
+        uint32_t flags;
+        int mem_type;
+        drm_ttm_backend_func_t *func;
 } drm_ttm_backend_t;
 
 typedef struct drm_ttm {
@@ -427,7 +428,13 @@ typedef struct drm_bo_driver {
 /*
  * buffer objects (drm_bo.c)
  */
-
+extern int drm_bo_init_mm(struct drm_device * dev, unsigned type,
+			  unsigned long p_offset, unsigned long p_size);
+extern int drm_buffer_object_create(struct drm_device *dev, unsigned 
long size,
+				    drm_bo_type_t type, uint32_t mask,
+				    uint32_t hint, uint32_t page_alignment,
+				    unsigned long buffer_start,
+				    drm_buffer_object_t ** buf_obj);
 extern int drm_bo_ioctl(DRM_IOCTL_ARGS);
 extern int drm_mm_init_ioctl(DRM_IOCTL_ARGS);
 extern int drm_bo_driver_finish(struct drm_device *dev);
@@ -471,4 +478,9 @@ extern int 
drm_bo_move_accel_cleanup(drm_buffer_object_t * bo,
 				     uint32_t fence_flags,
 				     drm_bo_mem_reg_t * new_mem);
 
+extern int drm_mem_reg_ioremap(struct drm_device *dev, drm_bo_mem_reg_t 
* mem,
+			       void **virtual);
+extern void drm_mem_reg_iounmap(struct drm_device *dev, 
drm_bo_mem_reg_t * mem,
+				void *virtual);
+
 #endif
diff --git a/linux-core/drm_os_linux.h b/linux-core/drm_os_linux.h
index 2ea105c..816959e 100644
--- a/linux-core/drm_os_linux.h
+++ b/linux-core/drm_os_linux.h
@@ -119,6 +119,24 @@ static __inline__ int mtrr_del(int reg, unsigned 
long base, unsigned long size)
 
 #define DRM_GET_PRIV_WITH_RETURN(_priv, _filp) _priv = 
_filp->private_data
 
+/**
+ * Get the pointer to the SAREA.
+ *
+ * Searches the SAREA on the mapping lists and points drm_device::sarea 
to it.
+ */
+#define DRM_GETSAREA()							 \
+do { 									 \
+	drm_map_list_t *entry;						 \
+	list_for_each_entry( entry, &dev->maplist->head, head ) {	 \
+		if ( entry->map &&					 \
+		     entry->map->type == _DRM_SHM &&			 \
+		     (entry->map->flags & _DRM_CONTAINS_LOCK) ) {	 \
+			dev_priv->sarea = entry->map;			 \
+ 			break;						 \
+ 		}							 \
+ 	}								 \
+} while (0)
+
 #define DRM_HZ HZ
 
 #define DRM_WAIT_ON( ret, queue, timeout, condition )		\
diff --git a/linux-core/drm_stub.c b/linux-core/drm_stub.c
index f4da7da..01ffe67 100644
--- a/linux-core/drm_stub.c
+++ b/linux-core/drm_stub.c
@@ -79,27 +79,28 @@ static int drm_fill_in_dev(drm_device_t * dev, 
struct pci_dev *pdev,
 #endif
 	dev->irq = pdev->irq;
 
-	if (drm_ht_create(&dev->map_hash, DRM_MAP_HASH_ORDER)) {
-		drm_free(dev->maplist, sizeof(*dev->maplist), DRM_MEM_MAPS);
+	if (drm_ht_create(&dev->map_hash, DRM_MAP_HASH_ORDER))
 		return -ENOMEM;
-	}
+
 	if (drm_mm_init(&dev->offset_manager, DRM_FILE_PAGE_OFFSET_START,
 			DRM_FILE_PAGE_OFFSET_SIZE)) {
-		drm_free(dev->maplist, sizeof(*dev->maplist), DRM_MEM_MAPS);
 		drm_ht_remove(&dev->map_hash);
 		return -ENOMEM;
 	}
 
 	if (drm_ht_create(&dev->object_hash, DRM_OBJECT_HASH_ORDER)) {
-                drm_free(dev->maplist, sizeof(*dev->maplist), 
DRM_MEM_MAPS);
 		drm_ht_remove(&dev->map_hash);
 		drm_mm_takedown(&dev->offset_manager);
 		return -ENOMEM;
 	}
 
 	dev->maplist = drm_calloc(1, sizeof(*dev->maplist), DRM_MEM_MAPS);
-	if (dev->maplist == NULL)
+	if (dev->maplist == NULL) {
+		drm_ht_remove(&dev->object_hash);
+		drm_ht_remove(&dev->map_hash);
+		drm_mm_takedown(&dev->offset_manager);
 		return -ENOMEM;
+	}
 	INIT_LIST_HEAD(&dev->maplist->head);
 
 	/* the DRM has 6 counters */
@@ -113,10 +114,6 @@ static int drm_fill_in_dev(drm_device_t * dev, 
struct pci_dev *pdev,
 
 	dev->driver = driver;
 
-	if (dev->driver->load)
-		if ((retcode = dev->driver->load(dev, ent->driver_data)))
-			goto error_out_unreg;
-
 	if (drm_core_has_AGP(dev)) {
 		if (drm_device_is_agp(dev))
 			dev->agp = drm_agp_init(dev);
@@ -136,6 +133,10 @@ static int drm_fill_in_dev(drm_device_t * dev, 
struct pci_dev *pdev,
 		}
 	}
 
+	if (dev->driver->load)
+		if ((retcode = dev->driver->load(dev, ent->driver_data)))
+			goto error_out_unreg;
+
 	retcode = drm_ctxbitmap_init(dev);
 	if (retcode) {
 		DRM_ERROR("Cannot allocate memory for context bitmap.\n");
diff --git a/linux-core/drm_vm.c b/linux-core/drm_vm.c
index b887153..1f905fb 100644
--- a/linux-core/drm_vm.c
+++ b/linux-core/drm_vm.c
@@ -516,7 +516,8 @@ static int drm_mmap_dma(struct file *filp, struct 
vm_area_struct *vma)
 		return -EINVAL;
 	}
 
-	if (!capable(CAP_SYS_ADMIN) && (dma->flags & _DRM_DMA_USE_PCI_RO)) {
+	if (!capable(CAP_SYS_ADMIN) &&
+	    (dma->flags & _DRM_DMA_USE_PCI_RO)) {
 		vma->vm_flags &= ~(VM_WRITE | VM_MAYWRITE);
 #if defined(__i386__) || defined(__x86_64__)
 		pgprot_val(vma->vm_page_prot) &= ~_PAGE_RW;
@@ -738,7 +739,7 @@ static unsigned long drm_bo_vm_nopfn(struct 
vm_area_struct *vma,
 	unsigned long bus_base;
 	unsigned long bus_offset;
 	unsigned long bus_size;
-	unsigned long ret = NOPFN_REFAULT;
+	int ret = NOPFN_REFAULT;
 
 	if (address > vma->vm_end)
 		return NOPFN_SIGBUS;
