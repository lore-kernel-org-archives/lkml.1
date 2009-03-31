Return-Path: <linux-kernel-owner+w=401wt.eu-S1764031AbZCaXah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764031AbZCaXah (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 19:30:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763520AbZCaXUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 19:20:55 -0400
Received: from sous-sol.org ([216.99.217.87]:33207 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763403AbZCaXUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 19:20:53 -0400
Message-Id: <20090331231523.458171337@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Tue, 31 Mar 2009 16:11:02 -0700
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
Subject: [patch 17/45] ath5k: use spin_lock_irqsave for beacon lock
References: <20090331231045.719396245@sous-sol.org>
Content-Disposition: inline; filename=ath5k-use-spin_lock_irqsave-for-beacon-lock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Bob Copeland <me@bobcopeland.com>

upstream commit: b5f03956c56d72ad336e5c2c42a025f25d952c30

ath5k_reset can be called from process context, which in turn can
call ath5k_beacon_config which takes the sc->block spinlock.  Since
it can also be taken in hard irq context, use spin_lock_irqsave
everywhere.  This fixes a potential deadlock in adhoc mode.

Changes-licensed-under: 3-Clause-BSD

Cc: stable@kernel.org
Signed-off-by: Bob Copeland <me@bobcopeland.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/net/wireless/ath5k/base.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -1668,7 +1668,6 @@ ath5k_check_ibss_tsf(struct ath5k_softc 
 	}
 }
 
-
 static void
 ath5k_tasklet_rx(unsigned long data)
 {
@@ -2188,6 +2187,7 @@ static void
 ath5k_beacon_config(struct ath5k_softc *sc)
 {
 	struct ath5k_hw *ah = sc->ah;
+	unsigned long flags;
 
 	ath5k_hw_set_imr(ah, 0);
 	sc->bmisscount = 0;
@@ -2211,9 +2211,9 @@ ath5k_beacon_config(struct ath5k_softc *
 
 		if (sc->opmode == NL80211_IFTYPE_ADHOC) {
 			if (ath5k_hw_hasveol(ah)) {
-				spin_lock(&sc->block);
+				spin_lock_irqsave(&sc->block, flags);
 				ath5k_beacon_send(sc);
-				spin_unlock(&sc->block);
+				spin_unlock_irqrestore(&sc->block, flags);
 			}
 		} else
 			ath5k_beacon_update_timers(sc, -1);

