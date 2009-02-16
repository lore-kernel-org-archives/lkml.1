Return-Path: <linux-kernel-owner+w=401wt.eu-S1757055AbZBPL4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757055AbZBPL4m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 06:56:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754025AbZBPL4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 06:56:33 -0500
Received: from smtp-101-monday.noc.nerim.net ([62.4.17.101]:61670 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750705AbZBPL4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 06:56:32 -0500
From: Damien Wyart <damien.wyart@free.fr>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #12650] Strange load average and ksoftirqd behavior with 2.6.29-rc2-git1
References: <rjPbZ5GRJPO.A.1kE.ur0lJB@chimera>
	<20090215080941.GA2295@localhost.localdomain>
	<20090215090026.GA31147@elte.hu>
	<20090215095128.GA3234@localhost.localdomain>
	<20090215101351.GA23274@elte.hu>
	<20090215103445.GA2335@localhost.localdomain>
	<20090215110104.GB31351@elte.hu>
	<20090215180355.GA2273@localhost.localdomain>
	<20090215193102.GA16873@elte.hu>
	<20090216084223.GA2641@localhost.localdomain>
	<20090216095059.GL6182@elte.hu>
Date: Mon, 16 Feb 2009 12:56:30 +0100
In-Reply-To: <20090216095059.GL6182@elte.hu> (Ingo Molnar's message of "Mon,
	16 Feb 2009 10:50:59 +0100")
Message-ID: <87hc2u61e9.fsf@free.fr>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.0.90
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar <mingo@elte.hu> [090216 10:50]:
> hm, we need a trace with both abstime and process information included:

>   echo funcgraph-proc     > trace_options
>   echo funcgraph-abstime  > trace_options

> Also, at 140 msecs the duration is a bit short - could you please make a 
> 1-2 seconds capture? You can do that by increasing the number in 
> buffer_size_kb 10-fold:

>    echo 14100 > buffer_size_kb 

Ok, I've redone a trace with these options enabled. The file is here:
http://damien.wyart.free.fr/ksoftirqd_pb/trace_tip_2009.02.16_ksoftirqd_pb_abstime_proc.txt.gz

> Hm ... even with this limited trace, there's an unusually high amount of 
> RCU activities. Each activity goes like this:

>   457.680976 |   1)               |  do_softirq() {
>   457.680976 |   1)               |    __do_softirq() {
>   457.680977 |   1)               |      rcu_process_callbacks() {
>   457.680977 |   1)               |        __rcu_process_callbacks() {
> 4  457.680978 |   1)   0.478 us    |          force_quiescent_state();
>   457.680979 |   1)   1.591 us    |        }
>   457.680979 |   1)               |        __rcu_process_callbacks() {
>   457.680980 |   1)   0.478 us    |          force_quiescent_state();
>   457.680981 |   1)               |          cpu_quiet() {
>   457.680981 |   1)   0.506 us    |            _spin_lock_irqsave();
>   457.680982 |   1)   0.496 us    |            _spin_unlock_irqrestore();
>   457.680983 |   1)   2.545 us    |          }
>   457.680984 |   1)   4.626 us    |        }
>   457.680985 |   1)   7.823 us    |      }
>   457.680985 |   1)   0.496 us    |      _local_bh_enable();
>   457.680986 |   1)   9.845 us    |    }
>   457.680987 |   1) + 10.962 us   |  }

> I've Cc:-ed Paul, as you have tree-RCU enabled, which is a new feature 
> in v2.6.29:

>  #
>  # RCU Subsystem
>  #
>  # CONFIG_CLASSIC_RCU is not set
>  CONFIG_TREE_RCU=y
>  # CONFIG_PREEMPT_RCU is not set
>  # CONFIG_RCU_TRACE is not set
>  CONFIG_RCU_FANOUT=32
>  # CONFIG_RCU_FANOUT_EXACT is not set
>  # CONFIG_TREE_RCU_TRACE is not set
>  # CONFIG_PREEMPT_RCU_TRACE is not set

> Damien, as an experiment, if you change your config to 
> CONFIG_CLASSIC_RCU=y, does the ksoftirqd problem go away?

Yes, in that case the problem completely goes away. Nice catch!

> On the other hand ... the softirq processing there looks anomalous in
> itself, and might be due to some compiler bug perhaps. Could you try
> the debug patch below please (you'll get it automatically if you
> update to latest -tip), and redo the trace - the ftrace_printk() info
> should now be embedded in the trace. The expected result would be for
> the printed ot value to be non-zero at the #1 point, and zero at the
> #2 point.

> Note: if it's a compiler optimization bug then this patch might make the 
> whole problem go away.

> 	Ingo

> ------------------>
> >From 2d7cf65eec92937bff1073311f6843aa7189bff2 Mon Sep 17 00:00:00 2001
> From: Ingo Molnar <mingo@elte.hu>
> Date: Mon, 16 Feb 2009 10:48:37 +0100
> Subject: [PATCH] softirq: debug

> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  kernel/softirq.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)

> diff --git a/kernel/softirq.c b/kernel/softirq.c
> index 3dd0d13..110cad0 100644
> --- a/kernel/softirq.c
> +++ b/kernel/softirq.c
> @@ -196,7 +196,9 @@ asmlinkage void __do_softirq(void)
>  	cpu = smp_processor_id();
>  restart:
>  	/* Reset the pending bitmask before enabling irqs */
> +	ftrace_printk("#1 softirq pending: %08x\n", local_softirq_pending());
>  	set_softirq_pending(0);
> +	ftrace_printk("#2 softirq pending: %08x\n", local_softirq_pending());

>  	local_irq_enable();

I've done my new trace after recompiling very latest tip, so this should
have been taken into account.

So this seems RCU-related... If more tests are needed, do not hesitate
to ask. Btw, on the laptop which also shows ksoftirqd problems, I also
have CONFIG_TREE_RCU=y.

-- 
Damien
