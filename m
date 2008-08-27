Return-Path: <linux-kernel-owner+w=401wt.eu-S1755992AbYH0Lxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992AbYH0Lxw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 07:53:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754906AbYH0Lxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 07:53:42 -0400
Received: from smtp118.mail.mud.yahoo.com ([209.191.84.167]:30673 "HELO
	smtp118.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754936AbYH0Lxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 07:53:40 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=xDJMpvSPBGah1wtxGCK0klQnAfGfyg5zdiRYJkALsV93Tbg52ZHBD16yklC+634XQgbcM07cxcy8OAKWnk4Lz+x6odhp2WoBuxz4qwK93bgaVgWBFYTRiVDTnz1z9Qh0uPEiUtIUbnyROgJTdOCmttO9yBeMhfmdEX0475KY8jc=  ;
X-YMail-OSG: qRbKsOAVM1mpuCx7Bx4vcFQ9VWy3muYaUfG6H6ddSM.np1CbIPiY196wkRvkcqJO.rPo1Nm1Ty8RYvNzS7GDl3qbTC1UreKmwmfI3M3k2ozh_7k3da575laoUMkKUIPPBsfTuXQLDC.tJ8TAWlTsF_lw
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Gregory Haskins <ghaskins@novell.com>
Subject: Re: [PATCH 3/5] sched: make double-lock-balance fair
Date: Wed, 27 Aug 2008 21:53:31 +1000
User-Agent: KMail/1.9.5
Cc: mingo@elte.hu, srostedt@redhat.com, peterz@infradead.org,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       npiggin@suse.de, gregory.haskins@gmail.com
References: <20080825200852.23217.13842.stgit@dev.haskins.net> <200808271636.09243.nickpiggin@yahoo.com.au> <48B53D86.8080806@novell.com>
In-Reply-To: <48B53D86.8080806@novell.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808272153.32007.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 August 2008 21:41, Gregory Haskins wrote:
> Nick Piggin wrote:
> > On Tuesday 26 August 2008 22:23, Gregory Haskins wrote:
> >> Nick Piggin wrote:
> >>> On Tuesday 26 August 2008 06:15, Gregory Haskins wrote:
> >>>> double_lock balance() currently favors logically lower cpus since they
> >>>> often do not have to release their own lock to acquire a second lock.
> >>>> The result is that logically higher cpus can get starved when there is
> >>>> a lot of pressure on the RQs.  This can result in higher latencies on
> >>>> higher cpu-ids.
> >>>>
> >>>> This patch makes the algorithm more fair by forcing all paths to have
> >>>> to release both locks before acquiring them again.  Since callsites to
> >>>> double_lock_balance already consider it a potential
> >>>> preemption/reschedule point, they have the proper logic to recheck for
> >>>> atomicity violations.
> >>>>
> >>>> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> >>>> ---
> >>>>
> >>>>  kernel/sched.c |   17 +++++------------
> >>>>  1 files changed, 5 insertions(+), 12 deletions(-)
> >>>>
> >>>> diff --git a/kernel/sched.c b/kernel/sched.c
> >>>> index 6e0bde6..b7326cd 100644
> >>>> --- a/kernel/sched.c
> >>>> +++ b/kernel/sched.c
> >>>> @@ -2790,23 +2790,16 @@ static int double_lock_balance(struct rq
> >>>> *this_rq, struct rq *busiest) __acquires(busiest->lock)
> >>>>  	__acquires(this_rq->lock)
> >>>>  {
> >>>> -	int ret = 0;
> >>>> -
> >>>>  	if (unlikely(!irqs_disabled())) {
> >>>>  		/* printk() doesn't work good under rq->lock */
> >>>>  		spin_unlock(&this_rq->lock);
> >>>>  		BUG_ON(1);
> >>>>  	}
> >>>> -	if (unlikely(!spin_trylock(&busiest->lock))) {
> >>>> -		if (busiest < this_rq) {
> >>>> -			spin_unlock(&this_rq->lock);
> >>>> -			spin_lock(&busiest->lock);
> >>>> -			spin_lock_nested(&this_rq->lock, SINGLE_DEPTH_NESTING);
> >>>> -			ret = 1;
> >>>> -		} else
> >>>> -			spin_lock_nested(&busiest->lock, SINGLE_DEPTH_NESTING);
> >>>> -	}
> >>>> -	return ret;
> >>>> +
> >>>> +	spin_unlock(&this_rq->lock);
> >>>> +	double_rq_lock(this_rq, busiest);
> >>>
> >>> Rather than adding the extra atomic operation, can't you just put this
> >>> into the unlikely spin_trylock failure path rather than the unfair
> >>> logic there?
> >>
> >> The trick is that we *must* first release this_rq before proceeding or
> >> the new proposal doesn't work as intended.  This patch effectively
> >> breaks up the this_rq->lock critical section evenly across all CPUs as
> >> if it hit the case common for higher cpus.
> >
> > I don't exactly see why my proposal would introduce any more latency,
> > because we only trylock while holding the existing lock -- this is will
> > only ever add a small ~constant time to the critical section, regardless
> > of whether it is a high or low CPU runqueue.
>
> Its because we are trying to create a break in the critical section of
> this_rq->lock, not improve the acquisition of busiest->lock.  So whether
> you do spin_lock or spin_trylock on busiest does not matter.  Busiest
> will not be contended in the case that I am concerned with.  If you use
> my example below: rq[N] will not be contended because cpuN is blocked on
> rq[0] after already having released rq[N].  So its the contention
> against this_rq that is the problem.
>
> Or am I missing your point completely?

Well my point is just that after my change, there may be some windows
of "unfair" behaviour where one CPU gets to go ahead early, but AFAIKS
now there is no systemic bias against higher numbered CPUs (except the
small issue of taking lowered numbered locks first which is also present
in any solution).

As such, I would actually like to see my proposal implemented in the
!lowlatency case as well... unless my reasoning has a hole in it?

But if you are _also_ wanting to eliminate the long lock hold time and
strictly improve fairness for lowlatency kernels, then I agree that your
patch goes much further than mine, so I don't object to putting that
under CONFIG_PREEMPT.


> >> This modification decreased
> >> latency by over 800% (went from > 400us to < 50us) on cpus 6 and 7 in my
> >> 8-way box namely because they were not forced to wait for all the other
> >> lower cores to finish, but rather completions of double_lock_balance
> >> were handled in true FIFO w.r.t. to other calls to
> >> double_lock_balance().  It has to do with the positioning within your
> >> FIFO ticket locks (though even if ticket locks are not present on a
> >> given architecture we should still see an improvement.)
> >>
> >> When a low cpu wants to double lock, it tends to hold this_rq and gets
> >> in line for busiest_rq with no bearing on how long it held this_rq.
> >> Therefore the following scenario can occur:
> >>
> >> cpu 0                     cpu N
> >> ----------------------------------
> >> rq[0] locked
> >> ..
> >> ..
> >> ..
> >>                                double_lock(N, 0)
> >>                                rq[N] released
> >>                                blocked on rq[0]
> >> ..
> >> ..
> >> ..
> >> ..
> >> double_lock(0, N)
> >> rq[N] locked
> >> double_lock returns
> >> ..
> >> ..
> >> ..
> >> ..
> >> rq[0] released         rq[0] locked
> >>                                   double_lock returns
> >>                                   ...
> >>                                   ...
> >>                                   ...
> >>
> >> ---------------------------------
> >>
> >> So double lock acquisition favors the lower cpus unfairly.  They will
> >> always win, even if they were not first.  Now with the combination of my
> >> patch plus your ticket locks, entry into the double lock becomes FIFO
> >> because the "blocked on rq[0]" would have inserted it in the
> >> time-ordered head of rq[0].
> >
> > Right, but I don't think it is particularly wrong to allow a given
> > CPU to double_lock_balance ahead of another guy if we're already holding
> > the lock.
>
> Its not "wrong".  Its just a latency source ;)

OK, sure.


> >  _So long as_ the lock we are trying to acquire is uncontended,
> > and we don't introduce this skewed unfairness due to lower CPUs being
> > allowed to hold their lower lock while higher CPUs have to release their
> > lock and first queue on the lower.
> >
> > The difference is that with my patch, there is a small window where the
> > guy who asks for the double lock first will go through second. I don't
> > think this really adds a fundamental amount of latency, and the
> > performance benefit should not be ignored.
> >
> > Linux's traditional and I suppose much largest user base does not require
> > realtime or really strict fairness, so IMO it is always questionable to
> > make changes like this.
>
> Please take a look at the v2 series that I sent out yesterday.  I have
> now predicated this on CONFIG_PREEMPT, per your comments.

Those patches look pretty OK with me now.
