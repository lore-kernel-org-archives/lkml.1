Return-Path: <linux-kernel-owner+w=401wt.eu-S1756593AbYLEOsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593AbYLEOsA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 09:48:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753067AbYLEOru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 09:47:50 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:42855 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903AbYLEOrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 09:47:49 -0500
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] p54usb: fix usb_kill_urb hang with slub_debug=P
Date: Fri, 5 Dec 2008 15:47:45 +0100
User-Agent: KMail/1.10.0 (Linux/2.6.28-rc6-wl; KDE/4.1.0; x86_64; ; )
Cc: Johannes Berg <johannes@sipsolutions.net>,
       John W Linville <linville@tuxdriver.com>, linux-usb@vger.kernel.org,
       gregkh@suse.de, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812051547.45790.chunkeey@web.de>
X-Provags-ID: V01U2FsdGVkX19VLsAz1qMdhqqMtYBYrq85vGhQghf99C77IKVf
	GDGDFfgHtDZmPWW8TUqMBvefSog0jSdX3z22AkqT5t1Tbq94zZ
	h0FCgrV60=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a problem identified by Johannes Berg.

It looks like this is a classic case of "use-after-freed". 
A module which should reproduce the problem on
any other USB device can be found right here:
http://kerneltrap.org/mailarchive/linux-usb/2008/12/4/4317064

Tested-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Christian Lamparter <chunkeey@web.de>
CC: stable@vger.kernel.org
---
diff --git a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
index 3444f52..0b9a922 100644
--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -209,7 +209,14 @@ static void p54u_free_urbs(struct ieee80211_hw *dev)
 		if (!info->urb)
 			continue;
 
+		/*
+		 * usb_get_urb and usb_free_urb are part of a temporary
+		 * workaround. Otherwise we get a pretty bad freeze,
+		 * if SLUB's poisoning debug option is enabled.
+		 */
+		usb_get_urb(info->urb);
 		usb_kill_urb(info->urb);
+		usb_free_urb(info->urb);
 		kfree_skb(skb);
 	}
 }

