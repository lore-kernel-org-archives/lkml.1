Return-Path: <linux-kernel-owner+w=401wt.eu-S1759314AbZDFPnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759314AbZDFPnP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 11:43:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757274AbZDFPhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 11:37:13 -0400
Received: from www.tglx.de ([62.245.132.106]:59700 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757067AbZDFPhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 11:37:11 -0400
Date: Mon, 6 Apr 2009 17:35:09 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       a.p.zijlstra@chello.nl, ego@in.ibm.com, mingo@elte.hu,
       andi@firstfloor.org, venkatesh.pallipadi@intel.com,
       vatsa@linux.vnet.ibm.com, arjan@infradead.org,
       svaidy@linux.vnet.ibm.com
Subject: Re: [v4 RFC PATCH 4/4] timers: logic to move non pinned timers
In-Reply-To: <20090406152843.GA11645@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.2.00.0904061732020.21577@localhost.localdomain>
References: <20090401113128.GA22478@linux.vnet.ibm.com> <20090401113738.GE22478@linux.vnet.ibm.com> <alpine.LFD.2.00.0904032142460.12916@localhost.localdomain> <20090406051656.GA17412@linux.vnet.ibm.com> <20090406104228.GB17412@linux.vnet.ibm.com>
 <alpine.LFD.2.00.0904061248120.747@localhost.localdomain> <20090406152843.GA11645@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arun,

On Mon, 6 Apr 2009, Arun R Bharadwaj wrote:
> > > -	new_cpu_base = &__get_cpu_var(hrtimer_bases);
> > > +again:
> > > +	new_cpu_base = &per_cpu(hrtimer_bases, cpu);
> > >  	new_base = &new_cpu_base->clock_base[base->index];
> > >  
> > >  	if (base != new_base) {
> > > @@ -220,6 +242,32 @@ switch_hrtimer_base(struct hrtimer *time
> > >  		spin_unlock(&base->cpu_base->lock);
> > >  		spin_lock(&new_base->cpu_base->lock);
> > >  		timer->base = new_base;
> > > +
> > > +		if (cpu == preferred_cpu) {
> > > +			/* Calculate clock monotonic expiry time */
> > > +			ktime_t expires = ktime_sub(hrtimer_get_expires(timer),
> > > +							new_base->offset);
> > > +
> > > +			/*
> > > +			 * Get the next event on target cpu from the
> > > +			 * clock events layer.
> > > +			 * This covers the highres=off nohz=on case as well.
> > > +			 */
> > > +			ktime_t next = clockevents_get_next_event(cpu);
> > > +
> > > +			ktime_t delta = ktime_sub(expires, next);
> > > +
> > > +			/*
> > > +			 * We do not migrate the timer when it is expiring
> > > +			 * before the next event on the target cpu because
> > > +			 * we cannot reprogram the target cpu hardware and
> > > +			 * we would cause it to fire late.
> > > +			 */
> > > +			if (delta.tv64 < 0) {
> > > +				cpu = smp_processor_id();
> > 
> >   You are missing a small but fatal detail here: You hold
> >   new_base->cpu_base->lock. So you need to do:
> >
> 
> I just moved the if block.. if (cpu==preferred_cpu) above the base
> locking part to avoid the extra unlocking.

That's not a good idea. You want to look at the next event with the
base lock of the other cpu held. That prevents that expires the first
pending timer right after you checked next_event and before you queue
your timer, which then might become the first timer to expire but you
can't reprogram the clock event device on the other cpu.

Thanks,

	tglx
