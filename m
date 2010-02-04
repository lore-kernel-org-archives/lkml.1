Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933408Ab0BDRYw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:24:52 -0500
Received: from kroah.org ([198.145.64.141]:35000 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933388Ab0BDRWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:22:35 -0500
X-Mailbox-Line: From linux@linux.site Thu Feb  4 09:15:29 2010
Message-Id: <20100204171529.452810643@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 04 Feb 2010 09:12:44 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Felix Fietkau <nbd@openwrt.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [73/74] ath9k: fix beacon slot/buffer leak
In-Reply-To: <20100204171850.GA16539@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 74401773f80b6d42f7a4c6994ca0cca883b03745 upstream.

When cleaning up beacon buffers and slots, ath9k currently checks if
sc->ah->opmode is set to a beacon related mode before cleaning up
buffers.
An unfortunate ordering of interface up/down commands can lead to
sc->ah->opmode being set to monitor mode, while there are AP interfaces
present on the same wiphy.
Always cleaning up beacon buffers if present fixes this issue.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2285,10 +2285,10 @@ static void ath9k_remove_interface(struc
 	    (sc->sc_ah->opmode == NL80211_IFTYPE_MESH_POINT)) {
 		ath9k_ps_wakeup(sc);
 		ath9k_hw_stoptxdma(sc->sc_ah, sc->beacon.beaconq);
-		ath_beacon_return(sc, avp);
 		ath9k_ps_restore(sc);
 	}
 
+	ath_beacon_return(sc, avp);
 	sc->sc_flags &= ~SC_OP_BEACONS;
 
 	for (i = 0; i < ARRAY_SIZE(sc->beacon.bslot); i++) {


