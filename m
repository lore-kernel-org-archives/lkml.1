Return-Path: <linux-kernel-owner+w=401wt.eu-S1761962AbYFEXxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761962AbYFEXxd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 19:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752850AbYFEXx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 19:53:26 -0400
Received: from hs-out-0708.google.com ([64.233.178.241]:33495 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519AbYFEXxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 19:53:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=N3c7u9F/dPg5wcLsu0PK0Kq1CWM0L5Uh6ONXbD0HwvaMITKuld/RO526g7B/zEP6SZ
         ylVP1B1qa65lkdk0hxN1i8QpFZnaDnFZAj1a3RQcttJ0FwQ8EhXXD/m+xeRCPEbufpis
         dcokC9nuLgZQPmj8Ac+cPpnBxb++dD3XnKRFQ=
Message-ID: <48487C69.7000202@gmail.com>
Date: Thu, 05 Jun 2008 20:53:13 -0300
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Sitsofe Wheeler <sitsofe@yahoo.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [X86][BISECTED] WARNING: at kernel/lockdep.c:2680
References: <4844868F.20104@gmail.com> <1212483192.6304.8.camel@twins> <d1af83620806030522i4b8120dgda19d3196f0838f5@mail.gmail.com> <g26kkr$4qc$1@ger.gmane.org> <20080605130823.GD6332@elte.hu>
In-Reply-To: <20080605130823.GD6332@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Sitsofe Wheeler <sitsofe@yahoo.com> wrote:
> 
>> OK I've managed to bisect this down to commit 
>> [c6531cce6e6e4b99bcda46b6268d6f2d9e30aea4] (sched: do not trace 
>> sched_clock):
>>
>> commit c6531cce6e6e4b99bcda46b6268d6f2d9e30aea4
>> Author: Ingo Molnar <mingo@elte.hu>
>> Date:   Mon May 12 21:21:14 2008 +0200
>>
>>     sched: do not trace sched_clock
>>
>>     The tracer uses sched_clock, so do not trace it.
>>
>>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
>>     Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>>
>> Reverting this made the lockdep warning go away. Here is the bisection log:
> 
> ah, good find! Does the patch below (instead of the full revert) fix it 
> as well? I've queued the fix up into tip/tracing/ftrace.
> 
> 	Ingo
> 
> ---------------->
> Subject: sched: sched_clock() lockdep fix
> From: Ingo Molnar <mingo@elte.hu>
> Date: Thu Jun 05 15:04:17 CEST 2008
> 
> Sitsofe Wheeler reported a lockdep warning and bisected it down to:
> 
>> commit c6531cce6e6e4b99bcda46b6268d6f2d9e30aea4
>> Author: Ingo Molnar <mingo@elte.hu>
>> Date:   Mon May 12 21:21:14 2008 +0200
>>
>>     sched: do not trace sched_clock
> 
> do not use raw irq flags in cpu_clock() as it causes lockdep to lose
> track of the true state of the IRQ flag.
> 
> Reported-and-bisected-by: Sitsofe Wheeler <sitsofe@yahoo.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  kernel/sched.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux/kernel/sched.c
> ===================================================================
> --- linux.orig/kernel/sched.c
> +++ linux/kernel/sched.c
> @@ -862,7 +862,7 @@ unsigned long long notrace cpu_clock(int
>  	unsigned long long prev_cpu_time, time, delta_time;
>  	unsigned long flags;
>  
> -	raw_local_irq_save(flags);
> +	local_irq_save(flags);
>  	prev_cpu_time = per_cpu(prev_cpu_time, cpu);
>  	time = __cpu_clock(cpu) + per_cpu(time_offset, cpu);
>  	delta_time = time-prev_cpu_time;
> @@ -871,7 +871,7 @@ unsigned long long notrace cpu_clock(int
>  		time = __sync_cpu_clock(time, cpu);
>  		per_cpu(prev_cpu_time, cpu) = time;
>  	}
> -	raw_local_irq_restore(flags);
> +	local_irq_restore(flags);
>  
>  	return time;
>  }
> 

I didn't manage to get through a bisection run for the warning - thanks 
to Sitsofe for doing it.  The patch does eliminate the warning for me.

Thanks,

-- 
Kevin Winchester

