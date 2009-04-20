Return-Path: <linux-kernel-owner+w=401wt.eu-S1757130AbZDTUQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757130AbZDTUQe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 16:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756686AbZDTUPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 16:15:32 -0400
Received: from mga14.intel.com ([143.182.124.37]:27286 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756556AbZDTUPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 16:15:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,219,1239001200"; 
   d="scan'208";a="133562780"
Message-Id: <20090420200450.552359000@linux-os.sc.intel.com>
References: <20090420200450.128993000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Mon, 20 Apr 2009 13:02:30 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Weidong Han <weidong.han@intel.com>
Subject: [patch 4/5] x2apic, IR: remove reinit_intr_remapped_IO_APIC()
Content-Disposition: inline; filename=remove_reinit_intr_remapped_ioapic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When interrupt-remapping is enabled, We are relying on setup_IO_APIC_irqs()
to configure remapped entries in the IO-APIC, which comes little bit later
after enabling interrupt-remapping.

Meanwhile, Restore of old io-apic entries after enabling interrupt-remapping
will not make the interrupts through io-apic functional anyway.

So remove unnecessary reinit_intr_remapped_IO_APIC().

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Weidong Han <weidong.han@intel.com>
---

Index: tip/arch/x86/include/asm/io_apic.h
===================================================================
--- tip.orig/arch/x86/include/asm/io_apic.h
+++ tip/arch/x86/include/asm/io_apic.h
@@ -166,8 +166,6 @@ extern void free_ioapic_entries(struct I
 extern int save_IO_APIC_setup(struct IO_APIC_route_entry **ioapic_entries);
 extern void mask_IO_APIC_setup(struct IO_APIC_route_entry **ioapic_entries);
 extern int restore_IO_APIC_setup(struct IO_APIC_route_entry **ioapic_entries);
-extern void reinit_intr_remapped_IO_APIC(int intr_remapping,
-	struct IO_APIC_route_entry **ioapic_entries);
 
 extern void probe_nr_irqs_gsi(void);
 
Index: tip/arch/x86/kernel/apic/apic.c
===================================================================
--- tip.orig/arch/x86/kernel/apic/apic.c
+++ tip/arch/x86/kernel/apic/apic.c
@@ -1416,8 +1416,6 @@ end_restore:
 		 * IR enabling failed
 		 */
 		restore_IO_APIC_setup(ioapic_entries);
-	else
-		reinit_intr_remapped_IO_APIC(x2apic_preenabled, ioapic_entries);
 
 	unmask_8259A();
 	local_irq_restore(flags);
Index: tip/arch/x86/kernel/apic/io_apic.c
===================================================================
--- tip.orig/arch/x86/kernel/apic/io_apic.c
+++ tip/arch/x86/kernel/apic/io_apic.c
@@ -834,20 +834,6 @@ int restore_IO_APIC_setup(struct IO_APIC
 	return 0;
 }
 
-void reinit_intr_remapped_IO_APIC(int intr_remapping,
-	struct IO_APIC_route_entry **ioapic_entries)
-
-{
-	/*
-	 * for now plain restore of previous settings.
-	 * TBD: In the case of OS enabling interrupt-remapping,
-	 * IO-APIC RTE's need to be setup to point to interrupt-remapping
-	 * table entries. for now, do a plain restore, and wait for
-	 * the setup_IO_APIC_irqs() to do proper initialization.
-	 */
-	restore_IO_APIC_setup(ioapic_entries);
-}
-
 void free_ioapic_entries(struct IO_APIC_route_entry **ioapic_entries)
 {
 	int apic;

-- 

