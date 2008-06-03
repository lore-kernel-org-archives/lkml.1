Return-Path: <linux-kernel-owner+w=401wt.eu-S1756368AbYFCGLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756368AbYFCGLh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 02:11:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbYFCGL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 02:11:28 -0400
Received: from smtp118.mail.mud.yahoo.com ([209.191.84.167]:41295 "HELO
	smtp118.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752522AbYFCGL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 02:11:27 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=2cjmCy1p5QId0xJIwgH0SuGokSA5ItKN7Jo0geSaGYgpzGrD/y4lIuCKoQH6lF6JXHIYAV/FMwrbJ5Ab3mZxx04F9E8Yv7F0GfK3iHbBjcx/YURmTyaOEWPFmvZV59uSc6sW/6pRpscWhLV7UKpSqk5qv8MfM9ulXcghpaoe/iE=  ;
X-YMail-OSG: 1cceciUVM1kqqP5Dat106wG9qoqlDCKflmcmdbvQQAe8MqiWG8t8UsIE9inPTk6xTT4RcMgFEtH_ludBsOpaw6f95fG9DTpp2Z6frSTvTablYNN7IgN3YXn4oQONSyD.Z.A-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: benh@kernel.crashing.org
Subject: Re: MMIO and gcc re-ordering issue
Date: Tue, 3 Jun 2008 16:11:13 +1000
User-Agent: KMail/1.9.5
Cc: Russell King <rmk+lkml@arm.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, linux-arch@vger.kernel.org,
       scottwood@freescale.com, linuxppc-dev@ozlabs.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       tpiepho@freescale.com
References: <1211852026.3286.36.camel@pasglop> <200806031416.18195.nickpiggin@yahoo.com.au> <1212467551.9496.23.camel@pasglop>
In-Reply-To: <1212467551.9496.23.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806031611.13817.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 June 2008 14:32, Benjamin Herrenschmidt wrote:
> > This whole thread also ties in with my posts about mmiowb (which IMO
> > should go away).
> >
> > readl/writel:  strongly ordered wrt one another and other stores
> >                to cacheable RAM, byteswapping
> > __readl/__writel:  not ordered (needs mb/rmb/wmb to order with
> >                    other readl/writel and cacheable operations, or
> >                    io_*mb to order with one another)
> > raw_readl/raw_writel:  strongly ordered, no byteswapping
> > __raw_readl/__raw_writel:  not ordered, no byteswapping
> >
> > then get rid of *relaxed* variants.
>
> In addition, some archs like powerpc also provide readl_be/writel_be as
> being defined as big endian (ie. byteswap on LE archs, no byteswap on BE
> archs).

Sure.


> As of today, powerpc lacks the raw_readl/raw_writel and __readl/__writel
> variants (ie, we only provide fully ordered + byteswap and no ordering +
> no byteswap variants).
>
> If we agree on the above semantics, I'll do a patch providing the
> missing ones.

Let's see what Linus thinks...


> > Linus: on x86, memory operations to wc and wc+ memory are not ordered
> > with one another, or operations to other memory types (ie. load/load
> > and store/store reordering is allowed). Also, as you know, store/load
> > reordering is explicitly allowed as well, which covers all memory
> > types. So perhaps it is not quite true to say readl/writel is strongly
> > ordered by default even on x86. You would have to put in some
> > mfence instructions in them to make it so.
> >
> > So, what *exact* definition are you going to mandate for readl/writel?
> > Anything less than strict ordering then we also need to ensure drivers
> > use the correct barriers (to implement strict ordering, we could either
> > put mfence instructions in, or explicitly disallow readl/writel to be
> > used on wc/wc+ memory).
>
> The ordering guarantees that I provide on powerpc for "ordered" variants
> are:
>
> 	- cacheable store + writel stays ordered (ie, write to some
>           DMA stuff and then a register to trigger the DMA).
>
> 	- readl + cacheable read stays ordered (ie. read some status
>           register, for example, after an interrupt, and then read the
>           resulting data in memory).
>
> 	- any of these ordered vs. spin_lock and spin_unlock (with the
>           exception that stores done before the spin_lock
>           could potentially leak into the lock).
>
> 	- readl is synchronous (ie, makes the CPU think the
>           data was actually used before executing subsequent
>           instructions, thus waits for the data to come back,
>           for example to ensure that a read used to push out
>           post buffers followed by a delay will indeed happen
>           with the right delay).

So your readl can pass an earlier cacheable store or earlier writel?


> We don't provide meaningless ones like writel + cacheable store for
> example. (PCI posting would defeat it anyway).

What do you mean by meaningless? Ordering of writel followed by a
cacheable store  is meaningful eg. for retaining io operations within
locks. OK, you explicitly have some extra code for spin_unlock, but
not for bit locks, mutexes, etc. It would make sense to have the
default operations _very_ strongly ordered IMO, and then move drivers
to be more relaxed when they are verified.
