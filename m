Return-Path: <linux-kernel-owner+w=401wt.eu-S1752023AbZG3P7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023AbZG3P7R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 11:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751003AbZG3P7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 11:59:15 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:50222 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbZG3P7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 11:59:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:in-reply-to:references
         :x-mailer:mime-version:content-type:content-transfer-encoding;
        b=G1lRLKwpy+wsok0tRhwe20Szu84jz4TnvJnzDBzQMcaZSYY9GPPmHEvV6symspnleC
         k2pkzu7qQNmKNRmGZmzwbkL310KSAOMQobNoRJjP1PFr9gerAp/NzMae6HmS48NFpyoK
         AIlMLCw8tXCyyPlLLXxKA+ZH399quoPVCGmtw=
Date: Thu, 30 Jul 2009 19:00:09 +0300
From: Pekka Paalanen <pq@iki.fi>
To: Thomas Hellstrom <thellstrom@vmware.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
Subject: Re: [PATCH 2/2] ttm: Fix ttm in-kernel copying of pages with
 non-standard caching attributes.
Message-ID: <20090730190010.649589ba@iki.fi>
In-Reply-To: <1248422254-32193-2-git-send-email-thellstrom@vmware.com>
References: <1248422254-32193-1-git-send-email-thellstrom@vmware.com>
	<1248422254-32193-2-git-send-email-thellstrom@vmware.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

since I see this patch in Linus' tree, and I likely have to patch
TTM in Nouveau's compat-branch to compile with older kernels,
I have a question below.

(The Nouveau kernel tree's compat branch offers drm.ko, ttm.ko and
nouveau.ko to be built against kernels 2.6.28 and later.)

On Fri, 24 Jul 2009 09:57:34 +0200
Thomas Hellstrom <thellstrom@vmware.com> wrote:

> For x86 this affected highmem pages only, since they were always kmapped
> cache-coherent, and this is fixed using kmap_atomic_prot().
> 
> For other architectures that may not modify the linear kernel map we
> resort to vmap() for now, since kmap_atomic_prot() generally uses the
> linear kernel map for lowmem pages. This of course comes with a
> performance impact and should be optimized when possible.
> 
> Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
> ---
>  drivers/gpu/drm/ttm/ttm_bo_util.c |   63 ++++++++++++++++++++++++++++++------
>  1 files changed, 52 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/gpu/drm/ttm/ttm_bo_util.c b/drivers/gpu/drm/ttm/ttm_bo_util.c
> index 3e5d0c4..ce2e6f3 100644
> --- a/drivers/gpu/drm/ttm/ttm_bo_util.c
> +++ b/drivers/gpu/drm/ttm/ttm_bo_util.c
> @@ -136,7 +136,8 @@ static int ttm_copy_io_page(void *dst, void *src, unsigned long page)
>  }
>  
>  static int ttm_copy_io_ttm_page(struct ttm_tt *ttm, void *src,
> -				unsigned long page)
> +				unsigned long page,
> +				pgprot_t prot)
>  {
>  	struct page *d = ttm_tt_get_page(ttm, page);
>  	void *dst;
> @@ -145,17 +146,35 @@ static int ttm_copy_io_ttm_page(struct ttm_tt *ttm, void *src,
>  		return -ENOMEM;
>  
>  	src = (void *)((unsigned long)src + (page << PAGE_SHIFT));
> -	dst = kmap(d);
> +
> +#ifdef CONFIG_X86
> +	dst = kmap_atomic_prot(d, KM_USER0, prot);
> +#else
> +	if (prot != PAGE_KERNEL)
> +		dst = vmap(&d, 1, 0, prot);
> +	else
> +		dst = kmap(d);
> +#endif

What are the implications of choosing the non-CONFIG_X86 path
even on x86?

Is kmap_atomic_prot() simply an optimization allowed by the x86
arch, and the alternate way also works, although it uses the
precious vmalloc address space?

Since kmap_atomic_prot() is not exported on earlier kernels,
I'm tempted to just do the non-CONFIG_X86 path.

>  	if (!dst)
>  		return -ENOMEM;
>  
>  	memcpy_fromio(dst, src, PAGE_SIZE);
> -	kunmap(d);
> +
> +#ifdef CONFIG_X86
> +	kunmap_atomic(dst, KM_USER0);
> +#else
> +	if (prot != PAGE_KERNEL)
> +		vunmap(dst);
> +	else
> +		kunmap(d);
> +#endif
> +
>  	return 0;
>  }
>  
>  static int ttm_copy_ttm_io_page(struct ttm_tt *ttm, void *dst,
> -				unsigned long page)
> +				unsigned long page,
> +				pgprot_t prot)
>  {
>  	struct page *s = ttm_tt_get_page(ttm, page);
>  	void *src;
> @@ -164,12 +183,28 @@ static int ttm_copy_ttm_io_page(struct ttm_tt *ttm, void *dst,
>  		return -ENOMEM;
>  
>  	dst = (void *)((unsigned long)dst + (page << PAGE_SHIFT));
> -	src = kmap(s);
> +#ifdef CONFIG_X86
> +	src = kmap_atomic_prot(s, KM_USER0, prot);
> +#else
> +	if (prot != PAGE_KERNEL)
> +		src = vmap(&s, 1, 0, prot);
> +	else
> +		src = kmap(s);
> +#endif
>  	if (!src)
>  		return -ENOMEM;
>  
>  	memcpy_toio(dst, src, PAGE_SIZE);
> -	kunmap(s);
> +
> +#ifdef CONFIG_X86
> +	kunmap_atomic(src, KM_USER0);
> +#else
> +	if (prot != PAGE_KERNEL)
> +		vunmap(src);
> +	else
> +		kunmap(s);
> +#endif
> +
>  	return 0;
>  }
>  
> @@ -214,11 +249,17 @@ int ttm_bo_move_memcpy(struct ttm_buffer_object *bo,
>  
>  	for (i = 0; i < new_mem->num_pages; ++i) {
>  		page = i * dir + add;
> -		if (old_iomap == NULL)
> -			ret = ttm_copy_ttm_io_page(ttm, new_iomap, page);
> -		else if (new_iomap == NULL)
> -			ret = ttm_copy_io_ttm_page(ttm, old_iomap, page);
> -		else
> +		if (old_iomap == NULL) {
> +			pgprot_t prot = ttm_io_prot(old_mem->placement,
> +						    PAGE_KERNEL);
> +			ret = ttm_copy_ttm_io_page(ttm, new_iomap, page,
> +						   prot);
> +		} else if (new_iomap == NULL) {
> +			pgprot_t prot = ttm_io_prot(new_mem->placement,
> +						    PAGE_KERNEL);
> +			ret = ttm_copy_io_ttm_page(ttm, old_iomap, page,
> +						   prot);
> +		} else
>  			ret = ttm_copy_io_page(new_iomap, old_iomap, page);
>  		if (ret)
>  			goto out1;
> -- 
> 1.6.1.3


Thanks.

-- 
Pekka Paalanen
http://www.iki.fi/pq/

