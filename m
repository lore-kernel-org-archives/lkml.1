Return-Path: <linux-kernel-owner+w=401wt.eu-S932258AbZKMTuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932258AbZKMTuh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 14:50:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932237AbZKMTue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 14:50:34 -0500
Received: from hera.kernel.org ([140.211.167.34]:36062 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932223AbZKMTuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 14:50:32 -0500
Date: Fri, 13 Nov 2009 19:50:18 GMT
From: tip-bot for Jon Hunter <jon-hunter@ti.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       johnstul@us.ibm.com, jon-hunter@ti.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       johnstul@us.ibm.com, jon-hunter@ti.com, tglx@linutronix.de
In-Reply-To: <1250617512-23567-3-git-send-email-jon-hunter@ti.com>
References: <1250617512-23567-3-git-send-email-jon-hunter@ti.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] nohz: Allow 32-bit machines to sleep for more than 2.15 seconds
Message-ID: <tip-97813f2fe77804a4464564c75ba8d8826377feea@git.kernel.org>
Git-Commit-ID: 97813f2fe77804a4464564c75ba8d8826377feea
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  97813f2fe77804a4464564c75ba8d8826377feea
Gitweb:     http://git.kernel.org/tip/97813f2fe77804a4464564c75ba8d8826377feea
Author:     Jon Hunter <jon-hunter@ti.com>
AuthorDate: Tue, 18 Aug 2009 12:45:11 -0500
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 13 Nov 2009 20:46:24 +0100

nohz: Allow 32-bit machines to sleep for more than 2.15 seconds

In the dynamic tick code, "max_delta_ns" (member of the
"clock_event_device" structure) represents the maximum sleep time
that can occur between timer events in nanoseconds.

The variable, "max_delta_ns", is defined as an unsigned long
which is a 32-bit integer for 32-bit machines and a 64-bit
integer for 64-bit machines (if -m64 option is used for gcc).
The value of max_delta_ns is set by calling the function
"clockevent_delta2ns()" which returns a maximum value of LONG_MAX.
For a 32-bit machine LONG_MAX is equal to 0x7fffffff and in
nanoseconds this equates to ~2.15 seconds. Hence, the maximum
sleep time for a 32-bit machine is ~2.15 seconds, where as for
a 64-bit machine it will be many years.

This patch changes the type of max_delta_ns to be "u64" instead of
"unsigned long" so that this variable is a 64-bit type for both 32-bit
and 64-bit machines. It also changes the maximum value returned by
clockevent_delta2ns() to KTIME_MAX.  Hence this allows a 32-bit
machine to sleep for longer than ~2.15 seconds. Please note that this
patch also changes "min_delta_ns" to be "u64" too and although this is
unnecessary, it makes the patch simpler as it avoids to fixup all
callers of clockevent_delta2ns().

[ tglx: changed "unsigned long long" to u64 as we use this data type
  	through out the time code ]

Signed-off-by: Jon Hunter <jon-hunter@ti.com>
Cc: John Stultz <johnstul@us.ibm.com>
LKML-Reference: <1250617512-23567-3-git-send-email-jon-hunter@ti.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/clockchips.h |    8 ++++----
 kernel/hrtimer.c           |    3 ++-
 kernel/time/clockevents.c  |   11 +++++------
 kernel/time/tick-oneshot.c |    4 ++--
 kernel/time/timer_list.c   |    6 ++++--
 5 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
