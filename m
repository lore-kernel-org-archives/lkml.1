Return-Path: <linux-kernel-owner+w=401wt.eu-S1754102AbZDVO5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102AbZDVO5s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 10:57:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752437AbZDVO5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 10:57:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56436 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327AbZDVO5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 10:57:38 -0400
Date: Wed, 22 Apr 2009 16:56:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Oleg Nesterov <oleg@redhat.com>
Cc: David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, Trond.Myklebust@netapp.com,
       serue@us.ibm.com, steved@redhat.com, viro@zeniv.linux.org.uk,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Document that wake_up(), complete() and co. imply a
	full memory barrier
Message-ID: <20090422145658.GA15088@elte.hu>
References: <1239649429.16771.9.camel@heimdal.trondhjem.org> <20090413181733.GA10424@redhat.com> <32260.1239658818@redhat.com> <20090413214852.GA1127@redhat.com> <1239659841.16771.26.camel@heimdal.trondhjem.org> <20090413222451.GA2758@redhat.com> <14561.1239873018@redhat.com> <21239.1240407420@redhat.com> <20090422135134.GA5249@elte.hu> <20090422143930.GA1212@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090422143930.GA1212@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Oleg Nesterov <oleg@redhat.com> wrote:

> On 04/22, Ingo Molnar wrote:
> >
> > * David Howells <dhowells@redhat.com> wrote:
> >
> > > Oleg Nesterov <oleg@redhat.com> wrote:
> > >
> > > > > That's an interesting question.  Should wake_up() imply a barrier of any
> > > > > sort, I wonder.  Well, __wake_up() does impose a barrier as it uses a
> > > > > spinlock, but I wonder if that's sufficient.
> > > >
> > > > wake_up() does imply the barrier. Note the smp_wmb() in try_to_wake_up().
> > > > And in fact this wmb() implies mb(), because spin_lock() itself is STORE,
> > > > and the futher LOADs can't leak up before spin_lock().
> > > >
> > > > But afaics, this doesn't matter? prepare_to_wait() sets
> > > > task->state under wait_queue_head_t->lock and wake_up() takes
> > > > this look too, so we can't miss the event.
> > > >
> > > > Or I completely misunderstood the issue...
> > >
> > > The problem is not what wake_up() and co. do, it's what you are
> > > allowed to assume that they do.
> > >
> > > However, I think you're right, and that we can assume they imply a
> > > full memory barrier.  To this end, I've attached a patch to
> > > document this.
> > >
> > > David
> > > ---
> > > From: David Howells <dhowells@redhat.com>
> > > Subject: [PATCH] Document that wake_up(), complete() and co. imply a full memory barrier
> > >
> > > Add to the memory barriers document to note that wake_up(), complete() and
> > > co. all imply a full memory barrier.
> >
> > No. They dont generally imply a full memory barrier versus any
> > arbitrary prior (or following) memory access.
> >
> > try_to_wake_up() has an smp_wmb() so it is a write memory barrier
> > (but not necessarily a read memory barrier). Otherwise there are
> > spinlocks there but spinlocks are not explicit 'full memory
> > barriers'.
> 
> Yes. But please look at the changelog in
> 
> 	 "Add memory barrier semantics to wake_up() & co"
> 	 04e2f1741d235ba599037734878d72e57cb302b5

yes - but still that commit is only wrt. the ->state check.

> However, I must admit, I don't understand how to document the 
> semantics correctly. This wmb() before spin_lock() ensures we 
> don't read task->state before previous STOREs. This is what we 
> care about, and this is what I meant when I said "this wmb() 
> implies mb()".
> 
> So, I think that try_to_wake_up() implies that the LOADS after it 
> can't be reordered with STOREs before it (and wmb() of course).

Note that the patch David sent says "full memory barrier", not "full 
memory barrier wrt. task->state":

+ (*) wake_up(), try_to_wake_up() and co. imply a full memory barrier.
+
+ (*) complete() and co. imply a full memory barrier.

These statements are not true in that form, as this code does not 
imply a full memory barrier. It does imply one on task->state 
_alone_ (and a couple of other wq-internal variables it happens to 
read for sure).

But even that one isnt entirely true in the two sub-cases i noted: 
the !wq case (which can happen in object state teardown) and the 
special ->func handler (which can happen in custom wakeup code a'la 
eventpoll).

So adding a comment that says "this is a full memory barrier" is 
simply not true to that extent, and is easily misunderstood. Adding 
"this is a fully memory barrier for task->state dependent data flow" 
would be more correct. (with a 'as long as wq is not NULL, and as 
long as the code using this isnt overriding ->func)

Agreed?

	Ingo
