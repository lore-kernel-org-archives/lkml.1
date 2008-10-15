Return-Path: <linux-kernel-owner+w=401wt.eu-S1752501AbYJOKnD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501AbYJOKnD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 06:43:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752207AbYJOKmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 06:42:51 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:61274 "EHLO
	WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189AbYJOKmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 06:42:50 -0400
X-BigFish: VPS5(z34a4lzzzzzz32i6bh64h)
X-Spam-TCS-SCL: 3:0
X-FB-SS: 5,
X-WSS-ID: 0K8S0F3-01-L1L-01
Date: Wed, 15 Oct 2008 12:42:16 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: stable@kernel.org
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/2][stable] x86: SB600: skip IRQ0 override if it is not
	routed to INT2 of IOAPIC
Message-ID: <20081015104216.GC4706@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 15 Oct 2008 10:42:40.0477 (UTC) FILETIME=[BF4498D0:01C92EB2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some more HP laptops BIOS reports an IRQ0 override
but the SB600 chipset is configured such that timer
interrupts go to INT0 of IOAPIC.

Check IRQ0 routing and if it is routed to INT0 of IOAPIC skip the
timer override.

See following bug reports:
http://bugzilla.kernel.org/show_bug.cgi?id=11715
http://bugzilla.kernel.org/show_bug.cgi?id=11516

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/early-quirks.c |   55 +++++++++++++++++++++++++++++++++++++--
 1 files changed, 52 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index 733c4f8..3ce029f 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -95,7 +95,8 @@ static void __init nvidia_bugs(int num, int slot, int func)
 
 }
 
-static u32 ati_ixp4x0_rev(int num, int slot, int func)
+#if defined(CONFIG_ACPI) && defined(CONFIG_X86_IO_APIC)
+static u32 __init ati_ixp4x0_rev(int num, int slot, int func)
 {
 	u32 d;
 	u8  b;
@@ -115,7 +116,6 @@ static u32 ati_ixp4x0_rev(int num, int slot, int func)
 
 static void __init ati_bugs(int num, int slot, int func)
 {
-#if defined(CONFIG_ACPI) && defined (CONFIG_X86_IO_APIC)
 	u32 d;
 	u8  b;
 
@@ -138,9 +138,56 @@ static void __init ati_bugs(int num, int slot, int func)
 		printk(KERN_INFO "If you got timer trouble "
 		       "try acpi_use_timer_override\n");
 	}
-#endif
 }
 
+static u32 __init ati_sbx00_rev(int num, int slot, int func)
+{
+	u32 old, d;
+
+	d = read_pci_config(num, slot, func, 0x70);
+	old = d;
+	d &= ~(1<<8);
+	write_pci_config(num, slot, func, 0x70, d);
+	d = read_pci_config(num, slot, func, 0x8);
+	d &= 0xff;
+	write_pci_config(num, slot, func, 0x70, old);
+
+	return d;
+}
+
+static void __init ati_bugs_contd(int num, int slot, int func)
+{
+	u32 d, rev;
+
+	if (acpi_use_timer_override)
+		return;
+
+	rev = ati_sbx00_rev(num, slot, func);
+	if (rev > 0x13)
+		return;
+
+	/* check for IRQ0 interrupt swap */
+	d = read_pci_config(num, slot, func, 0x64);
+	if (!(d & (1<<14)))
+		acpi_skip_timer_override = 1;
+
+	if (acpi_skip_timer_override) {
+		printk(KERN_INFO "SB600 revision 0x%x\n", rev);
+		printk(KERN_INFO "Ignoring ACPI timer override.\n");
+		printk(KERN_INFO "If you got timer trouble "
+		       "try acpi_use_timer_override\n");
+	}
+}
+#else
+static void __init ati_bugs(int num, int slot, int func)
+{
+}
+
+static void __init ati_bugs_contd(int num, int slot, int func)
+{
+}
+#endif
+
 #ifdef CONFIG_DMAR
 static void __init intel_g33_dmar(int num, int slot, int func)
 {
@@ -176,6 +223,8 @@ static struct chipset early_qrk[] __initdata = {
 	  PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, fix_hypertransport_config },
 	{ PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP400_SMBUS,
 	  PCI_CLASS_SERIAL_SMBUS, PCI_ANY_ID, 0, ati_bugs },
+	{ PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_SBX00_SMBUS,
+	  PCI_CLASS_SERIAL_SMBUS, PCI_ANY_ID, 0, ati_bugs_contd },
 #ifdef CONFIG_DMAR
 	{ PCI_VENDOR_ID_INTEL, 0x29c0,
 	  PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, intel_g33_dmar },
-- 
1.6.0.2



