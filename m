Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205Ab0CHNkL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 08:40:11 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:63236 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab0CHNkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 08:40:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=XgVjQhgiXjmOZBndho4aV60fQ8iZq02fSjjd3kOtJiPYiQrMWxbK8SIEw4ksEGq7Ui
         lCCCI/rCSlTeZQJCTCTkLYDbHrKrVp65agtMjbmCKaALSbU2UJfzrc1qEmGomTiSm9V7
         WUfCX9NT8hL/Y0Rys5eTTDd5dcExURUejiF+0=
Date: Mon, 8 Mar 2010 16:39:24 +0300
From: Dan Carpenter <error27@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] rt2860: off by one errors
Message-ID: <20100308133923.GA18477@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code is trying to say that if the offset is higher than the max it 
should be set to the max, but there is an off by one bug and it sets it 
one passed the end of the array.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/staging/rt2860/sta_ioctl.c b/drivers/staging/rt2860/sta_ioctl.c
index de4b627..33a6939 100644
--- a/drivers/staging/rt2860/sta_ioctl.c
+++ b/drivers/staging/rt2860/sta_ioctl.c
@@ -1047,8 +1047,7 @@ int rt_ioctl_giwscan(struct net_device *dev,
 			if (tmpRate == 0x6c
 			    && pAdapter->ScanTab.BssEntry[i].HtCapabilityLen >
 			    0) {
-				int rate_count =
-				    sizeof(ralinkrate) / sizeof(__s32);
+				int rate_count = ARRAY_SIZE(ralinkrate);
 				struct rt_ht_cap_info capInfo =
 				    pAdapter->ScanTab.BssEntry[i].HtCapability.
 				    HtCapInfo;
@@ -1061,10 +1060,11 @@ int rt_ioctl_giwscan(struct net_device *dev,
 				int rate_index =
 				    12 + ((u8)capInfo.ChannelWidth * 24) +
 				    ((u8)shortGI * 48) + ((u8)maxMCS);
+
 				if (rate_index < 0)
 					rate_index = 0;
-				if (rate_index > rate_count)
-					rate_index = rate_count;
+				if (rate_index >= rate_count)
+					rate_index = rate_count - 1;
 				iwe.u.bitrate.value =
 				    ralinkrate[rate_index] * 500000;
 			}
@@ -2338,7 +2338,7 @@ int rt_ioctl_giwrate(struct net_device *dev,
 */
 	GET_PAD_FROM_NET_DEV(pAd, dev);
 
-	rate_count = sizeof(ralinkrate) / sizeof(__s32);
+	rate_count = ARRAY_SIZE(ralinkrate);
 	/*check if the interface is down */
 	if (!RTMP_TEST_FLAG(pAd, fRTMP_ADAPTER_INTERRUPT_IN_USE)) {
 		DBGPRINT(RT_DEBUG_TRACE, ("INFO::Network is down!\n"));
@@ -2369,8 +2369,8 @@ int rt_ioctl_giwrate(struct net_device *dev,
 	if (rate_index < 0)
 		rate_index = 0;
 
-	if (rate_index > rate_count)
-		rate_index = rate_count;
+	if (rate_index >= rate_count)
+		rate_index = rate_count - 1;
 
 	wrqu->bitrate.value = ralinkrate[rate_index] * 500000;
 	wrqu->bitrate.disabled = 0;
