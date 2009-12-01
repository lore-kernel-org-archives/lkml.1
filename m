Return-Path: <linux-kernel-owner+w=401wt.eu-S1753520AbZLAOmH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbZLAOmH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 09:42:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752658AbZLAOmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 09:42:06 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:35330 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727AbZLAOmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 09:42:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=VY0di4eoJPdoRR9bwVgnWz/LzW6XMhDGRdj/6XJvFoklCfSAICzNP9uMqXoW5GHN4R
         9drcacEjfsoLoZofS5Alnu4/EcnHt/ma+8q90M8jDg2RtK5gMLGKxGK0Zn1HKrMP+5Yj
         zzrMRvFBFH3Z0NgOYpL2BL0wWFHifjNoRvH1w=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, johnstul@us.ibm.com, lethal@linux-sh.org,
       linux-pm@lists.linux-foundation.org,
       Magnus Damm <magnus.damm@gmail.com>, tglx@linutronix.de
Date: Tue, 01 Dec 2009 23:36:39 +0900
Message-Id: <20091201143639.15075.36789.sendpatchset@rxone.opensource.se>
Subject: [PATCH] clocksource: Add suspend callback
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Add a clocksource suspend callback. This callback can
be used by the clocksource driver to shutdown and perform
any kind of late suspend activities even though the
clocksource driver itself is a non-sysdev driver.

One example where this is useful is to fix the sh_cmt.c
platform driver that today suspends using the platform bus
and shuts down the clocksource too early.

With this callback in place the sh_cmt driver will suspend
using the clocksource and clockevent hooks and leave the
platform device pm callbacks unused.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 Applies to linux-next

 include/linux/clocksource.h |    3 +++
 kernel/time/clocksource.c   |   12 ++++++++++++
 kernel/time/timekeeping.c   |    1 +
 3 files changed, 16 insertions(+)

--- 0002/include/linux/clocksource.h
+++ work/include/linux/clocksource.h	2009-11-30 13:31:40.000000000 +0900
@@ -154,6 +154,7 @@ extern u64 timecounter_cyc2time(struct t
  * @max_idle_ns:	max idle time permitted by the clocksource (nsecs)
  * @flags:		flags describing special properties
  * @vread:		vsyscall based read
+ * @suspend:		suspend function for the clocksource, if necessary
  * @resume:		resume function for the clocksource, if necessary
  */
 struct clocksource {
@@ -172,6 +173,7 @@ struct clocksource {
 	u64 max_idle_ns;
 	unsigned long flags;
 	cycle_t (*vread)(void);
+	void (*suspend)(struct clocksource *cs);
 	void (*resume)(struct clocksource *cs);
 #ifdef CONFIG_IA64
 	void *fsys_mmio;        /* used by fsyscall asm code */
@@ -277,6 +279,7 @@ extern void clocksource_unregister(struc
 extern void clocksource_touch_watchdog(void);
 extern struct clocksource* clocksource_get_next(void);
 extern void clocksource_change_rating(struct clocksource *cs, int rating);
+extern void clocksource_suspend(void);
 extern void clocksource_resume(void);
 extern struct clocksource * __init __weak clocksource_default_clock(void);
 
--- 0002/kernel/time/clocksource.c
+++ work/kernel/time/clocksource.c	2009-11-30 13:30:52.000000000 +0900
@@ -441,6 +441,18 @@ static inline int clocksource_watchdog_k
 #endif /* CONFIG_CLOCKSOURCE_WATCHDOG */
 
 /**
+ * clocksource_suspend - suspend the clocksource(s)
+ */
+void clocksource_suspend(void)
+{
+	struct clocksource *cs;
+
+	list_for_each_entry_reverse(cs, &clocksource_list, list)
+		if (cs->suspend)
+			cs->suspend(cs);
+}
+
+/**
  * clocksource_resume - resume the clocksource(s)
  */
 void clocksource_resume(void)
--- 0001/kernel/time/timekeeping.c
+++ work/kernel/time/timekeeping.c	2009-11-30 13:42:56.000000000 +0900
@@ -611,6 +611,7 @@ static int timekeeping_suspend(struct sy
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 
 	clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, NULL);
+	clocksource_suspend();
 
 	return 0;
 }
