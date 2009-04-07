Return-Path: <linux-kernel-owner+w=401wt.eu-S1755037AbZDGCl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037AbZDGCl1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 22:41:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752648AbZDGClS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 22:41:18 -0400
Received: from mail.deathmatch.net ([72.66.92.28]:4069 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172AbZDGClR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 22:41:17 -0400
Date: Mon, 6 Apr 2009 22:40:21 -0400
From: Bob Copeland <me@bobcopeland.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Sergey S. Kostyliov" <rathamahata@gmail.com>,
       johannes@sipsolutions.net
Subject: Re: [Bug #12490] ath5k related kernel panic in 2.6.29-rc1
Message-ID: <20090407024021.GA26739@hash.localnet>
References: <n4io5wq70ZO.A.gzG.rFn2JB@chimera> <AsKNxFx2juN.A.GaD.UJn2JB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AsKNxFx2juN.A.GaD.UJn2JB@chimera>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 06, 2009 at 08:55:05PM +0200, Rafael J. Wysocki wrote:
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12490
> Subject		: ath5k related kernel panic in 2.6.29-rc1
> Submitter	: "Sergey S. Kostyliov" <rathamahata@gmail.com>
> Date		: 2009-01-12 7:38 (85 days old)
> References	: http://marc.info/?l=linux-kernel&m=123174591509586&w=4
> Handled-By	: Bob Copeland <me@bobcopeland.com>

I must admit I still don't have an idea of the root cause on this
one.  It still looks like some kind of memory corruption to me, 
but no smoking gun so far.  The one patch in 2.6.30 that might have 
fixed it in the driver didn't help.

Anyway here's a patch to buy some time.  Johannes, would this be
an acceptable band-aid for now?

Sergey, can you test this patch?  It doesn't fix anything but hopefully
makes your system survive the bug.  I gave it a quick test by forcing
one of the rate indexes to a bad value.

From: Bob Copeland <me@bobcopeland.com>
Date: Mon, 6 Apr 2009 22:04:09 -0400
Subject: [PATCH] mac80211: be more resilient in the face of bad rate indexes

If for whatever reason the rate tables contain invalid rates,
ieee80211_get_tx_rate will warn and return NULL, causing some
drivers to crash.  Those that don't will subsequently hit a
BUG_ON() in rate.c.  Instead, return a valid rate structure from
ieee80211_get_tx_rate() and only WARN() in rate_control_get_rate().

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 include/net/mac80211.h |   12 +++++++++---
 net/mac80211/rate.c    |    2 +-
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 3b83a80..4a74f40 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1014,13 +1014,19 @@ static inline void SET_IEEE80211_PERM_ADDR(struct ieee80211_hw *hw, u8 *addr)
 	memcpy(hw->wiphy->perm_addr, addr, ETH_ALEN);
 }
 
+static inline s8
+rate_lowest_index(struct ieee80211_supported_band *sband,
+		  struct ieee80211_sta *sta);
+
 static inline struct ieee80211_rate *
 ieee80211_get_tx_rate(const struct ieee80211_hw *hw,
 		      const struct ieee80211_tx_info *c)
 {
-	if (WARN_ON(c->control.rates[0].idx < 0))
-		return NULL;
-	return &hw->wiphy->bands[c->band]->bitrates[c->control.rates[0].idx];
+	s8 idx = c->control.rates[0].idx;
+	if (WARN_ON(idx < 0))
+		idx = rate_lowest_index(hw->wiphy->bands[c->band],
+					c->control.sta);
+	return &hw->wiphy->bands[c->band]->bitrates[idx];
 }
 
 static inline struct ieee80211_rate *
diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 4641f00..d8a5d46 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -238,7 +238,7 @@ void rate_control_get_rate(struct ieee80211_sub_if_data *sdata,
 				      sdata->max_ratectrl_rateidx);
 	}
 
-	BUG_ON(info->control.rates[0].idx < 0);
+	WARN_ON(info->control.rates[0].idx < 0);
 }
 
 struct rate_control_ref *rate_control_get(struct rate_control_ref *ref)
-- 
1.6.0.6




-- 
Bob Copeland %% www.bobcopeland.com

