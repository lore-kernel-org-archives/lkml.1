Return-Path: <linux-kernel-owner+w=401wt.eu-S1757813AbZEKJxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757813AbZEKJxd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 05:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755711AbZEKJxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 05:53:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:53811 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755129AbZEKJxU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 05:53:20 -0400
Date: Mon, 11 May 2009 09:52:08 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, lenb@kernel.org, akpm@linux-foundation.org,
       jbarnes@virtuousgeek.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lenb@kernel.org, yinghai@kernel.org, jbarnes@virtuousgeek.org,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4A01C35C.7060207@kernel.org>
References: <4A01C35C.7060207@kernel.org>
Subject: [tip:irq/numa] x86/acpi: remove irq-compression trick on 32-bit
Message-ID: <tip-b9e0353fc85dab4ef5ebcef2bd09ebc4ce6d5a7b@git.kernel.org>
Git-Commit-ID: b9e0353fc85dab4ef5ebcef2bd09ebc4ce6d5a7b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 11 May 2009 09:52:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b9e0353fc85dab4ef5ebcef2bd09ebc4ce6d5a7b
Gitweb:     http://git.kernel.org/tip/b9e0353fc85dab4ef5ebcef2bd09ebc4ce6d5a7b
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Wed, 6 May 2009 10:05:32 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 11 May 2009 10:35:06 +0200

x86/acpi: remove irq-compression trick on 32-bit

We already have a per cpu vector on 32-bit via recent changes, and
don't need this trick any more (which trick obfuscates the real GSI
mappings and which only triggers on larger systems to begin with):

On 3 ioapic system (24 per ioapic) before patch I got:

ACPI: PCI Interrupt Link [ILSB] enabled at IRQ 71
IOAPIC[2]: Set routing entry (10-23 -> 0xa9 -> IRQ 64 Mode:1 Active:1)
pci 0000:80:01.1: PCI INT A -> Link[ILSB] -> GSI 71 (level, low) -> IRQ 64
ACPI: PCI Interrupt Link [LE5B] enabled at IRQ 67
IOAPIC[2]: Set routing entry (10-19 -> 0xb1 -> IRQ 65 Mode:1 Active:1)
pci 0000:83:00.0: PCI INT B -> Link[LE5B] -> GSI 67 (level, low) -> IRQ 65
ACPI: PCI Interrupt Link [LE5A] enabled at IRQ 66
IOAPIC[2]: Set routing entry (10-18 -> 0xb9 -> IRQ 66 Mode:1 Active:1)
pci 0000:83:00.1: PCI INT A -> Link[LE5A] -> GSI 66 (level, low) -> IRQ 66
ACPI: PCI Interrupt Link [LE5D] enabled at IRQ 65
IOAPIC[2]: Set routing entry (10-17 -> 0xc1 -> IRQ 67 Mode:1 Active:1)
pci 0000:84:00.0: PCI INT B -> Link[LE5D] -> GSI 65 (level, low) -> IRQ 67
ACPI: PCI Interrupt Link [LE5C] enabled at IRQ 64
IOAPIC[2]: Set routing entry (10-16 -> 0xc9 -> IRQ 68 Mode:1 Active:1)
pci 0000:84:00.1: PCI INT A -> Link[LE5C] -> GSI 64 (level, low) -> IRQ 68
pci 0000:87:00.0: PCI INT B -> Link[LE5A] -> GSI 66 (level, low) -> IRQ 66
pci 0000:87:00.1: PCI INT A -> Link[LE5D] -> GSI 65 (level, low) -> IRQ 67
pci 0000:88:00.0: PCI INT B -> Link[LE5C] -> GSI 64 (level, low) -> IRQ 68
pci 0000:88:00.1: PCI INT A -> Link[LE5B] -> GSI 67 (level, low) -> IRQ 65
pci 0000:8b:00.0: PCI INT B -> Link[LE5A] -> GSI 66 (level, low) -> IRQ 66
pci 0000:8b:00.1: PCI INT A -> Link[LE5D] -> GSI 65 (level, low) -> IRQ 67
pci 0000:8c:00.0: PCI INT B -> Link[LE5C] -> GSI 64 (level, low) -> IRQ 68
pci 0000:8c:00.1: PCI INT A -> Link[LE5B] -> GSI 67 (level, low) -> IRQ 65

after the patch we get:

ACPI: PCI Interrupt Link [ILSB] enabled at IRQ 71
IOAPIC[2]: Set routing entry (10-23 -> 0xa9 -> IRQ 71 Mode:1 Active:1)
pci 0000:80:01.1: PCI INT A -> Link[ILSB] -> GSI 71 (level, low) -> IRQ 71
ACPI: PCI Interrupt Link [LE5B] enabled at IRQ 67
IOAPIC[2]: Set routing entry (10-19 -> 0xb1 -> IRQ 67 Mode:1 Active:1)
pci 0000:83:00.0: PCI INT B -> Link[LE5B] -> GSI 67 (level, low) -> IRQ 67
ACPI: PCI Interrupt Link [LE5A] enabled at IRQ 66
IOAPIC[2]: Set routing entry (10-18 -> 0xb9 -> IRQ 66 Mode:1 Active:1)
pci 0000:83:00.1: PCI INT A -> Link[LE5A] -> GSI 66 (level, low) -> IRQ 66
ACPI: PCI Interrupt Link [LE5D] enabled at IRQ 65
IOAPIC[2]: Set routing entry (10-17 -> 0xc1 -> IRQ 65 Mode:1 Active:1)
pci 0000:84:00.0: PCI INT B -> Link[LE5D] -> GSI 65 (level, low) -> IRQ 65
ACPI: PCI Interrupt Link [LE5C] enabled at IRQ 64
IOAPIC[2]: Set routing entry (10-16 -> 0xc9 -> IRQ 64 Mode:1 Active:1)
pci 0000:84:00.1: PCI INT A -> Link[LE5C] -> GSI 64 (level, low) -> IRQ 64
pci 0000:87:00.0: PCI INT B -> Link[LE5A] -> GSI 66 (level, low) -> IRQ 66
pci 0000:87:00.1: PCI INT A -> Link[LE5D] -> GSI 65 (level, low) -> IRQ 65
pci 0000:88:00.0: PCI INT B -> Link[LE5C] -> GSI 64 (level, low) -> IRQ 64
pci 0000:88:00.1: PCI INT A -> Link[LE5B] -> GSI 67 (level, low) -> IRQ 67
pci 0000:8b:00.0: PCI INT B -> Link[LE5A] -> GSI 66 (level, low) -> IRQ 66
pci 0000:8b:00.1: PCI INT A -> Link[LE5D] -> GSI 65 (level, low) -> IRQ 65
pci 0000:8c:00.0: PCI INT B -> Link[LE5C] -> GSI 64 (level, low) -> IRQ 64
pci 0000:8c:00.1: PCI INT A -> Link[LE5B] -> GSI 67 (level, low) -> IRQ 67

