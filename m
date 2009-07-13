Return-Path: <linux-kernel-owner+w=401wt.eu-S1756884AbZGMSHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884AbZGMSHv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 14:07:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756871AbZGMSHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 14:07:51 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:57004 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756840AbZGMSHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 14:07:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=w4k0wXsjSOjN3OKXCG/wj2l4+yjQKxf9lsHGahX9PrT0GZ4AbLj8nmiJuWQtsYB00J
         liyB61vMelrYN/Nevj4zbGBwMYg6VjN8Cd644XvArGmFfqrZPt+ACc+lBDe18uVf+I45
         3jpIut3b+sk5OiCfTk7I2+1yXys53TrxKRog8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 13 Jul 2009 20:14:28 +0200
Message-Id: <20090713181428.16765.64673.sendpatchset@localhost.localdomain>
In-Reply-To: <20090713181329.16765.68428.sendpatchset@localhost.localdomain>
References: <20090713181329.16765.68428.sendpatchset@localhost.localdomain>
Subject: [PATCH 08/10] Staging: rtl8192su/ieee80211: remove unused ieee80211_wx_get_encode_ext()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: rtl8192su/ieee80211: remove unused ieee80211_wx_get_encode_ext()

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rtl8192su/ieee80211/ieee80211.h    |    3 -
 drivers/staging/rtl8192su/ieee80211/ieee80211_wx.c |   55 ---------------------
 2 files changed, 58 deletions(-)

Index: b/drivers/staging/rtl8192su/ieee80211/ieee80211.h
===================================================================
--- a/drivers/staging/rtl8192su/ieee80211/ieee80211.h
+++ b/drivers/staging/rtl8192su/ieee80211/ieee80211.h
@@ -2220,9 +2220,6 @@ extern int ieee80211_wx_set_encode(struc
 extern int ieee80211_wx_get_encode(struct ieee80211_device *ieee,
 				   struct iw_request_info *info,
 				   union iwreq_data *wrqu, char *key);
-extern int ieee80211_wx_get_encode_ext(struct ieee80211_device *ieee,
-                            struct iw_request_info *info,
-                            union iwreq_data* wrqu, char *extra);
 extern int ieee80211_wx_set_encode_ext(struct ieee80211_device *ieee,
                             struct iw_request_info *info,
                             union iwreq_data* wrqu, char *extra);
Index: b/drivers/staging/rtl8192su/ieee80211/ieee80211_wx.c
===================================================================
--- a/drivers/staging/rtl8192su/ieee80211/ieee80211_wx.c
+++ b/drivers/staging/rtl8192su/ieee80211/ieee80211_wx.c
@@ -675,61 +675,6 @@ done:
         return ret;
 }
 
-int ieee80211_wx_get_encode_ext(struct ieee80211_device *ieee,
-			       struct iw_request_info *info,
-			       union iwreq_data *wrqu, char *extra)
-{
-	struct iw_point *encoding = &wrqu->encoding;
-	struct iw_encode_ext *ext = (struct iw_encode_ext *)extra;
-	struct ieee80211_crypt_data *crypt;
-	int idx, max_key_len;
-
-	max_key_len = encoding->length - sizeof(*ext);
-	if (max_key_len < 0)
-		return -EINVAL;
-
-	idx = encoding->flags & IW_ENCODE_INDEX;
-	if (idx) {
-		if (idx < 1 || idx > WEP_KEYS)
-			return -EINVAL;
-		idx--;
-	} else
-		idx = ieee->tx_keyidx;
-
-	if (!(ext->ext_flags & IW_ENCODE_EXT_GROUP_KEY) &&
-	    ext->alg != IW_ENCODE_ALG_WEP)
-		if (idx != 0 || ieee->iw_mode != IW_MODE_INFRA)
-			return -EINVAL;
-
-	crypt = ieee->crypt[idx];
-	encoding->flags = idx + 1;
-	memset(ext, 0, sizeof(*ext));
-
-	if (crypt == NULL || crypt->ops == NULL ) {
-		ext->alg = IW_ENCODE_ALG_NONE;
-		ext->key_len = 0;
-		encoding->flags |= IW_ENCODE_DISABLED;
-	} else {
-		if (strcmp(crypt->ops->name, "WEP") == 0 )
-			ext->alg = IW_ENCODE_ALG_WEP;
-		else if (strcmp(crypt->ops->name, "TKIP"))
-			ext->alg = IW_ENCODE_ALG_TKIP;
-		else if (strcmp(crypt->ops->name, "CCMP"))
-			ext->alg = IW_ENCODE_ALG_CCMP;
-		else
-			return -EINVAL;
-		ext->key_len = crypt->ops->get_key(ext->key, SCM_KEY_LEN, NULL, crypt->priv);
-		encoding->flags |= IW_ENCODE_ENABLED;
-		if (ext->key_len &&
-		    (ext->alg == IW_ENCODE_ALG_TKIP ||
-		     ext->alg == IW_ENCODE_ALG_CCMP))
-			ext->ext_flags |= IW_ENCODE_EXT_TX_SEQ_VALID;
-
-	}
-
-	return 0;
-}
-
 int ieee80211_wx_set_mlme(struct ieee80211_device *ieee,
                                struct iw_request_info *info,
                                union iwreq_data *wrqu, char *extra)
