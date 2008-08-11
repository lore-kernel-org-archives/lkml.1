Return-Path: <linux-kernel-owner+w=401wt.eu-S1753130AbYHKMa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130AbYHKMa5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 08:30:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751498AbYHKMau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 08:30:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55481 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316AbYHKMat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 08:30:49 -0400
Date: Mon, 11 Aug 2008 14:30:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Langsdorf, Mark" <mark.langsdorf@amd.com>,
       lkml <linux-kernel@vger.kernel.org>, Gautham R Shenoy <ego@in.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Regression in 2.6.27-rc1 for set_cpus_allowed_ptr
Message-ID: <20080811123020.GB10082@elte.hu>
References: <6453C3CB8E2B3646B0D020C112613273C5AC5A@sausexmb4.amd.com> <200808082303.41068.rjw@sisk.pl> <b647ffbd0808081431q27a48113q5beee1bae7c24b0a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b647ffbd0808081431q27a48113q5beee1bae7c24b0a@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:

> 2008/8/8 Rafael J. Wysocki <rjw@sisk.pl>:
> > [Adding CCs]
> >
> > On Friday, 8 of August 2008, Langsdorf, Mark wrote:
> >> One of my co-workers noticed that the powernow-k8
> >> driver no longer restarts when a CPU core is
> >> hot-disabled and then hot-enabled on AMD quad-core
> >> systems.
> >>
> >> The following comands work fine on 2.6.26 and fail
> >> on 2.6.27-rc1:
> >>
> >> echo 0 > /sys/devices/system/cpu/cpu3/online
> >> echo 1 > /sys/devices/system/cpu/cpu3/online
> >> find /sys -name cpufreq
> >>
> >> For 2.6.26, the find will return a cpufreq
> >> directory for each processor.  In 2.6.27-rc1,
> >> the cpu3 directory is missing.
> >>
> >> After digging through the code, the following
> >> logic is failing when the core is hot-enabled
> >> at runtime.  The code works during the boot
> >> sequence.
> >>
> >>       cpumask_t = current->cpus_allowed;
> >>       set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
> >>       if (smp_processor_id() != cpu)
> >>               return -ENODEV;
> >>
> 
> 
> if it gets called from any of the cpu-hotplug handlers, it won't work
> now (x86-microcode is another victim).
> 
> Please give a try to the following patch: http://lkml.org/lkml/2008/7/30/171
> 
> does it help?
> 
> (the explanation is also available in this thread).

i've queued up the fix below in tip/sched/urgent.

	Ingo

------------------------>
>From 3bc8fb8f85b79aa2d6341adb5090799b93d64bc9 Mon Sep 17 00:00:00 2001
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Date: Wed, 30 Jul 2008 12:34:04 +0200
Subject: [PATCH] sched, cpu hotplug: fix set_cpus_allowed() use in hotplug callbacks

Mark Langsdorf reported:

> One of my co-workers noticed that the powernow-k8
> driver no longer restarts when a CPU core is
> hot-disabled and then hot-enabled on AMD quad-core
> systems.
>
> The following comands work fine on 2.6.26 and fail
> on 2.6.27-rc1:
>
> echo 0 > /sys/devices/system/cpu/cpu3/online
> echo 1 > /sys/devices/system/cpu/cpu3/online
> find /sys -name cpufreq
>
> For 2.6.26, the find will return a cpufreq
> directory for each processor.  In 2.6.27-rc1,
> the cpu3 directory is missing.
>
> After digging through the code, the following
> logic is failing when the core is hot-enabled
> at runtime.  The code works during the boot
> sequence.
>
>       cpumask_t = current->cpus_allowed;
>       set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
>       if (smp_processor_id() != cpu)
>               return -ENODEV;

a similar problem also affects the microcode driver.

So set the CPU active before calling the CPU_ONLINE notifier chain,
there are a handful of notifiers that use set_cpus_allowed().

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/cpu.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index e202a68..c977c33 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -349,6 +349,8 @@ static int __cpuinit _cpu_up(unsigned int cpu, int tasks_frozen)
 		goto out_notify;
 	BUG_ON(!cpu_online(cpu));
 
+	cpu_set(cpu, cpu_active_map);
+
 	/* Now call notifier in preparation. */
 	raw_notifier_call_chain(&cpu_chain, CPU_ONLINE | mod, hcpu);
 
@@ -383,9 +385,6 @@ int __cpuinit cpu_up(unsigned int cpu)
 
 	err = _cpu_up(cpu, 0);
 
-	if (cpu_online(cpu))
-		cpu_set(cpu, cpu_active_map);
-
 out:
 	cpu_maps_update_done();
 	return err;
