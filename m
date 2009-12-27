Return-Path: <linux-kernel-owner+w=401wt.eu-S1751216AbZL0ULl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751216AbZL0ULl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 15:11:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751166AbZL0ULh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 15:11:37 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60424 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750980AbZL0ULf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 15:11:35 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 2/12] PCI / PM: Propagate wake-up enable for PCIe devices too
Date: Sun, 27 Dec 2009 21:00:33 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc2-tst; KDE/4.3.3; x86_64; ; )
Cc: Matthew Garrett <mjg@redhat.com>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Oliver Neukum <oliver@neukum.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Shaohua Li <shaohua.li@intel.com>,
       Francois Romieu <romieu@fr.zoreil.com>
References: <200912272057.10443.rjw@sisk.pl>
In-Reply-To: <200912272057.10443.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912272100.33117.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Having read the PM part of the PCIe 2.0 specification more carefully
I think that it was a mistake to restrict the wake-up enable
propagation to non-PCIe devices, because if we do not request
control of the root ports' PME registers via OSC, PCIe PME is
supposed to be handled by the platform, just like the non-PCIe PME.
Even if we do that, the wake-up propagation is done to allow the
devices to wake up the system from sleep states which involves the
platform anyway, so it won't hurt.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/pci-acpi.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

Index: linux-2.6/drivers/pci/pci-acpi.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci-acpi.c
+++ linux-2.6/drivers/pci/pci-acpi.c
@@ -112,11 +112,7 @@ static bool acpi_pci_can_wakeup(struct p
 static void acpi_pci_propagate_wakeup_enable(struct pci_bus *bus, bool enable)
 {
 	while (bus->parent) {
-		struct pci_dev *bridge = bus->self;
-		int ret;
-
-		ret = acpi_pm_device_sleep_wake(&bridge->dev, enable);
-		if (!ret || pci_is_pcie(bridge))
+		if (!acpi_pm_device_sleep_wake(&bus->self->dev, enable))
 			return;
 		bus = bus->parent;
 	}
@@ -131,9 +127,7 @@ static int acpi_pci_sleep_wake(struct pc
 	if (acpi_pci_can_wakeup(dev))
 		return acpi_pm_device_sleep_wake(&dev->dev, enable);
 
-	if (!pci_is_pcie(dev))
-		acpi_pci_propagate_wakeup_enable(dev->bus, enable);
-
+	acpi_pci_propagate_wakeup_enable(dev->bus, enable);
 	return 0;
 }
 

