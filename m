Return-Path: <linux-kernel-owner+w=401wt.eu-S1757652AbZFZAQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757652AbZFZAQR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 20:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753351AbZFZAPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 20:15:17 -0400
Received: from mga03.intel.com ([143.182.124.21]:5615 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754898AbZFZAPM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 20:15:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,293,1243839600"; 
   d="scan'208,223";a="158663131"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "H. Peter Anvin" <hpa@linux.intel.com>,
       "Pan, Jacob jun" <jacob.jun.pan@intel.com>
Date: Thu, 25 Jun 2009 17:15:12 -0700
Subject: [PATCH 8/9] x86/apic: match destination id with destination mode
Thread-Topic: [PATCH 8/9] x86/apic: match destination id with destination
 mode
Thread-Index: Acn18yxWTvKlclBLQ6iIdNPUQsyazw==
Message-ID: <43F901BD926A4E43B106BF17856F07556412B7E7@orsmsx508.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 791a44040dde6670f90a729cf91ed302d84b875a Mon Sep 17 00:00:00 2001
From: Jacob Pan <jacob.jun.pan@intel.com>
Date: Tue, 12 May 2009 10:51:08 -0700
Subject: [PATCH] x86/apic: match destination id with destination mode

current code assigns logical destination IDs regardless of destination modes, this is not a problem since we only use logical delivery so far. but it could be a problem with platforms only supports physical mode

Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
---
 arch/x86/kernel/apic/io_apic.c |   27 +++++++++++++++++++--------
 1 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 4d0216f..c84dc3d 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1431,7 +1431,10 @@ int setup_ioapic_entry(int apic_id, int irq,
 	} else {
 		entry->delivery_mode = apic->irq_delivery_mode;
 		entry->dest_mode = apic->irq_dest_mode;
-		entry->dest = destination;
+		if (apic->irq_dest_mode)
+			entry->dest = destination;
+		else	/* physical ID of BSP */
+			entry->dest = boot_cpu_id;
 		entry->vector = vector;
 	}
 
@@ -1576,7 +1579,10 @@ static void __init setup_timer_IRQ0_pin(unsigned int apic_id, unsigned int pin,
 	 */
 	entry.dest_mode = apic->irq_dest_mode;
 	entry.mask = 0;			/* don't mask IRQ for edge */
-	entry.dest = apic->cpu_mask_to_apicid(apic->target_cpus());
+	if (!apic->irq_dest_mode)
+		entry.dest = boot_cpu_id;	/* physical apic id */
+	else
+		entry.dest = apic->cpu_mask_to_apicid(apic->target_cpus());
 	entry.delivery_mode = apic->irq_delivery_mode;
 	entry.polarity = 0;
 	entry.trigger = 0;
@@ -2343,7 +2349,8 @@ set_ioapic_affinity_irq_desc(struct irq_desc *desc, const struct cpumask *mask)
 	dest = set_desc_affinity(desc, mask);
 	if (dest != BAD_APICID) {
 		/* Only the high 8 bits are valid. */
-		dest = SET_APIC_LOGICAL_ID(dest);
+		if (apic->irq_dest_mode)
+			dest = SET_APIC_LOGICAL_ID(dest);
 		__target_IO_APIC_irq(irq, dest, cfg);
 		ret = 0;
 	}
@@ -3273,9 +3280,11 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq, struct msi_ms
 	err = assign_irq_vector(irq, cfg, apic->target_cpus());
 	if (err)
 		return err;
-
-	dest = apic->cpu_mask_to_apicid_and(cfg->domain, apic->target_cpus());
-
+	if (apic->irq_dest_mode)
+		dest = apic->cpu_mask_to_apicid_and(cfg->domain,
+						apic->target_cpus());
+	else
+		dest = boot_cpu_id;
 	if (irq_remapped(irq)) {
 		struct irte irte;
 		int ir_index;
@@ -3339,8 +3348,10 @@ static int set_msi_irq_affinity(unsigned int irq, const struct cpumask *mask)
 	struct irq_cfg *cfg;
 	struct msi_msg msg;
 	unsigned int dest;
-
-	dest = set_desc_affinity(desc, mask);
+	if (apic->irq_dest_mode)
+		dest = set_desc_affinity(desc, mask);
+	else
+		dest = boot_cpu_id;
 	if (dest == BAD_APICID)
 		return -1;
 
-- 
1.5.6.5

