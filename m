Return-Path: <linux-kernel-owner+w=401wt.eu-S1764287AbZGABH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764287AbZGABH7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 21:07:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761526AbZGAAfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:35:22 -0400
Received: from kroah.org ([198.145.64.141]:60549 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761519AbZGAAfP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:35:15 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:36 2009
Message-Id: <20090701002436.136350710@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:24:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Sujith <Sujith.Manoharan@atheros.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 073/108] ath9k: Initialize ANI timers
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=ath9k-initialize-ani-timers.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sujith <Sujith.Manoharan@atheros.com>

commit 415f738ecf41b427921b503ecfd427e26f89dc23 upstream.

The various ANI timers have to be initialized properly when
starting the calibration timer.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath9k/main.c |   24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -408,6 +408,18 @@ set_timer:
 	mod_timer(&sc->ani.timer, jiffies + msecs_to_jiffies(cal_interval));
 }
 
+static void ath_start_ani(struct ath_softc *sc)
+{
+	unsigned long timestamp = jiffies_to_msecs(jiffies);
+
+	sc->ani.longcal_timer = timestamp;
+	sc->ani.shortcal_timer = timestamp;
+	sc->ani.checkani_timer = timestamp;
+
+	mod_timer(&sc->ani.timer,
+		  jiffies + msecs_to_jiffies(ATH_ANI_POLLINTERVAL));
+}
+
 /*
  * Update tx/rx chainmask. For legacy association,
  * hard code chainmask to 1x1, for 11n association, use
@@ -920,9 +932,7 @@ static void ath9k_bss_assoc_info(struct 
 		sc->nodestats.ns_avgtxrssi = ATH_RSSI_DUMMY_MARKER;
 		sc->nodestats.ns_avgtxrate = ATH_RATE_DUMMY_MARKER;
 
-		/* Start ANI */
-		mod_timer(&sc->ani.timer,
-			  jiffies + msecs_to_jiffies(ATH_ANI_POLLINTERVAL));
+		ath_start_ani(sc);
 	} else {
 		DPRINTF(sc, ATH_DBG_CONFIG, "Bss Info DISSOC\n");
 		sc->curaid = 0;
@@ -2271,12 +2281,8 @@ static int ath9k_add_interface(struct ie
 
 	ath9k_hw_set_interrupts(sc->sc_ah, sc->imask);
 
-	if (conf->type == NL80211_IFTYPE_AP) {
-		/* TODO: is this a suitable place to start ANI for AP mode? */
-		/* Start ANI */
-		mod_timer(&sc->ani.timer,
-			  jiffies + msecs_to_jiffies(ATH_ANI_POLLINTERVAL));
-	}
+	if (conf->type == NL80211_IFTYPE_AP)
+		ath_start_ani(sc);
 
 out:
 	mutex_unlock(&sc->mutex);


