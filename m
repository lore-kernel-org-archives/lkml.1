Return-Path: <linux-kernel-owner+w=401wt.eu-S2992622AbXCBQ4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992622AbXCBQ4i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 11:56:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992623AbXCBQ4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 11:56:37 -0500
Received: from smtp.osdl.org ([65.172.181.24]:34409 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992620AbXCBQ4g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 11:56:36 -0500
Date: Fri, 2 Mar 2007 08:48:33 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       john stultz <johnstul@us.ibm.com>, Roman Zippel <zippel@linux-m68k.org>,
       Christian Borntraeger <cborntra@de.ibm.com>, linux-s390@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] timer/hrtimer: take per cpu locks in sane order
Message-Id: <20070302084833.732d09dd.akpm@linux-foundation.org>
In-Reply-To: <20070302142308.GB8226@osiris.boeblingen.de.ibm.com>
References: <20070227153051.GD7911@osiris.boeblingen.de.ibm.com>
	<20070302125848.GA8226@osiris.boeblingen.de.ibm.com>
	<20070302130433.GA4391@elte.hu>
	<20070302142308.GB8226@osiris.boeblingen.de.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Mar 2007 15:23:08 +0100 Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> On Fri, Mar 02, 2007 at 02:04:33PM +0100, Ingo Molnar wrote:
> > 
> > * Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> > 
> > > -	spin_lock(&new_base->lock);
> > > -	spin_lock(&old_base->lock);
> > > +	/*
> > > +	 * If we take a lock from a different cpu, make sure we have always
> > > +	 * the same locking order. That is the lock that belongs to the cpu
> > > +	 * with the lowest number is taken first.
> > > +	 */
> > > +	lock1 = smp_processor_id() < cpu ? &new_base->lock : &old_base->lock;
> > > +	lock2 = smp_processor_id() < cpu ? &old_base->lock : &new_base->lock;
> > > +	spin_lock(lock1);
> > > +	spin_lock(lock2);
> > 
> > looks good to me. Wouldnt this be cleaner via double_lock_timer() - 
> > similar to how double_rq_lock() works in kernel/sched.c - instead of 
> > open-coding it?
> 
> Something like the stuff below? Exploits the knowledge that the two
> tvec_base_t's are in a per_cpu array. Otherwise I would end up passing
> a lot of redundant stuff. But still I think that isn't a good solution
> but rather a hack...?
> I'd go for the patch above.

Yeah, it'd be nicer to pass in the CPU number(s), use that to make the
ordering decision.  Perhaps (smp_processor_id() - cpu).

> ---
> Index: linux-2.6/kernel/timer.c
> ===================================================================
> --- linux-2.6.orig/kernel/timer.c
> +++ linux-2.6/kernel/timer.c
> @@ -1640,6 +1640,28 @@ static void migrate_timer_list(tvec_base
>  	}
>  }
>  
> +static void __devinit double_tvec_lock(tvec_base_t *base1, tvec_base_t *base2)
> +{
> +	if (base1 < base2) {
> +		spin_lock(&base1->lock);
> +		spin_lock(&base2->lock);
> +	} else {
> +		spin_lock(&base2->lock);
> +		spin_lock(&base1->lock);
> +	}
> +}
> +
> +static void __devinit double_tvec_unlock(tvec_base_t *base1, tvec_base_t *base2)
> +{
> +	if (base1 < base2) {
> +		spin_unlock(&base1->lock);
> +		spin_unlock(&base2->lock);
> +	} else {
> +		spin_unlock(&base2->lock);
> +		spin_unlock(&base1->lock);
> +	}
> +}

And to undo the locks in the reverse order from that in which they were
taken.


