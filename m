Return-Path: <linux-kernel-owner+w=401wt.eu-S1757604AbYC1TtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757604AbYC1TtV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 15:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753931AbYC1TtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 15:49:13 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:57107
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708AbYC1TtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 15:49:12 -0400
Date: Fri, 28 Mar 2008 20:49:09 +0100
From: Andrea Arcangeli <andrea@qumranet.com>
To: Andrew Morton <akpm@osdl.org>, Yang Shi <yang.shi@windriver.com>
Cc: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: regression breaks lowmem reserved RAM
Message-ID: <20080328194909.GA10617@duo.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is crashing at boot my lowmem reserved RAM patch. This is causing
GFP_DMA allocations at boot for no good reason. It crashes in my case
because there's no ram below 16M available to linux. Are you sure this
is needed at all, for sure if there's any bug this isn't the right fix.

Please reverse, thanks!

changeset:   87150:1f7afb388483
user:        Yang Shi <yang.shi@windriver.com>
date:        Tue Mar 04 11:20:51 2008 +0100
summary:     Fix DMA access of block device in 64-bit kernel on some non-x86 systems with 4GB or upper 4GB memory

diff --git a/block/blk-settings.c b/block/blk-settings.c
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -140,7 +140,7 @@ void blk_queue_bounce_limit(struct reque
 	/* Assume anything <= 4GB can be handled by IOMMU.
 	   Actually some IOMMUs can handle everything, but I don't
 	   know of a way to test this here. */
-	if (b_pfn < (min_t(u64, 0xffffffff, BLK_BOUNCE_HIGH) >> PAGE_SHIFT))
+	if (b_pfn <= (min_t(u64, 0xffffffff, BLK_BOUNCE_HIGH) >> PAGE_SHIFT))
 		dma = 1;
 	q->bounce_pfn = max_low_pfn;
 #else
