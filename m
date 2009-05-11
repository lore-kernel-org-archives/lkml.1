Return-Path: <linux-kernel-owner+w=401wt.eu-S1757590AbZEKJzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757590AbZEKJzk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 05:55:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757967AbZEKJyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 05:54:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:53897 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757937AbZEKJyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 05:54:04 -0400
Date: Mon, 11 May 2009 09:52:39 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, lenb@kernel.org, akpm@linux-foundation.org,
       jbarnes@virtuousgeek.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lenb@kernel.org, yinghai@kernel.org, jbarnes@virtuousgeek.org,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4A01C3DD.3050104@kernel.org>
References: <4A01C3DD.3050104@kernel.org>
Subject: [tip:irq/numa] x86/acpi: move pin_programmed bit map to io_apic.c
Message-ID: <tip-bdfe8ac153546537ed24de69610ea781a734f785@git.kernel.org>
Git-Commit-ID: bdfe8ac153546537ed24de69610ea781a734f785
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 11 May 2009 09:52:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bdfe8ac153546537ed24de69610ea781a734f785
Gitweb:     http://git.kernel.org/tip/bdfe8ac153546537ed24de69610ea781a734f785
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Wed, 6 May 2009 10:07:41 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 11 May 2009 10:35:08 +0200

x86/acpi: move pin_programmed bit map to io_apic.c

Prepare to call setup_io_apic_routing() in pcibios_irq_enable()
also remove not needed member apic_id.

[ Impact: clean up, prepare for future change ]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Len Brown <lenb@kernel.org>
LKML-Reference: <4A01C3DD.3050104@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/acpi/boot.c    |   18 ++----------------
 arch/x86/kernel/apic/io_apic.c |   25 ++++++++++++++++++++++++-
 2 files changed, 26 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 8019ecf..dcfbc3a 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -904,10 +904,8 @@ extern int es7000_plat;
 #endif
 
 static struct {
-	int apic_id;
 	int gsi_base;
 	int gsi_end;
-	DECLARE_BITMAP(pin_programmed, MP_MAX_IOAPIC_PIN + 1);
 } mp_ioapic_routing[MAX_IO_APICS];
 
 int mp_find_ioapic(int gsi)
@@ -996,7 +994,6 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 	 * Build basic GSI lookup table to facilitate gsi->io_apic lookups
 	 * and to prevent reprogramming of IOAPIC pins (PCI GSIs).
 	 */
-	mp_ioapic_routing[idx].apic_id = mp_ioapics[idx].apicid;
 	mp_ioapic_routing[idx].gsi_base = gsi_base;
 	mp_ioapic_routing[idx].gsi_end = gsi_base +
 	    io_apic_get_redir_entries(idx);
@@ -1189,7 +1186,7 @@ static int mp_config_acpi_gsi(struct device *dev, u32 gsi, int triggering,
 	mp_irq.srcbus = number;
 	mp_irq.srcbusirq = (((devfn >> 3) & 0x1f) << 2) | ((pin - 1) & 3);
 	ioapic = mp_find_ioapic(gsi);
-	mp_irq.dstapic = mp_ioapic_routing[ioapic].apic_id;
+	mp_irq.dstapic = mp_ioapics[ioapic].apicid;
 	mp_irq.dstirq = mp_find_ioapic_pin(ioapic, gsi);
 
 	save_mp_irq(&mp_irq);
@@ -1224,23 +1221,12 @@ int mp_register_gsi(struct device *dev, u32 gsi, int triggering, int polarity)
 
 	if (ioapic_pin > MP_MAX_IOAPIC_PIN) {
 		printk(KERN_ERR "Invalid reference to IOAPIC pin "
-		       "%d-%d\n", mp_ioapic_routing[ioapic].apic_id,
+		       "%d-%d\n", mp_ioapics[ioapic].apicid,
 		       ioapic_pin);
 		return gsi;
 	}
 	mp_config_acpi_gsi(dev, gsi, triggering, polarity);
 
-	/*
-	 * Avoid pin reprogramming.  PRTs typically include entries
-	 * with redundant pin->gsi mappings (but unique PCI devices);
-	 * we only program the IOAPIC on the first.
-	 */
-	if (test_bit(ioapic_pin, mp_ioapic_routing[ioapic].pin_programmed)) {
-		pr_debug("Pin %d-%d already programmed\n",
-			 mp_ioapic_routing[ioapic].apic_id, ioapic_pin);
-		return gsi;
-	}
-	set_bit(ioapic_pin, mp_ioapic_routing[ioapic].pin_programmed);
 	io_apic_set_pci_routing(dev, ioapic, ioapic_pin, gsi,
 				triggering == ACPI_EDGE_SENSITIVE ? 0 : 1,
 				polarity == ACPI_ACTIVE_HIGH ? 0 : 1);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 21c30e1..e279ae3 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3922,7 +3922,7 @@ int __init io_apic_get_version(int ioapic)
 }
 #endif
 
-int io_apic_set_pci_routing(struct device *dev, int ioapic, int pin, int irq,
+static int __io_apic_set_pci_routing(struct device *dev, int ioapic, int pin, int irq,
 				 int triggering, int polarity)
 {
 	struct irq_desc *desc;
@@ -3959,6 +3959,29 @@ int io_apic_set_pci_routing(struct device *dev, int ioapic, int pin, int irq,
 	return 0;
 }
 
+static struct {
+	DECLARE_BITMAP(pin_programmed, MP_MAX_IOAPIC_PIN + 1);
+} mp_ioapic_routing[MAX_IO_APICS];
+
+int io_apic_set_pci_routing(struct device *dev, int ioapic, int pin, int irq,
+				 int triggering, int polarity)
+{
+
+	/*
+	 * Avoid pin reprogramming.  PRTs typically include entries
+	 * with redundant pin->gsi mappings (but unique PCI devices);
+	 * we only program the IOAPIC on the first.
+	 */
+	if (test_bit(pin, mp_ioapic_routing[ioapic].pin_programmed)) {
+		pr_debug("Pin %d-%d already programmed\n",
+			 mp_ioapics[ioapic].apicid, pin);
+		return 0;
+	}
+	set_bit(pin, mp_ioapic_routing[ioapic].pin_programmed);
+
+	return __io_apic_set_pci_routing(dev, ioapic, pin, irq,
+					 triggering, polarity);
+}
 
 int acpi_get_override_irq(int bus_irq, int *trigger, int *polarity)
 {
