Return-Path: <linux-kernel-owner+w=401wt.eu-S1751879AbYLHRo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879AbYLHRo0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 12:44:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750741AbYLHRoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 12:44:14 -0500
Received: from relay2.sgi.com ([192.48.179.30]:43746 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750715AbYLHRoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 12:44:14 -0500
From: John Keller <jpk@sgi.com>
To: linux-ia64@vger.kernel.org
Cc: tglx@linutronix.de, mingo@elte.hu, yinghai@kernel.org,
       linux-kernel@vger.kernel.org, John Keller <jpk@sgi.com>
Message-Id: <20081208174411.119278.58670.83945@attica.americas.sgi.com>
Subject: [PATCH] ia64: SN: prevent IRQ retargetting in request_irq()
Date: Mon,  8 Dec 2008 11:44:11 -0600 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the introduction of the generic affinity autoselector,
irq_select_affinity(), IRQs are now being retargetted,
using a default mask, via the request_irq() path.
This results in all IRQs targetted at CPU 0.

SN Altix assigns affinity in the SN PROM, and does not
expect that to be changed as part of request_irq().

Set the IRQ_AFFINITY_SET flag to prevent
request_irq() from resetting affinity.


Signed-off-by: John Keller <jpk@sgi.com>


Index: linux-2.6/arch/ia64/sn/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/ia64/sn/kernel/irq.c	2008-12-03 14:19:41.000000000 -0600
+++ linux-2.6/arch/ia64/sn/kernel/irq.c	2008-12-08 11:03:19.116963490 -0600
@@ -5,7 +5,7 @@
  * License.  See the file "COPYING" in the main directory of this archive
  * for more details.
  *
- * Copyright (c) 2000-2007 Silicon Graphics, Inc.  All Rights Reserved.
+ * Copyright (c) 2000-2008 Silicon Graphics, Inc.  All Rights Reserved.
  */
 
 #include <linux/irq.h>
@@ -375,6 +375,7 @@ void sn_irq_fixup(struct pci_dev *pci_de
 	int cpu = nasid_slice_to_cpuid(nasid, slice);
 #ifdef CONFIG_SMP
 	int cpuphys;
+	irq_desc_t *desc;
 #endif
 
 	pci_dev_get(pci_dev);
@@ -391,6 +392,12 @@ void sn_irq_fixup(struct pci_dev *pci_de
 #ifdef CONFIG_SMP
 	cpuphys = cpu_physical_id(cpu);
 	set_irq_affinity_info(sn_irq_info->irq_irq, cpuphys, 0);
+	desc = irq_to_desc(sn_irq_info->irq_irq);
+	/*
+	 * Affinity was set by the PROM, prevent it from
+	 * being reset by the request_irq() path.
+	 */
+	desc->status |= IRQ_AFFINITY_SET;
 #endif
 }
 
