Return-Path: <linux-kernel-owner+w=401wt.eu-S1757472AbZCLSpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472AbZCLSpw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 14:45:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756469AbZCLSpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 14:45:43 -0400
Received: from fk-out-0910.google.com ([209.85.128.188]:58741 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934AbZCLSpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 14:45:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=L9//tpxi+gNiTANcbhHZaf8nOoY3MTe/y2R0k3lkfiJgJLlCrEuHq1BMm6ZIb6rIrf
         iBysNv4tVj/UNZTobNcU7SMKPAHf1KQrbpZeqfSjHcnZjjcuvZ9K6OSHDu2hUVyDFMZk
         ClBUnFaCGJr72C+k2FNvjvkbZ8xcAjnjXqKAI=
Date: Thu, 12 Mar 2009 19:45:37 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jason Baron <jbaron@redhat.com>
Cc: mingo@elte.hu, rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       acme@ghostprotocols.net, fche@redhat.com, peterz@infradead.org,
       compudj@krystal.dyndns.org
Subject: Re: [Patch 1/2] tracepoints for softirq entry/exit - add
	softirq-to-name array
Message-ID: <20090312184533.GB11045@nowhere>
References: <20090312183336.GB3352@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090312183336.GB3352@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 12, 2009 at 02:33:36PM -0400, Jason Baron wrote:
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


Hi,

May be you could abuse open_softirq() to append dynamically these entries:

char *softirq_to_name[NR_SOFTIRQS];

#define open_softirq(nr, func)	\
	softirq_to_name[nr] = __stringify(nr); \
	__open_softirq(nr, func);

So that it's a bit more scalable.

Frederic.


> +
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

