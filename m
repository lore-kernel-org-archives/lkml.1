Return-Path: <linux-kernel-owner+w=401wt.eu-S1756136AbZA2Itg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136AbZA2Itg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 03:49:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753023AbZA2It1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 03:49:27 -0500
Received: from casper.infradead.org ([85.118.1.10]:51880 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102AbZA2It0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 03:49:26 -0500
Subject: Re: [PATCH] use per cpu data for single cpu ipi calls
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au, npiggin@suse.de, torvalds@linux-foundation.org,
       mingo@elte.hu, tglx@linutronix.de, arjan@infradead.org
In-Reply-To: <20090128173039.cbc29e81.akpm@linux-foundation.org>
References: <alpine.DEB.1.10.0901281029150.25359@gandalf.stny.rr.com>
	 <200901290955.38940.rusty@rustcorp.com.au>
	 <alpine.DEB.1.10.0901281916400.9203@gandalf.stny.rr.com>
	 <20090128173039.cbc29e81.akpm@linux-foundation.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 29 Jan 2009 09:49:14 +0100
Message-Id: <1233218954.7835.11.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-28 at 17:30 -0800, Andrew Morton wrote:
> On Wed, 28 Jan 2009 19:52:16 -0500 (EST)
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > 
> > The smp_call_function can be passed a wait parameter telling it to
> > wait for all the functions running on other CPUs to complete before
> > returning, or to return without waiting. Unfortunately, this is
> > currently just a suggestion and not manditory. That is, the
> 
> "mandatory"
> 
> > smp_call_function can decide not to return and wait instead.
> > 
> > The reason for this is because it uses kmalloc to allocate storage
> > to send to the called CPU and that CPU will free it when it is done.
> > But if we fail to allocate the storage, the stack is used instead.
> > This means we must wait for the called CPU to finish before
> > continuing.
> > 
> > Unfortunatly, some callers do no abide by this hint and act as if
> 
> "Unfortunately".
> 
> > the non-wait option is mandatory. The MTRR code for instance will
> > deadlock if the smp_call_function is set to wait. This is because
> > the smp_call_function will wait for the other CPUs to finish their
> > called functions, but those functions are waiting on the caller to
> > continue.
> > 
> > This patch changes the generic smp_call_function code to use per cpu
> > variables instead of allocating for a single CPU call. The
> > smp_call_function_many will fall back to the smp_call_function_single
> > if it fails its alloc. The smp_call_function_single is modified
> > to not force the wait state.
> > 
> > Since we now are using a single data per cpu we must synchronize the
> > callers to prevent a second caller modifying the data before the
> > first called IPI functions complete. To do so, I added a flag to
> > the call_single_data called CSD_FLAG_LOCK. When the single CPU is
> > called (which can be called when a many call fails an alloc), we
> > set the LOCK bit on this per cpu data. When the caller finishes
> > it clears the LOCK bit.
> > 
> > The caller must wait till the LOCK bit is cleared before setting
> > it. When it is cleared, there is no IPI function using it.
> > A spinlock is used to synchronize the setting of the bit between
> > callers. Since only one callee can be called at a time, and it
> > is the only thing to clear it, the IPI does not need to use
> > any locking.
> > 
> > Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> > ---
> > diff --git a/kernel/smp.c b/kernel/smp.c
> > index 5cfa0e5..aba3813 100644
> > --- a/kernel/smp.c
> > +++ b/kernel/smp.c
> > @@ -18,6 +18,7 @@ __cacheline_aligned_in_smp DEFINE_SPINLOCK(call_function_lock);
> >  enum {
> >  	CSD_FLAG_WAIT		= 0x01,
> >  	CSD_FLAG_ALLOC		= 0x02,
> > +	CSD_FLAG_LOCK		= 0x04,
> >  };
> >  
> >  struct call_function_data {
> > @@ -186,6 +187,9 @@ void generic_smp_call_function_single_interrupt(void)
> >  			if (data_flags & CSD_FLAG_WAIT) {
> >  				smp_wmb();
> >  				data->flags &= ~CSD_FLAG_WAIT;
> > +			} else if (data_flags & CSD_FLAG_LOCK) {
> > +				smp_wmb();
> > +				data->flags &= ~CSD_FLAG_LOCK;
> >  			} else if (data_flags & CSD_FLAG_ALLOC)
> >  				kfree(data);
> >  		}
> > @@ -196,6 +200,9 @@ void generic_smp_call_function_single_interrupt(void)
> >  	}
> >  }
> >  
> > +static DEFINE_PER_CPU(struct call_single_data, csd_data);
> > +static DEFINE_SPINLOCK(csd_data_lock);
> > +
> >  /*
> >   * smp_call_function_single - Run a function on a specific CPU
> >   * @func: The function to run. This must be fast and non-blocking.
> > @@ -224,14 +231,35 @@ int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
> >  		func(info);
> >  		local_irq_restore(flags);
> >  	} else if ((unsigned)cpu < nr_cpu_ids && cpu_online(cpu)) {
> > -		struct call_single_data *data = NULL;
> > +		struct call_single_data *data;
> >  
> >  		if (!wait) {
> > -			data = kmalloc(sizeof(*data), GFP_ATOMIC);
> > -			if (data)
> > -				data->flags = CSD_FLAG_ALLOC;
> > -		}

I would advise against removing this, it would destroy a lot of the
properties of smp_call_function_single() that it was designed to have.

That kmalloc allows you to send multiple requests and batch them.

> > -		if (!data) {
> > +			data = &per_cpu(csd_data, cpu);
> > +			/*
> > +			 * We are calling a function on a single CPU
> > +			 * and we are not going to wait for it to finish.
> > +			 * We use a per cpu data to pass the information
> > +			 * to that CPU, but since all callers of this
> > +			 * code will use the same data, we must
> > +			 * synchronize the callers to prevent a new caller
> > +			 * from corrupting the data before the callee
> > +			 * can access it.
> > +			 *
> > +			 * The CSD_FLAG_LOCK is used to let us know when
> > +			 * the IPI handler is done with the data.
> > +			 * The first caller will set it, and the callee
> > +			 * will clear it. The next caller must wait for
> > +			 * it to clear before we set it again. This
> > +			 * will make sure the callee is done with the
> > +			 * data before a new caller will use it.
> > +			 * We use spinlocks to manage the callers.
> > +			 */
> > +			spin_lock(&csd_data_lock);
> > +			while (data->flags & CSD_FLAG_LOCK)
> > +				cpu_relax();
> > +			data->flags = CSD_FLAG_LOCK;
> > +			spin_unlock(&csd_data_lock);
> > +		} else {
> >  			data = &d;
> >  			data->flags = CSD_FLAG_WAIT;
> >  		}
> 
> Well that looks nice.
> 
> Can we make the spinlock a per-cpu thing as well?  Or is that
> over-optimising?  We'd need to initialise all those spinlocks at
> runtime.

I think we should, its easy enough, and

static DEFINE_PER_CPU(spinlock_t, csd_lock) =
	__SPIN_LOCK_UNLOCKED(csd_lock);

might just work.

> In generic_smp_call_function_single_interrupt(), did you consider
> releasing the "lock" _before_ calling the callback function?  That
> would reduces latencies a bit, allow more concurrency.  Maybe that's
> over-optimising too.

You'd have to copy the func and info fields to do that, but yeah, that'd
work.

> Can generic_smp_call_function_single_interrupt() ever see
> CSD_FLAG_ALLOC set now?  If not, that kfree can go away.

Like said above, removing that kmalloc will hurt people.
