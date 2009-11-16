Return-Path: <linux-kernel-owner+w=401wt.eu-S1752064AbZKPJFM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064AbZKPJFM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 04:05:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751901AbZKPJFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 04:05:11 -0500
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:57108 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbZKPJFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 04:05:09 -0500
Date: Mon, 16 Nov 2009 10:05:06 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Gregory Haskins <ghaskins@novell.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [BUG] sched_rt_periodic_timer vs cpu hotplug
Message-ID: <20091116090506.GA6077@osiris.boeblingen.de.ibm.com>
References: <20091111101801.GA19103@osiris.boeblingen.de.ibm.com>
 <1257935428.23203.82.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257935428.23203.82.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 11, 2009 at 11:30:28AM +0100, Peter Zijlstra wrote:
> On Wed, 2009-11-11 at 11:18 +0100, Heiko Carstens wrote:
> > we've seen a crash on s390 which seems to be related to sched_rt_period_timer vs.
> > cpu hotplug:
> > 
> >     <1>Unable to handle kernel pointer dereference at virtual kernel address 00000000ff5ec000
> >     <4>Oops: 0011 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[...]
> >     <4>Krnl PSW : 0404200180000000 000000000013952c (sched_rt_period_timer+0x188/0x3d8)
[...]
> >     <4>([<00000000001394d0>] sched_rt_period_timer+0x12c/0x3d8)
> >     <4> [<0000000000173db0>] __run_hrtimer+0xb0/0x110
> >     <4> [<00000000001740b2>] hrtimer_interrupt+0xf2/0x1e8
> >     <4> [<000000000010770c>] clock_comparator_work+0x68/0x70
> >     <4> [<000000000010dbc0>] do_extint+0x18c/0x190
> >     <4> [<0000000000117f9e>] ext_no_vtime+0x1e/0x22
> >     <4> [<000000000058ea04>] _spin_unlock_irq+0x48/0x80
> >     <4>([<000000000058ea00>] _spin_unlock_irq+0x44/0x80)
> >     <4> [<000000000043c190>] dasd_block_tasklet+0x1b8/0x2b0
> >     <4> [<0000000000155b0e>] tasklet_hi_action+0xfe/0x1f4
> >     <4> [<00000000001570d4>] __do_softirq+0x184/0x2e8
> >     <4> [<0000000000110b34>] do_softirq+0xe4/0xe8
> >     <4> [<0000000000156ac4>] irq_exit+0xc0/0xe0
> >     <4> [<000000000010db7a>] do_extint+0x146/0x190
> >     <4> [<0000000000117f9e>] ext_no_vtime+0x1e/0x22
> >     <4> [<0000000000115040>] vtime_stop_cpu+0xac/0x100
> >     <4>([<0000000000114fe6>] vtime_stop_cpu+0x52/0x100)
> >     <4> [<000000000010a324>] cpu_idle+0xfc/0x198
> >     <4> [<0000000000584a64>] start_secondary+0xb4/0xc0
>
> Does something like the below fix it? Normal sched_domain bits also do
> sync_sched() for domain destruction as can be seen from
> detach_destroy_domains()..
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 91642c1..3b02339 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -7918,6 +7923,8 @@ sd_parent_degenerate(struct sched_domain *sd, struct sched_domain *parent)
>  
>  static void free_rootdomain(struct root_domain *rd)
>  {
> +	synchronize_sched();
> +
>  	cpupri_cleanup(&rd->cpupri);

We haven't seen the bug above with your patch applied again. On the other
hand the race window is so small, that we were also unable to reproduce
the original bug.
Instead we are later running into a different use-after-free bug. But that
one is unrelated to this one.

Anyway, your patch should fix this bug. Would be good to have it in .32

Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>
