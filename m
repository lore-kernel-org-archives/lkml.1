Return-Path: <linux-kernel-owner+w=401wt.eu-S1756256AbZA2IgI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256AbZA2IgI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 03:36:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752648AbZA2Ifz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 03:35:55 -0500
Received: from mx2.redhat.com ([66.187.237.31]:47165 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753351AbZA2Ify (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 03:35:54 -0500
Date: Thu, 29 Jan 2009 09:31:08 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Matthew Wilcox <matthew@wil.cx>, Chuck Lever <cel@citi.umich.edu>,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Ingo Molnar <mingo@elte.hu>, stable@kernel.org
Subject: Re: [RFC v7] wait: prevent exclusive waiter starvation
Message-ID: <20090129083108.GA27495@redhat.com>
References: <20090123095904.GA22890@cmpxchg.org> <20090123113541.GB12684@redhat.com> <20090123133050.GA19226@redhat.com> <20090126215957.GA3889@cmpxchg.org> <20090127032359.GA17359@redhat.com> <20090127193434.GA19673@cmpxchg.org> <20090127200544.GA28843@redhat.com> <20090128091453.GA22036@cmpxchg.org> <20090129044227.GA5231@redhat.com> <20090128233734.81d8004a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090128233734.81d8004a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28, Andrew Morton wrote:
>
> On Thu, 29 Jan 2009 05:42:27 +0100 Oleg Nesterov <oleg@redhat.com> wrote:
>
> > On 01/28, Johannes Weiner wrote:
> > >
> > > Add abort_exclusive_wait() which removes the process' wait descriptor
> > > from the waitqueue, iff still queued, or wakes up the next waiter
> > > otherwise.  It does so under the waitqueue lock.  Racing with a wake
> > > up means the aborting process is either already woken (removed from
> > > the queue) and will wake up the next waiter, or it will remove itself
> > > from the queue and the concurrent wake up will apply to the next
> > > waiter after it.
> > >
> > > Use abort_exclusive_wait() in __wait_event_interruptible_exclusive()
> > > and __wait_on_bit_lock() when they were interrupted by other means
> > > than a wake up through the queue.
> >
> > Imho, this all is right, and this patch should replace
> > lock_page_killable-avoid-lost-wakeups.patch (except for stable tree).
>
> I dropped lock_page_killable-avoid-lost-wakeups.patch a while ago.
>
> So I think we're saying that
> lock_page_killable-avoid-lost-wakeups.patch actually did fix the bug?

I think yes,

> And that "[RFC v7] wait: prevent exclusive waiter starvation" fixes it
> as well, and in a preferable manner, but not a manner which we consider
> suitable for -stable?  (why?)

I meant that lock_page_killable-avoid-lost-wakeups.patch is much simpler,
and thus it looks more "safe" for -stable.

But it is not optimal, and Johannes's patch is also more generic, it fixes
wait_event_interruptible_exclusive() as well.

> And hence that lock_page_killable-avoid-lost-wakeups.patch is the
> appropriate fix for -stable?
>
> If so, that's a bit unusual, and the -stable maintainers may choose to
> take the patch which we're putting into 2.6.29.

Well, I don't know ;)

But Johannes's looks good to me, if you already dropped the old patch,
then I think this one can go into -stable after some testing. Hopefully
maintainers can review it.

Oleg.

