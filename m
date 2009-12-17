Return-Path: <linux-kernel-owner+w=401wt.eu-S1753316AbZLQFrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbZLQFrf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 00:47:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752690AbZLQFra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 00:47:30 -0500
Received: from mga12.intel.com ([143.182.124.36]:19997 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752550AbZLQFr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 00:47:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="223878849"
Date: Thu, 17 Dec 2009 08:22:48 -0500
From: "Youquan,Song" <youquan.song@linux.intel.com>
To: jbarnes@virtuousgeek.org
Cc: andrew.patterson@hp.com, andi@firstfloor.org, ying.huang@intel.com,
       kent.liu@intel.com, youquan.song@intel.com,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [Resend PATCH]PCIe AER: reject aer inject if hardware mask error reporting
Message-ID: <20091217132248.GC11466@youquan-linux.bj.intel.com>
References: <20091211234855.GB7196@youquan-linux.bj.intel.com> <1260836954.19155.84.camel@bluto.andrew>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260836954.19155.84.camel@bluto.andrew>
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
index 7fcd533..d002cd9 100644
--- a/drivers/pci/pcie/aer/aer_inject.c
+++ b/drivers/pci/pcie/aer/aer_inject.c
@@ -321,7 +321,7 @@ static int aer_inject(struct aer_error_inj *einj)
 	unsigned long flags;
 	unsigned int devfn = PCI_DEVFN(einj->dev, einj->fn);
 	int pos_cap_err, rp_pos_cap_err;
-	u32 sever;
+	u32 sever, mask;
 	int ret = 0;
 
 	dev = pci_get_domain_bus_and_slot((int)einj->domain, einj->bus, devfn);
@@ -374,6 +374,24 @@ static int aer_inject(struct aer_error_inj *einj)
 	err->header_log2 = einj->header_log2;
 	err->header_log3 = einj->header_log3;
 
+	pci_read_config_dword(dev, pos_cap_err + PCI_ERR_COR_MASK, &mask);
+	if (einj->cor_status && !(einj->cor_status & ~mask)) {
+		ret = -EINVAL;
+		printk(KERN_WARNING "The correctable error(s) is masked "
+				"by device\n");
+		spin_unlock_irqrestore(&inject_lock, flags);
+		goto out_put;
+	}
+
+	pci_read_config_dword(dev, pos_cap_err + PCI_ERR_UNCOR_MASK, &mask);
+	if (einj->uncor_status && !(einj->uncor_status & ~mask)) {
+		ret = -EINVAL;
+		printk(KERN_WARNING "The uncorrectable error(s) is masked "
+				"by device\n");
+		spin_unlock_irqrestore(&inject_lock, flags);
+		goto out_put;
+	}
+
 	rperr = __find_aer_error_by_dev(rpdev);
 	if (!rperr) {
 		rperr = rperr_alloc;
