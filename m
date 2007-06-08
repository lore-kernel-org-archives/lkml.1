Return-Path: <linux-kernel-owner+w=401wt.eu-S937832AbXFHHRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937832AbXFHHRp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 03:17:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937510AbXFHHQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:16:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33846 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937320AbXFHHQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:16:56 -0400
Date: Fri, 8 Jun 2007 09:16:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: [patch 3/4] pi-futex: Fix exit races and locking problems
Message-ID: <20070608071611.GB30226@elte.hu>
References: <20070607235106.387346000@linutronix.de> <20070607235801.558491000@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070607235801.558491000@linutronix.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Gleixner <tglx@linutronix.de> wrote:

> From: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
> 
> 1. New entries can be added to tsk->pi_state_list after task completed
>    exit_pi_state_list(). The result is memory leakage and deadlocks.
> 
> 2. handle_mm_fault() is called under spinlock. The result is obvious.
> 
> 3. results in self-inflicted deadlock inside glibc.
>    Sometimes futex_lock_pi returns -ESRCH, when it is not expected
>    and glibc enters to for(;;) sleep() to simulate deadlock. This problem
>    is quite obvious and I think the patch is right. Though it looks like
>    each "if" in futex_lock_pi() got some stupid special case "else if". :-)
> 
> 4. sometimes futex_lock_pi() returns -EDEADLK,
>    when nobody has the lock. The reason is also obvious (see comment
>    in the patch), but correct fix is far beyond my comprehension.
>    I guess someone already saw this, the chunk:
> 
>                         if (rt_mutex_trylock(&q.pi_state->pi_mutex))
>                                 ret = 0;
> 
>    is obviously from the same opera. But it does not work, because the
>    rtmutex is really taken at this point: wake_futex_pi() of previous
>    owner reassigned it to us. My fix works. But it looks very stupid.
>    I would think about removal of shift of ownership in wake_futex_pi()
>    and making all the work in context of process taking lock.
> 
> From: Thomas Gleixner <tglx@linutronix.de>
> 
> Fix 1) Avoid the tasklist lock variant of the exit race fix by adding
>     an additional state transition to the exit code.
> 
>     This fixes also the issue, when a task with recursive segfaults
>     is not able to release the futexes.
> 
> Fix 2) Cleanup the lookup_pi_state() failure path and solve the -ESRCH
>     problem finally.
> 
> Fix 3) Solve the fixup_pi_state_owner() problem which needs to do the fixup
>     in the lock protected section by using the in_atomic userspace access
>     functions.
> 	
>     This removes also the ugly lock drop / unqueue inside of fixup_pi_state()
> 
> Fix 4) Fix a stale lock in the error path of futex_wake_pi()
> 
> Added some error checks for verification.
> 
> The -EDEADLK problem is solved by the rtmutex fixups.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

i've read the patch and it looks all good - but obviously testing will 
tell us what's up, this stuff is ... complex.

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
