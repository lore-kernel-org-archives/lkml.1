Return-Path: <linux-kernel-owner+w=401wt.eu-S1758000AbXK3WSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758000AbXK3WSd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 17:18:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754741AbXK3WS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 17:18:27 -0500
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:23496 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753130AbXK3WS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 17:18:26 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=abP7Y5KPfAwQDlfDRh6iFFHoqFfLGKVbhgdN85EG4yXQOLcmuxudfFzGTVMWT3etHafHfYUwHN8Iby2Hiz7H2z+1FSYYzobzF3vrSIGUQ592Bue5OuoP3RKQrxkB0+3UjCwoZ3t5px7PxumlWBttL2d91C3+iVXeVkiNgotFyG8=  ;
X-YMail-OSG: cZQJwuwVM1mgtv0Bg8q6vyQqI60iPatINX8MUC2bQbWO72_zuctra_jEP7HhqGzWNfZGKp.4uQ--
From: David Brownell <david-b@pacbell.net>
To: rtc-linux@googlegroups.com
Subject: [patch 2.6.24-rc3] rtc-cmos alarm acts as oneshot
Date: Fri, 30 Nov 2007 14:18:23 -0800
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711301418.24033.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Start making the rtc-cmos alarm act more like a oneshot alarm by disabling
that alarm after its IRQ fires.  (ACPI hooks are also needed.)

The Linux RTC framework has previously been a bit vague in this area,
but any other behavior is problematic and not very portable.  RTCs with
full YYYY-MM-DD HH:MM[:SS] alarms won't have a problem here.  Only ones
with partial match criteria, with the most visible example being the PC
RTC, get confused.  (Because the criteria will match repeatedly.)

Update comments relating to that oneshot behavior and timezone handling.
(Timezones are another issue that's mostly visible with rtc-cmos.  That's
because PCs often dual-boot MS-Windows, which likes its RTC to match local
wall-clock time instead of UTC.)

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/rtc/rtc-cmos.c  |   14 +++++++++++++-
 drivers/rtc/rtc-dev.c   |    9 +++++++++
 drivers/rtc/rtc-sysfs.c |   19 +++++++++++++------
 3 files changed, 35 insertions(+), 7 deletions(-)

--- g26.orig/drivers/rtc/rtc-cmos.c	2007-11-30 13:49:14.000000000 -0800
+++ g26/drivers/rtc/rtc-cmos.c	2007-11-30 14:12:20.000000000 -0800
@@ -472,10 +472,22 @@ static struct cmos_rtc	cmos_rtc;
 static irqreturn_t cmos_interrupt(int irq, void *p)
 {
 	u8		irqstat;
+	u8		rtc_control;
 
 	spin_lock(&rtc_lock);
 	irqstat = CMOS_READ(RTC_INTR_FLAGS);
-	irqstat &= (CMOS_READ(RTC_CONTROL) & RTC_IRQMASK) | RTC_IRQF;
+	rtc_control = CMOS_READ(RTC_CONTROL);
+	irqstat &= (rtc_control & RTC_IRQMASK) | RTC_IRQF;
+
+	/* All Linux RTC alarms should be treated as if they were oneshot.
+	 * Similar code may be needed in system wakeup paths, in case the
+	 * alarm woke the system.
+	 */
+	if (irqstat & RTC_AIE) {
+		rtc_control &= ~RTC_AIE;
+		CMOS_WRITE(rtc_control, RTC_CONTROL);
+		CMOS_READ(RTC_INTR_FLAGS);
+	}
 	spin_unlock(&rtc_lock);
 
 	if (is_intr(irqstat)) {
--- g26.orig/drivers/rtc/rtc-dev.c	2007-11-30 13:49:14.000000000 -0800
+++ g26/drivers/rtc/rtc-dev.c	2007-11-30 14:12:20.000000000 -0800
@@ -246,6 +246,15 @@ static int rtc_dev_ioctl(struct inode *i
 	/* if the driver does not provide the ioctl interface
 	 * or if that particular ioctl was not implemented
 	 * (-ENOIOCTLCMD), we will try to emulate here.
+	 *
+	 * Drivers *SHOULD NOT* provide ioctl implementations
+	 * for these requests.  Instead, provide methods to
+	 * support the following code, so that the RTC's main
+	 * features are accessible without using ioctls.
+	 *
+	 * RTC and alarm times will be in UTC, by preference,
+	 * but dual-booting with MS-Windows implies RTCs must
+	 * use the local wall clock time.
 	 */
 
 	switch (cmd) {
--- g26.orig/drivers/rtc/rtc-sysfs.c	2007-11-30 13:49:15.000000000 -0800
+++ g26/drivers/rtc/rtc-sysfs.c	2007-11-30 14:12:20.000000000 -0800
@@ -17,6 +17,13 @@
 
 /* device attributes */
 
+/*
+ * NOTE:  RTC times displayed in sysfs use the RTC's timezone.  That's
+ * ideally UTC.  However, PCs that also boot to MS-Windows normally use
+ * the local time and change to match daylight savings time.  That affects
+ * attributes including date, time, since_epoch, and wakealarm.
+ */
+
 static ssize_t
 rtc_sysfs_show_name(struct device *dev, struct device_attribute *attr,
 		char *buf)
@@ -113,13 +120,13 @@ rtc_sysfs_show_wakealarm(struct device *
 	unsigned long alarm;
 	struct rtc_wkalrm alm;
 
-	/* Don't show disabled alarms; but the RTC could leave the
-	 * alarm enabled after it's already triggered.  Alarms are
-	 * conceptually one-shot, even though some common hardware
-	 * (PCs) doesn't actually work that way.
+	/* Don't show disabled alarms.  For uniformity, RTC alarms are
+	 * conceptually one-shot, even though some common RTCs (on PCs)
+	 * don't actually work that way.
 	 *
-	 * REVISIT maybe we should require RTC implementations to
-	 * disable the RTC alarm after it triggers, for uniformity.
+	 * NOTE: RTC implementations where the alarm doesn't match an
+	 * exact YYYY-MM-DD HH:MM[:SS] date *must* disable their RTC
+	 * alarms after they trigger, to ensure one-shot semantics.
 	 */
 	retval = rtc_read_alarm(to_rtc_device(dev), &alm);
 	if (retval == 0 && alm.enabled) {
