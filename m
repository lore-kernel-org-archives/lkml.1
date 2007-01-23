Return-Path: <linux-kernel-owner+w=401wt.eu-S933169AbXAWWN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933169AbXAWWN4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 17:13:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933144AbXAWWMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 17:12:12 -0500
Received: from www.osadl.org ([213.239.205.134]:35819 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933142AbXAWWAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 17:00:50 -0500
Message-Id: <20070123211204.055149000@localhost.localdomain>
References: <20070123211159.178138000@localhost.localdomain>
Date: Tue, 23 Jan 2007 22:01:04 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       John Stultz <johnstul@us.ibm.com>,
       Arjan van de Veen <arjan@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: [patch 09/46] i386 Remove useless code in tsc.c
Content-Disposition: inline; filename=i386-tsc-remove-useless-code.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

The delayed work code in arch/i386/kernel/tsc.c is an unused leftover of the
GTOD conversion. Remove it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>

---
 arch/i386/kernel/tsc.c |   40 ++--------------------------------------
 1 file changed, 2 insertions(+), 38 deletions(-)

Index: linux-2.6.20-rc4-mm1-bo/arch/i386/kernel/tsc.c
===================================================================
--- linux-2.6.20-rc4-mm1-bo.orig/arch/i386/kernel/tsc.c
+++ linux-2.6.20-rc4-mm1-bo/arch/i386/kernel/tsc.c
@@ -222,34 +222,6 @@ out_no_tsc:
 
 #ifdef CONFIG_CPU_FREQ
 
-static unsigned int cpufreq_delayed_issched = 0;
-static unsigned int cpufreq_init = 0;
-static struct work_struct cpufreq_delayed_get_work;
-
-static void handle_cpufreq_delayed_get(struct work_struct *work)
-{
-	unsigned int cpu;
-
-	for_each_online_cpu(cpu)
-		cpufreq_get(cpu);
-
-	cpufreq_delayed_issched = 0;
-}
-
-/*
- * if we notice cpufreq oddness, schedule a call to cpufreq_get() as it tries
- * to verify the CPU frequency the timing core thinks the CPU is running
- * at is still correct.
- */
-static inline void cpufreq_delayed_get(void)
-{
-	if (cpufreq_init && !cpufreq_delayed_issched) {
-		cpufreq_delayed_issched = 1;
-		printk(KERN_DEBUG "Checking if CPU frequency changed.\n");
-		schedule_work(&cpufreq_delayed_get_work);
-	}
-}
-
 /*
  * if the CPU frequency is scaled, TSC-based delays will need a different
  * loops_per_jiffy value to function properly.
@@ -313,17 +285,9 @@ static struct notifier_block time_cpufre
 
 static int __init cpufreq_tsc(void)
 {
-	int ret;
-
-	INIT_WORK(&cpufreq_delayed_get_work, handle_cpufreq_delayed_get);
-	ret = cpufreq_register_notifier(&time_cpufreq_notifier_block,
-					CPUFREQ_TRANSITION_NOTIFIER);
-	if (!ret)
-		cpufreq_init = 1;
-
-	return ret;
+	return cpufreq_register_notifier(&time_cpufreq_notifier_block,
+					 CPUFREQ_TRANSITION_NOTIFIER);
 }
-
 core_initcall(cpufreq_tsc);
 
 #endif

--

