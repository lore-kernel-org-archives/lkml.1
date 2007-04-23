Return-Path: <linux-kernel-owner+w=401wt.eu-S1754037AbXDWJOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037AbXDWJOy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 05:14:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754094AbXDWJOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 05:14:53 -0400
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:37937 "EHLO
	outbound3-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754037AbXDWJOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 05:14:51 -0400
X-BigFish: VP
X-Server-Uuid: 519AC16A-9632-469E-B354-112C592D09E8
From: "Joachim Deguara" <joachim.deguara@amd.com>
Organization: AMD
To: linux-kernel@vger.kernel.org
Subject: [PATCH] x86_64: make GART PTEs uncacheable
Date: Mon, 23 Apr 2007 11:14:10 +0200
User-Agent: KMail/1.9.5
cc: ak@suse.de, "Langsdorf, Mark" <mark.langsdorf@amd.com>
MIME-Version: 1.0
Message-ID: <200704231114.10327.joachim.deguara@amd.com>
X-OriginalArrivalTime: 23 Apr 2007 09:12:17.0032 (UTC)
 FILETIME=[7D29D080:01C78587]
X-WSS-ID: 6A32A7FE1SK67439-01-01
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patches fixes the silent data corruption problems being seen using the 
GART iommu where 4kB of data where incorrect (seen mostly on Nvidia CK804 
systems).  This fix, to mark the memory regin the GART PTEs reside on as 
uncacheable, also brings the code in line with the AGP specification.

Signed-off-by: Joachim Deguara <joachim.deguara@amd.com>

---
diff --git a/arch/x86_64/kernel/pci-gart.c b/arch/x86_64/kernel/pci-gart.c
index 2bac8c6..0bae862 100644
--- a/arch/x86_64/kernel/pci-gart.c
+++ b/arch/x86_64/kernel/pci-gart.c
@@ -519,7 +519,11 @@ static __init int init_k8_gatt(struct ag
 	gatt_size = (aper_size >> PAGE_SHIFT) * sizeof(u32); 
 	gatt = (void *)__get_free_pages(GFP_KERNEL, get_order(gatt_size)); 
 	if (!gatt) 
-		panic("Cannot allocate GATT table"); 
+		panic("Cannot allocate GATT table");
+	if (change_page_attr_addr((unsigned long)gatt, gatt_size >> PAGE_SHIFT, 
PAGE_KERNEL_NOCACHE))
+		panic("Could not set GART PTEs to uncacheable pages");
+	global_flush_tlb();
+
 	memset(gatt, 0, gatt_size); 
 	agp_gatt_table = gatt;
 


