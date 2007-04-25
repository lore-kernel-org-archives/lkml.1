Return-Path: <linux-kernel-owner+w=401wt.eu-S1750712AbXDYX6E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750712AbXDYX6E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 19:58:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750940AbXDYX6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 19:58:04 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40557 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750712AbXDYX6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 19:58:01 -0400
Date: Wed, 25 Apr 2007 16:57:22 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Pavel Machek <pavel@ucw.cz>
cc: Kenneth Crudup <kenny@panix.com>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Con Kolivas <kernel@kolivas.org>,
       suspend2-devel@lists.suspend2.net, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
 hang in atomic copy)
In-Reply-To: <20070425232806.GL17387@elf.ucw.cz>
Message-ID: <alpine.LFD.0.98.0704251632531.9964@woody.linux-foundation.org>
References: <alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org>
 <20070425072350.GA6866@ucw.cz> <Pine.LNX.4.64.0704251239110.8406@vaio.localdomain>
 <alpine.LFD.0.98.0704251252070.9964@woody.linux-foundation.org>
 <20070425202741.GC17387@elf.ucw.cz> <alpine.LFD.0.98.0704251332090.9964@woody.linux-foundation.org>
 <20070425214420.GG17387@elf.ucw.cz> <alpine.LFD.0.98.0704251515140.9964@woody.linux-foundation.org>
 <20070425224928.GJ17387@elf.ucw.cz> <alpine.LFD.0.98.0704251601020.9964@woody.linux-foundation.org>
 <20070425232806.GL17387@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Apr 2007, Pavel Machek wrote:
> 
> > For suspend to ram, in contrast, since you *know* that nobody will be 
> > touching the hardware, and since the timings are very different anyway 
> > (you'd hope that you can resume in a second or two), you'd generally want 
> > to keep the DMA engine tables right where they are, and just literally 
> > suspend the PCI chip itself.
> 
> I'd actually prefer resume to be similar to module insert, too... Do
> you think that resume is _that_ time critical?

I think it probably depends on the device, and it should depend on the 
driver writer how he wants to do it.

My _point_ is that there is absolutely zero reason to think that the two 
events are the same. We *know* that for snapshot+shutdown, we need to 
actually keep the DMA tables intact *over* the snapshot (because writing 
out the snapshot may _need_ them). But exactly because we keep them 
intact, a driver writer may sanely say "I didn't even bother shutting them 
down, so on thaw, I cannot trust them, so I'll just re-initialize them 
entirely".

In contrast, over suspend-to-ram, it's entirely reasonable to just leave 
them in memory, and just keep them. There's no *reason* not to.

And that's my whole point in this argument: the two paths are 
fundamentally totally different. You *claim* that "snapshot()" needs to 
stop DMA etc, but that's simply not true.

So I claim:
 - for a lot of devices, it's actually a *lot* easier to just have 
   snapshot not do anythign at all, and re-initialze on thaw
 - for those same devices, for s2ram, since the tables are *safe* and 
   don't get touched by anything else, it's probably easier to just let 
   them be.

See? The "it's easier to do X" is a _different_ X for the two cases. 

So the whole "suspend is a superset of freeze" is simply not true.

> [I'd like you to drop me a line saying you understand current design
> and that it works -- even if it is very inelegant]

I _do_ understand the current design. I just think that it's totally 
and seriously broken. I've ranted against it before. I think it's stupid 
to play like you're "suspending" something just to save some state, 
especially since most users probably don't even *want* to suspend the 
state, and would quite happily re-initialize the chip instead.

And I think it's horrible to have a dynamic flag to tell the difference 
between two or more state changes that the devices should statically be 
able to determine. _If_ some driver really does have the same routine, 
just use the same routine. There are no downsides to splitting them up.

> Now, we can separate suspend/freeze and resume/thaw (with some common
> helpers). It will speed the code up by avoiding unneccessary
> operations. It also needs attetion from driver writers (ouch).
> 
> Do we want to do that?

I'd personally certainly want to do that. But I want to split up the 
callers too. Right now we mix those a lot as well. I suspect that would 
automatically be fixed by just forcing them to separate out (since they 
now call different functions of the devices), but I'm not 100% sure. There 
might be other issues.

Just as an example: one of the most painful things there is in the suspend 
sequence is that we shut off the console (because the console device will 
be suspended in hw, and it's thus not safe to use it over a suspend/resume 
sequence). That should just go away entirely for "snapshot()", because 
there is *never* any excuse for actually turning off the console during a 
snapshot: even a network console should be entirely functional.  Things 
like that - things that sound like small issues, but that really aren't.

(Right now you can enable the "don't disable the console" config option, 
but since network drivers will actually shut down etc, it just means that 
you'll have oopses etc if you do, and you have netconsole enabled)

		Linus
