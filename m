Return-Path: <linux-kernel-owner+w=401wt.eu-S1758970AbZJPLj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758970AbZJPLj7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 07:39:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758881AbZJPLj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 07:39:58 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:58364 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758870AbZJPLj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 07:39:57 -0400
Subject: Re: 2.6.32-rc4-git1 -- INFO: possible circular locking dependency 
 detected
From: Johannes Berg <johannes@sipsolutions.net>
To: Miles Lane <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <a44ae5cd0910120528h6d8992fcn8b6592ee799fbfc5@mail.gmail.com>
References: <a44ae5cd0910120528h6d8992fcn8b6592ee799fbfc5@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Oct 2009 19:20:40 +0900
Message-Id: <1255688440.4095.339.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Actually ... seems to be easy to fix.

Can you reproduce this reliably? I suspect not. If you can, try the
patch below to make sure -- I'm pretty certain it is a correct patch
anyhow though.

johannes

---
 net/mac80211/agg-tx.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- wireless-testing.orig/net/mac80211/agg-tx.c	2009-10-16 19:13:48.000000000 +0900
+++ wireless-testing/net/mac80211/agg-tx.c	2009-10-16 19:15:12.000000000 +0900
@@ -666,11 +666,13 @@ void ieee80211_process_addba_resp(struct
 
 	state = &sta->ampdu_mlme.tid_state_tx[tid];
 
+	del_timer_sync(&sta->ampdu_mlme.tid_tx[tid]->addba_resp_timer);
+
 	spin_lock_bh(&sta->lock);
 
 	if (!(*state & HT_ADDBA_REQUESTED_MSK)) {
 		spin_unlock_bh(&sta->lock);
-		return;
+		goto timer_still_needed;
 	}
 
 	if (mgmt->u.action.u.addba_resp.dialog_token !=
@@ -679,13 +681,13 @@ void ieee80211_process_addba_resp(struct
 #ifdef CONFIG_MAC80211_HT_DEBUG
 		printk(KERN_DEBUG "wrong addBA response token, tid %d\n", tid);
 #endif /* CONFIG_MAC80211_HT_DEBUG */
-		return;
+		goto timer_still_needed;
 	}
 
-	del_timer_sync(&sta->ampdu_mlme.tid_tx[tid]->addba_resp_timer);
 #ifdef CONFIG_MAC80211_HT_DEBUG
 	printk(KERN_DEBUG "switched off addBA timer for tid %d \n", tid);
 #endif /* CONFIG_MAC80211_HT_DEBUG */
+
 	if (le16_to_cpu(mgmt->u.action.u.addba_resp.status)
 			== WLAN_STATUS_SUCCESS) {
 		u8 curstate = *state;
@@ -700,4 +702,8 @@ void ieee80211_process_addba_resp(struct
 		___ieee80211_stop_tx_ba_session(sta, tid, WLAN_BACK_INITIATOR);
 	}
 	spin_unlock_bh(&sta->lock);
+
+	return;
+ timer_still_needed:
+	add_timer(&sta->ampdu_mlme.tid_tx[tid]->addba_resp_timer);
 }


