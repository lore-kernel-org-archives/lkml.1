Return-Path: <linux-kernel-owner+w=401wt.eu-S1760031AbXEJKoK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760031AbXEJKoK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 06:44:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754992AbXEJKn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 06:43:58 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43682 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754343AbXEJKn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 06:43:57 -0400
Date: Thu, 10 May 2007 03:43:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/13] i386 sg: add support for chaining scatterlists
Message-Id: <20070510034331.2d3e9410.akpm@linux-foundation.org>
In-Reply-To: <11787925162760-git-send-email-jens.axboe@oracle.com>
References: <11787925152319-git-send-email-jens.axboe@oracle.com>
	<11787925162760-git-send-email-jens.axboe@oracle.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007 12:21:49 +0200 Jens Axboe <jens.axboe@oracle.com> wrote:

> The core of the patch - allow the last sg element in a scatterlist
> table to point to the start of a new table. We overload the LSB of
> the page pointer to indicate whether this is a valid sg entry, or
> merely a link to the next list.
> 
> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> ---
>  include/asm-i386/scatterlist.h |    2 +
>  include/linux/scatterlist.h    |   52 +++++++++++++++++++++++++++++++++++++--
>  2 files changed, 51 insertions(+), 3 deletions(-)
> 
> diff --git a/include/asm-i386/scatterlist.h b/include/asm-i386/scatterlist.h
> index d7e45a8..bd5164a 100644
> --- a/include/asm-i386/scatterlist.h
> +++ b/include/asm-i386/scatterlist.h
> @@ -10,6 +10,8 @@ struct scatterlist {
>      unsigned int	length;
>  };
>  
> +#define ARCH_HAS_SG_CHAIN
> +
>  /* These macros should be used after a pci_map_sg call has been done
>   * to get bus addresses of each of the SG entries and their lengths.
>   * You should only work with the number of sg entries pci_map_sg
> diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
> index c5bffde..bad6b9e 100644
> --- a/include/linux/scatterlist.h
> +++ b/include/linux/scatterlist.h
> @@ -20,13 +20,59 @@ static inline void sg_init_one(struct scatterlist *sg, const void *buf,
>  	sg_set_buf(sg, buf, buflen);
>  }
>  
> ...
>
>  /*
>   * Loop over each sg element, following the pointer to a new list if necessary
>   */
>  #define for_each_sg(sglist, sg, nr, __i)	\
> -	for (__i = 0, sg = (sglist); __i < nr; __i++, sg = sg_next(sg))
> +	for (__i = 0, sg = (sglist); __i < (nr); __i++, sg = sg_next(sg))
> +
> +/*
> + * We could improve this by passing in the maximum size of an sglist, so
> + * we could jump directly to the last table. That would eliminate this
> + * (potentially) lengthy scan.
> + */
> +static inline struct scatterlist *sg_last(struct scatterlist *sgl,
> +					  unsigned int nents)
> +{
> +#ifdef ARCH_HAS_SG_CHAIN
> +	struct scatterlist *ret = &sgl[nents - 1];
> +#else
> +	struct scatterlist *sg, *ret = NULL;
> +	int i;
> +
> +	for_each_sg(sgl, sg, nents, i)
> +		ret = sg;
> +
> +#endif
> +	return ret;
> +}

Looks too large to be inlined.

> +/*
> + * Chain previous sglist to this one
> + */
> +static inline void sg_chain(struct scatterlist *prv, unsigned int prv_nents,
> +			    struct scatterlist *sgl)
> +{
> +#ifndef ARCH_HAS_SG_CHAIN
> +	BUG();
> +#endif

Can use BUILD_BUG_ON here.  Or just #error.

> +	prv[prv_nents - 1].page = (struct page *) ((unsigned long) sgl | 0x01);
> +}


