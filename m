Return-Path: <linux-kernel-owner+w=401wt.eu-S1759290AbZAWAv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759290AbZAWAv6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 19:51:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754096AbZAWAvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 19:51:50 -0500
Received: from mx2.redhat.com ([66.187.237.31]:42009 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753796AbZAWAvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 19:51:50 -0500
Date: Fri, 23 Jan 2009 01:47:02 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Matthew Wilcox <matthew@wil.cx>, Chuck Lever <cel@citi.umich.edu>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC v4] wait: prevent waiter starvation in __wait_on_bit_lock
Message-ID: <20090123004702.GA18362@redhat.com>
References: <20090117215110.GA3300@redhat.com> <20090118013802.GA12214@cmpxchg.org> <20090118023211.GA14539@redhat.com> <20090120203131.GA20985@cmpxchg.org> <20090121143602.GA16584@redhat.com> <20090121213813.GB23270@cmpxchg.org> <20090122202550.GA5726@redhat.com> <b647ffbd0901221626o5e654682t147625fa3e19976f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b647ffbd0901221626o5e654682t147625fa3e19976f@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23, Dmitry Adamushko wrote:
>
> 2009/1/22 Oleg Nesterov <oleg@redhat.com>:
> >
> > I think this is correct, and (unfortunately ;) you are right:
> > we need rmb() even after finish_wait().
>
> Hum, I think it's actually not necessary in this particular case when
> (1) "the next contender is us" and (2) we are in the "ret != 0" path
> so that the only thing we really care about -- if we were exclusivly
> woken up, then wake up somebody else [*].
>
> "the next contender is us" implies that we were still on the 'wq'
> queue when __wake_up_bit() -> __wake_up() has been called, meaning
> that wq->lock has also been taken (in __wake_up()).
>
> Now, on our side, we are definitely on the 'wq' queue before calling
> finish_wait(), meaning that we also take the wq->lock.
>
> In short, wq->lock is a sync. mechanism in this case. The scheme is as follows:
>
> our side:
>
> [ finish_wait() ]
>
> lock(wq->lock);

But we can skip lock(wq->lock), afaics.

Without rmb(), test_bit() can be re-ordered with list_empty_careful()
in finish_wait() and even with __set_task_state(TASK_RUNNING).

> p.s. if the explanation is vague or heh even wrong, it's definitely
> due to the lack of sleep ;-))

The same on my side ;)

Oleg.

