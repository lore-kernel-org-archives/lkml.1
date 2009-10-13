Return-Path: <linux-kernel-owner+w=401wt.eu-S1761483AbZJMWAE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761483AbZJMWAE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 18:00:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761475AbZJMWAD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 18:00:03 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:63881 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761473AbZJMWAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 18:00:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=aH2vYdeqNwtbl20ev8NfWiYRKQcTDOy8m9QMc1pb2B4kWcAAXmhTXrle3Q4JfZROsM
         i9sfq98dtBT5MwybUn/MC7lXJEvQwBRZftCIMCeUZQKNlIdYGYVVl+e5YPCzQJD/0zOs
         77c57OyKkoeJ4i8cNBmttrYQbXGCaMawVYaxA=
From: Paul Fertser <fercerpav@gmail.com>
To: Anton Vorontsov <cbou@mail.ru>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       Nelson Castillo <arhuaco@freaks-unidos.net>,
       Balaji Rao <balajirrao@openmoko.org>,
       Paul Fertser <fercerpav@gmail.com>
Subject: [PATCH] power: pcf50633: introduces battery charging current control
Date: Wed, 14 Oct 2009 01:59:04 +0400
Message-Id: <1255471148-29047-2-git-send-email-fercerpav@gmail.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1255471148-29047-1-git-send-email-fercerpav@gmail.com>
References: <1255471148-29047-1-git-send-email-fercerpav@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Balaji Rao <balajirrao@openmoko.org>

Signed-off-by: Balaji Rao <balajirrao@openmoko.org>
Signed-off-by: Paul Fertser <fercerpav@gmail.com>
---
 drivers/power/pcf50633-charger.c  |   73 ++++++++++++++++++++++++++++++++++---
 include/linux/mfd/pcf50633/core.h |    2 +
 2 files changed, 70 insertions(+), 5 deletions(-)

diff --git a/drivers/power/pcf50633-charger.c b/drivers/power/pcf50633-charger.c
index 48e92c0..13f2839 100644
--- a/drivers/power/pcf50633-charger.c
+++ b/drivers/power/pcf50633-charger.c
@@ -48,16 +48,21 @@ int pcf50633_mbc_usb_curlim_set(struct pcf50633 *pcf, int ma)
 	u8 bits;
 	int charging_start = 1;
 	u8 mbcs2, chgmod;
+	unsigned int mbcc5;
 
-	if (ma >= 1000)
+	if (ma >= 1000) {
 		bits = PCF50633_MBCC7_USB_1000mA;
-	else if (ma >= 500)
+		ma = 1000;
+	} else if (ma >= 500) {
 		bits = PCF50633_MBCC7_USB_500mA;
-	else if (ma >= 100)
+		ma = 500;
+	} else if (ma >= 100) {
 		bits = PCF50633_MBCC7_USB_100mA;
-	else {
+		ma = 100;
+	} else {
 		bits = PCF50633_MBCC7_USB_SUSPEND;
 		charging_start = 0;
+		ma = 0;
 	}
 
 	ret = pcf50633_reg_set_bit_mask(pcf, PCF50633_REG_MBCC7,
@@ -67,7 +72,24 @@ int pcf50633_mbc_usb_curlim_set(struct pcf50633 *pcf, int ma)
 	else
 		dev_info(pcf->dev, "usb curlim to %d mA\n", ma);
 
-	/* Manual charging start */
+	/*
+	 * We limit the charging current to be the USB current limit.
+	 * The reason is that on pcf50633, when it enters PMU Standby mode,
+	 * which it does when the device goes "off", the USB current limit
+	 * reverts to the variant default.  In at least one common case, that
+	 * default is 500mA.  By setting the charging current to be the same
+	 * as the USB limit we set here before PMU standby, we enforce it only
+	 * using the correct amount of current even when the USB current limit
+	 * gets reset to the wrong thing
+	 */
+
+	if (mbc->pcf->pdata->chg_ref_current_ma) {
+		mbcc5 = (ma << 8) / mbc->pcf->pdata->chg_ref_current_ma;
+		if (mbcc5 > 255)
+			mbcc5 = 255;
+		pcf50633_reg_write(mbc->pcf, PCF50633_REG_MBCC5, mbcc5);
+	}
+
 	mbcs2 = pcf50633_reg_read(pcf, PCF50633_REG_MBCS2);
 	chgmod = (mbcs2 & PCF50633_MBCS2_MBC_MASK);
 
@@ -157,9 +179,50 @@ static ssize_t set_usblim(struct device *dev,
 
 static DEVICE_ATTR(usb_curlim, S_IRUGO | S_IWUSR, show_usblim, set_usblim);
 
+static ssize_t
+show_chglim(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct pcf50633_mbc *mbc = dev_get_drvdata(dev);
+	u8 mbcc5 = pcf50633_reg_read(mbc->pcf, PCF50633_REG_MBCC5);
+	unsigned int ma;
+
+	if (!mbc->pcf->pdata->chg_ref_current_ma)
+		return -ENODEV;
+
+	ma = (mbc->pcf->pdata->chg_ref_current_ma *  mbcc5) >> 8;
+
+	return sprintf(buf, "%u\n", ma);
+}
+
+static ssize_t set_chglim(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct pcf50633_mbc *mbc = dev_get_drvdata(dev);
+	unsigned long ma;
+	unsigned int mbcc5;
+	int ret;
+
+	if (!mbc->pcf->pdata->chg_ref_current_ma)
+		return -ENODEV;
+
+	ret = strict_strtoul(buf, 10, &ma);
+	if (ret)
+		return -EINVAL;
+
+	mbcc5 = (ma << 8) / mbc->pcf->pdata->chg_ref_current_ma;
+	if (mbcc5 > 255)
+		mbcc5 = 255;
+	pcf50633_reg_write(mbc->pcf, PCF50633_REG_MBCC5, mbcc5);
+
+	return count;
+}
+
+static DEVICE_ATTR(chg_curlim, S_IRUGO | S_IWUSR, show_chglim, set_chglim);
+
 static struct attribute *pcf50633_mbc_sysfs_entries[] = {
 	&dev_attr_chgmode.attr,
 	&dev_attr_usb_curlim.attr,
+	&dev_attr_chg_curlim.attr,
 	NULL,
 };
 
diff --git a/include/linux/mfd/pcf50633/core.h b/include/linux/mfd/pcf50633/core.h
index 9aba7b7..222dd90 100644
--- a/include/linux/mfd/pcf50633/core.h
+++ b/include/linux/mfd/pcf50633/core.h
@@ -31,6 +31,8 @@ struct pcf50633_platform_data {
 
 	int charging_restart_interval;
 
+	int chg_ref_current_ma;
+
 	/* Callbacks */
 	void (*probe_done)(struct pcf50633 *);
 	void (*mbc_event_callback)(struct pcf50633 *, int);
-- 
1.6.0.6

