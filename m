Return-Path: <linux-kernel-owner+w=401wt.eu-S1757917AbZKXGxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757917AbZKXGxR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 01:53:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755630AbZKXGxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 01:53:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44656 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754114AbZKXGxQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 01:53:16 -0500
Date: Tue, 24 Nov 2009 07:53:22 +0100
From: Nick Piggin <npiggin@suse.de>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: newidle balancing in NUMA domain?
Message-ID: <20091124065322.GC20981@wotan.suse.de>
References: <20091123112228.GA2287@wotan.suse.de> <1258987059.6193.73.camel@marge.simson.net> <20091123151152.GA19175@wotan.suse.de> <1258989704.4531.574.camel@laptop> <20091123152931.GD19175@wotan.suse.de> <1258991617.6182.21.camel@marge.simson.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258991617.6182.21.camel@marge.simson.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 23, 2009 at 04:53:37PM +0100, Mike Galbraith wrote:
> On Mon, 2009-11-23 at 16:29 +0100, Nick Piggin wrote:
> 
> > So basically about the least well performing or scalable possible
> > software architecture. This is exactly the wrong thing to optimise
> > for, guys.
> 
> Hm.  Isn't fork/exec our daily bread?

No. Not for handing out tiny chunks of work and attempting to do
them in parallel. There is this thing called Amdahl's law, and if
you write a parallel program that wantonly uses the heaviest
possible primitives in its serial sections, then it doesn't deserve
to go fast.

That is what IPC or shared memory is for. Vastly faster, vastly more
scalable, vastly easier for scheduler balancing (both via manual or
automatic placement).


> > The fact that you have to coax the scheduler into touching heaps
> > more remote cachelines and vastly increasing the amount of inter
> > node task migration should have been kind of a hint.
> > 
> > 
> > > Fork balancing only works until all cpus are active. But once a core
> > > goes idle it's left idle until we hit a general load-balance cycle.
> > > Newidle helps because it picks up these threads from other cpus,
> > > completing the current batch sooner, allowing the program to continue
> > > with the next.
> > > 
> > > There's just not much you can do from the fork() side of things once
> > > you've got them all running.
> > 
> > It sounds like allowing fork balancing to be more aggressive could
> > definitely help.
> 
> It doesn't. Task which is _already_ forked, placed and waiting over
> yonder can't do spit for getting this cpu active again without running
> so he can phone home.  This isn't only observable with x264, it just
> rubs our noses in it.  It is also quite observable in a kbuild.  What if
> the waiter is your next fork?

I'm not saying that vastly increasing task movement between NUMA
nodes won't *help* some workloads. Indeed they tend to be ones that
aren't very well parallelised (then it becomes critical to wake up
any waiter if a CPU becomes free because it might be holding a
heavily contended resource).

But can you apprciate that these are at one side of the spectrum of
workloads, and that others will much prefer to keep good affinity?
No matter how "nice" your workload is, you can't keep traffic off
the interconnect if the kernel screws up your numa placement.

And also, I'm not saying that we were at _exactly_ the right place
before and there was no room for improvement, but considering that
we didn't have a lot of active _regressions_ in the balancer, we
can really use that to our favour and concentrate changes in code
that does have regressions. And be really conservative and careful
with changes to the balancer.

