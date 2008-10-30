Return-Path: <linux-kernel-owner+w=401wt.eu-S1757963AbYJ3RRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757963AbYJ3RRW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 13:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753188AbYJ3RRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 13:17:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:58904 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759AbYJ3RRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 13:17:12 -0400
Subject: Deadline scheduling (was: Re: Rearranging layout of code in the
 scheduler)
From: Peter Zijlstra <peterz@infradead.org>
To: faggioli@gandalf.sssup.it
Cc: henrik@austad.us, Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>, fabio@gandalf.sssup.it,
       Michael Trimarchi <trimarchimichael@yahoo.it>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       "gregory.haskins" <gregory.haskins@gmail.com>
In-Reply-To: <20081030174925.36023f19jy3o832t@feanor.sssup.it>
References: <200810281634.11285.henrik@austad.us>
	 <1225212627.15763.16.camel@lappy.programming.kicks-ass.net>
	 <20081030174925.36023f19jy3o832t@feanor.sssup.it>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 30 Oct 2008 18:17:14 +0100
Message-Id: <1225387034.7803.182.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-30 at 17:49 +0100, faggioli@gandalf.sssup.it wrote:
> Quoting Peter Zijlstra <peterz@infradead.org>:
> >> Before I dive in, I should probably justify my motivations for writing
> >> this email. I'm working away on implementing an EDF scheduler for real
> >> time tasks in the kernel. This again leads to hacking at the existing
> >> source as I'm not about to toss out the entire scheduler - just replace
> >> (by some Kconfig switch) the RR/FIFO classes. As to why I'm looking at
> >> EDF, I think the answer to that is a bit too long (and not appropriate
> >> for this email anyway) so I'll leave that part out.
> Well, I understand that, but it could be interesting... At least to me. :-)
> 
> > You and a few other folks.
> Yes, here we are! :-)
> 
> We also have some code, but it still is highly experimental and we are  
> deeply rearranging it.
> 
> > The most interesting part of EDF is not the
> > actual scheduler itself (although there are fun issues with that as
> > well), but extending the Priority Inheritance framework to deal with all
> > the fun cases that come with EDF.
> The main problem is that, especially to deal with SMP systems, we also  
> need to investigate theoretical issues and find out what the best  
> approach could be.
> 
> > Well, adding a sched_class, no need to replace anything besides that.
> >
> I'm not saying anything in possible sched.c and sched_{fair|rt}.c code  
> rearranging, I also only wonder why replacing fixed priority RT  
> scheduling with EDF.
> 
> I think they both could be in... Maybe we can discuss on where, I mean  
> on which position, in the linked list of scheduling classes, to put  
> each of them.

Right, ideally I'd like to see 2 EDF classes on top of FIFO, so that we
end up with the following classes

  hedf     - hard EDF
  sedf     - soft EDF (bounded tardiness)
  fifo/rr  - the current static priority scheduler
  fair     - the current proportional fair scheduler
  idle     - the idle scheduler

The two edf classes must share some state, so that the sedf class knows
about the utilisation consumed by hedf, and the main difference between
these two classes is the schedulability test.

[ NOTE: read EDF as any deadline scheduler, so it might as well be
        pfair PD^2 scheduler. ]

The few problems this gives are things like kstopmachine and the
migration threads, which should run at the max priority available on the
system.

[ NOTE: although possibly we could make an exception for the migration
        threads, as we generally don't need to migrate running RT tasks]

Perhaps we can introduce another class on top of hedf which will run
just these two tasks and is not exposed to userspace (yes, I understand
it will ruin just about any schedulability analysis).

Which leaves us with the big issue of priority inversion ;-)

We can do deadline inheritance and bandwidth inheritance by changing
plist to a rb-tree/binary heap and mapping the static priority levels
somewhere at the back and also propagating the actual task responsible
for the boost down the chain (so as to be able to do bandwidth
inheritance).

>From what I gather the sssup folks are doing that, although they
reported that DI between disjoint schedule domains (partitions) posed an
interesting problem.

Personally I'd like to see the full priority inversion issue solved by
something like the proxy execution protocol, however the SMP extension
thereof seems to be a tad expensive - found a book on graph theory, all
that remains is finding time to read it :-)

The advantage of proxy execution is that its fully invariant to the
schedule function and thus even works for proportional fair schedulers
and any kind of scheduler hierarchy.


