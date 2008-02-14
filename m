Return-Path: <linux-kernel-owner+w=401wt.eu-S935523AbYBNXt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935523AbYBNXt4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 18:49:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934852AbYBNXsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 18:48:45 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56677 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933614AbYBNXsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 18:48:43 -0500
Date: Fri, 15 Feb 2008 00:48:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Greg KH <gregkh@suse.de>, Frans Pop <elendil@planet.nl>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [2.6.25-rc1] System no longer powers off after shutdown
Message-ID: <20080214234832.GA14363@elte.hu>
References: <200802111623.38478.elendil@planet.nl> <200802122139.14840.elendil@planet.nl> <20080212205622.GA21986@suse.de> <200802131239.14305.elendil@planet.nl> <20080213165837.GA10129@suse.de> <86802c440802141538m44d64b6as827426174874979d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440802141538m44d64b6as827426174874979d@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> after disable cpufreq, i got
> 
> ACPI: Preparing to enter system sleep state S5
> Disabling non-boot CPUs ...
> kvm: disabling virtualization on CPU1
> CPU 1 is now offline
> CPU1 is down
> kvm: disabling virtualization on CPU2
> CPU 2 is now offline
> ================> hang here.
> 
> but x86.git/mm could go through down all the cpus....
> 
> interesting...

i suspect some kobject related race, and i have the feeling this all is 
timing dependent.

Andrew started seeing reboot hangs roughly around the time when the 
kobject changes went upstream. Given that x86.git had flux in that 
timeframe too i couldnt be sure what caused them.

i have the fixlet below in x86.git but it didnt solve Andrew's problem 
so it's parking now at the end of the queue, with no clear purpose in 
life :-) If it would solve someone's problem it might be revitalized.

Note: this does not fix any particular bug i know about, it's just a 
hack.

	Ingo

------------------------------>
Subject: x86: highprio shutdown hack
From: Ingo Molnar <mingo@elte.hu>

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/reboot.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

Index: linux-x86.q/arch/x86/kernel/reboot.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/reboot.c
+++ linux-x86.q/arch/x86/kernel/reboot.c
@@ -396,8 +396,20 @@ static void native_machine_shutdown(void
 	if (!cpu_isset(reboot_cpu_id, cpu_online_map))
 		reboot_cpu_id = smp_processor_id();
 
-	/* Make certain I only run on the appropriate processor */
-	set_cpus_allowed(current, cpumask_of_cpu(reboot_cpu_id));
+	/*
+	 * Make certain we only run on the appropriate processor,
+	 * and with sufficient priority:
+	 */
+	{
+		struct sched_param schedparm;
+		int ret;
+
+		schedparm.sched_priority = 99;
+		ret = sched_setscheduler(current, SCHED_RR, &schedparm);
+		WARN_ON_ONCE(1);
+
+		set_cpus_allowed(current, cpumask_of_cpu(reboot_cpu_id));
+	}
 
 	/* O.K Now that I'm on the appropriate processor,
 	 * stop all of the others.
