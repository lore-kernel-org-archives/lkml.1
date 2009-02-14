Return-Path: <linux-kernel-owner+w=401wt.eu-S1762392AbZBNB1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762392AbZBNB1Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 20:27:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762964AbZBNBNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 20:13:10 -0500
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:49177
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763411AbZBNBNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 20:13:06 -0500
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yinghai@kernel.org>, Ian Campbell <Ian.Campbell@citrix.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 8/9] xen: bind pirq to vector and event channel
Date: Fri, 13 Feb 2009 17:12:06 -0800
Message-Id: <69aeef6bc01fbe1fdc6ebd41910e6dc8767b103c.1234573847.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <0e852da646969a2296f66cbc485f278fe1fa9929.1234573847.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1234573847.git.jeremy.fitzhardinge@citrix.com>
 <cover.1234573847.git.jeremy.fitzhardinge@citrix.com>
 <3c7db30686056c9b86cc61ef50dd5572de868512.1234573847.git.jeremy.fitzhardinge@citrix.com>
 <3e46dae897fd5620f50b4cca9272969f5546aa88.1234573847.git.jeremy.fitzhardinge@citrix.com>
 <79724b71f4b8ef1fb65ea246dde2e3e1344b2a43.1234573847.git.jeremy.fitzhardinge@citrix.com>
 <cbcff9ab54a2189156077c81c706fc30ba84344c.1234573847.git.jeremy.fitzhardinge@citrix.com>
 <5b0148b366eaa87072ab261f71c4c545be8e607f.1234573847.git.jeremy.fitzhardinge@citrix.com>
 <4e896f722e4175f96f3846896c3a7b627e634e7e.1234573847.git.jeremy.fitzhardinge@citrix.com>
 <0e852da646969a2296f66cbc485f278fe1fa9929.1234573847.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1234573847.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1234573847.git.jeremy.fitzhardinge@citrix.com>
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

