Return-Path: <linux-kernel-owner+w=401wt.eu-S1754149AbZDVNwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149AbZDVNwV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 09:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753001AbZDVNwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 09:52:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40249 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752985AbZDVNwD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 09:52:03 -0400
Date: Wed, 22 Apr 2009 15:51:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Howells <dhowells@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Trond.Myklebust@netapp.com, serue@us.ibm.com, steved@redhat.com,
       viro@zeniv.linux.org.uk,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Document that wake_up(), complete() and co. imply a
	full memory barrier
Message-ID: <20090422135134.GA5249@elte.hu>
References: <20090416143351.GD6532@redhat.com> <20090415162712.342d4c07.akpm@linux-foundation.org> <1239649429.16771.9.camel@heimdal.trondhjem.org> <20090413181733.GA10424@redhat.com> <32260.1239658818@redhat.com> <20090413214852.GA1127@redhat.com> <1239659841.16771.26.camel@heimdal.trondhjem.org> <20090413222451.GA2758@redhat.com> <14561.1239873018@redhat.com> <21239.1240407420@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21239.1240407420@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Howells <dhowells@redhat.com> wrote:

> Oleg Nesterov <oleg@redhat.com> wrote:
> 
> > > That's an interesting question.  Should wake_up() imply a barrier of any
> > > sort, I wonder.  Well, __wake_up() does impose a barrier as it uses a
> > > spinlock, but I wonder if that's sufficient.
> > 
> > wake_up() does imply the barrier. Note the smp_wmb() in try_to_wake_up().
> > And in fact this wmb() implies mb(), because spin_lock() itself is STORE,
> > and the futher LOADs can't leak up before spin_lock().
> > 
> > But afaics, this doesn't matter? prepare_to_wait() sets 
> > task->state under wait_queue_head_t->lock and wake_up() takes 
> > this look too, so we can't miss the event.
> > 
> > Or I completely misunderstood the issue...
> 
> The problem is not what wake_up() and co. do, it's what you are 
> allowed to assume that they do.
> 
> However, I think you're right, and that we can assume they imply a 
> full memory barrier.  To this end, I've attached a patch to 
> document this.
> 
> David
> ---
> From: David Howells <dhowells@redhat.com>
> Subject: [PATCH] Document that wake_up(), complete() and co. imply a full memory barrier
> 
> Add to the memory barriers document to note that wake_up(), complete() and
> co. all imply a full memory barrier.

No. They dont generally imply a full memory barrier versus any 
arbitrary prior (or following) memory access.

try_to_wake_up() has an smp_wmb() so it is a write memory barrier 
(but not necessarily a read memory barrier). Otherwise there are 
spinlocks there but spinlocks are not explicit 'full memory 
barriers'.

Also, there's a sub-detail wrt. the wake_up() variants in that they 
have a fastpath for the !q case - then they dont have any atomics at 
all - they just return straight away.

Another sub-detail: wakeups using a special wakeup handler might not 
even call try_to_wake_up() - so in their case not even a write 
barrier can be assumed.

So your patch is misleading in a number of areas here.

	Ingo
