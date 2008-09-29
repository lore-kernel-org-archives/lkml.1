Return-Path: <linux-kernel-owner+w=401wt.eu-S1753071AbYI2WQN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071AbYI2WQN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 18:16:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753164AbYI2WPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 18:15:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48224 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752364AbYI2WPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 18:15:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH 5/6] SATA Sil: Blacklist system that spins off disks during ACPI power off
Date: Tue, 30 Sep 2008 00:16:26 +0200
User-Agent: KMail/1.9.9
Cc: Tejun Heo <htejun@gmail.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       linux-ide@vger.kernel.org, Thomas Renninger <trenn@suse.de>,
       Robert Hancock <hancockr@shaw.ca>, LKML <linux-kernel@vger.kernel.org>,
       Frans Pop <elendil@planet.nl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200808290002.55026.rjw@sisk.pl> <48D17BBE.5020807@garzik.org> <200809300006.24919.rjw@sisk.pl>
In-Reply-To: <200809300006.24919.rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200809300016.27190.rjw@sisk.pl>
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

SATA Sil: Blacklist system that spins off disks during ACPI power off

Some notebooks from HP have the problem that their BIOSes attempt to
spin down hard drives before entering ACPI system states S4 and S5.
This leads to a yo-yo effect during system power-off shutdown and the
last phase of hibernation when the disk is first spun down by the
kernel and then almost immediately turned on and off by the BIOS.
This, in turn, may result in shortening the disk's life times.

To prevent this from happening we can blacklist the affected systems
using DMI information.

Blacklist HP nx6325 that uses the sata_sil driver.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/ata/sata_sil.c |   36 +++++++++++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/ata/sata_sil.c
===================================================================
--- linux-2.6.orig/drivers/ata/sata_sil.c
+++ linux-2.6/drivers/ata/sata_sil.c
@@ -603,11 +603,38 @@ static void sil_init_controller(struct a
 	}
 }
 
+static bool sil_broken_system_poweroff(struct pci_dev *pdev)
+{
+	static const struct dmi_system_id broken_systems[] = {
+		{
+			.ident = "HP Compaq nx6325",
+			.matches = {
+				DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+				DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq nx6325"),
+			},
+			/* PCI slot number of the controller */
+			.driver_data = (void *)0x12UL,
+		},
+
+		{ }	/* terminate list */
+	};
+	const struct dmi_system_id *dmi = dmi_first_match(broken_systems);
+
+	if (dmi) {
+		unsigned long slot = (unsigned long)dmi->driver_data;
+		/* apply the quirk only to on-board controllers */
+		return slot == PCI_SLOT(pdev->devfn);
+	}
+
+	return false;
+}
+
 static int sil_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	static int printed_version;
 	int board_id = ent->driver_data;
-	const struct ata_port_info *ppi[] = { &sil_port_info[board_id], NULL };
+	struct ata_port_info pi = sil_port_info[board_id];
+	const struct ata_port_info *ppi[] = { &pi, NULL };
 	struct ata_host *host;
 	void __iomem *mmio_base;
 	int n_ports, rc;
@@ -621,6 +648,13 @@ static int sil_init_one(struct pci_dev *
 	if (board_id == sil_3114)
 		n_ports = 4;
 
+	if (sil_broken_system_poweroff(pdev)) {
+		pi.flags |= ATA_FLAG_NO_POWEROFF_SPINDOWN |
+					ATA_FLAG_NO_HIBERNATE_SPINDOWN;
+		dev_info(&pdev->dev, "quirky BIOS, skipping spindown "
+				"on poweroff and hibernation\n");
+	}
+
 	host = ata_host_alloc_pinfo(&pdev->dev, ppi, n_ports);
 	if (!host)
 		return -ENOMEM;

