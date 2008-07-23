Return-Path: <linux-kernel-owner+w=401wt.eu-S1754538AbYGWLUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538AbYGWLUy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 07:20:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752779AbYGWLUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 07:20:32 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:45053 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486AbYGWLUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 07:20:30 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: linville@tuxdriver.com
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       Jiri Slaby <jirislaby@gmail.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Nick Kossifidis <mickflemm@gmail.com>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: [PATCH 1/3] Ath5k: fix beacon-update deadlock
Date: Wed, 23 Jul 2008 13:17:33 +0200
Message-Id: <1216811855-9387-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.6.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 9d139c810a2aa17365cc548d0cd2a189d8433c65 introduced
AA deadlock -- ath5k_config_interface(); holds sc->lock
and it calls ath5k_beacon_update(); which tries to grab the
lock again.

Don't grab the lock in beacon update, since only caller is
config iface for now.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>
Cc: Luis R. Rodriguez <mcgrof@gmail.com>
---
 drivers/net/wireless/ath5k/base.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 7273e9f..898a969 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -3065,8 +3065,6 @@ ath5k_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
 
 	ath5k_debug_dump_skb(sc, skb, "BC  ", 1);
 
-	mutex_lock(&sc->lock);
-
 	if (sc->opmode != IEEE80211_IF_TYPE_IBSS) {
 		ret = -EIO;
 		goto end;
@@ -3081,9 +3079,7 @@ ath5k_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
 		ath5k_beacon_config(sc);
 		mmiowb();
 	}
-
 end:
-	mutex_unlock(&sc->lock);
 	return ret;
 }
 
-- 
1.5.6.2

