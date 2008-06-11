Return-Path: <linux-kernel-owner+w=401wt.eu-S1758079AbYFKFAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758079AbYFKFAx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 01:00:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751332AbYFKFAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 01:00:44 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:47428 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751196AbYFKFAn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 01:00:43 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=4On1RP4DU9if9CePld3EK8FVOCYun+xnYzA2wdWwShabK3FF2Weoct25FsmTTfoetAF7fTJhDiyfCiMfMPcCEMhk4zdfURyASH4omFv8GK29TgAwqIjxhf4GTlgn9e4gFf8px62Ce9E0Ojo7fxV8U2hJfPQ1uTmlVPP/XToY13w=  ;
X-YMail-OSG: WJTFbqwVM1lZLP0yWhxITTqQipLJyr7Z2dMhlIw6KQPZAFjGkylFKhIR6TXkewp3aGeySHhg437uSLdGWj.pmOR49fcumCRmugG8I6r4LnU_m3pf8ZAUFEZt3.RoTsQYUok-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Paul Mackerras <paulus@samba.org>
Subject: Re: MMIO and gcc re-ordering issue
Date: Wed, 11 Jun 2008 15:00:30 +1000
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, Trent Piepho <tpiepho@freescale.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>, linux-arch@vger.kernel.org,
       scottwood@freescale.com, linuxppc-dev@ozlabs.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
References: <1211852026.3286.36.camel@pasglop> <200806101656.51211.nickpiggin@yahoo.com.au> <18511.21025.978328.596571@cargo.ozlabs.ibm.com>
In-Reply-To: <18511.21025.978328.596571@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200806111500.30789.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 June 2008 14:18, Paul Mackerras wrote:
> Nick Piggin writes:
> > OK, I'm sitll not quite sure where this has ended up. I guess you are
> > happy with x86 semantics as they are now. That is, all IO accesses are
> > strongly ordered WRT one another and WRT cacheable memory (which includes
> > keeping them within spinlocks),
>
> My understanding was that on x86, loads could pass stores in general,
> i.e. a later load could be performed before an earlier store.

Yes, this is the one reordering allowed by the ISA on cacheable memory.
WC memory is weaker, which Linus wants to allow exception for because
one must explicitly ask for it. UC memory (which presumably is what
we're talking about as "IO access") I think is stronger in that it does
not allow any reordering between one another or any cacheable access:

AMD says this:

c — A store (wp,wt,wb,uc,wc,wc+) may not pass a previous load 
(wp,wt,wb,uc,wc,wc+).
f — A load (uc) does not pass a previous store (wp,wt,wb,uc,wc,wc+).
g — A store (wp,wt,wb,uc) does not pass a previous store (wp,wt,wb,uc).
i — A load (wp,wt,wb,wc,wc+) does not pass a previous store (uc).

AMD does allow WC/WC+ to be weakly ordered WRT WC as well as UC, which
Intel seemingly does not. But we're alrady treating WC as special.

I can't actually find the definitive statement in the Intel manuals
saying UC is strongly ordered also WRT WB. Linus?


> I guess 
> that can't be true for uncached loads, but could a cacheable load be
> performed before an earlier uncached store?
> > - as strong as x86. guaranteed not to break drivers that work on x86,
> >   but slower on some archs. To me, this is most pleasing. It is much
> >   much easier to notice something is going a little slower and to work
> >   out how to use weaker ordering there, than it is to debug some
> >   once-in-a-bluemoon breakage caused by just the right architecture,
> >   driver, etc. It totally frees up the driver writer from thinking
> >   about barriers, provided they get the locking right.
>
> I just wish we had even one actual example of things going wrong with
> the current rules we have on powerpc to motivate changing to this
> model.

~/usr/src/linux-2.6> git grep test_and_set_bit drivers/ | wc -l
506
How sure are you that none of those forms part of a cobbled-together
locking scheme that hopes to constrain some IO access?

~/usr/src/linux-2.6> git grep test_and_set_bit drivers/ | grep while | wc -l
29
How about those?

~/usr/src/linux-2.6> git grep mutex_lock drivers/ | wc -l
3138
How sure are you that none of them is hoping to constrain IO operations
within the lock?

Also grep for down, down_write, write_lock, and maybe some others I've
forgotten. And then forget completely about locking and imagine some
of the open coded things you see around the place (or parts where drivers
try to get creative and open code their own locking or try lockless
things).


> > Now that doesn't leave waker ordering architectures lumped with "slow old
> > x86 semantics". Think of it as giving them the benefit of sharing x86
> > development and testing :) We can then formalise the relaxed __ accessors
> > to be more complete (ie. +/- byteswapping).
>
> That leaves a gulf between the extremely strongly ordered writel
> etc. and the extremely weakly ordered __writel etc.  The current
> powerpc scheme is fine for a lot of drivers but your proposal would
> leave us no way to deliver it to them.

But surely you have to audit the drivers anyway to ensure they are OK
with the current powerpc scheme. In which case, once you have audited
them and know they are safe, you can easily convert them to the even
_faster_ __readl/__writel, and just add the appropriate barriers.

