Return-Path: <linux-kernel-owner+w=401wt.eu-S1423455AbXD3QBJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423455AbXD3QBJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 12:01:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423461AbXD3P4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 11:56:00 -0400
Received: from mail.suse.de ([195.135.220.2]:45013 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423459AbXD3Pty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 11:49:54 -0400
From: Andi Kleen <ak@suse.de>
References: <20070430549.617098000@suse.de>
In-Reply-To: <20070430549.617098000@suse.de>
To: anil.s.keshavamurthy@intel.com, ak@suse.de, ego@in.ibm.com,
       patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [20/34] i386: avoid checking for cpu gone when CONFIG_HOTPLUG_CPU not defined
Message-Id: <20070430154952.F39E9151CA@wotan.suse.de>
Date: Mon, 30 Apr 2007 17:49:52 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>

Avoid checking for cpu gone in mm hot path when CONFIG_HOTPLUG_CPU is not
defined.

Signed-off-by: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/smp.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux/arch/i386/kernel/smp.c
===================================================================
--- linux.orig/arch/i386/kernel/smp.c
+++ linux/arch/i386/kernel/smp.c
@@ -359,10 +359,12 @@ void native_flush_tlb_others(const cpuma
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
