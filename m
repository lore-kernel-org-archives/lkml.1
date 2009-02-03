Return-Path: <linux-kernel-owner+w=401wt.eu-S1753567AbZBCJl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567AbZBCJl3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 04:41:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751627AbZBCJlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 04:41:17 -0500
Received: from mail-bw0-f12.google.com ([209.85.218.12]:47983 "EHLO
	mail-bw0-f12.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358AbZBCJlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 04:41:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dui+hjrBINbslmJ09TSPuSebPDhG42aVbptJ4Ol+2JmPl9q4SOCp01NUS2jA3dxRLF
         XsiGtQ8QQQyjYzHffFWHoUOzeLczW5b46js5ff8OZYoLsCizvIveQyLzkS3y9iODCAM4
         LzxAx2L2vzKRN9jnkmM4JkO+VKLh27TZ93Qi4=
Date: Tue, 3 Feb 2009 09:41:08 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: herbert@gondor.apana.org.au, zbr@ioremap.net, w@1wt.eu,
       dada1@cosmosbay.com, ben@zeus.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [PATCH v2] tcp: splice as many packets as possible at once
Message-ID: <20090203094108.GA4639@ff.dom.local>
References: <20090202080855.GA4129@ff.dom.local> <20090202.001854.261399333.davem@davemloft.net> <20090202084358.GB4129@ff.dom.local> <20090202.235017.253437221.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090202.235017.253437221.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 02, 2009 at 11:50:17PM -0800, David Miller wrote:
> From: Jarek Poplawski <jarkao2@gmail.com>
> Date: Mon, 2 Feb 2009 08:43:58 +0000
> 
> > On Mon, Feb 02, 2009 at 12:18:54AM -0800, David Miller wrote:
> > > Allocating 4096 or 8192 bytes for a 1500 byte frame is wasteful.
> > 
> > I mean allocating chunks of cached pages similarly to sk_sndmsg_page
> > way. I guess the similar problem is to be worked out in any case. But
> > it seems doing it on the linear area requires less changes in other
> > places.
> 
> This is a very interesting idea, but it has some drawbacks:
> 
> 1) Just like any other allocator we'll need to find a way to
>    handle > PAGE_SIZE allocations, and thus add handling for
>    compound pages etc.
>  
>    And exactly the drivers that want such huge SKB data areas
>    on receive should be converted to use scatter gather page
>    vectors in order to avoid multi-order pages and thus strains
>    on the page allocator.

I guess compound pages are handled by put_page() enough, but I don't
think they should be main argument here, and I agree: scatter gather
should be used where possible.

> 
> 2) Space wastage and poor packing can be an issue.
> 
>    Even with SLAB/SLUB we get poor packing, look at Evegeniy's
>    graphs that he made when writing his NTA patches.

I'm a bit lost here: could you "remind" the way page space would be
used/saved in your paged variant e.g. for ~1500B skbs?

> 
> Now, when choosing a way to move forward, I'm willing to accept a
> little bit of the issues in #2 for the sake of avoiding the
> issues in #1 above.
> 
> Jarek, note that we can just keep your current splice() copy hacks in
> there.  And as a result we can have an easier to handle migration
> path.  We just do the page RX allocation conversions in the drivers
> where performance really matters, for hardware a lot of people have.
> 
> That's a lot smoother and has less issues that converting the system
> wide SKB allocator upside down.
> 

Yes, this looks reasonable. On the other hand, I think it would be
nice to get some opinions of slab folks (incl. Evgeniy) on the expected
efficiency of such a solution. (It seems releasing with put_page() will
always have some cost with delayed reusing and/or waste of space.)

Jarek P.
