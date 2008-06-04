Return-Path: <linux-kernel-owner+w=401wt.eu-S1757564AbYFDCro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564AbYFDCro (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 22:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752519AbYFDCrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 22:47:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47684 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752143AbYFDCre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 22:47:34 -0400
Date: Tue, 3 Jun 2008 19:46:44 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Trent Piepho <tpiepho@freescale.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>, linux-arch@vger.kernel.org,
       scottwood@freescale.com, linuxppc-dev@ozlabs.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: MMIO and gcc re-ordering issue
In-Reply-To: <200806041205.45833.nickpiggin@yahoo.com.au>
Message-ID: <alpine.LFD.1.10.0806031932370.3473@woody.linux-foundation.org>
References: <1211852026.3286.36.camel@pasglop> <Pine.LNX.4.64.0806031130130.3242@t2.domain.actdsltmp> <alpine.LFD.1.10.0806031153360.3473@woody.linux-foundation.org> <200806041205.45833.nickpiggin@yahoo.com.au>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 4 Jun 2008, Nick Piggin wrote:
> 
> Actually, according to the document I am looking at (the AMD one), a UC
> store may pass a previous WC store.

Hmm. Intel arch manyal, Vol 3, 10.3 (page 10-7 in my version):

  "If the WC bufer is partially filled, the writes may be delayed until 
   the next ocurrence of a serializing event; such as, an SFENCE or MFENCE 
   instruction, CPUID execution, a read or write to uncached memory, ..."

Any typos mine.

Anyway, Intel certainly seems to document that WC memory is serialized by 
any access to UC memory.

But yes, I can well imagine that AMD is different, and I also heartily 
would recommend rather being safe than sorry. Putting an explicit memory 
barrier in between those accesses when you know it might make a difference 
is just a good idea. 

But basically, as far as I know the thing was designed to be invisible to 
old software: that is the whole idea behind WC memory. So the design was 
certainly intended to be that you can generally mark a framebuffer-like 
structure WC without any software _ever_ caring, as long as you keep all 
control ports in UC memory.

Of course, because burst writes from the WC buffer are <i>so</i> much more 
efficient on the PCI bus than dribbling them out one write at a time, it 
didn't take long before all the graphics cards etc wanted to <i>also</i> 
mark their command queues as WC memory, so that you could burst out the 
commands to the ring buffers as fast as possible. So now you have both 
your frame buffer *and* your command buffers mapped WC, and now ordering 
really has to be ensured in software if you access both.

[ And then there are the crazy people who mark *main memory* as WC, 
  because they don't want to pollute the cache with all the data, and then 
  you have the issue of cache coherency etc crap. Which only gets worse 
  with SMP, especially if one processor thinks it has part of memory 
  exclusively cached, and another one - or even the same one, 
  through another aliasign address - ignores the cache protocol.

  And you now get unhappy CPU's that think that there is a bug in the 
  cache protocol and they get machine check faults.

  So what started out as a "we can do accesses to the frame buffer more 
  efficiently without anybody ever even having to know or care" has 
  turned into a whole nightmare of people using it for other things, and 
  then you very much _do_ have to care! ]

And it doesn't surprise me if AMD then didn't get exactly the same 
rules. 

Oh, well.

		Linus
