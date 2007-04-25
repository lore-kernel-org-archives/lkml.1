Return-Path: <linux-kernel-owner+w=401wt.eu-S2993136AbXDYXwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993136AbXDYXwx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 19:52:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993135AbXDYXww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 19:52:52 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:40211 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S2993136AbXDYXwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 19:52:51 -0400
Date: Thu, 26 Apr 2007 01:52:35 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Kenneth Crudup <kenny@panix.com>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2: hang in atomic copy)
Message-ID: <20070425235235.GN17387@elf.ucw.cz>
References: <alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org> <20070425072350.GA6866@ucw.cz> <Pine.LNX.4.64.0704251239110.8406@vaio.localdomain> <alpine.LFD.0.98.0704251252070.9964@woody.linux-foundation.org> <20070425202741.GC17387@elf.ucw.cz> <alpine.LFD.0.98.0704251332090.9964@woody.linux-foundation.org> <20070425214420.GG17387@elf.ucw.cz> <alpine.LFD.0.98.0704251515140.9964@woody.linux-foundation.org> <20070425235718.66b71f01@the-village.bc.nu> <alpine.LFD.0.98.0704251610310.9964@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0704251610310.9964@woody.linux-foundation.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Both of them have to ensure you can make a consistent snapshot.
> 
> Bzzt. Wrong again. Very much so.
> 
> STR does not need to "ensure that you have a consistent snapshot".
> 
> Why? Becuase there is no _room_ for inconsistency. There's nothing to be 
> "inconsistent with", since any changes to memory (by things like DMA or 
> other setup that happens while the suspend process is going on) is by 
> _definition_ consistent with the resume image (becasue there is no 
> separate image).

Do you propose to keep DMAs running while suspending-to-RAM? That
sounds really unsafe; we are shutting down our PCI controllers at that
time; doing that while DMAs are running sounds bad.

> That's TOTALLY DIFFERENT from "suspend to disk". In suspend to disk, you 
> need a completely different kind of mindset, namely you need a single 
> consistent image, where the image is consistent not only with memory, but 
> with all the devices.
> 
> For example, the whole myth that "freeze" needs to shut off DMA is a total 
> and utter *myth*. It needs nothing of the sort at all. Rather than shut 
> off DMA and try to make the hardware be wevy wevy quiet while it's hunting 
> wabbits, it's a lot easier to just do nothing at all on "freeze",

No. Sorry, you are wrong here. 

Remember that during resume we run

freeze()
copy old data into memory
thaw()

. Now, if the old kernel left DMAs running, it could be overwriting
the data we are copying in. It is not about DMA tables. While
resuming, CPU needs to be alone, without interference from DMA engines
(or other CPUs), because copying back old image means writing to
memory that was not properly alocated.

(Now, we could add one more hook, turn_off_dmas_for_copyback(), but
that looks like way too many hooks to me. And I'm not comfortable with
DMA engines running while I'm trying to copy image. They may be
overwriting data I'm trying to copy...) 

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
