Return-Path: <linux-kernel-owner+w=401wt.eu-S1758129AbZCQAbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758129AbZCQAbX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 20:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761804AbZCQA21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 20:28:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:9470 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754366AbZCQA2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 20:28:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,375,1233561600"; 
   d="scan'208";a="395024227"
Message-Id: <20090317001320.700032000@linux-os.sc.intel.com>
References: <20090317000452.805772000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Mon, 16 Mar 2009 17:04:59 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, dwmw2@infradead.org,
       yinghai@kernel.org, steiner@sgi.com
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [patch 07/13] x2apic: use virtual wire A mode in disable_IO_APIC() with interrupt-remapping
Content-Disposition: inline; filename=use_virtual_wire_a_kexec.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

disable_IO_APIC() gets called during crashdump aswell, which configures the
IO-APIC/LAPIC so that legacy interrupts can be delivered for the kexec'd kernel.

In the presence of interrupt-remapping, we need to change the
interrupt-remapping configuration aswell as modifying IO-APIC for virtual wire
B mode.

To keep things simple during the crash, use virtual wire A mode
(for which we don't need to touch io-apic and interrupt-remapping tables).

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
---

Index: tip/arch/x86/kernel/apic/io_apic.c
===================================================================
--- tip.orig/arch/x86/kernel/apic/io_apic.c
+++ tip/arch/x86/kernel/apic/io_apic.c
@@ -2040,8 +2040,13 @@ void disable_IO_APIC(void)
 	 * If the i8259 is routed through an IOAPIC
 	 * Put that IOAPIC in virtual wire mode
 	 * so legacy interrupts can be delivered.
+	 *
+	 * With interrupt-remapping, for now we will use virtual wire A mode,
+	 * as virtual wire B is little complex (need to configure both
+	 * IOAPIC RTE aswell as interrupt-remapping table entry).
+	 * As this gets called during crash dump, keep this simple for now.
 	 */
-	if (ioapic_i8259.pin != -1) {
+	if (ioapic_i8259.pin != -1 && !intr_remapping_enabled) {
 		struct IO_APIC_route_entry entry;
 
 		memset(&entry, 0, sizeof(entry));
@@ -2061,7 +2066,10 @@ void disable_IO_APIC(void)
 		ioapic_write_entry(ioapic_i8259.apic, ioapic_i8259.pin, entry);
 	}
 
-	disconnect_bsp_APIC(ioapic_i8259.pin != -1);
+	/*
+	 * Use virtual wire A mode when interrupt remapping is enabled.
+	 */
+	disconnect_bsp_APIC(!intr_remapping_enabled && ioapic_i8259.pin != -1);
 }
 
 #ifdef CONFIG_X86_32

-- 

