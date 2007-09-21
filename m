Return-Path: <linux-kernel-owner+w=401wt.eu-S1760905AbXIUXXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760905AbXIUXXZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 19:23:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753558AbXIUXXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 19:23:16 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:61722 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbXIUXXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 19:23:15 -0400
Date: Fri, 21 Sep 2007 19:23:09 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       dipankar@in.ibm.com, josht@linux.vnet.ibm.com, tytso@us.ibm.com,
       dvhltc@us.ibm.com, Thomas Gleixner <tglx@linutronix.de>,
       bunk@kernel.org, ego@in.ibm.com, oleg@tv-sign.ru
Subject: Re: [PATCH RFC 3/9] RCU: Preemptible RCU
In-Reply-To: <20070921224459.GD9059@linux.vnet.ibm.com>
Message-ID: <Pine.LNX.4.58.0709211914310.419@gandalf.stny.rr.com>
References: <20070910183004.GA3299@linux.vnet.ibm.com>
 <20070910183412.GC3819@linux.vnet.ibm.com> <20070921144003.GC15697@goodmis.org>
 <20070921174653.64c15a92@twins> <20070921223112.GG15697@goodmis.org>
 <20070921224459.GD9059@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



--
On Fri, 21 Sep 2007, Paul E. McKenney wrote:

>
> If you do a synchronize_rcu() it might well have to wait through the
> following sequence of states:
>
> Stage 0: (might have to wait through part of this to get out of "next" queue)
> 	rcu_try_flip_idle_state,	/* "I" */
> 	rcu_try_flip_waitack_state, 	/* "A" */
> 	rcu_try_flip_waitzero_state,	/* "Z" */
> 	rcu_try_flip_waitmb_state	/* "M" */
> Stage 1:
> 	rcu_try_flip_idle_state,	/* "I" */
> 	rcu_try_flip_waitack_state, 	/* "A" */
> 	rcu_try_flip_waitzero_state,	/* "Z" */
> 	rcu_try_flip_waitmb_state	/* "M" */
> Stage 2:
> 	rcu_try_flip_idle_state,	/* "I" */
> 	rcu_try_flip_waitack_state, 	/* "A" */
> 	rcu_try_flip_waitzero_state,	/* "Z" */
> 	rcu_try_flip_waitmb_state	/* "M" */
> Stage 3:
> 	rcu_try_flip_idle_state,	/* "I" */
> 	rcu_try_flip_waitack_state, 	/* "A" */
> 	rcu_try_flip_waitzero_state,	/* "Z" */
> 	rcu_try_flip_waitmb_state	/* "M" */
> Stage 4:
> 	rcu_try_flip_idle_state,	/* "I" */
> 	rcu_try_flip_waitack_state, 	/* "A" */
> 	rcu_try_flip_waitzero_state,	/* "Z" */
> 	rcu_try_flip_waitmb_state	/* "M" */
>
> So yes, grace periods do indeed have some latency.

Yes they do. I'm now at the point that I'm just "trusting" you that you
understand that each of these stages are needed. My IQ level only lets me
understand next -> wait -> done, but not the extra 3 shifts in wait.

;-)

> >
> > True, but the "me" confused me. Since that task struct is not me ;-)
>
> Well, who is it, then?  ;-)

It's the app I watch sitting there waiting it's turn for it's callback to
run.

> > > >
> > > > Isn't the GP detection done via a tasklet/softirq. So wouldn't a
> > > > local_bh_disable be sufficient here? You already cover NMIs, which would
> > > > also handle normal interrupts.
> > >
> > > This is also my understanding, but I think this disable is an
> > > 'optimization' in that it avoids the regular IRQs from jumping through
> > > these hoops outlined below.
> >
> > But isn't disabling irqs slower than doing a local_bh_disable? So the
> > majority of times (where irqs will not happen) we have this overhead.
>
> The current code absolutely must exclude the scheduling-clock hardirq
> handler.

ACKed,
The reasoning you gave in Peter's reply most certainly makes sense.


> > > > > + *
> > > > > + * If anyone is nuts enough to run this CONFIG_PREEMPT_RCU implementation
> > > >
> > > > Oh, come now! It's not "nuts" to use this ;-)
> > > >
> > > > > + * on a large SMP, they might want to use a hierarchical organization of
> > > > > + * the per-CPU-counter pairs.
> > > > > + */
> > >
> > > Its the large SMP case that's nuts, and on that I have to agree with
> > > Paul, its not really large SMP friendly.
> >
> > Hmm, that could be true. But on large SMP systems, you usually have a
> > large amounts of memory, so hopefully a really long synchronize_rcu
> > would not be a problem.
>
> Somewhere in the range from 64 to a few hundred CPUs, the global lock
> protecting the try_flip state machine would start sucking air pretty
> badly.  But the real problem is synchronize_sched(), which loops through
> all the CPUs --  this would likely cause problems at a few tens of
> CPUs, perhaps as early as 10-20.

hehe, From someone who's largest box is 4 CPUs, to me 16 CPUS is large.
But I can see hundreds, let alone thousands of CPUs would make a huge
grinding halt on things like synchronize_sched. God, imaging if all CPUs
did that approximately at the same time. The system would should a huge
jitter.

-- Steve

