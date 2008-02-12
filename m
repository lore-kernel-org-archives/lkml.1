Return-Path: <linux-kernel-owner+w=401wt.eu-S1764347AbYBLSNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764347AbYBLSNc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 13:13:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764232AbYBLSNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 13:13:07 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40028 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763879AbYBLSNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 13:13:05 -0500
Date: Tue, 12 Feb 2008 10:11:13 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] kgdb-light -v10
In-Reply-To: <20080212182024.GA4940@one.firstfloor.org>
Message-ID: <alpine.LFD.1.00.0802121001180.2920@woody.linux-foundation.org>
References: <20080211162141.GA31434@elte.hu> <20080211171039.GA20446@one.firstfloor.org> <20080211230335.GA16102@elte.hu> <20080212100327.GA30873@one.firstfloor.org> <20080212112747.GA1569@elte.hu> <20080212121903.GA419@one.firstfloor.org> <20080212123839.GA15360@elte.hu>
 <20080212135027.GA1343@one.firstfloor.org> <20080212152846.GC3078@elte.hu> <alpine.LFD.1.00.0802120829410.2920@woody.linux-foundation.org> <20080212182024.GA4940@one.firstfloor.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 12 Feb 2008, Andi Kleen wrote:
>
> >  - the kgdb commands should always act on the *current* CPU only
> >  - add one command that says "switch over to CPU #n" which just releases 
> >    the current CPU and sends an IPI to that CPU #n (no timeouts, no 
> >    synchronous waiting, no nothing - it's like a "continue", but with a 
> >    "try to get the other CPU to stop"
> 
> The problem I see here is that the kernel tends to get badly confused
> if one CPU just stops responding. At some point someone does an global
> IPI and that then hangs.  You would need to hotunplug the CPU which
> is theoretically possible, but quite intrusive.

You're thinking about this totally *wrong*.

You definitely do not want to hot-unplug or isolate anything at all. 
That's explicitly against the whole point of kgdb not changing what it is 
trying to measure.

Just let the other CPU's hang naturally if they need to wait for IPI's 
etc. What's the downside? That's what you were trying to do in the first 
place by havign the kgdb callback!

So you can't have it both ways. Either serializing other cpu's with kgdb 
is good (the whole "kgdb_nmicallback" thing or whatever it was called), in 
which case it's also perfectly ok to just let them stop when waiting for 
IPI's.

My point was *not* that kgdb should take control of one CPU, and the other 
CPU's should continue to work as if nothing happened. That is insane and 
impossible (since you may be stopping a CPU while it holds central 
spinlocks etc). No, my point was that I think kgdb should be as light and 
non-intrusive as possible, and that any "higher level behaviour" (like the 
decision of whether to try to synchronize other CPU's or not) should be 
left to the debugger.

But only if that makes kgdb patches less intrusive!

In other words, I'm not at all trying to push any particular solution 
here, except for the "keep it simple, and anything even remotely debatable 
or intrusive to the system should be excised". And I wanted to point out 
that maybe all these timeout etc decisions can be pushed to the debugger.

So I think we can either:

 - have no timeouts or other fancy crap _at_all_, with very simple locking 
   (ie looks what v10 mostly seems to do)

 - or you do the fancy dance entirely in the remote debugger.

I don't care. The only thing I care about is that kgdb support never 
_ever_ shows up in any interesting code, and that it remains totally 
invisible to essentially all of the kernel except the place that would 
otherwise print out an oops.

And I absolutely don't want it to be fancy, I want it to be so simple that 
even _I_ can look at it and say "I think this is crap, but it's _trivial_ 
crap".

IOW: as long as people keep arguing about it, I sure as hell won't ever 
merge it. It needs to be so _obvious_ and so _minimal_ that I can feel 
that I finally don't need to care.

			Linus
