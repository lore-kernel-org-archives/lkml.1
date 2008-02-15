Return-Path: <linux-kernel-owner+w=401wt.eu-S934614AbYBOAm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934614AbYBOAm0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 19:42:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751299AbYBOAmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 19:42:11 -0500
Received: from cantor.suse.de ([195.135.220.2]:37943 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbYBOAmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 19:42:09 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-pci@atrey.karlin.mff.cuni.cz
Cc: linux-kernel@vger.kernel.org, pcihpd-discuss@lists.sourceforge.net,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 01/12] PCI: remove pci_find_present
Date: Thu, 14 Feb 2008 16:39:59 -0800
Message-Id: <1203036010-27988-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.4
In-Reply-To: <20080215003909.GA27981@kroah.com>
References: <20080215003909.GA27981@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No one is using this function anymore for quite some time, so remove it.
Everyone calls pci_dev_present() instead anyway...

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/pci/search.c |   35 +++++++++++++++--------------------
 include/linux/pci.h  |    2 --
 2 files changed, 15 insertions(+), 22 deletions(-)

diff --git a/drivers/pci/search.c b/drivers/pci/search.c
index 8541034..1aabe3d 100644
--- a/drivers/pci/search.c
+++ b/drivers/pci/search.c
@@ -436,7 +436,18 @@ exit:
 	return dev;
 }
 
-const struct pci_device_id *pci_find_present(const struct pci_device_id *ids)
+/**
+ * pci_dev_present - Returns 1 if device matching the device list is present, 0 if not.
+ * @ids: A pointer to a null terminated list of struct pci_device_id structures
+ * that describe the type of PCI device the caller is trying to find.
+ *
+ * Obvious fact: You do not have a reference to any device that might be found
+ * by this function, so if that device is removed from the system right after
+ * this function is finished, the value will be stale.  Use this function to
+ * find devices that are usually built into a system, or for a general hint as
+ * to if another device happens to be present at this specific moment in time.
+ */
+int pci_dev_present(const struct pci_device_id *ids)
 {
 	struct pci_dev *dev;
 	const struct pci_device_id *found = NULL;
@@ -452,27 +463,11 @@ const struct pci_device_id *pci_find_present(const struct pci_device_id *ids)
 	}
 exit:
 	up_read(&pci_bus_sem);
-	return found;
-}
-
-/**
- * pci_dev_present - Returns 1 if device matching the device list is present, 0 if not.
- * @ids: A pointer to a null terminated list of struct pci_device_id structures
- * that describe the type of PCI device the caller is trying to find.
- *
- * Obvious fact: You do not have a reference to any device that might be found
- * by this function, so if that device is removed from the system right after
- * this function is finished, the value will be stale.  Use this function to
- * find devices that are usually built into a system, or for a general hint as
- * to if another device happens to be present at this specific moment in time.
- */
-int pci_dev_present(const struct pci_device_id *ids)
-{
-	return pci_find_present(ids) == NULL ? 0 : 1;
+	if (found)
+		return 1;
+	return 0;
 }
-
 EXPORT_SYMBOL(pci_dev_present);
-EXPORT_SYMBOL(pci_find_present);
 
 #ifdef CONFIG_PCI_LEGACY
 EXPORT_SYMBOL(pci_find_device);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 87195b6..8eebbff 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -517,7 +517,6 @@ struct pci_dev *pci_get_slot(struct pci_bus *bus, unsigned int devfn);
 struct pci_dev *pci_get_bus_and_slot(unsigned int bus, unsigned int devfn);
 struct pci_dev *pci_get_class(unsigned int class, struct pci_dev *from);
 int pci_dev_present(const struct pci_device_id *ids);
-const struct pci_device_id *pci_find_present(const struct pci_device_id *ids);
 
 int pci_bus_read_config_byte(struct pci_bus *bus, unsigned int devfn,
 			     int where, u8 *val);
@@ -807,7 +806,6 @@ static inline struct pci_dev *pci_get_class(unsigned int class,
 
 #define pci_dev_present(ids)	(0)
 #define no_pci_devices()	(1)
-#define pci_find_present(ids)	(NULL)
 #define pci_dev_put(dev)	do { } while (0)
 
 static inline void pci_set_master(struct pci_dev *dev)
-- 
1.5.4

