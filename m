Return-Path: <linux-kernel-owner+w=401wt.eu-S1752932AbYKNPmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932AbYKNPmR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 10:42:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751399AbYKNPmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 10:42:04 -0500
Received: from mx2.redhat.com ([66.187.237.31]:37256 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345AbYKNPmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 10:42:01 -0500
Date: Fri, 14 Nov 2008 17:41:55 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Frank Mayhar <fmayhar@google.com>, Peter Zijlstra <peterz@infradead.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Doug Chapman <doug.chapman@hp.com>, mingo@elte.hu, adobriyan@gmail.com,
       akpm@linux-foundation.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: regression introduced by - timers: fix itimer/many thread hang
Message-ID: <20081114164155.GA7738@redhat.com>
References: <Pine.LNX.4.64.0811060900450.3595@quilx.com> <1225984098.7803.4642.camel@twins> <1226015568.2186.20.camel@bobble.smo.corp.google.com> <1226053744.7803.5851.camel@twins> <1226081448.28191.64.camel@bobble.smo.corp.google.com> <1226089574.31966.85.camel@lappy.programming.kicks-ass.net> <Pine.LNX.4.64.0811100834500.21257@quilx.com> <1226328152.7685.192.camel@twins> <1226340009.19109.17.camel@bobble.smo.corp.google.com> <20081114024239.07CC91541E8@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081114024239.07CC91541E8@magilla.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13, Roland McGrath wrote:
>
> An idea like taking siglock in account_group_*() should be a non-starter.

Yes sure. The patch was buggy anyway, but even _if_ was correct it was
only a temporary hack for 2.6.28.

> A third variety of possible fix that we haven't explored much is to delay
> parts of the teardown to __put_task_struct or to finish_task_switch's
> TASK_DEAD case.  That is, make simpler code on the tick path remain safe
> until it's no longer possible to have a tick (because it's after the final
> deschedule).

This was already discussed a bit,
	http://marc.info/?l=linux-kernel&m=122640473714466

and perhaps this makes sense. With this change we can simplify other code.

> If I'm understanding it correctly, Oleg's task_rq_unlock_wait change makes
> sure that if any task_rq_lock is in effect when clearing ->signal, it's
> effectively serialized either to:
> 	CPU1(tsk)				CPU2(parent)
> 	task_rq_lock(tsk)...task_rq_unlock(tsk)
> 						tsk->signal = NULL;
> 						__cleanup_signal(sig);
> or to:
> 	CPU1(tsk)				CPU2(parent)
> 						tsk->signal = NULL;
> 	task_rq_lock(tsk)...task_rq_unlock(tsk)
> 						__cleanup_signal(sig);
> so that the locked "..." code either sees NULL or sees a signal_struct
> that cannot be passed to __cleanup_signal until after task_rq_unlock.
> Is that right?
>
> Doesn't the same bug exist for account_group_user_time and
> account_group_system_time?  Those aren't called with task_rq_lock(current)
> held, I don't think.  So Oleg's change doesn't address the whole problem,
> unless I'm missing something (which is always likely).

You are right. (please see below).

Even run_posix_cpu_timers() becomes unsafe. And I must admit, I have read
this part of the patch carefully before, and I didn't notice the problem.
I'll try to finally read the whole patch carefully on Sunday, but I don't
trust myself ;)

> The first thing that pops to my mind is to protect the freeing of
> signal_struct and thread_group_cputime_free (i.e. some or most of the
> __cleanup_signal worK) with RCU.  Then use rcu_read_lock() around accesses
> to current->signal in places that can run after exit_notify,

Yes, this was my initial intent, but needs more changes. (actually,
I personally like the idea to free ->signal from __put_task_struct()
more, but I have no good arguments).

Currently I am trying to find the ugly, but simple fixes for 2.6.28.

account_group_user_time(), run_posix_cpu_timers() are simpler to
fix. Again, I need to actually read the code, but afaics we can
rely on the fact that the task is current, so we can change the
code

	-	if (!->signal)
	+	if (->exit_state)
			return;

But of course, I do agree, we need a more clever fix for the long
term, even if the change above can really help.

Oleg.

