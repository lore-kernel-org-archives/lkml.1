Return-Path: <linux-kernel-owner+w=401wt.eu-S1753506AbXLCTXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506AbXLCTXR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 14:23:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752326AbXLCTXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 14:23:04 -0500
Received: from mu-out-0910.google.com ([209.85.134.184]:56629 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbXLCTXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 14:23:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=O81n1mnewDB14YwiiJzNh7aJe/KcOmIDIfV92AGMInsiEiK1uDMBmjg9Pfzlu9HBffgp6Yka6cFpXKtQReiBjEO0LSGB7/CT1egxXR9kp8pwfPbYRKRFFGy1WzlBhDRa7iFH06zXH7epTTrVxYCEojsiEzC/HIL4FpuHpz8UOao=
Date: Mon, 3 Dec 2007 22:22:49 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Michael Wu <flamingice@sourmilk.net>
Cc: LKWL <linux-wireless@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] NET: mac80211 - fix inappropriate memory freeing
Message-ID: <20071203192249.GC7328@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch does fix inappropriate memory freeing in case
of requested rate_control_ops was not found. In this case
the list head entity is going to be accidently wasted.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---
 net/mac80211/ieee80211_rate.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/ieee80211_rate.c b/net/mac80211/ieee80211_rate.c
index 3260a4a..c3f2783 100644
--- a/net/mac80211/ieee80211_rate.c
+++ b/net/mac80211/ieee80211_rate.c
@@ -60,11 +60,11 @@ void ieee80211_rate_control_unregister(struct rate_control_ops *ops)
 	list_for_each_entry(alg, &rate_ctrl_algs, list) {
 		if (alg->ops == ops) {
 			list_del(&alg->list);
+			kfree(alg);
 			break;
 		}
 	}
 	mutex_unlock(&rate_ctrl_mutex);
-	kfree(alg);
 }
 EXPORT_SYMBOL(ieee80211_rate_control_unregister);
 
-- 
1.5.3.5

