Return-Path: <linux-kernel-owner+w=401wt.eu-S1758143AbYKUTit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758143AbYKUTit (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 14:38:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757544AbYKUTie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 14:38:34 -0500
Received: from mga09.intel.com ([134.134.136.24]:51671 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758057AbYKUTic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 14:38:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,645,1220252400"; 
   d="scan'208";a="465874645"
Date: Sat, 22 Nov 2008 02:41:45 +0800
From: Yu Zhao <yu.zhao@intel.com>
To: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Cc: "achiang@hp.com" <achiang@hp.com>,
       "bjorn.helgaas@hp.com" <bjorn.helgaas@hp.com>,
       "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
       "greg@kroah.com" <greg@kroah.com>, "mingo@elte.hu" <mingo@elte.hu>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "matthew@wil.cx" <matthew@wil.cx>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       "rdreier@cisco.com" <rdreier@cisco.com>,
       "horms@verge.net.au" <horms@verge.net.au>,
       "yinghai@kernel.org" <yinghai@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: [PATCH 8/13 v7] PCI: cleanup pci_bus_add_devices()
Message-ID: <20081121184145.GI7810@yzhao12-linux.sh.intel.com>
References: <20081121183605.GA7810@yzhao12-linux.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081121183605.GA7810@yzhao12-linux.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This cleanup makes pci_bus_add_devices() easier to read.

Signed-off-by: Yu Zhao <yu.zhao@intel.com>

---
 drivers/pci/bus.c |   55 +++++++++++++++++++++++++++--------------------------
 1 files changed, 28 insertions(+), 27 deletions(-)

diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index 999cc40..9d800cb 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -71,7 +71,7 @@ pci_bus_alloc_resource(struct pci_bus *bus, struct resource *res,
 }
 
 /**
- * add a single device
+ * pci_bus_add_device - add a single device
  * @dev: device to add
  *
  * This adds a single pci device to the global
@@ -105,7 +105,7 @@ int pci_bus_add_device(struct pci_dev *dev)
 void pci_bus_add_devices(struct pci_bus *bus)
 {
 	struct pci_dev *dev;
-	struct pci_bus *child_bus;
+	struct pci_bus *child;
 	int retval;
 
 	list_for_each_entry(dev, &bus->devices, bus_list) {
@@ -120,39 +120,40 @@ void pci_bus_add_devices(struct pci_bus *bus)
 	list_for_each_entry(dev, &bus->devices, bus_list) {
 		BUG_ON(!dev->is_added);
 
+		child = dev->subordinate;
 		/*
 		 * If there is an unattached subordinate bus, attach
 		 * it and then scan for unattached PCI devices.
 		 */
-		if (dev->subordinate) {
-		       if (list_empty(&dev->subordinate->node)) {
-			       down_write(&pci_bus_sem);
-			       list_add_tail(&dev->subordinate->node,
-					       &dev->bus->children);
-			       up_write(&pci_bus_sem);
-			}
-			pci_bus_add_devices(dev->subordinate);
-
-			/* register the bus with sysfs as the parent is now
-			 * properly registered. */
-			child_bus = dev->subordinate;
-			if (child_bus->is_added)
-				continue;
-			child_bus->dev.parent = child_bus->bridge;
-			retval = device_register(&child_bus->dev);
-			if (retval)
-				dev_err(&dev->dev, "Error registering pci_bus,"
-					" continuing...\n");
-			else {
-				child_bus->is_added = 1;
-				retval = device_create_file(&child_bus->dev,
-							&dev_attr_cpuaffinity);
-			}
+		if (!child)
+			continue;
+		if (list_empty(&child->node)) {
+			down_write(&pci_bus_sem);
+			list_add_tail(&child->node, &dev->bus->children);
+			up_write(&pci_bus_sem);
+		}
+		pci_bus_add_devices(child);
+
+		/*
+		 * register the bus with sysfs as the parent is now
+		 * properly registered.
+		 */
+		if (child->is_added)
+			continue;
+		child->dev.parent = child->bridge;
+		retval = device_register(&child->dev);
+		if (retval)
+			dev_err(&dev->dev, "Error registering pci_bus,"
+				" continuing...\n");
+		else {
+			child->is_added = 1;
+			retval = device_create_file(&child->dev,
+						&dev_attr_cpuaffinity);
 			if (retval)
 				dev_err(&dev->dev, "Error creating cpuaffinity"
 					" file, continuing...\n");
 
-			retval = device_create_file(&child_bus->dev,
+			retval = device_create_file(&child->dev,
 						&dev_attr_cpulistaffinity);
 			if (retval)
 				dev_err(&dev->dev,
-- 
1.5.6.4

