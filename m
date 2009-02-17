Return-Path: <linux-kernel-owner+w=401wt.eu-S1753472AbZBQM3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472AbZBQM3n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 07:29:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751332AbZBQM3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 07:29:34 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59583 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913AbZBQM3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 07:29:33 -0500
Date: Tue, 17 Feb 2009 13:25:44 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] generic-smp: remove single ipi fallback for
	smp_call_function_many()
Message-ID: <20090217122544.GA14292@redhat.com>
References: <20090216163847.431174825@chello.nl> <20090216164114.433430761@chello.nl> <20090216191008.GA1521@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090216191008.GA1521@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16, Oleg Nesterov wrote:
>
> > +	data->refs = cpumask_weight(&data->cpumask);
> > +
> > +	spin_lock_irqsave(&call_function.lock, flags);
> > +	call_function.counter++;
> > +	list_add_tail_rcu(&data->csd.list, &call_function.queue);
> > +	spin_unlock_irqrestore(&call_function.lock, flags);
>
> What if the initialization above leaks into the critical section?
>
> I mean, generic_smp_call_function_interrupt() running on another CPU
> can see the result of list_add_tail_rcu() and cpumask_and(data->cpumask)
> but not (say) "data->refs = ...".

I was wrong, sorry.

list_add_tail_rcu() implies wmb() and list_for_each_entry_rcu() does
smp_read_barrier_depends(), so another CPU must always see the fully
initialized entry.

Oleg.

