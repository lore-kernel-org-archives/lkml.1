Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965871Ab0BZTcz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 14:32:55 -0500
Received: from hera.kernel.org ([140.211.167.34]:35556 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965824Ab0BZTcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 14:32:53 -0500
Message-ID: <4B882156.10507@kernel.org>
Date: Fri, 26 Feb 2010 11:30:30 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Thomas Renninger <trenn@suse.de>, Gary Hade <garyhade@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: Iranna D Ankad <iranna.ankad@in.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>, len.brown@intel.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH -v8 1/2] x86: fix out of order of gsi - have right boot_ioapic_idx
References: <201002221108.42847.trenn@suse.de> <4B826CA6.7060007@kernel.org> <201002221258.38506.trenn@suse.de> <4B839ACB.3000804@kernel.org> <4B842129.8020906@kernel.org>
In-Reply-To: <4B842129.8020906@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


found IBM x3950 will have problem after

|commit b9c61b70075c87a8612624736faf4a2de5b1ed30
|
|    x86/pci: update pirq_enable_irq() to setup io apic routing

The problem is that with the patch, the machine freezes when
console=ttyS0,... kernel serial parameter is passed.
It seem to freeze at DVD initialization and the whole problem seem
to be DVD/pata related, but somehow exposed through the serial
parameter.
Such apic problems can expose really weird behavior..

<6>ACPI: IOAPIC (id[0x10] address[0xfecff000] gsi_base[0])
<6>IOAPIC[0]: apic_id 16, version 0, address 0xfecff000, GSI 0-2
<6>ACPI: IOAPIC (id[0x0f] address[0xfec00000] gsi_base[3])
<6>IOAPIC[1]: apic_id 15, version 0, address 0xfec00000, GSI 3-38
<6>ACPI: IOAPIC (id[0x0e] address[0xfec01000] gsi_base[39])
<6>IOAPIC[2]: apic_id 14, version 0, address 0xfec01000, GSI 39-74
<6>ACPI: INT_SRC_OVR (bus 0 bus_irq 1 global_irq 4 dfl dfl)
<6>ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 5 dfl dfl)
<6>ACPI: INT_SRC_OVR (bus 0 bus_irq 3 global_irq 6 dfl dfl)
<6>ACPI: INT_SRC_OVR (bus 0 bus_irq 4 global_irq 7 dfl dfl)
<6>ACPI: INT_SRC_OVR (bus 0 bus_irq 6 global_irq 9 dfl dfl)
<6>ACPI: INT_SRC_OVR (bus 0 bus_irq 7 global_irq 10 dfl dfl)
<6>ACPI: INT_SRC_OVR (bus 0 bus_irq 8 global_irq 11 low edge)
<6>ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 12 dfl dfl)
<6>ACPI: INT_SRC_OVR (bus 0 bus_irq 12 global_irq 15 dfl dfl)
<6>ACPI: INT_SRC_OVR (bus 0 bus_irq 13 global_irq 16 dfl dfl)
<6>ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 17 low edge)
<6>ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 18 dfl dfl)

it turns out that system have three io apic controller. but put boot ioapic
routing in second one. and that gsi_base is not 0. it is using bunch of INT_SRC_OVR...

recent changes
1. one set routing for first io apic controller
2. assume irq = gsi
will break theat system.

so try to remap those gsi, need to seperate boot_ioapic_id detection out of enable_IO_APIC
and call them early.
introduce boot_ioapic_id, and remap_ioapic_gsi...

-v2: shift gsi with delta instead of gsi_base of boot_ioapic_idx
-v3: double check with find_isa_irq_apic(0, mp_INT) to get right boot_ioapic_idx
-v4: nr_legacy_irqs
-v5: add print out for boot_ioapic_idx, and also make it could be applied for current
     kernel and previous kernel
-v6: add bus_irq, in acpi_sci_ioapic_setup, so can get overwride for sci right mapping...
-v7: looks like pnpacpi get irq instead of gsi, so need to revert them back...
-v8: split to two patches
     this one only have right boot_ioapic_idx

