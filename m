Return-Path: <linux-kernel-owner+w=401wt.eu-S1754514AbYHKO20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754514AbYHKO20 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 10:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753904AbYHKO2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 10:28:15 -0400
Received: from wx-out-0506.google.com ([66.249.82.237]:44104 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889AbYHKO2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 10:28:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=es0SrMgLk3qMZCrOkYzdI1f75oLIIU7wW/vEVWWh8DBs3Y1WaxFzaKvzU5awjBWv6v
         sEw6wRRXHFsZe2f8omqHG+fqI47uhh+TGIabfumdzsOkW/u+QGm4cPC46E0b3fzlb7Sw
         F9NXg1pBvahXMaCS4QQfogNpeEQhhHgkEpkQo=
Message-ID: <b647ffbd0808110728h66b9f2e8n501eb141763c6db1@mail.gmail.com>
Date: Mon, 11 Aug 2008 16:28:11 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: Regression in 2.6.27-rc1 for set_cpus_allowed_ptr
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Langsdorf, Mark" <mark.langsdorf@amd.com>,
       lkml <linux-kernel@vger.kernel.org>,
       "Gautham R Shenoy" <ego@in.ibm.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <20080811123020.GB10082@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6453C3CB8E2B3646B0D020C112613273C5AC5A@sausexmb4.amd.com>
	 <200808082303.41068.rjw@sisk.pl>
	 <b647ffbd0808081431q27a48113q5beee1bae7c24b0a@mail.gmail.com>
	 <20080811123020.GB10082@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/8/11 Ingo Molnar <mingo@elte.hu>:
>
> * Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:
>
>> 2008/8/8 Rafael J. Wysocki <rjw@sisk.pl>:
>> > [Adding CCs]
>> >
>> > On Friday, 8 of August 2008, Langsdorf, Mark wrote:
>> >> One of my co-workers noticed that the powernow-k8
>> >> driver no longer restarts when a CPU core is
>> >> hot-disabled and then hot-enabled on AMD quad-core
>> >> systems.
>> >>
>> >> The following comands work fine on 2.6.26 and fail
>> >> on 2.6.27-rc1:
>> >>
>> >> echo 0 > /sys/devices/system/cpu/cpu3/online
>> >> echo 1 > /sys/devices/system/cpu/cpu3/online
>> >> find /sys -name cpufreq
>> >>
>> >> For 2.6.26, the find will return a cpufreq
>> >> directory for each processor.  In 2.6.27-rc1,
>> >> the cpu3 directory is missing.
>> >>
>> >> After digging through the code, the following
>> >> logic is failing when the core is hot-enabled
>> >> at runtime.  The code works during the boot
>> >> sequence.
>> >>
>> >>       cpumask_t = current->cpus_allowed;
>> >>       set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
>> >>       if (smp_processor_id() != cpu)
>> >>               return -ENODEV;
>> >>
>>
>>
>> if it gets called from any of the cpu-hotplug handlers, it won't work
>> now (x86-microcode is another victim).
>>
>> Please give a try to the following patch: http://lkml.org/lkml/2008/7/30/171
>>
>> does it help?
>>
>> (the explanation is also available in this thread).
>
> i've queued up the fix below in tip/sched/urgent.
>
>        Ingo
>
> ------------------------>
> From 3bc8fb8f85b79aa2d6341adb5090799b93d64bc9 Mon Sep 17 00:00:00 2001
> From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
> Date: Wed, 30 Jul 2008 12:34:04 +0200
> Subject: [PATCH] sched, cpu hotplug: fix set_cpus_allowed() use in hotplug callbacks
>
> Mark Langsdorf reported:
>
>> One of my co-workers noticed that the powernow-k8
>> driver no longer restarts when a CPU core is
>> hot-disabled and then hot-enabled on AMD quad-core
>> systems.
>>
>> The following comands work fine on 2.6.26 and fail
>> on 2.6.27-rc1:
>>
>> echo 0 > /sys/devices/system/cpu/cpu3/online
>> echo 1 > /sys/devices/system/cpu/cpu3/online
>> find /sys -name cpufreq
>>
>> For 2.6.26, the find will return a cpufreq
>> directory for each processor.  In 2.6.27-rc1,
>> the cpu3 directory is missing.
>>
>> After digging through the code, the following
>> logic is failing when the core is hot-enabled
>> at runtime.  The code works during the boot
>> sequence.
>>
>>       cpumask_t = current->cpus_allowed;
>>       set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
>>       if (smp_processor_id() != cpu)
>>               return -ENODEV;
>
> a similar problem also affects the microcode driver.
>
> So set the CPU active before calling the CPU_ONLINE notifier chain,
> there are a handful of notifiers that use set_cpus_allowed().
>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>

This fix also solves the problem with x86-microcode. I've sent
alternative patches for microcode, but as this "rely on
set_cpus_allowed_ptr() being workable in cpu-hotplug(CPU_ONLINE, ...)"
thing seems to be more broad than what we thought, perhaps this fix
should be applied.

With this patch we define that by the moment CPU_ONLINE is being sent,
a 'cpu' is online and ready for tasks to be migrated onto it.


> ---
>  kernel/cpu.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/kernel/cpu.c b/kernel/cpu.c
> index e202a68..c977c33 100644
> --- a/kernel/cpu.c
> +++ b/kernel/cpu.c
> @@ -349,6 +349,8 @@ static int __cpuinit _cpu_up(unsigned int cpu, int tasks_frozen)
>                goto out_notify;
>        BUG_ON(!cpu_online(cpu));
>
> +       cpu_set(cpu, cpu_active_map);
> +
>        /* Now call notifier in preparation. */
>        raw_notifier_call_chain(&cpu_chain, CPU_ONLINE | mod, hcpu);
>
> @@ -383,9 +385,6 @@ int __cpuinit cpu_up(unsigned int cpu)
>
>        err = _cpu_up(cpu, 0);
>
> -       if (cpu_online(cpu))
> -               cpu_set(cpu, cpu_active_map);
> -
>  out:
>        cpu_maps_update_done();
>        return err;
>



-- 
Best regards,
Dmitry Adamushko
