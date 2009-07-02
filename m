Return-Path: <linux-kernel-owner+w=401wt.eu-S1754920AbZGBRxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920AbZGBRxk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 13:53:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751890AbZGBRxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 13:53:32 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52065 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbZGBRxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 13:53:31 -0400
Date: Thu, 2 Jul 2009 13:53:14 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
       andi@firstfloor.org, akpm@linux-foundation.org, earl_chew@agilent.com,
       Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH 3/3] exec: Allow do_coredump to wait for user space
	pipe readers to complete (v6)
Message-ID: <20090702175314.GB8972@hmsreliant.think-freely.org>
References: <20090622172818.GB14673@hmsreliant.think-freely.org> <20090701182834.GC31414@hmsreliant.think-freely.org> <20090701183707.GF31414@hmsreliant.think-freely.org> <20090702082854.GA15003@redhat.com> <20090702102936.GA8028@hmsreliant.think-freely.org> <20090702113610.GA3552@redhat.com> <20090702144422.GA8972@hmsreliant.think-freely.org> <20090702153736.GA15031@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090702153736.GA15031@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 02, 2009 at 05:37:36PM +0200, Oleg Nesterov wrote:
> On 07/02, Neil Horman wrote:
> >
> > On Thu, Jul 02, 2009 at 01:36:10PM +0200, Oleg Nesterov wrote:
> > > On 07/02, Neil Horman wrote:
> > > >
> > > > > >  void do_coredump(long signr, int exit_code, struct pt_regs *regs)
> > > > > >  {
> > > > > >  	struct core_state core_state;
> > > > > > @@ -1862,6 +1886,8 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
> > > > > >  		current->signal->group_exit_code |= 0x80;
> > > > > >
> > > > > >  close_fail:
> > > > > > +	if (ispipe && core_pipe_limit)
> > > > > > +		wait_for_dump_helpers(file);
> > > > >
> > > > > Oh. I thought I misread the first version, but now I see I got it right.
> > > > > And now I confused again.
> > > > >
> > > > > So, we only wait if core_pipe_limit != 0. Why?
> > > > >
> > > > > The previous version, v4, called wait_for_dump_helpers() unconditionally.
> > > > > And this looks more right to me. Once again, even without wait_for_dump()
> > > > > the coredumping process can't be reaped until core_pattern app reads all
> > > > > data from the pipe.
> > > > >
> > > > > I won't insist. However, anybody else please take a look?
> > > > >
> > > > > core_pipe_limit != 0 limits the number of coredump-via-pipe in flight, OK.
> > > > >
> > > > > But, should wait_for_dump_helpers() depend on core_limit_pipe != 0?
> > > > >
> > > > I messed this up in v4 and am fixing it here.  If you read the documentation I
> > > > added in patch 2, you can see that my intent with the core_pipe_limit sysctl was
> > > > to designate 0 as a special value allowing unlimited parallel core_dumps in
> > > > which we do not wait for any user space process completion
> > >
> > > We do wait in any case. If core_dump app doesn't read the data from the pipe
> > > ->core_dump() can't complete. OK, unless all data fits into pipe buffers.
> > >
> > Thats true, but consider the converse situation, in which the userspace app does
> > read the pipe, so that we return from ->core_dump().  If the user app then
> > queries the /proc/<pid> directory of the crashing  process we are open to race.
> > Thats what this wait helps with.
> 
> Sure. And I do agree wait_for_dump_helpers() is useful.
> 
> And I do agree with core_pipe_limit.
> 
> > > > (so that current
> > > > system behavior can be maintained, which I think is desireable for those user
> > > > space helpers who don't need access to a crashing processes meta data via proc.
> > > > If you look above in the second patch where we do an atomic_inc_return, you'll
> > > > see that we only honor the core_pipe_limit value if its non-zero.  This addional
> > > > check restores the behavior I documented in that patch.
> > >
> > > If you you look at my message you will see I am not arguing, but I am asking
> > > others to ack this behaviour.
> > >
> > Ok, but you asked the question as to why I added that check, this is the answer.
> 
> And I still can't understand your answer.
> 
> My question is: why don't we do wait_for_dump_helpers() if core_pipe_limit == 0.
> 
I'm sorry if I'm not explaining myself clearly.  Perhaps it would be best to say
that I made this choice by design.  I wanted core_pipe_limit == 0 to be a
special value in which we did 2 things:
1) Allowed an unlimited number of coredumps-to-pipes in parallel.
2) Disabled waiting on usermode helper processes to complete

I understand what you're saying in that we block in ->core_wait() once the pipe
fills up, but, as you see, we want to be able to wait after we've finished
writing the core (for the reasons we've discussed).  Conversely, I see advantage
in not waiting on usermode helpers if they have no need for additional crashing
process info.  In short, I see an advantage to being able to disable this
waiting feature from user space.  I.e allowing the crashing process to exit
immediately while the user helper continues to run could be adventageous.

Put it this way: If you want to be able to have an unlimited number of user mode
helpers run in parallel and have the kernel wait on each of them, set
core_pipe_limit to MAXINT, and you effectively have that situation.  Since
core_pipe_limit == 0 effectively has to mean the same thing as core_pipe_limit
== MAXINT (in that you have an effectively unbounded number of processes
operating concurrently), why not add in this feature which allows you to disable
the wait after ->core_dump() entirely.



> Because I don't really understand how core_pipe_limit connected to
> wait_for_dump_helpers(). Because, once again, we have to wait for core_pattern
> app in any case.
> 
> > > As for implementation, my only complaint is that wait_for_dump_helpers() lacks
> > > signal_pending() check, this wasn't answered.
> > >
> > I'll have to defer to others on this.  It seems to me that, given that we are
> > waiting here in the context of process that has already received a fatal signal,
> > theres no opportunity to handle subsequent signals,
> 
> Yes, we can't handle subsequent signals, but this is not needed.
> 
Ok.

> > I agree we busy wait if a signal is
> > pending,
> 
> Yes. And this is not nice.
> 
> > but if we drop out of the loop if a signal is pending then we cancel
> > the wait early, leading to the early removal of the /proc file for the crashing
> > process.
> 
> Yes. But if signal_pending() == T we already have other problems. In
> particular pipe_write() can fail, and in this case the coredump won't
> complete anyway.
> 
Who's going to call pipe_write?  The userspace process isn't going to write to
stdin, and by the time we're in this loop, we're done writing to the pipe
anyway.

> Hopefully this will be changed soon: the coredumping task should ignore
> ignore all signals except SIGKILL which should terminate the coredump,
> and in this case of course wait_for_dump_helpers() should abort.
> 
It sounds like what we should do then is, rather than gate the loop on
signal_pending, we should instead gate it on fatal_signal_pending, which should
only return true if SIGKILL is asserted on the crashing task.  Does that sound
reasonable to you?

> > Could we add a schedule to the loop to allow the user space helper to
> > run if a signal is pending instead of just dropping the loop?
> 
> Not sure I understand what you mean, but no, we can't return to user-space
> to handle the signal. (and just in case, pipe_wait() does schedule()).
> 
Ok, I was starting to think you meant we need to check the helper process for
signals, but I see know you're really concerned about the SIGKILL condition for
the crashing process, and yes, for that condition the signal check makes sense.
Do you agree that gating the loop on the additional check of
fatal_signal_pending makes sense here?

Regards
Neil

> Oleg.
> 
> 
