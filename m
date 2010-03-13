Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935086Ab0CMAVU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:21:20 -0500
Received: from kroah.org ([198.145.64.141]:60897 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934841Ab0CMAU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:20:27 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:11 2010
Message-Id: <20100313001511.371477157@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:12:49 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Felix Fietkau <nbd@openwrt.org>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 071/123] ath9k: fix beacon timer restart after a card reset
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Felix Fietkau <nbd@openwrt.org>

commit d8728ee919282c7b01b65cd479ec1e2a9c5d3ba8 upstream.

In AP mode, ath_beacon_config_ap only restarts the timer if a TSF
restart is requested. Apparently this was added, because this function
unconditionally sets the flag for TSF reset.

The problem with this is, that ath9k_hw_reset() clobbers the timer
registers (specified in the initvals), thus effectively disabling the
SWBA interrupt whenever a card reset without TSF reset is issued
(happens in a few places in the code).

This patch fixes ath_beacon_config_ap to only issue the TSF reset flag
when necessary, but reinitialize the timer unconditionally. Tests show,
that this is enough to keep the SWBA interrupt going after a call to
ath_reset()

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/beacon.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -525,16 +525,13 @@ static void ath_beacon_config_ap(struct
 {
 	u32 nexttbtt, intval;
 
-	/* Configure the timers only when the TSF has to be reset */
-
-	if (!(sc->sc_flags & SC_OP_TSF_RESET))
-		return;
-
 	/* NB: the beacon interval is kept internally in TU's */
 	intval = conf->beacon_interval & ATH9K_BEACON_PERIOD;
 	intval /= ATH_BCBUF;    /* for staggered beacons */
 	nexttbtt = intval;
-	intval |= ATH9K_BEACON_RESET_TSF;
+
+	if (sc->sc_flags & SC_OP_TSF_RESET)
+		intval |= ATH9K_BEACON_RESET_TSF;
 
 	/*
 	 * In AP mode we enable the beacon timers and SWBA interrupts to


