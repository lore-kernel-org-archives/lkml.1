Return-Path: <linux-kernel-owner+w=401wt.eu-S932632AbXJRDSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932632AbXJRDSo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 23:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758430AbXJRDSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 23:18:34 -0400
Received: from rtr.ca ([76.10.145.34]:1334 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755126AbXJRDSe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 23:18:34 -0400
Message-ID: <4716D088.3040608@rtr.ca>
Date: Wed, 17 Oct 2007 23:18:32 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] Fix /proc/acpi/alarm BCD alarm encodings
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>Linus Torvalds wrote:
>On Wed, 26 Sep 2007, Mark Lord wrote:
>> 
>> The existing code in linux/drivers/acpi/sleep/proc.c has a nasty bug
>> that prevents BCD mode from working:  the code converts binary to BCD
>> three times in a row, each time taking the previous result.
>> This thoroughly mangles the alarm timestamp, and never worked.
>> 
>> The patch below fixes it, by removing the first two (bogus)
>> conversions, and leaving only the final conversion in place.
>> Tested & working on my system here.
>
>Actually, it cannot possibly really fix it.
>
>That code is doing all the arithmetic in non-BCD mode, but the "adjust" 
>case doesn't do a BCD_TO_BIN() on that arithmetic.
>
>In other words, the logic you removed was certainly total crap, but 
>there's more crap remaining inside the "if (adjust)" logic. I just suspect 
>you never tested that part (ie using a string that starts with '+').
>
>In fact, for the non-broken case, the old broken code *should* have been a 
>no-op, since it did BIN_TO_BCD() followed by BCD_TO_BIN(). It then totally
>stupidly seemed to expect that the "adjust" case would do a BCD addition! 
>So I don't even see why your patch should have mattered or worked!
>
>So how about this cleanup instead? Does this work for you?
>
>NOTE! I wanted to switch "acpi_system_alarm_seq_show()" over to this too, 
>but that code has a strange rule:
>
>        if (acpi_gbl_FADT.day_alarm)
>                /* ACPI spec: only low 6 its should be cared */
>                day = CMOS_READ(acpi_gbl_FADT.day_alarm) & 0x3F;
>        else
>                day = CMOS_READ(RTC_DAY_OF_MONTH);
>
>and note the "& 0x3f" which is done in BCD mode. Strange. But we always 
>write zero (which may or may not be correct). So I'd have to add a mask to 
>the interface, and I decided it wasn't worth it until somebody talks about 
>how that thing actually works..

Linus, this is your patch from a few weeks ago.
It (still) solves problems for me here.
This should go into 2.6.24.

Fix BIN_TO_BCD()/BCD_TO_BIN() handling when setting the real-time alarm clock.

Signed-off-by: Mark Lord <mlord@pobox.com>

---
 drivers/acpi/sleep/proc.c |   66 +++++++++++++++++++-------------------------
 1 files changed, 29 insertions(+), 37 deletions(-)

diff --git a/drivers/acpi/sleep/proc.c b/drivers/acpi/sleep/proc.c
index 3839efd..1538355 100644
--- a/drivers/acpi/sleep/proc.c
+++ b/drivers/acpi/sleep/proc.c
@@ -194,6 +194,23 @@ static int get_date_field(char **p, u32 * value)
 	return result;
 }
 
