Return-Path: <linux-kernel-owner+w=401wt.eu-S1753893AbXLCTT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893AbXLCTT7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 14:19:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751780AbXLCTTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 14:19:53 -0500
Received: from mu-out-0910.google.com ([209.85.134.191]:53174 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725AbXLCTTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 14:19:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Np2R35jGgr186SfwXc5OcF2Z4eWeo/KAULRNjQMMnOcr2rwJbxCou72CUWKOlLYp2jWxBvBnhLYQDUkVp88TEJYMD3kTWVUUNDB8qF7EqAXPWJByEW5MufUtLg8hrlJQ4aYC77JZO4EkJwzrUpPSLY2n5vvMMQTyKI+iUc2vRDw=
Date: Mon, 3 Dec 2007 22:19:41 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Thomas Tuttle <linux-kernel@ttuttle.net>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Oops with 2.6.24 git when loading iwl3945
Message-ID: <20071203191941.GB7328@cvg>
References: <1196196237.19410.1223544787@webmail.messagingengine.com> <20071202164316.GB7377@cvg> <1196617561.16481.1224371239@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1196617561.16481.1224371239@webmail.messagingengine.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Thomas Tuttle - Sun, Dec 02, 2007 at 12:46:01PM -0500]
| On Sun, 2 Dec 2007 19:43:16 +0300, "Cyrill Gorcunov"
| <gorcunov@gmail.com> said:
| > [Thomas Tuttle - Tue, Nov 27, 2007 at 03:43:57PM -0500]
| > | Hey.
| > | 
| > | I'm using a git snapshot that gentoo distributed mere hours ago (so I'm
| > | fairly confident it's current), and I'm getting an Oops when I try to
| > | load the iwl3945 driver.  I've attached it as plain text.
| > | 
| > | Hope this helps,
| > | 
| > | Thomas Tuttle
| > 
| > Hi Thomas,
| > Could you please test the patch?
| 
| It didn't help.  The original oops says the problem was in strcmp.  It
| was a GPF, which suggests to me that one of the arguments is NULL. 
| Since ops->name is checked at the beginning of the function, the only
| other possibility is that alg->ops->name is NULL.  I added a bit of code
| to check for this, and it turns out that one of the strings was indeed
| NULL.  I didn't know where to go from there in debugging, but I hope it
| helps.
| 
| Thanks,
| 
| Thomas Tuttle
|

Hi Thomas,

could you please try that one ;)
Ayway as my previous patch and this one have to be applied anyway (regardless
the OOPs you catched). So I've sent previous patch to list and this one too,
but that is more important for - does these (both) patch helped. Thanks a lot
for patience (i know the problem is in strcmp but it seems that is a side issue -
main problems seems to be in sych. events)

		Cyrill
---

From: Cyrill Gorcunov <gorcunov@gmail.com>
Date: Mon, 3 Dec 2007 22:12:30 +0300
Subject: [PATCH] [PATCH] NET: mac80211 - fix inappropriate memory freeing

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

