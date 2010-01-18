Return-Path: <linux-kernel-owner+w=401wt.eu-S1755850Ab0ARSek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850Ab0ARSek (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 13:34:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754444Ab0ARSej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 13:34:39 -0500
Received: from relay1.sgi.com ([192.48.179.29]:49577 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754825Ab0ARSei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 13:34:38 -0500
Message-Id: <20100118183418.045021000@alcatraz.americas.sgi.com>
References: <20100118183412.560438000@alcatraz.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 18 Jan 2010 12:34:13 -0600
From: Mike Travis <travis@sgi.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>
Cc: Russ Anderson <rja@sgi.com>, Dave Airlie <airlied@redhat.com>,
       Alex Chiang <achiang@hp.com>, Thomas Gleixner <tglx@linutronix.de>,
       Cyrill Gorcunov <gorcunov@openvz.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Robin Holt <holt@sgi.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Adam Jackson <ajax@nwnk.net>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gaetan Nadon <memsize@videotron.ca>, "H. Peter Anvin" <hpa@zytor.com>,
       Aaron Plattner <aplattner@nvidia.com>, Jack Steiner <steiner@sgi.com>,
       Tiago Vignatti <tiago.vignatti@nokia.com>, Cliff Wickman <cpw@sgi.com>,
       Matthew Wilcox <willy@linux.intel.com>,
       Christian Zander <chzander@nvidia.com>, Yu Zhao <yu.zhao@intel.com>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, x86@kernel.org
Subject: [PATCH 1/4] pci: Update pci_set_vga_state to call arch functions
Content-Disposition: inline; filename=update-pci
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update pci_set_vga_state to call arch dependent functions to enable
Legacy VGA I/O transactions to be redirected to correct target.

Signed-off-by: Mike Travis <travis@sgi.com>

Cc: Dave Airlie <airlied@redhat.com>
Cc: Alex Chiang <achiang@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Robin Holt <holt@sgi.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Adam Jackson <ajax@nwnk.net>
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Gaetan Nadon <memsize@videotron.ca>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Aaron Plattner <aplattner@nvidia.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: Tiago Vignatti <tiago.vignatti@nokia.com>
Cc: Cliff Wickman <cpw@sgi.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Christian Zander <chzander@nvidia.com>
Cc: Yu Zhao <yu.zhao@intel.com>

Cc: linux-kernel@vger.kernel.org
Cc: linux-pci@vger.kernel.org
Cc: x86@kernel.org
---
 drivers/pci/pci.c   |   25 ++++++++++++++++++++++++-
 include/linux/pci.h |    5 +++++
 2 files changed, 29 insertions(+), 1 deletion(-)

--- linux.orig/drivers/pci/pci.c
+++ linux/drivers/pci/pci.c
@@ -2544,6 +2544,23 @@
 	return 0;
 }
 
+/* Some architectures require additional programming to enable VGA */
+static arch_set_vga_state_t arch_set_vga_state;
+
+void pci_register_set_vga_state(arch_set_vga_state_t func)
+{
+	arch_set_vga_state = func;	/* NULL disables */
+}
+
+static int pci_set_vga_state_arch(struct pci_dev *dev, bool decode,
+		      unsigned int command_bits, bool change_bridge)
+{
+	if (arch_set_vga_state)
+		return arch_set_vga_state(dev, decode, command_bits,
+						change_bridge);
+	return 0;
+}
+
 /**
  * pci_set_vga_state - set VGA decode state on device and parents if requested
  * @dev: the PCI device
@@ -2557,9 +2574,15 @@
 	struct pci_bus *bus;
 	struct pci_dev *bridge;
 	u16 cmd;
+	int rc;
 
 	WARN_ON(command_bits & ~(PCI_COMMAND_IO|PCI_COMMAND_MEMORY));
 
+	/* ARCH specific VGA enables */
+	rc = pci_set_vga_state_arch(dev, decode, command_bits, change_bridge);
+	if (rc)
+		return rc;
+
 	pci_read_config_word(dev, PCI_COMMAND, &cmd);
 	if (decode == true)
 		cmd |= command_bits;
@@ -2769,6 +2792,7 @@
 EXPORT_SYMBOL(pci_disable_device);
 EXPORT_SYMBOL(pci_find_capability);
 EXPORT_SYMBOL(pci_bus_find_capability);
+EXPORT_SYMBOL(pci_register_set_vga_state);
 EXPORT_SYMBOL(pci_release_regions);
 EXPORT_SYMBOL(pci_request_regions);
 EXPORT_SYMBOL(pci_request_regions_exclusive);
@@ -2801,4 +2825,3 @@
 EXPORT_SYMBOL(pci_prepare_to_sleep);
 EXPORT_SYMBOL(pci_back_from_sleep);
 EXPORT_SYMBOL_GPL(pci_set_pcie_reset_state);
-
--- linux.orig/include/linux/pci.h
+++ linux/include/linux/pci.h
@@ -942,6 +942,11 @@
 }
 #endif /* CONFIG_PCI_DOMAINS */
 
+/* some architectures require additional setup to direct VGA traffic */
+typedef int (*arch_set_vga_state_t)(struct pci_dev *pdev, bool decode,
+		      unsigned int command_bits, bool change_bridge);
+extern void pci_register_set_vga_state(arch_set_vga_state_t func);
+
 #else /* CONFIG_PCI is not enabled */
 
 /*

-- 
