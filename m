Return-Path: <linux-kernel-owner+w=401wt.eu-S1759999AbYHaNQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759999AbYHaNQe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 09:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759205AbYHaNOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 09:14:49 -0400
Received: from smtp.nokia.com ([192.100.122.233]:61153 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759024AbYHaNOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 09:14:48 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: linux-fsdevel-owner@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <ext-adrian.hunter@nokia.com>
Subject: [PATCH] UBIFS: push empty flash hack down
Date: Sun, 31 Aug 2008 17:52:39 +0300
Message-Id: <1220194366-12731-6-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1220194366-12731-1-git-send-email-dedekind@infradead.org>
References: <1220194366-12731-1-git-send-email-dedekind@infradead.org>
X-OriginalArrivalTime: 31 Aug 2008 13:14:25.0884 (UTC) FILETIME=[7DECB1C0:01C90B6B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

We have a hack which forces the amount of flash space to be
equivalent to 'c->blocks_cnt' in case of empty FS. This is
to make users happy and see '%0' used in 'df' when they
mount an empty FS. This hack is not needed in
'ubifs_calc_available()', but it is only needed the caller,
in 'ubifs_budg_get_free_space()'. So push it down there.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/ubifs/budget.c |   24 +++++++++++-------------
 fs/ubifs/super.c  |    2 --
 2 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/fs/ubifs/budget.c b/fs/ubifs/budget.c
index ac0d2e1..f6d2eaa 100644
--- a/fs/ubifs/budget.c
+++ b/fs/ubifs/budget.c
@@ -302,18 +302,6 @@ long long ubifs_calc_available(const struct ubifs_info *c, int min_idx_lebs)
 	int subtract_lebs;
 	long long available;
 
-	/*
-	 * Force the amount available to the total size reported if the used
-	 * space is zero.
-	 */
-	if (c->lst.total_used <= UBIFS_INO_NODE_SZ &&
-	    c->budg_data_growth + c->budg_dd_growth == 0) {
-		/* Do the same calculation as for c->block_cnt */
-		available = c->main_lebs - 2;
-		available *= c->leb_size - c->dark_wm;
-		return available;
-	}
-
 	available = c->main_bytes - c->lst.total_used;
 
 	/*
@@ -739,8 +727,18 @@ long long ubifs_budg_get_free_space(struct ubifs_info *c)
 		return 0;
 	}
 
-	available = ubifs_calc_available(c, min_idx_lebs);
 	outstanding = c->budg_data_growth + c->budg_dd_growth;
+
+	/*
+	 * Force the amount available to the total size reported if the used
+	 * space is zero.
+	 */
+	if (c->lst.total_used <= UBIFS_INO_NODE_SZ && !outstanding) {
+		spin_unlock(&c->space_lock);
+		return (long long)c->block_cnt << UBIFS_BLOCK_SHIFT;
+	}
+
+	available = ubifs_calc_available(c, min_idx_lebs);
 	spin_unlock(&c->space_lock);
 
 	if (available > outstanding)
diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index f71e6b8..1018053 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -649,8 +649,6 @@ static int init_constants_late(struct ubifs_info *c)
 	 *
 	 * Subtract the LEB reserved for GC and the LEB which is reserved for
 	 * deletions.
-	 *
-	 * Review 'ubifs_calc_available()' if changing this calculation.
 	 */
 	tmp64 = c->main_lebs - 2;
 	tmp64 *= (uint64_t)c->leb_size - c->dark_wm;
-- 
1.5.4.1

