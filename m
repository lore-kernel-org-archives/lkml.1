Return-Path: <linux-kernel-owner+w=401wt.eu-S1763825AbYD3W5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763825AbYD3W5U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 18:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751290AbYD3W5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 18:57:04 -0400
Received: from gw.goop.org ([64.81.55.164]:42908 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753936AbYD3W5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 18:57:03 -0400
Message-ID: <4818F92F.5030505@goop.org>
Date: Wed, 30 Apr 2008 15:56:47 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080418)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-kernel@vger.kernel.org, peterz@infradead.org, npiggin@suse.de,
       linux-arch@vger.kernel.org, mingo@elte.hu, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 1/10] Add generic helpers for arch IPI function calls
References: <1209453990-7735-1-git-send-email-jens.axboe@oracle.com> <1209453990-7735-2-git-send-email-jens.axboe@oracle.com>
In-Reply-To: <1209453990-7735-2-git-send-email-jens.axboe@oracle.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> +/*
> + * smp_call_function_single - Run a function on a specific CPU
> + * @func: The function to run. This must be fast and non-blocking.
> + * @info: An arbitrary pointer to pass to the function.
> + * @retry: Unused
>   

I wonder if it isn't finally time to drop this parameter?  Now that 
there aren't a zillion arch implementations of this to fix, we only need 
to fix a dozen or so callers.

> + * @wait: If true, wait until function has completed on other CPUs.
> + *
> + * Returns 0 on success, else a negative status code.
> + */
> [...]
> +/**
> + * smp_call_function_mask(): Run a function on a set of other CPUs.
> + * @mask: The set of cpus to run on.
> + * @func: The function to run. This must be fast and non-blocking.
> + * @info: An arbitrary pointer to pass to the function.
> + * @wait: If true, wait (atomically) until function has completed on other CPUs.
> + *
> + * Returns 0 on success, else a negative status code.
> + *
> + * If @wait is true, then returns once @func has returned.
> + *
> + * You must not call this function with disabled interrupts or from a
> + * hardware interrupt handler or from a bottom half handler.
>   

Mention preemption needs to be disabled?  Or allow preemption and take 
appropriate precautions internally?  It's not obvious to me that all the 
callers are calling with preemption disabled.

> + */
> +int smp_call_function_mask(cpumask_t mask, void (*func)(void *), void *info,
> +			   int wait)
> +{
> +	struct call_function_data *data;
> +	cpumask_t allbutself;
> +	unsigned long flags;
> +	int cpu, num_cpus;
> +
> +	/* Can deadlock when called with interrupts disabled */
> +	WARN_ON(wait && irqs_disabled());
>   
WARN_ON(preemptible())?
preempt_disable()?

> +
> +	cpu = smp_processor_id();
> +	allbutself = cpu_online_map;
> +	cpu_clear(cpu, allbutself);
> +	cpus_and(mask, mask, allbutself);
> +	num_cpus = cpus_weight(mask);
>   
    J
