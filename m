Return-Path: <linux-kernel-owner+w=401wt.eu-S1756326AbYDGT5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756326AbYDGT5X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 15:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752765AbYDGT45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 15:56:57 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:45216 "EHLO WNmonitoring"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752167AbYDGT44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 15:56:56 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: linville@tuxdriver.com
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       Michael Wu <flamingice@sourmilk.net>,
       Johannes Berg <johannes@sipsolutions.net>, Jiri Benc <jbenc@suse.cz>
Subject: [PATCH 1/2] mac80211: fix recursive locking in ieee80211_sta_expire
Date: Mon,  7 Apr 2008 21:53:48 +0200
Message-Id: <1207598029-20000-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

it's against -mm, what's current mac80211 git tree? It seems that
-mm has fresher material, than wireless-2.6...

--

ieee80211_sta_expire grabs local->sta_lock and calls sta_info_unlink
which tries to grab the lock again. (make available) and use
__sta_info_unlink variant instead.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Michael Wu <flamingice@sourmilk.net>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Jiri Benc <jbenc@suse.cz>
---
 net/mac80211/ieee80211_sta.c |    2 +-
 net/mac80211/sta_info.c      |    2 +-
 net/mac80211/sta_info.h      |    2 ++
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index f9cf2f1..cfe6fcc 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -3081,7 +3081,7 @@ static void ieee80211_sta_expire(struct net_device *dev, unsigned long exp_time)
 		if (time_after(jiffies, sta->last_rx + exp_time)) {
 			printk(KERN_DEBUG "%s: expiring inactive STA %s\n",
 			       dev->name, print_mac(mac, sta->addr));
-			sta_info_unlink(&sta);
+			__sta_info_unlink(&sta);
 			if (sta)
 				list_add(&sta->list, &tmp_list);
 		}
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index f708367..ba02b43 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -409,7 +409,7 @@ static struct sta_info *__sta_info_unpin(struct sta_info *sta)
 	return ret;
 }
 
-static void __sta_info_unlink(struct sta_info **sta)
+void __sta_info_unlink(struct sta_info **sta)
 {
 	struct ieee80211_local *local = (*sta)->local;
 	struct ieee80211_sub_if_data *sdata = (*sta)->sdata;
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 5e39a41..3a89b28 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -347,6 +347,8 @@ int sta_info_insert(struct sta_info *sta);
  * has already unlinked it.
  */
 void sta_info_unlink(struct sta_info **sta);
+/* no lock version */
+void __sta_info_unlink(struct sta_info **sta);
 
 void sta_info_destroy(struct sta_info *sta);
 void sta_info_set_tim_bit(struct sta_info *sta);
-- 
1.5.4.4

