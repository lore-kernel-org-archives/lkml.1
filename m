Return-Path: <linux-kernel-owner+w=401wt.eu-S1758230AbZLFXjI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758230AbZLFXjI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 18:39:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758159AbZLFXjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 18:39:04 -0500
Received: from kroah.org ([198.145.64.141]:33847 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758162AbZLFXix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 18:38:53 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 15:32:11 2009
Message-Id: <20091206233210.990907937@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 15:30:51 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Maciej Sosnowski <maciej.sosnowski@intel.com>,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [19/20] dca: redesign locks to fix deadlocks
References: <20091206233032.387950574@mini.kroah.org>
Content-Disposition: inline; filename=dca-redesign-locks-to-fix-deadlocks.patch
In-Reply-To: <20091206233711.GA11609@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Maciej Sosnowski <maciej.sosnowski@intel.com>

commit eb4400e3a040b90a3ad805b01fcbc99a5f615c8f upstream.

Change spin_locks to irqsave to prevent dead-locks.
Protect adding and deleting to/from dca_providers list.
Drop the lock during dca_sysfs_add_req() and dca_sysfs_remove_req() calls
as they might sleep (use GFP_KERNEL allocation).

Signed-off-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
Acked-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/dca/dca-core.c |   51 +++++++++++++++++++++++++++++++------------------
 1 file changed, 33 insertions(+), 18 deletions(-)

--- a/drivers/dca/dca-core.c
+++ b/drivers/dca/dca-core.c
@@ -28,7 +28,7 @@
 #include <linux/device.h>
 #include <linux/dca.h>
 
-#define DCA_VERSION "1.4"
+#define DCA_VERSION "1.8"
 
 MODULE_VERSION(DCA_VERSION);
 MODULE_LICENSE("GPL");
@@ -60,16 +60,17 @@ int dca_add_requester(struct device *dev
 {
 	struct dca_provider *dca;
 	int err, slot = -ENODEV;
+	unsigned long flags;
 
 	if (!dev)
 		return -EFAULT;
 
-	spin_lock(&dca_lock);
+	spin_lock_irqsave(&dca_lock, flags);
 
 	/* check if the requester has not been added already */
 	dca = dca_find_provider_by_dev(dev);
 	if (dca) {
-		spin_unlock(&dca_lock);
+		spin_unlock_irqrestore(&dca_lock, flags);
 		return -EEXIST;
 	}
 
@@ -78,19 +79,21 @@ int dca_add_requester(struct device *dev
 		if (slot >= 0)
 			break;
 	}
-	if (slot < 0) {
-		spin_unlock(&dca_lock);
+
+	spin_unlock_irqrestore(&dca_lock, flags);
+
+	if (slot < 0)
 		return slot;
-	}
 
 	err = dca_sysfs_add_req(dca, dev, slot);
 	if (err) {
-		dca->ops->remove_requester(dca, dev);
-		spin_unlock(&dca_lock);
+		spin_lock_irqsave(&dca_lock, flags);
+		if (dca == dca_find_provider_by_dev(dev))
+			dca->ops->remove_requester(dca, dev);
+		spin_unlock_irqrestore(&dca_lock, flags);
 		return err;
 	}
 
-	spin_unlock(&dca_lock);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(dca_add_requester);
@@ -103,25 +106,25 @@ int dca_remove_requester(struct device *
 {
 	struct dca_provider *dca;
 	int slot;
+	unsigned long flags;
 
 	if (!dev)
 		return -EFAULT;
 
-	spin_lock(&dca_lock);
+	spin_lock_irqsave(&dca_lock, flags);
 	dca = dca_find_provider_by_dev(dev);
 	if (!dca) {
-		spin_unlock(&dca_lock);
+		spin_unlock_irqrestore(&dca_lock, flags);
 		return -ENODEV;
 	}
 	slot = dca->ops->remove_requester(dca, dev);
-	if (slot < 0) {
-		spin_unlock(&dca_lock);
+	spin_unlock_irqrestore(&dca_lock, flags);
+
+	if (slot < 0)
 		return slot;
-	}
 
 	dca_sysfs_remove_req(dca, slot);
 
-	spin_unlock(&dca_lock);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(dca_remove_requester);
@@ -135,17 +138,18 @@ u8 dca_common_get_tag(struct device *dev
 {
 	struct dca_provider *dca;
 	u8 tag;
+	unsigned long flags;
 
-	spin_lock(&dca_lock);
+	spin_lock_irqsave(&dca_lock, flags);
 
 	dca = dca_find_provider_by_dev(dev);
 	if (!dca) {
-		spin_unlock(&dca_lock);
+		spin_unlock_irqrestore(&dca_lock, flags);
 		return -ENODEV;
 	}
 	tag = dca->ops->get_tag(dca, dev, cpu);
 
-	spin_unlock(&dca_lock);
+	spin_unlock_irqrestore(&dca_lock, flags);
 	return tag;
 }
 
@@ -217,11 +221,16 @@ static BLOCKING_NOTIFIER_HEAD(dca_provid
 int register_dca_provider(struct dca_provider *dca, struct device *dev)
 {
 	int err;
+	unsigned long flags;
 
 	err = dca_sysfs_add_provider(dca, dev);
 	if (err)
 		return err;
+
+	spin_lock_irqsave(&dca_lock, flags);
 	list_add(&dca->node, &dca_providers);
+	spin_unlock_irqrestore(&dca_lock, flags);
+
 	blocking_notifier_call_chain(&dca_provider_chain,
 				     DCA_PROVIDER_ADD, NULL);
 	return 0;
@@ -234,9 +243,15 @@ EXPORT_SYMBOL_GPL(register_dca_provider)
  */
 void unregister_dca_provider(struct dca_provider *dca)
 {
+	unsigned long flags;
+
 	blocking_notifier_call_chain(&dca_provider_chain,
 				     DCA_PROVIDER_REMOVE, NULL);
+
+	spin_lock_irqsave(&dca_lock, flags);
 	list_del(&dca->node);
+	spin_unlock_irqrestore(&dca_lock, flags);
+
 	dca_sysfs_remove_provider(dca);
 }
 EXPORT_SYMBOL_GPL(unregister_dca_provider);


