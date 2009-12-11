Return-Path: <linux-kernel-owner+w=401wt.eu-S933747AbZLKQNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933747AbZLKQNT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 11:13:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932799AbZLKQNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 11:13:15 -0500
Received: from mga05.intel.com ([192.55.52.89]:10263 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932797AbZLKQNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 11:13:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,382,1257148800"; 
   d="scan'208";a="755109092"
Date: Fri, 11 Dec 2009 18:48:55 -0500
From: "Youquan,Song" <youquan.song@linux.intel.com>
To: jbarnes@virtuousgeek.org
Cc: andi@firstfloor.org, ying.huang@intel.com, kent.liu@intel.com,
       youquan.song@intel.com, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: [PATCH]PCIe AER: reject aer inject if hardware mask error reporting
Message-ID: <20091211234855.GB7196@youquan-linux.bj.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correcteable/Uncorrectable Error Mask Register are used by PCIe AER driver 
which will controls the reporting of idividual errors to PCIe RC via PCIe
error messages. 

If hardware masks special error reporting to RC, the aer_inject driver should
 not inject aer error.

Signed-off-by: Youquan, Song <youquan.song@intel.com>
Acked-by: Ying, Huang <ying.huang@intel.com>
---

diff --git a/drivers/pci/pcie/aer/aer_inject.c b/drivers/pci/pcie/aer/aer_inject.c
index ad77f0c..fa2bc22 100644
--- a/drivers/pci/pcie/aer/aer_inject.c
+++ b/drivers/pci/pcie/aer/aer_inject.c
@@ -302,7 +302,7 @@ static int aer_inject(struct aer_error_inj *einj)
 	unsigned long flags;
 	unsigned int devfn = PCI_DEVFN(einj->dev, einj->fn);
 	int pos_cap_err, rp_pos_cap_err;
-	u32 sever;
+	u32 sever, mask;
 	int ret = 0;
 
 	dev = pci_get_bus_and_slot(einj->bus, devfn);
@@ -354,6 +354,22 @@ static int aer_inject(struct aer_error_inj *einj)
 	err->header_log2 = einj->header_log2;
 	err->header_log3 = einj->header_log3;
 
+	pci_read_config_dword(dev, pos_cap_err + PCI_ERR_COR_MASK, &mask);
+	if (einj->cor_status && !(einj->cor_status & ~mask)) {
+		ret = -EINVAL;
+		printk(KERN_WARNING "The correctable error is masked by device\n");
+		spin_unlock_irqrestore(&inject_lock, flags);
+		goto out_put;
+	}
+
+	pci_read_config_dword(dev, pos_cap_err + PCI_ERR_UNCOR_MASK, &mask);
+	if (einj->uncor_status && !(einj->uncor_status & ~mask)) {
+		ret = -EINVAL;
+		printk(KERN_WARNING "The uncorrectable error is masked by device\n");
+		spin_unlock_irqrestore(&inject_lock, flags);
+		goto out_put;
+	}
+
 	rperr = __find_aer_error_by_dev(rpdev);
 	if (!rperr) {
 		rperr = rperr_alloc;
