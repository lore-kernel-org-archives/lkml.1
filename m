Return-Path: <linux-kernel-owner+w=401wt.eu-S1761148AbZCNAg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761148AbZCNAg1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 20:36:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753271AbZCNATX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 20:19:23 -0400
Received: from kroah.org ([198.145.64.141]:47153 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753539AbZCNATL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 20:19:11 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 17:07:46 2009
Message-Id: <20090314000746.710349143@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 17:05:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Alexander Duyck <alexander.h.duyck@intel.com>,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Wilcox <willy@linux.intel.com>
Subject: [patch 51/96] PCI: Add PCI quirk to disable L0s ASPM state for 82575 and 82598
References: <20090314000508.803142980@mini.kroah.org>
Content-Disposition: inline; filename=pci-add-pci-quirk-to-disable-l0s-aspm-state-for-82575-and-82598.patch
In-Reply-To: <20090314001449.GA4485@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alexander Duyck <alexander.h.duyck@intel.com>

commit 649426efcfbc67a8b033497151816cbac9fd0cfa upstream.

This patch is intended to disable L0s ASPM link state for 82598 (ixgbe)
parts due to the fact that it is possible to corrupt TX data when coming
back out of L0s on some systems.  The workaround had been added for 82575
(igb) previously, but did not use the ASPM api.  This quirk uses the ASPM
api to prevent the ASPM subsystem from re-enabling the L0s state.

Instead of adding the fix in igb to the ixgbe driver as well it was
decided to move it into a pci quirk.  It is necessary to move the fix out
of the driver and into a pci quirk in order to prevent the issue from
occuring prior to driver load to handle the possibility of the device being
passed to a VM via direct assignment.

Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/quirks.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -22,6 +22,7 @@
 #include <linux/delay.h>
 #include <linux/acpi.h>
 #include <linux/kallsyms.h>
+#include <linux/pci-aspm.h>
 #include "pci.h"
 
 /* The Mellanox Tavor device gives false positive parity errors
@@ -1542,6 +1543,30 @@ static void __devinit quirk_e100_interru
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, PCI_ANY_ID, quirk_e100_interrupt);
 
+/*
+ * The 82575 and 82598 may experience data corruption issues when transitioning
+ * out of L0S.  To prevent this we need to disable L0S on the pci-e link
+ */
+static void __devinit quirk_disable_aspm_l0s(struct pci_dev *dev)
+{
+	dev_info(&dev->dev, "Disabling L0s\n");
+	pci_disable_link_state(dev, PCIE_LINK_STATE_L0S);
+}
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x10a7, quirk_disable_aspm_l0s);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x10a9, quirk_disable_aspm_l0s);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x10b6, quirk_disable_aspm_l0s);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x10c6, quirk_disable_aspm_l0s);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x10c7, quirk_disable_aspm_l0s);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x10c8, quirk_disable_aspm_l0s);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x10d6, quirk_disable_aspm_l0s);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x10db, quirk_disable_aspm_l0s);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x10dd, quirk_disable_aspm_l0s);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x10e1, quirk_disable_aspm_l0s);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x10ec, quirk_disable_aspm_l0s);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x10f1, quirk_disable_aspm_l0s);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x10f4, quirk_disable_aspm_l0s);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x1508, quirk_disable_aspm_l0s);
+
 static void __devinit fixup_rev1_53c810(struct pci_dev* dev)
 {
 	/* rev 1 ncr53c810 chips don't set the class at all which means


