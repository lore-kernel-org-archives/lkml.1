Return-Path: <linux-kernel-owner+w=401wt.eu-S1755016Ab0AEAqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016Ab0AEAqu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:46:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754984Ab0AEAqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:46:33 -0500
Received: from kroah.org ([198.145.64.141]:34369 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754350Ab0AEAfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:35:30 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Felix Fietkau <nbd@openwrt.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 48/97] ath9k: fix missed error codes in the tx status check
Date: Mon,  4 Jan 2010 16:33:01 -0800
Message-Id: <1262651630-7354-48-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Felix Fietkau <nbd@openwrt.org>

commit 5b479a076de091590423a9e6dfc2584126b28761 upstream.

My previous change added in:

 commit 815833e7ecf0b9a017315cae6aef4d7cd9517681
    ath9k: fix tx status reporting

was not checking all possible tx error conditions. This could possibly
lead to throughput issues due to slow rate control adaption or missed
retransmissions of failed A-MPDU frames.

This patch adds a mask for all possible error conditions and uses it
in the xmit ok check.

Reported-by: Björn Smedman <bjorn.smedman@venatech.se>
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/wireless/ath/ath9k/mac.h  |    3 +++
 drivers/net/wireless/ath/ath9k/xmit.c |    2 +-
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index ff65f85..9720c4d 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -77,6 +77,9 @@
 #define ATH9K_TXERR_XTXOP          0x08
 #define ATH9K_TXERR_TIMER_EXPIRED  0x10
 #define ATH9K_TX_ACKED		   0x20
+#define ATH9K_TXERR_MASK						\
+	(ATH9K_TXERR_XRETRY | ATH9K_TXERR_FILT | ATH9K_TXERR_FIFO |	\
+	 ATH9K_TXERR_XTXOP | ATH9K_TXERR_TIMER_EXPIRED)
 
 #define ATH9K_TX_BA                0x01
 #define ATH9K_TX_PWRMGMT           0x02
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 2e0b86b..2c6b063 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2020,7 +2020,7 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 		if (bf_isaggr(bf))
 			txq->axq_aggr_depth--;
 
-		txok = !(ds->ds_txstat.ts_status & ATH9K_TXERR_FILT);
+		txok = !(ds->ds_txstat.ts_status & ATH9K_TXERR_MASK);
 		txq->axq_tx_inprogress = false;
 		spin_unlock_bh(&txq->axq_lock);
 
-- 
1.6.6

