Return-Path: <linux-kernel-owner+w=401wt.eu-S1762295AbZDBIjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762295AbZDBIjR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 04:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757795AbZDBIjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 04:39:00 -0400
Received: from gw-ca.panasas.com ([209.116.51.66]:12973 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757651AbZDBIi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 04:38:58 -0400
Message-ID: <49D47925.5050307@panasas.com>
Date: Thu, 02 Apr 2009 11:36:53 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: axboe@kernel.dk, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH 05/17] bio: cleanup rw usage
References: <1238593472-30360-1-git-send-email-tj@kernel.org> <1238593472-30360-6-git-send-email-tj@kernel.org>
In-Reply-To: <1238593472-30360-6-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Apr 2009 08:38:55.0155 (UTC) FILETIME=[753E2030:01C9B36E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2009 04:44 PM, Tejun Heo wrote:
> Impact: cleanup
> 
> bio confusingly uses @write_to_vm and @reading for data directions,
> both of which mean the opposite of the usual block/bio convention of
> using READ and WRITE w.r.t. IO devices.  The only place where the
> inversion is necessary is when caling get_user_pages_fast() in
> bio_copy_user_iov() as the gup uses the VM convention of read/write
> w.r.t. VM.
> 
> This patch converts all bio functions to use READ/WRITE rw parameter
> and let the one place where inversion is necessary to rw == READ.
> 

Hi one more nit picking just if you are at it. If you want
I can do the work and send it to you so you can squash it into this patch.
See bellow

> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  block/blk-map.c     |   10 +++++-----
>  fs/bio.c            |   50 +++++++++++++++++++++++++-------------------------
>  include/linux/bio.h |   18 +++++++++---------
>  3 files changed, 39 insertions(+), 39 deletions(-)
> 
> diff --git a/block/blk-map.c b/block/blk-map.c
> index b0b65ef..29aa60d 100644
> --- a/block/blk-map.c
> +++ b/block/blk-map.c
> @@ -68,15 +68,15 @@ int blk_rq_map_user_iov(struct request_queue *q, struct request *rq,
>  			int iov_count, unsigned int len, gfp_t gfp_mask)
>  {
>  	struct bio *bio = ERR_PTR(-EINVAL);
> -	int read = rq_data_dir(rq) == READ;
> +	int rw = rq_data_dir(rq);
>  
>  	if (!iov || iov_count <= 0)
>  		return -EINVAL;
>  
>  	if (!map_data)
> -		bio = bio_map_user_iov(q, NULL, iov, iov_count, read, gfp_mask);
> +		bio = bio_map_user_iov(q, NULL, iov, iov_count, rw, gfp_mask);
>  	if (bio == ERR_PTR(-EINVAL))
> -		bio = bio_copy_user_iov(q, map_data, iov, iov_count, read,
> +		bio = bio_copy_user_iov(q, map_data, iov, iov_count, rw,
>  					gfp_mask);
>  	if (IS_ERR(bio))
>  		return PTR_ERR(bio);
> @@ -177,7 +177,7 @@ EXPORT_SYMBOL(blk_rq_unmap_user);
>  int blk_rq_map_kern(struct request_queue *q, struct request *rq, void *kbuf,
>  		    unsigned int len, gfp_t gfp_mask)
>  {
> -	int reading = rq_data_dir(rq) == READ;
> +	int rw = rq_data_dir(rq);
>  	int do_copy = 0;
>  	struct bio *bio;
>  
> @@ -188,7 +188,7 @@ int blk_rq_map_kern(struct request_queue *q, struct request *rq, void *kbuf,
>  
>  	do_copy = !blk_rq_aligned(q, kbuf, len) || object_is_on_stack(kbuf);
>  	if (do_copy)
> -		bio = bio_copy_kern(q, kbuf, len, gfp_mask, reading);
> +		bio = bio_copy_kern(q, kbuf, len, gfp_mask, rw);
>  	else
>  		bio = bio_map_kern(q, kbuf, len, gfp_mask);
>  
> diff --git a/fs/bio.c b/fs/bio.c
> index 80f61ed..70e5153 100644
> --- a/fs/bio.c
> +++ b/fs/bio.c
> @@ -780,7 +780,7 @@ int bio_uncopy_user(struct bio *bio)
>   *	@map_data: pointer to the rq_map_data holding pages (if necessary)
>   *	@iov:	the iovec.
>   *	@iov_count: number of elements in the iovec
> - *	@write_to_vm: bool indicating writing to pages or not
> + *	@rw: READ or WRITE
>   *	@gfp_mask: memory allocation flags
>   *
>   *	Prepares and returns a bio for indirect user io, bouncing data
> @@ -789,8 +789,8 @@ int bio_uncopy_user(struct bio *bio)
>   */
>  struct bio *bio_copy_user_iov(struct request_queue *q,
>  			      struct rq_map_data *map_data,
> -			      struct sg_iovec *iov, int iov_count,
> -			      int write_to_vm, gfp_t gfp_mask)
> +			      struct sg_iovec *iov, int iov_count, int rw,
> +			      gfp_t gfp_mask)
>  {
>  	struct bio_map_data *bmd;
>  	struct bio_vec *bvec;
> @@ -823,7 +823,8 @@ struct bio *bio_copy_user_iov(struct request_queue *q,
>  	if (!bio)
>  		goto out_bmd;
>  
> -	bio->bi_rw |= (!write_to_vm << BIO_RW);
> +	if (rw == WRITE)
> +		bio->bi_rw |= 1 << BIO_RW;

can we pleas have an inline that does that? Like bio_set_dir()?
and change all users. You will be surprised how many there are.

It gives me an hart attack every time I have to write yet another
one.

>  
>  	ret = 0;
>  
> @@ -872,7 +873,7 @@ struct bio *bio_copy_user_iov(struct request_queue *q,
>  	 */
>  	if (unlikely(map_data && map_data->null_mapped))
>  		bio->bi_flags |= (1 << BIO_NULL_MAPPED);
> -	else if (!write_to_vm) {
> +	else if (rw == WRITE) {
>  		ret = __bio_copy_iov(bio, bio->bi_io_vec, iov, iov_count, 0, 0);
>  		if (ret)
>  			goto cleanup;
> @@ -897,7 +898,7 @@ out_bmd:
>   *	@map_data: pointer to the rq_map_data holding pages (if necessary)
>   *	@uaddr: start of user address
>   *	@len: length in bytes
> - *	@write_to_vm: bool indicating writing to pages or not
> + *	@rw: READ or WRITE
>   *	@gfp_mask: memory allocation flags
>   *
>   *	Prepares and returns a bio for indirect user io, bouncing data
> @@ -905,21 +906,21 @@ out_bmd:
>   *	call bio_uncopy_user() on io completion.
>   */
>  struct bio *bio_copy_user(struct request_queue *q, struct rq_map_data *map_data,
> -			  unsigned long uaddr, unsigned int len,
> -			  int write_to_vm, gfp_t gfp_mask)
> +			  unsigned long uaddr, unsigned int len, int rw,
> +			  gfp_t gfp_mask)
>  {
>  	struct sg_iovec iov;
>  
>  	iov.iov_base = (void __user *)uaddr;
>  	iov.iov_len = len;
>  
> -	return bio_copy_user_iov(q, map_data, &iov, 1, write_to_vm, gfp_mask);
> +	return bio_copy_user_iov(q, map_data, &iov, 1, rw, gfp_mask);
>  }
>  
>  static struct bio *__bio_map_user_iov(struct request_queue *q,
>  				      struct block_device *bdev,
>  				      struct sg_iovec *iov, int iov_count,
> -				      int write_to_vm, gfp_t gfp_mask)
> +				      int rw, gfp_t gfp_mask)
>  {
>  	int i, j;
>  	size_t tot_len = 0;
> @@ -967,8 +968,8 @@ static struct bio *__bio_map_user_iov(struct request_queue *q,
>  		const int local_nr_pages = end - start;
>  		const int page_limit = cur_page + local_nr_pages;
>  		
> -		ret = get_user_pages_fast(uaddr, local_nr_pages,
> -				write_to_vm, &pages[cur_page]);
> +		ret = get_user_pages_fast(uaddr, local_nr_pages, rw == READ,
> +					  &pages[cur_page]);
>  		if (ret < local_nr_pages) {
>  			ret = -EFAULT;
>  			goto out_unmap;
> @@ -1008,7 +1009,7 @@ static struct bio *__bio_map_user_iov(struct request_queue *q,
>  	/*
>  	 * set data direction, and check if mapped pages need bouncing
>  	 */
> -	if (!write_to_vm)
> +	if (rw == WRITE)
>  		bio->bi_rw |= (1 << BIO_RW);

Here

>  
>  	bio->bi_bdev = bdev;
> @@ -1033,14 +1034,14 @@ static struct bio *__bio_map_user_iov(struct request_queue *q,
>   *	@bdev: destination block device
>   *	@uaddr: start of user address
>   *	@len: length in bytes
> - *	@write_to_vm: bool indicating writing to pages or not
> + *	@rw: READ or WRITE
>   *	@gfp_mask: memory allocation flags
>   *
>   *	Map the user space address into a bio suitable for io to a block
>   *	device. Returns an error pointer in case of error.
>   */
>  struct bio *bio_map_user(struct request_queue *q, struct block_device *bdev,
> -			 unsigned long uaddr, unsigned int len, int write_to_vm,
> +			 unsigned long uaddr, unsigned int len, int rw,
>  			 gfp_t gfp_mask)
>  {
>  	struct sg_iovec iov;
> @@ -1048,7 +1049,7 @@ struct bio *bio_map_user(struct request_queue *q, struct block_device *bdev,
>  	iov.iov_base = (void __user *)uaddr;
>  	iov.iov_len = len;
>  
> -	return bio_map_user_iov(q, bdev, &iov, 1, write_to_vm, gfp_mask);
> +	return bio_map_user_iov(q, bdev, &iov, 1, rw, gfp_mask);
>  }
>  
>  /**
> @@ -1057,20 +1058,19 @@ struct bio *bio_map_user(struct request_queue *q, struct block_device *bdev,
>   *	@bdev: destination block device
>   *	@iov:	the iovec.
>   *	@iov_count: number of elements in the iovec
> - *	@write_to_vm: bool indicating writing to pages or not
> + *	@rw: READ or WRITE
>   *	@gfp_mask: memory allocation flags
>   *
>   *	Map the user space address into a bio suitable for io to a block
>   *	device. Returns an error pointer in case of error.
>   */
>  struct bio *bio_map_user_iov(struct request_queue *q, struct block_device *bdev,
> -			     struct sg_iovec *iov, int iov_count,
> -			     int write_to_vm, gfp_t gfp_mask)
> +			     struct sg_iovec *iov, int iov_count, int rw,
> +			     gfp_t gfp_mask)
>  {
>  	struct bio *bio;
>  
> -	bio = __bio_map_user_iov(q, bdev, iov, iov_count, write_to_vm,
> -				 gfp_mask);
> +	bio = __bio_map_user_iov(q, bdev, iov, iov_count, rw, gfp_mask);
>  	if (IS_ERR(bio))
>  		return bio;
>  
> @@ -1219,23 +1219,23 @@ static void bio_copy_kern_endio(struct bio *bio, int err)
>   *	@data: pointer to buffer to copy
>   *	@len: length in bytes
>   *	@gfp_mask: allocation flags for bio and page allocation
> - *	@reading: data direction is READ
> + *	@rw: READ or WRITE
>   *
>   *	copy the kernel address into a bio suitable for io to a block
>   *	device. Returns an error pointer in case of error.
>   */
>  struct bio *bio_copy_kern(struct request_queue *q, void *data, unsigned int len,
> -			  gfp_t gfp_mask, int reading)
> +			  gfp_t gfp_mask, int rw)
>  {
>  	struct bio *bio;
>  	struct bio_vec *bvec;
>  	int i;
>  
> -	bio = bio_copy_user(q, NULL, (unsigned long)data, len, 1, gfp_mask);
> +	bio = bio_copy_user(q, NULL, (unsigned long)data, len, READ, gfp_mask);
>  	if (IS_ERR(bio))
>  		return bio;
>  
> -	if (!reading) {
> +	if (rw == WRITE) {
>  		void *p = data;
>  
>  		bio_for_each_segment(bvec, bio, i) {
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index 4bf7442..45f56d2 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -387,24 +387,24 @@ int bio_get_nr_vecs(struct block_device *bdev);
>  sector_t bio_sector_offset(struct bio *bio, unsigned short index,
>  			   unsigned int offset);
>  struct bio *bio_map_user(struct request_queue *q, struct block_device *bdev,
> -			 unsigned long uaddr, unsigned int len,
> -			 int write_to_vm, gfp_t gfp_mask);
> +			 unsigned long uaddr, unsigned int len, int rw,
> +			 gfp_t gfp_mask);
>  struct bio *bio_map_user_iov(struct request_queue *q, struct block_device *bdev,
> -			     struct sg_iovec *iov, int iov_count,
> -			     int write_to_vm, gfp_t gfp_mask);
> +			     struct sg_iovec *iov, int iov_count, int rw,
> +			     gfp_t gfp_mask);
>  void bio_unmap_user(struct bio *bio);
>  struct bio *bio_copy_user(struct request_queue *q, struct rq_map_data *map_data,
> -			  unsigned long uaddr, unsigned int len,
> -			  int write_to_vm, gfp_t gfp_mask);
> +			  unsigned long uaddr, unsigned int len, int rw,
> +			  gfp_t gfp_mask);
>  struct bio *bio_copy_user_iov(struct request_queue *q,
>  			      struct rq_map_data *map_data,
> -			      struct sg_iovec *iov, int iov_count,
> -			      int write_to_vm, gfp_t gfp_mask);
> +			      struct sg_iovec *iov, int iov_count, int rw,
> +			      gfp_t gfp_mask);
>  int bio_uncopy_user(struct bio *bio);
>  struct bio *bio_map_kern(struct request_queue *q, void *data, unsigned int len,
>  			 gfp_t gfp_mask);
>  struct bio *bio_copy_kern(struct request_queue *q, void *data, unsigned int len,
> -			  gfp_t gfp_mask, int reading);
> +			  gfp_t gfp_mask, int rw);
>  void bio_set_pages_dirty(struct bio *bio);
>  void bio_check_pages_dirty(struct bio *bio);
>  void zero_fill_bio(struct bio *bio);

Boaz
