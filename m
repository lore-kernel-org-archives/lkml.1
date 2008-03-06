Return-Path: <linux-kernel-owner+w=401wt.eu-S1758353AbYCFTGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758353AbYCFTGz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 14:06:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756859AbYCFTGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 14:06:44 -0500
Received: from smtp-out.google.com ([216.239.33.17]:27877 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754271AbYCFTGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 14:06:42 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:subject:from:to:cc:in-reply-to:references:
	content-type:organization:date:message-id:mime-version:x-mailer:content-transfer-encoding;
	b=iSfJcJNOQHlbuBJ/ZkFFl8VkGXznYtpSjkV1w6cM8vwipd/MzPizxu+YHbNmanV5I
	QrhCunpfZKtIXUiamvcbw==
Subject: Re: [Bugme-new] [Bug 9906] New: Weird hang with NPTL and SIGPROF.
From: Frank Mayhar <fmayhar@google.com>
To: Roland McGrath <roland@redhat.com>
Cc: parag.warudkar@gmail.com,
       Alejandro Riveira =?ISO-8859-1?Q?Fern=E1ndez?= 
	<ariveira@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Jakub Jelinek <jakub@redhat.com>
In-Reply-To: <20080305040826.D0E6127010A@magilla.localdomain>
References: <bug-9906-10286@http.bugzilla.kernel.org/>
	 <20080206165045.89b809cc.akpm@linux-foundation.org>
	 <1202345893.8525.33.camel@peace.smo.corp.google.com>
	 <alpine.LRH.1.00.0802062148480.7445@mini.warudkars.net>
	 <20080207162203.3e3cf5ab@Varda>
	 <alpine.LRH.1.00.0802071040010.29320@mini.warudkars.net>
	 <alpine.LRH.1.00.0802071054160.29320@mini.warudkars.net>
	 <20080207165455.04ec490b@Varda>
	 <alpine.LRH.1.00.0802071100230.29369@mini.warudkars.net>
	 <alpine.LRH.1.00.0802071153130.15220@mini.warudkars.net>
	 <1204314904.4850.23.camel@peace.smo.corp.google.com>
	 <20080304070016.903E127010A@magilla.localdomain>
	 <1204660376.9768.1.camel@bobble.smo.corp.google.com>
	 <20080305040826.D0E6127010A@magilla.localdomain>
Content-Type: text/plain
Organization: Google, Inc.
Date: Thu, 06 Mar 2008 11:04:03 -0800
Message-Id: <1204830243.20004.31.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-03-04 at 20:08 -0800, Roland McGrath wrote:
> check_process_timers can look just like check_thread_timers, but
> consulting the shared fields instead of the per-thread ones for both the
> clock accumulators and the timers' expiry times.  Likewise, arm_timer
> only has to set signal->it_*_expires; process_timer_rebalance goes away.

Okay, my understanding of this is still evolving, so please (please!)
correct me when I get it wrong.  I take what you're saying to mean that,
first, run_posix_cpu_timers() only needs to be run once per thread
group.  It _sounds_ like it should be checking the shared fields rather
than the per-task fields for timer expiration (in fact, the more I think
about it the more sure I am that that's the case).

The old process_timer_rebalance() routine was intended to distribute the
remaining ticks across all the threads, so that the per-task fields
would cause run_posix_cpu_timers() to run at the appropriate time.  With
it checking the shared fields this becomes no longer necessary.

Since the shared fields are getting all the ticks, this will work for
per-thread timers as well.

The arm_timers() routine, instead of calling posix_timer_rebalance(),
should just directly set signal->it_*_expires to the expiration time,
e.g.:
			switch (CPUCLOCK_WHICH(timer->it_clock)) {
			default:
				BUG();
			case CPUCLOCK_VIRT:
				if (!cputime_eq(p->signal->it_virt_expires,
						cputime_zero) &&
				    cputime_lt(p->signal->it_virt_expires,
					       timer->it.cpu.expires.cpu))
					break;
				p->signal->it_virt_expires = timer->it.cpu.expires.cpu;
				goto rebalance;
			case CPUCLOCK_PROF:
				if (!cputime_eq(p->signal->it_prof_expires,
						cputime_zero) &&
				    cputime_lt(p->signal->it_prof_expires,
					       timer->it.cpu.expires.cpu))
					break;
				i = p->signal->rlim[RLIMIT_CPU].rlim_cur;
				if (i != RLIM_INFINITY &&
				    i <= cputime_to_secs(timer->it.cpu.expires.cpu))
					break;
				p->signal->it_prof_expires = timer->it.cpu.expires.cpu;
				goto rebalance;
			case CPUCLOCK_SCHED:
				p->signal->it_sched_expires = timer->it.cpu.expires.sched;
				break;
			}


> If you do all that then the time spent in run_posix_cpu_timers should
> not be affected at all by the number of threads.  The only "walking the
> timer lists" that happens is popping the expired timers off the head of
> the lists that are kept in ascending order of expiry time.  For each
> flavor of timer, there are n+1 steps in the "walk" for n timers that
> have expired.  So already no costs here should scale with the number of
> timers, just the with the number of timers that all expire at the same time.

It's still probably worthwhile to defer processing to a workqueue
thread, though, just because it's still a lot to do at interrupt.  I'll
probably end up trying it both ways.

One thing that's still unclear to me is, if there were only one run of
run_posix_cpu_timers() per thread group per tick, how would per-thread
timers be serviced?

> The simplifications I described above will obviously greatly improve
> your test case (many threads and with some process timers expiring
> pretty frequently).  We need to consider and analyze the other kinds of
> cases too.  That is, cases with a few threads (not many more than the
> number of CPUs); cases where no timer is close to expiring very often.
> The most common cases, from one-thread cases to one-million thread
> cases, are when no timers are going off before next Tuesday (if any are
> set at all).  Then run_posix_cpu_timers always bails out early, and none
> of the costs you've seen become relevant at all.  Any change to what the
> timer interrupt handler does on every tick affects those cases too.

These are all on the roadmap, and in fact the null case should already
be covered. :-)

> As I mentioned in my last message, my concern about this originally was
> with the SMP cache/lock effects of multiple CPUs touching the same
> memory in signal_struct on every tick (which presumably all tend to
> happen simultaneously on all the CPUs).  I'd insist that we have
> measurements and analysis as thorough as possible of the effects of
> introducing that frequent/synchronized sharing, before endorsing such
> changes.  I have a couple of guesses as to what might be reasonable ways
> to mitigate that.  But it needs a lot of measurement and wise opinion on
> the low-level performance effects of each proposal.

I've given this some thought.  It seems clear that there's going to be
some performance penalty when multiple CPUs are competing trying to
update the same field at the tick.  It would be much better if there
were cacheline-aligned per-cpu fields associated with either the task or
the signal structure; that way each CPU could update its own field
without competing with the others.  Processing in run_posix_cpu_timers
would still be constant, although slightly higher for having to consult
multiple fields instead of just one.  Not one per thread, though, just
one per CPU, a much smaller and fixed number.
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

