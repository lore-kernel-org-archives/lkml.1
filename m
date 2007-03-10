Return-Path: <linux-kernel-owner+w=401wt.eu-S1767788AbXCJELG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767788AbXCJELG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 23:11:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767778AbXCJEKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 23:10:37 -0500
Received: from ns1.suse.de ([195.135.220.2]:36320 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767785AbXCJEKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 23:10:16 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-pci@atrey.karlin.mff.cuni.cz
Cc: linux-kernel@vger.kernel.org, pcihpd-discuss@lists.sourceforge.net,
       Tejun Heo <htejun@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/4] PCI: allow multiple calls to pcim_pin_device()
Date: Fri,  9 Mar 2007 20:08:31 -0800
Message-Id: <11734997142797-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.0.2
In-Reply-To: <20070310040356.GB30638@kroah.com>
References: <20070310040356.GB30638@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <htejun@gmail.com>

Sanity check in pcim_pin_device() was too restrictive in that it didn't
allow multiple calls to the function, which is against the devres
philosohpy of fire-and-forget.  Track pinned status separately and allow
pinning multiple times.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Acked-by: Ian McDonald <ian.mcdonald@jandi.co.nz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/pci/pci.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index df49530..a32db06 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -757,7 +757,8 @@ int pci_enable_device(struct pci_dev *dev)
  * when a device is enabled using managed PCI device enable interface.
  */
 struct pci_devres {
-	unsigned int disable:1;
+	unsigned int enabled:1;
+	unsigned int pinned:1;
 	unsigned int orig_intx:1;
 	unsigned int restore_intx:1;
 	u32 region_mask;
@@ -781,7 +782,7 @@ static void pcim_release(struct device *gendev, void *res)
 	if (this->restore_intx)
 		pci_intx(dev, this->orig_intx);
 
-	if (this->disable)
+	if (this->enabled && !this->pinned)
 		pci_disable_device(dev);
 }
 
@@ -820,12 +821,12 @@ int pcim_enable_device(struct pci_dev *pdev)
 	dr = get_pci_dr(pdev);
 	if (unlikely(!dr))
 		return -ENOMEM;
-	WARN_ON(!!dr->disable);
+	WARN_ON(!!dr->enabled);
 
 	rc = pci_enable_device(pdev);
 	if (!rc) {
 		pdev->is_managed = 1;
-		dr->disable = 1;
+		dr->enabled = 1;
 	}
 	return rc;
 }
@@ -843,9 +844,9 @@ void pcim_pin_device(struct pci_dev *pdev)
 	struct pci_devres *dr;
 
 	dr = find_pci_dr(pdev);
-	WARN_ON(!dr || !dr->disable);
+	WARN_ON(!dr || !dr->enabled);
 	if (dr)
-		dr->disable = 0;
+		dr->pinned = 1;
 }
 
 /**
@@ -876,7 +877,7 @@ pci_disable_device(struct pci_dev *dev)
 
 	dr = find_pci_dr(dev);
 	if (dr)
-		dr->disable = 0;
+		dr->enabled = 0;
 
 	if (atomic_sub_return(1, &dev->enable_cnt) != 0)
 		return;
-- 
1.5.0.2

