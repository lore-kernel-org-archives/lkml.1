Return-Path: <linux-kernel-owner+w=401wt.eu-S1759320AbZKFEqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759320AbZKFEqm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 23:46:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756091AbZKFEqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 23:46:42 -0500
Received: from mail.gmx.net ([213.165.64.20]:34751 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750741AbZKFEql (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 23:46:41 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+tYTx9o66tsX2oIWIc9PFmhYm16PQIPxn7y48O+5
	6xRRZ0qpt+yHCs
Subject: Re: [patch] Re: There is something with scheduler (was Re: [patch]
 Re: [regression bisect -next] BUG: using smp_processor_id() in preemptible
 [00000000] code: rmmod)
From: Mike Galbraith <efault@gmx.de>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       hpa@zytor.com, tglx@linutronix.de
In-Reply-To: <4AF38A72.9000900@cn.fujitsu.com>
References: <1256784158.2848.8.camel@dhcp231-106.rdu.redhat.com>
	 <1256805552.7158.22.camel@marge.simson.net>
	 <20091029091411.GE22963@elte.hu>
	 <1256807967.7158.58.camel@marge.simson.net>
	 <1256813310.7574.3.camel@marge.simson.net> <20091102182808.GA8950@elte.hu>
	 <1257190811.19608.2.camel@marge.simson.net>
	 <4AF2AC30.4000003@cn.fujitsu.com>
	 <1257430388.6437.31.camel@marge.simson.net>
	 <1257431437.7016.3.camel@marge.simson.net>
	 <1257462632.6560.8.camel@marge.simson.net>
	 <4AF38A72.9000900@cn.fujitsu.com>
Content-Type: text/plain
Date: Fri, 06 Nov 2009 05:46:43 +0100
Message-Id: <1257482803.6956.4.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.63
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-11-06 at 10:31 +0800, Lai Jiangshan wrote:
>  
> > +/*
> > + * cpu_rq_lock - lock the runqueue a given task resides on and disable
> > + * interrupts. Note the ordering: we can safely lookup the cpu_rq without
> > + * explicitly disabling preemption.
> > + */
> > +static struct rq *cpu_rq_lock(int cpu, unsigned long *flags)
> > +	__acquires(rq->lock)
> > +{
> > +	struct rq *rq;
> > +
> > +	for (;;) {
> > +		local_irq_save(*flags);
> > +		rq = cpu_rq(cpu);
> > +		spin_lock(&rq->lock);
> > +		if (likely(rq == cpu_rq(cpu)))
> > +			return rq;
> > +		spin_unlock_irqrestore(&rq->lock, *flags);
> > +	}
> > +}
> > +
> > +static inline void cpu_rq_unlock(struct rq *rq, unsigned long *flags)
> > +	__releases(rq->lock)
> > +{
> > +	spin_unlock_irqrestore(&rq->lock, *flags);
> > +}
> > +
> 
> The above code is totally garbage, cpu_rq(cpu) is constant.

No, that's not the garbage bit.  The true hazard of late late night is
that you can't _see_ anymore.  cpu_rq_lock + spin_unlock :)))))

Now I'm _really_ puzzled.  Embarrassing, but funny.

	-Mike

