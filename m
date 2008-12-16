Return-Path: <linux-kernel-owner+w=401wt.eu-S1759213AbYLPUfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759213AbYLPUfr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 15:35:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752124AbYLPUff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 15:35:35 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43730 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532AbYLPUfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 15:35:34 -0500
Date: Tue, 16 Dec 2008 21:35:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>,
       Jan Beulich <jbeulich@novell.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH 00 of 14] swiotlb/x86: lay groundwork for xen dom0 use
	of swiotlb
Message-ID: <20081216203513.GA14787@elte.hu>
References: <patchbomb.1229458644@abulafia.goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <patchbomb.1229458644@abulafia.goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Hi Ingo,
> 
> Here's some patches to clean up swiotlb to prepare for some Xen dom0 
> patches.  These have been posted before, but undergone a round of 
> cleanups to address various comments.

applied to tip/core/iommu, thanks Jeremy.

the only patch that seems to have the potential to break drivers is:

  be4ac7b: swiotlb: consistently use address_needs_mapping everywhere

looks fine to me, but the gents on the Cc: might have a dissenting 
opinion?

	Ingo

------------->
>From be4ac7b87b27380bc43fa4f686e39b46eca2c866 Mon Sep 17 00:00:00 2001
From: Jeremy Fitzhardinge <jeremy@goop.org>
Date: Tue, 16 Dec 2008 12:17:28 -0800
Subject: [PATCH] swiotlb: consistently use address_needs_mapping everywhere

Impact: remove open-coded DMA mask assumptions

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 lib/swiotlb.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index db724ba..76821f0 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -465,13 +465,9 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 	dma_addr_t dev_addr;
 	void *ret;
 	int order = get_order(size);
-	u64 dma_mask = DMA_32BIT_MASK;
-
-	if (hwdev && hwdev->coherent_dma_mask)
-		dma_mask = hwdev->coherent_dma_mask;
 
 	ret = (void *)__get_free_pages(flags, order);
-	if (ret && !is_buffer_dma_capable(dma_mask, virt_to_bus(ret), size)) {
+	if (ret && !address_needs_mapping(hwdev, virt_to_bus(ret), size)) {
 		/*
 		 * The allocated memory isn't reachable by the device.
 		 * Fall back on swiotlb_map_single().
@@ -495,9 +491,9 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 	dev_addr = virt_to_bus(ret);
 
 	/* Confirm address can be DMA'd by device */
-	if (!is_buffer_dma_capable(dma_mask, dev_addr, size)) {
+	if (!address_needs_mapping(hwdev, dev_addr, size)) {
 		printk("hwdev DMA mask = 0x%016Lx, dev_addr = 0x%016Lx\n",
-		       (unsigned long long)dma_mask,
+		       (unsigned long long)dma_get_mask(hwdev),
 		       (unsigned long long)dev_addr);
 
 		/* DMA_TO_DEVICE to avoid memcpy in unmap_single */
