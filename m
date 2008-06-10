Return-Path: <linux-kernel-owner+w=401wt.eu-S1755883AbYFJG5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883AbYFJG5R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 02:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751807AbYFJG5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 02:57:03 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:36454 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751708AbYFJG5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 02:57:00 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=xDZikxqGStiwEGzKEPH3cpJ0WgwiyuVOSA0dfz+TW86kkkV8jYzs8CF2setBOGnwG5rhfG6/xCs7b+PvE/d052dlzhK7Pwjo97hPANv9tCn7egXox9FRKja6AWKK7sK2k5UslBSIXqTeM6ThNZ3ajp8PzqT4wVX/T7CtBk8jNis=  ;
X-YMail-OSG: FEhUCHMVM1n1N_vX1B4eaQDh.dF3DevoHlvsLhovDP_dhe1P6.03WJ1zJUD4_iLjsKQIx1g6v90EEDEGntg.ky2UVet7j1Xw.Y7ANh6B6Q--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>
Subject: Re: MMIO and gcc re-ordering issue
Date: Tue, 10 Jun 2008 16:56:50 +1000
User-Agent: KMail/1.9.5
Cc: Trent Piepho <tpiepho@freescale.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>, linux-arch@vger.kernel.org,
       scottwood@freescale.com, linuxppc-dev@ozlabs.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
References: <1211852026.3286.36.camel@pasglop> <Pine.LNX.4.64.0806031130130.3242@t2.domain.actdsltmp> <alpine.LFD.1.10.0806031153360.3473@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0806031153360.3473@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200806101656.51211.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 June 2008 05:07, Linus Torvalds wrote:
> On Tue, 3 Jun 2008, Trent Piepho wrote:
> > On Tue, 3 Jun 2008, Linus Torvalds wrote:
> > > On Tue, 3 Jun 2008, Nick Piggin wrote:
> > > > Linus: on x86, memory operations to wc and wc+ memory are not ordered
> > > > with one another, or operations to other memory types (ie. load/load
> > > > and store/store reordering is allowed). Also, as you know, store/load
> > > > reordering is explicitly allowed as well, which covers all memory
> > > > types. So perhaps it is not quite true to say readl/writel is
> > > > strongly ordered by default even on x86. You would have to put in
> > > > some mfence instructions in them to make it so.
> >
> > So on x86, these could be re-ordered?
> >
> > writel(START_OPERATION, CONTROL_REGISTER);
> > status = readl(STATUS_REGISTER);
>
> With both registers in a WC+ area, yes. The write may be in the WC buffers
> until the WC buffers are flushed (short list: a fence, a serializing
> instruction, a read-write to uncached memory, or an interrupt. There are
> others, but those are the main ones).
>
> But if the status register is in uncached memory (which is the only *sane*
> thing to do), then it doesn't matter if the control register is in WC
> memory. Because the status register read is itself serializing with the WC
> buffer, it's actually fine.
>
> So this is used for putting things like ring queues in WC memory, and fill
> them up with writes, and get nice bursty write traffic with the CPU
> automatically buffering it up (think "stdio.h on a really low level"). And
> if you then have the command registers in UC memory or using IO port
> accesses, reading and writing to them will automatically serialize.

OK, I'm sitll not quite sure where this has ended up. I guess you are happy
with x86 semantics as they are now. That is, all IO accesses are strongly
ordered WRT one another and WRT cacheable memory (which includes keeping
them within spinlocks), *unless* one asks for WC memory, in which case that
memory is quite weakly ordered (and is not even ordered by a regular IO
readl, at least according to AMD spec). So for WC memory, one still needs
to use mb/rmb/wmb.

So that still doesn't tell us what *minimum* level of ordering we should
provide in the cross platform readl/writel API. Some relatively sane
suggestions would be:

- as strong as x86. guaranteed not to break drivers that work on x86,
  but slower on some archs. To me, this is most pleasing. It is much
  much easier to notice something is going a little slower and to work
  out how to use weaker ordering there, than it is to debug some
  once-in-a-bluemoon breakage caused by just the right architecture,
  driver, etc. It totally frees up the driver writer from thinking
  about barriers, provided they get the locking right.

- ordered WRT other IO accessors, constrained within spinlocks, but not
  cacheable memory. This is what powerpc does now. It's a little faster
  for them, and probably covers the vast majority of drivers, but there
  are real possibilities to get it wrong (trivial example: using bit
  locks or mutexes or any kind of open coded locking or lockless
  synchronisation can break).

- (less sane) same as above, but not ordered WRT spinlocks. This is what
  ia64 (sn2) does. From a purist POV, it is a little less arbitrary than
  powerpc, but in practice, it will break a lot more drivers than powerpc.

I was kind of joking about taking control of this issue :) But seriously,
it needs a decision to be made. I vote for #1. My rationale: I'm still
finding relatively major (well, found maybe 4 or 5 in the last couple of
years) bugs in the mm subsystem due to memory ordering problems. This is
apparently one of the most well reviewed and tested bit of code in the
kernel by people who know all about memory ordering. Not to mention that
mm/ does not have to worry about IO ordering at all. Then apparently
driver are the least reviewed and tested. Connect dots.

Now that doesn't leave waker ordering architectures lumped with "slow old
x86 semantics". Think of it as giving them the benefit of sharing x86
development and testing :) We can then formalise the relaxed __ accessors
to be more complete (ie. +/- byteswapping). I'd also propose to add
io_rmb/io_wmb/io_mb that order io/io access, to help architectures like
sn2 where the io/cacheable barrier is pretty expensive.

Any comments?
