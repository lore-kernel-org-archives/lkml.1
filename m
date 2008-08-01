Return-Path: <linux-kernel-owner+w=401wt.eu-S1762330AbYHAVQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762330AbYHAVQu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 17:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760006AbYHAVKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 17:10:45 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:40853 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760944AbYHAVKm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 17:10:42 -0400
Date: Fri, 1 Aug 2008 14:10:25 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [patch 01/17] RCU read sched
Message-ID: <20080801211025.GR14851@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080715222604.331269462@polymtl.ca> <20080715222746.136282703@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080715222746.136282703@polymtl.ca>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 06:26:05PM -0400, Mathieu Desnoyers wrote:
> Add rcu_read_lock_sched() and rcu_read_unlock_sched() to rcupdate.h to match the
> recently added write-side call_rcu_sched() and rcu_barrier_sched(). They also
> match the no-so-recently-added synchronize_sched().
> 
> It will help following matching use of the update/read lock primitives. Those
> new read lock will replace preempt_disable()/enable() used in pair with
> RCU-classic synchronization.

Looks good, but...

synchronize_sched(), call_rcu_sched(), and rcu_barrier_sched() can also
pair up with:

o	local_irq_save() and local_irq_restore()
o	local_irq_disable() and local_irq_enable()
o	spin_lock_irqsave() and spin_lock_irqrestore()
o	etc. etc.

I do very much like the idea of marking the intent of matching with
RCU, but am getting a bit queasy about adding rcu_read_lock_sched_irq()
and so on.

Thoughts?  Other than having an rcu_read_lock_sched_nop() or some
other window-dressing macro that doesn't really do anything?  (Which
might really be the right thing to do...)

						Thanx, Paul

> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: Paul E McKenney <paulmck@linux.vnet.ibm.com>
> CC: akpm@linux-foundation.org
> ---
>  include/linux/rcupdate.h |   18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> Index: linux-2.6-lttng/include/linux/rcupdate.h
> ===================================================================
> --- linux-2.6-lttng.orig/include/linux/rcupdate.h	2008-07-15 15:28:08.000000000 -0400
> +++ linux-2.6-lttng/include/linux/rcupdate.h	2008-07-15 17:38:02.000000000 -0400
> @@ -133,6 +133,24 @@ struct rcu_head {
>  #define rcu_read_unlock_bh() __rcu_read_unlock_bh()
> 
>  /**
> + * rcu_read_lock_sched - mark the beginning of a RCU-classic critical section
> + *
> + * Should be used with either
> + * - synchronize_sched()
> + * or
> + * - call_rcu_sched() and rcu_barrier_sched()
> + * on the write-side to insure proper synchronization.
> + */
> +#define rcu_read_lock_sched() preempt_disable()
> +
> +/*
> + * rcu_read_unlock_sched - marks the end of a RCU-classic critical section
> + *
> + * See rcu_read_lock_sched for more information.
> + */
> +#define rcu_read_unlock_sched() preempt_enable()
> +
> +/**
>   * rcu_dereference - fetch an RCU-protected pointer in an
>   * RCU read-side critical section.  This pointer may later
>   * be safely dereferenced.
> 
> -- 
> Mathieu Desnoyers
> Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
