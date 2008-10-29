Return-Path: <linux-kernel-owner+w=401wt.eu-S1755942AbYJ2WnI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942AbYJ2WnI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 18:43:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755211AbYJ2Wmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 18:42:32 -0400
Received: from mga03.intel.com ([143.182.124.21]:49814 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755683AbYJ2Wmb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 18:42:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,509,1220252400"; 
   d="scan'208";a="67313286"
Date: Wed, 29 Oct 2008 15:42:29 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: jens.axboe@oracle.com, paulmck@linux.vnet.ibm.com, mingo@elte.hu,
       jeremy.fitzhardinge@citrix.com, nickpiggin@yahoo.com.au,
       torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, asit.k.mallick@intel.com
Subject: [patch] generic-ipi: fix the smp_mb() placement
Message-ID: <20081029224229.GK30573@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While looking at some other issue recently, we encountered this smp_mb()
placement issue.  x86 specific code also needs some similar fixes. Patch for
that will follow soon.

Please review the appended generic-ipi fix.

thanks,
suresh
---

From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: generic-ipi: fix the smp_mb() placement

smp_mb() is needed (to make the memory operations visible globally) before
sending the ipi on the sender and the receiver (on Alpha atleast) needs
smp_read_barrier_depends() in the handler before reading the call_single_queue
list in a lock-free fashion.

On x86, x2apic mode register accesses for sending IPI's don't have serializing
semantics. So the need for smp_mb() before sending the IPI becomes more
critical in x2apic mode.

Remove the unnecessary smp_mb() in csd_flag_wait(), as the presence of that
smp_mb() doesn't mean anything on the sender, when the ipi receiver is not
doing any thing special (like memory fence) after clearing the CSD_FLAG_WAIT.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

diff --git a/kernel/smp.c b/kernel/smp.c
index f362a85..75c8dde 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -51,10 +51,6 @@ static void csd_flag_wait(struct call_single_data *data)
 {
 	/* Wait for response */
 	do {
-		/*
-		 * We need to see the flags store in the IPI handler
-		 */
-		smp_mb();
 		if (!(data->flags & CSD_FLAG_WAIT))
 			break;
 		cpu_relax();
@@ -76,6 +72,11 @@ static void generic_exec_single(int cpu, struct call_single_data *data)
 	list_add_tail(&data->list, &dst->list);
 	spin_unlock_irqrestore(&dst->lock, flags);
 
+	/*
+	 * Make the list addition visible before sending the ipi.
+	 */
+	smp_mb();
+
 	if (ipi)
 		arch_send_call_function_single_ipi(cpu);
 
@@ -157,7 +158,7 @@ void generic_smp_call_function_single_interrupt(void)
 	 * Need to see other stores to list head for checking whether
 	 * list is empty without holding q->lock
 	 */
-	smp_mb();
+	smp_read_barrier_depends();
 	while (!list_empty(&q->list)) {
 		unsigned int data_flags;
 
@@ -191,7 +192,7 @@ void generic_smp_call_function_single_interrupt(void)
 		/*
 		 * See comment on outer loop
 		 */
-		smp_mb();
+		smp_read_barrier_depends();
 	}
 }
 
@@ -370,6 +371,11 @@ int smp_call_function_mask(cpumask_t mask, void (*func)(void *), void *info,
 	list_add_tail_rcu(&data->csd.list, &call_function_queue);
 	spin_unlock_irqrestore(&call_function_lock, flags);
 
+	/*
+	 * Make the list addition visible before sending the ipi.
+	 */
+	smp_mb();
+
 	/* Send a message to all CPUs in the map */
 	arch_send_call_function_ipi(mask);
 
