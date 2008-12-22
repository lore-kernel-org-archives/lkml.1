Return-Path: <linux-kernel-owner+w=401wt.eu-S1755219AbYLVP2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219AbYLVP2k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 10:28:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754651AbYLVP22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 10:28:28 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:24655 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645AbYLVP21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 10:28:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=DWpLV6lAJLtZAhWmKh2fIsFdqA9zzYJ2FDkiOREth5x7EVi1mkiqmul18wK7WmxEU3
         yi8nsxQjNZ+JZ959Dlvw4eh++XbS7FzR2Lz0q79c4rdSGzj2Sof1JdHizC0jIm/APrTd
         xrVbOzADI1orBFKJWpWKur4j1yRywDXuBp9OQ=
Message-ID: <c62985530812220728v49a6da6hc2057032bc4bcb19@mail.gmail.com>
Date: Mon, 22 Dec 2008 16:28:26 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Cyrill Gorcunov" <gorcunov@gmail.com>
Subject: Re: [PATCH] hrtimer: increase clock min delta threshold while interrupt hanging
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20081222151723.GA7927@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <494EEC60.4080708@gmail.com> <20081222151723.GA7927@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/22 Cyrill Gorcunov <gorcunov@gmail.com>:
> [Frederic Weisbecker - Mon, Dec 22, 2008 at 02:24:48AM +0100]
> | Impact: avoid hanging on slow systems
> |
> | While using the function graph tracer on a virtualized system, the hrtimer_interrupt
> | can hang the system on an infinite loop.
> | This can be caused on several situation where something intrusive is slowing the
> | system (ie: tracing) and the next clock events to program are always before the current
> | time.
> | This patch implements a reasonable compromise. If such a situation is detected, we share
> | the CPUs time in 1/4 to process the hrtimer interrupts. This is enough to let the system
> | running without serious starvation.
> |
> | It has been successfully tested under VirtualBox with 1000 HZ and 100 HZ with function graph
> | tracer launched. On both cases, the clock events were increased until about 25 ms periodic ticks,
> | which means 40 HZ.
> |
> | Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> | Cc: Thomas Gleixner <tglx@linutronix.de>
> | ---
> |  kernel/hrtimer.c |   30 +++++++++++++++++++++++++++++-
> |  1 files changed, 29 insertions(+), 1 deletions(-)
> |
> | diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
> | index bda9cb9..02f2477 100644
> | --- a/kernel/hrtimer.c
> | +++ b/kernel/hrtimer.c
> | @@ -1171,6 +1171,29 @@ static void __run_hrtimer(struct hrtimer *timer)
> |
> |  #ifdef CONFIG_HIGH_RES_TIMERS
> |
> | +static int force_clock_reprogram;
> | +
> | +/*
> | + * After 5 iteration's attempts, we consider that hrtimer_interrupt()
> | + * is hanging, which could happen with something that slows the interrupt
> | + * such as the tracing. Then we force the clock reprogramming for each future
> | + * hrtimer interrupts to avoid infinite loops and use the min_delta_ns
> | + * threshold that we will overwrite.
> | + * The next tick event will be scheduled to 3 times we currently spend on
> | + * hrtimer_interrupt(). This gives a good compromise, the cpus will spend
> | + * 1/4 of their time to process the hrtimer interrupts. This is enough to
> | + * let it running without serious starvation.
> | + */
> | +
> | +static inline void
> | +hrtimer_interrupt_hanging(struct clock_event_device *dev,
> | +                     ktime_t try_time)
> | +{
> | +     force_clock_reprogram = 1;
> | +     dev->min_delta_ns = (unsigned long)try_time.tv64 * 3;
> | +     printk(KERN_WARNING "hrtimer: interrupt too slow, "
> | +             "forcing clock min delta to %lu ns\n", dev->min_delta_ns);
> | +}
> |  /*
> |   * High resolution timer interrupt
> |   * Called with interrupts disabled
> | @@ -1180,6 +1203,7 @@ void hrtimer_interrupt(struct clock_event_device *dev)
> |       struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
> |       struct hrtimer_clock_base *base;
> |       ktime_t expires_next, now;
> | +     int nr_retries = 0;
> |       int i;
> |
> |       BUG_ON(!cpu_base->hres_active);
> | @@ -1187,6 +1211,10 @@ void hrtimer_interrupt(struct clock_event_device *dev)
> |       dev->next_event.tv64 = KTIME_MAX;
> |
> |   retry:
> | +     /* 5 retries is enough to notice a hang */
> | +     if (!(++nr_retries % 5))
> | +             hrtimer_interrupt_hanging(dev, ktime_sub(ktime_get(), now));
> | +
> |       now = ktime_get();
>
> Hi Frederic,
>
> is it really needed to use mod operation here?


This is a kind of paranoid check.
But actually you are right, it is not necessary.
If we force the clock reprogramming, we will not retry again...



> Why cant we test for plain 5 and flush it to zero then?
> I mean something like
>
>        if (++nr_retries > 5) {
>                nr_retries = 0;
>                ...
>        }
>
> Did I miss anything?
>
>                - Cyrill -
>


Since the clock reprogramming can't fail anymore after that, we can
just check ++nr_retries == 5 or why not
++nr_retries >= 5 if we want to stay paranoid......

I will fix it if the patched is accepted...
