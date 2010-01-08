Return-Path: <linux-kernel-owner+w=401wt.eu-S1754538Ab0AHA53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538Ab0AHA53 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 19:57:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754516Ab0AHA53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 19:57:29 -0500
Received: from mga02.intel.com ([134.134.136.20]:11818 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754515Ab0AHA51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 19:57:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,238,1262592000"; 
   d="scan'208";a="482291075"
Date: Fri, 8 Jan 2010 08:57:25 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>
Subject: Re: [RFC]cfq-iosched: quantum check tweak
Message-ID: <20100108005725.GA3083@sli10-desk.sh.intel.com>
References: <20091225091030.GA28365@sli10-desk.sh.intel.com>
 <4e5e476b0912250144l96c4d34v300910216e5c7a08@mail.gmail.com>
 <20091228033554.GB15242@sli10-desk.sh.intel.com>
 <4e5e476b0912280102t2278d7a5ld3e8784f52f2be31@mail.gmail.com>
 <1262829893.4984.13.camel@sli10-desk.sh.intel.com>
 <4e5e476b1001071344i4f702496y22f33bc2d4bc834d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4e5e476b1001071344i4f702496y22f33bc2d4bc834d@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 08, 2010 at 05:44:27AM +0800, Corrado Zoccolo wrote:
> Hi Shahoua,
> 
> On Thu, Jan 7, 2010 at 3:04 AM, Shaohua Li <shaohua.li@intel.com> wrote:
> > On Mon, 2009-12-28 at 17:02 +0800, Corrado Zoccolo wrote:
> >> Hi Shaohua,
> >> On Mon, Dec 28, 2009 at 4:35 AM, Shaohua Li <shaohua.li@intel.com> wrote:
> >> > On Fri, Dec 25, 2009 at 05:44:40PM +0800, Corrado Zoccolo wrote:
> >> >> On Fri, Dec 25, 2009 at 10:10 AM, Shaohua Li <shaohua.li@intel.com> wrote:
> >> >> > Currently a queue can only dispatch up to 4 requests if there are other queues.
> >> >> > This isn't optimal, device can handle more requests, for example, AHCI can
> >> >> > handle 31 requests. I can understand the limit is for fairness, but we could
> >> >> > do some tweaks:
> >> >> > 1. if the queue still has a lot of slice left, sounds we could ignore the limit
> >> >> ok. You can even scale the limit proportionally to the remaining slice
> >> >> (see below).
> >> > I can't understand the meaning of below scale. cfq_slice_used_soon() means
> >> > dispatched requests can finish before slice is used, so other queues will not be
> >> > impacted. I thought/hope a cfq_slice_idle time is enough to finish the
> >> > dispatched requests.
> >> cfq_slice_idle is 8ms, that is the average time to complete 1 request
> >> on most disks. If you have more requests dispatched on a
> >> NCQ-rotational disk (non-RAID), it will take more time. Probably a
> >> linear formula is not the most accurate, but still more accurate than
> >> taking just 1 cfq_slice_idle. If you can experiment a bit, you could
> >> also try:
> >>  cfq_slice_idle * ilog2(nr_dispatched+1)
> >>  cfq_slice_idle * (1<<(ilog2(nr_dispatched+1)>>1))
> >>
> >> >
> >> >> > 2. we could keep the check only when cfq_latency is on. For uses who don't care
> >> >> > about latency should be happy to have device fully piped on.
> >> >> I wouldn't overload low_latency with this meaning. You can obtain the
> >> >> same by setting the quantum to 32.
> >> > As this impact fairness, so natually thought we could use low_latency. I'll remove
> >> > the check in next post.
> >> Great.
> >> >> > I have a test of random direct io of two threads, each has 32 requests one time
> >> >> > without patch: 78m/s
> >> >> > with tweak 1: 138m/s
> >> >> > with two tweaks and disable latency: 156m/s
> >> >>
> >> >> Please, test also with competing seq/random(depth1)/async workloads,
> >> >> and measure also introduced latencies.
> >> > depth1 should be ok, as if device can only send one request, it should not require
> >> > more requests from ioscheduler.
> >> I mean have a run with, at the same time:
> >> * one seq reader,
> >> * h random readers with depth 1 (non-aio)
> >> * one async seq writer
> >> * k random readers with large depth.
> >> In this way, you can see if the changes you introduce to boost your
> >> workload affect more realistic scenarios, in which various workloads
> >> are mixed.
> >> I explicitly add the depth1 random readers, since they are sceduled
> >> differently than the large (>4) depth ones.
> > I tried a fio script which does like your description, but the data
> > isn't stable, especially the write speed, other kind of io speed is
> > stable. Apply below patch doesn't make things worse (still write speed
> > isn't stable, other io is stable), so I can't say if the patch passes
> > the test, but it appears latency reported by fio hasn't change. I adopt
> > the slice_idle * dispatched approach, which I thought should be safe.
> 
> I'm doing some tests right now on a single ncq rotational disk, and
> the average service time when submitting with a high depth is halved
> w.r.t. depth 1, so I think you could test also with the formula :
> slice_idle * dispatched / 2. It should give a performance boost,
> without noticeable impact on latency
Thanks for looking at it. can you forward your tests to me so I can
check here? I'll do more aggressive formula next. It shouldn't impact
my SSD which is very fast, each request takes less than 1ms. We'd better
have a mechanism to measure device speed, but jiffies isn't good. I'm thinking
using sched_clock() which has its issue too like having drift between CPUs.

Thanks,
Shaohua
