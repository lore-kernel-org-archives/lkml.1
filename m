Return-Path: <linux-kernel-owner+w=401wt.eu-S1756169AbZEKOj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169AbZEKOj4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 10:39:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753830AbZEKOjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 10:39:31 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:57842 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbZEKOja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 10:39:30 -0400
Date: Mon, 11 May 2009 20:09:14 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mahesh Jagannath Salgaonkar <mahesh@linux.vnet.ibm.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH][REPOST] Don't export sched_mc_power_savings
	onmulti-socket single core system
Message-ID: <20090511143914.GB4853@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <4A081A4B.1000204@linux.vnet.ibm.com> <20090511123529.GH13954@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090511123529.GH13954@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar <mingo@elte.hu> [2009-05-11 14:35:29]:

> 
> * Mahesh Jagannath Salgaonkar <mahesh@linux.vnet.ibm.com> wrote:
> 
> > My previous post got lost somewhere in lkml list. Hence reposting 
> > this patch again.
> 
> no, it did not get lost, i gave you the feedback below more than a 
> month ago. FYI, this resubmission has the same corrupted-patch 
> problem.

Hi Ingo,

My copy of the [REPOST] seem to have tabs correct.  Anyways I have
added an extra parentheses also in the #define. Please check and
apply.

Thanks,
Vaidy

Don't export sched_mc_power_savings on multi-socket single core system

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
 
