Return-Path: <linux-kernel-owner+w=401wt.eu-S932200AbZHPTbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200AbZHPTbk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 15:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755973AbZHPTbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 15:31:31 -0400
Received: from mail-fx0-f215.google.com ([209.85.220.215]:55539 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755897AbZHPTbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 15:31:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=qmA1QXFNrJQkmoxM199fxHpdsLhUVFwkg+WLQWDSWOBSlLnz8KcnZsVcqdBcvit/92
         UqA5c5/KflSLSLwCX8T4uXty890mnGyt8QMxbSklqiW+K5cqQBDjDtMvQuzrjpbUUV3F
         CxFXHEiww/N7ROo7IpX1UugWNnw5PpMBRgRoU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 16 Aug 2009 21:31:30 +0200
Message-Id: <20090816193130.3789.20875.sendpatchset@localhost.localdomain>
In-Reply-To: <20090816192934.3789.3648.sendpatchset@localhost.localdomain>
References: <20090816192934.3789.3648.sendpatchset@localhost.localdomain>
Subject: [PATCH 16/22] Staging: rtxxx0: remove dead virtual adapter support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: rtxxx0: remove dead virtual adapter support

* remove dead virtual adapter support
* remove needless rt28xx_ioctl() wrapper
* remove superfluous NULL checks

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rt2860/rt_linux.h    |    6 
 drivers/staging/rt2860/rt_main_dev.c |   33 ---
 drivers/staging/rt2860/rtmp.h        |    5 
 drivers/staging/rt2860/sta_ioctl.c   |  293 -----------------------------------
 4 files changed, 9 insertions(+), 328 deletions(-)

Index: b/drivers/staging/rt2860/rt_linux.h
===================================================================
--- a/drivers/staging/rt2860/rt_linux.h
+++ b/drivers/staging/rt2860/rt_linux.h
@@ -198,12 +198,6 @@ struct os_cookie {
 	INT 					ioctl_if;
 };
 
-typedef struct _VIRTUAL_ADAPTER
-{
-	struct net_device		*RtmpDev;
-	struct net_device		*VirtualDev;
-} VIRTUAL_ADAPTER, PVIRTUAL_ADAPTER;
-
 #undef  ASSERT
 #define ASSERT(x)
 
Index: b/drivers/staging/rt2860/rt_main_dev.c
===================================================================
--- a/drivers/staging/rt2860/rt_main_dev.c
+++ b/drivers/staging/rt2860/rt_main_dev.c
@@ -670,7 +670,7 @@ err:
 static const struct net_device_ops rt2860_netdev_ops = {
 	.ndo_open		= MainVirtualIF_open,
 	.ndo_stop		= MainVirtualIF_close,
-	.ndo_do_ioctl		= rt28xx_ioctl,
+	.ndo_do_ioctl		= rt28xx_sta_ioctl,
 	.ndo_get_stats		= RT28xx_get_ether_stats,
 	.ndo_validate_addr	= NULL,
 	.ndo_set_mac_address	= eth_mac_addr,
@@ -970,37 +970,6 @@ void tbtt_tasklet(unsigned long data)
 
 }
 
-INT rt28xx_ioctl(
-	IN	struct net_device	*net_dev,
-	IN	OUT	struct ifreq	*rq,
-	IN	INT					cmd)
-{
-	VIRTUAL_ADAPTER	*pVirtualAd = NULL;
-	RTMP_ADAPTER	*pAd = NULL;
-	INT				ret = 0;
-
-	if (net_dev->priv_flags == INT_MAIN)
-	{
-		pAd = net_dev->ml_priv;
-	}
-	else
-	{
-		pVirtualAd = net_dev->ml_priv;
-		pAd = pVirtualAd->RtmpDev->ml_priv;
-	}
-
-	if (pAd == NULL)
-	{
-		/* if 1st open fail, pAd will be free;
-		   So the net_dev->ml_priv will be NULL in 2rd open */
-		return -ENETDOWN;
-	}
-
-	ret = rt28xx_sta_ioctl(net_dev, rq, cmd);
-
-	return ret;
-}
-
 /*
     ========================================================================
 
Index: b/drivers/staging/rt2860/rtmp.h
===================================================================
--- a/drivers/staging/rt2860/rtmp.h
+++ b/drivers/staging/rt2860/rtmp.h
@@ -6331,11 +6331,6 @@ VOID RT28xx_UpdateBeaconToAsic(
 	IN ULONG BeaconLen,
 	IN ULONG UpdatePos);
 
-INT rt28xx_ioctl(
-	IN	struct net_device	*net_dev,
-	IN	OUT	struct ifreq	*rq,
-	IN	INT			cmd);
-
 INT rt28xx_sta_ioctl(
 	IN	struct net_device	*net_dev,
 	IN	OUT	struct ifreq	*rq,
Index: b/drivers/staging/rt2860/sta_ioctl.c
===================================================================
--- a/drivers/staging/rt2860/sta_ioctl.c
+++ b/drivers/staging/rt2860/sta_ioctl.c
@@ -577,38 +577,10 @@ int rt_ioctl_giwfreq(struct net_device *
 		   struct iw_request_info *info,
 		   struct iw_freq *freq, char *extra)
 {
-    VIRTUAL_ADAPTER *pVirtualAd = NULL;
-#ifndef RT30xx
-	PRTMP_ADAPTER pAdapter = NULL;
-#endif
-#ifdef RT30xx
-	PRTMP_ADAPTER pAdapter;
-#endif
-	UCHAR ch;
+	PRTMP_ADAPTER pAdapter = dev->ml_priv;
+	UCHAR ch = pAdapter->CommonCfg.Channel;
 	ULONG	m;
 
-	if (dev->priv_flags == INT_MAIN)
-	{
-		pAdapter = dev->ml_priv;
-	}
-	else
-	{
-		pVirtualAd = dev->ml_priv;
-#ifndef RT30xx
-		if (pVirtualAd && pVirtualAd->RtmpDev)
-#endif
-			pAdapter = pVirtualAd->RtmpDev->ml_priv;
-	}
-
-	if (pAdapter == NULL)
-	{
-		/* if 1st open fail, pAd will be free;
-		   So the net_dev->ml_priv will be NULL in 2rd open */
-		return -ENETDOWN;
-	}
-
-		ch = pAdapter->CommonCfg.Channel;
-
 	DBGPRINT(RT_DEBUG_TRACE,("==>rt_ioctl_giwfreq  %d\n", ch));
 
     MAP_CHANNEL_ID_TO_KHZ(ch, m);
