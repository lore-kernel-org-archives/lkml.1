Return-Path: <linux-kernel-owner+w=401wt.eu-S1757495AbYJ3TBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495AbYJ3TBS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 15:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752948AbYJ3TBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 15:01:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:32932 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374AbYJ3TBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 15:01:01 -0400
Date: Thu, 30 Oct 2008 15:00:59 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ring-buffer: add paranoid checks for loops
In-Reply-To: <20081030184552.GC17822@elte.hu>
Message-ID: <alpine.DEB.1.10.0810301452070.15853@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0810291439460.13214@gandalf.stny.rr.com> <20081030184552.GC17822@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 30 Oct 2008, Ingo Molnar wrote:
> 
> hm, all those magic constants look a bit like voodoo and make the 
> patch ugly, and people who read this will be confused about the 
> purpose for sure.

Point taken.

> 
> But the checks are still worth having in practice. So could you please 
> improve the comments, to come up with some tangible calculation that 
> leads to these constants?
> 
> For example the '1000' constant, how did you come to that? Could you 
> estimate what type of interrupt storm is needed to trigger it falsely? 
> So instead of this comment:

My original number was 100,000, but I thought that a bit high ;-)
Since it is OK for an interrupt to preempt this code and perform a trace, 
which would make the condition fail by the one being preempted. The 
likelyhood of an interrupt coming in at that location 1000 times in a row 
seems to be awefully low. It's not enough that a 1000 interrupts come in, 
the task being preempted must loop 1000 times and have a trace interrupt 
cause the condition to fail each time. I'll explain it this way in the 
comments.

I picked a big number because I can see a traced interrupt that is very 
active causing several interruptions in this code.

> 
> > +	 * If we loop here 1,000 times, that means we are either
> > +	 * in an interrupt storm, or we have something buggy.
> > +	 * Bail!
> 
> something like this might look more acceptable:
> 
> > +	 * If we loop here 1,000 times, that means we are either
> > +	 * in an interrupt storm that preempted the same trace-entry
> > +	 * attempt 1000 times in a row, or we have a bug in the tracer.
> > +	 * Bail!
> 
> i.e. please exaplain every single magic number there so that it can be 
> followed how you got to that number, and what precise effects that 
> number has.
> 
> In the cases where you just guessed a number based on experiments, 
> please think it through and insert an analysis about the effects of 
> that number.
> 
> Would this be doable?

Again, there are small "allowable" races that causes the code to loop a 
few times.  I'll try to explain them a bit better in the comments.
There's small races between the reader and writer that can hit just right 
to cause a "loop again". But these chances are much smaller than the 
interrupt tracing situation.

I'll look deeper at the reasons for the races and explain them a bit 
better.

Thanks,

-- Steve

