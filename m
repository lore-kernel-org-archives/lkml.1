Return-Path: <linux-kernel-owner+w=401wt.eu-S934773AbXKPXHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934773AbXKPXHo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 18:07:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761670AbXKPXHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 18:07:13 -0500
Received: from hu-out-0506.google.com ([72.14.214.226]:35159 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760574AbXKPXHJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 18:07:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=FUrV6J810BMZVwDuvOuEQwNL4+2vrtdM8VQbKqS0rRAcohhBBJaR2bqz61AZgFJuuCcHSDk5EvOdHXg9kqb+orE2WfOO8gka8/kuY0PLXB4bks8+qjuSjw+RcNOvTvyKIy+tpSLCcJZSnlE2kVOFB+3x4WEtpu2BSY8jdgowZTA=
From: Miguel =?utf-8?q?Bot=C3=B3n?= <mboton.lkml@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] mac80211: add power management support -v2
Date: Sat, 17 Nov 2007 00:07:01 +0100
User-Agent: KMail/1.9.7
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com, yi.zhu@intel.com
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200711170007.01676.mboton.lkml@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds power management support in mac80211.

This allows us to enable power management through the "iwconfig <device> power 
<off/on>" command.
The code is based on "mac80211-10.0.0" but it is a little bit modified.

Signed-off-by: Miguel Botón <mboton@gmail.com>

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 5fcc4c1..c82b6fa 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -452,6 +452,8 @@ struct ieee80211_conf {
 	u8 antenna_max;
 	u8 antenna_sel_tx;
 	u8 antenna_sel_rx;
+
+	u8 power_management_enable;     /* flag to enable/disable power management 
*/
 };
 
 /**
diff --git a/net/mac80211/ieee80211_ioctl.c b/net/mac80211/ieee80211_ioctl.c
index 6caa3ec..f5eebec 100644
--- a/net/mac80211/ieee80211_ioctl.c
+++ b/net/mac80211/ieee80211_ioctl.c
@@ -674,6 +687,46 @@ static int ieee80211_ioctl_giwtxpower(struct net_device 
*dev,
 	return 0;
 }
 
+static int ieee80211_ioctl_siwpower(struct net_device *dev,
+				    struct iw_request_info *info,
+				    union iwreq_data *wrqu,
+				    char *extra)
+{
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_conf *conf = &local->hw.conf;
+
+	if (wrqu->power.disabled) {
+		conf->power_management_enable = 0;
+		return ieee80211_hw_config(local);
+	}
+
+	switch (wrqu->power.flags & IW_POWER_MODE) {
+	case IW_POWER_ON:       /* If not specified */
+	case IW_POWER_MODE:     /* If set all mask */
+	case IW_POWER_ALL_R:    /* If explicitely state all */
+		break;
+	default:                /* Otherwise we don't support it */
+		return -EINVAL;
+	}
+
+	conf->power_management_enable = 1;
+
+	return ieee80211_hw_config(local);
+}
+
+static int ieee80211_ioctl_giwpower(struct net_device *dev,
+				    struct iw_request_info *info,
+				    union iwreq_data *wrqu,
+				    char *extra)
+{
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_conf *conf = &local->hw.conf;
+
+	wrqu->power.disabled = !conf->power_management_enable;
+
+	return 0;
+}
+
 static int ieee80211_ioctl_siwrts(struct net_device *dev,
 				  struct iw_request_info *info,
 				  struct iw_param *rts, char *extra)
@@ -1111,8 +1166,8 @@ static const iw_handler ieee80211_handler[] =
 	(iw_handler) ieee80211_ioctl_giwretry,		/* SIOCGIWRETRY */
 	(iw_handler) ieee80211_ioctl_siwencode,		/* SIOCSIWENCODE */
 	(iw_handler) ieee80211_ioctl_giwencode,		/* SIOCGIWENCODE */
-	(iw_handler) NULL,				/* SIOCSIWPOWER */
-	(iw_handler) NULL,				/* SIOCGIWPOWER */
+	(iw_handler) ieee80211_ioctl_siwpower,		/* SIOCSIWPOWER */
+	(iw_handler) ieee80211_ioctl_giwpower,		/* SIOCGIWPOWER */
 	(iw_handler) NULL,				/* -- hole -- */
 	(iw_handler) NULL,				/* -- hole -- */
 	(iw_handler) ieee80211_ioctl_siwgenie,		/* SIOCSIWGENIE */


-- 
	Miguel Botón
