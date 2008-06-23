Return-Path: <linux-kernel-owner+w=401wt.eu-S1756349AbYFWDm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349AbYFWDm0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 23:42:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753227AbYFWDmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 23:42:16 -0400
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:41180 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753127AbYFWDmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 23:42:15 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=H8A/hrbYouCKzuRtRIWw6bjvcI2HmhrDtwtWBIhCZcWD8SoAGa1IhLsq2/Xj7ifz9flL8I+5qE0cZJMxfwaXWJoRdcj9C4yihgOuAbjVQ3Sy1hoaMCg2+WgkvFQkVgyaj6FQDPBD/5n/pCgQF0Afk+l/Rfvvymt3QFSPg8f3tRw=  ;
X-YMail-OSG: _vcNfGUVM1kxmR.ogtf.ZUUAEZdtVrPrv6o2lMFnfxUoAsVrkHNOkEO62r4Vygzd4Im8GYP3HkTSvCaHUsE.3qVlGyg4R5YFaUfLCgOyVcj77xYqZ04s0oNXtPRVQz7wSUo-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: lkml <linux-kernel@vger.kernel.org>
Subject: [patch 2.6.26-rc7] rtc_read_alarm() handles wraparound
Date: Sun, 22 Jun 2008 20:42:13 -0700
User-Agent: KMail/1.9.9
Cc: rtc-linux@googlegroups.com, Mark Lord <lkml@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806222042.13929.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While 0e36a9a4a788e4e92407774df76c545910810d35 made sure that active
alarms were never returned with invalid "wildcard" fields (negative),
it can still report (wrongly) that the alarm triggers in the past.

Example, if it's now 10am, an alarm firing at 5am will be triggered
TOMORROW not today.  (Which may also be next month or next year...)

This updates that alarm handling in three ways:

  * Handle alarm rollover in the common cases of RTCs that don't
    support matching on all date fields.

  * Skip the invalid-field logic when it's not needed.

  * Minor bugfix ... tm_isdst should be ignored, it's one of the
    fields Linux doesn't maintain.

A warning is emitted for some of the unhandled rollover cases, but
the possible combinations are a bit too numerous to handle every
bit of potential hardware and firmware braindamage.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/rtc/interface.c |  102 ++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 91 insertions(+), 11 deletions(-)

--- a/drivers/rtc/interface.c	2008-06-21 19:51:24.000000000 -0700
+++ b/drivers/rtc/interface.c	2008-06-22 13:05:57.000000000 -0700
@@ -126,12 +126,25 @@ int rtc_read_alarm(struct rtc_device *rt
 	int err;
 	struct rtc_time before, now;
 	int first_time = 1;
+	unsigned long t_now, t_alm;
+	enum { none, day, month, year } missing = none;
+	unsigned days;
 
-	/* The lower level RTC driver may not be capable of filling
-	 * in all fields of the rtc_time struct (eg. rtc-cmos),
-	 * and so might instead return -1 in some fields.
-	 * We deal with that here by grabbing a current RTC timestamp
-	 * and using values from that for any missing (-1) values.
+	/* The lower level RTC driver may return -1 in some fields,
+	 * creating invalid alarm->time values, for reasons like:
+	 *
+	 *   - The hardware may not be capable of filling them in;
+	 *     many alarms match only on time-of-day fields, not
+	 *     day/month/year calendar data.
+	 *
+	 *   - Some hardware uses illegal values as "wildcard" match
+	 *     values, which non-Linux firmware (like a BIOS) may try
+	 *     to set up as e.g. "alarm 15 minutes after each hour".
+	 *     Linux uses only oneshot alarms.
+	 *
+	 * When we see that here, we deal with it by using values from
+	 * a current RTC timestamp for any missing (-1) values.  The
+	 * RTC driver prevents "periodic alarm" modes.
 	 *
 	 * But this can be racey, because some fields of the RTC timestamp
 	 * may have wrapped in the interval since we read the RTC alarm,
@@ -174,6 +187,10 @@ int rtc_read_alarm(struct rtc_device *rt
 		if (!alarm->enabled)
 			return 0;
 
+		/* full-function RTCs won't have such missing fields */
+		if (rtc_valid_tm(&alarm->time) == 0)
+			return 0;
+
 		/* get the "after" timestamp, to detect wrapped fields */
 		err = rtc_read_time(rtc, &now);
 		if (err < 0)
@@ -183,22 +200,85 @@ int rtc_read_alarm(struct rtc_device *rt
 	} while (   before.tm_min   != now.tm_min
 		 || before.tm_hour  != now.tm_hour
 		 || before.tm_mon   != now.tm_mon
-		 || before.tm_year  != now.tm_year
-		 || before.tm_isdst != now.tm_isdst);
+		 || before.tm_year  != now.tm_year);
 
