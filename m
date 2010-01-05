Return-Path: <linux-kernel-owner+w=401wt.eu-S1754357Ab0AEAf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357Ab0AEAf2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:35:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754329Ab0AEAfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:35:21 -0500
Received: from kroah.org ([198.145.64.141]:34325 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754203Ab0AEAfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:35:17 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Sujith <Sujith.Manoharan@atheros.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Luis Rodriguez <lrodriguez@atheros.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 43/97] mac80211: Fix IBSS merge
Date: Mon,  4 Jan 2010 16:32:56 -0800
Message-Id: <1262651630-7354-43-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sujith <Sujith.Manoharan@atheros.com>

commit 450aae3d7b60a970f266349a837dfb30a539198b upstream.

Currently, in IBSS mode, a single creator would go into
a loop trying to merge/scan. This happens because the IBSS timer is
rearmed on finishing a scan and the subsequent
timer invocation requests another scan immediately.

This patch fixes this issue by checking if we have just completed
a scan run trying to merge with other IBSS networks.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Cc: Luis Rodriguez <lrodriguez@atheros.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/mac80211/ibss.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index f1362f3..fbffce9 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -455,6 +455,10 @@ static void ieee80211_sta_merge_ibss(struct ieee80211_sub_if_data *sdata)
 
 	ieee80211_sta_expire(sdata, IEEE80211_IBSS_INACTIVITY_LIMIT);
 
+	if (time_before(jiffies, ifibss->last_scan_completed +
+		       IEEE80211_IBSS_MERGE_INTERVAL))
+		return;
+
 	if (ieee80211_sta_active_ibss(sdata))
 		return;
 
-- 
1.6.6

