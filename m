Return-Path: <linux-kernel-owner+w=401wt.eu-S1759411AbZEFRIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759411AbZEFRIQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 13:08:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754459AbZEFRH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 13:07:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:38604 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751733AbZEFRH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 13:07:56 -0400
Message-ID: <4A01C387.7090103@kernel.org>
Date: Wed, 06 May 2009 10:06:15 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: [PATCH 2/7] x86/acpi: calling mp_config_acpi_gsi in mp_register_gsi
 -v2
References: <4A01C35C.7060207@kernel.org>
In-Reply-To: <4A01C35C.7060207@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


it seems that change about calling mp_config_acpi_gsi in acpi_pci_irq_enable()
never get into mainline.

actually we could call that in mp_register_gsi with struct device...
also could make mp_config_acpi_gsi to be static

v2: some calling could have to be pci device, need to check that

[Impact: make update_mptable working]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/mpspec.h |    9 -----
 arch/x86/kernel/acpi/boot.c   |   66 +++++++++++++++++++++++++-----------------
 2 files changed, 40 insertions(+), 35 deletions(-)

Index: linux-2.6/arch/x86/include/asm/mpspec.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/mpspec.h
+++ linux-2.6/arch/x86/include/asm/mpspec.h
@@ -77,17 +77,8 @@ extern int mp_register_gsi(struct device
 				 int active_high_low);
 extern int acpi_probe_gsi(void);
 #ifdef CONFIG_X86_IO_APIC
-extern int mp_config_acpi_gsi(unsigned char number, unsigned int devfn, u8 pin,
-				u32 gsi, int triggering, int polarity);
 extern int mp_find_ioapic(int gsi);
 extern int mp_find_ioapic_pin(int ioapic, int gsi);
-#else
-static inline int
-mp_config_acpi_gsi(unsigned char number, unsigned int devfn, u8 pin,
-		   u32 gsi, int triggering, int polarity)
-{
-	return 0;
-}
 #endif
 #else /* !CONFIG_ACPI: */
 static inline int acpi_probe_gsi(void)
Index: linux-2.6/arch/x86/kernel/acpi/boot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/acpi/boot.c
+++ linux-2.6/arch/x86/kernel/acpi/boot.c
@@ -33,6 +33,7 @@
 #include <linux/irq.h>
 #include <linux/bootmem.h>
 #include <linux/ioport.h>
+#include <linux/pci.h>
 
 #include <asm/pgtable.h>
 #include <asm/io_apic.h>
@@ -1158,6 +1159,44 @@ void __init mp_config_acpi_legacy_irqs(v
 	}
 }
 
+static int mp_config_acpi_gsi(struct device *dev, u32 gsi, int triggering,
+			int polarity)
+{
+#ifdef CONFIG_X86_MPPARSE
+	struct mpc_intsrc mp_irq;
+	struct pci_dev *pdev;
+	unsigned char number;
+	unsigned int devfn;
+	int ioapic;
+	u8 pin;
+
+	if (!acpi_ioapic)
+		return 0;
+	if (!dev)
+		return 0;
+	if (dev->bus != &pci_bus_type)
+		return 0;
+
+	pdev = to_pci_dev(dev);
+	number = pdev->bus->number;
+	devfn = pdev->devfn;
+	pin = pdev->pin;
+	/* print the entry should happen on mptable identically */
+	mp_irq.type = MP_INTSRC;
+	mp_irq.irqtype = mp_INT;
+	mp_irq.irqflag = (triggering == ACPI_EDGE_SENSITIVE ? 4 : 0x0c) |
+				(polarity == ACPI_ACTIVE_HIGH ? 1 : 3);
+	mp_irq.srcbus = number;
+	mp_irq.srcbusirq = (((devfn >> 3) & 0x1f) << 2) | ((pin - 1) & 3);
+	ioapic = mp_find_ioapic(gsi);
+	mp_irq.dstapic = mp_ioapic_routing[ioapic].apic_id;
+	mp_irq.dstirq = mp_find_ioapic_pin(ioapic, gsi);
+
+	save_mp_irq(&mp_irq);
+#endif
+	return 0;
+}
+
 int mp_register_gsi(struct device *dev, u32 gsi, int triggering, int polarity)
 {
 	int ioapic;
@@ -1189,6 +1228,7 @@ int mp_register_gsi(struct device *dev,
 		       ioapic_pin);
 		return gsi;
 	}
+	mp_config_acpi_gsi(dev, gsi, triggering, polarity);
 
 	/*
 	 * Avoid pin reprogramming.  PRTs typically include entries
@@ -1208,32 +1248,6 @@ int mp_register_gsi(struct device *dev,
 	return gsi;
 }
 
-int mp_config_acpi_gsi(unsigned char number, unsigned int devfn, u8 pin,
-			u32 gsi, int triggering, int polarity)
-{
-#ifdef CONFIG_X86_MPPARSE
-	struct mpc_intsrc mp_irq;
-	int ioapic;
-
-	if (!acpi_ioapic)
-		return 0;
-
-	/* print the entry should happen on mptable identically */
-	mp_irq.type = MP_INTSRC;
-	mp_irq.irqtype = mp_INT;
-	mp_irq.irqflag = (triggering == ACPI_EDGE_SENSITIVE ? 4 : 0x0c) |
-				(polarity == ACPI_ACTIVE_HIGH ? 1 : 3);
-	mp_irq.srcbus = number;
-	mp_irq.srcbusirq = (((devfn >> 3) & 0x1f) << 2) | ((pin - 1) & 3);
-	ioapic = mp_find_ioapic(gsi);
-	mp_irq.dstapic = mp_ioapic_routing[ioapic].apic_id;
-	mp_irq.dstirq = mp_find_ioapic_pin(ioapic, gsi);
-
-	save_mp_irq(&mp_irq);
-#endif
-	return 0;
-}
-
 /*
  * Parse IOAPIC related entries in MADT
  * returns 0 on success, < 0 on error
