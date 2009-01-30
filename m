Return-Path: <linux-kernel-owner+w=401wt.eu-S1754795AbZA3Lvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795AbZA3Lvk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 06:51:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021AbZA3Lvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 06:51:32 -0500
Received: from brick.kernel.dk ([93.163.65.50]:9593 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805AbZA3Lvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 06:51:31 -0500
Date: Fri, 30 Jan 2009 12:49:41 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Divyesh Shah <dpshah@google.com>
Cc: mikew@google.com, nauman@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2][RESEND] Allow RT requests to pre-empt ongoing BE timeslice in CFQ.
Message-ID: <20090130114941.GN30821@kernel.dk>
References: <20090128060140.16117.44772.stgit@hyd-omgvisitor1.hyd.corp.google.com> <af41c7c40901272217j4bc8e0devbe5f22ffbd07b692@mail.gmail.com> <20090130112621.GJ30821@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090130112621.GJ30821@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 30 2009, Jens Axboe wrote:
> On Wed, Jan 28 2009, Divyesh Shah wrote:
> 
> Strange, I was pretty sure this was added, but apparently not. Can you
> resend a non-whitespace damaged version and I'll make sure to add it to
> the mix.

Nevermind, found non-cc'ed original on lkml, which wasn't whitespace
damaged.

> 
> 
> > + Jens Axboe
> > 
> > On Wed, Jan 28, 2009 at 11:35 AM, Divyesh Shah <dpshah@google.com> wrote:
> > > This patch adds the ability to pre-empt an ongoing BE timeslice when a RT
> > > request is waiting for the current timeslice to complete. This reduces the
> > > wait time to disk for RT requests from an upper bound of 4 (current value
> > > of cfq_quantum) to 1 disk request.
> > >
> > > Signed-off-by: Divyesh Shah <dpshah@google.com>
> > > ---
> > > Applied Jens' suggeested changes to avoid the rb lookup and use !cfq_class_rt()
> > > and retested.
> > >
> > > Latency(secs) for the RT task when doing sequential reads from 10G file.
> > >                       | only RT | RT + BE | RT + BE + this patch
> > > small (512 byte) reads | 143     | 163     | 145
> > > large (1Mb) reads      | 142     | 158     | 146
> > >
> > >  block/cfq-iosched.c |   39 ++++++++++++++++++++++++++++++++++++++-
> > >  1 files changed, 38 insertions(+), 1 deletions(-)
> > >
> > > diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> > > index e8525fa..5fec9e5 100644
> > > --- a/block/cfq-iosched.c
> > > +++ b/block/cfq-iosched.c
> > > @@ -84,6 +84,11 @@ struct cfq_data {
> > >         */
> > >        struct cfq_rb_root service_tree;
> > >        unsigned int busy_queues;
> > > +       /*
> > > +        * Used to track any pending rt requests so we can pre-empt current
> > > +        * non-RT cfqq in service when this value is non-zero.
> > > +        */
> > > +       unsigned int busy_rt_queues;
> > >
> > >        int rq_in_driver;
> > >        int sync_flight;
> > > @@ -562,6 +567,8 @@ static void cfq_add_cfqq_rr(struct cfq_data *cfqd, struct cfq_queue *cfqq)
> > >        BUG_ON(cfq_cfqq_on_rr(cfqq));
> > >        cfq_mark_cfqq_on_rr(cfqq);
> > >        cfqd->busy_queues++;
> > > +       if (cfq_class_rt(cfqq))
> > > +               cfqd->busy_rt_queues++;
> > >
> > >        cfq_resort_rr_list(cfqd, cfqq);
> > >  }
> > > @@ -581,6 +588,8 @@ static void cfq_del_cfqq_rr(struct cfq_data *cfqd, struct cfq_queue *cfqq)
> > >
> > >        BUG_ON(!cfqd->busy_queues);
> > >        cfqd->busy_queues--;
> > > +       if (cfq_class_rt(cfqq))
> > > +               cfqd->busy_rt_queues--;
> > >  }
> > >
> > >  /*
> > > @@ -1005,6 +1014,20 @@ static struct cfq_queue *cfq_select_queue(struct cfq_data *cfqd)
> > >                goto expire;
> > >
> > >        /*
> > > +        * If we have a RT cfqq waiting, then we pre-empt the current non-rt
> > > +        * cfqq.
> > > +        */
> > > +       if (!cfq_class_rt(cfqq) && cfqd->busy_rt_queues) {
> > > +               /*
> > > +                * We simulate this as cfqq timed out so that it gets to bank
> > > +                * the remaining of its time slice.
> > > +                */
> > > +               cfq_log_cfqq(cfqd, cfqq, "preempt");
> > > +               cfq_slice_expired(cfqd, 1);
> > > +               goto new_queue;
> > > +       }
> > > +
> > > +       /*
> > >         * The active queue has requests and isn't expired, allow it to
> > >         * dispatch.
> > >         */
> > > @@ -1067,6 +1090,13 @@ __cfq_dispatch_requests(struct cfq_data *cfqd, struct cfq_queue *cfqq,
> > >                if (RB_EMPTY_ROOT(&cfqq->sort_list))
> > >                        break;
> > >
> > > +               /*
> > > +                * If there is a non-empty RT cfqq waiting for current
> > > +                * cfqq's timeslice to complete, pre-empt this cfqq
> > > +                */
> > > +               if (!cfq_class_rt(cfqq) && cfqd->busy_rt_queues)
> > > +                       break;
> > > +
> > >        } while (dispatched < max_dispatch);
> > >
> > >        /*
> > > @@ -1801,6 +1831,12 @@ cfq_should_preempt(struct cfq_data *cfqd, struct cfq_queue *new_cfqq,
> > >        if (rq_is_meta(rq) && !cfqq->meta_pending)
> > >                return 1;
> > >
> > > +       /*
> > > +        * Allow an RT request to pre-empt an ongoing non-RT cfqq timeslice.
> > > +        */
> > > +       if (cfq_class_rt(new_cfqq) && !cfq_class_rt(cfqq))
> > > +               return 1;
> > > +
> > >        if (!cfqd->active_cic || !cfq_cfqq_wait_request(cfqq))
> > >                return 0;
> > >
> > > @@ -1870,7 +1906,8 @@ cfq_rq_enqueued(struct cfq_data *cfqd, struct cfq_queue *cfqq,
> > >                /*
> > >                 * not the active queue - expire current slice if it is
> > >                 * idle and has expired it's mean thinktime or this new queue
> > > -                * has some old slice time left and is of higher priority
> > > +                * has some old slice time left and is of higher priority or
> > > +                * this new queue is RT and the current one is BE
> > >                 */
> > >                cfq_preempt_queue(cfqd, cfqq);
> > >                cfq_mark_cfqq_must_dispatch(cfqq);
> > >
> > >
> 
> -- 
> Jens Axboe
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Jens Axboe

