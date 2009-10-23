Return-Path: <linux-kernel-owner+w=401wt.eu-S1751504AbZJWMpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751504AbZJWMpi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 08:45:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751385AbZJWMpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 08:45:38 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:61678 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbZJWMph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 08:45:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=H/UjBPy7gzuyvTcZWSEu9WDbTiRm3y69GF6RJz4P3gYo0QCDz6bo2Ps74cswBs2E4j
         VUouv53Gkw1AostbI8/tGUKSZT+8Nc3x21T+ZMxLm/lB6Z7hQIytFSg4zGIe8CNV+3Xl
         dGe59Hu2PQljQrbzEiwm69Cs1zLiesiwkd2aQ=
Message-ID: <4AE1A7DD.5000107@gmail.com>
Date: Fri, 23 Oct 2009 14:55:57 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Staging: Cleanup redundant tests on unsigned
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The variables are unsigned so the test `>= 0' is always true,
the `< 0' test always fails. In these cases the other part of
the test catches wrapped values.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/staging/comedi/comedi_fops.c     |    4 +-
 drivers/staging/go7007/go7007-v4l2.c     |    2 +-
 drivers/staging/rt2860/common/cmm_info.c |   37 ++++++++++-------------------
 drivers/staging/rt3090/common/cmm_info.c |    8 +++---
 drivers/staging/usbip/vhci_sysfs.c       |    2 +-
 5 files changed, 21 insertions(+), 32 deletions(-)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index aaad76e..8425806 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -300,7 +300,7 @@ static int do_bufconfig_ioctl(struct comedi_device *dev, void *arg)
 	if (copy_from_user(&bc, arg, sizeof(struct comedi_bufconfig)))
 		return -EFAULT;
 
-	if (bc.subdevice >= dev->n_subdevices || bc.subdevice < 0)
+	if (bc.subdevice >= dev->n_subdevices)
 		return -EINVAL;
 
 	s = dev->subdevices + bc.subdevice;
@@ -556,7 +556,7 @@ static int do_bufinfo_ioctl(struct comedi_device *dev, void *arg)
 	if (copy_from_user(&bi, arg, sizeof(struct comedi_bufinfo)))
 		return -EFAULT;
 
-	if (bi.subdevice >= dev->n_subdevices || bi.subdevice < 0)
+	if (bi.subdevice >= dev->n_subdevices)
 		return -EINVAL;
 
 	s = dev->subdevices + bi.subdevice;
diff --git a/drivers/staging/go7007/go7007-v4l2.c b/drivers/staging/go7007/go7007-v4l2.c
index 4bd353a..2e20a6a 100644
--- a/drivers/staging/go7007/go7007-v4l2.c
+++ b/drivers/staging/go7007/go7007-v4l2.c
@@ -809,7 +809,7 @@ static int vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
 		return retval;
 
 	mutex_lock(&gofh->lock);
-	if (buf->index < 0 || buf->index >= gofh->buf_count)
+	if (buf->index >= gofh->buf_count)
 		goto unlock_and_return;
 
 	gobuf = &gofh->bufs[buf->index];
