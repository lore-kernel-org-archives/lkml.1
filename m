Return-Path: <linux-kernel-owner+w=401wt.eu-S1755103AbYKVFgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103AbYKVFgs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 00:36:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751110AbYKVFgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 00:36:39 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45763 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667AbYKVFgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 00:36:38 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
Subject: Re: [PATCH 1/3 v2] softirq: Introduce statistics for softirq
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, h-shimamoto@ct.jp.nec.com
In-Reply-To: <20081121202544.83dcd88f.kobayashi.kk@ncos.nec.co.jp>
References: <20081121202232.0489f84b.kobayashi.kk@ncos.nec.co.jp> <20081121202544.83dcd88f.kobayashi.kk@ncos.nec.co.jp>
Message-Id: <20081122142437.57B4.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Sat, 22 Nov 2008 14:36:34 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Statistics for softirq doesn't exist.
> It will be helpful like statistics for interrupts.
> This patch introduces counting the number of softirq,
> which will be exported in /proc/softirqs.
> 
> When softirq handler consumes much CPU time,
> /proc/stat is like the following.
> 
> $ while :; do  cat /proc/stat | head -n1 ; sleep 10 ; done
> cpu  88 0 408 739665 583 28 2 0 0
> cpu  450 0 1090 740970 594 28 1294 0 0
>                               ^^^^
>                              softirq
> 
> In such a situation,
> /proc/softirqs shows us which softirq handler is invoked.
> We can see the increase rate of softirqs.
> 
> <before>
> $ cat /proc/softirqs
>                 CPU0       CPU1       CPU2       CPU3
> HI                 0          0          0          0
> TIMER         462850     462805     462782     462718
> NET_TX             0          0          0        365
> NET_RX          2472          2          2         40
> BLOCK              0          0        381       1164
> TASKLET            0          0          0        224
> SCHED         462654     462689     462698     462427
> RCU             3046       2423       3367       3173
> 
> <after>
> $ cat /proc/softirqs
>                 CPU0       CPU1       CPU2       CPU3
> HI                 0          0          0          0
> TIMER         463361     465077     465056     464991
> NET_TX            53          0          1        365
> NET_RX          3757          2          2         40
> BLOCK              0          0        398       1170
> TASKLET            0          0          0        224
> SCHED         463074     464318     464612     463330
> RCU             3505       2948       3947       3673

Maybe, this printing format don't works well on >100 CPUS.

Do you have any experience of trouble-shooting by this patch?
Actually, I don't understand this patch usuful working situation.

Honestly, I think HI and TASKLET are not beneficialness.
end user can't know what tasklet spent time.
TIMER also are not so much useful because it always have the same rate.

So.. guessing...

ultra band-width networking problem?



> 
> When CPU TIME of softirq is high,
> the rates of increase is the following.
>   TIMER  : 220/sec     : CPU1-3
>   NET_TX : 5/sec       : CPU0
>   NET_RX : 120/sec     : CPU0
>   SCHED  : 40-200/sec  : all CPU
>   RCU    : 45-58/sec   : all CPU
> 
> The rates of increase in an idle mode is the following.
>   TIMER  : 250/sec
>   SCHED  : 250/sec
>   RCU    : 2/sec
> 
> It seems many softirqs for receiving packets and rcu are invoked.
> This gives us help for checking system.
> 
> Signed-off-by: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
> Reviewed-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> ---
>  include/linux/kernel_stat.h |   12 ++++++++++++
>  kernel/softirq.c            |    1 +
>  2 files changed, 13 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
> index 4a145ca..57c1643 100644
> --- a/include/linux/kernel_stat.h
> +++ b/include/linux/kernel_stat.h
> @@ -5,6 +5,7 @@
>  #include <linux/threads.h>
>  #include <linux/percpu.h>
>  #include <linux/cpumask.h>
> +#include <linux/interrupt.h>
>  #include <asm/irq.h>
>  #include <asm/cputime.h>
>  
> @@ -29,6 +30,7 @@ struct cpu_usage_stat {
>  struct kernel_stat {
>  	struct cpu_usage_stat	cpustat;
>  	unsigned int irqs[NR_IRQS];
> +	unsigned int softirqs[NR_SOFTIRQS];
>  };
>  
>  DECLARE_PER_CPU(struct kernel_stat, kstat);
> @@ -52,6 +54,16 @@ static inline unsigned int kstat_irqs_cpu(unsigned int irq, int cpu)
>         return kstat_cpu(cpu).irqs[irq];
>  }
>  
> +static inline void kstat_incr_softirqs_this_cpu(unsigned int irq)
> +{
> +	kstat_this_cpu.softirqs[irq]++;
> +}
> +
> +static inline unsigned int kstat_softirqs_cpu(unsigned int irq, int cpu)
> +{
> +       return kstat_cpu(cpu).softirqs[irq];
> +}
> +
>  /*
>   * Number of interrupts per specific IRQ source, since bootup
>   */
> diff --git a/kernel/softirq.c b/kernel/softirq.c
> index e7c69a7..088e179 100644
> --- a/kernel/softirq.c
> +++ b/kernel/softirq.c
> @@ -208,6 +208,7 @@ restart:
>  	do {
>  		if (pending & 1) {
>  			int prev_count = preempt_count();
> +			kstat_incr_softirqs_this_cpu(h - softirq_vec);
>  
>  			h->action(h);

you should explain this patch don't decrease system performance.



