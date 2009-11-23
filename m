Return-Path: <linux-kernel-owner+w=401wt.eu-S1755588AbZKWP33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588AbZKWP33 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 10:29:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755474AbZKWP31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 10:29:27 -0500
Received: from cantor.suse.de ([195.135.220.2]:38378 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755468AbZKWP30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 10:29:26 -0500
Date: Mon, 23 Nov 2009 16:29:31 +0100
From: Nick Piggin <npiggin@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: newidle balancing in NUMA domain?
Message-ID: <20091123152931.GD19175@wotan.suse.de>
References: <20091123112228.GA2287@wotan.suse.de> <1258987059.6193.73.camel@marge.simson.net> <20091123151152.GA19175@wotan.suse.de> <1258989704.4531.574.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258989704.4531.574.camel@laptop>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 23, 2009 at 04:21:44PM +0100, Peter Zijlstra wrote:
> On Mon, 2009-11-23 at 16:11 +0100, Nick Piggin wrote:
> 
> > Wait, you say it was activated to improve fork/exec CPU utilization?
> > For the x264 load? What do you mean by this? Do you mean it is doing
> > a lot of fork/exec/exits and load is not being spread quickly enough?
> > Or that NUMA allocations get screwed up because tasks don't get spread
> > out quickly enough before running?
> > 
> > In either case, I think newidle balancing is maybe not the right solution.
> > newidle balancing only checks the system state when the destination
> > CPU goes idle. fork events increase load at the source CPU. So for
> > example if you find newidle helps to pick up forks, then if the
> > newidle event happens to come in before the fork, we'll have to wait
> > for the next rebalance event.
> > 
> > So possibly making fork/exec balancing more aggressive might be a
> > better approach. This can be done by reducing the damping idx, or
> > perhaps some other conditions to reduce eg imbalance_pct or something
> > for forkexec balancing. Probably needs some studying of the workload
> > to work out why forkexec is failing.
> 
> >From what I can remember from that workload it basically spawns tons of
> very short lived threads, waits for a bunch to complete, goto 1.

So basically about the least well performing or scalable possible
software architecture. This is exactly the wrong thing to optimise
for, guys.

The fact that you have to coax the scheduler into touching heaps
more remote cachelines and vastly increasing the amount of inter
node task migration should have been kind of a hint.


> Fork balancing only works until all cpus are active. But once a core
> goes idle it's left idle until we hit a general load-balance cycle.
> Newidle helps because it picks up these threads from other cpus,
> completing the current batch sooner, allowing the program to continue
> with the next.
> 
> There's just not much you can do from the fork() side of things once
> you've got them all running.

It sounds like allowing fork balancing to be more aggressive could
definitely help.


> > OK. This would be great if fixing up involves making things closer
> > to what they were rather than adding more complex behaviour on top
> > of other changes that broke stuff. And doing it in 2.6.32 would be
> > kind of nice...
> 
> .32 is kind of closed, with us being at -rc8.

It's a bad regression though.

