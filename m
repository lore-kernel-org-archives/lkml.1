Return-Path: <linux-kernel-owner+w=401wt.eu-S1753463AbZDVOoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463AbZDVOoT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 10:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751433AbZDVOoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 10:44:09 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44798 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937AbZDVOoI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 10:44:08 -0400
Date: Wed, 22 Apr 2009 16:39:30 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, Trond.Myklebust@netapp.com,
       serue@us.ibm.com, steved@redhat.com, viro@zeniv.linux.org.uk,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Document that wake_up(), complete() and co. imply a
	full memory barrier
Message-ID: <20090422143930.GA1212@redhat.com>
References: <20090415162712.342d4c07.akpm@linux-foundation.org> <1239649429.16771.9.camel@heimdal.trondhjem.org> <20090413181733.GA10424@redhat.com> <32260.1239658818@redhat.com> <20090413214852.GA1127@redhat.com> <1239659841.16771.26.camel@heimdal.trondhjem.org> <20090413222451.GA2758@redhat.com> <14561.1239873018@redhat.com> <21239.1240407420@redhat.com> <20090422135134.GA5249@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090422135134.GA5249@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22, Ingo Molnar wrote:
>
> * David Howells <dhowells@redhat.com> wrote:
>
> > Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > > > That's an interesting question.  Should wake_up() imply a barrier of any
> > > > sort, I wonder.  Well, __wake_up() does impose a barrier as it uses a
> > > > spinlock, but I wonder if that's sufficient.
> > >
> > > wake_up() does imply the barrier. Note the smp_wmb() in try_to_wake_up().
> > > And in fact this wmb() implies mb(), because spin_lock() itself is STORE,
> > > and the futher LOADs can't leak up before spin_lock().
> > >
> > > But afaics, this doesn't matter? prepare_to_wait() sets
> > > task->state under wait_queue_head_t->lock and wake_up() takes
> > > this look too, so we can't miss the event.
> > >
> > > Or I completely misunderstood the issue...
> >
> > The problem is not what wake_up() and co. do, it's what you are
> > allowed to assume that they do.
> >
> > However, I think you're right, and that we can assume they imply a
> > full memory barrier.  To this end, I've attached a patch to
> > document this.
> >
> > David
> > ---
> > From: David Howells <dhowells@redhat.com>
> > Subject: [PATCH] Document that wake_up(), complete() and co. imply a full memory barrier
> >
> > Add to the memory barriers document to note that wake_up(), complete() and
> > co. all imply a full memory barrier.
>
> No. They dont generally imply a full memory barrier versus any
> arbitrary prior (or following) memory access.
>
> try_to_wake_up() has an smp_wmb() so it is a write memory barrier
> (but not necessarily a read memory barrier). Otherwise there are
> spinlocks there but spinlocks are not explicit 'full memory
> barriers'.

Yes. But please look at the changelog in

	 "Add memory barrier semantics to wake_up() & co"
	 04e2f1741d235ba599037734878d72e57cb302b5

However, I must admit, I don't understand how to document the semantics
correctly. This wmb() before spin_lock() ensures we don't read task->state
before previous STOREs. This is what we care about, and this is what
I meant when I said "this wmb() implies mb()".

So, I think that try_to_wake_up() implies that the LOADS after it can't be
reordered with STOREs before it (and wmb() of course).

Oleg.

