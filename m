Return-Path: <linux-kernel-owner+w=401wt.eu-S1758283AbZEVXZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758283AbZEVXZh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 19:25:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758033AbZEVXZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 19:25:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:57715 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757945AbZEVXZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 19:25:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,235,1241420400"; 
   d="scan'208";a="415001998"
Message-Id: <20090522232230.020301000@intel.com>
References: <20090522231940.553094000@intel.com>
User-Agent: quilt/0.46-1
Date: Fri, 22 May 2009 16:19:41 -0700
From: venkatesh.pallipadi@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org, shaohua.li@intel.com,
       svaidy@linux.vnet.ibm.com, a.p.zijlstra@chello.nl,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: [patch 1/2] x86: Add pm_play_dead funcptr to power-efficiently offline CPUs
Content-Disposition: inline; filename=0001-x86-Add-pm_play_dead-funcptr-to-power-efficiently-o.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a funcptr pm_play_dead (similar to pm_idle) that can take
the offline CPUs to the most power efficient idle state.

This patch just adds the func pointer. The pointer will get initialized
by patch that follows.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
---
 arch/x86/include/asm/smp.h |    2 ++
 arch/x86/kernel/smpboot.c  |    7 ++++++-
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 19e0d88..0388b81 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -148,6 +148,8 @@ static inline int num_booting_cpus(void)
 {
 	return cpumask_weight(cpu_callout_mask);
 }
+
+extern void (*pm_play_dead)(void);
 #endif /* CONFIG_SMP */
 
 extern unsigned disabled_cpus __cpuinitdata;
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 58d24ef..4f8af6a 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1195,6 +1195,8 @@ __init void prefill_possible_map(void)
 	nr_cpu_ids = possible;
 }
 
+void (*pm_play_dead)(void) = NULL;
+
 #ifdef CONFIG_HOTPLUG_CPU
 
 static void remove_siblinginfo(int cpu)
@@ -1313,7 +1315,10 @@ void play_dead_common(void)
 void native_play_dead(void)
 {
 	play_dead_common();
-	wbinvd_halt();
+	if (pm_play_dead)
+		pm_play_dead();
+	else
+		wbinvd_halt();
 }
 
 #else /* ... !CONFIG_HOTPLUG_CPU */
-- 
1.6.0.6

-- 

