Return-Path: <linux-kernel-owner+w=401wt.eu-S1754032AbZGCKNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032AbZGCKNY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 06:13:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbZGCKNR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 06:13:17 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49108 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752447AbZGCKNQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 06:13:16 -0400
Date: Fri, 3 Jul 2009 12:10:14 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
       andi@firstfloor.org, akpm@linux-foundation.org, earl_chew@agilent.com,
       Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH 3/3] exec: Allow do_coredump to wait for user space
	pipe readers to complete (v6)
Message-ID: <20090703101014.GA5764@redhat.com>
References: <20090622172818.GB14673@hmsreliant.think-freely.org> <20090701182834.GC31414@hmsreliant.think-freely.org> <20090701183707.GF31414@hmsreliant.think-freely.org> <20090702082854.GA15003@redhat.com> <20090702102936.GA8028@hmsreliant.think-freely.org> <20090702113610.GA3552@redhat.com> <20090702144422.GA8972@hmsreliant.think-freely.org> <20090702153736.GA15031@redhat.com> <20090702175314.GB8972@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090702175314.GB8972@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02, Neil Horman wrote:
>
> On Thu, Jul 02, 2009 at 05:37:36PM +0200, Oleg Nesterov wrote:
>
> > And I still can't understand your answer.
> >
> > My question is: why don't we do wait_for_dump_helpers() if core_pipe_limit == 0.
> >
> I'm sorry if I'm not explaining myself clearly.  Perhaps it would be best to say
> that I made this choice by design.  I wanted core_pipe_limit == 0 to be a
> special value in which we did 2 things:
> 1) Allowed an unlimited number of coredumps-to-pipes in parallel.
> 2) Disabled waiting on usermode helper processes to complete
>
> I understand what you're saying in that we block in ->core_wait() once the pipe
> fills up, but, as you see, we want to be able to wait after we've finished
> writing the core (for the reasons we've discussed).  Conversely, I see advantage
> in not waiting on usermode helpers if they have no need for additional crashing
> process info.  In short, I see an advantage to being able to disable this
> waiting feature from user space.  I.e allowing the crashing process to exit
> immediately while the user helper continues to run could be adventageous.
>
> Put it this way: If you want to be able to have an unlimited number of user mode
> helpers run in parallel and have the kernel wait on each of them, set
> core_pipe_limit to MAXINT, and you effectively have that situation.  Since
> core_pipe_limit == 0 effectively has to mean the same thing as core_pipe_limit
> == MAXINT (in that you have an effectively unbounded number of processes
> operating concurrently), why not add in this feature which allows you to disable
> the wait after ->core_dump() entirely.
>
>
>
> > Because I don't really understand how core_pipe_limit connected to
> > wait_for_dump_helpers(). Because, once again, we have to wait for core_pattern
> > app in any case.
> >
> > > > As for implementation, my only complaint is that wait_for_dump_helpers() lacks
> > > > signal_pending() check, this wasn't answered.
> > > >
> > > I'll have to defer to others on this.  It seems to me that, given that we are
> > > waiting here in the context of process that has already received a fatal signal,
> > > theres no opportunity to handle subsequent signals,
> >
> > Yes, we can't handle subsequent signals, but this is not needed.
> >
> Ok.
>
> > > I agree we busy wait if a signal is
> > > pending,
> >
> > Yes. And this is not nice.
> >
> > > but if we drop out of the loop if a signal is pending then we cancel
> > > the wait early, leading to the early removal of the /proc file for the crashing
> > > process.
> >
> > Yes. But if signal_pending() == T we already have other problems. In
> > particular pipe_write() can fail, and in this case the coredump won't
> > complete anyway.
> >
> Who's going to call pipe_write?  The userspace process isn't going to write to
> stdin,

dump_write() calls pipe_write().

> and by the time we're in this loop, we're done writing to the pipe
> anyway.

Sure. But dump_write() can fail if we recieve the signal. In that case
it doesn't really matter wait_for_dump_helpers() aborts.

> > Hopefully this will be changed soon: the coredumping task should ignore
> > ignore all signals except SIGKILL which should terminate the coredump,
> > and in this case of course wait_for_dump_helpers() should abort.
> >
> It sounds like what we should do then is, rather than gate the loop on
> signal_pending, we should instead gate it on fatal_signal_pending, which should
> only return true if SIGKILL is asserted on the crashing task.  Does that sound
> reasonable to you?

No. I reply to v7.

Oleg.

