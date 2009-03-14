Return-Path: <linux-kernel-owner+w=401wt.eu-S1755054AbZCNCxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054AbZCNCxv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 22:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752821AbZCNCx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 22:53:27 -0400
Received: from tomts5.bellnexxia.net ([209.226.175.25]:46071 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753943AbZCNCxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 22:53:25 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AugFAJO2uklMQW1W/2dsb2JhbACBTc5Qg34G
Date: Fri, 13 Mar 2009 22:53:21 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Jason Baron <jbaron@redhat.com>
Cc: mingo@elte.hu, rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       acme@ghostprotocols.net, fweisbec@gmail.com, fche@redhat.com,
       peterz@infradead.org
Subject: Re: [Patch 1/2] tracepoints for softirq entry/exit - add
	softirq-to-name array
Message-ID: <20090314025321.GB22526@Krystal>
References: <20090312183336.GB3352@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090312183336.GB3352@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 22:51:54 up 13 days, 23:18,  2 users,  load average: 0.20, 0.23,
	0.16
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jason Baron (jbaron@redhat.com) wrote:
> 
> create a 'softirq_to_name' array, which is indexed by softirq #, so
> that we can easily convert between the softirq index # and its name, in
> order to get more meaningful output messages.
> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>
> 
> ---
> 
>  include/linux/interrupt.h |    5 +++++
>  kernel/softirq.c          |    9 ++++++++-
>  2 files changed, 13 insertions(+), 1 deletions(-)
> 
> 
> diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
> index e7bcfd7..da82ee4 100644
> --- a/include/linux/interrupt.h
> +++ b/include/linux/interrupt.h
> @@ -258,6 +258,11 @@ enum
>  	NR_SOFTIRQS
>  };
>  
> +/* map softirq index to softirq name. update 'softirq_to_name' in
> + * kernel/softirq.c when adding a new softirq.
> + */
> +extern char *softirq_to_name[NR_SOFTIRQS];
> +
>  /* softirq mask and active fields moved to irq_cpustat_t in
>   * asm/hardirq.h to get better cache usage.  KAO
>   */
> diff --git a/kernel/softirq.c b/kernel/softirq.c
> index 40ff3cf..ba1511f 100644
> --- a/kernel/softirq.c
> +++ b/kernel/softirq.c
> @@ -53,6 +53,12 @@ static struct softirq_action softirq_vec[NR_SOFTIRQS] __cacheline_aligned_in_smp
>  
>  static DEFINE_PER_CPU(struct task_struct *, ksoftirqd);
>  
> +char *softirq_to_name[NR_SOFTIRQS] = {
> +	"HI_SOFTIRQ", "TIMER_SOFTIRQ", "NET_TX_SOFTIRQ", "NET_RX_SOFTIRQ",
> +	"BLOCK_SOFTIRQ", "TASKLET_SOFTIRQ", "SCHED_SOFTIRQ", "HRTIMER_SOFTIRQ",
> +	"RCU_SOFTIRQ"
> +};
> +

Small nit :

this should be a const char *.

Besides that it looks good, and very useful to a tracer. We just have to
make sure this table can eventually be saved into a trace.

Mathieu

>  /*
>   * we cannot loop indefinitely here to avoid userspace starvation,
>   * but we also don't want to introduce a worst case 1/HZ latency
> @@ -209,9 +215,10 @@ restart:
>  			h->action(h);
>  
>  			if (unlikely(prev_count != preempt_count())) {
> -				printk(KERN_ERR "huh, entered softirq %td %p"
> +				printk(KERN_ERR "huh, entered softirq %td %s %p"
>  				       "with preempt_count %08x,"
>  				       " exited with %08x?\n", h - softirq_vec,
> +				       softirq_to_name[h - softirq_vec],
>  				       h->action, prev_count, preempt_count());
>  				preempt_count() = prev_count;
>  			}
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
