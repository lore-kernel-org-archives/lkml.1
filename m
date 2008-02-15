Return-Path: <linux-kernel-owner+w=401wt.eu-S1763635AbYBOUhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763635AbYBOUhb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 15:37:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759119AbYBOUhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 15:37:14 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:56041 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758544AbYBOUhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 15:37:11 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: linville@tuxdriver.com
Cc: <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org,
       ath5k-devel@lists.ath5k.org, Jiri Slaby <jirislaby@gmail.com>,
       Nick Kossifidis <mickflemm@gmail.com>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: [PATCH 1/1] WDEV: ath5k, test single chip before reset
Date: Fri, 15 Feb 2008 21:37:07 +0100
Message-Id: <1203107827-27632-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move ath5k_hw_nic_wakeup after ah_single_chip being set, because we
test the value in there and decides whether reset or not.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>
Cc: Luis R. Rodriguez <mcgrof@gmail.com>
---
 drivers/net/wireless/ath5k/hw.c |   21 ++++++++++-----------
 1 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index 3a4bf40..9cdd27f 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -181,11 +181,6 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc, u8 mac_version)
 	else if (ah->ah_version <= AR5K_AR5211)
 		ah->ah_proc_rx_desc = ath5k_hw_proc_old_rx_status;
 
-	/* Bring device out of sleep and reset it's units */
-	ret = ath5k_hw_nic_wakeup(ah, AR5K_INIT_MODE, true);
-	if (ret)
-		goto err_free;
-
 	/* Get MAC, PHY and RADIO revisions */
 	srev = ath5k_hw_reg_read(ah, AR5K_SREV);
 	ah->ah_mac_srev = srev;
@@ -210,12 +205,13 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc, u8 mac_version)
 	}
 
 	/* Identify single chip solutions */
-	if((srev <= AR5K_SREV_VER_AR5414) &&
-	(srev >= AR5K_SREV_VER_AR2424)) {
-		ah->ah_single_chip = true;
-	} else {
-		ah->ah_single_chip = false;
-	}
+	ah->ah_single_chip = srev >= AR5K_SREV_VER_AR2424 &&
+			srev <= AR5K_SREV_VER_AR5414;
+
+	/* Bring device out of sleep and reset it's units */
+	ret = ath5k_hw_nic_wakeup(ah, AR5K_INIT_MODE, true);
+	if (ret)
+		goto err_free;
 
 	/* Single chip radio */
 	if (ah->ah_radio_2ghz_revision == ah->ah_radio_5ghz_revision)
-- 
1.5.3.8

