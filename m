Return-Path: <linux-kernel-owner+w=401wt.eu-S1753490AbYJ1Quz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490AbYJ1Quz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 12:50:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752435AbYJ1Qus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 12:50:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:54263 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbYJ1Quq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 12:50:46 -0400
Subject: Re: Rearranging layout of code in the scheduler
From: Peter Zijlstra <peterz@infradead.org>
To: henrik@austad.us
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>,
       Dario <faggioli@gandalf.sssup.it>
In-Reply-To: <200810281634.11285.henrik@austad.us>
References: <200810281634.11285.henrik@austad.us>
Content-Type: text/plain
Date: Tue, 28 Oct 2008 17:50:27 +0100
Message-Id: <1225212627.15763.16.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-28 at 16:34 +0100, Henrik Austad wrote:
> Hello, 
> 
> Before I dive in, I should probably justify my motivations for writing
> this email. I'm working away on implementing an EDF scheduler for real
> time tasks in the kernel. This again leads to hacking at the existing
> source as I'm not about to toss out the entire scheduler - just replace
> (by some Kconfig switch) the RR/FIFO classes. As to why I'm looking at
> EDF, I think the answer to that is a bit too long (and not appropriate
> for this email anyway) so I'll leave that part out.

You and a few other folks. The most interesting part of EDF is not the
actual scheduler itself (although there are fun issues with that as
well), but extending the Priority Inheritance framework to deal with all
the fun cases that come with EDF.

> However, what I do mean to discuss is the current state of the scheduler
> code. Working through the code, I must say I'm really impressed. The
> code is clean, it is well thought out and the new approach with
> sched_class and sched_entity makes it very modular. However, digging
> deeper, I find myself turning more and more desperate, looking over my
> shoulder for a way out.
> 
> Now, I'm in no doubt that the code *is* modular, that it *is* clean and
> tidy, but coming from outside, it is not that easy to grasp it all. And,
> it is not just the sheer size and complexity of the scheduler itself,
> but also a lot with how the code is arranged.
> 
> For instance, functions like free_fair_sched_group,
> alloc_fair_sched_group etc - does IMHO belong in sched_fair.c and not in
> sched.c. The same goes for several rt-functions and structs.
> 
> So, if one drew up a list over all events that would cause functions in
> sched.c to be called, this could be used to make a minimized 'interface'
> and then let the scheduler call the appropriate function for the given
> class in the same fashion sched_tick is used today. 

I'd start out small by moving the functions to the right file. After
that you could look at providing methods in the sched_class.

> What I would like, is to rip out all the *actual* scheduling logic and
> put this in sched_[fair|rt].c and let sched be purely event-driven
> (which would be a nice design goal in itself). This would also lead to
> sched_[fair|rt].h, where the structs, macros, defines etc can be
> defined. Today these are defined in just about everywhere, making the
> code unnecessary complicated (I'm not going to say messy since I'm not
> *that* senior to kernel coding :-))

You might need to be careful there, or introduce sched_(fair|rt).h for
those.

> Why not use the sched_class for all that it's worth - make the different
> classes implement a set of functions and let sched.c be oblivious to
> what's going on other than turning the machinery around?

Sounds good, its been on the agenda for a while, but nobody ever got
around to it.

Other cleanups that can be done are:
 - get rid of all the load balance iterator stuff and move
   that all into sched_fair

 - extract the common sched_entity members and create:

   struct {
	struct sched_entity_common common;
	union {
		struct sched_entity fair;
		struct sched_rt_entity rt;
	}
   }

> Is this something worth pursuing? I mean, the scheduler *does* work, and
> if it ain't broken, don't fix it. However, I have a strong feeling that
> this can be done a lot cleaner, not to mention, changing from one type
> of scheduler to another will be much easier. :-)

Well, adding a sched_class, no need to replace anything besides that.



