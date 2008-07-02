Return-Path: <linux-kernel-owner+w=401wt.eu-S1757970AbYGBWii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757970AbYGBWii (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 18:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753416AbYGBWia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 18:38:30 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:37361 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbYGBWi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 18:38:29 -0400
Subject: Re: b43 locks the machine when resuming after suspend to disk
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, debian-kernel@lists.debian.org,
       Giacomo Mulas <gmulas@ca.astro.it>,
       Broadcom Linux <bcm43xx-dev@lists.berlios.de>,
       linux-kernel@vger.kernel.org, stable <stable@kernel.org>
In-Reply-To: <486C0206.7060606@lwfinger.net>
References: <alpine.DEB.1.10.0807021830300.32045@capitanata.ca.astro.it>
	 <200807022340.31894.rjw@sisk.pl>	<1215035167.13270.8.camel@johannes.berg>
	 <1215035761.13270.10.camel@johannes.berg>  <486C0206.7060606@lwfinger.net>
Content-Type: text/plain
Date: Thu, 03 Jul 2008 00:37:36 +0200
Message-Id: <1215038256.13270.16.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-02 at 17:32 -0500, Larry Finger wrote:
> Johannes Berg wrote:
> >>> I think you need the appended patch, but it only applies to linux-next.
> >> A different version has been merged into what will become 2.6.26. I'll
> >> see what we can do about stable.
> > 
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=ef3a62d272f033989e83eb1f26505f93f93e3e69;hp=6d1a3fb567a728d31474636e167c324702a0c38b
> > 
> > Anybody have a stable tree around to see if that applies? I think it
> > should.
> 
> It didn't, but this version will. It has been compile tested only.

Ah, the TXRX result thing, thanks a bunch. Adding stable to CC, can you
pick this up?


Subject: mac80211: detect driver tx bugs

When a driver rejects a frame in it's ->tx() callback, it must also
stop queues, otherwise mac80211 can go into a loop here. Detect this
situation and abort the loop after five retries, warning about the
driver bug.

Thanks to Larry Finger <Larry.Finger@lwfinger.net> for doing the -stable
port.


--- linux-2.6.orig/net/mac80211/tx.c
+++ linux-2.6/net/mac80211/tx.c
@@ -1090,7 +1090,7 @@ static int ieee80211_tx(struct net_devic
 	ieee80211_tx_handler *handler;
 	struct ieee80211_txrx_data tx;
 	ieee80211_txrx_result res = TXRX_DROP, res_prepare;
-	int ret, i;
+	int ret, i, retries = 0;
 
 	WARN_ON(__ieee80211_queue_pending(local, control->queue));
 
@@ -1181,6 +1181,13 @@ retry:
 		if (!__ieee80211_queue_stopped(local, control->queue)) {
 			clear_bit(IEEE80211_LINK_STATE_PENDING,
 				  &local->state[control->queue]);
+			retries++;
+			/*
+			 * Driver bug, it's rejecting packets but
+			 * not stopping queues.
+			 */
+			if (WARN_ON_ONCE(retries > 5))
+				goto drop;
 			goto retry;
 		}
 		memcpy(&store->control, control,



