Return-Path: <linux-kernel-owner+w=401wt.eu-S933660AbZIDQUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933660AbZIDQUG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 12:20:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932542AbZIDQUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 12:20:04 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:40751 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932771AbZIDQUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 12:20:01 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: a.zummo@towertech.it, rtc-linux@googlegroups.com,
       Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 2/2] rtc: Add boot_timesource sysfs attribute
Date: Fri,  4 Sep 2009 12:26:08 -0400
Message-Id: <1252081568-6000-2-git-send-email-mjg@redhat.com>
X-Mailer: git-send-email 1.6.4.1
In-Reply-To: <1252081568-6000-1-git-send-email-mjg@redhat.com>
References: <1252081568-6000-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 146.115.120.20
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_RTC_HCTOSYS allows the kernel to read the system time from the RTC
at boot and resume, avoiding the need for userspace to do so. Unfortunately
userspace currently has no way to know whether this configuration option
is enabled and thus cannot sensibly choose whether to run hwclock itself or
not. Add a boot_timesource sysfs attribute which indicates whether a given
RTC set the system clock.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 Documentation/rtc.txt   |    2 ++
 drivers/rtc/rtc-sysfs.c |   14 ++++++++++++++
 2 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/Documentation/rtc.txt b/Documentation/rtc.txt
index 216bb8c..a086cad 100644
--- a/Documentation/rtc.txt
+++ b/Documentation/rtc.txt
@@ -142,6 +142,8 @@ The sysfs interface under /sys/class/rtc/rtcN provides access to various
 rtc attributes without requiring the use of ioctls. All dates and times
 are in the RTC's timezone, rather than in system time.
 
+boot_timesource: 1 if the RTC provided the system time at boot via the
+		 CONFIG_RTC_HCTOSYS kernel option, 0 otherwise
 date:  	   	 RTC-provided date
 max_user_freq:	 The maximum interrupt rate an unprivileged user may request
 		 from this RTC.
diff --git a/drivers/rtc/rtc-sysfs.c b/drivers/rtc/rtc-sysfs.c
index 2531ce4..dbd6af8 100644
--- a/drivers/rtc/rtc-sysfs.c
+++ b/drivers/rtc/rtc-sysfs.c
@@ -102,6 +102,19 @@ rtc_sysfs_set_max_user_freq(struct device *dev, struct device_attribute *attr,
 	return n;
 }
 
+static ssize_t
+rtc_sysfs_show_hctosys(struct device *dev, struct device_attribute *attr,
+		char *buf)
+{
+#ifdef CONFIG_RTC_HCTOSYS_DEVICE
+	if (strcmp(dev_name(&to_rtc_device(dev)->dev),
+		   CONFIG_RTC_HCTOSYS_DEVICE) == 0)
+		return sprintf(buf, "1\n");
+	else
+#endif
+		return sprintf(buf, "0\n");
+}
+
 static struct device_attribute rtc_attrs[] = {
 	__ATTR(name, S_IRUGO, rtc_sysfs_show_name, NULL),
 	__ATTR(date, S_IRUGO, rtc_sysfs_show_date, NULL),
@@ -109,6 +122,7 @@ static struct device_attribute rtc_attrs[] = {
 	__ATTR(since_epoch, S_IRUGO, rtc_sysfs_show_since_epoch, NULL),
 	__ATTR(max_user_freq, S_IRUGO | S_IWUSR, rtc_sysfs_show_max_user_freq,
 			rtc_sysfs_set_max_user_freq),
+	__ATTR(boot_timesource, S_IRUGO, rtc_sysfs_show_hctosys, NULL),
 	{ },
 };
 
-- 
1.6.4.1

