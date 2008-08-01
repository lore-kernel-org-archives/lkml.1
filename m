Return-Path: <linux-kernel-owner+w=401wt.eu-S1755148AbYHAPtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148AbYHAPtT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 11:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751337AbYHAPtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 11:49:12 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:32675 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbYHAPtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 11:49:11 -0400
Date: Fri, 1 Aug 2008 08:44:05 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Eric Anholt <eric@anholt.net>
Cc: linux-kernel@vger.kernel.org, keithp@keithp.com
Subject: Re: [PATCH] drm: Add GEM ("graphics execution manager") to i915
 driver.
Message-Id: <20080801084405.62d3c823.randy.dunlap@oracle.com>
In-Reply-To: <1217573919-7496-3-git-send-email-eric@anholt.net>
References: <1217573919-7496-1-git-send-email-eric@anholt.net>
	<1217573919-7496-2-git-send-email-eric@anholt.net>
	<1217573919-7496-3-git-send-email-eric@anholt.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jul 2008 23:58:39 -0700 Eric Anholt wrote:

> GEM allows the creation of persistent buffer objects accessible by the
> graphics device through new ioctls for managing execution of commands on the
> device.  The userland API is almost entirely driver-specific to ensure that
> any driver building on this model can easily map the interface to individual
> driver requirements.
> 
> GEM is used by the 2d driver for managing its internal state allocations and
> will be used for pixmap storage to reduce memory consumption and enable
> zero-copy GLX_EXT_texture_from_pixmap, and in the 3d driver is used to enable
> GL_EXT_framebuffer_object and GL_ARB_pixel_buffer_object.

"the 2d driver" ... "the 3d driver".
Just curious:  Is there only one of each of these?


> diff --git a/drivers/gpu/drm/drm_agpsupport.c b/drivers/gpu/drm/drm_agpsupport.c
> index aefa5ac..2639be2 100644
> --- a/drivers/gpu/drm/drm_agpsupport.c
> +++ b/drivers/gpu/drm/drm_agpsupport.c
> @@ -33,6 +33,7 @@
>  
>  #include "drmP.h"
>  #include <linux/module.h>
> +#include <asm/agp.h>
>  
>  #if __OS_HAS_AGP
>  
> @@ -452,4 +453,52 @@ int drm_agp_unbind_memory(DRM_AGP_MEM * handle)
>  	return agp_unbind_memory(handle);
>  }
>  
> -#endif				/* __OS_HAS_AGP */
> +/**

In the kernel source tree, "/**" means "beginning of kernel-doc notation",
so please don't use it when kernel-doc isn't being used.
(in multiple places/files)


> + * Binds a collection of pages into AGP memory at the given offset, returning
> + * the AGP memory structure containing them.
> + *
> + * No reference is held on the pages during this time -- it is up to the
> + * caller to handle that.
> + */
> +DRM_AGP_MEM *
> +drm_agp_bind_pages(struct drm_device *dev,
> +		   struct page **pages,
> +		   unsigned long num_pages,
> +		   uint32_t gtt_offset)

and the preferred function format is more like:

DRM_AGP_MEM *drm_agp_bind_page(struct drm_device *dev,
...
(many places)


> +{
> +	DRM_AGP_MEM *mem;
> +	int ret, i;
> +
> +	DRM_DEBUG("\n");
> +
> +	mem = drm_agp_allocate_memory(dev->agp->bridge, num_pages,
> +				      AGP_USER_MEMORY);
> +	if (mem == NULL) {
> +		DRM_ERROR("Failed to allocate memory for %ld pages\n",
> +			  num_pages);
> +		return NULL;
> +	}
> +
> +	for (i = 0; i < num_pages; i++)
> +		mem->memory[i] = phys_to_gart(page_to_phys(pages[i]));
> +	mem->page_count = num_pages;
> +
> +	mem->is_flushed = true;
> +	ret = drm_agp_bind_memory(mem, gtt_offset / PAGE_SIZE);
> +	if (ret != 0) {
> +		DRM_ERROR("Failed to bind AGP memory: %d\n", ret);
> +		agp_free_memory(mem);
> +		return NULL;
> +	}
> +
> +	return mem;
> +}
> +EXPORT_SYMBOL(drm_agp_bind_pages);





> diff --git a/include/drm/drmP.h b/include/drm/drmP.h
> index 1c1b13e..a540db8 100644
> --- a/include/drm/drmP.h
> +++ b/include/drm/drmP.h
> @@ -104,6 +104,7 @@ struct drm_device;
>  #define DRIVER_DMA_QUEUE   0x200
>  #define DRIVER_FB_DMA      0x400
>  #define DRIVER_IRQ_VBL2    0x800
> +#define DRIVER_GEM         0x1000
>  
>  /***********************************************************************/
>  /** \name Begin the DRM... */

What uses/processes this comment notation, please?


> @@ -771,6 +838,22 @@ struct drm_device {
>  	spinlock_t drw_lock;
>  	struct idr drw_idr;
>  	/*@} */
> +
> +	/** \name GEM information */
> +	/*@{ */

and this one?

> +	spinlock_t object_name_lock;
> +	struct idr object_name_idr;
> +	atomic_t object_count;
> +	atomic_t object_memory;
> +	atomic_t pin_count;
> +	atomic_t pin_memory;
> +	atomic_t gtt_count;
> +	atomic_t gtt_memory;
> +	uint32_t gtt_total;
> +	uint32_t invalidate_domains;    /* domains pending invalidation */
> +	uint32_t flush_domains;         /* domains pending flush */
> +	/*@} */
> +
>  };


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
