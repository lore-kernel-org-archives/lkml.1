Return-Path: <linux-kernel-owner+w=401wt.eu-S1761663AbXEJNA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761663AbXEJNA3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 09:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755771AbXEJNAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 09:00:22 -0400
Received: from ik-out-1112.google.com ([66.249.90.176]:11516 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755709AbXEJNAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 09:00:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sqTpWyHL8EB8yWhPRnYBr7cdBQj7A4eV7JH2HvZIqJobFTMVbmWfcI59DM+c53wrkarVsAfTOuM2TWGBtxmBbputVRSSYyIeab7f/JjD3SoXz53P5dCakKLz4n96IC175U/FDxpcj9c+pLiPMixWqWv35+qT73SNqLrz65/Yo3k=
Message-ID: <a781481a0705100600n3258564r96f44cacce00c372@mail.gmail.com>
Date: Thu, 10 May 2007 18:30:19 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Jens Axboe" <jens.axboe@oracle.com>
Subject: Re: [PATCH 7/12] i386 sg: add support for chaining scatterlists
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <11787972373410-git-send-email-jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11787972373654-git-send-email-jens.axboe@oracle.com>
	 <11787972373410-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

On 5/10/07, Jens Axboe <jens.axboe@oracle.com> wrote:
> The core of the patch - allow the last sg element in a scatterlist
> table to point to the start of a new table. We overload the LSB of
> the page pointer to indicate whether this is a valid sg entry, or
> merely a link to the next list.
>
> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> ---
>  include/asm-i386/scatterlist.h |    2 +
>  include/linux/scatterlist.h    |   52 ++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 52 insertions(+), 2 deletions(-)
>
> diff --git a/include/asm-i386/scatterlist.h b/include/asm-i386/scatterlist.h
> index d7e45a8..bd5164a 100644
> --- a/include/asm-i386/scatterlist.h
> +++ b/include/asm-i386/scatterlist.h
> @@ -10,6 +10,8 @@ struct scatterlist {
>      unsigned int       length;
>  };
>
> +#define ARCH_HAS_SG_CHAIN
> +
>  /* These macros should be used after a pci_map_sg call has been done
>   * to get bus addresses of each of the SG entries and their lengths.
>   * You should only work with the number of sg entries pci_map_sg
> diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
> index bed5ab4..fa2dc1c 100644
> --- a/include/linux/scatterlist.h
> +++ b/include/linux/scatterlist.h
> [...]
> +/*
> + * We could improve this by passing in the maximum size of an sglist, so
> + * we could jump directly to the last table. That would eliminate this
> + * (potentially) lengthy scan.
> + */
> +static inline struct scatterlist *sg_last(struct scatterlist *sgl,
> +                                         unsigned int nents)
> +{
> +#ifdef ARCH_HAS_SG_CHAIN
> +       struct scatterlist *ret = &sgl[nents - 1];
> +#else
> +       struct scatterlist *sg, *ret = NULL;
> +       int i;
> +
> +       for_each_sg(sgl, sg, nents, i)
> +               ret = sg;
> +
> +#endif
> +       return ret;
> +}
> +
> +/*
> + * Chain previous sglist to this one
> + */
> +static inline void sg_chain(struct scatterlist *prv, unsigned int prv_nents,
> +                           struct scatterlist *sgl)
> +{
> +#ifndef ARCH_HAS_SG_CHAIN
> +       BUG();
> +#endif
> +       prv[prv_nents - 1].page = (struct page *) ((unsigned long) sgl | 0x01);
> +}
> +
>  #endif /* _LINUX_SCATTERLIST_H */

(Style triviality)

In include/linux/scatterlist.h, why not simply:

#ifdef ARCH_HAS_SG_CHAIN

> +/*
> + * We could improve this by passing in the maximum size of an sglist, so
> + * we could jump directly to the last table. That would eliminate this
> + * (potentially) lengthy scan.
> + */
> +static inline struct scatterlist *sg_last(struct scatterlist *sgl,
> +                                         unsigned int nents)
> +{
> +       struct scatterlist *ret = &sgl[nents - 1];
> +       return ret;
> +}
> +
> +/*
> + * Chain previous sglist to this one
> + */
> +static inline void sg_chain(struct scatterlist *prv, unsigned int prv_nents,
> +                           struct scatterlist *sgl)
> +{
> +       prv[prv_nents - 1].page = (struct page *) ((unsigned long) sgl | 0x01);
> +}

#else

> +/*
> + * We could improve this by passing in the maximum size of an sglist, so
> + * we could jump directly to the last table. That would eliminate this
> + * (potentially) lengthy scan.
> + */
> +static inline struct scatterlist *sg_last(struct scatterlist *sgl,
> +                                         unsigned int nents)
> +{
> +       struct scatterlist *sg, *ret = NULL;
> +       int i;
> +
> +       for_each_sg(sgl, sg, nents, i)
> +               ret = sg;
> +
> +       return ret;
> +}
> +
> +/*
> + * Chain previous sglist to this one
> + */
> +static inline void sg_chain(struct scatterlist *prv, unsigned int prv_nents,
> +                           struct scatterlist *sgl)
> +{
> +       BUG();
> +}

#endif /* ARCH_HAS_SG_CHAIN */

Similar to most of the other headers I've seen, and avoids multiple
usage if #ifdef / #ifndef.
