Return-Path: <linux-kernel-owner+w=401wt.eu-S933996AbZDHP1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933996AbZDHP1o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 11:27:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933231AbZDHP00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 11:26:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:52412 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933089AbZDHP0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 11:26:22 -0400
Date: Wed, 8 Apr 2009 15:24:54 GMT
From: Becky Bruce <beckyb@kernel.crashing.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       galak@kernel.crashing.org, fujita.tomonori@lab.ntt.co.jp,
       tglx@linutronix.de, beckyb@kernel.crashing.org, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, galak@kernel.crashing.org,
       tglx@linutronix.de, beckyb@kernel.crashing.org, mingo@elte.hu
In-Reply-To: <1239199761-22886-4-git-send-email-galak@kernel.crashing.org>
References: <1239199761-22886-4-git-send-email-galak@kernel.crashing.org>
Subject: [tip:core/iommu] swiotlb: map_page fix for highmem systems
Message-ID: <tip-dd6b02fe427f30520d0adc94aa52352367227873@git.kernel.org>
Git-Commit-ID: dd6b02fe427f30520d0adc94aa52352367227873
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 08 Apr 2009 15:24:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dd6b02fe427f30520d0adc94aa52352367227873
Gitweb:     http://git.kernel.org/tip/dd6b02fe427f30520d0adc94aa52352367227873
Author:     Becky Bruce <beckyb@kernel.crashing.org>
AuthorDate: Wed, 8 Apr 2009 09:09:17 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 8 Apr 2009 16:18:36 +0200

swiotlb: map_page fix for highmem systems

The current code calls virt_to_phys() on address that might
be in highmem, which is bad.  This wasn't needed, anyway, because
we already have the physical address we need.

Get rid of the now-unused virtual address as well.

Signed-off-by: Becky Bruce <beckyb@kernel.crashing.org>
Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
Cc: jeremy@goop.org
Cc: ian.campbell@citrix.com
LKML-Reference: <1239199761-22886-4-git-send-email-galak@kernel.crashing.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
