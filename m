Return-Path: <linux-kernel-owner+w=401wt.eu-S1754230AbYLVJE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230AbYLVJE4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 04:04:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753352AbYLVJEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 04:04:40 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:2526 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316AbYLVJEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 04:04:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=IeJNTPT4X4lw56s50CRhZ1JCTyGxXnY2bayCs7sDcOy60dlq6gv6uTndHWATSlwLZB
         UQaQJz5tDQ9A0vaC0giVTxOUreOoaGd8RmdHkP5Lo53Cd8kQysilcu1xdlXPjwLtRFPF
         bB3hr1Orm7DWz+QRyNHsksgCkMjgh91A7UnGo=
Message-ID: <c62985530812220104s227f4d24k9142b56bce41f4f1@mail.gmail.com>
Date: Mon, 22 Dec 2008 10:04:38 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Frans Pop" <elendil@planet.nl>
Subject: Re: [PATCH] hrtimer: increase clock min delta threshold while interrupt hanging
Cc: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
In-Reply-To: <200812220307.16808.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <494EEC60.4080708@gmail.com> <200812220307.16808.elendil@planet.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/22 Frans Pop <elendil@planet.nl>:
>> Impact: avoid hanging on slow systems
>>
>> While using the function graph tracer on a virtualized system, the
>> hrtimer_interrupt can hang the system on an infinite loop.
>> This can be caused on several situation where something intrusive is
>> slowing the system (ie: tracing) and the next clock events to program
>> are always before the current time.
>> This patch implements a reasonable compromise. If such a situation is
>> detected, we share the CPUs time in 1/4 to process the hrtimer
>> interrupts. This is enough to let the system running without serious
>> starvation.
>
> Should there maybe also be a mechanism to allow the system to automatically
> "recover" to higher (the original?) clockfrequencies, for example if the
> danger of loops has passed after tracing has been disabled?


As Ingo said, printing a warning should be enough.
The real problem lays in the fact that we don't know the source of the
slowness. It can
be tracing, it can be something else (why not an nmi bombing)....


>> It has been successfully tested under VirtualBox with 1000 HZ and 100
>> HZ with function graph tracer launched. On both cases, the clock events
>> were increased until about 25 ms periodic ticks, which means 40 HZ.
>>
>> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> ---
>>  kernel/hrtimer.c |   30 +++++++++++++++++++++++++++++-
>>  1 files changed, 29 insertions(+), 1 deletions(-)
>>
>> diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
>> index bda9cb9..02f2477 100644
>> --- a/kernel/hrtimer.c
>> +++ b/kernel/hrtimer.c
>> @@ -1171,6 +1171,29 @@ static void __run_hrtimer(struct hrtimer *timer)
>>
>>  #ifdef CONFIG_HIGH_RES_TIMERS
>>
>> +static int force_clock_reprogram;
>
> Shouldn't this be initialized to 0?
>
>> +
>> +/*
>> + * After 5 iteration's attempts, we consider that hrtimer_interrupt()
>> + * is hanging, which could happen with something that slows the interrupt
>> + * such as the tracing. Then we force the clock reprogramming for each future
>> + * hrtimer interrupts to avoid infinite loops and use the min_delta_ns
>> + * threshold that we will overwrite.
>> + * The next tick event will be scheduled to 3 times we currently spend on
>> + * hrtimer_interrupt(). This gives a good compromise, the cpus will spend
>> + * 1/4 of their time to process the hrtimer interrupts. This is enough to
>> + * let it running without serious starvation.
>> + */
>> +
>> +static inline void
>> +hrtimer_interrupt_hanging(struct clock_event_device *dev,
>> +                       ktime_t try_time)
>> +{
>> +       force_clock_reprogram = 1;
>> +       dev->min_delta_ns = (unsigned long)try_time.tv64 * 3;
>> +       printk(KERN_WARNING "hrtimer: interrupt too slow, "
>> +               "forcing clock min delta to %lu ns\n", dev->min_delta_ns);
>> +}
>>  /*
>>   * High resolution timer interrupt
>>   * Called with interrupts disabled
>> @@ -1180,6 +1203,7 @@ void hrtimer_interrupt(struct clock_event_device *dev)
>>         struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
>>         struct hrtimer_clock_base *base;
>>         ktime_t expires_next, now;
>> +       int nr_retries = 0;
>>         int i;
>>
>>         BUG_ON(!cpu_base->hres_active);
>> @@ -1187,6 +1211,10 @@ void hrtimer_interrupt(struct clock_event_device *dev)
>>         dev->next_event.tv64 = KTIME_MAX;
>>
>>   retry:
>> +       /* 5 retries is enough to notice a hang */
>> +       if (!(++nr_retries % 5))
>> +               hrtimer_interrupt_hanging(dev, ktime_sub(ktime_get(), now)); +
>>         now = ktime_get();
>>
>>         expires_next.tv64 = KTIME_MAX;
>> @@ -1239,7 +1267,7 @@ void hrtimer_interrupt(struct clock_event_device *dev)
>>         /* Reprogramming necessary ? */
>>         if (expires_next.tv64 != KTIME_MAX) {
>> -               if (tick_program_event(expires_next, 0))
>> +               if (tick_program_event(expires_next, force_clock_reprogram))
>>                       goto retry;
>>         }
>>  }
>
> Shouldn't force_clock_reprogram be reset to 0 after it has fired and been
> handled?
>

No, we need to keep the clock reprogramming forcing for each next
hrtimer interrupt if
we want the min delta to be used inside tick_dev_program_event().
