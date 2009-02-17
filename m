Return-Path: <linux-kernel-owner+w=401wt.eu-S1753875AbZBQSek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875AbZBQSek (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 13:34:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbZBQSeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 13:34:31 -0500
Received: from mx2.redhat.com ([66.187.237.31]:42217 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752898AbZBQSeb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 13:34:31 -0500
Date: Tue, 17 Feb 2009 19:30:14 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] generic-smp: remove kmalloc()
Message-ID: <20090217183014.GA3934@redhat.com>
References: <20090216163847.431174825@chello.nl> <20090216164114.433430761@chello.nl> <1234885258.4744.153.camel@laptop> <20090217172113.GA26459@redhat.com> <1234892420.4744.158.camel@laptop> <1234892764.4744.159.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234892764.4744.159.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17, Peter Zijlstra wrote:
>
> On Tue, 2009-02-17 at 18:40 +0100, Peter Zijlstra wrote:
>
> > > What do you think?
> >
> > While I would say, don't do that to your deadlock scenario, I do like
> > the extra freedom this provides, so I'm inclined to go with this. Let me
> > spin a new patch and build a kernel with it ;-)
>
> Should we do the same for the _single case? It too can copy the csd data
> into the stack and return before calling func.

If you are going to change _many(), then I'd say it makes sense to change
_single() too...

But, Peter, please think twice ;) I am not really sure we need this change.

Let's look at the deadlock scenario again,

        void func(void *arg)
        {
                lock(LOCK);
                unlock(LOCK);
        }

        smp_call_function(func, NULL, 0);

        lock(LOCK);
        smp_call_function(another_func, NULL, 0);
        unlock(LOCK);

First of all, if this LOCK can be locked from irq, then we need
lock_irq(LOCK) before the 2nd smp_call_function(). Yes, smp_call_function()
removes smp_processor_id() from ->mask, but still the code above is hardly
correct.

Otoh, perhaps we can allow to call smp_call_function() with irqs disabled
(unless wait of course), in that case this change makes a bit more sense.
Perhaps.

So this all is up to you. If you think this change does not complicate
the code too much, then we can count it as minor optimization, because it
can speedup smp_call_function() sometimes.

Oleg.