Reported-by: Iranna D Ankad <iranna.ankad@in.ibm.com>
Bisected-by: Iranna D Ankad <iranna.ankad@in.ibm.com>
Tested-by: Gary Hade <garyhade@us.ibm.com>
Cc: Thomas Renninger <trenn@suse.de>
Cc: stable@kernel.org
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/io_apic.h |    1 +
 arch/x86/kernel/apic/io_apic.c |   32 ++++++++++++++++++++------------
 2 files changed, 21 insertions(+), 12 deletions(-)

Index: linux-2.6/arch/x86/include/asm/io_apic.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/io_apic.h
+++ linux-2.6/arch/x86/include/asm/io_apic.h
@@ -113,6 +113,7 @@ struct IR_IO_APIC_route_entry {
  */
 extern int nr_ioapics;
 extern int nr_ioapic_registers[MAX_IO_APICS];
+extern int boot_ioapic_idx;
 
 #define MP_MAX_IOAPIC_PIN 127
 
Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -84,6 +84,7 @@ int nr_ioapic_registers[MAX_IO_APICS];
 /* I/O APIC entries */
 struct mpc_ioapic mp_ioapics[MAX_IO_APICS];
 int nr_ioapics;
+int boot_ioapic_idx;
 
 /* IO APIC gsi routing info */
 struct mp_ioapic_gsi  mp_gsi_routing[MAX_IO_APICS];
@@ -1467,9 +1468,9 @@ static struct {
 	DECLARE_BITMAP(pin_programmed, MP_MAX_IOAPIC_PIN + 1);
 } mp_ioapic_routing[MAX_IO_APICS];
 
-static void __init setup_IO_APIC_irqs(void)
+static void __init setup_IO_APIC_irqs(int apic_id)
 {
-	int apic_id = 0, pin, idx, irq;
+	int pin, idx, irq;
 	int notcon = 0;
 	struct irq_desc *desc;
 	struct irq_cfg *cfg;
@@ -1477,14 +1478,6 @@ static void __init setup_IO_APIC_irqs(vo
 
 	apic_printk(APIC_VERBOSE, KERN_DEBUG "init IO_APIC IRQs\n");
 
-#ifdef CONFIG_ACPI
-	if (!acpi_disabled && acpi_ioapic) {
-		apic_id = mp_find_ioapic(0);
-		if (apic_id < 0)
-			apic_id = 0;
-	}
-#endif
-
 	for (pin = 0; pin < nr_ioapic_registers[apic_id]; pin++) {
 		idx = find_irq_entry(apic_id, pin, mp_INT);
 		if (idx == -1) {
@@ -2002,6 +1995,21 @@ void __init enable_IO_APIC(void)
 	clear_IO_APIC();
 }
 
+static void __init probe_ioapic_i8259(void)
+{
+	/* probe boot ioapic idx */
+	boot_ioapic_idx = ioapic_i8259.apic;
+	if (boot_ioapic_idx < 0)
+		boot_ioapic_idx = find_isa_irq_apic(0, mp_INT);
+#ifdef CONFIG_ACPI
+	if (!acpi_disabled && acpi_ioapic && boot_ioapic_idx < 0)
+		boot_ioapic_idx = mp_find_ioapic(0);
+#endif
+	if (boot_ioapic_idx < 0)
+		boot_ioapic_idx = 0;
+	printk(KERN_INFO "boot_ioapic_idx: %d\n", boot_ioapic_idx);
+}
+
 /*
  * Not an __init, needed by the reboot code
  */
@@ -3120,7 +3128,6 @@ out:
 
 void __init setup_IO_APIC(void)
 {
-
 	/*
 	 * calling enable_IO_APIC() is moved to setup_local_APIC for BP
 	 */
@@ -3133,7 +3140,8 @@ void __init setup_IO_APIC(void)
 	x86_init.mpparse.setup_ioapic_ids();
 
 	sync_Arb_IDs();
-	setup_IO_APIC_irqs();
+	probe_ioapic_i8259();
+	setup_IO_APIC_irqs(boot_ioapic_idx);
 	init_IO_APIC_traps();
 	if (legacy_pic->nr_legacy_irqs)
 		check_timer();
