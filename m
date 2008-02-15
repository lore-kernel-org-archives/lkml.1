Return-Path: <linux-kernel-owner+w=401wt.eu-S934775AbYBOAn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934775AbYBOAn6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 19:43:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934578AbYBOAmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 19:42:25 -0500
Received: from ns.suse.de ([195.135.220.2]:37968 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933917AbYBOAmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 19:42:24 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-pci@atrey.karlin.mff.cuni.cz
Cc: linux-kernel@vger.kernel.org, pcihpd-discuss@lists.sourceforge.net,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 04/12] PCI: remove pci_get_device_reverse
Date: Thu, 14 Feb 2008 16:40:02 -0800
Message-Id: <1203036010-27988-4-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.4
In-Reply-To: <20080215003909.GA27981@kroah.com>
References: <20080215003909.GA27981@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes the pci_get_device_reverse function as there should not be
any need to walk pci devices backwards anymore.  All users of this call
are now gone from the tree, so it is safe to remove it.

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/pci/search.c |   41 -----------------------------------------
 include/linux/pci.h  |   10 ----------
 2 files changed, 0 insertions(+), 51 deletions(-)

diff --git a/drivers/pci/search.c b/drivers/pci/search.c
index 1aabe3d..a04c43f 100644
--- a/drivers/pci/search.c
+++ b/drivers/pci/search.c
@@ -360,46 +360,6 @@ pci_get_device(unsigned int vendor, unsigned int device, struct pci_dev *from)
 }
 
 /**
- * pci_get_device_reverse - begin or continue searching for a PCI device by vendor/device id
- * @vendor: PCI vendor id to match, or %PCI_ANY_ID to match all vendor ids
- * @device: PCI device id to match, or %PCI_ANY_ID to match all device ids
- * @from: Previous PCI device found in search, or %NULL for new search.
- *
- * Iterates through the list of known PCI devices in the reverse order of
- * pci_get_device.
- * If a PCI device is found with a matching @vendor and @device, the reference
- * count to the  device is incremented and a pointer to its device structure
- * is returned Otherwise, %NULL is returned.  A new search is initiated by
- * passing %NULL as the @from argument.  Otherwise if @from is not %NULL,
- * searches continue from next device on the global list.  The reference
- * count for @from is always decremented if it is not %NULL.
- */
-struct pci_dev *
-pci_get_device_reverse(unsigned int vendor, unsigned int device, struct pci_dev *from)
-{
-	struct list_head *n;
-	struct pci_dev *dev;
-
-	WARN_ON(in_interrupt());
-	down_read(&pci_bus_sem);
-	n = from ? from->global_list.prev : pci_devices.prev;
-
-	while (n && (n != &pci_devices)) {
-		dev = pci_dev_g(n);
-		if ((vendor == PCI_ANY_ID || dev->vendor == vendor) &&
-		    (device == PCI_ANY_ID || dev->device == device))
-			goto exit;
-		n = n->prev;
-	}
-	dev = NULL;
-exit:
-	dev = pci_dev_get(dev);
-	up_read(&pci_bus_sem);
-	pci_dev_put(from);
-	return dev;
-}
-
-/**
  * pci_get_class - begin or continue searching for a PCI device by class
  * @class: search for a PCI device with this class designation
  * @from: Previous PCI device found in search, or %NULL for new search.
@@ -479,7 +439,6 @@ EXPORT_SYMBOL(pci_find_bus);
 EXPORT_SYMBOL(pci_find_next_bus);
 /* For everyone */
 EXPORT_SYMBOL(pci_get_device);
-EXPORT_SYMBOL(pci_get_device_reverse);
 EXPORT_SYMBOL(pci_get_subsys);
 EXPORT_SYMBOL(pci_get_slot);
 EXPORT_SYMBOL(pci_get_bus_and_slot);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 8eebbff..99cd9b2 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -507,9 +507,6 @@ struct pci_bus *pci_find_next_bus(const struct pci_bus *from);
 
 struct pci_dev *pci_get_device(unsigned int vendor, unsigned int device,
 				struct pci_dev *from);
-struct pci_dev *pci_get_device_reverse(unsigned int vendor, unsigned int device,
-				struct pci_dev *from);
-
 struct pci_dev *pci_get_subsys(unsigned int vendor, unsigned int device,
 				unsigned int ss_vendor, unsigned int ss_device,
 				struct pci_dev *from);
@@ -782,13 +779,6 @@ static inline struct pci_dev *pci_get_device(unsigned int vendor,
 	return NULL;
 }
 
-static inline struct pci_dev *pci_get_device_reverse(unsigned int vendor,
-						     unsigned int device,
-						     struct pci_dev *from)
-{
-	return NULL;
-}
-
 static inline struct pci_dev *pci_get_subsys(unsigned int vendor,
 					     unsigned int device,
 					     unsigned int ss_vendor,
-- 
1.5.4

