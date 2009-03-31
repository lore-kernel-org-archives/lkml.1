Return-Path: <linux-kernel-owner+w=401wt.eu-S1764826AbZCaXbH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764826AbZCaXbH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 19:31:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763662AbZCaXVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 19:21:05 -0400
Received: from sous-sol.org ([216.99.217.87]:33219 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763793AbZCaXVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 19:21:03 -0400
Message-Id: <20090331231547.410331303@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Tue, 31 Mar 2009 16:11:06 -0700
From: Chris Wright <chrisw@sous-sol.org>
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
       alan@lxorguk.ukuu.org.uk, Bob Copeland <me@bobcopeland.com>,
       John W Linville <linville@tuxdriver.com>
Subject: [patch 21/45] ath5k: warn and correct rate for unknown hw rate indexes
References: <20090331231045.719396245@sous-sol.org>
Content-Disposition: inline; filename=ath5k-warn-and-correct-rate-for-unknown-hw-rate-indexes.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Bob Copeland <me@bobcopeland.com>

upstream commit: b726604706ad88d8b28bc487e45e710f58cc19ee

ath5k sets up a mapping table from the hardware rate index to
the rate index used by mac80211; however, we have seen some
received frames with incorrect rate indexes.  Such frames
normally get dropped with a warning in __ieee80211_rx(),
but it doesn't include enough information to track down the
error.

This patch adds a warning to hw_to_driver_rix for any lookups
that result in a rate index of -1, then returns a valid rate so
the frame can be processed.

Changes-licensed-under: 3-Clause-BSD

Signed-off-by: Bob Copeland <me@bobcopeland.com>
Cc: stable@kernel.org
Signed-off-by: John W. Linville <linville@tuxdriver.com>
[chrisw: add db5b4f7ae3901fdc48c5b988fc2a5e0cb4ec1870 to backport]
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/net/wireless/ath5k/base.c |   14 ++++++++++++--
 drivers/net/wireless/ath5k/base.h |    2 +-
 2 files changed, 13 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -1090,8 +1090,18 @@ ath5k_mode_setup(struct ath5k_softc *sc)
 static inline int
 ath5k_hw_to_driver_rix(struct ath5k_softc *sc, int hw_rix)
 {
-	WARN_ON(hw_rix < 0 || hw_rix > AR5K_MAX_RATES);
-	return sc->rate_idx[sc->curband->band][hw_rix];
+	int rix;
+
+	/* return base rate on errors */
+	if (WARN(hw_rix < 0 || hw_rix >= AR5K_MAX_RATES,
+			"hw_rix out of bounds: %x\n", hw_rix))
+		return 0;
+
+	rix = sc->rate_idx[sc->curband->band][hw_rix];
+	if (WARN(rix < 0, "invalid hw_rix: %x\n", hw_rix))
+		rix = 0;
+
+	return rix;
 }
 
 /***************\
--- a/drivers/net/wireless/ath5k/base.h
+++ b/drivers/net/wireless/ath5k/base.h
@@ -112,7 +112,7 @@ struct ath5k_softc {
 	struct ieee80211_supported_band sbands[IEEE80211_NUM_BANDS];
 	struct ieee80211_channel channels[ATH_CHAN_MAX];
 	struct ieee80211_rate	rates[IEEE80211_NUM_BANDS][AR5K_MAX_RATES];
-	u8			rate_idx[IEEE80211_NUM_BANDS][AR5K_MAX_RATES];
+	s8			rate_idx[IEEE80211_NUM_BANDS][AR5K_MAX_RATES];
 	enum nl80211_iftype	opmode;
 	struct ath5k_hw		*ah;		/* Atheros HW */
 

