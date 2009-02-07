Return-Path: <linux-kernel-owner+w=401wt.eu-S1753187AbZBGBXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187AbZBGBXA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 20:23:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752093AbZBGBWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 20:22:50 -0500
Received: from mail.fireflyinternet.com ([78.156.72.243]:1555 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752835AbZBGBWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 20:22:49 -0500
X-Greylist: delayed 1822 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Feb 2009 20:22:49 EST
Subject: Re: Gem GTT mmaps..
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas@shipmail.org>,
       DRI <dri-devel@lists.sourceforge.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <200902061424.02906.jbarnes@virtuousgeek.org>
References: <498A1760.7010108@shipmail.org>
	 <200902060914.59956.jbarnes@virtuousgeek.org>
	 <498CAD2F.5070806@shipmail.org>
	 <200902061424.02906.jbarnes@virtuousgeek.org>
Content-Type: text/plain
Date: Sat, 07 Feb 2009 00:52:21 +0000
Message-Id: <1233967941.11716.1009.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: 78.156.66.37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I tried it, it's not too happy. My only concern is that this now relies
on userspace to correctly call SW_FINISH (and not unmap after mmapping
the GTT_MMAP) or otherwise the object is leaked? Patch comments inline.

On Fri, 2009-02-06 at 14:24 -0800, Jesse Barnes wrote:
> This one should cover the cases you found.
>   - ref at map time will keep the object around so fault shouldn't fail
>   - additional threads will take their refs in vm_open/close
>   - unmap will unref and remove mmap_offset allowing object to be freed
> 
> -- 
> Jesse Barnes, Intel Open Source Technology Center
> 
> diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
> index 6915fb8..2752114 100644
> --- a/drivers/gpu/drm/drm_gem.c
> +++ b/drivers/gpu/drm/drm_gem.c
> @@ -460,6 +460,23 @@ drm_gem_object_handle_free(struct kref *kref)
>  }
>  EXPORT_SYMBOL(drm_gem_object_handle_free);
>  
> +void drm_gem_vm_open(struct vm_area_struct *vma)
> +{
> +	struct drm_gem_object *obj = vma->vm_private_data;
> +
> +	drm_gem_object_reference(obj);
> +}
> +EXPORT_SYMBOL(drm_gem_vm_open);
> +
> +void drm_gem_vm_close(struct vm_area_struct *vma)
> +{
> +	struct drm_gem_object *obj = vma->vm_private_data;
> +
> +	drm_gem_object_unreference(obj);

Need to take the dev->struct_mutex for this potential free.

> +}
> +EXPORT_SYMBOL(drm_gem_vm_close);
> +
> +
>  /**
>   * drm_gem_mmap - memory map routine for GEM objects
>   * @filp: DRM file pointer
> diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
> index aac12ee..a31cbdb 100644
> --- a/drivers/gpu/drm/i915/i915_drv.c
> +++ b/drivers/gpu/drm/i915/i915_drv.c
> @@ -94,6 +94,8 @@ static int i915_resume(struct drm_device *dev)
>  
>  static struct vm_operations_struct i915_gem_vm_ops = {
>  	.fault = i915_gem_fault,
> +	.open = drm_gem_vm_open,
> +	.close = drm_gem_vm_close,
>  };
>  
>  static struct drm_driver driver = {
> diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
> index 1441831..a476de0 100644
> --- a/drivers/gpu/drm/i915/i915_gem.c
> +++ b/drivers/gpu/drm/i915/i915_gem.c
> @@ -52,6 +52,7 @@ static void i915_gem_object_free_page_list(struct drm_gem_object *obj);
>  static int i915_gem_object_wait_rendering(struct drm_gem_object *obj);
>  static int i915_gem_object_bind_to_gtt(struct drm_gem_object *obj,
>  					   unsigned alignment);
> +static void i915_gem_free_mmap_offset(struct drm_gem_object *obj);
>  static int i915_gem_object_get_fence_reg(struct drm_gem_object *obj, bool write);
>  static void i915_gem_clear_fence_reg(struct drm_gem_object *obj);
>  static int i915_gem_evict_something(struct drm_device *dev);
> @@ -497,6 +498,13 @@ i915_gem_sw_finish_ioctl(struct drm_device *dev, void *data,
>  		i915_gem_object_flush_cpu_write_domain(obj);
>  
>  	drm_gem_object_unreference(obj);
> +
> +	/* If it's been GTT mapped, unref it again... */
> +	if (obj_priv->mmap_offset) {

This test occurs after the potential free above.

> +		i915_gem_free_mmap_offset(obj);
> +		drm_gem_object_unreference(obj);
> +	}
> +
>  	mutex_unlock(&dev->struct_mutex);
>  	return ret;
>  }
> @@ -607,8 +615,6 @@ int i915_gem_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
>  	case -EAGAIN:
>  		return VM_FAULT_OOM;
>  	case -EFAULT:
> -	case -EBUSY:
> -		DRM_ERROR("can't insert pfn??  fault or busy...\n");
>  		return VM_FAULT_SIGBUS;
>  	default:
>  		return VM_FAULT_NOPAGE;
> @@ -684,6 +690,32 @@ out_free_list:
>  	return ret;
>  }
>  
> +static void
> +i915_gem_free_mmap_offset(struct drm_gem_object *obj)
> +{
> +	struct drm_device *dev = obj->dev;
> +	struct drm_i915_gem_object *obj_priv = obj->driver_private;
> +	struct drm_gem_mm *mm = dev->mm_private;
> +	struct drm_map_list *list;
> +	struct drm_map *map;
> +
> +	list = &obj->map_list;
> +	drm_ht_remove_item(&mm->offset_hash, &list->hash);
> +
> +	if (list->file_offset_node) {
> +		drm_mm_put_block(list->file_offset_node);
> +		list->file_offset_node = NULL;
> +	}
> +
> +	map = list->map;
> +	if (map) {
> +		drm_free(map, sizeof(*map), DRM_MEM_DRIVER);
> +		list->map = NULL;
> +	}
> +
> +	obj_priv->mmap_offset = 0;
> +}
> +
>  /**
>   * i915_gem_get_gtt_alignment - return required GTT alignment for an object
>   * @obj: object to check
> @@ -788,7 +820,7 @@ i915_gem_mmap_gtt_ioctl(struct drm_device *dev, void *data,
>  		list_add(&obj_priv->list, &dev_priv->mm.inactive_list);
>  	}
>  
> -	drm_gem_object_unreference(obj);
> +	/* Leave lookup reference around until unmap time */
>  	mutex_unlock(&dev->struct_mutex);
>  
>  	return 0;
> @@ -2885,9 +2917,6 @@ int i915_gem_init_object(struct drm_gem_object *obj)
>  void i915_gem_free_object(struct drm_gem_object *obj)
>  {
>  	struct drm_device *dev = obj->dev;
> -	struct drm_gem_mm *mm = dev->mm_private;
> -	struct drm_map_list *list;
> -	struct drm_map *map;
>  	struct drm_i915_gem_object *obj_priv = obj->driver_private;
>  
>  	while (obj_priv->pin_count > 0)
> @@ -2898,20 +2927,6 @@ void i915_gem_free_object(struct drm_gem_object *obj)
>  
>  	i915_gem_object_unbind(obj);
>  
> -	list = &obj->map_list;
> -	drm_ht_remove_item(&mm->offset_hash, &list->hash);
> -
> -	if (list->file_offset_node) {
> -		drm_mm_put_block(list->file_offset_node);
> -		list->file_offset_node = NULL;
> -	}
> -
> -	map = list->map;
> -	if (map) {
> -		drm_free(map, sizeof(*map), DRM_MEM_DRIVER);
> -		list->map = NULL;
> -	}
> -

Add a BUG_ON(obj_priv->mmap_offset) for fun and double-faults!

>  	drm_free(obj_priv->page_cpu_valid, 1, DRM_MEM_DRIVER);
>  	drm_free(obj->driver_private, 1, DRM_MEM_DRIVER);
>  }
> diff --git a/include/drm/drmP.h b/include/drm/drmP.h
> index 8190b9b..e5f4ae9 100644
> --- a/include/drm/drmP.h
> +++ b/include/drm/drmP.h
> @@ -1321,6 +1321,8 @@ void drm_gem_object_free(struct kref *kref);
>  struct drm_gem_object *drm_gem_object_alloc(struct drm_device *dev,
>  					    size_t size);
>  void drm_gem_object_handle_free(struct kref *kref);
> +void drm_gem_vm_open(struct vm_area_struct *vma);
> +void drm_gem_vm_close(struct vm_area_struct *vma);
>  int drm_gem_mmap(struct file *filp, struct vm_area_struct *vma);

-ickle

