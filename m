Return-Path: <linux-kernel-owner+w=401wt.eu-S1765671AbZDAQfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765671AbZDAQfg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 12:35:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760260AbZDAQfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 12:35:25 -0400
Received: from gw-ca.panasas.com ([209.116.51.66]:21570 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756288AbZDAQfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 12:35:24 -0400
Message-ID: <49D3974F.6080601@panasas.com>
Date: Wed, 01 Apr 2009 19:33:19 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: axboe@kernel.dk, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH 10/17] bio: use bio_create_from_sgl() in bio_map_user_iov()
References: <1238593472-30360-1-git-send-email-tj@kernel.org> <1238593472-30360-11-git-send-email-tj@kernel.org>
In-Reply-To: <1238593472-30360-11-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Apr 2009 16:35:19.0772 (UTC) FILETIME=[D896C9C0:01C9B2E7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2009 04:44 PM, Tejun Heo wrote:
> Impact: cleanup
> 
> As bio_map_user_iov() is unique in the way it acquires pages to map
> from all other three operations (user-copy, kern-map, kern-copy), the
> function still needs to get the pages itself but the bio creation can
> use bio_create_from_sgl().  Create sgl of mapped pages and use it to
> create bio from it.  The code will be further simplified with future
> changes to bio_create_from_sgl().
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  fs/bio.c |   79 ++++++++++++++++++++++++++------------------------------------
>  1 files changed, 33 insertions(+), 46 deletions(-)
> 
> diff --git a/fs/bio.c b/fs/bio.c
> index 4540afc..1ca8b16 100644
> --- a/fs/bio.c
> +++ b/fs/bio.c
> @@ -1059,13 +1059,13 @@ struct bio *bio_copy_user(struct request_queue *q, struct rq_map_data *md,
>  struct bio *bio_map_user_iov(struct request_queue *q, struct block_device *bdev,
>  			     struct iovec *iov, int count, int rw, gfp_t gfp)
>  {
> -	int i, j;
>  	size_t tot_len = 0;
>  	int nr_pages = 0;
> +	int nents = 0;
> +	struct scatterlist *sgl;
>  	struct page **pages;
>  	struct bio *bio;
> -	int cur_page = 0;
> -	int ret, offset;
> +	int i, ret;
>  
>  	for (i = 0; i < count; i++) {
>  		unsigned long uaddr = (unsigned long)iov[i].iov_base;
> @@ -1088,70 +1088,57 @@ struct bio *bio_map_user_iov(struct request_queue *q, struct block_device *bdev,
>  	if (!nr_pages || tot_len & q->dma_pad_mask)
>  		return ERR_PTR(-EINVAL);
>  
> -	bio = bio_kmalloc(gfp, nr_pages);
> -	if (!bio)
> +	sgl = kmalloc(nr_pages * sizeof(sgl[0]), gfp);
> +	if (!sgl)
>  		return ERR_PTR(-ENOMEM);
> +	sg_init_table(sgl, nr_pages);
>  
>  	ret = -ENOMEM;
> -	pages = kcalloc(nr_pages, sizeof(struct page *), gfp);
> +	pages = kcalloc(nr_pages, sizeof(pages[0]), gfp);
>  	if (!pages)
> -		goto out;
> +		goto err_sgl;
>  
>  	for (i = 0; i < count; i++) {
>  		unsigned long uaddr = (unsigned long)iov[i].iov_base;
>  		unsigned long len = iov[i].iov_len;
> -		unsigned long end = (uaddr + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
> -		unsigned long start = uaddr >> PAGE_SHIFT;
> -		const int local_nr_pages = end - start;
> -		const int page_limit = cur_page + local_nr_pages;
> -		
> +		unsigned long offset = offset_in_page(uaddr);
> +		int local_nr_pages = PFN_UP(uaddr + len) - PFN_DOWN(uaddr);
> +
>  		ret = get_user_pages_fast(uaddr, local_nr_pages, rw == READ,
> -					  &pages[cur_page]);
> +					  &pages[nents]);

Fast look at all users of get_user_pages_fast().

This can be converted to take an sglist instead of pages* array.
Outside of this code all users either have a fixed-size allocated array
or hard coded one page. This here is the main user. (Out of 5)

Note to self:

>  		if (ret < local_nr_pages) {
>  			ret = -EFAULT;
> -			goto out_unmap;
> +			goto err_pages;
>  		}
>  
> -		offset = uaddr & ~PAGE_MASK;
> -		for (j = cur_page; j < page_limit; j++) {
> -			unsigned int bytes = PAGE_SIZE - offset;
> +		while (len) {
> +			unsigned int bytes = min(PAGE_SIZE - offset, len);
>  
> -			if (len <= 0)
> -				break;
> -			
> -			if (bytes > len)
> -				bytes = len;
> -
> -			/*
> -			 * sorry...
> -			 */
> -			if (bio_add_pc_page(q, bio, pages[j], bytes, offset) <
> -					    bytes)
> -				break;
> +			sg_set_page(&sgl[nents], pages[nents], bytes, offset);
>  
> +			nents++;
>  			len -= bytes;
>  			offset = 0;
>  		}
> -
> -		cur_page = j;
> -		/*
> -		 * release the pages we didn't map into the bio, if any
> -		 */
> -		while (j < page_limit)
> -			page_cache_release(pages[j++]);
>  	}
> +	BUG_ON(nents != nr_pages);
>  
> -	kfree(pages);
> +	bio = bio_create_from_sgl(q, sgl, nents, nr_pages, rw, gfp);
> +	if (IS_ERR(bio)) {
> +		ret = PTR_ERR(bio);
> +		goto err_pages;
> +	}
>  
> -	/*
> -	 * set data direction, and check if mapped pages need bouncing
> -	 */
> -	if (rw == WRITE)
> -		bio->bi_rw |= (1 << BIO_RW);
> +	/* release the pages we didn't map into the bio, if any */
> +	for (i = bio->bi_vcnt; i < nr_pages; i++)
> +		page_cache_release(pages[i]);
>  
>  	bio->bi_bdev = bdev;
>  	bio->bi_flags |= (1 << BIO_USER_MAPPED);
>  
> +	kfree(sgl);
> +	kfree(pages);
> +
>  	/*
>  	 * subtle -- if __bio_map_user() ended up bouncing a bio,
>  	 * it would normally disappear when its bi_end_io is run.
> @@ -1162,15 +1149,15 @@ struct bio *bio_map_user_iov(struct request_queue *q, struct block_device *bdev,
>  
>  	return bio;
>  
> - out_unmap:
> +err_pages:
>  	for (i = 0; i < nr_pages; i++) {
> -		if(!pages[i])
> +		if (!pages[i])
>  			break;
>  		page_cache_release(pages[i]);
>  	}
> - out:
>  	kfree(pages);
> -	bio_put(bio);
> +err_sgl:
> +	kfree(sgl);
>  	return ERR_PTR(ret);
>  }
>  

