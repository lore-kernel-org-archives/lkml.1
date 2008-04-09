Return-Path: <linux-kernel-owner+w=401wt.eu-S1753381AbYDICcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381AbYDICcd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 22:32:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751995AbYDICc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 22:32:26 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:27379 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751868AbYDICcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 22:32:25 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=nO8oY3P1DLEN5DoJ6suvLay9Dx6YIeKG7vBsoLb3joeHVW2gMlzoZzQ9NDaowblPVwf3lllKtoYaw1cX2744IPSjZ2xMJ5ifTn59FWCbn+y/YUQ049NHO5n7Ra8kKiDwHRMaWuheQBIIWi+XBz+e1UYvJEV6XP6NyWa9zJi1dno=  ;
X-YMail-OSG: Pa99cqIVM1miHwURMYtJhFchEQ6fuDT2VSEpP2iT8Lgat65jKWACYH8s4.Sku1KoGOv4lT3yAQ--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC PATCH 1/2] futex: rely on get_user_pages() for shared futexes
Date: Wed, 9 Apr 2008 12:32:10 +1000
User-Agent: KMail/1.9.5
Cc: Eric Dumazet <dada1@cosmosbay.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
References: <20080404193332.348493000@chello.nl> <200804082140.04356.nickpiggin@yahoo.com.au> <1207673959.15579.77.camel@twins>
In-Reply-To: <1207673959.15579.77.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804091232.10476.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 April 2008 02:59, Peter Zijlstra wrote:
> On Tue, 2008-04-08 at 21:40 +1000, Nick Piggin wrote:
> > On Saturday 05 April 2008 06:33, Peter Zijlstra wrote:
> > > On the way of getting rid of the mmap_sem requirement for shared
> > > futexes, start by relying on get_user_pages().
> > >
> > > This requires we get the page associated with the key, and put the page
> > > when we're done with it.
> >
> > Hi Peter,
> >
> > Cool.
> >
> > I'm all for removing mmap_sem requirement from shared futexes...
> > Are there many apps which make a non-trivial use of them I wonder?
>
> No idea. I've heard some stories, but I've never seen any code..
>
> > I guess it will help legacy (pre-FUTEX_PRIVATE) usespaces in
> > performance too, though.
>
> Yeah, that was one of the motivations for this patch.
>
> > What I'm worried about with this is invalidate or truncate races.
> > With direct IO, it obviously doesn't matter because the only
> > requirement is that the page existed at the address at some point
> > during the syscall...
> >
> > So I'd really like you to not carry the page around in the key, but
> > just continue using the same key we have now. Also, lock the page
> > and ensure it hasn't been truncated before taking the inode from the
> > key and incrementing its count (page lock's extra atomics should be
> > more or less cancelled out by fewer mmap_sem atomic ops).
> >
> > get_futex_key should look something like this I would have thought:?
>
> Does look nicer, will have to ponder it a bit though.
>
> I must admit to not fully understanding why we take inode/mm references
> in the key anyway as neither will stop unmapping the futex.

I guess that's the problem; if we unmap the futex then we might
free the inode without a ref.


> Will make this into a nice patch.. thanks!
>
> > BTW. I like that it removes a lot of fshared crap from around
> > the place. And also this is a really good user of fast_gup
> > because I guess it should usually be faulted in. The problem is
> > that this could be a little more expensive for architectures that
> > don't implement fast_gup. Though most should be able to.
>
> Yeah, if that really becomes a problem (but I doubt it will) we could
> possibly make the old and new scheme work based on ARCH_HAVE_PTE_SPECIAL
> or something ugly like that.

Yeah, hopefully we won't have to worry. Technically this is a slowish
path anyway, so while heavy global contention and even sleeping on
mmap_sem may be a problem, I doubt the extra atomic or so would be
out of the noise.

Anyway, again thanks for doing this patch. What would be really nice
in order to get some testing concurrently while I'm trying to get
fast_gup in, is to make patch 2 which is exactly the same but it
still uses get_user_pages (ie. it just moves the mmap_sem call right
around the get_user_pages site). Then patch 3 can just remove those
3 lines and replace them with a call to fast_gup. Does that make sense?

Thanks,
Nick
