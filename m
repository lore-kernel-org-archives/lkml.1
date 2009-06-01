Return-Path: <linux-kernel-owner+w=401wt.eu-S1758950AbZFAPfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758950AbZFAPfz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 11:35:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755568AbZFAPdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 11:33:38 -0400
Received: from smtp.citrix.com ([66.165.176.89]:62354 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754107AbZFAPdh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 11:33:37 -0400
X-IronPort-AV: E=Sophos;i="4.41,284,1241409600"; 
   d="scan'208";a="4484695"
From: Ian Campbell <ian.campbell@citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: Ian Campbell <ian.campbell@citrix.com>,
       Becky Bruce <beckyb@kernel.crashing.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Kumar Gala <galak@kernel.crashing.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       <linuxppc-dev@ozlabs.org>
Subject: [PATCH 08/11] swiotlb: support HIGHMEM in swiotlb_bus_to_virt
Date: Mon, 1 Jun 2009 16:33:00 +0100
Message-ID: <1243870383-12954-9-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1243870383-12954-1-git-send-email-ian.campbell@citrix.com>
References: <1243870383-12954-1-git-send-email-ian.campbell@citrix.com>
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
 lib/swiotlb.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index d37499b..d2b296a 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -130,9 +130,18 @@ static dma_addr_t swiotlb_virt_to_bus(struct device *hwdev,
 	return phys_to_dma(hwdev, virt_to_phys(address));
 }
 
-void * __weak swiotlb_bus_to_virt(struct device *hwdev, dma_addr_t address)
+static void *swiotlb_bus_to_virt(struct device *hwdev, dma_addr_t address)
 {
+#ifdef CONFIG_HIGHMEM
+	unsigned long pfn = PFN_DOWN(dma_to_phys(hwdev, address));
+	void *pageaddr = page_address(pfn_to_page(pfn));
+
+	if (pageaddr != NULL)
+		return pageaddr + (address % PAGE_SIZE);
+	return NULL;
+#else
 	return phys_to_virt(dma_to_phys(hwdev, address));
+#endif
 }
 
 static void swiotlb_print_info(unsigned long bytes)
-- 
1.5.6.5

