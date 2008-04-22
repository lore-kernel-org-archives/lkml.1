Return-Path: <linux-kernel-owner+w=401wt.eu-S1755752AbYDVJQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752AbYDVJQY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 05:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756282AbYDVJQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 05:16:15 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:31155
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755570AbYDVJQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 05:16:14 -0400
Message-ID: <480DACDD.7040108@qumranet.com>
Date: Tue, 22 Apr 2008 12:16:13 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, npiggin@suse.de,
       torvalds@linux-foundation.org
Subject: Re: [PATCH 1/11] Add generic helpers for arch IPI function calls
References: <1208851058-8500-1-git-send-email-jens.axboe@oracle.com> <1208851058-8500-2-git-send-email-jens.axboe@oracle.com>
In-Reply-To: <1208851058-8500-2-git-send-email-jens.axboe@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> This adds kernel/smp.c which contains helpers for IPI function calls. In
> addition to supporting the existing smp_call_function() in a more efficient
> manner, it also adds a more scalable variant called smp_call_function_single()
> for calling a given function on a single CPU only.
>
> The core of this is based on the x86-64 patch from Nick Piggin, lots of
> changes since then. "Alan D. Brunelle" <Alan.Brunelle@hp.com> has
> contributed lots of fixes and suggestions as well.
>
> +int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
> +			     int retry, int wait)
> +{
> +	unsigned long flags;
> +	/* prevent preemption and reschedule on another processor */
> +	int me = get_cpu();
> +	int ret = 0;
> +
> +	/* Can deadlock when called with interrupts disabled */
> +	WARN_ON(wait && irqs_disabled());
> +
> +	if (cpu == me) {
> +		local_irq_save(flags);
> +		func(info);
> +		local_irq_restore(flags);
> +	} else {
> +		struct call_single_data d;
> +		struct call_single_data *data;
> +
> +		if (!wait) {
> +			data = kmalloc(sizeof(*data), GFP_ATOMIC);
> +			if (unlikely(!data)) {
> +				ret = -ENOMEM;
> +				goto out;
> +			}
> +			data->flags = CSD_FLAG_ALLOC;
> +		} else {
> +			data = &d;
> +			data->flags = CSD_FLAG_WAIT;
> +		}
> +
>   

Instead of introducing a rare error case, how about falling back to the 
wait case if the allocation fails?

Of course, if the called function relies on the calling cpu doing 
something else, then this fails, but I don't think anybody would do 
that?  On the other hand, there is at least one use of 
smp_call_function_single() with !wait, which doesn't check the error return.

-- 
error compiling committee.c: too many arguments to function

