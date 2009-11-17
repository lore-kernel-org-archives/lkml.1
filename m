Return-Path: <linux-kernel-owner+w=401wt.eu-S1752764AbZKQMuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764AbZKQMuw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 07:50:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752647AbZKQMuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 07:50:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3040 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752626AbZKQMuv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 07:50:51 -0500
Date: Tue, 17 Nov 2009 13:48:52 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Spencer Candland <spencer@bluehost.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: utime/stime decreasing on thread exit
Message-ID: <20091117124851.GA3616@dhcp-lab-161.englab.brq.redhat.com>
References: <4AF123F5.50407@jp.fujitsu.com> <4AF26176.4080307@jp.fujitsu.com> <1257778154.4108.341.camel@laptop> <20091109172020.GA7751@redhat.com> <1257787903.4108.345.camel@laptop> <20091109192355.GA13724@redhat.com> <20091110104452.GB2391@dhcp-lab-161.englab.brq.redhat.com> <20091110174008.GA12909@redhat.com> <20091110182415.GB6066@dhcp-lab-161.englab.brq.redhat.com> <20091110192327.GA16325@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091110192327.GA16325@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 08:23:27PM +0100, Oleg Nesterov wrote:
> > > Can't we ensure that fastpath_timer_check() never do while_each_thread() ?
> >
> > Removing possibility to call while_each_tread() from fastpath_timer_check()
> > was exactly my intension here, perhaps I was not clear.
> 
> Yes, yes, I understand.
> 
> I meant, perhaps we can ensure this shouldn't happen "by design", instead
> of checking ->running in fastpath_timer_check().

Rule "sig->cputimer_expire != zero implies sig->cputimer.running == true" is
_almost_ assured (after fix in next mail). IMHO there is only one problem with
that functions: posix_cpu_timer_set() and posix_cpu_timer_schedule().

These functions first call thread_group_cputimer() without
tsk->sighand->siglock (only tasklist_lock is taken) and then
arm_timer(), which setups list and cputime_expires cache.

When there is some timer expiring already we can have situation like below:

cpu_timer_sample_group()
				check_process_timers()
					stop_process_timers()
arm_timer()

At the end we end with cputimer_expire != zero and ->running == false.
Very unlikely situation indeed, but possible. To address this
we can do in arm_timer() something like that:

	if (unlikely(!sig->cputimer.running)) {
		cpu_timer_sample_group()
		bump_cpu_timer();
	}

Since we have this we can do optimization, you proposed here:

http://lkml.org/lkml/2009/3/23/381

Use cputimer->running in fastpath_timer_check(). I'm going to work on
it as well on some other optimizations in posix-cpu-timer.c


> Still. check_process_timers() updates sig->cputime_expires at the end,
> but it never clears it. For example,
> 
> 	if (sched_expires != 0 &&
> 	    (sig->cputime_expires.sched_exp == 0 ||
> 	     sig->cputime_expires.sched_exp > sched_expires))
> 		sig->cputime_expires.sched_exp = sched_expires;
> 
> Why?
> 
> Now suppose that (say) sig->cputime_expires.sched_exp != 0, there are
> no cpu timers, ->running == F.
> 
> In this case fastpath_timer_check() always returns T and triggers the
> slow path which does nothing, not good.

This is real bug. I will fix it in the next patch. 

Stanislaw
