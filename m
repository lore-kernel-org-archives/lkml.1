Return-Path: <linux-kernel-owner+w=401wt.eu-S932065AbYEBCMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065AbYEBCMs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 22:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755448AbYEBCMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 22:12:40 -0400
Received: from ns2.suse.de ([195.135.220.15]:35588 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753981AbYEBCMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 22:12:39 -0400
Date: Fri, 2 May 2008 04:12:34 +0200
From: Nick Piggin <npiggin@suse.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       peterz@infradead.org, linux-arch@vger.kernel.org, jeremy@goop.org,
       mingo@elte.hu
Subject: Re: [PATCH 1/10] Add generic helpers for arch IPI function calls
Message-ID: <20080502021233.GC11844@wotan.suse.de>
References: <1209453990-7735-1-git-send-email-jens.axboe@oracle.com> <1209453990-7735-2-git-send-email-jens.axboe@oracle.com> <20080429135936.GC12390@linux.vnet.ibm.com> <20080430112934.GA23203@linux.vnet.ibm.com> <20080430113456.GY12774@kernel.dk> <20080430121712.GR11126@linux.vnet.ibm.com> <20080430123717.GC12774@kernel.dk> <20080502020241.GA26088@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080502020241.GA26088@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2008 at 07:02:41PM -0700, Paul E. McKenney wrote:
> On Wed, Apr 30, 2008 at 02:37:17PM +0200, Jens Axboe wrote:
> > > Here are some (probably totally broken) ideas:
> > > 
> > > 1.	Global lock so that only one smp_call_function() in the
> > > 	system proceeds.  Additional calls would be spinning with
> > > 	irqs -enabled- on the lock, avoiding deadlock.  Kind of
> > > 	defeats the purpose of your list, though...
> > 
> > That is what we used to do, that will obviously work. But defeats most
> > of the purpose, unfortunately :-)
> > 
> > > 2.	Maintain a global mask of current targets of smp_call_function()
> > > 	CPUs.  A given CPU may proceed if it is not a current target
> > > 	and if none of its target CPUs are already in the mask.
> > > 	This mask would be manipulated under a global lock.
> > > 
> > > 3.	As in #2 above, but use per-CPU counters.  This allows the
> > > 	current CPU to proceed if it is not a target, but also allows
> > > 	concurrent smp_call_function()s to proceed even if their
> > > 	lists of target CPUs overlap.
> > > 
> > > 4.	#2 or #3, but where CPUs can proceed freely if their allocation
> > > 	succeeded.
> > > 
> > > 5.	If a given CPU is waiting for other CPUs to respond, it polls
> > > 	its own list (with irqs disabled), thus breaking the deadlock.
> > > 	This means that you cannot call smp_call_function() while holding
> > > 	a lock that might be acquired by the called function, but that
> > > 	is not a new prohibition -- the only safe way to hold such a
> > > 	lock is with irqs disabled, and you are not allowed to call
> > > 	the smp_call_function() with irqs disabled in the first place
> > > 	(right?).
> > > 
> > > #5 might actually work...
> > 
> > Yeah, #5 sounds quite promising. I'll see if I can work up a patch for
> > that, or if you feel so inclined, I'll definitely take patches :-)
> > 
> > The branch is 'generic-ipi' on git://git.kernel.dk/linux-2.6-block.git
> > The link is pretty slow, so it's best pull'ed off of Linus base. Or just
> > grab the patches from the gitweb interface:
> > 
> > http://git.kernel.dk/?p=linux-2.6-block.git;a=shortlog;h=refs/heads/generic-ipi
> 
> And here is an untested patch for getting rid of the fallback element,
> and eliminating the "wait" deadlocks.

Hey this is coming along really nicely, thanks guys.

The only problem I have with this is that if you turn IRQs off, you
probably don't expect call function functions to be processed under
you (sure that doesn't happen now, but it could if anybody actually
starts to call IPIs under irq off).

What I _really_ wanted to do is just keep the core API as a non-deadlocky
one that has its data passed into it; and then implemented the fallbacky,
deadlocky one on top of that. In places where it makes sense, callers
could then use the new API if they want to.

We could make another rule that smp_call_function might also run functions,
but IMO that is starting to turn into spaghetti ;) Clever spaghetti though,
I give you that!


> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
> 
>  smp.c |   80 +++++++++++-------------------------------------------------------
>  1 file changed, 14 insertions(+), 66 deletions(-)
> 
> diff --git a/kernel/smp.c b/kernel/smp.c
> index 36d3eca..9df96fa 100644
> --- a/kernel/smp.c
> +++ b/kernel/smp.c
> @@ -17,7 +17,6 @@ __cacheline_aligned_in_smp DEFINE_SPINLOCK(call_function_lock);
>  enum {
>  	CSD_FLAG_WAIT		= 0x01,
>  	CSD_FLAG_ALLOC		= 0x02,
> -	CSD_FLAG_FALLBACK	= 0x04,
>  };
>  
>  struct call_function_data {
> @@ -33,9 +32,6 @@ struct call_single_queue {
>  	spinlock_t lock;
>  };
>  
> -static DEFINE_PER_CPU(struct call_function_data, cfd_fallback);
> -static DEFINE_PER_CPU(unsigned long, cfd_fallback_used);
> -
>  void __cpuinit init_call_single_data(void)
>  {
>  	int i;
> @@ -59,6 +55,7 @@ static void csd_flag_wait(struct call_single_data *data)
>  		if (!(data->flags & CSD_FLAG_WAIT))
>  			break;
>  		cpu_relax();
> +		generic_smp_call_function_interrupt();
>  	} while (1);
>  }
>  
> @@ -84,48 +81,13 @@ static void generic_exec_single(int cpu, struct call_single_data *data)
>  		csd_flag_wait(data);
>  }
>  
> -/*
> - * We need to have a global per-cpu fallback of call_function_data, so
> - * we can safely proceed with smp_call_function() if dynamic allocation
> - * fails and we cannot fall back to on-stack allocation (if wait == 0).
> - */
> -static noinline void acquire_cpu_fallback(int cpu)
> -{
> -	while (test_and_set_bit_lock(0, &per_cpu(cfd_fallback_used, cpu)))
> -		cpu_relax();
> -}
> -
> -static noinline void free_cpu_fallback(struct call_single_data *csd)
> -{
> -	struct call_function_data *data;
> -	int cpu;
> -
> -	data = container_of(csd, struct call_function_data, csd);
> -
> -	/*
> -	 * We could drop this loop by embedding a cpu variable in
> -	 * csd, but this should happen so extremely rarely (if ever)
> -	 * that this seems like a better idea
> -	 */
> -	for_each_possible_cpu(cpu) {
> -		if (&per_cpu(cfd_fallback, cpu) != data)
> -			continue;
> -
> -		clear_bit_unlock(0, &per_cpu(cfd_fallback_used, cpu));
> -		break;
> -	}
> -}
> -
>  static void rcu_free_call_data(struct rcu_head *head)
>  {
>  	struct call_function_data *data;
>  
>  	data = container_of(head, struct call_function_data, rcu_head);
>  
> -	if (data->csd.flags & CSD_FLAG_ALLOC)
> -		kfree(data);
> -	else
> -		free_cpu_fallback(&data->csd);
> +	kfree(data);
>  }
>  
>  /*
> @@ -222,8 +184,6 @@ void generic_smp_call_function_single_interrupt(void)
>  				data->flags &= ~CSD_FLAG_WAIT;
>  			} else if (data_flags & CSD_FLAG_ALLOC)
>  				kfree(data);
> -			else if (data_flags & CSD_FLAG_FALLBACK)
> -				free_cpu_fallback(data);
>  		}
>  		/*
>  		 * See comment on outer loop
> @@ -244,6 +204,7 @@ void generic_smp_call_function_single_interrupt(void)
>  int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
>  			     int retry, int wait)
>  {
> +	struct call_single_data d = NULL;
>  	unsigned long flags;
>  	/* prevent preemption and reschedule on another processor */
>  	int me = get_cpu();
> @@ -258,21 +219,14 @@ int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
>  	} else {
>  		struct call_single_data *data;
>  
> -		if (wait) {
> -			struct call_single_data d;
> -
> -			data = &d;
> -			data->flags = CSD_FLAG_WAIT;
> -		} else {
> +		if (!wait) {
>  			data = kmalloc(sizeof(*data), GFP_ATOMIC);
>  			if (data)
>  				data->flags = CSD_FLAG_ALLOC;
> -			else {
> -				acquire_cpu_fallback(me);
> -
> -				data = &per_cpu(cfd_fallback, me).csd;
> -				data->flags = CSD_FLAG_FALLBACK;
> -			}
> +		}
> +		if (!data) {
> +			data = &d;
> +			data->flags = CSD_FLAG_WAIT;
>  		}
>  
>  		data->func = func;
> @@ -320,6 +274,7 @@ void __smp_call_function_single(int cpu, struct call_single_data *data)
>  int smp_call_function_mask(cpumask_t mask, void (*func)(void *), void *info,
>  			   int wait)
>  {
> +	struct call_function_data d;
>  	struct call_function_data *data;
>  	cpumask_t allbutself;
>  	unsigned long flags;
> @@ -345,21 +300,14 @@ int smp_call_function_mask(cpumask_t mask, void (*func)(void *), void *info,
>  		return smp_call_function_single(cpu, func, info, 0, wait);
>  	}
>  
> -	if (wait) {
> -		struct call_function_data d;
> -
> -		data = &d;
> -		data->csd.flags = CSD_FLAG_WAIT;
> -	} else {
> +	if (!wait) {
>  		data = kmalloc(sizeof(*data), GFP_ATOMIC);
>  		if (data)
>  			data->csd.flags = CSD_FLAG_ALLOC;
> -		else {
> -			acquire_cpu_fallback(cpu);
> -
> -			data = &per_cpu(cfd_fallback, cpu);
> -			data->csd.flags = CSD_FLAG_FALLBACK;
> -		}
> +	}
> +	if (!data) {
> +		data = &d;
> +		data->csd.flags = CSD_FLAG_WAIT;
>  	}
>  
>  	spin_lock_init(&data->lock);
