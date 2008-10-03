Return-Path: <linux-kernel-owner+w=401wt.eu-S1754359AbYJCVz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359AbYJCVz4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 17:55:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753437AbYJCVzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 17:55:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41521 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752911AbYJCVzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 17:55:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4/6] SATA AHCI: Blacklist system that spins off disks during ACPI power off
Date: Fri, 3 Oct 2008 23:57:52 +0200
User-Agent: KMail/1.9.9
Cc: Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       linux-ide@vger.kernel.org, Thomas Renninger <trenn@suse.de>,
       Robert Hancock <hancockr@shaw.ca>, LKML <linux-kernel@vger.kernel.org>,
       Frans Pop <elendil@planet.nl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
References: <200808290002.55026.rjw@sisk.pl> <200810031703.32114.rjw@sisk.pl> <200810032348.59709.rjw@sisk.pl>
In-Reply-To: <200810032348.59709.rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200810032357.53024.rjw@sisk.pl>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

SATA AHCI: Blacklist system that spins off disks during ACPI power off

Some notebooks from HP have the problem that their BIOSes attempt to
spin down hard drives before entering ACPI system states S4 and S5.
This leads to a yo-yo effect during system power-off shutdown and the
last phase of hibernation when the disk is first spun down by the
kernel and then almost immediately turned on and off by the BIOS.
This, in turn, may result in shortening the disk's life times.

To prevent this from happening we can blacklist the affected systems
using DMI information.

Blacklist HP nx6310 that uses the AHCI driver.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Tejun Heo <htejun@gmail.com>
---
 drivers/ata/ahci.c |   32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

Index: linux-2.6/drivers/ata/ahci.c
===================================================================
--- linux-2.6.orig/drivers/ata/ahci.c
+++ linux-2.6/drivers/ata/ahci.c
@@ -2528,6 +2528,32 @@ static void ahci_p5wdh_workaround(struct
 	}
 }
 
+static bool ahci_broken_system_poweroff(struct pci_dev *pdev)
+{
+	static const struct dmi_system_id broken_systems[] = {
+		{
+			.ident = "HP Compaq nx6310",
+			.matches = {
+				DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+				DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq nx6310"),
+			},
+			/* PCI slot number of the controller */
+			.driver_data = (void *)0x1FUL,
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
 static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	static int printed_version;
@@ -2623,6 +2649,12 @@ static int ahci_init_one(struct pci_dev 
 		}
 	}
 
+	if (ahci_broken_system_poweroff(pdev)) {
+		pi.flags |= ATA_FLAG_NO_POWEROFF_SPINDOWN;
+		dev_info(&pdev->dev,
+			"quirky BIOS, skipping spindown on poweroff\n");
+	}
+
 	/* CAP.NP sometimes indicate the index of the last enabled
 	 * port, at other times, that of the last possible port, so
 	 * determining the maximum port number requires looking at