diff --git a/drivers/staging/rt2860/common/cmm_info.c b/drivers/staging/rt2860/common/cmm_info.c
index 019cc44..7b9f929 100644
--- a/drivers/staging/rt2860/common/cmm_info.c
+++ b/drivers/staging/rt2860/common/cmm_info.c
@@ -249,22 +249,16 @@ INT Set_CountryRegion_Proc(
 	region = simple_strtol(arg, 0, 10);
 
 	// Country can be set only when EEPROM not programmed
-	if (pAd->CommonCfg.CountryRegion & 0x80)
-	{
+	if (pAd->CommonCfg.CountryRegion & 0x80) {
 		DBGPRINT(RT_DEBUG_ERROR, ("Set_CountryRegion_Proc::parameter of CountryRegion in eeprom is programmed \n"));
 		return FALSE;
 	}
 
-	if((region >= 0) && (region <= REGION_MAXIMUM_BG_BAND))
-	{
+	if (region <= REGION_MAXIMUM_BG_BAND) {
 		pAd->CommonCfg.CountryRegion = (UCHAR) region;
-	}
-	else if (region == REGION_31_BG_BAND)
-	{
+	} else if (region == REGION_31_BG_BAND) {
 		pAd->CommonCfg.CountryRegion = (UCHAR) region;
-	}
-	else
-	{
+	} else {
 		DBGPRINT(RT_DEBUG_ERROR, ("Set_CountryRegion_Proc::parameters out of range\n"));
 		return FALSE;
 	}
@@ -295,18 +289,14 @@ INT Set_CountryRegionABand_Proc(
 	region = simple_strtol(arg, 0, 10);
 
 	// Country can be set only when EEPROM not programmed
-	if (pAd->CommonCfg.CountryRegionForABand & 0x80)
-	{
+	if (pAd->CommonCfg.CountryRegionForABand & 0x80) {
 		DBGPRINT(RT_DEBUG_ERROR, ("Set_CountryRegionABand_Proc::parameter of CountryRegion in eeprom is programmed \n"));
 		return FALSE;
 	}
 
-	if((region >= 0) && (region <= REGION_MAXIMUM_A_BAND))
-	{
+	if (region <= REGION_MAXIMUM_A_BAND) {
 		pAd->CommonCfg.CountryRegionForABand = (UCHAR) region;
-	}
-	else
-	{
+	} else {
 		DBGPRINT(RT_DEBUG_ERROR, ("Set_CountryRegionABand_Proc::parameters out of range\n"));
 		return FALSE;
 	}
@@ -2194,13 +2184,13 @@ INT	Set_HtMcs_Proc(
 			(pAd->MacTab.Content[BSSID_WCID].HTPhyMode.field.MODE < MODE_HTMIX))
 		{
 	        if ((pAd->StaCfg.DesiredTransmitSetting.field.MCS != MCS_AUTO) &&
-				(HtMcs >= 0 && HtMcs <= 3) &&
+				(HtMcs <= 3) &&
 	            (pAd->StaCfg.DesiredTransmitSetting.field.FixedTxMode == FIXED_TXMODE_CCK))
 			{
 				RTMPSetDesiredRates(pAd, (LONG) (RateIdToMbps[HtMcs] * 1000000));
 			}
 	        else if ((pAd->StaCfg.DesiredTransmitSetting.field.MCS != MCS_AUTO) &&
-					(HtMcs >= 0 && HtMcs <= 7) &&
+					(HtMcs <= 7) &&
 	            	(pAd->StaCfg.DesiredTransmitSetting.field.FixedTxMode == FIXED_TXMODE_OFDM))
 			{
 				RTMPSetDesiredRates(pAd, (LONG) (RateIdToMbps[HtMcs+4] * 1000000));
@@ -2255,10 +2245,9 @@ INT	Set_HtTxBASize_Proc(
 
 	Size = simple_strtol(arg, 0, 10);
 
-	if (Size <=0 || Size >=64)
-	{
+	if (Size == 0 || Size >= 64)
 		Size = 8;
-	}
+
 	pAd->CommonCfg.TxBASize = Size-1;
 	DBGPRINT(RT_DEBUG_ERROR, ("Set_HtTxBASize ::(TxBASize= %d)\n", Size));
 
@@ -2364,7 +2353,7 @@ INT	Set_HtMpduDensity_Proc(
 
 	Value = simple_strtol(arg, 0, 10);
 
-	if (Value <=7 && Value >= 0)
+	if (Value <= 7)
 		pAd->CommonCfg.BACapability.field.MpduDensity = Value;
 	else
 		pAd->CommonCfg.BACapability.field.MpduDensity = 4;
@@ -2582,7 +2571,7 @@ INT	Set_HtMIMOPSmode_Proc(
 
 	Value = simple_strtol(arg, 0, 10);
 
-	if (Value <=3 && Value >= 0)
+	if (Value <= 3)
 		pAd->CommonCfg.BACapability.field.MMPSmode = Value;
 	else
 		pAd->CommonCfg.BACapability.field.MMPSmode = 3;
diff --git a/drivers/staging/rt3090/common/cmm_info.c b/drivers/staging/rt3090/common/cmm_info.c
index 3e51e98..c710f85 100644
--- a/drivers/staging/rt3090/common/cmm_info.c
+++ b/drivers/staging/rt3090/common/cmm_info.c
@@ -2548,13 +2548,13 @@ INT	Set_HtMcs_Proc(
 			(pAd->MacTab.Content[BSSID_WCID].HTPhyMode.field.MODE < MODE_HTMIX))
 		{
 	        if ((pAd->StaCfg.DesiredTransmitSetting.field.MCS != MCS_AUTO) &&
-				(HtMcs >= 0 && HtMcs <= 3) &&
+				(HtMcs <= 3) &&
 	            (pAd->StaCfg.DesiredTransmitSetting.field.FixedTxMode == FIXED_TXMODE_CCK))
 			{
 				RTMPSetDesiredRates(pAd, (LONG) (RateIdToMbps[HtMcs] * 1000000));
 			}
 	        else if ((pAd->StaCfg.DesiredTransmitSetting.field.MCS != MCS_AUTO) &&
-					(HtMcs >= 0 && HtMcs <= 7) &&
+					(HtMcs <= 7) &&
 			(pAd->StaCfg.DesiredTransmitSetting.field.FixedTxMode == FIXED_TXMODE_OFDM))
 			{
 				RTMPSetDesiredRates(pAd, (LONG) (RateIdToMbps[HtMcs+4] * 1000000));
@@ -2741,7 +2741,7 @@ INT	Set_HtMpduDensity_Proc(
 
 	Value = simple_strtol(arg, 0, 10);
 
-	if (Value <=7 && Value >= 0)
+	if (Value <= 7)
 		pAd->CommonCfg.BACapability.field.MpduDensity = Value;
 	else
 		pAd->CommonCfg.BACapability.field.MpduDensity = 4;
@@ -2959,7 +2959,7 @@ INT	Set_HtMIMOPSmode_Proc(
 
 	Value = simple_strtol(arg, 0, 10);
 
-	if (Value <=3 && Value >= 0)
+	if (Value <= 3)
 		pAd->CommonCfg.BACapability.field.MMPSmode = Value;
 	else
 		pAd->CommonCfg.BACapability.field.MMPSmode = 3;
diff --git a/drivers/staging/usbip/vhci_sysfs.c b/drivers/staging/usbip/vhci_sysfs.c
index d8992d1..260be8a 100644
--- a/drivers/staging/usbip/vhci_sysfs.c
+++ b/drivers/staging/usbip/vhci_sysfs.c
@@ -134,7 +134,7 @@ static DEVICE_ATTR(detach, S_IWUSR, NULL, store_detach);
 static int valid_args(__u32 rhport, enum usb_device_speed speed)
 {
 	/* check rhport */
-	if ((rhport < 0) || (rhport >= VHCI_NPORTS)) {
+	if (rhport >= VHCI_NPORTS) {
 		usbip_uerr("port %u\n", rhport);
 		return -EINVAL;
 	}
