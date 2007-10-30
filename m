Return-Path: <linux-kernel-owner+w=401wt.eu-S1756354AbXJ3Jef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756354AbXJ3Jef (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 05:34:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758052AbXJ3Jdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 05:33:38 -0400
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:15336 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758032AbXJ3Jdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 05:33:35 -0400
Message-ID: <4726FA01.2030002@panasas.com>
Date: Tue, 30 Oct 2007 11:31:45 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
       netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] [CRYPTO] tcrypt: Move sg_init_table out of timing
 loops
References: <20071026145905.GA13850@gondor.apana.org.au> <E1IlQfM-0003cO-00@gondolin.me.apana.org.au> <20071029201627.GD7499@kernel.dk>
In-Reply-To: <20071029201627.GD7499@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Oct 2007 09:31:07.0019 (UTC) FILETIME=[992CA5B0:01C81AD7]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29 2007 at 22:16 +0200, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Fri, Oct 26 2007, Herbert Xu wrote:
>> [CRYPTO] tcrypt: Move sg_init_table out of timing loops
>>
>> This patch moves the sg_init_table out of the timing loops for hash
>> algorithms so that it doesn't impact on the speed test results.
> 
> Wouldn't it be better to just make sg_init_one() call sg_init_table?
> 
> diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
> index 4571231..ccc55a6 100644
> --- a/include/linux/scatterlist.h
> +++ b/include/linux/scatterlist.h
> @@ -202,28 +202,6 @@ static inline void __sg_mark_end(struct scatterlist *sg)
>  }
>  
>  /**
> - * sg_init_one - Initialize a single entry sg list
> - * @sg:		 SG entry
> - * @buf:	 Virtual address for IO
> - * @buflen:	 IO length
> - *
> - * Notes:
> - *   This should not be used on a single entry that is part of a larger
> - *   table. Use sg_init_table() for that.
> - *
> - **/
> -static inline void sg_init_one(struct scatterlist *sg, const void *buf,
> -			       unsigned int buflen)
> -{
> -	memset(sg, 0, sizeof(*sg));
> -#ifdef CONFIG_DEBUG_SG
> -	sg->sg_magic = SG_MAGIC;
> -#endif
> -	sg_mark_end(sg, 1);
> -	sg_set_buf(sg, buf, buflen);
> -}
> -
> -/**
>   * sg_init_table - Initialize SG table
>   * @sgl:	   The SG table
>   * @nents:	   Number of entries in table
> @@ -247,6 +225,24 @@ static inline void sg_init_table(struct scatterlist *sgl, unsigned int nents)
>  }
>  
>  /**
> + * sg_init_one - Initialize a single entry sg list
> + * @sg:		 SG entry
> + * @buf:	 Virtual address for IO
> + * @buflen:	 IO length
> + *
> + * Notes:
> + *   This should not be used on a single entry that is part of a larger
> + *   table. Use sg_init_table() for that.
> + *
> + **/
> +static inline void sg_init_one(struct scatterlist *sg, const void *buf,
> +			       unsigned int buflen)
> +{
> +	sg_init_table(sg, 1);
> +	sg_set_buf(sg, buf, buflen);
> +}
> +
> +/**
>   * sg_phys - Return physical address of an sg entry
>   * @sg:	     SG entry
>   *
> 
Yes please submit this patch. scsi-ml is full of sg_init_one, specially
on the error recovery path.

Thanks
Boaz
