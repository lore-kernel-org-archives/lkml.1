Return-Path: <linux-kernel-owner+w=401wt.eu-S1755168AbYJVJhB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168AbYJVJhB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 05:37:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752799AbYJVJgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 05:36:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:31505 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752292AbYJVJgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 05:36:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,463,1220252400"; 
   d="scan'208";a="351087281"
Date: Wed, 22 Oct 2008 16:40:41 +0800
From: Yu Zhao <yu.zhao@intel.com>
To: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Cc: "achiang@hp.com" <achiang@hp.com>,
       "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
       "greg@kroah.com" <greg@kroah.com>, "mingo@elte.hu" <mingo@elte.hu>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "matthew@wil.cx" <matthew@wil.cx>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       "rdreier@cisco.com" <rdreier@cisco.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: [PATCH 2/16 v6] PCI: define PCI resource names in an 'enum'
Message-ID: <20081022084041.GB3773@yzhao12-linux.sh.intel.com>
References: <20081022083809.GA3757@yzhao12-linux.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081022083809.GA3757@yzhao12-linux.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves all definitions of the PCI resource names to an 'enum',
and also replaces some hard-coded resource variables with symbol
names. This change eases introduction of device specific resources.

Cc: Alex Chiang <achiang@hp.com>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Greg KH <greg@kroah.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Roland Dreier <rdreier@cisco.com>
Signed-off-by: Yu Zhao <yu.zhao@intel.com>

---
 drivers/pci/pci-sysfs.c |    4 +++-
 drivers/pci/pci.c       |   19 ++-----------------
 drivers/pci/probe.c     |    2 +-
 drivers/pci/proc.c      |    7 ++++---
 include/linux/pci.h     |   37 ++++++++++++++++++++++++-------------
 5 files changed, 34 insertions(+), 35 deletions(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 110022d..5c456ab 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -101,11 +101,13 @@ resource_show(struct device * dev, struct device_attribute *attr, char * buf)
 	struct pci_dev * pci_dev = to_pci_dev(dev);
 	char * str = buf;
 	int i;
-	int max = 7;
+	int max;
 	resource_size_t start, end;
 
 	if (pci_dev->subordinate)
 		max = DEVICE_COUNT_RESOURCE;
+	else
+		max = PCI_BRIDGE_RESOURCES;
 
 	for (i = 0; i < max; i++) {
 		struct resource *res =  &pci_dev->resource[i];
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index ae62f01..40284dc 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -359,24 +359,9 @@ pci_find_parent_resource(const struct pci_dev *dev, struct resource *res)
 static void
 pci_restore_bars(struct pci_dev *dev)
 {
-	int i, numres;
-
-	switch (dev->hdr_type) {
-	case PCI_HEADER_TYPE_NORMAL:
-		numres = 6;
-		break;
-	case PCI_HEADER_TYPE_BRIDGE:
-		numres = 2;
-		break;
-	case PCI_HEADER_TYPE_CARDBUS:
-		numres = 1;
-		break;
-	default:
-		/* Should never get here, but just in case... */
-		return;
-	}
+	int i;
 
-	for (i = 0; i < numres; i++)
+	for (i = 0; i < PCI_BRIDGE_RESOURCES; i++)
 		pci_update_resource(dev, i);
 }
 
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index aaaf0a1..a52784c 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -426,7 +426,7 @@ static struct pci_bus *pci_alloc_child_bus(struct pci_bus *parent,
 	child->subordinate = 0xff;
 
 	/* Set up default resource pointers and names.. */
-	for (i = 0; i < 4; i++) {
+	for (i = 0; i < PCI_BRIDGE_RES_NUM; i++) {
 		child->resource[i] = &bridge->resource[PCI_BRIDGE_RESOURCES+i];
 		child->resource[i]->name = child->name;
 	}
diff --git a/drivers/pci/proc.c b/drivers/pci/proc.c
index e1098c3..f6f2a59 100644
--- a/drivers/pci/proc.c
+++ b/drivers/pci/proc.c
@@ -352,15 +352,16 @@ static int show_device(struct seq_file *m, void *v)
 			dev->vendor,
 			dev->device,
 			dev->irq);
-	/* Here should be 7 and not PCI_NUM_RESOURCES as we need to preserve compatibility */
-	for (i=0; i<7; i++) {
+
+	/* only print standard and ROM resources to preserve compatibility */
+	for (i = 0; i <= PCI_ROM_RESOURCE; i++) {
 		resource_size_t start, end;
 		pci_resource_to_user(dev, i, &dev->resource[i], &start, &end);
 		seq_printf(m, "\t%16llx",
 			(unsigned long long)(start |
 			(dev->resource[i].flags & PCI_REGION_FLAG_MASK)));
 	}
-	for (i=0; i<7; i++) {
+	for (i = 0; i <= PCI_ROM_RESOURCE; i++) {
 		resource_size_t start, end;
 		pci_resource_to_user(dev, i, &dev->resource[i], &start, &end);
 		seq_printf(m, "\t%16llx",
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 43e1fc1..2ada2b6 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -76,7 +76,30 @@ enum pci_mmap_state {
 #define PCI_DMA_FROMDEVICE	2
 #define PCI_DMA_NONE		3
 
-#define DEVICE_COUNT_RESOURCE	12
+/*
+ *  For PCI devices, the region numbers are assigned this way:
+ */
+enum {
+	/* #0-5: standard PCI regions */
+	PCI_STD_RESOURCES,
+	PCI_STD_RESOURCES_END = 5,
+
+	/* #6: expansion ROM */
+	PCI_ROM_RESOURCE,
+
+	/* address space assigned to buses behind the bridge */
+#ifndef PCI_BRIDGE_RES_NUM
+#define PCI_BRIDGE_RES_NUM 4
+#endif
+	PCI_BRIDGE_RESOURCES,
+	PCI_BRIDGE_RES_END = PCI_BRIDGE_RESOURCES + PCI_BRIDGE_RES_NUM - 1,
+
+	/* total resources associated with a PCI device */
+	PCI_NUM_RESOURCES,
+
+	/* preserve this for compatibility */
+	DEVICE_COUNT_RESOURCE
+};
 
 typedef int __bitwise pci_power_t;
 
@@ -262,18 +285,6 @@ static inline void pci_add_saved_cap(struct pci_dev *pci_dev,
 	hlist_add_head(&new_cap->next, &pci_dev->saved_cap_space);
 }
 
-/*
- *  For PCI devices, the region numbers are assigned this way:
- *
- *	0-5	standard PCI regions
- *	6	expansion ROM
- *	7-10	bridges: address space assigned to buses behind the bridge
- */
-
-#define PCI_ROM_RESOURCE	6
-#define PCI_BRIDGE_RESOURCES	7
-#define PCI_NUM_RESOURCES	11
-
 #ifndef PCI_BUS_NUM_RESOURCES
 #define PCI_BUS_NUM_RESOURCES	16
 #endif
-- 
1.5.6.4

