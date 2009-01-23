Return-Path: <linux-kernel-owner+w=401wt.eu-S1762225AbZAWLIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762225AbZAWLIR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 06:08:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761084AbZAWLHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 06:07:39 -0500
Received: from mx2.redhat.com ([66.187.237.31]:35291 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761051AbZAWLHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 06:07:37 -0500
Date: Fri, 23 Jan 2009 12:05:00 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Matthew Wilcox <matthew@wil.cx>, Chuck Lever <cel@citi.umich.edu>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC v4] wait: prevent waiter starvation in __wait_on_bit_lock
Message-ID: <20090123110500.GA12684@redhat.com>
References: <20090117215110.GA3300@redhat.com> <20090118013802.GA12214@cmpxchg.org> <20090118023211.GA14539@redhat.com> <20090120203131.GA20985@cmpxchg.org> <20090121143602.GA16584@redhat.com> <20090121213813.GB23270@cmpxchg.org> <20090122202550.GA5726@redhat.com> <b647ffbd0901221626o5e654682t147625fa3e19976f@mail.gmail.com> <20090123004702.GA18362@redhat.com> <b647ffbd0901230207u642e24cdg98700aa68ed1aa33@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b647ffbd0901230207u642e24cdg98700aa68ed1aa33@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23, Dmitry Adamushko wrote:
>
> 2009/1/23 Oleg Nesterov <oleg@redhat.com>:
> > On 01/23, Dmitry Adamushko wrote:
> >>
> >> In short, wq->lock is a sync. mechanism in this case. The scheme is as follows:
> >>
> >> our side:
> >>
> >> [ finish_wait() ]
> >>
> >> lock(wq->lock);
> >
> > But we can skip lock(wq->lock), afaics.
> >
> > Without rmb(), test_bit() can be re-ordered with list_empty_careful()
> > in finish_wait() and even with __set_task_state(TASK_RUNNING).
>
> But taking into account the constraints of this special case, namely
> (1), we can't skip lock(wq->lock).
>
> (1) "the next contender is us"
>
> In this particular situation, we are only interested in the case when
> we were woken up by __wake_up_bit().

Yes,

> that means we are _on_ the 'wq' list when we do finish_wait() -> we do
> take the 'wq->lock'.

Hmm. No?

We are doing exclusive wait, and we use autoremove_wake_function().
If we were woken, we are removed from ->task_list.

> Moreover, imagine the following case (roughly similar to finish_wait()):
>
> if (LOAD(a) == 1) {
>     // do something here
>     mb();
> }
>
> LOAD(b);
>
> Can LOAD(b) be reordered with LOAD(a)?

Well, I think yes it can. But I'd suggest you to ask somebody else ;)

So, without rmb() I think it is theoretically possible that we read
test_bit() before we get list_empty_careful() == T.

Oleg.

