Return-Path: <linux-kernel-owner+w=401wt.eu-S1753470AbZFECTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470AbZFECTY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 22:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752161AbZFECTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 22:19:17 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37591 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751976AbZFECTQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 22:19:16 -0400
Date: Fri, 5 Jun 2009 04:14:30 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] cpuhotplug: introduce try_get_online_cpus() take 2
Message-ID: <20090605021430.GA24872@redhat.com>
References: <4A1F9CEA.1070705@cn.fujitsu.com> <20090530015342.GA21502@linux.vnet.ibm.com> <20090530043739.GA12157@in.ibm.com> <4A27708C.6030703@cn.fujitsu.com> <20090604204958.GA5071@redhat.com> <4A28759D.4040602@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A28759D.4040602@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05, Lai Jiangshan wrote:
>
> Oleg Nesterov wrote:
> > On 06/04, Lai Jiangshan wrote:
> >>
> >> +	if (unlikely(!atomic_inc_not_zero(&cpu_hotplug.refcount))) {
> >> +		DEFINE_WAIT(wait);
> >> +
> >> +		for (;;) {
> >> +			prepare_to_wait(&cpu_hotplug.sleeping_readers, &wait,
> >> +					TASK_UNINTERRUPTIBLE);
> >> +			if (atomic_inc_not_zero(&cpu_hotplug.refcount))
> >> +				break;
> >> +			schedule();
> >> +		}
> >> +
> >> +		finish_wait(&cpu_hotplug.sleeping_readers, &wait);
> >> +	}
> >>  }
> >
> > Looks like the code above can be replaced with
> >
> > 	wait_event(atomic_inc_not_zero(&cpu_hotplug.refcount));
>
> You are right, but with the atomic_inc_not_zero() has side-effect,
> I'm afraid that wait_event() will be changed in future, and it may
> increases the cpu_hotplug.refcount twice.

We already have side-effects in wait_event(), see use_module().
And  wait_event(atomic_inc_not_zero()) is much easier to understand.

Personally, I think wait_event() must work correctly if "condition"
has side-effects.

But this is subjective. So, of course, please do what you like more.

> > Hmm. It seems to me that cpu_hotplug_done() needs mb__before_atomic_inc()
> > before atomic_inc. Otherwise, "active_writer = NULL" can be re-ordered with
> > atomic_inc(). If the new reader does get_online_cpus() + put_online_cpus()
> > quicky, it can see active_writer != NULL.
> >
>
> The lines "active_writer = NULL" and "atomic_inc()" can exchange,
> there is no code need to synchronize to them.
> get_online_cpus()/put_online_cpus() will see "active_writer != current",
> it just what get_online_cpus()/put_online_cpus() needs.

I meant another problem, but I misread the patch. When I actually applied
it I don't see any problems with re-ordering.

This means I should find something else ;) put_online_cpus() does not
need smp_mb__after_atomic_dec(). atomic_dec_and_test() implies mb() on
both sides, this is even documented.

Oleg.

