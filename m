Return-Path: <linux-kernel-owner+w=401wt.eu-S1752815AbZBPWZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815AbZBPWZn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 17:25:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751079AbZBPWZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 17:25:34 -0500
Received: from casper.infradead.org ([85.118.1.10]:32967 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbZBPWZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 17:25:33 -0500
Subject: Re: Q: smp.c && barriers (Was: [PATCH 1/4] generic-smp: remove
 single ipi fallback for smp_call_function_many())
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20090216220214.GA10093@redhat.com>
References: <20090216163847.431174825@chello.nl>
	 <20090216164114.433430761@chello.nl> <20090216204902.GA6924@redhat.com>
	 <1234818201.30178.386.camel@laptop> <20090216213205.GA9098@redhat.com>
	 <1234820704.30178.396.camel@laptop>  <20090216220214.GA10093@redhat.com>
Content-Type: text/plain
Date: Mon, 16 Feb 2009 23:24:57 +0100
Message-Id: <1234823097.30178.406.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-16 at 23:02 +0100, Oleg Nesterov wrote:
> On 02/16, Peter Zijlstra wrote:
> >
> > On Mon, 2009-02-16 at 22:32 +0100, Oleg Nesterov wrote:
> > > > I was about to write a response, but found it to be a justification for
> > > > the read_barrier_depends() at the end of the loop.
> > >
> > > I forgot to mention I don't understand the read_barrier_depends() at the
> > > end of the loop as well ;)
> >
> > Suppose cpu0 adds to csd to cpu1:
> >
> >
> >  cpu0:                 cpu1:
> >
> > add entry1
> > mb();
> > send ipi
> >                       run ipi handler
> >                       read_barrier_depends()
> >                       while (!list_empty())    [A]
> >                         do foo
> >
> > add entry2
> > mb();
> > [no ipi -- we still observe entry1]
> >
> >                         remove foo
> >                         read_barrier_depends()
> >                       while (!list_empty())      [B]
> 
> Still can't understand.
> 
> cpu1 (generic_smp_call_function_single_interrupt) does
> list_replace_init(q->lock), this lock is also taken by
> generic_exec_single().
> 
> Either cpu1 sees entry2 on list, or cpu0 sees list_empty()
> and sends ipi.

cpu0:		cpu1:

spin_lock_irqsave(&dst->lock, flags);
ipi = list_empty(&dst->list);
list_add_tail(&data->list, &dst->list);
spin_unlock_irqrestore(&dst->lock, flags);

ipi ----->

		while (!list_empty(&q->list)) {
                	unsigned int data_flags;

                	spin_lock(&q->lock);
               		list_replace_init(&q->list, &list);
	                spin_unlock(&q->lock);


Strictly speaking the unlock() is semi-permeable, allowing the read of
q->list to enter the critical section, allowing us to observe an empty
list, never getting to q->lock on cpu1.

The mb()/rbd() pair seems to avoid that.

> > The read_barrier_depends() matches the mb() on the other cpu, without
> > which the 'new' entry might not be observed.
> 
> And that mb() looks unneeded too. Again, because
> generic_smp_call_function_single_interrupt() takes call_single_queue.lock
> before it uses "data".
> 
> 
> Even if I missed something (very possible), then I can't understand
> why we need rmb() only on alpha.

Because only alpha is insane enough to do speculative reads? Dunno
really :-)

