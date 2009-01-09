Return-Path: <linux-kernel-owner+w=401wt.eu-S1756800AbZAIUcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800AbZAIUcB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 15:32:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756573AbZAIUbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 15:31:14 -0500
Received: from bee.hiwaay.net ([216.180.54.11]:38448 "EHLO bee.hiwaay.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756449AbZAIUbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 15:31:12 -0500
Date: Fri, 9 Jan 2009 14:31:10 -0600
From: Chris Adams <cmadams@hiwaay.net>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix leap second message hang
Message-ID: <20090109203110.GA1523360@hiwaay.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resending this outside the big long thread to make sure it gets added
(it isn't critical right now but I don't want to forget it).

From: Chris Adams <cmadams@hiwaay.net>

The code to handle leap seconds printks an information message when the
second is inserted or deleted.  It does this while holding xtime_lock.
However, printk wakes up klogd, and in some cases, the scheduler tries
to get the current kernel time, trying to get xtime_lock (which results
in a deadlock).  This moved the printks outside of the lock.  It also
adds a comment to not use printk while holding xtime_lock.

Signed-off-by: Chris Adams <cmadams@hiwaay.net>
Acked-by: Linas Vepstas <linasvepstas@gmail.com>
---
diff -urpN linux-2.6.28-git5-vanilla/include/linux/time.h linux-2.6.28-git5/include/linux/time.h
--- linux-2.6.28-git5-vanilla/include/linux/time.h	2009-01-02 22:09:10.000000000 -0600
+++ linux-2.6.28-git5/include/linux/time.h	2009-01-03 11:57:27.000000000 -0600
@@ -99,6 +99,12 @@ static inline struct timespec timespec_s
 
 extern struct timespec xtime;
 extern struct timespec wall_to_monotonic;
+
+/*
+ * Do not call printk while holding this lock; it wakes klogd and the
+ * scheduler may try to get the current kernel time, which will try to get
+ * this lock.
+ */
 extern seqlock_t xtime_lock;
 
 extern unsigned long read_persistent_clock(void);
diff -urpN linux-2.6.28-git5-vanilla/kernel/time/ntp.c linux-2.6.28-git5/kernel/time/ntp.c
--- linux-2.6.28-git5-vanilla/kernel/time/ntp.c	2009-01-02 22:09:34.000000000 -0600
+++ linux-2.6.28-git5/kernel/time/ntp.c	2009-01-03 11:57:46.000000000 -0600
@@ -130,6 +130,7 @@ void ntp_clear(void)
 static enum hrtimer_restart ntp_leap_second(struct hrtimer *timer)
 {
 	enum hrtimer_restart res = HRTIMER_NORESTART;
+	const char *msg = NULL;
 
 	write_seqlock(&xtime_lock);
 
@@ -140,8 +141,7 @@ static enum hrtimer_restart ntp_leap_sec
 		xtime.tv_sec--;
 		wall_to_monotonic.tv_sec++;
 		time_state = TIME_OOP;
-		printk(KERN_NOTICE "Clock: "
-		       "inserting leap second 23:59:60 UTC\n");
+		msg = "Clock: inserting leap second 23:59:60 UTC";
 		hrtimer_add_expires_ns(&leap_timer, NSEC_PER_SEC);
 		res = HRTIMER_RESTART;
 		break;
@@ -150,8 +150,7 @@ static enum hrtimer_restart ntp_leap_sec
 		time_tai--;
 		wall_to_monotonic.tv_sec--;
 		time_state = TIME_WAIT;
-		printk(KERN_NOTICE "Clock: "
-		       "deleting leap second 23:59:59 UTC\n");
+		msg = "Clock: deleting leap second 23:59:59 UTC";
 		break;
 	case TIME_OOP:
 		time_tai++;
@@ -166,6 +165,9 @@ static enum hrtimer_restart ntp_leap_sec
 
 	write_sequnlock(&xtime_lock);
 
+	if (msg)
+		printk(KERN_NOTICE "%s\n", msg);
+
 	return res;
 }
 
