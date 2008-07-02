Return-Path: <linux-kernel-owner+w=401wt.eu-S1750891AbYGBWb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750891AbYGBWb3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 18:31:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750781AbYGBWbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 18:31:19 -0400
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:55419 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750700AbYGBWbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 18:31:18 -0400
Message-ID: <486C0206.7060606@lwfinger.net>
Date: Wed, 02 Jul 2008 17:32:38 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, debian-kernel@lists.debian.org,
       Giacomo Mulas <gmulas@ca.astro.it>,
       Broadcom Linux <bcm43xx-dev@lists.berlios.de>,
       linux-kernel@vger.kernel.org
Subject: Re: b43 locks the machine when resuming after suspend to disk
References: <alpine.DEB.1.10.0807021830300.32045@capitanata.ca.astro.it>	<200807022340.31894.rjw@sisk.pl>	<1215035167.13270.8.camel@johannes.berg> <1215035761.13270.10.camel@johannes.berg>
In-Reply-To: <1215035761.13270.10.camel@johannes.berg>
Content-Type: multipart/mixed;
 boundary="------------080304080402090908030704"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080304080402090908030704
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Johannes Berg wrote:
>>> I think you need the appended patch, but it only applies to linux-next.
>> A different version has been merged into what will become 2.6.26. I'll
>> see what we can do about stable.
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=ef3a62d272f033989e83eb1f26505f93f93e3e69;hp=6d1a3fb567a728d31474636e167c324702a0c38b
> 
> Anybody have a stable tree around to see if that applies? I think it
> should.

It didn't, but this version will. It has been compile tested only.

Larry

===========================


Index: linux-2.6/net/mac80211/tx.c
===================================================================
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


--------------080304080402090908030704
Content-Type: text/plain;
 name="mac80211_tx_patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mac80211_tx_patch"

Index: linux-2.6/net/mac80211/tx.c
===================================================================
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


--------------080304080402090908030704--
