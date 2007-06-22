Return-Path: <linux-kernel-owner+w=401wt.eu-S1756228AbXFVUpB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228AbXFVUpB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 16:45:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751175AbXFVUoy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 16:44:54 -0400
Received: from mga03.intel.com ([143.182.124.21]:26993 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337AbXFVUox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 16:44:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,452,1175497200"; 
   d="scan'208";a="242277011"
Date: Fri, 22 Jun 2007 13:40:30 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3/7] ICH Force HPET: ICH7 or later quirk to force detect enable
Message-ID: <20070622204030.GC22807@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Force detect and/or enable HPET on ICH chipsets. This patch just handles the
detection part and following patches use this information. Adds a function
to repeat the force enabling during resume time.

Using HPET this way, instead of PIT increases the time CPUs can
reside in C-state when system is totally idle. On my test system with
Core 2 Duo, average C-state residency goes up from ~20mS to ~80mS.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

---
 arch/i386/kernel/quirks.c |  101 ++++++++++++++++++++++++++++++++++++++++++++++
 include/asm-i386/hpet.h   |    2 
 2 files changed, 103 insertions(+)

Index: linux-2.6.22-rc5/arch/i386/kernel/quirks.c
===================================================================
--- linux-2.6.22-rc5.orig/arch/i386/kernel/quirks.c	2007-06-17 08:51:58.000000000 +0200
+++ linux-2.6.22-rc5/arch/i386/kernel/quirks.c	2007-06-17 08:52:10.000000000 +0200
@@ -4,6 +4,8 @@
 #include <linux/pci.h>
 #include <linux/irq.h>
 
+#include <asm/hpet.h>
+
 #if defined(CONFIG_X86_IO_APIC) && defined(CONFIG_SMP) && defined(CONFIG_PCI)
 
 static void __devinit quirk_intel_irqbalance(struct pci_dev *dev)
@@ -48,3 +50,102 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_IN
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_E7525_MCH,	quirk_intel_irqbalance);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_E7520_MCH,	quirk_intel_irqbalance);
 #endif
+
+#if defined(CONFIG_HPET_TIMER)
+unsigned long force_hpet_address;
+
+static void __iomem *rcba_base;
+
+void ich_force_hpet_resume(void)
+{
+	u32 val;
+
+	if (!force_hpet_address)
+		return;
+
+	if (rcba_base == NULL)
+		BUG();
+
+	/* read the Function Disable register, dword mode only */
+	val = readl(rcba_base + 0x3404);
+	if (!(val & 0x80)) {
+		/* HPET disabled in HPTC. Trying to enable */
+		writel(val | 0x80, rcba_base + 0x3404);
+	}
+
+	val = readl(rcba_base + 0x3404);
+	if (!(val & 0x80))
+		BUG();
+	else
+		printk(KERN_DEBUG "Force enabled HPET at resume\n");
+
+	return;
+}
+
+static void ich_force_enable_hpet(struct pci_dev *dev)
+{
+	u32 val, rcba;
+	int err = 0;
+
+	if (hpet_address || force_hpet_address)
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
+	rcba_base = ioremap_nocache(rcba, 0x4000);
+	if (rcba_base == NULL) {
+		printk(KERN_DEBUG "ioremap failed. Cannot force enable HPET\n");
+		return;
+	}
+
+	/* read the Function Disable register, dword mode only */
+	val = readl(rcba_base + 0x3404);
+
+	if (val & 0x80) {
+		/* HPET is enabled in HPTC. Just not reported by BIOS */
+		val = val & 0x3;
+		force_hpet_address = 0xFED00000 | (val << 12);
+		printk(KERN_DEBUG "Force enabled HPET at base address 0x%lx\n",
+			       force_hpet_address);
+		iounmap(rcba_base);
+		return;
+	}
+
+	/* HPET disabled in HPTC. Trying to enable */
+	writel(val | 0x80, rcba_base + 0x3404);
+
+	val = readl(rcba_base + 0x3404);
+	if (!(val & 0x80)) {
+		err = 1;
+	} else {
+		val = val & 0x3;
+		force_hpet_address = 0xFED00000 | (val << 12);
+	}
+
+	if (err) {
+		force_hpet_address = 0;
+		iounmap(rcba_base);
+		printk(KERN_DEBUG "Failed to force enable HPET\n");
+	} else {
+		printk(KERN_DEBUG "Force enabled HPET at base address 0x%lx\n",
+			       force_hpet_address);
+	}
+}
+
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ESB2_0,
+                         ich_force_enable_hpet);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH6_1,
+                         ich_force_enable_hpet);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH7_1,
+                         ich_force_enable_hpet);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH7_31,
+                         ich_force_enable_hpet);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH8_1,
+                         ich_force_enable_hpet);
+#endif
Index: linux-2.6.22-rc5/include/asm-i386/hpet.h
===================================================================
--- linux-2.6.22-rc5.orig/include/asm-i386/hpet.h	2007-06-17 08:52:09.000000000 +0200
+++ linux-2.6.22-rc5/include/asm-i386/hpet.h	2007-06-17 08:52:10.000000000 +0200
@@ -72,6 +72,8 @@ extern int hpet_enable(void);
 #include <asm/vsyscall.h>
 #endif
 
+void ich_force_hpet_resume(void);
+
 #ifdef CONFIG_HPET_EMULATE_RTC
 
 #include <linux/interrupt.h>
