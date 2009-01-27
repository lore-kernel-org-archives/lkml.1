Return-Path: <linux-kernel-owner+w=401wt.eu-S1754590AbZA0HlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590AbZA0HlQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 02:41:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751885AbZA0Hk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 02:40:57 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:54442 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbZA0Hkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 02:40:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=aqmrTgLYEUk67kivoOm7KbWhcz7tttWg8qSFTi3EJIeItV5yHDIu9J/PXm99TH93fA
         lUk1SVo/mem2j6kGEJKF26aUUfVrjxDUbLY38AFDMlDtEsvEr9fwriQ2J5wUBF0eYWbl
         yPBghm6hUUJX9qzLcSUiNQkSYHpNDTxwFDTZw=
Date: Tue, 27 Jan 2009 07:40:48 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: zbr@ioremap.net, herbert@gondor.apana.org.au, w@1wt.eu,
       dada1@cosmosbay.com, ben@zeus.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [PATCH v2] tcp: splice as many packets as possible at once
Message-ID: <20090127074048.GA4197@ff.dom.local>
References: <20090120103122.GC9167@ioremap.net> <20090126082036.GB4183@ff.dom.local> <20090126212130.GA4338@ioremap.net> <20090126.221056.174077798.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090126.221056.174077798.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2009 at 10:10:56PM -0800, David Miller wrote:
> From: Evgeniy Polyakov <zbr@ioremap.net>
> Date: Tue, 27 Jan 2009 00:21:30 +0300
> 
> > Hi Jarek.
> > 
> > On Mon, Jan 26, 2009 at 08:20:36AM +0000, Jarek Poplawski (jarkao2@gmail.com) wrote:
> > > > 1. Network (tree) allocator
> > > > http://www.ioremap.net/projects/nta
> > > 
> > > I looked at this a bit, but alas I didn't find much for this Herbert's
> > > idea of payload in fragments/pages. Maybe some kind of API RFC is
> > > needed before this resurrection?
> > 
> > Basic idea is to steal some (probably a lot) pages from the slab
> > allocator and put network buffers there without strict need for
> > power-of-two alignment and possible wraps when we add skb_shared_info at
> > the end, so that old e1000 driver required order-4 allocations for the
> > jumbo frames. We can do that in alloc_skb() and friends and put returned
> > buffers into skb's fraglist and updated reference counters for those
> > pages; and with additional copy of the network headers into skb->head.

I think the main problem is to respect put_page() more, and maybe you
mean to add this to your allocator too, but using slab pages for this
looks a bit complex to me, but I can miss something.

> We are going back and forth saying the same thing, I think :-)
> (BTW, I think NTA is cool and we might do something like that
> eventually)
> 
> The basic thing we have to do is make the drivers receive into
> pages, and then slide the network headers (only) into the linear
> SKB data area.

As a matter of fact, I wonder if these headers should be always
separated. Their "chunk" could be refcounted as well, I guess.

Jarek P.
