Return-Path: <linux-kernel-owner+w=401wt.eu-S1755678AbYLWBdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678AbYLWBdi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 20:33:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753667AbYLWBd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 20:33:29 -0500
Received: from mga02.intel.com ([134.134.136.20]:59153 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753532AbYLWBd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 20:33:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,266,1228118400"; 
   d="scan'208";a="373023719"
Date: Mon, 22 Dec 2008 17:33:28 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de
Cc: travis@sgi.com, rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Subject: [patch] x86: use logical apicid in x2apic_cluster's x2apic_cpu_mask_to_apicid_and()
Message-ID: <20081223013327.GA29686@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: x86: use logical apicid in x2apic_cluster's x2apic_cpu_mask_to_apicid_and()

These commits:

	commit 95d313cf1c1ecedc8bec5727b09bdacbf67dfc45
	Author: Mike Travis <travis@sgi.com>
	Date:   Tue Dec 16 17:33:54 2008 -0800

	    x86: Add cpu_mask_to_apicid_and

and
	commit 6eeb7c5a99434596c5953a95baa17d2f085664e3
	Author: Mike Travis <travis@sgi.com>
	Date:   Tue Dec 16 17:33:55 2008 -0800

	    x86: update add-cpu_mask_to_apicid_and to use struct cpumask*

broke interrupt delivery on x2apic platforms.  As x2apic cluster mode uses
logical delivery mode, we need to use logical apicid instead of physical apicid
in x2apic_cpu_mask_to_apicid_and()

Impact: fixes the broken interrupt delivery issue on generic x2apic platforms.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tip/arch/x86/kernel/genx2apic_cluster.c
===================================================================
--- tip.orig/arch/x86/kernel/genx2apic_cluster.c	2008-12-22 17:15:38.000000000 -0800
+++ tip/arch/x86/kernel/genx2apic_cluster.c	2008-12-22 17:16:17.000000000 -0800
@@ -114,7 +114,7 @@
 	int cpu;
 
 	/*
-	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
+	 * We're using fixed IRQ delivery, can only return one logical APIC ID.
 	 * May as well be the first.
 	 */
 	cpu = cpumask_first(cpumask);
@@ -130,14 +130,14 @@
 	int cpu;
 
 	/*
-	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
+	 * We're using fixed IRQ delivery, can only return one logical APIC ID.
 	 * May as well be the first.
 	 */
 	for_each_cpu_and(cpu, cpumask, andmask)
 		if (cpumask_test_cpu(cpu, cpu_online_mask))
 			break;
 	if (cpu < nr_cpu_ids)
-		return per_cpu(x86_cpu_to_apicid, cpu);
+		return per_cpu(x86_cpu_to_logical_apicid, cpu);
 	return BAD_APICID;
 }
 
