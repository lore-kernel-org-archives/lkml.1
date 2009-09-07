Return-Path: <linux-kernel-owner+w=401wt.eu-S1751698AbZIGGjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751698AbZIGGjy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 02:39:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750719AbZIGGjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 02:39:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:11083 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699AbZIGGjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 02:39:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,345,1249282800"; 
   d="scan'208";a="548346707"
Date: Mon, 7 Sep 2009 10:18:17 -0400
From: Youquan Song <youquan.song@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org,
       Suresh Siddha <suresh.b.siddha@intel.com>, youquan.song@intel.com
Subject: disallow interrupt remapping if not all ioapic under interrupt remapping
Message-ID: <20090907141817.GB26091@youquan-linux.bj.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current kernel enable interrupt remapping only when all the vt-d unit support
interrupt remapping. So it is reasonable we should also disallow enabling
intr-remapping if there any io-apics that are not listed under vt-d units. 
Otherwise we can run into issues.

Acked-by: Suresh Siddha <suresh.b.siddha@intel.com> 
Signed-off-by: Youquan Song <youquan.song@intel.com>
---

diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
index 7b287cb..a8a4383 100644
--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@ -570,9 +570,6 @@ int __init dmar_table_init(void)
 		printk(KERN_INFO PREFIX "No ATSR found\n");
 #endif
 
-#ifdef CONFIG_INTR_REMAP
-	parse_ioapics_under_ir();
-#endif
 	return 0;
 }
 
diff --git a/drivers/pci/intr_remapping.c b/drivers/pci/intr_remapping.c
index 4f5b871..ebfa47b 100644
--- a/drivers/pci/intr_remapping.c
+++ b/drivers/pci/intr_remapping.c
@@ -626,6 +626,11 @@ int __init enable_intr_remapping(int eim)
 	struct dmar_drhd_unit *drhd;
 	int setup = 0;
 
+	if (parse_ioapics_under_ir() != 1) {
+		printk(KERN_INFO "Not enable interrupt remapping\n");
+		return -1;
+	}
+
 	for_each_drhd_unit(drhd) {
 		struct intel_iommu *iommu = drhd->iommu;
 
