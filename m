Return-Path: <linux-kernel-owner+w=401wt.eu-S1753088Ab0AHRkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088Ab0AHRkq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 12:40:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753018Ab0AHRko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 12:40:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45423 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753015Ab0AHRkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 12:40:41 -0500
Date: Fri, 8 Jan 2010 12:40:35 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Shaohua Li <shaohua.li@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>
Subject: Re: [RFC]cfq-iosched: quantum check tweak
Message-ID: <20100108174035.GD22219@redhat.com>
References: <20091225091030.GA28365@sli10-desk.sh.intel.com> <4e5e476b0912250144l96c4d34v300910216e5c7a08@mail.gmail.com> <20091228033554.GB15242@sli10-desk.sh.intel.com> <4e5e476b0912280102t2278d7a5ld3e8784f52f2be31@mail.gmail.com> <1262829893.4984.13.camel@sli10-desk.sh.intel.com> <4e5e476b1001071344i4f702496y22f33bc2d4bc834d@mail.gmail.com> <20100108171535.GC22219@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100108171535.GC22219@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 08, 2010 at 12:15:35PM -0500, Vivek Goyal wrote:
> On Thu, Jan 07, 2010 at 10:44:27PM +0100, Corrado Zoccolo wrote:
> > Hi Shahoua,
> > 
> > On Thu, Jan 7, 2010 at 3:04 AM, Shaohua Li <shaohua.li@intel.com> wrote:
> > > On Mon, 2009-12-28 at 17:02 +0800, Corrado Zoccolo wrote:
> > >> Hi Shaohua,
> > >> On Mon, Dec 28, 2009 at 4:35 AM, Shaohua Li <shaohua.li@intel.com> wrote:
> > >> > On Fri, Dec 25, 2009 at 05:44:40PM +0800, Corrado Zoccolo wrote:
> > >> >> On Fri, Dec 25, 2009 at 10:10 AM, Shaohua Li <shaohua.li@intel.com> wrote:
> > >> >> > Currently a queue can only dispatch up to 4 requests if there are other queues.
> > >> >> > This isn't optimal, device can handle more requests, for example, AHCI can
> > >> >> > handle 31 requests. I can understand the limit is for fairness, but we could
> > >> >> > do some tweaks:
> > >> >> > 1. if the queue still has a lot of slice left, sounds we could ignore the limit
> > >> >> ok. You can even scale the limit proportionally to the remaining slice
> > >> >> (see below).
> > >> > I can't understand the meaning of below scale. cfq_slice_used_soon() means
> > >> > dispatched requests can finish before slice is used, so other queues will not be
> > >> > impacted. I thought/hope a cfq_slice_idle time is enough to finish the
> > >> > dispatched requests.
> > >> cfq_slice_idle is 8ms, that is the average time to complete 1 request
> > >> on most disks. If you have more requests dispatched on a
> > >> NCQ-rotational disk (non-RAID), it will take more time. Probably a
> > >> linear formula is not the most accurate, but still more accurate than
> > >> taking just 1 cfq_slice_idle. If you can experiment a bit, you could
> > >> also try:
> > >>  cfq_slice_idle * ilog2(nr_dispatched+1)
> > >>  cfq_slice_idle * (1<<(ilog2(nr_dispatched+1)>>1))
> > >>
> > >> >
> > >> >> > 2. we could keep the check only when cfq_latency is on. For uses who don't care
> > >> >> > about latency should be happy to have device fully piped on.
> > >> >> I wouldn't overload low_latency with this meaning. You can obtain the
> > >> >> same by setting the quantum to 32.
> > >> > As this impact fairness, so natually thought we could use low_latency. I'll remove
> > >> > the check in next post.
> > >> Great.
> > >> >> > I have a test of random direct io of two threads, each has 32 requests one time
> > >> >> > without patch: 78m/s
> > >> >> > with tweak 1: 138m/s
> > >> >> > with two tweaks and disable latency: 156m/s
> > >> >>
> > >> >> Please, test also with competing seq/random(depth1)/async workloads,
> > >> >> and measure also introduced latencies.
> > >> > depth1 should be ok, as if device can only send one request, it should not require
> > >> > more requests from ioscheduler.
> > >> I mean have a run with, at the same time:
> > >> * one seq reader,
> > >> * h random readers with depth 1 (non-aio)
> > >> * one async seq writer
> > >> * k random readers with large depth.
> > >> In this way, you can see if the changes you introduce to boost your
> > >> workload affect more realistic scenarios, in which various workloads
> > >> are mixed.
> > >> I explicitly add the depth1 random readers, since they are sceduled
> > >> differently than the large (>4) depth ones.
> > > I tried a fio script which does like your description, but the data
> > > isn't stable, especially the write speed, other kind of io speed is
> > > stable. Apply below patch doesn't make things worse (still write speed
> > > isn't stable, other io is stable), so I can't say if the patch passes
> > > the test, but it appears latency reported by fio hasn't change. I adopt
> > > the slice_idle * dispatched approach, which I thought should be safe.
> > 
> > I'm doing some tests right now on a single ncq rotational disk, and
> > the average service time when submitting with a high depth is halved
> > w.r.t. depth 1, so I think you could test also with the formula :
> > slice_idle * dispatched / 2. It should give a performance boost,
> > without noticeable impact on latency.
> > 
> 
> But I guess the right comparison here would service times vary when we
> push queue depths from 4 to higher (as done by this patch). Were you
> running deep seeky queues or sequential queues. Curious to know whether
> service times reduced even in case of deep seeky queues on this single
> disk.
> 
> I think this patch breaks the meaning of cfq_quantum? Now we can allow
> dispatch of more requests from the same queue. I had kind of liked the
> idea of respecting cfq_quantum. Especially it can help in testing. With
> this patch cfq_quantum will more or less loose its meaning.
> 

