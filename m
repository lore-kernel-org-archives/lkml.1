Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968294Ab0B0NBI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 08:01:08 -0500
Received: from hera.kernel.org ([140.211.167.34]:47841 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968247Ab0B0NBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 08:01:05 -0500
Date: Sat, 27 Feb 2010 12:57:18 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, ebiederm@xmission.com, garyhade@us.ibm.com,
       iranna.ankad@in.ibm.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
       trenn@suse.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, ebiederm@xmission.com, garyhade@us.ibm.com,
       iranna.ankad@in.ibm.com, suresh.b.siddha@intel.com, trenn@suse.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4B882156.10507@kernel.org>
References: <4B882156.10507@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86: Fix out of order gsi - have the right boot_ioapic_idx
Message-ID: <tip-ca8c764cb39bf6cade71933b38e8c830eb8b73c6@git.kernel.org>
Git-Commit-ID: ca8c764cb39bf6cade71933b38e8c830eb8b73c6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 27 Feb 2010 12:57:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ca8c764cb39bf6cade71933b38e8c830eb8b73c6
Gitweb:     http://git.kernel.org/tip/ca8c764cb39bf6cade71933b38e8c830eb8b73c6
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Fri, 26 Feb 2010 11:30:30 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 27 Feb 2010 12:54:16 +0100

x86: Fix out of order gsi - have the right boot_ioapic_idx

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

This patch introduces boot_ioapic_idx.

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

 -v8: split into two patches this one only have right boot_ioapic_idx

Reported-by: Iranna D Ankad <iranna.ankad@in.ibm.com>
Bisected-by: Iranna D Ankad <iranna.ankad@in.ibm.com>
Tested-by: Gary Hade <garyhade@us.ibm.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: len.brown@intel.com
Cc: <stable@kernel.org> # .33.x
LKML-Reference: <4B882156.10507@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/io_apic.h |    1 +
 arch/x86/kernel/apic/io_apic.c |   32 ++++++++++++++++++++------------
 2 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 5f61f6e..b16c075 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -113,6 +113,7 @@ struct IR_IO_APIC_route_entry {
  */
 extern int nr_ioapics;
 extern int nr_ioapic_registers[MAX_IO_APICS];
+extern int boot_ioapic_idx;
 
 #define MP_MAX_IOAPIC_PIN 127
 
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 72ac2a3..53533a0 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -84,6 +84,7 @@ int nr_ioapic_registers[MAX_IO_APICS];
 /* I/O APIC entries */
 struct mpc_ioapic mp_ioapics[MAX_IO_APICS];
 int nr_ioapics;
+int boot_ioapic_idx;
 
 /* IO APIC gsi routing info */
 struct mp_ioapic_gsi  mp_gsi_routing[MAX_IO_APICS];
@@ -1473,9 +1474,9 @@ static struct {
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
@@ -1483,14 +1484,6 @@ static void __init setup_IO_APIC_irqs(void)
 
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
@@ -2008,6 +2001,21 @@ void __init enable_IO_APIC(void)
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
@@ -3126,7 +3134,6 @@ out:
 
 void __init setup_IO_APIC(void)
 {
-
 	/*
 	 * calling enable_IO_APIC() is moved to setup_local_APIC for BP
 	 */
@@ -3139,7 +3146,8 @@ void __init setup_IO_APIC(void)
 	x86_init.mpparse.setup_ioapic_ids();
 
 	sync_Arb_IDs();
-	setup_IO_APIC_irqs();
+	probe_ioapic_i8259();
+	setup_IO_APIC_irqs(boot_ioapic_idx);
 	init_IO_APIC_traps();
 	if (nr_legacy_irqs)
 		check_timer();
