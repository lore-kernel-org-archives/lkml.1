Return-Path: <linux-kernel-owner+w=401wt.eu-S1752938AbZJAV1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938AbZJAV1u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 17:27:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752861AbZJAV1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 17:27:49 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:46283 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827AbZJAV1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 17:27:49 -0400
Subject: Re: 2.6.32-rc0-git: oops in wireless, iwl3945 related?
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, yi.zhu@intel.com, reinette.chatre@intel.com,
       linux-wireless@vger.kernel.org
In-Reply-To: <1254431783.3959.45.camel@johannes.local>
References: <20090929171249.GB14405@elf.ucw.cz>
	 <1254431783.3959.45.camel@johannes.local>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Oct 2009 23:27:49 +0200
Message-Id: <1254432469.3959.46.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-01 at 23:16 +0200, Johannes Berg wrote:

> > wlan0: Selected IBSS BSSID 02:18:41:de:3f:02 based on configured SSID
> > wlan0: Trigger new scan to find an IBSS to join
> > wlan0: Trigger new scan to find an IBSS to join
> > wlan0: Creating new IBSS network, BSSID f2:d3:80:82:ed:6a
> > wlan0: Creating new IBSS network, BSSID 52:17:bf:45:d6:9d
> > skb_over_panic: text:c07b4113 len:130 put:36 head:e4c3edf0
> 
> This entire log is very odd ... can you reproduce this easily? printk
> timestamps would be useful.

Kinda looks like a race condition, but it's rather odd. I think there's
a race condition, so I'm going to submit this patch regardless after
some testing, but if you want please try the patch below.

johannes

---
 net/mac80211/ibss.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- wireless-testing.orig/net/mac80211/ibss.c	2009-10-01 23:21:11.000000000 +0200
+++ wireless-testing/net/mac80211/ibss.c	2009-10-01 23:22:24.000000000 +0200
@@ -831,7 +831,7 @@ void ieee80211_ibss_notify_scan_complete
 		if (!sdata->u.ibss.ssid_len)
 			continue;
 		sdata->u.ibss.last_scan_completed = jiffies;
-		ieee80211_sta_find_ibss(sdata);
+		mod_timer(&ifibss->timer, 0);
 	}
 	mutex_unlock(&local->iflist_mtx);
 }


