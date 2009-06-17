Return-Path: <linux-kernel-owner+w=401wt.eu-S1755246AbZFQPbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246AbZFQPbe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 11:31:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753886AbZFQPb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 11:31:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:37462 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753353AbZFQPbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 11:31:25 -0400
Date: Wed, 17 Jun 2009 15:30:46 GMT
From: tip-bot for Subrata Modak <subrata@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       andi@firstfloor.org, elendil@planet.nl, sachinp@linux.vnet.ibm.com,
       subrata@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, elendil@planet.nl, sachinp@linux.vnet.ibm.com,
       subrata@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090520062115.23889.45487.sendpatchset@subratamodak.linux.ibm.com>
References: <20090520062115.23889.45487.sendpatchset@subratamodak.linux.ibm.com>
Subject: [tip:x86/urgent] x86: Remove indirect variable usage at arch/x86/kernel/tsc.c
Message-ID: <tip-5a8aee6c809dc36e42b256566e5e28e244be3c74@git.kernel.org>
Git-Commit-ID: 5a8aee6c809dc36e42b256566e5e28e244be3c74
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 17 Jun 2009 15:30:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5a8aee6c809dc36e42b256566e5e28e244be3c74
Gitweb:     http://git.kernel.org/tip/5a8aee6c809dc36e42b256566e5e28e244be3c74
Author:     Subrata Modak <subrata@linux.vnet.ibm.com>
AuthorDate: Wed, 20 May 2009 11:51:15 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 17 Jun 2009 17:26:30 +0200

x86: Remove indirect variable usage at arch/x86/kernel/tsc.c

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

Also included fix expected by Frans Pop:

> No comments on your patch, but it might be good to also fix the incorrect
> indentation here: line 644 needs an extra tab.

Please refer:

  http://lkml.org/lkml/2009/5/19/312, and,
  http://lkml.org/lkml/2009/5/19/301.

Signed-off-by: Subrata Modak <subrata@linux.vnet.ibm.com>
Cc: Sachin P Sant <sachinp@linux.vnet.ibm.com>
Cc: Frans Pop <elendil@planet.nl>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
LKML-Reference: <20090520062115.23889.45487.sendpatchset@subratamodak.linux.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/tsc.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 3e1c057..7714609 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -631,17 +631,16 @@ static int time_cpufreq_notifier(struct notifier_block *nb, unsigned long val,
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
 #else
-	lpj = &boot_cpu_data.loops_per_jiffy;
+		lpj = &boot_cpu_data.loops_per_jiffy;
 #endif
 
 	if (!ref_freq) {
@@ -652,7 +651,7 @@ static int time_cpufreq_notifier(struct notifier_block *nb, unsigned long val,
 	if ((val == CPUFREQ_PRECHANGE  && freq->old < freq->new) ||
 			(val == CPUFREQ_POSTCHANGE && freq->old > freq->new) ||
 			(val == CPUFREQ_RESUMECHANGE)) {
-		*lpj = 	cpufreq_scale(loops_per_jiffy_ref, ref_freq, freq->new);
+		*lpj = cpufreq_scale(loops_per_jiffy_ref, ref_freq, freq->new);
 
 		tsc_khz = cpufreq_scale(tsc_khz_ref, ref_freq, freq->new);
 		if (!(freq->flags & CPUFREQ_CONST_LOOPS))
