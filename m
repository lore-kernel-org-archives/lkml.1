Return-Path: <linux-kernel-owner+w=401wt.eu-S1756810AbYKMTp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810AbYKMTp1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 14:45:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753293AbYKMTef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 14:34:35 -0500
Received: from gw.goop.org ([64.81.55.164]:34408 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753925AbYKMTeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 14:34:14 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 36 of 38] xen: route hardware irqs via Xen
X-Mercurial-Node: 00079eee3818aa0205e275284aa011c6ac3285f1
Message-Id: <00079eee3818aa0205e2.1226603434@abulafia.goop.org>
In-Reply-To: <patchbomb.1226603398@abulafia.goop.org>
Date: Thu, 13 Nov 2008 11:10:34 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch puts the hooks into place so that when the interrupt
subsystem registers an irq, it gets routed via Xen (if we're running
under Xen).

The first step is to get a gsi for a particular device+pin.  We use
the normal acpi interrupt routing to do the mapping.

Normally the gsi number is used directly as the irq number.  We can't
do that since we also have irqs for non-hardware event channels, and
so we must share the irq space between them.  A given gsi is only
allocated a single irq, so re-registering a gsi will simply return the
same irq.

We therefore allocate an irq for a given gsi, and return that.  As a
special case, we reserve the first 16 irqs for identity-mapping legacy
irqs, since there's a fair amount of code which assumes that.

Having allocated an irq, we ask Xen to allocate a vector, and then
bind that pirq/vector to an event channel.  When the hardware raises
an interrupt on a vector, Xen signals us on the corresponding event
channel, which gets routed to the irq and delivered to the appropriate
device driver.

This patch does everything except set up the IO APIC pin routing to
the vector.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/acpi/boot.c |    8 +++
 arch/x86/pci/legacy.c       |    4 +
 arch/x86/xen/Makefile       |    1
 arch/x86/xen/pci.c          |   98 +++++++++++++++++++++++++++++++++++++++++++
 arch/x86/xen/xen-ops.h      |    1
 drivers/xen/events.c        |    9 ++-
 include/asm-x86/xen/pci.h   |    7 +++
 include/xen/events.h        |    8 +++
 8 files changed, 132 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -42,6 +42,8 @@
 #include <asm/mpspec.h>
 #include <asm/smp.h>
 
+#include <asm/xen/pci.h>
+
 #include <asm/xen/hypervisor.h>
 
 #ifdef CONFIG_X86_LOCAL_APIC
@@ -501,6 +503,12 @@
 	unsigned int irq;
 	unsigned int plat_gsi = gsi;
 
+#ifdef CONFIG_XEN_PCI
+	irq = xen_register_gsi(gsi, triggering, polarity);
+	if ((int)irq >= 0)
+		return irq;
+#endif
+
 #ifdef CONFIG_PCI
 	/*
 	 * Make sure all (legacy) PCI IRQs are set as level-triggered.
diff --git a/arch/x86/pci/legacy.c b/arch/x86/pci/legacy.c
--- a/arch/x86/pci/legacy.c
+++ b/arch/x86/pci/legacy.c
@@ -3,6 +3,7 @@
  */
 #include <linux/init.h>
 #include <linux/pci.h>
