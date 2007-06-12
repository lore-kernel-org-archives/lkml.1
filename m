Return-Path: <linux-kernel-owner+w=401wt.eu-S1757256AbXFLJDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256AbXFLJDq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 05:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753657AbXFLJDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 05:03:38 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:59051 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086AbXFLJDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 05:03:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PNDLIjt/XZascRfziK2VtwLK4pdTgjmW07wH+La7oRNS2qNMwWfpl/2Y17CEUSYLeucJZclc9AsIMWmbYYhVelmDStL5WTefv4PVFZ+ehPfvsn5njTgT8EAdM5EvtPYp21Bz1LhI8iAI0jIORCRZKAui9Rrt72NxtI2qeA1QC/Q=
Message-ID: <b647ffbd0706120203l2de530b9la51853b928d60b92@mail.gmail.com>
Date: Tue, 12 Jun 2007 11:03:36 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: vatsa@linux.vnet.ibm.com
Subject: Re: [RFC][PATCH 4/6] Fix (bad?) interactions between SCHED_RT and SCHED_NORMAL tasks
Cc: "Ingo Molnar" <mingo@elte.hu>, "Nick Piggin" <nickpiggin@yahoo.com.au>,
       efault@gmx.de, kernel@kolivas.org, containers@lists.osdl.org,
       ckrm-tech@lists.sourceforge.net, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, pwil3058@bigpond.net.au, tingy@cs.umass.edu,
       tong.n.li@intel.com, wli@holomorphy.com, linux-kernel@vger.kernel.org,
       dmitry.adamushko@gmail.com, balbir@in.ibm.com
In-Reply-To: <20070611155504.GD2109@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070611154724.GA32435@in.ibm.com>
	 <20070611155504.GD2109@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/07, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> wrote:
> Currently nr_running and raw_weighted_load fields in runqueue affect
> some CFS calculations (like distribute_fair_add, enqueue_sleeper etc).

[ briefly looked.. a few comments so far ]


(1)

I had an idea of per-sched-class 'load balance' calculator. So that
update_load() (as in your patch) would look smth like :

...
struct sched_class *class = sched_class_highest;
unsigned long total = 0;

do {
                total += class->update_load(..., now);
                class = class->next;
     } while (class);
...

and e.g. update_load_fair() would become a fair_sched_class :: update_load().

That said, all the sched_classes would report a load created by their
entities (tasks) over the last sampling period. Ideally, the
calculation should not be merely based on the 'raw_weighted_load' but
rather done in a similar way to update_load_fair() as in v17.

I'll take a look at how it can be mapped on the current v17 codebase
(including your patches #1-3) and come up with some real code so we
would have a base for discussion.


(2)

>  static void entity_tick(struct lrq *lrq, struct sched_entity *curr)
>  {
>         struct sched_entity *next;
>         struct rq *rq = lrq_rq(lrq);
>         u64 now = __rq_clock(rq);
>
> +       /* replay load smoothening for all ticks we lost */
> +       while (time_after_eq64(now, lrq->last_tick)) {
> +               update_load_fair(lrq);
> +               lrq->last_tick += TICK_NSEC;
> +       }

I think, it won't work properly this way. The first call returns a
load for last TICK_NSEC and all the consequent ones report zero load
('this_load = 0' internally).. as a result, we will get a lower load
than it likely was.

I guess, update_load_fair() (as it's in v17) could be slightly changed
to report the load for an interval of time over which the load
statistics have been accumulated (delta_exec_time and fair_exec_time):

update_load_fair(Irq, now - Irq->last_tick)

This new (second) argument would be used instead of TICK_NSEC
(internally in update_load_fair()) ... but again, I'll come up with
some code for further discussion.


> --
> Regards,
> vatsa
>

-- 
Best regards,
Dmitry Adamushko
