Return-Path: <linux-kernel-owner+w=401wt.eu-S1758141AbZE2IqO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758141AbZE2IqO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 04:46:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757107AbZE2IoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 04:44:17 -0400
Received: from smtp.citrix.com ([66.165.176.89]:56015 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756855AbZE2IoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 04:44:15 -0400
X-IronPort-AV: E=Sophos;i="4.41,270,1241409600"; 
   d="scan'208";a="4461769"
From: Ian Campbell <ian.campbell@citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: Ian Campbell <ian.campbell@citrix.com>,
       Becky Bruce <beckyb@kernel.crashing.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Kumar Gala <galak@kernel.crashing.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       <linuxppc-dev@ozlabs.org>
Subject: [PATCH 8/9] swiotlb: support HIGHMEM in swiotlb_bus_to_virt
Date: Fri, 29 May 2009 09:44:02 +0100
Message-ID: <1243586643-5554-9-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1243586643-5554-1-git-send-email-ian.campbell@citrix.com>
References: <1243586643-5554-1-git-send-email-ian.campbell@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than supplying a __weak hook which architectures which support
highmem can overide simply provide a version of swiotlb_bus_to_virt
which works with high memory. Make it conditional since it is a more
expensive variant than the non-highmem version.

Acutal function contents taken from the PowerPC swiotlb patchset by
Becky Bruce.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Becky Bruce <beckyb@kernel.crashing.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linuxppc-dev@ozlabs.org
---
 lib/swiotlb.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index e332342..c50a5ed 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -130,10 +130,22 @@ static dma_addr_t swiotlb_virt_to_bus(struct device *hwdev,
 	return phys_to_dma(hwdev, virt_to_phys(address));
 }
 
-void * __weak swiotlb_bus_to_virt(struct device *hwdev, dma_addr_t address)
+#ifdef CONFIG_HIGHMEM
+static void * swiotlb_bus_to_virt(struct device *hwdev, dma_addr_t address)
+{
+	unsigned long pfn = PFN_DOWN(dma_to_phys(hwdev, addr));
+	void *pageaddr = page_address(pfn_to_page(pfn));
+
+	if (pageaddr != NULL)
+		return pageaddr + (addr % PAGE_SIZE);
+	return NULL;
+}
+#else
+static void * swiotlb_bus_to_virt(struct device *hwdev, dma_addr_t address)
 {
 	return phys_to_virt(dma_to_phys(hwdev, address));
 }
+#endif
 
 static void swiotlb_print_info(unsigned long bytes)
 {
-- 
1.5.6.5

