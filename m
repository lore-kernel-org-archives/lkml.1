Return-Path: <linux-kernel-owner+w=401wt.eu-S932335AbZDAOxH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932335AbZDAOxH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 10:53:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763455AbZDAOwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 10:52:54 -0400
Received: from gw-ca.panasas.com ([209.116.51.66]:2027 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761580AbZDAOwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 10:52:53 -0400
Message-ID: <49D37F43.9000300@panasas.com>
Date: Wed, 01 Apr 2009 17:50:43 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: axboe@kernel.dk, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH 06/17] blk-map/bio: use struct iovec instead of sg_iovec
References: <1238593472-30360-1-git-send-email-tj@kernel.org> <1238593472-30360-7-git-send-email-tj@kernel.org>
In-Reply-To: <1238593472-30360-7-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Apr 2009 14:52:49.0576 (UTC) FILETIME=[86C95A80:01C9B2D9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2009 04:44 PM, Tejun Heo wrote:
> Impact: cleanup
> 
> blk-map and bio use sg_iovec for addr-len segments although there
> isn't anything sg-specific about the API.  This is mostly due to
> historical reasons.  sg_iovec is by definition identical to iovec.
> Use iovec instead.  This removes bogus dependency on scsi sg and will
> allow use of iovec helpers.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  block/blk-map.c        |    5 ++---
>  block/scsi_ioctl.c     |    8 +++-----
>  fs/bio.c               |   23 +++++++++++------------
>  include/linux/bio.h    |    6 +++---
>  include/linux/blkdev.h |    8 ++++----
>  5 files changed, 23 insertions(+), 27 deletions(-)
> 

OK, The actual one user in sg.c passes a void*, so no casts are
needed. (I couldn't find where are the type-casts of old users)

Should we make this a part of a bigger cleanup that removes
sg_iovec, from Kernel altogether and only makes a #define for
user-mode?

BTW: 
    user-mode scsi/sg.h does not come from the Kernels exported
    headers. It comes with the gcc distribution.
    If we remove it alltogether it will not affect anybody.

If you want I can help with this little chore?

Boaz

> diff --git a/block/blk-map.c b/block/blk-map.c
> index 29aa60d..4f0221a 100644
> --- a/block/blk-map.c
> +++ b/block/blk-map.c
> @@ -5,7 +5,6 @@
>  #include <linux/module.h>
>  #include <linux/bio.h>
>  #include <linux/blkdev.h>
> -#include <scsi/sg.h>		/* for struct sg_iovec */
>  
>  #include "blk.h"
>  
> @@ -64,7 +63,7 @@ static int __blk_rq_unmap_user(struct bio *bio)
>   *    unmapping.
>   */
>  int blk_rq_map_user_iov(struct request_queue *q, struct request *rq,
> -			struct rq_map_data *map_data, struct sg_iovec *iov,
> +			struct rq_map_data *map_data, struct iovec *iov,
>  			int iov_count, unsigned int len, gfp_t gfp_mask)
>  {
>  	struct bio *bio = ERR_PTR(-EINVAL);
> @@ -130,7 +129,7 @@ int blk_rq_map_user(struct request_queue *q, struct request *rq,
>  		    struct rq_map_data *map_data, void __user *ubuf,
>  		    unsigned long len, gfp_t gfp_mask)
>  {
> -	struct sg_iovec iov;
> +	struct iovec iov;
>  
>  	iov.iov_base = ubuf;
>  	iov.iov_len = len;
> diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
> index c8e8868..73cfd91 100644
> --- a/block/scsi_ioctl.c
> +++ b/block/scsi_ioctl.c
> @@ -289,7 +289,7 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
>  	if (hdr->iovec_count) {
>  		const int size = sizeof(struct sg_iovec) * hdr->iovec_count;
>  		size_t iov_data_len;
> -		struct sg_iovec *iov;
> +		struct iovec *iov;
>  
>  		iov = kmalloc(size, GFP_KERNEL);
>  		if (!iov) {
> @@ -304,11 +304,9 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
>  		}
>  
>  		/* SG_IO howto says that the shorter of the two wins */
> -		iov_data_len = iov_length((struct iovec *)iov,
> -					  hdr->iovec_count);
> +		iov_data_len = iov_length(iov, hdr->iovec_count);
>  		if (hdr->dxfer_len < iov_data_len) {
> -			hdr->iovec_count = iov_shorten((struct iovec *)iov,
> -						       hdr->iovec_count,
> +			hdr->iovec_count = iov_shorten(iov, hdr->iovec_count,
>  						       hdr->dxfer_len);
>  			iov_data_len = hdr->dxfer_len;
>  		}
> diff --git a/fs/bio.c b/fs/bio.c
> index 70e5153..9d13f21 100644
> --- a/fs/bio.c
> +++ b/fs/bio.c
> @@ -28,7 +28,6 @@
>  #include <linux/blktrace_api.h>
>  #include <linux/pfn.h>
>  #include <trace/block.h>
> -#include <scsi/sg.h>		/* for struct sg_iovec */
>  
>  DEFINE_TRACE(block_split);
>  
> @@ -656,17 +655,17 @@ int bio_add_page(struct bio *bio, struct page *page, unsigned int len,
>  
>  struct bio_map_data {
>  	struct bio_vec *iovecs;
> -	struct sg_iovec *sgvecs;
> +	struct iovec *sgvecs;
>  	int nr_sgvecs;
>  	int is_our_pages;
>  };
>  
>  static void bio_set_map_data(struct bio_map_data *bmd, struct bio *bio,
> -			     struct sg_iovec *iov, int iov_count,
> +			     struct iovec *iov, int iov_count,
>  			     int is_our_pages)
>  {
>  	memcpy(bmd->iovecs, bio->bi_io_vec, sizeof(struct bio_vec) * bio->bi_vcnt);
> -	memcpy(bmd->sgvecs, iov, sizeof(struct sg_iovec) * iov_count);
> +	memcpy(bmd->sgvecs, iov, sizeof(struct iovec) * iov_count);
>  	bmd->nr_sgvecs = iov_count;
>  	bmd->is_our_pages = is_our_pages;
>  	bio->bi_private = bmd;
> @@ -693,7 +692,7 @@ static struct bio_map_data *bio_alloc_map_data(int nr_segs, int iov_count,
>  		return NULL;
>  	}
>  
> -	bmd->sgvecs = kmalloc(sizeof(struct sg_iovec) * iov_count, gfp_mask);
> +	bmd->sgvecs = kmalloc(sizeof(struct iovec) * iov_count, gfp_mask);
>  	if (bmd->sgvecs)
>  		return bmd;
>  
> @@ -703,7 +702,7 @@ static struct bio_map_data *bio_alloc_map_data(int nr_segs, int iov_count,
>  }
>  
>  static int __bio_copy_iov(struct bio *bio, struct bio_vec *iovecs,
> -			  struct sg_iovec *iov, int iov_count, int uncopy,
> +			  struct iovec *iov, int iov_count, int uncopy,
>  			  int do_free_page)
>  {
>  	int ret = 0, i;
> @@ -789,7 +788,7 @@ int bio_uncopy_user(struct bio *bio)
>   */
>  struct bio *bio_copy_user_iov(struct request_queue *q,
>  			      struct rq_map_data *map_data,
> -			      struct sg_iovec *iov, int iov_count, int rw,
> +			      struct iovec *iov, int iov_count, int rw,
>  			      gfp_t gfp_mask)
>  {
>  	struct bio_map_data *bmd;
> @@ -909,7 +908,7 @@ struct bio *bio_copy_user(struct request_queue *q, struct rq_map_data *map_data,
>  			  unsigned long uaddr, unsigned int len, int rw,
>  			  gfp_t gfp_mask)
>  {
> -	struct sg_iovec iov;
> +	struct iovec iov;
>  
>  	iov.iov_base = (void __user *)uaddr;
>  	iov.iov_len = len;
> @@ -919,7 +918,7 @@ struct bio *bio_copy_user(struct request_queue *q, struct rq_map_data *map_data,
>  
>  static struct bio *__bio_map_user_iov(struct request_queue *q,
>  				      struct block_device *bdev,
> -				      struct sg_iovec *iov, int iov_count,
> +				      struct iovec *iov, int iov_count,
>  				      int rw, gfp_t gfp_mask)
>  {
>  	int i, j;
> @@ -1044,7 +1043,7 @@ struct bio *bio_map_user(struct request_queue *q, struct block_device *bdev,
>  			 unsigned long uaddr, unsigned int len, int rw,
>  			 gfp_t gfp_mask)
>  {
> -	struct sg_iovec iov;
> +	struct iovec iov;
>  
>  	iov.iov_base = (void __user *)uaddr;
>  	iov.iov_len = len;
> @@ -1053,7 +1052,7 @@ struct bio *bio_map_user(struct request_queue *q, struct block_device *bdev,
>  }
>  
>  /**
> - *	bio_map_user_iov - map user sg_iovec table into bio
> + *	bio_map_user_iov - map user iovec table into bio
>   *	@q: the struct request_queue for the bio
>   *	@bdev: destination block device
>   *	@iov:	the iovec.
> @@ -1065,7 +1064,7 @@ struct bio *bio_map_user(struct request_queue *q, struct block_device *bdev,
>   *	device. Returns an error pointer in case of error.
>   */
>  struct bio *bio_map_user_iov(struct request_queue *q, struct block_device *bdev,
> -			     struct sg_iovec *iov, int iov_count, int rw,
> +			     struct iovec *iov, int iov_count, int rw,
>  			     gfp_t gfp_mask)
>  {
>  	struct bio *bio;
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index 45f56d2..8215ded 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -23,6 +23,7 @@
>  #include <linux/highmem.h>
>  #include <linux/mempool.h>
>  #include <linux/ioprio.h>
> +#include <linux/uio.h>
>  
>  #ifdef CONFIG_BLOCK
>  
> @@ -356,7 +357,6 @@ struct bio_pair {
>  };
>  
>  struct request_queue;
> -struct sg_iovec;
>  struct rq_map_data;
>  
>  struct bio_pair *bio_split(struct bio *bi, int first_sectors);
> @@ -390,7 +390,7 @@ struct bio *bio_map_user(struct request_queue *q, struct block_device *bdev,
>  			 unsigned long uaddr, unsigned int len, int rw,
>  			 gfp_t gfp_mask);
>  struct bio *bio_map_user_iov(struct request_queue *q, struct block_device *bdev,
> -			     struct sg_iovec *iov, int iov_count, int rw,
> +			     struct iovec *iov, int iov_count, int rw,
>  			     gfp_t gfp_mask);
>  void bio_unmap_user(struct bio *bio);
>  struct bio *bio_copy_user(struct request_queue *q, struct rq_map_data *map_data,
> @@ -398,7 +398,7 @@ struct bio *bio_copy_user(struct request_queue *q, struct rq_map_data *map_data,
>  			  gfp_t gfp_mask);
>  struct bio *bio_copy_user_iov(struct request_queue *q,
>  			      struct rq_map_data *map_data,
> -			      struct sg_iovec *iov, int iov_count, int rw,
> +			      struct iovec *iov, int iov_count, int rw,
>  			      gfp_t gfp_mask);
>  int bio_uncopy_user(struct bio *bio);
>  struct bio *bio_map_kern(struct request_queue *q, void *data, unsigned int len,
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 465d6ba..d7bb20c 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -19,6 +19,7 @@
>  #include <linux/gfp.h>
>  #include <linux/bsg.h>
>  #include <linux/smp.h>
> +#include <linux/uio.h>
>  
>  #include <asm/scatterlist.h>
>  
> @@ -29,7 +30,6 @@ struct elevator_queue;
>  struct request_pm_state;
>  struct blk_trace;
>  struct request;
> -struct sg_io_hdr;
>  
>  #define BLKDEV_MIN_RQ	4
>  #define BLKDEV_MAX_RQ	128	/* Default maximum */
> @@ -781,9 +781,9 @@ extern int blk_rq_map_user(struct request_queue *, struct request *,
>  			   gfp_t);
>  extern int blk_rq_unmap_user(struct bio *);
>  extern int blk_rq_map_kern(struct request_queue *, struct request *, void *, unsigned int, gfp_t);
> -extern int blk_rq_map_user_iov(struct request_queue *, struct request *,
> -			       struct rq_map_data *, struct sg_iovec *, int,
> -			       unsigned int, gfp_t);
> +extern int blk_rq_map_user_iov(struct request_queue *q, struct request *rq,
> +			       struct rq_map_data *map_data, struct iovec *iov,
> +			       int iov_count, unsigned int len, gfp_t gfp_mask);
>  extern int blk_execute_rq(struct request_queue *, struct gendisk *,
>  			  struct request *, int);
>  extern void blk_execute_rq_nowait(struct request_queue *, struct gendisk *,

