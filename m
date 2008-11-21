Return-Path: <linux-kernel-owner+w=401wt.eu-S1757979AbYKUTje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757979AbYKUTje (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 14:39:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755613AbYKUTjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 14:39:24 -0500
Received: from mga09.intel.com ([134.134.136.24]:43091 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752360AbYKUTjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 14:39:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,645,1220252400"; 
   d="scan'208";a="465874757"
Date: Sat, 22 Nov 2008 02:42:35 +0800
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
Subject: [PATCH 9/13 v7] PCI: split a new function from
	pci_bus_add_devices()
Message-ID: <20081121184235.GJ7810@yzhao12-linux.sh.intel.com>
References: <20081121183605.GA7810@yzhao12-linux.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081121183605.GA7810@yzhao12-linux.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch splits a new function from pci_bus_add_devices(). The new
function can be used to register PCI bus to the device core.

Signed-off-by: Yu Zhao <yu.zhao@intel.com>

---
 drivers/pci/bus.c |   49 ++++++++++++++++++++++++++++++-------------------
 drivers/pci/pci.h |    1 +
 2 files changed, 31 insertions(+), 19 deletions(-)

diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index 9d800cb..65f5a6f 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -91,6 +91,34 @@ int pci_bus_add_device(struct pci_dev *dev)
 }
 
 /**
+ * pci_bus_add_child - add a child bus
+ * @bus: bus to add
+ *
+ * This adds sysfs entries for a single bus
+ */
+int pci_bus_add_child(struct pci_bus *bus)
+{
+	int retval;
+
+	if (bus->bridge)
+		bus->dev.parent = bus->bridge;
+
+	retval = device_register(&bus->dev);
+	if (retval)
+		return retval;
+
+	bus->is_added = 1;
+
+	retval = device_create_file(&bus->dev, &dev_attr_cpuaffinity);
+	if (retval)
+		return retval;
+
+	retval = device_create_file(&bus->dev, &dev_attr_cpulistaffinity);
+
+	return retval;
+}
+
+/**
  * pci_bus_add_devices - insert newly discovered PCI devices
  * @bus: bus to check for new devices
  *
@@ -140,26 +168,9 @@ void pci_bus_add_devices(struct pci_bus *bus)
 		 */
 		if (child->is_added)
 			continue;
-		child->dev.parent = child->bridge;
-		retval = device_register(&child->dev);
+		retval = pci_bus_add_child(child);
 		if (retval)
-			dev_err(&dev->dev, "Error registering pci_bus,"
-				" continuing...\n");
-		else {
-			child->is_added = 1;
-			retval = device_create_file(&child->dev,
-						&dev_attr_cpuaffinity);
-			if (retval)
-				dev_err(&dev->dev, "Error creating cpuaffinity"
-					" file, continuing...\n");
-
-			retval = device_create_file(&child->dev,
-						&dev_attr_cpulistaffinity);
-			if (retval)
-				dev_err(&dev->dev,
-					"Error creating cpulistaffinity"
-					" file, continuing...\n");
-		}
+			dev_err(&dev->dev, "Error adding bus, continuing\n");
 	}
 }
 
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 3de70d7..315bbe6 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -170,6 +170,7 @@ extern int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 				struct resource *res, unsigned int reg);
 extern int pci_resource_bar(struct pci_dev *dev, int resno,
 			    enum pci_bar_type *type);
+extern int pci_bus_add_child(struct pci_bus *bus);
 extern void pci_enable_ari(struct pci_dev *dev);
 /**
  * pci_ari_enabled - query ARI forwarding status
-- 
1.5.6.4

