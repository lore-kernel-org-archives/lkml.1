Return-Path: <linux-kernel-owner+w=401wt.eu-S1758156AbZDFQvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758156AbZDFQvk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 12:51:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757271AbZDFQu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 12:50:58 -0400
Received: from www.tglx.de ([62.245.132.106]:37324 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757105AbZDFQu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 12:50:57 -0400
Date: Mon, 6 Apr 2009 18:48:48 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       a.p.zijlstra@chello.nl, ego@in.ibm.com, mingo@elte.hu,
       andi@firstfloor.org, venkatesh.pallipadi@intel.com,
       vatsa@linux.vnet.ibm.com, arjan@infradead.org,
       svaidy@linux.vnet.ibm.com
Subject: Re: [v5 PATCH 4/4] timers: logic to move non pinned timers
In-Reply-To: <20090406162205.GE15269@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.2.00.0904061846140.21577@localhost.localdomain>
References: <20090406161357.GB15269@linux.vnet.ibm.com> <20090406162205.GE15269@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arun,

On Mon, 6 Apr 2009, Arun R Bharadwaj wrote:
> +again:
> +	new_cpu_base = &per_cpu(hrtimer_bases, cpu);
>  	new_base = &new_cpu_base->clock_base[base->index];
>  
>  	if (base != new_base) {
> @@ -219,6 +230,34 @@ switch_hrtimer_base(struct hrtimer *time
>  		timer->base = NULL;
>  		spin_unlock(&base->cpu_base->lock);
>  		spin_lock(&new_base->cpu_base->lock);
> +
> +		if (cpu == preferred_cpu) {
> +			/* Calculate clock monotonic expiry time */
> +			ktime_t expires = ktime_sub(hrtimer_get_expires(timer),
> +							new_base->offset);
> +
> +			/*
> +			 * Get the next event on target cpu from the
> +			 * clock events layer.
> +			 * This covers the highres=off nohz=on case as well.
> +			 */
> +			ktime_t next = clockevents_get_next_event(cpu);
> +
> +			ktime_t delta = ktime_sub(expires, next);
> +
> +			/*
> +			 * We do not migrate the timer when it is expiring
> +			 * before the next event on the target cpu because
> +			 * we cannot reprogram the target cpu hardware and
> +			 * we would cause it to fire late.
> +			 */
> +			if (delta.tv64 < 0) {
> +				cpu = smp_processor_id();
> +				spin_unlock(&new_base->cpu_base->lock);
> +				spin_lock(&base->cpu_base->lock);

Darn, I knew that I missed something when I looked at this before:

      	     	    	   	 timer->base = base;

Thanks,

	tglx
