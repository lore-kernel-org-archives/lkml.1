Return-Path: <linux-kernel-owner+w=401wt.eu-S1758054AbXLXOuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758054AbXLXOuw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 09:50:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754871AbXLXOul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 09:50:41 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:46746 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757285AbXLXOuk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 09:50:40 -0500
Date: Mon, 24 Dec 2007 15:50:34 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: jbenc@suse.cz, flamingice@sourmilk.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 36/38] net/mac80211: Use time_before, time_before_eq, etc.
Message-ID: <Pine.LNX.4.64.0712241550090.23999@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The functions time_before, time_before_eq, time_after, and time_after_eq
are more robust for comparing jiffies against other values.

A simplified version of the semantic patch making this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@ change_compare_np @
expression E;
@@

(
- jiffies <= E
+ time_before_eq(jiffies,E)
|
- jiffies >= E
+ time_after_eq(jiffies,E)
|
- jiffies < E
+ time_before(jiffies,E)
|
- jiffies > E
+ time_after(jiffies,E)
)

@ include depends on change_compare_np @
@@

#include <linux/jiffies.h>

@ no_include depends on !include && change_compare_np @
@@

  #include <linux/...>
+ #include <linux/jiffies.h>
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---

diff -r -u -p a/net/mac80211/rc80211_simple.c b/net/mac80211/rc80211_simple.c
--- a/net/mac80211/rc80211_simple.c	2007-11-13 16:01:34.000000000 +0100
+++ b/net/mac80211/rc80211_simple.c	2007-12-23 20:30:40.000000000 +0100
@@ -13,6 +13,7 @@
 #include <linux/slab.h>
 #include <linux/skbuff.h>
 #include <linux/compiler.h>
+#include <linux/jiffies.h>
 
 #include <net/mac80211.h>
 #include "ieee80211_i.h"
@@ -194,7 +195,7 @@ static void rate_control_simple_tx_statu
 		rate_control_rate_dec(local, sta);
 	}
 
-	if (srctrl->avg_rate_update + 60 * HZ < jiffies) {
+	if (time_after(jiffies, srctrl->avg_rate_update + 60 * HZ)) {
 		srctrl->avg_rate_update = jiffies;
 		if (srctrl->tx_avg_rate_num > 0) {
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
diff -r -u -p a/net/mac80211/rx.c b/net/mac80211/rx.c
--- a/net/mac80211/rx.c	2007-12-04 13:19:55.000000000 +0100
+++ b/net/mac80211/rx.c	2007-12-23 20:30:40.000000000 +0100
@@ -14,6 +14,7 @@
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/rcupdate.h>
+#include <linux/jiffies.h>
 #include <net/mac80211.h>
 #include <net/ieee80211_radiotap.h>
 
@@ -741,7 +742,7 @@ ieee80211_reassemble_find(struct ieee802
 		    compare_ether_addr(hdr->addr2, f_hdr->addr2) != 0)
 			continue;
 
-		if (entry->first_frag_time + 2 * HZ < jiffies) {
+		if (time_after(jiffies, entry->first_frag_time + 2 * HZ)) {
 			__skb_queue_purge(&entry->skb_list);
 			continue;
 		}
