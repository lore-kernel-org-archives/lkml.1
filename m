Return-Path: <linux-kernel-owner+w=401wt.eu-S937575AbZDDB6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937575AbZDDB6o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 21:58:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935893AbZDDB5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 21:57:43 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:64884 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937383AbZDDB5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 21:57:42 -0400
From: Becky Bruce <beckyb@kernel.crashing.org>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, jeremy@goop.org,
       fujita.tomonori@lab.ntt.co.jp, ian.campbell@citrix.com
Cc: Becky Bruce <beckyb@kernel.crashing.org>
Subject: [PATCH 3/7] swiotlb: map_page fix for highmem systems
Date: Fri,  3 Apr 2009 20:56:45 -0500
Message-Id: <1238810209-24499-4-git-send-email-beckyb@kernel.crashing.org>
X-Mailer: git-send-email 1.5.6.6
In-Reply-To: <1238810209-24499-3-git-send-email-beckyb@kernel.crashing.org>
References: <1238810209-24499-1-git-send-email-beckyb@kernel.crashing.org>
 <1238810209-24499-2-git-send-email-beckyb@kernel.crashing.org>
 <1238810209-24499-3-git-send-email-beckyb@kernel.crashing.org>
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
index fa62498..eb6dbbd 100644
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

