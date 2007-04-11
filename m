Return-Path: <linux-kernel-owner+w=401wt.eu-S1753278AbXDKQiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278AbXDKQiO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 12:38:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753285AbXDKQiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 12:38:14 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:57823 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753278AbXDKQiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 12:38:13 -0400
Message-Id: <20070411162904.232696302@mvista.com>
User-Agent: quilt/0.46-1
Date: Wed, 11 Apr 2007 09:29:04 -0700
From: Daniel Walker <dwalker@mvista.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, johnstul@us.ibm.com, tglx@linutronix.de
Subject: [PATCH] i386 tsc: remove xtime_lock'ing around cpufreq notifier
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The locking of the xtime_lock around the cpu notifier is unessesary now. At one
time the tsc was used after a frequency change for timekeeping, but the re-write
of timekeeping no longer uses the TSC unless the frequency is constant. 

The variables that are changed in this section of code had also once been used
for timekeeping, but not any longer ..

Signed-Off-By: Daniel Walker <dwalker@mvista.com>

---
 arch/i386/kernel/tsc.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

Index: linux-2.6.20/arch/i386/kernel/tsc.c
===================================================================
--- linux-2.6.20.orig/arch/i386/kernel/tsc.c
+++ linux-2.6.20/arch/i386/kernel/tsc.c
@@ -200,13 +200,10 @@ time_cpufreq_notifier(struct notifier_bl
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
@@ -237,9 +234,6 @@ time_cpufreq_notifier(struct notifier_bl
 			}
 		}
 	}
-end:
-	if (val != CPUFREQ_RESUMECHANGE && val != CPUFREQ_SUSPENDCHANGE)
-		write_sequnlock_irq(&xtime_lock);
 
 	return 0;
 }
-- 

-- 
