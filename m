Return-Path: <linux-kernel-owner+w=401wt.eu-S1752240AbZLVEXB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240AbZLVEXB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 23:23:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751008AbZLVEXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 23:23:00 -0500
Received: from mail.atheros.com ([12.36.123.2]:21503 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917AbZLVEW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 23:22:59 -0500
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <19248.19829.293087.367661@gargle.gargle.HOWL>
Date: Tue, 22 Dec 2009 10:09:17 +0530
To: Luis Rodriguez <lrodriguez@atheros.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: Asus eeepc 1008HA suspend issue and mac80211 suspend corner case
In-Reply-To: <20091222022355.GA32508@bombadil.infradead.org>
References: <20091222022355.GA32508@bombadil.infradead.org>
X-Mailer: VM 8.0.12 under 23.1.1 (x86_64-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luis Rodriguez wrote:
> That log can be found here:
> 
> http://bombadil.infradead.org/~mcgrof/logs/2.6.31-with-2.6.32-wireless/irq-disabled.txt

Thanks for the log.
It's a bug in ath9k, related to PowerSave.

Can you test this patch ?

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 3f5b887..419c382 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2504,6 +2504,9 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 		return; /* another wiphy still in use */
 	}
 
+	/* Ensure HW is awake when we try to shut it down. */
+	ath9k_ps_wakeup(sc);
+
 	if (ah->btcoex_hw.enabled) {
 		ath9k_hw_btcoex_disable(ah);
 		if (ah->btcoex_hw.scheme == ATH_BTCOEX_CFG_3WIRE)
@@ -2524,8 +2527,10 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 	/* disable HAL and put h/w to sleep */
 	ath9k_hw_disable(ah);
 	ath9k_hw_configpcipowersave(ah, 1, 1);
-	ath9k_setpower(sc, ATH9K_PM_FULL_SLEEP);
+	ath9k_ps_restore(sc);
 
+	/* Finally, put the chip in FULL SLEEP mode */
+	ath9k_setpower(sc, ATH9K_PM_FULL_SLEEP);
 	sc->sc_flags |= SC_OP_INVALID;
 
 	mutex_unlock(&sc->mutex);