+/* Read a possibly BCD register, always return binary */
+static u32 cmos_bcd_read(int offset, int rtc_control)
+{
+	u32 val = CMOS_READ(offset);
+	if (!(rtc_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD)
+		BCD_TO_BIN(val);
+	return val;
+}
+
+/* Write binary value into possibly BCD register */
+static void cmos_bcd_write(u32 val, int offset, int rtc_control)
+{
+	if (!(rtc_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD)
+		BIN_TO_BCD(val);
+	CMOS_WRITE(val, offset);
+}
+
 static ssize_t
 acpi_system_write_alarm(struct file *file,
 			const char __user * buffer, size_t count, loff_t * ppos)
@@ -258,35 +275,18 @@ acpi_system_write_alarm(struct file *file,
 	spin_lock_irq(&rtc_lock);
 
 	rtc_control = CMOS_READ(RTC_CONTROL);
-	if (!(rtc_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
-		BIN_TO_BCD(yr);
-		BIN_TO_BCD(mo);
-		BIN_TO_BCD(day);
-		BIN_TO_BCD(hr);
-		BIN_TO_BCD(min);
-		BIN_TO_BCD(sec);
-	}
 
 	if (adjust) {
-		yr += CMOS_READ(RTC_YEAR);
-		mo += CMOS_READ(RTC_MONTH);
-		day += CMOS_READ(RTC_DAY_OF_MONTH);
-		hr += CMOS_READ(RTC_HOURS);
-		min += CMOS_READ(RTC_MINUTES);
-		sec += CMOS_READ(RTC_SECONDS);
+		yr += cmos_bcd_read(RTC_YEAR, rtc_control);
+		mo += cmos_bcd_read(RTC_MONTH, rtc_control);
+		day += cmos_bcd_read(RTC_DAY_OF_MONTH, rtc_control);
+		hr += cmos_bcd_read(RTC_HOURS, rtc_control);
+		min += cmos_bcd_read(RTC_MINUTES, rtc_control);
+		sec += cmos_bcd_read(RTC_SECONDS, rtc_control);
 	}
 
 	spin_unlock_irq(&rtc_lock);
 
-	if (!(rtc_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
-		BCD_TO_BIN(yr);
-		BCD_TO_BIN(mo);
-		BCD_TO_BIN(day);
-		BCD_TO_BIN(hr);
-		BCD_TO_BIN(min);
-		BCD_TO_BIN(sec);
-	}
-
 	if (sec > 59) {
 		min++;
 		sec -= 60;
@@ -307,14 +307,6 @@ acpi_system_write_alarm(struct file *file,
 		yr++;
 		mo -= 12;
 	}
-	if (!(rtc_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
-		BIN_TO_BCD(yr);
-		BIN_TO_BCD(mo);
-		BIN_TO_BCD(day);
-		BIN_TO_BCD(hr);
-		BIN_TO_BCD(min);
-		BIN_TO_BCD(sec);
-	}
 
 	spin_lock_irq(&rtc_lock);
 	/*
@@ -326,9 +318,9 @@ acpi_system_write_alarm(struct file *file,
 	CMOS_READ(RTC_INTR_FLAGS);
 
 	/* write the fields the rtc knows about */
-	CMOS_WRITE(hr, RTC_HOURS_ALARM);
-	CMOS_WRITE(min, RTC_MINUTES_ALARM);
-	CMOS_WRITE(sec, RTC_SECONDS_ALARM);
+	cmos_bcd_write(hr, RTC_HOURS_ALARM, rtc_control);
+	cmos_bcd_write(min, RTC_MINUTES_ALARM, rtc_control);
+	cmos_bcd_write(sec, RTC_SECONDS_ALARM, rtc_control);
 
 	/*
 	 * If the system supports an enhanced alarm it will have non-zero
@@ -336,11 +328,11 @@ acpi_system_write_alarm(struct file *file,
 	 * to the RTC area of memory.
 	 */
 	if (acpi_gbl_FADT.day_alarm)
-		CMOS_WRITE(day, acpi_gbl_FADT.day_alarm);
+		cmos_bcd_write(day, acpi_gbl_FADT.day_alarm, rtc_control);
 	if (acpi_gbl_FADT.month_alarm)
-		CMOS_WRITE(mo, acpi_gbl_FADT.month_alarm);
+		cmos_bcd_write(mo, acpi_gbl_FADT.month_alarm, rtc_control);
 	if (acpi_gbl_FADT.century)
-		CMOS_WRITE(yr / 100, acpi_gbl_FADT.century);
+		cmos_bcd_write(yr / 100, acpi_gbl_FADT.century, rtc_control);
 	/* enable the rtc alarm interrupt */
 	rtc_control |= RTC_AIE;
 	CMOS_WRITE(rtc_control, RTC_CONTROL);
