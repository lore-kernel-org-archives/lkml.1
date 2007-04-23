Return-Path: <linux-kernel-owner+w=401wt.eu-S1752413AbXDWNt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413AbXDWNt1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 09:49:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751690AbXDWNt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 09:49:27 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57251 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750888AbXDWNt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 09:49:26 -0400
Date: Mon, 23 Apr 2007 14:52:55 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matt_Domsch@dell.com, linux-kernel@vger.kernel.org
Subject: [PATCH] edd: Switch to refcounting PCI APIs
Message-ID: <20070423145255.3ff4369e@the-village.bc.nu>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc6-mm1/drivers/firmware/edd.c linux-2.6.21-rc6-mm1/drivers/firmware/edd.c
--- linux.vanilla-2.6.21-rc6-mm1/drivers/firmware/edd.c	2007-04-12 14:14:43.000000000 +0100
+++ linux-2.6.21-rc6-mm1/drivers/firmware/edd.c	2007-04-23 11:50:57.185158272 +0100
@@ -669,7 +669,7 @@
 	struct edd_info *info = edd_dev_get_info(edev);
 
 	if (edd_dev_is_type(edev, "PCI")) {
-		return pci_find_slot(info->params.interface_path.pci.bus,
+		return pci_get_slot(info->params.interface_path.pci.bus,
 				     PCI_DEVFN(info->params.interface_path.pci.slot,
 					       info->params.interface_path.pci.
 					       function));
@@ -682,9 +682,12 @@
 {
 
 	struct pci_dev *pci_dev = edd_get_pci_dev(edev);
+	int ret;
 	if (!pci_dev)
 		return 1;
-	return sysfs_create_link(&edev->kobj,&pci_dev->dev.kobj,"pci_dev");
+	ret = sysfs_create_link(&edev->kobj,&pci_dev->dev.kobj,"pci_dev");
+	pci_dev_put(pci_dev);
+	return ret;
 }
 
 static inline void
