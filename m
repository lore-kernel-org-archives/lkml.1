Return-Path: <linux-kernel-owner+w=401wt.eu-S1761596AbZEFVzL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761596AbZEFVzL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 17:55:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761010AbZEFVyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 17:54:20 -0400
Received: from kroah.org ([198.145.64.141]:56863 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761089AbZEFVyS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 17:54:18 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed May  6 14:47:55 2009
Message-Id: <20090506214755.469393608@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 06 May 2009 14:45:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       Vasanthakumar Thiagarajan <vasanth@atheros.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch 02/58] mac80211: Fix bug in getting rx status for frames pending in reorder buffer
References: <20090506214528.660389067@mini.kroah.org>
Content-Disposition: inline; filename=mac80211-fix-bug-in-getting-rx-status-for-frames-pending-in-reorder-buffer.patch
In-Reply-To: <20090506215017.GA21981@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Vasanthakumar Thiagarajan <vasanth@atheros.com>

upstream commit: b3631286aca3f54427ca0eb950981e9753866f6c

Currently rx status for frames which are completed from reorder buffer
is taken from it's cb area which is not always right, cb is not holding
the rx status when driver uses mac80211's non-irq rx handler to pass it's
received frames. This results in dropping almost all frames from reorder
buffer when security is enabled by doing double decryption (first in hw,
second in sw because of wrong rx status). This patch copies rx status into
cb area before the frame is put into reorder buffer. After this patch,
there is a significant improvement in throughput with ath9k + WPA2(AES).

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Acked-by: Johannes Berg <johannes@sipsolutions.net>
Cc: stable@kernel.org
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 net/mac80211/rx.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -29,6 +29,7 @@
 static u8 ieee80211_sta_manage_reorder_buf(struct ieee80211_hw *hw,
 					   struct tid_ampdu_rx *tid_agg_rx,
 					   struct sk_buff *skb,
+					   struct ieee80211_rx_status *status,
 					   u16 mpdu_seq_num,
 					   int bar_req);
 /*
@@ -1538,7 +1539,7 @@ ieee80211_rx_h_ctrl(struct ieee80211_rx_
 		/* manage reordering buffer according to requested */
 		/* sequence number */
 		rcu_read_lock();
-		ieee80211_sta_manage_reorder_buf(hw, tid_agg_rx, NULL,
+		ieee80211_sta_manage_reorder_buf(hw, tid_agg_rx, NULL, NULL,
 						 start_seq_num, 1);
 		rcu_read_unlock();
 		return RX_DROP_UNUSABLE;
@@ -2034,6 +2035,7 @@ static inline u16 seq_sub(u16 sq1, u16 s
 static u8 ieee80211_sta_manage_reorder_buf(struct ieee80211_hw *hw,
 					   struct tid_ampdu_rx *tid_agg_rx,
 					   struct sk_buff *skb,
+					   struct ieee80211_rx_status *rxstatus,
 					   u16 mpdu_seq_num,
 					   int bar_req)
 {
@@ -2115,6 +2117,8 @@ static u8 ieee80211_sta_manage_reorder_b
 
 	/* put the frame in the reordering buffer */
 	tid_agg_rx->reorder_buf[index] = skb;
+	memcpy(tid_agg_rx->reorder_buf[index]->cb, rxstatus,
+	       sizeof(*rxstatus));
 	tid_agg_rx->stored_mpdu_num++;
 	/* release the buffer until next missing frame */
 	index = seq_sub(tid_agg_rx->head_seq_num, tid_agg_rx->ssn)
@@ -2140,7 +2144,8 @@ static u8 ieee80211_sta_manage_reorder_b
 }
 
 static u8 ieee80211_rx_reorder_ampdu(struct ieee80211_local *local,
-				     struct sk_buff *skb)
+				     struct sk_buff *skb,
+				     struct ieee80211_rx_status *status)
 {
 	struct ieee80211_hw *hw = &local->hw;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
@@ -2191,7 +2196,7 @@ static u8 ieee80211_rx_reorder_ampdu(str
 
 	/* according to mpdu sequence number deal with reordering buffer */
 	mpdu_seq_num = (sc & IEEE80211_SCTL_SEQ) >> 4;
-	ret = ieee80211_sta_manage_reorder_buf(hw, tid_agg_rx, skb,
+	ret = ieee80211_sta_manage_reorder_buf(hw, tid_agg_rx, skb, status,
 						mpdu_seq_num, 0);
  end_reorder:
 	return ret;
@@ -2255,7 +2260,7 @@ void __ieee80211_rx(struct ieee80211_hw 
 		return;
 	}
 
-	if (!ieee80211_rx_reorder_ampdu(local, skb))
+	if (!ieee80211_rx_reorder_ampdu(local, skb, status))
 		__ieee80211_rx_handle_packet(hw, skb, status, rate);
 
 	rcu_read_unlock();


