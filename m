Return-Path: <linux-kernel-owner+w=401wt.eu-S1758205AbZA2PeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205AbZA2PeS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 10:34:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752149AbZA2PeD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 10:34:03 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:47889 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117AbZA2PeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 10:34:01 -0500
Subject: Re: [PATCH -v2] use per cpu data for single cpu ipi calls
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, npiggin@suse.de,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>, jens.axboe@oracle.com
In-Reply-To: <alpine.DEB.1.10.0901290958170.13065@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0901281029150.25359@gandalf.stny.rr.com>
	 <200901290955.38940.rusty@rustcorp.com.au>
	 <alpine.DEB.1.10.0901281916400.9203@gandalf.stny.rr.com>
	 <20090128173039.cbc29e81.akpm@linux-foundation.org>
	 <1233218954.7835.11.camel@twins>
	 <alpine.DEB.1.10.0901290958170.13065@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Thu, 29 Jan 2009 16:33:32 +0100
Message-Id: <1233243212.4495.102.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-29 at 10:08 -0500, Steven Rostedt wrote:
> The smp_call_function can be passed a wait parameter telling it to
> wait for all the functions running on other CPUs to complete before
> returning, or to return without waiting. Unfortunately, this is
> currently just a suggestion and not manditory. That is, the
> smp_call_function can decide not to return and wait instead.
> 
> The reason for this is because it uses kmalloc to allocate storage
> to send to the called CPU and that CPU will free it when it is done.
> But if we fail to allocate the storage, the stack is used instead.
> This means we must wait for the called CPU to finish before
> continuing.
> 
> Unfortunatly, some callers do no abide by this hint and act as if
> the non-wait option is mandatory. The MTRR code for instance will
> deadlock if the smp_call_function is set to wait. This is because
> the smp_call_function will wait for the other CPUs to finish their
> called functions, but those functions are waiting on the caller to
> continue.
> 
> This patch changes the generic smp_call_function code to use per cpu
> variables if the allocation of the data fails for a single CPU call. The
> smp_call_function_many will fall back to the smp_call_function_single
> if it fails its alloc. The smp_call_function_single is modified
> to not force the wait state.
> 
> Since we now are using a single data per cpu we must synchronize the
> callers to prevent a second caller modifying the data before the
> first called IPI functions complete. To do so, I added a flag to
> the call_single_data called CSD_FLAG_LOCK. When the single CPU is
> called (which can be called when a many call fails an alloc), we
> set the LOCK bit on this per cpu data. When the caller finishes
> it clears the LOCK bit.
> 
> The caller must wait till the LOCK bit is cleared before setting
> it. When it is cleared, there is no IPI function using it.
> A spinlock is used to synchronize the setting of the bit between
> callers. Since only one callee can be called at a time, and it
> is the only thing to clear it, the IPI does not need to use
> any locking.
> 
>  [
>    changes for v2:
> 
>    -- kept kmalloc and only use per cpu if kmalloc fails.
>           (Requested by Peter Zijlstra)
> 
>    -- added per cpu spinlocks
>           (Requested by Andrew Morton and Peter Zijlstra)
>  ]
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>

Looks nice, thanks!

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

> ---
> diff --git a/kernel/smp.c b/kernel/smp.c
> index 5cfa0e5..9bce851 100644
> --- a/kernel/smp.c
> +++ b/kernel/smp.c
> @@ -18,6 +18,7 @@ __cacheline_aligned_in_smp DEFINE_SPINLOCK(call_function_lock);
>  enum {
>  	CSD_FLAG_WAIT		= 0x01,
>  	CSD_FLAG_ALLOC		= 0x02,
> +	CSD_FLAG_LOCK		= 0x04,
>  };
>  
>  struct call_function_data {
> @@ -186,6 +187,9 @@ void generic_smp_call_function_single_interrupt(void)
>  			if (data_flags & CSD_FLAG_WAIT) {
>  				smp_wmb();
>  				data->flags &= ~CSD_FLAG_WAIT;
> +			} else if (data_flags & CSD_FLAG_LOCK) {
> +				smp_wmb();
> +				data->flags &= ~CSD_FLAG_LOCK;
>  			} else if (data_flags & CSD_FLAG_ALLOC)
>  				kfree(data);
>  		}
> @@ -196,6 +200,10 @@ void generic_smp_call_function_single_interrupt(void)
>  	}
>  }
>  
> +static DEFINE_PER_CPU(struct call_single_data, csd_data);
> +static DEFINE_PER_CPU(spinlock_t, csd_data_lock) =
> +	__SPIN_LOCK_UNLOCKED(csd_lock);
> +
>  /*
>   * smp_call_function_single - Run a function on a specific CPU
>   * @func: The function to run. This must be fast and non-blocking.
> @@ -224,14 +232,41 @@ int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
>  		func(info);
>  		local_irq_restore(flags);
>  	} else if ((unsigned)cpu < nr_cpu_ids && cpu_online(cpu)) {
> -		struct call_single_data *data = NULL;
> +		struct call_single_data *data;
>  
>  		if (!wait) {
> +			/*
> +			 * We are calling a function on a single CPU
> +			 * and we are not going to wait for it to finish.
> +			 * We first try to allocate the data, but if we
> +			 * fail, we fall back to use a per cpu data to pass
> +			 * the information to that CPU. Since all callers
> +			 * of this code will use the same data, we must
> +			 * synchronize the callers to prevent a new caller
> +			 * from corrupting the data before the callee
> +			 * can access it.
> +			 *
> +			 * The CSD_FLAG_LOCK is used to let us know when
> +			 * the IPI handler is done with the data.
> +			 * The first caller will set it, and the callee
> +			 * will clear it. The next caller must wait for
> +			 * it to clear before we set it again. This
> +			 * will make sure the callee is done with the
> +			 * data before a new caller will use it.
> +			 * We use spinlocks to manage the callers.
> +			 */
>  			data = kmalloc(sizeof(*data), GFP_ATOMIC);
>  			if (data)
>  				data->flags = CSD_FLAG_ALLOC;
> -		}
> -		if (!data) {
> +			else {
> +				data = &per_cpu(csd_data, cpu);
> +				spin_lock(&per_cpu(csd_data_lock, cpu));
> +				while (data->flags & CSD_FLAG_LOCK)
> +					cpu_relax();
> +				data->flags = CSD_FLAG_LOCK;
> +				spin_unlock(&per_cpu(csd_data_lock, cpu));
> +			}
> +		} else {
>  			data = &d;
>  			data->flags = CSD_FLAG_WAIT;
>  		}
> 

