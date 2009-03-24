Return-Path: <linux-kernel-owner+w=401wt.eu-S1755839AbZCXVp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839AbZCXVp7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 17:45:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754944AbZCXVo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 17:44:27 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:34832 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922AbZCXVoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 17:44:25 -0400
From: Becky Bruce <beckyb@kernel.crashing.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fujita.tomonori@lab.ntt.co.jp, ian.campbell@citrix.com,
       jeremy@goop.org, Becky Bruce <beckyb@kernel.crashing.org>
Subject: [PATCH 4/5] swiotlb: map_page fix for highmem systems
Date: Tue, 24 Mar 2009 16:28:45 -0500
Message-Id: <1237930126-6741-5-git-send-email-beckyb@kernel.crashing.org>
X-Mailer: git-send-email 1.5.6.6
In-Reply-To: <1237930126-6741-4-git-send-email-beckyb@kernel.crashing.org>
References: <1237930126-6741-1-git-send-email-beckyb@kernel.crashing.org>
 <1237930126-6741-2-git-send-email-beckyb@kernel.crashing.org>
 <1237930126-6741-3-git-send-email-beckyb@kernel.crashing.org>
 <1237930126-6741-4-git-send-email-beckyb@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current code calls virt_to_phys() on address that might
be in highmem, which is bad.  This wasn't needed, anyway, because
we already have the physical address we need. Get rid of the
now-unused virtual address as well.

Signed-off-by: Becky Bruce <beckyb@kernel.crashing.org>
---
 lib/swiotlb.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index c152f17..b33180e 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -640,7 +640,6 @@ dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
 			    struct dma_attrs *attrs)
 {
 	phys_addr_t phys = page_to_phys(page) + offset;
-	void *ptr = page_address(page) + offset;
 	dma_addr_t dev_addr = swiotlb_phys_to_bus(dev, phys);
 	void *map;
 
@@ -651,7 +650,7 @@ dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
 	 * buffering it.
 	 */
 	if (!address_needs_mapping(dev, dev_addr, size) &&
-	    !range_needs_mapping(virt_to_phys(ptr), size))
+	    !range_needs_mapping(phys, size))
 		return dev_addr;
 
 	/*
-- 
1.5.6.6

