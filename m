Return-Path: <linux-kernel-owner+w=401wt.eu-S1754287AbYJOKml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287AbYJOKml (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 06:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753207AbYJOKmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 06:42:32 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:44096 "EHLO
	SG2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195AbYJOKmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 06:42:31 -0400
X-BigFish: VPS5(z34a4lzzzzzz32i6bh66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0K8S0EF-02-0QW-01
Date: Wed, 15 Oct 2008 12:41:50 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: stable@kernel.org
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 1/2][stable] x86: SB450: skip IRQ0 override if it is not
	routed to INT2 of IOAPIC
Message-ID: <20081015104150.GB4706@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 15 Oct 2008 10:42:18.0758 (UTC) FILETIME=[B2528A60:01C92EB2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some HP nx6... laptops (e.g. nx6325) BIOS reports an IRQ0 override
but the SB450 chipset is configured such that timer interrupt goes INT0
of IOAPIC.

Check IRQ0 routing and if it is routed to INT0 of IOAPIC skip the
timer override.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/early-quirks.c |   48 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 48 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index 4353cf5..6b839b1 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -95,6 +95,52 @@ static void __init nvidia_bugs(int num, int slot, int func)
 
 }
 
+static u32 ati_ixp4x0_rev(int num, int slot, int func)
+{
+	u32 d;
+	u8  b;
+
+	b = read_pci_config_byte(num, slot, func, 0xac);
+	b &= ~(1<<5);
+	write_pci_config_byte(num, slot, func, 0xac, b);
+
+	d = read_pci_config(num, slot, func, 0x70);
+	d |= 1<<8;
+	write_pci_config(num, slot, func, 0x70, d);
+
+	d = read_pci_config(num, slot, func, 0x8);
+	d &= 0xff;
+	return d;
+}
+
+static void __init ati_bugs(int num, int slot, int func)
+{
+#if defined(CONFIG_ACPI) && defined (CONFIG_X86_IO_APIC)
+	u32 d;
+	u8  b;
+
+	if (acpi_use_timer_override)
+		return;
+
+	d = ati_ixp4x0_rev(num, slot, func);
+	if (d  < 0x82)
+		acpi_skip_timer_override = 1;
+	else {
+		/* check for IRQ0 interrupt swap */
+		outb(0x72, 0xcd6); b = inb(0xcd7);
+		if (!(b & 0x2))
+			acpi_skip_timer_override = 1;
+	}
+
+	if (acpi_skip_timer_override) {
+		printk(KERN_INFO "SB4X0 revision 0x%x\n", d);
+		printk(KERN_INFO "Ignoring ACPI timer override.\n");
+		printk(KERN_INFO "If you got timer trouble "
+		       "try acpi_use_timer_override\n");
+	}
+#endif
+}
+
 #define QFLAG_APPLY_ONCE 	0x1
 #define QFLAG_APPLIED		0x2
 #define QFLAG_DONE		(QFLAG_APPLY_ONCE|QFLAG_APPLIED)
@@ -114,6 +160,8 @@ static struct chipset early_qrk[] __initdata = {
 	  PCI_CLASS_BRIDGE_PCI, PCI_ANY_ID, QFLAG_APPLY_ONCE, via_bugs },
 	{ PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_K8_NB,
 	  PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, fix_hypertransport_config },
+	{ PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP400_SMBUS,
+	  PCI_CLASS_SERIAL_SMBUS, PCI_ANY_ID, 0, ati_bugs },
 	{}
 };
 
-- 
1.6.0.2



