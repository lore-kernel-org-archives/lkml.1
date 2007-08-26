Return-Path: <linux-kernel-owner+w=401wt.eu-S1754999AbXHZScb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999AbXHZScb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 14:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754056AbXHZScW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 14:32:22 -0400
Received: from deine-taler.de ([217.160.107.63]:50707 "EHLO deine-taler.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753635AbXHZScV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 14:32:21 -0400
Date: Sun, 26 Aug 2007 20:32:20 +0200
From: Ulrich Kunitz <kune@deine-taler.de>
To: Miles Lane <miles.lane@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, dsd@gentoo.org
Subject: Re: 2.6.23-rc3-mm1 -- =?utf-8?Q?drivers=2F?=
	=?utf-8?Q?net=2Fwireless=2Fzd1211rw-mac80211=2Fzd=5Fmac=2Ec=3A822=3A_erro?=
	=?utf-8?B?cjog4oCYSUVFRTgwMjExX0VSUF9DSEFOR0VfUFJFQU1CTEU=?=
	=?utf-8?B?4oCZ?= undeclared (first use in this function)
Message-ID: <20070826183219.GA19299@deine-taler.de>
References: <a44ae5cd0708261012l5a0c125q5716400db3e911ba@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a44ae5cd0708261012l5a0c125q5716400db3e911ba@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Miles Lane wrote:

>   CC [M]  drivers/net/wireless/zd1211rw-mac80211/zd_mac.o
> drivers/net/wireless/zd1211rw-mac80211/zd_mac.c: In function
> 'zd_op_erp_ie_changed':
> drivers/net/wireless/zd1211rw-mac80211/zd_mac.c:822: error:
> 'IEEE80211_ERP_CHANGE_PREAMBLE' undeclared (first use in this
> function)
> drivers/net/wireless/zd1211rw-mac80211/zd_mac.c:822: error: (Each
> undeclared identifier is reported only once
> drivers/net/wireless/zd1211rw-mac80211/zd_mac.c:822: error: for each
> function it appears in.)
> drivers/net/wireless/zd1211rw-mac80211/zd_mac.c: At top level:
> drivers/net/wireless/zd1211rw-mac80211/zd_mac.c:844: error: unknown
> field 'erp_ie_changed' specified in initializer
> drivers/net/wireless/zd1211rw-mac80211/zd_mac.c:844: warning:
> initialization from incompatible pointer type
> make[4]: *** [drivers/net/wireless/zd1211rw-mac80211/zd_mac.o] Error 1

Probably following patch is missing from -mm. Notify also that
zd1211rw-mac80211 is currently not working on wireless-dev.git
branch everything, so even with the ERP patch, zd1211rw-mac80211
will probably not work on -mm.

I had to write my own git-patch-mangling script to be able to create a
tree that allowed me to bisect the problem. (The script is able to
replay "git log -p" output.) The result of the bisect has been the
patch titled "mac80211: split RX handlers into own file" and it is
quite large. I had no chance so far to have a further look.


commit 741f99b32747492ca0d8bb4cc0602e15ffc513b9
Author: Daniel Drake <dsd@gentoo.org>
Date:   Fri Jul 27 15:43:24 2007 +0200

    [PATCH] mac80211: implement ERP info change notifications
    
    zd1211rw and bcm43xx are interested in being notified when ERP IE conditions
    change, so that they can reprogram a register which affects how control frames
    are transmitted.
    
    This patch adds an interface similar to the one that can be found in softmac.
    
    Signed-off-by: Daniel Drake <dsd@gentoo.org>
    Signed-off-by: Jiri Benc <jbenc@suse.cz>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 3282038..e503cd3 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -697,6 +697,14 @@ struct ieee80211_ops {
 	void (*sta_table_notification)(struct ieee80211_hw *hw,
 				       int num_sta);
 
+	/* Handle ERP IE change notifications. Must be atomic. */
+	void (*erp_ie_changed)(struct ieee80211_hw *hw, u8 changes,
+			       int cts_protection, int preamble);
+
+	/* Flags for the erp_ie_changed changes parameter */
+#define IEEE80211_ERP_CHANGE_PROTECTION (1<<0) /* protection flag changed */
+#define IEEE80211_ERP_CHANGE_PREAMBLE (1<<1) /* barker preamble mode changed */
+
 	/* Configure TX queue parameters (EDCF (aifs, cw_min, cw_max),
 	 * bursting) for a hardware TX queue.
 	 * queue = IEEE80211_TX_QUEUE_*.
diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index befc97b..f6e650a 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -464,8 +464,10 @@ static int ieee80211_open(struct net_device *dev)
 	if (sdata->type == IEEE80211_IF_TYPE_MNTR) {
 		local->monitors++;
 		local->hw.conf.flags |= IEEE80211_CONF_RADIOTAP;
-	} else
+	} else {
 		ieee80211_if_config(dev);
+		ieee80211_reset_erp_info(dev);
+	}
 
 	if (sdata->type == IEEE80211_IF_TYPE_STA &&
 	    !local->user_space_mlme)
@@ -748,6 +750,27 @@ int ieee80211_hw_config(struct ieee80211_local *local)
 	return ret;
 }
 
+void ieee80211_erp_info_change_notify(struct net_device *dev, u8 changes)
+{
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	if (local->ops->erp_ie_changed)
+		local->ops->erp_ie_changed(local_to_hw(local), changes,
+					   sdata->use_protection,
+					   !sdata->short_preamble);
+}
+
+void ieee80211_reset_erp_info(struct net_device *dev)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	sdata->short_preamble = 0;
+	sdata->use_protection = 0;
+	ieee80211_erp_info_change_notify(dev,
+					 IEEE80211_ERP_CHANGE_PROTECTION |
+					 IEEE80211_ERP_CHANGE_PREAMBLE);
+}
+
 struct dev_mc_list *ieee80211_get_mc_list_item(struct ieee80211_hw *hw,
 					       struct dev_mc_list *prev,
 					       void **ptr)
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index b0af6e9..cc9999c 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -788,6 +788,8 @@ struct sta_info * ieee80211_ibss_add_sta(struct net_device *dev,
 					 u8 *addr);
 int ieee80211_sta_deauthenticate(struct net_device *dev, u16 reason);
 int ieee80211_sta_disassociate(struct net_device *dev, u16 reason);
+void ieee80211_erp_info_change_notify(struct net_device *dev, u8 changes);
+void ieee80211_reset_erp_info(struct net_device *dev);
 
 /* ieee80211_iface.c */
 int ieee80211_if_add(struct net_device *dev, const char *name,
diff --git a/net/mac80211/ieee80211_ioctl.c b/net/mac80211/ieee80211_ioctl.c
index 8292431..1fde214 100644
--- a/net/mac80211/ieee80211_ioctl.c
+++ b/net/mac80211/ieee80211_ioctl.c
@@ -1054,17 +1054,21 @@ static int ieee80211_ioctl_prism2_param(struct net_device *dev,
 		break;
 
 	case PRISM2_PARAM_CTS_PROTECT_ERP_FRAMES:
-		if (sdata->type != IEEE80211_IF_TYPE_AP)
+		if (sdata->type == IEEE80211_IF_TYPE_AP) {
+			sdata->use_protection = !!value;
+			ieee80211_erp_info_change_notify(dev, IEEE80211_ERP_CHANGE_PROTECTION);
+		} else {
 			ret = -ENOENT;
-		else
-			sdata->use_protection = value;
+		}
 		break;
 
 	case PRISM2_PARAM_PREAMBLE:
-		if (sdata->type != IEEE80211_IF_TYPE_AP)
+		if (sdata->type != IEEE80211_IF_TYPE_AP) {
+			sdata->short_preamble = !!value;
+			ieee80211_erp_info_change_notify(dev, IEEE80211_ERP_CHANGE_PREAMBLE);
+		} else {
 			ret = -ENOENT;
-		else
-			sdata->short_preamble = value;
+		}
 		break;
 
 	case PRISM2_PARAM_STAT_TIME:
diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 578c1a6..39022c5 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -319,6 +319,7 @@ static void ieee80211_handle_erp_ie(struct net_device *dev, u8 erp_value)
 	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
 	int use_protection = (erp_value & WLAN_ERP_USE_PROTECTION) != 0;
 	int preamble_mode = (erp_value & WLAN_ERP_BARKER_PREAMBLE) != 0;
+	u8 changes = 0;
 
 	if (use_protection != sdata->use_protection) {
 		if (net_ratelimit()) {
@@ -329,6 +330,7 @@ static void ieee80211_handle_erp_ie(struct net_device *dev, u8 erp_value)
 			       MAC_ARG(ifsta->bssid));
 		}
 		sdata->use_protection = use_protection;
+		changes |= IEEE80211_ERP_CHANGE_PROTECTION;
 	}
 
 	if (!preamble_mode != sdata->short_preamble) {
@@ -341,7 +343,11 @@ static void ieee80211_handle_erp_ie(struct net_device *dev, u8 erp_value)
 			       MAC_ARG(ifsta->bssid));
 		}
 		sdata->short_preamble = !preamble_mode;
+		changes |= IEEE80211_ERP_CHANGE_PREAMBLE;
 	}
+
+	if (changes)
+		ieee80211_erp_info_change_notify(dev, changes);
 }
 
 
@@ -400,7 +406,6 @@ static void ieee80211_set_associated(struct net_device *dev,
 				     struct ieee80211_if_sta *ifsta, int assoc)
 {
 	union iwreq_data wrqu;
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	if (ifsta->associated == assoc)
 		return;
@@ -428,8 +433,7 @@ static void ieee80211_set_associated(struct net_device *dev,
 		ieee80211_sta_send_associnfo(dev, ifsta);
 	} else {
 		netif_carrier_off(dev);
-		sdata->short_preamble = 0;
-		sdata->use_protection = 0;
+		ieee80211_reset_erp_info(dev);
 		memset(wrqu.ap_addr.sa_data, 0, ETH_ALEN);
 	}
 	wrqu.ap_addr.sa_family = ARPHRD_ETHER;
