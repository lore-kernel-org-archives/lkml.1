Return-Path: <linux-kernel-owner+w=401wt.eu-S1755047AbZLBAym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047AbZLBAym (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 19:54:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754999AbZLBAyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 19:54:41 -0500
Received: from mga11.intel.com ([192.55.52.93]:60065 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754938AbZLBAyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 19:54:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,324,1257148800"; 
   d="scan'208";a="518876467"
Message-Id: <20091201233334.975416130@sbs-t61.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Tue, 01 Dec 2009 15:31:15 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>, hpa@zytor.com, mingo@elte.hu,
       tglx@linutronix.de, ebiederm@xmission.com, garyhade@us.ibm.com
Cc: linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com
Subject: [patch 1/4] x86, io-apic: move the effort of clearing remoteIRR explicitly before migrating the irq
Content-Disposition: inline; filename=fix_irq_migration_ioapic_level_delivered_as_edge.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Maciej W. Rozycki" <macro@linux-mips.org>
Subject:  x86, io-apic: move the effort of clearing remoteIRR explicitly before migrating the irq

When the level-triggered interrupt is seen as an edge interrupt, we try
to clear the remoteIRR explicitly (using either an io-apic eoi register
when present or through the idea of changing trigger mode of the io-apic
RTE to edge and then back to level). But this explicit try also needs to
happen before we try to migrate the irq. Otherwise irq migration attempt
will fail anyhow, as it postpones the irq migration to a later attempt
when it sees the remoteIRR in the io-apic RTE still set.

Signed-off-by: "Maciej W. Rozycki" <macro@linux-mips.org>
Reviewed-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/kernel/apic/io_apic.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

Index: tip-linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- tip-linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ tip-linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -2583,6 +2583,20 @@ static void ack_apic_level(unsigned int 
 	 */
 	ack_APIC_irq();
 
+	/* Tail end of version 0x11 I/O APIC bug workaround */
+	if (!(v & (1 << (i & 0x1f)))) {
+		atomic_inc(&irq_mis_count);
+
+		if (use_eoi_reg)
+			eoi_ioapic_irq(desc);
+		else {
+			spin_lock(&ioapic_lock);
+			__mask_and_edge_IO_APIC_irq(cfg);
+			__unmask_and_level_IO_APIC_irq(cfg);
+			spin_unlock(&ioapic_lock);
+		}
+	}
+
 	/* Now we can move and renable the irq */
 	if (unlikely(do_unmask_irq)) {
 		/* Only migrate the irq if the ack has been received.
@@ -2616,20 +2630,6 @@ static void ack_apic_level(unsigned int 
 			move_masked_irq(irq);
 		unmask_IO_APIC_irq_desc(desc);
 	}
-
-	/* Tail end of version 0x11 I/O APIC bug workaround */
-	if (!(v & (1 << (i & 0x1f)))) {
-		atomic_inc(&irq_mis_count);
-
-		if (use_eoi_reg)
-			eoi_ioapic_irq(desc);
-		else {
-			spin_lock(&ioapic_lock);
-			__mask_and_edge_IO_APIC_irq(cfg);
-			__unmask_and_level_IO_APIC_irq(cfg);
-			spin_unlock(&ioapic_lock);
-		}
-	}
 }
 
 #ifdef CONFIG_INTR_REMAP


