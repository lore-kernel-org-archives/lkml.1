Return-Path: <linux-kernel-owner+w=401wt.eu-S1756887AbYKDWIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887AbYKDWIn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 17:08:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754434AbYKDWIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 17:08:18 -0500
Received: from mga03.intel.com ([143.182.124.21]:34582 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753799AbYKDWIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 17:08:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,545,1220252400"; 
   d="scan'208";a="70951046"
Message-Id: <20081104215626.897026000@linux-os.sc.intel.com>
References: <20081104215626.751033000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 04 Nov 2008 13:53:04 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: jens.axboe@oracle.com, mingo@elte.hu, jeremy.fitzhardinge@citrix.com,
       nickpiggin@yahoo.com.au, torvalds@linux-foundation.org,
       paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, venkatesh.pallipadi@intel.com,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 2/3] x86: Add smp_mb() before sending INVALIDATE_TLB_VECTOR
Content-Disposition: inline; filename=x86_fix_mb_tlb_flush.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On x86, x2apic mode accesses for sending IPI's don't have serializing
semantics. If the IPI receiver refers(in lock-free fashion) to some memory setup
by the sender, the need for smp_mb() before sending the IPI becomes critical in
x2apic mode.

Add the smp_mb() in native_flush_tlb_others() before sending the IPI.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: linux-2.6.git/arch/x86/kernel/tlb_32.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/tlb_32.c	2008-10-13 10:04:12.000000000 -0700
+++ linux-2.6.git/arch/x86/kernel/tlb_32.c	2008-11-04 10:01:16.000000000 -0800
@@ -154,6 +154,12 @@
 	flush_mm = mm;
 	flush_va = va;
 	cpus_or(flush_cpumask, cpumask, flush_cpumask);
+
+	/*
+	 * Make the above memory operations globally visible before
+	 * sending the IPI.
+	 */
+	smp_mb();
 	/*
 	 * We have to send the IPI only to
 	 * CPUs affected.
Index: linux-2.6.git/arch/x86/kernel/tlb_64.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/tlb_64.c	2008-10-31 11:15:11.000000000 -0700
+++ linux-2.6.git/arch/x86/kernel/tlb_64.c	2008-11-04 10:01:31.000000000 -0800
@@ -183,6 +183,11 @@
 	cpus_or(f->flush_cpumask, cpumask, f->flush_cpumask);
 
 	/*
+	 * Make the above memory operations globally visible before
+	 * sending the IPI.
+	 */
+	smp_mb();
+	/*
 	 * We have to send the IPI only to
 	 * CPUs affected.
 	 */

-- 

