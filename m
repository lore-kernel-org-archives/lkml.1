Return-Path: <linux-kernel-owner+w=401wt.eu-S1758617AbZA2SIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758617AbZA2SIi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 13:08:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752466AbZA2SI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 13:08:29 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:33656 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbZA2SI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 13:08:28 -0500
Date: Thu, 29 Jan 2009 13:08:27 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, npiggin@suse.de,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>, jens.axboe@oracle.com
Subject: Re: [PATCH -v2] use per cpu data for single cpu ipi calls
In-Reply-To: <1233251741.4495.111.camel@laptop>
Message-ID: <alpine.DEB.1.10.0901291306550.27527@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0901281029150.25359@gandalf.stny.rr.com>  <200901290955.38940.rusty@rustcorp.com.au>  <alpine.DEB.1.10.0901281916400.9203@gandalf.stny.rr.com>  <20090128173039.cbc29e81.akpm@linux-foundation.org>  <1233218954.7835.11.camel@twins>
  <alpine.DEB.1.10.0901290958170.13065@gandalf.stny.rr.com>  <alpine.LFD.2.00.0901290912320.3123@localhost.localdomain>  <1233251222.4495.110.camel@laptop> <1233251741.4495.111.camel@laptop>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 29 Jan 2009, Peter Zijlstra wrote:
> > 
> > 
> > > +                       else {
> > > +                               data = &per_cpu(csd_data, cpu);
> > > +                               spin_lock(&per_cpu(csd_data_lock, cpu));
> > > +                               while (data->flags & CSD_FLAG_LOCK)
> > > +                                       cpu_relax();
> > > +                               data->flags = CSD_FLAG_LOCK;
> > > +                               spin_unlock(&per_cpu(csd_data_lock, cpu));
> > > +                       }
> > 
> > I think your argument would hold if he did:
> > 
> >   data = &__get_cpu_var(csd_data);
> > 
> > But now he's actually grabbing the remote cpu's csd, and thus needs
> > atomicy around that remote csd -- which two cpus could contend for.
> 
> So the below should do
> 
> ---
>  kernel/smp.c |    6 +-----
>  1 files changed, 1 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/smp.c b/kernel/smp.c
> index 9bce851..9eead6c 100644
> --- a/kernel/smp.c
> +++ b/kernel/smp.c
> @@ -201,8 +201,6 @@ void generic_smp_call_function_single_interrupt(void)
>  }
>  
>  static DEFINE_PER_CPU(struct call_single_data, csd_data);
> -static DEFINE_PER_CPU(spinlock_t, csd_data_lock) =
> -	__SPIN_LOCK_UNLOCKED(csd_lock);
>  
>  /*
>   * smp_call_function_single - Run a function on a specific CPU
> @@ -259,12 +257,10 @@ int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
>  			if (data)
>  				data->flags = CSD_FLAG_ALLOC;
>  			else {
> -				data = &per_cpu(csd_data, cpu);
> -				spin_lock(&per_cpu(csd_data_lock, cpu));
> +				data = &per_cpu(csd_data, me);
>  				while (data->flags & CSD_FLAG_LOCK)
>  					cpu_relax();
>  				data->flags = CSD_FLAG_LOCK;
> -				spin_unlock(&per_cpu(csd_data_lock, cpu));
>  			}
>  		} else {
>  			data = &d;

Ah, OK.

So if we just use our own CPU data, we can through away the spinlocks and 
just do the test ourselves.

That's even better.

Ingo, can you apply Peter's patch on top of mine.

-- Steve

