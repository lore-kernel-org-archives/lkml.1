Return-Path: <linux-kernel-owner+w=401wt.eu-S2993132AbXDYXVI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993132AbXDYXVI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 19:21:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993136AbXDYXVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 19:21:08 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37411 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993132AbXDYXVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 19:21:06 -0400
Date: Wed, 25 Apr 2007 16:20:30 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Pavel Machek <pavel@ucw.cz>, Kenneth Crudup <kenny@panix.com>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
 hang in atomic copy)
In-Reply-To: <20070425235718.66b71f01@the-village.bc.nu>
Message-ID: <alpine.LFD.0.98.0704251610310.9964@woody.linux-foundation.org>
References: <20070419070437.GA25211@elte.hu> <20070424202336.GC16503@elf.ucw.cz>
 <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org>
 <20070424212408.GD16457@elf.ucw.cz> <alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org>
 <20070425072350.GA6866@ucw.cz> <Pine.LNX.4.64.0704251239110.8406@vaio.localdomain>
 <alpine.LFD.0.98.0704251252070.9964@woody.linux-foundation.org>
 <20070425202741.GC17387@elf.ucw.cz> <alpine.LFD.0.98.0704251332090.9964@woody.linux-foundation.org>
 <20070425214420.GG17387@elf.ucw.cz> <alpine.LFD.0.98.0704251515140.9964@woody.linux-foundation.org>
 <20070425235718.66b71f01@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 25 Apr 2007, Alan Cox wrote:
> 
> Both of them have to ensure you can make a consistent snapshot.

Bzzt. Wrong again. Very much so.

STR does not need to "ensure that you have a consistent snapshot".

Why? Becuase there is no _room_ for inconsistency. There's nothing to be 
"inconsistent with", since any changes to memory (by things like DMA or 
other setup that happens while the suspend process is going on) is by 
_definition_ consistent with the resume image (becasue there is no 
separate image).

> Doing that means you've got to be able to define a single "point" at 
> which the snapshot is made and is internally self-consistent. That in 
> both cases tends to mean you've got to ensure nothing occurs which pees 
> on the image while you are making that snapshot (such as outstanding 
> O_DIRECT I/O to user pages).

Get off the drugs, Alan. There *is* no snapshot with suspend-to-ram.

Which is the whole point I'm trying to make! A _lot_ of people are 
confused about this.

With suspend-to-ram, you don't need to do a damn thing to the chip, except 
suspend it and resume it. There are _zero_ consistency issues. There is no 
need to freeze anything at any point. You can suspend each device totally 
independently of all other devices (taking into account things like bus 
topology, of course), and there is no "atomic" snapshot that needs to ever 
exist.

That's TOTALLY DIFFERENT from "suspend to disk". In suspend to disk, you 
need a completely different kind of mindset, namely you need a single 
consistent image, where the image is consistent not only with memory, but 
with all the devices.

For example, the whole myth that "freeze" needs to shut off DMA is a total 
and utter *myth*. It needs nothing of the sort at all. Rather than shut 
off DMA and try to make the hardware be wevy wevy quiet while it's hunting 
wabbits, it's a lot easier to just do nothing at all on "freeze", and just 
make sure that "thaw" will re-initialze the DMA tables entirely! All 
drivers have code to do that anyway, since that's what you need to do at 
boot.

Notice?  Totally different. Absolutely NOTHING in common. Not on a 
practical plane, and not even conceptually.  The current (broken!) 
implementation has forced a totally idiotic model on things, where instead 
of snapshotting doing the sane and simple thing, it ends up doing extra 
work that is totally unnecessary, but *becomes* necessary just because it 
*also* shares the "resume" path (which should _not_ be the same either!)

			Linus
