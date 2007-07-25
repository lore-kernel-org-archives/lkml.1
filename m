Return-Path: <linux-kernel-owner+w=401wt.eu-S1765264AbXGYOIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765264AbXGYOIU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 10:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756857AbXGYOHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 10:07:09 -0400
Received: from rex.snapgear.com ([203.143.235.140]:59454 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753747AbXGYOHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 10:07:04 -0400
Date: Thu, 26 Jul 2007 00:06:25 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200707251406.l6PE6PMW005829@goober>
To: linux-kernel@vger.kernel.org
Subject: [M68KNOMMU 06/06]: use common hardware routines in common timer code
Cc: gerg@uclinux.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Modify the common m68knommu timer code to use the common hardware
timer functions. This removes all use of the miscellaneous function
pointers used previously for the hardware timer support routines.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naur linux-2.6.22/arch/m68knommu/kernel/time.c linux-2.6.22-uc0/arch/m68knommu/kernel/time.c
--- linux-2.6.22/arch/m68knommu/kernel/time.c	2007-07-12 15:23:02.000000000 +1000
+++ linux-2.6.22-uc0/arch/m68knommu/kernel/time.c	2007-07-12 15:27:00.000000000 +1000
@@ -27,7 +27,6 @@
 
 #define	TICK_SIZE (tick_nsec / 1000)
 
-
 static inline int set_rtc_mmss(unsigned long nowtime)
 {
 	if (mach_set_clock_mmss)
@@ -39,15 +38,11 @@
  * timer_interrupt() needs to keep up the real-time clock,
  * as well as call the "do_timer()" routine every clocktick
  */
-static irqreturn_t timer_interrupt(int irq, void *dummy)
+irqreturn_t arch_timer_interrupt(int irq, void *dummy)
 {
 	/* last time the cmos clock got updated */
 	static long last_rtc_update=0;
 
-	/* may need to kick the hardware timer */
-	if (mach_tick)
-	  mach_tick();
-
 	write_seqlock(&xtime_lock);
 
 	do_timer(1);
@@ -103,10 +98,10 @@
 {
 	unsigned int year, mon, day, hour, min, sec;
 
-	extern void arch_gettod(int *year, int *mon, int *day, int *hour,
-				int *min, int *sec);
-
-	arch_gettod(&year, &mon, &day, &hour, &min, &sec);
+	if (mach_gettod)
+		mach_gettod(&year, &mon, &day, &hour, &min, &sec);
+	else
+		year = mon = day = hour = min = sec = 0;
 
 	if ((year += 1900) < 1970)
 		year += 100;
@@ -114,7 +109,7 @@
 	xtime.tv_nsec = 0;
 	wall_to_monotonic.tv_sec = -xtime.tv_sec;
 
-	mach_sched_init(timer_interrupt);
+	hw_timer_init();
 }
 
 /*
@@ -128,7 +123,7 @@
 
 	do {
 		seq = read_seqbegin_irqsave(&xtime_lock, flags);
-		usec = mach_gettimeoffset ? mach_gettimeoffset() : 0;
+		usec = hw_timer_offset();
 		sec = xtime.tv_sec;
 		usec += (xtime.tv_nsec / 1000);
 	} while (read_seqretry_irqrestore(&xtime_lock, seq, flags));
@@ -160,8 +155,7 @@
 	 * Discover what correction gettimeofday
 	 * would have done, and then undo it!
 	 */
-	if (mach_gettimeoffset)
-		nsec -= (mach_gettimeoffset() * 1000);
+	nsec -= (hw_timer_offset() * 1000);
 
 	wtm_sec  = wall_to_monotonic.tv_sec + (xtime.tv_sec - sec);
 	wtm_nsec = wall_to_monotonic.tv_nsec + (xtime.tv_nsec - nsec);
