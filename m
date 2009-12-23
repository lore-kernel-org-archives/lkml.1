Return-Path: <linux-kernel-owner+w=401wt.eu-S1752153AbZLWECB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153AbZLWECB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 23:02:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751497AbZLWECA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 23:02:00 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:47878 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbZLWEB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 23:01:59 -0500
Subject: [RFC][PATCH 2/14] Convert arm to read/update_persistent_clock
From: john stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Russell King <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.infradead.org
In-Reply-To: <1261540826.3508.62.camel@localhost.localdomain>
References: <1261540762.3508.61.camel@localhost.localdomain>
	 <1261540826.3508.62.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Dec 2009 20:01:42 -0800
Message-ID: <1261540902.3508.63.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the arm architecture to use the generic
read_persistent_clock and update_persistent_clock interfaces, reducing
the amount of arch specific code we have to maintain, and allowing for
further cleanups in the future.

Also removes a direct xtime access, replacing it with
current_kernel_time()

I have not built or tested this patch, so help from arch maintainers
would be appreciated.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 Kconfig                 |    3 +++
 include/asm/mach/time.h |    2 +-
 kernel/time.c           |   39 ++++++++-------------------------------
 mach-footbridge/time.c  |    4 ++--
 4 files changed, 14 insertions(+), 34 deletions(-)

Index: gettimeoffset/arch/arm/Kconfig
===================================================================
--- gettimeoffset.orig/arch/arm/Kconfig	2009-12-22 18:50:54.000000000 -0800
+++ gettimeoffset/arch/arm/Kconfig	2009-12-22 18:51:20.000000000 -0800
@@ -38,6 +38,9 @@ config GENERIC_GPIO
 config GENERIC_TIME
 	bool
 
+config GENERIC_CMOS_UPDATE
+        def_bool y
+
 config GENERIC_CLOCKEVENTS
 	bool
 
Index: gettimeoffset/arch/arm/include/asm/mach/time.h
===================================================================
--- gettimeoffset.orig/arch/arm/include/asm/mach/time.h	2009-12-22 18:50:54.000000000 -0800
+++ gettimeoffset/arch/arm/include/asm/mach/time.h	2009-12-22 18:51:20.000000000 -0800
@@ -50,7 +50,7 @@ extern void timer_tick(void);
  * Kernel time keeping support.
  */
 struct timespec;
-extern int (*set_rtc)(void);
+extern int (*set_rtc)(struct timespec now);
 extern void save_time_delta(struct timespec *delta, struct timespec *rtc);
 extern void restore_time_delta(struct timespec *delta, struct timespec *rtc);
 
Index: gettimeoffset/arch/arm/kernel/time.c
===================================================================
--- gettimeoffset.orig/arch/arm/kernel/time.c	2009-12-22 18:50:54.000000000 -0800
+++ gettimeoffset/arch/arm/kernel/time.c	2009-12-22 18:51:20.000000000 -0800
@@ -80,7 +80,7 @@ EXPORT_SYMBOL(profile_pc);
 /*
  * hook for setting the RTC's idea of the current time.
  */
-int (*set_rtc)(void);
+int (*set_rtc)(struct timespec now);
 
 #ifndef CONFIG_GENERIC_TIME
 static unsigned long dummy_gettimeoffset(void)
@@ -89,34 +89,11 @@ static unsigned long dummy_gettimeoffset
 }
 #endif
 
-static unsigned long next_rtc_update;
-
-/*
- * If we have an externally synchronized linux clock, then update
- * CMOS clock accordingly every ~11 minutes.  set_rtc() has to be
- * called as close as possible to 500 ms before the new second
- * starts.
- */
-static inline void do_set_rtc(void)
+int update_persistent_clock(struct timespec now)
 {
-	if (!ntp_synced() || set_rtc == NULL)
-		return;
-
-	if (next_rtc_update &&
-	    time_before((unsigned long)xtime.tv_sec, next_rtc_update))
-		return;
-
-	if (xtime.tv_nsec < 500000000 - ((unsigned) tick_nsec >> 1) &&
-	    xtime.tv_nsec >= 500000000 + ((unsigned) tick_nsec >> 1))
-		return;
-
-	if (set_rtc())
-		/*
-		 * rtc update failed.  Try again in 60s
-		 */
-		next_rtc_update = xtime.tv_sec + 60;
-	else
-		next_rtc_update = xtime.tv_sec + 660;
+	if (set_rtc == NULL)
+		return -1;
+	return set_rtc(now);
 }
 
 #ifdef CONFIG_LEDS
@@ -305,9 +282,10 @@ EXPORT_SYMBOL(do_settimeofday);
  */
 void save_time_delta(struct timespec *delta, struct timespec *rtc)
 {
+	struct timespec now = current_kernel_time();
 	set_normalized_timespec(delta,
-				xtime.tv_sec - rtc->tv_sec,
-				xtime.tv_nsec - rtc->tv_nsec);
+				now.tv_sec - rtc->tv_sec,
+				now.tv_nsec - rtc->tv_nsec);
 }
 EXPORT_SYMBOL(save_time_delta);
 
@@ -336,7 +314,6 @@ void timer_tick(void)
 {
 	profile_tick(CPU_PROFILING);
 	do_leds();
-	do_set_rtc();
 	write_seqlock(&xtime_lock);
 	do_timer(1);
 	write_sequnlock(&xtime_lock);
Index: gettimeoffset/arch/arm/mach-footbridge/time.c
===================================================================
--- gettimeoffset.orig/arch/arm/mach-footbridge/time.c	2009-12-22 18:50:54.000000000 -0800
+++ gettimeoffset/arch/arm/mach-footbridge/time.c	2009-12-22 18:51:20.000000000 -0800
@@ -61,12 +61,12 @@ static unsigned long __init get_isa_cmos
 	return mktime(year, mon, day, hour, min, sec);
 }
 
-static int set_isa_cmos_time(void)
+static int set_isa_cmos_time(struct timespec now)
 {
 	int retval = 0;
 	int real_seconds, real_minutes, cmos_minutes;
 	unsigned char save_control, save_freq_select;
-	unsigned long nowtime = xtime.tv_sec;
+	unsigned long nowtime = now.tv_sec;
 
 	save_control = CMOS_READ(RTC_CONTROL); /* tell the clock it's being set */
 	CMOS_WRITE((save_control|RTC_SET), RTC_CONTROL);


