Return-Path: <linux-kernel-owner+w=401wt.eu-S1764744AbXJRNus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764744AbXJRNus (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 09:50:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764287AbXJRNuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 09:50:11 -0400
Received: from sa8.bezeqint.net ([192.115.104.22]:60896 "EHLO sa8.bezeqint.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764213AbXJRNuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 09:50:09 -0400
Message-ID: <47176483.8030103@panasas.com>
Date: Thu, 18 Oct 2007 15:49:55 +0200
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu,
       linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       alan@lxorguk.ukuu.org.uk, tomof@acm.org
Subject: Re: [bug] ata subsystem related crash with latest -git
References: <20071018082145.GK5063@kernel.dk> <20071018.045505.106265100.davem@davemloft.net> <20071018115702.GW5063@kernel.dk> <20071018.050554.115911163.davem@davemloft.net> <20071018120950.GX5063@kernel.dk> <20071018121547.GY5063@kernel.dk> <20071018125840.GF5063@kernel.dk> <20071018133200.GH5063@kernel.dk>
In-Reply-To: <20071018133200.GH5063@kernel.dk>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct. 18, 2007, 15:32 +0200, Jens Axboe <jens.axboe@oracle.com> wrote:
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
>  

Jens, again, please correct me if I'm wrong, but when sg points at the
entry right before a chain entry this implementation of sg_next will
return a pointer to the chain entry here, which I believe it must not.

>  	return sg;
>  }
> 

here's how I think sg_next should be implemented:

  */
 static inline struct scatterlist *sg_next(struct scatterlist *sg)
 {
+#ifdef CONFIG_DEBUG_SG
+	BUG_ON(sg->sg_magic != SG_MAGIC);
+#endif
+	if (sg_is_last(sg))
+		return NULL;
+
 	sg++;
 
 	if (unlikely(sg_is_chain(sg)))
 		sg = sg_chain_ptr(sg);
 
 	return sg;
 }
