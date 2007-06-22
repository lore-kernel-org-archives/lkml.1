Return-Path: <linux-kernel-owner+w=401wt.eu-S1758779AbXFVPwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758779AbXFVPwT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 11:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757666AbXFVPwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 11:52:11 -0400
Received: from mail.screens.ru ([213.234.233.54]:51667 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757620AbXFVPwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 11:52:10 -0400
Date: Fri, 22 Jun 2007 19:52:47 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Daniel Walker <dwalker@mvista.com>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, kuznet@ms2.inr.ac.ru
Subject: Re: [RFC PATCH 6/6] Convert tasklets to work queues
Message-ID: <20070622155247.GA133@tv-sign.ru>
References: <20070622040014.234651401@goodmis.org> <20070622040137.414439610@goodmis.org> <1182496008.3228.25.camel@dhcp193.mvista.com> <1182518958.5493.45.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1182518958.5493.45.camel@localhost.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22, Steven Rostedt wrote:
>
> > truct tasklet_struct, work);
> > > +
> > > +	if (unlikely(atomic_read(&t->count))) {
> > > +		pr_debug("tasklet disabled %s %p\n", t->n, t);
> > > +		set_bit(TASKLET_STATE_PENDING, &t->state);
> > > +		smp_mb();
> > > +		/* make sure we were not just enabled */
> > > +		if (likely(atomic_read(&t->count)))
> > > +			goto out;
> > > +		clear_bit(TASKLET_STATE_PENDING, &t->state);

Looking closer, I think this is not right, and the smp_mb__before_clear_bit()
can't help.


				/* t->count == 1 */

work_tasklet_exec()					tasklet_enable()

...

set_bit(TASKLET_STATE_PENDING);				atomic_dec_and_test(&t->count);


				/* t->count == 0 */


// False
if (atomic_read(&t->count))
	goto out;

							// True
							if (test_and_clear_bit(_PENDING))
								tasklet_schedule();


clear_bit(TASKLET_STATE_PENDING);

execute t->func();


So, t->func() will be executed twice because tasklet_enable() does
tasklet_schedule().


So I think we need a fix for work_tasklet_exec,

-		clear_bit(TASKLET_STATE_PENDING);
+		if (!test_and_clear_bit(TASKLET_STATE_PENDING))
			goto out;



Steven, a very stupid suggestion, could you move the code for tasklet_enable()
up, closer to tasklet_disable() ?

Oleg.

