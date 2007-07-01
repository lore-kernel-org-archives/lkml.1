Return-Path: <linux-kernel-owner+w=401wt.eu-S1758785AbXGAUUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758785AbXGAUUz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 16:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758317AbXGAUUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 16:20:17 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:46810 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757996AbXGAUUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 16:20:14 -0400
Date: Sun, 1 Jul 2007 22:20:40 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Dan Williams <dcbw@redhat.com>,
       "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] drivers/net/wireless/libertas/wext.c: remove dead code
Message-ID: <20070701202040.GD10869@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes dead code introduced by
commit 90a42210f275e1f828eb6c08bf8252c2d6a774e0 and spotted
by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 drivers/net/wireless/libertas/wext.c |    3 ---
 1 file changed, 3 deletions(-)

--- linux-2.6.22-rc6-mm1/drivers/net/wireless/libertas/wext.c.old	2007-06-29 21:52:56.000000000 +0200
+++ linux-2.6.22-rc6-mm1/drivers/net/wireless/libertas/wext.c	2007-06-29 21:53:43.000000000 +0200
@@ -1823,85 +1823,82 @@ static int wlan_set_encodeext(struct net
 	} else if ((alg == IW_ENCODE_ALG_TKIP) || (alg == IW_ENCODE_ALG_CCMP)) {
 		struct WLAN_802_11_KEY * pkey;
 
 		/* validate key length */
 		if (((alg == IW_ENCODE_ALG_TKIP)
 			&& (ext->key_len != KEY_LEN_WPA_TKIP))
 		    || ((alg == IW_ENCODE_ALG_CCMP)
 		        && (ext->key_len != KEY_LEN_WPA_AES))) {
 				lbs_deb_wext("invalid size %d for key of alg"
 				       "type %d\n",
 				       ext->key_len,
 				       alg);
 				ret = -EINVAL;
 				goto out;
 		}
 
 		if (ext->ext_flags & IW_ENCODE_EXT_GROUP_KEY) {
 			pkey = &assoc_req->wpa_mcast_key;
 			set_bit(ASSOC_FLAG_WPA_MCAST_KEY, &assoc_req->flags);
 		} else {
 			pkey = &assoc_req->wpa_unicast_key;
 			set_bit(ASSOC_FLAG_WPA_UCAST_KEY, &assoc_req->flags);
 		}
 
 		memset(pkey, 0, sizeof (struct WLAN_802_11_KEY));
 		memcpy(pkey->key, ext->key, ext->key_len);
 		pkey->len = ext->key_len;
 		if (pkey->len)
 			pkey->flags |= KEY_INFO_WPA_ENABLED;
 
 		/* Do this after zeroing key structure */
 		if (ext->ext_flags & IW_ENCODE_EXT_GROUP_KEY) {
 			pkey->flags |= KEY_INFO_WPA_MCAST;
 		} else {
 			pkey->flags |= KEY_INFO_WPA_UNICAST;
 		}
 
 		if (alg == IW_ENCODE_ALG_TKIP) {
 			pkey->type = KEY_TYPE_ID_TKIP;
 		} else if (alg == IW_ENCODE_ALG_CCMP) {
 			pkey->type = KEY_TYPE_ID_AES;
-		} else {
-			ret = -EINVAL;
-			goto out;
 		}
 
 		/* If WPA isn't enabled yet, do that now */
 		if (   assoc_req->secinfo.WPAenabled == 0
 		    && assoc_req->secinfo.WPA2enabled == 0) {
 			assoc_req->secinfo.WPAenabled = 1;
 			assoc_req->secinfo.WPA2enabled = 1;
 			set_bit(ASSOC_FLAG_SECINFO, &assoc_req->flags);
 		}
 
 		disable_wep (assoc_req);
 	}
 
 out:
 	if (ret == 0) {
 		wlan_postpone_association_work(priv);
 	} else {
 		wlan_cancel_association_work(priv);
 	}
 	mutex_unlock(&adapter->lock);
 
 	lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
 	return ret;
 }
 
 
 static int wlan_set_genie(struct net_device *dev,
 			  struct iw_request_info *info,
 			  struct iw_point *dwrq,
 			  char *extra)
 {
 	wlan_private *priv = dev->priv;
 	wlan_adapter *adapter = priv->adapter;
 	int ret = 0;
 	struct assoc_request * assoc_req;
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
 	mutex_lock(&adapter->lock);
 	assoc_req = wlan_get_association_request(adapter);
 	if (!assoc_req) {

