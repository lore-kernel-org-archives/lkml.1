Return-Path: <linux-kernel-owner+w=401wt.eu-S1753450AbZKVSsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450AbZKVSsx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 13:48:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753256AbZKVSsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 13:48:52 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45403 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753234AbZKVSsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 13:48:52 -0500
Date: Sun, 22 Nov 2009 10:48:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ilya Loginov <isloginov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, David Woodhouse <dwmw2@infradead.org>,
       linux-kernel@vger.kernel.org, Peter Horton <phorton@bitbox.co.uk>,
       "Ed L. Cashin" <ecashin@coraid.com>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] mtd: fix mtd_blkdevs problem with caches on some
 architectures (2.6.31)
Message-Id: <20091122104816.b6920ede.akpm@linux-foundation.org>
In-Reply-To: <20091122165521.0b488e05.isloginov@gmail.com>
References: <20091118170810.2bb9cd54.isloginov@gmail.com>
	<20091120163751.731781e8.akpm@linux-foundation.org>
	<20091121170437.0839daef.isloginov@gmail.com>
	<20091121095429.1378828c.akpm@linux-foundation.org>
	<20091122021128.db47e202.isloginov@gmail.com>
	<20091121152633.8c79e341.akpm@linux-foundation.org>
	<20091122124631.908a32c4.isloginov@gmail.com>
	<20091122132915.GA3046@elte.hu>
	<20091122165521.0b488e05.isloginov@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Nov 2009 16:55:21 +0300 Ilya Loginov <isloginov@gmail.com> wrote:

> +#ifndef ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE
> +# error	"You should to define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE for your platform."
> +#endif
> +#if ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE
> +static inline void bio_flush_dcache_pages(struct bio *bi)
> +{
> +	int i;
> +	struct bio_vec* bvec;
> +
> +	bio_for_each_segment(bvec, bi, i)
> +		flush_dcache_page(bvec->bv_page);
> +}
> +#else
> +static inline void bio_flush_dcache_pages(struct bio *bi)
> +{
> +}
> +#endif
> +
>  extern struct bio *bio_copy_user(struct request_queue *, struct rq_map_data *,
>  				 unsigned long, unsigned int, int, gfp_t);
>  extern struct bio *bio_copy_user_iov(struct request_queue *,
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 69103e0..9b5214c 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -740,6 +740,24 @@ struct req_iterator {
>  #define rq_iter_last(rq, _iter)					\
>  		(_iter.bio->bi_next == NULL && _iter.i == _iter.bio->bi_vcnt-1)
>  
> +#ifndef ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE
> +# error	"You should to define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE for your platform."
> +#endif
> +#if ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE
> +static inline void rq_flush_dcache_pages(struct request *rq)
> +{
> +	struct req_iterator iter;
> +	struct bio_vec* bvec;
> +
> +	rq_for_each_segment(bvec, rq, iter)
> +		flush_dcache_page(bvec->bv_page);
> +}
> +#else
> +static inline void rq_flush_dcache_pages(struct request *rq)
> +{
> +}
> +#endif

I don't think the non-stub versions of these should be inlined.  They
will generate quite a lot of code and they're pretty heavyweight. 
Better to implement them in block/ somewhere, and EXPORT_SYMBOL().

