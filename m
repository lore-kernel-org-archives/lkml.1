Return-Path: <linux-kernel-owner+w=401wt.eu-S1752050AbZJTNRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050AbZJTNRl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 09:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751351AbZJTNRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 09:17:41 -0400
Received: from brick.kernel.dk ([93.163.65.50]:40903 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149AbZJTNRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 09:17:40 -0400
Date: Tue, 20 Oct 2009 15:17:44 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [RFC PATCH 1/5] cfq-iosched: adapt slice to number of
	processes   doing I/O
Message-ID: <20091020131744.GH10727@kernel.dk>
References: <200910192221.03805.czoccolo@gmail.com> <20091020005446.GB10727@kernel.dk> <4e5e476b0910200301w4ae2725ch37b81c1529bdcfec@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4e5e476b0910200301w4ae2725ch37b81c1529bdcfec@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 20 2009, Corrado Zoccolo wrote:
> On Tue, Oct 20, 2009 at 2:54 AM, Jens Axboe <jens.axboe@oracle.com> wrote:
> > On Mon, Oct 19 2009, Corrado Zoccolo wrote:
> >> When the number of processes performing I/O concurrently increases,
> >> a fixed time slice per process will cause large latencies.
> >>
> >> This patch, if low_latency mode is enabled,  will scale the time slice
> >> assigned to each process according to a 300ms target latency.
> >>
> >> In order to keep fairness among processes:
> >> * The number of active processes is computed using a special form of
> >> running average, that quickly follows sudden increases (to keep latency low),
> >> and decrease slowly (to have fairness in spite of rapid decreases of this
> >> value).
> >>
> >> To safeguard sequential bandwidth, we impose a minimum time slice
> >> (computed using 2*cfq_slice_idle as base, adjusted according to priority
> >> and async-ness).
> >
> > Generally, this looks good. Just one minor style nit:
> >
> >> +static inline unsigned
> >> +cfq_get_avg_queues(struct cfq_data *cfqd, bool rt) {
> >> +     unsigned min_q, max_q;
> >> +     unsigned mult  = cfq_hist_divisor - 1;
> >> +     unsigned round = cfq_hist_divisor / 2;
> >> +     unsigned busy  = rt ? cfqd->busy_rt_queues :
> >> +             (cfqd->busy_queues - cfqd->busy_rt_queues);
> >> +     min_q = min(cfqd->busy_queues_avg[rt], busy);
> >> +     max_q = max(cfqd->busy_queues_avg[rt], busy);
> >> +     cfqd->busy_queues_avg[rt] = (mult * max_q + min_q + round) /
> >> +             cfq_hist_divisor;
> >> +     return cfqd->busy_queues_avg[rt];
> >> +}
> >
> > A lot of your code suffers from the specific problem of being largely
> > unreadable. To me, as the maintainer of that code, that is a maintenance
> > issue. I already asked you to get rid of the ?: constructs for earlier
> > patches, this series even takes it to the extreme of doing nested ?:
> > clauses. Don't do it! It's unreadable.
> 
> Ok. I'll resubmit a revised version of the patches that address this
> stile issue, as well as your concern with too large functions and
> lacking comments.
> I didn't realize that you hated ?: so much :).

I do, personally it doesn't read anywhere near as naturally as a simple
'if'. And when you start doing x = a ? b : c ? d : e; I almost reach for
the nearest expletive :-)

And adding a local scope with {} and having 3-4 broken lines of
multiplications, divisions (etc) inside max()/min() calls doesn't add to
the readability in any positive way...

> To me, it seems a good way to achieve a different readability goal,
> i.e. define the value of a variable in a single place, instead of
> scattering it around on multiple lines.

I prefer putting it elsewhere instead. So instead of doing:

        foo_type bar = x(y) == BAZ ? a : b;

you have

get_foo_type(y)
{
        if (x(y) == BAZ)
                return a;

        return b;
}

        foo_type bar = get_foo_type(y);

which is a lot more readable to me. Especially since you have to do the
get_foo_type() operation in a lot of places.

> >> @@ -2152,10 +2186,9 @@ static void cfq_insert_request(struct request_queue *q, struct request *rq)
> >>       cfq_log_cfqq(cfqd, cfqq, "insert_request");
> >>       cfq_init_prio_data(cfqq, RQ_CIC(rq)->ioc);
> >>
> >> -     cfq_add_rq_rb(rq);
> >> -
> >>       rq_set_fifo_time(rq, jiffies + cfqd->cfq_fifo_expire[rq_is_sync(rq)]);
> >>       list_add_tail(&rq->queuelist, &cfqq->fifo);
> >> +     cfq_add_rq_rb(rq);
> >>
> >>       cfq_rq_enqueued(cfqd, cfqq, rq);
> >
> > If the fifo vs service tree ordering is now important, you should
> > comment on why.
> It's not important for the patches per se, but I found odd (and it
> caused me some headache while debugging) that in cfq_add_rq_rb the
> fifo was still empty.
> In the new form, the rq will be complete when added, while in the
> previous, it still had some empty fields.

Then keep it like it is, or do it as a separate patch. When you include
it in a functionally changing patch like this, I'm assuming there must
be a reason for that. And when it seems like there isn't, you wonder
what is up.

-- 
Jens Axboe

