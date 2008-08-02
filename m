Return-Path: <linux-kernel-owner+w=401wt.eu-S1756881AbYHBOjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881AbYHBOjT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 10:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752460AbYHBOjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 10:39:05 -0400
Received: from www.tglx.de ([62.245.132.106]:34746 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753413AbYHBOjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 10:39:04 -0400
Subject: [PATCH] rtc_time_to_tm: Fix signed / unsigned arithmetic
From: Jan Altenberg <jan.altenberg@linutronix.de>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>, stable@kernel.org,
       tglx@linutronix.de
Content-Type: text/plain
Date: Sat, 02 Aug 2008 16:34:40 +0200
Message-Id: <1217687680.3872.10.camel@bender>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

commit 945185a69daa457c4c5e46e47f4afad7dcea734f changed the some types
in rtc_time_to_tm() to unsigned:

 void rtc_time_to_tm(unsigned long time, struct rtc_time *tm)
 {
-       register int days, month, year;
+       unsigned int days, month, year;

This doesn't work for all cases, because days is checked for < 0 later
on:

if (days < 0) {
	year -= 1;
	days += 365 + LEAP_YEAR(year);
}

I think the correct fix would be to keep days signed and do an
appropriate cast later on. See attached patch.

Signed-off-by: Jan Altenberg <jan.altenberg@linutronix.de>

---
diff --git a/drivers/rtc/rtc-lib.c b/drivers/rtc/rtc-lib.c
index 9f996ec..dd70bf7 100644
--- a/drivers/rtc/rtc-lib.c
+++ b/drivers/rtc/rtc-lib.c
@@ -51,10 +51,11 @@ EXPORT_SYMBOL(rtc_year_days);
  */
 void rtc_time_to_tm(unsigned long time, struct rtc_time *tm)
 {
-	unsigned int days, month, year;
+	unsigned int month, year;
+	int days;
 
 	days = time / 86400;
-	time -= days * 86400;
+	time -= (unsigned int) days * 86400;
 
 	/* day of the week, 1970-01-01 was a Thursday */
 	tm->tm_wday = (days + 4) % 7;


