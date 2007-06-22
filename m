Return-Path: <linux-kernel-owner+w=401wt.eu-S1756226AbXFVNdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226AbXFVNdb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 09:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753854AbXFVNdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 09:33:23 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:50400 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312AbXFVNdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 09:33:22 -0400
Subject: Re: [RFC PATCH 6/6] Convert tasklets to work queues
From: Steven Rostedt <rostedt@goodmis.org>
To: Daniel Walker <dwalker@mvista.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, kuznet@ms2.inr.ac.ru
In-Reply-To: <1182496008.3228.25.camel@dhcp193.mvista.com>
References: <20070622040014.234651401@goodmis.org>
	 <20070622040137.414439610@goodmis.org>
	 <1182496008.3228.25.camel@dhcp193.mvista.com>
Content-Type: text/plain
Date: Fri, 22 Jun 2007 09:29:18 -0400
Message-Id: <1182518958.5493.45.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-22 at 00:06 -0700, Daniel Walker wrote:

> > +void tasklet_schedule(struct tasklet_struct *t)
> > +{
> > +	BUG_ON(!ktaskletd_wq);
> > +	pr_debug("scheduling tasklet %s %p\n", t->n, t);
> 
> I'd change these pr_debug lines to "tasklet : scheduling %s %p\n" for
> readability ..

As Ingo suggested, the next round won't even have them.



> truct tasklet_struct, work);
> > +
> > +	if (unlikely(atomic_read(&t->count))) {
> > +		pr_debug("tasklet disabled %s %p\n", t->n, t);
> > +		set_bit(TASKLET_STATE_PENDING, &t->state);
> > +		smp_mb();
> > +		/* make sure we were not just enabled */
> > +		if (likely(atomic_read(&t->count)))
> > +			goto out;
> > +		clear_bit(TASKLET_STATE_PENDING, &t->state);
> 
> smp_mb__before_clear_bit ?

The smp_mb() is needed before the atomic_read. But since that atomic
read is in a conditional, no more barriers are needed if we continue.

Thanks go out to Oleg for pointing out the smp_mb was needed!


> > +
> > +void __init softirq_init(void)
> > +{
> > +}
> 
> ifdef's ?

Nah, ifdefs are ugly. Even uglier than stubbed functions. I guess I
could simply put it in the header as a define do {} while(0).

> 
> > +void init_tasklets(void)
> > +{
> > +	ktaskletd_wq = create_workqueue("tasklets");
> > +	BUG_ON(!ktaskletd_wq);
> > +}
> > +
> > +void takeover_tasklets(unsigned int cpu)
> > +{
> > +	pr_debug("Implement takeover tasklets??\n");
> > +}
> 
> hmm .. Looks like it's for migration of tasklets .. I take it your not
> sure that's handled ? Try cpu hotplug ..


Actually, I believe that the workqueues will handle it themselves, so I
don't need to do any special handling. Just another advantage of
converting tasklets into work queues.

> 
> > +void tasklet_init(struct tasklet_struct *t,
> > +		  void (*func)(unsigned long), unsigned long data)
> > +{
> > +	INIT_WORK(&t->work, work_tasklet_exec);
> > +	INIT_LIST_HEAD(&t->list);
> > +	t->state = 0;
> > +	atomic_set(&t->count, 0);
> > +	t->func = func;
> > +	t->data = data;
> > +	t->n = "anonymous";
> 
> Is this "anonymous" just used for debugging ? Is so you could fill it
> with a kallsyms lookup with the __builtin_return_address() ..

Yeah, they were started for debugging, but I also thought about making
some sort of interface for user land to see what was defined. So using
kallsyms might not look well. It's easy enough to find if an anonymous
tasklet gives me trouble.


-- Steve