I guess this is a question of soft limit and hard limit. May be we can
bump up default cfq_quantum to 8 and internally define a soft limit of
of 50% of cfq_quantum. So we will start throttling number of requests
from a queue when cfqq->dispatched reaches 4. But will allow more
dispatches up to cfq_quantum based on how much slice is left and what's
the possiblity that already dispatched request will finish with-in the
slice.

That way we will maintain existing behavior, meaning of cfq_quantum as
well as possibly get performance improvement in the said case.

Vivek

> > > Currently a queue can only dispatch up to 4 requests if there are other queues.
> > > This isn't optimal, device can handle more requests, for example, AHCI can
> > > handle 31 requests. I can understand the limit is for fairness, but we could
> > > do a tweak: if the queue still has a lot of slice left, sounds we could ignore
> > > the limit.
> > > For async io, 40ms/8ms = 5 - quantum = 1, we only send extra 1 request in maxium.
> > > For sync io, 100ms/8ms = 12 - quantum = 8, we might send extra 8 requests in maxium.
> > > This might cause latency issue if the queue is preempted at the very beginning.
> > >
> > > This patch boost my workload from 78m/s to 102m/s, which isn't that big as my last
> > > post, but also is a big improvement.
> > 
> > Acked-by: Corrado Zoccolo <czoccolo@gmail.com>
> > 
> > >
> > > Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> > > ---
> > >  block/cfq-iosched.c |   15 ++++++++++++++-
> > >  1 file changed, 14 insertions(+), 1 deletion(-)
> > >
> > > Index: linux-2.6/block/cfq-iosched.c
> > > ===================================================================
> > > --- linux-2.6.orig/block/cfq-iosched.c
> > > +++ linux-2.6/block/cfq-iosched.c
> > > @@ -2242,6 +2242,19 @@ static int cfq_forced_dispatch(struct cf
> > >        return dispatched;
> > >  }
> > >
> > > +static inline bool cfq_slice_used_soon(struct cfq_data *cfqd,
> > > +       struct cfq_queue *cfqq)
> > > +{
> > > +       /* the queue hasn't finished any request, can't estimate */
> > > +       if (cfq_cfqq_slice_new(cfqq))
> > > +               return true;
> > > +       if (time_after(jiffies + cfqd->cfq_slice_idle * cfqq->dispatched,
> > > +               cfqq->slice_end))
> > > +               return true;
> > > +
> > > +       return false;
> > > +}
> > > +
> > >  static bool cfq_may_dispatch(struct cfq_data *cfqd, struct cfq_queue *cfqq)
> > >  {
> > >        unsigned int max_dispatch;
> > > @@ -2275,7 +2288,7 @@ static bool cfq_may_dispatch(struct cfq_
> > >                /*
> > >                 * We have other queues, don't allow more IO from this one
> > >                 */
> > > -               if (cfqd->busy_queues > 1)
> > > +               if (cfqd->busy_queues > 1 && cfq_slice_used_soon(cfqd, cfqq))
> > >                        return false;
> > >
> > >                /*
> > >
> > >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
