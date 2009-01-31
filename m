Return-Path: <linux-kernel-owner+w=401wt.eu-S1760615AbZAaC7E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760615AbZAaC7E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 21:59:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756483AbZAaCrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 21:47:13 -0500
Received: from kroah.org ([198.145.64.141]:55119 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756073AbZAaCrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 21:47:07 -0500
Date: Fri, 30 Jan 2009 18:42:14 -0800
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
       alan@lxorguk.ukuu.org.uk, Andrey Yurovsky <andrey@cozybit.com>,
       Nick Kossifidis <mickflemm@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Bob Copeland <me@bobcopeland.com>
Subject: [patch 01/43] ath5k: fix mesh point operation
Message-ID: <20090131024214.GB12368@kroah.com>
References: <20090131022548.656772939@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ath5k-fix-mesh-point-operation.patch"
In-Reply-To: <20090131024158.GA12368@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andrey Yurovsky <andrey@cozybit.com>

commit b706e65b40417e03c2451bb3f92488f3736843fa upstream.

This patch fixes mesh point operation (thanks to YanBo for pointing
out the problem): make mesh point interfaces start beaconing when
they come up and configure the RX filter in mesh mode so that mesh
beacons and action frames are received.  Add mesh point to the check
in ath5k_add_interface.  Tested with multiple AR5211 cards.

Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>
Acked-by: Nick Kossifidis <mickflemm@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Cc: Bob Copeland <me@bobcopeland.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath5k/base.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -2157,7 +2157,8 @@ ath5k_beacon_config(struct ath5k_softc *
 
 	if (sc->opmode == NL80211_IFTYPE_STATION) {
 		sc->imask |= AR5K_INT_BMISS;
-	} else if (sc->opmode == NL80211_IFTYPE_ADHOC) {
+	} else if (sc->opmode == NL80211_IFTYPE_ADHOC ||
+		   sc->opmode == NL80211_IFTYPE_MESH_POINT) {
 		/*
 		 * In IBSS mode we use a self-linked tx descriptor and let the
 		 * hardware send the beacons automatically. We have to load it
@@ -2748,6 +2749,7 @@ static int ath5k_add_interface(struct ie
 	switch (conf->type) {
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_ADHOC:
+	case NL80211_IFTYPE_MESH_POINT:
 	case NL80211_IFTYPE_MONITOR:
 		sc->opmode = conf->type;
 		break;
@@ -2819,7 +2821,8 @@ ath5k_config_interface(struct ieee80211_
 	}
 
 	if (conf->changed & IEEE80211_IFCC_BEACON &&
-	    vif->type == NL80211_IFTYPE_ADHOC) {
+	    (vif->type == NL80211_IFTYPE_ADHOC ||
+	     vif->type == NL80211_IFTYPE_MESH_POINT)) {
 		struct sk_buff *beacon = ieee80211_beacon_get(hw, vif);
 		if (!beacon) {
 			ret = -ENOMEM;
@@ -2951,6 +2954,9 @@ static void ath5k_configure_filter(struc
 		sc->opmode == NL80211_IFTYPE_ADHOC) {
 		rfilt |= AR5K_RX_FILTER_BEACON;
 	}
+	if (sc->opmode == NL80211_IFTYPE_MESH_POINT)
+		rfilt |= AR5K_RX_FILTER_CONTROL | AR5K_RX_FILTER_BEACON |
+			AR5K_RX_FILTER_PROBEREQ | AR5K_RX_FILTER_PROM;
 
 	/* Set filters */
 	ath5k_hw_set_rx_filter(ah,rfilt);

