Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145Ab0CDD5w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 22:57:52 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:38453 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754973Ab0CDD5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 22:57:40 -0500
From: John Stultz <johnstul@us.ibm.com>
To: "	lkml" <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>, Kyle McMartin <kyle@mcmartin.ca>,
       Helge Deller <deller@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 04/14] parisc: Convert parisc to use read/update_persistent_clock
Date: Wed,  3 Mar 2010 19:57:19 -0800
Message-Id: <1267675049-12337-5-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1267675049-12337-4-git-send-email-johnstul@us.ibm.com>
References: <1267675049-12337-1-git-send-email-johnstul@us.ibm.com>
 <1267675049-12337-2-git-send-email-johnstul@us.ibm.com>
 <1267675049-12337-3-git-send-email-johnstul@us.ibm.com>
 <1267675049-12337-4-git-send-email-johnstul@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the parisc architecture to use the generic read_persistent_clock and update_persistent_clock interfaces, reducing the amount of arch specific code we have to maintain, and allowing for further cleanups in the future.

I have not built or tested this patch, so help from arch maintainers would be appreciated.

Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Helge Deller <deller@gmx.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 arch/parisc/kernel/time.c |   29 +++++++++++++----------------
 1 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/arch/parisc/kernel/time.c b/arch/parisc/kernel/time.c
index a79c6f9..05511cc 100644
--- a/arch/parisc/kernel/time.c
+++ b/arch/parisc/kernel/time.c
@@ -250,9 +250,21 @@ static int __init rtc_init(void)
 }
 module_init(rtc_init);
 
-void __init time_init(void)
+void read_persistent_clock(struct timespec *ts)
 {
 	static struct pdc_tod tod_data;
+	if (pdc_tod_read(&tod_data) == 0) {
+		ts->tv_sec = tod_data.tod_sec;
+		ts->tv_nsec = tod_data.tod_usec * 1000;
+	} else {
+		printk(KERN_ERR "Error reading tod clock\n");
+	        ts->tv_sec = 0;
+		ts->tv_nsec = 0;
+	}
+}
+
+void __init time_init(void)
+{
 	unsigned long current_cr16_khz;
 
 	clocktick = (100 * PAGE0->mem_10msec) / HZ;
@@ -264,19 +276,4 @@ void __init time_init(void)
 	clocksource_cr16.mult = clocksource_khz2mult(current_cr16_khz,
 						clocksource_cr16.shift);
 	clocksource_register(&clocksource_cr16);
-
-	if (pdc_tod_read(&tod_data) == 0) {
-		unsigned long flags;
-
-		write_seqlock_irqsave(&xtime_lock, flags);
-		xtime.tv_sec = tod_data.tod_sec;
-		xtime.tv_nsec = tod_data.tod_usec * 1000;
-		set_normalized_timespec(&wall_to_monotonic,
-		                        -xtime.tv_sec, -xtime.tv_nsec);
-		write_sequnlock_irqrestore(&xtime_lock, flags);
-	} else {
-		printk(KERN_ERR "Error reading tod clock\n");
-	        xtime.tv_sec = 0;
-		xtime.tv_nsec = 0;
-	}
 }
-- 
1.6.0.4