-	/* Fill in any missing alarm fields using the timestamp */
+	/* Fill in the missing alarm fields using the timestamp; we
+	 * know there's at least one since alarm->time is invalid.
+	 */
 	if (alarm->time.tm_sec == -1)
 		alarm->time.tm_sec = now.tm_sec;
 	if (alarm->time.tm_min == -1)
 		alarm->time.tm_min = now.tm_min;
 	if (alarm->time.tm_hour == -1)
 		alarm->time.tm_hour = now.tm_hour;
-	if (alarm->time.tm_mday == -1)
+
+	/* For simplicity, only support date rollover for now */
+	if (alarm->time.tm_mday == -1) {
 		alarm->time.tm_mday = now.tm_mday;
-	if (alarm->time.tm_mon == -1)
+		missing = day;
+	}
+	if (alarm->time.tm_mon == -1) {
 		alarm->time.tm_mon = now.tm_mon;
-	if (alarm->time.tm_year == -1)
+		if (missing == none)
+			missing = month;
+	}
+	if (alarm->time.tm_year == -1) {
 		alarm->time.tm_year = now.tm_year;
+		if (missing == none)
+			missing = year;
+	}
+
+	/* with luck, no rollover is needed */
+	rtc_tm_to_time(&now, &t_now);
+	rtc_tm_to_time(&alarm->time, &t_alm);
+	if (t_now < t_alm)
+		goto done;
+
+	switch (missing) {
+
+	/* 24 hour rollover ... if it's now 10am Monday, an alarm that
+	 * that will trigger at 5am will do so at 5am Tuesday, which
+	 * could also be in the next month or year.  This is a common
+	 * case, especially for PCs.
+	 */
+	case day:
+		dev_dbg(&rtc->dev, "alarm rollover: %s\n", "day");
+		t_alm += 24 * 60 * 60;
+		rtc_time_to_tm(t_alm, &alarm->time);
+		break;
+
+	/* Month rollover ... if it's the 31th, an alarm on the 3rd will
+	 * be next month.  An alarm matching on the 30th, 29th, or 28th
+	 * may end up in the month after that!  Many newer PCs support
+	 * this type of alarm.
+	 */
+	case month:
+		dev_dbg(&rtc->dev, "alarm rollover: %s\n", "month");
+		do {
+			if (alarm->time.tm_mon < 11)
+				alarm->time.tm_mon++;
+			else {
+				alarm->time.tm_mon = 0;
+				alarm->time.tm_year++;
+			}
+			days = rtc_month_days(alarm->time.tm_mon,
+					alarm->time.tm_year);
+		} while (days < alarm->time.tm_mday);
+		break;
+
+	/* Year rollover ... easy except for leap years! */
+	case year:
+		dev_dbg(&rtc->dev, "alarm rollover: %s\n", "year");
+		do {
+			alarm->time.tm_year++;
+		} while (!rtc_valid_tm(&alarm->time));
+		break;
+
+	default:
+		dev_warn(&rtc->dev, "alarm rollover not handled\n");
+	}
+
+done:
 	return 0;
 }
 EXPORT_SYMBOL_GPL(rtc_read_alarm);
