Return-Path: <linux-kernel-owner+w=401wt.eu-S1757452AbYKMTqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452AbYKMTqi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 14:46:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752768AbYKMTei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 14:34:38 -0500
Received: from gw.goop.org ([64.81.55.164]:34455 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753904AbYKMTeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 14:34:16 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 37 of 38] xen: bind pirq to vector and event channel
X-Mercurial-Node: 9246f7451e9785194a13c5a844ce6809dfb7ddb5
Message-Id: <9246f7451e9785194a13.1226603435@abulafia.goop.org>
In-Reply-To: <patchbomb.1226603398@abulafia.goop.org>
Date: Thu, 13 Nov 2008 11:10:35 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Having converting a dev+pin to a gsi, and that gsi to an irq, and
allocated a vector for the irq, we must program the IO APIC to deliver
an interrupt on a pin to the vector, so Xen can deliver it as an event
channel.

Given the pirq, we can get the gsi and vector.  We map the gsi to a
specific IO APIC's pin, and set the routing entry.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/apic.c |    4 ++--
 arch/x86/xen/pci.c  |   34 +++++++++++++++++++++++++++++++---
 2 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/arch/x86/xen/apic.c b/arch/x86/xen/apic.c
--- a/arch/x86/xen/apic.c
+++ b/arch/x86/xen/apic.c
@@ -4,6 +4,7 @@
 
 #include <asm/io_apic.h>
 #include <asm/acpi.h>
+#include <asm/hw_irq.h>
 
 #include <asm/xen/hypervisor.h>
 #include <asm/xen/hypercall.h>
@@ -13,8 +14,7 @@
 
 static void __init xen_io_apic_init(void)
 {
-	printk("xen apic init\n");
-	dump_stack();
+	enable_IO_APIC();
 }
 
 static unsigned int xen_io_apic_read(unsigned apic, unsigned reg)
diff --git a/arch/x86/xen/pci.c b/arch/x86/xen/pci.c
--- a/arch/x86/xen/pci.c
+++ b/arch/x86/xen/pci.c
@@ -2,8 +2,10 @@
 #include <linux/acpi.h>
 #include <linux/pci.h>
 
+#include <asm/mpspec.h>
+#include <asm/io_apic.h>
+
 #include <asm/xen/hypervisor.h>
-
 #include <xen/interface/xen.h>
 #include <xen/events.h>
 
@@ -11,6 +13,31 @@
 
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
+	setup_ioapic_entry(ioapic, -1, &entry, ~0, trigger, polarity, vector);
+	ioapic_write_entry(ioapic, ioapic_pin, entry);
+}
+
 int xen_register_gsi(u32 gsi, int triggering, int polarity)
 {
 	int irq;
@@ -25,6 +52,9 @@
 
 	printk(KERN_DEBUG "xen: --> irq=%d\n", irq);
 
+	if (irq > 0)
+		xen_set_io_apic_routing(irq, triggering, polarity);
+
 	return irq;
 }
 
@@ -45,8 +75,6 @@
 
 		printk(KERN_INFO "xen: PCI device %s pin %d -> irq %d\n",
 		       pci_name(dev), dev->pin, irq);
-
-		/* install vector in ioapic? */
 	} else
 		printk(KERN_INFO "xen: irq enable for %s failed: rc=%d pin=%d irq=%d\n",
 			pci_name(dev), rc, dev->pin, dev->irq);


