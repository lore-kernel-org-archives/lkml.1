Return-Path: <linux-kernel-owner+w=401wt.eu-S1761283AbZCMRKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761283AbZCMRKe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 13:10:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760448AbZCMRCs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 13:02:48 -0400
Received: from gw.goop.org ([64.81.55.164]:57449 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759907AbZCMRCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 13:02:47 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       David Airlie <airlied@linux.ie>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 27/27] agp/intel: use dma_alloc_coherent for special cursor memory
Date: Fri, 13 Mar 2009 10:00:12 -0700
Message-Id: <1236963612-14287-28-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1236963612-14287-1-git-send-email-jeremy@goop.org>
References: <1236963612-14287-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Given that i810 wants special physically contiguous memory for its cursor,
allocate it with dma_alloc_coherent, which will give us memory with the
right properties.  This is particularly for Xen, which won't normally
give us physically contiuous memory.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: David Airlie <airlied@linux.ie>
---
 drivers/char/agp/intel-agp.c |   26 +++++++++++---------------
 1 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
index 4373adb..8ba6808 100644
--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -244,33 +244,29 @@ static void intel_i810_agp_enable(struct agp_bridge_data *bridge, u32 mode)
 /* Exists to support ARGB cursors */
 static void *i8xx_alloc_pages(void)
 {
-	struct page *page;
-
-	page = alloc_pages(GFP_KERNEL | GFP_DMA32, 2);
-	if (page == NULL)
+	void *addr;
+	dma_addr_t _d;
+	
+	addr = dma_alloc_coherent(NULL, 4 * PAGE_SIZE, &_d, GFP_KERNEL);
+	if (addr == NULL)
 		return NULL;
 
-	if (set_pages_uc(page, 4) < 0) {
-		set_pages_wb(page, 4);
-		__free_pages(page, 2);
+	if (set_memory_uc((unsigned long)addr, 4) < 0) {
+		set_memory_wb((unsigned long)addr, 4);
+		dma_free_coherent(NULL, 4 * PAGE_SIZE, addr, _d);
 		return NULL;
 	}
-	get_page(page);
 	atomic_inc(&agp_bridge->current_memory_agp);
-	return page_address(page);
+	return addr;
 }
 
 static void i8xx_destroy_pages(void *addr)
 {
-	struct page *page;
-
 	if (addr == NULL)
 		return;
 
-	page = virt_to_page(addr);
-	set_pages_wb(page, 4);
-	put_page(page);
-	__free_pages(page, 2);
+	set_memory_wb((unsigned long)addr, 4);
+	dma_free_coherent(NULL, 4 * PAGE_SIZE, addr, virt_to_bus(addr));
 	atomic_dec(&agp_bridge->current_memory_agp);
 }
 
-- 
1.6.0.6

