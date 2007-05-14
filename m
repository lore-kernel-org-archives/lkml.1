Return-Path: <linux-kernel-owner+w=401wt.eu-S1757791AbXENJG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757791AbXENJG4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 05:06:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755198AbXENJGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 05:06:50 -0400
Received: from www.osadl.org ([213.239.205.134]:39666 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755053AbXENJGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 05:06:49 -0400
Subject: [PATCH] timekeeping fix mismerge
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       john stultz <johnstul@us.ibm.com>
Content-Type: text/plain
Date: Mon, 14 May 2007 11:10:02 +0200
Message-Id: <1179133802.22481.327.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The time keeping code move to kernel/time/timekeeping.c broke the
clocksource resume logic patch. Fix it up and move the
clocksource_resume() call to the appropriate place.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index f9217bf..3d1042f 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -273,6 +273,8 @@ static int timekeeping_resume(struct sys_device *dev)
 	unsigned long flags;
 	unsigned long now = read_persistent_clock();
 
+	clocksource_resume();
+
 	write_seqlock_irqsave(&xtime_lock, flags);
 
 	if (now && (now > timekeeping_suspend_time)) {
diff --git a/kernel/timer.c b/kernel/timer.c
index a6c580a..5ec5490 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1499,8 +1499,6 @@ unregister_time_interpolator(struct time_interpolator *ti)
 		prev = &curr->next;
 	}
 
-	clocksource_resume();
-
 	write_seqlock_irqsave(&xtime_lock, flags);
 	if (ti == time_interpolator) {
 		/* we lost the best time-interpolator: */


