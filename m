Return-Path: <linux-kernel-owner+w=401wt.eu-S1755975AbYDGT5I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975AbYDGT5I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 15:57:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752331AbYDGT45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 15:56:57 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:45217 "EHLO WNmonitoring"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752124AbYDGT44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 15:56:56 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: linville@tuxdriver.com
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       Michael Wu <flamingice@sourmilk.net>,
       Johannes Berg <johannes@sipsolutions.net>, Jiri Benc <jbenc@suse.cz>
Subject: [PATCH 2/2] mac80211: fix defined but not used
Date: Mon,  7 Apr 2008 21:53:49 +0200
Message-Id: <1207598029-20000-2-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.4.4
In-Reply-To: <1207598029-20000-1-git-send-email-jirislaby@gmail.com>
References: <1207598029-20000-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two symbols are used only in ifdeffed function. Move them to that
section too.
net/mac80211/sta_info.c:387: warning: `__sta_info_pin' defined but not used
net/mac80211/sta_info.c:397: warning: `__sta_info_unpin' defined but not used

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Michael Wu <flamingice@sourmilk.net>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Jiri Benc <jbenc@suse.cz>
---
 net/mac80211/sta_info.c |   60 +++++++++++++++++++++++-----------------------
 1 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index ba02b43..e30426e 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -379,36 +379,6 @@ void sta_info_clear_tim_bit(struct sta_info *sta)
 	spin_unlock_irqrestore(&sta->local->sta_lock, flags);
 }
 
-/*
- * See comment in __sta_info_unlink,
- * caller must hold local->sta_lock.
- */
-static void __sta_info_pin(struct sta_info *sta)
-{
-	WARN_ON(sta->pin_status != STA_INFO_PIN_STAT_NORMAL);
-	sta->pin_status = STA_INFO_PIN_STAT_PINNED;
-}
-
-/*
- * See comment in __sta_info_unlink, returns sta if it
- * needs to be destroyed.
- */
-static struct sta_info *__sta_info_unpin(struct sta_info *sta)
-{
-	struct sta_info *ret = NULL;
-	unsigned long flags;
-
-	spin_lock_irqsave(&sta->local->sta_lock, flags);
-	WARN_ON(sta->pin_status != STA_INFO_PIN_STAT_DESTROY &&
-		sta->pin_status != STA_INFO_PIN_STAT_PINNED);
-	if (sta->pin_status == STA_INFO_PIN_STAT_DESTROY)
-		ret = sta;
-	sta->pin_status = STA_INFO_PIN_STAT_NORMAL;
-	spin_unlock_irqrestore(&sta->local->sta_lock, flags);
-
-	return ret;
-}
-
 void __sta_info_unlink(struct sta_info **sta)
 {
 	struct ieee80211_local *local = (*sta)->local;
@@ -565,6 +535,36 @@ static void sta_info_cleanup(unsigned long data)
 }
 
 #ifdef CONFIG_MAC80211_DEBUGFS
+/*
+ * See comment in __sta_info_unlink,
+ * caller must hold local->sta_lock.
+ */
+static void __sta_info_pin(struct sta_info *sta)
+{
+	WARN_ON(sta->pin_status != STA_INFO_PIN_STAT_NORMAL);
+	sta->pin_status = STA_INFO_PIN_STAT_PINNED;
+}
+
+/*
+ * See comment in __sta_info_unlink, returns sta if it
+ * needs to be destroyed.
+ */
+static struct sta_info *__sta_info_unpin(struct sta_info *sta)
+{
+	struct sta_info *ret = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&sta->local->sta_lock, flags);
+	WARN_ON(sta->pin_status != STA_INFO_PIN_STAT_DESTROY &&
+		sta->pin_status != STA_INFO_PIN_STAT_PINNED);
+	if (sta->pin_status == STA_INFO_PIN_STAT_DESTROY)
+		ret = sta;
+	sta->pin_status = STA_INFO_PIN_STAT_NORMAL;
+	spin_unlock_irqrestore(&sta->local->sta_lock, flags);
+
+	return ret;
+}
+
 static void sta_info_debugfs_add_work(struct work_struct *work)
 {
 	struct ieee80211_local *local =
-- 
1.5.4.4

