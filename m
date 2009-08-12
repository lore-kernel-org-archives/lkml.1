Return-Path: <linux-kernel-owner+w=401wt.eu-S1755816AbZHLDQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816AbZHLDQO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 23:16:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755804AbZHLDQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 23:16:13 -0400
Received: from mga03.intel.com ([143.182.124.21]:63607 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755403AbZHLDQN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 23:16:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,364,1246863600"; 
   d="scan'208";a="174823074"
Date: Wed, 12 Aug 2009 11:16:12 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, venkatesh.pallipadi@intel.com
Subject: [PATCH] disable per-cpu hpet timer if ARAT is supported
Message-ID: <20090812031612.GA10062@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CPU support always running local APIC timer, per-cpu hpet timer could be
disabled, which is useless and wasteful in such case. Let's leave the timers
to others.
Impact: should have no impact except reserving less timers.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index dedc2bd..5969e10 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -584,6 +584,8 @@ static void hpet_msi_capability_lookup(unsigned int start_timer)
 	unsigned int num_timers_used = 0;
 	int i;
 
+	if (boot_cpu_has(X86_FEATURE_ARAT))
+		return;
 	id = hpet_readl(HPET_ID);
 
 	num_timers = ((id & HPET_ID_NUMBER) >> HPET_ID_NUMBER_SHIFT);
@@ -872,10 +874,8 @@ int __init hpet_enable(void)
 
 	if (id & HPET_ID_LEGSUP) {
 		hpet_legacy_clockevent_register();
-		hpet_msi_capability_lookup(2);
 		return 1;
 	}
-	hpet_msi_capability_lookup(0);
 	return 0;
 
 out_nohpet:
@@ -908,9 +908,17 @@ static __init int hpet_late_init(void)
 	if (!hpet_virt_address)
 		return -ENODEV;
 
+	if (hpet_readl(HPET_ID) & HPET_ID_LEGSUP)
+		hpet_msi_capability_lookup(2);
+	else
+		hpet_msi_capability_lookup(0);
+
 	hpet_reserve_platform_timers(hpet_readl(HPET_ID));
 	hpet_print_config();
 
+	if (boot_cpu_has(X86_FEATURE_ARAT))
+		return 0;
+
 	for_each_online_cpu(cpu) {
 		hpet_cpuhp_notify(NULL, CPU_ONLINE, (void *)(long)cpu);
 	}
