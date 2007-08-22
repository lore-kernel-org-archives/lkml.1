Return-Path: <linux-kernel-owner+w=401wt.eu-S932675AbXHVQYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932675AbXHVQYM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 12:24:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932429AbXHVQX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 12:23:56 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50819 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932319AbXHVQXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 12:23:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.23-rc3-mm1: fix b43 compilation
Date: Wed, 22 Aug 2007 18:33:58 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Michael Buesch <mb@bu3sch.de>,
       "John W. Linville" <linville@tuxdriver.com>,
       Broadcom Linux <bcm43xx-dev@lists.berlios.de>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
In-Reply-To: <20070822020648.5ea3a612.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708221833.59375.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 22 August 2007 11:06, Andrew Morton wrote:
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc3/2.6.23-rc3-mm1/
> 
> - git-ixgbe.patch got dropped - git-net.patch destroyed it
> 
> - then git-net got dropped as it doesn't work

Apparently, the b43 driver is expecting another version of mac80211.

This patch fixes the compilation, but I'm not sure what about the
functionality. ;-)

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/net/wireless/b43/main.c |    6 ++----
 drivers/net/wireless/b43/xmit.c |   10 ++++------
 2 files changed, 6 insertions(+), 10 deletions(-)

Index: linux-2.6.23-rc3-mm1/drivers/net/wireless/b43/main.c
===================================================================
--- linux-2.6.23-rc3-mm1.orig/drivers/net/wireless/b43/main.c
+++ linux-2.6.23-rc3-mm1/drivers/net/wireless/b43/main.c
@@ -1189,8 +1189,7 @@ static void b43_write_probe_resp_plcp(st
 
 	plcp.data = 0;
 	b43_generate_plcp_hdr(&plcp, size + FCS_LEN, rate);
-	dur = ieee80211_generic_frame_duration(dev->wl->hw,
-					       dev->wl->if_id, size,
+	dur = ieee80211_generic_frame_duration(dev->wl->hw, size,
 					       B43_RATE_TO_BASE100KBPS(rate));
 	/* Write PLCP in two parts and timing for packet transfer */
 	tmp = le32_to_cpu(plcp.data);
@@ -1246,8 +1245,7 @@ static u8 *b43_generate_probe_resp(struc
 	/* Set the frame control. */
 	hdr->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 					 IEEE80211_STYPE_PROBE_RESP);
-	dur = ieee80211_generic_frame_duration(dev->wl->hw,
-					       dev->wl->if_id, *dest_size,
+	dur = ieee80211_generic_frame_duration(dev->wl->hw, *dest_size,
 					       B43_RATE_TO_BASE100KBPS(rate));
 	hdr->duration_id = dur;
 
Index: linux-2.6.23-rc3-mm1/drivers/net/wireless/b43/xmit.c
===================================================================
--- linux-2.6.23-rc3-mm1.orig/drivers/net/wireless/b43/xmit.c
+++ linux-2.6.23-rc3-mm1/drivers/net/wireless/b43/xmit.c
@@ -220,7 +220,6 @@ static void generate_txhdr_fw4(struct b4
 	} else {
 		int fbrate_base100kbps = B43_RATE_TO_BASE100KBPS(rate_fb);
 		txhdr->dur_fb = ieee80211_generic_frame_duration(dev->wl->hw,
-								 dev->wl->if_id,
 								 fragment_len,
 								 fbrate_base100kbps);
 	}
@@ -311,16 +310,15 @@ static void generate_txhdr_fw4(struct b4
 		rts_rate_fb_ofdm = b43_is_ofdm_rate(rts_rate_fb);
 
 		if (txctl->flags & IEEE80211_TXCTL_USE_CTS_PROTECT) {
-			ieee80211_ctstoself_get(dev->wl->hw, dev->wl->if_id,
-						fragment_data, fragment_len,
-						txctl,
+			ieee80211_ctstoself_get(dev->wl->hw, fragment_data,
+						fragment_len, txctl,
 						(struct ieee80211_cts *)(txhdr->
 									 rts_frame));
 			mac_ctl |= B43_TX4_MAC_SENDCTS;
 			len = sizeof(struct ieee80211_cts);
 		} else {
-			ieee80211_rts_get(dev->wl->hw, dev->wl->if_id,
-					  fragment_data, fragment_len, txctl,
+			ieee80211_rts_get(dev->wl->hw, fragment_data,
+					  fragment_len, txctl,
 					  (struct ieee80211_rts *)(txhdr->
 								   rts_frame));
 			mac_ctl |= B43_TX4_MAC_SENDRTS;
