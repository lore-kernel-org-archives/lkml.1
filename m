Return-Path: <linux-kernel-owner+w=401wt.eu-S1763434AbZB1CQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763434AbZB1CQ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 21:16:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756635AbZB1COS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 21:14:18 -0500
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:46159
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750910AbZB1COM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 21:14:12 -0500
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 08/10] xen: bind pirq to vector and event channel
Date: Fri, 27 Feb 2009 18:14:06 -0800
Message-Id: <1235787248-18184-9-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1235787248-18184-1-git-send-email-jeremy@goop.org>
References: <1235787248-18184-1-git-send-email-jeremy@goop.org>
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
 arch/x86/xen/pci.c  |   30 ++++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/apic.c b/arch/x86/xen/apic.c
index 17736a0..e9d9ea7 100644
--- a/arch/x86/xen/apic.c
+++ b/arch/x86/xen/apic.c
@@ -4,6 +4,7 @@
 
 #include <asm/io_apic.h>
 #include <asm/acpi.h>
+#include <asm/hw_irq.h>
 
 #include <asm/xen/hypervisor.h>
 #include <asm/xen/hypercall.h>
@@ -13,8 +14,7 @@
 
 void __init xen_io_apic_init(void)
 {
-	printk("xen apic init\n");
-	dump_stack();
+	enable_IO_APIC();
 }
 
 unsigned int xen_io_apic_read(unsigned apic, unsigned reg)
diff --git a/arch/x86/xen/pci.c b/arch/x86/xen/pci.c
index f450007..61f070c 100644
--- a/arch/x86/xen/pci.c
+++ b/arch/x86/xen/pci.c
@@ -2,6 +2,8 @@
 #include <linux/acpi.h>
 #include <linux/pci.h>
 
+#include <asm/mpspec.h>
+#include <asm/io_apic.h>
 #include <asm/pci_x86.h>
 
 #include <asm/xen/hypervisor.h>
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
@@ -25,6 +52,9 @@ int xen_register_gsi(u32 gsi, int triggering, int polarity)
 
 	printk(KERN_DEBUG "xen: --> irq=%d\n", irq);
 
+	if (irq > 0)
+		xen_set_io_apic_routing(irq, triggering, polarity);
+
 	return irq;
 }
 
-- 
1.6.0.6

