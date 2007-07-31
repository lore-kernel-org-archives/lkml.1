Return-Path: <linux-kernel-owner+w=401wt.eu-S941471AbXGaCak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941471AbXGaCak (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 22:30:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S940575AbXGaCS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 22:18:57 -0400
Received: from ns.suse.de ([195.135.220.2]:52867 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S940569AbXGaCSz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 22:18:55 -0400
From: NeilBrown <neilb@suse.de>
To: linux-kernel@vger.kernel.org
Date: Tue, 31 Jul 2007 12:18:42 +1000
Message-Id: <1070731021842.25606@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Subject: [PATCH 033 of 35] Simplify stacking of IO restrictions
References: <20070731112539.22428.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Stacking device drives (dm/md) no longer need to worry about
most queue limits as they are handled at a lower level.  The
only limit of any interest at the top level now is the hard
sector size.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./block/ll_rw_blk.c             |   14 ---------
 ./drivers/md/dm-table.c         |   61 ----------------------------------------
 ./include/linux/device-mapper.h |    6 ---
 3 files changed, 81 deletions(-)

diff .prev/block/ll_rw_blk.c ./block/ll_rw_blk.c
--- .prev/block/ll_rw_blk.c	2007-07-31 11:21:27.000000000 +1000
+++ ./block/ll_rw_blk.c	2007-07-31 11:21:28.000000000 +1000
@@ -690,11 +690,6 @@ void blk_queue_hardsect_size(struct requ
 
 EXPORT_SYMBOL(blk_queue_hardsect_size);
 
-/*
- * Returns the minimum that is _not_ zero, unless both are zero.
- */
-#define min_not_zero(l, r) (l == 0) ? r : ((r == 0) ? l : min(l, r))
-
 /**
  * blk_queue_stack_limits - inherit underlying queue limits for stacked drivers
  * @t:	the stacking driver (top)
@@ -702,16 +697,7 @@ EXPORT_SYMBOL(blk_queue_hardsect_size);
  **/
 void blk_queue_stack_limits(struct request_queue *t, struct request_queue *b)
 {
-	/* zero is "infinity" */
-	t->max_sectors = min_not_zero(t->max_sectors,b->max_sectors);
-	t->max_hw_sectors = min_not_zero(t->max_hw_sectors,b->max_hw_sectors);
-
-	t->max_phys_segments = min(t->max_phys_segments,b->max_phys_segments);
-	t->max_hw_segments = min(t->max_hw_segments,b->max_hw_segments);
-	t->max_segment_size = min(t->max_segment_size,b->max_segment_size);
 	t->hardsect_size = max(t->hardsect_size,b->hardsect_size);
-	if (!test_bit(QUEUE_FLAG_CLUSTER, &b->queue_flags))
-		clear_bit(QUEUE_FLAG_CLUSTER, &t->queue_flags);
 }
 
 EXPORT_SYMBOL(blk_queue_stack_limits);

diff .prev/drivers/md/dm-table.c ./drivers/md/dm-table.c
--- .prev/drivers/md/dm-table.c	2007-07-31 11:21:27.000000000 +1000
+++ ./drivers/md/dm-table.c	2007-07-31 11:21:28.000000000 +1000
@@ -75,34 +75,12 @@ static unsigned int int_log(unsigned int
 }
 
 /*
- * Returns the minimum that is _not_ zero, unless both are zero.
- */
-#define min_not_zero(l, r) (l == 0) ? r : ((r == 0) ? l : min(l, r))
-
-/*
  * Combine two io_restrictions, always taking the lower value.
  */
 static void combine_restrictions_low(struct io_restrictions *lhs,
 				     struct io_restrictions *rhs)
 {
-	lhs->max_sectors =
-		min_not_zero(lhs->max_sectors, rhs->max_sectors);
-
-	lhs->max_phys_segments =
-		min_not_zero(lhs->max_phys_segments, rhs->max_phys_segments);
-
-	lhs->max_hw_segments =
-		min_not_zero(lhs->max_hw_segments, rhs->max_hw_segments);
-
 	lhs->hardsect_size = max(lhs->hardsect_size, rhs->hardsect_size);
-
-	lhs->max_segment_size =
-		min_not_zero(lhs->max_segment_size, rhs->max_segment_size);
-
-	lhs->seg_boundary_mask =
-		min_not_zero(lhs->seg_boundary_mask, rhs->seg_boundary_mask);
-
-	lhs->no_cluster |= rhs->no_cluster;
 }
 
 /*
@@ -536,26 +514,7 @@ void dm_set_device_limits(struct dm_targ
 	 *        into q this would just be a call to
 	 *        combine_restrictions_low()
 	 */
-	rs->max_sectors =
-		min_not_zero(rs->max_sectors, q->max_sectors);
-
-	rs->max_phys_segments =
-		min_not_zero(rs->max_phys_segments,
-			     q->max_phys_segments);
-
-	rs->max_hw_segments =
-		min_not_zero(rs->max_hw_segments, q->max_hw_segments);
-
 	rs->hardsect_size = max(rs->hardsect_size, q->hardsect_size);
-
-	rs->max_segment_size =
-		min_not_zero(rs->max_segment_size, q->max_segment_size);
-
-	rs->seg_boundary_mask =
-		min_not_zero(rs->seg_boundary_mask,
-			     q->seg_boundary_mask);
-
-	rs->no_cluster |= !test_bit(QUEUE_FLAG_CLUSTER, &q->queue_flags);
 }
 EXPORT_SYMBOL_GPL(dm_set_device_limits);
 
@@ -684,18 +643,8 @@ int dm_split_args(int *argc, char ***arg
 
 static void check_for_valid_limits(struct io_restrictions *rs)
 {
-	if (!rs->max_sectors)
-		rs->max_sectors = SAFE_MAX_SECTORS;
-	if (!rs->max_phys_segments)
-		rs->max_phys_segments = MAX_PHYS_SEGMENTS;
-	if (!rs->max_hw_segments)
-		rs->max_hw_segments = MAX_HW_SEGMENTS;
 	if (!rs->hardsect_size)
 		rs->hardsect_size = 1 << SECTOR_SHIFT;
-	if (!rs->max_segment_size)
-		rs->max_segment_size = MAX_SEGMENT_SIZE;
-	if (!rs->seg_boundary_mask)
-		rs->seg_boundary_mask = -1;
 }
 
 int dm_table_add_target(struct dm_table *t, const char *type,
@@ -874,17 +823,7 @@ void dm_table_set_restrictions(struct dm
 	 * Make sure we obey the optimistic sub devices
 	 * restrictions.
 	 */
-	blk_queue_max_sectors(q, t->limits.max_sectors);
-	q->max_phys_segments = t->limits.max_phys_segments;
-	q->max_hw_segments = t->limits.max_hw_segments;
 	q->hardsect_size = t->limits.hardsect_size;
-	q->max_segment_size = t->limits.max_segment_size;
-	q->seg_boundary_mask = t->limits.seg_boundary_mask;
-	if (t->limits.no_cluster)
-		q->queue_flags &= ~(1 << QUEUE_FLAG_CLUSTER);
-	else
-		q->queue_flags |= (1 << QUEUE_FLAG_CLUSTER);
-
 }
 
 unsigned int dm_table_get_num_targets(struct dm_table *t)

diff .prev/include/linux/device-mapper.h ./include/linux/device-mapper.h
--- .prev/include/linux/device-mapper.h	2007-07-31 11:19:51.000000000 +1000
+++ ./include/linux/device-mapper.h	2007-07-31 11:21:28.000000000 +1000
@@ -110,13 +110,7 @@ struct target_type {
 };
 
 struct io_restrictions {
-	unsigned int		max_sectors;
-	unsigned short		max_phys_segments;
-	unsigned short		max_hw_segments;
 	unsigned short		hardsect_size;
-	unsigned int		max_segment_size;
-	unsigned long		seg_boundary_mask;
-	unsigned char		no_cluster; /* inverted so that 0 is default */
 };
 
 struct dm_target {
