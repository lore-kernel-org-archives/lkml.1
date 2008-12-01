Return-Path: <linux-kernel-owner+w=401wt.eu-S1753173AbYLAQ4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbYLAQ4Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 11:56:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751370AbYLAQ4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 11:56:14 -0500
Received: from rtr.ca ([76.10.145.34]:37553 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253AbYLAQ4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 11:56:13 -0500
Message-ID: <4934176F.6080900@rtr.ca>
Date: Mon, 01 Dec 2008 11:57:19 -0500
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>, Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>, lkml <linux-kernel@vger.kernel.org>,
       rtc-linux@googlegroups.com, linux-acpi@vger.kernel.org
Subject: PATCH: /proc/acpi/alarm: handle day-of-month wraparound on readback
References: <200806222042.13929.david-b@pacbell.net>
In-Reply-To: <200806222042.13929.david-b@pacbell.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix month wrap issue with readback from /proc/acpi/alarm
This bug has been around *forever*.

$ echo '2008-12-01 10:36:20' > /proc/acpi/alarm
$ cat /proc/acpi/alarm
2008-11-01 10:36:20

Note how the readback above shows the month incorrectly.
But with this patch applied, it shows the correct month (12).

Patch applies/works on kernels 2.6.25.* through 2.6.27.*,
and probably on earlier kernels as well.

Probably best to queue it up for the next major cycle.

Signed-off-by: Mark Lord <mlord@pobox.com>

--- linux-2.6.25/drivers/acpi/sleep/proc.c	2008-06-09 14:27:19.000000000 -0400
+++ linux/drivers/acpi/sleep/proc.c	2008-11-30 18:08:31.000000000 -0500
@@ -84,12 +84,15 @@
 #define	HAVE_ACPI_LEGACY_ALARM
 #endif
 
+static u32 cmos_bcd_read(int offset, int rtc_control);
+
 #ifdef	HAVE_ACPI_LEGACY_ALARM
 
 static int acpi_system_alarm_seq_show(struct seq_file *seq, void *offset)
 {
 	u32 sec, min, hr;
 	u32 day, mo, yr, cent = 0;
+	u32 today = 0;
 	unsigned char rtc_control = 0;
 	unsigned long flags;
 
@@ -97,38 +100,32 @@
 
 	spin_lock_irqsave(&rtc_lock, flags);
 
-	sec = CMOS_READ(RTC_SECONDS_ALARM);
-	min = CMOS_READ(RTC_MINUTES_ALARM);
-	hr = CMOS_READ(RTC_HOURS_ALARM);
 	rtc_control = CMOS_READ(RTC_CONTROL);
+	sec = cmos_bcd_read(RTC_SECONDS_ALARM, rtc_control);
+	min = cmos_bcd_read(RTC_MINUTES_ALARM, rtc_control);
+	hr = cmos_bcd_read(RTC_HOURS_ALARM, rtc_control);
 
 	/* If we ever get an FACP with proper values... */
-	if (acpi_gbl_FADT.day_alarm)
+	if (acpi_gbl_FADT.day_alarm) {
 		/* ACPI spec: only low 6 its should be cared */
 		day = CMOS_READ(acpi_gbl_FADT.day_alarm) & 0x3F;
-	else
-		day = CMOS_READ(RTC_DAY_OF_MONTH);
+		if (!(rtc_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD)
+			BCD_TO_BIN(day);
+	} else
+		day = cmos_bcd_read(RTC_DAY_OF_MONTH, rtc_control);
 	if (acpi_gbl_FADT.month_alarm)
-		mo = CMOS_READ(acpi_gbl_FADT.month_alarm);
-	else
-		mo = CMOS_READ(RTC_MONTH);
+		mo = cmos_bcd_read(acpi_gbl_FADT.month_alarm, rtc_control);
+	else {
+		mo = cmos_bcd_read(RTC_MONTH, rtc_control);
+		today = cmos_bcd_read(RTC_DAY_OF_MONTH, rtc_control);
+	}
 	if (acpi_gbl_FADT.century)
-		cent = CMOS_READ(acpi_gbl_FADT.century);
+		cent = cmos_bcd_read(acpi_gbl_FADT.century, rtc_control);
 
-	yr = CMOS_READ(RTC_YEAR);
+	yr = cmos_bcd_read(RTC_YEAR, rtc_control);
 
 	spin_unlock_irqrestore(&rtc_lock, flags);
 
-	if (!(rtc_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
-		BCD_TO_BIN(sec);
-		BCD_TO_BIN(min);
-		BCD_TO_BIN(hr);
-		BCD_TO_BIN(day);
-		BCD_TO_BIN(mo);
-		BCD_TO_BIN(yr);
-		BCD_TO_BIN(cent);
-	}
-
 	/* we're trusting the FADT (see above) */
 	if (!acpi_gbl_FADT.century)
 		/* If we're not trusting the FADT, we should at least make it
@@ -153,6 +150,20 @@
 	else
 		yr += cent * 100;
 
+	/*
+	 * Show correct dates for alarms up to a month into the future.
+	 * This solves issues for nearly all situations with the common
+	 * 30-day alarm clocks in PC hardware.
+	 */
+	if (day < today) {
+		if (mo < 12) {
+			mo += 1;
+		} else {
+			mo = 1;
+			yr += 1;
+		}
+	}
+
 	seq_printf(seq, "%4.4u-", yr);
 	(mo > 12) ? seq_puts(seq, "**-") : seq_printf(seq, "%2.2u-", mo);
 	(day > 31) ? seq_puts(seq, "** ") : seq_printf(seq, "%2.2u ", day);
