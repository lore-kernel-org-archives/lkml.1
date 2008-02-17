Return-Path: <linux-kernel-owner+w=401wt.eu-S1761195AbYBQMca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761195AbYBQMca (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 07:32:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757725AbYBQMXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 07:23:30 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:38355 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994AbYBQMW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 07:22:57 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>
Subject: [PATCH 25/27] pci: fix section mismatch warning in pci_scan_child_bus
Date: Sun, 17 Feb 2008 13:23:02 +0100
Message-Id: <1203250984-11285-25-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.4.1.143.ge7e51
In-Reply-To: <20080217121255.GA10519@uranus.ravnborg.org>
References: <20080217121255.GA10519@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following warning:
WARNING: vmlinux.o(.text+0x47bdb1): Section mismatch in reference from the function pci_scan_child_bus() to the function .devinit.text:pcibios_fixup_bus()

We had plenty of functions that could be annotated __devinit but
due to the former restriction that annotated symbols could not
be annotated they were not so.
So annotate these function and fix the references from the
pci/hotplug/* code to silence the resuting warnings.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Greg KH <greg@kroah.com>
---
 drivers/pci/hotplug-pci.c              |    2 +-
 drivers/pci/hotplug/acpiphp_glue.c     |    2 +-
 drivers/pci/hotplug/cpci_hotplug_pci.c |    2 +-
 drivers/pci/hotplug/pciehp_pci.c       |    2 +-
 drivers/pci/hotplug/shpchp_pci.c       |    2 +-
 drivers/pci/probe.c                    |    8 ++++----
 6 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/pci/hotplug-pci.c b/drivers/pci/hotplug-pci.c
index a590ef6..4d4a644 100644
--- a/drivers/pci/hotplug-pci.c
+++ b/drivers/pci/hotplug-pci.c
@@ -4,7 +4,7 @@
 #include "pci.h"
 
 
-unsigned int pci_do_scan_bus(struct pci_bus *bus)
+unsigned int __devinit pci_do_scan_bus(struct pci_bus *bus)
 {
 	unsigned int max;
 
diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index cf22f9e..5e50008 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -1085,7 +1085,7 @@ static int acpiphp_bus_trim(acpi_handle handle)
  * This function should be called per *physical slot*,
  * not per each slot object in ACPI namespace.
  */
-static int enable_device(struct acpiphp_slot *slot)
+static int __ref enable_device(struct acpiphp_slot *slot)
 {
 	struct pci_dev *dev;
 	struct pci_bus *bus = slot->bridge->pci_bus;
diff --git a/drivers/pci/hotplug/cpci_hotplug_pci.c b/drivers/pci/hotplug/cpci_hotplug_pci.c
index 5e9be44..dddac96 100644
--- a/drivers/pci/hotplug/cpci_hotplug_pci.c
+++ b/drivers/pci/hotplug/cpci_hotplug_pci.c
@@ -250,7 +250,7 @@ int cpci_led_off(struct slot* slot)
  * Device configuration functions
  */
 
-int cpci_configure_slot(struct slot* slot)
+int __ref cpci_configure_slot(struct slot* slot)
 {
 	struct pci_bus *parent;
 	int fn;
diff --git a/drivers/pci/hotplug/pciehp_pci.c b/drivers/pci/hotplug/pciehp_pci.c
index dd50713..9372a84 100644
--- a/drivers/pci/hotplug/pciehp_pci.c
+++ b/drivers/pci/hotplug/pciehp_pci.c
@@ -167,7 +167,7 @@ static void program_fw_provided_values(struct pci_dev *dev)
 	}
 }
 
-static int pciehp_add_bridge(struct pci_dev *dev)
+static int __ref pciehp_add_bridge(struct pci_dev *dev)
 {
 	struct pci_bus *parent = dev->bus;
 	int pass, busnr, start = parent->secondary;
diff --git a/drivers/pci/hotplug/shpchp_pci.c b/drivers/pci/hotplug/shpchp_pci.c
index 0a6b25e..a69a215 100644
--- a/drivers/pci/hotplug/shpchp_pci.c
+++ b/drivers/pci/hotplug/shpchp_pci.c
@@ -96,7 +96,7 @@ static void program_fw_provided_values(struct pci_dev *dev)
 	}
 }
 
-int shpchp_configure_device(struct slot *p_slot)
+int __ref shpchp_configure_device(struct slot *p_slot)
 {
 	struct pci_dev *dev;
 	struct pci_bus *parent = p_slot->ctrl->pci_dev->subordinate;
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 4d23b9f..5ffd610 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -286,7 +286,7 @@ static void pci_read_bases(struct pci_dev *dev, unsigned int howmany, int rom)
 	}
 }
 
-void pci_read_bridge_bases(struct pci_bus *child)
+void __devinit pci_read_bridge_bases(struct pci_bus *child)
 {
 	struct pci_dev *dev = child->self;
 	u8 io_base_lo, io_limit_lo;
@@ -472,7 +472,7 @@ static void pci_fixup_parent_subordinate_busnr(struct pci_bus *child, int max)
  * them, we proceed to assigning numbers to the remaining buses in
  * order to avoid overlaps between old and new bus numbers.
  */
-int pci_scan_bridge(struct pci_bus *bus, struct pci_dev * dev, int max, int pass)
+int __devinit pci_scan_bridge(struct pci_bus *bus, struct pci_dev * dev, int max, int pass)
 {
 	struct pci_bus *child;
 	int is_cardbus = (dev->hdr_type == PCI_HEADER_TYPE_CARDBUS);
@@ -1008,7 +1008,7 @@ int pci_scan_slot(struct pci_bus *bus, int devfn)
 	return nr;
 }
 
-unsigned int pci_scan_child_bus(struct pci_bus *bus)
+unsigned int __devinit pci_scan_child_bus(struct pci_bus *bus)
 {
 	unsigned int devfn, pass, max = bus->secondary;
 	struct pci_dev *dev;
@@ -1116,7 +1116,7 @@ err_out:
 	return NULL;
 }
 
-struct pci_bus *pci_scan_bus_parented(struct device *parent,
+struct pci_bus * __devinit pci_scan_bus_parented(struct device *parent,
 		int bus, struct pci_ops *ops, void *sysdata)
 {
 	struct pci_bus *b;
-- 
1.5.4.rc3.14.g44397

