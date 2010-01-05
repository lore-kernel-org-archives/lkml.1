Return-Path: <linux-kernel-owner+w=401wt.eu-S1755049Ab0AEArT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049Ab0AEArT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754971Ab0AEAqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:46:30 -0500
Received: from kroah.org ([198.145.64.141]:34381 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754368Ab0AEAfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:35:33 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Sujith <Sujith.Manoharan@atheros.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 50/97] ath9k: fix suspend by waking device prior to stop
Date: Mon,  4 Jan 2010 16:33:03 -0800
Message-Id: <1262651630-7354-50-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sujith <Sujith.Manoharan@atheros.com>

commit 3867cf6a8c699846e928e8f5a9f31013708df192 upstream.

Ensure the device is awake prior to trying to tell hardware
to stop it. Impact of not doing this is we can likely leave
the device in an undefined state likely causing issues with
suspend and resume. This patch ensures harware is where it
should be prior to suspend.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/wireless/ath/ath9k/main.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 91f9710..80df8f3 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2147,6 +2147,9 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 		return; /* another wiphy still in use */
 	}
 
+	/* Ensure HW is awake when we try to shut it down. */
+	ath9k_ps_wakeup(sc);
+
 	if (sc->sc_flags & SC_OP_BTCOEX_ENABLED) {
 		ath9k_hw_btcoex_disable(sc->sc_ah);
 		if (sc->btcoex_info.btcoex_scheme == ATH_BTCOEX_CFG_3WIRE)
@@ -2167,6 +2170,9 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 	/* disable HAL and put h/w to sleep */
 	ath9k_hw_disable(sc->sc_ah);
 	ath9k_hw_configpcipowersave(sc->sc_ah, 1, 1);
+	ath9k_ps_restore(sc);
+
+	/* Finally, put the chip in FULL SLEEP mode */
 	ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_FULL_SLEEP);
 
 	sc->sc_flags |= SC_OP_INVALID;
-- 
1.6.6

