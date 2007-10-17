Return-Path: <linux-kernel-owner+w=401wt.eu-S932207AbXJQNte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932207AbXJQNte (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 09:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752842AbXJQNt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 09:49:26 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:42713 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394AbXJQNtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 09:49:25 -0400
Message-ID: <471612E1.2050907@tiscali.nl>
Date: Wed, 17 Oct 2007 15:49:21 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/4] fix not-and/or errors
References: <47161243.6060007@tiscali.nl>
In-Reply-To: <47161243.6060007@tiscali.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    if(!x & y) should either be if(!(x & y)) or if(!x && y)
    I made changes as seemed appropriate, but please review
    
    several changes to drivers/net/
    
    Signed-off-by: Roel Kluin <12o3l@tiscali.nl>

diff --git a/drivers/net/e1000e/82571.c b/drivers/net/e1000e/82571.c
index cf70522..14141a5 100644
--- a/drivers/net/e1000e/82571.c
+++ b/drivers/net/e1000e/82571.c
@@ -283,7 +283,7 @@ static s32 e1000_get_invariants_82571(struct e1000_adapter *adapter)
 			adapter->flags &= ~FLAG_HAS_WOL;
 		/* quad ports only support WoL on port A */
 		if (adapter->flags & FLAG_IS_QUAD_PORT &&
-		    (!adapter->flags & FLAG_IS_QUAD_PORT_A))
+		    (!(adapter->flags & FLAG_IS_QUAD_PORT_A)))
 			adapter->flags &= ~FLAG_HAS_WOL;
 		break;
 
diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index 074055e..e3eca6d 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -6407,7 +6407,7 @@ static int airo_set_encode(struct net_device *dev,
 			set_wep_key(local, index, NULL, 0, perm, 1);
 		} else
 			/* Don't complain if only change the mode */
-			if(!dwrq->flags & IW_ENCODE_MODE) {
+			if(!(dwrq->flags & IW_ENCODE_MODE)) {
 				return -EINVAL;
 			}
 	}
diff --git a/drivers/net/wireless/atmel.c b/drivers/net/wireless/atmel.c
index 059ce3f..57cc7e5 100644
--- a/drivers/net/wireless/atmel.c
+++ b/drivers/net/wireless/atmel.c
@@ -1759,7 +1759,7 @@ static int atmel_set_encode(struct net_device *dev,
 			priv->default_key = index;
 		} else
 			/* Don't complain if only change the mode */
-			if (!dwrq->flags & IW_ENCODE_MODE) {
+			if (!(dwrq->flags & IW_ENCODE_MODE)) {
 				return -EINVAL;
 			}
 	}
diff --git a/drivers/net/wireless/libertas/wext.c b/drivers/net/wireless/libertas/wext.c
index c6f5aa3..d93438c 100644
--- a/drivers/net/wireless/libertas/wext.c
+++ b/drivers/net/wireless/libertas/wext.c
@@ -1380,7 +1380,7 @@ static int wlan_get_encodeext(struct net_device *dev,
 		index = adapter->wep_tx_keyidx;
 	}
 
-	if (!ext->ext_flags & IW_ENCODE_EXT_GROUP_KEY &&
+	if (!(ext->ext_flags & IW_ENCODE_EXT_GROUP_KEY) &&
 	    ext->alg != IW_ENCODE_ALG_WEP) {
 		if (index != 0 || adapter->mode != IW_MODE_INFRA)
 			goto out;
diff --git a/drivers/net/wireless/p54common.c b/drivers/net/wireless/p54common.c
index 2c63cf0..b67a31e 100644
--- a/drivers/net/wireless/p54common.c
+++ b/drivers/net/wireless/p54common.c
@@ -374,7 +374,7 @@ static void p54_rx_frame_sent(struct ieee80211_hw *dev, struct sk_buff *skb)
 			if ((entry_hdr->magic1 & cpu_to_le16(0x4000)) != 0)
 				pad = entry_data->align[0];
 
-			if (!status.control.flags & IEEE80211_TXCTL_NO_ACK) {
+			if (!(status.control.flags & IEEE80211_TXCTL_NO_ACK)) {
 				if (!(payload->status & 0x01))
 					status.flags |= IEEE80211_TX_STATUS_ACK;
 				else
diff --git a/drivers/net/wireless/prism54/isl_ioctl.c b/drivers/net/wireless/prism54/isl_ioctl.c
index 6d80ca4..b9d0073 100644
--- a/drivers/net/wireless/prism54/isl_ioctl.c
+++ b/drivers/net/wireless/prism54/isl_ioctl.c
@@ -1118,7 +1118,7 @@ prism54_set_encode(struct net_device *ndev, struct iw_request_info *info,
 			    mgt_set_request(priv, DOT11_OID_DEFKEYID, 0,
 					    &index);
 		} else {
-			if (!dwrq->flags & IW_ENCODE_MODE) {
+			if (!(dwrq->flags & IW_ENCODE_MODE)) {
 				/* we cannot do anything. Complain. */
 				return -EINVAL;
 			}
@@ -2610,7 +2610,7 @@ prism2_ioctl_set_encryption(struct net_device *dev,
 			    mgt_set_request(priv, DOT11_OID_DEFKEYID, 0,
 					    &index);
 		} else {
-			if (!param->u.crypt.flags & IW_ENCODE_MODE) {
+			if (!(param->u.crypt.flags & IW_ENCODE_MODE)) {
 				/* we cannot do anything. Complain. */
 				return -EINVAL;
 			}
diff --git a/drivers/net/wireless/zd1211rw/zd_rf_uw2453.c b/drivers/net/wireless/zd1211rw/zd_rf_uw2453.c
index 857dcf3..3c1cca4 100644
--- a/drivers/net/wireless/zd1211rw/zd_rf_uw2453.c
+++ b/drivers/net/wireless/zd1211rw/zd_rf_uw2453.c
@@ -403,7 +403,7 @@ static int uw2453_init_hw(struct zd_rf *rf)
 		if (r)
 			return r;
 
-		if (!intr_status & 0xf) {
+		if (!(intr_status & 0xf)) {
 			dev_dbg_f(zd_chip_dev(chip),
 				"PLL locked on configuration %d\n", i);
 			found_config = i;
