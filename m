Return-Path: <linux-kernel-owner+w=401wt.eu-S932356AbZKSDV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932356AbZKSDV7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 22:21:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757988AbZKSDV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 22:21:56 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59243 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757980AbZKSDVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 22:21:55 -0500
Date: Thu, 19 Nov 2009 04:20:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jean Delvare <khali@linux-fr.org>,
       Leon Woestenberg <leon.woestenberg@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-i2c@vger.kernel.org,
       rt-users <linux-rt-users@vger.kernel.org>,
       "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cleanup sched_yield (sys)call nesting.
Message-ID: <20091119032024.GA13378@elte.hu>
References: <20091107210147.3e754278@hyperion.delvare>
 <4AF7148C.9090706@thebigcorporation.com>
 <20091112211255.09cd884a@hyperion.delvare>
 <alpine.LFD.2.00.0911132139560.24119@localhost.localdomain>
 <20091116155606.GC29479@sirena.org.uk>
 <c384c5ea0911171650t1c441dc4v746d31e4154fcb30@mail.gmail.com>
 <20091118010520.4cd397d4@lxorguk.ukuu.org.uk>
 <c384c5ea0911180828x7c857189w3316c93bb78100ab@mail.gmail.com>
 <20091118175202.490989d8@hyperion.delvare>
 <1258577194.12429.86.camel@sven.thebigcorporation.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258577194.12429.86.camel@sven.thebigcorporation.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sven-Thorsten Dietrich <sven@thebigcorporation.com> wrote:

> Subject: clean up chaining in sched_yield()
> From: Sven-Thorsten Dietrich <sdietrich@suse.de>
> 
> The call to sys_sched_yield for in-Kernel is messy.
> and the return code from sys_sched_yield is ignored when called from
> in-kernel.
> 
> Signed-off-by: Sven-Thorsten Dietrich <sdietrich@suse.de>
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 3c11ae0..db2c0f9 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -6647,12 +6647,12 @@ SYSCALL_DEFINE3(sched_getaffinity, pid_t, pid, unsigned int, len,
>  }
>  
>  /**
> - * sys_sched_yield - yield the current processor to other threads.
> + * do_sched_yield - yield the current processor to other threads.
>   *
>   * This function yields the current CPU to other tasks. If there are no
>   * other threads running on this CPU then this function will return.
>   */
> -SYSCALL_DEFINE0(sched_yield)
> +static inline void do_sched_yield(void) 
>  {
>  	struct rq *rq = this_rq_lock();
>  
> @@ -6669,6 +6669,11 @@ SYSCALL_DEFINE0(sched_yield)
>  	preempt_enable_no_resched();
>  
>  	schedule();
> +}
> +
> +SYSCALL_DEFINE0(sched_yield)
> +{
> +	do_sched_yield();
>  
>  	return 0;
>  }
> @@ -6746,7 +6751,7 @@ EXPORT_SYMBOL(__cond_resched_softirq);
>  void __sched yield(void)
>  {
>  	set_current_state(TASK_RUNNING);
> -	sys_sched_yield();
> +	do_sched_yield();
>  }
>  EXPORT_SYMBOL(yield);

Why do you consider an in-kernel call to sys_*() 'messy'? It is not - 
and we rely on being able to do it with various syscalls.

Also, your patch bloats the scheduler a bit, for no good reason.

Thanks,

	Ingo
