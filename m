Return-Path: <linux-kernel-owner+w=401wt.eu-S1752354AbXDQH4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354AbXDQH4S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 03:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752388AbXDQH4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 03:56:18 -0400
Received: from ns1.suse.de ([195.135.220.2]:44917 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752264AbXDQH4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 03:56:17 -0400
Date: Tue, 17 Apr 2007 09:56:11 +0200
From: Nick Piggin <npiggin@suse.de>
To: Peter Williams <pwil3058@bigpond.net.au>
Cc: Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       Ingo Molnar <mingo@elte.hu>, ck list <ck@vds.kolivas.org>,
       Bill Huey <billh@gnuppy.monkey.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070417075611.GC20026@wotan.suse.de>
References: <200704151327.13589.kernel@kolivas.org> <1176619384.6222.70.camel@Homer.simpson.net> <46240F98.3020800@bigpond.net.au> <1176776941.6222.21.camel@Homer.simpson.net> <20070417034050.GD25513@wotan.suse.de> <46244A52.4000403@bigpond.net.au> <20070417042954.GG25513@wotan.suse.de> <462467E9.4030509@bigpond.net.au> <20070417064436.GE1057@wotan.suse.de> <46247BE7.2070307@bigpond.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46247BE7.2070307@bigpond.net.au>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2007 at 05:48:55PM +1000, Peter Williams wrote:
> Nick Piggin wrote:
> >>Other hints that it was a bad idea was the need to transfer time slices 
> >>between children and parents during fork() and exit().
> >
> >I don't see how that has anything to do with dual arrays.
> 
> It's totally to do with the dual arrays.  The only real purpose of the 
> time slice in O(1) (regardless of what its perceived purpose was) was to 
> control the switching between the arrays.

The O(1) design is pretty convoluted in that regard. In my scheduler,
the only purpose of the arrays is to renew time slices.

The fork/exit logic is added to make interactivity better. Ingo's
scheduler has similar equivalent logic.


> >If you put
> >a new child at the back of the queue, then your various interactive
> >shell commands that typically do a lot of dependant forking get slowed
> >right down behind your compile job. If you give a new child its own
> >timeslice irrespective of the parent, then you have things like 'make'
> >(which doesn't use a lot of CPU time) spawning off lots of high
> >priority children.
> 
> This is an artefact of trying to control nice using time slices while 
> using them for controlling array switching and whatever else they were 
> being used for.  Priority (static and dynamic) is the the best way to 
> implement nice.

I don't like the timeslice based nice in mainline. It's too nasty
with latencies. nicksched is far better in that regard IMO.

But I don't know how you can assert a particular way is the best way
to do something.


> >You need to do _something_ (Ingo's does). I don't see why this would
> >be tied with a dual array. FWIW, mine doesn't do anything on exit()
> >like most others, but it may need more tuning in this area.
> >
> >
> >>This disregard for the dual array mechanism has prevented me from 
> >>looking at the rest of your scheduler in any great detail so I can't 
> >>comment on any other ideas that may be in there.
> >
> >Well I wasn't really asking you to review it. As I said, everyone
> >has their own idea of what a good design does, and review can't really
> >distinguish between the better of two reasonable designs.
> >
> >A fair evaluation of the alternatives seems like a good idea though.
> >Nobody is actually against this, are they?
> 
> No.  It would be nice if the basic ideas that each scheduler tries to 
> implement could be extracted and explained though.  This could lead to a 
> melding of ideas that leads to something quite good.
> 
> >
> >
> >>>I haven't looked at Con's ones for a while,
> >>>but I believe they are also much more straightforward than mainline...
> >>I like Con's scheduler (partly because it uses a single array) but 
> >>mainly because it's nice and simple.  However, his earlier schedulers 
> >>were prone to starvation (admittedly, only if you went out of your way 
> >>to make it happen) and I tried to convince him to use the anti 
> >>starvation mechanism in my SPA schedulers but was unsuccessful.  I 
> >>haven't looked at his latest scheduler that sparked all this furore so 
> >>can't comment on it.
> >
> >I agree starvation or unfairness is unacceptable for a new scheduler.
> >
> >
> >>>For example, let's say all else is equal between them, then why would
> >>>we go with the O(logN) implementation rather than the O(1)?
> >>In the highly unlikely event that you can't separate them on technical 
> >>grounds, Occam's razor recommends choosing the simplest solution. :-)
> >
> >O(logN) vs O(1) is technical grounds.
> 
> In that case I'd go O(1) provided that the k factor for the O(1) wasn't 
> greater than O(logN)'s k factor multiplied by logMaxN.

Yes, or even significantly greater around typical large sizes of N.
