Return-Path: <linux-kernel-owner+w=401wt.eu-S1030357AbXC2QiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030357AbXC2QiK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 12:38:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030352AbXC2QiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 12:38:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59804 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030357AbXC2QiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 12:38:09 -0400
Subject: [PATCH] Fix 82875 PCI setup
From: Adam Jackson <ajackson@redhat.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Thu, 29 Mar 2007 12:16:40 -0400
Message-Id: <1175185000.26247.33.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 (2.10.0-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Feeney <jfeeney@redhat.com>

The 82875 EDAC driver enables an otherwise-hidden PCI device, but
doesn't register it as a PCI device properly.  Therefore, the device
list in /proc/bus/pci/devices is different than the tree in 
/sys/bus/pci. This usually manifests as the X server failing to start,
since it expects the two lists to be consistent.

Signed-off-by: Adam Jackson <ajackson@redhat.com>

--- linux-2.6.18.noarch/drivers/edac/i82875p_edac.c~
+++ linux-2.6.18.noarch/drivers/edac/i82875p_edac.c
@@ -261,10 +261,6 @@ static void i82875p_check(struct mem_ctl
 	i82875p_process_error_info(mci, &info, 1);
 }
 
-#ifdef CONFIG_PROC_FS
-extern int pci_proc_attach_device(struct pci_dev *);
-#endif
-
 /* Return 0 on success or 1 on failure. */
 static int i82875p_setup_overfl_dev(struct pci_dev *pdev,
 		struct pci_dev **ovrfl_pdev, void __iomem **ovrfl_window)
@@ -287,17 +283,12 @@ static int i82875p_setup_overfl_dev(stru
 
 		if (dev == NULL)
 			return 1;
+
+        	pci_bus_add_device(dev);
 	}
 
 	*ovrfl_pdev = dev;
 
-#ifdef CONFIG_PROC_FS
-	if ((dev->procent == NULL) && pci_proc_attach_device(dev)) {
-		i82875p_printk(KERN_ERR, "%s(): Failed to attach overflow "
-			       "device\n", __func__);
-		return 1;
-	}
-#endif  /* CONFIG_PROC_FS */
 	if (pci_enable_device(dev)) {
 		i82875p_printk(KERN_ERR, "%s(): Failed to enable overflow "
 			       "device\n", __func__);



