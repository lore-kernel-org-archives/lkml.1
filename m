Return-Path: <linux-kernel-owner+w=401wt.eu-S1761761AbZFXTl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761761AbZFXTl2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 15:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753909AbZFXTlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 15:41:21 -0400
Received: from smtpauth02.prod.mesa1.secureserver.net ([64.202.165.182]:54643
	"HELO smtpauth02.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753287AbZFXTlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 15:41:20 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Jun 2009 15:41:20 EDT
Date: Wed, 24 Jun 2009 22:34:39 +0300
From: Dan Aloni <dan@aloni.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH] prevent rtl8192su from crashing dev_ioctl in SIOCGIWNAME
Message-ID: <20090624193439.GA23924@localhost>
References: <20090620133222.GA18731@localhost> <200906202251.16916.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906202251.16916.bzolnier@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(adapted from the rtl8187se patch)

ieee80211_wx_get_name() ignores sizeof(wrqu->name) which is IFNAMSIZ (16), and
on certain conditions, the concatenated string will be larger than IFNAMSIZ
including the terminating zero.

    length ("802.11" ++ "b" ++ "/g" ++ " linked" ++ "\x00") == 17

This fix uses strl{cpy,cat} in addition to the reduction of the total
possible length of the output string by a char.

It can be applied to 2.6.30-stable as well.

Signed-off-by: Dan Aloni <dan@aloni.org>
---
 .../rtl8192su/ieee80211/ieee80211_softmac_wx.c     |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/rtl8192su/ieee80211/ieee80211_softmac_wx.c b/drivers/staging/rtl8192su/ieee80211/ieee80211_softmac_wx.c
index 1f50c46..b93ddc9 100644
--- a/drivers/staging/rtl8192su/ieee80211/ieee80211_softmac_wx.c
+++ b/drivers/staging/rtl8192su/ieee80211/ieee80211_softmac_wx.c
@@ -548,21 +548,21 @@ int ieee80211_wx_get_name(struct ieee80211_device *ieee,
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
 	if (ieee->mode & (IEEE_N_24G | IEEE_N_5G))
-		strcat(wrqu->name, "/n");
+		strlcat(wrqu->name, "/n", IFNAMSIZ);
 
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
