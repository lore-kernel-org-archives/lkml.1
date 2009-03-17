Return-Path: <linux-kernel-owner+w=401wt.eu-S1762664AbZCQAao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762664AbZCQAao (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 20:30:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761617AbZCQA20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 20:28:26 -0400
Received: from mga03.intel.com ([143.182.124.21]:32172 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759523AbZCQA2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 20:28:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,375,1233561600"; 
   d="scan'208";a="120907285"
Message-Id: <20090317001321.398981000@linux-os.sc.intel.com>
References: <20090317000452.805772000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Mon, 16 Mar 2009 17:05:04 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, dwmw2@infradead.org,
       yinghai@kernel.org, steiner@sgi.com
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [patch 12/13] x86: fix broken irq migration logic while cleaning up multiple vectors
Content-Disposition: inline; filename=fix_spurious_interrupt.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During irq migration, we send a low priority interrupt to the previous
irq destination. This happens in non interrupt-remapping case after interrupt
starts arriving at new destination and in interrupt-remapping case after
modifying and flushing the interrupt-remapping table entry caches.

This low priority irq cleanup handler can cleanup multiple vectors, as
multiple irq's can be migrated at almost the same time. While
there will be multiple invocations of irq cleanup handler (one cleanup
IPI for each irq migration), first invocation of the cleanup handler
can potentially cleanup more than one vector (as the first invocation can
see the requests for more than vector cleanup). When we cleanup multiple
vectors during the first invocation of the smp_irq_move_cleanup_interrupt(),
other vectors that are to be cleanedup can still be pending in the local
cpu's IRR (as smp_irq_move_cleanup_interrupt() runs with interrupts disabled).

When we are ready to unhook a vector corresponding to an irq, check if that
vector is registered in the local cpu's IRR. If so skip that cleanup and
do a self IPI with the cleanup vector, so that we give a chance to
service the pending vector interrupt and then cleanup that vector
allocation once we execute the lowest priority handler.

This fixes spurious interrupts seen when migrating multiple vectors
at the same time.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
---

Index: tip/arch/x86/kernel/apic/io_apic.c
===================================================================
--- tip.orig/arch/x86/kernel/apic/io_apic.c
+++ tip/arch/x86/kernel/apic/io_apic.c
@@ -2414,6 +2414,7 @@ asmlinkage void smp_irq_move_cleanup_int
 	me = smp_processor_id();
 	for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS; vector++) {
 		unsigned int irq;
+		unsigned int irr;
 		struct irq_desc *desc;
 		struct irq_cfg *cfg;
 		irq = __get_cpu_var(vector_irq)[vector];
@@ -2433,6 +2434,18 @@ asmlinkage void smp_irq_move_cleanup_int
 		if (vector == cfg->vector && cpumask_test_cpu(me, cfg->domain))
 			goto unlock;
 
+		irr = apic_read(APIC_IRR + (vector / 32 * 0x10));
+		/*
+		 * Check if the vector that needs to be cleanedup is
+		 * registered at the cpu's IRR. If so, then this is not
+		 * the best time to clean it up. Lets clean it up in the
+		 * next attempt by sending another IRQ_MOVE_CLEANUP_VECTOR
+		 * to myself.
+		 */
+		if (irr  & (1 << (vector % 32))) {
+			apic->send_IPI_self(IRQ_MOVE_CLEANUP_VECTOR);
+			goto unlock;
+		}
 		__get_cpu_var(vector_irq)[vector] = -1;
 		cfg->move_cleanup_count--;
 unlock:

-- 

