Return-Path: <linux-kernel-owner+w=401wt.eu-S932683AbZKDV0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932683AbZKDV0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 16:26:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932668AbZKDV0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 16:26:17 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:61407 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758208AbZKDV0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 16:26:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=wSWMlmQo7G/BsKwlPG51mljvNLYFOwwGUvurTe/OBaS6oK5qDz2swGdHRWcoYILQEc
         AIYb1YjNlbeBecBifPKpK01ePD/ExRPEOvykhzsWhg7u8ikWFgfgmnZ2yZUZryaoY0rB
         qHX8mchUsHHmhuIgMqXXnZ6IUfqdcBYsaG6LA=
From: Paul Fertser <fercerpav@gmail.com>
To: Anton Vorontsov <cbou@mail.ru>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>, Paul Fertser <fercerpav@gmail.com>
Subject: [PATCH 6/6] power: pcf50633: query charger status directly
Date: Thu,  5 Nov 2009 00:24:59 +0300
Message-Id: <1257369899-325-6-git-send-email-fercerpav@gmail.com>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <1257369899-325-5-git-send-email-fercerpav@gmail.com>
References: <1257369899-325-1-git-send-email-fercerpav@gmail.com>
 <1257369899-325-2-git-send-email-fercerpav@gmail.com>
 <1257369899-325-3-git-send-email-fercerpav@gmail.com>
 <1257369899-325-4-git-send-email-fercerpav@gmail.com>
 <1257369899-325-5-git-send-email-fercerpav@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current scheme is fragile and is likely to go off sync, especially on
batfull->adapter charging automatic MBC transition.

Query the status bit every time we need it instead.

We need to export another function to query for USB presence because
we can't read anything from PCF50633 (via I2C) inside irq context and
that is needed by usb gadgets.

Signed-off-by: Paul Fertser <fercerpav@gmail.com>
---
 drivers/power/pcf50633-charger.c |   50 ++++++++++++++++++++++----------------
 include/linux/mfd/pcf50633/mbc.h |    1 +
 2 files changed, 30 insertions(+), 21 deletions(-)

diff --git a/drivers/power/pcf50633-charger.c b/drivers/power/pcf50633-charger.c
index 4718733..b915a00 100644
--- a/drivers/power/pcf50633-charger.c
+++ b/drivers/power/pcf50633-charger.c
@@ -29,9 +29,7 @@
 struct pcf50633_mbc {
 	struct pcf50633 *pcf;
 
-	int adapter_active;
 	int adapter_online;
-	int usb_active;
 	int usb_online;
 
 	struct power_supply usb;
@@ -88,7 +86,7 @@ int pcf50633_mbc_usb_curlim_set(struct pcf50633 *pcf, int ma)
 		pcf50633_reg_write(mbc->pcf, PCF50633_REG_MBCC5, mbcc5);
 	}
 
