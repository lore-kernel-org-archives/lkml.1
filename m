Return-Path: <linux-kernel-owner+w=401wt.eu-S1760189AbXHVJFD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760189AbXHVJFD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 05:05:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758741AbXHVIxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 04:53:39 -0400
Received: from 1wt.eu ([62.212.114.60]:2127 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756309AbXHVIxg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 04:53:36 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070822084040.%N@1wt.eu>
References: <20070822083844.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Wed, 22 Aug 2007 11:39:35 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Michael Buesch <mb@bu3sch.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       Willy Tarreau <w@1wt.eu>
Subject: [2.6.20.17 review 51/58] softmac: Fix deadlock of wx_set_essid with assoc work
Content-Disposition: inline; filename=0051-softmac-Fix-deadlock-of-wx_set_essid-with-assoc-wor.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The essid wireless extension does deadlock against the assoc mutex,
as we don't unlock the assoc mutex when flushing the workqueue, which
also holds the lock.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/ieee80211/softmac/ieee80211softmac_wx.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/net/ieee80211/softmac/ieee80211softmac_wx.c b/net/ieee80211/softmac/ieee80211softmac_wx.c
index fb58e03..c3c39ed 100644
--- a/net/ieee80211/softmac/ieee80211softmac_wx.c
+++ b/net/ieee80211/softmac/ieee80211softmac_wx.c
@@ -74,8 +74,8 @@ ieee80211softmac_wx_set_essid(struct net_device *net_dev,
 	struct ieee80211softmac_auth_queue_item *authptr;
 	int length = 0;
 
+check_assoc_again:
 	mutex_lock(&sm->associnfo.mutex);
-
 	/* Check if we're already associating to this or another network
 	 * If it's another network, cancel and start over with our new network
 	 * If it's our network, ignore the change, we're already doing it!
@@ -98,13 +98,18 @@ ieee80211softmac_wx_set_essid(struct net_device *net_dev,
 				cancel_delayed_work(&authptr->work);
 			sm->associnfo.bssvalid = 0;
 			sm->associnfo.bssfixed = 0;
-			flush_scheduled_work();
 			sm->associnfo.associating = 0;
 			sm->associnfo.associated = 0;
+			/* We must unlock to avoid deadlocks with the assoc workqueue
+			 * on the associnfo.mutex */
+			mutex_unlock(&sm->associnfo.mutex);
+			flush_scheduled_work();
+			/* Avoid race! Check assoc status again. Maybe someone started an
+			 * association while we flushed. */
+			goto check_assoc_again;
 		}
 	}
 
-
 	sm->associnfo.static_essid = 0;
 	sm->associnfo.assoc_wait = 0;
 
-- 
1.5.2.5

-- 
