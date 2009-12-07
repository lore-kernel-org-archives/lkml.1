Return-Path: <linux-kernel-owner+w=401wt.eu-S934406AbZLGA0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934406AbZLGA0e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:26:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758512AbZLGANR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:13:17 -0500
Received: from kroah.org ([198.145.64.141]:34442 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758359AbZLGANN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:13:13 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:50 2009
Message-Id: <20091207000649.895216946@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:00:31 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Lennert Buytenhek <buytenh@marvell.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [055/119] mac80211: fix two remote exploits
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=mac80211-fix-two-remote-exploits.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Johannes Berg <johannes@sipsolutions.net>

commit 4253119acf412fd686ef4bd8749b5a4d70ea3a51 upstream.

Lennert Buytenhek noticed a remotely triggerable problem
in mac80211, which is due to some code shuffling I did
that ended up changing the order in which things were
done -- this was in

  commit d75636ef9c1af224f1097941879d5a8db7cd04e5
  Author: Johannes Berg <johannes@sipsolutions.net>
  Date:   Tue Feb 10 21:25:53 2009 +0100

    mac80211: RX aggregation: clean up stop session

The problem is that the BUG_ON moved before the various
checks, and as such can be triggered.

As the comment indicates, the BUG_ON can be removed since
the ampdu_action callback must already exist when the
state is OPERATIONAL.

A similar code path leads to a WARN_ON in
ieee80211_stop_tx_ba_session, which can also be removed.

Cc: Lennert Buytenhek <buytenh@marvell.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/agg-rx.c |    4 ----
 net/mac80211/agg-tx.c |    2 +-
 2 files changed, 1 insertion(+), 5 deletions(-)

--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -85,10 +85,6 @@ void ieee80211_sta_stop_rx_ba_session(st
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
 
-	/* stop HW Rx aggregation. ampdu_action existence
-	 * already verified in session init so we add the BUG_ON */
-	BUG_ON(!local->ops->ampdu_action);
-
 	rcu_read_lock();
 
 	sta = sta_info_get(local, ra);
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -546,7 +546,7 @@ int ieee80211_stop_tx_ba_session(struct 
 	struct sta_info *sta;
 	int ret = 0;
 
-	if (WARN_ON(!local->ops->ampdu_action))
+	if (!local->ops->ampdu_action)
 		return -EINVAL;
 
 	if (tid >= STA_TID_NUM)


