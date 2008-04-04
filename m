Return-Path: <linux-kernel-owner+w=401wt.eu-S1754255AbYDDXSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255AbYDDXSU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 19:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751133AbYDDXSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 19:18:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37350 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752017AbYDDXSM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 19:18:12 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Frank Mayhar <fmayhar@google.com>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
Subject: Re: posix-cpu-timers revamp
In-Reply-To: Frank Mayhar's message of  Wednesday, 2 April 2008 13:34:24 -0700 <1207168464.11976.48.camel@bobble.smo.corp.google.com>
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
	<1204830243.20004.31.camel@bobble.smo.corp.google.com>
	<20080311075020.A93DB26F991@magilla.localdomain>
	<1205269507.23124.57.camel@bobble.smo.corp.google.com>
	<20080311213507.5BCDF26F991@magilla.localdomain>
	<1205455050.19551.16.camel@bobble.smo.corp.google.com>
	<20080321071846.1B22B26F9A7@magilla.localdomain>
	<1206122240.14638.31.camel@bobble.smo.corp.google.com>
	<20080322215829.D69D026F9A7@magilla.localdomain>
	<1206380079.21896.20.camel@bobble.smo.corp.google.com>
	<20080331054404.78CDB26F8E9@magilla.localdomain>
	<1206995072.14649.41.camel@bobble.smo.corp.google.com>
	<20080402020707.151E126F8DC@magilla.localdomain>
	<1207158164.11976.32.camel@bobble.smo.corp.google.com>
	<20080402194836.4933026F98A@magilla.localdomain>
	<1207168464.11976.48.camel@bobble.smo.corp.google.com>
X-Windows: even not doing anything would have been better than nothing.
Message-Id: <20080404231739.7E25126F8DC@magilla.localdomain>
Date: Fri,  4 Apr 2008 16:17:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> BTW I did look at allocating it in posix_cpu_timer_set() and
> set_process_cpu_timer() but the first at least is doing stuff with locks
> held.  I'll keep looking at it, though.

Yeah, it's a little sticky.  It would be simple enough to arrange things to
do the allocation when needed before taking locks, but would not make the
code wonderfully self-contained.  I wouldn't worry about it unless/until we
conclude for other reasons that this really is the best way to go.  We seem
now to be leaning towards allocating at clone time anyway.

> One little gotcha we just ran into, though:  When checking
> tsk->signal->(anything) in run_posix_cpu_timers(), we have to hold
> tasklist_lock to avoid a race with release_task().  This is going to
> make even the null case always cost more than before.

This is reminiscent of something that came up once before.  I think it
was the same issue of what happens on a tick while the thread is in the
middle of exiting and racing with release_task.  See commit
72ab373a5688a78cbdaf3bf96012e597d5399bb7, commit
3de463c7d9d58f8cf3395268230cb20a4c15bffa and related history (some of
the further history is pre-GIT).

> For the local environment, I solved the problem by moving the percpu
> structure out of the signal structure entirely and by making it
> refcounted.  

This is a big can of worms that we really don't need.  Complicating the
data structure handling this way is really not warranted at all just to
address this race.  You'll just create another version of the same race
with a different pointer, and then solve it some simple way that you
could have just used to solve the existing problem.  If you don't have
some independent (and very compelling) reasons to reorganize the data
structures, nix nix nix.

We can make posix_cpu_timers_exit() or earlier in the exit/reap path
tweak any state we need to ensure that this problem won't come up.
But, off hand, I don't think we need any new state.

Probably the right fix is to make the fast-path check do:

	rcu_read_lock();
	signal = rcu_dereference(current->signal);
	if (unlikely(!signal) || !fastpath_process_timer_check(signal)) {
		rcu_read_unlock();
		return;
	}
	sighand = lock_task_sighand(current, &flags);
	rcu_read_unlock();
	if (likely(sighand))
		slowpath_process_timer_work(signal);
	unlock_task_sighand(sighand, &flags);

Another approach that is probably fine too is just to do:

	if (unlikely(current->exit_state))
		return;

We can never get to the __exit_signal code that causes the race if we
are not already late in exit.  The former seems a little preferable
because the added fast-path cost is the same (or perhaps even more
cache-friendly), but it fires timers even at the very last tick during
exit, and only loses the ideal behavior (of always firing if the timer
expiration is ever crossed) at the last possible instant.


Thanks,
Roland
