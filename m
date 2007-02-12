Return-Path: <linux-kernel-owner+w=401wt.eu-S933006AbXBLP4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933006AbXBLP4Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 10:56:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933011AbXBLP4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 10:56:16 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:4085 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933006AbXBLP4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 10:56:15 -0500
Date: Tue, 13 Feb 2007 02:55:53 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.osdl.org>,
       jgarzik <jgarzik@pobox.com>
Subject: Re: [PATCH 5/8] lguest: trivial guest network driver
Message-ID: <20070212155553.GA15627@gondor.apana.org.au>
References: <1171251406.10409.13.camel@localhost.localdomain> <1171251471.10409.15.camel@localhost.localdomain> <1171251578.10409.17.camel@localhost.localdomain> <1171251698.10409.20.camel@localhost.localdomain> <1171251770.10409.23.camel@localhost.localdomain> <1171251894.10409.26.camel@localhost.localdomain> <1171251965.10409.28.camel@localhost.localdomain> <1171252113.10409.30.camel@localhost.localdomain> <1171252219.10409.33.camel@localhost.localdomain> <1171252321.10409.36.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1171252321.10409.36.camel@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 12, 2007 at 02:52:01PM +1100, Rusty Russell wrote:
>
> +static void skb_to_dma(const struct sk_buff *skb, unsigned int len,
> +		       struct lguest_dma *dma)
> +{
> +	unsigned int i, seg;
> +
> +	for (i = seg = 0; i < len; seg++, i += rest_of_page(skb->data + i)) {
> +		dma->addr[seg] = virt_to_phys(skb->data + i);
> +		dma->len[seg] = min((unsigned)(len - i),
> +				    rest_of_page(skb->data + i));
> +	}
> +	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++, seg++) {
> +		const skb_frag_t *f = &skb_shinfo(skb)->frags[i];
> +		/* Should not happen with MTU less than 64k - 2 * PAGE_SIZE. */
> +		if (seg == LGUEST_MAX_DMA_SECTIONS) {
> +			printk("Woah dude!  Megapacket!\n");
> +			break;
> +		}
> +		dma->addr[seg] = page_to_phys(f->page) + f->page_offset;
> +		dma->len[seg] = f->size;
> +	}

The length field from the skb covers the fragmented parts as well.
So you don't want to use it as the boundary for the loop over the
skb header data.  As it is, if the skb has fragments, the first
loop will try to read them off the header.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
