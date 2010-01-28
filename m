Return-Path: <linux-kernel-owner+w=401wt.eu-S932232Ab0A1I7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932232Ab0A1I7y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 03:59:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754253Ab0A1I7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 03:59:53 -0500
Received: from mga12.intel.com ([143.182.124.36]:29833 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754211Ab0A1I7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 03:59:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="237732966"
Date: Thu, 28 Jan 2010 11:34:05 -0500
From: "Youquan,Song" <youquan.song@linux.intel.com>
To: jbarnes@virtuousgeek.org
Cc: andi@firstfloor.org, ying.huang@intel.com, youquan.song@intel.com,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH]PCIE AER: PCI access remove spinlock protection in aer_inject
Message-ID: <20100128163405.GA2944@youquan-linux.bj.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the PCI configuration access code out of the spin_lock protection because
pci_read_aer already includes spin_lock protection which will replace the PCI
access method if have aer error injected.

Signed-off-by: Youquan, Song <youquan.song@intel.com>
---


diff --git a/drivers/pci/pcie/aer/aer_inject.c b/drivers/pci/pcie/aer/aer_inject.c
index 8c30a95..953a0b9 100644
--- a/drivers/pci/pcie/aer/aer_inject.c
+++ b/drivers/pci/pcie/aer/aer_inject.c
@@ -357,6 +357,22 @@ static int aer_inject(struct aer_error_inj *einj)
 		goto out_put;
 	}
 
+	pci_read_config_dword(dev, pos_cap_err + PCI_ERR_COR_MASK, &mask);
+	if (einj->cor_status && !(einj->cor_status & ~mask)) {
+		ret = -EINVAL;
+		printk(KERN_WARNING "The correctable error(s) is masked "
+				"by device\n");
+		goto out_put;
+	}
+
+	pci_read_config_dword(dev, pos_cap_err + PCI_ERR_UNCOR_MASK, &mask);
+	if (einj->uncor_status && !(einj->uncor_status & ~mask)) {
+		ret = -EINVAL;
+		printk(KERN_WARNING "The uncorrectable error(s) is masked "
+				"by device\n");
+		goto out_put;
+	}
+
 	spin_lock_irqsave(&inject_lock, flags);
 
 	err = __find_aer_error_by_dev(dev);
@@ -374,24 +390,6 @@ static int aer_inject(struct aer_error_inj *einj)
 	err->header_log2 = einj->header_log2;
 	err->header_log3 = einj->header_log3;
 
-	pci_read_config_dword(dev, pos_cap_err + PCI_ERR_COR_MASK, &mask);
-	if (einj->cor_status && !(einj->cor_status & ~mask)) {
-		ret = -EINVAL;
-		printk(KERN_WARNING "The correctable error(s) is masked "
-				"by device\n");
-		spin_unlock_irqrestore(&inject_lock, flags);
-		goto out_put;
-	}
-
-	pci_read_config_dword(dev, pos_cap_err + PCI_ERR_UNCOR_MASK, &mask);
-	if (einj->uncor_status && !(einj->uncor_status & ~mask)) {
-		ret = -EINVAL;
-		printk(KERN_WARNING "The uncorrectable error(s) is masked "
-				"by device\n");
-		spin_unlock_irqrestore(&inject_lock, flags);
-		goto out_put;
-	}
-
 	rperr = __find_aer_error_by_dev(rpdev);
 	if (!rperr) {
 		rperr = rperr_alloc;
