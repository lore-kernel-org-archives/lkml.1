Return-Path: <linux-kernel-owner+w=401wt.eu-S1754452AbZGAJcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452AbZGAJcm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 05:32:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752868AbZGAJcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 05:32:33 -0400
Received: from brick.kernel.dk ([93.163.65.50]:60103 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752837AbZGAJcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 05:32:32 -0400
Date: Wed, 1 Jul 2009 11:32:35 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Shan Wei <shanwei@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 2/2] cfq-iosched: get rid of the need for __GFP_FAIL in
	cfq_find_alloc_queue()
Message-ID: <20090701093235.GX23611@kernel.dk>
References: <1246007120-24034-1-git-send-email-jens.axboe@oracle.com> <1246007120-24034-3-git-send-email-jens.axboe@oracle.com> <4A4B2C3D.7090800@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A4B2C3D.7090800@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 01 2009, Shan Wei wrote:
> Jens Axboe said:
> > Setup an emergency fallback cfqq that we allocate at IO scheduler init
> > time. If the slab allocation fails in cfq_find_alloc_queue(), we'll just
> > punt IO to that cfqq instead. This ensures that cfq_find_alloc_queue()
> > never fails without having to ensure free memory.
> > 
> > Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> > ---
> >  
> > @@ -1740,11 +1745,8 @@ cfq_get_queue(struct cfq_data *cfqd, int is_sync, struct io_context *ioc,
> >  		cfqq = *async_cfqq;
> >  	}
> >  
> > -	if (!cfqq) {
> > +	if (!cfqq)
> >  		cfqq = cfq_find_alloc_queue(cfqd, is_sync, ioc, gfp_mask);
> > -		if (!cfqq)
> > -			return NULL;
> > -	}
> 
> I jsut reviewed the code and found that the check of cfqq is also redundant
> after doing cfq_get_queue() in cfq_set_request.
> 
> The patch is based on Linus's main tree. 

It's not redundant in Linus' tree, cfq_get_queue() can return NULL for
!= __GFP_WAIT.


> 
> Signed-off-by: Shan Wei <shanwei@cn.fujitsu.com>
> ---
>  block/cfq-iosched.c |    4 ----
>  1 files changed, 0 insertions(+), 4 deletions(-)
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 833ec18..c373237 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -2307,10 +2307,6 @@ cfq_set_request(struct request_queue *q, struct request *rq, gfp_t gfp_mask)
>  	cfqq = cic_to_cfqq(cic, is_sync);
>  	if (!cfqq) {
>  		cfqq = cfq_get_queue(cfqd, is_sync, cic->ioc, gfp_mask);
> -
> -		if (!cfqq)
> -			goto queue_fail;
> -
>  		cic_set_cfqq(cic, cfqq, is_sync);
>  	}
>  

-- 
Jens Axboe

