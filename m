Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031655Ab0B1JIc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 04:08:32 -0500
Received: from hera.kernel.org ([140.211.167.34]:42539 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031496Ab0B1JI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 04:08:27 -0500
Message-ID: <4B8A321A.1000008@kernel.org>
Date: Sun, 28 Feb 2010 01:06:34 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, hpa@zytor.com,
       garyhade@us.ibm.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       mingo@redhat.com, iranna.ankad@in.ibm.com, suresh.b.siddha@intel.com,
       trenn@suse.de
Subject: [PATCH -v12 1/2] x86: fix out of order of gsi -- partial
References: <4B882182.4030205@kernel.org> <tip-519d637a93116ffbcd50e9e3f2591f41584f372c@git.kernel.org> <20100227130113.GA18661@elte.hu> <m1y6ieo5zw.fsf@fess.ebiederm.org> <4B897537.5050406@kernel.org> <m1zl2ue585.fsf@fess.ebiederm.org> <4B8995FB.9000908@kernel.org> <m1mxyue31g.fsf@fess.ebiederm.org> <4B89E751.1060903@kernel.org> <20100228080941.GD14205@elte.hu>
In-Reply-To: <20100228080941.GD14205@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Eric W. Biederman <ebiederm@xmission.com>

Iranna D Ankad reported that IBM x3950 systems have boot problems
after this commit:

 |
 | commit b9c61b70075c87a8612624736faf4a2de5b1ed30
 |
 |    x86/pci: update pirq_enable_irq() to setup io apic routing
 |

The problem is that with the patch, the machine freezes when
console=ttyS0,... kernel serial parameter is passed.

It seem to freeze at DVD initialization and the whole problem
seem to be DVD/pata related, but somehow exposed through the
serial parameter.

Such apic problems can expose really weird behavior:

  ACPI: IOAPIC (id[0x10] address[0xfecff000] gsi_base[0])
  IOAPIC[0]: apic_id 16, version 0, address 0xfecff000, GSI 0-2
  ACPI: IOAPIC (id[0x0f] address[0xfec00000] gsi_base[3])
  IOAPIC[1]: apic_id 15, version 0, address 0xfec00000, GSI 3-38
  ACPI: IOAPIC (id[0x0e] address[0xfec01000] gsi_base[39])
  IOAPIC[2]: apic_id 14, version 0, address 0xfec01000, GSI 39-74
  ACPI: INT_SRC_OVR (bus 0 bus_irq 1 global_irq 4 dfl dfl)
  ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 5 dfl dfl)
  ACPI: INT_SRC_OVR (bus 0 bus_irq 3 global_irq 6 dfl dfl)
  ACPI: INT_SRC_OVR (bus 0 bus_irq 4 global_irq 7 dfl dfl)
  ACPI: INT_SRC_OVR (bus 0 bus_irq 6 global_irq 9 dfl dfl)
  ACPI: INT_SRC_OVR (bus 0 bus_irq 7 global_irq 10 dfl dfl)
  ACPI: INT_SRC_OVR (bus 0 bus_irq 8 global_irq 11 low edge)
  ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 12 dfl dfl)
  ACPI: INT_SRC_OVR (bus 0 bus_irq 12 global_irq 15 dfl dfl)
  ACPI: INT_SRC_OVR (bus 0 bus_irq 13 global_irq 16 dfl dfl)
  ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 17 low edge)
  ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 18 dfl dfl)

It turns out that the system has three io apic controllers, but
boot ioapic routing is in the second one, and that gsi_base is
not 0 - it is using a bunch of INT_SRC_OVR...

So these recent changes:

 1. one set routing for first io apic controller
 2. assume irq = gsi

... will break that system.

So try to remap those gsis, need to seperate boot_ioapic_idx
detection out of enable_IO_APIC() and call them early.

