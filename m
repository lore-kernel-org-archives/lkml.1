Return-Path: <linux-kernel-owner+w=401wt.eu-S1765287AbXKPSfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765287AbXKPSfH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 13:35:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750772AbXKPSex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 13:34:53 -0500
Received: from an-out-0708.google.com ([209.85.132.246]:19771 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754532AbXKPSew convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 13:34:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=KWFgpUWy0Ywd5itbDSrqnlPBdTJD6h4CjgfJ9UF4q91MTLoJVDismUUFNqLcdYz1Nr50qz0mLbUm3A0XIFyOXCwImwcsZ/6t9QvLxNTD1kNchJm0VJjJ8FPqBSiZjw/JGtQi2GpwGp7BGajFFjPi5ncgEMA+yrvY3dx5j42eMoE=
From: Miguel =?utf-8?q?Bot=C3=B3n?= <mboton.lkml@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] mac80211: add power management support
Date: Fri, 16 Nov 2007 19:29:36 +0100
User-Agent: KMail/1.9.7
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com, yi.zhu@intel.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200711161929.36283.mboton.lkml@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds power management support in mac80211.

This allows us to enable power management through the "iwconfig <device> power <off/on>" command.
The code is based on "mac80211-10.0.0" but it is a little bit modified.

Signed-off-by: Miguel Botón <mboton@gmail.com>

diff --git a/net/mac80211/ieee80211_ioctl.c b/net/mac80211/ieee80211_ioctl.c
index 6caa3ec..f5eebec 100644
--- a/net/mac80211/ieee80211_ioctl.c
+++ b/net/mac80211/ieee80211_ioctl.c
@@ -674,6 +687,51 @@ static int ieee80211_ioctl_giwtxpower(struct net_device *dev,
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
+		if (ieee80211_hw_config(local))
+			return -EINVAL;
+		return 0;
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
+	if (ieee80211_hw_config(local))
+		return -EINVAL;
+
+	return 0;
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
