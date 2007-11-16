Return-Path: <linux-kernel-owner+w=401wt.eu-S1765357AbXKPTCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765357AbXKPTCU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 14:02:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752411AbXKPTCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 14:02:07 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:53205 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbXKPTCE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 14:02:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=aTWVdmEE9e9f7IdFOL35HatGoxljpOOn3iWVQERvQAgVvHR4rsAqp8yAIAh1o7v/2YnyUrlr07clzY1lFzInLTG6XLsjJIFZMNGu0e8qLWYoULguLMMoqWK2jxIGOKT0nLQBANdjpR1yP5a8cW/7dLi/eJesoWJH8vN0waSeTCM=
From: Miguel =?utf-8?q?Bot=C3=B3n?= <mboton.lkml@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] mac80211: add power management support
Date: Fri, 16 Nov 2007 20:02:01 +0100
User-Agent: KMail/1.9.7
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com, yi.zhu@intel.com
References: <200711161929.36283.mboton.lkml@gmail.com> <200711161953.26801.mboton.lkml@gmail.com>
In-Reply-To: <200711161953.26801.mboton.lkml@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200711162002.01972.mboton.lkml@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Today is not a good day for me... I sent the previous patch with wordwrap enabled.
This one is the correct.

--

This patch adds power management support in mac80211.

This allows us to enable power management through the "iwconfig <device> power <off/on>" command.
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
+	u8 power_management_enable;     /* flag to enable/disable power management */
 };
 
 /**
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
