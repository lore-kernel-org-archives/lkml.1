Return-Path: <linux-kernel-owner+w=401wt.eu-S1752520AbXFYUGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520AbXFYUGj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 16:06:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751426AbXFYUGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 16:06:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51964 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751209AbXFYUGc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 16:06:32 -0400
Date: Mon, 25 Jun 2007 22:06:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [patch, v2.6.22-rc6] sys_time() speedup
Message-ID: <20070625200601.GA18980@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [patch] sys_time() speedup
From: Ingo Molnar <mingo@elte.hu>

improve performance of sys_time(). sys_time() returns time in seconds, 
but it does so by calling do_gettimeofday() and then returning the 
tv_sec portion of the GTOD time. But the data structure "xtime", which 
is updated by every timer/scheduler tick, already offers HZ granularity 
time.

the patch improves the sysbench OLTP macrobenchmark significantly:

2.6.22-rc6:

#threads
   1:        transactions:                        3733   (373.21 per sec.)
   2:        transactions:                        6676   (667.46 per sec.)
   3:        transactions:                        6957   (695.50 per sec.)
   4:        transactions:                        7055   (705.48 per sec.)
   5:        transactions:                        6596   (659.33 per sec.)

2.6.22-rc6 + sys_time.patch:

   1:        transactions:                        4005   (400.47 per sec.)
   2:        transactions:                        7379   (737.77 per sec.)
   3:        transactions:                        7347   (734.49 per sec.)
   4:        transactions:                        7468   (746.65 per sec.)
   5:        transactions:                        7428   (742.47 per sec.)

mixed API uses of gettimeofday() and time() are guaranteed to be 
coherent via the use of a at-most-once-per-second slowpath that updates 
xtime.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/time.c |   27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

Index: linux/kernel/time.c
===================================================================
--- linux.orig/kernel/time.c
+++ linux/kernel/time.c
@@ -57,14 +57,17 @@ EXPORT_SYMBOL(sys_tz);
  */
 asmlinkage long sys_time(time_t __user * tloc)
 {
-	time_t i;
-	struct timeval tv;
+	/*
+	 * We read xtime.tv_sec atomically - it's updated
+	 * atomically by update_wall_time(), so no need to
+	 * even read-lock the xtime seqlock:
+	 */
+	time_t i = xtime.tv_sec;
 
-	do_gettimeofday(&tv);
-	i = tv.tv_sec;
+	smp_rmb(); /* sys_time() results are coherent */
 
 	if (tloc) {
-		if (put_user(i,tloc))
+		if (put_user(i, tloc))
 			i = -EFAULT;
 	}
 	return i;
@@ -373,6 +376,20 @@ void do_gettimeofday (struct timeval *tv
 
 	tv->tv_sec = sec;
 	tv->tv_usec = usec;
+
+	/*
+	 * Make sure xtime.tv_sec [returned by sys_time()] always
+	 * follows the gettimeofday() result precisely. This
+	 * condition is extremely unlikely, it can hit at most
+	 * once per second:
+	 */
+	if (unlikely(xtime.tv_sec != tv->tv_sec)) {
+		unsigned long flags;
+
+		write_seqlock_irqsave(&xtime_lock);
+		update_wall_time();
+		write_seqlock_irqrestore(&xtime_lock);
+	}
 }
 
 EXPORT_SYMBOL(do_gettimeofday);
