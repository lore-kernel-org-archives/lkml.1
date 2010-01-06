Return-Path: <linux-kernel-owner+w=401wt.eu-S932294Ab0AFQf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932294Ab0AFQf6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 11:35:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755875Ab0AFQfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 11:35:47 -0500
Received: from smtp.mujha-vel.cz ([81.30.225.246]:51473 "EHLO
	smtp.mujha-vel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755672Ab0AFQfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 11:35:46 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] NET: wireless, fix memory leak
Date: Wed,  6 Jan 2010 17:35:43 +0100
Message-Id: <1262795743-15009-2-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.5.7
In-Reply-To: <1262795743-15009-1-git-send-email-jslaby@suse.cz>
References: <1262795743-15009-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanse found a memory leak in cfg80211_wext_siwscan. creq is not
freed/assigned on all paths. Fix that.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/wireless/scan.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 9c50c85..3003d13 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -685,7 +685,7 @@ int cfg80211_wext_siwscan(struct net_device *dev,
 	/* No channels found? */
 	if (!i) {
 		err = -EINVAL;
-		goto out;
+		goto out_free;
 	}
 
 	/* Set real number of channels specified in creq->channels[] */
@@ -696,7 +696,7 @@ int cfg80211_wext_siwscan(struct net_device *dev,
 		if (wrqu->data.flags & IW_SCAN_THIS_ESSID) {
 			if (wreq->essid_len > IEEE80211_MAX_SSID_LEN) {
 				err = -EINVAL;
-				goto out;
+				goto out_free;
 			}
 			memcpy(creq->ssids[0].ssid, wreq->essid, wreq->essid_len);
 			creq->ssids[0].ssid_len = wreq->essid_len;
@@ -717,6 +717,9 @@ int cfg80211_wext_siwscan(struct net_device *dev,
  out:
 	cfg80211_unlock_rdev(rdev);
 	return err;
+out_free:
+	kfree(creq);
+	goto out;
 }
 EXPORT_SYMBOL_GPL(cfg80211_wext_siwscan);
 
-- 
1.6.5.7

