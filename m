Return-Path: <linux-kernel-owner+w=401wt.eu-S933094AbXDFVm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933094AbXDFVm5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 17:42:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933102AbXDFVm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 17:42:57 -0400
Received: from mga03.intel.com ([143.182.124.21]:10326 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933094AbXDFVm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 17:42:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,383,1170662400"; 
   d="scan'208"; a="209449428:sNHT17768156"
Date: Fri, 6 Apr 2007 14:41:50 -0700
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: akpm@osdl.org
Subject: Avoid checking for cpu gone when CONFIG_HOTPLUG_CPU not defined
Message-ID: <20070406214150.GA3545@linux-os.sc.intel.com>
Reply-To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Subject: Avoid checking for cpu gone when CONFIG_HOTPLUG_CPU not defined

Avoid checking for cpu gone in mm hot path when
CONFIG_HOTPLUG_CPU is not defined.

Signed-off-by: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>

---
 arch/i386/kernel/smp.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: work/arch/i386/kernel/smp.c
===================================================================
--- work.orig/arch/i386/kernel/smp.c
+++ work/arch/i386/kernel/smp.c
@@ -365,10 +365,12 @@ static void flush_tlb_others(cpumask_t c
 	BUG_ON(cpu_isset(smp_processor_id(), cpumask));
 	BUG_ON(!mm);
 
+#ifdef CONFIG_HOTPLUG_CPU
 	/* If a CPU which we ran on has gone down, OK. */
 	cpus_and(cpumask, cpumask, cpu_online_map);
-	if (cpus_empty(cpumask))
+	if (unlikely(cpus_empty(cpumask)))
 		return;
+#endif
 
 	/*
 	 * i'm not happy about this global shared spinlock in the
