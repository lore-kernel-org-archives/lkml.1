Return-Path: <linux-kernel-owner+w=401wt.eu-S1758044AbZJSX7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758044AbZJSX7c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 19:59:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755913AbZJSX7c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 19:59:32 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:44748 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755889AbZJSX7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 19:59:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xSWKvryVKL+S5QsBSXQU6Q89yB6HXQGVEB8+8x0HFDrNHpC97fQN+ofZri5AaHVt8X
         A+jthun21aLTOP/Hgpyyluey1i5fy0a98zLbHVPGc7MSccga/i3dvdDafgnlumHGQ/Av
         etyDtxJ4URh6getX2HutbBVTqvhOLcWlJTMgw=
Date: Tue, 20 Oct 2009 04:01:21 +0400
From: Paul Fertser <fercerpav@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
       linux-kernel@vger.kernel.org,
       Nelson Castillo <arhuaco@freaks-unidos.net>,
       Balaji Rao <balajirrao@openmoko.org>
Subject: Re: [PATCH] power: pcf50633: introduces battery charging current
	control
Message-ID: <20091020000121.GC19580@home.pavel.comp>
References: <1255471148-29047-1-git-send-email-fercerpav@gmail.com> <1255471148-29047-2-git-send-email-fercerpav@gmail.com> <20091017170124.GB1526@ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="BwCQnh7xodEAoBMC"
Content-Disposition: inline
In-Reply-To: <20091017170124.GB1526@ucw.cz>
User-Agent: Mutt/1.5.17 (2007-11-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BwCQnh7xodEAoBMC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

Pavel, thanks for you review.

On Sat, Oct 17, 2009 at 07:01:24PM +0200, Pavel Machek wrote:
> > From: Balaji Rao <balajirrao@openmoko.org>
> 
> Could we get some changelog here? Like 'it adds new file to sysfs
> interface, ...'

Done.

> > +static ssize_t
> > +show_chglim(struct device *dev, struct device_attribute *attr, char *buf)
> 
> Could we get meaningful function names?

Well, this function name is derived from the sysfs attribute name and
since we already have "usb_curlim" sysfs attribute and corresponding
functions show_usblim() and set_usblim() it might be beneficial to
keep the driver code consistent. I now documented the attribute
behaviour in the code in the hope that users will look it up if in
doubt.

> > @@ -31,6 +31,8 @@ struct pcf50633_platform_data {
> >  
> >  	int charging_restart_interval;
> >  
> > +	int chg_ref_current_ma;
> > +
> 
> ...and variable names? This is also inconsistent with name above.

I added a comment explaining what this value is supposed to be set
to. The name is borrowed directly from the datasheet where it is
called "charger reference current". I hope this is ok.

Please find the new patch attached.

NB: Anton, if you apply this modified version, a new comment in
include/linux/mfd/pcf50633/core.h will produce a trivial merge
conflict with the later patch ("get rid of charging restart software
auto-triggering"). I can resend the whole series for your convenience
after everything else is sorted out if you prefer.

-- 
Be free, use free (http://www.gnu.org/philosophy/free-sw.html) software!
mailto:fercerpav@gmail.com

--BwCQnh7xodEAoBMC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-power-pcf50633-introduces-battery-charging-current.patch"

>From 06206380d4d200371d5da118a6b5ded0105c808e Mon Sep 17 00:00:00 2001
From: Balaji Rao <balajirrao@openmoko.org>
Date: Thu, 29 Jan 2009 15:00:37 +0000
Subject: [PATCH v2] power: pcf50633: introduces battery charging current control

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
index 48e92c0..b789f5b 100644
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
 
@@ -157,9 +179,55 @@ static ssize_t set_usblim(struct device *dev,
 
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
index 9aba7b7..ec9d3de 100644
--- a/include/linux/mfd/pcf50633/core.h
+++ b/include/linux/mfd/pcf50633/core.h
@@ -31,6 +31,13 @@ struct pcf50633_platform_data {
 
 	int charging_restart_interval;
 
+	/*
+	 * Should be set according to the reference resistor used, see
+	 * I_{ch(ref)} charger reference current in the pcf50633 User
+	 * Manual.
+	 */
+	int chg_ref_current_ma;
+
 	/* Callbacks */
 	void (*probe_done)(struct pcf50633 *);
 	void (*mbc_event_callback)(struct pcf50633 *, int);
-- 
1.6.0.6


--BwCQnh7xodEAoBMC--
