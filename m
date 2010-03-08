Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab0CHOIq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 09:08:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34314 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754468Ab0CHOIo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 09:08:44 -0500
Date: Mon, 8 Mar 2010 09:08:20 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>, Shaohua Li <shaohua.li@intel.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH 2/2] cfq-iosched: rethink seeky detection for SSDs
Message-ID: <20100308140820.GA10306@redhat.com>
References: <1267296340-3820-1-git-send-email-czoccolo@gmail.com> <1267296340-3820-2-git-send-email-czoccolo@gmail.com> <1267296340-3820-3-git-send-email-czoccolo@gmail.com> <20100301142553.GB8878@redhat.com> <4e5e476b1003031147n6a53b646k418483a93013d77c@mail.gmail.com> <20100303232832.GD5230@redhat.com> <4e5e476b1003041234t21ed2facxe4dbeccec79b2ba6@mail.gmail.com> <20100304222726.GA3577@redhat.com> <4e5e476b1003051431m1bcd919and1726339b4570b8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4e5e476b1003051431m1bcd919and1726339b4570b8@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 05, 2010 at 11:31:43PM +0100, Corrado Zoccolo wrote:

[..]
> > ---
> >  block/cfq-iosched.c |    7 +++++--
> >  1 files changed, 5 insertions(+), 2 deletions(-)
> >
> > diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> > index 40840da..296aa23 100644
> > --- a/block/cfq-iosched.c
> > +++ b/block/cfq-iosched.c
> > @@ -1788,9 +1788,12 @@ static bool cfq_should_idle(struct cfq_data *cfqd, struct cfq_queue *cfqq)
> >        if (prio == IDLE_WORKLOAD)
> >                return false;
> >
> > +       /* Don't idle on NCQ SSDs */
> > +       if (blk_queue_nonrot(cfqd->queue) && cfqd->hw_tag)
> > +               return false;
> > +
> >        /* We do for queues that were marked with idle window flag. */
> > -       if (cfq_cfqq_idle_window(cfqq) &&
> > -          !(blk_queue_nonrot(cfqd->queue) && cfqd->hw_tag))
> > +       if (cfq_cfqq_idle_window(cfqq))
> >                return true;
> >
> >        /*
> > --
> > 1.6.2.5
> >
> >
> > Now I am wondering what are the side affects of above change.
> >
> > One advantage of idling on service tree even on NCQ SSD is that READS get
> > more protection from WRITES. Especially if there are SSDs which implement
> > NCQ but really suck at WRITE speed or don't implement parallel IO
> > channels.
> I think the following code:
>         /*
>          * If this is an async queue and we have sync IO in flight, let it wait
>          */
>         if (cfqd->rq_in_flight[BLK_RW_SYNC] && !cfq_cfqq_sync(cfqq))
>                 return false;
> already provides this protection, regardless of the result of cfq_should_idle().

It does but in some cases it does not. For example, consider a case of one
writer and one reader (sequential or seeky) trying to do some IO. Now
reader will do one read and then immediately writer will pump few requests
(4-5 in dispatch queue) and then reader does one read and it goes on and
this can add to latency of reader on bad NCQ SSDs.
  
> 
> >
> > I see cfq_should_idle() being used at four places.
> >
> > - cfq_select_queue()
> >                if (cfqq->cfqg->nr_cfqq == 1 && RB_EMPTY_ROOT(&cfqq->sort_list)
> >                    && cfqq->dispatched && cfq_should_idle(cfqd, cfqq)) {
> >                        cfqq = NULL;
> >                        goto keep_queue;
> >                }
> >
> > This is for fairness in group scheduling. I think that impact here should
> > not be much because this condition is primarily hit on media where we idle
> > on the queue.
> >
> > On NCQ SSD, I don't think we get fairness in group scheduling much until
> > and unless a group is generating enough traffic to keep the request queue
> > full.
> >
> > - cfq_select_queue()
> >            (cfqq->dispatched && cfq_should_idle(cfqd, cfqq))) {
> >                cfqq = NULL;
> >
> > Should we really wait for a dispatched request to complete on NCQ SSD?
> I don't think so. This is the cause for the bad performance we are looking at.
> And remember that, without my patch, you will still get the same bad
> behaviour, just with different conditions (one random and one
> sequential reader, regardless of request size).
> > On SSD with parallel channel, I think this will reduce throughput?
> >
> > - cfq_may_dispatch()
> >
> >        /*
> >         * Drain async requests before we start sync IO
> >         */
> >        if (cfq_should_idle(cfqd, cfqq) && cfqd->rq_in_driver[BLK_RW_ASYNC])
> >                return false;
> >
> > If NCQ SSD is implementing parallel IO channels, probably there is no need
> > to clear out WRITES before we start sync IO?
> Right. I think this is present for crazy NCQ rotational disks, where a
> write could sit in cache forever if a stream of reads is coming.
> >
> > - cfq_arm_slice_timer()
> >
> >               if (!cfqd->cfq_slice_idle || !cfq_should_idle(cfqd, cfqq))
> >                return;
> >
> > cfq_arm_slice_timer()  already check for NCQ SSD and does not arm timer
> > so this function should remain unaffected with this change.
> >
> > So the question is, should we wait on service tree on an NCQ SSD or not?
> I don't see a good reason to wait, and bad results if we do.

Actually with my patch, we will not get fairness on NCQ SSD (group
scheduling) until and unless a group has enough traffic to keep the
SSD busy (or dispatch queue full). Previously we used to wait on empty
service tree on NCQ SSD and now we will not.

But I guess, we can move wait on the group under the tunable
group_isolation=1, so that if one prefers more isolation between groups
even at the expense of total throughput, he can choose to do so.
 
> >
> > Secondly, your patch of determining cfqq seeky nature based on request
> > size on SSD, helps only on non NCQ SSD.
> We know it helps on non NCQ. If we fix the waiting bug, it could help
> also on NCQ, in scenarios where lot of processes (> NCQ depth) are
> submitting requests with largely different sizes.

Ok, I will run some more tests with my patch and if I don't see any major
regressions, I will send it to Jens.

Thanks
Vivek
