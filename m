Return-Path: <linux-kernel-owner+w=401wt.eu-S933074AbZAPLpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933074AbZAPLpf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 06:45:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759645AbZAPLp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 06:45:26 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:49636 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759449AbZAPLpZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 06:45:25 -0500
Message-Id: <4970818A.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Fri, 16 Jan 2009 11:46:02 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: fully honor "nolapic" (take 2)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"nolapic" should not only suppress SMP and use of the LAPIC, but it
also ought to have the effect of disabling all IO-APIC related activity
as well as PCI MSI and HT-IRQs.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/kernel/apic.c    |    9 ++++++++-
 arch/x86/kernel/io_apic.c |    6 ++++++
 arch/x86/kernel/smpboot.c |    1 +
 3 files changed, 13 insertions(+), 1 deletion(-)

--- linux-2.6.29-rc1/arch/x86/kernel/apic.c	2009-01-14 11:36:05.000000000 +0100
+++ 2.6.29-rc1-x86-no-lapic/arch/x86/kernel/apic.c	2009-01-16 11:57:45.000000000 +0100
@@ -1125,6 +1125,13 @@ void __cpuinit setup_local_APIC(void)
 	unsigned int value;
 	int i, j;
 
+	if (disable_apic) {
+#ifdef CONFIG_X86_IO_APIC
+		disable_ioapic_setup();
+#endif
+		return;
+	}
+
 #ifdef CONFIG_X86_32
 	/* Pound the ESR really hard over the head with a big hammer - mbligh */
 	if (lapic_is_integrated() && esr_disable) {
@@ -1565,11 +1570,11 @@ int apic_version[MAX_APICS];
 
 int __init APIC_init_uniprocessor(void)
 {
-#ifdef CONFIG_X86_64
 	if (disable_apic) {
 		pr_info("Apic disabled\n");
 		return -1;
 	}
+#ifdef CONFIG_X86_64
 	if (!cpu_has_apic) {
 		disable_apic = 1;
 		pr_info("Apic disabled by BIOS\n");
--- linux-2.6.29-rc1/arch/x86/kernel/io_apic.c	2009-01-14 11:36:05.000000000 +0100
+++ 2.6.29-rc1-x86-no-lapic/arch/x86/kernel/io_apic.c	2009-01-13 15:05:37.000000000 +0100
@@ -3258,6 +3258,9 @@ static int msi_compose_msg(struct pci_de
 	int err;
 	unsigned dest;
 
+	if (disable_apic)
+		return -ENXIO;
+
 	cfg = irq_cfg(irq);
 	err = assign_irq_vector(irq, cfg, TARGET_CPUS);
 	if (err)
@@ -3726,6 +3729,9 @@ int arch_setup_ht_irq(unsigned int irq, 
 	struct irq_cfg *cfg;
 	int err;
 
+	if (disable_apic)
+		return -ENXIO;
+
 	cfg = irq_cfg(irq);
 	err = assign_irq_vector(irq, cfg, TARGET_CPUS);
 	if (!err) {
--- linux-2.6.29-rc1/arch/x86/kernel/smpboot.c	2009-01-14 11:36:05.000000000 +0100
+++ 2.6.29-rc1-x86-no-lapic/arch/x86/kernel/smpboot.c	2009-01-14 09:14:16.000000000 +0100
@@ -1125,6 +1125,7 @@ static int __init smp_sanity_check(unsig
 		printk(KERN_ERR "... forcing use of dummy APIC emulation."
 				"(tell your hw vendor)\n");
 		smpboot_clear_io_apic();
+		disable_ioapic_setup();
 		return -1;
 	}
 



