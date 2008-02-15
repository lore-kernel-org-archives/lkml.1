Return-Path: <linux-kernel-owner+w=401wt.eu-S1765738AbYBOU77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765738AbYBOU77 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 15:59:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765617AbYBOU7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 15:59:38 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:56097 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765585AbYBOU7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 15:59:36 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: linville@tuxdriver.com
Cc: <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org,
       ath5k-devel@lists.ath5k.org, Jiri Slaby <jirislaby@gmail.com>,
       Nick Kossifidis <mickflemm@gmail.com>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: [PATCH 2/3] WDEV, ath5k, don't return int from bool function
Date: Fri, 15 Feb 2008 21:58:52 +0100
Message-Id: <1203109133-32217-2-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <1203109133-32217-1-git-send-email-jirislaby@gmail.com>
References: <1203109133-32217-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sparse sees int -> bool cast as an error:
hw.c:3754:10: warning: cast truncates bits from constant value (ffffffea becomes 0)
Fix it by converting the rettype to int and check appropriately.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>
Cc: Luis R. Rodriguez <mcgrof@gmail.com>
---
 drivers/net/wireless/ath5k/ath5k.h |    2 +-
 drivers/net/wireless/ath5k/base.c  |    5 ++++-
 drivers/net/wireless/ath5k/hw.c    |    8 ++++----
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath5k/ath5k.h b/drivers/net/wireless/ath5k/ath5k.h
index c79066b..69dea33 100644
--- a/drivers/net/wireless/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath5k/ath5k.h
@@ -1035,7 +1035,7 @@ struct ath5k_hw {
 		unsigned int, unsigned int, enum ath5k_pkt_type, unsigned int,
 		unsigned int, unsigned int, unsigned int, unsigned int,
 		unsigned int, unsigned int, unsigned int);
-	bool (*ah_setup_xtx_desc)(struct ath5k_hw *, struct ath5k_desc *,
+	int (*ah_setup_xtx_desc)(struct ath5k_hw *, struct ath5k_desc *,
 		unsigned int, unsigned int, unsigned int, unsigned int,
 		unsigned int, unsigned int);
 	int (*ah_proc_tx_desc)(struct ath5k_hw *, struct ath5k_desc *);
diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 49d38e8..59e5d56 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -668,7 +668,10 @@ ath5k_attach(struct pci_dev *pdev, struct ieee80211_hw *hw)
 	 * return false w/o doing anything.  MAC's that do
 	 * support it will return true w/o doing anything.
 	 */
-	if (ah->ah_setup_xtx_desc(ah, NULL, 0, 0, 0, 0, 0, 0))
+	ret = ah->ah_setup_xtx_desc(ah, NULL, 0, 0, 0, 0, 0, 0);
+	if (ret < 0)
+		goto err;
+	if (ret > 0)
 		__set_bit(ATH_STAT_MRRETRY, sc->status);
 
 	/*
diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index 93a75f2..463413a 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -45,7 +45,7 @@ static int ath5k_hw_setup_4word_tx_desc(struct ath5k_hw *, struct ath5k_desc *,
 	unsigned int, unsigned int, enum ath5k_pkt_type, unsigned int,
 	unsigned int, unsigned int, unsigned int, unsigned int, unsigned int,
 	unsigned int, unsigned int);
-static bool ath5k_hw_setup_xr_tx_desc(struct ath5k_hw *, struct ath5k_desc *,
+static int ath5k_hw_setup_xr_tx_desc(struct ath5k_hw *, struct ath5k_desc *,
 	unsigned int, unsigned int, unsigned int, unsigned int, unsigned int,
 	unsigned int);
 static int ath5k_hw_proc_4word_tx_status(struct ath5k_hw *, struct ath5k_desc *);
@@ -3733,7 +3733,7 @@ static int ath5k_hw_setup_4word_tx_desc(struct ath5k_hw *ah,
 /*
  * Initialize a 4-word multirate tx descriptor on 5212
  */
-static bool
+static int
 ath5k_hw_setup_xr_tx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
 	unsigned int tx_rate1, u_int tx_tries1, u_int tx_rate2, u_int tx_tries2,
 	unsigned int tx_rate3, u_int tx_tries3)
@@ -3773,10 +3773,10 @@ ath5k_hw_setup_xr_tx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
 
 #undef _XTX_TRIES
 
-		return true;
+		return 1;
 	}
 
-	return false;
+	return 0;
 }
 
 /*
-- 
1.5.3.8

