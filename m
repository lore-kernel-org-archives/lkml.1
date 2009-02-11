Return-Path: <linux-kernel-owner+w=401wt.eu-S1757016AbZBKWCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757016AbZBKWCV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 17:02:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756282AbZBKWBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 17:01:51 -0500
Received: from outbound-mail-130.bluehost.com ([67.222.38.30]:42959 "HELO
	outbound-mail-130.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754038AbZBKWBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 17:01:49 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=itMgzTR4vvZLlyhwCcVW6cVgcDrDwDPDAYSQGkpEvgNRRGXCzbW3mTdfGnMTpCpOmMt4JJbtMH4hggcZO5R5eK0hqeb2hJzT+oAV8XDvDa1hTTEWFkqKfW5fe7Oij189;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: dri-devel@lists.sourceforge.net, Eric Anholt <eric@anholt.net>
Subject: Re: Gem GTT mmaps..
Date: Wed, 11 Feb 2009 14:01:46 -0800
User-Agent: KMail/1.9.10
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>
References: <498A1760.7010108@shipmail.org> <200902061424.02906.jbarnes@virtuousgeek.org> <1233967941.11716.1009.camel@localhost>
In-Reply-To: <1233967941.11716.1009.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902111401.46669.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 6, 2009 4:52 pm Chris Wilson wrote:
> I tried it, it's not too happy. My only concern is that this now relies
> on userspace to correctly call SW_FINISH (and not unmap after mmapping
> the GTT_MMAP) or otherwise the object is leaked? Patch comments inline.

This one relies on munmap or exit (as it should be).  I think we're leaking a
refcount somewhere, but afaict it's not caused by this patch (failing to take
a ref at mmap time leads to a panic in unpin).  That leak may have been fixed
by one of your other patches, haven't updated & tested yet.

  - ref at map time will keep the object around so fault shouldn't fail
  - additional threads will take their refs in vm_open/close
  - unmap will unref and remove mmap_offset allowing object to be freed

Tested with modetest while looking at /proc/dri/...

-- 
Jesse Barnes, Intel Open Source Technology Center

diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
index 6915fb8..393d2db 100644
--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -460,6 +460,26 @@ drm_gem_object_handle_free(struct kref *kref)
 }
 EXPORT_SYMBOL(drm_gem_object_handle_free);
 
+void drm_gem_vm_open(struct vm_area_struct *vma)
+{
+	struct drm_gem_object *obj = vma->vm_private_data;
+
+	drm_gem_object_reference(obj);
+}
+EXPORT_SYMBOL(drm_gem_vm_open);
+
+void drm_gem_vm_close(struct vm_area_struct *vma)
+{
+	struct drm_gem_object *obj = vma->vm_private_data;
+	struct drm_device *dev = obj->dev;
+
+	mutex_lock(&dev->struct_mutex);
+	drm_gem_object_unreference(obj);
+	mutex_unlock(&dev->struct_mutex);
+}
+EXPORT_SYMBOL(drm_gem_vm_close);
+
+
 /**
  * drm_gem_mmap - memory map routine for GEM objects
  * @filp: DRM file pointer
@@ -521,6 +541,12 @@ int drm_gem_mmap(struct file *filp, struct vm_area_struct *vma)
 #endif
 	vma->vm_page_prot = __pgprot(prot);
 
+	/* Take a ref here so our fault handler always has an object
+	 * to work with.  This ref will be dropped when the last
+	 * process does a vm_close (at munmap or exit time).
+	 */
+	drm_gem_object_reference(obj);
+
 	vma->vm_file = filp;	/* Needed for drm_vm_open() */
 	drm_vm_open_locked(vma);
 
diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
index aac12ee..a31cbdb 100644
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -94,6 +94,8 @@ static int i915_resume(struct drm_device *dev)
 
 static struct vm_operations_struct i915_gem_vm_ops = {
 	.fault = i915_gem_fault,
+	.open = drm_gem_vm_open,
+	.close = drm_gem_vm_close,
 };
 
 static struct drm_driver driver = {
diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 1441831..d1a031b 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -607,8 +607,6 @@ int i915_gem_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	case -EAGAIN:
 		return VM_FAULT_OOM;
 	case -EFAULT:
-	case -EBUSY:
-		DRM_ERROR("can't insert pfn??  fault or busy...\n");
 		return VM_FAULT_SIGBUS;
 	default:
 		return VM_FAULT_NOPAGE;
@@ -684,6 +682,30 @@ out_free_list:
 	return ret;
 }
 
+static void
+i915_gem_free_mmap_offset(struct drm_gem_object *obj)
+{
+	struct drm_device *dev = obj->dev;
+	struct drm_i915_gem_object *obj_priv = obj->driver_private;
+	struct drm_gem_mm *mm = dev->mm_private;
+	struct drm_map_list *list;
+
+	list = &obj->map_list;
+	drm_ht_remove_item(&mm->offset_hash, &list->hash);
+
+	if (list->file_offset_node) {
+		drm_mm_put_block(list->file_offset_node);
+		list->file_offset_node = NULL;
+	}
+
+	if (list->map) {
+		drm_free(list->map, sizeof(struct drm_map), DRM_MEM_DRIVER);
+		list->map = NULL;
+	}
+
+	obj_priv->mmap_offset = 0;
+}
+
 /**
  * i915_gem_get_gtt_alignment - return required GTT alignment for an object
  * @obj: object to check
@@ -2885,9 +2907,6 @@ int i915_gem_init_object(struct drm_gem_object *obj)
 void i915_gem_free_object(struct drm_gem_object *obj)
 {
 	struct drm_device *dev = obj->dev;
-	struct drm_gem_mm *mm = dev->mm_private;
-	struct drm_map_list *list;
-	struct drm_map *map;
 	struct drm_i915_gem_object *obj_priv = obj->driver_private;
 
 	while (obj_priv->pin_count > 0)
@@ -2898,19 +2917,7 @@ void i915_gem_free_object(struct drm_gem_object *obj)
 
 	i915_gem_object_unbind(obj);
 
-	list = &obj->map_list;
-	drm_ht_remove_item(&mm->offset_hash, &list->hash);
-
-	if (list->file_offset_node) {
-		drm_mm_put_block(list->file_offset_node);
-		list->file_offset_node = NULL;
-	}
-
-	map = list->map;
-	if (map) {
-		drm_free(map, sizeof(*map), DRM_MEM_DRIVER);
-		list->map = NULL;
-	}
+	i915_gem_free_mmap_offset(obj);
 
 	drm_free(obj_priv->page_cpu_valid, 1, DRM_MEM_DRIVER);
 	drm_free(obj->driver_private, 1, DRM_MEM_DRIVER);
diff --git a/include/drm/drmP.h b/include/drm/drmP.h
index 8190b9b..e5f4ae9 100644
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -1321,6 +1321,8 @@ void drm_gem_object_free(struct kref *kref);
 struct drm_gem_object *drm_gem_object_alloc(struct drm_device *dev,
 					    size_t size);
 void drm_gem_object_handle_free(struct kref *kref);
+void drm_gem_vm_open(struct vm_area_struct *vma);
+void drm_gem_vm_close(struct vm_area_struct *vma);
 int drm_gem_mmap(struct file *filp, struct vm_area_struct *vma);
 
 static inline void
