Return-Path: <linux-kernel-owner+w=401wt.eu-S1763303AbXGOQGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763303AbXGOQGx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 12:06:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762619AbXGOQEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 12:04:53 -0400
Received: from www.osadl.org ([213.239.205.134]:42532 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762581AbXGOQEv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 12:04:51 -0400
Message-Id: <20070715155540.724510405@inhelltoy.tec.linutronix.de>
References: <20070715155510.341941668@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sun, 15 Jul 2007 16:10:43 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@suse.de>
Subject: [patch-mm 02/33] clockevents: Allow build w/o run-tine usage for
	migration purposes
Content-Disposition: inline;
	filename=clockevents-allow-build-without-runtime-use.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Migration aid to allow preparatory patches which introduce not yet
used parts of clock events code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>

---
 include/linux/clockchips.h |    8 ++++++--
 kernel/time/Kconfig        |    5 +++++
 kernel/time/Makefile       |    2 +-
 kernel/time/clockevents.c  |    3 ++-
 4 files changed, 14 insertions(+), 4 deletions(-)

Index: linux-2.6.22-rc6-mm/kernel/time/Kconfig
===================================================================
--- linux-2.6.22-rc6-mm.orig/kernel/time/Kconfig	2007-07-15 09:43:59.000000000 +0200
+++ linux-2.6.22-rc6-mm/kernel/time/Kconfig	2007-07-15 09:44:08.000000000 +0200
@@ -23,3 +23,8 @@ config HIGH_RES_TIMERS
 	  hardware is not capable then this option only increases
 	  the size of the kernel image.
 
+config GENERIC_CLOCKEVENTS_BUILD
+	bool
+	default y
+	depends on GENERIC_CLOCKEVENTS || GENERIC_CLOCKEVENTS_MIGR
+
Index: linux-2.6.22-rc6-mm/kernel/time/Makefile
===================================================================
--- linux-2.6.22-rc6-mm.orig/kernel/time/Makefile	2007-07-15 09:43:59.000000000 +0200
+++ linux-2.6.22-rc6-mm/kernel/time/Makefile	2007-07-15 09:44:08.000000000 +0200
@@ -1,6 +1,6 @@
 obj-y += timekeeping.o ntp.o clocksource.o jiffies.o timer_list.o
 
-obj-$(CONFIG_GENERIC_CLOCKEVENTS)		+= clockevents.o
+obj-$(CONFIG_GENERIC_CLOCKEVENTS_BUILD)		+= clockevents.o
 obj-$(CONFIG_GENERIC_CLOCKEVENTS)		+= tick-common.o
 obj-$(CONFIG_GENERIC_CLOCKEVENTS_BROADCAST)	+= tick-broadcast.o
 obj-$(CONFIG_TICK_ONESHOT)			+= tick-oneshot.o
Index: linux-2.6.22-rc6-mm/include/linux/clockchips.h
===================================================================
--- linux-2.6.22-rc6-mm.orig/include/linux/clockchips.h	2007-07-15 09:44:07.000000000 +0200
+++ linux-2.6.22-rc6-mm/include/linux/clockchips.h	2007-07-15 09:44:08.000000000 +0200
@@ -8,7 +8,7 @@
 #ifndef _LINUX_CLOCKCHIPS_H
 #define _LINUX_CLOCKCHIPS_H
 
-#ifdef CONFIG_GENERIC_CLOCKEVENTS
+#ifdef CONFIG_GENERIC_CLOCKEVENTS_BUILD
 
 #include <linux/clocksource.h>
 #include <linux/cpumask.h>
@@ -127,9 +127,13 @@ extern void clockevents_unregister_notif
 extern int clockevents_program_event(struct clock_event_device *dev,
 				     ktime_t expires, ktime_t now);
 
+#ifdef CONFIG_GENERIC_CLOCKEVENTS
 extern void clockevents_notify(unsigned long reason, void *arg);
-
 #else
+# define clockevents_notify(reason, arg) do { } while (0)
+#endif
+
+#else /* CONFIG_GENERIC_CLOCKEVENTS_BUILD */
 
 #define clockevents_notify(reason, arg) do { } while (0)
 
Index: linux-2.6.22-rc6-mm/kernel/time/clockevents.c
===================================================================
--- linux-2.6.22-rc6-mm.orig/kernel/time/clockevents.c	2007-07-15 09:43:59.000000000 +0200
+++ linux-2.6.22-rc6-mm/kernel/time/clockevents.c	2007-07-15 16:30:12.000000000 +0200
@@ -245,6 +245,7 @@ void clockevents_release_device(struct c
 	spin_unlock(&clockevents_lock);
 }
 
+#ifdef CONFIG_GENERIC_CLOCKEVENTS
 /**
  * clockevents_notify - notification about relevant events
  */
@@ -273,4 +274,4 @@ void clockevents_notify(unsigned long re
 	spin_unlock(&clockevents_lock);
 }
 EXPORT_SYMBOL_GPL(clockevents_notify);
-
+#endif

-- 

