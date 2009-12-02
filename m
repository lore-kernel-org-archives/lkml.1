Return-Path: <linux-kernel-owner+w=401wt.eu-S1753267AbZLBKFM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267AbZLBKFM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 05:05:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752442AbZLBKFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 05:05:11 -0500
Received: from relay.gothnet.se ([82.193.160.251]:49315 "EHLO
	GOTHNET-SMTP2.gothnet.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751055AbZLBKFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 05:05:08 -0500
Message-ID: <4B163BB5.9060708@shipmail.org>
Date: Wed, 02 Dec 2009 11:04:37 +0100
From: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@shipmail.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080926)
MIME-Version: 1.0
To: Jerome Glisse <jglisse@redhat.com>
CC: airlied@gmail.com, linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: Re: [PATCH 1/3] drm/ttm: Add range validation function
References: <1258723764-4399-1-git-send-email-jglisse@redhat.com> <1258723764-4399-2-git-send-email-jglisse@redhat.com>
In-Reply-To: <1258723764-4399-2-git-send-email-jglisse@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-BitDefender-Scanner: Mail not scanned due to license constraints
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jerome,
Please see comments inline.


Jerome Glisse wrote:
> Add a function to validate buffer in a given range of
> memory. This is needed by some hw for some of their
> buffer (scanout buffer, cursor ...).
>
> Signed-off-by: Jerome Glisse <jglisse@redhat.com>
> ---
>  drivers/gpu/drm/ttm/ttm_bo.c    |  305 ++++++++++++++++++++++++++++++++++++++-
>  include/drm/ttm/ttm_bo_api.h    |    5 +
>  include/drm/ttm/ttm_bo_driver.h |    1 +
>  3 files changed, 310 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
> index 87c0625..6b0e7e8 100644
> --- a/drivers/gpu/drm/ttm/ttm_bo.c
> +++ b/drivers/gpu/drm/ttm/ttm_bo.c
> @@ -247,7 +247,6 @@ EXPORT_SYMBOL(ttm_bo_unreserve);
>  /*
>   * Call bo->mutex locked.
>   */
> -
>   

Whitespace.

