Return-Path: <linux-kernel-owner+w=401wt.eu-S1755075Ab0AEArp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075Ab0AEArp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:47:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932069Ab0AEArj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:47:39 -0500
Received: from kroah.org ([198.145.64.141]:34316 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754321Ab0AEAfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:35:16 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 42/97] mac80211: fix WMM AP settings application
Date: Mon,  4 Jan 2010 16:32:55 -0800
Message-Id: <1262651630-7354-42-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>

commit 0183826b58a2712ffe608bc3302447be3e6a3ab8 upstream.

My
  commit 77fdaa12cea26c204cc12c312fe40bc0f3dcdfd8
  Author: Johannes Berg <johannes@sipsolutions.net>
  Date:   Tue Jul 7 03:45:17 2009 +0200

      mac80211: rework MLME for multiple authentications

inadvertedly broke WMM because it removed, along with
a bunch of other now useless initialisations, the line
initialising sdata->u.mgd.wmm_last_param_set to -1
which would make it adopt any WMM parameter set. If,
as is usually the case, the AP uses WMM parameter set
sequence number zero, we'd never update it until the
AP changes the sequence number.

Add the missing initialisation back to get the WMM
settings from the AP applied locally.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/mac80211/mlme.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index dc5049d..f13d181 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -904,6 +904,14 @@ static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
 	sdata->u.mgd.flags &= ~(IEEE80211_STA_CONNECTION_POLL |
 				IEEE80211_STA_BEACON_POLL);
 
+	/*
+	 * Always handle WMM once after association regardless
+	 * of the first value the AP uses. Setting -1 here has
+	 * that effect because the AP values is an unsigned
+	 * 4-bit value.
+	 */
+	sdata->u.mgd.wmm_last_param_set = -1;
+
 	ieee80211_led_assoc(local, 1);
 
 	sdata->vif.bss_conf.assoc = 1;
-- 
1.6.6

