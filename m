Return-Path: <linux-kernel-owner+w=401wt.eu-S1757951AbZEKJyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757951AbZEKJyi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 05:54:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757905AbZEKJxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 05:53:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:53846 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757684AbZEKJxk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 05:53:40 -0400
Date: Mon, 11 May 2009 09:52:29 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, lenb@kernel.org, akpm@linux-foundation.org,
       jbarnes@virtuousgeek.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lenb@kernel.org, yinghai@kernel.org, jbarnes@virtuousgeek.org,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4A01C387.7090103@kernel.org>
References: <4A01C387.7090103@kernel.org>
Subject: [tip:irq/numa] x86/acpi: call mp_config_acpi_gsi() in mp_register_gsi()
Message-ID: <tip-a31f82057ce6f7ced578d64c07a72ccbdc7336e4@git.kernel.org>
Git-Commit-ID: a31f82057ce6f7ced578d64c07a72ccbdc7336e4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 11 May 2009 09:52:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a31f82057ce6f7ced578d64c07a72ccbdc7336e4
Gitweb:     http://git.kernel.org/tip/a31f82057ce6f7ced578d64c07a72ccbdc7336e4
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Wed, 6 May 2009 10:06:15 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 11 May 2009 10:35:08 +0200

x86/acpi: call mp_config_acpi_gsi() in mp_register_gsi()

The patch to call mp_config_acpi_gsi() from the ACPI IRQ registration
code never got mainline because there were open discussions about it.

This call is needed to properly update the kernel's copy of the mptable,
when the update_mptable boot parameter is needed.

Now that the dust has settled with the APIC unification, and since there
were no objections when the patch was re-submitted, try this again.

[ Impact: fix the update_mptable boot parameter ]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Len Brown <lenb@kernel.org>
LKML-Reference: <4A01C387.7090103@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/mpspec.h |    9 -----
 arch/x86/kernel/acpi/boot.c   |   66 +++++++++++++++++++++++++----------------
 2 files changed, 40 insertions(+), 35 deletions(-)

diff --git a/arch/x86/include/asm/mpspec.h b/arch/x86/include/asm/mpspec.h
index 3ea1f53..c34961a 100644
--- a/arch/x86/include/asm/mpspec.h
+++ b/arch/x86/include/asm/mpspec.h
@@ -77,17 +77,8 @@ extern int mp_register_gsi(struct device *dev, u32 gsi, int edge_level,
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
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index fb5e882..8019ecf 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -33,6 +33,7 @@
 #include <linux/irq.h>
 #include <linux/bootmem.h>
 #include <linux/ioport.h>
+#include <linux/pci.h>
 
 #include <asm/pgtable.h>
 #include <asm/io_apic.h>
@@ -1158,6 +1159,44 @@ void __init mp_config_acpi_legacy_irqs(void)
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
@@ -1189,6 +1228,7 @@ int mp_register_gsi(struct device *dev, u32 gsi, int triggering, int polarity)
 		       ioapic_pin);
 		return gsi;
 	}
+	mp_config_acpi_gsi(dev, gsi, triggering, polarity);
 
 	/*
 	 * Avoid pin reprogramming.  PRTs typically include entries
@@ -1208,32 +1248,6 @@ int mp_register_gsi(struct device *dev, u32 gsi, int triggering, int polarity)
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
