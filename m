Return-Path: <linux-kernel-owner+w=401wt.eu-S1752534AbZLWEGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534AbZLWEGg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 23:06:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751545AbZLWEGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 23:06:35 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:45260 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbZLWEGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 23:06:34 -0500
Subject: [RFC][PATCH 6/14] Convert frv to read/update_persistent_clock
From: john stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: David Howells <dhowells@redhat.com>
In-Reply-To: <1261541130.3508.66.camel@localhost.localdomain>
References: <1261540762.3508.61.camel@localhost.localdomain>
	 <1261540826.3508.62.camel@localhost.localdomain>
	 <1261540902.3508.63.camel@localhost.localdomain>
	 <1261540988.3508.64.camel@localhost.localdomain>
	 <1261541054.3508.65.camel@localhost.localdomain>
	 <1261541130.3508.66.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Dec 2009 20:06:28 -0800
Message-ID: <1261541188.3508.67.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the frv architecture to use the generic
read_persistent_clock and update_persistent_clock interfaces, reducing
the amount of arch specific code we have to maintain, and allowing for
further cleanups in the future.

I have not built or tested this patch, so help from arch maintainers
would be appreciated.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 time.c |   34 +++++++---------------------------
 1 file changed, 7 insertions(+), 27 deletions(-)

Index: gettimeoffset/arch/frv/kernel/time.c
===================================================================
--- gettimeoffset.orig/arch/frv/kernel/time.c	2009-12-22 18:50:55.000000000 -0800
+++ gettimeoffset/arch/frv/kernel/time.c	2009-12-22 18:51:05.000000000 -0800
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
@@ -74,22 +66,6 @@ static irqreturn_t timer_interrupt(int i
 
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
 


