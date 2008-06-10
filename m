Return-Path: <linux-kernel-owner+w=401wt.eu-S1756292AbYFJRmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292AbYFJRmV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 13:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752572AbYFJRmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 13:42:09 -0400
Received: from outbound-mail-10.bluehost.com ([69.89.17.210]:45330 "HELO
	outbound-mail-10.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752621AbYFJRmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 13:42:07 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: MMIO and gcc re-ordering issue
Date: Tue, 10 Jun 2008 10:41:28 -0700
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, Trent Piepho <tpiepho@freescale.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>, linux-arch@vger.kernel.org,
       scottwood@freescale.com, linuxppc-dev@ozlabs.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
References: <1211852026.3286.36.camel@pasglop> <alpine.LFD.1.10.0806031153360.3473@woody.linux-foundation.org> <200806101656.51211.nickpiggin@yahoo.com.au>
In-Reply-To: <200806101656.51211.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806101041.28829.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 09, 2008 11:56 pm Nick Piggin wrote:
> So that still doesn't tell us what *minimum* level of ordering we should
> provide in the cross platform readl/writel API. Some relatively sane
> suggestions would be:
>
> - as strong as x86. guaranteed not to break drivers that work on x86,
>   but slower on some archs. To me, this is most pleasing. It is much
>   much easier to notice something is going a little slower and to work
>   out how to use weaker ordering there, than it is to debug some
>   once-in-a-bluemoon breakage caused by just the right architecture,
>   driver, etc. It totally frees up the driver writer from thinking
>   about barriers, provided they get the locking right.
>
> - ordered WRT other IO accessors, constrained within spinlocks, but not
>   cacheable memory. This is what powerpc does now. It's a little faster
>   for them, and probably covers the vast majority of drivers, but there
>   are real possibilities to get it wrong (trivial example: using bit
>   locks or mutexes or any kind of open coded locking or lockless
>   synchronisation can break).
>
> - (less sane) same as above, but not ordered WRT spinlocks. This is what
>   ia64 (sn2) does. From a purist POV, it is a little less arbitrary than
>   powerpc, but in practice, it will break a lot more drivers than powerpc.
>
> I was kind of joking about taking control of this issue :) But seriously,
> it needs a decision to be made. I vote for #1. My rationale: I'm still
> finding relatively major (well, found maybe 4 or 5 in the last couple of
> years) bugs in the mm subsystem due to memory ordering problems. This is
> apparently one of the most well reviewed and tested bit of code in the
> kernel by people who know all about memory ordering. Not to mention that
> mm/ does not have to worry about IO ordering at all. Then apparently
> driver are the least reviewed and tested. Connect dots.
>
> Now that doesn't leave waker ordering architectures lumped with "slow old
> x86 semantics". Think of it as giving them the benefit of sharing x86
> development and testing :) We can then formalise the relaxed __ accessors
> to be more complete (ie. +/- byteswapping). I'd also propose to add
> io_rmb/io_wmb/io_mb that order io/io access, to help architectures like
> sn2 where the io/cacheable barrier is pretty expensive.
>
> Any comments?

FWIW that approach sounds pretty good to me.  Arches that suffer from 
performance penalties can still add lower level primitives and port selected 
drivers over, so really they won't be losing much.  AFAICT though drivers 
will still have to worry about regular memory ordering issues; they'll just 
be safe from I/O related ones. :)  Still, the simplification is probably 
worth it.

Jesse

