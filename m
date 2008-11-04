Return-Path: <linux-kernel-owner+w=401wt.eu-S1756369AbYKDWI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369AbYKDWI2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 17:08:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754274AbYKDWIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 17:08:17 -0500
Received: from mga01.intel.com ([192.55.52.88]:54714 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753740AbYKDWIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 17:08:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,545,1220252400"; 
   d="scan'208";a="399922290"
Message-Id: <20081104215627.046867000@linux-os.sc.intel.com>
References: <20081104215626.751033000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 04 Nov 2008 13:53:05 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: jens.axboe@oracle.com, mingo@elte.hu, jeremy.fitzhardinge@citrix.com,
       nickpiggin@yahoo.com.au, torvalds@linux-foundation.org,
       paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, venkatesh.pallipadi@intel.com,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 3/3] generic-ipi: fix the smp_mb() usage
Content-Disposition: inline; filename=generic_ipi_weaken_barrier.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the unnecessary smp_mb() in csd_flag_wait(), as the presence of that
smp_mb() doesn't mean anything on the sender, when the ipi receiver is not
doing any thing special (like memory fence) after clearing the CSD_FLAG_WAIT.

IPI receiver (on Alpha atleast) needs smp_read_barrier_depends() in the handler
before reading the call_single_queue list in a lock-free fashion. Replace
the existing smp_mb() (which is unnecessary) with smp_read_barrier_depends()

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: linux-2.6.git/kernel/smp.c
===================================================================
--- linux-2.6.git.orig/kernel/smp.c	2008-11-04 09:54:29.000000000 -0800
+++ linux-2.6.git/kernel/smp.c	2008-11-04 10:04:54.000000000 -0800
@@ -51,10 +51,6 @@
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
@@ -162,7 +158,7 @@
 	 * Need to see other stores to list head for checking whether
 	 * list is empty without holding q->lock
 	 */
-	smp_mb();
+	smp_read_barrier_depends();
 	while (!list_empty(&q->list)) {
 		unsigned int data_flags;
 
@@ -196,7 +192,7 @@
 		/*
 		 * See comment on outer loop
 		 */
-		smp_mb();
+		smp_read_barrier_depends();
 	}
 }
 

-- 

