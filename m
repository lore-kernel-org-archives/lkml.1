Return-Path: <linux-kernel-owner+w=401wt.eu-S1758359AbZELX2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758359AbZELX2n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 19:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756237AbZELXZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 19:25:31 -0400
Received: from 75-149-38-2-SFBA.hfc.comcastbusiness.net ([75.149.38.2]:36195
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753633AbZELXZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 19:25:26 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 09/17] xen: bind pirq to vector and event channel
Date: Tue, 12 May 2009 16:25:16 -0700
Message-Id: <1242170724-13349-10-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1242170724-13349-1-git-send-email-jeremy@goop.org>
References: <1242170724-13349-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Having converting a dev+pin to a gsi, and that gsi to an irq, and
allocated a vector for the irq, we must program the IO APIC to deliver
an interrupt on a pin to the vector, so Xen can deliver it as an event
channel.

Given the pirq, we can get the gsi and vector.  We map the gsi to a
specific IO APIC's pin, and set the routing entry.

(We were passing the ACPI triggering and polarity levels directly into
the apic - but they have reversed values.  The result was that
all the level-triggered interrupts were edge, and vice-versa.
It's surprising that anything worked at all, but now AHCI works
for me.

Thanks for Gerd Hoffmann for noticing this.)

[ Impact: program IO APICs under Xen ]

Diagnosed-by: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/apic.c |    2 ++
 arch/x86/xen/pci.c  |   33 +++++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/apic.c b/arch/x86/xen/apic.c
index 8ae563c..35a8af7 100644
--- a/arch/x86/xen/apic.c
+++ b/arch/x86/xen/apic.c
@@ -4,6 +4,7 @@
 
 #include <asm/io_apic.h>
 #include <asm/acpi.h>
+#include <asm/hw_irq.h>
 
 #include <asm/xen/hypervisor.h>
 #include <asm/xen/hypercall.h>
@@ -13,6 +14,7 @@
 
 static void __init xen_io_apic_init(void)
 {
+	enable_IO_APIC();
 }
 
 static unsigned int xen_io_apic_read(unsigned apic, unsigned reg)
diff --git a/arch/x86/xen/pci.c b/arch/x86/xen/pci.c
index f450007..af4e898 100644
--- a/arch/x86/xen/pci.c
+++ b/arch/x86/xen/pci.c
@@ -2,6 +2,8 @@
 #include <linux/acpi.h>
 #include <linux/pci.h>
 
+#include <asm/mpspec.h>
+#include <asm/io_apic.h>
 #include <asm/pci_x86.h>
 
 #include <asm/xen/hypervisor.h>
@@ -11,6 +13,32 @@
 
 #include "xen-ops.h"
 
+static void xen_set_io_apic_routing(int irq, int trigger, int polarity)
+{
+	int ioapic, ioapic_pin;
+	int vector, gsi;
+	struct IO_APIC_route_entry entry;
+
+	gsi = xen_gsi_from_irq(irq);
+	vector = xen_vector_from_irq(irq);
+
+	ioapic = mp_find_ioapic(gsi);
+	if (ioapic == -1) {
+		printk(KERN_WARNING "xen_set_ioapic_routing: irq %d gsi %d ioapic %d\n",
+			irq, gsi, ioapic);
+		return;
+	}
+
+	ioapic_pin = mp_find_ioapic_pin(ioapic, gsi);
+
+	printk(KERN_INFO "xen_set_ioapic_routing: irq %d gsi %d vector %d ioapic %d pin %d triggering %d polarity %d\n",
+		irq, gsi, vector, ioapic, ioapic_pin, trigger, polarity);
+
+	setup_ioapic_entry(ioapic, -1, &entry, ~0, trigger, polarity, vector,
+			   ioapic_pin);
+	ioapic_write_entry(ioapic, ioapic_pin, entry);
+}
+
 int xen_register_gsi(u32 gsi, int triggering, int polarity)
 {
 	int irq;
@@ -25,6 +53,11 @@ int xen_register_gsi(u32 gsi, int triggering, int polarity)
 
 	printk(KERN_DEBUG "xen: --> irq=%d\n", irq);
 
+	if (irq > 0)
+		xen_set_io_apic_routing(irq,
+					triggering == ACPI_EDGE_SENSITIVE ? 0 : 1,
+					polarity == ACPI_ACTIVE_HIGH ? 0 : 1);
+
 	return irq;
 }
 
-- 
1.6.0.6

