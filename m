Return-Path: <linux-kernel-owner+w=401wt.eu-S1753994AbXJWKHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbXJWKHk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 06:07:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752081AbXJWKHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 06:07:20 -0400
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:64711 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbXJWKHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 06:07:16 -0400
Date: Tue, 23 Oct 2007 03:06:38 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86_64: set cpu_index to NR_CPUS instead of 0
To: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Message-id: <200710230306.38640.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86_64: set cpu_index to NR_CPUS instead of 0

same BIOS will support two/four dualcore/quadcore system, and will get

ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 15:1 APIC version 16
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1 15:1 APIC version 16
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
Processor #2 15:1 APIC version 16
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
Processor #3 15:1 APIC version 16
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x84] disabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x85] disabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x86] disabled)
ACPI: LAPIC (acpi_id[0x08] lapic_id[0x87] disabled)
ACPI: LAPIC (acpi_id[0x09] lapic_id[0x88] disabled)
ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x89] disabled)
ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x8a] disabled)
ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x8b] disabled)
ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x8c] disabled)
ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x8d] disabled)
ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x8e] disabled)
ACPI: LAPIC (acpi_id[0x10] lapic_id[0x8f] disabled)

SMP: Allowing 16 CPUs, 12 hotplug CPUs

the /proc/cpuinfo will show as bunch of NULL cpus with cpu_index=0

so assign impossible cpu_index value at first instead of 0.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

Index: linux-2.6/arch/x86/kernel/smpboot_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/smpboot_64.c
+++ linux-2.6/arch/x86/kernel/smpboot_64.c
@@ -861,6 +861,18 @@ void __init smp_set_apicids(void)
 	x86_cpu_to_apicid_ptr = NULL;
 }
 
+static void __init smp_cpu_index_default(void)
+{
+	int i;
+	struct cpuinfo_x86 *c;
+
+	for_each_cpu_mask(i, cpu_possible_map) {
+		c = &cpu_data(i);
+		/* mark all to hotplug */
+		c->cpu_index = NR_CPUS;
+	}
+}
+
 /*
  * Prepare for SMP bootup.  The MP table or ACPI has been read
  * earlier.  Just do some sanity checking here and enable APIC mode.
@@ -868,6 +880,7 @@ void __init smp_set_apicids(void)
 void __init smp_prepare_cpus(unsigned int max_cpus)
 {
 	nmi_watchdog_default();
+	smp_cpu_index_default();
 	current_cpu_data = boot_cpu_data;
 	current_thread_info()->cpu = 0;  /* needed? */
 	smp_set_apicids();
