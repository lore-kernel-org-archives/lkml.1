Return-Path: <linux-kernel-owner+w=401wt.eu-S1759430AbYBNPlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759430AbYBNPlb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 10:41:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753867AbYBNPjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 10:39:23 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:49925 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753256AbYBNPjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 10:39:14 -0500
From: =?utf-8?q?S=2E=C3=87a=C4=9Flar=20Onur?= <caglar@pardus.org.tr>
To: linux-kernel@vger.kernel.org
Cc: linux-wireless@vger.kernel.org,
       =?utf-8?q?S=2E=C3=87a=C4=9Flar=20Onur?= <caglar@pardus.org.tr>
Subject: [PATCH 09/14] net/mac80211/: Use time_* macros
Date: Thu, 14 Feb 2008 17:36:47 +0200
Message-Id: <1203003412-11594-10-git-send-email-caglar@pardus.org.tr>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: y
References: y
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The functions time_before, time_before_eq, time_after, and time_after_eq are more robust for comparing jiffies against other values.

So following patch implements usage of the time_after() macro, defined at linux/jiffies.h, which deals with wrapping correctly

Cc: linux-wireless@vger.kernel.org
Signed-off-by: S.Çağlar Onur <caglar@pardus.org.tr>
---
 net/mac80211/rc80211_simple.c |    3 ++-
 net/mac80211/rx.c             |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/rc80211_simple.c b/net/mac80211/rc80211_simple.c
index 9a78b11..91bbff1 100644
--- a/net/mac80211/rc80211_simple.c
+++ b/net/mac80211/rc80211_simple.c
@@ -7,6 +7,7 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/jiffies.h>
 #include <linux/init.h>
 #include <linux/netdevice.h>
 #include <linux/types.h>
@@ -177,7 +178,7 @@ static void rate_control_simple_tx_status(void *priv, struct net_device *dev,
 		rate_control_rate_dec(local, sta);
 	}
 
-	if (srctrl->avg_rate_update + 60 * HZ < jiffies) {
+	if (time_after(jiffies, srctrl->avg_rate_update + 60 * HZ)) {
 		srctrl->avg_rate_update = jiffies;
 		if (srctrl->tx_avg_rate_num > 0) {
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 535407d..592581a 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -9,6 +9,7 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/jiffies.h>
 #include <linux/kernel.h>
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
@@ -801,7 +802,7 @@ ieee80211_reassemble_find(struct ieee80211_sub_if_data *sdata,
 		    compare_ether_addr(hdr->addr2, f_hdr->addr2) != 0)
 			continue;
 
-		if (entry->first_frag_time + 2 * HZ < jiffies) {
+		if (time_after(jiffies, entry->first_frag_time + 2 * HZ)) {
 			__skb_queue_purge(&entry->skb_list);
 			continue;
 		}
-- 
1.5.3.7

