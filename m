Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936381Ab0CMBTj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:19:39 -0500
Received: from hera.kernel.org ([140.211.167.34]:46145 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934963Ab0CMAUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:20:35 -0500
Date: Sat, 13 Mar 2010 00:19:44 GMT
From: tip-bot for John Stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       dhowells@redhat.com, akpm@linux-foundation.org, johnstul@us.ibm.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       dhowells@redhat.com, johnstul@us.ibm.com, akpm@linux-foundation.org,
       tglx@linutronix.de
In-Reply-To: <1267675049-12337-4-git-send-email-johnstul@us.ibm.com>
References: <1267675049-12337-4-git-send-email-johnstul@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/cleanup] frv: Convert frv to use read/update_persistent_clock
Message-ID: <tip-739b27116a0e6903d6c85d6769e69f43d8fa4128@git.kernel.org>
Git-Commit-ID: 739b27116a0e6903d6c85d6769e69f43d8fa4128
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 13 Mar 2010 00:19:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  739b27116a0e6903d6c85d6769e69f43d8fa4128
Gitweb:     http://git.kernel.org/tip/739b27116a0e6903d6c85d6769e69f43d8fa4128
Author:     John Stultz <johnstul@us.ibm.com>
AuthorDate: Wed, 3 Mar 2010 19:57:18 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 13 Mar 2010 01:14:09 +0100

frv: Convert frv to use read/update_persistent_clock

This patch converts the frv architecture to use the generic
read_persistent_clock and update_persistent_clock interfaces, reducing
the amount of arch specific code we have to maintain, and allowing for
further cleanups in the future.

I have not built or tested this patch, so help from arch maintainers
would be appreciated.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <1267675049-12337-4-git-send-email-johnstul@us.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/frv/kernel/time.c |   34 +++++++---------------------------
 1 files changed, 7 insertions(+), 27 deletions(-)

diff --git a/arch/frv/kernel/time.c b/arch/frv/kernel/time.c
index fb0ce75..0ddbbae 100644
--- a/arch/frv/kernel/time.c
+++ b/arch/frv/kernel/time.c
@@ -48,20 +48,12 @@ static struct irqaction timer_irq  = {
 	.name = "timer",
 };
 
-static inline int set_rtc_mmss(unsigned long nowtime)
-{
-	return -1;
-}
-
 /*
  * timer_interrupt() needs to keep up the real-time clock,
  * as well as call the "do_timer()" routine every clocktick
  */
 static irqreturn_t timer_interrupt(int irq, void *dummy)
 {
-	/* last time the cmos clock got updated */
-	static long last_rtc_update = 0;
-
 	profile_tick(CPU_PROFILING);
 	/*
 	 * Here we are in the timer irq handler. We just have irqs locally
@@ -74,22 +66,6 @@ static irqreturn_t timer_interrupt(int irq, void *dummy)
 
 	do_timer(1);
 
-	/*
-	 * If we have an externally synchronized Linux clock, then update
-	 * CMOS clock accordingly every ~11 minutes. Set_rtc_mmss() has to be
-	 * called as close as possible to 500 ms before the new second starts.
-	 */
-	if (ntp_synced() &&
-	    xtime.tv_sec > last_rtc_update + 660 &&
-	    (xtime.tv_nsec / 1000) >= 500000 - ((unsigned) TICK_SIZE) / 2 &&
-	    (xtime.tv_nsec / 1000) <= 500000 + ((unsigned) TICK_SIZE) / 2
-	    ) {
-		if (set_rtc_mmss(xtime.tv_sec) == 0)
-			last_rtc_update = xtime.tv_sec;
-		else
-			last_rtc_update = xtime.tv_sec - 600; /* do it again in 60 s */
-	}
-
 #ifdef CONFIG_HEARTBEAT
 	static unsigned short n;
 	n++;
@@ -119,7 +95,8 @@ void time_divisor_init(void)
 	__set_TCSR_DATA(0, base >> 8);
 }
 
-void time_init(void)
+
+void read_persistent_clock(struct timespec *ts)
 {
 	unsigned int year, mon, day, hour, min, sec;
 
@@ -135,9 +112,12 @@ void time_init(void)
 
 	if ((year += 1900) < 1970)
 		year += 100;
-	xtime.tv_sec = mktime(year, mon, day, hour, min, sec);
-	xtime.tv_nsec = 0;
+	ts->tv_sec = mktime(year, mon, day, hour, min, sec);
+	ts->tv_nsec = 0;
+}
 
+void time_init(void)
+{
 	/* install scheduling interrupt handler */
 	setup_irq(IRQ_CPU_TIMER0, &timer_irq);
 
