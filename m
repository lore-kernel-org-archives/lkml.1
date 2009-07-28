Return-Path: <linux-kernel-owner+w=401wt.eu-S1753691AbZG1Xto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691AbZG1Xto (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:49:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753476AbZG1Xtn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:49:43 -0400
Received: from kroah.org ([198.145.64.141]:35655 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753608AbZG1Xtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:49:39 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 16:41:52 2009
Message-Id: <20090728234152.583353035@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 16:40:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dan Aloni <dan@aloni.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [patch 09/71] Staging: prevent rtl8187se from crashing dev_ioctl() in SIOCGIWNAME
References: <20090728234029.868717854@mini.kroah.org>
Content-Disposition: inline; filename=staging-prevent-rtl8187se-from-crashing-dev_ioctl-in-siocgiwname.patch
In-Reply-To: <20090728234756.GA11917@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Aloni <dan@aloni.org>

commit 02c8baecf5d8850dba40b47cdf003ed2e04e66dd upstream.

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
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c
@@ -461,19 +461,19 @@ int ieee80211_wx_get_name(struct ieee802
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


