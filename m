Return-Path: <linux-kernel-owner+w=401wt.eu-S966665AbXEGUd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966665AbXEGUd5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 16:33:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966660AbXEGUdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 16:33:54 -0400
Received: from mga03.intel.com ([143.182.124.21]:61747 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966659AbXEGUdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 16:33:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,502,1170662400"; 
   d="scan'208";a="225363038"
Date: Mon, 7 May 2007 13:31:28 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [PATCH 4/8] Force detect and enable HPET on ICH
Message-ID: <20070507203128.GD3926@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Force detect and/or enable HPET on ICH chipsets. This patch just handles the
detection part and following patches use this information.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

Index: linux-2.6.21-rc-mm-hpet/arch/i386/kernel/quirks.c
===================================================================
--- linux-2.6.21-rc-mm-hpet.orig/arch/i386/kernel/quirks.c	2007-02-04 10:44:54.000000000 -0800
+++ linux-2.6.21-rc-mm-hpet/arch/i386/kernel/quirks.c	2007-04-18 11:08:43.000000000 -0700
@@ -6,6 +6,7 @@
 #include <asm/pci-direct.h>
 #include <asm/genapic.h>
 #include <asm/cpu.h>
+#include <asm/hpet.h>
 
 #if defined(CONFIG_X86_IO_APIC) && defined(CONFIG_SMP) && defined(CONFIG_PCI)
 static void __devinit verify_quirk_intel_irqbalance(struct pci_dev *dev)
@@ -97,3 +98,125 @@
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,   PCI_DEVICE_ID_INTEL_E7520_MCH,  verify_quirk_intel_irqbalance);
 
 #endif
+
+#if defined(CONFIG_HPET_TIMER)
+unsigned long force_hpet_address;
+
+static void __iomem *rcba_base;
+
+#ifdef CONFIG_PM
+static int force_hpet_resume(struct sys_device *sys_device)
+{
+	u32 val;
+
+	if (!force_hpet_address)
+		return 0;
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
+	return 0;
+}
+
+static struct sysdev_class force_hpet_class = {
+	set_kset_name("force_hpet"),
+	.resume		= force_hpet_resume,
+};
+
+static struct sys_device force_hpet_device = {
+	.id		= 0,
+	.cls		= &force_hpet_class,
+};
+#endif
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
+
+#ifdef CONFIG_PM
+		/* We need to rewrite the PCI space on S3 resume */
+		err = sysdev_class_register(&force_hpet_class);
+		if (!err) {
+			err = sysdev_register(&force_hpet_device);
+			if (err) {
+				sysdev_class_unregister(&force_hpet_class);
+			}
+		}
+#endif
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
