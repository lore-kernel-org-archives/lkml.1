Return-Path: <linux-kernel-owner+w=401wt.eu-S1756760AbZETIo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760AbZETIo4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 04:44:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754932AbZETIou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 04:44:50 -0400
Received: from araneidae.co.uk ([62.3.233.233]:1920 "EHLO araneidae.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754444AbZETIot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 04:44:49 -0400
Date: Wed, 20 May 2009 09:44:33 +0100 (BST)
From: Michael Abbott <michael@araneidae.co.uk>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
cc: Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [GIT PULL] cputime patch for 2.6.30-rc6
In-Reply-To: <20090520100912.4f9c2037@skybase>
Message-ID: <Pine.LNX.4.64.0905200918170.14352@venus.araneidae.co.uk>
References: <20090518160904.7df88425@skybase> <1242660243.26820.439.camel@twins>
 <Pine.LNX.4.64.0905181717001.21259@venus.araneidae.co.uk>
 <20090519110047.2e0d9e55@skybase> <1242725488.26820.485.camel@twins>
 <20090520100912.4f9c2037@skybase>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 May 2009, Martin Schwidefsky wrote:
> On Tue, 19 May 2009 11:31:28 +0200 Peter Zijlstra <peterz@infradead.org> wrote:
> > On Tue, 2009-05-19 at 11:00 +0200, Martin Schwidefsky wrote:
> > > I don't see a problem here. In an idle multiple cpu system there IS 
> > > more idle time than elapsed time. What would makes sense is to 
> > > compare elapsed time * #cpus with the idle time. But then there is 
> > > cpu hotplug which forces you to look at the delta of two measuring 
> > > points where the number of cpus did not change.
> 
> Well, we better distinguish between the semantical problem and the
> performance consideration, no? One thing is what the proc field is
> supposed to contain, the other is how fast you can do it.
> 
> I have been refering to the semantical problem, but your point with the 
> performance is very valid as well. So
> 
> 1) are we agreed that the second field of /proc/uptime should contain 
> the aggregate idle time of all cpus?

I think that this very simple node (only two fields, let me call them 
uptime and idle) should be amenable to simple interpretation.  In 
particular, I'd like to be able to compute

	busy = uptime - idle

In other words, idle should be in the same units of time as uptime, which 
is to say it should be in units of elapsed time, not aggregate CPU time.  

As far as I can see, that is how it used to be (at least, that's how it 
behaves on a dual core processor running a hugely patched 2.6.9 kernel 
that I'm looking at here).

Thus, the patch to /proc/uptime that we're discussing has, in the view I'm 
trying to argue, replaced a clearly broken idle field with a more subtly 
broken version.

The strongest point in my case is this: the first field is in units of 
elapsed wall clock time, and therefore the second should also be.  Of 
course, established practice here is also important, but there is some 
ambiguity in the man pages I'm looking at -- this field is described in 
proc(5) as:

	the amount of time spent in idle process (seconds)

Not aggregate CPU time, but elapsed time, I think is meant here, but the 
wording is ambiguous.  Grepping for uptime in Documentation doesn't come 
up with anything clear either, but I can quote old (2.6.9) precedent 
(don't have a more recent multi-core system to hand).
