Return-Path: <linux-kernel-owner+w=401wt.eu-S1754638AbXDZCdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638AbXDZCdn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 22:33:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754679AbXDZCdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 22:33:43 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59768 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754638AbXDZCdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 22:33:42 -0400
Date: Wed, 25 Apr 2007 19:32:19 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Pavel Machek <pavel@ucw.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Kenneth Crudup <kenny@panix.com>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Con Kolivas <kernel@kolivas.org>,
       suspend2-devel@lists.suspend2.net, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
 hang in atomic copy)
In-Reply-To: <463008A2.9020301@zytor.com>
Message-ID: <alpine.LFD.0.98.0704251915460.9964@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0704251239110.8406@vaio.localdomain>
 <alpine.LFD.0.98.0704251252070.9964@woody.linux-foundation.org>
 <20070425202741.GC17387@elf.ucw.cz> <alpine.LFD.0.98.0704251332090.9964@woody.linux-foundation.org>
 <20070425214420.GG17387@elf.ucw.cz> <alpine.LFD.0.98.0704251515140.9964@woody.linux-foundation.org>
 <20070425235718.66b71f01@the-village.bc.nu>
 <alpine.LFD.0.98.0704251610310.9964@woody.linux-foundation.org>
 <20070425235235.GN17387@elf.ucw.cz> <alpine.LFD.0.98.0704251702290.9964@woody.linux-foundation.org>
 <20070426001414.GO17387@elf.ucw.cz> <alpine.LFD.0.98.0704251734320.9964@woody.linux-foundation.org>
 <463008A2.9020301@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 25 Apr 2007, H. Peter Anvin wrote:
> 
> That was the 1990s.  On a brand new server system:
> 
> 00:08.0 System peripheral: Intel Corporation 5000 Series Chipset DMA
> Engine (rev b1)
> 
> For better or worse, slave DMA seems to be making a comeback of sorts.
> Not to mention all kinds of embedded crap^Whardware with optimized DMA
> engines which look nothing like PCI at all.

Well, the solution to that tends to be to just leave them be, and hold 
them on until the very end - and just ignore them (and just make-believe 
that it's actually the device itself that does the DMA transfer).

The PCI spec for controlling DMA is really pretty nasty. You can disable 
it in the PCI config word, of course, but that usually just messes up the 
device entirely.

So in practice, the way to shut up DMA (regardless of whether it's an 
internal DMA engine or an external one) is that you just tell the device 
not to listen any more (for example, for a network controller, the way to 
make sure it doesn't do DMA is just to make sure that you're not sending 
any frames, but also that it's not listening to any either)!

So whether it's internal to the device, or some "system DMA controller", 
the sequence for shutting down DMA always ends up being the same:

 - make sure the host itself doesn't generate any new traffic (eg shut 
   down the send-queue). This is generally a higher-level thing anyway, ie 
   not really a driver decision.
 - the driver needs to tell the hardware to stop listening (ie "stop 
   scanning the command mailboxes" or "stop walking USB command 
   structures" or "stop receiving data")
 - the driver then needs to wait for the controller to say "ok, I'm idle".

because regardless of whether it's the system DMA controller or some 
on-chip DMA controller, you generally can *not* just say "stop 
transferring DMA data", because that will generally just lock the chip up 
or cause other major unhappiness.

So I don't think an external DMA controller (like the i8237, ugh!) really 
_changes_ anything. Except for just the horrible pain of serializing 
access to them for programming etc horrible resource handling issues, of 
course (but that's not specific to suspend/resume).

			Linus
