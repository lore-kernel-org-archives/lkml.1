Return-Path: <linux-kernel-owner+w=401wt.eu-S1751673AbXDZAOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673AbXDZAOh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 20:14:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751951AbXDZAOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 20:14:37 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:52712 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751673AbXDZAOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 20:14:36 -0400
Date: Thu, 26 Apr 2007 02:14:14 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Kenneth Crudup <kenny@panix.com>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2: hang in atomic copy)
Message-ID: <20070426001414.GO17387@elf.ucw.cz>
References: <Pine.LNX.4.64.0704251239110.8406@vaio.localdomain> <alpine.LFD.0.98.0704251252070.9964@woody.linux-foundation.org> <20070425202741.GC17387@elf.ucw.cz> <alpine.LFD.0.98.0704251332090.9964@woody.linux-foundation.org> <20070425214420.GG17387@elf.ucw.cz> <alpine.LFD.0.98.0704251515140.9964@woody.linux-foundation.org> <20070425235718.66b71f01@the-village.bc.nu> <alpine.LFD.0.98.0704251610310.9964@woody.linux-foundation.org> <20070425235235.GN17387@elf.ucw.cz> <alpine.LFD.0.98.0704251702290.9964@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0704251702290.9964@woody.linux-foundation.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Why? Becuase there is no _room_ for inconsistency. There's nothing to be 
> > > "inconsistent with", since any changes to memory (by things like DMA or 
> > > other setup that happens while the suspend process is going on) is by 
> > > _definition_ consistent with the resume image (becasue there is no 
> > > separate image).
> > 
> > Do you propose to keep DMAs running while suspending-to-RAM?
> 
> What part of "suspend a chip" do you have trouble with?
> 
> DMA obviously does *not* happen with a suspended device. There's no need 
> to turn DMA even off - it just doesn't happen!

Ok, I guess I'll have nightmares of DMA controllers doing DMAs from
chips that are no longer there tonight.

> > > For example, the whole myth that "freeze" needs to shut off DMA is a total 
> > > and utter *myth*. It needs nothing of the sort at all. Rather than shut 
> > > off DMA and try to make the hardware be wevy wevy quiet while it's hunting 
> > > wabbits, it's a lot easier to just do nothing at all on "freeze",
> > 
> > No. Sorry, you are wrong here. 
> > 
> > Remember that during resume we run
> > 
> > freeze()
> > copy old data into memory
> > thaw()
> > 
> > Now, if the old kernel left DMAs running, it could be overwriting
> > the data we are copying in.
> 
> The *thaw* needs to happen with devices quiescent. 
> 
> But that sure doesn't have anythign to do with the "snapshot()" path. In 
> fact, you'll have rebooted the machine in between.

Only the fact that we are currently using same device call during
snapshot() and during restore(). We obviously could do _5_ device
calls

(suspend/resume/freeze/quiesce_disable_dma/thaw)

...but that looks like too many calls to me.

> So what does that have to do with "snapshotting"?

I'm not comfortable with memory I'm copying changing under my hands
because of some DMA. It just looks like asking for trouble. I _think_
we can get away with DMA running during snapshot, because driver may
not assume anything about the DMA result before it got completion
interrupt, but... 

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
