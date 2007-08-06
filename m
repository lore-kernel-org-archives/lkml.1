Return-Path: <linux-kernel-owner+w=401wt.eu-S932479AbXHFTDL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932479AbXHFTDL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 15:03:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753472AbXHFTC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 15:02:57 -0400
Received: from mx0.towertech.it ([213.215.222.73]:55451 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754689AbXHFTC4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 15:02:56 -0400
Date: Mon, 6 Aug 2007 21:01:54 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: rtc-linux@googlegroups.com
Cc: hpa@zytor.com, Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eugene Teo <eugeneteo@kernel.sg>
Subject: Re: [rtc-linux] Re: rtc max frequency setting
Message-ID: <20070806210154.45ca4570@i1501.lan.towertech.it>
In-Reply-To: <46B5148E.50302@zytor.com>
References: <Pine.LNX.4.64.0708050042560.14443@fbirervta.pbzchgretzou.qr>
	<46B5148E.50302@zytor.com>
Organization: Tower Technologies
X-Mailer: Sylpheed
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 04 Aug 2007 17:06:38 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

> 
> Jan Engelhardt wrote:
> > Hi,
> > 
> > with the old rtc.ko module, there was a /proc/sys/dev/rtc/max-user-freq 
> > that could be set. With rtc_cmos.ko (or the new rtc infrastructure in 
> > general), I am missing this file. Where can I set the max-user-freq now, 
> > or is this obsolete now? (mplayer prefers to have user-freq to be >= 1024.)
> > 

 quick hack to set the maximum freq. I haven't tested t, just compiled.
 I'm not sure about simple_strtoul.

 please provide feedback ;)

---
 drivers/rtc/rtc-sysfs.c |   27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

--- linux-2.6.orig/drivers/rtc/rtc-sysfs.c	2007-08-06 20:34:12.000000000 +0200
+++ linux-2.6/drivers/rtc/rtc-sysfs.c	2007-08-06 20:50:03.000000000 +0200
@@ -73,11 +73,37 @@ rtc_sysfs_show_since_epoch(struct device
 	return retval;
 }
 
+static ssize_t
+rtc_sysfs_show_max_user_freq(struct device *dev, struct device_attribute *attr,
+		char *buf)
+{
+	struct rtc_device *rtc = to_rtc_device(dev);
+	return sprintf(buf, "%d\n", rtc->max_user_freq);
+}
+
+static ssize_t
+rtc_sysfs_set_max_user_freq(struct device *dev, struct device_attribute *attr,
+		const char *buf, size_t n)
+{
+	unsigned long w;
+	struct rtc_device *rtc = to_rtc_device(dev);
+
+	w = simple_strtoul(buf, NULL, 0);
+	if (is_power_of_2(w)) {
+		rtc->max_user_freq = w;
+		return n;
+	}
+
+	return -EINVAL;
+}
+
 static struct device_attribute rtc_attrs[] = {
 	__ATTR(name, S_IRUGO, rtc_sysfs_show_name, NULL),
 	__ATTR(date, S_IRUGO, rtc_sysfs_show_date, NULL),
 	__ATTR(time, S_IRUGO, rtc_sysfs_show_time, NULL),
 	__ATTR(since_epoch, S_IRUGO, rtc_sysfs_show_since_epoch, NULL),
+	__ATTR(max_user_freq, S_IRUGO | S_IWUSR, rtc_sysfs_show_max_user_freq,
+					rtc_sysfs_set_max_user_freq),
 	{ },
 };
 


-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

