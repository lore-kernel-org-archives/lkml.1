Return-Path: <linux-kernel-owner+w=401wt.eu-S1754390Ab0AEAqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390Ab0AEAqx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:46:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754976Ab0AEAqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:46:31 -0500
Received: from kroah.org ([198.145.64.141]:34375 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754367Ab0AEAfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:35:31 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 49/97] ath9k: wake hardware during AMPDU TX actions
Date: Mon,  4 Jan 2010 16:33:02 -0800
Message-Id: <1262651630-7354-49-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Luis R. Rodriguez <lrodriguez@atheros.com>

commit 8b685ba9de803f210936400612a32a2003f47cd3 upstream.

AMDPDU actions poke hardware for TX operation, as such
we want to turn hardware on for these actions. AMDPU RX operations
do not require hardware on as nothing is done in hardware for
those actions. Without this we cannot guarantee hardware has
been programmed correctly for each AMPDU TX action.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/wireless/ath/ath9k/main.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 909e839..91f9710 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2726,15 +2726,21 @@ static int ath9k_ampdu_action(struct ieee80211_hw *hw,
 	case IEEE80211_AMPDU_RX_STOP:
 		break;
 	case IEEE80211_AMPDU_TX_START:
+		ath9k_ps_wakeup(sc);
 		ath_tx_aggr_start(sc, sta, tid, ssn);
 		ieee80211_start_tx_ba_cb_irqsafe(hw, sta->addr, tid);
+		ath9k_ps_restore(sc);
 		break;
 	case IEEE80211_AMPDU_TX_STOP:
+		ath9k_ps_wakeup(sc);
 		ath_tx_aggr_stop(sc, sta, tid);
 		ieee80211_stop_tx_ba_cb_irqsafe(hw, sta->addr, tid);
+		ath9k_ps_restore(sc);
 		break;
 	case IEEE80211_AMPDU_TX_OPERATIONAL:
+		ath9k_ps_wakeup(sc);
 		ath_tx_aggr_resume(sc, sta, tid);
+		ath9k_ps_restore(sc);
 		break;
 	default:
 		DPRINTF(sc, ATH_DBG_FATAL, "Unknown AMPDU action\n");
-- 
1.6.6