@@ -656,31 +628,7 @@ int rt_ioctl_giwmode(struct net_device *
 		   struct iw_request_info *info,
 		   __u32 *mode, char *extra)
 {
-#ifndef RT30xx
-	PRTMP_ADAPTER 	pAdapter = NULL;
-	VIRTUAL_ADAPTER *pVirtualAd = NULL;
-
-	if (dev->priv_flags == INT_MAIN)
-	{
-		pAdapter = dev->ml_priv;
-	}
-	else
-	{
-		pVirtualAd = dev->ml_priv;
-		if (pVirtualAd && pVirtualAd->RtmpDev)
-			pAdapter = pVirtualAd->RtmpDev->ml_priv;
-	}
-
-	if (pAdapter == NULL)
-	{
-		/* if 1st open fail, pAd will be free;
-		   So the net_dev->ml_priv will be NULL in 2rd open */
-		return -ENETDOWN;
-	}
-#endif
-#ifdef RT30xx
 	PRTMP_ADAPTER pAdapter = dev->ml_priv;
-#endif
 
 	if (ADHOC_ON(pAdapter))
 		*mode = IW_MODE_ADHOC;
@@ -724,37 +672,11 @@ int rt_ioctl_giwrange(struct net_device 
 		   struct iw_request_info *info,
 		   struct iw_point *data, char *extra)
 {
-#ifndef RT30xx
-	PRTMP_ADAPTER 	pAdapter = NULL;
-	VIRTUAL_ADAPTER *pVirtualAd = NULL;
-#endif
-#ifdef RT30xx
 	PRTMP_ADAPTER pAdapter = dev->ml_priv;
-#endif
 	struct iw_range *range = (struct iw_range *) extra;
 	u16 val;
 	int i;
 
-#ifndef RT30xx
-	if (dev->priv_flags == INT_MAIN)
-	{
-		pAdapter = dev->ml_priv;
-	}
-	else
-	{
-		pVirtualAd = dev->ml_priv;
-		if (pVirtualAd && pVirtualAd->RtmpDev)
-			pAdapter = pVirtualAd->RtmpDev->ml_priv;
-	}
-
-	if (pAdapter == NULL)
-	{
-		/* if 1st open fail, pAd will be free;
-		   So the net_dev->ml_priv will be NULL in 2rd open */
-		return -ENETDOWN;
-	}
-#endif
-
 	DBGPRINT(RT_DEBUG_TRACE ,("===>rt_ioctl_giwrange\n"));
 	data->length = sizeof(struct iw_range);
 	memset(range, 0, sizeof(struct iw_range));
@@ -871,31 +793,7 @@ int rt_ioctl_giwap(struct net_device *de
 		      struct iw_request_info *info,
 		      struct sockaddr *ap_addr, char *extra)
 {
-#ifndef RT30xx
-	PRTMP_ADAPTER 	pAdapter = NULL;
-	VIRTUAL_ADAPTER *pVirtualAd = NULL;
-
-	if (dev->priv_flags == INT_MAIN)
-	{
-		pAdapter = dev->ml_priv;
-	}
-	else
-	{
-		pVirtualAd = dev->ml_priv;
-		if (pVirtualAd && pVirtualAd->RtmpDev)
-			pAdapter = pVirtualAd->RtmpDev->ml_priv;
-	}
-
-	if (pAdapter == NULL)
-	{
-		/* if 1st open fail, pAd will be free;
-		   So the net_dev->ml_priv will be NULL in 2rd open */
-		return -ENETDOWN;
-	}
-#endif
-#ifdef RT30xx
 	PRTMP_ADAPTER pAdapter = dev->ml_priv;
-#endif
 
 	if (INFRA_ON(pAdapter) || ADHOC_ON(pAdapter))
 	{
@@ -1398,31 +1296,7 @@ int rt_ioctl_giwessid(struct net_device 
 			 struct iw_request_info *info,
 			 struct iw_point *data, char *essid)
 {
-#ifndef RT30xx
-	PRTMP_ADAPTER 	pAdapter = NULL;
-	VIRTUAL_ADAPTER *pVirtualAd = NULL;
-
-	if (dev->priv_flags == INT_MAIN)
-	{
-		pAdapter = dev->ml_priv;
-	}
-	else
-	{
-		pVirtualAd = dev->ml_priv;
-		if (pVirtualAd && pVirtualAd->RtmpDev)
-			pAdapter = pVirtualAd->RtmpDev->ml_priv;
-	}
-
-	if (pAdapter == NULL)
-	{
-		/* if 1st open fail, pAd will be free;
-		   So the net_dev->ml_priv will be NULL in 2rd open */
-		return -ENETDOWN;
-	}
-#endif
-#ifdef RT30xx
 	PRTMP_ADAPTER pAdapter = dev->ml_priv;
-#endif
 
 	data->flags = 1;
     if (MONITOR_ON(pAdapter))
@@ -1482,31 +1356,7 @@ int rt_ioctl_giwnickn(struct net_device 
 			 struct iw_request_info *info,
 			 struct iw_point *data, char *nickname)
 {
-#ifndef RT30xx
-	PRTMP_ADAPTER 	pAdapter = NULL;
-	VIRTUAL_ADAPTER *pVirtualAd = NULL;
-
-	if (dev->priv_flags == INT_MAIN)
-	{
-		pAdapter = dev->ml_priv;
-	}
-	else
-	{
-		pVirtualAd = dev->ml_priv;
-		if (pVirtualAd && pVirtualAd->RtmpDev)
-			pAdapter = pVirtualAd->RtmpDev->ml_priv;
-	}
-
-	if (pAdapter == NULL)
-	{
-		/* if 1st open fail, pAd will be free;
-		   So the net_dev->ml_priv will be NULL in 2rd open */
-		return -ENETDOWN;
-	}
-#endif
-#ifdef RT30xx
 	PRTMP_ADAPTER pAdapter = dev->ml_priv;
-#endif
 
 	if (data->length > strlen(pAdapter->nickname) + 1)
 		data->length = strlen(pAdapter->nickname) + 1;
@@ -1550,31 +1400,7 @@ int rt_ioctl_giwrts(struct net_device *d
 		       struct iw_request_info *info,
 		       struct iw_param *rts, char *extra)
 {
-#ifndef RT30xx
-	PRTMP_ADAPTER 	pAdapter = NULL;
-	VIRTUAL_ADAPTER *pVirtualAd = NULL;
-
-	if (dev->priv_flags == INT_MAIN)
-	{
-		pAdapter = dev->ml_priv;
-	}
-	else
-	{
-		pVirtualAd = dev->ml_priv;
-		if (pVirtualAd && pVirtualAd->RtmpDev)
-			pAdapter = pVirtualAd->RtmpDev->ml_priv;
-	}
-
-	if (pAdapter == NULL)
-	{
-		/* if 1st open fail, pAd will be free;
-		   So the net_dev->ml_priv will be NULL in 2rd open */
-		return -ENETDOWN;
-	}
-#endif
-#ifdef RT30xx
 	PRTMP_ADAPTER pAdapter = dev->ml_priv;
-#endif
 
 	//check if the interface is down
     	if(!RTMP_TEST_FLAG(pAdapter, fRTMP_ADAPTER_INTERRUPT_IN_USE))
@@ -1621,31 +1447,7 @@ int rt_ioctl_giwfrag(struct net_device *
 			struct iw_request_info *info,
 			struct iw_param *frag, char *extra)
 {
-#ifndef RT30xx
-	PRTMP_ADAPTER 	pAdapter = NULL;
-	VIRTUAL_ADAPTER *pVirtualAd = NULL;
-
-	if (dev->priv_flags == INT_MAIN)
-	{
-		pAdapter = dev->ml_priv;
-	}
-	else
-	{
-		pVirtualAd = dev->ml_priv;
-		if (pVirtualAd && pVirtualAd->RtmpDev)
-			pAdapter = pVirtualAd->RtmpDev->ml_priv;
-	}
-
-	if (pAdapter == NULL)
-	{
-		/* if 1st open fail, pAd will be free;
-		   So the net_dev->ml_priv will be NULL in 2rd open */
-		return -ENETDOWN;
-	}
-#endif
-#ifdef RT30xx
 	PRTMP_ADAPTER pAdapter = dev->ml_priv;
-#endif
 
 	//check if the interface is down
     	if(!RTMP_TEST_FLAG(pAdapter, fRTMP_ADAPTER_INTERRUPT_IN_USE))
@@ -1781,32 +1583,8 @@ rt_ioctl_giwencode(struct net_device *de
 			  struct iw_request_info *info,
 			  struct iw_point *erq, char *key)
 {
-#ifdef RT30xx
 	PRTMP_ADAPTER pAdapter = dev->ml_priv;
-#endif
 	int kid;
-#ifndef RT30xx
-	PRTMP_ADAPTER 	pAdapter = NULL;
-	VIRTUAL_ADAPTER *pVirtualAd = NULL;
-
-	if (dev->priv_flags == INT_MAIN)
-	{
-		pAdapter = dev->ml_priv;
-	}
-	else
-	{
-		pVirtualAd = dev->ml_priv;
-		if (pVirtualAd && pVirtualAd->RtmpDev)
-			pAdapter = pVirtualAd->RtmpDev->ml_priv;
-	}
-
-	if (pAdapter == NULL)
-	{
-		/* if 1st open fail, pAd will be free;
-		   So the net_dev->ml_priv will be NULL in 2rd open */
-		return -ENETDOWN;
-	}
-#endif
 
 	//check if the interface is down
 	if(!RTMP_TEST_FLAG(pAdapter, fRTMP_ADAPTER_INTERRUPT_IN_USE))
@@ -1863,31 +1641,12 @@ static int
 rt_ioctl_setparam(struct net_device *dev, struct iw_request_info *info,
 			 void *w, char *extra)
 {
-    VIRTUAL_ADAPTER	*pVirtualAd = NULL;
-	PRTMP_ADAPTER pAdapter;
-	POS_COOKIE pObj;
+	PRTMP_ADAPTER pAdapter = dev->ml_priv;
+	POS_COOKIE pObj = (POS_COOKIE)pAdapter->OS_Cookie;
 	char *this_char = extra;
 	char *value;
 	int  Status=0;
 
-	if (dev->priv_flags == INT_MAIN)
-	{
-		pAdapter = dev->ml_priv;
-	}
-	else
-	{
-		pVirtualAd = dev->ml_priv;
-		pAdapter = pVirtualAd->RtmpDev->ml_priv;
-	}
-	pObj = (POS_COOKIE) pAdapter->OS_Cookie;
-
-	if (pAdapter == NULL)
-	{
-		/* if 1st open fail, pAd will be free;
-		   So the net_dev->ml_priv will be NULL in 2rd open */
-		return -ENETDOWN;
-	}
-
 	{
 		pObj->ioctl_if_type = INT_MAIN;
         pObj->ioctl_if = MAIN_MBSSID;
@@ -2031,27 +1790,10 @@ rt_private_show(struct net_device *dev, 
 		struct iw_point *wrq, char *extra)
 {
     INT				Status = 0;
-    VIRTUAL_ADAPTER	*pVirtualAd = NULL;
-    PRTMP_ADAPTER   pAd;
-	POS_COOKIE		pObj;
+    PRTMP_ADAPTER pAd = dev->ml_priv;
+    POS_COOKIE pObj = (POS_COOKIE) pAd->OS_Cookie;
     u32             subcmd = wrq->flags;
 
-	if (dev->priv_flags == INT_MAIN)
-		pAd = dev->ml_priv;
-	else
-	{
-		pVirtualAd = dev->ml_priv;
-		pAd = pVirtualAd->RtmpDev->ml_priv;
-	}
-	pObj = (POS_COOKIE) pAd->OS_Cookie;
-
-	if (pAd == NULL)
-	{
-		/* if 1st open fail, pAd will be free;
-		   So the net_dev->ml_priv will be NULL in 2rd open */
-		return -ENETDOWN;
-	}
-
     if (extra == NULL)
     {
         wrq->length = 0;
@@ -5017,32 +4759,13 @@ INT rt28xx_sta_ioctl(
 	IN	OUT	struct ifreq	*rq,
 	IN	INT					cmd)
 {
-	POS_COOKIE			pObj;
-	VIRTUAL_ADAPTER		*pVirtualAd = NULL;
-	RTMP_ADAPTER        *pAd = NULL;
+	RTMP_ADAPTER *pAd = net_dev->ml_priv;
+	POS_COOKIE pObj = (POS_COOKIE)pAd->OS_Cookie;
 	struct iwreq        *wrq = (struct iwreq *) rq;
 	BOOLEAN				StateMachineTouched = FALSE;
 	INT					Status = NDIS_STATUS_SUCCESS;
 	USHORT				subcmd;
 
-	if (net_dev->priv_flags == INT_MAIN)
-	{
-		pAd = net_dev->ml_priv;
-	}
-	else
-	{
-		pVirtualAd = net_dev->ml_priv;
-		pAd = pVirtualAd->RtmpDev->ml_priv;
-	}
-	pObj = (POS_COOKIE) pAd->OS_Cookie;
-
-	if (pAd == NULL)
-	{
-		/* if 1st open fail, pAd will be free;
-		   So the net_dev->ml_priv will be NULL in 2rd open */
-		return -ENETDOWN;
-	}
-
     //check if the interface is down
     if(!RTMP_TEST_FLAG(pAd, fRTMP_ADAPTER_INTERRUPT_IN_USE))
     {
