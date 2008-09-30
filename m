Return-Path: <linux-kernel-owner+w=401wt.eu-S1753685AbYI3Hpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685AbYI3Hpp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 03:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751921AbYI3HmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 03:42:18 -0400
Received: from smtp.nokia.com ([192.100.122.233]:41768 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315AbYI3HmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 03:42:08 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: linux-fsdevel@vger.kernel.org
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org
Subject: [PATCH] UBIFS: inline one-line functions
Date: Tue, 30 Sep 2008 12:18:59 +0300
Message-Id: <1222766358-21886-4-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1222766358-21886-1-git-send-email-dedekind@infradead.org>
References: <1222766358-21886-1-git-send-email-dedekind@infradead.org>
X-OriginalArrivalTime: 30 Sep 2008 07:41:36.0616 (UTC) FILETIME=[F7B4B680:01C922CF]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

'ubifs_get_lprops()' and 'ubifs_release_lprops()' basically wrap
mutex lock and unlock. We have them because we want lprops subsystem
be separate and as independent as possible. And we planned better
locking rules for lprops.

Anyway, because they are short, it is better to inline them.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/ubifs/lprops.c |   28 ----------------------------
 fs/ubifs/misc.h   |   27 +++++++++++++++++++++++++++
 fs/ubifs/ubifs.h  |    2 --
 3 files changed, 27 insertions(+), 30 deletions(-)

diff --git a/fs/ubifs/lprops.c b/fs/ubifs/lprops.c
index 3659b88..f27176e 100644
--- a/fs/ubifs/lprops.c
+++ b/fs/ubifs/lprops.c
@@ -461,18 +461,6 @@ static void change_category(struct ubifs_info *c, struct ubifs_lprops *lprops)
 }
 
 /**
- * ubifs_get_lprops - get reference to LEB properties.
- * @c: the UBIFS file-system description object
- *
- * This function locks lprops. Lprops have to be unlocked by
- * 'ubifs_release_lprops()'.
- */
-void ubifs_get_lprops(struct ubifs_info *c)
-{
-	mutex_lock(&c->lp_mutex);
-}
-
-/**
  * calc_dark - calculate LEB dark space size.
  * @c: the UBIFS file-system description object
  * @spc: amount of free and dirty space in the LEB
@@ -643,22 +631,6 @@ const struct ubifs_lprops *ubifs_change_lp(struct ubifs_info *c,
 }
 
 /**
- * ubifs_release_lprops - release lprops lock.
- * @c: the UBIFS file-system description object
- *
- * This function has to be called after each 'ubifs_get_lprops()' call to
- * unlock lprops.
- */
-void ubifs_release_lprops(struct ubifs_info *c)
-{
-	ubifs_assert(mutex_is_locked(&c->lp_mutex));
-	ubifs_assert(c->lst.empty_lebs >= 0 &&
-		     c->lst.empty_lebs <= c->main_lebs);
-
-	mutex_unlock(&c->lp_mutex);
-}
-
-/**
  * ubifs_get_lp_stats - get lprops statistics.
  * @c: UBIFS file-system description object
  * @st: return statistics
diff --git a/fs/ubifs/misc.h b/fs/ubifs/misc.h
index 4c12a92..4fa81d8 100644
--- a/fs/ubifs/misc.h
+++ b/fs/ubifs/misc.h
@@ -310,4 +310,31 @@ static inline int ubifs_tnc_lookup(struct ubifs_info *c,
 	return ubifs_tnc_locate(c, key, node, NULL, NULL);
 }
 
+/**
+ * ubifs_get_lprops - get reference to LEB properties.
+ * @c: the UBIFS file-system description object
+ *
+ * This function locks lprops. Lprops have to be unlocked by
+ * 'ubifs_release_lprops()'.
+ */
+static inline void ubifs_get_lprops(struct ubifs_info *c)
+{
+	mutex_lock(&c->lp_mutex);
+}
+
+/**
+ * ubifs_release_lprops - release lprops lock.
+ * @c: the UBIFS file-system description object
+ *
+ * This function has to be called after each 'ubifs_get_lprops()' call to
+ * unlock lprops.
+ */
+static inline void ubifs_release_lprops(struct ubifs_info *c)
+{
+	ubifs_assert(mutex_is_locked(&c->lp_mutex));
+	ubifs_assert(c->lst.empty_lebs >= 0 &&
+		     c->lst.empty_lebs <= c->main_lebs);
+	mutex_unlock(&c->lp_mutex);
+}
+
 #endif /* __UBIFS_MISC_H__ */
diff --git a/fs/ubifs/ubifs.h b/fs/ubifs/ubifs.h
index 17c620b..ce86549 100644
--- a/fs/ubifs/ubifs.h
+++ b/fs/ubifs/ubifs.h
@@ -1586,12 +1586,10 @@ int ubifs_lpt_post_commit(struct ubifs_info *c);
 void ubifs_lpt_free(struct ubifs_info *c, int wr_only);
 
 /* lprops.c */
-void ubifs_get_lprops(struct ubifs_info *c);
 const struct ubifs_lprops *ubifs_change_lp(struct ubifs_info *c,
 					   const struct ubifs_lprops *lp,
 					   int free, int dirty, int flags,
 					   int idx_gc_cnt);
-void ubifs_release_lprops(struct ubifs_info *c);
 void ubifs_get_lp_stats(struct ubifs_info *c, struct ubifs_lp_stats *stats);
 void ubifs_add_to_cat(struct ubifs_info *c, struct ubifs_lprops *lprops,
 		      int cat);
-- 
1.5.4.1

