Return-Path: <linux-kernel-owner+w=401wt.eu-S1759478AbYHaNQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759478AbYHaNQu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 09:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759271AbYHaNOu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 09:14:50 -0400
Received: from smtp.nokia.com ([192.100.122.233]:61155 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759122AbYHaNOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 09:14:49 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: linux-fsdevel-owner@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <ext-adrian.hunter@nokia.com>
Subject: [PATCH] UBIFS: remove incorrect index space check
Date: Sun, 31 Aug 2008 17:52:40 +0300
Message-Id: <1220194366-12731-7-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1220194366-12731-1-git-send-email-dedekind@infradead.org>
References: <1220194366-12731-1-git-send-email-dedekind@infradead.org>
X-OriginalArrivalTime: 31 Aug 2008 13:14:25.0900 (UTC) FILETIME=[7DEF22C0:01C90B6B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

When we report free space to user-space, we should not report
0 if the amount of empty LEBs is too low, because they would
be produced by GC when needed. Thus, just call
'ubifs_calc_available()' straight away which would take
'min_idx_lebs' into account anyway.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/ubifs/budget.c |   15 +--------------
 1 files changed, 1 insertions(+), 14 deletions(-)

diff --git a/fs/ubifs/budget.c b/fs/ubifs/budget.c
index f6d2eaa..9ef630a 100644
--- a/fs/ubifs/budget.c
+++ b/fs/ubifs/budget.c
@@ -709,24 +709,11 @@ void ubifs_release_dirty_inode_budget(struct ubifs_info *c,
  */
 long long ubifs_budg_get_free_space(struct ubifs_info *c)
 {
-	int min_idx_lebs, rsvd_idx_lebs;
+	int min_idx_lebs;
 	long long available, outstanding, free;
 
-	/* Do exactly the same calculations as in 'do_budget_space()' */
 	spin_lock(&c->space_lock);
 	min_idx_lebs = ubifs_calc_min_idx_lebs(c);
-
-	if (min_idx_lebs > c->lst.idx_lebs)
-		rsvd_idx_lebs = min_idx_lebs - c->lst.idx_lebs;
-	else
-		rsvd_idx_lebs = 0;
-
-	if (rsvd_idx_lebs > c->lst.empty_lebs + c->freeable_cnt + c->idx_gc_cnt
-				- c->lst.taken_empty_lebs) {
-		spin_unlock(&c->space_lock);
-		return 0;
-	}
-
 	outstanding = c->budg_data_growth + c->budg_dd_growth;
 
 	/*
-- 
1.5.4.1

