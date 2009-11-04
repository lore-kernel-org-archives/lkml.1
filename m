Return-Path: <linux-kernel-owner+w=401wt.eu-S1758216AbZKDVZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758216AbZKDVZ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 16:25:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758189AbZKDVZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 16:25:57 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:61407 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758178AbZKDVZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 16:25:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=FJr3y56ThmI9ewaHWF2nldEvN8G4nrSZhvvHFbdX/xy5a2928SL7EaI0Y9IA0tvIDv
         yv1+FF+QLd8jJReecYNetYo0NBMP9RQVi3dMa0GNL6ScDMvrN6lBr9UF//7dzlBU1ShS
         A5rXuJbPxsXn/FXXBV6eOuDlpajkNszxdzp1A=
From: Paul Fertser <fercerpav@gmail.com>
To: Anton Vorontsov <cbou@mail.ru>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>, Balaji Rao <balajirrao@openmoko.org>,
       Paul Fertser <fercerpav@gmail.com>
Subject: [PATCH 2/6] power: pcf50633: introduces battery charging current control
Date: Thu,  5 Nov 2009 00:24:55 +0300
Message-Id: <1257369899-325-2-git-send-email-fercerpav@gmail.com>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <1257369899-325-1-git-send-email-fercerpav@gmail.com>
References: <1257369899-325-1-git-send-email-fercerpav@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Balaji Rao <balajirrao@openmoko.org>

Implement a new sysfs attribute to allow changing MBC charging limit on the
fly independently of usb current limit. It also gets set automatically
every time usb current limit is changed.

Limiting charging current also prevents violating USB specification in the
case when the whole device is shut down and usb current limit is reset to
the factory default by the pcf50633 state transition.

Signed-off-by: Balaji Rao <balajirrao@openmoko.org>
Signed-off-by: Paul Fertser <fercerpav@gmail.com>
---
 drivers/power/pcf50633-charger.c  |   78 ++++++++++++++++++++++++++++++++++--
 include/linux/mfd/pcf50633/core.h |    7 +++
 2 files changed, 80 insertions(+), 5 deletions(-)

diff --git a/drivers/power/pcf50633-charger.c b/drivers/power/pcf50633-charger.c
index 48e92c0..21b6e64 100644
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
+	if (mbc->pcf->pdata->charger_reference_current_ma) {
+		mbcc5 = (ma << 8) / mbc->pcf->pdata->charger_reference_current_ma;
+		if (mbcc5 > 255)
+			mbcc5 = 255;
+		pcf50633_reg_write(mbc->pcf, PCF50633_REG_MBCC5, mbcc5);
+	}
+
 	mbcs2 = pcf50633_reg_read(pcf, PCF50633_REG_MBCS2);
 	chgmod = (mbcs2 & PCF50633_MBCS2_MBC_MASK);
 
@@ -157,9 +179,55 @@ static ssize_t set_usblim(struct device *dev,
 
 static DEVICE_ATTR(usb_curlim, S_IRUGO | S_IWUSR, show_usblim, set_usblim);
 
+static ssize_t
+show_chglim(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct pcf50633_mbc *mbc = dev_get_drvdata(dev);
+	u8 mbcc5 = pcf50633_reg_read(mbc->pcf, PCF50633_REG_MBCC5);
+	unsigned int ma;
+
+	if (!mbc->pcf->pdata->charger_reference_current_ma)
+		return -ENODEV;
+
+	ma = (mbc->pcf->pdata->charger_reference_current_ma *  mbcc5) >> 8;
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
+	if (!mbc->pcf->pdata->charger_reference_current_ma)
+		return -ENODEV;
+
+	ret = strict_strtoul(buf, 10, &ma);
+	if (ret)
+		return -EINVAL;
+
+	mbcc5 = (ma << 8) / mbc->pcf->pdata->charger_reference_current_ma;
+	if (mbcc5 > 255)
+		mbcc5 = 255;
+	pcf50633_reg_write(mbc->pcf, PCF50633_REG_MBCC5, mbcc5);
+
+	return count;
+}
+
+/*
+ * This attribute allows to change MBC charging limit on the fly
+ * independently of usb current limit. It also gets set automatically every
+ * time usb current limit is changed.
+ */
+static DEVICE_ATTR(chg_curlim, S_IRUGO | S_IWUSR, show_chglim, set_chglim);
+
 static struct attribute *pcf50633_mbc_sysfs_entries[] = {
 	&dev_attr_chgmode.attr,
 	&dev_attr_usb_curlim.attr,
+	&dev_attr_chg_curlim.attr,
 	NULL,
 };
 
diff --git a/include/linux/mfd/pcf50633/core.h b/include/linux/mfd/pcf50633/core.h
index 9aba7b7..09af8fd 100644
--- a/include/linux/mfd/pcf50633/core.h
+++ b/include/linux/mfd/pcf50633/core.h
@@ -31,6 +31,13 @@ struct pcf50633_platform_data {
 
 	int charging_restart_interval;
 
+	/*
+	 * Should be set accordingly to the reference resistor used, see
+	 * I_{ch(ref)} charger reference current in the pcf50633 User
+	 * Manual.
+	 */
+	int charger_reference_current_ma;
+
 	/* Callbacks */
 	void (*probe_done)(struct pcf50633 *);
 	void (*mbc_event_callback)(struct pcf50633 *, int);
-- 
1.6.4.4

