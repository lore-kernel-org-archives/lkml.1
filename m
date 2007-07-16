Return-Path: <linux-kernel-owner+w=401wt.eu-S1761951AbXGPTEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761951AbXGPTEj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 15:04:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754990AbXGPTEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 15:04:10 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:57192 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757875AbXGPTEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 15:04:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=rj2bmIDWi1reKxJBPXx52Q9pCxnNsQfhKD6rbAtkI3iijNF6LIIMg3274jVOv6PAk4P76U4SDXINRTezWQnthcuOqDxYNw6hmuRMpn77LnMZ/MNOT4DUVFa6sH8U9V3PE8t7cv4A3tSNFXS526kyGz6HkIObWoRB4E3+GC0o9IA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 05/33] Add chained sg support to linux/scatterlist.h
Date: Mon, 16 Jul 2007 21:21:38 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
References: <11845792671245-git-send-email-jens.axboe@oracle.com> <11845792671254-git-send-email-jens.axboe@oracle.com>
In-Reply-To: <11845792671254-git-send-email-jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200707162121.38098.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 July 2007, Jens Axboe wrote:
> The core of the patch - allow the last sg element in a scatterlist
> table to point to the start of a new table. We overload the LSB of
> the page pointer to indicate whether this is a valid sg entry, or
> merely a link to the next list.
> 
> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> ---
>  include/linux/scatterlist.h |   79 +++++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 77 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
> index bed5ab4..10f6223 100644
> --- a/include/linux/scatterlist.h
> +++ b/include/linux/scatterlist.h
> @@ -20,8 +20,36 @@ static inline void sg_init_one(struct scatterlist *sg, const void *buf,
>  	sg_set_buf(sg, buf, buflen);
>  }
>  
> -#define sg_next(sg)		((sg) + 1)
> -#define sg_last(sg, nents)	(&(sg[(nents) - 1]))
> +/*
> + * We overload the LSB of the page pointer to indicate whether it's
> + * a valid sg entry, or whether it points to the start of a new scatterlist.
> + * Those low bits are there for everyone! (thanks mason :-)
> + */
> +#define sg_is_chain(sg)		((unsigned long) (sg)->page & 0x01)
> +#define sg_chain_ptr(sg)	\
> +	((struct scatterlist *) ((unsigned long) (sg)->page & ~0x01))
> +
> +/**
> + * sg_next - return the next scatterlist entry in a list
> + * @sg:		The current sg entry
> + *
> + * Usually the next entry will be @sg@ + 1, but if this sg element is part
> + * of a chained scatterlist, it could jump to the start of a new
> + * scatterlist array.
> + *
> + * Note that the caller must ensure that there are further entries after
> + * the current entry, this function will NOT return NULL for an end-of-list.
> + *
> + */
> +static inline struct scatterlist *sg_next(struct scatterlist *sg)
> +{
> +	sg++;
> +
> +	if (unlikely(sg_is_chain(sg)))
> +		sg = sg_chain_ptr(sg);
> +
> +	return sg;
> +}
>  
>  /*
>   * Loop over each sg element, following the pointer to a new list if necessary
> @@ -29,4 +57,51 @@ static inline void sg_init_one(struct scatterlist *sg, const void *buf,
>  #define for_each_sg(sglist, sg, nr, __i)	\
>  	for (__i = 0, sg = (sglist); __i < (nr); __i++, sg = sg_next(sg))
>  
> +/**
> + * sg_last - return the last scatterlist entry in a list
> + * @sgl:	First entry in the scatterlist
> + * @nents:	Number of entries in the scatterlist
> + *
> + * Should only be used casually, it (currently) scan the entire list
> + * to get the last entry.
> + *
> + * Note that the @sgl@ pointer passed in need not be the first one,
> + * the important bit is that @nents@ denotes the number of entries that
> + * exist from @sgl@.
> + *
> + */
> +static inline struct scatterlist *sg_last(struct scatterlist *sgl,
> +					  unsigned int nents)
> +{
> +#ifdef ARCH_HAS_SG_CHAIN

Shouldn't this be #ifndef?

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
> +
> +/**
> + * sg_chain - Chain two sglists together
> + * @prv:	First scatterlist
> + * @prv_nents:	Number of entries in prv
> + * @sgl:	Second scatterlist
> + *
> + * Links @prv@ and @sgl@ together, to form a longer scatterlist.
> + *
> + */
> +static inline void sg_chain(struct scatterlist *prv, unsigned int prv_nents,
> +			    struct scatterlist *sgl)
> +{
> +#ifndef ARCH_HAS_SG_CHAIN
> +	BUG();
> +#endif
> +	prv[prv_nents - 1].page = (struct page *) ((unsigned long) sgl | 0x01);
> +}
> +
>  #endif /* _LINUX_SCATTERLIST_H */
