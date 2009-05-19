Return-Path: <linux-kernel-owner+w=401wt.eu-S1754888AbZESSD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888AbZESSD2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 14:03:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754236AbZESSDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 14:03:20 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:48252 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754771AbZESSDS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 14:03:18 -0400
From: Subrata Modak <subrata@linux.vnet.ibm.com>
To: <x86@kernel.org>
Cc: Sachin P Sant <sachinp@linux.vnet.ibm.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>,
       Subrata Modak <subrata@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Date: Tue, 19 May 2009 23:33:07 +0530
Message-Id: <20090519180302.603.3124.sendpatchset@subratamodak.linux.ibm.com>
Subject: [PATCH] Remove indirect variable usage at arch/x86/kernel/tsc.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following warning is generated on compilation:

CC      arch/x86/kernel/tsc.o
arch/x86/kernel/tsc.c: In function 'time_cpufreq_notifier':
arch/x86/kernel/tsc.c:634: warning: 'dummy' may be used uninitialized in this function

However, there seems to be no practical usage of variable 'dummy'
in the following piece of code:

630 static int time_cpufreq_notifier(struct notifier_block *nb, unsigned long val,
631                                 void *data)
632 {
633         struct cpufreq_freqs *freq = data;
634         unsigned long *lpj, dummy;
635 
636         if (cpu_has(&cpu_data(freq->cpu), X86_FEATURE_CONSTANT_TSC))
637                 return 0;
638 
639         lpj = &dummy;
640         if (!(freq->flags & CPUFREQ_CONST_LOOPS))
641 #ifdef CONFIG_SMP
642                 lpj = &cpu_data(freq->cpu).loops_per_jiffy;
643 #else
644         lpj = &boot_cpu_data.loops_per_jiffy;
645 #endif
646 

'lpj' probably will get to point to some address after this if() statement.

647         if (!ref_freq) {
648                 ref_freq = freq->old;
649                 loops_per_jiffy_ref = *lpj;

And, if it does, then "loops_per_jiffy_ref" will have a proper value,
else, even with "lpj = &dummy" will not gurantee "loops_per_jiffy_ref = *lpj"
to have the expected value.

650                 tsc_khz_ref = tsc_khz;
651         }
652         if ((val == CPUFREQ_PRECHANGE  && freq->old < freq->new) ||
653                         (val == CPUFREQ_POSTCHANGE && freq->old > freq->new) ||
654                         (val == CPUFREQ_RESUMECHANGE)) {
655                 *lpj =  cpufreq_scale(loops_per_jiffy_ref, ref_freq, freq->new);
656 
657                 tsc_khz = cpufreq_scale(tsc_khz_ref, ref_freq, freq->new);
658                 if (!(freq->flags & CPUFREQ_CONST_LOOPS))
659                         mark_tsc_unstable("cpufreq changes");
660         }
661 
662         set_cyc2ns_scale(tsc_khz, freq->cpu);
663 
664         return 0;
665 }

Is there any specific reason for 'dummy' to exist in this function ?
If not, i would like to propose the following fix.

Signed-off-by: Subrata Modak <subrata@linux.vnet.ibm.com>
To: <x86@kernel.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Sachin P Sant <sachinp@linux.vnet.ibm.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] Remove indirect variable usage at arch/x86/kernel/tsc.c
---

--- a/arch/x86/kernel/tsc.c	2009-05-19 00:57:26.000000000 +0530
+++ b/arch/x86/kernel/tsc.c	2009-05-19 21:45:46.000000000 +0530
@@ -631,12 +631,11 @@ static int time_cpufreq_notifier(struct 
 				void *data)
 {
 	struct cpufreq_freqs *freq = data;
-	unsigned long *lpj, dummy;
+	unsigned long *lpj = NULL;
 
 	if (cpu_has(&cpu_data(freq->cpu), X86_FEATURE_CONSTANT_TSC))
 		return 0;
 
-	lpj = &dummy;
 	if (!(freq->flags & CPUFREQ_CONST_LOOPS))
 #ifdef CONFIG_SMP
 		lpj = &cpu_data(freq->cpu).loops_per_jiffy;

---
Regards--
Subrata

