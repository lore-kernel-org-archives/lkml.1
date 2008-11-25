Return-Path: <linux-kernel-owner+w=401wt.eu-S1753172AbYKYVYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172AbYKYVYf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 16:24:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752121AbYKYVY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 16:24:27 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:33897 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752023AbYKYVY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 16:24:26 -0500
From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH] fakephp: Allocate PCI resources before adding the device
To: "Darrick J. Wong" <djwong@us.ibm.com>, Greg K-H <greg@kroah.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 25 Nov 2008 13:24:22 -0800
Message-ID: <20081125212422.22631.69619.stgit@elm3a70.beaverton.ibm.com>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For PCI devices, pci_bus_assign_resources() must be called to set up the
pci_device->resource array before pci_bus_add_devices() can be called, else
attempts to load drivers results in BAR collision errors where there are none.
This is not done in fakephp, so devices can be "unplugged" but scanning the
parent bus won't bring the devices back due to resource unallocation.  Move the
pci_bus_add_device-calling logic into pci_rescan_bus and preface it with a call
to pci_bus_assign_resources so that we only have to (re)allocate resources once
per bus where a new device is found.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 drivers/pci/hotplug/fakephp.c |   42 +++++++++++++++++++++++++----------------
 1 files changed, 26 insertions(+), 16 deletions(-)

diff --git a/drivers/pci/hotplug/fakephp.c b/drivers/pci/hotplug/fakephp.c
index 3a2637a..a3826e6 100644
--- a/drivers/pci/hotplug/fakephp.c
+++ b/drivers/pci/hotplug/fakephp.c
@@ -195,13 +195,13 @@ static void remove_slot_worker(struct work_struct *work)
  * Tries hard not to re-enable already existing devices;
  * also handles scanning of subfunctions.
  */
-static void pci_rescan_slot(struct pci_dev *temp)
+static int pci_rescan_slot(struct pci_dev *temp)
 {
 	struct pci_bus *bus = temp->bus;
 	struct pci_dev *dev;
 	int func;
-	int retval;
 	u8 hdr_type;
+	int count = 0;
 
 	if (!pci_read_config_byte(temp, PCI_HEADER_TYPE, &hdr_type)) {
 		temp->hdr_type = hdr_type & 0x7f;
@@ -213,17 +213,12 @@ static void pci_rescan_slot(struct pci_dev *temp)
 				dbg("New device on %s function %x:%x\n",
 					bus->name, temp->devfn >> 3,
 					temp->devfn & 7);
-				retval = pci_bus_add_device(dev);
-				if (retval)
-					dev_err(&dev->dev, "error adding "
-						"device, continuing.\n");
-				else
-					add_slot(dev);
+				count++;
 			}
 		}
 		/* multifunction device? */
 		if (!(hdr_type & 0x80))
-			return;
+			return count;
 
 		/* continue scanning for other functions */
 		for (func = 1, temp->devfn++; func < 8; func++, temp->devfn++) {
@@ -239,16 +234,13 @@ static void pci_rescan_slot(struct pci_dev *temp)
 					dbg("New device on %s function %x:%x\n",
 						bus->name, temp->devfn >> 3,
 						temp->devfn & 7);
-					retval = pci_bus_add_device(dev);
-					if (retval)
-						dev_err(&dev->dev, "error adding "
-							"device, continuing.\n");
-					else
-						add_slot(dev);
+					count++;
 				}
 			}
 		}
 	}
+
+	return count;
 }
 
 
@@ -262,6 +254,8 @@ static void pci_rescan_bus(const struct pci_bus *bus)
 {
 	unsigned int devfn;
 	struct pci_dev *dev;
+	int retval;
+	int found = 0;
 	dev = alloc_pci_dev();
 	if (!dev)
 		return;
@@ -270,7 +264,23 @@ static void pci_rescan_bus(const struct pci_bus *bus)
 	dev->sysdata = bus->sysdata;
 	for (devfn = 0; devfn < 0x100; devfn += 8) {
 		dev->devfn = devfn;
-		pci_rescan_slot(dev);
+		found += pci_rescan_slot(dev);
+	}
+
+	if (found) {
+		pci_bus_assign_resources(bus);
+		list_for_each_entry(dev, &bus->devices, bus_list) {
+			/* Skip already-added devices */
+			if (dev->is_added)
+					continue;
+			retval = pci_bus_add_device(dev);
+			if (retval)
+				dev_err(&dev->dev,
+					"Error adding device, continuing\n");
+			else
+				add_slot(dev);
+		}
+		pci_bus_add_devices(bus);
 	}
 	kfree(dev);
 }

