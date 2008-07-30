Return-Path: <linux-kernel-owner+w=401wt.eu-S1757079AbYG3A0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757079AbYG3A0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 20:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753434AbYG3A0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 20:26:09 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42930 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249AbYG3A0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 20:26:06 -0400
Date: Wed, 30 Jul 2008 02:26:03 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andi Kleen <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] generic smp function call: add multiple queues for scaling
Message-ID: <20080730002603.GB23938@one.firstfloor.org>
References: <488FA8A5.6060204@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <488FA8A5.6060204@goop.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ah I see the locking is here. Never mind the earlier comment.

> +#define	NQUEUES	CONFIG_GENERIC_SMP_QUEUES
> +#else
> +#define	NQUEUES	1
> +#endif
> +
> static DEFINE_PER_CPU(struct call_single_queue, call_single_queue);
> -static LIST_HEAD(call_function_queue);
> -__cacheline_aligned_in_smp DEFINE_SPINLOCK(call_function_lock);
> +struct queue {
> +	struct list_head list;
> +	spinlock_t lock;
> +};
> +
> +static __cacheline_aligned_in_smp struct queue 
> call_function_queues[NQUEUES];

Hmm are you sure this aligns the individual elements and not the whole
array? 

> void ipi_call_unlock(void)
> {
> -	spin_unlock(&call_function_lock);
> +	int i;
> +
> +	for(i = 0; i < NQUEUES; i++)
> +		spin_unlock(&call_function_queues[i].lock);
> }
> 
> void ipi_call_lock_irq(void)
> {
> -	spin_lock_irq(&call_function_lock);
> +	int i;
> +
> +	for(i = 0; i < NQUEUES; i++)
> +		spin_lock_irq(&call_function_queues[i].lock);
> }
> 
> void ipi_call_unlock_irq(void)
> {
> -	spin_unlock_irq(&call_function_lock);
> +	int i;
> +
> +	for(i = 0; i < NQUEUES; i++)
> +		spin_unlock_irq(&call_function_queues[i].lock);
> }
> +
> +
> +static int __init init_smp_function_call(void)
> +{
> +	int i;
> +
> +	for(i = 0; i < NQUEUES; i++) {
> +		INIT_LIST_HEAD(&call_function_queues[i].list);
> +		spin_lock_init(&call_function_queues[i].lock);
> +	}
> +
> +	return 0;
> +}
> +early_initcall(init_smp_function_call);

You can avoid all that init gunk by using the [0 ... NQUEUES] = ..
gcc extension in the initializer.

-Andi
