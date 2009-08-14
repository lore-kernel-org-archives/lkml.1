Return-Path: <linux-kernel-owner+w=401wt.eu-S1756796AbZHNNsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796AbZHNNsN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 09:48:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755712AbZHNNsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 09:48:10 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:64166 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353AbZHNNsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 09:48:08 -0400
Message-Id: <20090814134807.609730216@de.ibm.com>
References: <20090814134717.859098725@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Fri, 14 Aug 2009 15:47:18 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       john stultz <johnstul@us.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 01/15] introduce timekeeping_leap_insert
Content-Disposition: inline; filename=leap_insert.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: john stultz <johnstul@us.ibm.com>

Signed-off-by: john stultz <johnstul@us.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 include/linux/time.h      |    1 +
 kernel/time/ntp.c         |    7 ++-----
 kernel/time/timekeeping.c |    7 +++++++
 3 files changed, 10 insertions(+), 5 deletions(-)

Index: linux-2.6/include/linux/time.h
===================================================================
--- linux-2.6.orig/include/linux/time.h
+++ linux-2.6/include/linux/time.h
@@ -147,6 +147,7 @@ extern struct timespec timespec_trunc(st
 extern int timekeeping_valid_for_hres(void);
 extern void update_wall_time(void);
 extern void update_xtime_cache(u64 nsec);
+extern void timekeeping_leap_insert(int leapsecond);
 
 struct tms;
 extern void do_sys_times(struct tms *);
Index: linux-2.6/kernel/time/ntp.c
===================================================================
--- linux-2.6.orig/kernel/time/ntp.c
+++ linux-2.6/kernel/time/ntp.c
@@ -194,8 +194,7 @@ static enum hrtimer_restart ntp_leap_sec
 	case TIME_OK:
 		break;
 	case TIME_INS:
-		xtime.tv_sec--;
-		wall_to_monotonic.tv_sec++;
+		timekeeping_leap_insert(-1);
 		time_state = TIME_OOP;
 		printk(KERN_NOTICE
 			"Clock: inserting leap second 23:59:60 UTC\n");
@@ -203,9 +202,8 @@ static enum hrtimer_restart ntp_leap_sec
 		res = HRTIMER_RESTART;
 		break;
 	case TIME_DEL:
-		xtime.tv_sec++;
+		timekeeping_leap_insert(1);
 		time_tai--;
-		wall_to_monotonic.tv_sec--;
 		time_state = TIME_WAIT;
 		printk(KERN_NOTICE
 			"Clock: deleting leap second 23:59:59 UTC\n");
@@ -219,7 +217,6 @@ static enum hrtimer_restart ntp_leap_sec
 			time_state = TIME_OK;
 		break;
 	}
-	update_vsyscall(&xtime, clock);
 
 	write_sequnlock(&xtime_lock);
 
Index: linux-2.6/kernel/time/timekeeping.c
===================================================================
--- linux-2.6.orig/kernel/time/timekeeping.c
+++ linux-2.6/kernel/time/timekeeping.c
@@ -58,6 +58,13 @@ void update_xtime_cache(u64 nsec)
 
 struct clocksource *clock;
 
+/* must hold xtime_lock */
+void timekeeping_leap_insert(int leapsecond)
+{
+	xtime.tv_sec += leapsecond;
+	wall_to_monotonic.tv_sec -= leapsecond;
+	update_vsyscall(&xtime, clock);
+}
 
 #ifdef CONFIG_GENERIC_TIME
 /**

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

