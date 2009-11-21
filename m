Return-Path: <linux-kernel-owner+w=401wt.eu-S1753964AbZKUAiI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964AbZKUAiI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 19:38:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753623AbZKUAiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 19:38:08 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57142 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753464AbZKUAiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 19:38:07 -0500
Date: Fri, 20 Nov 2009 16:37:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ilya Loginov <isloginov@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       Peter Horton <phorton@bitbox.co.uk>,
       "Ed L. Cashin" <ecashin@coraid.com>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] mtd: fix mtd_blkdevs problem with caches on some
 architectures (2.6.31)
Message-Id: <20091120163751.731781e8.akpm@linux-foundation.org>
In-Reply-To: <20091118170810.2bb9cd54.isloginov@gmail.com>
References: <20091118170810.2bb9cd54.isloginov@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Nov 2009 17:08:10 +0300
Ilya Loginov <isloginov@gmail.com> wrote:

> 	Mtdblock driver doesn't call flush_dcache_page for pages in request.
> 	This may cause problem on architectures where icache doesn't fill from
> dcache or with dcache aliases.
> 	This patch resolves this issue.
> 
> Signed-off-by: Ilya Loginov <isloginov@gmail.com>
> ---
> mtd_blkdevs.c |    7 +++++++
> 1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
> index 7baba40..59d5d25 100644
> --- a/drivers/mtd/mtd_blkdevs.c
> +++ b/drivers/mtd/mtd_blkdevs.c
> @@ -46,6 +46,8 @@ static int do_blktrans_request(struct mtd_blktrans_ops *tr,
>  {
>  	unsigned long block, nsect;
>  	char *buf;
> +	struct req_iterator iter;
> +	struct bio_vec *bvec;
>  
>  	block = blk_rq_pos(req) << 9 >> tr->blkshift;
>  	nsect = blk_rq_cur_bytes(req) >> tr->blkshift;
> @@ -68,12 +70,17 @@ static int do_blktrans_request(struct mtd_blktrans_ops *tr,
>  		for (; nsect > 0; nsect--, block++, buf += tr->blksize)
>  			if (tr->readsect(dev, block, buf))
>  				return -EIO;
> +		rq_for_each_segment(bvec, req, iter)
> +			flush_dcache_page(bvec->bv_page);
>  		return 0;
>  
>  	case WRITE:
>  		if (!tr->writesect)
>  			return -EIO;
>  
> +		rq_for_each_segment(bvec, req, iter)
> +			flush_dcache_page(bvec->bv_page);
> +		
>  		for (; nsect > 0; nsect--, block++, buf += tr->blksize)
>  			if (tr->writesect(dev, block, buf))
>  				return -EIO;

Please see the recent linux-kernel thread "prevent AoE causing cache
aliases".

Your patch fixes bascially the same problem in MTD as we have in AOE. 
And it introduces the same problem as well - pointless empty
cache-thrashing loops on architectures for which flush_dcache_page() is
a no-op.

What would be better here would be for block core to add a new
rq_flush_dcache_pages() and bio_flush_dcache_pages() which the drivers
can call.  Those functions would be a no-op on architectures which
don't need them.

Jens has made noises about implementing this, but he is working on his
suntan this week.

