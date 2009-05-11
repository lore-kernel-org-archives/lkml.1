Return-Path: <linux-kernel-owner+w=401wt.eu-S1757834AbZEKPLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757834AbZEKPLW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 11:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754557AbZEKPLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 11:11:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:36231 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752989AbZEKPLG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 11:11:06 -0400
Date: Mon, 11 May 2009 15:09:51 GMT
From: tip-bot for Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, venkatesh.pallipadi@intel.com,
       mahesh@linux.vnet.ibm.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de, mingo@elte.hu, svaidy@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, venkatesh.pallipadi@intel.com,
       mahesh@linux.vnet.ibm.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de, mingo@elte.hu, svaidy@linux.vnet.ibm.com
In-Reply-To: <20090511143914.GB4853@dirshya.in.ibm.com>
References: <20090511143914.GB4853@dirshya.in.ibm.com>
Subject: [tip:sched/core] sched: Don't export sched_mc_power_savings on multi-socket single core system
Message-ID: <tip-33faf60cb97fee37b0e60a68c171f9099c576dec@git.kernel.org>
Git-Commit-ID: 33faf60cb97fee37b0e60a68c171f9099c576dec
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 11 May 2009 15:09:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  33faf60cb97fee37b0e60a68c171f9099c576dec
Gitweb:     http://git.kernel.org/tip/33faf60cb97fee37b0e60a68c171f9099c576dec
Author:     Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
AuthorDate: Mon, 11 May 2009 20:09:14 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 11 May 2009 17:05:57 +0200

sched: Don't export sched_mc_power_savings on multi-socket single core system

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

[ Impact: make the sched_mc_power_saving control available more consistently ]

Signed-off-by: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
Cc: Suresh B Siddha <suresh.b.siddha@intel.com>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20090511143914.GB4853@dirshya.in.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/topology.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index f44b49a..066ef59 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -203,7 +203,8 @@ struct pci_bus;
 void x86_pci_root_bus_res_quirks(struct pci_bus *b);
 
 #ifdef CONFIG_SMP
-#define mc_capable()	(cpumask_weight(cpu_core_mask(0)) != nr_cpu_ids)
+#define mc_capable()	((boot_cpu_data.x86_max_cores > 1) && \
+			(cpumask_weight(cpu_core_mask(0)) != nr_cpu_ids))
 #define smt_capable()			(smp_num_siblings > 1)
 #endif
 
