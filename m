Return-Path: <linux-kernel-owner+w=401wt.eu-S1759451AbXKTSWG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759451AbXKTSWG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 13:22:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752484AbXKTSV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 13:21:56 -0500
Received: from mga10.intel.com ([192.55.52.92]:61741 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750884AbXKTSVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 13:21:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,442,1188802800"; 
   d="scan'208";a="395094554"
Date: Tue, 20 Nov 2007 10:22:20 -0800
From: mark gross <mgross@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] intel-iommu-fault_reason_index_cleanup.patch
Message-ID: <20071120182220.GC18038@linux.intel.com>
Reply-To: mgross@linux.intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch fixes an off by one bug in the fault reason string
reporting function, and cleans up some of the code around this buglet.


please apply.

--mgross

Signed-off-by: mark gross <mgross@linux.intel.com>


Index: linux-2.6.23-rc2-iommu/drivers/pci/intel-iommu.c
===================================================================
--- linux-2.6.23-rc2-iommu.orig/drivers/pci/intel-iommu.c	2007-11-20 10:04:39.000000000 -0800
+++ linux-2.6.23-rc2-iommu/drivers/pci/intel-iommu.c	2007-11-20 10:10:48.000000000 -0800
@@ -745,7 +745,7 @@
 
 /* iommu interrupt handling. Most stuff are MSI-like. */
 
-static char *fault_reason_strings[] =
+static const char *fault_reason_strings[] =
 {
 	"Software",
 	"Present bit in root entry is clear",
@@ -759,15 +759,14 @@
 	"Context table ptr is invalid",
 	"non-zero reserved fields in RTP",
 	"non-zero reserved fields in CTP",
-	"non-zero reserved fields in PTE",
-	"Unknown"
+	"non-zero reserved fields in PTE"
 };
 #define MAX_FAULT_REASON_IDX 	(ARRAY_SIZE(fault_reason_strings) - 1)
 
-char *dmar_get_fault_reason(u8 fault_reason)
+const char *dmar_get_fault_reason(u8 fault_reason)
 {
-	if (fault_reason >= MAX_FAULT_REASON_IDX)
-		return fault_reason_strings[MAX_FAULT_REASON_IDX - 1];
+	if (fault_reason > MAX_FAULT_REASON_IDX)
+		return "Unknown";
 	else
 		return fault_reason_strings[fault_reason];
 }
@@ -825,7 +824,7 @@
 static int iommu_page_fault_do_one(struct intel_iommu *iommu, int type,
 		u8 fault_reason, u16 source_id, u64 addr)
 {
-	char *reason;
+	const char *reason;
 
 	reason = dmar_get_fault_reason(fault_reason);
 
Index: linux-2.6.23-rc2-iommu/include/linux/dmar.h
===================================================================
--- linux-2.6.23-rc2-iommu.orig/include/linux/dmar.h	2007-11-20 10:12:06.000000000 -0800
+++ linux-2.6.23-rc2-iommu/include/linux/dmar.h	2007-11-20 10:13:43.000000000 -0800
@@ -28,7 +28,7 @@
 #ifdef CONFIG_DMAR
 struct intel_iommu;
 
-extern char *dmar_get_fault_reason(u8 fault_reason);
+extern const char *dmar_get_fault_reason(u8 fault_reason);
 
 /* Can't use the common MSI interrupt functions
  * since DMAR is not a pci device
