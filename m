Return-Path: <linux-kernel-owner+w=401wt.eu-S1754368AbYFCHTN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368AbYFCHTN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 03:19:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753152AbYFCHTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 03:19:00 -0400
Received: from smtp113.mail.mud.yahoo.com ([209.191.84.66]:30747 "HELO
	smtp113.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751228AbYFCHS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 03:18:59 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=L/B8UIs9JSnrFQLGoy5Mri3GdVYgOtcj8hoy89Z1NzqLUu8WVOk60swVcqw1oh0UOSTPVTzKhVf6OGUik2Owy3gTpSrbcRNGlqqYHkBk5iaui4lm5NdHJB3VNq3DHCSHEhGvP5Wj7gIVIvj3TjDqoUL6tCErHz1BSOqLSJbiT58=  ;
X-YMail-OSG: zXPUNwcVM1lzv3Lisiv7j0CNxx8.DBKQYW5cEMZfQtErJ7XrtUqhIEo6q0aqj3s97JrxumHUrOw3pTtJAB.UDsETrtRJSGAI.e3olqD7paQEmcgNdLZ6OGGIZjub.1YVSd4-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Paul Mackerras <paulus@samba.org>
Subject: Re: MMIO and gcc re-ordering issue
Date: Tue, 3 Jun 2008 17:18:42 +1000
User-Agent: KMail/1.9.5
Cc: benh@kernel.crashing.org, Russell King <rmk+lkml@arm.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, linux-arch@vger.kernel.org,
       scottwood@freescale.com, linuxppc-dev@ozlabs.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       tpiepho@freescale.com
References: <1211852026.3286.36.camel@pasglop> <200806031611.13817.nickpiggin@yahoo.com.au> <18500.60032.989380.864674@cargo.ozlabs.ibm.com>
In-Reply-To: <18500.60032.989380.864674@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806031718.43393.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 June 2008 16:53, Paul Mackerras wrote:
> Nick Piggin writes:
> > So your readl can pass an earlier cacheable store or earlier writel?
>
> No.  It's quite gross at the moment, it has a sync before the access
> (i.e. a full mb()) and a twi; isync sequence after the access that
> stalls execution until the data comes back.

OK.


> > > We don't provide meaningless ones like writel + cacheable store for
> > > example. (PCI posting would defeat it anyway).
> >
> > What do you mean by meaningless? Ordering of writel followed by a
> > cacheable store  is meaningful eg. for retaining io operations within
> > locks. OK, you explicitly have some extra code for spin_unlock, but
> > not for bit locks, mutexes, etc. It would make sense to have the
> > default operations _very_ strongly ordered IMO, and then move drivers
> > to be more relaxed when they are verified.
>
> It's meaningless in the sense that nothing guarantees that the writel
> has actually hit the device, even if we put a full mb() barrier in
> between the writel and the cacheable write.  That would guarantee that
> the writel had got to the PCI host bridge, and couldn't be reordered
> with other accesses to the device, but not that the device had
> actually seen it.

OK, but I think fits OK with our SMP ordering model for cacheable
stores: no amount of barriers on CPU0 will guarantee that CPU1 has
seen the store, you actually have to observe a causual effect
of the store before you can say that.


> I don't mind adding code to the mutex unlock to do the same as
> spin_unlock, but I really don't want to have *two* sync instructions
> for every MMIO write.  One is bad enough.

So you can't provide iostore/store ordering without another sync
after the writel store?

I guess the problem with providing exceptions is that it makes it
hard for people who absolutely don't know or care about ordering.
I don't like having to think about it "hmm, we can allow this type
of reordering... oh, unless some silly device does X...".

If we come up with a sane set of weakly ordered accessors
(including io_*mb()), it will make it easier to go through the
important drivers and improve them. We don't have to enforce the
the new semantics strictly until then if they'll slow you down
too much in the meantime.
