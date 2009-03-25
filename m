Return-Path: <linux-kernel-owner+w=401wt.eu-S1757346AbZCYXbE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346AbZCYXbE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 19:31:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752893AbZCYXax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 19:30:53 -0400
Received: from gir.skynet.ie ([193.1.99.77]:39165 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849AbZCYXaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 19:30:52 -0400
Date: Wed, 25 Mar 2009 23:30:48 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Eric Anholt <eric@anholt.net>
cc: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
Subject: Re: [PATCH 4/6] drm/i915: Fix lock order reversal in shmem pread
 path.
In-Reply-To: <1238017510-26784-5-git-send-email-eric@anholt.net>
Message-ID: <alpine.DEB.2.00.0903252328590.27027@skynet.skynet.ie>
References: <1238017510-26784-1-git-send-email-eric@anholt.net> <1238017510-26784-2-git-send-email-eric@anholt.net> <1238017510-26784-3-git-send-email-eric@anholt.net> <1238017510-26784-4-git-send-email-eric@anholt.net>
 <1238017510-26784-5-git-send-email-eric@anholt.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



I've no idea when a fault is likely in the fast case, i.e. will it happen
usually on the first page etc, because if it happens on the last page and 
you fallback and restart the whole copy, I would think that would be 
sub-optimal, granted it could get ugly quick, but this code has already 
hit a few branches on the tree.

Dave.

>  static inline int
> +fast_shmem_read(struct page **pages,
> +		loff_t page_base, int page_offset,
> +		char __user *data,
> +		int length)
> +{
> +	char __iomem *vaddr;
> +	int ret;
> +
> +	vaddr = kmap_atomic(pages[page_base >> PAGE_SHIFT], KM_USER0);
> +	if (vaddr == NULL)
> +		return -ENOMEM;
> +	ret = __copy_to_user_inatomic(data, vaddr + page_offset, length);
> +	kunmap_atomic(vaddr, KM_USER0);
> +
> +	return ret;
> +}
> +
> +static inline int
>  slow_shmem_copy(struct page *dst_page,
>  		int dst_offset,
>  		struct page *src_page,
> @@ -164,6 +182,179 @@ slow_shmem_copy(struct page *dst_page,
>  }
>  
>  /**
> + * This is the fast shmem pread path, which attempts to copy_from_user directly
> + * from the backing pages of the object to the user's address space.  On a
> + * fault, it fails so we can fall back to i915_gem_shmem_pwrite_slow().
> + */
> +static int
> +i915_gem_shmem_pread_fast(struct drm_device *dev, struct drm_gem_object *obj,
> +			  struct drm_i915_gem_pread *args,
> +			  struct drm_file *file_priv)
> +{
> +	struct drm_i915_gem_object *obj_priv = obj->driver_private;
> +	ssize_t remain;
> +	loff_t offset, page_base;
> +	char __user *user_data;
> +	int page_offset, page_length;
> +	int ret;
> +
> +	user_data = (char __user *) (uintptr_t) args->data_ptr;
> +	remain = args->size;
> +
> +	mutex_lock(&dev->struct_mutex);
> +
> +	ret = i915_gem_object_get_pages(obj);
> +	if (ret != 0)
> +		goto fail_unlock;
> +
> +	ret = i915_gem_object_set_cpu_read_domain_range(obj, args->offset,
> +							args->size);
> +	if (ret != 0)
> +		goto fail_put_pages;
> +
> +	obj_priv = obj->driver_private;
> +	offset = args->offset;
> +
> +	while (remain > 0) {
> +		/* Operation in this page
> +		 *
> +		 * page_base = page offset within aperture
> +		 * page_offset = offset within page
> +		 * page_length = bytes to copy for this page
> +		 */
> +		page_base = (offset & ~(PAGE_SIZE-1));
> +		page_offset = offset & (PAGE_SIZE-1);
> +		page_length = remain;
> +		if ((page_offset + remain) > PAGE_SIZE)
> +			page_length = PAGE_SIZE - page_offset;
> +
> +		ret = fast_shmem_read(obj_priv->pages,
> +				      page_base, page_offset,
> +				      user_data, page_length);
> +		if (ret)
> +			goto fail_put_pages;
> +
> +		remain -= page_length;
> +		user_data += page_length;
> +		offset += page_length;
> +	}
> +
> +fail_put_pages:
> +	i915_gem_object_put_pages(obj);
> +fail_unlock:
> +	mutex_unlock(&dev->struct_mutex);
> +
> +	return ret;
> +}
> +
> +/**
> + * This is the fallback shmem pread path, which allocates temporary storage
> + * in kernel space to copy_to_user into outside of the struct_mutex, so we
> + * can copy out of the object's backing pages while holding the struct mutex
> + * and not take page faults.
> + */
> +static int
> +i915_gem_shmem_pread_slow(struct drm_device *dev, struct drm_gem_object *obj,
> +			  struct drm_i915_gem_pread *args,
> +			  struct drm_file *file_priv)
> +{
> +	struct drm_i915_gem_object *obj_priv = obj->driver_private;
> +	struct mm_struct *mm = current->mm;
> +	struct page **user_pages;
> +	ssize_t remain;
> +	loff_t offset, pinned_pages, i;
> +	loff_t first_data_page, last_data_page, num_pages;
> +	int shmem_page_index, shmem_page_offset;
> +	int data_page_index,  data_page_offset;
> +	int page_length;
> +	int ret;
> +	uint64_t data_ptr = args->data_ptr;
> +
> +	remain = args->size;
> +
> +	/* Pin the user pages containing the data.  We can't fault while
> +	 * holding the struct mutex, yet we want to hold it while
> +	 * dereferencing the user data.
> +	 */
> +	first_data_page = data_ptr / PAGE_SIZE;
> +	last_data_page = (data_ptr + args->size - 1) / PAGE_SIZE;
> +	num_pages = last_data_page - first_data_page + 1;
> +
> +	user_pages = kcalloc(num_pages, sizeof(struct page *), GFP_KERNEL);
> +	if (user_pages == NULL)
> +		return -ENOMEM;
> +
> +	down_read(&mm->mmap_sem);
> +	pinned_pages = get_user_pages(current, mm, (uintptr_t)args->data_ptr,
> +				      num_pages, 0, 0, user_pages, NULL);
> +	up_read(&mm->mmap_sem);
> +	if (pinned_pages < num_pages) {
> +		ret = -EFAULT;
> +		goto fail_put_user_pages;
> +	}
> +
> +	mutex_lock(&dev->struct_mutex);
> +
> +	ret = i915_gem_object_get_pages(obj);
> +	if (ret != 0)
> +		goto fail_unlock;
> +
> +	ret = i915_gem_object_set_cpu_read_domain_range(obj, args->offset,
> +							args->size);
> +	if (ret != 0)
> +		goto fail_put_pages;
> +
> +	obj_priv = obj->driver_private;
> +	offset = args->offset;
> +
> +	while (remain > 0) {
> +		/* Operation in this page
> +		 *
> +		 * shmem_page_index = page number within shmem file
> +		 * shmem_page_offset = offset within page in shmem file
> +		 * data_page_index = page number in get_user_pages return
> +		 * data_page_offset = offset with data_page_index page.
> +		 * page_length = bytes to copy for this page
> +		 */
> +		shmem_page_index = offset / PAGE_SIZE;
> +		shmem_page_offset = offset & ~PAGE_MASK;
> +		data_page_index = data_ptr / PAGE_SIZE - first_data_page;
> +		data_page_offset = data_ptr & ~PAGE_MASK;
> +
> +		page_length = remain;
> +		if ((shmem_page_offset + page_length) > PAGE_SIZE)
> +			page_length = PAGE_SIZE - shmem_page_offset;
> +		if ((data_page_offset + page_length) > PAGE_SIZE)
> +			page_length = PAGE_SIZE - data_page_offset;
> +
> +		ret = slow_shmem_copy(user_pages[data_page_index],
> +				      data_page_offset,
> +				      obj_priv->pages[shmem_page_index],
> +				      shmem_page_offset,
> +				      page_length);
> +		if (ret)
> +			goto fail_put_pages;
> +
> +		remain -= page_length;
> +		data_ptr += page_length;
> +		offset += page_length;
> +	}
> +
> +fail_put_pages:
> +	i915_gem_object_put_pages(obj);
> +fail_unlock:
> +	mutex_unlock(&dev->struct_mutex);
> +fail_put_user_pages:
> +	for (i = 0; i < pinned_pages; i++) {
> +		SetPageDirty(user_pages[i]);
> +		page_cache_release(user_pages[i]);
> +	}
> +	kfree(user_pages);
> +
> +	return ret;
> +}
> +
> +/**
>   * Reads data from the object referenced by handle.
>   *
>   * On error, the contents of *data are undefined.
> @@ -175,8 +366,6 @@ i915_gem_pread_ioctl(struct drm_device *dev, void *data,
>  	struct drm_i915_gem_pread *args = data;
>  	struct drm_gem_object *obj;
>  	struct drm_i915_gem_object *obj_priv;
> -	ssize_t read;
> -	loff_t offset;
>  	int ret;
>  
>  	obj = drm_gem_object_lookup(dev, file_priv, args->handle);
> @@ -194,33 +383,13 @@ i915_gem_pread_ioctl(struct drm_device *dev, void *data,
>  		return -EINVAL;
>  	}
>  
> -	mutex_lock(&dev->struct_mutex);
> -
> -	ret = i915_gem_object_set_cpu_read_domain_range(obj, args->offset,
> -							args->size);
> -	if (ret != 0) {
> -		drm_gem_object_unreference(obj);
> -		mutex_unlock(&dev->struct_mutex);
> -		return ret;
> -	}
> -
> -	offset = args->offset;
> -
> -	read = vfs_read(obj->filp, (char __user *)(uintptr_t)args->data_ptr,
> -			args->size, &offset);
> -	if (read != args->size) {
> -		drm_gem_object_unreference(obj);
> -		mutex_unlock(&dev->struct_mutex);
> -		if (read < 0)
> -			return read;
> -		else
> -			return -EINVAL;
> -	}
> +	ret = i915_gem_shmem_pread_fast(dev, obj, args, file_priv);
> +	if (ret != 0)
> +		ret = i915_gem_shmem_pread_slow(dev, obj, args, file_priv);
>  
>  	drm_gem_object_unreference(obj);
> -	mutex_unlock(&dev->struct_mutex);
>  
> -	return 0;
> +	return ret;
>  }
>  
>  /* This is the fast write path which cannot handle
> 
