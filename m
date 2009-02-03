Return-Path: <linux-kernel-owner+w=401wt.eu-S1753008AbZBCLKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008AbZBCLKg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 06:10:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751986AbZBCLKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 06:10:24 -0500
Received: from intermatrixgroup.ru ([195.178.208.66]:33338 "EHLO
	tservice.net.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbZBCLKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 06:10:23 -0500
Date: Tue, 3 Feb 2009 14:10:12 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: David Miller <davem@davemloft.net>, herbert@gondor.apana.org.au, w@1wt.eu,
       dada1@cosmosbay.com, ben@zeus.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [PATCH v2] tcp: splice as many packets as possible at once
Message-ID: <20090203111012.GA16878@ioremap.net>
References: <20090202080855.GA4129@ff.dom.local> <20090202.001854.261399333.davem@davemloft.net> <20090202084358.GB4129@ff.dom.local> <20090202.235017.253437221.davem@davemloft.net> <20090203094108.GA4639@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090203094108.GA4639@ff.dom.local>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 03, 2009 at 09:41:08AM +0000, Jarek Poplawski (jarkao2@gmail.com) wrote:
> > 1) Just like any other allocator we'll need to find a way to
> >    handle > PAGE_SIZE allocations, and thus add handling for
> >    compound pages etc.
> >  
> >    And exactly the drivers that want such huge SKB data areas
> >    on receive should be converted to use scatter gather page
> >    vectors in order to avoid multi-order pages and thus strains
> >    on the page allocator.
> 
> I guess compound pages are handled by put_page() enough, but I don't
> think they should be main argument here, and I agree: scatter gather
> should be used where possible.

Problem is to allocate them, since with the time memory will be
quite fragmented, which will not allow to find a big enough page.

NTA tried to solve this by not allowing to free the data allocated on
the different CPU, contrary to what SLAB does. Modulo cache coherency
improvements, it allows to combine freed chunks back into the pages and
combine them in turn to get bigger contiguous areas suitable for the
drivers which were not converted to use the scatter gather approach.
I even believe that for some hardware it is the only way to deal
with the jumbo frames.

> > 2) Space wastage and poor packing can be an issue.
> > 
> >    Even with SLAB/SLUB we get poor packing, look at Evegeniy's
> >    graphs that he made when writing his NTA patches.
> 
> I'm a bit lost here: could you "remind" the way page space would be
> used/saved in your paged variant e.g. for ~1500B skbs?

At least in NTA I used cache line alignment for smaller chunks, while
SLAB uses power of two. Thus for 1500 MTU SLAB wastes about 500 bytes
per packet (modulo size of the shared info structure).

> Yes, this looks reasonable. On the other hand, I think it would be
> nice to get some opinions of slab folks (incl. Evgeniy) on the expected
> efficiency of such a solution. (It seems releasing with put_page() will
> always have some cost with delayed reusing and/or waste of space.)

Well, my opinion is rather biased here :)

-- 
	Evgeniy Polyakov
