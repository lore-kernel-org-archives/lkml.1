Return-Path: <linux-kernel-owner+w=401wt.eu-S1751462AbZHOJBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751462AbZHOJBw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 05:01:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751303AbZHOJBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 05:01:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:41736 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937AbZHOJBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 05:01:49 -0400
Date: Sat, 15 Aug 2009 09:01:24 GMT
From: tip-bot for John Stultz <johnstul@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       johnstul@us.ibm.com, schwidefsky@de.ibm.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       johnstul@us.ibm.com, schwidefsky@de.ibm.com, tglx@linutronix.de
In-Reply-To: <20090814134807.609730216@de.ibm.com>
References: <20090814134807.609730216@de.ibm.com>
Subject: [tip:timers/core] timekeeping: Introduce timekeeping_leap_insert
Message-ID: <tip-31089c13bcb18d2cd2a3ddfbe3a28666346f237e@git.kernel.org>
Git-Commit-ID: 31089c13bcb18d2cd2a3ddfbe3a28666346f237e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 15 Aug 2009 09:01:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  31089c13bcb18d2cd2a3ddfbe3a28666346f237e
Gitweb:     http://git.kernel.org/tip/31089c13bcb18d2cd2a3ddfbe3a28666346f237e
Author:     John Stultz <johnstul@us.ibm.com>
AuthorDate: Fri, 14 Aug 2009 15:47:18 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 15 Aug 2009 10:55:45 +0200

timekeeping: Introduce timekeeping_leap_insert

Move the adjustment of xtime, wall_to_monotonic and the update of the
vsyscall variables to the timekeeping code.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
LKML-Reference: <20090814134807.609730216@de.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>


---
 include/linux/time.h      |    1 +
 kernel/time/ntp.c         |    7 ++-----
 kernel/time/timekeeping.c |    7 +++++++
 3 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/include/linux/time.h b/include/linux/time.h
index ea16c1a..e7c8445 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -147,6 +147,7 @@ extern struct timespec timespec_trunc(struct timespec t, unsigned gran);
 extern int timekeeping_valid_for_hres(void);
 extern void update_wall_time(void);
 extern void update_xtime_cache(u64 nsec);
+extern void timekeeping_leap_insert(int leapsecond);
 
 struct tms;
 extern void do_sys_times(struct tms *);
diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 7fc6437..4800f93 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -194,8 +194,7 @@ static enum hrtimer_restart ntp_leap_second(struct hrtimer *timer)
 	case TIME_OK:
 		break;
 	case TIME_INS:
-		xtime.tv_sec--;
-		wall_to_monotonic.tv_sec++;
+		timekeeping_leap_insert(-1);
 		time_state = TIME_OOP;
 		printk(KERN_NOTICE
 			"Clock: inserting leap second 23:59:60 UTC\n");
@@ -203,9 +202,8 @@ static enum hrtimer_restart ntp_leap_second(struct hrtimer *timer)
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
@@ -219,7 +217,6 @@ static enum hrtimer_restart ntp_leap_second(struct hrtimer *timer)
 			time_state = TIME_OK;
 		break;
 	}
-	update_vsyscall(&xtime, clock);
 
 	write_sequnlock(&xtime_lock);
 
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 02c0b2c..b8b70fb 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
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
