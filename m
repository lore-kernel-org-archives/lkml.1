Return-Path: <linux-kernel-owner+w=401wt.eu-S1755312AbZFYO34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312AbZFYO34 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 10:29:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751607AbZFYO3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 10:29:48 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:44282 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbZFYO3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 10:29:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=X/I1AwwCaSeSqaZ0JxumBK9DUpjStNzFan8mbhwgxrkmSPD8ZFM14QZyx6SHTHD4ZH
         0pllEXtYJ1RFhiN0IUQCAK59Kt8GRRjIkPtSGunTAC1/ZVJufn4VTvhAFSYekNMdT1/Q
         GozMaCHcm1A+INzauhl23RF2JKBw5hGgSQIy0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Dan Aloni <dan@aloni.org>
Subject: Re: [PATCH] prevent rtl8192su from crashing dev_ioctl in SIOCGIWNAME
Date: Thu, 25 Jun 2009 16:34:55 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.31-rc1-next-20090625-02642-g2b5b204; KDE/4.2.3; i686; ; )
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>,
       "Greg Kroah-Hartman" <gregkh@suse.de>
References: <20090620133222.GA18731@localhost> <200906202251.16916.bzolnier@gmail.com> <20090624193439.GA23924@localhost>
In-Reply-To: <20090624193439.GA23924@localhost>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906251634.55900.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 June 2009 21:34:39 Dan Aloni wrote:
> (adapted from the rtl8187se patch)
> 
> ieee80211_wx_get_name() ignores sizeof(wrqu->name) which is IFNAMSIZ (16), and
> on certain conditions, the concatenated string will be larger than IFNAMSIZ
> including the terminating zero.
> 
>     length ("802.11" ++ "b" ++ "/g" ++ " linked" ++ "\x00") == 17
> 
> This fix uses strl{cpy,cat} in addition to the reduction of the total
> possible length of the output string by a char.
> 
> It can be applied to 2.6.30-stable as well.
> 
> Signed-off-by: Dan Aloni <dan@aloni.org>

Thanks!

I fixed some minor whitespace issues:

ERROR: space required after that ',' (ctx:VxV)                                                      
#50: FILE: drivers/staging/rtl8192su/ieee80211/ieee80211_softmac_wx.c:563:                          
+               strlcat(wrqu->name,"  link", IFNAMSIZ);                                             
                                  ^                                                                 

ERROR: space required after that ',' (ctx:VxV)
#53: FILE: drivers/staging/rtl8192su/ieee80211/ieee80211_softmac_wx.c:565:
+               strlcat(wrqu->name," .....", IFNAMSIZ);                   

and applied it to rtl8192su branch of my misc.git tree (just to keep it
together with other rtl8192su changes and not forget about this fix):

	git://git.kernel.org:/pub/scm/linux/kernel/git/bart/misc.git rtl8192su

Greg, here is the final version of the patch:

Date: Wed, 24 Jun 2009 22:34:39 +0300
From: Dan Aloni <dan@aloni.org>
Subject: [PATCH] Staging: prevent rtl8192su from crashing dev_ioctl in SIOCGIWNAME

(adapted from the rtl8187se patch)

ieee80211_wx_get_name() ignores sizeof(wrqu->name) which is IFNAMSIZ (16), and
on certain conditions, the concatenated string will be larger than IFNAMSIZ
including the terminating zero.

    length ("802.11" ++ "b" ++ "/g" ++ " linked" ++ "\x00") == 17

This fix uses strl{cpy,cat} in addition to the reduction of the total
possible length of the output string by a char.

Signed-off-by: Dan Aloni <dan@aloni.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
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
+		strlcat(wrqu->name, "  link", IFNAMSIZ);
 	else if(ieee->state != IEEE80211_NOLINK)
-		strcat(wrqu->name," link..");
+		strlcat(wrqu->name, " .....", IFNAMSIZ);
 
 
 	return 0;
-- 
1.6.0.4


