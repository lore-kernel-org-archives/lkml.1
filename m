Return-Path: <linux-kernel-owner+w=401wt.eu-S1758689AbYHHQic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758689AbYHHQic (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 12:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754536AbYHHQgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 12:36:20 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:49901 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751720AbYHHQgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 12:36:18 -0400
Date: Fri, 8 Aug 2008 19:34:43 +0300
From: Adrian Bunk <bunk@kernel.org>
To: a.zummo@towertech.it
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <david-b@pacbell.net>
Subject: [6/17] rtc: use bcd2bin/bin2bcd
Message-ID: <20080808163443.GM14495@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes various rtc related code to use the
new bcd2bin/bin2bcd functions instead of the obsolete 
BCD_TO_BIN/BIN_TO_BCD/BCD2BIN/BIN2BCD macros.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/x86/kernel/rtc.c     |   20 +++++++++----------
 drivers/char/ds1286.c     |   34 ++++++++++++++++----------------
 drivers/char/ds1302.c     |   24 +++++++++++-----------
 drivers/char/ip27-rtc.c   |   24 +++++++++++-----------
 drivers/char/rtc.c        |   40 +++++++++++++++++++-------------------
 include/asm-generic/rtc.h |   24 +++++++++++-----------
 6 files changed, 83 insertions(+), 83 deletions(-)

1135b6b20d063af3c5f6f3d67fd54af946c4eb45 
diff --git a/arch/x86/kernel/rtc.c b/arch/x86/kernel/rtc.c
index 05191bb..8120f1b 100644
--- a/arch/x86/kernel/rtc.c
+++ b/arch/x86/kernel/rtc.c
@@ -52,7 +52,7 @@ int mach_set_rtc_mmss(unsigned long nowtime)
 
 	cmos_minutes = CMOS_READ(RTC_MINUTES);
 	if (!(save_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD)
-		BCD_TO_BIN(cmos_minutes);
+		cmos_minutes = bcd2bin(cmos_minutes);
 
 	/*
 	 * since we're only adjusting minutes and seconds,
@@ -69,8 +69,8 @@ int mach_set_rtc_mmss(unsigned long nowtime)
 
 	if (abs(real_minutes - cmos_minutes) < 30) {
 		if (!(save_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
-			BIN_TO_BCD(real_seconds);
-			BIN_TO_BCD(real_minutes);
+			real_seconds = bin2bcd(real_seconds);
+			real_minutes = bin2bcd(real_minutes);
 		}
 		CMOS_WRITE(real_seconds,RTC_SECONDS);
 		CMOS_WRITE(real_minutes,RTC_MINUTES);
@@ -124,16 +124,16 @@ unsigned long mach_get_cmos_time(void)
 	WARN_ON_ONCE(RTC_ALWAYS_BCD && (status & RTC_DM_BINARY));
 
 	if (RTC_ALWAYS_BCD || !(status & RTC_DM_BINARY)) {
-		BCD_TO_BIN(sec);
-		BCD_TO_BIN(min);
-		BCD_TO_BIN(hour);
-		BCD_TO_BIN(day);
-		BCD_TO_BIN(mon);
-		BCD_TO_BIN(year);
+		sec = bcd2bin(sec);
+		min = bcd2bin(min);
+		hour = bcd2bin(hour);
+		day = bcd2bin(day);
+		mon = bcd2bin(mon);
+		year = bcd2bin(year);
 	}
 
 	if (century) {
-		BCD_TO_BIN(century);
+		century = bcd2bin(century);
 		year += century * 100;
 		printk(KERN_INFO "Extended CMOS year: %d\n", century * 100);
 	} else
diff --git a/drivers/char/ds1286.c b/drivers/char/ds1286.c
index fb58493..2ae5c41 100644
--- a/drivers/char/ds1286.c
+++ b/drivers/char/ds1286.c
@@ -210,8 +210,8 @@ static int ds1286_ioctl(struct inode *inode, struct file *file,
 		if (sec != 0)
 			return -EINVAL;
 
-		min = BIN2BCD(min);
-		min = BIN2BCD(hrs);
+		min = bin2bcd(min);
+		min = bin2bcd(hrs);
 
 		spin_lock(&ds1286_lock);
 		rtc_write(hrs, RTC_HOURS_ALARM);
@@ -353,7 +353,7 @@ static int ds1286_proc_output(char *buf)
 
 	ds1286_get_time(&tm);
 	hundredth = rtc_read(RTC_HUNDREDTH_SECOND);
-	BCD_TO_BIN(hundredth);
+	hundredth = bcd2bin(hundredth);
 
 	p += sprintf(p,
 	             "rtc_time\t: %02d:%02d:%02d.%02d\n"
@@ -479,12 +479,12 @@ static void ds1286_get_time(struct rtc_time *rtc_tm)
 	rtc_write(save_control, RTC_CMD);
 	spin_unlock_irqrestore(&ds1286_lock, flags);
 
-	BCD_TO_BIN(rtc_tm->tm_sec);
-	BCD_TO_BIN(rtc_tm->tm_min);
-	BCD_TO_BIN(rtc_tm->tm_hour);
-	BCD_TO_BIN(rtc_tm->tm_mday);
-	BCD_TO_BIN(rtc_tm->tm_mon);
-	BCD_TO_BIN(rtc_tm->tm_year);
+	rtc_tm->tm_sec = bcd2bin(rtc_tm->tm_sec);
+	rtc_tm->tm_min = bcd2bin(rtc_tm->tm_min);
+	rtc_tm->tm_hour = bcd2bin(rtc_tm->tm_hour);
+	rtc_tm->tm_mday = bcd2bin(rtc_tm->tm_mday);
+	rtc_tm->tm_mon = bcd2bin(rtc_tm->tm_mon);
+	rtc_tm->tm_year = bcd2bin(rtc_tm->tm_year);
 
 	/*
 	 * Account for differences between how the RTC uses the values
@@ -533,12 +533,12 @@ static int ds1286_set_time(struct rtc_time *rtc_tm)
 	if (yrs >= 100)
 		yrs -= 100;
 
-	BIN_TO_BCD(sec);
-	BIN_TO_BCD(min);
-	BIN_TO_BCD(hrs);
-	BIN_TO_BCD(day);
-	BIN_TO_BCD(mon);
-	BIN_TO_BCD(yrs);
+	sec = bin2bcd(sec);
+	min = bin2bcd(min);
+	hrs = bin2bcd(hrs);
+	day = bin2bcd(day);
+	mon = bin2bcd(mon);
+	yrs = bin2bcd(yrs);
 
 	spin_lock_irqsave(&ds1286_lock, flags);
 	save_control = rtc_read(RTC_CMD);
@@ -574,8 +574,8 @@ static void ds1286_get_alm_time(struct rtc_time *alm_tm)
 	cmd = rtc_read(RTC_CMD);
 	spin_unlock_irqrestore(&ds1286_lock, flags);
 
-	BCD_TO_BIN(alm_tm->tm_min);
-	BCD_TO_BIN(alm_tm->tm_hour);
+	alm_tm->tm_min = bcd2bin(alm_tm->tm_min);
+	alm_tm->tm_hour = bcd2bin(alm_tm->tm_hour);
 	alm_tm->tm_sec = 0;
 }
 
diff --git a/drivers/char/ds1302.c b/drivers/char/ds1302.c
index c5e67a6..170693c 100644
--- a/drivers/char/ds1302.c
+++ b/drivers/char/ds1302.c
@@ -131,12 +131,12 @@ get_rtc_time(struct rtc_time *rtc_tm)
 
 	local_irq_restore(flags);
 
-	BCD_TO_BIN(rtc_tm->tm_sec);
-	BCD_TO_BIN(rtc_tm->tm_min);
-	BCD_TO_BIN(rtc_tm->tm_hour);
-	BCD_TO_BIN(rtc_tm->tm_mday);
-	BCD_TO_BIN(rtc_tm->tm_mon);
-	BCD_TO_BIN(rtc_tm->tm_year);
+	rtc_tm->tm_sec = bcd2bin(rtc_tm->tm_sec);
+	rtc_tm->tm_min = bcd2bin(rtc_tm->tm_min);
+	rtc_tm->tm_hour = bcd2bin(rtc_tm->tm_hour);
+	rtc_tm->tm_mday = bcd2bin(rtc_tm->tm_mday);
+	rtc_tm->tm_mon = bcd2bin(rtc_tm->tm_mon);
+	rtc_tm->tm_year = bcd2bin(rtc_tm->tm_year);
 
 	/*
 	 * Account for differences between how the RTC uses the values
@@ -211,12 +211,12 @@ static long rtc_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 			else
 				yrs -= 1900;	/* RTC (70, 71, ... 99) */
 
-			BIN_TO_BCD(sec);
-			BIN_TO_BCD(min);
-			BIN_TO_BCD(hrs);
-			BIN_TO_BCD(day);
-			BIN_TO_BCD(mon);
-			BIN_TO_BCD(yrs);
+			sec = bin2bcd(sec);
+			min = bin2bcd(min);
+			hrs = bin2bcd(hrs);
+			day = bin2bcd(day);
+			mon = bin2bcd(mon);
+			yrs = bin2bcd(yrs);
 
 			lock_kernel();
 			local_irq_save(flags);
diff --git a/drivers/char/ip27-rtc.c b/drivers/char/ip27-rtc.c
index ec9d044..2abd881 100644
--- a/drivers/char/ip27-rtc.c
+++ b/drivers/char/ip27-rtc.c
@@ -130,12 +130,12 @@ static long rtc_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		if (yrs >= 100)
 			yrs -= 100;
 
-		sec = BIN2BCD(sec);
-		min = BIN2BCD(min);
-		hrs = BIN2BCD(hrs);
-		day = BIN2BCD(day);
-		mon = BIN2BCD(mon);
-		yrs = BIN2BCD(yrs);
+		sec = bin2bcd(sec);
+		min = bin2bcd(min);
+		hrs = bin2bcd(hrs);
+		day = bin2bcd(day);
+		mon = bin2bcd(mon);
+		yrs = bin2bcd(yrs);
 
 		spin_lock_irq(&rtc_lock);
 		rtc->control |= M48T35_RTC_SET;
@@ -311,12 +311,12 @@ static void get_rtc_time(struct rtc_time *rtc_tm)
 	rtc->control &= ~M48T35_RTC_READ;
 	spin_unlock_irq(&rtc_lock);
 
-	rtc_tm->tm_sec = BCD2BIN(rtc_tm->tm_sec);
-	rtc_tm->tm_min = BCD2BIN(rtc_tm->tm_min);
-	rtc_tm->tm_hour = BCD2BIN(rtc_tm->tm_hour);
-	rtc_tm->tm_mday = BCD2BIN(rtc_tm->tm_mday);
-	rtc_tm->tm_mon = BCD2BIN(rtc_tm->tm_mon);
-	rtc_tm->tm_year = BCD2BIN(rtc_tm->tm_year);
+	rtc_tm->tm_sec = bcd2bin(rtc_tm->tm_sec);
+	rtc_tm->tm_min = bcd2bin(rtc_tm->tm_min);
+	rtc_tm->tm_hour = bcd2bin(rtc_tm->tm_hour);
+	rtc_tm->tm_mday = bcd2bin(rtc_tm->tm_mday);
+	rtc_tm->tm_mon = bcd2bin(rtc_tm->tm_mon);
+	rtc_tm->tm_year = bcd2bin(rtc_tm->tm_year);
 
 	/*
 	 * Account for differences between how the RTC uses the values
diff --git a/drivers/char/rtc.c b/drivers/char/rtc.c
index dbefbb3..65c69db 100644
--- a/drivers/char/rtc.c
+++ b/drivers/char/rtc.c
@@ -518,17 +518,17 @@ static int rtc_do_ioctl(unsigned int cmd, unsigned long arg, int kernel)
 		if (!(CMOS_READ(RTC_CONTROL) & RTC_DM_BINARY) ||
 							RTC_ALWAYS_BCD) {
 			if (sec < 60)
-				BIN_TO_BCD(sec);
+				sec = bin2bcd(sec);
 			else
 				sec = 0xff;
 
 			if (min < 60)
-				BIN_TO_BCD(min);
+				min = bin2bcd(min);
 			else
 				min = 0xff;
 
 			if (hrs < 24)
-				BIN_TO_BCD(hrs);
+				hrs = bin2bcd(hrs);
 			else
 				hrs = 0xff;
 		}
@@ -614,12 +614,12 @@ static int rtc_do_ioctl(unsigned int cmd, unsigned long arg, int kernel)
 
 		if (!(CMOS_READ(RTC_CONTROL) & RTC_DM_BINARY)
 		    || RTC_ALWAYS_BCD) {
-			BIN_TO_BCD(sec);
-			BIN_TO_BCD(min);
-			BIN_TO_BCD(hrs);
-			BIN_TO_BCD(day);
-			BIN_TO_BCD(mon);
-			BIN_TO_BCD(yrs);
+			sec = bin2bcd(sec);
+			min = bin2bcd(min);
+			hrs = bin2bcd(hrs);
+			day = bin2bcd(day);
+			mon = bin2bcd(mon);
+			yrs = bin2bcd(yrs);
 		}
 
 		save_control = CMOS_READ(RTC_CONTROL);
@@ -1095,7 +1095,7 @@ no_irq:
 	spin_unlock_irq(&rtc_lock);
 
 	if (!(ctrl & RTC_DM_BINARY) || RTC_ALWAYS_BCD)
-		BCD_TO_BIN(year);       /* This should never happen... */
+		year = bcd2bin(year);       /* This should never happen... */
 
 	if (year < 20) {
 		epoch = 2000;
@@ -1348,13 +1348,13 @@ void rtc_get_rtc_time(struct rtc_time *rtc_tm)
 	spin_unlock_irqrestore(&rtc_lock, flags);
 
 	if (!(ctrl & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
-		BCD_TO_BIN(rtc_tm->tm_sec);
-		BCD_TO_BIN(rtc_tm->tm_min);
-		BCD_TO_BIN(rtc_tm->tm_hour);
-		BCD_TO_BIN(rtc_tm->tm_mday);
-		BCD_TO_BIN(rtc_tm->tm_mon);
-		BCD_TO_BIN(rtc_tm->tm_year);
-		BCD_TO_BIN(rtc_tm->tm_wday);
+		rtc_tm->tm_sec = bcd2bin(rtc_tm->tm_sec);
+		rtc_tm->tm_min = bcd2bin(rtc_tm->tm_min);
+		rtc_tm->tm_hour = bcd2bin(rtc_tm->tm_hour);
+		rtc_tm->tm_mday = bcd2bin(rtc_tm->tm_mday);
+		rtc_tm->tm_mon = bcd2bin(rtc_tm->tm_mon);
+		rtc_tm->tm_year = bcd2bin(rtc_tm->tm_year);
+		rtc_tm->tm_wday = bcd2bin(rtc_tm->tm_wday);
 	}
 
 #ifdef CONFIG_MACH_DECSTATION
@@ -1388,9 +1388,9 @@ static void get_rtc_alm_time(struct rtc_time *alm_tm)
 	spin_unlock_irq(&rtc_lock);
 
 	if (!(ctrl & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
-		BCD_TO_BIN(alm_tm->tm_sec);
-		BCD_TO_BIN(alm_tm->tm_min);
-		BCD_TO_BIN(alm_tm->tm_hour);
+		alm_tm->tm_sec = bcd2bin(alm_tm->tm_sec);
+		alm_tm->tm_min = bcd2bin(alm_tm->tm_min);
+		alm_tm->tm_hour = bcd2bin(alm_tm->tm_hour);
 	}
 }
 
diff --git a/include/asm-generic/rtc.h b/include/asm-generic/rtc.h
index be4af00..3dbe540 100644
--- a/include/asm-generic/rtc.h
+++ b/include/asm-generic/rtc.h
@@ -88,12 +88,12 @@ static inline unsigned int get_rtc_time(struct rtc_time *time)
 
 	if (!(ctrl & RTC_DM_BINARY) || RTC_ALWAYS_BCD)
 	{
-		BCD_TO_BIN(time->tm_sec);
-		BCD_TO_BIN(time->tm_min);
-		BCD_TO_BIN(time->tm_hour);
-		BCD_TO_BIN(time->tm_mday);
-		BCD_TO_BIN(time->tm_mon);
-		BCD_TO_BIN(time->tm_year);
+		time->tm_sec = bcd2bin(time->tm_sec);
+		time->tm_min = bcd2bin(time->tm_min);
+		time->tm_hour = bcd2bin(time->tm_hour);
+		time->tm_mday = bcd2bin(time->tm_mday);
+		time->tm_mon = bcd2bin(time->tm_mon);
+		time->tm_year = bcd2bin(time->tm_year);
 	}
 
 #ifdef CONFIG_MACH_DECSTATION
@@ -163,12 +163,12 @@ static inline int set_rtc_time(struct rtc_time *time)
 
 	if (!(CMOS_READ(RTC_CONTROL) & RTC_DM_BINARY)
 	    || RTC_ALWAYS_BCD) {
-		BIN_TO_BCD(sec);
-		BIN_TO_BCD(min);
-		BIN_TO_BCD(hrs);
-		BIN_TO_BCD(day);
-		BIN_TO_BCD(mon);
-		BIN_TO_BCD(yrs);
+		sec = bin2bcd(sec);
+		min = bin2bcd(min);
+		hrs = bin2bcd(hrs);
+		day = bin2bcd(day);
+		mon = bin2bcd(mon);
+		yrs = bin2bcd(yrs);
 	}
 
 	save_control = CMOS_READ(RTC_CONTROL);

