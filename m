Return-Path: <linux-kernel-owner+w=401wt.eu-S1755763AbYDJIGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763AbYDJIGQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 04:06:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753307AbYDJIGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 04:06:03 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47705 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480AbYDJIGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 04:06:00 -0400
Date: Thu, 10 Apr 2008 17:04:19 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [patch 11/17] Implement immediate update via stop_machine_run
Cc: kosaki.motohiro@jp.fujitsu.com, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Jason Baron <jbaron@redhat.com>, Adrian Bunk <bunk@stusta.de>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Christoph Hellwig <hch@infradead.org>, akpm@osdl.org
In-Reply-To: <20080409152050.389300996@polymtl.ca>
References: <20080409150829.855195878@polymtl.ca> <20080409152050.389300996@polymtl.ca>
Message-Id: <20080410164159.2327.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> -Updating immediate values, cannot rely on smp_call_function() b/c synchronizing
>  cpus using IPIs leads to deadlocks. Process A held a read lock on 
>  tasklist_lock, then process B called apply_imv_update(). Process A received the 
>  IPI and begins executing ipi_busy_loop(). Then process C takes a write lock 
>  irq on the task list lock, before receiving the IPI. Thus, process A holds up 
>  process C, and C can't get an IPI b/c interrupts are disabled. Solve this 
>  problem by using a new 'ALL_CPUS' parameter to stop_machine_run(). Which 
>  runs a function on all cpus after they are busy looping and have disabled 
>  irqs. Since this is done in a new process context, we don't have to worry 
>  about interrupted spin_locks. Also, less lines of code. Has survived 24 hours+
>  of testing...

it seems this patch is must, Why do you separate patch [10/17] and [11/17]?
this patch remove almost portion of [10/17].
IMHO these patch merge into 1 patch is better.


> +static int stop_machine_imv_update(void *imv_ptr)
> +{
> +	struct __imv *imv = imv_ptr;
> +
> +	if (!wrote_text) {

it seems racy.
Why don't need test_and_set?

I think your stop_machine_run(ALL_CPUS) call fn concurrency...


> +		text_poke((void *)imv->imv, (void *)imv->var, imv->size);
> +		wrote_text = 1;
> +		smp_wmb(); /* make sure other cpus see that this has run */
> +	} else
> +		sync_core();
> +
> +	flush_icache_range(imv->imv, imv->imv + imv->size);
> +
> +	return 0;
> +}
> +


