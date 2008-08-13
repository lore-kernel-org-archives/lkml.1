Return-Path: <linux-kernel-owner+w=401wt.eu-S1756739AbYHMIow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739AbYHMIow (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 04:44:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752729AbYHMIji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 04:39:38 -0400
Received: from smtp.nokia.com ([192.100.122.230]:37181 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579AbYHMIjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 04:39:37 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Zoltan Sogor <weth@inf.u-szeged.hu>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH] UBIFS: reserve more space for index
Date: Wed, 13 Aug 2008 13:17:49 +0300
Message-Id: <1218622675-28853-21-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1218622675-28853-1-git-send-email-dedekind@infradead.org>
References: <1218622675-28853-1-git-send-email-dedekind@infradead.org>
X-OriginalArrivalTime: 13 Aug 2008 08:39:04.0222 (UTC) FILETIME=[0ACFA3E0:01C8FD20]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

At the moment UBIFS reserves twice old index size space for the
index. But this is not enough in some cases, because if the indexing
node are very fragmented and there are many small gaps, while the
dirty index has big znodes - in-the-gaps method would fail.

Thus, reserve trise as more, in which case we are guaranteed that
we can commit in any case.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/ubifs/budget.c      |    8 ++++----
 fs/ubifs/find.c        |    9 +++++++--
 fs/ubifs/misc.h        |    2 +-
 fs/ubifs/ubifs-media.h |    4 ++--
 4 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/fs/ubifs/budget.c b/fs/ubifs/budget.c
index a3978ba..323d83a 100644
--- a/fs/ubifs/budget.c
+++ b/fs/ubifs/budget.c
@@ -263,8 +263,8 @@ int ubifs_calc_min_idx_lebs(struct ubifs_info *c)
 
 	idx_size = c->old_idx_sz + c->budg_idx_growth + c->budg_uncommitted_idx;
 
-	/* And make sure we have twice the index size of space reserved */
-	idx_size <<= 1;
+	/* And make sure we have trice the index size of space reserved */
+	idx_size = idx_size + (idx_size << 1);
 
 	/*
 	 * We do not maintain 'old_idx_size' as 'old_idx_lebs'/'old_idx_bytes'
@@ -388,11 +388,11 @@ static int can_use_rp(struct ubifs_info *c)
  * This function makes sure UBIFS has enough free eraseblocks for index growth
  * and data.
  *
- * When budgeting index space, UBIFS reserves twice as more LEBs as the index
+ * When budgeting index space, UBIFS reserves trice as more LEBs as the index
  * would take if it was consolidated and written to the flash. This guarantees
  * that the "in-the-gaps" commit method always succeeds and UBIFS will always
  * be able to commit dirty index. So this function basically adds amount of
- * budgeted index space to the size of the current index, multiplies this by 2,
+ * budgeted index space to the size of the current index, multiplies this by 3,
  * and makes sure this does not exceed the amount of free eraseblocks.
  *
  * Notes about @c->min_idx_lebs and @c->lst.idx_lebs variables:
diff --git a/fs/ubifs/find.c b/fs/ubifs/find.c
index 10394c5..c70c767 100644
--- a/fs/ubifs/find.c
+++ b/fs/ubifs/find.c
@@ -290,9 +290,14 @@ int ubifs_find_dirty_leb(struct ubifs_info *c, struct ubifs_lprops *ret_lp,
 		idx_lp = idx_heap->arr[0];
 		sum = idx_lp->free + idx_lp->dirty;
 		/*
-		 * Since we reserve twice as more space for the index than it
+		 * Since we reserve trice as more space for the index than it
 		 * actually takes, it does not make sense to pick indexing LEBs
-		 * with less than half LEB of dirty space.
+		 * with less than, say, half LEB of dirty space. May be half is
+		 * not the optimal boundary - this should be tested and
+		 * checked. This boundary should determine how much we use
+		 * in-the-gaps to consolidate the index comparing to how much
+		 * we use garbage collector to consolidate it. The "half"
+		 * criteria just feels to be fine.
 		 */
 		if (sum < min_space || sum < c->half_leb_size)
 			idx_lp = NULL;
diff --git a/fs/ubifs/misc.h b/fs/ubifs/misc.h
index cd83ffc..87dabf9 100644
--- a/fs/ubifs/misc.h
+++ b/fs/ubifs/misc.h
@@ -308,7 +308,7 @@ static inline long long ubifs_reported_space(const struct ubifs_info *c,
 {
 	int divisor, factor;
 
-	divisor = UBIFS_MAX_DATA_NODE_SZ + (c->max_idx_node_sz << 1);
+	divisor = UBIFS_MAX_DATA_NODE_SZ + (c->max_idx_node_sz * 3);
 	factor = UBIFS_MAX_DATA_NODE_SZ - UBIFS_DATA_NODE_SZ;
 	do_div(free, divisor);
 
diff --git a/fs/ubifs/ubifs-media.h b/fs/ubifs/ubifs-media.h
index 0cc7da9..bd2121f 100644
--- a/fs/ubifs/ubifs-media.h
+++ b/fs/ubifs/ubifs-media.h
@@ -228,10 +228,10 @@ enum {
 /* Minimum number of orphan area logical eraseblocks */
 #define UBIFS_MIN_ORPH_LEBS 1
 /*
- * Minimum number of main area logical eraseblocks (buds, 2 for the index, 1
+ * Minimum number of main area logical eraseblocks (buds, 3 for the index, 1
  * for GC, 1 for deletions, and at least 1 for committed data).
  */
-#define UBIFS_MIN_MAIN_LEBS (UBIFS_MIN_BUD_LEBS + 5)
+#define UBIFS_MIN_MAIN_LEBS (UBIFS_MIN_BUD_LEBS + 6)
 
 /* Minimum number of logical eraseblocks */
 #define UBIFS_MIN_LEB_CNT (UBIFS_SB_LEBS + UBIFS_MST_LEBS + \
-- 
1.5.4.1

