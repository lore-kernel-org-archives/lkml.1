Return-Path: <linux-kernel-owner+w=401wt.eu-S1759004AbXJYXug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759004AbXJYXug (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 19:50:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753166AbXJYXua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 19:50:30 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:21025 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752900AbXJYXu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 19:50:29 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=twbsSK1lPDT+m/QDtLsMpZzrmwHQNaVWaXXtHqQiU0JBdFmqEiyn6WPSShNmolDhdooBXsoSKT5fe3evHQsLIUEZDmcNOCKQQ5dJG+SYPF/XHlD3mykwqUV3oEq8ynRmK5YWFwlspyEQX4UXeXCfWDUuCZW8X8zChQ1G7MtMKZo=  ;
X-YMail-OSG: HaBQ.zgVM1lTWYSDFPd2OGcV7xXeNQgDEK8hMiOnsPO7dabwLBV2c7_K9Hnk56v_IN_uTOb40A--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andi Kleen <ak@novell.com>
Subject: Re: Is gcc thread-unsafe?
Date: Fri, 26 Oct 2007 09:43:44 +1000
User-Agent: KMail/1.9.5
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <200710251324.49888.nickpiggin@yahoo.com.au> <200710260849.42776.nickpiggin@yahoo.com.au> <200710260109.50092.ak@novell.com>
In-Reply-To: <200710260109.50092.ak@novell.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710260943.44719.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 October 2007 09:09, Andi Kleen wrote:
> On Friday 26 October 2007 00:49:42 Nick Piggin wrote:

> > Marking volatile I think is out of the question. To start with,
> > volatile creates really poor code (and most of the time we actually
> > do want the code in critical sections to be as tight as possible).
>
> Poor code is better than broken code I would say. Besides
> the cross CPU synchronization paths are likely dominated by
> cache misses anyways; it's unlikely they're actually limited
> by the core CPU. So it'll probably not matter all that much
> if the code is poor or not.

But we have to mark all memory access inside the critical section
as volatile, even after the CPU synchronisation, and often the
common case where there is no contention or cacheline bouncing.

Sure, real code is dominated by cache misses anyway, etc etc.
However volatile prevents a lot of real optimisations that we'd
actually want to do, and increases icache size etc.


> > But also because I don't think these bugs are just going to be
> > found easily.
> >
> > > It might be useful to come up with some kind of assembler pattern
> > > matcher to check if any such code is generated for the kernel
> > > and try it with different compiler versions.
> >
> > Hard to know how to do it. If you can, then it would be interesting.
>
> I checked my kernel for "adc" at least (for the trylock/++ pattern)
> and couldn't find any (in fact all of them were in
> data the compiler thought to be code). That was not a allyesconfig build,
> so i missed some code.

sbb as well.


> For cmov it's at first harder because they're much more frequent
> and cmov to memory is a multiple instruction pattern (the instruction
> does only support memory source operands). Luckily gcc
> doesn't know the if (x) mem = a; => ptr = cmov(x, &a, &dummy); *ptr = a;
> transformation trick so I don't think there are actually any conditional
> stores on current x86.
>
> It might be a problem on other architectures which support true
> conditional stores though (like IA64 or ARM)

It might just depend on the instruction costs that gcc knows about.
For example, if ld/st is expensive, they might hoist them out of
loops etc. You don't even need to have one of these predicate or
pseudo predicate instructions.


> Also I'm not sure if gcc doesn't know any other tricks like the
> conditional add using carry, although I cannot think of any related
> to stores from the top of my hat.
>
> Anyways, if it's only conditional add if we ever catch such a case
> it could be also handled with inline assembly similar to local_inc()

But we don't actually know what it is, and it could change with
different architectures or versions of gcc. I think the sanest thing
is for gcc to help us out here, seeing as there is this very well
defined requirement that we want.

If you really still want the optimisation to occur, I don't think it
is too much to use a local variable for the accumulator (eg. in the
simple example case).
