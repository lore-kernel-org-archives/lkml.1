Return-Path: <linux-kernel-owner+w=401wt.eu-S1752273AbZELX2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273AbZELX2Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 19:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754680AbZELXZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 19:25:30 -0400
Received: from 75-149-38-2-SFBA.hfc.comcastbusiness.net ([75.149.38.2]:36194
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753411AbZELXZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 19:25:26 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 08/17] xen: direct irq registration to pirq event channels
Date: Tue, 12 May 2009 16:25:15 -0700
Message-Id: <1242170724-13349-9-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1242170724-13349-1-git-send-email-jeremy@goop.org>
References: <1242170724-13349-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch puts the hooks into place so that when the interrupt
subsystem registers an irq, it gets routed via Xen (if we're running
under Xen).

The first step is to get a gsi for a particular device+pin.  We use
the normal acpi interrupt routing to do the mapping.

We reserve enough irq space to fit the hardware interrupt sources in,
so we can allocate the irq == gsi, as we do in the native case;
software events will get allocated irqs above that.

Having allocated an irq, we ask Xen to allocate a vector, and then
bind that pirq/vector to an event channel.  When the hardware raises
an interrupt on a vector, Xen signals us on the corresponding event
channel, which gets routed to the irq and delivered to the appropriate
device driver.

This patch does everything except set up the IO APIC pin routing to
the vector.

[ Impact: route hardware interrupts via Xen ]

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/xen/pci.h |   13 +++++++++++
 arch/x86/kernel/acpi/boot.c    |    8 ++++++-
 arch/x86/xen/Kconfig           |   11 +++++++++
 arch/x86/xen/Makefile          |    1 +
 arch/x86/xen/pci.c             |   47 ++++++++++++++++++++++++++++++++++++++++
 drivers/xen/events.c           |    6 ++++-
 include/xen/events.h           |    8 ++++++
 7 files changed, 92 insertions(+), 2 deletions(-)
 create mode 100644 arch/x86/include/asm/xen/pci.h
 create mode 100644 arch/x86/xen/pci.c

diff --git a/arch/x86/include/asm/xen/pci.h b/arch/x86/include/asm/xen/pci.h
new file mode 100644
index 0000000..0563fc6
--- /dev/null
+++ b/arch/x86/include/asm/xen/pci.h
@@ -0,0 +1,13 @@
+#ifndef _ASM_X86_XEN_PCI_H
+#define _ASM_X86_XEN_PCI_H
+
+#ifdef CONFIG_XEN_DOM0_PCI
+int xen_register_gsi(u32 gsi, int triggering, int polarity);
+#else
+static inline int xen_register_gsi(u32 gsi, int triggering, int polarity)
+{
+	return -1;
+}
+#endif
+
+#endif	/* _ASM_X86_XEN_PCI_H */
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 4147e0c..d4de1c2 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -41,6 +41,8 @@
 #include <asm/mpspec.h>
 #include <asm/smp.h>
 
+#include <asm/xen/pci.h>
+
 #include <asm/xen/hypervisor.h>
 
 static int __initdata acpi_force = 0;
@@ -530,9 +532,13 @@ int acpi_gsi_to_irq(u32 gsi, unsigned int *irq)
  */
 int acpi_register_gsi(u32 gsi, int triggering, int polarity)
 {
-	unsigned int irq;
+	int irq;
 	unsigned int plat_gsi = gsi;
 
+	irq = xen_register_gsi(gsi, triggering, polarity);
+	if (irq >= 0)
+		return irq;
+
 #ifdef CONFIG_PCI
 	/*
 	 * Make sure all (legacy) PCI IRQs are set as level-triggered.
diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
index fe69286..42e9f0a 100644
--- a/arch/x86/xen/Kconfig
+++ b/arch/x86/xen/Kconfig
@@ -37,6 +37,17 @@ config XEN_DEBUG_FS
 	  Enable statistics output and various tuning options in debugfs.
 	  Enabling this option may incur a significant performance overhead.
 
+config XEN_PCI_PASSTHROUGH
+       bool #"Enable support for Xen PCI passthrough devices"
+       depends on XEN && PCI
+       help
+         Enable support for passing PCI devices through to
+	 unprivileged domains. (COMPLETELY UNTESTED)
+
+config XEN_DOM0_PCI
+       def_bool y
+       depends on XEN_DOM0 && PCI
+
 config XEN_DOM0
 	bool "Enable Xen privileged domain support"
 	depends on XEN && X86_IO_APIC && ACPI
diff --git a/arch/x86/xen/Makefile b/arch/x86/xen/Makefile
index 73ecb74..639965a 100644
--- a/arch/x86/xen/Makefile
+++ b/arch/x86/xen/Makefile
@@ -12,3 +12,4 @@ obj-y		:= enlighten.o setup.o multicalls.o mmu.o irq.o \
 obj-$(CONFIG_SMP)		+= smp.o spinlock.o
 obj-$(CONFIG_XEN_DEBUG_FS)	+= debugfs.o
 obj-$(CONFIG_XEN_DOM0)		+= vga.o apic.o
+obj-$(CONFIG_XEN_DOM0_PCI)	+= pci.o
\ No newline at end of file
diff --git a/arch/x86/xen/pci.c b/arch/x86/xen/pci.c
new file mode 100644
index 0000000..f450007
--- /dev/null
+++ b/arch/x86/xen/pci.c
@@ -0,0 +1,47 @@
+#include <linux/kernel.h>
+#include <linux/acpi.h>
+#include <linux/pci.h>
+
+#include <asm/pci_x86.h>
+
+#include <asm/xen/hypervisor.h>
+
+#include <xen/interface/xen.h>
+#include <xen/events.h>
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
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 88395bb..968e927 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -419,6 +419,7 @@ static unsigned int startup_pirq(unsigned int irq)
 	struct evtchn_bind_pirq bind_pirq;
 	struct irq_info *info = info_for_irq(irq);
 	int evtchn = evtchn_from_irq(irq);
+	int rc;
 
 	BUG_ON(info->type != IRQT_PIRQ);
 
@@ -428,7 +429,8 @@ static unsigned int startup_pirq(unsigned int irq)
 	bind_pirq.pirq = irq;
 	/* NB. We are happy to share unless we are probing. */
 	bind_pirq.flags = probing_irq(irq) ? 0 : BIND_PIRQ__WILL_SHARE;
-	if (HYPERVISOR_event_channel_op(EVTCHNOP_bind_pirq, &bind_pirq) != 0) {
+	rc = HYPERVISOR_event_channel_op(EVTCHNOP_bind_pirq, &bind_pirq);
+	if (rc != 0) {
 		if (!probing_irq(irq))
 			printk(KERN_INFO "Failed to obtain physical IRQ %d\n",
 			       irq);
@@ -1187,4 +1189,6 @@ void __init xen_init_IRQ(void)
 		mask_evtchn(i);
 
 	irq_ctx_init(smp_processor_id());
+
+	xen_setup_pirqs();
 }
diff --git a/include/xen/events.h b/include/xen/events.h
index e5b541d..6fe4863 100644
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -69,4 +69,12 @@ int xen_vector_from_irq(unsigned pirq);
 /* Return gsi allocated to pirq */
 int xen_gsi_from_irq(unsigned pirq);
 
+#ifdef CONFIG_XEN_DOM0_PCI
+void xen_setup_pirqs(void);
+#else
+static inline void xen_setup_pirqs(void)
+{
+}
+#endif
+
 #endif	/* _XEN_EVENTS_H */
-- 
1.6.0.6

