Return-Path: <linux-kernel-owner+w=401wt.eu-S935087AbYBOApW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935087AbYBOApW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 19:45:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934722AbYBOAmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 19:42:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54059 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761071AbYBOAme (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 19:42:34 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-pci@atrey.karlin.mff.cuni.cz
Cc: linux-kernel@vger.kernel.org, pcihpd-discuss@lists.sourceforge.net,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Scott Murray <scottm@somanetworks.com>
Subject: [PATCH 06/12] PCI Hotplug: make cpcihp driver use modern apis
Date: Thu, 14 Feb 2008 16:40:04 -0800
Message-Id: <1203036010-27988-6-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.4
In-Reply-To: <20080215003909.GA27981@kroah.com>
References: <20080215003909.GA27981@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes the depandancy of the cpcihp driver from the PCI_LEGACY
config option by removing its usage of the pci_find_bus() function.


Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Scott Murray <scottm@somanetworks.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/pci/hotplug/Kconfig          |    2 +-
 drivers/pci/hotplug/cpcihp_generic.c |    8 +++++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/hotplug/Kconfig b/drivers/pci/hotplug/Kconfig
index 2cdd832..17fb3d6 100644
--- a/drivers/pci/hotplug/Kconfig
+++ b/drivers/pci/hotplug/Kconfig
@@ -119,7 +119,7 @@ config HOTPLUG_PCI_CPCI_ZT5550
 
 config HOTPLUG_PCI_CPCI_GENERIC
 	tristate "Generic port I/O CompactPCI Hotplug driver"
-	depends on HOTPLUG_PCI_CPCI && X86 && PCI_LEGACY
+	depends on HOTPLUG_PCI_CPCI && X86
 	help
 	  Say Y here if you have a CompactPCI system card that exposes the #ENUM
 	  hotswap signal as a bit in a system register that can be read through
diff --git a/drivers/pci/hotplug/cpcihp_generic.c b/drivers/pci/hotplug/cpcihp_generic.c
index f3852a6..148fb46 100644
--- a/drivers/pci/hotplug/cpcihp_generic.c
+++ b/drivers/pci/hotplug/cpcihp_generic.c
@@ -154,12 +154,18 @@ static int __init cpcihp_generic_init(void)
 	if(!r)
 		return -EBUSY;
 
-	dev = pci_find_slot(bridge_busnr, PCI_DEVFN(bridge_slot, 0));
+	bus = pci_find_bus(0, bridge_busnr);
+	if (!bus) {
+		err("Invalid bus number %d", bridge_busnr);
+		return -EINVAL;
+	}
+	dev = pci_get_slot(bus, PCI_DEVFN(bridge_slot, 0));
 	if(!dev || dev->hdr_type != PCI_HEADER_TYPE_BRIDGE) {
 		err("Invalid bridge device %s", bridge);
 		return -EINVAL;
 	}
 	bus = dev->subordinate;
+	pci_dev_put(dev);
 
 	memset(&generic_hpc, 0, sizeof (struct cpci_hp_controller));
 	generic_hpc_ops.query_enum = query_enum;
-- 
1.5.4

