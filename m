Return-Path: <linux-kernel-owner+w=401wt.eu-S1757504AbZBYTBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757504AbZBYTBd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 14:01:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755405AbZBYTBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 14:01:23 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:60997 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754158AbZBYTBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 14:01:22 -0500
Date: Wed, 25 Feb 2009 11:01:18 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, stable@kernel.org,
       akpm@linux-foundation.org, npiggin@suse.de, penberg@cs.helsinki.fi
Subject: Re: [PATCH] v4 Teach RCU that idle task is not quiscent state at
	boot
Message-ID: <20090225190118.GI6797@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090223161611.GA9563@linux.vnet.ibm.com> <20090223204332.GA19861@linux.vnet.ibm.com> <20090225002937.GA23733@linux.vnet.ibm.com> <20090225141945.GA28455@linux.vnet.ibm.com> <19f34abd0902251038y4c0a5261ya16dfb3db7a3302@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <19f34abd0902251038y4c0a5261ya16dfb3db7a3302@mail.gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 25, 2009 at 07:38:23PM +0100, Vegard Nossum wrote:
> 2009/2/25 Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
> > This patch fixes a bug located by Vegard Nossum with the aid of
> > kmemcheck, updated based on review comments from Nick Piggin,
> > Ingo Molnar, and Andrew Morton.
> >
> > The boot CPU runs in the context of its idle thread during boot-up.
> > During this time, idle_cpu(0) will always return nonzero, which will
> > fool Classic and Hierarchical RCU into deciding that a large chunk of
> > the boot-up sequence is a big long quiescent state.  This in turn causes
> > RCU to prematurely end grace periods during this time.
> >
> > This patch changes the rcutree.c and rcuclassic.c rcu_check_callbacks()
> > function to ignore the idle task as a quiescent state until the
> > system has started up the scheduler in rest_init(), introducing a
> > new non-API function rcu_idle_now_means_idle() to inform RCU of this
> > transition.  RCU maintains an internal rcu_idle_cpu_truthful variable
> > to track this state, which is then used by rcu_check_callback() to
> > determine if it should believe idle_cpu().
> >
> > Because this patch has the effect of disallowing RCU grace periods
> > during long stretches of the boot-up sequence, this patch also introduces
> > Josh Triplett's UP-only optimization that makes synchronize_rcu() be a
> > no-op if num_online_cpus() returns 1.  This allows boot-time code that
> > calls synchronize_rcu() to proceed normally.  Note, however, that RCU
> > callbacks registered by call_rcu() will likely queue up until later in
> > the boot sequence.  Although rcuclassic and rcutree can also use this
> > same optimization after boot completes, rcupreempt must restrict its
> > use of this optimization to the portion of the boot sequence before the
> > scheduler starts up, given that an rcupreempt RCU read-side critical
> > section may be preeempted.
> >
> > In addition, this patch takes Nick Piggin's suggestion to make the
> > system_state global variable be __read_mostly.
> >
> > Changes since v3:
> >
> > o       WARN_ON(nr_context_switches() > 0) to verify that RCU
> >        switches out of boot-time mode before the first context
> >        switch, as suggested by Nick Piggin.
> >
> > Changes since v2:
> >
> > o       Created rcu_blocking_is_gp() internal-to-RCU API that
> >        determines whether a call to synchronize_rcu() is itself
> >        a grace period.
> >
> > o       The definition of rcu_blocking_is_gp() for rcuclassic and
> >        rcutree checks to see if but a single CPU is online.
> >
> > o       The definition of rcu_blocking_is_gp() for rcupreempt
> >        checks to see both if but a single CPU is online and if
> >        the system is still in early boot.
> >
> >        This allows rcupreempt to again work correctly if running
> >        on a single CPU after booting is complete.
> >
> > o       Added check to rcupreempt's synchronize_sched() for there
> >        being but one online CPU.
> >
> > Tested all three variants both SMP and !SMP, booted fine, passed a short
> > rcutorture test on both x86 and Power.
> >
> > Located-by: Vegard Nossum <vegard.nossum@gmail.com>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Tested-by: Vegard Nossum <vegard.nossum@gmail.com>
> 
> I used such a patch and config (as attached) to verify. On unpatched
> kernel, I get this:
> 
> rcu callbacks called: 2300 (should be 4000)
> 
> And with the patch, it seems better:
> 
> rcu callbacks called: 4000 (should be 4000)
> 
> Actually, the first part of the text itself is wrong, because it used
> to count upwards. But it should really say "rcu callbacks NOT called".

Yes, your test patch does look like it validates my patch, thank you!!!

> Of course, this kind of check will always be inaccurate, so it is not
> fit for mainline. The inaccuracy stems from the fact that there could
> be other users of RCU that disturb our expected behaviour, and we
> don't know how quickly the callbacks will be run, only that if
> "enough" of them run inside the spinlock, something is probably wrong.
> But... what am I saying, you're the expert ;-)

On RCU, maybe, but the boot-time code has changed considerably since
I last looked at it.  ;-)

> But it is useful enough to verify your patch. Some other configs I
> tried gave the correct result all the time, but I don't know what is
> special about this one.

Thank you again!!!

I will be submitting another patch that differs only in the names of
the variable and function that Ingo pointed out, so I believe it will
be legitimate to attach your Tested-by: to that upcoming patch.

							Thanx, Paul