index 4d438b0..0cf725b 100644
--- a/include/linux/clockchips.h
+++ b/include/linux/clockchips.h
@@ -77,8 +77,8 @@ enum clock_event_nofitiers {
 struct clock_event_device {
 	const char		*name;
 	unsigned int		features;
-	unsigned long		max_delta_ns;
-	unsigned long		min_delta_ns;
+	u64			max_delta_ns;
+	u64			min_delta_ns;
 	u32			mult;
 	u32			shift;
 	int			rating;
@@ -116,8 +116,8 @@ static inline unsigned long div_sc(unsigned long ticks, unsigned long nsec,
 }
 
 /* Clock event layer functions */
-extern unsigned long clockevent_delta2ns(unsigned long latch,
-					 struct clock_event_device *evt);
+extern u64 clockevent_delta2ns(unsigned long latch,
+			       struct clock_event_device *evt);
 extern void clockevents_register_device(struct clock_event_device *dev);
 
 extern void clockevents_exchange_device(struct clock_event_device *old,
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 6d70204..c215b74 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1240,7 +1240,8 @@ hrtimer_interrupt_hanging(struct clock_event_device *dev,
 	force_clock_reprogram = 1;
 	dev->min_delta_ns = (unsigned long)try_time.tv64 * 3;
 	printk(KERN_WARNING "hrtimer: interrupt too slow, "
-		"forcing clock min delta to %lu ns\n", dev->min_delta_ns);
+	       "forcing clock min delta to %llu ns\n",
+	       (unsigned long long) dev->min_delta_ns);
 }
 /*
  * High resolution timer interrupt
diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index 620b58a..05e8aee 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -37,10 +37,9 @@ static DEFINE_SPINLOCK(clockevents_lock);
  *
  * Math helper, returns latch value converted to nanoseconds (bound checked)
  */
-unsigned long clockevent_delta2ns(unsigned long latch,
-				  struct clock_event_device *evt)
+u64 clockevent_delta2ns(unsigned long latch, struct clock_event_device *evt)
 {
-	u64 clc = ((u64) latch << evt->shift);
+	u64 clc = (u64) latch << evt->shift;
 
 	if (unlikely(!evt->mult)) {
 		evt->mult = 1;
@@ -50,10 +49,10 @@ unsigned long clockevent_delta2ns(unsigned long latch,
 	do_div(clc, evt->mult);
 	if (clc < 1000)
 		clc = 1000;
-	if (clc > LONG_MAX)
-		clc = LONG_MAX;
+	if (clc > KTIME_MAX)
+		clc = KTIME_MAX;
 
-	return (unsigned long) clc;
+	return clc;
 }
 EXPORT_SYMBOL_GPL(clockevent_delta2ns);
 
diff --git a/kernel/time/tick-oneshot.c b/kernel/time/tick-oneshot.c
index a96c0e2..0a8a213 100644
--- a/kernel/time/tick-oneshot.c
+++ b/kernel/time/tick-oneshot.c
@@ -50,9 +50,9 @@ int tick_dev_program_event(struct clock_event_device *dev, ktime_t expires,
 				dev->min_delta_ns += dev->min_delta_ns >> 1;
 
 			printk(KERN_WARNING
-			       "CE: %s increasing min_delta_ns to %lu nsec\n",
+			       "CE: %s increasing min_delta_ns to %llu nsec\n",
 			       dev->name ? dev->name : "?",
-			       dev->min_delta_ns << 1);
+			       (unsigned long long) dev->min_delta_ns << 1);
 
 			i = 0;
 		}
diff --git a/kernel/time/timer_list.c b/kernel/time/timer_list.c
index fa00da1..665c76e 100644
--- a/kernel/time/timer_list.c
+++ b/kernel/time/timer_list.c
@@ -204,8 +204,10 @@ print_tickdevice(struct seq_file *m, struct tick_device *td, int cpu)
 		return;
 	}
 	SEQ_printf(m, "%s\n", dev->name);
-	SEQ_printf(m, " max_delta_ns:   %lu\n", dev->max_delta_ns);
-	SEQ_printf(m, " min_delta_ns:   %lu\n", dev->min_delta_ns);
+	SEQ_printf(m, " max_delta_ns:   %llu\n",
+		   (unsigned long long) dev->max_delta_ns);
+	SEQ_printf(m, " min_delta_ns:   %llu\n",
+		   (unsigned long long) dev->min_delta_ns);
 	SEQ_printf(m, " mult:           %u\n", dev->mult);
 	SEQ_printf(m, " shift:          %u\n", dev->shift);
 	SEQ_printf(m, " mode:           %d\n", dev->mode);