So introduce boot_ioapic_idx, and remap_ioapic_gsi()...

 -v2: shift gsi with delta instead of gsi_base of boot_ioapic_idx

 -v3: double check with find_isa_irq_apic(0, mp_INT) to get right
      boot_ioapic_idx

 -v4: nr_legacy_irqs

 -v5: add print out for boot_ioapic_idx, and also make it could be
      applied for current kernel and previous kernel

 -v6: add bus_irq, in acpi_sci_ioapic_setup, so can get overwride
      for sci right mapping...

 -v7: looks like pnpacpi get irq instead of gsi, so need to revert
      them back...

 -v8: split into two patches

 -v9: according to Eric, use fixed 16 for shifting instead of remap

 -v10: still need to touch rsparser.c

 -v11: just revert back to way Eric suggest...
      anyway the ioapic in first ioapic is blocked by second...

 -v12: two patches, this one will add more loop but check apic_id and irq > 16

Reported-by: Iranna D Ankad <iranna.ankad@in.ibm.com>
Bisected-by: Iranna D Ankad <iranna.ankad@in.ibm.com>
Tested-by: Gary Hade <garyhade@us.ibm.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: len.brown@intel.com

---
 arch/x86/kernel/apic/io_apic.c |   28 ++++++++++------------------
 1 file changed, 10 insertions(+), 18 deletions(-)

Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -1475,7 +1475,7 @@ static struct {
 
 static void __init setup_IO_APIC_irqs(void)
 {
-	int apic_id = 0, pin, idx, irq;
+	int apic_id, pin, idx, irq;
 	int notcon = 0;
 	struct irq_desc *desc;
 	struct irq_cfg *cfg;
@@ -1483,14 +1483,7 @@ static void __init setup_IO_APIC_irqs(vo
 
 	apic_printk(APIC_VERBOSE, KERN_DEBUG "init IO_APIC IRQs\n");
 
-#ifdef CONFIG_ACPI
-	if (!acpi_disabled && acpi_ioapic) {
-		apic_id = mp_find_ioapic(0);
-		if (apic_id < 0)
-			apic_id = 0;
-	}
-#endif
-
+	for (apic_id = 0; apic_id < nr_ioapics; apic_id++)
 	for (pin = 0; pin < nr_ioapic_registers[apic_id]; pin++) {
 		idx = find_irq_entry(apic_id, pin, mp_INT);
 		if (idx == -1) {
@@ -1512,6 +1505,9 @@ static void __init setup_IO_APIC_irqs(vo
 
 		irq = pin_2_irq(idx, apic_id, pin);
 
+		if ((apic_id > 0) && (irq > 16))
+			continue;
+
 		/*
 		 * Skip the timer IRQ if there's a quirk handler
 		 * installed and if it returns 1:
@@ -4105,27 +4101,23 @@ int acpi_get_override_irq(int bus_irq, i
 #ifdef CONFIG_SMP
 void __init setup_ioapic_dest(void)
 {
-	int pin, ioapic = 0, irq, irq_entry;
+	int pin, ioapic, irq, irq_entry;
 	struct irq_desc *desc;
 	const struct cpumask *mask;
 
 	if (skip_ioapic_setup == 1)
 		return;
 
-#ifdef CONFIG_ACPI
-	if (!acpi_disabled && acpi_ioapic) {
-		ioapic = mp_find_ioapic(0);
-		if (ioapic < 0)
-			ioapic = 0;
-	}
-#endif
-
+	for (ioapic = 0; ioapic < nr_ioapics; ioapic++)
 	for (pin = 0; pin < nr_ioapic_registers[ioapic]; pin++) {
 		irq_entry = find_irq_entry(ioapic, pin, mp_INT);
 		if (irq_entry == -1)
 			continue;
 		irq = pin_2_irq(irq_entry, ioapic, pin);
 
+		if ((ioapic > 0) && (irq > 16))
+			continue;
+
 		desc = irq_to_desc(irq);
 
 		/*