>  static int ttm_bo_add_ttm(struct ttm_buffer_object *bo, bool zero_alloc)
>  {
>  	struct ttm_bo_device *bdev = bo->bdev;
> @@ -418,6 +417,7 @@ static int ttm_bo_cleanup_refs(struct ttm_buffer_object *bo, bool remove_all)
>  			kref_put(&bo->list_kref, ttm_bo_ref_bug);
>  		}
>  		if (bo->mem.mm_node) {
> +			bo->mem.mm_node->private = NULL;
>  			drm_mm_put_block(bo->mem.mm_node);
>  			bo->mem.mm_node = NULL;
>  		}
> @@ -610,6 +610,7 @@ static int ttm_bo_evict(struct ttm_buffer_object *bo, unsigned mem_type,
>  
>  	spin_lock(&glob->lru_lock);
>  	if (evict_mem.mm_node) {
> +		evict_mem.mm_node->private = NULL;
>  		drm_mm_put_block(evict_mem.mm_node);
>  		evict_mem.mm_node = NULL;
>  	}
>   
> @@ -826,6 +827,7 @@ int ttm_bo_mem_space(struct ttm_buffer_object *bo,
>  		mem->mm_node = node;
>  		mem->mem_type = mem_type;
>  		mem->placement = cur_flags;
> +		node->private = bo;
>  		return 0;
>  	}
>  
>   

I'd like a big warning here somewhere, because since the pointer to the 
bo is not refcounted, it may
never be dereferenced outside of the lru spinlock, because as soon as 
you release the lru spinlock, someone
else may destroy the buffer. The current usage is valid AFAICT. If you 
choose to refcount it, use bo::list_kref.


> @@ -856,6 +858,7 @@ int ttm_bo_mem_space(struct ttm_buffer_object *bo,
>  
>  		if (ret == 0 && mem->mm_node) {
>  			mem->placement = cur_flags;
> +			mem->mm_node->private = bo;
>  			return 0;
>  		}
>  
> @@ -868,6 +871,173 @@ int ttm_bo_mem_space(struct ttm_buffer_object *bo,
>  }
>  EXPORT_SYMBOL(ttm_bo_mem_space);
>  
> +static unsigned long ttm_bo_free_size_if_evicted(struct ttm_buffer_object *bo)
> +{
> +	struct ttm_mem_type_manager *man = &bo->bdev->man[bo->mem.mem_type];
> +	struct drm_mm_node *node;
> +	unsigned long size;
> +
> +	size = bo->mem.mm_node->size;
> +	if (bo->mem.mm_node->ml_entry.prev != &man->manager.ml_entry) {
> +		node = list_entry(bo->mem.mm_node->ml_entry.prev,
> +					struct drm_mm_node, ml_entry);
> +		if (node->free)
> +			size += node->size;
> +	}
> +	if (bo->mem.mm_node->ml_entry.next != &man->manager.ml_entry) {
> +		node = list_entry(bo->mem.mm_node->ml_entry.next,
> +					struct drm_mm_node, ml_entry);
> +		if (node->free)
> +			size += node->size;
> +	}
> +	return size;
> +}
> +
> +static void ttm_manager_evict_first(struct ttm_buffer_object *bo)
> +{
> +	struct ttm_mem_type_manager *man = &bo->bdev->man[bo->mem.mem_type];
> +	unsigned long free_size_bo, free_size_bo_first;
> +	struct ttm_buffer_object *bo_first;
> +
> +	/* BO is not on lru list, don't add it */
> +	if (!list_empty(&bo->lru))
> +		return;
> +	bo_first = list_first_entry(&man->lru, struct ttm_buffer_object, lru);
> +	free_size_bo = ttm_bo_free_size_if_evicted(bo);
> +	free_size_bo_first = ttm_bo_free_size_if_evicted(bo_first);
> +	if (free_size_bo > free_size_bo_first) {
> +		list_del_init(&bo->lru);
> +		list_add(&bo->lru, &man->lru);
> +	}
> +}
> +
>   

Hmm, Can you explain why we'd ever *not* want to put bo first on the lru 
list?
I mean , bo_first might not even be in the correct range? That would 
also save the size computations.


> +static int ttm_manager_space_range(struct ttm_buffer_object *bo,
> +					uint32_t mem_type,
> +					struct ttm_mem_reg *mem,
> +					unsigned long start, unsigned long end,
> +					bool interruptible, bool no_wait)
> +{
> +	struct ttm_bo_global *glob = bo->glob;
> +	struct drm_mm_node *entry;
> +	struct ttm_mem_type_manager *man = &bo->bdev->man[mem_type];
> +	struct drm_mm *mm = &man->manager;
> +	unsigned size = end - start;
> +	struct ttm_buffer_object *tbo;
> +	unsigned wasted;
> +	int ret;
> +
> +	mem->mm_node = NULL;
> +	ret = drm_mm_pre_get(&man->manager);
> +	if (unlikely(ret))
> +		return ret;
> +	spin_lock(&glob->lru_lock);
> +	list_for_each_entry(entry, &mm->ml_entry, ml_entry) {
> +		wasted = 0;
> +		if (mem->page_alignment) {
> +			unsigned tmp = entry->start % mem->page_alignment;
> +			if (tmp)
> +				wasted += mem->page_alignment - tmp;
> +		}
> +		if (entry->start < end && (entry->start+entry->size) > start) {
> +			if (!entry->free) {
> +				tbo = (struct ttm_buffer_object*)entry->private;
> +				ttm_manager_evict_first(tbo);
> +			} else {
> +				if ((entry->size - wasted) <= size) {
> +					/* Found a place */
> +					entry = drm_mm_get_block_atomic(entry,
> +							mem->num_pages,
> +							mem->page_alignment);
> +					mem->mm_node = entry;
> +					mem->mem_type = mem_type;
> +					entry->private = bo;
> +					break;
> +				}
> +			}
> +		}
> +	}
> +	spin_unlock(&glob->lru_lock);
> +	return 0;
> +}
>   

There's stuff here that belongs in drm_mm.c rather in the ttm code!
What about
drm_mm_search_free_range() // Returns a free block in the given range if 
any.
and perhaps functions to return the first non-free entry?


> +
> +static int ttm_bo_mem_space_range(struct ttm_buffer_object *bo,
> +				uint32_t proposed_placement,
> +				struct ttm_mem_reg *mem,
> +				unsigned long start, unsigned long end,
> +				bool interruptible, bool no_wait)
> +{
> +	struct ttm_bo_device *bdev = bo->bdev;
> +	struct ttm_bo_global *glob = bo->glob;
> +	struct ttm_mem_type_manager *man;
> +	uint32_t num_prios = bdev->driver->num_mem_type_prio;
> +	const uint32_t *prios = bdev->driver->mem_type_prio;
> +	uint32_t i;
> +	uint32_t mem_type = TTM_PL_SYSTEM;
> +	uint32_t cur_flags = 0;
> +	bool type_found = false;
> +	bool type_ok = false;
> +	bool evicted;
> +	int ret;
> +
> +	mem->mm_node = NULL;
> +retry:
> +	for (i = 0; i < num_prios; ++i) {
> +		mem_type = prios[i];
> +		man = &bdev->man[mem_type];
> +		type_ok = ttm_bo_mt_compatible(man,
> +						bo->type == ttm_bo_type_user,
> +						mem_type, proposed_placement,
> +						&cur_flags);
> +		if (!type_ok)
> +			continue;
> +		if (start > (man->offset + man->size) || end < man->offset)
> +			continue;
> +		cur_flags = ttm_bo_select_caching(man, bo->mem.placement,
> +							cur_flags);
> +		if (mem_type == TTM_PL_SYSTEM)
> +			break;
> +		if (man->has_type && man->use_type) {
> +			type_found = true;
> +			mem->placement = cur_flags;
> +			ret = ttm_manager_space_range(bo, mem_type, mem,
> +							start, end,
> +							interruptible, no_wait);
> +			if (ret)
> +				return ret;
> +		}
> +		if (mem->mm_node)
> +			break;
> +	}
> +	if ((type_ok && (mem_type == TTM_PL_SYSTEM)) || mem->mm_node) {
> +		mem->mem_type = mem_type;
> +		mem->placement = cur_flags;
> +		return 0;
> +	}
> +	for (i = 0, evicted = false; i < num_prios; ++i) {
> +		struct ttm_buffer_object *tmp;
> +
> +		mem_type = prios[i];
> +		man = &bdev->man[mem_type];
> +		type_ok = ttm_bo_mt_compatible(man,
> +						bo->type == ttm_bo_type_user,
> +						mem_type, proposed_placement,
> +						&cur_flags);
> +		if (!type_ok)
> +			continue;
> +		if (start > (man->offset + man->size) || end < man->offset)
> +			continue;
>   

> +		spin_lock(&glob->lru_lock);
> +		tmp = list_first_entry(&man->lru, struct ttm_buffer_object, lru);
> +		spin_unlock(&glob->lru_lock);
> +		ret = ttm_bo_evict(tmp, mem_type, interruptible, no_wait);
>   

^^^^This is incorrect. As soon as you release the lru lock, tmp may be 
destroyed by another process.
Furthermore, tmp must be reserved before calling ttm_bo_evict.  Please 
see how this is done in
ttm_bo_mem_force_space.


> +		if (unlikely(ret != 0))
> +			return ret;
> +	}
> +	if (!evicted)
> +		return -ENOMEM;
> +	goto retry;
> +}
> +
>  int ttm_bo_wait_cpu(struct ttm_buffer_object *bo, bool no_wait)
>  {
>  	int ret = 0;
> @@ -925,6 +1095,7 @@ int ttm_bo_move_buffer(struct ttm_buffer_object *bo,
>  out_unlock:
>  	if (ret && mem.mm_node) {
>  		spin_lock(&glob->lru_lock);
> +		mem.mm_node->private = NULL;
>  		drm_mm_put_block(mem.mm_node);
>  		spin_unlock(&glob->lru_lock);
>  	}
> @@ -998,6 +1169,137 @@ int ttm_buffer_object_validate(struct ttm_buffer_object *bo,
>  }
>  EXPORT_SYMBOL(ttm_buffer_object_validate);
>  
> +int ttm_bo_move_buffer_range(struct ttm_buffer_object *bo,
> +				uint32_t proposed_placement,
> +				unsigned long start, unsigned long end,
> +				bool interruptible, bool no_wait)
> +{
> +	struct ttm_bo_global *glob = bo->glob;
> +	int ret = 0;
> +	struct ttm_mem_reg mem;
> +
> +	BUG_ON(!atomic_read(&bo->reserved));
> +
> +	/*
> +	 * FIXME: It's possible to pipeline buffer moves.
> +	 * Have the driver move function wait for idle when necessary,
> +	 * instead of doing it here.
> +	 */
> +
> +	spin_lock(&bo->lock);
> +	ret = ttm_bo_wait(bo, false, interruptible, no_wait);
> +	spin_unlock(&bo->lock);
> +
> +	if (ret)
> +		return ret;
> +
> +	mem.num_pages = bo->num_pages;
> +	mem.size = mem.num_pages << PAGE_SHIFT;
> +	mem.page_alignment = bo->mem.page_alignment;
> +
> +	/*
> +	 * Determine where to move the buffer.
> +	 */
> +
> +	ret = ttm_bo_mem_space_range(bo, proposed_placement, &mem,
> +					start, end, interruptible, no_wait);
> +	if (ret)
> +		goto out_unlock;
> +
> +	ret = ttm_bo_handle_move_mem(bo, &mem, false, interruptible, no_wait);
> +
> +out_unlock:
> +	if (ret && mem.mm_node) {
> +		spin_lock(&glob->lru_lock);
> +		mem.mm_node->private = NULL;
> +		drm_mm_put_block(mem.mm_node);
> +		spin_unlock(&glob->lru_lock);
> +	}
> +	return ret;
> +}
> +
> +static int ttm_bo_mem_compat_range(uint32_t proposed_placement,
> +					struct ttm_mem_reg *mem,
> +					unsigned long start, unsigned long end)
> +{
> +	if ((proposed_placement & mem->placement & TTM_PL_MASK_MEM) == 0)
> +		return 0;
> +	if ((proposed_placement & mem->placement & TTM_PL_MASK_CACHING) == 0)
> +		return 0;
> +	if (mem->mm_node) {
> +		unsigned long eend = mem->mm_node->start + mem->mm_node->size;
> +		if (mem->mm_node->start < start || eend > end)
> +			return 0;
> +	}
> +
> +	return 1;
> +}
> +
> +int ttm_buffer_object_validate_range(struct ttm_buffer_object *bo,
> +					uint32_t proposed_placement,
> +					unsigned long start, unsigned long end,
> +					bool interruptible, bool no_wait)
> +{
> +	int ret;
> +
> +	/* Convert to page */
> +	start = start >> PAGE_SHIFT;
> +	end = end >> PAGE_SHIFT;
> +	/* Check that range is valid */
> +	if (start > end || (end - start) < bo->num_pages)
> +		return -EINVAL;
> +
> +	BUG_ON(!atomic_read(&bo->reserved));
> +	bo->proposed_placement = proposed_placement;
> +
> +	TTM_DEBUG("Proposed placement 0x%08lx, Old flags 0x%08lx\n",
> +		  (unsigned long)proposed_placement,
> +		  (unsigned long)bo->mem.placement);
> +
> +	/*
> +	 * Check whether we need to move buffer.
> +	 */
> +
> +	if (!ttm_bo_mem_compat_range(bo->proposed_placement, &bo->mem,
> +					start, end)) {
> +		ret = ttm_bo_move_buffer_range(bo, bo->proposed_placement,
> +						start, end,
> +						interruptible, no_wait);
> +		if (ret) {
> +			if (ret != -ERESTART)
> +				printk(KERN_ERR TTM_PFX
> +					"Failed moving buffer. "
> +					"Proposed placement 0x%08x\n",
> +					bo->proposed_placement);
> +			if (ret == -ENOMEM)
> +				printk(KERN_ERR TTM_PFX
> +					"Out of aperture space or "
> +					"DRM memory quota.\n");
> +			return ret;
> +		}
> +	}
> +
> +	/*
> +	 * We might need to add a TTM.
> +	 */
> +	if (bo->mem.mem_type == TTM_PL_SYSTEM && bo->ttm == NULL) {
> +		ret = ttm_bo_add_ttm(bo, true);
> +		if (ret)
> +			return ret;
> +	}
> +	/*
> +	 * Validation has succeeded, move the access and other
> +	 * non-mapping-related flag bits from the proposed flags to
> +	 * the active flags
> +	 */
> +
> +	ttm_flag_masked(&bo->mem.placement, bo->proposed_placement,
> +			~TTM_PL_MASK_MEMTYPE);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(ttm_buffer_object_validate_range);
> +
>  int
>  ttm_bo_check_placement(struct ttm_buffer_object *bo,
>  		       uint32_t set_flags, uint32_t clr_flags)
> @@ -1321,6 +1623,7 @@ int ttm_bo_init_mm(struct ttm_bo_device *bdev, unsigned type,
>  	man->has_type = true;
>  	man->use_type = true;
>  	man->size = p_size;
> +	man->offset = p_offset;
>  
>  	INIT_LIST_HEAD(&man->lru);
>  
> diff --git a/include/drm/ttm/ttm_bo_api.h b/include/drm/ttm/ttm_bo_api.h
> index 4911461..3756970 100644
> --- a/include/drm/ttm/ttm_bo_api.h
> +++ b/include/drm/ttm/ttm_bo_api.h
> @@ -308,6 +308,11 @@ extern int ttm_bo_wait(struct ttm_buffer_object *bo, bool lazy,
>  extern int ttm_buffer_object_validate(struct ttm_buffer_object *bo,
>  				      uint32_t proposed_placement,
>  				      bool interruptible, bool no_wait);
> +extern int ttm_buffer_object_validate_range(struct ttm_buffer_object *bo,
> +					uint32_t proposed_placement,
> +					unsigned long start, unsigned long end,
> +					bool interruptible, bool no_wait);
>   

Please add a documentation entry in the header.


> +
>  /**
>   * ttm_bo_unref
>   *
> diff --git a/include/drm/ttm/ttm_bo_driver.h b/include/drm/ttm/ttm_bo_driver.h
> index e8cd6d2..f00ba12 100644
> --- a/include/drm/ttm/ttm_bo_driver.h
> +++ b/include/drm/ttm/ttm_bo_driver.h
> @@ -224,6 +224,7 @@ struct ttm_mem_type_manager {
>  	unsigned long gpu_offset;
>  	unsigned long io_offset;
>  	unsigned long io_size;
> +	unsigned long offset;
>  	void *io_addr;
>  	uint64_t size;
>  	uint32_t available_caching;
>   

Please add a doc entry in the header also here.
@offset is a bit confusing given all other offset members. What about 
managed_offset or something similar?






