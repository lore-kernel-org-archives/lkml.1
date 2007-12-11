Return-Path: <linux-kernel-owner+w=401wt.eu-S1753068AbXLKK4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068AbXLKK4n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 05:56:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751699AbXLKK4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 05:56:35 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:44122 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbXLKK4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 05:56:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GhWzPi2LE/EikjvrpKqhXVUimD0JmDJVj+0IDT6uIXqZtgjqYIracm2IZqw/wmqz31p5MV+z1CO1e861drr7r0d54WMVhh6MWyEfd9d+4vDjE/IGGHBRmAj2wR9A7BfHLsfJhaqZ4g0iO137UrwdGz7iXOH+dUAHl+LuHFf71GA=
Message-ID: <b647ffbd0712110256o587b7e40s4161b31577a2c0ea@mail.gmail.com>
Date: Tue, 11 Dec 2007 11:56:32 +0100
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH 1/4] Replace hooks with pre/post schedule and wakeup methods
Cc: linux-kernel <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       vatsa@linux.vnet.ibm.com, "Balbir Singh" <balbir@in.ibm.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Gregory Haskins" <ghaskins@novell.com>,
       "Steven Rostedt" <srostedt@goodmis.org>
In-Reply-To: <20071211023610.608838664@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071211021348.555887986@goodmis.org>
	 <20071211023610.608838664@goodmis.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2007, Steven Rostedt <rostedt@goodmis.org> wrote:
> To make the main sched.c code more agnostic to the schedule classes.
> Instead of having specific hooks in the schedule code for the RT class
> balancing. They are replaced with a pre_schedule, post_schedule
> and task_wake_up methods. These methods may be used by any of the classes
> but currently, only the sched_rt class implements them.
>
> Signed-off-by: Steven Rostedt <srostedt@goodmis.org>
> ---
>  include/linux/sched.h |    3 +++
>  kernel/sched.c        |   20 ++++++++++++++++----
>  kernel/sched_rt.c     |   17 +++++++----------
>  3 files changed, 26 insertions(+), 14 deletions(-)
>
> Index: linux-sched/include/linux/sched.h
> ===================================================================
> --- linux-sched.orig/include/linux/sched.h      2007-12-10 20:39:11.000000000 -0500
> +++ linux-sched/include/linux/sched.h   2007-12-10 20:39:14.000000000 -0500
> @@ -848,6 +848,9 @@ struct sched_class {
>         int (*move_one_task) (struct rq *this_rq, int this_cpu,
>                               struct rq *busiest, struct sched_domain *sd,
>                               enum cpu_idle_type idle);
> +       void (*pre_schedule) (struct rq *this_rq, struct task_struct *task);
> +       void (*post_schedule) (struct rq *this_rq);
> +       void (*task_wake_up) (struct rq *this_rq, struct task_struct *task);

IMHO, it looks much better this way.

I had an idea of having a set of defined 'load balancing' points in
sched.c. Then every sched_class would provide smth like struct
load_balance_ops; that contains a number of callbacks (one per load
balancing point) or just one generic load_balance() method with an
additional argument to distinguish between different 'points'. Then we
could have smth like :

generic_load_balance(event, rq, task)
{
      for_each_sched_class (class) {
              if (!class->load_balance)
                       continue;
              if (class->load_balance(event, rq, task))
                       break; /* success, don't propagate any further */
      }
}

[ i.e., the same way we do it in pick_next_task() ]

then e.g. the following block in schedule()

---
#ifdef CONFIG_SMP
       if (prev->sched_class->pre_schedule)
              prev->sched_class->pre_schedule(rq, prev);
#endif

if (unlikely(!rq->nr_running))
          idle_balance(cpu, rq);
---

would be substituted by:

generic_load_balance(PRE_SCHEDULE, rq, prev);

i.e., the following block

>         if (unlikely(!rq->nr_running))
>                 idle_balance(cpu, rq);

is called from sched_class_fair :: load_balance_fair()
upon getting a PRE_SCHEDULE load-balancing point.

IMHO, it would look nicer this way _BUT_ yeah, this 'full' abstraction
adds additional overhead to the hot-path (which might make it not that
worthy).



-- 
Best regards,
Dmitry Adamushko
