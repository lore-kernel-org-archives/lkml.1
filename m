Return-Path: <linux-kernel-owner+w=401wt.eu-S1423493AbXD3PxG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423493AbXD3PxG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 11:53:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423481AbXD3PuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 11:50:11 -0400
Received: from mail.suse.de ([195.135.220.2]:45064 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423479AbXD3PuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 11:50:05 -0400
From: Andi Kleen <ak@suse.de>
References: <20070430549.617098000@suse.de>
In-Reply-To: <20070430549.617098000@suse.de>
To: dwalker@mvista.com, ak@suse.de, mingo@elte.hu, tglx@linutronix.de,
       johnstul@us.ibm.com, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [26/34] i386: remove xtime_lock'ing around cpufreq notifier
Message-Id: <20070430154959.64686151FC@wotan.suse.de>
Date: Mon, 30 Apr 2007 17:49:59 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Daniel Walker <dwalker@mvista.com>

The locking of the xtime_lock around the cpu notifier is unessesary now. 
At one time the tsc was used after a frequency change for timekeeping, but
the re-write of timekeeping no longer uses the TSC unless the frequency is
constant.

The variables that are changed in this section of code had also once been
used for timekeeping, but not any longer ..

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/tsc.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

Index: linux/arch/i386/kernel/tsc.c
===================================================================
--- linux.orig/arch/i386/kernel/tsc.c
+++ linux/arch/i386/kernel/tsc.c
@@ -144,13 +144,10 @@ time_cpufreq_notifier(struct notifier_bl
 {
 	struct cpufreq_freqs *freq = data;
 
-	if (val != CPUFREQ_RESUMECHANGE && val != CPUFREQ_SUSPENDCHANGE)
-		write_seqlock_irq(&xtime_lock);
-
 	if (!ref_freq) {
 		if (!freq->old){
 			ref_freq = freq->new;
-			goto end;
+			return 0;
 		}
 		ref_freq = freq->old;
 		loops_per_jiffy_ref = cpu_data[freq->cpu].loops_per_jiffy;
@@ -176,9 +173,6 @@ time_cpufreq_notifier(struct notifier_bl
 			}
 		}
 	}
-end:
-	if (val != CPUFREQ_RESUMECHANGE && val != CPUFREQ_SUSPENDCHANGE)
-		write_sequnlock_irq(&xtime_lock);
 
 	return 0;
 }
