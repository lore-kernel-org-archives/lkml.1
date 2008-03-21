Return-Path: <linux-kernel-owner+w=401wt.eu-S1760978AbYCUSz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760978AbYCUSz7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 14:55:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752901AbYCUSzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 14:55:51 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:62155 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbYCUSzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 14:55:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rFCtYW+jkpYFPH88A2f2gwbos/9mdO4xdkDVgVdqvesQrQfJMV5wEU9iwc6+2kCXZhGhkYlSyQgUMdENaJid41j9ynszzzJsgL58Xhb8fbRf1ImTODJJJUCd0ahPCrydt+FFUv8mdXW2ojreCfrJ7qKxAY2CkUl07C/1q3/D3o4=
Message-ID: <f19298770803211155m2641427eo932ca00382357354@mail.gmail.com>
Date: Fri, 21 Mar 2008 21:55:48 +0300
From: "Alexey Zaytsev" <alexey.zaytsev@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: printk timestamps jumping back and forth in 2.6.25-rc.
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
       lkml <linux-kernel@vger.kernel.org>,
       "Paul Mackerras" <paulus@samba.org>,
       "David Miller" <davem@davemloft.net>
In-Reply-To: <20080228201613.GA30999@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f19298770802280626g5ee17328ldedf7658a9f26f56@mail.gmail.com>
	 <20080228201315.GA30736@elte.hu> <20080228201613.GA30999@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/28/08, Ingo Molnar <mingo@elte.hu> wrote:
>
>  * Ingo Molnar <mingo@elte.hu> wrote:
>
>  > > Anything else I can do?
>  >
>  > yes, please test the patch below - does it fix the problem?
>
>
> (assuming you prefer patches that build, here's an updated one below.)
>

The patch was not included into the -rc6 kernel, so I thought maybe
I should remind about it. While the jumping timestamps might
be harmless, they for sure will confuse anyone observing some
unrelated bugs.

As I understand it, the overhead created on the architectures with
synchronous time stamp registers is not something measurable,
and the problem is more with the fact that some unnecessary
operations are performed and the result looks a bit ugly.
In this case, may I suggest to merge the patch for 2.6.25, and
revert it right after the release, until a better solution is found?

>
>         Ingo
>
>  -------------->
>  Subject: sched: make cpu_clock() globally synchronous
>  From: Ingo Molnar <mingo@elte.hu>
>  Date: Thu Feb 28 21:00:21 CET 2008
>
>  Alexey Zaytsev reported (and bisected) that the introduction of
>  cpu_clock() in printk made the timestamps jump back and forth.
>
>  Make cpu_clock() more reliable while still keeping it fast when it's
>  called frequently.
>
>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
>  ---
>   kernel/sched.c |   52 +++++++++++++++++++++++++++++++++++++++++++++++++---
>   1 file changed, 49 insertions(+), 3 deletions(-)
>
>  Index: linux/kernel/sched.c
>  ===================================================================
>  --- linux.orig/kernel/sched.c
>  +++ linux/kernel/sched.c
>  @@ -710,11 +710,39 @@ static inline u64 global_rt_runtime(void
>         return (u64)sysctl_sched_rt_runtime * NSEC_PER_USEC;
>   }
>
>  +static const unsigned long long time_sync_thresh = 100000;
>  +
>  +static DEFINE_PER_CPU(unsigned long long, time_offset);
>  +static DEFINE_PER_CPU(unsigned long long, prev_cpu_time);
>  +
>   /*
>  - * For kernel-internal use: high-speed (but slightly incorrect) per-cpu
>  - * clock constructed from sched_clock():
>  + * Global lock which we take every now and then to synchronize
>  + * the CPUs time. This method is not warp-safe, but it's good
>  + * enough to synchronize slowly diverging time sources and thus
>  + * it's good enough for tracing:
>   */
>  -unsigned long long cpu_clock(int cpu)
>  +static DEFINE_SPINLOCK(time_sync_lock);
>  +static unsigned long long prev_global_time;
>  +
>  +static unsigned long long __sync_cpu_clock(cycles_t time, int cpu)
>  +{
>  +       unsigned long flags;
>  +
>  +       spin_lock_irqsave(&time_sync_lock, flags);
>  +
>  +       if (time < prev_global_time) {
>  +               per_cpu(time_offset, cpu) += prev_global_time - time;
>  +               time = prev_global_time;
>  +       } else {
>  +               prev_global_time = time;
>  +       }
>  +
>  +       spin_unlock_irqrestore(&time_sync_lock, flags);
>  +
>  +       return time;
>  +}
>  +
>  +static unsigned long long __cpu_clock(int cpu)
>   {
>         unsigned long long now;
>         unsigned long flags;
>  @@ -735,6 +763,24 @@ unsigned long long cpu_clock(int cpu)
>
>         return now;
>   }
>  +
>  +/*
>  + * For kernel-internal use: high-speed (but slightly incorrect) per-cpu
>  + * clock constructed from sched_clock():
>  + */
>  +unsigned long long cpu_clock(int cpu)
>  +{
>  +       unsigned long long prev_cpu_time, time, delta_time;
>  +
>  +       prev_cpu_time = per_cpu(prev_cpu_time, cpu);
>  +       time = __cpu_clock(cpu) + per_cpu(time_offset, cpu);
>  +       delta_time = time-prev_cpu_time;
>  +
>  +       if (unlikely(delta_time > time_sync_thresh))
>
> +               time = __sync_cpu_clock(time, cpu);
>
> +
>  +       return time;
>  +}
>   EXPORT_SYMBOL_GPL(cpu_clock);
>
>   #ifndef prepare_arch_switch
>
