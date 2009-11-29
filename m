Return-Path: <linux-kernel-owner+w=401wt.eu-S1754248AbZK2PqI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248AbZK2PqI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 10:46:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754160AbZK2PqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 10:46:00 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36414 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753811AbZK2Pp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 10:45:56 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [RFC][PATCH 3/12] PCI / PM: Propagate wake-up enable for PCIe devices too
Date: Sun, 29 Nov 2009 16:35:54 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rc8-rjw; KDE/4.3.3; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Oliver Neukum <oliver@neukum.org>, Shaohua Li <shaohua.li@intel.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Francois Romieu <romieu@fr.zoreil.com>, Len Brown <lenb@kernel.org>
References: <200911160047.46299.rjw@sisk.pl> <200911291632.44763.rjw@sisk.pl>
In-Reply-To: <200911291632.44763.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911291635.54352.rjw@sisk.pl>
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
-		if (!ret || bridge->is_pcie)
+		if (!acpi_pm_device_sleep_wake(&bus->self->dev, enable))
 			return;
 		bus = bus->parent;
 	}
@@ -131,9 +127,7 @@ static int acpi_pci_sleep_wake(struct pc
 	if (acpi_pci_can_wakeup(dev))
 		return acpi_pm_device_sleep_wake(&dev->dev, enable);
 
-	if (!dev->is_pcie)
-		acpi_pci_propagate_wakeup_enable(dev->bus, enable);
-
+	acpi_pci_propagate_wakeup_enable(dev->bus, enable);
 	return 0;
 }
 

