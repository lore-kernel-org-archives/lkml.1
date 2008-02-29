Return-Path: <linux-kernel-owner+w=401wt.eu-S1757541AbYB2BRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757541AbYB2BRf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 20:17:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750909AbYB2BRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 20:17:23 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:45423 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750743AbYB2BRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 20:17:21 -0500
Date: Thu, 28 Feb 2008 17:16:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Karsten Wiese <fzu@wemgehoertderstaat.de>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Optimise tick_nohz_stop_sched_tick() a bit
Message-Id: <20080228171634.f6fab4de.akpm@linux-foundation.org>
In-Reply-To: <200802281510.51191.fzu@wemgehoertderstaat.de>
References: <200802281510.51191.fzu@wemgehoertderstaat.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Feb 2008 15:10:50 +0100 Karsten Wiese <fzu@wemgehoertderstaat.de> wrote:

> 
> Call
> 	ts = &per_cpu(tick_cpu_sched, cpu);
> and
> 	cpu = smp_processor_id();
> once instead of twice.
> 
> No functional change done, as changed code runs with local irq off.
> Reduces source lines and text size (20bytes on x86_64).
> 
> Signed-off-by: Karsten Wiese <fzu@wemgehoertderstaat.de>
> ---
>  kernel/time/tick-sched.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index 686da82..851a852 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -158,9 +158,8 @@ void tick_nohz_stop_idle(int cpu)
>  	}
>  }
>  
> -static ktime_t tick_nohz_start_idle(int cpu)
> +static ktime_t tick_nohz_start_idle(int cpu, struct tick_sched *ts)

Argument `cpu' is now unused.

>  {
> -	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
>  	ktime_t now, delta;
>  
>  	now = ktime_get();
> @@ -201,8 +200,8 @@ void tick_nohz_stop_sched_tick(void)
>  	local_irq_save(flags);
>  
>  	cpu = smp_processor_id();
> -	now = tick_nohz_start_idle(cpu);
>  	ts = &per_cpu(tick_cpu_sched, cpu);
> +	now = tick_nohz_start_idle(cpu, ts);
>  
>  	/*
>  	 * If this cpu is offline and it is the one which updates
> @@ -222,7 +221,6 @@ void tick_nohz_stop_sched_tick(void)
>  	if (need_resched())
>  		goto end;
>  
> -	cpu = smp_processor_id();
>  	if (unlikely(local_softirq_pending())) {
>  		static int ratelimit;
>  


--- a/kernel/time/tick-sched.c~optimise-tick_nohz_stop_sched_tick-a-bit-fix
+++ a/kernel/time/tick-sched.c
@@ -158,7 +158,7 @@ void tick_nohz_stop_idle(int cpu)
 	}
 }
 
-static ktime_t tick_nohz_start_idle(int cpu, struct tick_sched *ts)
+static ktime_t tick_nohz_start_idle(struct tick_sched *ts)
 {
 	ktime_t now, delta;
 
@@ -200,7 +200,7 @@ void tick_nohz_stop_sched_tick(void)
 
 	cpu = smp_processor_id();
 	ts = &per_cpu(tick_cpu_sched, cpu);
-	now = tick_nohz_start_idle(cpu, ts);
+	now = tick_nohz_start_idle(ts);
 
 	/*
 	 * If this cpu is offline and it is the one which updates
_

