Return-Path: <linux-kernel-owner+w=401wt.eu-S1030650AbXAZEsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030650AbXAZEsY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 23:48:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030723AbXAZEsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 23:48:24 -0500
Received: from smtp.osdl.org ([65.172.181.24]:45155 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030650AbXAZEsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 23:48:23 -0500
Date: Thu, 25 Jan 2007 20:48:07 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Woodhouse <dwmw2@infradead.org>
cc: Alan <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jgarzik@pobox.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] libata-sff: Don't call bmdma_stop on non DMA capable
 controllers
In-Reply-To: <1169785150.3593.231.camel@shinybook.infradead.org>
Message-ID: <Pine.LNX.4.64.0701252029570.25027@woody.linux-foundation.org>
References: <20070125150905.652f9ce2@localhost.localdomain> 
 <1169741658.3593.98.camel@shinybook.infradead.org> 
 <20070125172739.0c990a9a@localhost.localdomain> 
 <Pine.LNX.4.64.0701250940220.25027@woody.linux-foundation.org> 
 <1169770985.3593.146.camel@shinybook.infradead.org> 
 <Pine.LNX.4.64.0701251703570.25027@woody.linux-foundation.org> 
 <1169778239.3593.195.camel@shinybook.infradead.org> 
 <Pine.LNX.4.64.0701251832040.25027@woody.linux-foundation.org> 
 <1169782107.3593.219.camel@shinybook.infradead.org> 
 <Pine.LNX.4.64.0701251932250.25027@woody.linux-foundation.org>
 <1169785150.3593.231.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 26 Jan 2007, David Woodhouse wrote:
>
> Of course it could, but then again why shouldn't we special-case zero in
> _all_ of those use cases, just to make life easier for those poor driver
> authors who presumably can't manage to write userspace code using stdin
> or open() either.

You're not thinking, or, more likely YOU DON'T WANT TO.

What is so hard to understand? IRQ0 is a _real_irq_ as far as the 
*platform* goes even on PC's. Same goes for IO-port 0 and MMIO area zero.

Same goes for virtual address zero in a lot of user programs. It's a real 
virtual address. The fact that the NULL pointer points there doesn't make 
it less real.

Do you really have such a hard time understanding this fundamental issue?

Irq0 may _exist_. IO Port 0 may _exist_. Virtual address 0 may _exist_. 

Got it?

But they ARE NOT VALID THINGS FOR DRIVERS TO WORRY ABOUT.

When a *DRIVER* sees a NULL pointer, it's always a sign of "not here". 

It's not a "valid pointer that just happens to be at virtual address 
zero". But in other contexts it actually _can_ be exactly that (ie when 
you call "mmap(NULL .. MAP_FIXED)" you actually will get a NULL pointer 
that is a *REAL POINTER*.

Similarly, when a *DRIVER* seens a "port 0" or MMIO 0, it is perfectly 
valid for that driver to say "ok, my device apparently doesn't have an IO 
port".

That does not mean that "port 0" doesn't exist. It just means that AS FAR 
AS A DRIVER IS CONCERNED, port 0 is not a valid port for a driver!

Port 0 actually *does* exist on a PC. It's a system port (it also happens 
to be a total legacy port that nobody would ever use, but that's another 
issue entirely).

The same thing is true of irq 0. It exists. It's a valid IRQ for 
archtiecture code for a PC. It's just NOT A VALID IRQ FOR A DRIVER! So 
when a driver sees a device with !irq, it knows that the irq hasn't been 
allocated.

I don't understand why this is so hard for you to accept. Even when you 
yourself accept that irq0 actually *exists*, and even when you give as an 
example why "setup_irq()" must be able to take that irq, you give that as 
some kind of ass-hat example of why you are "right". Now you do exactly 
the same thing for the IO port space.

You're totally confused. You say the words, and you seem to understand 
that device drivers are special. But then you don't seem to follow that 
understanding through, and you want to then say that everything else is 
special too.

Don't you get it? If everybody is special, then nobody is special.

System code is special. System code can do things that drivers shouldn't 
do. System code can know that irq0 is actually the timer, and can set it 
up. System code can know that IO port 0 is actually decoded by the old and 
insane AT architecture DMA controller.

This is not even kernel-specific. "normal programs" think that NULL is 
special, and is never a valid pointer. But "system programs" may actually 
know better. If you're programming in DOS-EMU, and use vm86 mode, you know 
that you actually need to map the virtual address that is at 0, and NULL 
is suddenly not actually an invalid pointer: it's literally a pointer to 
the first byte in the vm86 model.

But when "malloc()" returns NULL, you know that it doesn't return such a 
"system pointer", so when malloc returns NULL, you realize that it's a 
special value.

The *EXACT* same thing is true within the kernel. When x86 architecture 
code explicitly sets up IRQ0, it does so because it knows that it's the 
timer interrupt. But that doesn't make it a valid irq for *anybody* else.

Ok, enough shouting.

Comprende? Do you _really_ think that the NULL pointer "doesn't exist"? Or 
can you realize that it's generally just a convention, and it's a 
convention that has been selected to be maximally easy to test for (both 
on a code generation level and on a C syntax level)? It doesn't mean that 
virtual address 0 "doesn't exist", and could not be mapped. 

The exact same thing is true of "IO port 0". It's the maximally simple 
_convention_ for someting that may actually exist, but it's somethign that 
NO NORMAL USER SHOULD EVER SEE AS A REAL IO PORT. There are special users 
that may use it, exactly the same way special users who know deep hardware 
details may decide that "on this architecture, the NULL pointer actually 
_literally_ means virtual address zero, and when I do *xyz* I actually can 
access things through it".

Does the fact that some things can use NULL as meaning something else than 
"no pointer" invalidate NULL as a concept? No. It just means that those 
things are very architecture-specific. They're not "common code" aka 
"drivers" any more.

Same exact deal.

		Linus
