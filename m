Return-Path: <linux-kernel-owner+w=401wt.eu-S1767155AbXCIKqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767155AbXCIKqA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 05:46:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767158AbXCIKqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 05:46:00 -0500
Received: from nz-out-0506.google.com ([64.233.162.225]:45354 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767155AbXCIKp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 05:45:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=HM0+pjB4HAlM1yOgSqvIctQz+g/5+Twy4ImLmS7M4jfr+D8/7FysX+r9/7RyyTyDCYwT7a2pqdO1z3tIHeBa6h2XLBf5rjhq67Xrwoef74LdoKmBiCS3pxNsu9rG6AnPNg5QiDDoe87IW/9cv7vhrvnxoK4fqJ4TyJk+/60S2IM=
Date: Fri, 9 Mar 2007 19:45:58 +0900
From: Tejun Heo <htejun@gmail.com>
To: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org, gregkh@suse.de,
       linux-kernel@vger.kernel.org
Subject: [PATCH] iomap: implement pcim_iounmap_regions()
Message-ID: <20070309104558.GE32687@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Implement pcim_iounmap_regions() - the opposite of
pcim_iomap_regions().

Signed-off-by: Tejun heo <htejun@gmail.com>
---
This one is used by libata's new init model and generally useful for
driver midlayers.  Please push it through libata-dev#upstream.

Thanks.

 include/linux/pci.h |    1 +
 lib/devres.c        |   26 ++++++++++++++++++++++++++
 2 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/include/linux/pci.h b/include/linux/pci.h
index 2c4b684..8d3b221 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -844,6 +844,7 @@ void __iomem * pcim_iomap(struct pci_dev *pdev, int bar, unsigned long maxlen);
 void pcim_iounmap(struct pci_dev *pdev, void __iomem *addr);
 void __iomem * const * pcim_iomap_table(struct pci_dev *pdev);
 int pcim_iomap_regions(struct pci_dev *pdev, u16 mask, const char *name);
+void pcim_iounmap_regions(struct pci_dev *pdev, u16 mask);
 
 extern int pci_pci_problems;
 #define PCIPCI_FAIL		1	/* No PCI PCI DMA */
diff --git a/lib/devres.c b/lib/devres.c
index eb38849..b1d336c 100644
--- a/lib/devres.c
+++ b/lib/devres.c
@@ -296,5 +296,31 @@ int pcim_iomap_regions(struct pci_dev *pdev, u16 mask, const char *name)
 	return rc;
 }
 EXPORT_SYMBOL(pcim_iomap_regions);
+
+/**
+ * pcim_iounmap_regions - Unmap and release PCI BARs
+ * @pdev: PCI device to map IO resources for
+ * @mask: Mask of BARs to unmap and release
+ *
+ * Unamp and release regions specified by @mask.
+ */
+void pcim_iounmap_regions(struct pci_dev *pdev, u16 mask)
+{
+	void __iomem * const *iomap;
+	int i;
+
+	iomap = pcim_iomap_table(pdev);
+	if (!iomap)
+		return;
+
+	for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
+		if (!(mask & (1 << i)))
+			continue;
+
+		pcim_iounmap(pdev, iomap[i]);
+		pci_release_region(pdev, i);
+	}
+}
+EXPORT_SYMBOL(pcim_iounmap_regions);
 #endif
 #endif
-- 
1.5.0.1

