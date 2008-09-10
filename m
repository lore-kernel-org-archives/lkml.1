Return-Path: <linux-kernel-owner+w=401wt.eu-S1752832AbYIJJTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832AbYIJJTT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 05:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751650AbYIJJTH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 05:19:07 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37592 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbYIJJTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 05:19:06 -0400
Subject: Re: [BUG] 2.6.27-rc5 couldn't boot on tulsa machine randomly
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1221037978.25574.22.camel@ymzhang>
References: <1220930793.25574.20.camel@ymzhang>
	 <1221037978.25574.22.camel@ymzhang>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Sep 2008 11:19:00 +0200
Message-Id: <1221038340.2442.70.camel@twins.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.23.91 (2.23.91-1.fc10) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-09-10 at 17:12 +0800, Zhang, Yanmin wrote:
> On Tue, 2008-09-09 at 11:26 +0800, Zhang, Yanmin wrote:
> > On my tulsa x86-64 machine, kernel 2.6.25-rc5 couldn't boot randomly.
> > 
> > Basically, function __enable_runtime forgets to reset  rt_rq->rt_throttled to 0.
> Peter,
> 
> Is there any issue with the patch?

No, just got lost in my inbox due to me getting distracted at the wrong
moment, sorry!

> I tested 2.6.27-rc6 and it still couldn't boot on my tulsa machine. With my patch,
> kernel could boot.

> > When every cpu is up, per-cpu migration_thread is created and it runs very fast,
> > sometimes to mark the corresponding rt_rq->rt_throttled to 1 very quickly. After
> > all cpus are up, with below calling chain,
> > sched_init_smp => arch_init_sched_domains => build_sched_domains => ...
> > => cpu_attach_domain => rq_attach_root => set_rq_online => ... => ﻿__enable_runtime,
> > ﻿__enable_runtime is called against every rt_rq again, so rt_rq->rt_time is reset to
> > 0, but ﻿rt_rq->rt_throttled might be still 1. Later on function do_sched_rt_period_timer
> > couldn't reset it, and all RT tasks couldn't be scheduled to run on that cpu.
> > here is RT task migration_thread which is woken up when a task is migrated to another cpu.
> > 
> > Below patch fixes it against 2.6.27-rc5.
> > 
> > ﻿Signed-off-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Ingo, please push to Linus.

> > ---
> > 
> > diff -Nraup linux-2.6.27-rc5/kernel/sched_rt.c linux-2.6.27-rc5_fix/kernel/sched_rt.c
> > --- linux-2.6.27-rc5/kernel/sched_rt.c	2008-09-09 11:06:43.000000000 +0800
> > +++ linux-2.6.27-rc5_fix/kernel/sched_rt.c	2008-09-09 11:13:04.000000000 +0800
> > @@ -350,6 +350,7 @@ static void __enable_runtime(struct rq *
> >  		spin_lock(&rt_rq->rt_runtime_lock);
> >  		rt_rq->rt_runtime = rt_b->rt_runtime;
> >  		rt_rq->rt_time = 0;
> > +		rt_rq->rt_throttled = 0;
> >  		spin_unlock(&rt_rq->rt_runtime_lock);
> >  		spin_unlock(&rt_b->rt_runtime_lock);
> >  	}
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 

