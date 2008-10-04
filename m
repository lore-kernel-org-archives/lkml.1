Return-Path: <linux-kernel-owner+w=401wt.eu-S1755620AbYJDW4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620AbYJDW4A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 18:56:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754625AbYJDWzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 18:55:53 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:30594 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754620AbYJDWzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 18:55:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=AG/kAdpGA6wVtCI8D7y8O1otEb7h2Yo3JjWmli3DivbVclRN8mtqE6fvud+3oq0JlZ
         x7bLb/v0vFlk4miJU56aJzxHqET1oycMK8iuQQtOBzF/MvSLx+sSf69qPmnGbZ423nBr
         5/SVMj1vuQ63jIkzQaLs9E+Gmu3i6nEvpMamA=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH] x86: gart iommu have direct mapping when agp is present too
Date: Sat,  4 Oct 2008 15:55:12 -0700
Message-Id: <1223160912-5069-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

move init_memory_mapping out of init_k8_gatt.

for: http://bugzilla.kernel.org/show_bug.cgi?id=11676
    2.6.27-rc2 to rc8, apgart fails, iommu=soft works, regression

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/pci-gart_64.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

Index: linux-2.6/arch/x86/kernel/pci-gart_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/pci-gart_64.c
+++ linux-2.6/arch/x86/kernel/pci-gart_64.c
@@ -650,7 +650,6 @@ static __init int init_k8_gatt(struct ag
 	struct pci_dev *dev;
 	void *gatt;
 	int i, error;
-	unsigned long start_pfn, end_pfn;
 
 	printk(KERN_INFO "PCI-DMA: Disabling AGP.\n");
 	aper_size = aper_base = info->aper_size = 0;
@@ -697,12 +696,6 @@ static __init int init_k8_gatt(struct ag
 	printk(KERN_INFO "PCI-DMA: aperture base @ %x size %u KB\n",
 	       aper_base, aper_size>>10);
 
-	/* need to map that range */
-	end_pfn = (aper_base>>PAGE_SHIFT) + (aper_size>>PAGE_SHIFT);
-	if (end_pfn > max_low_pfn_mapped) {
-		start_pfn = (aper_base>>PAGE_SHIFT);
-		init_memory_mapping(start_pfn<<PAGE_SHIFT, end_pfn<<PAGE_SHIFT);
-	}
 	return 0;
 
  nommu:
@@ -745,7 +738,8 @@ void __init gart_iommu_init(void)
 {
 	struct agp_kern_info info;
 	unsigned long iommu_start;
-	unsigned long aper_size;
+	unsigned long aper_base, aper_size;
+	unsigned long start_pfn, end_pfn;
 	unsigned long scratch;
 	long i;
 
@@ -783,8 +777,16 @@ void __init gart_iommu_init(void)
 		return;
 	}
 
+	/* need to map that range */
+	aper_size = info.aper_size << 20;
+	aper_base = info.aper_base;
+	end_pfn = (aper_base>>PAGE_SHIFT) + (aper_size>>PAGE_SHIFT);
+	if (end_pfn > max_low_pfn_mapped) {
+		start_pfn = (aper_base>>PAGE_SHIFT);
+		init_memory_mapping(start_pfn<<PAGE_SHIFT, end_pfn<<PAGE_SHIFT);
+	}
+
 	printk(KERN_INFO "PCI-DMA: using GART IOMMU.\n");
-	aper_size = info.aper_size * 1024 * 1024;
 	iommu_size = check_iommu_size(info.aper_base, aper_size);
 	iommu_pages = iommu_size >> PAGE_SHIFT;
 
