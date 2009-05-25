Return-Path: <linux-kernel-owner+w=401wt.eu-S1753345AbZEYLHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345AbZEYLHr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 07:07:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753037AbZEYLHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 07:07:31 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:38041 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980AbZEYLH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 07:07:29 -0400
Date: Mon, 25 May 2009 13:06:58 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Michael Abbott <michael@araneidae.co.uk>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [GIT PULL] cputime patch for 2.6.30-rc6
Message-ID: <20090525130658.20f4d682@skybase>
In-Reply-To: <Pine.LNX.4.64.0905200918170.14352@venus.araneidae.co.uk>
References: <20090518160904.7df88425@skybase>
	<1242660243.26820.439.camel@twins>
	<Pine.LNX.4.64.0905181717001.21259@venus.araneidae.co.uk>
	<20090519110047.2e0d9e55@skybase>
	<1242725488.26820.485.camel@twins>
	<20090520100912.4f9c2037@skybase>
	<Pine.LNX.4.64.0905200918170.14352@venus.araneidae.co.uk>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 May 2009 09:44:33 +0100 (BST)
Michael Abbott <michael@araneidae.co.uk> wrote:

> On Wed, 20 May 2009, Martin Schwidefsky wrote:
> > On Tue, 19 May 2009 11:31:28 +0200 Peter Zijlstra <peterz@infradead.org> wrote:
> > > On Tue, 2009-05-19 at 11:00 +0200, Martin Schwidefsky wrote:
> > > > I don't see a problem here. In an idle multiple cpu system there IS 
> > > > more idle time than elapsed time. What would makes sense is to 
> > > > compare elapsed time * #cpus with the idle time. But then there is 
> > > > cpu hotplug which forces you to look at the delta of two measuring 
> > > > points where the number of cpus did not change.
> > 
> > Well, we better distinguish between the semantical problem and the
> > performance consideration, no? One thing is what the proc field is
> > supposed to contain, the other is how fast you can do it.
> > 
> > I have been refering to the semantical problem, but your point with the 
> > performance is very valid as well. So
> > 
> > 1) are we agreed that the second field of /proc/uptime should contain 
> > the aggregate idle time of all cpus?
> 
> I think that this very simple node (only two fields, let me call them 
> uptime and idle) should be amenable to simple interpretation.  In 
> particular, I'd like to be able to compute
> 
> 	busy = uptime - idle

On a single cpu system this works. On an SMP with cpu hotplug it breaks.

> In other words, idle should be in the same units of time as uptime, which 
> is to say it should be in units of elapsed time, not aggregate CPU time.  

They are, no? The idle time is in units of cputime but what is measured
is wall-clock time. In fact the idle time is the result of the
calculation
	idle = wall_clock - user - nice - system -
		 iowait - irq - softirq - steal - guest
Trouble is that this is fundamentally per cpu. Just showing a single
cpu is kaputt, showing the sum of all cpus divided by the number of
cpus has problem with cpu hotplug. That leaves the simple approach to
just do the sum over all cpus.
 
> Thus, the patch to /proc/uptime that we're discussing has, in the view I'm 
> trying to argue, replaced a clearly broken idle field with a more subtly 
> broken version.

What is the least broken version?
 
> The strongest point in my case is this: the first field is in units of 
> elapsed wall clock time, and therefore the second should also be.  Of 
> course, established practice here is also important, but there is some 
> ambiguity in the man pages I'm looking at -- this field is described in 
> proc(5) as:
> 
> 	the amount of time spent in idle process (seconds)
> 
> Not aggregate CPU time, but elapsed time, I think is meant here, but the 
> wording is ambiguous.  Grepping for uptime in Documentation doesn't come 
> up with anything clear either, but I can quote old (2.6.9) precedent 
> (don't have a more recent multi-core system to hand).

In my view of the world the idle field IS wall clock. That is how we
calculate it on s390.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

