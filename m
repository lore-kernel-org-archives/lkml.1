Return-Path: <linux-kernel-owner+w=401wt.eu-S1754846AbYCKKvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846AbYCKKvy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 06:51:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752346AbYCKKvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 06:51:45 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:46923 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbYCKKvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 06:51:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding;
        b=xkbCYYoF604N2zjl3g6MsOie7ovMycwOhenpaumjp0X4UX6IbwEV4CxK9kejZSmJZtj68wBK/7zee+Cn4oQhKCbvmfFyc1VD/jAwwmzjFFEF8PeEyIXICvJN1Jnk2pJtTvnAf6GUpDMR4o5npOw25d2e3D1Io9FFKBXfyByqJ7Q=
Message-ID: <47D6643A.6060001@gmail.com>
Date: Tue, 11 Mar 2008 19:51:38 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux-pci@atrey.karlin.mff.cuni.cz,
       Linux Kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Jeff Garzik <jeff@garzik.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] devres: implement pcim_iomap_regions_request_all()
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some drivers need to reserve all PCI BARs to prevent other drivers
misusing unoccupied BARs.  pcim_iomap_regions_request_all() requests
all BARs and iomap specified BARs.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jeff Garzik <jeff@garzik.org>
---
After acked, it's probably best to push this through libata-dev as
that's the only user for now.

Thanks.

 lib/devres.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

Index: work/lib/devres.c
===================================================================
--- work.orig/lib/devres.c
+++ work/lib/devres.c
@@ -298,6 +298,31 @@ int pcim_iomap_regions(struct pci_dev *p
 EXPORT_SYMBOL(pcim_iomap_regions);
 
 /**
+ * pcim_iomap_regions_request_all - Request all BARs and iomap specified ones
+ * @pdev: PCI device to map IO resources for
+ * @mask: Mask of BARs to iomap
+ * @name: Name used when requesting regions
+ *
+ * Request all PCI BARs and iomap regions specified by @mask.
+ */
+int pcim_iomap_regions_request_all(struct pci_dev *pdev, u16 mask,
+				   const char *name)
+{
+	int request_mask = ((1 << 6) - 1) & ~mask;
+	int rc;
+
+	rc = pci_request_selected_regions(pdev, request_mask, name);
+	if (rc)
+		return rc;
+
+	rc = pcim_iomap_regions(pdev, mask, name);
+	if (rc)
+		pci_release_selected_regions(pdev, request_mask);
+	return rc;
+}
+EXPORT_SYMBOL(pcim_iomap_regions_request_all);
+
+/**
  * pcim_iounmap_regions - Unmap and release PCI BARs
  * @pdev: PCI device to map IO resources for
  * @mask: Mask of BARs to unmap and release
