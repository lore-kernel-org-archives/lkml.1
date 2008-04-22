Return-Path: <linux-kernel-owner+w=401wt.eu-S1761175AbYDVURU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761175AbYDVURU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 16:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753763AbYDVURJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 16:17:09 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37248 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267AbYDVURI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 16:17:08 -0400
Subject: Re: [PATCH 1/11] Add generic helpers for arch IPI function calls
From: Peter Zijlstra <peterz@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, npiggin@suse.de,
       torvalds@linux-foundation.org, sam@ravnborg.org
In-Reply-To: <1208890227-24808-2-git-send-email-jens.axboe@oracle.com>
References: <1208890227-24808-1-git-send-email-jens.axboe@oracle.com>
	 <1208890227-24808-2-git-send-email-jens.axboe@oracle.com>
Content-Type: text/plain
Date: Tue, 22 Apr 2008 22:17:03 +0200
Message-Id: <1208895423.7115.290.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-04-22 at 20:50 +0200, Jens Axboe wrote:

> +int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
> +			     int retry, int wait)
> +{
> +	unsigned long flags;
> +	/* prevent preemption and reschedule on another processor */
> +	int me = get_cpu();
> +
> +	/* Can deadlock when called with interrupts disabled */
> +	WARN_ON(wait && irqs_disabled());

With this fallback to wait the above condition isn't sufficient.

> +	if (cpu == me) {
> +		local_irq_save(flags);
> +		func(info);
> +		local_irq_restore(flags);
> +	} else {
> +		struct call_single_data *data;
> +
> +		if (wait) {
> +			struct call_single_data d;
> +
> +			data = &d;
> +			data->flags = CSD_FLAG_WAIT;
> +		} else {
> +			data = kmalloc(sizeof(*data), GFP_ATOMIC);
> +			if (data)
> +				data->flags = CSD_FLAG_ALLOC;
> +			else {
> +				while (test_and_set_bit_lock(0,
> +							&cfd_fallback_used))
> +					cpu_relax();
> +
> +				data = &cfd_fallback.csd;
> +				data->flags = CSD_FLAG_FALLBACK;
> +			}
> +		}
> +
> +		data->func = func;
> +		data->info = info;
> +		generic_exec_single(cpu, data);
> +	}
> +
> +	put_cpu();
> +	return 0;
> +}
> +EXPORT_SYMBOL(smp_call_function_single);


> +int smp_call_function_mask(cpumask_t mask, void (*func)(void *), void *info,
> +			   int wait)
> +{
> +	struct call_function_data *data;
> +	cpumask_t allbutself;
> +	unsigned long flags;
> +	int num_cpus;
> +
> +	/* Can deadlock when called with interrupts disabled */
> +	WARN_ON(wait && irqs_disabled());

idem

> +	allbutself = cpu_online_map;
> +	cpu_clear(smp_processor_id(), allbutself);
> +	cpus_and(mask, mask, allbutself);
> +	num_cpus = cpus_weight(mask);
> +
> +	if (!num_cpus)
> +		return 0;
> +
> +	if (wait) {
> +		struct call_function_data d;
> +
> +		data = &d;
> +		data->csd.flags = CSD_FLAG_WAIT;
> +	} else {
> +		data = kmalloc(sizeof(*data), GFP_ATOMIC);
> +		if (data)
> +			data->csd.flags = CSD_FLAG_ALLOC;
> +		else {
> +			while (test_and_set_bit_lock(0, &cfd_fallback_used))
> +				cpu_relax();
> +
> +			data = &cfd_fallback;
> +			data->csd.flags = CSD_FLAG_FALLBACK;
> +		}
> +	}
> +
> +	spin_lock_init(&data->lock);
> +	data->csd.func = func;
> +	data->csd.info = info;
> +	data->refs = num_cpus;
> +	data->cpumask = mask;
> +
> +	spin_lock_irqsave(&call_function_lock, flags);
> +	list_add_tail_rcu(&data->csd.list, &call_function_queue);
> +	spin_unlock_irqrestore(&call_function_lock, flags);
> +
> +	/* Send a message to all CPUs in the map */
> +	arch_send_call_function_ipi(mask);
> +
> +	/* optionally wait for the CPUs to complete */
> +	if (wait)
> +		csd_flag_wait(&data->csd);
> +
> +	return 0;
> +}



