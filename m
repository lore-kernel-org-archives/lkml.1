Return-Path: <linux-kernel-owner+w=401wt.eu-S1757199AbZJ3LuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199AbZJ3LuX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 07:50:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757168AbZJ3LuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 07:50:23 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:42495 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756489AbZJ3LuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 07:50:22 -0400
Subject: Re: OOPS in cfg80211_conn_work
From: Johannes Berg <johannes@sipsolutions.net>
To: Parag Warudkar <parag.lkml@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.0910300652350.2223@parag-laptop>
References: <f7848160910291617q2b168089l5ce489d2f47ebe96@mail.gmail.com>
	 <1256885343.3555.0.camel@johannes.local>
	 <alpine.DEB.2.00.0910300652350.2223@parag-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Oct 2009 12:50:25 +0100
Message-ID: <1256903425.3555.47.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-30 at 06:57 -0400, Parag Warudkar wrote:
> 
> On Fri, 30 Oct 2009, Johannes Berg wrote:
> 
> > On Thu, 2009-10-29 at 19:17 -0400, Parag Warudkar wrote:
> > > Oct 29 18:59:06 parag-laptop kernel: [  143.180037] wlan0:
> > > deauthenticating from 00:16:01:d6:6f:12 by local choice (reason=3)
> > > Oct 29 18:59:06 parag-laptop kernel: [  143.181137] wlan0: direct
> > > probe to AP 00:16:01:d6:6f:12 (try 1)
> > 
> > sorry, I can't read this log. please provide a non-wrapped version
> > 
> How does this look? (Sorry sent it in a rush earlier.)
> Below also is a disassembly of cfg80211_conn_work.

Thanks. I was going to ask for disassembly but you preempted me, I like
that :)

Since you say you can easily reproduce this, can you try the patch
below?

johannes

---
 net/wireless/sme.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- wireless-testing.orig/net/wireless/sme.c	2009-10-30 12:48:09.000000000 +0100
+++ wireless-testing/net/wireless/sme.c	2009-10-30 12:48:41.000000000 +0100
@@ -165,7 +165,7 @@ void cfg80211_conn_work(struct work_stru
 	struct cfg80211_registered_device *rdev =
 		container_of(work, struct cfg80211_registered_device, conn_work);
 	struct wireless_dev *wdev;
-	u8 bssid[ETH_ALEN];
+	u8 bssid_buf[ETH_ALEN], *bssid = NULL;
 
 	rtnl_lock();
 	cfg80211_lock_rdev(rdev);
@@ -181,7 +181,10 @@ void cfg80211_conn_work(struct work_stru
 			wdev_unlock(wdev);
 			continue;
 		}
-		memcpy(bssid, wdev->conn->params.bssid, ETH_ALEN);
+		if (wdev->conn->params.bssid) {
+			memcpy(bssid_buf, wdev->conn->params.bssid, ETH_ALEN);
+			bssid = bssid_buf;
+		}
 		if (cfg80211_conn_do_work(wdev))
 			__cfg80211_connect_result(
 					wdev->netdev, bssid,