-	mbcs2 = pcf50633_reg_read(pcf, PCF50633_REG_MBCS2);
+	mbcs2 = pcf50633_reg_read(mbc->pcf, PCF50633_REG_MBCS2);
 	chgmod = (mbcs2 & PCF50633_MBCS2_MBC_MASK);
 
 	/* If chgmod == BATFULL, setting chgena has no effect.
@@ -105,8 +103,6 @@ int pcf50633_mbc_usb_curlim_set(struct pcf50633 *pcf, int ma)
 				PCF50633_MBCC1_CHGENA, PCF50633_MBCC1_CHGENA);
 	}
 
-	mbc->usb_active = charging_start;
-
 	power_supply_changed(&mbc->usb);
 
 	return ret;
@@ -117,20 +113,44 @@ int pcf50633_mbc_get_status(struct pcf50633 *pcf)
 {
 	struct pcf50633_mbc *mbc  = platform_get_drvdata(pcf->mbc_pdev);
 	int status = 0;
+	u8 chgmod;
+
+	if (!mbc)
+		return 0;
+
+	chgmod = pcf50633_reg_read(mbc->pcf, PCF50633_REG_MBCS2)
+		& PCF50633_MBCS2_MBC_MASK;
 
 	if (mbc->usb_online)
 		status |= PCF50633_MBC_USB_ONLINE;
-	if (mbc->usb_active)
+	if (chgmod == PCF50633_MBCS2_MBC_USB_PRE ||
+	    chgmod == PCF50633_MBCS2_MBC_USB_PRE_WAIT ||
+	    chgmod == PCF50633_MBCS2_MBC_USB_FAST ||
+	    chgmod == PCF50633_MBCS2_MBC_USB_FAST_WAIT)
 		status |= PCF50633_MBC_USB_ACTIVE;
 	if (mbc->adapter_online)
 		status |= PCF50633_MBC_ADAPTER_ONLINE;
-	if (mbc->adapter_active)
+	if (chgmod == PCF50633_MBCS2_MBC_ADP_PRE ||
+	    chgmod == PCF50633_MBCS2_MBC_ADP_PRE_WAIT ||
+	    chgmod == PCF50633_MBCS2_MBC_ADP_FAST ||
+	    chgmod == PCF50633_MBCS2_MBC_ADP_FAST_WAIT)
 		status |= PCF50633_MBC_ADAPTER_ACTIVE;
 
 	return status;
 }
 EXPORT_SYMBOL_GPL(pcf50633_mbc_get_status);
 
+int pcf50633_mbc_get_usb_online_status(struct pcf50633 *pcf)
+{
+	struct pcf50633_mbc *mbc  = platform_get_drvdata(pcf->mbc_pdev);
+
+	if (!mbc)
+		return 0;
+
+	return mbc->usb_online;
+}
+EXPORT_SYMBOL_GPL(pcf50633_mbc_get_usb_online_status);
+
 static ssize_t
 show_chgmode(struct device *dev, struct device_attribute *attr, char *buf)
 {
@@ -248,26 +268,14 @@ pcf50633_mbc_irq_handler(int irq, void *data)
 		mbc->usb_online = 1;
 	} else if (irq == PCF50633_IRQ_USBREM) {
 		mbc->usb_online = 0;
-		mbc->usb_active = 0;
 		pcf50633_mbc_usb_curlim_set(mbc->pcf, 0);
 	}
 
 	/* Adapter */
-	if (irq == PCF50633_IRQ_ADPINS) {
+	if (irq == PCF50633_IRQ_ADPINS)
 		mbc->adapter_online = 1;
-		mbc->adapter_active = 1;
-	} else if (irq == PCF50633_IRQ_ADPREM) {
+	else if (irq == PCF50633_IRQ_ADPREM)
 		mbc->adapter_online = 0;
-		mbc->adapter_active = 0;
-	}
-
-	if (irq == PCF50633_IRQ_BATFULL) {
-		mbc->usb_active = 0;
-		mbc->adapter_active = 0;
-	} else if (irq == PCF50633_IRQ_USBLIMON)
-		mbc->usb_active = 0;
-	else if (irq == PCF50633_IRQ_USBLIMOFF)
-		mbc->usb_active = 1;
 
 	power_supply_changed(&mbc->ac);
 	power_supply_changed(&mbc->usb);
diff --git a/include/linux/mfd/pcf50633/mbc.h b/include/linux/mfd/pcf50633/mbc.h
index 4119579..df4f5fa 100644
--- a/include/linux/mfd/pcf50633/mbc.h
+++ b/include/linux/mfd/pcf50633/mbc.h
@@ -128,6 +128,7 @@ enum pcf50633_reg_mbcs3 {
 int pcf50633_mbc_usb_curlim_set(struct pcf50633 *pcf, int ma);
 
 int pcf50633_mbc_get_status(struct pcf50633 *);
+int pcf50633_mbc_get_usb_online_status(struct pcf50633 *);
 
 #endif
 
-- 
1.6.4.4

