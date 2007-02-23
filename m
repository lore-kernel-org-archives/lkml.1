Return-Path: <linux-kernel-owner+w=401wt.eu-S1750696AbXBWBlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750696AbXBWBlm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 20:41:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751544AbXBWBlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 20:41:42 -0500
Received: from mga09.intel.com ([134.134.136.24]:2760 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696AbXBWBll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 20:41:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,208,1170662400"; 
   d="scan'208"; a="49742949:sNHT25037667"
Date: Thu, 22 Feb 2007 17:06:17 -0800
From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
To: linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 1/5] RT kernel: force detect HPET from PCI space
Message-ID: <20070222170616.A27455@unix-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Patchset enables force detection of HPET, when it is not listed by BIOS.
and enables use of HPET as a event source. HPET timers
configures in stamdard interrupt mode can be used as dependable per CPU timer
on laptops that are known to have LAPIC stoppage with ACPI C3 state.

Patch is against rt kernel (2.6.20-rt8) and patch enables only x86-64
right now.

This patch:

Detect HPET by looking at PCI space, even when BIOS does not list HPET
device. This is useful to use HPET as dependable per CPU timer with tickless
kernels.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

Index: linux-2.6.21-rc-mm/arch/i386/kernel/quirks.c
===================================================================
--- linux-2.6.21-rc-mm.orig/arch/i386/kernel/quirks.c
+++ linux-2.6.21-rc-mm/arch/i386/kernel/quirks.c
@@ -48,3 +48,58 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_IN
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_E7525_MCH,	quirk_intel_irqbalance);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_E7520_MCH,	quirk_intel_irqbalance);
 #endif
+
+#if defined(CONFIG_HPET_TIMER)
+unsigned long force_hpet_address;
+
+static void __init force_enable_hpet(struct pci_dev *dev)
+{
+	u32 val, rcba;
+	void __iomem *base;
+
+	if (hpet_address)
+		return;
+
+	pci_read_config_dword(dev, 0xF0, &rcba);
+	rcba &= 0xFFFFC000;
+	if (rcba == 0) {
+		printk(KERN_DEBUG "RCBA disabled. Cannot force enable HPET\n");
+		return;
+	}
+
+	/* use bits 31:14, 16 kB aligned */
+	base = ioremap_nocache(rcba, 0x4000);
+	if (base == NULL) {
+		printk(KERN_DEBUG "ioremap failed. Cannot force enable HPET\n");
+		return;
+	}
+
+	/* read the Function Disable register, dword mode only */
+	val = readl(base + 0x3404);
+
+	if (!(val & 0x80)) {
+		/* HPET disabled in HPTC. Trying to enable */
+		writel(val | 0x80, base + 0x3404);
+	}
+
+	val = readl(base + 0x3404);
+
+	if (!(val & 0x80)) {
+		printk(KERN_DEBUG "Failed to force enable HPET\n");
+	} else {
+		val = val & 0x3;
+		force_hpet_address = 0xFED00000 | (val << 12);
+		printk(KERN_DEBUG "Force enabled HPET. Base address 0x%x\n",
+			       force_hpet_address);
+	}
+
+	iounmap(base);
+}
+
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ESB2_0,     force_enable_hpet);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,   PCI_DEVICE_ID_INTEL_ICH6_1,     force_enable_hpet);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,   PCI_DEVICE_ID_INTEL_ICH7_1,     force_enable_hpet);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,   PCI_DEVICE_ID_INTEL_ICH7_31,     force_enable_hpet);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,   PCI_DEVICE_ID_INTEL_ICH8_1,     force_enable_hpet);
+#endif
+
Index: linux-2.6.21-rc-mm/include/asm-i386/hpet.h
===================================================================
--- linux-2.6.21-rc-mm.orig/include/asm-i386/hpet.h
+++ linux-2.6.21-rc-mm/include/asm-i386/hpet.h
@@ -91,6 +91,7 @@
 #define HPET_TICK_RATE  (HZ * 100000UL)
 
 extern unsigned long hpet_address;	/* hpet memory map physical address */
+extern unsigned long force_hpet_address;/* hpet memory detected by quirk */
 extern int is_hpet_enabled(void);
 
 #ifdef CONFIG_X86_64
Index: linux-2.6.21-rc-mm/include/asm-x86_64/hpet.h
===================================================================
--- linux-2.6.21-rc-mm.orig/include/asm-x86_64/hpet.h
+++ linux-2.6.21-rc-mm/include/asm-x86_64/hpet.h
@@ -63,6 +63,7 @@ extern unsigned int hpet_calibrate_tsc(v
 
 extern int hpet_use_timer;
 extern unsigned long hpet_address;
+extern unsigned long force_hpet_address;
 extern unsigned long hpet_period;
 extern unsigned long hpet_tick;
 
