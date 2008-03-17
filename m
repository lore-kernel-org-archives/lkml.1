Return-Path: <linux-kernel-owner+w=401wt.eu-S1757251AbYCQJjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251AbYCQJjX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 05:39:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755963AbYCQJhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 05:37:45 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:42593 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753366AbYCQJhU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 05:37:20 -0400
From: =?utf-8?q?S=2E=C3=87a=C4=9Flar=20Onur?= <caglar@pardus.org.tr>
To: linux-kernel@vger.kernel.org
Cc: linux-wireless@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] net/mac80211/: Use time_* macros
Date: Mon, 17 Mar 2008 11:36:29 +0200
Message-Id: <1205746593-24820-7-git-send-email-caglar@pardus.org.tr>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1205746593-24820-6-git-send-email-caglar@pardus.org.tr>
References: <>
 <1205746593-24820-1-git-send-email-caglar@pardus.org.tr>
 <1205746593-24820-2-git-send-email-caglar@pardus.org.tr>
 <1205746593-24820-3-git-send-email-caglar@pardus.org.tr>
 <1205746593-24820-4-git-send-email-caglar@pardus.org.tr>
 <1205746593-24820-5-git-send-email-caglar@pardus.org.tr>
 <1205746593-24820-6-git-send-email-caglar@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The functions time_before, time_before_eq, time_after, and time_after_eq are more robust for comparing jiffies against other values.

So following patch implements usage of the time_after() macro, defined at linux/jiffies.h, which deals with wrapping correctly

Cc: linux-wireless@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
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
1.5.4.3

