Return-Path: <linux-kernel-owner+w=401wt.eu-S1753257AbYIJJPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257AbYIJJPb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 05:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751584AbYIJJPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 05:15:23 -0400
Received: from mga10.intel.com ([192.55.52.92]:41425 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751501AbYIJJPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 05:15:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,371,1217833200"; 
   d="scan'208";a="378687643"
Subject: Re: [BUG] 2.6.27-rc5 couldn't boot on tulsa machine randomly
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1220930793.25574.20.camel@ymzhang>
References: <1220930793.25574.20.camel@ymzhang>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 10 Sep 2008 17:12:58 +0800
Message-Id: <1221037978.25574.22.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-09-09 at 11:26 +0800, Zhang, Yanmin wrote:
> On my tulsa x86-64 machine, kernel 2.6.25-rc5 couldn't boot randomly.
> 
> Basically, function __enable_runtime forgets to reset  rt_rq->rt_throttled to 0.
Peter,

Is there any issue with the patch?

I tested 2.6.27-rc6 and it still couldn't boot on my tulsa machine. With my patch,
kernel could boot.

Yanmin


> When every cpu is up, per-cpu migration_thread is created and it runs very fast,
> sometimes to mark the corresponding rt_rq->rt_throttled to 1 very quickly. After
> all cpus are up, with below calling chain,
> sched_init_smp => arch_init_sched_domains => build_sched_domains => ...
> => cpu_attach_domain => rq_attach_root => set_rq_online => ... => ﻿__enable_runtime,
> ﻿__enable_runtime is called against every rt_rq again, so rt_rq->rt_time is reset to
> 0, but ﻿rt_rq->rt_throttled might be still 1. Later on function do_sched_rt_period_timer
> couldn't reset it, and all RT tasks couldn't be scheduled to run on that cpu.
> here is RT task migration_thread which is woken up when a task is migrated to another cpu.
> 
> Below patch fixes it against 2.6.27-rc5.
> 
> ﻿Signed-off-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>
> 
> ---
> 
> diff -Nraup linux-2.6.27-rc5/kernel/sched_rt.c linux-2.6.27-rc5_fix/kernel/sched_rt.c
> --- linux-2.6.27-rc5/kernel/sched_rt.c	2008-09-09 11:06:43.000000000 +0800
> +++ linux-2.6.27-rc5_fix/kernel/sched_rt.c	2008-09-09 11:13:04.000000000 +0800
> @@ -350,6 +350,7 @@ static void __enable_runtime(struct rq *
>  		spin_lock(&rt_rq->rt_runtime_lock);
>  		rt_rq->rt_runtime = rt_b->rt_runtime;
>  		rt_rq->rt_time = 0;
> +		rt_rq->rt_throttled = 0;
>  		spin_unlock(&rt_rq->rt_runtime_lock);
>  		spin_unlock(&rt_b->rt_runtime_lock);
>  	}
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

