Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756494Ab0BLOlS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 09:41:18 -0500
Received: from liberdade.minaslivre.org ([72.232.254.139]:60175 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473Ab0BLOlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 09:41:17 -0500
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Simon Raffeiner <sturmflut@lieberbiber.de>,
       Andrey Yurovsky <andrey@cozybit.com>,
       Javier Cardona <javier@cozybit.com>
Subject: [PATCH v2] nl80211: does not allow NEW_STATION and DEL_STATION for mesh
Date: Fri, 12 Feb 2010 12:34:50 -0200
Message-Id: <1265985290-1516-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1265978241-1601-1-git-send-email-cascardo@holoscopio.com>
References: <1265978241-1601-1-git-send-email-cascardo@holoscopio.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As discussed in linux-wireless mailing list, adding and removing
stations for mesh topologies is not necessary. Since doing it triggers
bugs, the sugestion was to simply disable it.

Tested using a custom iw command "station new". Works only after using
hostapd. "station del" command also works.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Simon Raffeiner <sturmflut@lieberbiber.de>
Cc: Andrey Yurovsky <andrey@cozybit.com>
Cc: Javier Cardona <javier@cozybit.com>
---

Should be fixed now! Sorry for all the noise.

---
 net/wireless/nl80211.c |   49 ++++++++++++-----------------------------------
 1 files changed, 13 insertions(+), 36 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 5b79ecf..a95ab9e 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2010,6 +2010,9 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 	if (!info->attrs[NL80211_ATTR_STA_SUPPORTED_RATES])
 		return -EINVAL;
 
+	if (!info->attrs[NL80211_ATTR_STA_AID])
+		return -EINVAL;
+
 	mac_addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
 	params.supported_rates =
 		nla_data(info->attrs[NL80211_ATTR_STA_SUPPORTED_RATES]);
@@ -2018,11 +2021,9 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 	params.listen_interval =
 		nla_get_u16(info->attrs[NL80211_ATTR_STA_LISTEN_INTERVAL]);
 
-	if (info->attrs[NL80211_ATTR_STA_AID]) {
-		params.aid = nla_get_u16(info->attrs[NL80211_ATTR_STA_AID]);
-		if (!params.aid || params.aid > IEEE80211_MAX_AID)
-			return -EINVAL;
-	}
+	params.aid = nla_get_u16(info->attrs[NL80211_ATTR_STA_AID]);
+	if (!params.aid || params.aid > IEEE80211_MAX_AID)
+		return -EINVAL;
 
 	if (info->attrs[NL80211_ATTR_HT_CAPABILITY])
 		params.ht_capa =
@@ -2037,6 +2038,12 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 	if (err)
 		goto out_rtnl;
 
+	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP_VLAN) {
+		err = -EINVAL;
+		goto out;
+	}
+
 	err = get_vlan(info, rdev, &params.vlan);
 	if (err)
 		goto out;
@@ -2044,35 +2051,6 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 	/* validate settings */
 	err = 0;
 
-	switch (dev->ieee80211_ptr->iftype) {
-	case NL80211_IFTYPE_AP:
-	case NL80211_IFTYPE_AP_VLAN:
-		/* all ok but must have AID */
-		if (!params.aid)
-			err = -EINVAL;
-		break;
-	case NL80211_IFTYPE_MESH_POINT:
-		/* disallow things mesh doesn't support */
-		if (params.vlan)
-			err = -EINVAL;
-		if (params.aid)
-			err = -EINVAL;
-		if (params.ht_capa)
-			err = -EINVAL;
-		if (params.listen_interval >= 0)
-			err = -EINVAL;
-		if (params.supported_rates)
-			err = -EINVAL;
-		if (params.sta_flags_mask)
-			err = -EINVAL;
-		break;
-	default:
-		err = -EINVAL;
-	}
-
-	if (err)
-		goto out;
-
 	if (!rdev->ops->add_station) {
 		err = -EOPNOTSUPP;
 		goto out;
@@ -2113,8 +2091,7 @@ static int nl80211_del_station(struct sk_buff *skb, struct genl_info *info)
 		goto out_rtnl;
 
 	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
-	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP_VLAN &&
-	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_MESH_POINT) {
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP_VLAN) {
 		err = -EINVAL;
 		goto out;
 	}
-- 
1.6.6.1

