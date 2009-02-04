Return-Path: <linux-kernel-owner+w=401wt.eu-S1756393AbZBDSof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393AbZBDSof (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 13:44:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754635AbZBDShY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 13:37:24 -0500
Received: from kroah.org ([198.145.64.141]:51090 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758524AbZBDShR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 13:37:17 -0500
Date: Wed, 4 Feb 2009 10:34:56 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, mohamed abbas <mohamed.abbas@intel.com>,
       Reinette Chatre <reinette.chatre@intel.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 20/33] iwlwifi: fix rs_get_rate WARN_ON()
Message-ID: <20090204183456.GU13936@kroah.com>
References: <20090204182823.831027530@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="iwlwifi-fix-rs_get_rate-warn_on.patch"
In-Reply-To: <20090204183403.GA13936@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Abbas, Mohamed <mohamed.abbas@intel.com>

commit c338ba3ca5bef2df2082d9e8d336ff7b2880c326 upstream.

In ieee80211_sta structure there is u64 supp_rates[IEEE80211_NUM_BANDS]
this is filled with all support rate from assoc_resp.  If we associate
with G-band AP only supp_rates of G-band will be set the other band
supp_rates will be set to 0. If the user type this command
this will cause mac80211 to set to new channel, mac80211
does not disassociate in setting new channel, so the active
band is now A-band. then in handling the new essid mac80211 will
kick in the assoc steps which involve sending disassociation frame.
in this mac80211 will WARN_ON sta->supp_rates[A_BAND] == 0.

This fixes:
http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1822
http://www.kerneloops.org/searchweek.php?search=rs_get_rate

Signed-off-by: mohamed abbas <mohamed.abbas@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c |   12 +++++++++---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c  |   12 ++++++++++--
 2 files changed, 19 insertions(+), 5 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
@@ -647,12 +647,16 @@ static void rs_get_rate(void *priv_r, st
 	s8 scale_action = 0;
 	unsigned long flags;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
-	u16 fc, rate_mask;
+	u16 fc;
+	u16 rate_mask = 0;
 	struct iwl3945_priv *priv = (struct iwl3945_priv *)priv_r;
 	DECLARE_MAC_BUF(mac);
 
 	IWL_DEBUG_RATE("enter\n");
 
+	if (sta)
+		rate_mask = sta->supp_rates[sband->band];
+
 	/* Send management frames and broadcast/multicast data using lowest
 	 * rate. */
 	fc = le16_to_cpu(hdr->frame_control);
@@ -660,11 +664,13 @@ static void rs_get_rate(void *priv_r, st
 	    is_multicast_ether_addr(hdr->addr1) ||
 	    !sta || !priv_sta) {
 		IWL_DEBUG_RATE("leave: No STA priv data to update!\n");
-		sel->rate_idx = rate_lowest_index(sband, sta);
+		if (!rate_mask)
+			sel->rate_idx = rate_lowest_index(sband, NULL);
+		else
+			sel->rate_idx = rate_lowest_index(sband, sta);
 		return;
 	}
 
-	rate_mask = sta->supp_rates[sband->band];
 	index = min(rs_sta->last_txrate_idx & 0xffff, IWL_RATE_COUNT - 1);
 
 	if (sband->band == IEEE80211_BAND_5GHZ)
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -951,7 +951,8 @@ static void rs_tx_status(void *priv_r, s
 	}
 
 	/* See if there's a better rate or modulation mode to try. */
-	rs_rate_scale_perform(priv, hdr, sta, lq_sta);
+	if (sta && sta->supp_rates[sband->band])
+		rs_rate_scale_perform(priv, hdr, sta, lq_sta);
 out:
 	return;
 }
@@ -2114,15 +2115,22 @@ static void rs_get_rate(void *priv_r, st
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	__le16 fc;
 	struct iwl_lq_sta *lq_sta;
+	u64 mask_bit = 0;
 
 	IWL_DEBUG_RATE_LIMIT("rate scale calculate new rate for skb\n");
 
+	if (sta)
+		mask_bit = sta->supp_rates[sband->band];
+
 	/* Send management frames and broadcast/multicast data using lowest
 	 * rate. */
 	fc = hdr->frame_control;
 	if (!ieee80211_is_data(fc) || is_multicast_ether_addr(hdr->addr1) ||
 	    !sta || !priv_sta) {
-		sel->rate_idx = rate_lowest_index(sband, sta);
+		if (!mask_bit)
+			sel->rate_idx = rate_lowest_index(sband, NULL);
+		else
+			sel->rate_idx = rate_lowest_index(sband, sta);
 		return;
 	}
 