As it can be seen that GSIs now get mapped lineary.

[ Impact: simplify irq number mapping on bigger 32-bit systems ]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Len Brown <lenb@kernel.org>
LKML-Reference: <4A01C35C.7060207@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/acpi/boot.c |   65 ++++--------------------------------------
 1 files changed, 7 insertions(+), 58 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 6ee96b5..fb5e882 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -1162,22 +1162,9 @@ int mp_register_gsi(struct device *dev, u32 gsi, int triggering, int polarity)
 {
 	int ioapic;
 	int ioapic_pin;
-#ifdef CONFIG_X86_32
-#define MAX_GSI_NUM	4096
-#define IRQ_COMPRESSION_START	64
-
-	static int pci_irq = IRQ_COMPRESSION_START;
-	/*
-	 * Mapping between Global System Interrupts, which
-	 * represent all possible interrupts, and IRQs
-	 * assigned to actual devices.
-	 */
-	static int gsi_to_irq[MAX_GSI_NUM];
-#else
 
 	if (acpi_irq_model != ACPI_IRQ_MODEL_IOAPIC)
 		return gsi;
-#endif
 
 	/* Don't set up the ACPI SCI because it's already set up */
 	if (acpi_gbl_FADT.sci_interrupt == gsi)
@@ -1196,66 +1183,28 @@ int mp_register_gsi(struct device *dev, u32 gsi, int triggering, int polarity)
 		gsi = ioapic_renumber_irq(ioapic, gsi);
 #endif
 
-	/*
-	 * Avoid pin reprogramming.  PRTs typically include entries
-	 * with redundant pin->gsi mappings (but unique PCI devices);
-	 * we only program the IOAPIC on the first.
-	 */
 	if (ioapic_pin > MP_MAX_IOAPIC_PIN) {
 		printk(KERN_ERR "Invalid reference to IOAPIC pin "
 		       "%d-%d\n", mp_ioapic_routing[ioapic].apic_id,
 		       ioapic_pin);
 		return gsi;
 	}
+
+	/*
+	 * Avoid pin reprogramming.  PRTs typically include entries
+	 * with redundant pin->gsi mappings (but unique PCI devices);
+	 * we only program the IOAPIC on the first.
+	 */
 	if (test_bit(ioapic_pin, mp_ioapic_routing[ioapic].pin_programmed)) {
 		pr_debug("Pin %d-%d already programmed\n",
 			 mp_ioapic_routing[ioapic].apic_id, ioapic_pin);
-#ifdef CONFIG_X86_32
-		return (gsi < IRQ_COMPRESSION_START ? gsi : gsi_to_irq[gsi]);
-#else
 		return gsi;
-#endif
 	}
-
 	set_bit(ioapic_pin, mp_ioapic_routing[ioapic].pin_programmed);
-#ifdef CONFIG_X86_32
-	/*
-	 * For GSI >= 64, use IRQ compression
-	 */
-	if ((gsi >= IRQ_COMPRESSION_START)
-	    && (triggering == ACPI_LEVEL_SENSITIVE)) {
-		/*
-		 * For PCI devices assign IRQs in order, avoiding gaps
-		 * due to unused I/O APIC pins.
-		 */
-		int irq = gsi;
-		if (gsi < MAX_GSI_NUM) {
-			/*
-			 * Retain the VIA chipset work-around (gsi > 15), but
-			 * avoid a problem where the 8254 timer (IRQ0) is setup
-			 * via an override (so it's not on pin 0 of the ioapic),
-			 * and at the same time, the pin 0 interrupt is a PCI
-			 * type.  The gsi > 15 test could cause these two pins
-			 * to be shared as IRQ0, and they are not shareable.
-			 * So test for this condition, and if necessary, avoid
-			 * the pin collision.
-			 */
-			gsi = pci_irq++;
-			/*
-			 * Don't assign IRQ used by ACPI SCI
-			 */
-			if (gsi == acpi_gbl_FADT.sci_interrupt)
-				gsi = pci_irq++;
-			gsi_to_irq[irq] = gsi;
-		} else {
-			printk(KERN_ERR "GSI %u is too high\n", gsi);
-			return gsi;
-		}
-	}
-#endif
 	io_apic_set_pci_routing(dev, ioapic, ioapic_pin, gsi,
 				triggering == ACPI_EDGE_SENSITIVE ? 0 : 1,
 				polarity == ACPI_ACTIVE_HIGH ? 0 : 1);
+
 	return gsi;
 }
 
