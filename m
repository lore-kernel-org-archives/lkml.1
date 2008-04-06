Return-Path: <linux-kernel-owner+w=401wt.eu-S1756010AbYDFFg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010AbYDFFg3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 01:36:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751896AbYDFFgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 01:36:20 -0400
Received: from tinker.exit.com ([206.223.0.1]:54983 "EHLO tinker.exit.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751890AbYDFFgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 01:36:18 -0400
X-Greylist: delayed 537 seconds by postgrey-1.27 at vger.kernel.org; Sun, 06 Apr 2008 01:36:18 EDT
Subject: Re: posix-cpu-timers revamp
From: Frank Mayhar <frank@exit.com>
Reply-To: frank@exit.com
To: Roland McGrath <roland@redhat.com>
Cc: Frank Mayhar <fmayhar@google.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20080404231739.7E25126F8DC@magilla.localdomain>
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
	 <20080404231739.7E25126F8DC@magilla.localdomain>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Exit Consulting
Date: Sat, 05 Apr 2008 22:26:48 -0700
Message-Id: <1207459608.94001.22.camel@jill.exit.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 FreeBSD GNOME Team Port 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-04-05 at 11:26 -0700, Roland McGrath wrote:
> > BTW I did look at allocating it in posix_cpu_timer_set() and
> > set_process_cpu_timer() but the first at least is doing stuff with locks
> > held.  I'll keep looking at it, though.
> 
> Yeah, it's a little sticky.  It would be simple enough to arrange things to
> do the allocation when needed before taking locks, but would not make the
> code wonderfully self-contained.  I wouldn't worry about it unless/until we
> conclude for other reasons that this really is the best way to go.  We seem
> now to be leaning towards allocating at clone time anyway.

Well, if we allocate at clone time then some things do get a bit
simpler.  (Hmm, for some reason I was thinking that we still allocate in
do_setitimer() as well, but it doesn't look like it.)

> > One little gotcha we just ran into, though:  When checking
> > tsk->signal->(anything) in run_posix_cpu_timers(), we have to hold
> > tasklist_lock to avoid a race with release_task().  This is going to
> > make even the null case always cost more than before.
> 
> This is reminiscent of something that came up once before.  I think it
> was the same issue of what happens on a tick while the thread is in the
> middle of exiting and racing with release_task.  See commit
> 72ab373a5688a78cbdaf3bf96012e597d5399bb7, commit
> 3de463c7d9d58f8cf3395268230cb20a4c15bffa and related history (some of
> the further history is pre-GIT).

Yeah, I checked that out.  The one difference here is that that was a
race between do_exit() (actually release_task()/__exit_signal()) and
run_posix_cpu_timers().  While this race was the same in that respect,
there was also a race between all of the timer-tick routines that call
any of account_group_user_time(), account_group_system_time() or
account_group_exec_runtime() and __exit_signal().  This is because those
functions all dereference tsk->signal.

> > For the local environment, I solved the problem by moving the percpu
> > structure out of the signal structure entirely and by making it
> > refcounted.  
> 
> This is a big can of worms that we really don't need.  Complicating the
> data structure handling this way is really not warranted at all just to
> address this race.  You'll just create another version of the same race
> with a different pointer, and then solve it some simple way that you
> could have just used to solve the existing problem.  If you don't have
> some independent (and very compelling) reasons to reorganize the data
> structures, nix nix nix.

Erm, well, this isn't reorganizing the data structures per se, since
these are new data structures.  Regardless, the way I did this was by
making the refcounted structure follow the lifetime of the task
structure.  It's instantiated when needed and at that point each task
structure in the thread group gets a reference, which is released when
that task structure is destroyed.  The last release destroys the data
structure.

The upshot of this is that none of the timer routines dereference
tsk->signal, so the races go away, no locking needed.  From my
perspective this was the simplest solution, since lock dependency
ordering is _really_ a can of worms.

The solution was really very simple, in fact.

> We can make posix_cpu_timers_exit() or earlier in the exit/reap path
> tweak any state we need to ensure that this problem won't come up.
> But, off hand, I don't think we need any new state.

That's certainly a possibility, but it'll still require more code in the
timer routines to check whatever state there is.

> Probably the right fix is to make the fast-path check do:
> 
> 	rcu_read_lock();
> 	signal = rcu_dereference(current->signal);
> 	if (unlikely(!signal) || !fastpath_process_timer_check(signal)) {
> 		rcu_read_unlock();
> 		return;
> 	}
> 	sighand = lock_task_sighand(current, &flags);
> 	rcu_read_unlock();
> 	if (likely(sighand))
> 		slowpath_process_timer_work(signal);
> 	unlock_task_sighand(sighand, &flags);
> 
> Another approach that is probably fine too is just to do:
> 
> 	if (unlikely(current->exit_state))
> 		return;
> 
> We can never get to the __exit_signal code that causes the race if we
> are not already late in exit.  The former seems a little preferable
> because the added fast-path cost is the same (or perhaps even more
> cache-friendly), but it fires timers even at the very last tick during
> exit, and only loses the ideal behavior (of always firing if the timer
> expiration is ever crossed) at the last possible instant.

I'll have to look at the code some more and thing about this.  For the
other timer routines I would think that the second approach would be
better, but I still think that best of all is to not have to check
anything at all (except of course the presence of the structure pointer
itself).

Regarding the second approach, without locking wouldn't that still be
racy?  Couldn't exit_state change (and therefore __exit_signal() run)
between the check and the dereference?
-- 
Frank Mayhar frank@exit.com     http://www.exit.com/
Exit Consulting                 http://www.gpsclock.com/
                                http://www.exit.com/blog/frank/
                                http://www.zazzle.com/fmayhar*
