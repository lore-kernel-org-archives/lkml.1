Return-Path: <linux-kernel-owner+w=401wt.eu-S1755698AbZCCDrB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698AbZCCDrB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 22:47:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751777AbZCCDqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 22:46:50 -0500
Received: from mail.deathmatch.net ([70.167.247.36]:4681 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbZCCDqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 22:46:49 -0500
Date: Mon, 2 Mar 2009 22:46:00 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Pavel Roskin <proski@gnu.org>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Jiri Slaby <jirislaby@gmail.com>,
       "ath5k-devel@venema.h4ckr.net" <ath5k-devel@venema.h4ckr.net>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>, mickflemm@gmail.com
Subject: Re: [ath5k-devel] [PATCH 1/1] ath5k: fix hw rate index condition
Message-ID: <20090303034600.GA3757@hash.localnet>
References: <1235688271-22346-1-git-send-email-jirislaby@gmail.com> <20090226230338.M86894@bobcopeland.com> <49A7236E.2020807@gmail.com> <b6c5339f0902261528i7b581125k29927c3c5ac4fe4c@mail.gmail.com> <49A726A7.6090809@gmail.com> <20090227022704.GA29850@hash.localnet> <20090227023912.GF13456@tesla> <20090227030608.GA29974@hash.localnet> <1235884912.9224.26.camel@mj>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235884912.9224.26.camel@mj>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 01, 2009 at 12:21:52AM -0500, Pavel Roskin wrote:
> I would prefer that we don't hide problems.
> 
> If we don't know why we cannot get a valid rate, we should use WARN_ON
> and find out why and when it happens.  I'm fine with using a bogus rate
> with WARN_ON.

So here is at least stage one of this, not yet the global "unknown rate"
infrastructure, but hopefully it will allow us to track down the issue.

It makes hw_to_driver_rix a little uglier, but oh well.  Thoughts?

From: Bob Copeland <me@bobcopeland.com>
Date: Mon, 2 Mar 2009 21:55:18 -0500
Subject: [PATCH] ath5k: warn and correct rate for unknown hw rate indexes

ath5k sets up a mapping table from the hardware rate index to
the rate index used by mac80211; however, we have seen some
received frames with incorrect rate indexes.  Such frames
normally get dropped with a warning in __ieee80211_rx(), but the 
warning doesn't include enough context to track down the error.

This patch adds a warning to hw_to_driver_rix for any lookups
that result in a rate index of -1, then returns a valid rate so
the frame can be processed.

This also includes the bug fix suggested by Pavel Roskin, in which
the mapping table is made signed, so rates initialized to -1 stay
that way.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath5k/base.c |   15 ++++++++++++---
 drivers/net/wireless/ath5k/base.h |    2 +-
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index f7c424d..8d4b11c 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -1100,9 +1100,18 @@ ath5k_mode_setup(struct ath5k_softc *sc)
 static inline int
 ath5k_hw_to_driver_rix(struct ath5k_softc *sc, int hw_rix)
 {
-	WARN(hw_rix < 0 || hw_rix >= AR5K_MAX_RATES,
-			"hw_rix out of bounds: %x\n", hw_rix);
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
diff --git a/drivers/net/wireless/ath5k/base.h b/drivers/net/wireless/ath5k/base.h
index 20e0d14..8229561 100644
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
 
-- 
1.6.0.6



-- 
Bob Copeland %% www.bobcopeland.com

