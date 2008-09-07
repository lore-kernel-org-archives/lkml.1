Return-Path: <linux-kernel-owner+w=401wt.eu-S1755723AbYIGPfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723AbYIGPfk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 11:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751531AbYIGPfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 11:35:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:48778 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbYIGPfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 11:35:31 -0400
Subject: [2.6.27 PATCH] Blacklist DMAR on Intel G31/G33 chipsets
From: David Woodhouse <dwmw2@infradead.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, andi@firstfloor.org, arjan@infradead.org,
       torvalds@linux-foundation.org, sfr@canb.auug.org.au,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20080905183459.GC14258@elte.hu>
References: <1220439231.2985.103.camel@pmac.infradead.org>
	 <1220518477.2985.163.camel@pmac.infradead.org>
	 <20080905183459.GC14258@elte.hu>
Content-Type: text/plain
Date: Sun, 07 Sep 2008 16:35:26 +0100
Message-Id: <1220801726.2985.450.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some BIOSes (the Intel DG33BU, for example) wrongly claim to have DMAR
when they don't. Avoid the resulting crashes when it doesn't work as
expected.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Acked-by: Ingo Molnar <mingo@elte.hu>

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 8d0e60a..c3edcdc 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -2348,11 +2348,34 @@ static void __init iommu_exit_mempool(void)
 
 }
 
+static int blacklist_iommu(const struct dmi_system_id *id)
+{
+	printk(KERN_INFO "%s detected; disabling IOMMU\n",
+	       id->ident);
+	dmar_disabled = 1;
+	return 0;
+}
+
+static struct dmi_system_id __initdata intel_iommu_dmi_table[] = {
+	{	/* Some DG33BU BIOS revisions advertised non-existent VT-d */
+		.callback = blacklist_iommu,
+		.ident = "Intel DG33BU",
+		{	DMI_MATCH(DMI_BOARD_VENDOR, "Intel Corporation"),
+			DMI_MATCH(DMI_BOARD_NAME, "DG33BU"),
+		}
+	},
+	{ }
+};
+
+
 void __init detect_intel_iommu(void)
 {
 	if (swiotlb || no_iommu || iommu_detected || dmar_disabled)
 		return;
 	if (early_dmar_detect()) {
+		dmi_check_system(intel_iommu_dmi_table);
+		if (dmar_disabled)
+			return;
 		iommu_detected = 1;
 	}
 }


-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



