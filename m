Return-Path: <linux-kernel-owner+w=401wt.eu-S933314AbZDHONj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933314AbZDHONj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 10:13:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932862AbZDHOKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 10:10:50 -0400
Received: from gate.crashing.org ([63.228.1.57]:35393 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933340AbZDHOKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 10:10:48 -0400
From: Kumar Gala <galak@kernel.crashing.org>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, jeremy@goop.org,
       fujita.tomonori@lab.ntt.co.jp, ian.campbell@citrix.com
Cc: beckyb@kernel.crashing.org
Subject: [PATCH 3/7] swiotlb: map_page fix for highmem systems
Date: Wed,  8 Apr 2009 09:09:17 -0500
Message-Id: <1239199761-22886-4-git-send-email-galak@kernel.crashing.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1239199761-22886-3-git-send-email-galak@kernel.crashing.org>
References: <1239199761-22886-1-git-send-email-galak@kernel.crashing.org>
 <1239199761-22886-2-git-send-email-galak@kernel.crashing.org>
 <1239199761-22886-3-git-send-email-galak@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Becky Bruce <beckyb@kernel.crashing.org>

The current code calls virt_to_phys() on address that might
be in highmem, which is bad.  This wasn't needed, anyway, because
we already have the physical address we need. Get rid of the
now-unused virtual address as well.

Signed-off-by: Becky Bruce <beckyb@kernel.crashing.org>
Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
---
 lib/swiotlb.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 4fd6a76..e8a47c8 100644
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
1.6.0.6

