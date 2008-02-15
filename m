Return-Path: <linux-kernel-owner+w=401wt.eu-S933132AbYBODqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933132AbYBODqW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 22:46:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764451AbYBODqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 22:46:05 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:17166 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764158AbYBODqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 22:46:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Ltkvir/INcuqLK+vaiMtxKn7lcHMeS/tiO5gczZZluHElmahSKTBchwPjpXeIV1amzA+sTXHShutWXw/1zCbZcYAsKWrnUTqbzclSg16e2TsZ987v9hJlM9jXiYHR/Kr4C2drNsqWb5dxy9RA1CgPvfMBEKUwmIPDfCCPchiyBM=
Message-ID: <86802c440802141945v85a2754i31bf7908957fe5a@mail.gmail.com>
Date: Thu, 14 Feb 2008 19:45:58 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [2.6.25-rc1] System no longer powers off after shutdown
Cc: "Greg KH" <gregkh@suse.de>, "Frans Pop" <elendil@planet.nl>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
In-Reply-To: <86802c440802141814t39b8082bx7ceb7eaf37c1142c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200802111623.38478.elendil@planet.nl>
	 <200802122139.14840.elendil@planet.nl>
	 <20080212205622.GA21986@suse.de>
	 <200802131239.14305.elendil@planet.nl>
	 <20080213165837.GA10129@suse.de>
	 <86802c440802141538m44d64b6as827426174874979d@mail.gmail.com>
	 <20080214234832.GA14363@elte.hu>
	 <86802c440802141814t39b8082bx7ceb7eaf37c1142c@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2008 at 6:14 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> On Thu, Feb 14, 2008 at 3:48 PM, Ingo Molnar <mingo@elte.hu> wrote:
>  >
>  >  * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>  >
>  >  > after disable cpufreq, i got
>  >  >
>  >  > ACPI: Preparing to enter system sleep state S5
>  >  > Disabling non-boot CPUs ...
>  >  > kvm: disabling virtualization on CPU1
>  >  > CPU 1 is now offline
>  >  > CPU1 is down
>  >  > kvm: disabling virtualization on CPU2
>  >  > CPU 2 is now offline
>  >  > ================> hang here.
>  >  >
>  >  > but x86.git/mm could go through down all the cpus....
>  >  >
>  >  > interesting...
>  >
>  >  i suspect some kobject related race, and i have the feeling this all is
>  >  timing dependent.
>  >
>  >  Andrew started seeing reboot hangs roughly around the time when the
>  >  kobject changes went upstream. Given that x86.git had flux in that
>  >  timeframe too i couldnt be sure what caused them.
>
>  it seems only happen
>  1. first hang with cpufreq enabled.
>  2. reboot to kernel with cpufreq disable will have problem.
>
>  wonder if different cpu freq out sync and next kernel with reboot
>  doesn't have cpufreq so it ....
>  -- with warm reset doesn't do the right job to sync freq again.

ACPI: Preparing to enter system sleep state S5
Disabling non-boot CPUs ...
kvm: disabling virtualization on CPU1
CPU 1 is now offline
1
2
3
4
5
CPU1 is down
kvm: disabling virtualization on CPU2
CPU 2 is now offline
1
2
3
4
5
CPU2 is down
kvm: disabling virtualization on CPU3
CPU 3 is now offline
========> some time later
Clocksource tsc unstable (delta = 515397918052 ns)
Time: hpet clocksource has been installed.


it hangs in

raw_notifier_call_chain(&cpu_chain, CPU_DEAD | mode, hcpu)== NOTIFY_BAD);

there are several nb, not sure which one cause hang.

8 hrtimer.c        hrtimers_init            1505
register_cpu_notifier(&hrtimers_nb);
9 rcuclassic.c     __rcu_init                570 register_cpu_notifier(&rcu_nb);
a rcupreempt.c     __rcu_init                892
register_cpu_notifier(&rcu_nb); ===> not used
b sched.c          migration_init           5951
register_cpu_notifier(&migration_notifier);
c softirq.c        spawn_ksoftirqd           645
register_cpu_notifier(&cpu_nfb);
d softlockup.c     spawn_softlockup_task     310
register_cpu_notifier(&cpu_nfb);
e timer.c          init_timers              1367
register_cpu_notifier(&timers_nb);
f page-writeback.c page_writeback_init       775
register_cpu_notifier(&ratelimit_nb);
g page_alloc.c     setup_per_cpu_pageset    2744
register_cpu_notifier(&pageset_notifier);
h slab.c           kmem_cache_init          1638
register_cpu_notifier(&cpucache_notifier);  ==> not used
i slub.c           kmem_cache_init          3036
register_cpu_notifier(&slab_notifier);
j vmstat.c         setup_vmstat              855
register_cpu_notifier(&vmstat_notifier);
k kvm_main.c       kvm_init                 1328 r =
register_cpu_notifier(&kvm_cpu_notifier);

maybe the one in softlockup.c?

YH
