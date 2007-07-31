Return-Path: <linux-kernel-owner+w=401wt.eu-S1762989AbXGaUUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762989AbXGaUUI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 16:20:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756074AbXGaUT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 16:19:56 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:46095 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758918AbXGaUTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 16:19:55 -0400
From: Kevin Corry <kevcorry@us.ibm.com>
Organization: IBM
To: linuxppc-dev@ozlabs.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] PowerPC: Fix num_cpus calculation in smp_call_function_map()
Date: Tue, 31 Jul 2007 15:19:46 -0500
User-Agent: KMail/1.9.5
Cc: Carl Love <carll@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707311519.48359.kevcorry@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[POWERPC]: Fix num_cpus calculation in smp_call_function_map().

In smp_call_function_map(), num_cpus is set to the number of online CPUs minus
one. However, if the CPU mask does not include all CPUs (except the one we're
running on), the routine will hang in the first while() loop until the 8 second
timeout occurs.

The num_cpus should be set to the number of CPUs specified in the mask passed
into the routine, after we've made any modifications to the mask. With this
change, we can also get rid of the call to cpus_empty() and avoid adding
another pass through the bitmask.

Signed-off-by: Kevin Corry <kevcorry@us.ibm.com>
Signed-off-by: Carl Love <carll@us.ibm.com>

Index: linux-2.6.23-rc1/arch/powerpc/kernel/smp.c
===================================================================
--- linux-2.6.23-rc1.orig/arch/powerpc/kernel/smp.c
+++ linux-2.6.23-rc1/arch/powerpc/kernel/smp.c
@@ -212,11 +212,6 @@ int smp_call_function_map(void (*func) (
 		atomic_set(&data.finished, 0);
 
 	spin_lock(&call_lock);
-	/* Must grab online cpu count with preempt disabled, otherwise
-	 * it can change. */
-	num_cpus = num_online_cpus() - 1;
-	if (!num_cpus)
-		goto done;
 
 	/* remove 'self' from the map */
 	if (cpu_isset(smp_processor_id(), map))
@@ -224,7 +219,9 @@ int smp_call_function_map(void (*func) (
 
 	/* sanity check the map, remove any non-online processors. */
 	cpus_and(map, map, cpu_online_map);
-	if (cpus_empty(map))
+
+	num_cpus = cpus_weight(map);
+	if (!num_cpus)
 		goto done;
 
 	call_data = &data;
