Return-Path: <linux-kernel-owner+w=401wt.eu-S1752262AbZH1KaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262AbZH1KaL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 06:30:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbZH1KaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 06:30:10 -0400
Received: from www.tglx.de ([62.245.132.106]:41391 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752213AbZH1KaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 06:30:09 -0400
Date: Fri, 28 Aug 2009 12:26:55 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Gregory Haskins <ghaskins@novell.com>
cc: Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Chris Friesen <cfriesen@nortel.com>, raz ben yehuda <raziebe@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       peterz@infradead.org, maximlevitsky@gmail.com, efault@gmx.de,
       wiseman@macs.biu.ac.il, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: Re: RFC: THE OFFLINE SCHEDULER
In-Reply-To: <4A975CC4.1090208@novell.com>
Message-ID: <alpine.LFD.2.00.0908281218560.2888@localhost.localdomain>
References: <1251282598.3514.20.camel@raz>  <alpine.DEB.1.10.0908260943090.9924@gentwo.org>  <1251297910.1791.22.camel@maxim-laptop> <1251298443.4791.7.camel@raz>  <1251300625.18584.18.camel@twins>  <alpine.DEB.1.10.0908261136590.9933@gentwo.org> 
 <1251302598.18584.31.camel@twins>  <alpine.DEB.1.10.0908261211340.9933@gentwo.org>  <20090826180407.GA13632@elte.hu>  <alpine.DEB.1.10.0908261509580.9933@gentwo.org>  <20090826193252.GA14721@elte.hu>  <alpine.DEB.1.10.0908261627110.5554@gentwo.org> 
 <20090826135041.e6169d18.akpm@linux-foundation.org>  <4A95A5EE.90400@nortel.com> <1251322663.3882.48.camel@raz> <4A96B997.1070001@nortel.com> <alpine.DEB.1.10.0908271257270.17470@gentwo.org> <alpine.LFD.2.00.0908272242500.2888@localhost.localdomain>
 <4A97071F.5070804@novell.com> <4A973DAE.4020508@redhat.com> <4A975025.8030500@novell.com> <4A975CC4.1090208@novell.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Aug 2009, Gregory Haskins wrote:
> > However, and to what I believe is your point: its not entirely clear to
> > me what impact, if any, there would be w.r.t. any _other_ events that
> > may be driven off of the scheduler tick (i.e. events other than
> > scheduling policies, like timeslice expiration, etc).  Perhaps someone
> > else like Thomas, Ingo, or Peter have some input here.
> > 
> > I guess the specific question to ask is: Does the scheduler tick code
> > have any role other than timeslice policies and updating accounting
> > information?  Examples would include timer-expiry, for instance.  I
> > would think most of this logic is handled by finer grained components
> > like HRT, but I am admittedly ignorant of the actual timer voodoo ;)

There is not much happening in the scheduler tick:

 - accounting of CPU time. this can be delegated to some other CPU
   as long as the user space task is running and consuming 100%

 - timer list timers. If there is no service/device active on that CPU
   then there are no timers to run

 - rcu call backs. Same as above, but might need some tweaking.

 - printk tick. Not really interesting

 - scheduler time slicing. Not necessary in such a context

 - posix cpu timers. Only interesting when the application uses them

So there is not much which needs the tick in such a scenario. 

Of course we'd need to exclude that CPU from the do_timer duty as
well.

> Thinking about this idea some more:  I can't see why this isn't just a
> trivial variation of the nohz idle code already in mainline.  In both
> cases (idle and FIFO tasks) the cpu is "consumed" 100% by some arbitrary
> job (spinning/HLT for idle, RT thread for FIFO) while we have the
> scheduler tick disabled.  The only real difference is a matter of
> power-management (HLT/mwait go to sleep-states, whereas spinning/rt-task
> run full tilt).
> 
> Therefore the answer may be as simple as bracketing the FIFO task with
> tick_nohz_stop_sched_tick() + tick_nohz_restart_sched_tick().  The nohz
> code will probably need some minor adjustments so it is not assuming
> things about the state being "idle" (e.g. "isidle") for places when it
> matters (idle_calls++ stat is one example).

Yeah, it's similar to what we do in nohz idle already, but we'd need
to split out some of the functions very carefully to reuse them.

> Potential problems:
> 
> a) disabling/renabling the tick on a per-RT task schedule() may prove to
> be prohibitively expensive.

For a single taks consuming 100% CPU it is a non problem. You disable
it once. But yes on a standard system this needs to be investigated.
 
> b) we will need to make sure the rt-bandwidth protection mechanism is
> defeated so the task is allowed to consume 100% bandwidth.
> 
> Perhaps these states should be in the cpuset/root-domain, and configured
> when you create the partition (e.g. "tick=off", "bandwidth=off" makes it
> an "offline" set).

That makes sense and should not be rocket science to implement.

Thanks,

	tglx
