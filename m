Return-Path: <linux-kernel-owner+w=401wt.eu-S936161AbZLQESZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936161AbZLQESZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:18:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936146AbZLQEFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:05:25 -0500
Received: from kroah.org ([198.145.64.141]:55891 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936129AbZLQEFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:05:21 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:58 2009
Message-Id: <20091217035658.273685245@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:56:55 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, greg@kroah.com
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       linux-wireless@vger.kernel.org,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Vasanthakumar Thiagarajan <vasanth@atheros.com>,
       Vivek Natarajan <Vivek.Natarajan@atheros.com>
Subject: [118/151] ath9k: fix processing of TX PS null data frames
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: "Luis R. Rodriguez" <lrodriguez@atheros.com>

This is a backport of upstream commit: e7824a50662f7f79b1a739f705b4d906c31cf221

When mac80211 was telling us to go into Powersave we listened
and immediately turned RX off. This meant hardware would not
see the ACKs from the AP we're associated with and hardware
we'd end up retransmiting the null data frame in a loop
helplessly.

Fix this by keeping track of the transmitted nullfunc frames
and only when we are sure the AP has sent back an ACK do we
go ahead and shut RX off.


Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Signed-off-by: Vivek Natarajan <Vivek.Natarajan@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    3 +++
 drivers/net/wireless/ath/ath9k/mac.c   |    2 ++
 drivers/net/wireless/ath/ath9k/mac.h   |    1 +
 drivers/net/wireless/ath/ath9k/main.c  |    9 ++++++++-
 drivers/net/wireless/ath/ath9k/xmit.c  |   16 ++++++++++++++++
 5 files changed, 30 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -139,6 +139,7 @@ struct ath_buf {
 	dma_addr_t bf_daddr;		/* physical addr of desc */
 	dma_addr_t bf_buf_addr;		/* physical addr of data buffer */
 	bool bf_stale;
+	bool bf_isnullfunc;
 	u16 bf_flags;
 	struct ath_buf_state bf_state;
 	dma_addr_t bf_dmacontext;
@@ -524,6 +525,8 @@ struct ath_led {
 #define SC_OP_BEACON_SYNC       BIT(19)
 #define SC_OP_BTCOEX_ENABLED    BIT(20)
 #define SC_OP_BT_PRIORITY_DETECTED BIT(21)
+#define SC_OP_NULLFUNC_COMPLETED   BIT(22)
+#define SC_OP_PS_ENABLED	BIT(23)
 
 struct ath_bus_ops {
 	void		(*read_cachesize)(struct ath_softc *sc, int *csz);
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -222,6 +222,8 @@ int ath9k_hw_txprocdesc(struct ath_hw *a
 	ds->ds_txstat.ts_status = 0;
 	ds->ds_txstat.ts_flags = 0;
 
+	if (ads->ds_txstatus1 & AR_FrmXmitOK)
+		ds->ds_txstat.ts_status |= ATH9K_TX_ACKED;
 	if (ads->ds_txstatus1 & AR_ExcessiveRetries)
 		ds->ds_txstat.ts_status |= ATH9K_TXERR_XRETRY;
 	if (ads->ds_txstatus1 & AR_Filtered)
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -76,6 +76,7 @@
 #define ATH9K_TXERR_FIFO           0x04
 #define ATH9K_TXERR_XTXOP          0x08
 #define ATH9K_TXERR_TIMER_EXPIRED  0x10
+#define ATH9K_TX_ACKED		   0x20
 
 #define ATH9K_TX_BA                0x01
 #define ATH9K_TX_PWRMGMT           0x02
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2327,6 +2327,7 @@ static int ath9k_config(struct ieee80211
 
 	if (changed & IEEE80211_CONF_CHANGE_PS) {
 		if (conf->flags & IEEE80211_CONF_PS) {
+			sc->sc_flags |= SC_OP_PS_ENABLED;
 			if (!(ah->caps.hw_caps &
 			      ATH9K_HW_CAP_AUTOSLEEP)) {
 				if ((sc->imask & ATH9K_INT_TIM_TIMER) == 0) {
@@ -2334,11 +2335,17 @@ static int ath9k_config(struct ieee80211
 					ath9k_hw_set_interrupts(sc->sc_ah,
 							sc->imask);
 				}
-				ath9k_hw_setrxabort(sc->sc_ah, 1);
 			}
 			sc->ps_enabled = true;
+			if ((sc->sc_flags & SC_OP_NULLFUNC_COMPLETED)) {
+				sc->sc_flags &= ~SC_OP_NULLFUNC_COMPLETED;
+				sc->ps_enabled = true;
+				ath9k_hw_setrxabort(sc->sc_ah, 1);
+			}
 		} else {
 			sc->ps_enabled = false;
+			sc->sc_flags &= ~(SC_OP_PS_ENABLED |
+					  SC_OP_NULLFUNC_COMPLETED);
 			ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_AWAKE);
 			if (!(ah->caps.hw_caps &
 			      ATH9K_HW_CAP_AUTOSLEEP)) {
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1592,6 +1592,13 @@ static int ath_tx_setup_buffer(struct ie
 	}
 
 	bf->bf_buf_addr = bf->bf_dmacontext;
+
+	if (ieee80211_is_nullfunc(fc) && ieee80211_has_pm(fc)) {
+		bf->bf_isnullfunc = true;
+		sc->sc_flags &= ~SC_OP_NULLFUNC_COMPLETED;
+	} else
+		bf->bf_isnullfunc = false;
+
 	return 0;
 }
 
@@ -1989,6 +1996,15 @@ static void ath_tx_processq(struct ath_s
 		if (ds == txq->axq_gatingds)
 			txq->axq_gatingds = NULL;
 
+		if (bf->bf_isnullfunc &&
+		    (ds->ds_txstat.ts_status & ATH9K_TX_ACKED)) {
+			if ((sc->sc_flags & SC_OP_PS_ENABLED)) {
+				sc->ps_enabled = true;
+				ath9k_hw_setrxabort(sc->sc_ah, 1);
+			} else
+				sc->sc_flags |= SC_OP_NULLFUNC_COMPLETED;
+		}
+
 		/*
 		 * Remove ath_buf's of the same transmit unit from txq,
 		 * however leave the last descriptor back as the holding


