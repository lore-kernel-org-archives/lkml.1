Return-Path: <linux-kernel-owner+w=401wt.eu-S1753381AbYKNCnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381AbYKNCnu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 21:43:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751295AbYKNCnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 21:43:42 -0500
Received: from mx1.redhat.com ([66.187.233.31]:41463 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751349AbYKNCnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 21:43:40 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Frank Mayhar <fmayhar@google.com>
X-Fcc: ~/Mail/linus
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Doug Chapman <doug.chapman@hp.com>, mingo@elte.hu, adobriyan@gmail.com,
       akpm@linux-foundation.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: regression introduced by - timers: fix itimer/many thread hang
In-Reply-To: Frank Mayhar's message of  Monday, 10 November 2008 10:00:09 -0800 <1226340009.19109.17.camel@bobble.smo.corp.google.com>
References: <1224694989.8431.23.camel@oberon>
	<1225132746.14792.13.camel@bobble.smo.corp.google.com>
	<1225219114.24204.37.camel@oberon>
	<1225936715.27507.44.camel@bobble.smo.corp.google.com>
	<1225969420.7803.4366.camel@twins>
	<Pine.LNX.4.64.0811060900450.3595@quilx.com>
	<1225984098.7803.4642.camel@twins>
	<1226015568.2186.20.camel@bobble.smo.corp.google.com>
	<1226053744.7803.5851.camel@twins>
	<1226081448.28191.64.camel@bobble.smo.corp.google.com>
	<1226089574.31966.85.camel@lappy.programming.kicks-ass.net>
	<Pine.LNX.4.64.0811100834500.21257@quilx.com>
	<1226328152.7685.192.camel@twins>
	<1226340009.19109.17.camel@bobble.smo.corp.google.com>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20081114024239.07CC91541E8@magilla.localdomain>
Date: Thu, 13 Nov 2008 18:42:39 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks.  I'm catching up on this after a few weeks off-line.
I don't have anything really new to add, but a few thoughts.

An idea like taking siglock in account_group_*() should be a non-starter.
The sole purpose of the per-cpu count scheme is to avoid cache ping-ponging
from updating a shared group-wide count with atomics or locked data in the
tick path.  If you take shared locks there, you have the same performance
hit in the tick path.  If that were acceptable for the real-world range of
cases of multiple threads on multiple CPUs, it could all be far simpler.

Over the years this sort of problem has come up a few times, races between
release_task(T) and code in the tick path when current==T.  The two kinds
of fixes are to make the hot tick path robust against simultaneous
teardown, with whatever adding of checks that entails, or else to
reorganize the teardown earlier in release_task or on the do_exit path so
that existing checks on the hot tick path already avoid entering the
problem parts of the tick path when teardown has begun.  It's clearly
preferable to make choices that minimize the work done in the common case
tick path.

There are two kinds of failure mode for these race bugs.  In one a
self-reaping thread calls release_task(current) and a tick interrupt
arrives somewhere in the middle.  In the other, a reaping parent (or
exec'ing sibling) calls release_task(T) between T's exit_notify and its
final deschedule, and the tick interrupt arrives in that interval.

A third variety of possible fix that we haven't explored much is to delay
parts of the teardown to __put_task_struct or to finish_task_switch's
TASK_DEAD case.  That is, make simpler code on the tick path remain safe
until it's no longer possible to have a tick (because it's after the final
deschedule).

The group-wide counts are used for two purposes: firing CPU timers, and
maintaining group CPU clocks for sampling (including wait4 rusage and
process accounting).  For timers, it's always OK if they don't fire until
up to a whole tick's worth of CPU accumulates on that CPU clock after they
might have ideally fired.  So for purposes of timers, it's fine to disable
firing on ticks anywhere from early in the exit path (a la PF_EXITING
checks) when that makes it easy to keep the tick path safe from teardown
races.  If there are live threads left in the group and a group-wide CPU
timer should fire, it will be seen after one of them runs for another tick.

Maintaining the group CPU clocks is a little different.  We do miss
whatever time a dying thread spends between when the code at the start of
__exit_signal runs and its final deschedule.  For the group-leader (or only
thread in single-threaded processes), it's the time between its parent
calling wait_task_zombie and the dying leader doing its final deschedule.
But we wouldn't like to miss any more CPU time from these counts than we
absolutely have to--that time is effectively accounted to noone.  Up
through 2.6.27, these were only summed from the per-thread counters
(updated on ticks, and exec_runtime also on context switches so that one is
quite precise).  Now we don't sum those, and just have the parallel
aggregate per-CPU group counts.  So the stretch of time lost to the final
accounting increases if account_group_*() bail out in a tick that hits
earlier in the exit path.  In some sense it would be ideal to delay all the
final tallies until finish_task_switch's TASK_DEAD case, especially for
exec_runtime (which could then lose no cycles at all).  (That sounds very
attractive for a self-reaping thread.  On the other hand, for a regular
child dying and its parent on another CPU waking up in wait, we currently
have some opportunity for parallelism between the child's exit path after
exit_notify and the parent doing all the release_task work.)

If I'm understanding it correctly, Oleg's task_rq_unlock_wait change makes
sure that if any task_rq_lock is in effect when clearing ->signal, it's
effectively serialized either to:
	CPU1(tsk)				CPU2(parent)
	task_rq_lock(tsk)...task_rq_unlock(tsk)
						tsk->signal = NULL;
						__cleanup_signal(sig);
or to:
	CPU1(tsk)				CPU2(parent)
						tsk->signal = NULL;
	task_rq_lock(tsk)...task_rq_unlock(tsk)
						__cleanup_signal(sig);
so that the locked "..." code either sees NULL or sees a signal_struct
that cannot be passed to __cleanup_signal until after task_rq_unlock.
Is that right?

Doesn't the same bug exist for account_group_user_time and
account_group_system_time?  Those aren't called with task_rq_lock(current)
held, I don't think.  So Oleg's change doesn't address the whole problem,
unless I'm missing something (which is always likely).

The first thing that pops to my mind is to protect the freeing of
signal_struct and thread_group_cputime_free (i.e. some or most of the
__cleanup_signal worK) with RCU.  Then use rcu_read_lock() around accesses
to current->signal in places that can run after exit_notify, including the
interrupt and tick paths.  Since __cleanup_signal is only possible after
anything that could use most of the signal_struct is ruled out, the
rcu_head could even be thrown into a union with some other member(s),
e.g. shared_pending, to save the two words bloat in signal_struct.

On the other hand, there is no real use to account_group_* doing any work
after the beginning of __exit_signal, since the updated counts can't ever
be read again.  Some new way of safely always bailing out would be fine
too, but I haven't thought of one off hand.

I've rambled on more than enough for one message.  So I'll confine this one
to the issue of tick-vs-release_task races.  If it's helpful to the
discussion, I can write separately about the trade-offs between the
original (<=2.6.27) approach to group CPU timers and clocks, and what
motivated the approach Frank implemented.


Thanks,
Roland
