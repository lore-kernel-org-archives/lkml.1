Return-Path: <linux-kernel-owner+w=401wt.eu-S1759350AbXITRi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759350AbXITRi6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 13:38:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758053AbXITRir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 13:38:47 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:20493 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756360AbXITRiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 13:38:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=2bwdqofJt6dL3kf9gpE8j1vkmgnRrTeQ7g7XV1xh025ojfCAdYo/vq+S+KrEfTVUhBgzzjHCZYsfe92m/Dsw9DKS0MCIYwK28w/SNeyv4S+H4Rku1nzLbFkKGapYTxJKtCNU4QloPDkthvV8RkTH476czTjLSfuaNg5ZXgJPiZE=  ;
X-YMail-OSG: uX_tNWYVM1mPyDjkPSoCHf2AsrOifqkPnhsltKEq5P1sFkBDHGxPmqVk58MuJBkJ.a3CdauYpA--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [13/17] Virtual compound page freeing in interrupt context
Date: Wed, 19 Sep 2007 06:36:59 +1000
User-Agent: KMail/1.9.5
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>
References: <20070919033605.785839297@sgi.com> <20070919033643.306595969@sgi.com>
In-Reply-To: <20070919033643.306595969@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709190636.59631.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 September 2007 13:36, Christoph Lameter wrote:
> If we are in an interrupt context then simply defer the free via a
> workqueue.
>
> In an interrupt context it is not possible to use vmalloc_addr() to
> determine the vmalloc address. So add a variant that does that too.
>
> Removing a virtual mappping *must* be done with interrupts enabled
> since tlb_xx functions are called that rely on interrupts for
> processor to processor communications.

These things will clash drastically with my lazy TLB flushing and scalability
work. Actually the lazy TLB flushing will provide a natural way to defer
unmapping at interrupt time, and the scalability work should make it
easier to vmap from interrupt context too, if you really need that.

>
> Signed-off-by: Christoph Lameter <clameter@sgi.com>
>
> ---
>  mm/page_alloc.c |   23 ++++++++++++++++++++++-
>  1 file changed, 22 insertions(+), 1 deletion(-)
>
> Index: linux-2.6/mm/page_alloc.c
> ===================================================================
> --- linux-2.6.orig/mm/page_alloc.c	2007-09-18 20:10:55.000000000 -0700
> +++ linux-2.6/mm/page_alloc.c	2007-09-18 20:11:40.000000000 -0700
> @@ -1297,7 +1297,12 @@ abort:
>  	return NULL;
>  }
>
> -static void vcompound_free(void *addr)
> +/*
> + * Virtual Compound freeing functions. This is complicated by the vmalloc
> + * layer not being able to free virtual allocations when interrupts are
> + * disabled. So we defer the frees via a workqueue if necessary.
> + */
> +static void __vcompound_free(void *addr)
>  {
>  	struct page **pages = vunmap(addr);
>  	int i;
> @@ -1320,6 +1325,22 @@ static void vcompound_free(void *addr)
>  	kfree(pages);
>  }
>
> +static void vcompound_free_work(struct work_struct *w)
> +{
> +	__vcompound_free((void *)w);
> +}
> +
> +static void vcompound_free(void *addr)
> +{
> +	if (in_interrupt()) {
> +		struct work_struct *w = addr;
> +
> +		INIT_WORK(w, vcompound_free_work);
> +		schedule_work(w);
> +	} else
> +		__vcompound_free(addr);
> +}
> +
>  /*
>   * This is the 'heart' of the zoned buddy allocator.
>   */
