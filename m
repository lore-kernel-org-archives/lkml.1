Return-Path: <linux-kernel-owner+w=401wt.eu-S1764714AbZDHLc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764714AbZDHLc6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 07:32:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764439AbZDHLZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 07:25:59 -0400
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:51717 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764438AbZDHLZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 07:25:57 -0400
Message-ID: <49DC89A3.3090605@linux.vnet.ibm.com>
Date: Wed, 08 Apr 2009 16:55:23 +0530
From: Mahesh Jagannath Salgaonkar <mahesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Ingo Molnar <mingo@elte.hu>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
CC: svaidy@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, dipankar@in.ibm.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH] Don't export sched_mc_power_savings on multi-socket single
 core system
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix to prevent sched_mc_power_saving from being exported through sysfs
for multi-scoket single core system. Max cores should be always greater than
one (1). My earlier patch that introduced fix for not exporting
'sched_mc_power_saving' on laptops  broke it on multi-socket single core
system. This fix addresses issue on both laptop and multi-socket single 
core system.
Below are the Test results:

1. Single socket - multi-core
       Before Patch: Does not export 'sched_mc_power_saving'
       After Patch: Does not export 'sched_mc_power_saving'
       Result: Pass

2. Multi Socket - single core
      Before Patch: exports 'sched_mc_power_saving'
      After Patch: Does not export 'sched_mc_power_saving'
      Result: Pass

3. Multi Socket - Multi core
      Before Patch: exports 'sched_mc_power_saving'
      After Patch: exports 'sched_mc_power_saving'


Signed-off-by: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>

Index: linux-2.6/arch/x86/include/asm/topology.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/topology.h
+++ linux-2.6/arch/x86/include/asm/topology.h
@@ -203,7 +203,8 @@ struct pci_bus;
 void set_pci_bus_resources_arch_default(struct pci_bus *b);

 #ifdef CONFIG_SMP
-#define mc_capable()   (cpumask_weight(cpu_core_mask(0)) != nr_cpu_ids)
+#define mc_capable()   (boot_cpu_data.x86_max_cores > 1) && \
+                       (cpumask_weight(cpu_core_mask(0)) != nr_cpu_ids)
 #define smt_capable()                  (smp_num_siblings > 1)
 #endif
