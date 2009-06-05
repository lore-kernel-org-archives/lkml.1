Return-Path: <linux-kernel-owner+w=401wt.eu-S1753994AbZFEMXB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbZFEMXB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 08:23:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751343AbZFEMWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 08:22:52 -0400
Received: from mail.deathmatch.net ([72.66.92.28]:2294 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbZFEMWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 08:22:51 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       nbd@openwrt.org, rathamahata@gmail.com, ognjen.maric@gmail.com,
       rjw@sisk.pl, Bob Copeland <me@bobcopeland.com>, stable@kernel.org
Subject: [PATCH] mac80211: fix minstrel single-rate memory corruption
Date: Fri,  5 Jun 2009 08:21:50 -0400
Message-Id: <1244204510-14007-1-git-send-email-me@bobcopeland.com>
X-Mailer: git-send-email 1.5.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The minstrel rate controller periodically looks up rate indexes in
a sampling table.  When accessing a specific row and column, minstrel
correctly does a bounds check which, on the surface, appears to handle
the case where mi->n_rates < 2.  However, mi->sample_idx is actually
defined as an unsigned, so the right hand side is taken to be a huge
positive number when negative, and the check will always fail.

Consequently, the RC will overrun the array and cause random memory
corruption when communicating with a peer that has only a single rate.
The max value of mi->sample_idx is around 25 so casting to int should
have no ill effects.

Without the change, uptime is a few minutes under load with an AP
that has a single hard-coded rate, and both the AP and STA could
potentially crash.  With the change, both lasted 12 hours with a
steady load.

Thanks to Ognjen Maric for providing the single-rate clue so I could
reproduce this.

This fixes http://bugzilla.kernel.org/show_bug.cgi?id=12490 on the
regression list (also http://bugzilla.kernel.org/show_bug.cgi?id=13000).

Cc: stable@kernel.org
Reported-by: Sergey S. Kostyliov <rathamahata@gmail.com>
Reported-by: Ognjen Maric <ognjen.maric@gmail.com>
Signed-off-by: Bob Copeland <me@bobcopeland.com>
---

John & Felix, the patch itself may be too subtle so feel free to do it a
different way.  However this is as minimal as it gets so I hope it can
be applied quickly to stable, and mainline if not too late.

 net/mac80211/rc80211_minstrel.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
index d9233ec..2681dfa 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -216,7 +216,7 @@ minstrel_get_next_sample(struct minstrel_sta_info *mi)
 	unsigned int sample_ndx;
 	sample_ndx = SAMPLE_TBL(mi, mi->sample_idx, mi->sample_column);
 	mi->sample_idx++;
-	if (mi->sample_idx > (mi->n_rates - 2)) {
+	if ((int) mi->sample_idx > (mi->n_rates - 2)) {
 		mi->sample_idx = 0;
 		mi->sample_column++;
 		if (mi->sample_column >= SAMPLE_COLUMNS)
-- 
1.5.4.1


