Return-Path: <linux-kernel-owner+w=401wt.eu-S1756684AbYLDGdF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684AbYLDGdF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 01:33:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753744AbYLDGcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 01:32:54 -0500
Received: from sh.osrg.net ([192.16.179.4]:37339 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751073AbYLDGcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 01:32:53 -0500
Date: Thu, 4 Dec 2008 15:32:46 +0900
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] block: use min_not_zero in blk_queue_stack_limits
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081204153243G.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is against for-2.6.29 in the block tree.
=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] block: use min_not_zero in blk_queue_stack_limits

zero is invalid for max_phys_segments, max_hw_segments, and
max_segment_size. It's better to use use min_not_zero instead of
min. min() works though (because the commit 0e435ac makes sure that
these values are set to the default values, non zero, if a queue is
initialized properly).

With this patch, blk_queue_stack_limits does the almost same thing
that dm's combine_restrictions_low() does. I think that it's easy to
remove dm's combine_restrictions_low.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 block/blk-settings.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index afa55e1..59fd05d 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -319,9 +319,9 @@ void blk_queue_stack_limits(struct request_queue *t, struct request_queue *b)
 	t->max_hw_sectors = min_not_zero(t->max_hw_sectors, b->max_hw_sectors);
 	t->seg_boundary_mask = min_not_zero(t->seg_boundary_mask, b->seg_boundary_mask);
 
-	t->max_phys_segments = min(t->max_phys_segments, b->max_phys_segments);
-	t->max_hw_segments = min(t->max_hw_segments, b->max_hw_segments);
-	t->max_segment_size = min(t->max_segment_size, b->max_segment_size);
+	t->max_phys_segments = min_not_zero(t->max_phys_segments, b->max_phys_segments);
+	t->max_hw_segments = min_not_zero(t->max_hw_segments, b->max_hw_segments);
+	t->max_segment_size = min_not_zero(t->max_segment_size, b->max_segment_size);
 	t->hardsect_size = max(t->hardsect_size, b->hardsect_size);
 	if (!t->queue_lock)
 		WARN_ON_ONCE(1);
-- 
1.5.5.GIT

