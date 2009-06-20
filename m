Return-Path: <linux-kernel-owner+w=401wt.eu-S1755134AbZFTNjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134AbZFTNjR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 09:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752334AbZFTNjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 09:39:08 -0400
Received: from p3plsmtpa01-04.prod.phx3.secureserver.net ([72.167.82.84]:47430
	"HELO p3plsmtpa01-04.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752241AbZFTNjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 09:39:07 -0400
X-Greylist: delayed 403 seconds by postgrey-1.27 at vger.kernel.org; Sat, 20 Jun 2009 09:39:07 EDT
Date: Sat, 20 Jun 2009 16:32:22 +0300
From: Dan Aloni <dan@aloni.org>
To: Linux Kernel List <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH] Staging: prevent rtl8187se from crashing dev_ioctl() in
	SIOCGIWNAME
Message-ID: <20090620133222.GA18731@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I repeatedly get __stack_chk_fail panic()s with this driver before
applying the attached fix.

ieee80211_wx_get_name() ignores sizeof(wrqu->name) which is IFNAMSIZ (16), and
on certain conditions, the concatenated string will be larger than IFNAMSIZ
including the terminating zero.

    length ("802.11" ++ "b" ++ "/g" ++ " linked" ++ "\x00") == 17

This fix uses strl{cpy,cat} in addition to the reduction of the total
possible length of the output string by a char.

It can be applied to 2.6.30-stable as well.

Signed-off-by: Dan Aloni <dan@aloni.org>
---
 .../rtl8187se/ieee80211/ieee80211_softmac_wx.c     |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c
index 93af37e..54b4b71 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c
@@ -461,19 +461,19 @@ int ieee80211_wx_get_name(struct ieee80211_device *ieee,
 			     struct iw_request_info *info,
 			     union iwreq_data *wrqu, char *extra)
 {
-	strcpy(wrqu->name, "802.11");
+	strlcpy(wrqu->name, "802.11", IFNAMSIZ);
 	if(ieee->modulation & IEEE80211_CCK_MODULATION){
-		strcat(wrqu->name, "b");
+		strlcat(wrqu->name, "b", IFNAMSIZ);
 		if(ieee->modulation & IEEE80211_OFDM_MODULATION)
-			strcat(wrqu->name, "/g");
+			strlcat(wrqu->name, "/g", IFNAMSIZ);
 	}else if(ieee->modulation & IEEE80211_OFDM_MODULATION)
-		strcat(wrqu->name, "g");
+		strlcat(wrqu->name, "g", IFNAMSIZ);
 
 	if((ieee->state == IEEE80211_LINKED) ||
 		(ieee->state == IEEE80211_LINKED_SCANNING))
-		strcat(wrqu->name," linked");
+		strlcat(wrqu->name,"  link", IFNAMSIZ);
 	else if(ieee->state != IEEE80211_NOLINK)
-		strcat(wrqu->name," link..");
+		strlcat(wrqu->name," .....", IFNAMSIZ);
 
 
 	return 0;
-- 
1.6.0.4

