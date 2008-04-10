Return-Path: <linux-kernel-owner+w=401wt.eu-S1758467AbYDJOmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758467AbYDJOmk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 10:42:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757901AbYDJOlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 10:41:47 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:56485 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757313AbYDJOlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 10:41:45 -0400
Message-Id: <20080410134829.412424000@sipsolutions.net>
References: <20080410134810.629048000@sipsolutions.net>
User-Agent: quilt/0.46-1
Date: Thu, 10 Apr 2008 15:48:13 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-kernel@vger.kernel.org
Cc: Josh Triplett <josh@freedesktop.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-wireless@vger.kernel.org, linux-sparse@vger.kernel.org
Subject: [RFC 3/3] mac80211: annotate with __requires_rcu
Content-Disposition: inline; filename=013-mac80211-rcu-sparse.patch
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As an example, this annotates mac80211 with the new __requires_rcu.

Not-yet-signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/key.c      |    2 +-
 net/mac80211/key.h      |    2 +-
 net/mac80211/rx.c       |   12 ++++++------
 net/mac80211/sta_info.h |    3 ++-
 net/mac80211/tx.c       |    3 ++-
 5 files changed, 12 insertions(+), 10 deletions(-)

--- everything.orig/net/mac80211/sta_info.h	2008-04-10 15:36:20.000000000 +0200
+++ everything/net/mac80211/sta_info.h	2008-04-10 15:36:45.000000000 +0200
@@ -321,7 +321,8 @@ static inline enum plink_state sta_plink
 /*
  * Get a STA info, must have be under RCU read lock.
  */
-struct sta_info *sta_info_get(struct ieee80211_local *local, u8 *addr);
+struct sta_info *sta_info_get(struct ieee80211_local *local, u8 *addr) __requires_rcu;
+
 /*
  * Get STA info by index, BROKEN!
  */
--- everything.orig/net/mac80211/key.c	2008-04-10 15:36:20.000000000 +0200
+++ everything/net/mac80211/key.c	2008-04-10 15:36:45.000000000 +0200
@@ -299,7 +299,7 @@ struct ieee80211_key *ieee80211_key_allo
 
 void ieee80211_key_link(struct ieee80211_key *key,
 			struct ieee80211_sub_if_data *sdata,
-			struct sta_info *sta)
+			struct sta_info *sta) __requires_rcu
 {
 	struct ieee80211_key *old_key;
 	unsigned long flags;
--- everything.orig/net/mac80211/key.h	2008-04-10 15:36:20.000000000 +0200
+++ everything/net/mac80211/key.h	2008-04-10 15:36:45.000000000 +0200
@@ -146,7 +146,7 @@ struct ieee80211_key *ieee80211_key_allo
  */
 void ieee80211_key_link(struct ieee80211_key *key,
 			struct ieee80211_sub_if_data *sdata,
-			struct sta_info *sta);
+			struct sta_info *sta) __requires(RCU);
 void ieee80211_key_free(struct ieee80211_key *key);
 void ieee80211_set_default_key(struct ieee80211_sub_if_data *sdata, int idx);
 void ieee80211_free_keys(struct ieee80211_sub_if_data *sdata);
--- everything.orig/net/mac80211/rx.c	2008-04-10 15:36:20.000000000 +0200
+++ everything/net/mac80211/rx.c	2008-04-10 15:36:45.000000000 +0200
@@ -1261,7 +1261,7 @@ static bool ieee80211_frame_allowed(stru
  * requires that rx->skb is a frame with ethernet header
  */
 static void
-ieee80211_deliver_skb(struct ieee80211_rx_data *rx)
+ieee80211_deliver_skb(struct ieee80211_rx_data *rx) __requires_rcu
 {
 	struct net_device *dev = rx->dev;
 	struct ieee80211_local *local = rx->local;
@@ -1349,7 +1349,7 @@ ieee80211_deliver_skb(struct ieee80211_r
 }
 
 static ieee80211_rx_result
-ieee80211_rx_h_amsdu(struct ieee80211_rx_data *rx)
+ieee80211_rx_h_amsdu(struct ieee80211_rx_data *rx) __requires_rcu
 {
 	struct net_device *dev = rx->dev;
 	struct ieee80211_local *local = rx->local;
@@ -1466,7 +1466,7 @@ ieee80211_rx_h_amsdu(struct ieee80211_rx
 }
 
 static ieee80211_rx_result
-ieee80211_rx_h_data(struct ieee80211_rx_data *rx)
+ieee80211_rx_h_data(struct ieee80211_rx_data *rx) __requires_rcu
 {
 	struct net_device *dev = rx->dev;
 	u16 fc;
@@ -1876,7 +1876,7 @@ static void __ieee80211_rx_handle_packet
 					 struct sk_buff *skb,
 					 struct ieee80211_rx_status *status,
 					 u32 load,
-					 struct ieee80211_rate *rate)
+					 struct ieee80211_rate *rate) __requires_rcu
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_sub_if_data *sdata;
@@ -1997,7 +1997,7 @@ static inline u16 seq_sub(u16 sq1, u16 s
 u8 ieee80211_sta_manage_reorder_buf(struct ieee80211_hw *hw,
 				struct tid_ampdu_rx *tid_agg_rx,
 				struct sk_buff *skb, u16 mpdu_seq_num,
-				int bar_req)
+				int bar_req) __requires_rcu
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_rx_status status;
@@ -2100,7 +2100,7 @@ u8 ieee80211_sta_manage_reorder_buf(stru
 }
 
 static u8 ieee80211_rx_reorder_ampdu(struct ieee80211_local *local,
-				     struct sk_buff *skb)
+				     struct sk_buff *skb) __requires_rcu
 {
 	struct ieee80211_hw *hw = &local->hw;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
--- everything.orig/net/mac80211/tx.c	2008-04-10 15:36:20.000000000 +0200
+++ everything/net/mac80211/tx.c	2008-04-10 15:36:45.000000000 +0200
@@ -968,7 +968,7 @@ static ieee80211_tx_result
 __ieee80211_tx_prepare(struct ieee80211_tx_data *tx,
 		       struct sk_buff *skb,
 		       struct net_device *dev,
-		       struct ieee80211_tx_control *control)
+		       struct ieee80211_tx_control *control) __requires_rcu
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_hdr *hdr;
@@ -1047,6 +1047,7 @@ static int ieee80211_tx_prepare(struct i
 				struct sk_buff *skb,
 				struct net_device *mdev,
 				struct ieee80211_tx_control *control)
+	__requires_rcu
 {
 	struct ieee80211_tx_packet_data *pkt_data;
 	struct net_device *dev;

-- 

