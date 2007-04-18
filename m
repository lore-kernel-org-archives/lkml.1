Return-Path: <linux-kernel-owner+w=401wt.eu-S2992907AbXDRRYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992907AbXDRRYg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 13:24:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992909AbXDRRYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 13:24:36 -0400
Received: from smtp.osdl.org ([65.172.181.24]:39249 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992907AbXDRRYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 13:24:35 -0400
Date: Wed, 18 Apr 2007 10:22:59 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Matt Mackall <mpm@selenic.com>
cc: Nick Piggin <npiggin@suse.de>, William Lee Irwin III <wli@holomorphy.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       Ingo Molnar <mingo@elte.hu>, ck list <ck@vds.kolivas.org>,
       Bill Huey <billh@gnuppy.monkey.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
 Scheduler [CFS]
In-Reply-To: <20070418152355.GU11115@waste.org>
Message-ID: <alpine.LFD.0.98.0704181012470.2828@woody.linux-foundation.org>
References: <20070417060955.GO8915@holomorphy.com> <20070417061503.GC1057@wotan.suse.de>
 <20070417062621.GL2986@holomorphy.com> <20070417070155.GF1057@wotan.suse.de>
 <20070417213954.GE11166@waste.org> <20070418031511.GA18452@wotan.suse.de>
 <20070418043831.GR11115@waste.org> <20070418050024.GF18452@wotan.suse.de>
 <20070418055525.GS11115@waste.org> <alpine.LFD.0.98.0704180742470.2828@woody.linux-foundation.org>
 <20070418152355.GU11115@waste.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 18 Apr 2007, Matt Mackall wrote:
>
> On Wed, Apr 18, 2007 at 07:48:21AM -0700, Linus Torvalds wrote:
> > And "fairness by euid" is probably a hell of a lot easier to do than 
> > trying to figure out the wakeup matrix.
> 
> For the record, you actually don't need to track a whole NxN matrix
> (or do the implied O(n**3) matrix inversion!) to get to the same
> result.

I'm sure you can do things differently, but the reason I think "fairness 
by euid" is actually worth looking at is that it's pretty much the 
*identical* issue that we'll have with "fairness by virtual machine" and a 
number of other "container" issues.

The fact is:

 - "fairness" is *not* about giving everybody the same amount of CPU time 
   (scaled by some niceness level or not). Anybody who thinks that is 
   "fair" is just being silly and hasn't thought it through.

 - "fairness" is multi-level. You want to be fair to threads within a 
   thread group (where "process" may be one good approximation of what a 
   "thread group" is, but not necessarily the only one).

   But you *also* want to be fair in between those "thread groups", and 
   then you want to be fair across "containers" (where "user" may be one 
   such container).

So I claim that anything that cannot be fair by user ID is actually really 
REALLY unfair. I think it's absolutely humongously STUPID to call 
something the "Completely Fair Scheduler", and then just be fair on a 
thread level. That's not fair AT ALL! It's the anti-thesis of being fair!

So if you have 2 users on a machine running CPU hogs, you should *first* 
try to be fair among users. If one user then runs 5 programs, and the 
other one runs just 1, then the *one* program should get 50% of the CPU 
time (the users fair share), and the five programs should get 10% of CPU 
time each. And if one of them uses two threads, each thread should get 5%.

So you should see one thread get 50& CPU (single thread of one user), 4 
threads get 10% CPU (their fair share of that users time), and 2 threads 
get 5% CPU (the fair share within that thread group!).

Any scheduling argument that just considers the above to be "7 threads 
total" and gives each thread 14% of CPU time "fairly" is *anything* but 
fair. It's a joke if that kind of scheduler then calls itself CFS!

And yes, that's largely what the current scheduler will do, but at least 
the current scheduler doesn't claim to be fair! So the current scheduler 
is a lot *better* if only in the sense that it doesn't make ridiculous 
claims that aren't true!

			Linus
