Return-Path: <linux-kernel-owner+w=401wt.eu-S1030717AbXAZC7N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030717AbXAZC7N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 21:59:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030711AbXAZC7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 21:59:13 -0500
Received: from smtp.osdl.org ([65.172.181.24]:42791 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030717AbXAZC7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 21:59:12 -0500
Date: Thu, 25 Jan 2007 18:58:57 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Woodhouse <dwmw2@infradead.org>
cc: Alan <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jgarzik@pobox.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] libata-sff: Don't call bmdma_stop on non DMA capable
 controllers
In-Reply-To: <1169778239.3593.195.camel@shinybook.infradead.org>
Message-ID: <Pine.LNX.4.64.0701251832040.25027@woody.linux-foundation.org>
References: <20070125150905.652f9ce2@localhost.localdomain> 
 <1169741658.3593.98.camel@shinybook.infradead.org> 
 <20070125172739.0c990a9a@localhost.localdomain> 
 <Pine.LNX.4.64.0701250940220.25027@woody.linux-foundation.org> 
 <1169770985.3593.146.camel@shinybook.infradead.org> 
 <Pine.LNX.4.64.0701251703570.25027@woody.linux-foundation.org>
 <1169778239.3593.195.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 26 Jan 2007, David Woodhouse wrote:
> 
> The quality of our drivers is low; I'm fully aware that trying to
> improve driver quality is a quixotic task.

This is an important point. I actually hold things like the kernel VM 
layer to _much_ higher standards than I would ever hold a driver writer. 
That said, we tend to have "0 is special" even there, although we tend to 
try to make it always be about a pointer for those cases.

But drivers really are not just the bulk of the code, but they also can't 
be tested nearly as well. So for that reason (and really _only_ for that 
reason), we should always just accept that a "driver" should never have to 
worry, and *all* of the inconvenience of some special case or whatever 
must be solidly elsewhere.

> But where do we draw the line? Should we abandon the dma-mapping stuff 
> too? Declare that page zero is a special case and you can't DMA to it? 
> Should we try to make every PCI write also do a read in order to flush 
> posted writes, because people can't cope with the real world?

I think we should try to aim for two things:

 - things that "just work" on a PC should generally "just work" everywhere 
   else. Just for the simple reason that most drivers never get tested 
   anywhere else.

 - if it can't "just work", we should have as many static checks as 
   possible, and not let it compile.

 - and if it does compile, the stuff that "looks simple" should just work.

For example, the reason "0" is special really _is_ about the compiler. For 
any integer (or pointer, or FP) type in C, there really is just one 
special value. 0 (or NULL, for pointers).

The reason why resources work fine with zeroes is that for a *resource*, 
zero isn't actually a special value at all. Why? A resource isn't an 
integer value. It's a struct.

So compiler type safety (or lack thereof) really ends up forcing some of 
these issues. If something is represented as an integral type, the only 
*obvious* real special case is always going to be 0, just because it's the 
only one you can "test for" implicitly. Similarly, if you return a 
pointer, you only have NULL that can sanely be used as a special value.

(Yeah, mmap() has taught some people about MAP_FAIL, but that's pretty 
unusual too. And in the VFS layer, we use the magic "error pointers" that 
actually encode error values in the bits too - but then, VFS people tend 
to have to know a lot more about the kernel than a driver writer should 
have to - VFS people are just held to higher standards).

With a pointer, NULL is usually ok anyway, and always tends to mean 
something special - and for the other stuff you can then hide things 
"behind" the pointer. So with a pointer, you could often have "ptr->valid" 
or something else. With an integer, you can't really do that, because 0 
always remains special, just because EVEN JUST BY MISTAKE the test of the 
integer actually just ends up making zero be special.

So if you want a separate "enable" value, it almost has to be a structure 
or some opaque type, because that's the only type where there isn't an 
implicit special value.

We've done it occasionally. The VM has done it, for example. And we do it 
in drivers for more complex cases (and resources is one such case: it's 
already not a single value, since it has a start and a length, and other 
structure).

We could have done it for interrupts too. A "struct irqnum" that has a bit 
that specifies "valid". That would work. But it tends to be painful, so it 
really has to give you something more than "zero is disabled".

It's just not worth it.

And it's why I decreed, that the ONLY SANE THING is to just let people do 
the obvious thing:

	if (!dev->irq)
		return -ENODEV;

you don't have to know ANYTHING, and that code just works, and just looks 
obvious. And you know what? If it causes a bit of pain for some platform 
maintainer, I don't care one whit. Because it's obviously much better than 
the alternatives.

We may not "need" that rule for IO ports. If IO port 0 "happens to work", 
then hey, fine. But on the other hand, _all_ the same arguments really 
end up being still 100% true. If some driver happens to write

	if (!dev->ioport)
		return -ENODEV;

then I say: go for it. The _driver_ is correct. It's the obvious thing to 
do. It works on PC's, and it's simple and looks fine. Why not? If it 
causes some minor heartburn for an architecture maintainer, so what? 
Really? The tradeoff is obvious, and the architecture maintainer needs to 
just go and fix his IO mappings so that no device ever sees a "valid" port 
at port 0.

But in the meantime: if nobody complains, and it happens to work on 
hardware even though some devices _can_ see a port of zero, I also don't 
care. So I'm certainly not going to claim that your laptop "must be 
fixed". If it works, it works. Hey fine.

But the first driver that doesn't work because it thought it didn't have 
an IO port (beause it was zero), and the first time somebody complains, I 
know *exactly* whose fault it is. It's not the driver.

			Linus
