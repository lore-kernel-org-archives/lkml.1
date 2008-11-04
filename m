Return-Path: <linux-kernel-owner+w=401wt.eu-S1757201AbYKDWI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201AbYKDWI7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 17:08:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754640AbYKDWIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 17:08:19 -0500
Received: from mga09.intel.com ([134.134.136.24]:63808 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754339AbYKDWIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 17:08:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,545,1220252400"; 
   d="scan'208";a="459279627"
Message-Id: <20081104215626.751033000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 04 Nov 2008 13:53:03 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: jens.axboe@oracle.com, mingo@elte.hu, jeremy.fitzhardinge@citrix.com,
       nickpiggin@yahoo.com.au, torvalds@linux-foundation.org,
       paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, venkatesh.pallipadi@intel.com,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 1/3] generic-ipi: add smp_mb() before sending the IPI
Content-Disposition: inline; filename=generic_ipi_strengthen_barrier.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

smp_mb() (to make the memory operations visible globally) is needed before
sending the ipi, if the receiver refers to the data(setup by the sender) in
a lock-free fashion.

On x86, x2apic mode accesses for sending IPI's don't have serializing
semantics. So the need for smp_mb() before sending the IPI becomes more
critical in x2apic mode.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: linux-2.6.git/kernel/smp.c
===================================================================
--- linux-2.6.git.orig/kernel/smp.c	2008-10-31 11:15:11.000000000 -0700
+++ linux-2.6.git/kernel/smp.c	2008-11-04 09:54:29.000000000 -0800
@@ -76,6 +76,11 @@
 	list_add_tail(&data->list, &dst->list);
 	spin_unlock_irqrestore(&dst->lock, flags);
 
+	/*
+	 * Make the list addition visible before sending the ipi.
+	 */
+	smp_mb();
+
 	if (ipi)
 		arch_send_call_function_single_ipi(cpu);
 
@@ -370,6 +375,11 @@
 	list_add_tail_rcu(&data->csd.list, &call_function_queue);
 	spin_unlock_irqrestore(&call_function_lock, flags);
 
+	/*
+	 * Make the list addition visible before sending the ipi.
+	 */
+	smp_mb();
+
 	/* Send a message to all CPUs in the map */
 	arch_send_call_function_ipi(mask);
 

-- 

