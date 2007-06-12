Return-Path: <linux-kernel-owner+w=401wt.eu-S1754740AbXFLKV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740AbXFLKV5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 06:21:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752292AbXFLKVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 06:21:50 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:55061 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752083AbXFLKVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 06:21:49 -0400
Date: Tue, 12 Jun 2007 15:56:22 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
Cc: vatsa@linux.vnet.ibm.com, "Ingo Molnar" <mingo@elte.hu>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>, efault@gmx.de,
       kernel@kolivas.org, containers@lists.osdl.org,
       ckrm-tech@lists.sourceforge.net, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, pwil3058@bigpond.net.au, tingy@cs.umass.edu,
       tong.n.li@intel.com, wli@holomorphy.com, linux-kernel@vger.kernel.org,
       balbir@in.ibm.com
Subject: Re: [RFC][PATCH 4/6] Fix (bad?) interactions between SCHED_RT and SCHED_NORMAL tasks
Message-ID: <20070612102622.GA925@in.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20070611154724.GA32435@in.ibm.com> <20070611155504.GD2109@in.ibm.com> <b647ffbd0706120203l2de530b9la51853b928d60b92@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b647ffbd0706120203l2de530b9la51853b928d60b92@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2007 at 11:03:36AM +0200, Dmitry Adamushko wrote:
> I had an idea of per-sched-class 'load balance' calculator. So that
> update_load() (as in your patch) would look smth like :
> 
> ...
> struct sched_class *class = sched_class_highest;
> unsigned long total = 0;
> 
> do {
>                total += class->update_load(..., now);
>                class = class->next;
>     } while (class);
> ...
> 
> and e.g. update_load_fair() would become a fair_sched_class :: 
> update_load().
> 
> That said, all the sched_classes would report a load created by their
> entities (tasks) over the last sampling period. Ideally, the
> calculation should not be merely based on the 'raw_weighted_load' but
> rather done in a similar way to update_load_fair() as in v17.

I like this idea. It neatly segregates load calculation across classes.
It effectively replaces what update_load() function I introduced in
Patch #4.

Btw what will update_load_rt() return?

> > static void entity_tick(struct lrq *lrq, struct sched_entity *curr)
> > {
> >        struct sched_entity *next;
> >        struct rq *rq = lrq_rq(lrq);
> >        u64 now = __rq_clock(rq);
> >
> >+       /* replay load smoothening for all ticks we lost */
> >+       while (time_after_eq64(now, lrq->last_tick)) {
> >+               update_load_fair(lrq);
> >+               lrq->last_tick += TICK_NSEC;
> >+       }
> 
> I think, it won't work properly this way. The first call returns a
> load for last TICK_NSEC and all the consequent ones report zero load
> ('this_load = 0' internally).. 

mm ..

        exec_delta64 = this_lrq->delta_exec_clock + 1;
        this_lrq->delta_exec_clock = 0;

So exec_delta64 (and fair_delta64) should be min 1 in successive calls. How can that lead to this_load = 0?

The idea behind 'replay lost ticks' is to avoid load smoothening of
-every- lrq -every- tick. Lets say that there are ten lrqs
(corresponding to ten different users). We load smoothen only the currently 
active lrq (whose task is currently running). Other lrqs load get smoothened 
as soon as they become active next time (thus catching up with all lost ticks).


-- 
Regards,
vatsa
