Return-Path: <linux-kernel-owner+w=401wt.eu-S933166AbXAWWBI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933166AbXAWWBI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 17:01:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933165AbXAWWBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 17:01:07 -0500
Received: from www.osadl.org ([213.239.205.134]:35871 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933162AbXAWWBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 17:01:04 -0500
Message-Id: <20070123211206.187512000@localhost.localdomain>
References: <20070123211159.178138000@localhost.localdomain>
Date: Tue, 23 Jan 2007 22:01:18 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       John Stultz <johnstul@us.ibm.com>,
       Arjan van de Veen <arjan@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: [patch 22/46] Extend next_timer_interrupt() to use a reference jiffie
Content-Disposition: inline;
	filename=dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

For CONFIG_NO_HZ we need to calculate the next timer wheel event based
on a given jiffie value.  Extend the existing code to allow the extra
'now' argument. Provide a compability function for the existing
implementations to call the function with now == jiffies. (This also
solves the racyness of the original code vs. jiffies changing during
the iteration.)

No functional changes to existing users of this infrastructure.

[ remove WARN_ON() that triggered on s390, by Carsten Otte <cotte@de.ibm.com> ]
[ made new helper static, Adrian Bunk <bunk@stusta.de> ]

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/timer.h |   10 ++++++++++
 kernel/hrtimer.c      |    2 +-
 kernel/timer.c        |   14 +++++++++++---
 3 files changed, 22 insertions(+), 4 deletions(-)

Index: linux-2.6.20-rc4-mm1-bo/include/linux/timer.h
===================================================================
--- linux-2.6.20-rc4-mm1-bo.orig/include/linux/timer.h
+++ linux-2.6.20-rc4-mm1-bo/include/linux/timer.h
@@ -61,7 +61,17 @@ extern int del_timer(struct timer_list *
 extern int __mod_timer(struct timer_list *timer, unsigned long expires);
 extern int mod_timer(struct timer_list *timer, unsigned long expires);
 
+/*
+ * Return when the next timer-wheel timeout occurs (in absolute jiffies),
+ * locks the timer base:
+ */
 extern unsigned long next_timer_interrupt(void);
+/*
+ * Return when the next timer-wheel timeout occurs (in absolute jiffies),
+ * locks the timer base and does the comparison against the given
+ * jiffie.
+ */
+extern unsigned long get_next_timer_interrupt(unsigned long now);
 
 /***
  * add_timer - start a timer
Index: linux-2.6.20-rc4-mm1-bo/kernel/hrtimer.c
===================================================================
--- linux-2.6.20-rc4-mm1-bo.orig/kernel/hrtimer.c
+++ linux-2.6.20-rc4-mm1-bo/kernel/hrtimer.c
@@ -533,7 +533,7 @@ ktime_t hrtimer_get_remaining(const stru
 }
 EXPORT_SYMBOL_GPL(hrtimer_get_remaining);
 
-#ifdef CONFIG_NO_IDLE_HZ
+#if defined(CONFIG_NO_IDLE_HZ) || defined(CONFIG_NO_HZ)
 /**
  * hrtimer_get_next_event - get the time until next expiry event
  *
Index: linux-2.6.20-rc4-mm1-bo/kernel/timer.c
===================================================================
--- linux-2.6.20-rc4-mm1-bo.orig/kernel/timer.c
+++ linux-2.6.20-rc4-mm1-bo/kernel/timer.c
@@ -591,7 +591,7 @@ static inline void __run_timers(tvec_bas
 	spin_unlock_irq(&base->lock);
 }
 
-#ifdef CONFIG_NO_IDLE_HZ
+#if defined(CONFIG_NO_IDLE_HZ) || defined(CONFIG_NO_HZ)
 /*
  * Find out when the next timer event is due to happen. This
  * is used on S/390 to stop all activity when a cpus is idle.
@@ -687,10 +687,10 @@ static unsigned long cmp_next_hrtimer_ev
 /**
  * next_timer_interrupt - return the jiffy of the next pending timer
  */
-unsigned long next_timer_interrupt(void)
+unsigned long get_next_timer_interrupt(unsigned long now)
 {
 	tvec_base_t *base = __get_cpu_var(tvec_bases);
-	unsigned long expires, now = jiffies;
+	unsigned long expires;
 
 	spin_lock(&base->lock);
 	expires = __next_timer_interrupt(base);
@@ -701,6 +701,14 @@ unsigned long next_timer_interrupt(void)
 
 	return cmp_next_hrtimer_event(now, expires);
 }
+
+#ifdef CONFIG_NO_IDLE_HZ
+unsigned long next_timer_interrupt(void)
+{
+	return get_next_timer_interrupt(jiffies);
+}
+#endif
+
 #endif
 
 /******************************************************************/

--

