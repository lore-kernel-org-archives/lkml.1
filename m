Return-Path: <linux-kernel-owner+w=401wt.eu-S1758518AbZASUD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758518AbZASUD0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 15:03:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754757AbZASUBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 15:01:06 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39390 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753403AbZASUA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 15:00:56 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH 6/6] SATA PIIX: Blacklist system that spins off disks during ACPI power off
Date: Mon, 19 Jan 2009 20:59:22 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc2-tst; KDE/4.1.3; x86_64; ; )
Cc: Frans Pop <elendil@planet.nl>, tj@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20081104062734.GA4420@havoc.gtf.org> <49739371.5030107@garzik.org> <200901192053.50831.rjw@sisk.pl>
In-Reply-To: <200901192053.50831.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901192059.23448.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Some notebooks from HP have the problem that their BIOSes attempt to
spin down hard drives before entering ACPI system states S4 and S5.
This leads to a yo-yo effect during system power-off shutdown and the
last phase of hibernation when the disk is first spun down by the
kernel and then almost immediately turned on and off by the BIOS.
This, in turn, may result in shortening the disk's life times.

To prevent this from happening we can blacklist the affected systems
using DMI information.

Blacklist HP 2510p that uses the ata_piix driver.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/ata/ata_piix.c |   34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

Index: linux-2.6/drivers/ata/ata_piix.c
===================================================================
--- linux-2.6.orig/drivers/ata/ata_piix.c
+++ linux-2.6/drivers/ata/ata_piix.c
@@ -1387,6 +1387,32 @@ static void piix_iocfg_bit18_quirk(struc
 	}
 }
 
+static bool piix_broken_system_poweroff(struct pci_dev *pdev)
+{
+	static const struct dmi_system_id broken_systems[] = {
+		{
+			.ident = "HP Compaq 2510p",
+			.matches = {
+				DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+				DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq 2510p"),
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
 /**
  *	piix_init_one - Register PIIX ATA PCI device with kernel services
  *	@pdev: PCI device to register
@@ -1422,6 +1448,14 @@ static int __devinit piix_init_one(struc
 	if (!in_module_init)
 		return -ENODEV;
 
+	if (piix_broken_system_poweroff(pdev)) {
+		piix_port_info[ent->driver_data].flags |=
+				ATA_FLAG_NO_POWEROFF_SPINDOWN |
+					ATA_FLAG_NO_HIBERNATE_SPINDOWN;
+		dev_info(&pdev->dev, "quirky BIOS, skipping spindown "
+				"on poweroff and hibernation\n");
+	}
+
 	port_info[0] = piix_port_info[ent->driver_data];
 	port_info[1] = piix_port_info[ent->driver_data];
 

