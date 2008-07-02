Return-Path: <linux-kernel-owner+w=401wt.eu-S1758668AbYGBVjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758668AbYGBVjS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 17:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752595AbYGBVjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 17:39:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38736 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752746AbYGBVjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 17:39:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Giacomo Mulas <gmulas@ca.astro.it>
Subject: Re: b43 locks the machine when resuming after suspend to disk
Date: Wed, 2 Jul 2008 23:40:31 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, debian-kernel@lists.debian.org,
       Broadcom Linux <bcm43xx-dev@lists.berlios.de>,
       Johannes Berg <johannes@sipsolutions.net>
References: <alpine.DEB.1.10.0807021830300.32045@capitanata.ca.astro.it>
In-Reply-To: <alpine.DEB.1.10.0807021830300.32045@capitanata.ca.astro.it>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807022340.31894.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 2 of July 2008, Giacomo Mulas wrote:
> I tried searching on the list for this, before posting, but searching the
> mailing list archives with keywords such as b43, suspend, resume... brings
> up such a ludicrous amount of threads that it's not realistic to check them
> all, so just tell me what to look for if it's been asked already.
> 
> Whenever I do a suspend to disk after using b43, the computer freezes hard
> as soon as it attempts again to access b43 after resume.
> 
> Minimal how to reproduce the freeze:
> 1) modprobe b43
> 2) hibernate (using any suspend to disk, which one is irrelevant)
> 3) resume
> 4) ifconfig wlan0 up
> 
> This has been happening (at least) since b43 was included in the mainline
> kernel, on my Asus A6K laptop running an x86_64 kernel (now the latest
> 2.6.25 stable release or compiled from the latest released debian sid
> sources). The nvidia module is not responsible: I explicitely booted my
> laptop in single user mode without any unnecessary modules, same result. It
> does not happen using the windows driver with ndiswrapper (which I would
> prefer to avoid for other reasons), so it definitely depends on b43 or
> something it depends on. Unloading and reloading the b43 module and all the
> other modules it depends on does not change anything. Just loading the
> module once, hibernating and resuming means freeze-up as soon as the module
> is actually initialised next time, regardless of it having been unloaded and
> reloaded any number of times before or after the suspend-resume cycle. No
> oopses, nothing on system logs, just instant freeze-up. Is there some
> testing a user can do to help nailing this? I am not a kernel developer,
> even if I am a decent C programmer.
> 
> Please CC me on replies, I am not on the list.

I think you need the appended patch, but it only applies to linux-next.

Thanks,
Rafael

---
When a driver rejects a frame in it's ->tx() callback, it must also
stop queues, otherwise mac80211 can go into a loop here. Detect this
situation and abort the loop after five retries, warning about the
driver bug.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/tx.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

Index: linux-next/net/mac80211/tx.c
===================================================================
--- linux-next.orig/net/mac80211/tx.c
+++ linux-next/net/mac80211/tx.c
@@ -1144,7 +1144,7 @@ static int ieee80211_tx(struct net_devic
 	struct ieee80211_tx_data tx;
 	ieee80211_tx_result res_prepare;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	int ret, i;
+	int ret, i, retries = 0;
 	u16 queue;
 
 	queue = skb_get_queue_mapping(skb);
@@ -1206,6 +1206,13 @@ retry:
 		 */
 		if (!__netif_subqueue_stopped(local->mdev, queue)) {
 			clear_bit(queue, local->queues_pending);
+			retries++;
+			/*
+			 * Driver bug, it's rejecting packets but
+			 * not stopping queues.
+			 */
+			if (WARN_ON_ONCE(retries > 5))
+				goto drop;
 			goto retry;
 		}
 		store->skb = skb;
