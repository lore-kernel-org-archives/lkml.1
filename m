Return-Path: <linux-kernel-owner+w=401wt.eu-S1753289AbYKQVSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbYKQVSu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 16:18:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751864AbYKQVSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 16:18:42 -0500
Received: from mx2.redhat.com ([66.187.237.31]:57469 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749AbYKQVSl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 16:18:41 -0500
Date: Mon, 17 Nov 2008 23:18:57 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Frank Mayhar <fmayhar@google.com>, Peter Zijlstra <peterz@infradead.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Doug Chapman <doug.chapman@hp.com>, mingo@elte.hu, adobriyan@gmail.com,
       akpm@linux-foundation.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: regression introduced by - timers: fix itimer/many thread hang
Message-ID: <20081117221857.GA29423@redhat.com>
References: <1226053744.7803.5851.camel@twins> <1226081448.28191.64.camel@bobble.smo.corp.google.com> <1226089574.31966.85.camel@lappy.programming.kicks-ass.net> <Pine.LNX.4.64.0811100834500.21257@quilx.com> <1226328152.7685.192.camel@twins> <1226340009.19109.17.camel@bobble.smo.corp.google.com> <20081114024239.07CC91541E8@magilla.localdomain> <20081114164155.GA7738@redhat.com> <20081117143623.GA4658@redhat.com> <20081117181655.8BDE9154221@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081117181655.8BDE9154221@magilla.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17, Roland McGrath wrote:
>
> > > 	-	if (!->signal)
> > > 	+	if (->exit_state)
> > > 			return;
> >
> > Yes, unless I missed something again, this should work. I'll send
> > the (simple) patches soon, but I have no idea how to test them.
>
> That certainly will exclude the problem of crashing in the tick interrupt
> after exit_notify.  Unfortunately, it's moving in an undesireable direction
> for the long run.  That is, it loses from the accounting even more of the
> CPU time spent on the exit path.

Yes, I thought about this too.

But please note that currently this already happens for sub-threads (and
if we protect ->signal with rcu too), the exiting sub-thread does not
contribute to accounting after release_task(self). Also, when the last
thread exits the process can be reaped by its parent, but after that
the threads can still use CPU.

IOW, when ->exit_signal != 0 we already sent the notification to parent
with utime/stime, the parent can reap current at any moment before it
does the final schedule. I don't think we can do something here.

But if we make ->signal refcountable, we can improve the case with the
exiting subthreads at least.

(Just in case, anyway I completeley agree, this hack (and unlock_wait)
 should be killed in 2.6.29).

> > However, I'm afraid there is another problem. On 32 bit cpus we can't
> > read "u64 sum_exec_runtime" atomically, and so thread_group_cputime()
> > can "overestimate" ->sum_exec_runtime by (up to) UINT_MAX if it races
> > with the thread which updates its per_cpu_ptr(.totals). This for example
> > means that check_process_timers() can fire the CPUCLOCK_SCHED timers
> > before time.
> >
> > No?
>
> Yes, I think you're right.  The best solution that comes to mind off hand
> is to protect the update/read of that u64 with a seqcount_t on 32-bit.

Oh, but we need them to be per-cpu, and both read and write need memory
barriers... Not that I argue, this will fix the problem of course, just
I don't know how this impacts the perfomance.

Oleg.

