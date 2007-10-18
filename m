Return-Path: <linux-kernel-owner+w=401wt.eu-S1762996AbXJRM6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762996AbXJRM6z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 08:58:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757679AbXJRM6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 08:58:47 -0400
Received: from sa12.bezeqint.net ([192.115.104.27]:35809 "EHLO
	sa12.bezeqint.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756402AbXJRM6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 08:58:46 -0400
Message-ID: <4717587E.6090301@panasas.com>
Date: Thu, 18 Oct 2007 14:58:38 +0200
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu,
       linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       alan@lxorguk.ukuu.org.uk, tomof@acm.org
Subject: Re: [bug] ata subsystem related crash with latest -git
References: <20071018082145.GK5063@kernel.dk> <20071018.045505.106265100.davem@davemloft.net> <20071018115702.GW5063@kernel.dk> <20071018.050554.115911163.davem@davemloft.net> <20071018120950.GX5063@kernel.dk> <20071018121547.GY5063@kernel.dk>
In-Reply-To: <20071018121547.GY5063@kernel.dk>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct. 18, 2007, 14:15 +0200, Jens Axboe <jens.axboe@oracle.com> wrote:
<snip>
>  /**
>   * sg_next - return the next scatterlist entry in a list
> @@ -43,10 +51,15 @@ static inline void sg_init_one(struct scatterlist *sg, const void *buf,
>   */
>  static inline struct scatterlist *sg_next(struct scatterlist *sg)
>  {
> -	sg++;
> -
> -	if (unlikely(sg_is_chain(sg)))
> +#ifdef CONFIG_DEBUG_SG
> +	BUG_ON(sg->sg_magic != SG_MAGIC);
> +#endif
> +	if (sg_is_last(sg))
> +		sg = NULL;
> +	else if (sg_is_chain(sg))
>  		sg = sg_chain_ptr(sg);
> +	else
> +		sg++;

Hmm, sg_next is not supposed to return a pointer to the chain entry
itself, but rather skip it.  I think that the fix needs only
check the "last" flag before incrementing sg.

+#ifdef CONFIG_DEBUG_SG
+	BUG_ON(sg->sg_magic != SG_MAGIC);
+#endif
+	if (sg_is_last(sg))
+		return NULL;
+
 	sg++
 
 	if (unlikely(sg_is_chain(sg)))
 		sg = sg_chain_ptr(sg);

>  
>  	return sg;
>  }
> @@ -83,6 +96,9 @@ static inline struct scatterlist *sg_last(struct scatterlist *sgl,
>  		ret = sg;
>  
>  #endif
> +#ifdef CONFIG_DEBUG_SG
> +	BUG_ON(sgl[0].sg_magic != SG_MAGIC);

can it also do BUG_ON(!sg_is_last(sg))?

> +#endif
>  	return ret;
>  }
>  

