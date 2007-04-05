Return-Path: <linux-kernel-owner+w=401wt.eu-S1767034AbXDEUui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767034AbXDEUui (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 16:50:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767147AbXDEUui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 16:50:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60041 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767034AbXDEUuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 16:50:37 -0400
Date: Thu, 5 Apr 2007 16:50:34 -0400
From: Dave Jones <davej@redhat.com>
To: "Jeff V. Merkey" <jmerkey@wolfmountaingroup.com>
Cc: Linux kernel <linux-kernel@vger.kernel.org>, venki@gelk.kernelslacker.org
Subject: Re: Preemption Broken:  centrino_target busted under SMP on 2.6.20.4
Message-ID: <20070405205034.GB3605@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Jeff V. Merkey" <jmerkey@wolfmountaingroup.com>,
	Linux kernel <linux-kernel@vger.kernel.org>, venki
References: <46155CFF.70701@wolfmountaingroup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46155CFF.70701@wolfmountaingroup.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 05, 2007 at 02:33:03PM -0600, Jeff V. Merkey wrote:
 > 
 > BUG: using smp_processor_id() in preemptible [00000001] code: 
 > kondemand/0/2473
 > caller is centrino_target+0xfb/0x600
 > [<401e3646>] debug_smp_processor_id+0x9e/0xb0
 > [<40112afb>] centrino_target+0xfb/0x600
 > [<40112a00>] centrino_target+0x0/0x600
 > [<40305bd9>] __cpufreq_driver_target+0x5c/0x6b
 > [<f897a537>] do_dbs_timer+0x1bc/0x208 [cpufreq_ondemand]
 > [<40134a46>] run_workqueue+0x85/0x125
 > [<40374f7f>] _spin_lock_irqsave+0x18/0x66
 > [<f897a37b>] do_dbs_timer+0x0/0x208 [cpufreq_ondemand]
 > [<401353fb>] worker_thread+0xf9/0x124
 > [<401213b9>] default_wake_function+0x0/0xc
 > [<40135302>] worker_thread+0x0/0x124
 > [<40137b37>] kthread+0xb0/0xd9
 > [<40137a87>] kthread+0x0/0xd9
 > [<40104b2f>] kernel_thread_helper+0x7/0x10

Given speedstep-centrino is obsoleted in favour of acpi-cpufreq,
I'm reluctant to spend too much time turd-polishing.
This big-hammer diff should fix this..

	Dave

diff --git a/arch/i386/kernel/cpu/cpufreq/speedstep-centrino.c b/arch/i386/kernel/cpu/cpufreq/speedstep-centrino.c
index f43b987..824d0a2 100644
--- a/arch/i386/kernel/cpu/cpufreq/speedstep-centrino.c
+++ b/arch/i386/kernel/cpu/cpufreq/speedstep-centrino.c
@@ -708,6 +708,7 @@ static int centrino_target (struct cpufreq_policy *policy,
 	saved_mask = current->cpus_allowed;
 	first_cpu = 1;
 	cpus_clear(covered_cpus);
+	preempt_disable();
 	for_each_cpu_mask(j, online_policy_cpus) {
 		/*
 		 * Support for SMP systems.
@@ -798,6 +799,7 @@ static int centrino_target (struct cpufreq_policy *policy,
 	}
 
 migrate_end:
+	preempt_enable();
 	set_cpus_allowed(current, saved_mask);
 	return 0;
 }

-- 
http://www.codemonkey.org.uk
