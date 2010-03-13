Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934970Ab0CMBVJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:21:09 -0500
Received: from kroah.org ([198.145.64.141]:60747 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934939Ab0CMAUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:20:30 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:11 2010
Message-Id: <20100313001511.455968532@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:12:50 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Felix Fietkau <nbd@openwrt.org>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 072/123] ath9k: fix rate control fallback rate selection
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Felix Fietkau <nbd@openwrt.org>

commit 5c0ba62fd4b2dce08055a89600f1d834f9f0fe9e upstream.

When selecting the tx fallback rate, rc.c used a separate variable
'nrix' for storing the next rate index, however it did not use that as
reference for further rate index lowering. Because of that, it ended up
reusing the same rate for multiple multi-rate retry stages, thus
decreasing delivery probability under changing link conditions.

This patch removes the separate (unnecessary) variable and fixes
fallback the way it was intended to work.
This should result in increased throughput and better link stability.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/rc.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -668,7 +668,7 @@ static void ath_get_rate(void *priv, str
 	struct ieee80211_tx_rate *rates = tx_info->control.rates;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	__le16 fc = hdr->frame_control;
-	u8 try_per_rate, i = 0, rix, nrix;
+	u8 try_per_rate, i = 0, rix;
 	int is_probe = 0;
 
 	if (rate_control_send_low(sta, priv_sta, txrc))
@@ -688,26 +688,25 @@ static void ath_get_rate(void *priv, str
 
 	rate_table = sc->cur_rate_table;
 	rix = ath_rc_get_highest_rix(sc, ath_rc_priv, rate_table, &is_probe);
-	nrix = rix;
 
 	if (is_probe) {
 		/* set one try for probe rates. For the
 		 * probes don't enable rts */
 		ath_rc_rate_set_series(rate_table, &rates[i++], txrc,
-				       1, nrix, 0);
+				       1, rix, 0);
 
 		/* Get the next tried/allowed rate. No RTS for the next series
 		 * after the probe rate
 		 */
-		ath_rc_get_lower_rix(rate_table, ath_rc_priv, rix, &nrix);
+		ath_rc_get_lower_rix(rate_table, ath_rc_priv, rix, &rix);
 		ath_rc_rate_set_series(rate_table, &rates[i++], txrc,
-				       try_per_rate, nrix, 0);
+				       try_per_rate, rix, 0);
 
 		tx_info->flags |= IEEE80211_TX_CTL_RATE_CTRL_PROBE;
 	} else {
 		/* Set the choosen rate. No RTS for first series entry. */
 		ath_rc_rate_set_series(rate_table, &rates[i++], txrc,
-				       try_per_rate, nrix, 0);
+				       try_per_rate, rix, 0);
 	}
 
 	/* Fill in the other rates for multirate retry */
@@ -716,10 +715,10 @@ static void ath_get_rate(void *priv, str
 		if (i + 1 == 4)
 			try_per_rate = 4;
 
-		ath_rc_get_lower_rix(rate_table, ath_rc_priv, rix, &nrix);
+		ath_rc_get_lower_rix(rate_table, ath_rc_priv, rix, &rix);
 		/* All other rates in the series have RTS enabled */
 		ath_rc_rate_set_series(rate_table, &rates[i], txrc,
-				       try_per_rate, nrix, 1);
+				       try_per_rate, rix, 1);
 	}
 
 	/*


