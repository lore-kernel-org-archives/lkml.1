Return-Path: <linux-kernel-owner+w=401wt.eu-S1760577AbZANIxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760577AbZANIxa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 03:53:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754123AbZANIxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 03:53:17 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:38116 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbZANIxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 03:53:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WAX9gFnUIvGpsWqjds8zZlCntxwuzWgOUIniEdBGTYKYFf/QJDykSFkf4cE42KUMAE
         ivxU9vIMIYs1TiZLAPV1eOgC68xeC8JX0RICKhvWdcUcsSL2ANrFvTjuI+RwH7ZVj7p+
         cOjaND9A+qeRXPUpbbKcbKIjX1+PK2JGr/Qew=
Date: Wed, 14 Jan 2009 08:53:08 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David Miller <davem@davemloft.net>, zbr@ioremap.net, dada1@cosmosbay.com,
       w@1wt.eu, ben@zeus.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: [PATCH] tcp: splice as many packets as possible at once
Message-ID: <20090114085308.GB4234@ff.dom.local>
References: <20090113.163705.130074998.davem@davemloft.net> <20090114035124.GA8409@gondor.apana.org.au> <20090113.232710.55011568.davem@davemloft.net> <20090114082630.GB16692@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090114082630.GB16692@gondor.apana.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 07:26:30PM +1100, Herbert Xu wrote:
> On Tue, Jan 13, 2009 at 11:27:10PM -0800, David Miller wrote:
> > 
> > So while trying to figure out a sane way to fix this, I found
> > another bug:
> > 
> > 	/*
> > 	 * map the linear part
> > 	 */
> > 	if (__splice_segment(virt_to_page(skb->data),
> > 			     (unsigned long) skb->data & (PAGE_SIZE - 1),
> > 			     skb_headlen(skb),
> > 			     offset, len, skb, spd))
> > 		return 1;
> > 
> > This will explode if the SLAB cache for skb->head is using compound
> > (ie. order > 0) pages.
> > 
> > For example, if this is an order-1 page being used for the skb->head
> > data (which would be true on most systems for jumbo MTU frames being
> > received into a linear SKB), the offset will be wrong and depending
> > upon skb_headlen() we could reference past the end of that
> > non-compound page we will end up grabbing a reference to.
> 
> I'm actually not worried so much about these packets since these
> drivers should be converted to skb frags as otherwise they'll
> probably stop working after a while due to memory fragmentation.
> 
> But yeah for correctness we definitely should address this in
> skb_splice_bits.
> 
> I still think Jarek's approach (the copying one) is probably the
> easiest for now until we can find a better way.
> 

Actually, I still think my second approach (the PageSlab) is probably
(if tested) the easiest for now, because it should fix the reported
(Willy's) problem, without any change or copy overhead for splice to
file (which could be still wrong, but not obviously wrong). Then we
could search for the only right way (which is most probably around
Herbert's new skb page allocator. IMHO "my" "copying approach" is too
risky e.g. for stable etc. because of unknown memory requirements,
especially for some larger size page configs/systems.

Jarek P.
