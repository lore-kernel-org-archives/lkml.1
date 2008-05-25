Return-Path: <linux-kernel-owner+w=401wt.eu-S1754750AbYEYNHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750AbYEYNHc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 09:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752335AbYEYNHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 09:07:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:58311 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbYEYNHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 09:07:19 -0400
Date: Sun, 25 May 2008 09:07:15 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Thomas Gleixner <tglx@linutronix.de>
cc: LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>, akpm@osdl.org,
       Ingo Molnar <mingo@elte.hu>, Clark Williams <clark.williams@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Gregory Haskins <ghaskins@novell.com>, Andi Kleen <ak@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] x86: enable preemption in delay
In-Reply-To: <alpine.LFD.1.10.0805251406260.3295@apollo.tec.linutronix.de>
Message-ID: <Pine.LNX.4.58.0805250905080.20291@gandalf.stny.rr.com>
References: <Pine.LNX.4.58.0805242306280.3977@gandalf.stny.rr.com>
 <alpine.LFD.1.10.0805251406260.3295@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 25 May 2008, Thomas Gleixner wrote:
> > -	preempt_disable();		/* TSC's are per-cpu */
> > +	preempt_disable();
> > +	cpu = smp_processor_id();
> >  	rdtscl(bclock);
> >  	do {
> >  		rep_nop();
> >  		rdtscl(now);
> > +		/* Allow RT tasks to run */
> > +		preempt_enable();
> > +		preempt_disable();
> > +		/*
> > +		 * It is possible that we moved to another CPU,
> > +		 * and since TSC's are per-cpu we need to
> > +		 * calculate that. The delay must guarantee that
> > +		 * we wait "at least" the amount of time. Being
> > +		 * moved to another CPU could make the wait longer
> > +		 * but we just need to make sure we waited long
> > +		 * enough. Rebalance the counter for this CPU.
> > +		 */
> > +		if (unlikely(cpu != smp_processor_id())) {
>
> Eeek, once you migrated you do this all the time. you need to update
> cpu here.

Good catch! I'll update that.

>
> > +			if ((now-bclock) >= loops)
> > +				break;
>
> Also this is really dangerous with unsynchronized TSCs. You might get
> migrated and return immediately because the TSC on the other CPU is
> far ahead.

No it isn't ;-)

The now and bclock are both from before the migration. The cpus were the
same becaues we were under preempt disbled at the time. I recalculate
after the change has been noticed.

But you are right, I forgot to update cpu. :-/

>
> What you really want is something like the patch below, but we should
> reuse the sched_clock_cpu() thingy to make that simpler. Looking into
> that right now.
>

Sure, but this should be simple enough.

-- Steve

