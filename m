Return-Path: <linux-kernel-owner+w=401wt.eu-S1754133Ab0ARU0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133Ab0ARU0T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 15:26:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753996Ab0ARU0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 15:26:18 -0500
Received: from mga02.intel.com ([134.134.136.20]:60874 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753749Ab0ARU0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 15:26:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,298,1262592000"; 
   d="scan'208";a="588184886"
Message-Id: <20100118201256.672679042@sbs-t61.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Mon, 18 Jan 2010 12:10:49 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: torvalds@linux-foundation.org, hpa@zytor.com, mingo@elte.hu,
       tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
       Yinghai Lu <yinghai@kernel.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Chris McDermott <lcm@linux.vnet.ibm.com>
Subject: [patch 2/2] x86, apic: use logical flat for systems with <= 8 logical cpus
References: <20100118201256.604267529@sbs-t61.sc.intel.com>
Content-Disposition: inline; filename=use_flat_mode_for_upto_8_logical_cpus.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can use logical flat mode if there are <= 8 logical cpu's (irrespective
of physical apic id values). This will enable simplified and efficient IPI
and device interrupt routing on such platforms.

This has been tested to work on both Intel and AMD platforms. Exceptions
like IBM summit platform which can't use logical flat mode are addressed
by using OEM platform checks.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Chris McDermott <lcm@linux.vnet.ibm.com>
---
 arch/x86/kernel/apic/apic.c     |   15 +--------------
 arch/x86/kernel/apic/probe_64.c |    8 +++-----
 2 files changed, 4 insertions(+), 19 deletions(-)

Index: tip/arch/x86/kernel/apic/apic.c
===================================================================
--- tip.orig/arch/x86/kernel/apic/apic.c
+++ tip/arch/x86/kernel/apic/apic.c
@@ -61,12 +61,6 @@ unsigned int boot_cpu_physical_apicid = 
 
 /*
  * The highest APIC ID seen during enumeration.
- *
- * This determines the messaging protocol we can use: if all APIC IDs
- * are in the 0 ... 7 range, then we can use logical addressing which
- * has some performance advantages (better broadcasting).
- *
- * If there's an APIC ID above 8, we use physical addressing.
  */
 unsigned int max_physical_apicid;
 
@@ -1898,14 +1892,7 @@ void __cpuinit generic_processor_info(in
 		max_physical_apicid = apicid;
 
 #ifdef CONFIG_X86_32
-	/*
-	 * Would be preferable to switch to bigsmp when CONFIG_HOTPLUG_CPU=y
-	 * but we need to work other dependencies like SMP_SUSPEND etc
-	 * before this can be done without some confusion.
-	 * if (CPU_HOTPLUG_ENABLED || num_processors > 8)
-	 *       - Ashok Raj <ashok.raj@intel.com>
-	 */
-	if (max_physical_apicid >= 8) {
+	if (num_processors > 8) {
 		switch (boot_cpu_data.x86_vendor) {
 		case X86_VENDOR_INTEL:
 			if (!APIC_XAPIC(version)) {
Index: tip/arch/x86/kernel/apic/probe_64.c
===================================================================
--- tip.orig/arch/x86/kernel/apic/probe_64.c
+++ tip/arch/x86/kernel/apic/probe_64.c
@@ -64,15 +64,13 @@ void __init default_setup_apic_routing(v
 			apic = &apic_x2apic_phys;
 		else
 			apic = &apic_x2apic_cluster;
-		printk(KERN_INFO "Setting APIC routing to %s\n", apic->name);
 	}
 #endif
 
-	if (apic == &apic_flat) {
-		if (max_physical_apicid >= 8)
+	if (apic == &apic_flat && num_processors > 8)
 			apic = &apic_physflat;
-		printk(KERN_INFO "Setting APIC routing to %s\n", apic->name);
-	}
+
+	printk(KERN_INFO "Setting APIC routing to %s\n", apic->name);
 
 	if (is_vsmp_box()) {
 		/* need to update phys_pkg_id */


