Return-Path: <linux-kernel-owner+w=401wt.eu-S1754719AbYH1OP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719AbYH1OP0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 10:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752742AbYH1OPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 10:15:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:36517 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbYH1OPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 10:15:16 -0400
Date: Thu, 28 Aug 2008 10:15:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Stefani Seibold <stefani@seibold.net>,
       Dario Faggioli <raistlin@linux.it>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 6/6] sched: disabled rt-bandwidth by default
Message-ID: <20080828141513.GC31444@goodmis.org>
References: <20080819103301.787700742@chello.nl> <20080819103844.459178947@chello.nl> <20080819110557.GA18608@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080819110557.GA18608@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2008 at 01:05:57PM +0200, Ingo Molnar wrote:
> 
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > Disable bandwidth control by default.
> > 
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > ---
> >  kernel/sched.c |   17 +++++++----------
> >  1 file changed, 7 insertions(+), 10 deletions(-)
> > 
> > Index: linux-2.6/kernel/sched.c
> > ===================================================================
> > --- linux-2.6.orig/kernel/sched.c
> > +++ linux-2.6/kernel/sched.c
> > @@ -824,9 +824,9 @@ static __read_mostly int scheduler_runni
> >  
> >  /*
> >   * part of the period that we allow rt tasks to run in us.
> > - * default: 0.95s
> > + * default: inf
> >   */
> > -int sysctl_sched_rt_runtime = 950000;
> > +int sysctl_sched_rt_runtime = -1;
> 
> The fixes look good to me, but this enabling of infinite RT task lockups 
> is not an improvement.
> 
> The thing is, i got far more bugreports about locked up RT tasks where 
> the lockup was unintentional, than real bugreports about anyone 
> _intending_ for the whole box to come to a grinding halt because a 
> high-prio RT tasks is monopolizing the CPU.
> 
> In fact there's only been this artificial test so far.
> 
> So could you please just increase the chunking to 10 seconds or so, from 
> the current 1 second? Anyone locking up the system for more than 10 
> seconds via an RT task has to deal with many other issues already.
> 
> I.e. keep the system borderline debuggable (up to 10 seconds delays are 
> _not_ nice so people will notice) - but it's still a marked improvement 
> from completly locked up desktops.
> 
> And those who really need longer than 10 second periods can set it 
> higher, or even (if they want to live dangerously or run POSIX 
> conformance tests) make it infinite (set it to -1) - and will have to 
> deal with other things like the softlockup watchdog as well.

My biggest concern about adding a limit to FIFO is that an RT developer
would spend weeks trying to debug their system wondering why their
planned CPU RT hog, is being preempted by a non-RT task.

For this, if this time limit does kick in, we should at the very least
print something out to let the user know this happened. After all, this
is more of a safety net anyway, and if we are hitting the limit, the
user should be notified. Perhaps even tell the user that if this
behaviour is expected, to up the sysctl <var> by more.

Peter, another question. Is this limit for a single RT task running, or
all RT tasks. I'm assuming here that it is a single RT task. If you have
20 RT tasks all running, would this let non RT tasks in? In that case,
this could be even a bigger issues.

Thanks,

-- Steve

