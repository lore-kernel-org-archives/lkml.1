Return-Path: <linux-kernel-owner+w=401wt.eu-S1759526AbXFVQh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759526AbXFVQh0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 12:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758480AbXFVQhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 12:37:15 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:36800 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758163AbXFVQhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 12:37:14 -0400
Subject: Re: [RFC PATCH 6/6] Convert tasklets to work queues
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Daniel Walker <dwalker@mvista.com>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, kuznet@ms2.inr.ac.ru
In-Reply-To: <20070622155247.GA133@tv-sign.ru>
References: <20070622040014.234651401@goodmis.org>
	 <20070622040137.414439610@goodmis.org>
	 <1182496008.3228.25.camel@dhcp193.mvista.com>
	 <1182518958.5493.45.camel@localhost.localdomain>
	 <20070622155247.GA133@tv-sign.ru>
Content-Type: text/plain
Date: Fri, 22 Jun 2007 12:35:25 -0400
Message-Id: <1182530125.5493.77.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-22 at 19:52 +0400, Oleg Nesterov wrote:
> On 06/22, Steven Rostedt wrote:
> >
> > > truct tasklet_struct, work);
> > > > +
> > > > +	if (unlikely(atomic_read(&t->count))) {
> > > > +		pr_debug("tasklet disabled %s %p\n", t->n, t);
> > > > +		set_bit(TASKLET_STATE_PENDING, &t->state);
> > > > +		smp_mb();
> > > > +		/* make sure we were not just enabled */
> > > > +		if (likely(atomic_read(&t->count)))
> > > > +			goto out;
> > > > +		clear_bit(TASKLET_STATE_PENDING, &t->state);

Yeah, I knew of the race but didn't think that running a tasklet
function twice would cause much harm here.  But not running it when it
needs to run, can have quite a negative impact.

> 
> So, t->func() will be executed twice because tasklet_enable() does
> tasklet_schedule().
> 
> 
> So I think we need a fix for work_tasklet_exec,
> 
> -		clear_bit(TASKLET_STATE_PENDING);
> +		if (!test_and_clear_bit(TASKLET_STATE_PENDING))
> 			goto out;
> 

OK, I like this. I'll add it in the next round.


> 
> 
> Steven, a very stupid suggestion, could you move the code for tasklet_enable()
> up, closer to tasklet_disable() ?

Not a stupid suggestion. I'll accommodate it.

Thanks,

-- Steve


