Return-Path: <linux-kernel-owner+w=401wt.eu-S1753266AbYKROOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266AbYKROOc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 09:14:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752529AbYKROOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 09:14:24 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42048 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752442AbYKROOY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 09:14:24 -0500
Date: Tue, 18 Nov 2008 15:14:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] core kernel fixes
Message-ID: <20081118141419.GA26741@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus

 Thanks,

	Ingo

------------------>
FUJITA Tomonori (1):
      swiotlb: use coherent_dma_mask in alloc_coherent

Ingo Molnar (1):
      MAINTAINERS: remove me as RAID maintainer


 MAINTAINERS   |    2 --
 lib/swiotlb.c |   10 +++++++---
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8e0777f..627e4c8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3928,8 +3928,6 @@ M:	bootc@bootc.net
 S:	Maintained
 
 SOFTWARE RAID (Multiple Disks) SUPPORT
-P:	Ingo Molnar
-M:	mingo@redhat.com
 P:	Neil Brown
 M:	neilb@suse.de
 L:	linux-raid@vger.kernel.org
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 78330c3..5f6c629 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -467,9 +467,13 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 	dma_addr_t dev_addr;
 	void *ret;
 	int order = get_order(size);
+	u64 dma_mask = DMA_32BIT_MASK;
+
+	if (hwdev && hwdev->coherent_dma_mask)
+		dma_mask = hwdev->coherent_dma_mask;
 
 	ret = (void *)__get_free_pages(flags, order);
-	if (ret && address_needs_mapping(hwdev, virt_to_bus(ret), size)) {
+	if (ret && !is_buffer_dma_capable(dma_mask, virt_to_bus(ret), size)) {
 		/*
 		 * The allocated memory isn't reachable by the device.
 		 * Fall back on swiotlb_map_single().
@@ -493,9 +497,9 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 	dev_addr = virt_to_bus(ret);
 
 	/* Confirm address can be DMA'd by device */
-	if (address_needs_mapping(hwdev, dev_addr, size)) {
+	if (!is_buffer_dma_capable(dma_mask, dev_addr, size)) {
 		printk("hwdev DMA mask = 0x%016Lx, dev_addr = 0x%016Lx\n",
-		       (unsigned long long)*hwdev->dma_mask,
+		       (unsigned long long)dma_mask,
 		       (unsigned long long)dev_addr);
 
 		/* DMA_TO_DEVICE to avoid memcpy in unmap_single */
