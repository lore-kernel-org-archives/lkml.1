Return-Path: <linux-kernel-owner+w=401wt.eu-S1756315AbYDIQai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315AbYDIQai (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 12:30:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753070AbYDIQaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 12:30:30 -0400
Received: from smtp-out.google.com ([216.239.33.17]:58041 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303AbYDIQa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 12:30:28 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:subject:from:to:cc:in-reply-to:references:
	content-type:organization:date:message-id:mime-version:x-mailer:content-transfer-encoding;
	b=drN5trpwaVcTUOSa+miVZyMV9A3gQvd7bYK13rdYgfJDWb7XbRpVP0BExthU08jrR
	9l1o+gyqc6Gm1UWRvRA+w==
Subject: Re: posix-cpu-timers revamp
From: Frank Mayhar <fmayhar@google.com>
To: Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080408224902.5BEB026F992@magilla.localdomain>
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
	 <1207459608.94001.22.camel@jill.exit.com>
	 <20080407200804.5541926F992@magilla.localdomain>
	 <1207690074.4687.18.camel@bobble.smo.corp.google.com>
	 <20080408224902.5BEB026F992@magilla.localdomain>
Content-Type: text/plain
Organization: Google, Inc.
Date: Wed, 09 Apr 2008 09:29:54 -0700
Message-Id: <1207758594.29898.11.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-04-08 at 15:49 -0700, Roland McGrath wrote:
> My explanation about the constraints on exit_state was specifically about
> the context of update_process_times(), which is part of the path for a
> clock tick interrupting current.

Understood.

> > And, you guessed it, the invariant gets violated.  Apparently the passed
> > task_struct isn't the same as "current" at this point.
> 
> The scheduler code has gotten a lot more complex since I first implemented
> posix-cpu-timers, and I've never been any expert on the scheduler at all.
> But I'm moderately sure all those things are all involved in context
> switch where the task of interest is about to be on a CPU or just was on a
> CPU.  I doubt those are places where the task in question could be
> simultaneously executing in exit_notify() on another CPU.  But we'd need
> to ask the scheduler experts to be sure we know what we're talking about
> there.

This was my conclusion as well.  Certainly the path through do_fork()
(elucidated below) doesn't even allow the task in question to even be
executing, much less on a different CPU, but all these routines with
"struct task_struct *" parameters make me nervous.  Which is why I
inserted the invariant check in the first place.

> > Found the exception.  do_fork() violates the invariant when it's
> > cranking up a new process.  Hmmm.
> 
> I haven't figured out what actual code path this refers to.

do_fork=>wake_up_new_task=>task_new_fair=>
	enqueue_task_fair=>enqueue_entity=>update_curr

> This sort of concern is among the reasons that checking ->signal was the
> course I found wise to suggest to begin with.  We can figure out what the
> constraints on ->exit_state are in all the places by understanding every
> corner of the scheduler.

Well, as much as I would like to take the time to do that, I do have a
_real_ job, here. :-)

>   We can measure whether it winds up being in a
> cooler cache line than ->signal and a net loss to add the load, or has
> superior performance as you seem to think.  Or we can just test the
> constraint that matters, whether the pointer we loaded was in fact null,
> and rely on RCU to make it not matter if there is a race after that load.
> It doesn't matter whether tsk is current or not, it only matters that we
> have the pointer and that we're using some CPU array slot or other that
> noone else is using simultaneously.
> 
>     static inline void account_group_exec_runtime(struct task_struct *tsk,
> 						  unsigned long long runtime)
>     {
> 	    struct signal_struct *sig;
> 	    struct task_cputime *times;
> 
> 	    rcu_read_lock();
> 	    sig = rcu_dereference(tsk->signal);
> 	    if (likely(sig) && sig->cputime.totals) {
> 		    times = per_cpu_ptr(sig->cputime.totals, get_cpu());
> 		    times->sum_exec_runtime += runtime;
> 		    put_cpu_no_resched();
> 	    }
> 	    rcu_read_unlock();
>     }

Yeah, agreed.  Of course, I was hoping (in vain, apparently) to avoid
this level of overhead here.  And I suspect I'll really have to do it in
each of these routines.  But I suppose it can't be helped.

Even with a thorough understanding of the scheduler(s) and code based on
that understanding, we would still not (necessarily) be protected from
future changes that violate the assumptions we make on that basis.
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

