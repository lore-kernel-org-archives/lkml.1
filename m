Return-Path: <linux-kernel-owner+w=401wt.eu-S1755094AbYE2SWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094AbYE2SWQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 14:22:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756252AbYE2SV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 14:21:57 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:62417 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758657AbYE2SV4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 14:21:56 -0400
Date: Thu, 29 May 2008 19:19:04 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Roman Zippel <zippel@linux-m68k.org>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
cc: Alessandro Zummo <a.zummo@towertech.it>, Rik van Riel <riel@redhat.com>,
       David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org
Subject: [PATCH v2] NTP: Let update_persistent_clock() sleep
Message-ID: <Pine.LNX.4.55.0805291649300.8254@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 This is a change that makes the 11-minute RTC update be run in the
process context.  This is so that update_persistent_clock() can sleep,
which may be required for certain types of RTC hardware -- most notably
I2C devices.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
Hello,

 This is the second version of the change -- the use of
schedule_delayed_work() makes it simpler and lets the timer be removed
altogether.  It obsoletes ntp-make-the-rtc-sync-mode-11-minute-again.patch
too (Andrew, please withdraw it from your tree), which is a good sign.

 Tested like the original with a Broadcom SWARM board and its M41T81 RTC
chip using the rtc-m41t80.c driver through the set of changes published 
earlier.

  Maciej

patch-2.6.26-rc1-20080505-sync-cmos-work-3
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/kernel/time/ntp.c linux-2.6.26-rc1-20080505/kernel/time/ntp.c
--- linux-2.6.26-rc1-20080505.macro/kernel/time/ntp.c	2008-05-05 02:56:03.000000000 +0000
+++ linux-2.6.26-rc1-20080505/kernel/time/ntp.c	2008-05-29 17:49:04.000000000 +0000
@@ -10,13 +10,13 @@
 
 #include <linux/mm.h>
 #include <linux/time.h>
-#include <linux/timer.h>
 #include <linux/timex.h>
 #include <linux/jiffies.h>
 #include <linux/hrtimer.h>
 #include <linux/capability.h>
 #include <linux/math64.h>
 #include <linux/clocksource.h>
+#include <linux/workqueue.h>
 #include <asm/timex.h>
 
 /*
@@ -218,11 +218,11 @@ void second_overflow(void)
 /* Disable the cmos update - used by virtualization and embedded */
 int no_sync_cmos_clock  __read_mostly;
 
-static void sync_cmos_clock(unsigned long dummy);
+static void sync_cmos_clock(struct work_struct *work);
 
-static DEFINE_TIMER(sync_cmos_timer, sync_cmos_clock, 0, 0);
+static DECLARE_DELAYED_WORK(sync_cmos_work, sync_cmos_clock);
 
-static void sync_cmos_clock(unsigned long dummy)
+static void sync_cmos_clock(struct work_struct *work)
 {
 	struct timespec now, next;
 	int fail = 1;
@@ -258,13 +258,13 @@ static void sync_cmos_clock(unsigned lon
 		next.tv_sec++;
 		next.tv_nsec -= NSEC_PER_SEC;
 	}
-	mod_timer(&sync_cmos_timer, jiffies + timespec_to_jiffies(&next));
+	schedule_delayed_work(&sync_cmos_work, timespec_to_jiffies(&next));
 }
 
 static void notify_cmos_timer(void)
 {
 	if (!no_sync_cmos_clock)
-		mod_timer(&sync_cmos_timer, jiffies + 1);
+		schedule_delayed_work(&sync_cmos_work, 0);
 }
 
 #else
