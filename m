Return-Path: <linux-kernel-owner+w=401wt.eu-S1757565AbXI1Vqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565AbXI1Vqc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 17:46:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754904AbXI1VqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 17:46:10 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:30939 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754223AbXI1VqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 17:46:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=oQIHAK0BsFAYj5/kw1dGfywh0LvWzljPLPrOoQ8qF1FxYT+wsfRbkJz84a/9s9H50ms7XgQQYqrzxpPJili8KFXqBfU/H7cLOzWHeOAornbxcMbdOjV/2XcxRNBzt1oIHlMsIzShLwWSL+5NvPJibITXnlPcyT9yjrCKboyVbAA=  ;
X-YMail-OSG: CD4LqrsVM1kp7VyUV4VOrcOM1b95UIqcKybwlE4JyvWcFVeMGn8PWSVGaSMB6xq0_qpnb.jxYA--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [15/17] SLUB: Support virtual fallback via SLAB_VFALLBACK
Date: Fri, 28 Sep 2007 15:14:47 +1000
User-Agent: KMail/1.9.5
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>
References: <20070919033605.785839297@sgi.com> <200709280742.38262.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0709281014060.4713@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0709281014060.4713@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200709281514.48293.nickpiggin@yahoo.com.au>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 29 September 2007 03:33, Christoph Lameter wrote:
> On Fri, 28 Sep 2007, Nick Piggin wrote:
> > On Wednesday 19 September 2007 13:36, Christoph Lameter wrote:
> > > SLAB_VFALLBACK can be specified for selected slab caches. If fallback
> > > is available then the conservative settings for higher order
> > > allocations are overridden. We then request an order that can
> > > accomodate at mininum 100 objects. The size of an individual slab
> > > allocation is allowed to reach up to 256k (order 6 on i386, order 4 on
> > > IA64).
> >
> > How come SLUB wants such a big amount of objects? I thought the
> > unqueued nature of it made it better than slab because it minimised
> > the amount of cache hot memory lying around in slabs...
>
> The more objects in a page the more the fast path runs. The more the fast
> path runs the lower the cache footprint and the faster the overall
> allocations etc.
>
> SLAB can be configured for large queues holdings lots of objects.
> SLUB can only reach the same through large pages because it does not
> have queues. One could add the ability to manage pools of cpu slabs but
> that would be adding yet another layer to compensate for the problem of
> the small pages. Reliable large page allocations means that we can get rid
> of these layers and the many workarounds that we have in place right now.

That doesn't sound very nice because you don't actually want to use up
higher order allocations if you can avoid it, and you definitely don't want
to be increasing your slab page size unit if you can help it, because it
compounds the problem of slab fragmentation.


> The unqueued nature of SLUB reduces memory requirements and in general the
> more efficient code paths of SLUB offset the advantage that SLAB can reach
> by being able to put more objects onto its queues.
> introduces complexity and cache line use through the need to manage those
> queues.

I thought it was slower. Have you fixed the performance regression?
(OK, I read further down that you are still working on it but not confirmed
yet...)


> > vmalloc is incredibly slow and unscalable at the moment. I'm still
> > working on making it more scalable and faster -- hopefully to a point
> > where it would actually be usable for this... but you still get moved off
> > large TLBs, and also have to inevitably do tlb flushing.
>
> Again I have not seen any fallbacks to vmalloc in my testing. What we are
> doing here is mainly to address your theoretical cases that we so far have
> never seen to be a problem and increase the reliability of allocations of
> page orders larger than 3 to a usable level. So far I have so far not
> dared to enable orders larger than 3 by default.

Basically, all that shows is that your testing isn't very thorough. 128MB
is an order of magnitude *more* memory than some users have. They
probably wouldn't be happy with a regression in slab allocator performance
either.


> > Or do you have SLUB at a point where performance is comparable to SLAB,
> > and this is just a possible idea for more performance?
>
> AFAICT SLUBs performance is superior to SLAB in most cases and it was like
> that from the beginning. I am still concerned about several corner cases
> though (I think most of them are going to be addressed by the per cpu
> patches in mm). Having a comparable or larger amount of per cpu objects as
> SLAB is something that also could address some of these concerns and could
> increase performance much further.

OK, so long as it isn't going to depend on using higher order pages, that's
fine. (if they help even further as an optional thing, that's fine too. You
can turn them on your huge systems and not even bother about adding
this vmap fallback -- you won't have me to nag you about these
purely theoretical issues).
