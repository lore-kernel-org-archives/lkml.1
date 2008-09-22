Return-Path: <linux-kernel-owner+w=401wt.eu-S1754139AbYIVSgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139AbYIVSgA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 14:36:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752959AbYIVSfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 14:35:51 -0400
Received: from ti-out-0910.google.com ([209.85.142.189]:2344 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752878AbYIVSft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 14:35:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=NwV1+E5/aZTzHI2NY1dAuhQ9gJrkCSzrI68O6GqvxO3G9Hc75CjtUvbHiiG5gH/ipt
         8mNaQE3vU3P0wd/lMmu4BLViC+smSmGOzcH/M8ofBcMvtjJV55rqPOhtoOu6KsEZuhGw
         7dun2pZTY9+28E+IMeTTVLD2oYJPZfKBWrV4M=
From: Denis ChengRq <crquan@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [WIRELESS CORE] a global static to local static improvement
Date: Tue, 23 Sep 2008 02:35:37 +0800
Message-Id: <1222108537-5097-1-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two improvements in this simple patch:
1. wiphy_counter is a static var only used in one function, so
   can use local static instead of global static;
2. wiphy_counter wrap handling killed one comparision with unlike;

Signed-off-by: Denis ChengRq <crquan@gmail.com>
---
 net/wireless/core.c |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index f1da0b9..af8af8b 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -32,7 +32,6 @@ MODULE_DESCRIPTION("wireless configuration support");
  * often because we need to do it for each command */
 LIST_HEAD(cfg80211_drv_list);
 DEFINE_MUTEX(cfg80211_drv_mutex);
-static int wiphy_counter;
 
 /* for debugfs */
 static struct dentry *ieee80211_debugfs_dir;
@@ -204,6 +203,8 @@ out_unlock:
 
 struct wiphy *wiphy_new(struct cfg80211_ops *ops, int sizeof_priv)
 {
+	static int wiphy_counter;
+
 	struct cfg80211_registered_device *drv;
 	int alloc_size;
 
@@ -220,21 +221,18 @@ struct wiphy *wiphy_new(struct cfg80211_ops *ops, int sizeof_priv)
 
 	mutex_lock(&cfg80211_drv_mutex);
 
-	drv->idx = wiphy_counter;
-
-	/* now increase counter for the next device unless
-	 * it has wrapped previously */
-	if (wiphy_counter >= 0)
-		wiphy_counter++;
-
-	mutex_unlock(&cfg80211_drv_mutex);
+	drv->idx = wiphy_counter++;
 
 	if (unlikely(drv->idx < 0)) {
+		wiphy_counter--;
+		mutex_unlock(&cfg80211_drv_mutex);
 		/* ugh, wrapped! */
 		kfree(drv);
 		return NULL;
 	}
 
+	mutex_unlock(&cfg80211_drv_mutex);
+
 	/* give it a proper name */
 	snprintf(drv->wiphy.dev.bus_id, BUS_ID_SIZE,
 		 PHY_NAME "%d", drv->idx);
-- 
1.5.6.3

