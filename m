Return-Path: <linux-kernel-owner+w=401wt.eu-S1765620AbXGSKB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765620AbXGSKB7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 06:01:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758283AbXGSJzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:55:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:33048 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756513AbXGSJzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:55:00 -0400
From: Andi Kleen <ak@suse.de>
References: <200707191154.642492000@suse.de>
In-Reply-To: <200707191154.642492000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [13/58] x86: Separate checking of unsynchronized and unstable TSC
Message-Id: <20070719095457.CBD1114E06@wotan.suse.de>
Date: Thu, 19 Jul 2007 11:54:57 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Preparationary patch for the new sched/printk_clock()

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/kernel/tsc.c   |    9 ++++-----
 arch/x86_64/kernel/tsc.c |    5 +----
 2 files changed, 5 insertions(+), 9 deletions(-)

Index: linux/arch/i386/kernel/tsc.c
===================================================================
--- linux.orig/arch/i386/kernel/tsc.c
+++ linux/arch/i386/kernel/tsc.c
@@ -331,7 +331,7 @@ static struct dmi_system_id __initdata b
  */
 __cpuinit int unsynchronized_tsc(void)
 {
-	if (!cpu_has_tsc || tsc_unstable)
+	if (!cpu_has_tsc)
 		return 1;
 	/*
 	 * Intel systems are normally all synchronized.
@@ -340,9 +340,9 @@ __cpuinit int unsynchronized_tsc(void)
 	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL) {
 		/* assume multi socket systems are not synchronized: */
 		if (num_possible_cpus() > 1)
-			tsc_unstable = 1;
+			return 1;
 	}
-	return tsc_unstable;
+	return 0;
 }
 
 /*
@@ -386,13 +386,12 @@ void __init tsc_init(void)
 	/* Check and install the TSC clocksource */
 	dmi_check_system(bad_tsc_dmi_table);
 
-	unsynchronized_tsc();
 	check_geode_tsc_reliable();
 	current_tsc_khz = tsc_khz;
 	clocksource_tsc.mult = clocksource_khz2mult(current_tsc_khz,
 							clocksource_tsc.shift);
 	/* lower the rating if we already know its unstable: */
-	if (check_tsc_unstable()) {
+	if (check_tsc_unstable() || unsynchronized_tsc()) {
 		clocksource_tsc.rating = 0;
 		clocksource_tsc.flags &= ~CLOCK_SOURCE_IS_CONTINUOUS;
 	} else
Index: linux/arch/x86_64/kernel/tsc.c
===================================================================
--- linux.orig/arch/x86_64/kernel/tsc.c
+++ linux/arch/x86_64/kernel/tsc.c
@@ -144,9 +144,6 @@ static int tsc_unstable = 0;
  */
 __cpuinit int unsynchronized_tsc(void)
 {
-	if (tsc_unstable)
-		return 1;
-
 #ifdef CONFIG_SMP
 	if (apic_is_clustered_box())
 		return 1;
@@ -218,7 +215,7 @@ void __init init_tsc_clocksource(void)
 	if (!notsc) {
 		clocksource_tsc.mult = clocksource_khz2mult(tsc_khz,
 							clocksource_tsc.shift);
-		if (check_tsc_unstable())
+		if (unsynchronized_tsc() || check_tsc_unstable())
 			clocksource_tsc.rating = 0;
 
 		clocksource_register(&clocksource_tsc);
