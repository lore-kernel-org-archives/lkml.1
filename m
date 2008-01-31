Return-Path: <linux-kernel-owner+w=401wt.eu-S934671AbYAaWLJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934671AbYAaWLJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 17:11:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934377AbYAaWKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 17:10:38 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:40273 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934275AbYAaWKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 17:10:37 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Greg KH <gregkh@suse.de>,
       Adrian Bunk <bunk@kernel.org>
Subject: [PATCH] pci: fix section mismatch warnings referring to pci_do_scan_bus
Date: Thu, 31 Jan 2008 23:10:30 +0100
Message-Id: <1201817440-5081-1-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.3.5.628.ga1309
In-Reply-To: <20080131220430.GA4874@uranus.ravnborg.org>
References: <20080131220430.GA4874@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following warnings:
WARNING: o-x86_64/drivers/pci/built-in.o(.text+0xb054): Section mismatch in reference from the function cpci_configure_slot() to the function .devinit.text:pci_do_scan_bus()
WARNING: o-x86_64/drivers/pci/built-in.o(.text+0x153ab): Section mismatch in reference from the function shpchp_configure_device() to the function .devinit.text:pci_do_scan_bus()
WARNING: o-x86_64/drivers/pci/built-in.o(__ksymtab+0xc0): Section mismatch in reference from the variable __ksymtab_pci_do_scan_bus to the function .devinit.text:pci_do_scan_bus()

PCI hotplug were the only user of pci_do_scan_bus()
so moving this function to the directory of
PCI Hotplug was a logical way to fix so
we only include this function in the kernel
when the CONFIG_HOTPLUG_PCI is enabled.

Then the abuse of __devinit could be dropped and
we no longer trigger the above warnings.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Greg KH <gregkh@suse.de>
Cc: Adrian Bunk <bunk@kernel.org>
---
 drivers/pci/hotplug/Makefile   |    1 +
 drivers/pci/hotplug/pci-core.c |   20 ++++++++++++++++++++
 drivers/pci/probe.c            |   15 ---------------
 3 files changed, 21 insertions(+), 15 deletions(-)
 create mode 100644 drivers/pci/hotplug/pci-core.c

diff --git a/drivers/pci/hotplug/Makefile b/drivers/pci/hotplug/Makefile
index 34a1891..f755a6e 100644
--- a/drivers/pci/hotplug/Makefile
+++ b/drivers/pci/hotplug/Makefile
@@ -1,6 +1,7 @@
 #
 # Makefile for the Linux kernel pci hotplug controller drivers.
 #
+obj-y := pci-core.o
 
 obj-$(CONFIG_HOTPLUG_PCI)		+= pci_hotplug.o
 obj-$(CONFIG_HOTPLUG_PCI_FAKE)		+= fakephp.o 
diff --git a/drivers/pci/hotplug/pci-core.c b/drivers/pci/hotplug/pci-core.c
new file mode 100644
index 0000000..e0fb169
--- /dev/null
+++ b/drivers/pci/hotplug/pci-core.c
@@ -0,0 +1,20 @@
+/* Core PCI functionality used only by PCI hotplug */
+
+#include <linux/pci.h>
+#include "../pci.h"
+
+
+unsigned int pci_do_scan_bus(struct pci_bus *bus)
+{
+	unsigned int max;
+
+	max = pci_scan_child_bus(bus);
+
+	/*
+	 * Make the discovered devices available.
+	 */
+	pci_bus_add_devices(bus);
+
+	return max;
+}
+EXPORT_SYMBOL(pci_do_scan_bus);
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 5fd5852..496fc13 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1050,20 +1050,6 @@ unsigned int pci_scan_child_bus(struct pci_bus *bus)
 	return max;
 }
 
-unsigned int __devinit pci_do_scan_bus(struct pci_bus *bus)
-{
-	unsigned int max;
-
-	max = pci_scan_child_bus(bus);
-
-	/*
-	 * Make the discovered devices available.
-	 */
-	pci_bus_add_devices(bus);
-
-	return max;
-}
-
 struct pci_bus * pci_create_bus(struct device *parent,
 		int bus, struct pci_ops *ops, void *sysdata)
 {
@@ -1156,7 +1142,6 @@ EXPORT_SYMBOL(pci_scan_bus_parented);
 
 #ifdef CONFIG_HOTPLUG
 EXPORT_SYMBOL(pci_add_new_bus);
-EXPORT_SYMBOL(pci_do_scan_bus);
 EXPORT_SYMBOL(pci_scan_slot);
 EXPORT_SYMBOL(pci_scan_bridge);
 EXPORT_SYMBOL(pci_scan_single_device);
-- 
1.5.4.rc3.14.g44397

