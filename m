Return-Path: <linux-kernel-owner+w=401wt.eu-S1761684AbXGVIYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761684AbXGVIYz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 04:24:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755957AbXGVIYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 04:24:33 -0400
Received: from brick.kernel.dk ([80.160.20.94]:27067 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753971AbXGVIYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 04:24:30 -0400
Date: Sun, 22 Jul 2007 10:24:34 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>, riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Tim Pepper <lnxninja@us.ibm.com>,
       Chris Snook <csnook@redhat.com>
Subject: Re: [PATCH 3/3] readahead: scale max readahead size depending on
	memory size
Message-ID: <20070722082434.GR11657@kernel.dk>
References: <20070721210005.000228000@chello.nl> <20070721210052.497469000@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070721210052.497469000@chello.nl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 21 2007, Peter Zijlstra wrote:
> Scale the default max readahead size with the system memory size.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  block/ll_rw_blk.c  |    2 +-
>  include/linux/fs.h |    1 +
>  mm/readahead.c     |   32 ++++++++++++++++++++++++++++++++
>  3 files changed, 34 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/block/ll_rw_blk.c
> ===================================================================
> --- linux-2.6.orig/block/ll_rw_blk.c
> +++ linux-2.6/block/ll_rw_blk.c
> @@ -208,7 +208,7 @@ void blk_queue_make_request(request_queu
>  	blk_queue_max_phys_segments(q, MAX_PHYS_SEGMENTS);
>  	blk_queue_max_hw_segments(q, MAX_HW_SEGMENTS);
>  	q->make_request_fn = mfn;
> -	q->backing_dev_info.ra_pages = (VM_MAX_READAHEAD * 1024) / PAGE_CACHE_SIZE;
> +	bdi_ra_init(&q->backing_dev_info);
>  	q->backing_dev_info.state = 0;
>  	q->backing_dev_info.capabilities = BDI_CAP_MAP_COPY;
>  	blk_queue_max_sectors(q, SAFE_MAX_SECTORS);
> Index: linux-2.6/include/linux/fs.h
> ===================================================================
> --- linux-2.6.orig/include/linux/fs.h
> +++ linux-2.6/include/linux/fs.h
> @@ -1696,6 +1696,7 @@ extern long do_splice_direct(struct file
>  
>  extern void
>  file_ra_state_init(struct file_ra_state *ra, struct address_space *mapping);
> +extern void bdi_ra_init(struct backing_dev_info *bdi);
>  extern loff_t no_llseek(struct file *file, loff_t offset, int origin);
>  extern loff_t generic_file_llseek(struct file *file, loff_t offset, int origin);
>  extern loff_t remote_llseek(struct file *file, loff_t offset, int origin);
> Index: linux-2.6/mm/readahead.c
> ===================================================================
> --- linux-2.6.orig/mm/readahead.c
> +++ linux-2.6/mm/readahead.c
> @@ -42,6 +42,38 @@ file_ra_state_init(struct file_ra_state 
>  }
>  EXPORT_SYMBOL_GPL(file_ra_state_init);
>  
> +static unsigned long ra_pages;
> +
> +static __init int readahead_init(void)
> +{
> +	/*
> +	 * Scale the max readahead window with system memory
> +	 *
> +	 *   64M:   128K
> +	 *  128M:   180K
> +	 *  256M:   256K
> +	 *  512M:   360K
> +	 *    1G:   512K
> +	 *    2G:   724K
> +	 *    4G:  1024K
> +	 *    8G:  1448K
> +	 *   16G:  2048K
> +	 */
> +	ra_pages = int_sqrt(totalram_pages/16);
> +	if (ra_pages > (2 << (20 - PAGE_SHIFT)))
> +		ra_pages = 2 << (20 - PAGE_SHIFT);
> +
> +	return 0;
> +}

How did you come up with these numbers?

-- 
Jens Axboe

