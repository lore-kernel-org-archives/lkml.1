Return-Path: <linux-kernel-owner+w=401wt.eu-S1757480AbZAGNwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480AbZAGNwc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 08:52:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752454AbZAGNwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 08:52:22 -0500
Received: from smtp.wellnetcz.com ([212.24.148.102]:44613 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbZAGNwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 08:52:21 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: linville@tuxdriver.com, davem@davemloft.net,
       linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       Nick Kossifidis <mickflemm@gmail.com>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 1/1] ath5k: fix hw rate index condition
Date: Wed,  7 Jan 2009 14:51:22 +0100
Message-Id: <1231336282-22283-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <20090106170740.GD11588@linux.vnet.ibm.com>
References: <20090106170740.GD11588@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dhaval Giani wrote:
> I see this on current git. Not sure how to reproduce it, has happened on
> two random occasions. At both times, I was not connected to a wireless
> network, but to wired networks.
> 
> ------------[ cut here ]------------
> WARNING: at net/mac80211/rx.c:2234 __ieee80211_rx+0x7f/0x559
> ...
> Call Trace:
>  [<f80d4192>] __ieee80211_rx+0x7f/0x559 [mac80211]
>  [<f80a19f4>] ath5k_tasklet_rx+0x4f7/0x53b [ath5k]
> ...

Hmm, maybe ath5k is culprit. Could you apply the attached patch and
use the kernel till the problem appears again?

--

Make sure we print out a warning when the index is out of bounds,
i.e. even on hw_rix == AR5K_MAX_RATES.

Also change to WARN and print text with the reported hw_rix.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>
Cc: Luis R. Rodriguez <lrodriguez@atheros.com>
Cc: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath5k/base.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 4af2607..0e65e25 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -1088,7 +1088,8 @@ ath5k_mode_setup(struct ath5k_softc *sc)
 static inline int
 ath5k_hw_to_driver_rix(struct ath5k_softc *sc, int hw_rix)
 {
-	WARN_ON(hw_rix < 0 || hw_rix > AR5K_MAX_RATES);
+	WARN(hw_rix < 0 || hw_rix >= AR5K_MAX_RATES,
+			"hw_rix out of bounds: %x\n", hw_rix);
 	return sc->rate_idx[sc->curband->band][hw_rix];
 }
 
-- 
1.6.0.6

