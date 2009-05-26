Return-Path: <linux-kernel-owner+w=401wt.eu-S1758893AbZEZW45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758893AbZEZW45 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 18:56:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754893AbZEZW4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 18:56:50 -0400
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:30784 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754876AbZEZW4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 18:56:49 -0400
X-Trace: 205322335/mk-filter-1.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.124.61/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.124.61
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AokFABMRHEpPRXw9/2dsb2JhbACBT81ghAsF
X-IronPort-AV: E=Sophos;i="4.41,254,1241391600"; 
   d="scan'208";a="205322335"
Date: Tue, 26 May 2009 23:55:50 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Kyle McMartin <kyle@mcmartin.ca>
cc: airlied@redhat.com, dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, eric@anholt.net, stable@kernel.org,
       linux-mm@kvack.org, shaohua.li@intel.com
Subject: Re: [PATCH] drm: i915: ensure objects are allocated below 4GB on
 PAE
In-Reply-To: <20090526162717.GC14808@bombadil.infradead.org>
Message-ID: <Pine.LNX.4.64.0905262343140.13452@sister.anvils>
References: <20090526162717.GC14808@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 May 2009, Kyle McMartin wrote:
> From: Kyle McMartin <kyle@redhat.com>
> 
> Ensure we allocate GEM objects below 4GB on PAE machines, otherwise
> misery ensues. This patch is based on a patch found on dri-devel by
> Shaohua Li, but Keith P. expressed reticence that the changes unfairly
> penalized other hardware.
> 
> (The mm/shmem.c hunk is necessary to ensure the DMA32 flag isn't used
>  by the slab allocator via radix_tree_preload, which will hit a
>  WARN_ON.)
> 
> Signed-off-by: Kyle McMartin <kyle@redhat.com>

I'm confused: I thought GFP_DMA32 only applies on x86_64:
my 32-bit PAE machine with (slightly!) > 4GB shows no ZONE_DMA32.
Does this patch perhaps depend on another, to enable DMA32 on 32-bit
PAE, or am I just in a muddle?

Regarding the mm/shmem.c hunk:
> -		error = radix_tree_preload(gfp & ~__GFP_HIGHMEM);
> +		error = radix_tree_preload(gfp & ~(__GFP_HIGHMEM|__GFP_DMA32));

Yes, that would make sense.  I dislike it, but my dislike is no
reason to hold you up: what it ought to say is
		error = radix_tree_preload(gfp & GFP_RECLAIM_MASK);
and similarly the several other (gfp & ~__GFP_HIGHMEM)s to be found
in nearby files: it's just an accident of history that nobody has
hit this issue with __GFP_DMA or __GFP_DMA32 before.  I intended
to change these months ago, my slowness is no reason to delay you.

Hugh

> ---
> 
> We're shipping a variant of this in Fedora 11 to fix a myriad of bugs on
> PAE hardware.
> 
> cheers, Kyle
> 
> ---
> diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
> index 4984aa8..ae52edc 100644
> --- a/drivers/gpu/drm/drm_gem.c
> +++ b/drivers/gpu/drm/drm_gem.c
> @@ -142,6 +142,9 @@ drm_gem_object_alloc(struct drm_device *dev, size_t size)
>  		return NULL;
>  	}
>  
> +	if (dev->gem_flags)
> +		mapping_set_gfp_mask(obj->filp->f_mapping, dev->gem_flags);
> +
>  	kref_init(&obj->refcount);
>  	kref_init(&obj->handlecount);
>  	obj->size = size;
> diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
> index 53d5445..c89ae3d 100644
> --- a/drivers/gpu/drm/i915/i915_dma.c
> +++ b/drivers/gpu/drm/i915/i915_dma.c
> @@ -1153,12 +1153,12 @@ int i915_driver_load(struct drm_device *dev, unsigned long flags)
>  	}
>  
>  #ifdef CONFIG_HIGHMEM64G
> -	/* don't enable GEM on PAE - needs agp + set_memory_* interface fixes */
> -	dev_priv->has_gem = 0;
> -#else
> +	/* avoid allocating buffers above 4GB on PAE */
> +	dev->gem_flags = GFP_USER | GFP_DMA32;
> +#endif
> +
>  	/* enable GEM by default */
>  	dev_priv->has_gem = 1;
> -#endif
>  
>  	dev->driver->get_vblank_counter = i915_get_vblank_counter;
>  	if (IS_GM45(dev))
> diff --git a/include/drm/drmP.h b/include/drm/drmP.h
> index c8c4221..3744c1f 100644
> --- a/include/drm/drmP.h
> +++ b/include/drm/drmP.h
> @@ -1019,6 +1019,7 @@ struct drm_device {
>  	uint32_t gtt_total;
>  	uint32_t invalidate_domains;    /* domains pending invalidation */
>  	uint32_t flush_domains;         /* domains pending flush */
> +	gfp_t gem_flags;		/* object allocation flags */
>  	/*@} */
>  
>  };
> diff --git a/mm/shmem.c b/mm/shmem.c
> index b25f95c..e615887 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1241,7 +1241,7 @@ repeat:
>  		 * Try to preload while we can wait, to not make a habit of
>  		 * draining atomic reserves; but don't latch on to this cpu.
>  		 */
> -		error = radix_tree_preload(gfp & ~__GFP_HIGHMEM);
> +		error = radix_tree_preload(gfp & ~(__GFP_HIGHMEM|__GFP_DMA32));
>  		if (error)
>  			goto failed;
>  		radix_tree_preload_end();