+#include <asm/xen/pci.h>
 #include "pci.h"
 
 /*
@@ -66,6 +67,9 @@
 #ifdef CONFIG_X86_VISWS
 	pci_visws_init();
 #endif
+#ifdef CONFIG_XEN_PCI
+	xen_pci_init();
+#endif
 	pci_legacy_init();
 	pcibios_irq_init();
 	pcibios_init();
diff --git a/arch/x86/xen/Makefile b/arch/x86/xen/Makefile
--- a/arch/x86/xen/Makefile
+++ b/arch/x86/xen/Makefile
@@ -11,3 +11,4 @@
 obj-$(CONFIG_SMP)		+= smp.o spinlock.o
 obj-$(CONFIG_XEN_DEBUG_FS)	+= debugfs.o
 obj-$(CONFIG_XEN_DOM0)		+= apic.o
+obj-$(CONFIG_XEN_PCI)		+= pci.o
\ No newline at end of file
diff --git a/arch/x86/xen/pci.c b/arch/x86/xen/pci.c
new file mode 100644
--- /dev/null
+++ b/arch/x86/xen/pci.c
@@ -0,0 +1,98 @@
+#include <linux/kernel.h>
+#include <linux/acpi.h>
+#include <linux/pci.h>
+
+#include <asm/xen/hypervisor.h>
+
+#include <xen/interface/xen.h>
+#include <xen/events.h>
+
+#include "../pci/pci.h"
+
+#include "xen-ops.h"
+
+int xen_register_gsi(u32 gsi, int triggering, int polarity)
+{
+	int irq;
+
+	if (!xen_domain())
+		return -1;
+
+	printk(KERN_DEBUG "xen: registering gsi %u triggering %d polarity %d\n",
+	       gsi, triggering, polarity);
+
+	irq = xen_allocate_pirq(gsi);
+
+	printk(KERN_DEBUG "xen: --> irq=%d\n", irq);
+
+	return irq;
+}
+
+static int xen_pci_pirq_enable(struct pci_dev *dev)
+{
+	int rc;
+
+	printk(KERN_DEBUG "xen: enabling pci device %s pin %d\n",
+	       pci_name(dev), dev->pin);
+
+	if (dev->pin == 0)
+		return 0;	/* no pin, nothing to do */
+
+	rc = acpi_pci_irq_enable(dev);
+
+	if (rc >= 0 && dev->irq != 0) {
+		int irq = dev->irq;
+
+		printk(KERN_INFO "xen: PCI device %s pin %d -> irq %d\n",
+		       pci_name(dev), dev->pin, irq);
+
+		/* install vector in ioapic? */
+	} else
+		printk(KERN_INFO "xen: irq enable for %s failed: rc=%d pin=%d irq=%d\n",
+			pci_name(dev), rc, dev->pin, dev->irq);
+
+	return rc;
+}
+
+static void xen_pci_pirq_disable(struct pci_dev *dev)
+{
+	printk(KERN_INFO "xen: disable pci device %s\n",
+	       pci_name(dev));
+
+	dump_stack();
+}
+
+void __init xen_pci_init(void)
+{
+	if (!xen_domain())
+		return;
+
+	/*
+	 * In either dom0 or when using pcifront we need to take
+	 * control of physical interrupts from pci devices.
+	 * Overriding these two put us in charge of interrupt routing
+	 * akin to ACPI.
+	 *
+	 * This overrides any previous settings.
+	 */
+	pcibios_enable_irq = xen_pci_pirq_enable;
+	pcibios_disable_irq = xen_pci_pirq_disable;
+}
+
+void __init xen_setup_pirqs(void)
+{
+#ifdef CONFIG_ACPI
+	int irq;
+
+	/*
+	 * Set up acpi interrupt in acpi_gbl_FADT.sci_interrupt.
+	 */
+	irq = xen_allocate_pirq(acpi_gbl_FADT.sci_interrupt);
+
+	printk(KERN_INFO "xen: allocated irq %d for acpi %d\n",
+	       irq, acpi_gbl_FADT.sci_interrupt);
+
+	/* Blerk. */
+	acpi_gbl_FADT.sci_interrupt = irq;
+#endif
+}
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -63,7 +63,6 @@
 static inline void xen_smp_init(void) {}
 #endif
 
-
 void xen_init_apic(void);
 
 /* Declare an asm function, along with symbols needed to make it
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -391,6 +391,7 @@
 	struct evtchn_bind_pirq bind_pirq;
 	struct irq_info *info = info_for_irq(irq);
 	int evtchn = evtchn_from_irq(irq);
+	int rc;
 
 	BUG_ON(info->type != IRQT_PIRQ);
 
@@ -400,10 +401,12 @@
 	bind_pirq.pirq = irq;
 	/* NB. We are happy to share unless we are probing. */
 	bind_pirq.flags = probing_irq(irq) ? 0 : BIND_PIRQ__WILL_SHARE;
-	if (HYPERVISOR_event_channel_op(EVTCHNOP_bind_pirq, &bind_pirq) != 0) {
+	rc = HYPERVISOR_event_channel_op(EVTCHNOP_bind_pirq, &bind_pirq);
+	if (rc != 0) {
 		if (!probing_irq(irq))
 			printk(KERN_INFO "Failed to obtain physical IRQ %d\n",
 			       irq);
+		dump_stack();
 		return 0;
 	}
 	evtchn = bind_pirq.port;
@@ -523,8 +526,6 @@
 	} else
 		irq = find_unbound_irq();
 
-	spin_unlock(&irq_mapping_update_lock);
-
 	set_irq_chip_and_handler_name(irq, &xen_pirq_chip,
 				      handle_level_irq, "pirq");
 
@@ -1167,4 +1168,6 @@
 		mask_evtchn(i);
 
 	irq_ctx_init(smp_processor_id());
+
+	xen_setup_pirqs();
 }
diff --git a/include/asm-x86/xen/pci.h b/include/asm-x86/xen/pci.h
new file mode 100644
--- /dev/null
+++ b/include/asm-x86/xen/pci.h
@@ -0,0 +1,7 @@
+#ifndef _ASM_X86_XEN_PCI_H
+#define _ASM_X86_XEN_PCI_H
+
+void xen_pci_init(void);
+int xen_register_gsi(u32 gsi, int triggering, int polarity);
+
+#endif	/* _ASM_X86_XEN_PCI_H */
diff --git a/include/xen/events.h b/include/xen/events.h
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -66,4 +66,12 @@
 /* Return gsi allocated to pirq */
 int xen_gsi_from_irq(unsigned pirq);
 
+#ifdef CONFIG_XEN_PCI
+void xen_setup_pirqs(void);
+#else
+static inline void xen_setup_pirqs(void)
+{
+}
+#endif
+
 #endif	/* _XEN_EVENTS_H */


