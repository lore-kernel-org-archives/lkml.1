Return-Path: <linux-kernel-owner+w=401wt.eu-S1756940AbZJPRTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756940AbZJPRTa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 13:19:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755950AbZJPRT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 13:19:27 -0400
Received: from kroah.org ([198.145.64.141]:48696 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756009AbZJPRSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 13:18:48 -0400
X-Mailbox-Line: From linux@linux.site Fri Oct 16 10:12:10 2009
Message-Id: <20091016171210.469831545@linux.site>
User-Agent: quilt/0.47-14.9
Date: Fri, 16 Oct 2009 10:10:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [45/46] mac80211: fix vlan and optimise RX
References: <20091016170953.128828149@linux.site>
Content-Disposition: inline; filename=mac80211-fix-vlan-and-optimise-rx.patch
In-Reply-To: <20091016171422.GA13339@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Johannes Berg <johannes@sipsolutions.net>

commit fbc44bf7177dfd61381da55405550b693943a432 upstream.

When receiving data frames, we can send them only to
the interface they belong to based on transmitting
station (this doesn't work for probe requests). Also,
don't try to handle other frames for AP_VLAN at all
since those interface should only receive data.

Additionally, the transmit side must check that the
station we're sending a frame to is actually on the
interface we're transmitting on, and not transmit
packets to functions that live on other interfaces,
so validate that as well.

Another bug fix is needed in sta_info.c where in the
VLAN case when adding/removing stations we overwrite
the sdata variable we still need.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/rx.c       |   10 ++++++++--
 net/mac80211/sta_info.c |    2 ++
 net/mac80211/tx.c       |    3 ++-
 3 files changed, 12 insertions(+), 3 deletions(-)

--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2155,11 +2155,17 @@ static void __ieee80211_rx_handle_packet
 
 	skb = rx.skb;
 
-	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+	if (rx.sdata && ieee80211_is_data(hdr->frame_control)) {
+		rx.flags |= IEEE80211_RX_RA_MATCH;
+		prepares = prepare_for_handlers(rx.sdata, &rx, hdr);
+		if (prepares)
+			prev = rx.sdata;
+	} else list_for_each_entry_rcu(sdata, &local->interfaces, list) {
 		if (!netif_running(sdata->dev))
 			continue;
 
-		if (sdata->vif.type == NL80211_IFTYPE_MONITOR)
+		if (sdata->vif.type == NL80211_IFTYPE_MONITOR ||
+		    sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
 			continue;
 
 		rx.flags |= IEEE80211_RX_RA_MATCH;
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -360,6 +360,7 @@ int sta_info_insert(struct sta_info *sta
 					     u.ap);
 
 		drv_sta_notify(local, &sdata->vif, STA_NOTIFY_ADD, &sta->sta);
+		sdata = sta->sdata;
 	}
 
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
@@ -494,6 +495,7 @@ static void __sta_info_unlink(struct sta
 
 		drv_sta_notify(local, &sdata->vif, STA_NOTIFY_REMOVE,
 			       &(*sta)->sta);
+		sdata = (*sta)->sdata;
 	}
 
 	if (ieee80211_vif_is_mesh(&sdata->vif)) {
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1736,7 +1736,8 @@ int ieee80211_subif_start_xmit(struct sk
 	if (!is_multicast_ether_addr(hdr.addr1)) {
 		rcu_read_lock();
 		sta = sta_info_get(local, hdr.addr1);
-		if (sta)
+		/* XXX: in the future, use sdata to look up the sta */
+		if (sta && sta->sdata == sdata)
 			sta_flags = get_sta_flags(sta);
 		rcu_read_unlock();
 	}


