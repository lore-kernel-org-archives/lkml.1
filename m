Return-Path: <linux-kernel-owner+w=401wt.eu-S1755514AbYFIRsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514AbYFIRsg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 13:48:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753162AbYFIRs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 13:48:26 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:64593 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752987AbYFIRsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 13:48:25 -0400
Date: Mon, 9 Jun 2008 19:48:59 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: David Brownell <david-b@pacbell.net>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-mtd@lists.infradead.org,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
Subject: Re: [patch 2.6.26-rc5-git] at91_nand speedup via
 {read,write}s{b,w}()
Message-ID: <20080609194859.3a9b5fcb@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <200806091007.37494.david-b@pacbell.net>
References: <200806090313.28515.david-b@pacbell.net>
	<20080609133124.0eb97e25@hskinnemo-gx745.norway.atmel.com>
	<200806091007.37494.david-b@pacbell.net>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Jun 2008 17:48:10.0896 (UTC) FILETIME=[FBB56100:01C8CA58]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell <david-b@pacbell.net> wrote:
> On Monday 09 June 2008, Haavard Skinnemoen wrote:
> > David Brownell <david-b@pacbell.net> wrote:
> > > This uses __raw_{read,write}s{b,w}() primitives to access data on NAND
> > > chips for more efficient I/O.
> > > 
> > > On an arm926 with memory clocked at 100 MHz, this reduced the elapsed
> > > time for a 64 MByte read by 16%.  ("dd" /dev/mtd0 to /dev/null, with
> > > an 8-bit NAND using hardware ECC and 128KB blocksize.)
> > 
> > Nice. Here are some numbers from my setup (256 MB, 8-bit, software ECC).
> > 
> > Before:
> > real	2m38.131s
> > user	0m0.228s
> > sys	2m37.740s
> > 
> > After:
> > real	2m27.404s
> > user	0m0.180s
> > sys	2m27.068s
> > 
> > which is a 6.8% speedup. I guess hardware ECC helps...
> 
> The AVR32 versions of readsb/writesb didn't look to me as if they'd
> be quite as fast as the ARM ones either.  If AVR32 has some analogue
> of "stmia r1!, {r3 - r6}" for burst 16 byte stores, it's not using
> it right now.  (What was the bug you found in its readsb?)

Note that I'm talking about the __raw_ versions of those, which are a
bit more optimized than the non-raw versions. They do

1:	ldins.b	r8:t, r12[0]
	ldins.b	r8:u, r12[0]
	ldins.b	r8:l, r12[0]
	ldins.b r8:b, r12[0]
	st.w	r11++, r8
	sub	r10, 4
	brge	1b

I don't think we have an instruction that can store multiple registers
to the same address...it would of course be acceptable to store to
incrementing addresses when dealing with NAND flash, but I don't think
it's a good idea in a general __raw_readsb implementation.

Here's the bug I found, btw:

--- a/arch/avr32/lib/io-readsb.S
+++ b/arch/avr32/lib/io-readsb.S
@@ -41,7 +41,7 @@ __raw_readsb:
 2:     sub     r10, -4
        reteq   r12
 
-3:     ld.uh   r8, r12[0]
+3:     ld.ub   r8, r12[0]
        sub     r10, 1
        st.b    r11++, r8
        brne    3b

Not sure how easy it is to trigger since that code is only executed for
odd sizes.

> Yes, I'd think the win would be most visible with hardware ECC, since
> without it you've still got a second manual scan of each block.  (And
> I see you observed this too, after applying a workaround for an ECC
> erratum you just learned about...)  My numbers for one pair of trials
> (the "16%" was an average of 6 runs) had a *lot* less system time.
> Which oddly enough went *up* after the switch to readsb/writesb:
> 
> Before:
> real    0m24.199s
> user    0m0.000s
> sys     0m5.630s
> 
> After:
> real    0m20.226s
> user    0m0.010s
> sys     0m6.000s

Hmm, that's odd. What's the CPU doing during the remaining 14 seconds?
It can't possibly be sleeping?

Ah, it's I/O wait, isn't it? Because you're going through the block
layer?

> However, the fact that you got a win even with soft ECC (and, I'm
> guessing, slower RAM and slower readsb) suggests that this speedup
> should be pretty generally applicable!

Yes, I would think so...although I've seen gcc generate somewhat crappy
code for the I/O accessors, and we do some address mangling in the
non-raw I/O accessors on avr32 which might explain some of the
difference.

> > though I can't 
> > seem to get it to work properly. Is there anything I need to do besides
> > flash_eraseall when changing the ECC layout?
> 
> I wouldn't know.  Just be sure not to lose all your badblocks data
> when you convert ...

Seems like flash_eraseall skips the bad blocks as it should.

> > Also, I wonder if we can use the DMA engine framework to get rid of all
> > that "sys" time...?
> 
> It's another one of those cases where the framework overhead has to be
> low enough to make that practical.  Last time I looked, the overhead to
> set up and wait for a DMA of a couple KBytes was a significant chunk of
> the cost to readsb()/writesb() the same data ... and that's even before
> the data starts transferring.

Right. I guess we should take a look at how to reduce that overhead at
some point...

> Plus, the MTD layer currently assumes DMA is never used.  Some of the
> buffers it passes are not suitable for dma_map_single() since they
> come from vmalloc.

Aw...the MTD layer uses vmalloc() all over the place :-(

> Sounds fair to me.  Thanks; this has been sitting in my tree for many
> months now, I finally made time to measure it and was pleasantly
> surprised by the size of the win!

Yeah...I'm still not sure where to send it though, since it touches
three different subsystems. I can set up a separate tree for it like
I've done a couple of times before...though I'm not sure if anyone ever
pulls it.

Haavard
